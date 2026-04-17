# API Design & Microservices Architecture for Claims

## Table of Contents

1. [API-First Design Philosophy](#1-api-first-design-philosophy)
2. [RESTful API Design for Claims](#2-restful-api-design-for-claims)
3. [Complete Claims API Specification](#3-complete-claims-api-specification)
4. [GraphQL for Claims](#4-graphql-for-claims)
5. [gRPC for Internal Communication](#5-grpc-for-internal-communication)
6. [Event-Driven APIs](#6-event-driven-apis)
7. [API Versioning Strategies](#7-api-versioning-strategies)
8. [API Security](#8-api-security)
9. [API Gateway Patterns](#9-api-gateway-patterns)
10. [Microservices Deep Dive](#10-microservices-deep-dive)
11. [Service Mesh](#11-service-mesh)
12. [Container Orchestration](#12-container-orchestration)
13. [Testing Microservices](#13-testing-microservices)
14. [API Documentation and Developer Portal](#14-api-documentation-and-developer-portal)
15. [Sample OpenAPI Specifications](#15-sample-openapi-specifications)
16. [Sample Event Schemas](#16-sample-event-schemas)
17. [Sample Protobuf Definitions](#17-sample-protobuf-definitions)
18. [Deployment Architecture](#18-deployment-architecture)

---

## 1. API-First Design Philosophy

### 1.1 Principles

```
API-FIRST DESIGN FOR CLAIMS PLATFORMS:
+====================================================================+
|                                                                    |
|  CORE PRINCIPLES:                                                  |
|                                                                    |
|  1. DESIGN THE API BEFORE WRITING CODE                             |
|     ├── OpenAPI spec is the first deliverable                      |
|     ├── API review by consumers before implementation              |
|     ├── Mock server from spec enables parallel development         |
|     └── Contract-driven development                                |
|                                                                    |
|  2. APIS ARE PRODUCTS                                              |
|     ├── Treat internal APIs with same care as external             |
|     ├── Version, document, monitor, and support APIs               |
|     ├── Consumer feedback drives API evolution                     |
|     └── API catalog as the system of record for capabilities       |
|                                                                    |
|  3. CONSISTENCY ACROSS ALL APIS                                    |
|     ├── Uniform naming conventions                                 |
|     ├── Standard error response format                             |
|     ├── Common pagination, filtering, sorting patterns             |
|     ├── Shared security model                                      |
|     └── API style guide enforced via linting                       |
|                                                                    |
|  4. CONSUMER-DRIVEN                                                |
|     ├── Design for consumer use cases, not internal structure      |
|     ├── BFF (Backend for Frontend) pattern for channel-specific    |
|     ├── GraphQL for flexible querying needs                        |
|     └── Webhooks for partner integration                           |
|                                                                    |
|  5. EVOLVABLE                                                      |
|     ├── Additive changes preferred (backward compatible)           |
|     ├── Versioning strategy established upfront                    |
|     ├── Deprecation policy with sunset headers                     |
|     └── Consumer-driven contract testing                           |
|                                                                    |
+====================================================================+
```

### 1.2 API Design Workflow

```
API DESIGN LIFECYCLE:
+------------------------------------------------------------------+
|                                                                  |
|  1. IDENTIFY CAPABILITY                                          |
|     └── What business capability does this API expose?           |
|                                                                  |
|  2. DEFINE RESOURCES AND OPERATIONS                              |
|     └── Map domain entities to REST resources                    |
|                                                                  |
|  3. WRITE OPENAPI SPECIFICATION                                  |
|     └── Full spec with schemas, examples, errors                 |
|                                                                  |
|  4. API DESIGN REVIEW                                            |
|     └── Review with API consumers and architecture team          |
|                                                                  |
|  5. GENERATE MOCK SERVER                                         |
|     └── Consumers can develop against mock                       |
|                                                                  |
|  6. IMPLEMENT                                                    |
|     └── Build service conforming to spec                         |
|                                                                  |
|  7. CONTRACT TEST                                                |
|     └── Verify implementation matches spec                       |
|                                                                  |
|  8. PUBLISH TO API CATALOG                                       |
|     └── Register in developer portal                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 2. RESTful API Design for Claims

### 2.1 Resource Naming and URL Structure

```
CLAIMS API URL STRUCTURE:
+====================================================================+
|                                                                    |
|  BASE URL: https://api.insurer.com/claims/v1                      |
|                                                                    |
|  RESOURCE HIERARCHY:                                               |
|  /claims                           # Claims collection             |
|  /claims/{claimId}                 # Single claim                  |
|  /claims/{claimId}/exposures       # Exposures on a claim          |
|  /claims/{claimId}/reserves        # Reserves on a claim           |
|  /claims/{claimId}/payments        # Payments on a claim           |
|  /claims/{claimId}/documents       # Documents on a claim          |
|  /claims/{claimId}/activities      # Activities/notes on a claim   |
|  /claims/{claimId}/parties         # Parties involved in claim     |
|  /claims/{claimId}/assignments     # Adjuster assignments          |
|  /claims/{claimId}/subrogation     # Subrogation details           |
|  /claims/{claimId}/litigation      # Litigation details            |
|                                                                    |
|  NAMING CONVENTIONS:                                               |
|  ├── Use plural nouns for collections: /claims, /payments          |
|  ├── Use kebab-case for multi-word: /loss-types, /body-parts      |
|  ├── No verbs in URLs (HTTP methods convey action)                 |
|  ├── Resource IDs are UUIDs: /claims/550e8400-e29b-...             |
|  ├── Nested resources for strong ownership: /claims/{id}/payments  |
|  └── Maximum 3 levels of nesting                                   |
|                                                                    |
|  SPECIAL ENDPOINTS:                                                |
|  /claims/search              # Advanced search (POST for complex)  |
|  /claims/{id}/close          # Action endpoint (verb acceptable)   |
|  /claims/{id}/reopen         # Action endpoint                     |
|  /claims/{id}/assign         # Action endpoint                     |
|  /fnol                       # FNOL submission (separate resource) |
|                                                                    |
+====================================================================+
```

### 2.2 HTTP Methods

```
HTTP METHOD SEMANTICS FOR CLAIMS:
+------------------------------------------------------------------+
| Method  | Operation       | Example                    | Response|
+------------------------------------------------------------------+
| GET     | Retrieve        | GET /claims/{id}           | 200     |
| GET     | List/Search     | GET /claims?status=OPEN    | 200     |
| POST    | Create          | POST /claims               | 201     |
| POST    | Action/Command  | POST /claims/{id}/close    | 200     |
| POST    | Complex search  | POST /claims/search        | 200     |
| PUT     | Full replace    | PUT /claims/{id}           | 200     |
| PATCH   | Partial update  | PATCH /claims/{id}         | 200     |
| DELETE  | Remove          | DELETE /claims/{id}/docs/x | 204     |
+------------------------------------------------------------------+

IDEMPOTENCY:
├── GET: naturally idempotent
├── PUT: idempotent (same result on repeat)
├── DELETE: idempotent
├── POST: NOT idempotent → use Idempotency-Key header
│   Header: Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
└── PATCH: NOT idempotent → use If-Match (ETag) for concurrency
```

### 2.3 Query Parameters

```
STANDARD QUERY PARAMETERS:
+------------------------------------------------------------------+
|                                                                  |
|  FILTERING:                                                      |
|  GET /claims?status=OPEN                                         |
|  GET /claims?lob=AUTO&state=CA                                   |
|  GET /claims?dateOfLoss.gte=2025-01-01&dateOfLoss.lte=2025-03-31|
|  GET /claims?totalIncurred.gte=100000                            |
|  GET /claims?adjusterId=adj-123                                  |
|                                                                  |
|  SORTING:                                                        |
|  GET /claims?sort=dateOfLoss:desc                                |
|  GET /claims?sort=totalIncurred:desc,dateReported:asc            |
|                                                                  |
|  PAGINATION:                                                     |
|  GET /claims?page=1&pageSize=25                                  |
|  GET /claims?offset=50&limit=25                                  |
|  Response includes: totalCount, totalPages, currentPage          |
|                                                                  |
|  FIELD SELECTION (Sparse Fieldsets):                              |
|  GET /claims/{id}?fields=claimNumber,status,totalIncurred        |
|                                                                  |
|  EXPANSION (Include related resources):                          |
|  GET /claims/{id}?expand=parties,reserves,latestActivity         |
|                                                                  |
+------------------------------------------------------------------+
```

### 2.4 HTTP Status Codes

```
STATUS CODE USAGE:
+------------------------------------------------------------------+
| Code | Meaning                  | Claims Usage                   |
+------------------------------------------------------------------+
| 200  | OK                       | Successful GET, PUT, PATCH     |
| 201  | Created                  | Successful POST (new resource) |
| 202  | Accepted                 | Async operation started        |
| 204  | No Content               | Successful DELETE              |
| 400  | Bad Request              | Invalid input, validation fail |
| 401  | Unauthorized             | Missing/invalid authentication |
| 403  | Forbidden                | Authenticated but not allowed  |
| 404  | Not Found                | Claim/resource doesn't exist   |
| 409  | Conflict                 | Duplicate, version mismatch    |
| 422  | Unprocessable Entity     | Valid syntax, business error   |
| 429  | Too Many Requests        | Rate limit exceeded            |
| 500  | Internal Server Error    | Unexpected server error        |
| 502  | Bad Gateway              | Upstream service failure       |
| 503  | Service Unavailable      | Service temporarily down       |
+------------------------------------------------------------------+
```

### 2.5 Error Response Format

```json
{
  "error": {
    "code": "CLAIM_VALIDATION_ERROR",
    "message": "The claim could not be created due to validation errors",
    "target": "POST /claims",
    "timestamp": "2025-04-16T10:30:00Z",
    "traceId": "abc-123-def-456",
    "details": [
      {
        "code": "REQUIRED_FIELD",
        "message": "Date of loss is required",
        "field": "dateOfLoss",
        "target": "body"
      },
      {
        "code": "INVALID_VALUE",
        "message": "State code 'XX' is not a valid US state",
        "field": "state",
        "target": "body",
        "rejectedValue": "XX"
      }
    ],
    "helpUrl": "https://developer.insurer.com/errors/CLAIM_VALIDATION_ERROR"
  }
}
```

### 2.6 HATEOAS for Claims Navigation

```json
{
  "claimId": "550e8400-e29b-41d4-a716-446655440000",
  "claimNumber": "CLM-2025-001234",
  "status": "OPEN",
  "totalIncurred": 45000.00,
  "_links": {
    "self": {
      "href": "/claims/v1/claims/550e8400-e29b-41d4-a716-446655440000"
    },
    "reserves": {
      "href": "/claims/v1/claims/550e8400-e29b.../reserves"
    },
    "payments": {
      "href": "/claims/v1/claims/550e8400-e29b.../payments"
    },
    "documents": {
      "href": "/claims/v1/claims/550e8400-e29b.../documents"
    },
    "activities": {
      "href": "/claims/v1/claims/550e8400-e29b.../activities"
    },
    "close": {
      "href": "/claims/v1/claims/550e8400-e29b.../close",
      "method": "POST"
    },
    "assign": {
      "href": "/claims/v1/claims/550e8400-e29b.../assign",
      "method": "POST"
    }
  }
}
```

---

## 3. Complete Claims API Specification

### 3.1 Claims CRUD Operations

```yaml
# OpenAPI 3.0 Specification - Claims API (Excerpt)
openapi: 3.0.3
info:
  title: Claims Management API
  version: 1.0.0
  description: API for managing P&C insurance claims
  contact:
    name: Claims Platform Team
    email: claims-api@insurer.com

servers:
  - url: https://api.insurer.com/claims/v1
    description: Production
  - url: https://api-staging.insurer.com/claims/v1
    description: Staging

paths:
  /claims:
    get:
      operationId: listClaims
      summary: List claims with filtering and pagination
      tags: [Claims]
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [OPEN, CLOSED, REOPENED, DENIED]
        - name: lob
          in: query
          schema:
            type: string
        - name: adjusterId
          in: query
          schema:
            type: string
            format: uuid
        - name: dateOfLoss.gte
          in: query
          schema:
            type: string
            format: date
        - name: dateOfLoss.lte
          in: query
          schema:
            type: string
            format: date
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: pageSize
          in: query
          schema:
            type: integer
            default: 25
            maximum: 100
        - name: sort
          in: query
          schema:
            type: string
            example: "dateOfLoss:desc"
      responses:
        '200':
          description: Claims list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClaimListResponse'
    post:
      operationId: createClaim
      summary: Create a new claim
      tags: [Claims]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateClaimRequest'
      responses:
        '201':
          description: Claim created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Claim'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /claims/{claimId}:
    get:
      operationId: getClaim
      summary: Get claim by ID
      tags: [Claims]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
        - name: expand
          in: query
          schema:
            type: string
            example: "parties,reserves,latestActivity"
      responses:
        '200':
          description: Claim details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Claim'
        '404':
          description: Claim not found
    patch:
      operationId: updateClaim
      summary: Partially update a claim
      tags: [Claims]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
        - name: If-Match
          in: header
          required: true
          schema:
            type: string
          description: ETag for optimistic concurrency
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateClaimRequest'
      responses:
        '200':
          description: Claim updated
        '409':
          description: Conflict (version mismatch)
```

### 3.2 Reserve Management API

```yaml
  /claims/{claimId}/reserves:
    get:
      operationId: listReserves
      summary: List all reserves for a claim
      tags: [Reserves]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Reserve lines
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ReserveListResponse'
    post:
      operationId: setReserve
      summary: Set or change a reserve
      tags: [Reserves]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/SetReserveRequest'
            example:
              reserveType: "LOSS"
              category: "INDEMNITY"
              amount: 50000.00
              reason: "Initial reserve based on damage estimate"
      responses:
        '200':
          description: Reserve set successfully
        '403':
          description: Insufficient authority
```

### 3.3 Payment Processing API

```yaml
  /claims/{claimId}/payments:
    get:
      operationId: listPayments
      summary: List all payments for a claim
      tags: [Payments]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Payment list
    post:
      operationId: createPayment
      summary: Create a payment on a claim
      tags: [Payments]
      parameters:
        - name: claimId
          in: path
          required: true
          schema:
            type: string
            format: uuid
        - name: Idempotency-Key
          in: header
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreatePaymentRequest'
            example:
              paymentType: "INDEMNITY"
              amount: 15000.00
              payee:
                name: "John Smith"
                type: "CLAIMANT"
                address:
                  street: "123 Main St"
                  city: "Dallas"
                  state: "TX"
                  zip: "75201"
              paymentMethod: "CHECK"
              memo: "Property damage payment - partial"
      responses:
        '201':
          description: Payment created
        '403':
          description: Insufficient authority
        '422':
          description: Business rule violation
```

### 3.4 Schema Definitions

```yaml
components:
  schemas:
    Claim:
      type: object
      properties:
        claimId:
          type: string
          format: uuid
        claimNumber:
          type: string
          example: "CLM-2025-001234"
        status:
          type: string
          enum: [OPEN, CLOSED, REOPENED, DENIED, VOID]
        lob:
          type: string
          enum: [PERSONAL_AUTO, HOMEOWNERS, COMMERCIAL_PROPERTY,
                 COMMERCIAL_GL, WORKERS_COMP, COMMERCIAL_AUTO]
        policyNumber:
          type: string
        insuredName:
          type: string
        dateOfLoss:
          type: string
          format: date
        dateReported:
          type: string
          format: date
        causeOfLoss:
          type: string
        state:
          type: string
          maxLength: 2
        description:
          type: string
        adjusterId:
          type: string
          format: uuid
        adjusterName:
          type: string
        financials:
          $ref: '#/components/schemas/ClaimFinancials'
        flags:
          $ref: '#/components/schemas/ClaimFlags'
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time
        version:
          type: integer
        _links:
          type: object

    ClaimFinancials:
      type: object
      properties:
        totalPaidLoss:
          type: number
          format: decimal
        totalPaidExpense:
          type: number
          format: decimal
        totalReservedLoss:
          type: number
          format: decimal
        totalReservedExpense:
          type: number
          format: decimal
        totalIncurred:
          type: number
          format: decimal
        totalRecovery:
          type: number
          format: decimal
        netIncurred:
          type: number
          format: decimal

    ClaimFlags:
      type: object
      properties:
        litigated:
          type: boolean
        attorneyRepresented:
          type: boolean
        siuReferral:
          type: boolean
        subrogationPotential:
          type: boolean
        catastropheEvent:
          type: boolean
        catEventId:
          type: string

    CreateClaimRequest:
      type: object
      required:
        - lob
        - policyNumber
        - dateOfLoss
        - state
        - description
      properties:
        lob:
          type: string
        policyNumber:
          type: string
        dateOfLoss:
          type: string
          format: date
        timeOfLoss:
          type: string
          format: time
        state:
          type: string
        causeOfLoss:
          type: string
        description:
          type: string
        claimant:
          $ref: '#/components/schemas/PartyInfo'
        reportedBy:
          $ref: '#/components/schemas/ContactInfo'
        lossLocation:
          $ref: '#/components/schemas/Address'

    SetReserveRequest:
      type: object
      required:
        - reserveType
        - amount
        - reason
      properties:
        reserveType:
          type: string
          enum: [LOSS, ALAE]
        category:
          type: string
          enum: [INDEMNITY, MEDICAL, EXPENSE]
        amount:
          type: number
          format: decimal
          minimum: 0
        reason:
          type: string
          maxLength: 500

    CreatePaymentRequest:
      type: object
      required:
        - paymentType
        - amount
        - payee
        - paymentMethod
      properties:
        paymentType:
          type: string
          enum: [INDEMNITY, MEDICAL, EXPENSE, RECOVERY]
        amount:
          type: number
          format: decimal
          minimum: 0.01
        payee:
          $ref: '#/components/schemas/PayeeInfo'
        paymentMethod:
          type: string
          enum: [CHECK, ACH, WIRE, VIRTUAL_CARD]
        memo:
          type: string
        invoiceNumber:
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
            timestamp:
              type: string
              format: date-time
            details:
              type: array
              items:
                type: object
                properties:
                  code:
                    type: string
                  message:
                    type: string
                  field:
                    type: string

    ClaimListResponse:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/Claim'
        pagination:
          $ref: '#/components/schemas/Pagination'

    Pagination:
      type: object
      properties:
        page:
          type: integer
        pageSize:
          type: integer
        totalCount:
          type: integer
        totalPages:
          type: integer
```

---

## 4. GraphQL for Claims

### 4.1 Schema Design

```graphql
type Query {
  claim(id: ID!): Claim
  claims(filter: ClaimFilter, sort: ClaimSort, pagination: PaginationInput): ClaimConnection!
  claimSearch(query: String!, filter: ClaimFilter): ClaimConnection!
}

type Mutation {
  createClaim(input: CreateClaimInput!): ClaimPayload!
  updateClaim(id: ID!, input: UpdateClaimInput!): ClaimPayload!
  closeClaim(id: ID!, input: CloseClaimInput!): ClaimPayload!
  reopenClaim(id: ID!, reason: String!): ClaimPayload!
  setReserve(claimId: ID!, input: SetReserveInput!): ReservePayload!
  createPayment(claimId: ID!, input: CreatePaymentInput!): PaymentPayload!
  assignClaim(claimId: ID!, adjusterId: ID!): AssignmentPayload!
}

type Subscription {
  claimUpdated(claimId: ID!): ClaimEvent!
  reserveChanged(claimId: ID!): ReserveEvent!
  paymentIssued(claimId: ID!): PaymentEvent!
}

type Claim {
  id: ID!
  claimNumber: String!
  status: ClaimStatus!
  lob: LineOfBusiness!
  policyNumber: String!
  insuredName: String!
  dateOfLoss: Date!
  dateReported: Date!
  causeOfLoss: String
  state: String!
  description: String
  adjuster: Adjuster
  financials: ClaimFinancials!
  parties: [Party!]!
  reserves: [Reserve!]!
  payments: [Payment!]!
  documents(type: DocumentType): [Document!]!
  activities(last: Int): [Activity!]!
  exposures: [Exposure!]!
  flags: ClaimFlags!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type ClaimFinancials {
  totalPaidLoss: Decimal!
  totalPaidExpense: Decimal!
  totalReservedLoss: Decimal!
  totalReservedExpense: Decimal!
  totalIncurred: Decimal!
  totalRecovery: Decimal!
  netIncurred: Decimal!
}

type Reserve {
  id: ID!
  reserveType: ReserveType!
  category: ReserveCategory!
  amount: Decimal!
  previousAmount: Decimal
  reason: String
  setBy: User!
  setAt: DateTime!
  approvedBy: User
  approvedAt: DateTime
}

type Payment {
  id: ID!
  paymentType: PaymentType!
  amount: Decimal!
  payee: Payee!
  paymentMethod: PaymentMethod!
  checkNumber: String
  status: PaymentStatus!
  issuedAt: DateTime!
  clearedAt: DateTime
}

enum ClaimStatus { OPEN CLOSED REOPENED DENIED VOID }
enum LineOfBusiness { PERSONAL_AUTO HOMEOWNERS COMMERCIAL_PROPERTY
                     COMMERCIAL_GL WORKERS_COMP COMMERCIAL_AUTO }
enum ReserveType { LOSS ALAE }
enum PaymentType { INDEMNITY MEDICAL EXPENSE RECOVERY }
enum PaymentMethod { CHECK ACH WIRE VIRTUAL_CARD }
enum PaymentStatus { PENDING ISSUED CLEARED VOIDED STOPPED }

input ClaimFilter {
  status: [ClaimStatus!]
  lob: [LineOfBusiness!]
  state: [String!]
  adjusterId: ID
  dateOfLossRange: DateRange
  totalIncurredMin: Decimal
  totalIncurredMax: Decimal
  litigated: Boolean
  catEventId: ID
}

input PaginationInput {
  page: Int = 1
  pageSize: Int = 25
}

type ClaimConnection {
  edges: [ClaimEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ClaimEdge {
  node: Claim!
  cursor: String!
}
```

### 4.2 GraphQL Query Examples

```graphql
# Adjuster dashboard query - single request for all needed data
query AdjusterDashboard($adjusterId: ID!) {
  claims(
    filter: { adjusterId: $adjusterId, status: [OPEN, REOPENED] }
    sort: { field: DATE_OF_LOSS, direction: DESC }
    pagination: { page: 1, pageSize: 50 }
  ) {
    totalCount
    edges {
      node {
        id
        claimNumber
        status
        lob
        insuredName
        dateOfLoss
        state
        financials {
          totalIncurred
          totalReservedLoss
        }
        adjuster {
          name
        }
        activities(last: 1) {
          description
          createdAt
        }
        flags {
          litigated
          siuReferral
        }
      }
    }
  }
}

# Detailed claim view with all related data
query ClaimDetail($claimId: ID!) {
  claim(id: $claimId) {
    id
    claimNumber
    status
    lob
    policyNumber
    insuredName
    dateOfLoss
    dateReported
    causeOfLoss
    state
    description
    financials {
      totalPaidLoss
      totalPaidExpense
      totalReservedLoss
      totalReservedExpense
      totalIncurred
      totalRecovery
      netIncurred
    }
    adjuster {
      id
      name
      email
      phone
    }
    parties {
      id
      name
      role
      contact {
        phone
        email
        address { street city state zip }
      }
    }
    reserves {
      id
      reserveType
      category
      amount
      setBy { name }
      setAt
    }
    payments {
      id
      paymentType
      amount
      payee { name }
      paymentMethod
      status
      checkNumber
      issuedAt
    }
    documents {
      id
      name
      type
      uploadedAt
      downloadUrl
    }
    activities(last: 20) {
      id
      type
      description
      createdBy { name }
      createdAt
    }
  }
}
```

---

## 5. gRPC for Internal Communication

### 5.1 Protobuf Definitions

```protobuf
syntax = "proto3";
package claims.v1;

import "google/protobuf/timestamp.proto";
import "google/protobuf/wrappers.proto";

service ClaimService {
  rpc GetClaim (GetClaimRequest) returns (Claim);
  rpc ListClaims (ListClaimsRequest) returns (ListClaimsResponse);
  rpc CreateClaim (CreateClaimRequest) returns (Claim);
  rpc UpdateClaimStatus (UpdateClaimStatusRequest) returns (Claim);
}

service ReserveService {
  rpc GetReserves (GetReservesRequest) returns (ReserveList);
  rpc SetReserve (SetReserveRequest) returns (Reserve);
  rpc ValidateReserveAuthority (ValidateAuthorityRequest)
      returns (AuthorityResponse);
}

service PaymentService {
  rpc CreatePayment (CreatePaymentRequest) returns (Payment);
  rpc GetPayment (GetPaymentRequest) returns (Payment);
  rpc VoidPayment (VoidPaymentRequest) returns (Payment);
}

service CoverageService {
  rpc VerifyCoverage (VerifyCoverageRequest) returns (CoverageResult);
  rpc GetPolicyForClaim (GetPolicyRequest) returns (PolicySummary);
}

message Claim {
  string claim_id = 1;
  string claim_number = 2;
  ClaimStatus status = 3;
  string lob = 4;
  string policy_number = 5;
  string insured_name = 6;
  google.protobuf.Timestamp date_of_loss = 7;
  google.protobuf.Timestamp date_reported = 8;
  string cause_of_loss = 9;
  string state = 10;
  string description = 11;
  string adjuster_id = 12;
  ClaimFinancials financials = 13;
  int32 version = 14;
}

message ClaimFinancials {
  int64 total_paid_loss_cents = 1;
  int64 total_paid_expense_cents = 2;
  int64 total_reserved_loss_cents = 3;
  int64 total_reserved_expense_cents = 4;
  int64 total_incurred_cents = 5;
  int64 total_recovery_cents = 6;
}

enum ClaimStatus {
  CLAIM_STATUS_UNSPECIFIED = 0;
  CLAIM_STATUS_OPEN = 1;
  CLAIM_STATUS_CLOSED = 2;
  CLAIM_STATUS_REOPENED = 3;
  CLAIM_STATUS_DENIED = 4;
}

message GetClaimRequest {
  string claim_id = 1;
}

message SetReserveRequest {
  string claim_id = 1;
  ReserveType reserve_type = 2;
  string category = 3;
  int64 amount_cents = 4;
  string reason = 5;
  string set_by_user_id = 6;
}

enum ReserveType {
  RESERVE_TYPE_UNSPECIFIED = 0;
  RESERVE_TYPE_LOSS = 1;
  RESERVE_TYPE_ALAE = 2;
}
```

---

## 6. Event-Driven APIs

### 6.1 WebSocket for Real-Time Updates

```
WEBSOCKET API FOR CLAIMS:
+------------------------------------------------------------------+
|                                                                  |
|  ENDPOINT: wss://api.insurer.com/claims/v1/ws                   |
|                                                                  |
|  SUBSCRIPTION MESSAGE:                                           |
|  {                                                               |
|    "action": "subscribe",                                        |
|    "channel": "claim-updates",                                   |
|    "filters": {                                                  |
|      "claimId": "550e8400-e29b-...",                             |
|      "eventTypes": ["RESERVE_CHANGED", "PAYMENT_ISSUED",        |
|                      "STATUS_CHANGED", "DOCUMENT_UPLOADED"]      |
|    }                                                             |
|  }                                                               |
|                                                                  |
|  EVENT MESSAGE:                                                  |
|  {                                                               |
|    "eventId": "evt-123",                                         |
|    "eventType": "RESERVE_CHANGED",                               |
|    "claimId": "550e8400-e29b-...",                               |
|    "timestamp": "2025-04-16T10:30:00Z",                         |
|    "data": {                                                     |
|      "reserveType": "LOSS",                                      |
|      "previousAmount": 25000.00,                                 |
|      "newAmount": 45000.00,                                      |
|      "changedBy": "Jane Adjuster"                                |
|    }                                                             |
|  }                                                               |
|                                                                  |
|  USE CASES:                                                      |
|  ├── Real-time claim updates in adjuster UI                      |
|  ├── Live dashboard refresh                                      |
|  ├── Collaborative claim handling notifications                  |
|  └── CAT event real-time monitoring                              |
|                                                                  |
+------------------------------------------------------------------+
```

### 6.2 Webhooks for Partner Integration

```
WEBHOOK API:
+------------------------------------------------------------------+
|                                                                  |
|  REGISTRATION:                                                   |
|  POST /webhooks                                                  |
|  {                                                               |
|    "url": "https://partner.com/callbacks/claims",                |
|    "events": ["claim.created", "claim.closed",                   |
|               "payment.issued", "reserve.changed"],              |
|    "secret": "whsec_abc123...",                                  |
|    "headers": {                                                  |
|      "X-Partner-Id": "partner-001"                               |
|    }                                                             |
|  }                                                               |
|                                                                  |
|  WEBHOOK PAYLOAD:                                                |
|  POST https://partner.com/callbacks/claims                       |
|  Headers:                                                        |
|    Content-Type: application/json                                |
|    X-Webhook-Signature: sha256=abc123...                         |
|    X-Webhook-Id: whk-evt-001                                    |
|    X-Webhook-Timestamp: 2025-04-16T10:30:00Z                    |
|                                                                  |
|  Body:                                                           |
|  {                                                               |
|    "id": "whk-evt-001",                                          |
|    "type": "claim.created",                                      |
|    "created": "2025-04-16T10:30:00Z",                            |
|    "data": {                                                     |
|      "claimId": "550e8400-e29b-...",                             |
|      "claimNumber": "CLM-2025-001234",                           |
|      "status": "OPEN",                                           |
|      "lob": "PERSONAL_AUTO",                                     |
|      "dateOfLoss": "2025-04-15"                                  |
|    }                                                             |
|  }                                                               |
|                                                                  |
|  RETRY POLICY:                                                   |
|  ├── Retry on non-2xx response                                   |
|  ├── Exponential backoff: 1m, 5m, 30m, 2h, 12h                  |
|  ├── Maximum 5 retries                                           |
|  ├── Dead letter queue after max retries                         |
|  └── Webhook disabled after 7 consecutive days of failures       |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 7. API Versioning Strategies

### 7.1 Versioning Approaches

```
API VERSIONING STRATEGY:
+------------------------------------------------------------------+
|                                                                  |
|  APPROACH 1: URL PATH VERSIONING (RECOMMENDED)                   |
|  ├── /claims/v1/claims                                           |
|  ├── /claims/v2/claims                                           |
|  ├── PRO: Explicit, easy to route, clear in logs                 |
|  ├── CON: URL pollution, requires routing per version            |
|  └── USED BY: Stripe, GitHub, Google                             |
|                                                                  |
|  APPROACH 2: HEADER VERSIONING                                   |
|  ├── Accept: application/vnd.insurer.claims.v1+json              |
|  ├── PRO: Clean URLs, content negotiation                        |
|  ├── CON: Less visible, harder to test with browser              |
|  └── USED BY: GitHub (also supports URL)                         |
|                                                                  |
|  APPROACH 3: QUERY PARAMETER                                     |
|  ├── /claims?version=1                                           |
|  ├── PRO: Easy to implement                                      |
|  ├── CON: Can be forgotten, pollutes cache keys                  |
|  └── USED BY: AWS (some APIs)                                    |
|                                                                  |
|  RECOMMENDED: URL path versioning for claims APIs                |
|  Major version only (v1, v2). Minor changes are backward         |
|  compatible and don't require version bump.                      |
|                                                                  |
|  DEPRECATION POLICY:                                             |
|  ├── Deprecation header: Deprecation: true                       |
|  ├── Sunset header: Sunset: Sat, 01 Jan 2027 00:00:00 GMT       |
|  ├── Minimum 12 months notice before sunsetting                  |
|  ├── Documentation updated with migration guide                  |
|  └── Usage monitoring to identify consumers needing migration    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 8. API Security

### 8.1 OAuth2 Flows

```
OAUTH2 FOR CLAIMS APIS:
+====================================================================+
|                                                                    |
|  AUTHORIZATION CODE FLOW (Web Applications):                       |
|  ┌──────┐    ┌──────────┐    ┌────────┐    ┌──────────────┐       |
|  │ User │───>│ Claims   │───>│ Auth   │───>│ Claims API   │       |
|  │      │    │ Web App  │    │ Server │    │              │       |
|  └──────┘    └──────────┘    └────────┘    └──────────────┘       |
|  1. User clicks login                                              |
|  2. App redirects to Auth Server                                   |
|  3. User authenticates (credentials + MFA)                         |
|  4. Auth Server returns authorization code to app                  |
|  5. App exchanges code for access token + refresh token            |
|  6. App uses access token to call Claims API                       |
|                                                                    |
|  CLIENT CREDENTIALS FLOW (Service-to-Service):                     |
|  ┌──────────────┐    ┌────────┐    ┌──────────────┐               |
|  │ Partner      │───>│ Auth   │───>│ Claims API   │               |
|  │ Service      │    │ Server │    │              │               |
|  └──────────────┘    └────────┘    └──────────────┘               |
|  1. Partner service sends client_id + client_secret                |
|  2. Auth Server validates credentials                              |
|  3. Auth Server returns access token                               |
|  4. Partner uses token to call Claims API                          |
|                                                                    |
+====================================================================+
```

### 8.2 JWT Token Design

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "key-2025-001"
  },
  "payload": {
    "iss": "https://auth.insurer.com",
    "sub": "user-12345",
    "aud": "claims-api",
    "exp": 1713270600,
    "iat": 1713267000,
    "jti": "unique-token-id",
    "scope": "claims:read claims:write reserves:read reserves:write payments:read",
    "claims_roles": ["adjuster", "wc_specialist"],
    "claims_lob": ["PERSONAL_AUTO", "WORKERS_COMP"],
    "claims_states": ["CA", "NV", "AZ"],
    "claims_authority": {
      "reserve_limit": 150000,
      "payment_limit": 50000,
      "settlement_limit": 100000
    },
    "org_id": "org-insurance-co",
    "tenant_id": "tenant-001"
  }
}
```

### 8.3 Rate Limiting

```
RATE LIMITING STRATEGY:
+------------------------------------------------------------------+
|                                                                  |
|  TIER-BASED RATE LIMITS:                                         |
|  +------------------------------------------------------------+  |
|  | Tier          | Requests/min | Requests/hour | Burst        |  |
|  +------------------------------------------------------------+  |
|  | Internal      | 1000         | 30000         | 2000         |  |
|  | Partner (Std) | 100          | 3000          | 200          |  |
|  | Partner (Prem)| 500          | 15000         | 1000         |  |
|  | Public        | 20           | 500           | 50           |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  RESPONSE HEADERS:                                               |
|  X-RateLimit-Limit: 100                                          |
|  X-RateLimit-Remaining: 73                                       |
|  X-RateLimit-Reset: 1713267060                                   |
|  Retry-After: 30 (when 429 returned)                             |
|                                                                  |
|  ENDPOINT-SPECIFIC LIMITS:                                       |
|  ├── POST /claims (create): 50/min (prevent abuse)              |
|  ├── POST /payments (create): 100/min                           |
|  ├── GET /claims/search: 200/min (expensive query)              |
|  └── GET /claims/{id}: 500/min (lightweight)                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 9. API Gateway Patterns

### 9.1 Gateway Architecture

```
API GATEWAY ARCHITECTURE:
+====================================================================+
|                                                                    |
|  ┌──────────────────────────────────────────────────────────────┐  |
|  │                       API GATEWAY                             │  |
|  │  (Kong / AWS API Gateway / Apigee)                           │  |
|  │                                                              │  |
|  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │  |
|  │  │ AuthN    │ │ Rate     │ │ Request  │ │ Routing  │       │  |
|  │  │ Plugin   │ │ Limiting │ │Transform │ │ Engine   │       │  |
|  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │  |
|  │                                                              │  |
|  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │  |
|  │  │ Caching  │ │ Logging  │ │ CORS     │ │ Circuit  │       │  |
|  │  │          │ │          │ │          │ │ Breaker  │       │  |
|  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │  |
|  │                                                              │  |
|  └──────────────────────────┬───────────────────────────────────┘  |
|                             │                                      |
|              ┌──────────────┼──────────────┐                       |
|              │              │              │                       |
|         ┌────▼────┐   ┌────▼────┐   ┌────▼────┐                  |
|         │ Claims  │   │ Reserve │   │ Payment │                  |
|         │ Service │   │ Service │   │ Service │                  |
|         └─────────┘   └─────────┘   └─────────┘                  |
|                                                                    |
|  ROUTING CONFIGURATION:                                            |
|  /claims/v1/claims/**    → claim-service:8080                      |
|  /claims/v1/reserves/**  → reserve-service:8080                    |
|  /claims/v1/payments/**  → payment-service:8080                    |
|  /claims/v1/documents/** → document-service:8080                   |
|  /claims/v1/search/**    → search-service:8080                     |
|  /claims/v1/fnol/**      → fnol-service:8080                      |
|                                                                    |
+====================================================================+
```

---

## 10. Microservices Deep Dive

### 10.1 FNOL Service

```
FNOL SERVICE SPECIFICATION:
+====================================================================+
|                                                                    |
|  BOUNDED CONTEXT: FNOL Intake                                      |
|                                                                    |
|  RESPONSIBILITIES:                                                 |
|  ├── Accept FNOL from all channels (web, mobile, phone, agent)     |
|  ├── Validate FNOL submission data                                 |
|  ├── Detect duplicate submissions                                  |
|  ├── Triage and categorize claim                                   |
|  ├── Create initial claim record                                   |
|  └── Trigger downstream processing                                 |
|                                                                    |
|  DATA MODEL:                                                       |
|  ┌──────────────────────────────────────┐                          |
|  │ fnol_submission                      │                          |
|  ├──────────────────────────────────────┤                          |
|  │ submission_id      UUID (PK)         │                          |
|  │ channel            ENUM              │                          |
|  │ submission_date    TIMESTAMP         │                          |
|  │ status             ENUM              │                          |
|  │ raw_payload        JSONB             │                          |
|  │ validated_data     JSONB             │                          |
|  │ duplicate_check    JSONB             │                          |
|  │ triage_result      JSONB             │                          |
|  │ claim_id           UUID (FK, nullable)│                          |
|  │ processing_errors  JSONB             │                          |
|  └──────────────────────────────────────┘                          |
|                                                                    |
|  API ENDPOINTS:                                                    |
|  POST /fnol                    Submit FNOL                         |
|  GET  /fnol/{id}               Get submission status               |
|  GET  /fnol/{id}/status        Track processing status             |
|  POST /fnol/{id}/documents     Attach documents to FNOL            |
|                                                                    |
|  EVENTS PUBLISHED:                                                 |
|  ├── FNOLReceived          (submission accepted)                   |
|  ├── FNOLValidated         (data validation passed)                |
|  ├── FNOLDuplicateDetected (potential duplicate found)             |
|  ├── ClaimCreatedFromFNOL  (claim successfully created)            |
|  └── FNOLRejected          (validation failed)                     |
|                                                                    |
|  EVENTS CONSUMED:                                                  |
|  ├── (none — FNOL is event source, not consumer)                   |
|                                                                    |
|  DUPLICATE DETECTION ALGORITHM:                                    |
|  ├── Match on: insured name + DOL + policy number                  |
|  ├── Fuzzy match on: claimant name + address + DOL ± 3 days       |
|  ├── Score: 0-100 (>80 = likely duplicate)                         |
|  └── Action: flag for review, don't auto-reject                    |
|                                                                    |
+====================================================================+
```

### 10.2 Reserve Service

```
RESERVE SERVICE SPECIFICATION:
+====================================================================+
|                                                                    |
|  BOUNDED CONTEXT: Reserve Management                               |
|                                                                    |
|  RESPONSIBILITIES:                                                 |
|  ├── Manage case-level reserves (set, change, approve)             |
|  ├── Validate authority levels                                     |
|  ├── Route approval workflows                                      |
|  ├── Calculate auto-reserves based on rules                        |
|  ├── Track reserve history (full audit trail)                      |
|  └── Provide reserve adequacy alerts                               |
|                                                                    |
|  DATA MODEL:                                                       |
|  ┌──────────────────────────────────────┐                          |
|  │ reserve_line                         │                          |
|  ├──────────────────────────────────────┤                          |
|  │ reserve_line_id   UUID (PK)          │                          |
|  │ claim_id          UUID (FK)          │                          |
|  │ exposure_id       UUID (FK, nullable)│                          |
|  │ reserve_type      ENUM (LOSS, ALAE)  │                          |
|  │ category          ENUM               │                          |
|  │ current_amount    DECIMAL(15,2)      │                          |
|  │ version           INTEGER            │                          |
|  └──────────────────────────────────────┘                          |
|                                                                    |
|  ┌──────────────────────────────────────┐                          |
|  │ reserve_change                       │                          |
|  ├──────────────────────────────────────┤                          |
|  │ change_id         UUID (PK)          │                          |
|  │ reserve_line_id   UUID (FK)          │                          |
|  │ previous_amount   DECIMAL(15,2)      │                          |
|  │ new_amount        DECIMAL(15,2)      │                          |
|  │ change_amount     DECIMAL(15,2)      │                          |
|  │ reason            TEXT               │                          |
|  │ requested_by      UUID               │                          |
|  │ requested_at      TIMESTAMP          │                          |
|  │ approval_status   ENUM               │                          |
|  │ approved_by       UUID               │                          |
|  │ approved_at       TIMESTAMP          │                          |
|  └──────────────────────────────────────┘                          |
|                                                                    |
|  API ENDPOINTS:                                                    |
|  GET  /claims/{claimId}/reserves                                   |
|  POST /claims/{claimId}/reserves                                   |
|  GET  /claims/{claimId}/reserves/{id}/history                      |
|  POST /claims/{claimId}/reserves/{id}/approve                      |
|                                                                    |
|  EVENTS PUBLISHED:                                                 |
|  ├── ReserveSet            (initial reserve created)               |
|  ├── ReserveChangeRequested (change pending approval)              |
|  ├── ReserveChanged        (change applied)                        |
|  ├── ReserveApproved       (supervisor approved)                   |
|  └── ReserveRejected       (supervisor rejected change)            |
|                                                                    |
|  EVENTS CONSUMED:                                                  |
|  ├── ClaimCreated          (create initial auto-reserve)           |
|  ├── PaymentIssued         (reduce outstanding reserve)            |
|  ├── PaymentVoided         (restore reserve)                       |
|  └── ClaimClosed           (zero out remaining reserves)           |
|                                                                    |
+====================================================================+
```

### 10.3 Payment Service

```
PAYMENT SERVICE SPECIFICATION:
+====================================================================+
|                                                                    |
|  BOUNDED CONTEXT: Payment Processing                               |
|                                                                    |
|  RESPONSIBILITIES:                                                 |
|  ├── Create and validate payment requests                          |
|  ├── Authority validation and approval routing                     |
|  ├── Duplicate payment detection                                   |
|  ├── OFAC/sanctions screening                                      |
|  ├── Payment execution (check, ACH, wire)                          |
|  ├── Payment status tracking                                       |
|  ├── Void/stop/reissue processing                                  |
|  ├── 1099 tax reporting data collection                            |
|  └── Integration with banking/treasury systems                     |
|                                                                    |
|  API ENDPOINTS:                                                    |
|  POST /claims/{claimId}/payments                                   |
|  GET  /claims/{claimId}/payments                                   |
|  GET  /claims/{claimId}/payments/{id}                              |
|  POST /claims/{claimId}/payments/{id}/approve                      |
|  POST /claims/{claimId}/payments/{id}/void                         |
|  POST /claims/{claimId}/payments/{id}/reissue                      |
|  GET  /payments/pending-approval                                   |
|  GET  /payments/batches/{batchId}                                  |
|                                                                    |
|  VALIDATION RULES:                                                 |
|  ├── Amount > 0 and ≤ remaining reserve                            |
|  ├── Amount ≤ user's payment authority                              |
|  ├── Claim must be in OPEN or REOPENED status                      |
|  ├── No duplicate payments (idempotency key check)                 |
|  ├── Payee not on OFAC sanctions list                              |
|  ├── Payment amount ≤ remaining policy limit                       |
|  └── Required fields validated per payment type                    |
|                                                                    |
|  EVENTS PUBLISHED:                                                 |
|  ├── PaymentRequested    (payment submitted)                       |
|  ├── PaymentApproved     (approved by supervisor)                  |
|  ├── PaymentIssued       (check/EFT generated)                     |
|  ├── PaymentCleared      (check cashed / EFT confirmed)            |
|  ├── PaymentVoided       (payment voided)                          |
|  ├── PaymentStopped      (stop payment on check)                   |
|  └── PaymentReissued     (replacement issued)                      |
|                                                                    |
+====================================================================+
```

### 10.4 Fraud Service

```
FRAUD SERVICE SPECIFICATION:
+====================================================================+
|                                                                    |
|  BOUNDED CONTEXT: Fraud Detection                                  |
|                                                                    |
|  RESPONSIBILITIES:                                                 |
|  ├── Real-time fraud scoring at FNOL                               |
|  ├── Ongoing fraud monitoring during claim lifecycle               |
|  ├── Red flag indicator evaluation                                 |
|  ├── SIU referral management                                       |
|  ├── Network analysis (fraud ring detection)                       |
|  ├── Predictive model serving (ML inference)                       |
|  └── Integration with external fraud databases                     |
|                                                                    |
|  API ENDPOINTS:                                                    |
|  POST /fraud/score                 Score a claim for fraud         |
|  GET  /fraud/claims/{claimId}      Get fraud assessment            |
|  POST /fraud/siu-referral          Create SIU referral             |
|  GET  /fraud/siu-referrals         List SIU referrals              |
|  POST /fraud/network-analysis      Analyze entity relationships    |
|                                                                    |
|  SCORING REQUEST/RESPONSE:                                         |
|  Request:                                                          |
|  {                                                                 |
|    "claimId": "...",                                               |
|    "claimData": {                                                  |
|      "dateOfLoss": "2025-04-15",                                   |
|      "dateReported": "2025-04-16",                                 |
|      "lob": "PERSONAL_AUTO",                                      |
|      "causeOfLoss": "COLLISION",                                   |
|      "totalClaimed": 25000,                                       |
|      "claimantName": "John Smith",                                |
|      "claimantSSN": "***-**-1234",                                |
|      "policyAge": 45,                                             |
|      "priorClaims": 3                                             |
|    }                                                               |
|  }                                                                 |
|                                                                    |
|  Response:                                                         |
|  {                                                                 |
|    "fraudScore": 72,                                               |
|    "riskLevel": "HIGH",                                            |
|    "redFlags": [                                                   |
|      { "code": "RF001", "desc": "Multiple prior claims",          |
|        "weight": 15 },                                             |
|      { "code": "RF007", "desc": "Recent policy inception",        |
|        "weight": 12 },                                             |
|      { "code": "RF015", "desc": "Claim exceeds typical range",    |
|        "weight": 10 }                                              |
|    ],                                                              |
|    "recommendation": "SIU_REVIEW",                                 |
|    "modelVersion": "fraud-v3.2.1"                                  |
|  }                                                                 |
|                                                                    |
|  DATABASE: PostgreSQL + Neo4j (graph for network analysis)         |
|                                                                    |
+====================================================================+
```

---

## 11. Service Mesh

### 11.1 Service Mesh Architecture

```
SERVICE MESH FOR CLAIMS (Istio):
+------------------------------------------------------------------+
|                                                                  |
|  TRAFFIC MANAGEMENT:                                             |
|  ├── Request routing with virtual services                       |
|  ├── Traffic splitting (canary: 5% new version)                  |
|  ├── Fault injection for resilience testing                      |
|  ├── Circuit breaking per service                                |
|  ├── Retry policies with backoff                                 |
|  └── Request timeouts per route                                  |
|                                                                  |
|  SECURITY (mTLS):                                                |
|  ├── Automatic mTLS between all services                         |
|  ├── No plaintext traffic within mesh                            |
|  ├── Service identity via SPIFFE/SPIRE                           |
|  ├── Authorization policies (which service can call which)       |
|  └── JWT validation at mesh ingress                              |
|                                                                  |
|  OBSERVABILITY:                                                  |
|  ├── Automatic distributed tracing (no code changes)             |
|  ├── Service-to-service metrics (latency, errors, throughput)    |
|  ├── Access logging for all mesh traffic                         |
|  └── Service topology visualization (Kiali)                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 12. Container Orchestration

### 12.1 Kubernetes Deployment

```yaml
# Sample Kubernetes Deployment for claim-service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: claim-service
  namespace: claims
  labels:
    app: claim-service
    version: v1.5.2
spec:
  replicas: 3
  selector:
    matchLabels:
      app: claim-service
  template:
    metadata:
      labels:
        app: claim-service
        version: v1.5.2
    spec:
      serviceAccountName: claim-service-sa
      containers:
        - name: claim-service
          image: ecr.aws/claims/claim-service:v1.5.2
          ports:
            - containerPort: 8080
              name: http
            - containerPort: 9090
              name: grpc
          env:
            - name: SPRING_PROFILES_ACTIVE
              value: production
            - name: DB_HOST
              valueFrom:
                secretKeyRef:
                  name: claim-db-credentials
                  key: host
          resources:
            requests:
              cpu: "500m"
              memory: "1Gi"
            limits:
              cpu: "2000m"
              memory: "4Gi"
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 30
          startupProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            failureThreshold: 30
            periodSeconds: 10
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: claim-service-hpa
  namespace: claims
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: claim-service
  minReplicas: 3
  maxReplicas: 50
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Percent
          value: 100
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 10
          periodSeconds: 60
```

---

## 13. Testing Microservices

### 13.1 Consumer-Driven Contract Testing

```
CONTRACT TESTING WITH PACT:
+------------------------------------------------------------------+
|                                                                  |
|  CONCEPT:                                                        |
|  ├── Consumer defines expected interactions (contract)           |
|  ├── Contract verified against provider (service under test)     |
|  ├── Contracts stored in Pact Broker                             |
|  └── Both sides tested independently                            |
|                                                                  |
|  EXAMPLE: Reserve Service consumes Claim Service                 |
|                                                                  |
|  CONSUMER (reserve-service) TEST:                                |
|                                                                  |
|  @PactTestFor(providerName = "claim-service")                    |
|  void shouldReturnClaimDetails() {                               |
|    // Define expected interaction                                 |
|    pact.given("claim CLM-001 exists")                             |
|        .uponReceiving("get claim by id")                          |
|        .method("GET")                                             |
|        .path("/claims/v1/claims/CLM-001")                         |
|        .willRespondWith()                                         |
|        .status(200)                                               |
|        .body(newJsonBody(body -> {                                 |
|          body.stringType("claimId");                               |
|          body.stringValue("status", "OPEN");                       |
|          body.object("financials", fin -> {                        |
|            fin.numberType("totalReservedLoss");                    |
|          });                                                       |
|        }));                                                        |
|                                                                  |
|    // Test consumer code against mock                            |
|    ClaimDetail claim = claimClient.getClaim("CLM-001");           |
|    assertThat(claim.getStatus()).isEqualTo("OPEN");               |
|  }                                                               |
|                                                                  |
|  PROVIDER (claim-service) VERIFICATION:                          |
|                                                                  |
|  @Provider("claim-service")                                      |
|  @PactBroker(url = "https://pact-broker.insurer.com")            |
|  void verifyPacts() {                                             |
|    // States setup                                               |
|    @State("claim CLM-001 exists")                                 |
|    void claimExists() {                                           |
|      claimRepository.save(testClaim("CLM-001"));                  |
|    }                                                             |
|    // Pact framework automatically verifies all interactions      |
|  }                                                               |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.2 Integration Testing with Testcontainers

```java
@Testcontainers
@SpringBootTest
class ClaimServiceIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:16")
            .withDatabaseName("claims")
            .withUsername("test")
            .withPassword("test");

    @Container
    static KafkaContainer kafka =
        new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.5.0"));

    @Container
    static GenericContainer<?> redis =
        new GenericContainer<>("redis:7")
            .withExposedPorts(6379);

    @Test
    void shouldCreateClaimAndPublishEvent() {
        // Create claim via API
        CreateClaimRequest request = CreateClaimRequest.builder()
            .lob("PERSONAL_AUTO")
            .policyNumber("POL-001")
            .dateOfLoss(LocalDate.of(2025, 4, 15))
            .state("TX")
            .description("Rear-end collision at intersection")
            .build();

        Claim result = webTestClient.post()
            .uri("/claims/v1/claims")
            .bodyValue(request)
            .exchange()
            .expectStatus().isCreated()
            .expectBody(Claim.class)
            .returnResult()
            .getResponseBody();

        assertThat(result.getClaimNumber()).isNotNull();
        assertThat(result.getStatus()).isEqualTo("OPEN");

        // Verify event published to Kafka
        ConsumerRecord<String, String> event =
            KafkaTestUtils.getSingleRecord(consumer, "claims.claim.lifecycle");
        assertThat(event.value()).contains("ClaimCreated");
    }
}
```

### 13.3 Chaos Engineering

```
CHAOS ENGINEERING FOR CLAIMS:
+------------------------------------------------------------------+
|                                                                  |
|  EXPERIMENTS:                                                    |
|  +------------------------------------------------------------+  |
|  | Experiment            | Tool       | Expected Behavior       |  |
|  +------------------------------------------------------------+  |
|  | Kill claim-service pod| Litmus     | Traffic reroutes to     |  |
|  |                       |            | healthy pods, no errors |  |
|  | Network partition     | Chaos Mesh | Retry with backoff,     |  |
|  | between services      |            | circuit breaker opens   |  |
|  | Database failover     | Litmus     | Read replica promotes,  |  |
|  |                       |            | brief read-only period  |  |
|  | Kafka broker down     | Chaos Mesh | Events queued locally,  |  |
|  |                       |            | replayed on recovery    |  |
|  | Redis cache failure   | Litmus     | Fallback to database,   |  |
|  |                       |            | degraded performance    |  |
|  | CPU stress test       | Stress-ng  | HPA scales up pods,     |  |
|  |                       |            | response times stable   |  |
|  | 100x FNOL surge       | k6         | Auto-scaling handles    |  |
|  | (CAT simulation)      |            | load within 15 minutes  |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 14. API Documentation and Developer Portal

### 14.1 Developer Portal Structure

```
CLAIMS API DEVELOPER PORTAL:
+------------------------------------------------------------------+
|                                                                  |
|  SECTIONS:                                                       |
|  ├── Getting Started                                             |
|  │   ├── Authentication guide                                    |
|  │   ├── Quick start (create first claim)                        |
|  │   ├── SDKs and client libraries                               |
|  │   └── Sandbox environment                                     |
|  ├── API Reference                                               |
|  │   ├── Claims API (interactive Swagger UI)                     |
|  │   ├── Reserves API                                            |
|  │   ├── Payments API                                            |
|  │   ├── Documents API                                           |
|  │   ├── FNOL API                                                |
|  │   └── Search API                                              |
|  ├── Guides                                                      |
|  │   ├── FNOL submission workflow                                |
|  │   ├── Reserve management                                     |
|  │   ├── Payment processing                                     |
|  │   ├── Document management                                    |
|  │   ├── Webhook integration                                    |
|  │   └── Error handling best practices                           |
|  ├── API Changelog                                               |
|  │   ├── Version history                                        |
|  │   ├── Breaking changes                                       |
|  │   └── Deprecation notices                                    |
|  ├── SDK Downloads                                               |
|  │   ├── Java SDK                                                |
|  │   ├── Python SDK                                              |
|  │   ├── JavaScript/TypeScript SDK                               |
|  │   └── .NET SDK                                                |
|  └── Support                                                     |
|      ├── FAQ                                                     |
|      ├── Status page                                             |
|      └── Contact / Support tickets                               |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 15. Sample OpenAPI Specifications

See Section 3 for the complete OpenAPI 3.0 specification covering Claims CRUD, Reserves, Payments, Documents, Search, and Assignment endpoints with full request/response schemas and examples.

---

## 16. Sample Event Schemas

### 16.1 CloudEvents Format

```json
{
  "specversion": "1.0",
  "id": "evt-2025-001234",
  "source": "/claims/claim-service",
  "type": "com.insurer.claims.ClaimCreated",
  "datacontenttype": "application/json",
  "time": "2025-04-16T10:30:00Z",
  "subject": "CLM-2025-001234",
  "data": {
    "claimId": "550e8400-e29b-41d4-a716-446655440000",
    "claimNumber": "CLM-2025-001234",
    "status": "OPEN",
    "lob": "PERSONAL_AUTO",
    "policyNumber": "POL-2025-112233",
    "insuredName": "John Smith",
    "dateOfLoss": "2025-04-15",
    "state": "TX",
    "causeOfLoss": "COLLISION",
    "adjusterId": "adj-42",
    "initialReserveLoss": 25000.00,
    "initialReserveALAE": 5000.00
  }
}
```

```json
{
  "specversion": "1.0",
  "id": "evt-2025-001235",
  "source": "/claims/reserve-service",
  "type": "com.insurer.claims.ReserveChanged",
  "datacontenttype": "application/json",
  "time": "2025-04-16T14:15:00Z",
  "subject": "CLM-2025-001234",
  "data": {
    "claimId": "550e8400-e29b-41d4-a716-446655440000",
    "reserveLineId": "res-line-001",
    "reserveType": "LOSS",
    "category": "INDEMNITY",
    "previousAmount": 25000.00,
    "newAmount": 45000.00,
    "changeAmount": 20000.00,
    "reason": "Revised damage estimate based on adjuster inspection",
    "changedBy": "adj-42",
    "approvalRequired": false
  }
}
```

```json
{
  "specversion": "1.0",
  "id": "evt-2025-001236",
  "source": "/claims/payment-service",
  "type": "com.insurer.claims.PaymentIssued",
  "datacontenttype": "application/json",
  "time": "2025-04-16T16:00:00Z",
  "subject": "CLM-2025-001234",
  "data": {
    "claimId": "550e8400-e29b-41d4-a716-446655440000",
    "paymentId": "pmt-001",
    "paymentType": "INDEMNITY",
    "amount": 15000.00,
    "payeeName": "John Smith",
    "payeeType": "CLAIMANT",
    "paymentMethod": "CHECK",
    "checkNumber": "100234567",
    "issuedBy": "adj-42",
    "reserveImpact": {
      "reserveType": "LOSS",
      "previousOutstanding": 45000.00,
      "newOutstanding": 30000.00
    }
  }
}
```

---

## 17. Sample Protobuf Definitions

See Section 5 for complete protobuf definitions covering ClaimService, ReserveService, PaymentService, and CoverageService with full message types and RPC definitions.

---

## 18. Deployment Architecture

### 18.1 Deployment Topology

```
CLAIMS MICROSERVICES DEPLOYMENT:
+====================================================================+
|                                                                    |
|  KUBERNETES CLUSTER (EKS)                                          |
|  ┌──────────────────────────────────────────────────────────────┐  |
|  │  NAMESPACE: claims-production                                │  |
|  │                                                              │  |
|  │  ┌────────────────────────────────────────────────────────┐  │  |
|  │  │  INGRESS (ALB Ingress Controller)                      │  │  |
|  │  │  ├── api.insurer.com/claims/* → claim services         │  │  |
|  │  │  └── TLS termination, WAF integration                  │  │  |
|  │  └────────────────────────────────────────────────────────┘  │  |
|  │                                                              │  |
|  │  SERVICES (3 replicas minimum each):                         │  |
|  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐   │  |
|  │  │ FNOL   │ │ Claim  │ │Coverage│ │Reserve │ │Payment │   │  |
|  │  │ (3)    │ │ (3)    │ │ (3)    │ │ (3)    │ │ (3)    │   │  |
|  │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘   │  |
|  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐   │  |
|  │  │Assign  │ │Document│ │ Comms  │ │ Fraud  │ │ Subro  │   │  |
|  │  │ (3)    │ │ (3)    │ │ (3)    │ │ (3)    │ │ (2)    │   │  |
|  │  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘   │  |
|  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐               │  |
|  │  │ Search │ │ Audit  │ │Analytic│ │ Config │               │  |
|  │  │ (3)    │ │ (3)    │ │ (3)    │ │ (2)    │               │  |
|  │  └────────┘ └────────┘ └────────┘ └────────┘               │  |
|  │                                                              │  |
|  │  INFRASTRUCTURE SERVICES:                                    │  |
|  │  ┌────────┐ ┌────────┐ ┌────────┐                           │  |
|  │  │Camunda │ │Keycloak│ │ Kafka  │                           │  |
|  │  │(Zeebe) │ │ (3)    │ │Connect │                           │  |
|  │  │ (3)    │ │        │ │ (3)    │                           │  |
|  │  └────────┘ └────────┘ └────────┘                           │  |
|  │                                                              │  |
|  └──────────────────────────────────────────────────────────────┘  |
|                                                                    |
|  MANAGED SERVICES:                                                 |
|  ├── Amazon MSK (Kafka): 6 brokers, 3 AZ                          |
|  ├── Amazon RDS (PostgreSQL): Multi-AZ, 2 read replicas           |
|  ├── Amazon ElastiCache (Redis): 3-node cluster                   |
|  ├── Amazon OpenSearch: 3-node cluster                            |
|  ├── Amazon S3: document and file storage                         |
|  └── Amazon CloudWatch: logging and monitoring                    |
|                                                                    |
|  TOTAL PODS (minimum): ~45 pods                                   |
|  TOTAL PODS (CAT surge): up to 500+ pods                          |
|                                                                    |
+====================================================================+
```

---

## Summary

API design and microservices architecture for claims platforms requires balancing multiple concerns:

1. **API consistency** — Establish and enforce style guides early; every team must follow the same patterns for naming, errors, pagination, and versioning.

2. **Domain alignment** — Use domain-driven design to identify service boundaries. Each microservice should own one bounded context and its data.

3. **Event-driven core** — Claims processing is inherently event-driven (injury happens, claim created, reserve set, payment issued). Embrace this with Kafka-based event streaming as the architectural backbone.

4. **Security by design** — Claims data is highly sensitive (PII, PHI, financial). OAuth2, JWT with claims-based authorization, mTLS between services, and field-level encryption are non-negotiable.

5. **Resilience for CAT events** — The architecture must handle 100x volume spikes. Auto-scaling, circuit breakers, bulkheads, and graceful degradation are essential patterns.

6. **Testing pyramid** — Unit tests for business logic, contract tests for service boundaries, integration tests with Testcontainers, and chaos engineering for resilience validation.

7. **Developer experience** — Treat APIs as products. Interactive documentation, sandbox environments, SDKs, and clear error messages reduce integration friction for both internal and external consumers.

8. **Observability** — In a distributed system, you cannot debug without comprehensive logging, metrics, and distributed tracing. Invest in observability from day one.

The combination of well-designed REST APIs for external access, gRPC for internal high-performance calls, GraphQL for flexible frontend queries, and event streaming for asynchronous processing creates a comprehensive communication architecture for modern claims platforms.
