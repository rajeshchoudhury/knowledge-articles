# Article 11: Integration Architecture & API Design for Life Claims

## Building the Connected Claims Ecosystem

---

## 1. Introduction

A modern life insurance claims system does not exist in isolation. It must integrate with dozens of internal and external systems to process claims effectively. This article provides the architectural blueprint for designing the integration layer of a claims system, including API design, integration patterns, and the complete integration map.

---

## 2. Integration Landscape

### 2.1 Complete Integration Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CLAIMS SYSTEM INTEGRATION MAP                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  INTERNAL SYSTEMS                    CLAIMS SYSTEM      EXTERNAL SYSTEMS    │
│                                     ┌────────────┐                          │
│  ┌──────────────┐                   │            │     ┌──────────────┐    │
│  │ Policy Admin │◀──────────────────│            │────▶│ Death Master  │    │
│  │ System (PAS) │──────────────────▶│            │     │ File / DMF   │    │
│  └──────────────┘                   │            │     └──────────────┘    │
│  ┌──────────────┐                   │            │     ┌──────────────┐    │
│  │ CRM          │◀──────────────────│            │────▶│ Identity     │    │
│  │              │──────────────────▶│  CLAIMS    │     │ Verification │    │
│  └──────────────┘                   │  MANAGEMENT│     └──────────────┘    │
│  ┌──────────────┐                   │  SYSTEM    │     ┌──────────────┐    │
│  │ Document     │◀──────────────────│            │────▶│ Fraud/SIU    │    │
│  │ Management   │──────────────────▶│            │     │ Databases    │    │
│  └──────────────┘                   │            │     └──────────────┘    │
│  ┌──────────────┐                   │            │     ┌──────────────┐    │
│  │ General      │◀──────────────────│            │────▶│ MIB          │    │
│  │ Ledger       │                   │            │     └──────────────┘    │
│  └──────────────┘                   │            │     ┌──────────────┐    │
│  ┌──────────────┐                   │            │────▶│ Rx Database  │    │
│  │ Reinsurance  │◀──────────────────│            │     └──────────────┘    │
│  │ System       │──────────────────▶│            │     ┌──────────────┐    │
│  └──────────────┘                   │            │────▶│ LexisNexis   │    │
│  ┌──────────────┐                   │            │     └──────────────┘    │
│  │ Correspondence│◀─────────────────│            │     ┌──────────────┐    │
│  │ System       │                   │            │────▶│ Payment      │    │
│  └──────────────┘                   │            │     │ Gateway      │    │
│  ┌──────────────┐                   │            │     └──────────────┘    │
│  │ Data         │◀──────────────────│            │     ┌──────────────┐    │
│  │ Warehouse    │                   │            │────▶│ E-Signature  │    │
│  └──────────────┘                   │            │     │ (DocuSign)   │    │
│  ┌──────────────┐                   │            │     └──────────────┘    │
│  │ Workflow/BPM │◀──────────────────│            │     ┌──────────────┐    │
│  │ Engine       │──────────────────▶│            │────▶│ State Vital  │    │
│  └──────────────┘                   │            │     │ Records      │    │
│  ┌──────────────┐                   │            │     └──────────────┘    │
│  │ Notification │◀──────────────────│            │     ┌──────────────┐    │
│  │ Service      │                   │            │────▶│ IRS / Tax    │    │
│  └──────────────┘                   └────────────┘     │ Filing       │    │
│                                                         └──────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Integration Patterns

### 3.1 Pattern Selection Guide

| Pattern | Use Case | Characteristics | Example |
|---|---|---|---|
| **Request-Reply (Sync)** | Real-time data retrieval | Low latency, tight coupling | Policy lookup at FNOL |
| **Async Messaging** | Event notification | Decoupled, reliable | Claim status change events |
| **Pub/Sub** | Broadcast events to multiple consumers | Fan-out, decoupled | New claim notification |
| **Batch** | Bulk data processing | High throughput, scheduled | DMF matching, reporting |
| **File Transfer** | Legacy system integration | Simple, batch-oriented | PAS extract files |
| **API Gateway** | External API management | Security, throttling, monitoring | Partner APIs |
| **Event Sourcing** | State change tracking | Immutable, auditability | Claim lifecycle events |
| **Saga** | Distributed transactions | Eventual consistency | Cross-system claim processing |

