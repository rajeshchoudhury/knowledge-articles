# Vendor & Partner Ecosystem in PnC Claims

## Table of Contents

1. [Vendor Ecosystem Overview](#1-vendor-ecosystem-overview)
2. [Claims Management System Vendors](#2-claims-management-system-vendors)
3. [Estimatics / Damage Estimation Vendors](#3-estimatics--damage-estimation-vendors)
4. [Auto Body Repair Networks (DRP)](#4-auto-body-repair-networks-drp)
5. [Rental Car Management](#5-rental-car-management)
6. [Salvage Vendors](#6-salvage-vendors)
7. [Independent Adjuster (IA) Firms](#7-independent-adjuster-ia-firms)
8. [Legal Service Providers](#8-legal-service-providers)
9. [Medical Management Vendors](#9-medical-management-vendors)
10. [Fraud Detection Vendors](#10-fraud-detection-vendors)
11. [Data & Analytics Providers](#11-data--analytics-providers)
12. [Document Management Vendors](#12-document-management-vendors)
13. [Payment Platforms](#13-payment-platforms)
14. [Telematics Providers](#14-telematics-providers)
15. [Drone & Aerial Imagery Providers](#15-drone--aerial-imagery-providers)
16. [Vendor Management Framework](#16-vendor-management-framework)
17. [Vendor Integration Architecture](#17-vendor-integration-architecture)
18. [Vendor Data Model](#18-vendor-data-model)
19. [Build vs Buy Decision Framework](#19-build-vs-buy-decision-framework)
20. [Vendor Risk Management & Business Continuity](#20-vendor-risk-management--business-continuity)

---

## 1. Vendor Ecosystem Overview

The PnC claims vendor ecosystem is a complex web of specialized providers that collectively enable end-to-end claims processing. No carrier operates claims entirely in-house; all rely on an ecosystem of dozens to hundreds of vendors across multiple categories.

### Vendor Ecosystem Map

```
+===================================================================+
|                   PnC CLAIMS VENDOR ECOSYSTEM                      |
+===================================================================+
|                                                                     |
|  CORE CLAIMS PLATFORM                                              |
|  +-------------------------------------------------------------+  |
|  | Claims Management System (Guidewire, Duck Creek, etc.)       |  |
|  +-------------------------------------------------------------+  |
|       |            |            |            |            |         |
|  ESTIMATION    INSPECTION   PAYMENT     ANALYTICS    DOCUMENTS     |
|  +----------+ +----------+ +--------+ +----------+ +-----------+  |
|  |CCC       | |Crawford  | |One Inc | |Verisk    | |OnBase     |  |
|  |Mitchell  | |Sedgwick  | |VPay    | |LexisNexis| |FileNet    |  |
|  |Xactimate | |McLarens  | |Stripe  | |CoreLogic | |DocuSign   |  |
|  |Audatex   | |EFI Global| |        | |TransUnion| |           |  |
|  +----------+ +----------+ +--------+ +----------+ +-----------+  |
|       |            |            |            |            |         |
|  REPAIR/RESTORE  LEGAL      MEDICAL     FRAUD       TELEMATICS    |
|  +----------+ +----------+ +--------+ +----------+ +-----------+  |
|  |DRP Shops | |Panel     | |MedBill | |Shift Tech| |CMT        |  |
|  |SERVPRO   | |Counsel   | |Nurse CM| |FRISS     | |Arity      |  |
|  |BELFOR    | |Lit Mgmt  | |IME     | |SAS       | |Octo       |  |
|  |ServiceMstr|          | |UR      | |BAE       | |           |  |
|  +----------+ +----------+ +--------+ +----------+ +-----------+  |
|       |            |                                               |
|  SALVAGE       RENTAL      AERIAL/DRONE   WEATHER                 |
|  +----------+ +----------+ +-----------+ +-----------+            |
|  |Copart    | |Enterprise| |EagleView  | |DTN        |            |
|  |IAA       | |Hertz     | |Nearmap    | |WeatherCo  |            |
|  |          | |Avis      | |Betterview | |NOAA       |            |
|  +----------+ +----------+ +-----------+ +-----------+            |
|                                                                     |
+===================================================================+
```

### Vendor Categories Summary

| Category | # of Typical Vendors | Annual Spend Range | Integration Complexity |
|----------|---------------------|-------------------|----------------------|
| Claims Management System | 1 (primary) | $5M–$50M+ | Very High |
| Estimatics | 2–3 | $2M–$15M | High |
| Auto Body / DRP | 500–5,000 shops | $50M–$500M+ (repair costs) | High |
| Rental Car | 2–3 | $10M–$100M+ | Medium |
| Salvage | 1–2 | $5M–$50M (offset by recoveries) | Medium |
| IA Firms | 3–10 | $10M–$100M+ (CAT surge) | High |
| Legal Services | 10–50 | $20M–$200M+ | Medium |
| Medical Management | 5–15 | $5M–$50M | Medium |
| Fraud Detection | 1–3 | $1M–$10M | High |
| Data & Analytics | 5–10 | $3M–$20M | High |
| Document Management | 1–3 | $1M–$10M | High |
| Payment | 1–2 | $1M–$5M | High |
| Telematics | 1–2 | $1M–$10M | Medium |
| Aerial/Drone | 1–3 | $1M–$10M | Medium |

---

## 2. Claims Management System Vendors

### 2.1 Guidewire ClaimCenter

**Overview:**
Guidewire ClaimCenter is the dominant claims management system in the P&C insurance market, used by a majority of the top 100 U.S. carriers. Originally built as a Java-based on-premise platform, it has transitioned to Guidewire Cloud (AWS-based SaaS).

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application Server | Java (J2EE), Gosu (proprietary language) |
| Database | Oracle, PostgreSQL (Cloud) |
| UI Framework | React (Jutro Digital Platform) |
| Integration | REST APIs, Cloud API, Messaging (Kafka) |
| Cloud Platform | AWS (Guidewire Cloud) |
| Deployment | Guidewire Cloud (managed SaaS) or self-managed |
| Extensibility | Gosu, PCFs (page configuration files), Plugins |

**Key Features:**

| Feature | Description |
|---------|-------------|
| FNOL | Multi-channel intake, guided workflows |
| Coverage Verification | Automated coverage analysis and exposure setup |
| Adjuster Assignment | Rules-based assignment with workload balancing |
| Reserve Management | Automated reserve recommendations, approval workflows |
| Activity Management | Task-based workflow engine with SLA tracking |
| Payment Processing | Multi-party payment with approval hierarchies |
| Litigation Management | Integrated legal case management |
| Subrogation | Automated subrogation identification and tracking |
| Fraud Detection | Rules engine + integration with SIU tools |
| Reporting | Built-in dashboards, Explore (BI tool) |
| Vendor Management | Assignment, tracking, and performance monitoring |
| Regulatory | State-specific compliance rules, deadline tracking |

**Integration Capabilities:**

```
+-------------------------------------------------------------------+
|                 GUIDEWIRE CLAIMCENTER INTEGRATION                   |
+-------------------------------------------------------------------+
|                                                                     |
|  CLOUD API (REST)                                                  |
|  +-------------------------------------------------------------+  |
|  | - Claim CRUD operations                                      |  |
|  | - Activity management                                        |  |
|  | - Document management                                        |  |
|  | - Payment operations                                         |  |
|  | - Note/history operations                                    |  |
|  | - Batch operations (bulk updates)                            |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  INTEGRATION FRAMEWORK                                             |
|  +-------------------------------------------------------------+  |
|  | - Pre-built integrations (Marketplace)                       |  |
|  | - Plugin architecture (Java/Gosu)                            |  |
|  | - Messaging (async events via Kafka)                         |  |
|  | - File-based integration (import/export)                     |  |
|  | - Webhooks (event notifications)                             |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  GUIDEWIRE MARKETPLACE                                             |
|  +-------------------------------------------------------------+  |
|  | Pre-built connectors to:                                     |  |
|  | - CCC, Mitchell, Audatex (estimatics)                        |  |
|  | - Copart, IAA (salvage)                                      |  |
|  | - Enterprise (rental)                                        |  |
|  | - Verisk/ISO (data services)                                 |  |
|  | - LexisNexis (data services)                                 |  |
|  | - Shift, FRISS (fraud)                                       |  |
|  | - One Inc, VPay (payment)                                    |  |
|  | - DocuSign (digital signature)                               |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

**Sample Cloud API Request - Create Claim:**

```json
POST /claim/v1/claims
Content-Type: application/json
Authorization: Bearer {token}

{
  "data": {
    "attributes": {
      "lossDate": "2024-10-10T14:30:00Z",
      "reportedDate": "2024-10-10T16:00:00Z",
      "lossType": "PR",
      "lossCause": "windstorm",
      "description": "Wind damage to roof from Hurricane Milton",
      "mainContact": {
        "id": "pc:1001"
      },
      "policy": {
        "policyNumber": "HO-123456789"
      },
      "lossLocation": {
        "addressLine1": "123 Ocean Drive",
        "city": "Tampa",
        "state": "FL",
        "postalCode": "33701"
      }
    }
  }
}
```

### 2.2 Duck Creek Claims

**Overview:**
Duck Creek Technologies provides a cloud-native SaaS claims management platform. Acquired by Vista Equity Partners in 2023, Duck Creek focuses on modern cloud architecture and low-code configuration.

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | .NET Core, C# |
| Database | SQL Server (Azure SQL) |
| UI | React, Angular |
| Integration | REST APIs, Azure Service Bus, ACORD messaging |
| Cloud Platform | Microsoft Azure |
| Deployment | SaaS (Duck Creek OnDemand) |
| Extensibility | Low-code configuration, .NET plugins |

**Key Differentiators:**
- Low-code/no-code configuration for business rules
- Native Azure cloud architecture
- Strong ACORD standards compliance
- Integrated distribution management
- Modern API-first design

### 2.3 Majesco Claims (now part of EIS)

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | Java, Microservices |
| Database | PostgreSQL, MongoDB |
| UI | React |
| Integration | REST APIs, Kafka, GraphQL |
| Cloud Platform | AWS, Azure, GCP (multi-cloud) |
| Deployment | SaaS, PaaS |
| Extensibility | Microservices, API-based |

### 2.4 Insurity

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | Java, .NET |
| Database | SQL Server, Oracle |
| UI | Web-based |
| Integration | REST APIs, Web Services |
| Cloud Platform | AWS |
| Deployment | SaaS, hosted |
| Extensibility | Configuration-driven |

### 2.5 Snapsheet

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | Node.js, Python |
| Database | PostgreSQL, MongoDB |
| UI | React |
| Integration | REST APIs, Webhooks |
| Cloud Platform | AWS |
| Deployment | SaaS only |
| Extensibility | API-first, Microservices |
| Focus | Virtual claims, photo-based estimation |

### 2.6 BriteCore

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | Python (Django) |
| Database | PostgreSQL |
| UI | Vue.js |
| Integration | REST APIs, Webhooks |
| Cloud Platform | AWS |
| Deployment | SaaS only |
| Extensibility | API-first, Python plugins |
| Focus | Small-mid carriers, mutual companies |

### 2.7 OneShield

**Architecture & Technology Stack:**

| Component | Technology |
|-----------|-----------|
| Application | Java |
| Database | Oracle, SQL Server |
| UI | Web-based, Angular |
| Integration | REST APIs, SOA |
| Cloud Platform | AWS, Azure |
| Deployment | SaaS, hosted, on-premise |
| Extensibility | Configuration, Java extensions |

### Vendor Comparison Matrix

| Feature | Guidewire | Duck Creek | Majesco | Insurity | Snapsheet | BriteCore | OneShield |
|---------|-----------|------------|---------|----------|-----------|-----------|-----------|
| **Market Position** | Leader | Strong #2 | Growing | Niche | Insurtech | Niche | Niche |
| **Target Market** | Mid-Large | Mid-Large | Mid | Small-Mid | All | Small-Mid | Mid |
| **Cloud Native** | Migrating | Yes | Yes | Partial | Yes | Yes | Partial |
| **SaaS** | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| **Multi-line** | Yes | Yes | Yes | Yes | Auto-focused | Yes | Yes |
| **Auto Claims** | Strong | Good | Good | Good | Excellent | Good | Good |
| **Property Claims** | Strong | Strong | Good | Good | Growing | Good | Good |
| **Workers Comp** | Strong | Good | Good | Good | No | Limited | Good |
| **API Coverage** | Extensive | Extensive | Good | Moderate | Excellent | Good | Moderate |
| **Marketplace** | Extensive | Growing | Limited | Limited | Limited | Limited | Limited |
| **Implementation** | 12-24 months | 9-18 months | 6-12 months | 6-12 months | 2-4 months | 3-6 months | 9-15 months |
| **Typical Cost** | $10M-$50M+ | $5M-$30M | $3M-$20M | $2M-$15M | $500K-$5M | $1M-$5M | $3M-$15M |
| **Gosu/Custom Lang** | Yes (Gosu) | No (.NET) | No (Java) | No | No | No (Python) | No (Java) |
| **Low-Code Config** | Limited | Strong | Good | Moderate | Good | Good | Moderate |

### Implementation Considerations

| Factor | Consideration |
|--------|--------------|
| Data migration | Historical claims data migration scope, mapping, cleansing |
| Integration complexity | Number and type of existing vendor integrations to rebuild |
| Customization | Degree of custom business rules and workflows |
| Training | Adjuster training scope (hundreds to thousands of users) |
| Parallel run | Duration of parallel operation with legacy system |
| Regulatory | State-specific configurations for all operating states |
| Performance | Claims volume handling capacity validation |
| Disaster recovery | DR/BCP setup in new environment |

---

## 3. Estimatics / Damage Estimation Vendors

### 3.1 CCC Intelligent Solutions

**Market Position:** Dominant in auto claims estimation (80%+ market share for auto body estimating).

**Products:**

| Product | Function | Users |
|---------|----------|-------|
| CCC ONE | Unified auto claims platform | Adjusters, shops, carriers |
| Estimate - STP | Straight-through processing for minor auto damage | Auto claims, AI-based |
| Photo Estimating | AI-powered photo-based damage assessment | Virtual adjusters, customers |
| Casualty | Bodily injury claims management | BI adjusters |
| Subrogation | Automated subrogation demand and recovery | Subrogation teams |
| Total Loss | Vehicle valuation and total loss processing | Total loss adjusters |
| Parts Network | OEM and aftermarket parts sourcing | Repair shops |

**Integration Architecture:**

```
+-------------------------------------------------------------------+
|                    CCC ONE INTEGRATION                              |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System (Guidewire, Duck Creek, etc.)                       |
|       |                                                             |
|       | REST API / SOAP / File (BMS)                               |
|       v                                                             |
|  +---------------------+     +-------------------+                  |
|  | Assignment Service   |---->| CCC ONE Platform |                  |
|  | (Send claim data,    |     | (Estimate, photos,|                  |
|  |  request estimate)   |     |  valuation, parts)|                  |
|  +---------------------+     +--------+----------+                  |
|                                       |                             |
|                              +--------v----------+                  |
|                              | Return Services    |                 |
|                              | - Estimate (EMS)   |                 |
|                              | - Photos           |                 |
|                              | - Valuation        |                 |
|                              | - Status updates   |                 |
|                              +-------------------+                  |
|                                                                     |
|  Data Formats:                                                     |
|  - BMS (Business Message Specification) - Industry standard        |
|  - EMS (Estimate Management Standard) - Estimate data exchange     |
|  - CIECA (Collision Industry Electronic Commerce Association)      |
|  - XML / JSON via REST APIs                                        |
|                                                                     |
+-------------------------------------------------------------------+
```

**Sample BMS Assignment Message:**

```xml
<BMS>
  <Assignment>
    <ClaimInfo>
      <ClaimNumber>CLM-2024-AUTO-0012345</ClaimNumber>
      <LossDate>2024-10-15</LossDate>
      <LossType>Collision</LossType>
      <LossDescription>Rear-end collision at intersection</LossDescription>
    </ClaimInfo>
    <VehicleInfo>
      <VIN>1HGCM82633A004352</VIN>
      <Year>2022</Year>
      <Make>Honda</Make>
      <Model>Accord</Model>
      <Trim>EX-L</Trim>
      <Mileage>28500</Mileage>
      <PreAccidentCondition>GOOD</PreAccidentCondition>
    </VehicleInfo>
    <OwnerInfo>
      <Name>John Smith</Name>
      <Phone>813-555-0123</Phone>
      <Email>john.smith@email.com</Email>
      <Address>
        <Street>456 Oak Lane</Street>
        <City>Tampa</City>
        <State>FL</State>
        <Zip>33602</Zip>
      </Address>
    </OwnerInfo>
    <AssignmentDetails>
      <AssignedTo>DRP_SHOP_001</AssignedTo>
      <AssignmentType>SUPPLEMENT</AssignmentType>
      <Priority>STANDARD</Priority>
      <InspectionType>ON_SITE</InspectionType>
    </AssignmentDetails>
  </Assignment>
</BMS>
```

### 3.2 Mitchell International

**Market Position:** Strong #2 in auto estimating, particularly in commercial auto and specialty lines.

**Products:**

| Product | Function |
|---------|----------|
| Mitchell WorkCenter | Claims workflow platform |
| Mitchell Estimating (UltraMate) | Auto damage estimation |
| Mitchell DecisionPoint | AI-based claims triage and routing |
| Mitchell Smart Advisors | Predictive analytics for claims |
| Mitchell TechAdvisor | Repair procedure guidance |
| Mitchell APD Solutions | Auto physical damage management |

### 3.3 Audatex/Solera

**Market Position:** Strong in international markets, growing U.S. presence. Part of Solera Holdings.

**Products:**

| Product | Function |
|---------|----------|
| Audatex Estimating | Auto damage estimation |
| Qapter (AI Estimating) | AI-powered damage assessment from photos |
| Audavin | Vehicle identification and build data |
| Solera Fleet Solutions | Fleet damage management |

### 3.4 Xactimate / Verisk

**Market Position:** Dominant in property damage estimation (95%+ market share for property claims estimating).

**Products:**

| Product | Function |
|---------|----------|
| Xactimate | Property damage estimation (desktop + mobile) |
| XactAnalysis | Assignment management and workflow |
| XactContents | Personal property/contents valuation |
| Xactware Roof IntelliScope | Aerial roof measurement |
| ClaimXperience | Policyholder self-service portal |
| Geomni | Aerial imagery and property data |

**Xactimate Integration:**

```
+-------------------------------------------------------------------+
|                 XACTIMATE INTEGRATION ARCHITECTURE                  |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | API / XactAnalysis Integration                              |
|       v                                                             |
|  +---------------------+                                           |
|  | XactAnalysis        |                                           |
|  | (Assignment Mgmt)    |                                           |
|  | - Create assignment  |                                           |
|  | - Route to adjuster  |                                           |
|  | - Track status       |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|             v                                                       |
|  +----------+----------+                                           |
|  | Xactimate (Field)   |                                           |
|  | - Sketch property    |                                           |
|  | - Room-by-room scope |                                           |
|  | - Line-item estimate |                                           |
|  | - Photo attachment   |                                           |
|  | - Price list (local) |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|             | Upload estimate                                       |
|             v                                                       |
|  +----------+----------+                                           |
|  | XactAnalysis        |                                           |
|  | - QA Review          |                                           |
|  | - Compliance check   |                                           |
|  | - Return to Claims   |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|             | Estimate data (XML/API)                               |
|             v                                                       |
|  Claims System                                                     |
|  - Import estimate amount                                          |
|  - Attach estimate document                                        |
|  - Update reserves                                                 |
|  - Trigger payment workflow                                        |
|                                                                     |
+-------------------------------------------------------------------+
```

**Xactimate Estimate Data Structure:**

```json
{
  "estimate": {
    "estimateId": "XM-2024-FL-045231",
    "claimNumber": "CLM-2024-0045231",
    "estimateType": "INITIAL",
    "priceListRegion": "FLTA",
    "priceListDate": "2024-10",
    "rooms": [
      {
        "roomName": "Master Bedroom",
        "roomType": "BEDROOM",
        "lineItems": [
          {
            "category": "RFG",
            "selector": "RFTEAR",
            "description": "Remove Comp. shingle roofing - 3 tab/pointed",
            "quantity": 24.5,
            "unit": "SQ",
            "unitPrice": 89.45,
            "total": 2191.53,
            "overheadAndProfit": false
          },
          {
            "category": "RFG",
            "selector": "RFSHGL",
            "description": "Comp. shingle roofing - 30 year - w/pointed",
            "quantity": 24.5,
            "unit": "SQ",
            "unitPrice": 298.76,
            "total": 7319.62,
            "overheadAndProfit": true
          }
        ]
      }
    ],
    "summary": {
      "rcv": 45231.89,
      "depreciation": 8756.23,
      "acv": 36475.66,
      "deductible": 2500.00,
      "netClaimRcv": 42731.89,
      "netClaimAcv": 33975.66,
      "overheadAndProfit": 6784.78,
      "tax": 0.00
    }
  }
}
```

---

## 4. Auto Body Repair Networks (DRP)

### DRP (Direct Repair Program) Overview

A DRP is a network of pre-approved body shops that have contractual agreements with insurers to repair damaged vehicles. These programs provide cost control, quality assurance, and faster cycle times.

### Shop Selection Algorithm

```
+------------------+     +-------------------+     +-------------------+
| Vehicle Location |     | Damage Severity   |     | Customer          |
| (GPS / address)  |     | (Estimate range,  |     | Preference        |
|                  |     |  photos, AI score) |     | (if any)          |
+--------+---------+     +--------+----------+     +--------+----------+
         |                         |                         |
         v                         v                         v
+--------+-------------------------+-------------------------+----------+
|                     SHOP SELECTION ENGINE                               |
|                                                                        |
|  1. Filter: Active DRP shops within radius (10-25 miles)              |
|  2. Filter: Shop certified for vehicle make (OEM certified)           |
|  3. Filter: Shop has capacity (current WIP < max WIP)                 |
|  4. Score: Performance scorecard (quality, cycle time, CSI)           |
|  5. Score: Proximity to customer                                      |
|  6. Score: Current utilization (prefer balanced distribution)         |
|  7. Score: Specialty match (luxury, EV, heavy hit, etc.)             |
|  8. Rank: Top 3 shops presented to customer                          |
|  9. Apply: Customer preference if provided                           |
+--------+----------------------------------------------------------+---+
         |                                                          |
         v                                                          v
+--------+----------+                                    +----------+---+
| Primary Shop      |                                    | Alternates   |
| Recommendation    |                                    | (2-3 options)|
+-------------------+                                    +--------------+
```

### DRP Performance Scorecard

| KPI | Weight | Calculation | Target |
|-----|--------|-------------|--------|
| Cycle time (keys-to-keys) | 20% | Avg calendar days from drop-off to pick-up | < 7 days |
| Customer satisfaction (CSI) | 25% | Post-repair survey score | > 4.5/5 |
| Supplement frequency | 15% | % of repairs with supplements | < 15% |
| Supplement severity | 10% | Avg supplement amount | < $500 |
| Come-back rate | 15% | % of vehicles returned within 30 days for same repair | < 2% |
| Cost variance | 10% | Actual vs. estimated repair cost | Within 5% |
| Touch time ratio | 5% | Active repair hours / total calendar hours | > 60% |

### DRP Agreement Data Model

```json
{
  "drpAgreement": {
    "agreementId": "DRP-2024-001234",
    "shopId": "SHOP-FL-Tampa-001",
    "shopName": "Premium Auto Body of Tampa",
    "shopAddress": {
      "street": "789 Industrial Blvd",
      "city": "Tampa",
      "state": "FL",
      "zip": "33610"
    },
    "agreementEffective": "2024-01-01",
    "agreementExpiration": "2025-12-31",
    "status": "ACTIVE",
    "contractTerms": {
      "laborRates": {
        "body": 52.00,
        "paint": 52.00,
        "frame": 56.00,
        "mechanical": 65.00,
        "aluminum": 58.00
      },
      "paintMaterials": {
        "method": "REFINISH_SYSTEM",
        "rate": 34.00,
        "unit": "PER_REFINISH_HOUR"
      },
      "partsDiscounts": {
        "aftermarket": "APPROVED_LIST",
        "recycled": "APPROVED_WITH_WARRANTY",
        "oem": "LIST_PRICE"
      },
      "warrantyPeriod": "LIFETIME_WORKMANSHIP",
      "slaRequirements": {
        "initialContact": "4_HOURS",
        "estimateCompletion": "24_HOURS",
        "repairStart": "48_HOURS_FROM_PARTS",
        "customerUpdate": "DAILY"
      }
    },
    "certifications": [
      "I-CAR_GOLD",
      "ASE_CERTIFIED",
      "HONDA_PROCERTIFIED",
      "TOYOTA_CERTIFIED"
    ],
    "capabilities": [
      "ALUMINUM_REPAIR",
      "EV_CERTIFIED",
      "ADAS_CALIBRATION",
      "FRAME_REPAIR"
    ],
    "capacity": {
      "maxSimultaneous": 35,
      "avgMonthlyVolume": 120,
      "currentWIP": 28
    },
    "performance": {
      "overallScore": 4.3,
      "cycleTimeDays": 5.8,
      "csiScore": 4.6,
      "supplementRate": 0.12,
      "comebackRate": 0.015
    }
  }
}
```

---

## 5. Rental Car Management

### Rental Integration Architecture

```
+-------------------------------------------------------------------+
|                  RENTAL CAR INTEGRATION                             |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | 1. Rental Authorization Request                             |
|       |    (Claim #, coverage, authorized days, class)              |
|       v                                                             |
|  +---------------------+                                           |
|  | Rental API Gateway   |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+--------+                                   |
|    |                  |        |                                    |
|    v                  v        v                                    |
| Enterprise         Hertz     Avis                                  |
| ARMS API           API       API                                   |
|    |                  |        |                                    |
|    v                  v        v                                    |
| 2. Reservation created, confirmation returned                      |
| 3. Rental status updates (extended, returned, etc.)                |
| 4. Direct billing invoice (daily/weekly)                           |
| 5. Final invoice at return                                         |
|                                                                     |
|  Direct Billing Data Flow:                                         |
|  +---------------------+     +---------------------+               |
|  | Rental Vendor        |---->| Claims System       |               |
|  | Invoice (daily/      |     | - Validate auth     |               |
|  |  weekly batch)       |     | - Match to claim    |               |
|  |                      |     | - Check limits      |               |
|  |                      |     | - Auto-pay or       |               |
|  |                      |     |   queue for review  |               |
|  +---------------------+     +---------------------+               |
|                                                                     |
+-------------------------------------------------------------------+
```

### Rental Authorization Data Model

```json
{
  "rentalAuthorization": {
    "authId": "RENT-AUTH-2024-0012345",
    "claimNumber": "CLM-2024-AUTO-0012345",
    "coverageType": "RENTAL_REIMBURSEMENT",
    "dailyLimit": 50.00,
    "maxDays": 30,
    "maxTotal": 1500.00,
    "vehicleClass": "INTERMEDIATE",
    "rentalVendor": "ENTERPRISE",
    "pickupLocation": "ENTERPRISE_TAMPA_DALE_MABRY",
    "pickupDate": "2024-10-16",
    "estimatedReturnDate": "2024-10-30",
    "status": "ACTIVE",
    "extensions": [
      {
        "extensionDate": "2024-10-28",
        "additionalDays": 7,
        "reason": "PARTS_DELAY",
        "authorizedBy": "ADJ-456"
      }
    ],
    "billing": {
      "method": "DIRECT_BILL",
      "invoices": [
        {
          "invoiceNumber": "ENT-INV-2024-78901",
          "periodStart": "2024-10-16",
          "periodEnd": "2024-10-22",
          "days": 7,
          "dailyRate": 42.99,
          "subtotal": 300.93,
          "taxes": 21.07,
          "total": 322.00,
          "status": "PAID"
        }
      ]
    }
  }
}
```

---

## 6. Salvage Vendors

### 6.1 Copart

**Overview:** Copart is the largest U.S. vehicle salvage auction company, operating 200+ locations. Founded in 1982, Copart processes millions of vehicles annually through its online auction platform (VB3).

### 6.2 IAA (Insurance Auto Auctions)

**Overview:** IAA is the second-largest U.S. salvage auction company, acquired by Ritchie Bros. in 2023. IAA operates 200+ locations.

### Salvage Integration Architecture

```
+-------------------------------------------------------------------+
|                  SALVAGE VENDOR INTEGRATION                         |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | 1. Total Loss Declaration                                   |
|       |    - Vehicle details (VIN, condition)                       |
|       |    - Salvage value estimate                                 |
|       |    - Title status                                           |
|       |    - Location of vehicle                                    |
|       v                                                             |
|  +---------------------+                                           |
|  | Salvage Assignment   |                                           |
|  | Service              |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+                                            |
|    |                  |                                             |
|    v                  v                                             |
|  Copart API        IAA API                                         |
|    |                  |                                             |
|    v                  v                                             |
|  2. Vehicle pickup scheduled                                       |
|  3. Vehicle received at auction location                           |
|  4. Vehicle listed for auction                                     |
|  5. Auction complete - sale price returned                         |
|  6. Title transfer initiated                                       |
|  7. Settlement and payment                                         |
|                                                                     |
|  Key Data Exchanges:                                               |
|  +-----------------+     +-------------------+                     |
|  | Assignment      |     | Auction Result    |                     |
|  | - VIN           |     | - Sale price      |                     |
|  | - Claim #       |     | - Buyer info      |                     |
|  | - Location      |     | - Fees            |                     |
|  | - Title status  |     | - Net proceeds    |                     |
|  | - Condition     |     | - Title status    |                     |
|  | - Damage desc   |     | - Settlement date |                     |
|  +-----------------+     +-------------------+                     |
|                                                                     |
+-------------------------------------------------------------------+
```

### Title Transfer Process

```
1. Carrier obtains title from policyholder (part of total loss settlement)
2. Carrier assigns title to salvage vendor
3. Salvage vendor re-titles to buyer after auction
4. State-specific requirements:
   - Branded title (salvage, rebuilt, flood)
   - NMVTIS reporting
   - Junk certificate (non-rebuildable)
```

### Salvage Data Model

```json
{
  "salvageAssignment": {
    "assignmentId": "SAL-2024-0012345",
    "claimNumber": "CLM-2024-AUTO-0012345",
    "salvageVendor": "COPART",
    "vehicle": {
      "vin": "1HGCM82633A004352",
      "year": 2022,
      "make": "Honda",
      "model": "Accord",
      "trim": "EX-L",
      "mileage": 28500,
      "color": "Blue",
      "titleState": "FL",
      "titleStatus": "CLEAN"
    },
    "damageInfo": {
      "primaryDamage": "REAR_END",
      "secondaryDamage": "UNDERCARRIAGE",
      "doesRun": true,
      "doesDrive": false,
      "hasKeys": true,
      "airbagDeployed": true,
      "damagePercentage": 78
    },
    "pickupInfo": {
      "location": "456 Oak Lane, Tampa, FL 33602",
      "contactName": "John Smith",
      "contactPhone": "813-555-0123",
      "pickupRequestDate": "2024-10-20",
      "pickupCompletedDate": "2024-10-22",
      "lotNumber": "COPART-TAMPA-LOT-789"
    },
    "auctionInfo": {
      "listingDate": "2024-10-28",
      "auctionDate": "2024-11-05",
      "auctionType": "ONLINE",
      "startingBid": 5000.00,
      "salePrice": 8750.00,
      "buyerName": "AutoParts Inc",
      "buyerLocation": "Miami, FL",
      "fees": {
        "auctionFee": 350.00,
        "storageFee": 75.00,
        "towFee": 125.00,
        "titleFee": 50.00,
        "totalFees": 600.00
      },
      "netProceeds": 8150.00,
      "settlementDate": "2024-11-15"
    }
  }
}
```

---

## 7. Independent Adjuster (IA) Firms

### Major IA Firms

| Firm | Employees/Network | Specialties | Key Clients |
|------|------------------|-------------|-------------|
| Crawford & Company | 9,000+ | Multi-line, international, TPA | Large commercial, specialty |
| Sedgwick | 30,000+ | WC, liability, property, TPA | Fortune 500, large carriers |
| McLarens | 2,000+ | Complex property, marine, construction | Specialty, London market |
| EFI Global | 800+ | Forensic engineering, environmental | Complex property, environmental |
| Pilot Catastrophe | 3,000+ | CAT property, residential | Personal lines carriers |
| Eberl Claims | 5,000+ | Multi-line, daily, CAT | Mid-market carriers |
| Engle Martin | 500+ | Complex commercial, environmental | Specialty, E&S |

### Assignment Management Integration

```
+-------------------------------------------------------------------+
|              IA ASSIGNMENT MANAGEMENT ARCHITECTURE                   |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | Create Assignment                                           |
|       | (Claim data, scope, authority, deadline)                    |
|       v                                                             |
|  +---------------------+                                           |
|  | Assignment Router    |                                           |
|  | (Rules engine)       |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+--------+--------+                          |
|    |        |         |        |        |                          |
|    v        v         v        v        v                          |
| Crawford  Sedgwick  McLarens  Pilot   Eberl                       |
|    |        |         |        |        |                          |
|    v        v         v        v        v                          |
|  +---------------------------------------------+                  |
|  | Common Assignment Protocol (XactAnalysis /   |                  |
|  | ClaimXperience / Custom API)                 |                  |
|  +---------------------------------------------+                  |
|                                                                     |
|  Assignment Routing Rules:                                         |
|  1. Claim type → IA firm specialization match                      |
|  2. Geographic coverage area → nearest qualified adjuster          |
|  3. Severity tier → authority level match                          |
|  4. Current workload → capacity balancing                          |
|  5. Performance history → quality routing                          |
|  6. Cost → fee schedule optimization                               |
|  7. Contractual volume commitments                                 |
|                                                                     |
+-------------------------------------------------------------------+
```

### IA Performance Management

| KPI | Description | Target | Measurement |
|-----|-------------|--------|-------------|
| Contact time | Time from assignment to first insured contact | < 24 hours | Timestamp in assignment system |
| Inspection time | Time from assignment to inspection completion | < 3 days (standard), < 24 hrs (CAT P1) | Timestamp in assignment system |
| Estimate accuracy | Supplement rate and supplement amount | < 15% supplement rate | Supplement tracking |
| Report quality | Completeness, accuracy, documentation | > 4.0/5 score | QA review sampling |
| Customer satisfaction | Insured satisfaction with adjuster | > 4.0/5 score | Post-inspection survey |
| Cycle time | Assignment to report submission | < 5 days | Timestamp difference |
| Photo quality | Sufficient, clear, properly labeled photos | Pass rate > 95% | QA review |
| Compliance | Licensing, CE, regulatory requirements | 100% compliant | License verification |

---

## 8. Legal Service Providers

### Legal Services Ecosystem

```
+-------------------------------------------------------------------+
|                  LEGAL SERVICES ECOSYSTEM                           |
+-------------------------------------------------------------------+
|                                                                     |
|  PANEL COUNSEL (Defense Attorneys)                                 |
|  +-------------------------------------------------------------+  |
|  | - Selected by carrier based on jurisdiction, specialty       |  |
|  | - Typically 3-5 firms per jurisdiction per specialty          |  |
|  | - Coverage litigation, liability defense, bad faith defense  |  |
|  | - Managed through litigation management guidelines           |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  LITIGATION MANAGEMENT                                             |
|  +-------------------------------------------------------------+  |
|  | - Case strategy development and approval                     |  |
|  | - Budget management and approval                             |  |
|  | - Discovery management                                      |  |
|  | - Expert witness management                                 |  |
|  | - Trial preparation oversight                               |  |
|  | - Settlement authority management                            |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  E-BILLING                                                         |
|  +-------------------------------------------------------------+  |
|  | - UTBMS (Uniform Task-Based Management System) coding        |  |
|  | - LEDES (Legal Electronic Data Exchange Standard) format      |  |
|  | - Automated bill review rules                               |  |
|  | - Rate and staffing compliance                              |  |
|  | - Vendors: Legal Tracker (Thomson Reuters), CounselLink     |  |
|  |   (LexisNexis), Wolters Kluwer, Brightflag                 |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

### UTBMS Code Standards

UTBMS (Uniform Task-Based Management System) codes standardize legal billing:

**Litigation Phases:**

| Phase Code | Phase | Description |
|-----------|-------|-------------|
| L100 | Case Assessment | Initial case evaluation and strategy |
| L200 | Pre-Trial Pleadings | Complaints, answers, motions |
| L300 | Interrogatories | Written discovery |
| L400 | Document Production | Document review and production |
| L500 | Depositions | Depositions of all parties |
| L600 | Settlement/Non-Binding ADR | Mediation, settlement negotiations |
| L700 | Court Motions | Dispositive and non-dispositive motions |
| L800 | Trial Preparation | Pre-trial preparation and trial |
| L900 | Trial | Actual trial proceedings |
| L1000 | Appeal | Appellate proceedings |

**Activity Codes (Examples):**

| Activity Code | Description |
|--------------|-------------|
| A101 | Plan and prepare for - conference, meeting, call |
| A102 | Research |
| A103 | Draft/revise - legal documents |
| A104 | Review/analyze - documents, evidence |
| A105 | Communicate (in writing) |
| A106 | Communicate (orally) |
| A107 | Court hearing / court appearance |
| A108 | Inspect/investigate |
| A109 | Negotiate |

### Legal Bill Review Automation

```json
{
  "legalInvoice": {
    "invoiceId": "LGL-INV-2024-78901",
    "claimNumber": "CLM-2024-LIT-001234",
    "lawFirm": "Smith & Jones LLP",
    "invoicePeriod": "2024-10-01 to 2024-10-31",
    "format": "LEDES_98BI",
    "lineItems": [
      {
        "date": "2024-10-05",
        "timekeeper": "J. Smith (Partner)",
        "rate": 450.00,
        "hours": 2.5,
        "amount": 1125.00,
        "utbmsPhase": "L300",
        "utbmsActivity": "A104",
        "description": "Review and analyze plaintiff discovery responses"
      },
      {
        "date": "2024-10-12",
        "timekeeper": "A. Johnson (Associate)",
        "rate": 275.00,
        "hours": 4.0,
        "amount": 1100.00,
        "utbmsPhase": "L400",
        "utbmsActivity": "A103",
        "description": "Draft privilege log for document production"
      }
    ],
    "expenses": [
      {
        "date": "2024-10-15",
        "expenseCode": "E101",
        "description": "Court filing fee",
        "amount": 350.00
      }
    ],
    "summary": {
      "totalFees": 8750.00,
      "totalExpenses": 1200.00,
      "totalInvoice": 9950.00,
      "autoReviewResults": {
        "violations": [
          {
            "type": "BLOCK_BILLING",
            "description": "Entry on 10/08 combines multiple tasks in single entry",
            "lineItemIndex": 3,
            "suggestedAction": "REQUEST_BREAKDOWN"
          },
          {
            "type": "RATE_EXCEEDED",
            "description": "Partner rate exceeds approved rate ($450 vs $425 approved)",
            "lineItemIndex": 0,
            "suggestedAction": "ADJUST_TO_APPROVED_RATE"
          }
        ],
        "suggestedAdjustment": -312.50,
        "adjustedTotal": 9637.50
      }
    }
  }
}
```

---

## 9. Medical Management Vendors

### Medical Bill Review

Medical bill review vendors analyze medical bills for accuracy and appropriateness in liability/BI claims and workers' compensation:

| Vendor | Specialty | Key Features |
|--------|-----------|-------------|
| Mitchell (Coventry) | WC, auto BI | PPO networks, fee schedule compliance |
| Conduent | WC, auto BI | Bill review, utilization review |
| Rising Medical Solutions | Auto BI, WC | Nurse case management, bill review |
| Optum (UnitedHealth) | WC, auto BI | Clinical review, pharmacy management |
| EK Health | WC | Utilization review, peer review |

### Medical Management Integration

```
+-------------------------------------------------------------------+
|              MEDICAL MANAGEMENT INTEGRATION                         |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | Medical bill received                                       |
|       v                                                             |
|  +---------------------+                                           |
|  | Bill Ingestion       |                                           |
|  | (Paper → OCR → Data) |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Bill Review Engine   |                                           |
|  | (Fee schedule,       |                                           |
|  |  UCR, PPO discount)  |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Clinical Review      |                                           |
|  | (Medical necessity,  |                                           |
|  |  treatment relation) |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Explanation of       |                                           |
|  | Review (EOR)         |                                           |
|  | Generated            |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Payment              |                                           |
|  | Recommendation       |                                           |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 10. Fraud Detection Vendors

### Vendor Comparison

| Vendor | Technology | Approach | Integration | Deployment |
|--------|-----------|----------|-------------|------------|
| Shift Technology | AI/ML (deep learning) | Claims fraud scoring, SIU case management | REST API, real-time | Cloud SaaS |
| FRISS | AI/ML, rules | Real-time fraud scoring, network analysis | REST API, real-time | Cloud SaaS |
| SAS (Institute) | Advanced analytics, ML | Fraud analytics, text mining, network analysis | Batch + API | On-premise, cloud |
| BAE Systems (NetReveal) | Network analytics, ML | Social network analysis, organized fraud rings | API, batch | On-premise, cloud |
| Verisk (ClaimSearch) | Data matching, analytics | Cross-carrier claim matching, duplicate detection | Batch file, API | SaaS |
| LexisNexis | Data analytics, link analysis | Identity verification, claims history | API | SaaS |

### Fraud Detection Integration Pattern

```
+-------------------------------------------------------------------+
|              FRAUD DETECTION INTEGRATION                            |
+-------------------------------------------------------------------+
|                                                                     |
|  FNOL Created / Claim Updated                                      |
|       |                                                             |
|       | Event published to message bus                              |
|       v                                                             |
|  +---------------------+                                           |
|  | Fraud Scoring        |                                           |
|  | Service              |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+---------+                                  |
|    |        |         |         |                                  |
|    v        v         v         v                                  |
|  Shift   FRISS    ClaimSearch  Internal                            |
|  API     API      API         Rules                                |
|    |        |         |         |                                  |
|    v        v         v         v                                  |
|  +----------+---------+---------+----------+                       |
|  | Score Aggregation & Decision Engine     |                       |
|  |                                         |                       |
|  | Combined score = w1*Shift + w2*FRISS    |                       |
|  |                + w3*ClaimSearch          |                       |
|  |                + w4*InternalRules        |                       |
|  |                                         |                       |
|  | IF score > 80 THEN refer to SIU         |                       |
|  | IF score 50-80 THEN flag for review     |                       |
|  | IF score < 50 THEN normal processing    |                       |
|  +-----------------------------------------+                       |
|             |                                                       |
|             v                                                       |
|  Claims System: Update fraud score, trigger workflow               |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 11. Data & Analytics Providers

### 11.1 ISO/Verisk

| Product | Purpose | Data |
|---------|---------|------|
| ClaimSearch | Cross-carrier claim matching | 1.5B+ claim records, cross-reference |
| ISO ClaimSearch Analytics | Fraud indicators, claim patterns | Scoring, alerts |
| Property Estimating Solutions | Xactimate pricing, aerial data | Repair cost data |
| PCS (Property Claim Services) | Catastrophe designation | CAT bulletins, loss estimates |
| Geomni | Aerial imagery, property data | Roof measurement, property characteristics |
| LOCATION | Location-based risk scoring | Geocoded risk data |

### 11.2 LexisNexis Risk Solutions

| Product | Purpose | Data |
|---------|---------|------|
| CLUE (Comprehensive Loss Underwriting Exchange) | Claims history by person/property | 7-year claims history |
| C.L.U.E. Auto | Vehicle claims history | Auto claims by VIN, driver |
| C.L.U.E. Property | Property claims history | Property claims by address |
| Current Carrier | Identify current insurance carrier | Carrier identification |
| MVR (Motor Vehicle Reports) | Driving record | Violations, accidents, suspensions |
| Criminal Records | Criminal background | Public record criminal history |
| People Search | Identity verification | Address history, associates, SSN |

### 11.3 TransUnion

| Product | Purpose | Data |
|---------|---------|------|
| TrueVision | Claims analytics, fraud detection | Identity, claims, public records |
| DriverRisk | Driver risk scoring | Driving behavior, violations |
| Property Data | Property characteristics | Building details, valuations |

### 11.4 CoreLogic

| Product | Purpose | Data |
|---------|---------|------|
| Weather Verification | Match weather to claim location | MEWS (Mapped Event Weather Service) |
| Property Data | Building characteristics | Construction, age, features |
| Wildfire Risk | Wildfire exposure scoring | WildFire Risk Score |
| Flood Risk | Flood exposure scoring | Flood risk data, FEMA maps |
| Reconstruction Cost | Replacement cost estimating | Cost data by location |

### ClaimSearch Integration

```json
{
  "claimSearchRequest": {
    "searchType": "COMPREHENSIVE",
    "searchSubject": {
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1985-03-15",
      "ssn": "XXX-XX-1234",
      "address": {
        "street": "456 Oak Lane",
        "city": "Tampa",
        "state": "FL",
        "zip": "33602"
      }
    },
    "vehicleInfo": {
      "vin": "1HGCM82633A004352"
    },
    "claimInfo": {
      "claimNumber": "CLM-2024-AUTO-0012345",
      "lossDate": "2024-10-15",
      "lossType": "COLLISION"
    },
    "requestedReports": [
      "PRIOR_CLAIMS",
      "FRAUD_INDICATORS",
      "CROSS_CARRIER_MATCH"
    ]
  }
}
```

**ClaimSearch Response:**

```json
{
  "claimSearchResponse": {
    "requestId": "CS-2024-78901234",
    "searchDate": "2024-10-16",
    "priorClaims": [
      {
        "claimDate": "2023-05-20",
        "claimType": "COLLISION",
        "carrier": "CARRIER_B",
        "status": "CLOSED",
        "paidAmount": 4500.00,
        "vehicle": "2022 Honda Accord",
        "injuryClaimed": false
      },
      {
        "claimDate": "2021-11-12",
        "claimType": "COMPREHENSIVE",
        "carrier": "CARRIER_C",
        "status": "CLOSED",
        "paidAmount": 1200.00,
        "vehicle": "2020 Honda Civic",
        "injuryClaimed": false
      }
    ],
    "fraudIndicators": {
      "overallScore": 22,
      "maxScore": 100,
      "riskLevel": "LOW",
      "indicators": [
        {
          "indicator": "PRIOR_CLAIMS_FREQUENCY",
          "score": 15,
          "detail": "2 prior claims in 3 years"
        },
        {
          "indicator": "LOSS_TYPE_PATTERN",
          "score": 7,
          "detail": "Multiple collision claims"
        }
      ]
    },
    "crossCarrierMatches": 0
  }
}
```

### CLUE Report Integration

```json
{
  "clueReport": {
    "reportType": "AUTO",
    "subjectVin": "1HGCM82633A004352",
    "subjectName": "John Smith",
    "reportDate": "2024-10-16",
    "claimsHistory": [
      {
        "dateOfLoss": "2023-05-20",
        "claimType": "COLLISION",
        "carrierName": "ABC Insurance",
        "policyType": "PERSONAL_AUTO",
        "amountPaid": 4500.00,
        "status": "CLOSED",
        "atFault": true,
        "bodilyInjury": false,
        "vehicle": {
          "vin": "1HGCM82633A004352",
          "year": 2022,
          "make": "Honda",
          "model": "Accord"
        }
      }
    ],
    "inquiries": [
      {
        "date": "2024-01-15",
        "type": "NEW_BUSINESS",
        "carrier": "DEF Insurance"
      }
    ]
  }
}
```

---

## 12. Document Management Vendors

### Platform Comparison

| Vendor | Platform | Strengths | Claims Focus | Deployment |
|--------|----------|-----------|-------------|------------|
| Hyland (OnBase) | OnBase | Enterprise content mgmt, workflow | Strong insurance vertical | On-prem, cloud |
| IBM (FileNet) | FileNet P8 | Scalability, compliance, governance | Enterprise-grade | On-prem, cloud |
| Alfresco (Hyland) | Alfresco | Open source, modern API | Flexible integration | On-prem, cloud |
| Microsoft | SharePoint | Collaboration, Microsoft ecosystem | General purpose | Cloud (M365) |
| Box | Box Platform | Cloud-native, collaboration | API-first integration | Cloud SaaS |
| Nuxeo (Hyland) | Nuxeo Platform | Modern architecture, headless CMS | API-first | Cloud |
| DocuSign | DocuSign Agreement Cloud | Digital signatures, workflows | E-signature focus | Cloud SaaS |

---

## 13. Payment Platforms

### Payment Platform Comparison

| Vendor | Specialty | Payment Methods | Integration |
|--------|-----------|----------------|-------------|
| One Inc | Insurance-specific payments | Check, ACH, virtual card, real-time | REST API, Guidewire certified |
| VPay (Optum) | Insurance claims payments | Virtual card, ACH, check | REST API, claims system integration |
| CheckFreePay (Fiserv) | Insurance payments | Check, ACH, card | Batch + API |

### Payment Integration Architecture

```
+-------------------------------------------------------------------+
|              PAYMENT PLATFORM INTEGRATION                           |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System (Payment Approved)                                  |
|       |                                                             |
|       | Payment request                                             |
|       | (Payee, amount, method, claim, coverage)                    |
|       v                                                             |
|  +---------------------+                                           |
|  | Payment Gateway      |                                           |
|  | (One Inc / VPay)     |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+---------+---------+                        |
|    |        |         |         |         |                        |
|    v        v         v         v         v                        |
|  ACH     Virtual   Physical  Real-time  Wire                      |
|  Direct  Card      Check     Payment   Transfer                   |
|  Deposit            Print     (Zelle,   (Large                     |
|                     & Mail    Venmo)    amounts)                   |
|    |        |         |         |         |                        |
|    v        v         v         v         v                        |
|  +---------------------------------------------+                  |
|  | Payment Status Tracking                      |                  |
|  | - Initiated                                  |                  |
|  | - Processing                                 |                  |
|  | - Sent / Deposited                           |                  |
|  | - Cleared / Cashed                           |                  |
|  | - Returned / Failed                          |                  |
|  | - Voided / Stopped                           |                  |
|  +---------------------------------------------+                  |
|             |                                                       |
|             v                                                       |
|  Claims System: Payment status update, reconciliation              |
|                                                                     |
+-------------------------------------------------------------------+
```

### Payment Data Model

```json
{
  "paymentRequest": {
    "paymentId": "PAY-2024-0045231-001",
    "claimNumber": "CLM-2024-0045231",
    "paymentType": "INDEMNITY",
    "coverageType": "COVERAGE_A_DWELLING",
    "costType": "CLAIM_COST",
    "costCategory": "STRUCTURAL_REPAIR",
    "payee": {
      "payeeType": "INSURED",
      "name": "John Smith",
      "taxId": "XXX-XX-1234",
      "address": {
        "street": "456 Oak Lane",
        "city": "Tampa",
        "state": "FL",
        "zip": "33602"
      }
    },
    "additionalPayees": [
      {
        "payeeType": "MORTGAGEE",
        "name": "First National Bank",
        "accountNumber": "MORT-123456"
      }
    ],
    "amount": {
      "gross": 42731.89,
      "deductible": 2500.00,
      "priorPayments": 0.00,
      "net": 40231.89
    },
    "paymentMethod": {
      "preferred": "ACH_DIRECT_DEPOSIT",
      "achDetails": {
        "routingNumber": "XXXXXX789",
        "accountNumber": "XXXXX4567",
        "accountType": "CHECKING"
      }
    },
    "approvalChain": [
      {
        "approver": "ADJ-456",
        "level": 1,
        "status": "APPROVED",
        "date": "2024-10-25",
        "authorityLimit": 50000.00
      }
    ],
    "scheduledDate": "2024-10-26",
    "status": "APPROVED_PENDING_DISBURSEMENT"
  }
}
```

---

## 14. Telematics Providers

### Telematics Integration for Claims

| Provider | Technology | Claims Use Cases |
|----------|-----------|-----------------|
| Cambridge Mobile Telematics (CMT) | Smartphone sensors, OBD | Crash detection, FNOL automation, reconstruction |
| Arity (Allstate) | Smartphone + connected car | Driving score, crash detection, risk |
| Octo Telematics | OBD, smartphone, connected car | Crash detection, FNOL, fraud detection |
| Verisk (Telematics Data Exchange) | Aggregation platform | Cross-carrier telematics data exchange |
| Zendrive | Smartphone sensors | Crash detection, driving analysis |

### Telematics FNOL Automation

```
+-------------------------------------------------------------------+
|              TELEMATICS CRASH DETECTION FLOW                        |
+-------------------------------------------------------------------+
|                                                                     |
|  1. Crash Event Detected                                           |
|     (Accelerometer spike + GPS + speed data)                       |
|       |                                                             |
|       v                                                             |
|  2. Crash Severity Assessment                                      |
|     (G-force magnitude, delta-V, impact direction)                 |
|       |                                                             |
|       +-- Minor (< 10 mph delta-V): Notify driver, offer FNOL     |
|       |                                                             |
|       +-- Moderate (10-25 mph): Push FNOL, notify carrier          |
|       |                                                             |
|       +-- Severe (> 25 mph): Auto-FNOL, notify emergency,         |
|           notify carrier immediately                               |
|       |                                                             |
|       v                                                             |
|  3. Data Package Created                                           |
|     {                                                              |
|       "crashTime": "2024-10-15T14:32:18Z",                        |
|       "location": { "lat": 27.9506, "lng": -82.4572 },           |
|       "speed": 35,                                                 |
|       "deltaV": 22,                                                |
|       "maxGForce": 8.5,                                           |
|       "impactDirection": "FRONT_LEFT",                             |
|       "airbagDeployed": true,                                      |
|       "preImpactBraking": true,                                    |
|       "preImpactSpeed": 38                                         |
|     }                                                              |
|       |                                                             |
|       v                                                             |
|  4. Auto-FNOL Creation in Claims System                            |
|       |                                                             |
|       v                                                             |
|  5. Adjuster receives pre-populated claim with telematics data     |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 15. Drone & Aerial Imagery Providers

### Provider Comparison

| Provider | Technology | Coverage | Resolution | Claims Use |
|----------|-----------|----------|-----------|-----------|
| EagleView | Fixed-wing aircraft, drone | 95% of U.S. properties | Sub-inch | Roof measurement, property data |
| Nearmap | Fixed-wing aircraft | Major metro areas | 2.8 inch | Property inspection, change detection |
| Betterview | Satellite + AI | Nationwide | Variable | Roof condition, property risk |
| Cape Analytics | Satellite + AI | Nationwide | Variable | Property attributes, risk scoring |
| Geomni (Verisk) | Aircraft, drone | U.S. coverage | Sub-inch | Roof measurement, claims |

### Aerial Imagery Integration

```json
{
  "aerialImageryRequest": {
    "requestId": "AIR-2024-0012345",
    "claimNumber": "CLM-2024-0045231",
    "propertyAddress": "123 Ocean Drive, Tampa, FL 33701",
    "coordinates": {
      "latitude": 27.7676,
      "longitude": -82.6403
    },
    "requestType": "ROOF_MEASUREMENT",
    "provider": "EAGLEVIEW",
    "products": [
      "ROOF_REPORT",
      "WALL_MEASUREMENT",
      "PROPERTY_IMAGERY"
    ]
  }
}
```

**Aerial Roof Report Response:**

```json
{
  "roofReport": {
    "reportId": "EV-RPT-2024-456789",
    "propertyAddress": "123 Ocean Drive, Tampa, FL 33701",
    "reportDate": "2024-10-18",
    "measurements": {
      "totalRoofArea": {
        "squares": 24.5,
        "sqFt": 2450
      },
      "facets": [
        {
          "facetId": "F1",
          "area": 850,
          "pitch": "6/12",
          "orientation": "SOUTH",
          "material": "ARCHITECTURAL_SHINGLE"
        },
        {
          "facetId": "F2",
          "area": 720,
          "pitch": "6/12",
          "orientation": "NORTH",
          "material": "ARCHITECTURAL_SHINGLE"
        }
      ],
      "ridgeLength": 62,
      "hipLength": 48,
      "rakeLength": 84,
      "eaveLength": 96,
      "valleyLength": 35,
      "flashingLength": 22,
      "stories": 2,
      "roofHeight": 24
    },
    "imagery": {
      "topDown": "https://imagery.eagleview.com/EV-2024-456789/top.jpg",
      "oblique": [
        "https://imagery.eagleview.com/EV-2024-456789/north.jpg",
        "https://imagery.eagleview.com/EV-2024-456789/south.jpg",
        "https://imagery.eagleview.com/EV-2024-456789/east.jpg",
        "https://imagery.eagleview.com/EV-2024-456789/west.jpg"
      ]
    }
  }
}
```

---

## 16. Vendor Management Framework

### Vendor Lifecycle

```
+-------------------------------------------------------------------+
|                   VENDOR MANAGEMENT LIFECYCLE                       |
+-------------------------------------------------------------------+
|                                                                     |
|  1. IDENTIFICATION & SELECTION                                     |
|     +----------------------------------------------------------+  |
|     | - RFP/RFI process                                         |  |
|     | - Capability assessment                                   |  |
|     | - Reference checks                                        |  |
|     | - POC/Pilot                                               |  |
|     | - Financial stability review                               |  |
|     | - Security assessment (SOC 2, penetration test)            |  |
|     +----------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  2. CONTRACTING                                                    |
|     +----------------------------------------------------------+  |
|     | - Master Service Agreement (MSA)                           |  |
|     | - Service Level Agreement (SLA)                            |  |
|     | - Data Processing Agreement (DPA)                          |  |
|     | - Business Associate Agreement (BAA) if PHI               |  |
|     | - Non-Disclosure Agreement (NDA)                           |  |
|     | - Insurance requirements                                   |  |
|     | - Pricing/fee schedule                                     |  |
|     +----------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  3. ONBOARDING                                                     |
|     +----------------------------------------------------------+  |
|     | - Technical integration setup                              |  |
|     | - API credentials provisioning                             |  |
|     | - Data connectivity testing                                |  |
|     | - User access provisioning                                 |  |
|     | - Training                                                 |  |
|     | - Pilot claims/transactions                                |  |
|     | - Go-live approval                                         |  |
|     +----------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  4. ONGOING MANAGEMENT                                             |
|     +----------------------------------------------------------+  |
|     | - SLA monitoring and reporting                             |  |
|     | - Performance scorecard (monthly/quarterly)                |  |
|     | - Invoice processing and reconciliation                   |  |
|     | - Issue/incident management                               |  |
|     | - Quarterly business reviews (QBR)                        |  |
|     | - Annual contract review                                  |  |
|     +----------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  5. OFFBOARDING (if needed)                                        |
|     +----------------------------------------------------------+  |
|     | - Transition plan                                          |  |
|     | - Data migration / extraction                              |  |
|     | - Knowledge transfer                                       |  |
|     | - Contract termination                                     |  |
|     | - Access revocation                                        |  |
|     | - Final settlement                                         |  |
|     +----------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

### SLA Management

| SLA Category | Metric | Measurement | Target |
|-------------|--------|-------------|--------|
| Availability | System uptime | Monthly uptime percentage | 99.9% |
| Performance | API response time | P95 latency | < 500ms |
| Support | Severity 1 response | Time to first response | < 1 hour |
| Support | Severity 2 response | Time to first response | < 4 hours |
| Processing | Assignment acceptance | Time to accept assignment | < 2 hours |
| Processing | Estimate delivery | Time from assignment to estimate | < 48 hours |
| Quality | Error rate | Errors per 1,000 transactions | < 5 |
| Security | Incident notification | Time to notify of breach | < 24 hours |

---

## 17. Vendor Integration Architecture

### Integration Patterns

```
+===================================================================+
|              VENDOR INTEGRATION ARCHITECTURE                        |
+===================================================================+
|                                                                     |
|  PATTERN 1: API-FIRST (Real-time)                                  |
|  +-------------------------------------------------------------+  |
|  | Claims System <--REST API--> Vendor System                   |  |
|  | - Synchronous request/response                               |  |
|  | - Best for: real-time scoring, data lookup, status checks    |  |
|  | - Examples: fraud scoring, ClaimSearch, payment initiation   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 2: EVENT-DRIVEN (Asynchronous)                            |
|  +-------------------------------------------------------------+  |
|  | Claims System --Event--> Message Bus --Event--> Vendor       |  |
|  | Vendor --Response Event--> Message Bus --> Claims System     |  |
|  | - Asynchronous, decoupled                                    |  |
|  | - Best for: assignments, notifications, status updates       |  |
|  | - Examples: IA assignment, salvage dispatch, rental auth     |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 3: FILE-BASED (Batch)                                     |
|  +-------------------------------------------------------------+  |
|  | Claims System --File--> SFTP/S3 --> Vendor System            |  |
|  | Vendor System --File--> SFTP/S3 --> Claims System            |  |
|  | - Scheduled batch processing                                 |  |
|  | - Best for: bulk data exchange, reporting, reconciliation    |  |
|  | - Examples: bordereaux, payment files, reinsurance reports   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 4: WEBHOOK (Push Notification)                            |
|  +-------------------------------------------------------------+  |
|  | Vendor System --HTTP POST--> Claims Webhook Endpoint         |  |
|  | - Real-time push from vendor to carrier                      |  |
|  | - Best for: status updates, alerts, completion notices       |  |
|  | - Examples: estimate complete, payment cleared, auction sold |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### Integration Hub Architecture

```
+-------------------------------------------------------------------+
|                   INTEGRATION HUB (iPaaS)                          |
+-------------------------------------------------------------------+
|                                                                     |
|  +---------------------+                                           |
|  | Claims System       |                                           |
|  | (Guidewire, etc.)   |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | API Gateway          |                                           |
|  | (Kong / Apigee /     |                                           |
|  |  AWS API Gateway)    |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Integration Hub      |                                           |
|  | (MuleSoft / Dell     |                                           |
|  |  Boomi / Workato)    |                                           |
|  |                      |                                           |
|  | Functions:           |                                           |
|  | - Message routing    |                                           |
|  | - Data transformation|                                           |
|  | - Protocol mediation |                                           |
|  | - Error handling     |                                           |
|  | - Retry logic        |                                           |
|  | - Monitoring/logging |                                           |
|  +---+----+----+----+--+                                           |
|      |    |    |    |                                               |
|      v    v    v    v                                               |
|  +------+ +------+ +------+ +------+                               |
|  | CCC  | |Copart| |One   | |Shift |                               |
|  |      | |      | |Inc   | |Tech  |                               |
|  +------+ +------+ +------+ +------+                               |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 18. Vendor Data Model

### Complete Vendor Data Model

```sql
CREATE TABLE vendor (
    vendor_id           VARCHAR(20)     PRIMARY KEY,
    vendor_name         VARCHAR(200)    NOT NULL,
    vendor_type         VARCHAR(30)     NOT NULL
        CHECK (vendor_type IN ('CLAIMS_SYSTEM','ESTIMATICS','BODY_SHOP','RENTAL',
               'SALVAGE','IA_FIRM','LEGAL','MEDICAL','FRAUD','DATA_ANALYTICS',
               'DOCUMENT_MGMT','PAYMENT','TELEMATICS','AERIAL_IMAGERY',
               'EMERGENCY_SERVICES','GENERAL_CONTRACTOR','OTHER')),
    vendor_status       VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
        CHECK (vendor_status IN ('PROSPECTIVE','ONBOARDING','ACTIVE',
               'SUSPENDED','OFFBOARDING','TERMINATED')),
    tax_id              VARCHAR(20),
    duns_number         VARCHAR(15),
    primary_contact     VARCHAR(100),
    primary_email       VARCHAR(200),
    primary_phone       VARCHAR(20),
    website             VARCHAR(200),
    address_street      VARCHAR(200),
    address_city        VARCHAR(100),
    address_state       VARCHAR(2),
    address_zip         VARCHAR(10),
    service_regions     TEXT[],
    onboard_date        DATE,
    offboard_date       DATE,
    risk_tier           VARCHAR(10)     CHECK (risk_tier IN ('CRITICAL','HIGH','MEDIUM','LOW')),
    soc2_certified      BOOLEAN         DEFAULT FALSE,
    soc2_expiration     DATE,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendor_contract (
    contract_id         VARCHAR(20)     PRIMARY KEY,
    vendor_id           VARCHAR(20)     NOT NULL REFERENCES vendor(vendor_id),
    contract_type       VARCHAR(30)     NOT NULL
        CHECK (contract_type IN ('MSA','SOW','SLA','AMENDMENT','RENEWAL','NDA','DPA','BAA')),
    contract_name       VARCHAR(200)    NOT NULL,
    effective_date      DATE            NOT NULL,
    expiration_date     DATE            NOT NULL,
    auto_renew          BOOLEAN         DEFAULT FALSE,
    renewal_notice_days INTEGER,
    total_contract_value DECIMAL(15,2),
    annual_value        DECIMAL(15,2),
    payment_terms       VARCHAR(50),
    status              VARCHAR(20)     DEFAULT 'ACTIVE'
        CHECK (status IN ('DRAFT','PENDING_APPROVAL','ACTIVE','EXPIRED','TERMINATED')),
    document_id         VARCHAR(20),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendor_sla (
    sla_id              VARCHAR(20)     PRIMARY KEY,
    contract_id         VARCHAR(20)     NOT NULL REFERENCES vendor_contract(contract_id),
    sla_metric          VARCHAR(100)    NOT NULL,
    sla_description     TEXT,
    measurement_unit    VARCHAR(30),
    target_value        DECIMAL(10,4)   NOT NULL,
    warning_threshold   DECIMAL(10,4),
    breach_threshold    DECIMAL(10,4),
    measurement_period  VARCHAR(20)     CHECK (measurement_period IN ('DAILY','WEEKLY','MONTHLY','QUARTERLY','ANNUAL')),
    penalty_type        VARCHAR(30),
    penalty_amount      DECIMAL(10,2),
    status              VARCHAR(20)     DEFAULT 'ACTIVE'
);

CREATE TABLE vendor_performance (
    performance_id      VARCHAR(20)     PRIMARY KEY,
    vendor_id           VARCHAR(20)     NOT NULL REFERENCES vendor(vendor_id),
    measurement_period  VARCHAR(20)     NOT NULL,
    period_start        DATE            NOT NULL,
    period_end          DATE            NOT NULL,
    overall_score       DECIMAL(5,2),
    quality_score       DECIMAL(5,2),
    timeliness_score    DECIMAL(5,2),
    cost_score          DECIMAL(5,2),
    compliance_score    DECIMAL(5,2),
    volume_processed    INTEGER,
    sla_met_count       INTEGER,
    sla_breached_count  INTEGER,
    customer_sat_score  DECIMAL(5,2),
    incidents_count     INTEGER,
    notes               TEXT,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendor_invoice (
    invoice_id          VARCHAR(20)     PRIMARY KEY,
    vendor_id           VARCHAR(20)     NOT NULL REFERENCES vendor(vendor_id),
    contract_id         VARCHAR(20)     REFERENCES vendor_contract(contract_id),
    invoice_number      VARCHAR(50)     NOT NULL,
    invoice_date        DATE            NOT NULL,
    due_date            DATE            NOT NULL,
    period_start        DATE,
    period_end          DATE,
    gross_amount        DECIMAL(15,2)   NOT NULL,
    adjustments         DECIMAL(15,2)   DEFAULT 0,
    net_amount          DECIMAL(15,2)   NOT NULL,
    currency            VARCHAR(3)      DEFAULT 'USD',
    status              VARCHAR(20)     DEFAULT 'RECEIVED'
        CHECK (status IN ('RECEIVED','UNDER_REVIEW','APPROVED','DISPUTED',
               'PAID','PARTIALLY_PAID','VOIDED')),
    payment_date        DATE,
    payment_reference   VARCHAR(50),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vendor_assignment (
    assignment_id       VARCHAR(20)     PRIMARY KEY,
    vendor_id           VARCHAR(20)     NOT NULL REFERENCES vendor(vendor_id),
    claim_id            VARCHAR(20)     NOT NULL,
    assignment_type     VARCHAR(30)     NOT NULL
        CHECK (assignment_type IN ('INSPECTION','ESTIMATE','REPAIR','RENTAL',
               'SALVAGE','LEGAL','MEDICAL_REVIEW','FRAUD_REVIEW','APPRAISAL',
               'ENGINEERING','ENVIRONMENTAL','OTHER')),
    assigned_date       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date            DATE,
    completed_date      TIMESTAMP,
    status              VARCHAR(20)     DEFAULT 'ASSIGNED'
        CHECK (status IN ('ASSIGNED','ACCEPTED','IN_PROGRESS','COMPLETED',
               'CANCELLED','REASSIGNED')),
    assigned_to         VARCHAR(100),
    instructions        TEXT,
    result_document_id  VARCHAR(20),
    quality_score       DECIMAL(5,2),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
```

---

## 19. Build vs Buy Decision Framework

### Decision Matrix

| Factor | Weight | Build (In-House) | Buy (Vendor) | Scoring |
|--------|--------|-------------------|--------------|---------|
| Core competency | 20% | 5 if core differentiator | 5 if commodity | 1-5 scale |
| Time to market | 15% | Usually longer (12-24 mo) | Usually faster (3-6 mo) | 1-5 scale |
| Total cost (5-year) | 15% | Development + maintenance | License + integration + ongoing | $ comparison |
| Flexibility | 10% | Full control | Limited by vendor roadmap | 1-5 scale |
| Talent availability | 10% | Need specialized team | Vendor provides expertise | 1-5 scale |
| Integration complexity | 10% | Native integration | API/connector needed | 1-5 scale |
| Vendor risk | 10% | No vendor dependency | Vendor lock-in, viability risk | 1-5 scale |
| Regulatory compliance | 5% | Full control of compliance | Vendor may or may not comply | 1-5 scale |
| Data security | 5% | Internal control | Third-party data sharing | 1-5 scale |

### Build vs Buy by Capability

| Capability | Recommendation | Rationale |
|-----------|---------------|-----------|
| Core claims processing | **Buy** (Guidewire, Duck Creek) | Too complex, too regulated to build from scratch |
| Auto estimating | **Buy** (CCC, Mitchell) | Requires massive parts/labor database |
| Property estimating | **Buy** (Xactimate) | Industry standard, adjuster expectation |
| Salvage auction | **Buy** (Copart, IAA) | Physical infrastructure, marketplace effect |
| Fraud scoring | **Buy** (Shift, FRISS) | AI/ML expertise, cross-carrier data |
| Payment processing | **Buy** (One Inc) | Regulatory complexity, payment rails |
| Document management | **Buy** (OnBase, FileNet) | Mature platforms, features |
| Customer portal | **Build or Buy** | Brand differentiation opportunity |
| Mobile app | **Build** | Brand, UX differentiation |
| Analytics/BI | **Build + Buy** | Buy platform (Tableau), build models |
| AI/ML models | **Build** | Competitive advantage, proprietary data |
| Workflow rules | **Build** (on platform) | Company-specific business rules |
| Integration layer | **Build** | Company-specific integration needs |

---

## 20. Vendor Risk Management & Business Continuity

### Vendor Risk Assessment

| Risk Category | Assessment Factors | Mitigation |
|--------------|-------------------|------------|
| Financial | Revenue, profitability, funding, credit rating | Financial review, escrow, multi-vendor |
| Operational | Capacity, scalability, redundancy | SLA, performance monitoring, backup vendor |
| Security | Data protection, access control, breach history | SOC 2, penetration testing, data encryption |
| Compliance | Regulatory compliance, audit history | Compliance attestation, audit rights |
| Strategic | Product roadmap alignment, M&A risk | Roadmap reviews, contractual protections |
| Concentration | Single vendor dependency | Multi-vendor strategy, exit planning |

### Business Continuity Planning

```
+-------------------------------------------------------------------+
|              VENDOR BCP FRAMEWORK                                   |
+-------------------------------------------------------------------+
|                                                                     |
|  FOR EACH CRITICAL VENDOR:                                         |
|                                                                     |
|  1. RISK ASSESSMENT                                                |
|     - What is the impact of vendor failure?                        |
|     - What is the probability of vendor failure?                   |
|     - What is the recovery time objective (RTO)?                   |
|     - What is the recovery point objective (RPO)?                  |
|                                                                     |
|  2. MITIGATION STRATEGIES                                          |
|     - Dual-vendor strategy (primary + backup)                      |
|     - Data portability (can we extract our data?)                  |
|     - API abstraction (can we swap vendors?)                       |
|     - In-house fallback (manual processes)                         |
|     - Contractual protections (source code escrow, SLA)            |
|                                                                     |
|  3. CONTINGENCY PLAN                                               |
|     - Trigger criteria for BCP activation                          |
|     - Communication plan (internal + vendor)                       |
|     - Switchover procedures                                        |
|     - Data recovery procedures                                     |
|     - Testing schedule (annual BCP test)                           |
|                                                                     |
|  4. EXIT PLANNING                                                  |
|     - Data extraction timeline (30-90 days)                        |
|     - Parallel run requirements                                    |
|     - Knowledge transfer requirements                              |
|     - Contractual exit provisions                                  |
|                                                                     |
+-------------------------------------------------------------------+
```

### Vendor Risk Tiering

| Tier | Criteria | Review Frequency | BCP Required |
|------|---------|-----------------|--------------|
| Critical | Claims system, payment platform, core data | Quarterly | Yes, tested annually |
| High | Estimatics, IA firms, fraud detection | Semi-annually | Yes |
| Medium | Rental, document management, analytics | Annually | Recommended |
| Low | Specialty services, occasional use | Every 2 years | No |

---

## Appendix A: Vendor Integration Checklist

```
FOR EACH NEW VENDOR INTEGRATION:

[ ] DISCOVERY
    [ ] Vendor API documentation reviewed
    [ ] Data model mapping completed
    [ ] Authentication mechanism confirmed (OAuth, API key, certificate)
    [ ] Rate limits and throttling understood
    [ ] Error handling patterns documented

[ ] DESIGN
    [ ] Integration pattern selected (API, event, file, webhook)
    [ ] Data transformation specifications written
    [ ] Error handling and retry logic designed
    [ ] Monitoring and alerting designed
    [ ] Security review completed

[ ] BUILD
    [ ] Integration code developed
    [ ] Unit tests written (mock vendor responses)
    [ ] Integration tests with vendor sandbox/UAT
    [ ] Performance testing completed
    [ ] Security scan completed

[ ] TEST
    [ ] End-to-end testing with vendor test environment
    [ ] Error scenario testing (timeouts, errors, invalid data)
    [ ] Volume/load testing
    [ ] Failover testing
    [ ] UAT with business users

[ ] DEPLOY
    [ ] Production credentials provisioned
    [ ] Production connectivity verified
    [ ] Monitoring dashboards configured
    [ ] Alerting rules configured
    [ ] Runbook documented
    [ ] Production smoke test completed

[ ] OPERATE
    [ ] Daily monitoring cadence established
    [ ] Vendor escalation contacts documented
    [ ] SLA tracking configured
    [ ] Invoice reconciliation process established
    [ ] Quarterly performance review scheduled
```

---

## Appendix B: Key Industry Standards

| Standard | Organization | Purpose |
|----------|-------------|---------|
| ACORD | ACORD | Insurance data standards (forms, XML, JSON) |
| BMS | CIECA | Auto damage estimate data exchange |
| EMS | CIECA | Electronic estimate messaging |
| LEDES | LEDES | Legal electronic billing |
| UTBMS | ABA/AIPLA | Legal task/activity billing codes |
| CIECA | CIECA | Collision industry electronic commerce |
| HL7 | HL7 | Healthcare data exchange (medical claims) |
| EDI 837 | ASC X12 | Healthcare claim transactions |
| ISO 20022 | ISO | Financial messaging (payments) |

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 16 (Catastrophe Claims), Article 18 (Document Management), and Article 20 (Claims Analytics).*
