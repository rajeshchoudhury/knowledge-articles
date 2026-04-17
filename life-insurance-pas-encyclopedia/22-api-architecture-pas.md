# Article 22: API Architecture for Policy Administration Systems

## Table of Contents

1. [Introduction](#1-introduction)
2. [API Strategy for Insurance](#2-api-strategy-for-insurance)
3. [REST API Design for Insurance](#3-rest-api-design-for-insurance)
4. [API Design for Key PAS Domains](#4-api-design-for-key-pas-domains)
5. [GraphQL for Insurance](#5-graphql-for-insurance)
6. [Event-Driven APIs](#6-event-driven-apis)
7. [ACORD API Standards](#7-acord-api-standards)
8. [API Security](#8-api-security)
9. [API Versioning](#9-api-versioning)
10. [API Gateway Patterns](#10-api-gateway-patterns)
11. [Developer Experience](#11-developer-experience)
12. [Complete OpenAPI 3.0 Specifications](#12-complete-openapi-30-specifications)
13. [Sample Request/Response Payloads](#13-sample-requestresponse-payloads)
14. [Architecture Reference](#14-architecture-reference)
15. [Performance & Scalability](#15-performance--scalability)
16. [Governance & Lifecycle](#16-governance--lifecycle)

---

## 1. Introduction

The API layer of a Policy Administration System (PAS) serves as the central nervous system connecting modern insurance operations—front-office portals, agent platforms, distribution partners, regulators, reinsurers, and internal microservices all converge on a well-designed API surface. This article provides an exhaustive treatment of API architecture for life insurance and annuity PAS platforms, covering strategy, design, implementation, security, governance, and operational excellence.

### 1.1 Why API Architecture Matters for PAS

Traditional PAS platforms were monolithic systems with tightly coupled user interfaces and batch-oriented integrations. Modern insurance demands:

- **Omnichannel Distribution**: APIs enable web portals, mobile apps, chatbots, and embedded insurance products to share a common back-end.
- **Ecosystem Connectivity**: Reinsurers, third-party administrators (TPAs), regulatory bodies, and InsurTech partners require programmatic access.
- **Composable Architecture**: API-first design allows PAS capabilities to be composed and recomposed as business needs evolve.
- **Speed-to-Market**: Well-designed APIs decouple front-end innovation from core system constraints.
- **Regulatory Compliance**: APIs provide auditable, traceable interaction points.

### 1.2 Scope of This Article

This article covers the complete API architecture stack:

```mermaid
graph TB
    subgraph "API Consumers"
        A1[Agent Portal]
        A2[Customer Portal]
        A3[Mobile Apps]
        A4[Distribution Partners]
        A5[Reinsurers]
        A6[Regulators]
        A7[Internal Microservices]
    end

    subgraph "API Infrastructure"
        B1[API Gateway]
        B2[API Management Platform]
        B3[Load Balancer / CDN]
    end

    subgraph "API Layer"
        C1[REST APIs]
        C2[GraphQL API]
        C3[Event-Driven APIs<br/>AsyncAPI / Webhooks]
        C4[gRPC Internal APIs]
    end

    subgraph "Backend Services"
        D1[New Business Service]
        D2[Policy Servicing]
        D3[Billing & Payments]
        D4[Claims Service]
        D5[Financial Engine]
        D6[Document Service]
        D7[Illustration Engine]
    end

    A1 & A2 & A3 --> B1
    A4 & A5 --> B2
    A6 --> B2
    A7 --> C4
    B1 --> C1 & C2
    B2 --> C1 & C3
    B3 --> B1
    C1 & C2 & C3 & C4 --> D1 & D2 & D3 & D4 & D5 & D6 & D7
```

---

## 2. API Strategy for Insurance

### 2.1 API-First Design Philosophy

API-first design mandates that APIs are designed before implementation begins. In an insurance context this means:

1. **Contract-First Development**: OpenAPI or AsyncAPI specifications are authored, reviewed, and agreed upon before any code is written.
2. **Design Review Board**: An API design review board (comprising architects, business analysts, and consumer representatives) approves all API contracts.
3. **Consumer-Driven**: API design is driven by consumer use cases, not implementation convenience.
4. **Machine-Readable Contracts**: All API contracts are machine-readable (OpenAPI 3.x, AsyncAPI 2.x, GraphQL SDL) and stored in version control.

#### API-First Workflow

```mermaid
flowchart LR
    A[Business Use Case] --> B[API Design<br/>OpenAPI Spec]
    B --> C[Design Review<br/>Board Approval]
    C --> D[Mock Server<br/>Generation]
    D --> E[Consumer Development<br/>Against Mocks]
    C --> F[Provider<br/>Implementation]
    E --> G[Contract Testing<br/>Pact]
    F --> G
    G --> H[Integration Testing]
    H --> I[Production<br/>Deployment]
```

### 2.2 API as a Product

Treating APIs as products requires:

| Aspect | Description | Insurance Example |
|--------|-------------|-------------------|
| **Product Manager** | Dedicated API product owner | PM for Policy Inquiry API family |
| **Roadmap** | Feature roadmap per API product | Adding real-time illustration endpoints in Q3 |
| **SLAs** | Published service levels | Policy Inquiry: 99.95% uptime, p99 < 200ms |
| **Versioning** | Clear lifecycle & deprecation | v1 sunset in 12 months after v2 GA |
| **Documentation** | Interactive, up-to-date docs | Swagger UI with "Try It" for sandbox |
| **Developer Portal** | Self-service onboarding | Partner portal with API key provisioning |
| **Analytics** | Usage metrics, error rates | Dashboard showing calls by partner, endpoint |
| **Feedback Loop** | Consumer feedback channels | API advisory council with top partners |

### 2.3 API Monetization Models

Insurance APIs can be monetized through several models:

1. **Free / Ecosystem Growth**: Open APIs to drive platform adoption (e.g., illustration APIs to attract distribution partners).
2. **Freemium / Tiered**: Basic policy inquiry free; premium analytics or real-time valuation behind paid tiers.
3. **Revenue Sharing**: Partners pay per-transaction for embedded insurance (e.g., per-policy-sold via API).
4. **Partner Licensing**: Annual license for API access with SLA guarantees and dedicated support.
5. **Data-as-a-Service**: Anonymized, aggregated risk data exposed via APIs for reinsurers and researchers.

### 2.4 Partner API Programs

A mature partner API program includes:

```mermaid
graph TD
    A[Partner Onboarding] --> B[Application & Vetting]
    B --> C[API Key Provisioning]
    C --> D[Sandbox Access]
    D --> E[Integration Development]
    E --> F[Certification Testing]
    F --> G[Production Access]
    G --> H[Ongoing Monitoring]
    H --> I[Quarterly Business Review]

    subgraph "Support Structure"
        S1[Developer Portal]
        S2[Technical Support]
        S3[API Advisory Council]
        S4[Partner Engineering]
    end
```

**Partner Tiers:**

| Tier | Access Level | Rate Limits | Support | Use Case |
|------|-------------|-------------|---------|----------|
| **Bronze** | Inquiry APIs only | 100 req/min | Community forum | Data aggregators |
| **Silver** | Inquiry + Servicing | 500 req/min | Email support (4hr SLA) | Broker-dealers |
| **Gold** | Full API suite | 2,000 req/min | Dedicated engineer | Strategic partners |
| **Platinum** | Custom APIs + Events | Custom | White-glove | MGA / Distribution platforms |

### 2.5 Open Insurance Initiatives

The industry is moving toward open insurance standards:

- **OPIN (Open Insurance)**: Standardized APIs for insurance data sharing (modeled after Open Banking).
- **ACORD REST APIs**: Industry-standard data models and API conventions.
- **Insurance Data Exchange (IDX)**: Cross-carrier data portability.
- **Regulatory Mandates**: Brazil's Open Insurance regulation, EU proposals, NAIC data-sharing frameworks.

---

## 3. REST API Design for Insurance

### 3.1 Resource Modeling

Insurance domain entities map to REST resources following domain-driven design principles:

```mermaid
erDiagram
    POLICY ||--o{ COVERAGE : contains
    POLICY ||--o{ PARTY_ROLE : has
    PARTY_ROLE }o--|| PARTY : references
    COVERAGE ||--o{ RIDER : includes
    POLICY ||--o{ FINANCIAL_TRANSACTION : records
    POLICY ||--o{ DOCUMENT : attaches
    POLICY ||--|{ BILLING_ARRANGEMENT : has
    COVERAGE ||--o{ BENEFIT : provides
    PARTY ||--o{ ADDRESS : has
    PARTY ||--o{ COMMUNICATION : has
    POLICY ||--o{ ACTIVITY : tracks
    POLICY ||--o{ NOTE : contains

    POLICY {
        string policyId PK
        string policyNumber
        string productCode
        string status
        date issueDate
        date effectiveDate
        string jurisdictionCode
    }

    COVERAGE {
        string coverageId PK
        string planCode
        decimal faceAmount
        string status
        date effectiveDate
    }

    PARTY {
        string partyId PK
        string firstName
        string lastName
        date dateOfBirth
        string taxId
    }

    PARTY_ROLE {
        string roleCode
        string policyId FK
        string partyId FK
    }
```

#### Primary Resources

| Resource | URI Pattern | Description |
|----------|-----------|-------------|
| **Policy** | `/policies/{policyId}` | Core policy record |
| **Coverage** | `/policies/{policyId}/coverages/{coverageId}` | Individual coverage/rider |
| **Party** | `/parties/{partyId}` | Person or organization |
| **Party Role** | `/policies/{policyId}/roles` | Party-to-policy relationships |
| **Financial Transaction** | `/policies/{policyId}/transactions` | Premium, loans, withdrawals |
| **Claim** | `/claims/{claimId}` | Claim record |
| **Document** | `/policies/{policyId}/documents/{documentId}` | Attached documents |
| **Billing** | `/policies/{policyId}/billing` | Billing arrangement |
| **Activity** | `/policies/{policyId}/activities` | Audit/activity trail |
| **Payment** | `/payments/{paymentId}` | Payment record |

### 3.2 URI Design Conventions

#### Naming Rules

```
# Collection resource — always plural nouns
GET /api/v1/policies
GET /api/v1/claims

# Singleton resource — accessed by identifier
GET /api/v1/policies/POL-12345678
GET /api/v1/claims/CLM-00001234

# Sub-resource — nested within parent
GET /api/v1/policies/POL-12345678/coverages
GET /api/v1/policies/POL-12345678/coverages/COV-001

# Cross-cutting / search
POST /api/v1/policies/search
POST /api/v1/parties/search

# Actions (non-CRUD operations)
POST /api/v1/policies/POL-12345678/actions/reinstate
POST /api/v1/policies/POL-12345678/actions/lapse
POST /api/v1/policies/POL-12345678/coverages/COV-001/actions/reduce

# Bulk operations
POST /api/v1/policies/bulk-inquiry
POST /api/v1/payments/bulk-process
```

#### URI Design Principles

1. **Use kebab-case** for multi-word path segments: `/billing-arrangements`, not `/billingArrangements`.
2. **Avoid verbs in URIs** except for action endpoints: `/policies/{id}/actions/{action}`.
3. **Use consistent identifiers**: Policy numbers are human-readable; prefer opaque IDs in URIs with policy numbers as query filters.
4. **Hierarchy reflects domain**: Coverages are sub-resources of policies, not top-level.
5. **Limit nesting depth**: Maximum 3 levels (`/policies/{id}/coverages/{id}/riders`).

### 3.3 HTTP Method Semantics for Insurance

| Method | Semantics | Insurance Example | Idempotent | Safe |
|--------|-----------|-------------------|------------|------|
| `GET` | Retrieve resource | Get policy details | Yes | Yes |
| `POST` | Create resource or trigger action | Submit new application | No | No |
| `PUT` | Full replacement | Update party demographics | Yes | No |
| `PATCH` | Partial update | Change beneficiary designation | No* | No |
| `DELETE` | Remove resource | Cancel pending change request | Yes | No |
| `HEAD` | Check existence | Verify policy exists | Yes | Yes |
| `OPTIONS` | Discover allowed methods | CORS preflight | Yes | Yes |

*PATCH is idempotent when using JSON Merge Patch; not necessarily with JSON Patch.

#### Method Mapping for PAS Operations

```
# Inquiry operations → GET
GET /policies/{id}                           # Policy summary
GET /policies/{id}/coverages                  # List coverages
GET /policies/{id}/values                     # Account/cash values
GET /policies/{id}/billing/schedule           # Billing schedule

# New business → POST
POST /applications                            # Submit application
POST /applications/{id}/actions/submit        # Submit for underwriting

# Policy changes → POST (action) or PATCH (data update)
PATCH /policies/{id}/parties/{partyId}       # Update address
POST /policies/{id}/actions/change-beneficiary   # Beneficiary change workflow
POST /policies/{id}/actions/increase-coverage    # Coverage increase

# Financial transactions → POST
POST /policies/{id}/payments                  # Make premium payment
POST /policies/{id}/withdrawals               # Request withdrawal
POST /policies/{id}/loans                     # Request policy loan
POST /policies/{id}/fund-transfers            # Transfer between funds

# Claims → POST, PATCH
POST /claims                                  # Submit claim
PATCH /claims/{claimId}                       # Update claim details

# Documents → GET, POST
POST /policies/{id}/documents                 # Upload document
GET /policies/{id}/documents/{docId}/content  # Download document
```

### 3.4 Status Code Usage

| Status Code | Meaning | Insurance Usage |
|-------------|---------|-----------------|
| `200 OK` | Success | Policy retrieved, change applied |
| `201 Created` | Resource created | Application submitted, claim created |
| `202 Accepted` | Async processing started | Change request accepted for processing |
| `204 No Content` | Success, no body | Document deleted |
| `301 Moved Permanently` | Resource relocated | API version permanently redirected |
| `304 Not Modified` | Cached response valid | Policy unchanged since ETag |
| `400 Bad Request` | Invalid request | Missing required fields in application |
| `401 Unauthorized` | Authentication failed | Invalid/expired JWT token |
| `403 Forbidden` | Authorization failed | Agent not licensed in jurisdiction |
| `404 Not Found` | Resource not found | Policy number doesn't exist |
| `409 Conflict` | State conflict | Policy already lapsed, can't process payment |
| `422 Unprocessable Entity` | Validation failed | Face amount below minimum for product |
| `429 Too Many Requests` | Rate limit exceeded | Partner exceeded API quota |
| `500 Internal Server Error` | Server error | Unexpected PAS engine failure |
| `502 Bad Gateway` | Upstream failure | Illustration engine unavailable |
| `503 Service Unavailable` | System down | Scheduled maintenance window |

#### Error Response Standard Format

```json
{
  "error": {
    "code": "POLICY_LAPSED",
    "message": "Cannot process premium payment. Policy POL-12345678 is in lapsed status.",
    "target": "policyStatus",
    "details": [
      {
        "code": "REINSTATEMENT_REQUIRED",
        "message": "Policy must be reinstated before payment can be applied.",
        "target": "actions",
        "link": {
          "rel": "reinstate",
          "href": "/api/v1/policies/POL-12345678/actions/reinstate",
          "method": "POST"
        }
      }
    ],
    "innererror": {
      "traceId": "abc-123-def-456",
      "timestamp": "2026-01-15T14:30:00Z"
    }
  }
}
```

### 3.5 Pagination

#### Cursor-Based Pagination (Recommended)

Cursor-based pagination provides stable results even when data changes:

```
GET /api/v1/policies?limit=25&cursor=eyJwb2xpY3lJZCI6IlBPTC0wMDEwMCJ9

Response:
{
  "data": [ ... ],
  "pagination": {
    "limit": 25,
    "hasMore": true,
    "nextCursor": "eyJwb2xpY3lJZCI6IlBPTC0wMDEyNSJ9",
    "previousCursor": "eyJwb2xpY3lJZCI6IlBPTC0wMDA3NSJ9"
  }
}
```

#### Offset-Based Pagination (Legacy Compatibility)

```
GET /api/v1/policies?offset=100&limit=25

Response:
{
  "data": [ ... ],
  "pagination": {
    "offset": 100,
    "limit": 25,
    "totalCount": 5432
  }
}
```

#### Comparison

| Aspect | Cursor-Based | Offset-Based |
|--------|-------------|--------------|
| Consistency | Stable under data changes | Items can shift between pages |
| Performance | O(1) lookup | O(n) with OFFSET on large tables |
| Bookmarkable | No (opaque cursor) | Yes |
| Total count | Not provided | Can include total |
| Best for | Real-time feeds, large datasets | Reports, admin UIs |

### 3.6 Filtering, Sorting, and Field Selection

#### Filtering

```
# Simple equality
GET /policies?status=Active&productCode=UL-100

# Comparison operators
GET /policies?issueDate[gte]=2025-01-01&issueDate[lt]=2026-01-01

# Multi-value (OR)
GET /policies?status=Active,PendingLapse

# Full-text search
GET /policies?q=John+Smith

# Complex search (POST body for complex queries)
POST /policies/search
{
  "filter": {
    "and": [
      { "field": "status", "operator": "in", "value": ["Active", "PaidUp"] },
      { "field": "faceAmount", "operator": "gte", "value": 500000 },
      { "field": "issueDate", "operator": "between", "value": ["2020-01-01", "2025-12-31"] },
      { "field": "owner.state", "operator": "eq", "value": "NY" }
    ]
  }
}
```

#### Sorting

```
# Single field
GET /policies?sort=issueDate

# Descending
GET /policies?sort=-issueDate

# Multiple fields
GET /policies?sort=-faceAmount,issueDate
```

#### Field Selection / Sparse Fieldsets

```
# Select specific fields
GET /policies/POL-12345678?fields=policyNumber,status,faceAmount,issueDate

# Select fields for related resources
GET /policies/POL-12345678?fields=policyNumber,status&include=coverages&fields[coverages]=planCode,faceAmount
```

### 3.7 HATEOAS for Policy Navigation

Hypermedia links enable clients to discover available actions:

```json
{
  "policyId": "POL-12345678",
  "policyNumber": "A1234567",
  "status": "Active",
  "productName": "Universal Life 100",
  "_links": {
    "self": {
      "href": "/api/v1/policies/POL-12345678"
    },
    "coverages": {
      "href": "/api/v1/policies/POL-12345678/coverages"
    },
    "values": {
      "href": "/api/v1/policies/POL-12345678/values"
    },
    "billing": {
      "href": "/api/v1/policies/POL-12345678/billing"
    },
    "transactions": {
      "href": "/api/v1/policies/POL-12345678/transactions"
    },
    "documents": {
      "href": "/api/v1/policies/POL-12345678/documents"
    },
    "actions": {
      "change-beneficiary": {
        "href": "/api/v1/policies/POL-12345678/actions/change-beneficiary",
        "method": "POST",
        "title": "Change Beneficiary"
      },
      "make-payment": {
        "href": "/api/v1/policies/POL-12345678/payments",
        "method": "POST",
        "title": "Make Premium Payment"
      },
      "request-withdrawal": {
        "href": "/api/v1/policies/POL-12345678/withdrawals",
        "method": "POST",
        "title": "Request Withdrawal"
      },
      "request-loan": {
        "href": "/api/v1/policies/POL-12345678/loans",
        "method": "POST",
        "title": "Request Policy Loan"
      },
      "surrender": {
        "href": "/api/v1/policies/POL-12345678/actions/surrender",
        "method": "POST",
        "title": "Surrender Policy"
      }
    }
  }
}
```

---

## 4. API Design for Key PAS Domains

### 4.1 Policy Inquiry API

```yaml
# OpenAPI 3.0 — Policy Inquiry
openapi: 3.0.3
info:
  title: Policy Inquiry API
  version: 1.0.0
  description: Retrieve policy information, values, coverages, and parties.

paths:
  /api/v1/policies/{policyId}:
    get:
      operationId: getPolicy
      summary: Retrieve policy details
      tags: [Policy Inquiry]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
          example: "POL-12345678"
        - name: fields
          in: query
          schema:
            type: string
          description: Comma-separated list of fields to return
          example: "policyNumber,status,faceAmount"
        - name: include
          in: query
          schema:
            type: string
          description: Related resources to include
          example: "coverages,parties,values"
      responses:
        '200':
          description: Policy found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PolicyResponse'
        '404':
          description: Policy not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /api/v1/policies/{policyId}/values:
    get:
      operationId: getPolicyValues
      summary: Retrieve policy financial values
      tags: [Policy Inquiry]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
        - name: asOfDate
          in: query
          schema:
            type: string
            format: date
          description: Valuation date (defaults to current)
      responses:
        '200':
          description: Policy values retrieved
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PolicyValuesResponse'

  /api/v1/policies/{policyId}/coverages:
    get:
      operationId: getPolicyCoverages
      summary: List all coverages and riders on a policy
      tags: [Policy Inquiry]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Coverage list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CoverageListResponse'

components:
  schemas:
    PolicyResponse:
      type: object
      properties:
        policyId:
          type: string
          example: "POL-12345678"
        policyNumber:
          type: string
          example: "A1234567"
        productCode:
          type: string
          example: "UL-100"
        productName:
          type: string
          example: "Universal Life 100"
        status:
          type: string
          enum: [Applied, Issued, Active, PaidUp, ExtendedTerm, ReducedPaidUp, Lapsed, Surrendered, Matured, Deceased, Terminated]
          example: "Active"
        issueDate:
          type: string
          format: date
          example: "2020-03-15"
        effectiveDate:
          type: string
          format: date
          example: "2020-04-01"
        policyDate:
          type: string
          format: date
        maturityDate:
          type: string
          format: date
        jurisdictionCode:
          type: string
          example: "NY"
        totalFaceAmount:
          $ref: '#/components/schemas/Money'
        owner:
          $ref: '#/components/schemas/PartyReference'
        insured:
          $ref: '#/components/schemas/PartyReference'
        _links:
          type: object

    PolicyValuesResponse:
      type: object
      properties:
        policyId:
          type: string
        asOfDate:
          type: string
          format: date
        accountValue:
          $ref: '#/components/schemas/Money'
        cashSurrenderValue:
          $ref: '#/components/schemas/Money'
        netCashSurrenderValue:
          $ref: '#/components/schemas/Money'
        deathBenefit:
          $ref: '#/components/schemas/Money'
        loanBalance:
          $ref: '#/components/schemas/Money'
        loanInterestDue:
          $ref: '#/components/schemas/Money'
        netAmountAtRisk:
          $ref: '#/components/schemas/Money'
        costBasis:
          $ref: '#/components/schemas/Money'
        fundValues:
          type: array
          items:
            $ref: '#/components/schemas/FundValue'

    FundValue:
      type: object
      properties:
        fundCode:
          type: string
        fundName:
          type: string
        units:
          type: number
          format: double
        unitValue:
          $ref: '#/components/schemas/Money'
        totalValue:
          $ref: '#/components/schemas/Money'
        allocationPercentage:
          type: number
          format: double

    Money:
      type: object
      properties:
        amount:
          type: number
          format: double
        currency:
          type: string
          default: "USD"

    PartyReference:
      type: object
      properties:
        partyId:
          type: string
        fullName:
          type: string
        _link:
          type: string

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            traceId:
              type: string
```

### 4.2 New Business Submission API

```yaml
openapi: 3.0.3
info:
  title: New Business Submission API
  version: 1.0.0

paths:
  /api/v1/applications:
    post:
      operationId: submitApplication
      summary: Submit a new insurance application
      tags: [New Business]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ApplicationSubmission'
      responses:
        '201':
          description: Application created
          headers:
            Location:
              schema:
                type: string
              example: /api/v1/applications/APP-00001234
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApplicationResponse'
        '422':
          description: Validation errors
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ValidationErrorResponse'

  /api/v1/applications/{applicationId}:
    get:
      operationId: getApplication
      summary: Retrieve application status and details
      tags: [New Business]
      parameters:
        - name: applicationId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Application details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApplicationResponse'

  /api/v1/applications/{applicationId}/actions/submit-for-underwriting:
    post:
      operationId: submitForUnderwriting
      summary: Submit application to underwriting
      tags: [New Business]
      parameters:
        - name: applicationId
          in: path
          required: true
          schema:
            type: string
      responses:
        '202':
          description: Submitted for underwriting
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UnderwritingSubmissionResponse'

  /api/v1/applications/{applicationId}/actions/issue:
    post:
      operationId: issuePolicy
      summary: Issue policy from approved application
      tags: [New Business]
      parameters:
        - name: applicationId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IssuanceRequest'
      responses:
        '201':
          description: Policy issued
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IssuanceResponse'

components:
  schemas:
    ApplicationSubmission:
      type: object
      required: [productCode, applicant, coverages]
      properties:
        productCode:
          type: string
          example: "UL-100"
        applicationDate:
          type: string
          format: date
        requestedEffectiveDate:
          type: string
          format: date
        jurisdictionCode:
          type: string
          example: "NY"
        applicant:
          $ref: '#/components/schemas/ApplicantInfo'
        insured:
          $ref: '#/components/schemas/InsuredInfo'
        coverages:
          type: array
          items:
            $ref: '#/components/schemas/RequestedCoverage'
        beneficiaries:
          type: array
          items:
            $ref: '#/components/schemas/BeneficiaryDesignation'
        paymentInfo:
          $ref: '#/components/schemas/PaymentInfo'
        producerCode:
          type: string
        replacementInfo:
          $ref: '#/components/schemas/ReplacementInfo'

    ApplicantInfo:
      type: object
      required: [firstName, lastName, dateOfBirth, taxId]
      properties:
        firstName:
          type: string
        middleName:
          type: string
        lastName:
          type: string
        suffix:
          type: string
        dateOfBirth:
          type: string
          format: date
        gender:
          type: string
          enum: [Male, Female, NonBinary]
        taxId:
          type: string
        citizenship:
          type: string
        addresses:
          type: array
          items:
            $ref: '#/components/schemas/Address'
        communications:
          type: array
          items:
            $ref: '#/components/schemas/Communication'

    InsuredInfo:
      type: object
      properties:
        sameAsApplicant:
          type: boolean
          default: true
        firstName:
          type: string
        lastName:
          type: string
        dateOfBirth:
          type: string
          format: date
        gender:
          type: string
        tobaccoUse:
          type: boolean
        occupation:
          type: string
        annualIncome:
          $ref: '#/components/schemas/Money'
        netWorth:
          $ref: '#/components/schemas/Money'

    RequestedCoverage:
      type: object
      required: [planCode, faceAmount]
      properties:
        planCode:
          type: string
        faceAmount:
          $ref: '#/components/schemas/Money'
        premiumMode:
          type: string
          enum: [Annual, SemiAnnual, Quarterly, Monthly]
        riskClassRequested:
          type: string
          enum: [PreferredPlus, Preferred, Standard, Substandard]

    BeneficiaryDesignation:
      type: object
      properties:
        designationType:
          type: string
          enum: [Primary, Contingent]
        beneficiaryType:
          type: string
          enum: [Individual, Trust, Estate, Charity, Organization]
        firstName:
          type: string
        lastName:
          type: string
        relationship:
          type: string
        percentage:
          type: number
        irrevocable:
          type: boolean
          default: false

    ApplicationResponse:
      type: object
      properties:
        applicationId:
          type: string
        status:
          type: string
          enum: [Draft, Submitted, InUnderwriting, Approved, Declined, Withdrawn, Issued]
        policyNumber:
          type: string
          description: Populated after issuance
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time
```

### 4.3 Policy Change Request API

```yaml
openapi: 3.0.3
info:
  title: Policy Change Request API
  version: 1.0.0

paths:
  /api/v1/policies/{policyId}/change-requests:
    post:
      operationId: createChangeRequest
      summary: Create a policy change request
      tags: [Policy Servicing]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ChangeRequest'
      responses:
        '201':
          description: Change request created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ChangeRequestResponse'
        '409':
          description: Conflicting change request pending

    get:
      operationId: listChangeRequests
      summary: List change requests for a policy
      tags: [Policy Servicing]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
        - name: status
          in: query
          schema:
            type: string
            enum: [Pending, Approved, Rejected, Completed, Cancelled]
      responses:
        '200':
          description: Change request list

components:
  schemas:
    ChangeRequest:
      type: object
      required: [changeType]
      properties:
        changeType:
          type: string
          enum:
            - BeneficiaryChange
            - AddressChange
            - OwnershipChange
            - FaceAmountIncrease
            - FaceAmountDecrease
            - CoverageAddition
            - CoverageRemoval
            - PremiumModeChange
            - BillingMethodChange
            - FundAllocationChange
            - DividendOptionChange
            - NameChange
            - AssignmentChange
        effectiveDate:
          type: string
          format: date
        reason:
          type: string
        details:
          type: object
          description: Change-type-specific payload
          oneOf:
            - $ref: '#/components/schemas/BeneficiaryChangeDetails'
            - $ref: '#/components/schemas/AddressChangeDetails'
            - $ref: '#/components/schemas/FaceAmountChangeDetails'
            - $ref: '#/components/schemas/FundAllocationChangeDetails'
        supportingDocuments:
          type: array
          items:
            type: string
            format: binary

    BeneficiaryChangeDetails:
      type: object
      properties:
        beneficiaries:
          type: array
          items:
            type: object
            properties:
              designationType:
                type: string
                enum: [Primary, Contingent]
              firstName:
                type: string
              lastName:
                type: string
              relationship:
                type: string
              percentage:
                type: number
              irrevocable:
                type: boolean

    AddressChangeDetails:
      type: object
      properties:
        partyId:
          type: string
        newAddress:
          type: object
          properties:
            line1:
              type: string
            line2:
              type: string
            city:
              type: string
            stateCode:
              type: string
            postalCode:
              type: string
            countryCode:
              type: string
```

### 4.4 Premium Payment API

```yaml
openapi: 3.0.3
info:
  title: Premium Payment API
  version: 1.0.0

paths:
  /api/v1/policies/{policyId}/payments:
    post:
      operationId: submitPayment
      summary: Submit a premium payment
      tags: [Payments]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PaymentRequest'
      responses:
        '201':
          description: Payment accepted
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentResponse'
        '409':
          description: Payment not allowed (e.g., policy lapsed)

    get:
      operationId: listPayments
      summary: List payment history for a policy
      tags: [Payments]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
        - name: fromDate
          in: query
          schema:
            type: string
            format: date
        - name: toDate
          in: query
          schema:
            type: string
            format: date
        - name: limit
          in: query
          schema:
            type: integer
            default: 25
        - name: cursor
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Payment history

components:
  schemas:
    PaymentRequest:
      type: object
      required: [amount, paymentMethod]
      properties:
        amount:
          $ref: '#/components/schemas/Money'
        paymentType:
          type: string
          enum: [ScheduledPremium, AdditionalPremium, LoanRepayment, ReinstatementPremium]
        paymentMethod:
          type: object
          properties:
            type:
              type: string
              enum: [ACH, CreditCard, Wire, Check, EFT]
            achDetails:
              type: object
              properties:
                routingNumber:
                  type: string
                accountNumber:
                  type: string
                accountType:
                  type: string
                  enum: [Checking, Savings]
            cardDetails:
              type: object
              properties:
                tokenizedCardNumber:
                  type: string
                expirationMonth:
                  type: integer
                expirationYear:
                  type: integer
        effectiveDate:
          type: string
          format: date
        memo:
          type: string

    PaymentResponse:
      type: object
      properties:
        paymentId:
          type: string
        status:
          type: string
          enum: [Pending, Processing, Applied, Failed, Reversed]
        confirmationNumber:
          type: string
        appliedDate:
          type: string
          format: date
        allocations:
          type: array
          items:
            type: object
            properties:
              fundCode:
                type: string
              amount:
                $ref: '#/components/schemas/Money'
```

### 4.5 Fund Transfer API

```yaml
openapi: 3.0.3
info:
  title: Fund Transfer API
  version: 1.0.0

paths:
  /api/v1/policies/{policyId}/fund-transfers:
    post:
      operationId: executeFundTransfer
      summary: Transfer between investment funds
      tags: [Financial]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/FundTransferRequest'
      responses:
        '201':
          description: Fund transfer executed
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/FundTransferResponse'

components:
  schemas:
    FundTransferRequest:
      type: object
      required: [transfers]
      properties:
        transferType:
          type: string
          enum: [Transfer, Rebalance, DollarCostAveraging]
        effectiveDate:
          type: string
          format: date
        transfers:
          type: array
          items:
            type: object
            required: [fromFund, toFund]
            properties:
              fromFund:
                type: string
              toFund:
                type: string
              amount:
                $ref: '#/components/schemas/Money'
              percentage:
                type: number
                description: Transfer percentage of from-fund value
        newAllocation:
          type: object
          description: For rebalance — target allocation
          properties:
            allocations:
              type: array
              items:
                type: object
                properties:
                  fundCode:
                    type: string
                  percentage:
                    type: number
```

### 4.6 Withdrawal / Loan Request API

```yaml
openapi: 3.0.3
info:
  title: Withdrawal & Loan API
  version: 1.0.0

paths:
  /api/v1/policies/{policyId}/withdrawals:
    post:
      operationId: requestWithdrawal
      summary: Request a partial withdrawal
      tags: [Financial]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WithdrawalRequest'
      responses:
        '201':
          description: Withdrawal request accepted
        '422':
          description: Withdrawal exceeds available amount

  /api/v1/policies/{policyId}/loans:
    post:
      operationId: requestLoan
      summary: Request a policy loan
      tags: [Financial]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LoanRequest'
      responses:
        '201':
          description: Loan request accepted
        '422':
          description: Loan amount exceeds maximum loanable value

components:
  schemas:
    WithdrawalRequest:
      type: object
      required: [amount]
      properties:
        amount:
          $ref: '#/components/schemas/Money'
        withdrawalType:
          type: string
          enum: [Partial, Full, SystematicWithdrawal, RequiredMinimumDistribution]
        taxWithholding:
          type: object
          properties:
            federalWithholdingPercent:
              type: number
            stateWithholdingPercent:
              type: number
        disbursement:
          $ref: '#/components/schemas/DisbursementMethod'
        fundSources:
          type: array
          items:
            type: object
            properties:
              fundCode:
                type: string
              amount:
                $ref: '#/components/schemas/Money'

    LoanRequest:
      type: object
      required: [amount]
      properties:
        amount:
          $ref: '#/components/schemas/Money'
        loanType:
          type: string
          enum: [Standard, Preferred, Automatic]
        disbursement:
          $ref: '#/components/schemas/DisbursementMethod'

    DisbursementMethod:
      type: object
      properties:
        method:
          type: string
          enum: [Check, ACH, Wire]
        payee:
          type: string
        achDetails:
          type: object
          properties:
            routingNumber:
              type: string
            accountNumber:
              type: string
```

### 4.7 Claim Submission API

```yaml
openapi: 3.0.3
info:
  title: Claims API
  version: 1.0.0

paths:
  /api/v1/claims:
    post:
      operationId: submitClaim
      summary: Submit a new claim
      tags: [Claims]
      requestBody:
        required: true
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

  /api/v1/claims/{claimId}:
    get:
      operationId: getClaim
      summary: Retrieve claim details
      tags: [Claims]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Claim details

  /api/v1/claims/{claimId}/documents:
    post:
      operationId: uploadClaimDocument
      summary: Upload supporting documentation
      tags: [Claims]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        content:
          multipart/form-data:
            schema:
              type: object
              properties:
                file:
                  type: string
                  format: binary
                documentType:
                  type: string
                  enum: [DeathCertificate, ProofOfLoss, MedicalRecords, PoliceReport, BeneficiaryIdentification, Other]
      responses:
        '201':
          description: Document uploaded

components:
  schemas:
    ClaimSubmission:
      type: object
      required: [policyId, claimType, dateOfEvent]
      properties:
        policyId:
          type: string
        claimType:
          type: string
          enum: [Death, AccidentalDeath, Disability, CriticalIllness, WaiverOfPremium, AcceleratedDeathBenefit, LivingBenefit]
        dateOfEvent:
          type: string
          format: date
        causeOfEvent:
          type: string
        claimant:
          type: object
          properties:
            partyId:
              type: string
            firstName:
              type: string
            lastName:
              type: string
            relationship:
              type: string
            contactPhone:
              type: string
            contactEmail:
              type: string
        notificationDate:
          type: string
          format: date
        description:
          type: string

    ClaimResponse:
      type: object
      properties:
        claimId:
          type: string
        claimNumber:
          type: string
        status:
          type: string
          enum: [Submitted, UnderReview, InformationRequested, Approved, Denied, Paid, Closed]
        policyId:
          type: string
        claimType:
          type: string
        dateOfEvent:
          type: string
          format: date
        estimatedPayoutAmount:
          $ref: '#/components/schemas/Money'
        assignedExaminer:
          type: string
        createdAt:
          type: string
          format: date-time
```

### 4.8 Document Retrieval API

```yaml
paths:
  /api/v1/policies/{policyId}/documents:
    get:
      operationId: listDocuments
      summary: List documents attached to a policy
      tags: [Documents]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
        - name: documentType
          in: query
          schema:
            type: string
            enum: [Application, Policy, Endorsement, Illustration, Correspondence, Statement, TaxForm, LegalDocument]
        - name: fromDate
          in: query
          schema:
            type: string
            format: date
      responses:
        '200':
          description: Document list
          content:
            application/json:
              schema:
                type: object
                properties:
                  documents:
                    type: array
                    items:
                      $ref: '#/components/schemas/DocumentMetadata'

  /api/v1/policies/{policyId}/documents/{documentId}/content:
    get:
      operationId: downloadDocument
      summary: Download document content
      tags: [Documents]
      parameters:
        - name: policyId
          in: path
          required: true
          schema:
            type: string
        - name: documentId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Document content
          content:
            application/pdf:
              schema:
                type: string
                format: binary
            image/tiff:
              schema:
                type: string
                format: binary

components:
  schemas:
    DocumentMetadata:
      type: object
      properties:
        documentId:
          type: string
        documentType:
          type: string
        title:
          type: string
        createdDate:
          type: string
          format: date-time
        contentType:
          type: string
        sizeBytes:
          type: integer
        tags:
          type: array
          items:
            type: string
```

### 4.9 Illustration Generation API

```yaml
paths:
  /api/v1/illustrations:
    post:
      operationId: generateIllustration
      summary: Generate a policy illustration
      tags: [Illustrations]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IllustrationRequest'
      responses:
        '202':
          description: Illustration generation started
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IllustrationJobResponse'

  /api/v1/illustrations/{illustrationId}:
    get:
      operationId: getIllustration
      summary: Retrieve illustration results
      tags: [Illustrations]
      parameters:
        - name: illustrationId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Illustration data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IllustrationResponse'

  /api/v1/illustrations/{illustrationId}/pdf:
    get:
      operationId: getIllustrationPdf
      summary: Download illustration as PDF
      tags: [Illustrations]
      responses:
        '200':
          description: PDF document
          content:
            application/pdf:
              schema:
                type: string
                format: binary

components:
  schemas:
    IllustrationRequest:
      type: object
      required: [productCode, insuredAge, insuredGender, faceAmount]
      properties:
        productCode:
          type: string
        insuredAge:
          type: integer
        insuredGender:
          type: string
        insuredRiskClass:
          type: string
        faceAmount:
          $ref: '#/components/schemas/Money'
        plannedPremium:
          $ref: '#/components/schemas/Money'
        premiumMode:
          type: string
        premiumPayingPeriod:
          type: integer
        riders:
          type: array
          items:
            type: object
            properties:
              riderCode:
                type: string
              coverageAmount:
                $ref: '#/components/schemas/Money'
        illustrationScenarios:
          type: array
          items:
            type: object
            properties:
              scenarioName:
                type: string
              interestRate:
                type: number
              dividendScale:
                type: string
```

### 4.10 Agent / Producer Services API

```yaml
paths:
  /api/v1/producers/{producerCode}:
    get:
      operationId: getProducer
      summary: Retrieve producer/agent information
      tags: [Producer Services]
      parameters:
        - name: producerCode
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Producer details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ProducerResponse'

  /api/v1/producers/{producerCode}/book-of-business:
    get:
      operationId: getBookOfBusiness
      summary: Retrieve producer's policy portfolio
      tags: [Producer Services]
      parameters:
        - name: producerCode
          in: path
          required: true
          schema:
            type: string
        - name: status
          in: query
          schema:
            type: string
        - name: productLine
          in: query
          schema:
            type: string
        - name: limit
          in: query
          schema:
            type: integer
            default: 50
        - name: cursor
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Book of business

  /api/v1/producers/{producerCode}/commissions:
    get:
      operationId: getCommissions
      summary: Retrieve commission statements
      tags: [Producer Services]
      parameters:
        - name: producerCode
          in: path
          required: true
          schema:
            type: string
        - name: fromDate
          in: query
          schema:
            type: string
            format: date
        - name: toDate
          in: query
          schema:
            type: string
            format: date
      responses:
        '200':
          description: Commission statement data

components:
  schemas:
    ProducerResponse:
      type: object
      properties:
        producerCode:
          type: string
        firstName:
          type: string
        lastName:
          type: string
        agency:
          type: string
        status:
          type: string
          enum: [Active, Inactive, Suspended, Terminated]
        licenses:
          type: array
          items:
            type: object
            properties:
              stateCode:
                type: string
              licenseNumber:
                type: string
              licenseType:
                type: string
              effectiveDate:
                type: string
                format: date
              expirationDate:
                type: string
                format: date
              status:
                type: string
        appointments:
          type: array
          items:
            type: object
            properties:
              lineOfAuthority:
                type: string
              companyCode:
                type: string
              effectiveDate:
                type: string
                format: date
```

---

## 5. GraphQL for Insurance

### 5.1 Schema Design for Policy Data

```graphql
# Core Types

type Query {
  policy(policyId: ID!): Policy
  policies(filter: PolicyFilter, pagination: PaginationInput): PolicyConnection!
  party(partyId: ID!): Party
  claim(claimId: ID!): Claim
  illustration(illustrationId: ID!): Illustration
  producer(producerCode: String!): Producer
}

type Mutation {
  submitApplication(input: ApplicationInput!): ApplicationResult!
  updateBeneficiary(policyId: ID!, input: BeneficiaryInput!): BeneficiaryResult!
  submitPayment(policyId: ID!, input: PaymentInput!): PaymentResult!
  requestWithdrawal(policyId: ID!, input: WithdrawalInput!): WithdrawalResult!
  requestLoan(policyId: ID!, input: LoanInput!): LoanResult!
  transferFunds(policyId: ID!, input: FundTransferInput!): FundTransferResult!
  submitClaim(input: ClaimInput!): ClaimResult!
  generateIllustration(input: IllustrationInput!): IllustrationJob!
}

type Subscription {
  policyStatusChanged(policyId: ID!): PolicyStatusEvent!
  claimStatusChanged(claimId: ID!): ClaimStatusEvent!
  paymentProcessed(policyId: ID!): PaymentEvent!
}

# Policy Types

type Policy {
  policyId: ID!
  policyNumber: String!
  productCode: String!
  productName: String!
  status: PolicyStatus!
  issueDate: Date
  effectiveDate: Date
  maturityDate: Date
  jurisdictionCode: String
  totalFaceAmount: Money!
  owner: Party!
  insured: Party!
  coverages: [Coverage!]!
  beneficiaries: [BeneficiaryDesignation!]!
  values(asOfDate: Date): PolicyValues!
  billing: BillingArrangement
  transactions(
    filter: TransactionFilter
    pagination: PaginationInput
  ): TransactionConnection!
  documents(filter: DocumentFilter): [Document!]!
  activities(pagination: PaginationInput): ActivityConnection!
  loans: [PolicyLoan!]!
}

type PolicyValues {
  asOfDate: Date!
  accountValue: Money!
  cashSurrenderValue: Money!
  netCashSurrenderValue: Money!
  deathBenefit: Money!
  loanBalance: Money!
  loanInterestDue: Money!
  netAmountAtRisk: Money!
  costBasis: Money!
  fundValues: [FundValue!]!
}

type Coverage {
  coverageId: ID!
  planCode: String!
  planName: String!
  coverageType: CoverageType!
  status: CoverageStatus!
  faceAmount: Money!
  effectiveDate: Date!
  terminationDate: Date
  riders: [Rider!]!
  insured: Party!
  benefits: [Benefit!]!
}

type Rider {
  riderId: ID!
  riderCode: String!
  riderName: String!
  status: CoverageStatus!
  benefitAmount: Money
  effectiveDate: Date!
}

type FundValue {
  fundCode: String!
  fundName: String!
  units: Float!
  unitValue: Money!
  totalValue: Money!
  allocationPercentage: Float!
}

type Party {
  partyId: ID!
  partyType: PartyType!
  firstName: String
  lastName: String
  fullName: String!
  dateOfBirth: Date
  gender: Gender
  taxId: String
  addresses: [Address!]!
  communications: [Communication!]!
  policies(role: RoleType): [Policy!]!
}

type BeneficiaryDesignation {
  designationType: DesignationType!
  party: Party!
  relationship: String
  percentage: Float!
  irrevocable: Boolean!
}

# Financial Types

type Money {
  amount: Float!
  currency: String!
}

type Transaction {
  transactionId: ID!
  transactionType: TransactionType!
  transactionDate: Date!
  effectiveDate: Date!
  amount: Money!
  status: TransactionStatus!
  description: String
}

# Enums

enum PolicyStatus {
  APPLIED
  ISSUED
  ACTIVE
  PAID_UP
  EXTENDED_TERM
  REDUCED_PAID_UP
  LAPSED
  SURRENDERED
  MATURED
  DECEASED
  TERMINATED
}

enum CoverageType {
  BASE
  RIDER
  SUPPLEMENTAL
}

enum CoverageStatus {
  ACTIVE
  TERMINATED
  WAIVED
  REDUCED
}

enum TransactionType {
  PREMIUM
  WITHDRAWAL
  LOAN
  LOAN_REPAYMENT
  SURRENDER
  DEATH_BENEFIT
  DIVIDEND
  INTEREST_CREDIT
  COI_DEDUCTION
  EXPENSE_CHARGE
  FUND_TRANSFER
}

enum DesignationType {
  PRIMARY
  CONTINGENT
}

enum PartyType {
  INDIVIDUAL
  ORGANIZATION
  TRUST
}

enum Gender {
  MALE
  FEMALE
  NON_BINARY
}

enum RoleType {
  OWNER
  INSURED
  BENEFICIARY
  PAYOR
  ASSIGNEE
}

# Input Types

input PolicyFilter {
  status: [PolicyStatus!]
  productCode: String
  issueDateFrom: Date
  issueDateTo: Date
  ownerPartyId: ID
  faceAmountMin: Float
  faceAmountMax: Float
  jurisdictionCode: String
  searchText: String
}

input PaginationInput {
  first: Int
  after: String
  last: Int
  before: String
}

# Connection Types (Relay-style pagination)

type PolicyConnection {
  edges: [PolicyEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type PolicyEdge {
  node: Policy!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}
```

### 5.2 Resolver Architecture

```typescript
// Resolver implementation pattern

const resolvers = {
  Query: {
    policy: async (_, { policyId }, context) => {
      context.authorize('policy:read');
      return context.dataSources.policyService.getPolicy(policyId);
    },
    policies: async (_, { filter, pagination }, context) => {
      context.authorize('policy:read');
      return context.dataSources.policyService.searchPolicies(filter, pagination);
    },
  },

  Policy: {
    owner: async (policy, _, context) => {
      return context.dataSources.partyLoader.load(policy.ownerPartyId);
    },
    insured: async (policy, _, context) => {
      return context.dataSources.partyLoader.load(policy.insuredPartyId);
    },
    coverages: async (policy, _, context) => {
      return context.dataSources.coverageLoader.load(policy.policyId);
    },
    values: async (policy, { asOfDate }, context) => {
      const date = asOfDate || new Date().toISOString().split('T')[0];
      return context.dataSources.valuationService.getValues(policy.policyId, date);
    },
    transactions: async (policy, { filter, pagination }, context) => {
      return context.dataSources.transactionService
        .getTransactions(policy.policyId, filter, pagination);
    },
    documents: async (policy, { filter }, context) => {
      return context.dataSources.documentService
        .getDocuments(policy.policyId, filter);
    },
  },

  Party: {
    policies: async (party, { role }, context) => {
      return context.dataSources.policyService
        .getPoliciesByParty(party.partyId, role);
    },
  },
};
```

### 5.3 DataLoader for Batching and Caching

```typescript
import DataLoader from 'dataloader';

function createDataLoaders(services) {
  return {
    partyLoader: new DataLoader(async (partyIds: string[]) => {
      const parties = await services.partyService.getPartiesByIds(partyIds);
      const partyMap = new Map(parties.map(p => [p.partyId, p]));
      return partyIds.map(id => partyMap.get(id) || null);
    }),

    coverageLoader: new DataLoader(async (policyIds: string[]) => {
      const coverages = await services.coverageService
        .getCoveragesByPolicyIds(policyIds);
      const coverageMap = new Map<string, Coverage[]>();
      coverages.forEach(c => {
        const list = coverageMap.get(c.policyId) || [];
        list.push(c);
        coverageMap.set(c.policyId, list);
      });
      return policyIds.map(id => coverageMap.get(id) || []);
    }),

    fundValueLoader: new DataLoader(async (keys: string[]) => {
      // keys format: "policyId:date"
      const results = await services.valuationService.batchGetFundValues(keys);
      return keys.map(k => results.get(k) || []);
    }),
  };
}
```

### 5.4 Complexity Limits

```typescript
import { createComplexityLimitRule } from 'graphql-validation-complexity';

const complexityLimit = createComplexityLimitRule(1000, {
  scalarCost: 1,
  objectCost: 2,
  listFactor: 10,
  onCost: (cost) => {
    console.log(`Query complexity: ${cost}`);
  },
  formatErrorMessage: (cost) =>
    `Query complexity ${cost} exceeds maximum of 1000.`,
});

// Field-level cost directives
// directive @cost(complexity: Int!) on FIELD_DEFINITION
// type Policy {
//   transactions(...): TransactionConnection! @cost(complexity: 50)
//   documents(...): [Document!]! @cost(complexity: 30)
//   values(...): PolicyValues! @cost(complexity: 20)
// }
```

### 5.5 Federation for Multi-Domain Insurance Data

```mermaid
graph TB
    subgraph "GraphQL Gateway"
        GW[Apollo Gateway / Federation Router]
    end

    subgraph "Subgraphs"
        S1[Policy Subgraph<br/>Policies, Coverages, Values]
        S2[Party Subgraph<br/>Persons, Organizations, Roles]
        S3[Financial Subgraph<br/>Transactions, Billing, Payments]
        S4[Claims Subgraph<br/>Claims, Benefits, Payouts]
        S5[Document Subgraph<br/>Documents, Correspondence]
        S6[Producer Subgraph<br/>Agents, Commissions, Licensing]
    end

    GW --> S1 & S2 & S3 & S4 & S5 & S6
```

```graphql
# Policy Subgraph — extends Party from Party subgraph
extend type Party @key(fields: "partyId") {
  partyId: ID! @external
  policyRoles: [PolicyRole!]!
}

type PolicyRole {
  policy: Policy!
  roleType: RoleType!
  effectiveDate: Date!
}
```

### 5.6 GraphQL vs REST Trade-offs for Insurance

| Aspect | REST | GraphQL | Recommendation |
|--------|------|---------|----------------|
| **Policy Inquiry (simple)** | Single GET call | Single query | Either works; REST simpler |
| **Policy Inquiry (complex)** | Multiple calls (N+1) | Single query with includes | GraphQL preferred |
| **New Business Submission** | POST with full payload | Mutation | REST preferred (simpler) |
| **Batch Operations** | Bulk endpoints | Query batching | REST for writes, GraphQL for reads |
| **Partner APIs** | Well-understood | Steeper learning curve | REST for external partners |
| **Internal BFF** | Many BFF endpoints | One flexible endpoint | GraphQL preferred |
| **Caching** | HTTP caching (CDN, ETag) | Complex (persisted queries) | REST easier to cache |
| **File upload** | Multipart POST | Requires separate approach | REST preferred |
| **Real-time** | SSE / Webhooks | Subscriptions | GraphQL subscriptions |
| **Versioning** | URL/header versioning | Schema evolution | GraphQL easier |

---

## 6. Event-Driven APIs

### 6.1 AsyncAPI Specification for Insurance Events

```yaml
asyncapi: 2.6.0
info:
  title: Insurance Policy Events API
  version: 1.0.0
  description: Event-driven API for life insurance policy administration events.

servers:
  production:
    url: kafka.insurance.example.com:9092
    protocol: kafka
    description: Production Kafka cluster
  webhook:
    url: https://api.insurance.example.com/webhooks
    protocol: https
    description: Webhook delivery endpoint

channels:
  policy.issued:
    description: Emitted when a new policy is issued
    subscribe:
      operationId: onPolicyIssued
      message:
        $ref: '#/components/messages/PolicyIssued'

  premium.received:
    description: Emitted when a premium payment is successfully applied
    subscribe:
      operationId: onPremiumReceived
      message:
        $ref: '#/components/messages/PremiumReceived'

  claim.submitted:
    description: Emitted when a new claim is submitted
    subscribe:
      operationId: onClaimSubmitted
      message:
        $ref: '#/components/messages/ClaimSubmitted'

  fund.transfer.completed:
    description: Emitted when a fund transfer is completed
    subscribe:
      operationId: onFundTransferCompleted
      message:
        $ref: '#/components/messages/FundTransferCompleted'

  payout.processed:
    description: Emitted when a claim payout is processed
    subscribe:
      operationId: onPayoutProcessed
      message:
        $ref: '#/components/messages/PayoutProcessed'

  policy.lapsed:
    description: Emitted when a policy lapses
    subscribe:
      operationId: onPolicyLapsed
      message:
        $ref: '#/components/messages/PolicyLapsed'

  policy.surrendered:
    description: Emitted when a policy is surrendered
    subscribe:
      operationId: onPolicySurrendered
      message:
        $ref: '#/components/messages/PolicySurrendered'

components:
  messages:
    PolicyIssued:
      name: PolicyIssued
      contentType: application/json
      headers:
        type: object
        properties:
          eventId:
            type: string
            format: uuid
          eventType:
            type: string
            const: "policy.issued"
          timestamp:
            type: string
            format: date-time
          correlationId:
            type: string
          source:
            type: string
      payload:
        type: object
        properties:
          policyId:
            type: string
          policyNumber:
            type: string
          productCode:
            type: string
          issueDate:
            type: string
            format: date
          effectiveDate:
            type: string
            format: date
          ownerPartyId:
            type: string
          insuredPartyId:
            type: string
          totalFaceAmount:
            type: number
          jurisdictionCode:
            type: string
          producerCode:
            type: string

    PremiumReceived:
      name: PremiumReceived
      contentType: application/json
      payload:
        type: object
        properties:
          paymentId:
            type: string
          policyId:
            type: string
          amount:
            type: number
          currency:
            type: string
          paymentType:
            type: string
          effectiveDate:
            type: string
            format: date
          paymentMethod:
            type: string

    ClaimSubmitted:
      name: ClaimSubmitted
      contentType: application/json
      payload:
        type: object
        properties:
          claimId:
            type: string
          policyId:
            type: string
          claimType:
            type: string
          dateOfEvent:
            type: string
            format: date
          claimantPartyId:
            type: string
          estimatedAmount:
            type: number
```

### 6.2 Event Schema Design Principles

1. **Self-Contained Events**: Each event carries enough context for consumers to act without fetching additional data.
2. **Immutable Facts**: Events describe what happened, not what to do.
3. **Causal Metadata**: Every event includes `eventId`, `timestamp`, `correlationId`, `causationId`, and `source`.
4. **Schema Versioning**: Events include a `schemaVersion` field; consumers must handle unknown fields gracefully.
5. **Domain Language**: Event names use past tense (`PolicyIssued`, not `IssuePolicy`).

### 6.3 Webhook Delivery

```mermaid
sequenceDiagram
    participant PAS as PAS System
    participant WE as Webhook Engine
    participant EP as Partner Endpoint

    PAS->>WE: Publish event
    WE->>WE: Match subscriptions
    WE->>EP: POST /webhook-endpoint<br/>with HMAC signature
    alt Success (2xx)
        EP-->>WE: 200 OK
        WE->>WE: Mark delivered
    else Failure (4xx/5xx/timeout)
        EP-->>WE: 500 Error
        WE->>WE: Schedule retry<br/>(exponential backoff)
        Note over WE: Retry at 30s, 2m,<br/>15m, 1h, 4h, 24h
        WE->>EP: Retry delivery
    end
```

#### Webhook Security

```
POST /partner/webhook-endpoint HTTP/1.1
Content-Type: application/json
X-Webhook-Id: evt_abc123
X-Webhook-Timestamp: 1704067200
X-Webhook-Signature: sha256=5257a869e7ecebeda32affa62cdca3fa51cad7e77a0e56ff536d0ce8e108d8bd

{
  "eventType": "policy.issued",
  "eventId": "evt_abc123",
  ...
}
```

Verification:

```python
import hmac
import hashlib

def verify_webhook(payload_body, signature_header, secret):
    expected = hmac.new(
        secret.encode('utf-8'),
        payload_body,
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(f"sha256={expected}", signature_header)
```

### 6.4 Event Subscription Management API

```yaml
paths:
  /api/v1/webhooks/subscriptions:
    post:
      operationId: createSubscription
      summary: Create a webhook subscription
      requestBody:
        content:
          application/json:
            schema:
              type: object
              required: [url, events]
              properties:
                url:
                  type: string
                  format: uri
                events:
                  type: array
                  items:
                    type: string
                  example: ["policy.issued", "claim.submitted", "premium.received"]
                filter:
                  type: object
                  properties:
                    productCodes:
                      type: array
                      items:
                        type: string
                    jurisdictions:
                      type: array
                      items:
                        type: string
                secret:
                  type: string
                  description: Shared secret for HMAC signature
      responses:
        '201':
          description: Subscription created
```

---

## 7. ACORD API Standards

### 7.1 ACORD REST API Framework

ACORD (Association for Cooperative Operations Research and Development) provides industry-standard data models and API conventions for insurance.

#### Key ACORD Concepts

| ACORD Concept | REST Mapping | Example |
|---------------|-------------|---------|
| `TXLifeRequest` / `TXLifeResponse` | Request/Response body | Policy inquiry maps to GET with TXLife response |
| `OLifE` (Object model for Life) | JSON schema | Party, Holding, Coverage objects |
| `Holding` | `/holdings/{id}` or `/policies/{id}` | Insurance contract container |
| `Party` | `/parties/{id}` | Person or Organization |
| `Relation` | Embedded in parent | Party-to-Holding relationship |
| `Coverage` | `/policies/{id}/coverages/{id}` | Coverage/benefit |
| `Activity` | `/policies/{id}/activities` | Transaction/event |

### 7.2 ACORD Message Mapping to REST

```mermaid
graph LR
    subgraph "ACORD Messages"
        A1[TXLifeRequest<br/>TransType=228<br/>Policy Inquiry]
        A2[TXLifeRequest<br/>TransType=103<br/>New Business]
        A3[TXLifeRequest<br/>TransType=152<br/>Policy Change]
    end

    subgraph "REST APIs"
        R1[GET /policies/{id}]
        R2[POST /applications]
        R3[POST /policies/{id}/change-requests]
    end

    A1 --> R1
    A2 --> R2
    A3 --> R3
```

### 7.3 ACORD Code Tables in API Responses

```json
{
  "policyStatus": {
    "code": "12",
    "description": "Active",
    "codeTable": "OLI_LU_POLSTAT"
  },
  "productType": {
    "code": "2",
    "description": "Universal Life",
    "codeTable": "OLI_LU_POLPROD"
  },
  "tobaccoUse": {
    "code": "1",
    "description": "Current Smoker",
    "codeTable": "OLI_LU_TOBACCOUSE"
  }
}
```

Provide a code lookup API:

```
GET /api/v1/reference/code-tables/OLI_LU_POLSTAT
GET /api/v1/reference/code-tables/OLI_LU_POLSTAT/codes/12
```

---

## 8. API Security

### 8.1 OAuth 2.0 Flows for Insurance

```mermaid
graph TB
    subgraph "Consumer Types"
        C1[Customer Portal<br/>Authorization Code + PKCE]
        C2[Agent Portal<br/>Authorization Code + PKCE]
        C3[Partner API<br/>Client Credentials]
        C4[Internal Service<br/>Client Credentials / mTLS]
        C5[Mobile App<br/>Authorization Code + PKCE]
    end

    subgraph "Identity Provider"
        IDP[OAuth 2.0 / OIDC<br/>Authorization Server]
    end

    subgraph "API Layer"
        GW[API Gateway<br/>Token Validation]
        API[PAS APIs]
    end

    C1 --> IDP
    C2 --> IDP
    C3 --> IDP
    C4 --> IDP
    C5 --> IDP
    IDP --> GW
    GW --> API
```

#### Authorization Code Flow (Customer/Agent Portals)

```
1. User clicks "Login" on portal
2. Redirect to: https://auth.insurance.com/authorize?
     response_type=code&
     client_id=portal-app&
     redirect_uri=https://portal.insurance.com/callback&
     scope=openid profile policy:read policy:write&
     state=xyz123&
     code_challenge=E9Melhoa2OwvFrEMTJguCH...&
     code_challenge_method=S256
3. User authenticates (MFA)
4. Redirect back with authorization code
5. Portal exchanges code for tokens:
   POST /token
   grant_type=authorization_code&
   code=AUTH_CODE&
   code_verifier=ORIGINAL_VERIFIER
6. Receive access_token + id_token + refresh_token
```

#### Client Credentials Flow (Partner APIs)

```
POST /token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
client_id=partner-xyz&
client_secret=SECRET&
scope=policy:read claims:write
```

#### Token Exchange (Internal Delegation)

```
POST /token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:token-exchange&
subject_token=ORIGINAL_ACCESS_TOKEN&
subject_token_type=urn:ietf:params:oauth:token-type:access_token&
requested_token_type=urn:ietf:params:oauth:token-type:access_token&
scope=financial:write&
audience=financial-service
```

### 8.2 JWT Token Design for Insurance

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "key-2026-01"
  },
  "payload": {
    "iss": "https://auth.insurance.com",
    "sub": "user-12345",
    "aud": "https://api.insurance.com",
    "exp": 1704070800,
    "iat": 1704067200,
    "jti": "unique-token-id",
    "scope": "policy:read policy:write claims:read",
    "roles": ["agent", "licensed-ny", "licensed-ca"],
    "producerCode": "AGT-001234",
    "agencyCode": "AGY-5678",
    "licenseStates": ["NY", "CA", "TX"],
    "policiesAccessible": "*",
    "clientId": "agent-portal-app",
    "amr": ["pwd", "otp"],
    "auth_time": 1704067100
  }
}
```

### 8.3 Authorization Patterns

#### Attribute-Based Access Control (ABAC) for Policy Access

```mermaid
graph LR
    A[API Request] --> B{Token Valid?}
    B -->|No| C[401 Unauthorized]
    B -->|Yes| D{Scope Sufficient?}
    D -->|No| E[403 Forbidden]
    D -->|Yes| F{ABAC Policy Check}
    F --> G{Is agent licensed<br/>in policy jurisdiction?}
    G -->|No| E
    G -->|Yes| H{Is agent assigned<br/>to this policy?}
    H -->|No| I{Is supervisor<br/>override allowed?}
    I -->|No| E
    I -->|Yes| J[Allow with Audit]
    H -->|Yes| J
    J --> K[Execute API Call]
```

#### Policy-Level Access Matrix

| Role | Policy Inquiry | Make Payment | Change Beneficiary | Submit Claim | View Financials |
|------|:---:|:---:|:---:|:---:|:---:|
| Policy Owner | Own policies | Own policies | Own policies | Own policies | Own policies |
| Beneficiary | Limited view | No | No | Own claims | No |
| Assigned Agent | Assigned policies | With authorization | With authorization | Yes | Assigned policies |
| Home Office | All | All | All | All | All |
| Partner (Silver) | Per agreement | No | No | No | No |
| Partner (Gold) | Per agreement | Per agreement | No | No | Per agreement |

### 8.4 Mutual TLS for B2B Integration

```mermaid
sequenceDiagram
    participant Partner as Partner System
    participant GW as API Gateway
    participant CA as Certificate Authority

    Note over Partner,CA: Certificate Setup (One-time)
    Partner->>CA: Generate CSR
    CA-->>Partner: Signed Client Certificate
    CA-->>GW: Upload Partner CA Certificate

    Note over Partner,GW: Runtime mTLS
    Partner->>GW: TLS Handshake (Client Cert)
    GW->>GW: Verify Client Certificate<br/>against trusted CA
    GW->>GW: Extract CN/SAN<br/>Map to partner identity
    GW-->>Partner: TLS Established
    Partner->>GW: API Request + OAuth Token
    GW->>GW: Validate OAuth Token
    GW->>GW: Verify token client matches<br/>certificate identity
```

### 8.5 Rate Limiting and Throttling

| Tier | Rate Limit | Burst | Quota (Daily) | Throttle Strategy |
|------|-----------|-------|---------------|-------------------|
| Bronze | 100 req/min | 20 req/sec | 10,000 | Fixed window |
| Silver | 500 req/min | 50 req/sec | 100,000 | Sliding window |
| Gold | 2,000 req/min | 200 req/sec | 500,000 | Token bucket |
| Platinum | Custom | Custom | Custom | Adaptive |

Rate limit headers:

```
HTTP/1.1 200 OK
X-RateLimit-Limit: 500
X-RateLimit-Remaining: 347
X-RateLimit-Reset: 1704067260
X-RateLimit-Policy: sliding-window-60s
```

When exceeded:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 30
X-RateLimit-Limit: 500
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1704067260

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit of 500 requests per minute exceeded. Retry after 30 seconds."
  }
}
```

### 8.6 DDoS Protection

Layered defense strategy:

```mermaid
graph TB
    A[Incoming Traffic] --> B[CDN/Edge<br/>Cloudflare/AWS Shield]
    B --> C[WAF<br/>OWASP Rules]
    C --> D[API Gateway<br/>Rate Limiting]
    D --> E[Application Layer<br/>Circuit Breaker]
    E --> F[PAS Backend<br/>Services]

    B -.->|Block| X1[Volumetric DDoS]
    C -.->|Block| X2[Protocol Attacks<br/>SQL Injection]
    D -.->|Block| X3[Application Layer<br/>Abuse]
    E -.->|Block| X4[Cascading<br/>Failures]
```

---

## 9. API Versioning

### 9.1 Versioning Strategies

#### URL Path Versioning (Recommended for PAS)

```
GET /api/v1/policies/POL-12345678
GET /api/v2/policies/POL-12345678
```

**Advantages**: Explicit, easy to route, cache-friendly, simple for partners.
**Disadvantages**: URL pollution, client library duplication.

#### Header Versioning

```
GET /api/policies/POL-12345678
Accept: application/vnd.insurance.v2+json
```

#### Query Parameter Versioning

```
GET /api/policies/POL-12345678?api-version=2.0
```

### 9.2 Backward Compatibility Rules

**Non-Breaking Changes (No version bump required):**
- Adding new optional fields to responses
- Adding new optional query parameters
- Adding new endpoints
- Adding new enum values (if consumer handles unknown values)
- Adding new HTTP methods to existing resources
- Relaxing validation constraints

**Breaking Changes (Version bump required):**
- Removing or renaming fields
- Changing field types
- Adding required fields to requests
- Changing URI structure
- Changing authentication mechanisms
- Changing error response format
- Removing enum values
- Changing default values

### 9.3 Deprecation Policy

```mermaid
gantt
    title API Version Lifecycle
    dateFormat YYYY-MM
    axisFormat %Y-%m

    section v1
    Active           :done, v1a, 2024-01, 2025-06
    Deprecated       :active, v1d, 2025-06, 2026-06
    Sunset           :crit, v1s, 2026-06, 2026-07

    section v2
    Beta             :done, v2b, 2025-01, 2025-06
    Active           :active, v2a, 2025-06, 2027-06
    Deprecated       :v2d, 2027-06, 2028-06

    section v3
    Beta             :v3b, 2027-01, 2027-06
    Active           :v3a, 2027-06, 2029-06
```

#### Sunset Headers

```
HTTP/1.1 200 OK
Sunset: Sat, 01 Jul 2026 00:00:00 GMT
Deprecation: true
Link: </api/v2/policies/POL-12345678>; rel="successor-version"
```

### 9.4 Version Lifecycle Management

| Phase | Duration | Description | Support Level |
|-------|----------|-------------|---------------|
| **Alpha** | 1-3 months | Internal testing | No SLA |
| **Beta** | 3-6 months | Partner preview | Best effort |
| **GA (Active)** | 18-24 months minimum | Production | Full SLA |
| **Deprecated** | 12 months | Migration period | Bug fixes only |
| **Sunset** | — | Decommissioned | 410 Gone |

---

## 10. API Gateway Patterns

### 10.1 Gateway Architecture

```mermaid
graph TB
    subgraph "External"
        E1[Partner A]
        E2[Partner B]
        E3[Customer Portal]
        E4[Agent Portal]
    end

    subgraph "DMZ"
        WAF[Web Application Firewall]
        LB[Load Balancer]
    end

    subgraph "API Gateway Cluster"
        GW1[Gateway Instance 1]
        GW2[Gateway Instance 2]
        GW3[Gateway Instance 3]
    end

    subgraph "Gateway Functions"
        F1[Authentication<br/>JWT Validation]
        F2[Authorization<br/>Scope/Role Check]
        F3[Rate Limiting<br/>Quota Management]
        F4[Request Transformation<br/>Header Injection]
        F5[Response Transformation<br/>Field Filtering]
        F6[Protocol Mediation<br/>REST → SOAP]
        F7[Caching<br/>Response Cache]
        F8[Circuit Breaker<br/>Fault Tolerance]
        F9[Logging & Analytics<br/>Request/Response Capture]
        F10[Routing<br/>Version / Tenant]
    end

    subgraph "Backend Services"
        S1[Policy Service]
        S2[Claims Service]
        S3[Financial Service]
        S4[Document Service]
        S5[Legacy PAS<br/>SOAP / MQ]
    end

    E1 & E2 & E3 & E4 --> WAF --> LB
    LB --> GW1 & GW2 & GW3
    GW1 & GW2 & GW3 --> F1 --> F2 --> F3 --> F10
    F10 --> F4 --> S1 & S2 & S3 & S4
    F10 --> F6 --> S5
    F10 --> F7
    F10 --> F8
    F10 --> F9
```

### 10.2 Routing Strategies

```yaml
# Kong / API Gateway configuration example
routes:
  - name: policy-inquiry-v1
    paths: ["/api/v1/policies"]
    methods: ["GET"]
    service: policy-service-v1
    plugins:
      - name: jwt
      - name: rate-limiting
        config:
          minute: 500
      - name: response-transformer
        config:
          remove:
            headers: ["X-Internal-Trace"]

  - name: policy-inquiry-v2
    paths: ["/api/v2/policies"]
    methods: ["GET"]
    service: policy-service-v2
    plugins:
      - name: jwt
      - name: rate-limiting
        config:
          minute: 1000

  - name: legacy-policy-soap
    paths: ["/api/v1/legacy/policies"]
    service: legacy-pas-adapter
    plugins:
      - name: request-transformer
        config:
          replace:
            headers: ["Content-Type:text/xml"]
```

### 10.3 Protocol Mediation

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Adapter
    participant LegacyPAS

    Client->>Gateway: REST: GET /api/v1/policies/POL-123
    Gateway->>Adapter: Forward REST request
    Adapter->>Adapter: Transform to SOAP/XML<br/>TXLifeRequest TransType=228
    Adapter->>LegacyPAS: SOAP: TXLifeRequest
    LegacyPAS-->>Adapter: SOAP: TXLifeResponse
    Adapter->>Adapter: Transform XML to JSON
    Adapter-->>Gateway: JSON response
    Gateway-->>Client: REST: 200 OK (JSON)
```

### 10.4 Caching Strategy

| API Endpoint | Cache TTL | Cache Key | Invalidation |
|-------------|-----------|-----------|--------------|
| `GET /policies/{id}` | 5 minutes | `policy:{id}:{fields}` | On policy change event |
| `GET /policies/{id}/values` | 1 hour (non-market) | `values:{id}:{date}` | End of business day |
| `GET /reference/code-tables/*` | 24 hours | `codes:{table}` | On reference data update |
| `GET /producers/{code}` | 1 hour | `producer:{code}` | On producer update |
| `GET /policies/{id}/documents` | 10 minutes | `docs:{id}:{filter}` | On document upload |
| `POST /illustrations` | No cache | — | — |

### 10.5 Circuit Breaker

```mermaid
stateDiagram-v2
    [*] --> Closed
    Closed --> Open : Failure threshold<br/>exceeded (5 failures<br/>in 60 seconds)
    Open --> HalfOpen : Timeout period<br/>(30 seconds)
    HalfOpen --> Closed : Probe request<br/>succeeds
    HalfOpen --> Open : Probe request<br/>fails

    Closed : Normal operation<br/>All requests pass through
    Open : Requests fail fast<br/>Return 503 immediately
    HalfOpen : Limited probe requests<br/>Test if backend recovered
```

---

## 11. Developer Experience

### 11.1 API Documentation

#### Swagger UI Configuration

Provide interactive documentation with:

- **Try It Out**: Pre-configured sandbox credentials for immediate API testing.
- **Code Samples**: Auto-generated examples in Java, Python, JavaScript, C#.
- **Response Examples**: Realistic insurance data in every example.
- **Authentication Flows**: Built-in OAuth flow with sandbox credentials.

#### Documentation Structure

```
Developer Portal
├── Getting Started
│   ├── Authentication Guide
│   ├── Sandbox Setup
│   └── Quick Start Tutorial
├── API Reference
│   ├── Policy Inquiry API
│   ├── New Business API
│   ├── Policy Servicing API
│   ├── Payments API
│   ├── Claims API
│   ├── Documents API
│   ├── Illustrations API
│   └── Producer Services API
├── Guides
│   ├── Policy Lifecycle Guide
│   ├── Integration Patterns
│   ├── Error Handling Guide
│   ├── Webhook Integration
│   └── Migration from v1 to v2
├── SDKs & Libraries
│   ├── Java SDK
│   ├── Python SDK
│   ├── JavaScript/TypeScript SDK
│   └── .NET SDK
└── Support
    ├── FAQ
    ├── Status Page
    ├── Changelog
    └── Contact Support
```

### 11.2 Sandbox Environment

```mermaid
graph TB
    subgraph "Developer Sandbox"
        A[Sandbox Portal<br/>Self-Service Sign-Up]
        B[Mock PAS Engine<br/>Simulated Responses]
        C[Test Data Generator<br/>Realistic Policies]
        D[Event Simulator<br/>Webhook Testing]
    end

    subgraph "Test Policies Available"
        P1["POL-TEST-001<br/>Active UL Policy"]
        P2["POL-TEST-002<br/>Lapsed Whole Life"]
        P3["POL-TEST-003<br/>Annuity in Payout"]
        P4["POL-TEST-004<br/>Term Life (convertible)"]
        P5["POL-TEST-005<br/>VUL with multiple funds"]
    end

    A --> B
    A --> C --> P1 & P2 & P3 & P4 & P5
    A --> D
```

### 11.3 SDK Generation

Auto-generated SDKs from OpenAPI specifications:

```bash
# Java SDK generation
openapi-generator generate \
  -i openapi-policy-inquiry.yaml \
  -g java \
  -o sdk/java \
  --additional-properties=library=okhttp-gson,groupId=com.insurance,artifactId=pas-api-client

# Python SDK generation
openapi-generator generate \
  -i openapi-policy-inquiry.yaml \
  -g python \
  -o sdk/python \
  --additional-properties=packageName=pas_api_client

# TypeScript SDK generation
openapi-generator generate \
  -i openapi-policy-inquiry.yaml \
  -g typescript-axios \
  -o sdk/typescript
```

### 11.4 Contract Testing with Pact

```typescript
// Consumer test (Portal testing against Policy API)
describe('Policy Inquiry API', () => {
  const provider = new PactV3({
    consumer: 'AgentPortal',
    provider: 'PolicyInquiryService',
  });

  it('returns policy details for an active policy', () => {
    provider
      .given('policy POL-12345678 exists and is active')
      .uponReceiving('a request for policy details')
      .withRequest({
        method: 'GET',
        path: '/api/v1/policies/POL-12345678',
        headers: { Authorization: 'Bearer valid-token' },
      })
      .willRespondWith({
        status: 200,
        headers: { 'Content-Type': 'application/json' },
        body: {
          policyId: like('POL-12345678'),
          policyNumber: like('A1234567'),
          status: term({ generate: 'Active', matcher: '^(Active|PaidUp|Lapsed)$' }),
          totalFaceAmount: {
            amount: like(500000.00),
            currency: 'USD',
          },
        },
      });

    return provider.executeTest(async (mockService) => {
      const client = new PolicyApiClient(mockService.url);
      const policy = await client.getPolicy('POL-12345678');
      expect(policy.policyId).toBe('POL-12345678');
      expect(policy.status).toBe('Active');
    });
  });
});
```

### 11.5 Postman Collections

Provide pre-built Postman collections:

```json
{
  "info": {
    "name": "PAS API Collection",
    "_postman_id": "pas-api-collection",
    "description": "Complete PAS API collection with examples"
  },
  "auth": {
    "type": "oauth2",
    "oauth2": [
      { "key": "tokenUrl", "value": "{{auth_url}}/token" },
      { "key": "clientId", "value": "{{client_id}}" },
      { "key": "scope", "value": "policy:read policy:write" }
    ]
  },
  "item": [
    {
      "name": "Policy Inquiry",
      "item": [
        {
          "name": "Get Policy by ID",
          "request": {
            "method": "GET",
            "url": "{{base_url}}/api/v1/policies/{{policy_id}}"
          }
        },
        {
          "name": "Search Policies",
          "request": {
            "method": "POST",
            "url": "{{base_url}}/api/v1/policies/search",
            "body": {
              "mode": "raw",
              "raw": "{\"filter\":{\"status\":[\"Active\"],\"productCode\":\"UL-100\"}}"
            }
          }
        }
      ]
    }
  ]
}
```

---

## 12. Complete OpenAPI 3.0 Specifications

### 12.1 Master PAS API Specification

```yaml
openapi: 3.0.3
info:
  title: Life Insurance Policy Administration System API
  description: |
    Comprehensive API for life insurance and annuity policy administration,
    covering the full policy lifecycle from application through claim settlement.
  version: 2.0.0
  contact:
    name: API Support
    email: api-support@insurance.com
    url: https://developer.insurance.com/support
  license:
    name: Proprietary
    url: https://developer.insurance.com/terms

servers:
  - url: https://api.insurance.com/api/v2
    description: Production
  - url: https://api-sandbox.insurance.com/api/v2
    description: Sandbox
  - url: https://api-staging.insurance.com/api/v2
    description: Staging

tags:
  - name: Policy Inquiry
    description: Retrieve policy information, values, coverages
  - name: New Business
    description: Application submission, underwriting, issuance
  - name: Policy Servicing
    description: Policy changes, beneficiary updates, ownership changes
  - name: Payments
    description: Premium payments, payment methods, billing
  - name: Financial
    description: Withdrawals, loans, fund transfers, surrenders
  - name: Claims
    description: Claim submission, tracking, documentation
  - name: Documents
    description: Document upload, retrieval, management
  - name: Illustrations
    description: Policy illustration generation and retrieval
  - name: Producer Services
    description: Agent/producer information, commissions, book of business

security:
  - oauth2: []
  - bearerAuth: []

paths:
  # -- POLICY INQUIRY --
  /policies:
    get:
      operationId: listPolicies
      summary: List policies with filtering
      tags: [Policy Inquiry]
      parameters:
        - $ref: '#/components/parameters/LimitParam'
        - $ref: '#/components/parameters/CursorParam'
        - name: status
          in: query
          schema:
            type: string
        - name: productCode
          in: query
          schema:
            type: string
        - name: ownerPartyId
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Policy list
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/PolicySummary'
                  pagination:
                    $ref: '#/components/schemas/Pagination'

  /policies/{policyId}:
    get:
      operationId: getPolicy
      summary: Get policy details
      tags: [Policy Inquiry]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
        - name: include
          in: query
          schema:
            type: string
          description: "Comma-separated: coverages,parties,values,billing"
      responses:
        '200':
          description: Policy details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Policy'
              example:
                policyId: "POL-12345678"
                policyNumber: "A1234567"
                productCode: "UL-100"
                productName: "Universal Life 100"
                status: "Active"
                issueDate: "2020-03-15"
                effectiveDate: "2020-04-01"
                jurisdictionCode: "NY"
                totalFaceAmount:
                  amount: 500000.00
                  currency: "USD"
                owner:
                  partyId: "PTY-001"
                  fullName: "John A. Smith"
                insured:
                  partyId: "PTY-001"
                  fullName: "John A. Smith"
        '404':
          $ref: '#/components/responses/NotFound'

  /policies/{policyId}/values:
    get:
      operationId: getPolicyValues
      summary: Get policy financial values
      tags: [Policy Inquiry]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
        - name: asOfDate
          in: query
          schema:
            type: string
            format: date
      responses:
        '200':
          description: Policy values
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PolicyValues'
              example:
                policyId: "POL-12345678"
                asOfDate: "2026-01-15"
                accountValue:
                  amount: 125432.67
                  currency: "USD"
                cashSurrenderValue:
                  amount: 121987.42
                  currency: "USD"
                netCashSurrenderValue:
                  amount: 96987.42
                  currency: "USD"
                deathBenefit:
                  amount: 500000.00
                  currency: "USD"
                loanBalance:
                  amount: 25000.00
                  currency: "USD"
                fundValues:
                  - fundCode: "GROWTH-01"
                    fundName: "Growth Fund"
                    units: 1234.5678
                    unitValue:
                      amount: 50.75
                      currency: "USD"
                    totalValue:
                      amount: 62654.32
                      currency: "USD"
                    allocationPercentage: 50.0
                  - fundCode: "BOND-01"
                    fundName: "Bond Fund"
                    units: 2345.6789
                    unitValue:
                      amount: 26.75
                      currency: "USD"
                    totalValue:
                      amount: 62746.90
                      currency: "USD"
                    allocationPercentage: 50.0

  # -- NEW BUSINESS --
  /applications:
    post:
      operationId: submitApplication
      summary: Submit new insurance application
      tags: [New Business]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ApplicationSubmission'
      responses:
        '201':
          description: Application created
          headers:
            Location:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ApplicationResponse'
        '422':
          $ref: '#/components/responses/ValidationError'

  # -- PAYMENTS --
  /policies/{policyId}/payments:
    post:
      operationId: submitPayment
      summary: Submit premium payment
      tags: [Payments]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PaymentRequest'
      responses:
        '201':
          description: Payment accepted
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaymentResponse'

  # -- CLAIMS --
  /claims:
    post:
      operationId: submitClaim
      summary: Submit a new claim
      tags: [Claims]
      requestBody:
        required: true
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

  /claims/{claimId}:
    get:
      operationId: getClaim
      summary: Get claim details
      tags: [Claims]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Claim details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClaimResponse'

  # -- FINANCIAL --
  /policies/{policyId}/withdrawals:
    post:
      operationId: requestWithdrawal
      summary: Request partial withdrawal
      tags: [Financial]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WithdrawalRequest'
      responses:
        '201':
          description: Withdrawal accepted
        '422':
          $ref: '#/components/responses/ValidationError'

  /policies/{policyId}/loans:
    post:
      operationId: requestLoan
      summary: Request policy loan
      tags: [Financial]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LoanRequest'
      responses:
        '201':
          description: Loan request accepted

  /policies/{policyId}/fund-transfers:
    post:
      operationId: executeFundTransfer
      summary: Transfer between investment funds
      tags: [Financial]
      parameters:
        - $ref: '#/components/parameters/PolicyIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/FundTransferRequest'
      responses:
        '201':
          description: Fund transfer executed

components:
  securitySchemes:
    oauth2:
      type: oauth2
      flows:
        clientCredentials:
          tokenUrl: https://auth.insurance.com/token
          scopes:
            policy:read: Read policy information
            policy:write: Modify policy data
            claims:read: Read claim information
            claims:write: Submit and modify claims
            financial:read: Read financial data
            financial:write: Execute financial transactions
            documents:read: Access documents
            documents:write: Upload documents
        authorizationCode:
          authorizationUrl: https://auth.insurance.com/authorize
          tokenUrl: https://auth.insurance.com/token
          scopes:
            openid: OpenID Connect
            profile: User profile
            policy:read: Read policy information
            policy:write: Modify policy data
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  parameters:
    PolicyIdParam:
      name: policyId
      in: path
      required: true
      schema:
        type: string
      example: "POL-12345678"
    LimitParam:
      name: limit
      in: query
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 25
    CursorParam:
      name: cursor
      in: query
      schema:
        type: string

  responses:
    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
          example:
            error:
              code: "NOT_FOUND"
              message: "Policy POL-99999999 not found."
              traceId: "abc-123"
    ValidationError:
      description: Validation failed
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

  schemas:
    Policy:
      type: object
      properties:
        policyId:
          type: string
        policyNumber:
          type: string
        productCode:
          type: string
        productName:
          type: string
        status:
          $ref: '#/components/schemas/PolicyStatus'
        issueDate:
          type: string
          format: date
        effectiveDate:
          type: string
          format: date
        maturityDate:
          type: string
          format: date
        jurisdictionCode:
          type: string
        totalFaceAmount:
          $ref: '#/components/schemas/Money'
        owner:
          $ref: '#/components/schemas/PartyRef'
        insured:
          $ref: '#/components/schemas/PartyRef'
        coverages:
          type: array
          items:
            $ref: '#/components/schemas/Coverage'
        _links:
          type: object

    PolicySummary:
      type: object
      properties:
        policyId:
          type: string
        policyNumber:
          type: string
        productName:
          type: string
        status:
          type: string
        totalFaceAmount:
          $ref: '#/components/schemas/Money'
        ownerName:
          type: string
        insuredName:
          type: string

    PolicyValues:
      type: object
      properties:
        policyId:
          type: string
        asOfDate:
          type: string
          format: date
        accountValue:
          $ref: '#/components/schemas/Money'
        cashSurrenderValue:
          $ref: '#/components/schemas/Money'
        netCashSurrenderValue:
          $ref: '#/components/schemas/Money'
        deathBenefit:
          $ref: '#/components/schemas/Money'
        loanBalance:
          $ref: '#/components/schemas/Money'
        loanInterestDue:
          $ref: '#/components/schemas/Money'
        netAmountAtRisk:
          $ref: '#/components/schemas/Money'
        costBasis:
          $ref: '#/components/schemas/Money'
        fundValues:
          type: array
          items:
            $ref: '#/components/schemas/FundValue'

    Coverage:
      type: object
      properties:
        coverageId:
          type: string
        planCode:
          type: string
        planName:
          type: string
        coverageType:
          type: string
          enum: [Base, Rider, Supplemental]
        status:
          type: string
        faceAmount:
          $ref: '#/components/schemas/Money'
        effectiveDate:
          type: string
          format: date

    FundValue:
      type: object
      properties:
        fundCode:
          type: string
        fundName:
          type: string
        units:
          type: number
          format: double
        unitValue:
          $ref: '#/components/schemas/Money'
        totalValue:
          $ref: '#/components/schemas/Money'
        allocationPercentage:
          type: number

    Money:
      type: object
      properties:
        amount:
          type: number
          format: double
        currency:
          type: string
          default: "USD"

    PartyRef:
      type: object
      properties:
        partyId:
          type: string
        fullName:
          type: string

    PolicyStatus:
      type: string
      enum:
        - Applied
        - Issued
        - Active
        - PaidUp
        - ExtendedTerm
        - ReducedPaidUp
        - Lapsed
        - Surrendered
        - Matured
        - Deceased
        - Terminated

    Pagination:
      type: object
      properties:
        limit:
          type: integer
        hasMore:
          type: boolean
        nextCursor:
          type: string
        previousCursor:
          type: string

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            target:
              type: string
            details:
              type: array
              items:
                type: object
            traceId:
              type: string
            timestamp:
              type: string
              format: date-time
```

---

## 13. Sample Request/Response Payloads

### 13.1 Policy Inquiry — Get Policy Details

**Request:**
```http
GET /api/v2/policies/POL-12345678?include=coverages,values HTTP/1.1
Host: api.insurance.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Accept: application/json
```

**Response (200 OK):**
```json
{
  "policyId": "POL-12345678",
  "policyNumber": "A1234567",
  "productCode": "UL-100",
  "productName": "Universal Life 100",
  "status": "Active",
  "issueDate": "2020-03-15",
  "effectiveDate": "2020-04-01",
  "maturityDate": "2070-04-01",
  "jurisdictionCode": "NY",
  "totalFaceAmount": {
    "amount": 500000.00,
    "currency": "USD"
  },
  "owner": {
    "partyId": "PTY-001",
    "fullName": "John A. Smith"
  },
  "insured": {
    "partyId": "PTY-001",
    "fullName": "John A. Smith"
  },
  "coverages": [
    {
      "coverageId": "COV-001",
      "planCode": "UL-BASE",
      "planName": "Universal Life Base Coverage",
      "coverageType": "Base",
      "status": "Active",
      "faceAmount": { "amount": 500000.00, "currency": "USD" },
      "effectiveDate": "2020-04-01"
    },
    {
      "coverageId": "COV-002",
      "planCode": "WOP-01",
      "planName": "Waiver of Premium",
      "coverageType": "Rider",
      "status": "Active",
      "faceAmount": { "amount": 500000.00, "currency": "USD" },
      "effectiveDate": "2020-04-01"
    }
  ],
  "values": {
    "asOfDate": "2026-01-15",
    "accountValue": { "amount": 125432.67, "currency": "USD" },
    "cashSurrenderValue": { "amount": 121987.42, "currency": "USD" },
    "netCashSurrenderValue": { "amount": 96987.42, "currency": "USD" },
    "deathBenefit": { "amount": 500000.00, "currency": "USD" },
    "loanBalance": { "amount": 25000.00, "currency": "USD" },
    "loanInterestDue": { "amount": 1250.00, "currency": "USD" }
  },
  "_links": {
    "self": { "href": "/api/v2/policies/POL-12345678" },
    "coverages": { "href": "/api/v2/policies/POL-12345678/coverages" },
    "values": { "href": "/api/v2/policies/POL-12345678/values" },
    "billing": { "href": "/api/v2/policies/POL-12345678/billing" },
    "transactions": { "href": "/api/v2/policies/POL-12345678/transactions" },
    "documents": { "href": "/api/v2/policies/POL-12345678/documents" }
  }
}
```

### 13.2 New Business — Submit Application

**Request:**
```http
POST /api/v2/applications HTTP/1.1
Host: api.insurance.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json
Idempotency-Key: app-submit-20260115-001
```

```json
{
  "productCode": "UL-100",
  "applicationDate": "2026-01-15",
  "requestedEffectiveDate": "2026-02-01",
  "jurisdictionCode": "CA",
  "applicant": {
    "firstName": "Jane",
    "middleName": "Marie",
    "lastName": "Doe",
    "dateOfBirth": "1985-07-20",
    "gender": "Female",
    "taxId": "***-**-6789",
    "citizenship": "US",
    "addresses": [
      {
        "type": "Home",
        "line1": "123 Main Street",
        "line2": "Apt 4B",
        "city": "Los Angeles",
        "stateCode": "CA",
        "postalCode": "90001",
        "countryCode": "US"
      }
    ],
    "communications": [
      { "type": "Email", "value": "jane.doe@email.com", "preferred": true },
      { "type": "MobilePhone", "value": "+1-310-555-0123" }
    ]
  },
  "insured": {
    "sameAsApplicant": true
  },
  "coverages": [
    {
      "planCode": "UL-BASE",
      "faceAmount": { "amount": 750000.00, "currency": "USD" },
      "premiumMode": "Monthly",
      "riskClassRequested": "PreferredPlus"
    },
    {
      "planCode": "WOP-01",
      "faceAmount": { "amount": 750000.00, "currency": "USD" }
    }
  ],
  "beneficiaries": [
    {
      "designationType": "Primary",
      "beneficiaryType": "Individual",
      "firstName": "Robert",
      "lastName": "Doe",
      "relationship": "Spouse",
      "percentage": 100.0,
      "irrevocable": false
    }
  ],
  "paymentInfo": {
    "initialPremium": { "amount": 450.00, "currency": "USD" },
    "paymentMethod": {
      "type": "ACH",
      "achDetails": {
        "routingNumber": "021000021",
        "accountNumber": "****5678",
        "accountType": "Checking"
      }
    }
  },
  "producerCode": "AGT-001234",
  "replacementInfo": {
    "isReplacement": false
  }
}
```

**Response (201 Created):**
```json
{
  "applicationId": "APP-20260115-001",
  "status": "Submitted",
  "policyNumber": null,
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-01-15T10:30:00Z",
  "_links": {
    "self": { "href": "/api/v2/applications/APP-20260115-001" },
    "submit-for-underwriting": {
      "href": "/api/v2/applications/APP-20260115-001/actions/submit-for-underwriting",
      "method": "POST"
    }
  }
}
```

### 13.3 Premium Payment

**Request:**
```http
POST /api/v2/policies/POL-12345678/payments HTTP/1.1
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json
Idempotency-Key: pay-20260115-001
```

```json
{
  "amount": { "amount": 450.00, "currency": "USD" },
  "paymentType": "ScheduledPremium",
  "paymentMethod": {
    "type": "ACH",
    "achDetails": {
      "routingNumber": "021000021",
      "accountNumber": "****5678",
      "accountType": "Checking"
    }
  },
  "effectiveDate": "2026-02-01"
}
```

**Response (201 Created):**
```json
{
  "paymentId": "PAY-20260115-001",
  "status": "Processing",
  "confirmationNumber": "CNF-8A2B3C4D",
  "amount": { "amount": 450.00, "currency": "USD" },
  "effectiveDate": "2026-02-01",
  "estimatedPostingDate": "2026-02-03",
  "allocations": [
    { "fundCode": "GROWTH-01", "amount": { "amount": 225.00, "currency": "USD" } },
    { "fundCode": "BOND-01", "amount": { "amount": 225.00, "currency": "USD" } }
  ]
}
```

### 13.4 Fund Transfer

**Request:**
```json
{
  "transferType": "Transfer",
  "effectiveDate": "2026-01-15",
  "transfers": [
    {
      "fromFund": "GROWTH-01",
      "toFund": "BOND-01",
      "amount": { "amount": 10000.00, "currency": "USD" }
    }
  ]
}
```

**Response (201 Created):**
```json
{
  "transferId": "XFR-20260115-001",
  "status": "Completed",
  "effectiveDate": "2026-01-15",
  "transfers": [
    {
      "fromFund": "GROWTH-01",
      "toFund": "BOND-01",
      "unitsRedeemed": 197.0443,
      "unitsPurchased": 373.8318,
      "amount": { "amount": 10000.00, "currency": "USD" }
    }
  ],
  "postTransferValues": {
    "fundValues": [
      { "fundCode": "GROWTH-01", "totalValue": { "amount": 52654.32, "currency": "USD" } },
      { "fundCode": "BOND-01", "totalValue": { "amount": 72746.90, "currency": "USD" } }
    ]
  }
}
```

### 13.5 Partial Withdrawal

**Request:**
```json
{
  "amount": { "amount": 15000.00, "currency": "USD" },
  "withdrawalType": "Partial",
  "taxWithholding": {
    "federalWithholdingPercent": 10.0,
    "stateWithholdingPercent": 5.0
  },
  "disbursement": {
    "method": "ACH",
    "payee": "Jane Doe",
    "achDetails": {
      "routingNumber": "021000021",
      "accountNumber": "****5678"
    }
  },
  "fundSources": [
    { "fundCode": "GROWTH-01", "amount": { "amount": 15000.00, "currency": "USD" } }
  ]
}
```

**Response (201 Created):**
```json
{
  "withdrawalId": "WDR-20260115-001",
  "status": "Processing",
  "grossAmount": { "amount": 15000.00, "currency": "USD" },
  "federalWithholding": { "amount": 1500.00, "currency": "USD" },
  "stateWithholding": { "amount": 750.00, "currency": "USD" },
  "netDisbursement": { "amount": 12750.00, "currency": "USD" },
  "taxableAmount": { "amount": 8200.00, "currency": "USD" },
  "estimatedDisbursementDate": "2026-01-20"
}
```

### 13.6 Policy Loan Request

**Request:**
```json
{
  "amount": { "amount": 30000.00, "currency": "USD" },
  "loanType": "Standard",
  "disbursement": {
    "method": "Check",
    "payee": "John A. Smith"
  }
}
```

**Response (201 Created):**
```json
{
  "loanId": "LN-20260115-001",
  "status": "Approved",
  "loanAmount": { "amount": 30000.00, "currency": "USD" },
  "loanType": "Standard",
  "interestRate": 5.75,
  "interestRateType": "Variable",
  "maximumLoanableValue": { "amount": 95000.00, "currency": "USD" },
  "estimatedDisbursementDate": "2026-01-22"
}
```

### 13.7 Claim Submission

**Request:**
```json
{
  "policyId": "POL-12345678",
  "claimType": "Death",
  "dateOfEvent": "2026-01-10",
  "causeOfEvent": "Natural Causes",
  "claimant": {
    "firstName": "Robert",
    "lastName": "Doe",
    "relationship": "Spouse",
    "contactPhone": "+1-310-555-0456",
    "contactEmail": "robert.doe@email.com"
  },
  "notificationDate": "2026-01-14",
  "description": "Insured passed away at home on January 10, 2026."
}
```

**Response (201 Created):**
```json
{
  "claimId": "CLM-20260115-001",
  "claimNumber": "C-2026-00001",
  "status": "Submitted",
  "policyId": "POL-12345678",
  "claimType": "Death",
  "dateOfEvent": "2026-01-10",
  "estimatedPayoutAmount": { "amount": 500000.00, "currency": "USD" },
  "requiredDocuments": [
    { "type": "DeathCertificate", "status": "Required" },
    { "type": "BeneficiaryIdentification", "status": "Required" },
    { "type": "ClaimForm", "status": "Required" }
  ],
  "assignedExaminer": "EXM-Johnson",
  "createdAt": "2026-01-15T11:00:00Z",
  "_links": {
    "self": { "href": "/api/v2/claims/CLM-20260115-001" },
    "upload-document": {
      "href": "/api/v2/claims/CLM-20260115-001/documents",
      "method": "POST"
    }
  }
}
```

### 13.8 Beneficiary Change

**Request:**
```json
{
  "changeType": "BeneficiaryChange",
  "effectiveDate": "2026-02-01",
  "reason": "Divorce — removing ex-spouse as beneficiary",
  "details": {
    "beneficiaries": [
      {
        "designationType": "Primary",
        "firstName": "Sarah",
        "lastName": "Smith",
        "relationship": "Child",
        "percentage": 60.0,
        "irrevocable": false
      },
      {
        "designationType": "Primary",
        "firstName": "Michael",
        "lastName": "Smith",
        "relationship": "Child",
        "percentage": 40.0,
        "irrevocable": false
      },
      {
        "designationType": "Contingent",
        "firstName": "Anna",
        "lastName": "Smith",
        "relationship": "Mother",
        "percentage": 100.0,
        "irrevocable": false
      }
    ]
  }
}
```

**Response (201 Created):**
```json
{
  "changeRequestId": "CHG-20260115-001",
  "status": "Pending",
  "changeType": "BeneficiaryChange",
  "policyId": "POL-12345678",
  "effectiveDate": "2026-02-01",
  "requiresSignature": true,
  "requiresApproval": false,
  "createdAt": "2026-01-15T12:00:00Z"
}
```

### 13.9 Illustration Generation

**Request:**
```json
{
  "productCode": "IUL-200",
  "insuredAge": 40,
  "insuredGender": "Male",
  "insuredRiskClass": "Preferred",
  "faceAmount": { "amount": 1000000.00, "currency": "USD" },
  "plannedPremium": { "amount": 12000.00, "currency": "USD" },
  "premiumMode": "Annual",
  "premiumPayingPeriod": 20,
  "riders": [
    { "riderCode": "ADB-01", "coverageAmount": { "amount": 1000000.00, "currency": "USD" } }
  ],
  "illustrationScenarios": [
    { "scenarioName": "Guaranteed", "interestRate": 0.0 },
    { "scenarioName": "Mid-Point", "interestRate": 5.5 },
    { "scenarioName": "Current", "interestRate": 7.25 }
  ]
}
```

**Response (202 Accepted):**
```json
{
  "illustrationId": "ILL-20260115-001",
  "status": "Generating",
  "estimatedCompletionTime": "2026-01-15T10:30:30Z",
  "_links": {
    "self": { "href": "/api/v2/illustrations/ILL-20260115-001" },
    "pdf": { "href": "/api/v2/illustrations/ILL-20260115-001/pdf" }
  }
}
```

### 13.10 Search Policies (Complex Query)

**Request:**
```json
{
  "filter": {
    "and": [
      { "field": "status", "operator": "in", "value": ["Active", "PaidUp"] },
      { "field": "totalFaceAmount.amount", "operator": "gte", "value": 250000 },
      { "field": "issueDate", "operator": "between", "value": ["2020-01-01", "2025-12-31"] },
      { "field": "jurisdictionCode", "operator": "in", "value": ["NY", "CA", "TX"] },
      { "field": "productCode", "operator": "eq", "value": "UL-100" }
    ]
  },
  "sort": ["-totalFaceAmount.amount", "issueDate"],
  "fields": ["policyNumber", "status", "totalFaceAmount", "ownerName", "issueDate"],
  "pagination": {
    "limit": 25,
    "cursor": null
  }
}
```

### 13.11 Agent Book of Business

**Response:**
```json
{
  "producerCode": "AGT-001234",
  "summary": {
    "totalPolicies": 342,
    "totalFaceAmount": { "amount": 125000000.00, "currency": "USD" },
    "activePolicies": 298,
    "lapsedPolicies": 12,
    "ytdCommissions": { "amount": 87500.00, "currency": "USD" }
  },
  "data": [
    {
      "policyId": "POL-12345678",
      "policyNumber": "A1234567",
      "productName": "Universal Life 100",
      "status": "Active",
      "ownerName": "John A. Smith",
      "insuredName": "John A. Smith",
      "totalFaceAmount": { "amount": 500000.00, "currency": "USD" },
      "issueDate": "2020-03-15",
      "nextPremiumDueDate": "2026-02-01",
      "annualizedPremium": { "amount": 5400.00, "currency": "USD" }
    }
  ],
  "pagination": {
    "limit": 50,
    "hasMore": true,
    "nextCursor": "eyJwb2xpY3lJZCI6IlBPTC0wMDM1MCJ9"
  }
}
```

### 13.12 Commission Statement

**Response:**
```json
{
  "producerCode": "AGT-001234",
  "statementPeriod": {
    "from": "2026-01-01",
    "to": "2026-01-31"
  },
  "commissions": [
    {
      "commissionId": "COM-001",
      "policyNumber": "A1234567",
      "transactionType": "Renewal",
      "premiumAmount": { "amount": 450.00, "currency": "USD" },
      "commissionRate": 0.05,
      "commissionAmount": { "amount": 22.50, "currency": "USD" },
      "processedDate": "2026-01-05"
    },
    {
      "commissionId": "COM-002",
      "policyNumber": "B9876543",
      "transactionType": "FirstYear",
      "premiumAmount": { "amount": 12000.00, "currency": "USD" },
      "commissionRate": 0.55,
      "commissionAmount": { "amount": 6600.00, "currency": "USD" },
      "processedDate": "2026-01-15"
    }
  ],
  "totals": {
    "totalCommissions": { "amount": 6622.50, "currency": "USD" },
    "chargebacks": { "amount": 0.00, "currency": "USD" },
    "netPayable": { "amount": 6622.50, "currency": "USD" }
  }
}
```

### 13.13 Error Response — Validation Failure

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Application submission contains validation errors.",
    "details": [
      {
        "code": "REQUIRED_FIELD",
        "message": "Applicant date of birth is required.",
        "target": "applicant.dateOfBirth",
        "severity": "Error"
      },
      {
        "code": "INVALID_VALUE",
        "message": "Face amount must be at least $50,000 for product UL-100.",
        "target": "coverages[0].faceAmount",
        "severity": "Error"
      },
      {
        "code": "BENEFICIARY_PERCENTAGE",
        "message": "Primary beneficiary percentages must total 100%. Current total: 80%.",
        "target": "beneficiaries",
        "severity": "Error"
      }
    ],
    "traceId": "req-abc123-def456",
    "timestamp": "2026-01-15T10:30:00Z"
  }
}
```

### 13.14 Error Response — Business Rule Violation

```json
{
  "error": {
    "code": "BUSINESS_RULE_VIOLATION",
    "message": "Withdrawal request violates policy constraints.",
    "details": [
      {
        "code": "EXCEEDS_MAXIMUM",
        "message": "Requested withdrawal of $15,000.00 exceeds maximum available withdrawal of $12,500.00 (net of surrender charges and minimum required balance).",
        "target": "amount",
        "context": {
          "requestedAmount": 15000.00,
          "maximumAvailable": 12500.00,
          "surrenderCharge": 3500.00,
          "minimumBalance": 1000.00
        }
      }
    ],
    "traceId": "req-xyz789",
    "timestamp": "2026-01-15T11:00:00Z"
  }
}
```

### 13.15 Webhook Event — Policy Issued

```json
{
  "eventId": "evt-20260201-001",
  "eventType": "policy.issued",
  "schemaVersion": "2.0",
  "timestamp": "2026-02-01T00:15:00Z",
  "source": "new-business-service",
  "correlationId": "app-20260115-001",
  "data": {
    "policyId": "POL-20260201-001",
    "policyNumber": "B2468101",
    "productCode": "UL-100",
    "productName": "Universal Life 100",
    "issueDate": "2026-02-01",
    "effectiveDate": "2026-02-01",
    "totalFaceAmount": {
      "amount": 750000.00,
      "currency": "USD"
    },
    "ownerPartyId": "PTY-JaneDoe",
    "ownerName": "Jane Marie Doe",
    "insuredPartyId": "PTY-JaneDoe",
    "jurisdictionCode": "CA",
    "producerCode": "AGT-001234",
    "applicationId": "APP-20260115-001"
  }
}
```

---

## 14. Architecture Reference

### 14.1 API Management Platform Architecture

```mermaid
graph TB
    subgraph "Consumers"
        C1[External Partners]
        C2[Internal Apps]
        C3[Mobile Apps]
    end

    subgraph "Edge Layer"
        CDN[CDN / Edge Cache]
        WAF[WAF]
        LB[Global Load Balancer]
    end

    subgraph "API Management Platform"
        DP[Developer Portal<br/>Documentation / Onboarding]
        AM[API Manager<br/>Lifecycle / Analytics]
        GW[API Gateway Cluster<br/>Routing / Security / Rate Limiting]
        AN[API Analytics<br/>Usage / Performance / Errors]
    end

    subgraph "Service Mesh"
        SM[Service Mesh<br/>Istio / Linkerd]
        SD[Service Discovery]
        MT[Mutual TLS]
        CB[Circuit Breaker]
        TR[Distributed Tracing]
    end

    subgraph "Microservices"
        MS1[Policy Service]
        MS2[Party Service]
        MS3[Financial Service]
        MS4[Claims Service]
        MS5[Document Service]
        MS6[Illustration Service]
        MS7[Billing Service]
        MS8[Notification Service]
    end

    subgraph "Data Layer"
        DB1[(Policy DB)]
        DB2[(Party DB)]
        DB3[(Financial DB)]
        DB4[(Document Store)]
        CACHE[(Redis Cache)]
        KAFKA[Kafka Event Bus]
    end

    C1 & C2 & C3 --> CDN --> WAF --> LB --> GW
    DP --> AM --> GW
    GW --> AN
    GW --> SM
    SM --> SD
    SM --> MT & CB & TR
    SM --> MS1 & MS2 & MS3 & MS4 & MS5 & MS6 & MS7 & MS8
    MS1 --> DB1
    MS2 --> DB2
    MS3 --> DB3
    MS5 --> DB4
    MS1 & MS3 & MS4 --> CACHE
    MS1 & MS2 & MS3 & MS4 & MS7 & MS8 --> KAFKA
```

### 14.2 Backend-for-Frontend (BFF) Pattern

```mermaid
graph TB
    subgraph "Frontend Applications"
        F1[Agent Portal<br/>React SPA]
        F2[Customer Portal<br/>React SPA]
        F3[Mobile App<br/>React Native]
        F4[Admin Console<br/>Angular]
    end

    subgraph "BFF Layer"
        BFF1[Agent BFF<br/>Optimized for agent workflows]
        BFF2[Customer BFF<br/>Optimized for self-service]
        BFF3[Mobile BFF<br/>Optimized for bandwidth]
        BFF4[Admin BFF<br/>Optimized for back-office]
    end

    subgraph "Core APIs"
        API1[Policy API]
        API2[Party API]
        API3[Financial API]
        API4[Claims API]
    end

    F1 --> BFF1
    F2 --> BFF2
    F3 --> BFF3
    F4 --> BFF4
    BFF1 & BFF2 & BFF3 & BFF4 --> API1 & API2 & API3 & API4
```

BFF responsibilities:
- **Aggregation**: Combine multiple API calls into a single response.
- **Transformation**: Shape data for the specific UI's needs.
- **Authentication**: Handle frontend-specific auth flows (cookie vs token).
- **Caching**: Frontend-specific caching strategies.
- **Bandwidth optimization**: Strip unnecessary fields for mobile.

### 14.3 Service Mesh for Inter-Service Communication

```mermaid
graph LR
    subgraph "Policy Service Pod"
        PS[Policy Service]
        PSP[Envoy Sidecar Proxy]
    end

    subgraph "Financial Service Pod"
        FS[Financial Service]
        FSP[Envoy Sidecar Proxy]
    end

    subgraph "Control Plane"
        CP[Istiod<br/>Control Plane]
    end

    PS --> PSP
    PSP -->|mTLS| FSP
    FSP --> FS
    CP --> PSP & FSP
```

---

## 15. Performance & Scalability

### 15.1 Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Policy inquiry p50 latency | < 50ms | API gateway to response |
| Policy inquiry p99 latency | < 200ms | API gateway to response |
| New business submission p99 | < 2s | End-to-end |
| Illustration generation p99 | < 30s | Async with polling |
| API availability | 99.95% | Monthly uptime |
| Throughput (peak) | 5,000 req/sec | Across all endpoints |
| Error rate | < 0.1% | 5xx errors |

### 15.2 Scalability Patterns

- **Horizontal Scaling**: Stateless API services behind load balancer.
- **Database Read Replicas**: CQRS pattern—reads served from replicas.
- **Response Caching**: Redis for frequently accessed policy data.
- **Async Processing**: Long-running operations (illustrations, batch changes) processed asynchronously.
- **Connection Pooling**: Database and HTTP connection pools sized for peak load.
- **Bulk APIs**: Dedicated bulk endpoints to reduce per-request overhead for batch operations.

### 15.3 Monitoring and Observability

```mermaid
graph TB
    subgraph "API Observability Stack"
        A[API Requests] --> B[Distributed Tracing<br/>Jaeger / Zipkin]
        A --> C[Metrics<br/>Prometheus / Datadog]
        A --> D[Logging<br/>ELK / Splunk]
        A --> E[API Analytics<br/>Usage Dashboard]

        B --> F[Trace Viewer<br/>End-to-end latency]
        C --> G[Grafana Dashboard<br/>SLA monitoring]
        D --> H[Log Search<br/>Error investigation]
        E --> I[API Product Dashboard<br/>Business metrics]
    end
```

Key metrics to monitor:
- Request rate by endpoint, partner, and status code.
- Latency percentiles (p50, p90, p95, p99).
- Error rate by type (4xx client errors, 5xx server errors).
- Rate limit utilization per partner.
- Authentication failure rate.
- Backend service health.
- Cache hit ratio.

---

## 16. Governance & Lifecycle

### 16.1 API Governance Framework

| Governance Area | Policy | Enforcement |
|----------------|--------|-------------|
| **Naming Conventions** | kebab-case URIs, camelCase JSON | Automated linting (Spectral) |
| **Security Standards** | OAuth 2.0 required, JWT validation | Gateway enforcement |
| **Versioning** | URL path versioning (v1, v2) | Design review |
| **Documentation** | OpenAPI 3.0 spec required | CI pipeline check |
| **Testing** | Contract tests required | CI pipeline |
| **Performance** | SLA per endpoint tier | Monitoring alerts |
| **Deprecation** | 12-month notice minimum | Sunset headers |
| **Change Management** | Breaking changes require new version | Design review board |
| **Data Privacy** | PII masking in logs | Automated scanning |
| **Compliance** | ACORD alignment for external APIs | Periodic audit |

### 16.2 API Design Linting

```yaml
# .spectral.yml — API Design Rules
extends: spectral:oas
rules:
  operation-operationId:
    severity: error
    message: "Every operation must have an operationId"
  path-must-use-kebab-case:
    severity: error
    given: "$.paths[*]~"
    then:
      function: pattern
      functionOptions:
        match: "^(/[a-z0-9-{}]+)+$"
  response-must-have-error-schema:
    severity: warn
    description: "4xx/5xx responses must use the standard error schema"
  must-have-pagination:
    severity: warn
    description: "Collection endpoints must support pagination"
  must-have-security:
    severity: error
    description: "All endpoints must declare security requirements"
```

### 16.3 API Lifecycle Summary

```mermaid
stateDiagram-v2
    [*] --> Design
    Design --> Review
    Review --> Approved
    Review --> Design : Revision needed
    Approved --> Development
    Development --> Testing
    Testing --> Beta
    Beta --> GA
    GA --> Deprecated
    Deprecated --> Sunset
    Sunset --> [*]

    Design : OpenAPI spec authoring
    Review : Design board review
    Development : Implementation + unit tests
    Testing : Contract tests + integration
    Beta : Partner preview
    GA : Full production + SLA
    Deprecated : Migration support
    Sunset : 410 Gone
```

---

## Summary

This article has provided a comprehensive treatment of API architecture for Life Insurance Policy Administration Systems. Key takeaways for solution architects:

1. **API-First**: Design APIs before implementation; treat them as products with dedicated ownership.
2. **REST for Breadth, GraphQL for Depth**: Use REST APIs for partner and external integrations; consider GraphQL for internal BFF patterns.
3. **Event-Driven APIs**: Complement synchronous APIs with event-driven patterns for real-time notifications.
4. **Security in Depth**: Layer OAuth 2.0, mTLS, rate limiting, and ABAC for comprehensive API security.
5. **Developer Experience**: Invest in documentation, sandboxes, SDKs, and contract testing.
6. **Governance**: Enforce standards through automated linting, design reviews, and lifecycle management.
7. **ACORD Alignment**: Map to industry-standard ACORD models for interoperability.
8. **Performance**: Design for sub-200ms policy inquiry with caching, async processing, and horizontal scaling.

The API layer is the keystone of a modern PAS—get it right, and the entire ecosystem benefits from composability, agility, and scale.