### 3.2 Event-Driven Architecture for Claims

```
EVENT BUS (Kafka / Amazon EventBridge / Azure Event Grid)
│
├── CLAIM EVENTS (topic: claims.lifecycle)
│   ├── claim.reported          → Consumed by: Triage, Analytics, Notification
│   ├── claim.documents.received → Consumed by: IDP Pipeline, SLA Timer
│   ├── claim.under.review      → Consumed by: Analytics, SLA Timer
│   ├── claim.approved          → Consumed by: Payment, Reinsurance, Analytics
│   ├── claim.denied            → Consumed by: Correspondence, Analytics
│   ├── claim.payment.issued    → Consumed by: GL, Tax, Analytics, Notification
│   ├── claim.closed            → Consumed by: Analytics, Archive, Reinsurance
│   └── claim.reopened          → Consumed by: Assignment, Analytics
│
├── DOCUMENT EVENTS (topic: claims.documents)
│   ├── document.received       → Consumed by: IDP, Document Tracker
│   ├── document.classified     → Consumed by: Claim Processor
│   ├── document.extracted      → Consumed by: Claim Processor, Validation
│   ├── document.validated      → Consumed by: Claim Processor, STP Engine
│   └── document.rejected       → Consumed by: Correspondence (re-request)
│
├── PAYMENT EVENTS (topic: claims.payments)
│   ├── payment.authorized      → Consumed by: Payment Gateway
│   ├── payment.issued          → Consumed by: GL, Notification, Tax
│   ├── payment.confirmed       → Consumed by: Claim Processor
│   ├── payment.returned        → Consumed by: Claim Processor, Investigation
│   └── payment.voided          → Consumed by: GL, Claim Processor
│
├── COMPLIANCE EVENTS (topic: claims.compliance)
│   ├── sla.approaching         → Consumed by: Assignment, Notification
│   ├── sla.breached            → Consumed by: Management Alert, Compliance
│   ├── regulatory.deadline     → Consumed by: Compliance Dashboard
│   └── escheatment.due         → Consumed by: Payment, Compliance
│
└── FRAUD EVENTS (topic: claims.fraud)
    ├── fraud.score.generated   → Consumed by: Triage, SIU
    ├── siu.referral.created    → Consumed by: SIU, Claim Processor
    └── siu.investigation.complete → Consumed by: Claim Processor
```

---

## 4. API Design

### 4.1 Claims API Specification

```yaml
openapi: 3.0.3
info:
  title: Life Insurance Claims API
  version: 2.0.0

paths:
  /api/v2/claims:
    post:
      summary: Submit new claim (FNOL)
      tags: [Claims]
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ClaimSubmission'
      responses:
        '201':
          description: Claim created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClaimResponse'
    
    get:
      summary: Search claims
      tags: [Claims]
      parameters:
        - name: policyNumber
          in: query
          schema: { type: string }
        - name: status
          in: query
          schema: { type: string }
        - name: dateFrom
          in: query
          schema: { type: string, format: date }
        - name: dateTo
          in: query
          schema: { type: string, format: date }
        - name: examinerId
          in: query
          schema: { type: string }
        - name: page
          in: query
          schema: { type: integer, default: 1 }
        - name: pageSize
          in: query
          schema: { type: integer, default: 20 }

  /api/v2/claims/{claimId}:
    get:
      summary: Get claim details
      tags: [Claims]
    patch:
      summary: Update claim
      tags: [Claims]

  /api/v2/claims/{claimId}/documents:
    get:
      summary: List claim documents
      tags: [Documents]
    post:
      summary: Upload document
      tags: [Documents]
      requestBody:
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                documentType: { type: string }
                file: { type: string, format: binary }

  /api/v2/claims/{claimId}/payments:
    get:
      summary: List claim payments
      tags: [Payments]
    post:
      summary: Initiate payment
      tags: [Payments]

  /api/v2/claims/{claimId}/activities:
    get:
      summary: Get claim activity/audit trail
      tags: [Activities]
    post:
      summary: Add activity/note
      tags: [Activities]

  /api/v2/claims/{claimId}/status:
    put:
      summary: Update claim status
      tags: [Claims]

  /api/v2/claims/{claimId}/benefit-calculation:
    get:
      summary: Get benefit calculation details
      tags: [Calculations]
    post:
      summary: Calculate/recalculate benefit
      tags: [Calculations]

  /api/v2/policies/{policyNumber}/claim-eligibility:
    get:
      summary: Check if policy is eligible for claim
      tags: [Policy]
```

### 4.2 API Security

```
API SECURITY LAYERS:
│
├── TRANSPORT SECURITY
│   ├── TLS 1.2+ (minimum)
│   ├── Certificate pinning for B2B
│   └── Mutual TLS for high-security integrations
│
├── AUTHENTICATION
│   ├── OAuth 2.0 + OpenID Connect (primary)
│   ├── API Keys (for service-to-service)
│   ├── JWT tokens with short expiry
│   └── mTLS certificates (for B2B partners)
│
├── AUTHORIZATION
│   ├── Role-Based Access Control (RBAC)
│   │   ├── CLAIMS_EXAMINER: Read/write claims, read policy
│   │   ├── CLAIMS_MANAGER: All examiner + admin functions
│   │   ├── SIU_INVESTIGATOR: Read claims + investigation tools
│   │   ├── BENEFICIARY: Read own claim status, upload documents
│   │   ├── EMPLOYER_ADMIN: Submit group claims, view status
│   │   └── SYSTEM_INTEGRATION: Service-specific permissions
│   ├── Attribute-Based Access Control (ABAC)
│   │   ├── Jurisdiction-based access
│   │   ├── Authority-limit based access
│   │   └── PHI access restrictions
│   └── Claim-level access control
│
├── DATA PROTECTION
│   ├── Field-level encryption for PII/PHI
│   ├── Data masking in API responses (based on role)
│   ├── Request/response payload encryption (for sensitive data)
│   └── PII tokenization
│
├── RATE LIMITING & THROTTLING
│   ├── Per-client rate limits
│   ├── Per-endpoint rate limits
│   ├── Burst protection
│   └── DDoS protection
│
└── MONITORING & AUDIT
    ├── API access logging
    ├── Anomaly detection
    ├── PII access audit trail
    └── Real-time security alerting
```

---

## 5. Key Integration Specifications

### 5.1 Policy Administration System (PAS) Integration

```
PAS INTEGRATION:

OPERATIONS:
├── Policy Lookup
│   ├── By policy number (exact match)
│   ├── By insured SSN + DOB (identity match)
│   ├── By insured name + DOB (fuzzy match)
│   └── Returns: Full policy snapshot at date of death
│
├── Policy Status at Date
│   ├── Input: Policy number, Date of death
│   ├── Returns: Policy status, premium status, grace period
│   └── Critical for coverage determination
│
├── Beneficiary Designation
│   ├── Current beneficiary designations
│   ├── Beneficiary change history
│   └── Irrevocable beneficiary flags
│
├── Policy Values
│   ├── Face amount / death benefit
│   ├── Cash value (at date of death)
│   ├── Loan balance and accrued interest
│   ├── Paid-up additions
│   ├── Dividend accumulations
│   └── Account value (for UL/VUL)
│
├── Rider Information
│   ├── Active riders and their status
│   ├── Rider benefit amounts
│   └── Rider effective dates
│
├── Policy Update
│   ├── Mark policy as "claim in process"
│   ├── Mark policy as "claim paid" / terminated
│   └── Adjustment for ADB (reduce face amount)
│
└── Underwriting File
    ├── Original application
    ├── Underwriting notes
    ├── Medical exam results (at issue)
    └── Required for contestability investigation

INTEGRATION PATTERN:
├── Real-time API preferred
├── Fallback: Message-based for legacy PAS
├── Cache frequently accessed policy data
├── Handle PAS unavailability gracefully
└── Consider read-only replica for queries
```

### 5.2 Payment Gateway Integration

```
PAYMENT INTEGRATION:

PAYMENT METHODS:
├── ACH/EFT
│   ├── Standard ACH (2-3 business days)
│   ├── Same-day ACH (available for smaller amounts)
│   ├── Input: Routing number, account number, amount
│   ├── Validate: Pre-note or micro-deposit verification
│   └── Confirmation: ACH trace number
│
├── Check
│   ├── Print-on-demand or batch print
│   ├── MICR encoding
│   ├── Positive pay file to bank
│   └── Track: Print date, mail date, cash date
│
├── Wire Transfer
│   ├── Domestic (Fedwire) or international (SWIFT)
│   ├── Typically for large amounts (>$1M)
│   ├── Same-day settlement
│   └── Higher cost
│
└── Retained Asset Account (RAA)
    ├── Interest-bearing account held by carrier
    ├── Checkbook provided to beneficiary
    ├── FDIC-insured (if structured properly)
    └── Regulatory scrutiny (some states restrict)

PAYMENT API:
POST /api/v2/payments/initiate
{
  "claimId": "CLM-2025-00789",
  "payeeId": "PARTY-001",
  "amount": 500410.96,
  "currency": "USD",
  "paymentMethod": "ACH",
  "bankingDetails": {
    "routingNumber": "123456789",
    "accountNumber": "encrypted:...",
    "accountType": "CHECKING"
  },
  "memo": "Life Insurance Death Benefit - Policy LIF-2020-001234",
  "taxWithholding": 0,
  "idempotencyKey": "pay-clm-2025-00789-001"
}
```

---

## 6. Legacy Integration Strategies

### 6.1 Common Legacy Systems in Life Insurance

| System | Technology | Integration Approach |
|---|---|---|
| Mainframe PAS (COBOL) | z/OS, CICS, DB2 | Screen scraping, MQ, CICS Transaction Gateway, API wrapper |
| AS/400 PAS | IBM i, RPG | Data queues, web services, API wrapper |
| Legacy Claims (client/server) | VB, PowerBuilder, Oracle | Database integration, API wrapper, RPA |
| Legacy DMS | FileNet v3, Documentum | API migration, content migration |
| Legacy correspondence | Mainframe print streams | Modern correspondence engine replacement |

### 6.2 Strangler Fig Pattern for Legacy Modernization

```
STRANGLER FIG PATTERN:
Phase 1: New API layer wraps legacy system
Phase 2: New functionality built in modern system
Phase 3: Gradually route traffic from legacy to modern
Phase 4: Legacy system decommissioned

┌──────────────────────────────────────────────────────────────┐
│                                                                │
│  Phase 1:  [Client] ──▶ [API Gateway] ──▶ [Legacy PAS]      │
│                                                                │
│  Phase 2:  [Client] ──▶ [API Gateway] ──┬▶ [Modern Claims]  │
│                                          └▶ [Legacy PAS]      │
│                                                                │
│  Phase 3:  [Client] ──▶ [API Gateway] ──┬▶ [Modern Claims]  │
│                                    (most) └▶ [Legacy PAS]     │
│                                              (some)            │
│  Phase 4:  [Client] ──▶ [API Gateway] ──▶ [Modern Claims]   │
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

---

## 7. Error Handling and Resilience

### 7.1 Integration Resilience Patterns

| Pattern | Purpose | Implementation |
|---|---|---|
| **Circuit Breaker** | Prevent cascading failures | Hystrix, Resilience4j |
| **Retry with Backoff** | Handle transient failures | Exponential backoff with jitter |
| **Bulkhead** | Isolate failures | Separate thread pools per integration |
| **Timeout** | Prevent indefinite waiting | Configurable per integration |
| **Dead Letter Queue** | Handle unprocessable messages | DLQ per integration topic |
| **Idempotency** | Handle duplicate messages safely | Idempotency keys on all writes |
| **Compensating Transaction** | Undo partial operations | Saga pattern implementation |

---

## 8. Summary

Integration architecture is the nervous system of a claims platform. Key principles:

1. **API-first design** - All integrations should be designed as APIs
2. **Event-driven by default** - Use events for notifications, sync APIs for queries
3. **Resilience is non-negotiable** - Design for failure at every integration point
4. **Security is multi-layered** - Transport, authentication, authorization, data protection
5. **Plan for legacy** - Most carriers have legacy systems that cannot be replaced overnight
6. **Standard data formats** - Use ACORD, FHIR, ISO 20022 for external integrations
7. **Monitor everything** - API metrics, error rates, latency are critical operational data

---

*Previous: [Article 10: Regulatory Compliance](10-regulatory-compliance.md)*
*Next: [Article 12: Payment Processing & Settlement](12-payment-processing.md)*
