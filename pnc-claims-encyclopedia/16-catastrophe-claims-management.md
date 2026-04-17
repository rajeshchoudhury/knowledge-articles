# Catastrophe (CAT) Claims Management: Complete Guide

## Table of Contents

1. [Introduction to Catastrophe Claims](#1-introduction-to-catastrophe-claims)
2. [Catastrophe Definition & Classification](#2-catastrophe-definition--classification)
3. [Types of Catastrophes](#3-types-of-catastrophes)
4. [CAT Response Planning](#4-cat-response-planning)
5. [CAT Organization Structure](#5-cat-organization-structure)
6. [Surge Staffing](#6-surge-staffing)
7. [CAT FNOL Surge Handling](#7-cat-fnol-surge-handling)
8. [Mobile Command Center & Field Operations](#8-mobile-command-center--field-operations)
9. [Aerial/Drone Imagery for Damage Assessment](#9-aerialdrone-imagery-for-damage-assessment)
10. [Satellite Imagery & Geospatial Analysis](#10-satellite-imagery--geospatial-analysis)
11. [Weather Data Integration](#11-weather-data-integration)
12. [Geocoding & Exposure Analysis](#12-geocoding--exposure-analysis)
13. [CAT Claims Triage & Prioritization](#13-cat-claims-triage--prioritization)
14. [Fast-Track Claims Processing](#14-fast-track-claims-processing)
15. [Managed Repair Programs for CAT](#15-managed-repair-programs-for-cat)
16. [Temporary Housing & ALE Management at Scale](#16-temporary-housing--ale-management-at-scale)
17. [NFIP Claims](#17-nfip-national-flood-insurance-program-claims)
18. [Earthquake Claims](#18-earthquake-claims)
19. [Wildfire Claims](#19-wildfire-claims)
20. [CAT Financial Management](#20-cat-financial-management)
21. [CAT Vendor Management](#21-cat-vendor-management)
22. [State Regulatory Requirements During CAT](#22-state-regulatory-requirements-during-cat)
23. [Public Communications & Customer Outreach](#23-public-communications--customer-outreach)
24. [CAT Claims Data Model Extensions](#24-cat-claims-data-model-extensions)
25. [Technology Platform Requirements for CAT Scalability](#25-technology-platform-requirements-for-cat-scalability)
26. [Post-CAT Analysis & Lessons Learned](#26-post-cat-analysis--lessons-learned)
27. [CAT Claims Dashboards & Real-Time Monitoring](#27-cat-claims-dashboards--real-time-monitoring)
28. [Historical CAT Event Case Studies](#28-historical-cat-event-case-studies)

---

## 1. Introduction to Catastrophe Claims

Catastrophe (CAT) claims management represents the most operationally intense and financially significant challenge in Property and Casualty insurance. A single catastrophic event can generate tens of thousands of claims within hours, overwhelming normal operational capacity by 10x–50x, creating immediate financial pressure on reserves and reinsurance treaties, and demanding coordination across dozens of vendors, regulatory bodies, and customer touchpoints.

A solutions architect designing a claims system must ensure the platform can seamlessly scale from steady-state operations (e.g., 500 FNOL per day) to catastrophe-mode operations (e.g., 25,000 FNOL per day) within hours.

### Why CAT Claims Differ from Standard Claims

| Dimension | Standard Claims | CAT Claims |
|-----------|----------------|------------|
| Volume | Predictable, steady | Massive surge, 10x–50x normal |
| Geography | Dispersed | Concentrated in impact zone |
| Time pressure | Days/weeks | Hours/days |
| Staffing | In-house adjusters | Surge IA workforce |
| Infrastructure | Office-based | Field-based / mobile |
| Regulatory | Standard timelines | Emergency orders, extended deadlines |
| Financial | Normal reserves | Reinsurance triggers, aggregate caps |
| Customer emotion | Moderate stress | Extreme distress, displacement |
| Media attention | Minimal | Intense public scrutiny |
| Technology | Normal load | Extreme load, offline needs |

### CAT Claims Lifecycle Overview

```
+-------------------------------------------------------------------+
|                   PRE-EVENT PHASE                                  |
|  Monitor weather → Activate plan → Pre-position resources         |
+-------------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------------+
|                   EVENT DECLARATION                                |
|  PCS designation → Internal CAT declaration → Command center      |
+-------------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------------+
|                   SURGE RESPONSE                                   |
|  FNOL surge → Surge staffing → Field deployment → Triage          |
+-------------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------------+
|                   ACTIVE CLAIMS PROCESSING                        |
|  Inspections → Estimates → Coverage decisions → Payments          |
+-------------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------------+
|                   WIND-DOWN                                        |
|  Volume normalization → IA release → Open claim management        |
+-------------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------------+
|                   POST-EVENT ANALYSIS                              |
|  Financial analysis → Lessons learned → System improvements       |
+-------------------------------------------------------------------+
```

---

## 2. Catastrophe Definition & Classification

### ISO PCS (Property Claim Services) Designation

ISO's Property Claim Services (PCS) unit, now part of Verisk Analytics, is the industry-standard authority for catastrophe designation in the United States. PCS has been tracking catastrophes since 1949.

#### PCS Designation Criteria

An event qualifies as a PCS-designated catastrophe when it meets **all** of the following thresholds:

| Criterion | Threshold | Notes |
|-----------|-----------|-------|
| Insured losses | ≥ $25 million | Adjusted periodically for inflation; was $5M before 1997, $25M since |
| Number of policyholders affected | Significant number | No fixed number, but typically hundreds+ |
| Number of insurers affected | Multiple | Not a single-company event |
| Geographic scope | Identifiable area | Must be mappable to affected zones |

#### PCS Catastrophe Numbering System

PCS assigns a unique serial number to each catastrophe:

```
Format: PCS-YYYY-NNN

  YYYY = Four-digit year
  NNN  = Sequential number within the year (starting at 01)

Examples:
  PCS-2024-001  =  First catastrophe of 2024
  PCS-2024-032  =  32nd catastrophe of 2024
```

Each PCS bulletin contains:

| Field | Description | Example |
|-------|-------------|---------|
| PCS Serial Number | Unique identifier | PCS-2024-015 |
| Event Name | Descriptive name | Hurricane Milton |
| Event Type | Peril classification | Hurricane/Tropical Storm |
| Event Start Date | Beginning of event | 2024-10-09 |
| Event End Date | End of event | 2024-10-11 |
| Affected States | List of impacted states | FL, GA, SC, NC |
| Estimated Insured Losses | Industry-wide loss estimate | $35B–$55B |
| Affected Lines | Lines of business | Homeowners, Commercial Property, Auto |
| Loss Update Schedule | When estimates will be refreshed | Monthly for 12 months |

#### PCS Bulletins Integration

```
+--------------------+         +-----------------------+
|  Verisk PCS Feed   |-------->|  CAT Event Ingestion  |
|  (API / File)      |         |  Service              |
+--------------------+         +-----------+-----------+
                                           |
                         +-----------------+-----------------+
                         |                 |                 |
                         v                 v                 v
                  +------+------+  +-------+------+  +------+------+
                  | CAT Event   |  | Exposure     |  | Reinsurance |
                  | Registry    |  | Analysis     |  | Notification|
                  +-------------+  +--------------+  +-------------+
```

**Sample PCS Feed Payload (JSON):**

```json
{
  "pcsSerial": "PCS-2024-015",
  "eventName": "Hurricane Milton",
  "eventType": "HURRICANE",
  "eventStartDate": "2024-10-09",
  "eventEndDate": "2024-10-11",
  "affectedStates": ["FL", "GA", "SC", "NC"],
  "estimatedInsuredLoss": {
    "low": 35000000000,
    "mid": 45000000000,
    "high": 55000000000,
    "currency": "USD"
  },
  "affectedLines": [
    "HOMEOWNERS",
    "COMMERCIAL_PROPERTY",
    "PERSONAL_AUTO",
    "COMMERCIAL_AUTO",
    "INLAND_MARINE"
  ],
  "bulletinDate": "2024-10-15",
  "bulletinVersion": 1,
  "affectedZipCodes": ["33701", "33702", "33703", "..."],
  "windField": {
    "category": 3,
    "maxSustainedWindMph": 120,
    "stormSurgeMaxFt": 15
  }
}
```

### Internal Catastrophe Declaration

Beyond PCS, carriers maintain their own internal CAT declaration criteria, often with lower thresholds:

| Internal Level | Trigger | Response |
|----------------|---------|----------|
| CAT Watch | Weather advisory, potential event | Monitor, alert leadership |
| CAT Level 1 | 500–2,000 expected claims | Partial activation, IA standby |
| CAT Level 2 | 2,000–10,000 expected claims | Full activation, IA deployment |
| CAT Level 3 | 10,000–50,000 expected claims | Maximum activation, multiple surge firms |
| CAT Level 4 | 50,000+ expected claims | Enterprise emergency, exec oversight |

---

## 3. Types of Catastrophes

### 3.1 Hurricanes / Tropical Storms

Hurricanes are the most financially significant catastrophe peril in the U.S., responsible for the majority of insured catastrophe losses historically.

**Characteristics:**
- Wind damage (roof, siding, windows, structural)
- Storm surge (coastal flooding, often the most destructive component)
- Inland flooding (from rainfall, often excluded under standard HO policies)
- Tornado spawning (embedded tornadoes within hurricane)
- Power outage (ALE claims from extended power loss)

**Saffir-Simpson Scale & Expected Claim Impact:**

| Category | Wind Speed (mph) | Expected Claims per 100K Policies | Avg Severity |
|----------|-----------------|----------------------------------|--------------|
| 1 | 74–95 | 5,000–15,000 | $8,000–$15,000 |
| 2 | 96–110 | 15,000–30,000 | $15,000–$30,000 |
| 3 | 111–129 | 30,000–50,000 | $30,000–$80,000 |
| 4 | 130–156 | 50,000–70,000 | $80,000–$200,000 |
| 5 | 157+ | 70,000+ | $200,000+ |

**Hurricane Claims Processing Considerations:**
- Named storm deductibles (percentage-based, typically 2%–5% of dwelling coverage)
- Wind vs. water coverage disputes (especially in coastal areas)
- Anti-concurrent causation clauses
- Flood exclusion enforcement (requires separate NFIP or private flood policy)
- Demand surge: contractor costs inflate 20%–50% post-hurricane
- Assignment of Benefits (AOB) abuse (especially in Florida)

### 3.2 Tornadoes

**Characteristics:**
- Highly localized but intense destruction
- EF-0 to EF-5 scale (Enhanced Fujita)
- Often occur in clusters (tornado outbreaks)
- Very fast onset, minimal warning time
- Total destruction possible in narrow path

**EF Scale Claims Impact:**

| EF Rating | Wind Speed (mph) | Damage Level | Typical Claim |
|-----------|-----------------|--------------|---------------|
| EF-0 | 65–85 | Light | Roof, gutters, siding: $2K–$10K |
| EF-1 | 86–110 | Moderate | Roof peeled, windows: $10K–$40K |
| EF-2 | 111–135 | Significant | Roof gone, walls damaged: $40K–$100K |
| EF-3 | 136–165 | Severe | Structure severely damaged: $100K–$250K |
| EF-4 | 166–200 | Devastating | Structure destroyed: Total loss |
| EF-5 | 200+ | Incredible | Complete destruction, slab swept clean |

### 3.3 Earthquakes

**Characteristics:**
- Not covered under standard HO or commercial property policies
- Requires separate earthquake policy or endorsement
- Measured on Richter/Moment Magnitude Scale
- Aftershock sequences can continue for months
- Liquefaction, landslide, and fire following earthquake

**Earthquake Claims Considerations:**
- Separate deductibles (typically 10%–25% of dwelling coverage)
- California Earthquake Authority (CEA) as quasi-public insurer
- USGS ShakeMap integration for damage estimation
- Modified Mercalli Intensity (MMI) scale for localized damage assessment
- Masonry vs. wood-frame construction significantly affects severity
- Chimney damage is the most common claim type for moderate events

### 3.4 Wildfires

**Characteristics:**
- Extended duration events (weeks to months)
- Total loss prevalent (homes completely consumed)
- Smoke damage for wider area (even without fire contact)
- Debris removal costs often exceed structure value
- Evacuation and ALE for extended periods
- Watershed damage causing subsequent flooding/mudslide

**Wildfire Claims Considerations:**
- Extended replacement cost provisions (typically 125%–150% of policy limit)
- Building code upgrade coverage
- Debris removal sublimits (often inadequate at 5%–10% of dwelling)
- ALE duration limits (12–24 months, sometimes extended by regulation)
- Tree/landscaping replacement limits
- FAIR Plan policies in high-risk areas (California FAIR Plan)
- Defensible space and mitigation credit adjustments

### 3.5 Floods

**Flood Insurance Landscape:**

| Program | Provider | Coverage | Max Limits |
|---------|----------|----------|------------|
| NFIP | FEMA (via WYO carriers) | Standard flood | $250K dwelling / $100K contents (residential) |
| Private Flood | Private insurers | Often broader | Varies, can exceed NFIP limits |
| Excess Flood | Private insurers | Above NFIP | Varies |
| Commercial NFIP | FEMA (via WYO) | Commercial buildings | $500K building / $500K contents |

**Flood Zone Designations:**

| Zone | Risk Level | NFIP Requirement |
|------|-----------|-----------------|
| A, AE, AH, AO | High risk (Special Flood Hazard Area) | Mandatory if federally backed mortgage |
| V, VE | High risk, coastal | Mandatory, higher premiums |
| B, X (shaded) | Moderate risk | Optional but recommended |
| C, X (unshaded) | Low risk | Optional |
| D | Undetermined | Optional |

### 3.6 Hail Storms

**Characteristics:**
- Most frequent CAT peril by event count
- Concentrated in "Hail Alley" (TX, OK, KS, NE, CO, SD)
- Primarily roof and auto damage
- Widespread but often moderate severity per claim
- Controversial "storm chasing" contractor issue

**Hail Size & Damage Correlation:**

| Hail Diameter | Comparison | Roof Damage | Auto Damage |
|---------------|------------|-------------|-------------|
| 1" (quarter) | Quarter | Possible granule loss | Minor dents |
| 1.5" (golf ball) | Golf ball | Significant granule loss, bruising | Moderate dents |
| 2" (hen egg) | Egg | Cracking, mat exposure | Significant dents |
| 2.75" (baseball) | Baseball | Severe damage, possible penetration | Totaled panels |
| 4"+ (softball) | Softball | Catastrophic, deck penetration | Likely total loss |

### 3.7 Winter Storms / Ice Storms

**Characteristics:**
- Ice dam formation causing water intrusion
- Roof collapse from snow/ice weight
- Frozen pipe bursts (most common winter claim)
- Tree/limb fall damage
- Power outage causing ALE and spoilage claims
- Wide geographic impact

### 3.8 Civil Unrest

**Characteristics:**
- Vandalism, looting, arson
- Coverage under standard property policies (fire, vandalism)
- Higher deductibles may apply for civil commotion
- Geographic clustering in urban cores
- Multiple peril types (fire + theft + vandalism)
- Proof of loss challenges (business records destroyed)

### 3.9 Terrorism

**Characteristics:**
- Terrorism Risk Insurance Act (TRIA) / TRIPRA framework
- Federal backstop for certified acts of terrorism
- Carrier deductibles and co-shares under TRIA
- NBCR (Nuclear, Biological, Chemical, Radiological) exclusions common
- Standalone terrorism policies for high-value risks
- Workers' compensation cannot exclude terrorism

### 3.10 Pandemic

**Characteristics:**
- Business interruption claims (coverage disputes)
- Workers' compensation claims (occupational exposure)
- Event cancellation claims
- Civil authority coverage disputes
- Physical damage trigger debate
- Regulatory and legislative mandates for coverage

---

## 4. CAT Response Planning

### Pre-Event Preparation

A well-designed CAT response plan includes the following components:

```
+------------------------------------------------------------------+
|                    CAT RESPONSE PLAN STRUCTURE                     |
+------------------------------------------------------------------+
|                                                                    |
|  1. GOVERNANCE & COMMAND                                           |
|     - CAT Committee charter                                       |
|     - Authority matrix (who can activate)                          |
|     - Escalation protocols                                         |
|     - Communication chain                                          |
|                                                                    |
|  2. PRE-EVENT READINESS                                            |
|     - IA firm contracts (standing agreements)                      |
|     - Technology stress testing                                    |
|     - Call center surge contracts                                  |
|     - Supply chain pre-positioning                                 |
|     - Regulatory contact database                                  |
|                                                                    |
|  3. EVENT MONITORING                                               |
|     - Weather service feeds (NWS, private)                         |
|     - Exposure monitoring tools                                    |
|     - Event tracking dashboards                                    |
|     - Pre-landfall/pre-event notifications                         |
|                                                                    |
|  4. ACTIVATION PROTOCOLS                                           |
|     - CAT level determination criteria                             |
|     - Resource mobilization checklists                             |
|     - Technology scaling runbooks                                  |
|     - Vendor activation procedures                                 |
|                                                                    |
|  5. OPERATIONAL PLAYBOOKS                                          |
|     - FNOL surge handling                                          |
|     - Field deployment logistics                                   |
|     - Fast-track processing rules                                  |
|     - Customer communication templates                             |
|                                                                    |
|  6. FINANCIAL PROTOCOLS                                            |
|     - Reserve posting rules for CAT                                |
|     - Reinsurance notification triggers                            |
|     - Payment authority escalation                                 |
|     - Cash management procedures                                   |
|                                                                    |
|  7. WIND-DOWN PROCEDURES                                           |
|     - IA release criteria                                          |
|     - Open claim management transition                             |
|     - Post-event financial reconciliation                          |
|     - Lessons learned process                                      |
|                                                                    |
+------------------------------------------------------------------+
```

### Event Monitoring

**Weather Monitoring Integration Points:**

| Source | Data Type | Frequency | Integration |
|--------|-----------|-----------|-------------|
| NOAA/NWS | Watches, warnings, advisories | Real-time | API / RSS |
| DTN (formerly WSI) | Commercial weather intelligence | Real-time | API |
| The Weather Company (IBM) | Forecast models, radar | Real-time | API |
| CoreLogic / RMS / AIR | Cat models, loss estimates | Pre/post event | API / File |
| USGS | Earthquake alerts, ShakeMaps | Real-time | API |
| NIFC (National Interagency Fire Center) | Wildfire intelligence | Multiple daily | API / GIS |

### CAT Declaration Triggers

```
+-------------------+     +-------------------+     +-------------------+
| Weather Alert     |     | Exposure Analysis |     | PCS Bulletin      |
| (NWS Warning)     |     | (Policy Count in  |     | (Industry CAT     |
|                   |     |  Affected Zone)   |     |  Designation)     |
+--------+----------+     +--------+----------+     +--------+----------+
         |                         |                         |
         v                         v                         v
+--------+-------------------------+-------------------------+----------+
|                     CAT DECISION ENGINE                                |
|                                                                        |
|  Rules:                                                                |
|  - IF NWS_WARNING = "Hurricane" AND ExposedPolicies > 5000            |
|    THEN CAT_LEVEL = 2                                                  |
|  - IF NWS_WARNING = "Hurricane" AND ExposedPolicies > 25000           |
|    THEN CAT_LEVEL = 3                                                  |
|  - IF PCS_BULLETIN received AND EstimatedLoss > $100M                 |
|    THEN CAT_LEVEL = 3                                                  |
|  - IF Earthquake AND MMI >= VII AND ExposedPolicies > 10000           |
|    THEN CAT_LEVEL = 3                                                  |
+--------+----------------------------------------------------------+---+
         |                                                          |
         v                                                          v
+--------+----------+                                    +----------+---+
| Auto-Notification |                                    | Resource     |
| - Exec team       |                                    | Mobilization |
| - CAT Director    |                                    | - IA firms   |
| - Reinsurance     |                                    | - Call center |
| - Regulators      |                                    | - Technology  |
+-------------------+                                    +--------------+
```

---

## 5. CAT Organization Structure

### Command Center Hierarchy

```
                        +-------------------+
                        |   CAT Committee   |
                        | (CEO, COO, CCO,   |
                        |  CFO, CIO, CLO)   |
                        +--------+----------+
                                 |
                        +--------+----------+
                        |   CAT Director    |
                        | (VP/SVP Claims)   |
                        +--------+----------+
                                 |
         +-----------+-----------+-----------+-----------+
         |           |           |           |           |
+--------+--+ +------+---+ +----+-----+ +---+------+ +--+--------+
| Operations| | Field     | | Financial| | Vendor   | | Technology|
| Lead      | | Lead      | | Lead     | | Lead     | | Lead      |
+-----------+ +----+------+ +----------+ +----------+ +-----------+
                   |
    +--------------+--------------+
    |              |              |
+---+----+   +----+---+   +-----+--+
| Region |   | Region |   | Region |
| Lead 1 |   | Lead 2 |   | Lead N |
+---+----+   +--------+   +--------+
    |
    +--- CAT Team 1 (5-10 adjusters)
    +--- CAT Team 2 (5-10 adjusters)
    +--- CAT Team N
```

### Role Definitions

| Role | Responsibilities | Authority | Reporting |
|------|-----------------|-----------|-----------|
| CAT Committee | Strategic decisions, financial authorization, public communications | Unlimited | Board |
| CAT Director | Overall CAT operations, resource allocation, performance monitoring | Full CAT operations | CAT Committee |
| Operations Lead | FNOL management, claim workflow, SLA monitoring | Operational decisions | CAT Director |
| Field Lead | Adjuster deployment, field logistics, inspection coordination | Field operations | CAT Director |
| Financial Lead | Reserve management, reinsurance, payment authorization | Financial within authority | CAT Director |
| Vendor Lead | IA firm management, contractor coordination, vendor payments | Vendor operations | CAT Director |
| Technology Lead | System scalability, mobile tools, data/reporting | Technology decisions | CAT Director |
| Region Lead | Regional adjuster teams, local logistics, local regulatory | Regional operations | Field Lead |
| Team Lead | Daily adjuster supervision, quality review, production tracking | Team operations | Region Lead |
| CAT Adjuster | Field inspections, damage documentation, estimate writing | Per-claim within authority | Team Lead |

### Command Center Operations

The physical or virtual command center requires:

**Physical Command Center:**
- Dedicated war room with multiple display screens
- Real-time dashboards showing claim volume, adjuster deployment, financial status
- Direct communication lines to field teams
- Conference bridge capability for multi-party coordination
- Backup power and communications
- Secure access to all claims and financial systems

**Virtual Command Center:**
- Video conferencing platform (persistent rooms)
- Shared digital dashboard access
- Chat/messaging channels by function
- Document collaboration spaces
- Mobile command center app for field leadership

---

## 6. Surge Staffing

### Independent Adjuster (IA) Firms

IA firms provide the surge workforce capacity essential for catastrophe response. Major firms include:

| Firm | Headquarters | Adjuster Pool | Specialties | Technology Platform |
|------|-------------|---------------|-------------|-------------------|
| Crawford & Company | Atlanta, GA | 9,000+ | Multi-line, international | Crawford Claims Solutions |
| Sedgwick | Memphis, TN | 30,000+ | All lines, TPA | viaOne |
| Pilot Catastrophe Services | Tampa, FL | 3,000+ | CAT-focused property | Custom mobile platform |
| AFCA (Alacrity) | Clearwater, FL | 2,000+ | Property CAT | Field tools |
| Eberl Claims | Cleveland, OH | 5,000+ | Multi-line | Digital assignment |
| Independent adjusters | Various | Thousands | Specialized | Xactimate, ClaimXperience |

### IA Deployment Process

```
+------------------+     +------------------+     +------------------+
| 1. CAT Declared  |---->| 2. IA Firms      |---->| 3. Adjuster      |
|    Resource needs |     |    Notified       |     |    Rostering     |
|    quantified     |     |    (volume/skills)|     |    (skills/certs) |
+------------------+     +------------------+     +------------------+
                                                          |
+------------------+     +------------------+     +-------+----------+
| 6. Field         |<----| 5. Travel &      |<----| 4. Licensing     |
|    Deployment    |     |    Logistics     |     |    Verification  |
|    (Assignments) |     |    (hotel/car)   |     |    (state req)   |
+------------------+     +------------------+     +------------------+
```

### Licensing Requirements

IA adjusters must hold valid licenses in the state where they are adjusting. During catastrophes, many states issue emergency temporary licenses:

| State | Normal License Requirement | CAT Emergency Provision |
|-------|---------------------------|------------------------|
| Florida | Licensed or registered | 180-day emergency designation |
| Texas | Licensed | Emergency order, reciprocity |
| Louisiana | Licensed | Temporary license via emergency order |
| California | Licensed | Limited emergency provisions |
| New York | Licensed | Temporary authorization during declared emergency |
| North Carolina | Licensed | 180-day emergency license |

**License Verification Data Model:**

```json
{
  "adjusterId": "ADJ-2024-88901",
  "adjusterName": "Jane Smith",
  "licenseRecords": [
    {
      "state": "FL",
      "licenseNumber": "W123456",
      "licenseType": "ALL_LINES",
      "issueDate": "2022-01-15",
      "expirationDate": "2026-01-14",
      "status": "ACTIVE",
      "isEmergencyLicense": false
    },
    {
      "state": "TX",
      "licenseNumber": "TX-ADJ-789012",
      "licenseType": "ALL_LINES",
      "issueDate": "2024-10-10",
      "expirationDate": "2025-04-08",
      "status": "ACTIVE",
      "isEmergencyLicense": true,
      "emergencyOrderNumber": "EO-2024-003"
    }
  ],
  "certifications": [
    "HAAG_CERTIFIED_ROOF_INSPECTOR",
    "IICRC_WRT",
    "XACTIMATE_CERTIFIED"
  ]
}
```

### Surge Staffing Cost Structure

| Cost Component | Typical Rate | Notes |
|----------------|-------------|-------|
| IA per-claim fee | $350–$800 per claim | Varies by complexity, peril |
| Daily rate (complex) | $600–$1,200/day | For large commercial losses |
| Travel & lodging | $150–$250/day | Hotel, rental car, per diem |
| Overtime premium | 1.5x after 8 hrs / 2x Sundays | Some firms, some states require |
| Xactimate license | Included or $50–$100/month | IA firm usually provides |
| Supervision fee | 10%–15% of IA fees | Firm overhead for management |
| Rush premium | 25%–50% uplift | First 72 hours of deployment |

---

## 7. CAT FNOL Surge Handling

### Volume Projection Model

```
Day After Event:  1    2    3    4    5    6    7    14   21   30
                  |    |    |    |    |    |    |    |    |    |
Volume (% of     5%  15%  25%  20%  12%   8%   5%   3%   2%   1%
  total expected)

Cumulative:       5%  20%  45%  65%  77%  85%  90%  95%  98%  99%
```

### FNOL Channel Capacity Planning

| Channel | Normal Capacity | CAT Capacity | Scale Factor | Scale Time |
|---------|----------------|--------------|--------------|------------|
| Phone/IVR | 500 calls/day | 10,000 calls/day | 20x | 4–8 hours |
| Web Portal | 200 FNOL/day | 15,000 FNOL/day | 75x | Minutes (auto-scale) |
| Mobile App | 100 FNOL/day | 8,000 FNOL/day | 80x | Minutes (auto-scale) |
| Chatbot | 50 FNOL/day | 5,000 FNOL/day | 100x | Minutes (auto-scale) |
| Agent/Broker | 150 FNOL/day | 3,000 FNOL/day | 20x | 24–48 hours |
| Email | 100 FNOL/day | 2,000 FNOL/day | 20x | Auto |

### IVR Capacity Management

```
                    +-------------------+
                    | Incoming Calls    |
                    | (10,000/day peak) |
                    +--------+----------+
                             |
                    +--------+----------+
                    | IVR Gateway       |
                    | (Cloud-based,     |
                    |  auto-scaling)    |
                    +--------+----------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+-------+  +-----+--------+
    | Self-Service |  | Guided FNOL |  | Agent Queue  |
    | (Status,FAQ) |  | (Automated  |  | (Priority    |
    |              |  |  FNOL form) |  |  routing)    |
    +--------------+  +------+------+  +------+-------+
                             |                |
                      +------+------+  +------+-------+
                      | Callback   |  | Overflow to  |
                      | Queue      |  | Outsource    |
                      | (Offer CB) |  | Call Center  |
                      +------------+  +--------------+
```

### Web Portal Scalability Architecture

```
+---------------------------+
| CDN (CloudFront/Akamai)   |
| - Static assets cached    |
| - Global distribution     |
+------------+--------------+
             |
+------------+--------------+
| Load Balancer (ALB/NLB)   |
| - Health checks           |
| - SSL termination         |
| - Rate limiting           |
+------------+--------------+
             |
+------------+--------------+--------+
|            |              |        |
| Web App    | Web App      | Web App|
| Instance 1 | Instance 2   | Inst N |
| (Auto-     | (Auto-       | (Auto- |
|  scaled)   |  scaled)     |  scale)|
+-----+------+-----+--------+---+---+
      |            |             |
+-----+------------+-------------+---+
| API Gateway                        |
| - Throttling                       |
| - Authentication                   |
| - Rate limiting per client         |
+-----+-----------------------------++
      |                              |
+-----+--------+          +---------+-------+
| FNOL Service |          | Claim Service   |
| (Kubernetes  |          | (Kubernetes     |
|  auto-scale) |          |  auto-scale)    |
+-----+--------+          +---------+-------+
      |                              |
+-----+------------------------------+--+
| Message Queue (Kafka / SQS)           |
| - Async claim creation                |
| - Guaranteed delivery                 |
| - Back-pressure handling              |
+-----+---------------------------------+
      |
+-----+--------+
| Database     |
| (Aurora/     |
|  RDS with    |
|  read        |
|  replicas)   |
+--------------+
```

### Chatbot Deployment for CAT

**Intent Design for CAT Chatbot:**

| Intent | Description | Resolution |
|--------|-------------|------------|
| `file_new_claim` | Customer wants to report a new claim | Guide through FNOL form |
| `check_claim_status` | Status inquiry for existing claim | Retrieve and display status |
| `find_contractor` | Need contractor/repair services | Redirect to managed repair |
| `temporary_housing` | Need temporary housing assistance | ALE intake process |
| `adjuster_schedule` | When will adjuster come? | Check/provide inspection schedule |
| `payment_status` | When will I receive payment? | Check payment status |
| `document_upload` | Need to submit documents | Guide to upload portal |
| `coverage_question` | Does my policy cover this? | General guidance, refer to adjuster |
| `emergency_services` | Need emergency board-up, water mitigation | Dispatch emergency vendor |

**Sample Chatbot FNOL Flow:**

```
Bot: I'm sorry to hear about the damage from Hurricane Milton.
     Let me help you file a claim. First, can you confirm
     your policy number?

User: HO-123456789

Bot: Thank you. I found your policy for 123 Ocean Drive,
     Tampa, FL 33701. Is this the property that was damaged?

User: Yes

Bot: What type of damage occurred? (Select all that apply)
     [ ] Wind damage to roof/structure
     [ ] Water intrusion/flooding
     [ ] Tree/debris damage
     [ ] Window/door damage
     [ ] Other

User: [Wind damage to roof/structure] [Water intrusion]

Bot: Is the property currently habitable?
     ( ) Yes, I can stay in the home
     ( ) No, I need temporary housing
     ( ) I'm not sure

User: No, I need temporary housing

Bot: I understand. I'll flag this as a priority claim for
     habitability. Can you briefly describe the damage?

User: The roof was blown off the back half of the house and
     there's water damage throughout the upstairs bedrooms.

Bot: I've created claim CLM-2024-0045231 and flagged it as
     HIGH PRIORITY due to habitability concerns. Here's what
     happens next:
     1. A claims adjuster will contact you within 24 hours
     2. For temporary housing, call our ALE hotline: 1-800-XXX-XXXX
     3. You can upload photos of the damage at [link]

     Is there anything else I can help with?
```

---

## 8. Mobile Command Center & Field Operations

### Physical Mobile Command Center

For large CAT events, carriers deploy physical mobile command centers:

| Component | Purpose | Specifications |
|-----------|---------|---------------|
| Mobile trailer/vehicle | Base of operations | 40-ft trailer, generator, satellite |
| Satellite uplink | Internet connectivity | 10+ Mbps symmetric |
| Network equipment | Local network for adjusters | Wi-Fi, wired connections |
| Workstations | Adjuster docking stations | 10–20 stations with monitors |
| Meeting space | Team coordination | Table for 8–12 people |
| Printing/scanning | Document processing | Network printer/scanner |
| Generator | Power independence | 30kW+ diesel generator |
| Supplies | Adjuster kits | Ladders, measuring tools, PPE |

### Field Adjuster Technology Kit

Each deployed CAT adjuster requires:

| Item | Purpose | Key Specifications |
|------|---------|-------------------|
| Laptop/tablet | Claims system access, estimate writing | Rugged, offline capable |
| Smartphone | Photos, GPS, communication | High-res camera (12MP+) |
| Mobile hotspot | Internet connectivity | 4G/5G, data plan |
| Drone (select adjusters) | Roof inspection | DJI Mavic series, FAA Part 107 |
| Measuring tools | Property measurement | Laser distance, tape measure |
| Roofing tools | Shingle inspection | Chalk, gauge, ladder |
| PPE | Safety equipment | Hard hat, boots, vest, respirator |
| Mobile printer | On-site document generation | Portable, battery-operated |
| Vehicle | Transportation | Rental SUV/truck |

### Field Operations Workflow

```
Day Start:
+--------------------+
| 1. Check           |
|    Assignments      |
|    (Mobile App)     |
+--------+-----------+
         |
         v
+--------+-----------+
| 2. Route            |
|    Optimization     |
|    (GPS/Maps)       |
+--------+-----------+
         |
         v
At Each Property:
+--------+-----------+
| 3. Check-in         |
|    (GPS Timestamp)   |
+--------+-----------+
         |
         v
+--------+-----------+
| 4. Policyholder      |
|    Interview         |
+--------+-----------+
         |
         v
+--------+-----------+
| 5. Exterior          |
|    Inspection         |
|    (Photos,Measure)   |
+--------+-----------+
         |
         v
+--------+-----------+
| 6. Interior          |
|    Inspection         |
|    (Photos,Scope)     |
+--------+-----------+
         |
         v
+--------+-----------+
| 7. Roof Inspection   |
|    (Ladder/Drone)     |
+--------+-----------+
         |
         v
+--------+-----------+
| 8. Write Estimate    |
|    (Xactimate)       |
+--------+-----------+
         |
         v
+--------+-----------+
| 9. Present to        |
|    Insured (review)   |
+--------+-----------+
         |
         v
+--------+-----------+
| 10. Upload           |
|     (Sync to cloud)  |
+--------+-----------+
         |
         v
Next Assignment...
```

---

## 9. Aerial/Drone Imagery for Damage Assessment

### Drone Program Architecture

```
+---------------------------------------------------------------------+
|                     DRONE OPERATIONS PLATFORM                        |
+---------------------------------------------------------------------+
|                                                                       |
|  +-------------------+     +-------------------+     +-------------+ |
|  | Flight Planning   |     | Fleet Management  |     | Regulatory  | |
|  | - Route creation  |     | - Drone inventory |     | Compliance  | |
|  | - Airspace check  |     | - Maintenance     |     | - FAA Part  | |
|  | - Weather check   |     | - Battery mgmt    |     |   107       | |
|  | - Priority zones  |     | - Pilot certs     |     | - Waivers   | |
|  +--------+----------+     +--------+----------+     +------+------+ |
|           |                         |                        |        |
|  +--------+-------------------------+------------------------+------+ |
|  |                 DRONE FLIGHT EXECUTION                           | |
|  |  - Automated flight paths                                       | |
|  |  - GPS-tagged imagery capture                                   | |
|  |  - Real-time video stream                                       | |
|  |  - Thermal imaging (optional)                                   | |
|  +--------+--------------------------------------------------------+ |
|           |                                                          |
|  +--------+--------------+     +-------------------+                 |
|  | Image Processing      |     | AI Analysis       |                 |
|  | - Orthomosaic         |     | - Damage detection|                 |
|  | - 3D reconstruction   |     | - Severity scoring|                 |
|  | - Georeferencing      |     | - Area measurement|                 |
|  | - Measurement tools   |     | - Material ID     |                 |
|  +--------+--------------+     +--------+----------+                 |
|           |                              |                           |
|  +--------+------------------------------+--------+                  |
|  |        CLAIMS INTEGRATION                      |                  |
|  |  - Attach to claim record                      |                  |
|  |  - Auto-populate estimate fields               |                  |
|  |  - Damage report generation                    |                  |
|  |  - Quality assurance workflow                  |                  |
|  +------------------------------------------------+                  |
+---------------------------------------------------------------------+
```

### Drone Imagery Data Model

```json
{
  "droneFlightId": "DF-2024-001234",
  "claimId": "CLM-2024-0045231",
  "propertyId": "PROP-789012",
  "pilot": {
    "pilotId": "PLT-456",
    "name": "John Doe",
    "faaLicense": "FA-3-12345678",
    "expirationDate": "2026-03-31"
  },
  "flight": {
    "droneModel": "DJI Mavic 3 Enterprise",
    "startTime": "2024-10-12T09:30:00Z",
    "endTime": "2024-10-12T09:52:00Z",
    "altitude": 120,
    "altitudeUnit": "FEET_AGL",
    "gpsCoordinates": {
      "latitude": 27.7676,
      "longitude": -82.6403
    },
    "weatherConditions": {
      "windSpeed": 12,
      "windUnit": "MPH",
      "visibility": "CLEAR",
      "temperature": 78
    }
  },
  "imagery": {
    "totalImages": 147,
    "imageResolution": "5280x3956",
    "hasOrthoMosaic": true,
    "has3DModel": true,
    "hasThermal": false,
    "storageLocation": "s3://claims-drone-imagery/2024/CLM-2024-0045231/",
    "totalSizeGB": 2.3
  },
  "aiAnalysis": {
    "damageDetected": true,
    "damageSeverity": "SEVERE",
    "damageAreas": [
      {
        "area": "ROOF_NORTH",
        "damageType": "MISSING_SHINGLES",
        "areaSqFt": 450,
        "confidence": 0.94
      },
      {
        "area": "ROOF_RIDGE",
        "damageType": "RIDGE_CAP_MISSING",
        "linearFt": 35,
        "confidence": 0.91
      }
    ],
    "estimatedRoofReplacementSqFt": 2100,
    "roofMaterial": "ARCHITECTURAL_SHINGLE",
    "roofAge": "10-15_YEARS"
  }
}
```

---

## 10. Satellite Imagery & Geospatial Analysis

### Satellite Imagery Providers

| Provider | Resolution | Revisit Time | Use Case |
|----------|-----------|-------------|----------|
| Maxar (WorldView) | 30 cm | 1–3 days | High-detail damage assessment |
| Planet Labs | 3 m (daily) | Daily | Wide-area monitoring |
| Airbus (Pleiades) | 50 cm | 1–2 days | Damage assessment |
| Copernicus (Sentinel-2) | 10 m | 5 days | Free, wide area monitoring |
| NOAA GOES | 1 km | 15 min | Weather monitoring, event tracking |

### Pre/Post Event Comparison

```
+-------------------------------------------+
| SATELLITE ANALYSIS PIPELINE               |
+-------------------------------------------+
|                                           |
| +------------------+  +-----------------+ |
| | Pre-Event Image  |  | Post-Event Image| |
| | (Baseline)       |  | (After Event)   | |
| +--------+---------+  +--------+--------+ |
|          |                      |          |
|          v                      v          |
| +--------+----------------------+--------+ |
| |      CHANGE DETECTION ALGORITHM        | |
| |  - Pixel-level comparison              | |
| |  - Spectral analysis                   | |
| |  - Object detection (buildings, roads) | |
| |  - Vegetation index (NDVI)             | |
| +--------+-------------------------------+ |
|          |                                 |
|          v                                 |
| +--------+-------------------------------+ |
| |      DAMAGE CLASSIFICATION             | |
| |  - No Damage                           | |
| |  - Minor Damage                        | |
| |  - Major Damage                        | |
| |  - Destroyed                           | |
| +--------+-------------------------------+ |
|          |                                 |
|          v                                 |
| +--------+-------------------------------+ |
| |      GEOCODED DAMAGE MAP               | |
| |  - Overlay on insured property data    | |
| |  - Heat map of damage severity         | |
| |  - Priority zones for adjuster deploy  | |
| +----------------------------------------+ |
+-------------------------------------------+
```

### Geospatial Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| GIS Platform | ArcGIS, QGIS, Google Earth Engine | Spatial analysis |
| Mapping | Mapbox, Google Maps, Leaflet | Visualization |
| Geocoding | Google Geocoding API, HERE, SmartyStreets | Address-to-coordinate |
| Spatial Database | PostGIS, Oracle Spatial, Amazon Location Service | Geospatial queries |
| Imagery Storage | Cloud Object Storage (S3, GCS) + COG format | Optimized tile serving |

---

## 11. Weather Data Integration

### Weather Data Providers

| Provider | Product | Data Types | Integration |
|----------|---------|-----------|-------------|
| DTN | WeatherSentry | Hail, wind, lightning, tornado | API, alerts |
| The Weather Company | Weather Data API | Forecast, history, alerts | REST API |
| NOAA/NWS | Public weather | Forecasts, warnings, radar | API, feeds |
| CoreLogic Weather | MEWS | Matched weather to property | API |
| StormGeo | Weather intelligence | Marine, energy, insurance | API, portal |

### Weather-to-Claim Correlation

```json
{
  "weatherEvent": {
    "eventId": "WX-2024-H015-FL",
    "eventType": "HURRICANE",
    "eventName": "Milton",
    "windData": [
      {
        "stationId": "KTPA",
        "location": "Tampa International",
        "maxGust": 105,
        "sustainedWind": 87,
        "timestamp": "2024-10-10T02:30:00Z"
      }
    ],
    "rainfallData": [
      {
        "stationId": "KTPA",
        "totalRainfall": 14.2,
        "rainfallUnit": "INCHES",
        "period": "24HR",
        "endTime": "2024-10-10T12:00:00Z"
      }
    ],
    "stormSurge": {
      "maxSurgeFeet": 12.5,
      "location": "Tampa Bay",
      "timestamp": "2024-10-10T03:00:00Z"
    }
  },
  "claimCorrelation": {
    "totalClaimsInZone": 45231,
    "windClaimsPercent": 62,
    "waterClaimsPercent": 28,
    "combinedPercent": 10
  }
}
```

---

## 12. Geocoding & Exposure Analysis

### Exposure Analysis Process

```
+-------------------+     +-------------------+     +-------------------+
| Policy Database   |     | Weather/Event     |     | Geospatial        |
| (All active       |     | Footprint         |     | Reference Data    |
|  policies with    |     | (Wind field,      |     | (Flood zones,     |
|  geocoded addrs)  |     |  flood extent,    |     |  building data,   |
|                   |     |  fire perimeter)  |     |  soil type)       |
+--------+----------+     +--------+----------+     +--------+----------+
         |                         |                         |
         v                         v                         v
+--------+-------------------------+-------------------------+----------+
|                     EXPOSURE ANALYSIS ENGINE                           |
|                                                                        |
|  1. Spatial overlay: policies within event footprint                   |
|  2. Hazard intensity mapping: wind speed, water depth per property     |
|  3. Vulnerability assessment: building characteristics + hazard        |
|  4. Loss estimation: coverage * damage ratio * hazard intensity        |
|  5. Aggregate analysis: total exposed TIV, expected claims, PML       |
+--------+----------------------------------------------------------+---+
         |                                                          |
         v                                                          v
+--------+----------+                                    +----------+---+
| Exposure Report   |                                    | Claim Volume |
| - Affected policy |                                    | Forecast     |
|   count           |                                    | - By day     |
| - Total insured   |                                    | - By peril   |
|   value (TIV)     |                                    | - By region  |
| - PML estimate    |                                    | - By LOB     |
+-------------------+                                    +--------------+
```

### PML (Probable Maximum Loss) Analysis

| Metric | Definition | Calculation |
|--------|-----------|-------------|
| Gross PML | Maximum expected loss before reinsurance | Sum(TIV * DamageRatio) for all exposed policies |
| Net PML | Maximum expected loss after reinsurance | Gross PML - Reinsurance Recoverable |
| Exposed TIV | Total insured value in affected zone | Sum(Coverage A + B + C + D) for exposed policies |
| Expected Claim Count | Predicted number of claims | ExposedPolicies * ReportingRate * DamageRate |
| Average Severity | Expected average claim payment | Total Expected Loss / Expected Claim Count |

### Geocoding Architecture

```json
{
  "geocodedProperty": {
    "policyNumber": "HO-123456789",
    "address": {
      "street": "123 Ocean Drive",
      "city": "Tampa",
      "state": "FL",
      "zip": "33701",
      "county": "Hillsborough"
    },
    "geocode": {
      "latitude": 27.7676,
      "longitude": -82.6403,
      "accuracy": "ROOFTOP",
      "source": "GOOGLE_GEOCODING_API",
      "lastGeocoded": "2024-01-15"
    },
    "propertyCharacteristics": {
      "constructionType": "FRAME",
      "yearBuilt": 2005,
      "stories": 2,
      "squareFootage": 2400,
      "roofType": "HIP",
      "roofMaterial": "ARCHITECTURAL_SHINGLE",
      "roofAge": 10,
      "floodZone": "AE",
      "distanceToCoastMiles": 0.8,
      "elevation": 12
    },
    "coverages": {
      "dwellingLimit": 450000,
      "otherStructures": 45000,
      "personalProperty": 225000,
      "lossOfUse": 90000,
      "windDeductible": 9000,
      "allPerilDeductible": 2500
    },
    "exposureZones": {
      "hurricaneZone": "COASTAL_HIGH_RISK",
      "floodZone": "AE",
      "sinkholeZone": "MODERATE",
      "wildFireZone": "LOW"
    }
  }
}
```

---

## 13. CAT Claims Triage & Prioritization

### Triage Categories

| Priority | Criteria | Target Response | SLA |
|----------|---------|----------------|-----|
| P1 - Emergency | Uninhabitable, structural collapse, active water intrusion, elderly/disabled | Same day / 24 hours | Contact within 4 hours |
| P2 - Urgent | Major damage, roof breached, significant interior damage | 24–48 hours | Contact within 24 hours |
| P3 - Standard | Moderate damage, cosmetic, partial roof damage, fence/shed | 3–7 days | Contact within 48 hours |
| P4 - Low | Minor damage, deductible-level, cosmetic only | 7–14 days | Contact within 72 hours |
| P5 - Deferred | Claims-made after initial surge, supplemental claims | 14–30 days | Contact within 7 days |

### Automated Triage Rules Engine

```
RULE: Priority_Assignment_CAT

INPUT:
  - claim.damageDescription (text)
  - claim.isHabitable (boolean)
  - claim.hasElderlyOrDisabled (boolean)
  - claim.estimatedDamage (currency)
  - claim.isActiveWaterIntrusion (boolean)
  - claim.isStructuralDamage (boolean)
  - property.constructionType
  - weather.maxWindSpeedAtProperty

RULES:
  IF claim.isHabitable = FALSE
    OR claim.isStructuralDamage = TRUE
    OR claim.isActiveWaterIntrusion = TRUE
    OR claim.hasElderlyOrDisabled = TRUE
  THEN priority = P1

  ELSE IF claim.estimatedDamage > $50,000
    OR weather.maxWindSpeedAtProperty > 100 mph
    OR claim.damageDescription CONTAINS ["roof gone", "collapsed", "destroyed"]
  THEN priority = P2

  ELSE IF claim.estimatedDamage > $10,000
    OR weather.maxWindSpeedAtProperty > 75 mph
  THEN priority = P3

  ELSE IF claim.estimatedDamage > deductible
  THEN priority = P4

  ELSE
    priority = P5

OUTPUT:
  claim.catPriority = priority
  claim.targetContactDate = NOW + priority.sla
  claim.assignmentPool = priority.adjusterPool
```

### Triage Scoring Model

For ML-based triage, a scoring model can be trained on historical CAT data:

| Feature | Weight | Source |
|---------|--------|--------|
| Habitability flag | 0.30 | FNOL |
| Estimated damage from FNOL | 0.15 | FNOL |
| Wind speed at property | 0.12 | Weather data |
| Storm surge depth at property | 0.10 | Flood model |
| Construction type vulnerability | 0.08 | Policy data |
| Building age | 0.05 | Policy data |
| Roof age | 0.05 | Property data |
| Distance to coastline | 0.05 | Geocoding |
| Elderly/disabled indicator | 0.05 | Policy data |
| Prior claim history | 0.03 | Claims history |
| Complaint/DOI history | 0.02 | Customer data |

---

## 14. Fast-Track Claims Processing

### Fast-Track Eligibility Criteria

| Criterion | Threshold | Rationale |
|-----------|-----------|-----------|
| Estimated damage | Below $10,000 or below policy deductible + $5,000 | Low complexity |
| Coverage clarity | No coverage questions (clear wind damage on HO policy) | No coverage investigation needed |
| Liability | First-party, no third-party involvement | No liability question |
| Damage type | Cosmetic (fence, siding, gutters, shed) | Standard repair scope |
| Photo documentation | Sufficient photos/video provided | No in-person inspection needed |
| Fraud indicators | No fraud flags triggered | Low fraud risk |

### Fast-Track Processing Flow

```
+------------------+     +-------------------+     +-------------------+
| FNOL Received    |---->| Auto-Triage       |---->| Fast-Track        |
| (Digital w/      |     | (Rules + ML)      |     | Eligible?         |
|  photos)         |     |                   |     |                   |
+------------------+     +-------------------+     +--------+----------+
                                                            |
                                              YES           |          NO
                                   +------------------------+--------+
                                   |                                 |
                          +--------v---------+              +--------v---------+
                          | Photo AI         |              | Standard CAT     |
                          | Analysis         |              | Queue            |
                          | (Damage          |              | (Assign to IA    |
                          |  estimation)     |              |  for inspection) |
                          +--------+---------+              +------------------+
                                   |
                          +--------v---------+
                          | Estimate         |
                          | Generation       |
                          | (Auto/assisted)  |
                          +--------+---------+
                                   |
                          +--------v---------+
                          | QA Review        |
                          | (Sample audit)   |
                          +--------+---------+
                                   |
                          +--------v---------+
                          | Settlement       |
                          | Offer to         |
                          | Policyholder     |
                          +--------+---------+
                                   |
                          +--------v---------+
                          | Payment          |
                          | (Same-day ACH    |
                          |  or check)       |
                          +------------------+
```

### Fast-Track Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| FNOL to settlement offer | < 48 hours | Timestamp difference |
| FNOL to payment | < 72 hours | Timestamp difference |
| Fast-track eligible rate | 20%–35% of CAT claims | Eligible / total claims |
| Customer acceptance rate | > 85% | Accepted / offered |
| Reopening rate | < 5% | Reopened / fast-track closed |
| Supplement rate | < 15% | Supplemented / fast-track closed |
| Customer satisfaction (CSAT) | > 4.2/5.0 | Post-close survey |

---

## 15. Managed Repair Programs for CAT

### Managed Repair Network

```
+-------------------+     +-------------------+     +-------------------+
| Claim Eligible    |---->| Contractor        |---->| Contractor        |
| for Managed       |     | Matching          |     | Assignment        |
| Repair            |     | (Location,skill,  |     | & Notification    |
|                   |     |  capacity,rating) |     |                   |
+-------------------+     +-------------------+     +--------+----------+
                                                             |
+-------------------+     +-------------------+     +--------v----------+
| Payment to        |<----| Work Completion   |<----| Scope & Estimate  |
| Contractor        |     | & QA              |     | Review            |
| (Direct billing)  |     | (Inspection,      |     | (Xactimate-based) |
|                   |     |  customer sign)   |     |                   |
+-------------------+     +-------------------+     +-------------------+
```

### Contractor Performance Scorecard

| Metric | Weight | Excellent | Good | Needs Improvement |
|--------|--------|-----------|------|-------------------|
| Quality score (QA inspection) | 25% | > 4.5/5 | 3.5–4.5 | < 3.5 |
| Cycle time (assignment to complete) | 20% | < 14 days | 14–21 days | > 21 days |
| Customer satisfaction | 20% | > 4.5/5 | 3.5–4.5 | < 3.5 |
| Supplement rate | 15% | < 5% | 5%–10% | > 10% |
| Callback/warranty rate | 10% | < 2% | 2%–5% | > 5% |
| Pricing competitiveness | 10% | Within 5% of benchmark | 5%–15% | > 15% |

---

## 16. Temporary Housing & ALE Management at Scale

### ALE (Additional Living Expense) Overview

ALE coverage (Coverage D in homeowners policies) pays for the increase in living expenses when a covered loss makes the insured property uninhabitable.

### ALE Calculation

```
ALE Payment = Temporary Living Costs - Normal Living Costs

Where:
  Temporary Living Costs:
    + Temporary housing (hotel, rental)
    + Meals (above normal grocery costs)
    + Laundry
    + Transportation (additional commute)
    + Storage of personal property
    + Pet boarding

  Normal Living Costs:
    - Mortgage payment (still due but not an ALE increase)
    - Normal utility costs
    - Normal grocery costs
    - Normal commute costs
```

### ALE Management at Scale During CAT

| Challenge | Solution | Technology |
|-----------|----------|-----------|
| Housing availability | Pre-negotiated hotel blocks, corporate apartments | Housing aggregation platform |
| Cost control | Daily rate caps by market, per diem guidelines | Automated rate validation |
| Duration management | Regular habitability reassessment, rebuild timeline | Case management workflow |
| Documentation | Receipts, logs, insured attestation | Mobile receipt capture, OCR |
| Fraud prevention | Duplicate address checks, rate reasonableness | Analytics, cross-referencing |
| Cash advances | Immediate $500–$2,000 advance for emergency expenses | Digital payment, same-day |

### ALE Data Model

```json
{
  "aleRecord": {
    "aleId": "ALE-2024-0045231-001",
    "claimId": "CLM-2024-0045231",
    "policyNumber": "HO-123456789",
    "coverageDLimit": 90000,
    "insuredProperty": {
      "address": "123 Ocean Drive, Tampa, FL 33701",
      "habitabilityStatus": "UNINHABITABLE",
      "uninhabitableDate": "2024-10-10",
      "estimatedRepairDuration": "6_MONTHS",
      "estimatedHabitableDate": "2025-04-10"
    },
    "temporaryHousing": [
      {
        "type": "HOTEL",
        "name": "Marriott Tampa",
        "startDate": "2024-10-10",
        "endDate": "2024-10-24",
        "dailyRate": 175.00,
        "totalCost": 2450.00
      },
      {
        "type": "RENTAL_APARTMENT",
        "name": "Furnished Finder #456",
        "startDate": "2024-10-25",
        "endDate": "2025-04-10",
        "monthlyRate": 2800.00,
        "totalCost": 15400.00
      }
    ],
    "expenses": [
      {
        "category": "MEALS",
        "amount": 3200.00,
        "normalCost": 1800.00,
        "alePayable": 1400.00
      },
      {
        "category": "LAUNDRY",
        "amount": 450.00,
        "normalCost": 100.00,
        "alePayable": 350.00
      },
      {
        "category": "PET_BOARDING",
        "amount": 2100.00,
        "normalCost": 0.00,
        "alePayable": 2100.00
      },
      {
        "category": "STORAGE",
        "amount": 1200.00,
        "normalCost": 0.00,
        "alePayable": 1200.00
      }
    ],
    "totalAleIncurred": 22900.00,
    "totalAlePaid": 18500.00,
    "remainingCoverageD": 67100.00,
    "advancePayments": [
      {
        "date": "2024-10-11",
        "amount": 2000.00,
        "type": "EMERGENCY_ADVANCE"
      }
    ]
  }
}
```

---

## 17. NFIP (National Flood Insurance Program) Claims

### NFIP Program Structure

```
+-------------------------------------------------------------------+
|                          FEMA / NFIP                                |
|  - Sets rates, coverage forms, claims procedures                    |
|  - Funds claims through National Flood Insurance Fund               |
+----------------------------+--------------------------------------+
                             |
              +--------------+---------------+
              |                              |
   +----------v-----------+     +-----------v-----------+
   | Write Your Own (WYO) |     | NFIP Direct           |
   | Program              |     | (FEMA direct to       |
   | (Private carriers    |     |  policyholder)        |
   |  issue/service NFIP  |     |                       |
   |  policies on behalf  |     | Claims serviced by    |
   |  of FEMA)            |     | FEMA contractors      |
   +----------+-----------+     +-----------+-----------+
              |                              |
              v                              v
   Same coverage forms, limits, and claims procedures
```

### NFIP Coverage Limits

| Coverage | Residential | Commercial |
|----------|------------|------------|
| Building | $250,000 max | $500,000 max |
| Contents | $100,000 max | $500,000 max |
| ALE / Business Interruption | Not covered | Not covered |
| Basement/Below Grade | Limited (specific items only) | Limited |

### NFIP Claims Processing Requirements

| Requirement | Detail | Timeline |
|-------------|--------|----------|
| Proof of Loss | Signed, sworn statement of loss | 60 days from loss (extendable) |
| Adjuster inspection | Required for all claims > $0 | Within 48 hours of assignment |
| Engineering inspection | Required for structural damage | Foundation/structural assessment |
| Substantial Damage determination | Community determines if damage > 50% of value | Post-event community assessment |
| ICC (Increased Cost of Compliance) | Up to $30,000 for code compliance | Must be substantially damaged |
| Appeals | NFIP appeal process, then litigation | Appeal within 60 days of denial |

### NFIP Proof of Loss Requirements

```
+-------------------------------------------------------------------+
|                    NFIP PROOF OF LOSS                               |
+-------------------------------------------------------------------+
| Required fields:                                                    |
|   - Policy number                                                   |
|   - Date and cause of loss                                          |
|   - Description of damaged property                                 |
|   - Detailed damage estimate (line items)                           |
|   - Total amount claimed (building)                                 |
|   - Total amount claimed (contents)                                 |
|   - Notarized signature of insured                                  |
|   - Supporting documentation (photos, receipts, inventory)          |
|                                                                     |
| Filing timeline:                                                    |
|   - 60 days from date of loss (standard)                            |
|   - Extension available upon written request                        |
|   - Waiver possible during CAT by FEMA directive                    |
|                                                                     |
| Consequence of non-filing:                                          |
|   - Claim may be denied                                             |
|   - Cannot sue under Standard Flood Insurance Policy                |
+-------------------------------------------------------------------+
```

### NFIP Claims Data Model

```json
{
  "nfipClaim": {
    "claimId": "NFIP-2024-FL-045231",
    "nfipPolicyNumber": "F-1234567890",
    "wyoCarrier": "COMPANY_XYZ",
    "wyoCompanyNumber": "12345",
    "communityNumber": "120153",
    "communityName": "TAMPA, CITY OF",
    "floodZone": "AE",
    "baseFloodElevation": 11,
    "lowestFloorElevation": 9,
    "buildingCoverage": 250000,
    "contentsCoverage": 100000,
    "deductible": {
      "building": 2000,
      "contents": 2000
    },
    "lossDetails": {
      "dateOfLoss": "2024-10-10",
      "causeOfLoss": "FLOOD",
      "floodType": "STORM_SURGE",
      "waterDepthInches": 36,
      "durationOfFloodingHours": 18
    },
    "proofOfLoss": {
      "status": "SUBMITTED",
      "submittedDate": "2024-11-15",
      "signedByInsured": true,
      "notarized": true,
      "buildingClaimed": 187500,
      "contentsClaimed": 78000
    },
    "icc": {
      "eligible": true,
      "substantialDamagePercent": 62,
      "iccAmount": 30000,
      "requiredImprovements": [
        "ELEVATION",
        "FLOOD_VENTS",
        "ELECTRICAL_ELEVATION"
      ]
    },
    "adjustments": {
      "buildingAdjusted": 175000,
      "contentsAdjusted": 72000,
      "iccAdjusted": 28500,
      "totalAdjusted": 275500
    }
  }
}
```

---

## 18. Earthquake Claims

### Earthquake Deductible Structures

| Type | Description | Typical Range |
|------|-------------|---------------|
| Percentage deductible | % of Coverage A (dwelling) | 5%–25% |
| Flat dollar deductible | Fixed dollar amount | $1,000–$50,000 |
| CEA deductible | California Earthquake Authority | 5%, 10%, 15%, 20%, 25% |

**Example:**
- Dwelling coverage: $500,000
- Earthquake deductible: 15%
- Deductible amount: $75,000

### Earthquake-Specific Damage Assessment

| Damage Type | Assessment Method | Special Considerations |
|-------------|------------------|----------------------|
| Foundation cracking | Engineering inspection | May require excavation |
| Chimney collapse | Visual + structural | Most common moderate EQ damage |
| Cripple wall failure | Structural engineering | Retrofit eligibility |
| Liquefaction | Geotechnical inspection | Soil analysis required |
| Masonry veneer failure | Visual inspection | Cosmetic vs. structural |
| Content breakage | Inventory + receipts | High-value items, art, wine |
| Pool/hardscape | Structural + cosmetic | Expensive to repair |

### Building Code Upgrade Coverage

```
Standard earthquake policy may include:
  - Ordinance or Law coverage (building code upgrades)
  - Typically 10%–25% of dwelling coverage
  - Covers:
    * Cost to bring undamaged portions up to current code
    * Demolition cost for undamaged portions if required by code
    * Increased construction cost to meet current building code
  - Key codes affecting earthquake repairs:
    * Seismic retrofit requirements
    * Soft-story ordinance compliance
    * Unreinforced masonry (URM) requirements
    * Foundation bolting requirements
```

---

## 19. Wildfire Claims

### Wildfire Claim Complexity

Wildfire claims are among the most complex property claims due to:

1. **Total loss prevalence**: 40%–60% of structures in fire path are total losses
2. **Extended ALE**: 12–36 months of temporary housing
3. **Debris removal**: Hazardous materials (asbestos, lead, toxins), EPA regulations
4. **Code upgrade**: Rebuilds must meet current building codes (often significantly different)
5. **Demand surge**: Construction costs inflate 30%–100% in fire-affected areas
6. **Extended replacement cost**: Policy may provide 125%–200% of dwelling limit

### Wildfire-Specific Coverages

| Coverage | Standard HO | Wildfire Enhancement | Typical Limits |
|----------|------------|---------------------|----------------|
| Dwelling (Cov A) | ACV or RCV | Extended Replacement Cost | 125%–200% of Cov A |
| Debris Removal | 5% of Cov A | Enhanced debris removal | 25%–50% of Cov A |
| ALE (Cov D) | 12 months | Extended to 24–36 months | 20%–30% of Cov A |
| Landscaping | 5% of Cov A | Enhanced landscaping | 10%–25% of Cov A |
| Code Upgrade | 10% of Cov A | Enhanced ordinance/law | 25%–50% of Cov A |
| Personal Property | ACV or RCV | Guaranteed RCV | 50%–75% of Cov A |

### Wildfire Total Loss Processing Steps

```
1.  Confirm total loss (fire department, adjuster, satellite imagery)
2.  Emergency ALE advance ($2,000–$5,000 immediate)
3.  Assign dedicated total loss adjuster
4.  Dwelling estimate: replacement cost new (RCV) of entire structure
5.  Contents inventory: room-by-room itemization
     - Insured completes detailed inventory worksheet
     - Each item: description, age, purchase price, replacement cost
     - Support with photos, receipts, credit card statements
6.  Debris removal estimate: environmental assessment
     - Asbestos testing (common in pre-1980 homes)
     - Soil contamination testing
     - EPA/state environmental compliance
7.  ALE setup: long-term rental, furnished
8.  Code upgrade assessment: current code vs. original construction
9.  Landscaping/hardscape assessment
10. Settlement offers:
     - ACV payment (immediate) = RCV - Depreciation
     - RCV holdback released upon repair/rebuild completion
     - Contents RCV holdback released upon replacement
11. Rebuild monitoring: progress inspections at milestones
12. Final settlement and claim closure
```

### Wildfire Debris Removal Complexity

| Phase | Activity | Cost Range | Duration |
|-------|----------|-----------|----------|
| Assessment | Environmental testing (asbestos, hazmat) | $2,000–$5,000 | 1–2 weeks |
| Permitting | EPA, state, local permits | $500–$2,000 | 2–4 weeks |
| Demolition | Structure removal | $5,000–$15,000 | 1–2 weeks |
| Hazmat removal | Asbestos, lead, chemicals | $10,000–$50,000 | 1–4 weeks |
| Soil remediation | Contaminated soil removal | $5,000–$30,000 | 1–4 weeks |
| Hauling | Debris transport to landfill | $5,000–$20,000 | 1–2 weeks |
| Final grading | Site preparation for rebuild | $3,000–$8,000 | 1 week |

---

## 20. CAT Financial Management

### Aggregate Monitoring

```
+-------------------------------------------------------------------+
|                CAT FINANCIAL MONITORING DASHBOARD                   |
+-------------------------------------------------------------------+
|                                                                     |
|  Event: Hurricane Milton (PCS-2024-015)                            |
|  Status: Active (Day 12)                                           |
|                                                                     |
|  +-------------------------------+  +-----------------------------+ |
|  | CLAIMS VOLUME                 |  | FINANCIAL SUMMARY           | |
|  | Reported:     45,231          |  | Incurred:    $1.24B         | |
|  | Open:         38,456          |  | Paid:        $312M          | |
|  | Closed:       6,775           |  | Reserves:    $928M          | |
|  | Fast-Tracked: 4,210           |  | IBNR:        $450M          | |
|  | Avg Severity: $27,420         |  | Total Est:   $1.69B         | |
|  +-------------------------------+  +-----------------------------+ |
|                                                                     |
|  +-------------------------------+  +-----------------------------+ |
|  | REINSURANCE                   |  | EXPENSE                     | |
|  | Treaty: $500M xs $200M       |  | ALAE:        $89M           | |
|  | Retention: $200M              |  | ULAE:        $34M           | |
|  | Ceded:   $640M               |  | IA Fees:     $67M           | |
|  | Remaining: $360M Layer 1      |  | Total Exp:   $123M          | |
|  | Cat Bond: Not triggered       |  | Expense %:   9.9%           | |
|  +-------------------------------+  +-----------------------------+ |
|                                                                     |
+-------------------------------------------------------------------+
```

### Reinsurance Notification Process

| Trigger | Notification | Timing | Content |
|---------|-------------|--------|---------|
| PCS designation | Preliminary notice | Within 24 hours | Event description, initial exposure |
| Retention breach probable | Formal notice | Within 72 hours | Updated loss estimate, reserve position |
| Retention breached | Formal claim | When paid losses exceed retention | Detailed bordereau, proof of loss |
| Monthly updates | Bordereaux | Monthly | Claim-level detail of CAT losses |
| Final settlement | Final report | At CAT closure | Final paid/incurred, ceded amounts |

### Catastrophe Excess of Loss Reinsurance Structure

```
+-------------------------------------------------------------------+
|                    REINSURANCE PROGRAM                              |
+-------------------------------------------------------------------+
|                                                                     |
|  Layer 4: $500M xs $1.2B  (ILW/Cat Bond)                          |
|  +---------------------------------------------------------+      |
|  | $500M excess of $1.2B attachment                         |      |
|  +---------------------------------------------------------+      |
|                                                                     |
|  Layer 3: $500M xs $700M  (Traditional reinsurance)                |
|  +---------------------------------------------------------+      |
|  | $500M excess of $700M attachment                          |      |
|  +---------------------------------------------------------+      |
|                                                                     |
|  Layer 2: $500M xs $200M  (Traditional reinsurance)                |
|  +---------------------------------------------------------+      |
|  | $500M excess of $200M attachment                          |      |
|  +---------------------------------------------------------+      |
|                                                                     |
|  Retention: $200M                                                  |
|  +---------------------------------------------------------+      |
|  | Company retains first $200M of CAT losses                |      |
|  +---------------------------------------------------------+      |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 21. CAT Vendor Management

### Emergency Vendor Categories

| Category | Services | Key Vendors | Deployment Speed |
|----------|----------|-------------|-----------------|
| Emergency board-up | Board broken windows/doors | ServiceMaster, BELFOR | < 4 hours |
| Water mitigation | Extraction, drying, dehumidification | SERVPRO, Paul Davis | < 4 hours |
| Tree removal | Fallen tree removal, clearing | Local arborists, Asplundh | 24–48 hours |
| Roofing (tarp) | Emergency tarping | Local roofers, CAT roofers | 24–72 hours |
| Generator services | Temporary power | United Rentals, Sunbelt | 24–48 hours |
| Contents pack-out | Inventory, pack, store, clean | ServiceMaster, BELFOR | 48–72 hours |
| Mold remediation | Assessment and remediation | AdvantaClean, local | 1–2 weeks |
| General contractor | Full repair/rebuild | Network contractors | 2–4 weeks |

### Vendor Activation Workflow

```
+------------------+     +-------------------+     +-------------------+
| CAT Declared     |---->| Vendor Master     |---->| Activate by       |
|                  |     | Contract Check    |     | Category/Region   |
|                  |     | (Active, capacity)|     |                   |
+------------------+     +-------------------+     +--------+----------+
                                                            |
+------------------+     +-------------------+     +--------v----------+
| Invoice          |<----| Work Orders       |<----| Assignment        |
| Processing       |     | & Completion      |     | (Match to claims) |
| (CAT pricing     |     | Tracking          |     |                   |
|  schedules)      |     |                   |     |                   |
+------------------+     +-------------------+     +-------------------+
```

---

## 22. State Regulatory Requirements During CAT

### Common Emergency Regulatory Actions

| Regulatory Action | Description | Typical Duration |
|------------------|-------------|-----------------|
| Cancellation/non-renewal moratorium | Carriers cannot cancel policies in affected area | 30–90 days |
| Claims settlement deadline extension | Extended time for claim investigation | 15–60 day extension |
| Premium grace period | Extended time for premium payment | 30–90 days |
| Proof of loss deadline extension | Extended deadline for NFIP and other proof of loss | 30–180 days |
| Licensing emergency orders | Temporary adjuster licensing | 90–180 days |
| Rate filing freeze | No rate increases in affected area | 6–12 months |
| Mandatory advance payments | Require partial payment within X days | $5,000–$10,000 within 48 hrs |

### State-Specific Requirements (Key States)

| State | Key CAT Requirements |
|-------|---------------------|
| **Florida** | 90-day cancellation moratorium, prompt pay penalties (18%+ interest on late payments), AOB reform provisions, mandatory 10% inspection within 14 days |
| **Texas** | Prompt payment (HB 1774), 18% penalty on late payments, $5,000 advance requirement within 5 days for habitability |
| **Louisiana** | 30-day claim acknowledgment, 30-day payment after agreement, penalty provisions, 1% penalty per day on late payments |
| **California** | Fair Claims Settlement Practices (10 CCR 2695), mandatory claim acknowledgment within 15 days, payment within 30 days of agreement |
| **New York** | Reg 64 prompt pay, 15-day acknowledgment, 35-day investigation, enhanced consumer protections |
| **North Carolina** | Unfair Claims Settlement Practices Act, mandatory response timelines, DOI complaint tracking |

### Regulatory Compliance Data Model

```json
{
  "catRegulatoryCompliance": {
    "catEventId": "PCS-2024-015",
    "affectedStates": [
      {
        "state": "FL",
        "emergencyOrders": [
          {
            "orderNumber": "EO-2024-FL-001",
            "issueDate": "2024-10-09",
            "effectiveDate": "2024-10-09",
            "expirationDate": "2025-01-07",
            "provisions": [
              {
                "type": "CANCELLATION_MORATORIUM",
                "affectedCounties": ["Hillsborough", "Pinellas", "Manatee"],
                "duration": 90
              },
              {
                "type": "ADJUSTER_EMERGENCY_LICENSE",
                "duration": 180
              },
              {
                "type": "PROOF_OF_LOSS_EXTENSION",
                "extensionDays": 60
              }
            ]
          }
        ],
        "complianceMetrics": {
          "claimsAcknowledgedWithin14Days": 0.97,
          "inspectionsWithin14Days": 0.89,
          "paymentsWithin90Days": 0.94,
          "doiComplaints": 127
        }
      }
    ]
  }
}
```

---

## 23. Public Communications & Customer Outreach

### Communication Phases

| Phase | Timing | Audience | Channels | Content |
|-------|--------|----------|----------|---------|
| Pre-event | 48–72 hrs before | All policyholders in zone | Email, SMS, app push | Preparation tips, emergency contacts, how to file claim |
| During event | During event | All policyholders in zone | SMS, social media, website | Safety first, report power outages, emergency services |
| Post-event | 0–48 hours after | All policyholders in zone | Email, SMS, app push, web | How to file claim, claim process overview, important numbers |
| Ongoing | Weekly | Claimants | Email, portal, SMS | Claim status updates, next steps, adjuster info |
| Completion | At resolution | Individual claimant | Email, mail, portal | Settlement details, payment info, survey |

### Proactive Communication Templates

**Pre-Event Notification:**

```
Subject: Hurricane Milton - Prepare Now and Know Your Coverage

Dear [Insured Name],

Hurricane Milton is expected to impact [County/Region] within the
next 48 hours. Here's what you need to know:

BEFORE THE STORM:
- Document your property with photos/video
- Secure important documents in waterproof container
- Know your evacuation route

YOUR COVERAGE:
- Policy Number: [Policy Number]
- Wind Deductible: [Deductible Amount]
- Flood Coverage: [Yes/No - separate policy required]

IF YOU HAVE DAMAGE:
- Call: 1-800-XXX-XXXX (24/7 claims hotline)
- Online: claims.company.com
- Mobile App: [App Name] on iOS/Android
- Do NOT make permanent repairs before adjuster inspection
- DO make emergency repairs to prevent further damage (save receipts)

Stay safe,
[Company Name] Claims Team
```

---

## 24. CAT Claims Data Model Extensions

### Core CAT Data Entities

```
+-------------------+       +-------------------+       +-------------------+
| CatastropheEvent  |       | AffectedZone      |       | DeploymentTeam    |
+-------------------+       +-------------------+       +-------------------+
| PK eventId        |<---+  | PK zoneId         |       | PK teamId         |
| pcsSerial         |    |  | FK eventId        |----+  | FK eventId        |
| eventName         |    |  | zoneName          |    |  | teamName          |
| eventType         |    |  | zoneType          |    |  | regionCode        |
| startDate         |    |  | geoPolygon        |    |  | teamLeadId        |
| endDate           |    |  | severityLevel     |    |  | baseLocation      |
| catLevel          |    |  | estimatedDamage   |    |  | activationDate    |
| status            |    |  | affectedPolicies  |    |  | deactivationDate  |
| estimatedLoss     |    |  | affectedProperties|    |  | status            |
| actualLoss        |    |  +-------------------+    |  +-------------------+
| reinsuranceTreaty |    |                            |
| pcsEstimate       |    |  +-------------------+    |  +-------------------+
+-------------------+    |  | CatClaim          |    |  | SurgeAdjuster     |
                         |  +-------------------+    |  +-------------------+
                         +--| FK eventId        |    |  | PK surgeAdjId     |
                            | FK claimId        |    +--| FK teamId         |
                            | FK zoneId         |       | adjusterId        |
                            | catPriority       |       | iaFirmId          |
                            | triageScore       |       | deploymentDate    |
                            | isFastTrack       |       | releaseDate       |
                            | fieldAdjusterId   |       | licensedStates[]  |
                            | inspectionDate    |       | certifications[]  |
                            | habitabilityFlag  |       | dailyRate         |
                            | aleRequired       |       | claimsAssigned    |
                            | damageZone        |       | claimsClosed      |
                            +-------------------+       | performanceScore  |
                                                        +-------------------+
```

### CatastropheEvent Table DDL

```sql
CREATE TABLE catastrophe_event (
    event_id            VARCHAR(20)     PRIMARY KEY,
    pcs_serial          VARCHAR(20)     UNIQUE,
    event_name          VARCHAR(100)    NOT NULL,
    event_type          VARCHAR(30)     NOT NULL
        CHECK (event_type IN ('HURRICANE','TORNADO','EARTHQUAKE','WILDFIRE',
               'FLOOD','HAIL','WINTER_STORM','CIVIL_UNREST','TERRORISM','PANDEMIC','OTHER')),
    start_date          DATE            NOT NULL,
    end_date            DATE,
    cat_level           SMALLINT        NOT NULL CHECK (cat_level BETWEEN 1 AND 4),
    status              VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('MONITORING','ACTIVE','WINDING_DOWN','CLOSED')),
    estimated_gross_loss DECIMAL(15,2),
    actual_gross_loss    DECIMAL(15,2),
    estimated_net_loss   DECIMAL(15,2),
    actual_net_loss      DECIMAL(15,2),
    estimated_claim_count INTEGER,
    actual_claim_count   INTEGER,
    affected_states      VARCHAR(200),
    reinsurance_treaty_id VARCHAR(20),
    reinsurance_notified BOOLEAN        DEFAULT FALSE,
    reinsurance_notification_date DATE,
    pcs_estimate_low     DECIMAL(15,2),
    pcs_estimate_mid     DECIMAL(15,2),
    pcs_estimate_high    DECIMAL(15,2),
    command_center_location VARCHAR(200),
    cat_director_id      VARCHAR(20),
    created_date         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date         TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    created_by           VARCHAR(50),
    updated_by           VARCHAR(50)
);

CREATE TABLE affected_zone (
    zone_id             VARCHAR(20)     PRIMARY KEY,
    event_id            VARCHAR(20)     NOT NULL REFERENCES catastrophe_event(event_id),
    zone_name           VARCHAR(100)    NOT NULL,
    zone_type           VARCHAR(30)     NOT NULL
        CHECK (zone_type IN ('WIND_FIELD','STORM_SURGE','FLOOD_EXTENT',
               'FIRE_PERIMETER','EARTHQUAKE_INTENSITY','HAIL_SWATH','DAMAGE_ZONE')),
    severity_level      VARCHAR(20)
        CHECK (severity_level IN ('CATASTROPHIC','SEVERE','MODERATE','MINOR')),
    geo_polygon         GEOMETRY(POLYGON, 4326),
    affected_policy_count INTEGER,
    affected_property_count INTEGER,
    estimated_damage     DECIMAL(15,2),
    zip_codes           TEXT[],
    counties            TEXT[],
    states              TEXT[],
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE deployment_team (
    team_id             VARCHAR(20)     PRIMARY KEY,
    event_id            VARCHAR(20)     NOT NULL REFERENCES catastrophe_event(event_id),
    team_name           VARCHAR(100)    NOT NULL,
    region_code         VARCHAR(10),
    team_lead_id        VARCHAR(20),
    base_location       VARCHAR(200),
    activation_date     DATE            NOT NULL,
    deactivation_date   DATE,
    status              VARCHAR(20)     DEFAULT 'ACTIVE'
        CHECK (status IN ('STANDBY','ACTIVE','WINDING_DOWN','DEACTIVATED')),
    target_daily_inspections INTEGER,
    actual_daily_inspections INTEGER,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE surge_adjuster (
    surge_adj_id        VARCHAR(20)     PRIMARY KEY,
    team_id             VARCHAR(20)     REFERENCES deployment_team(team_id),
    adjuster_id         VARCHAR(20)     NOT NULL,
    ia_firm_id          VARCHAR(20),
    deployment_date     DATE            NOT NULL,
    release_date        DATE,
    licensed_states     TEXT[]          NOT NULL,
    certifications      TEXT[],
    daily_rate          DECIMAL(10,2),
    per_claim_fee       DECIMAL(10,2),
    claims_assigned     INTEGER         DEFAULT 0,
    claims_closed       INTEGER         DEFAULT 0,
    claims_in_progress  INTEGER         DEFAULT 0,
    performance_score   DECIMAL(5,2),
    quality_score       DECIMAL(5,2),
    cycle_time_avg_days DECIMAL(5,1),
    status              VARCHAR(20)     DEFAULT 'ACTIVE'
        CHECK (status IN ('PENDING','ACTIVE','ON_HOLD','RELEASED')),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cat_claim (
    cat_claim_id        VARCHAR(20)     PRIMARY KEY,
    event_id            VARCHAR(20)     NOT NULL REFERENCES catastrophe_event(event_id),
    claim_id            VARCHAR(20)     NOT NULL,
    zone_id             VARCHAR(20)     REFERENCES affected_zone(zone_id),
    cat_priority        VARCHAR(5)      NOT NULL
        CHECK (cat_priority IN ('P1','P2','P3','P4','P5')),
    triage_score        DECIMAL(5,2),
    is_fast_track       BOOLEAN         DEFAULT FALSE,
    field_adjuster_id   VARCHAR(20),
    inspection_date     DATE,
    inspection_type     VARCHAR(20)
        CHECK (inspection_type IN ('FIELD','VIRTUAL','DRONE','DESK','SATELLITE')),
    habitability_flag   BOOLEAN         DEFAULT TRUE,
    ale_required        BOOLEAN         DEFAULT FALSE,
    ale_record_id       VARCHAR(20),
    damage_zone         VARCHAR(20),
    wind_speed_at_property DECIMAL(5,1),
    water_depth_inches  DECIMAL(5,1),
    is_total_loss       BOOLEAN         DEFAULT FALSE,
    fast_track_eligible BOOLEAN,
    emergency_services_dispatched BOOLEAN DEFAULT FALSE,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
```

### CAT Event API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/cat-events` | Create new CAT event |
| GET | `/api/v1/cat-events/{eventId}` | Get CAT event details |
| PUT | `/api/v1/cat-events/{eventId}` | Update CAT event |
| GET | `/api/v1/cat-events/{eventId}/claims` | List claims for CAT event |
| GET | `/api/v1/cat-events/{eventId}/zones` | List affected zones |
| POST | `/api/v1/cat-events/{eventId}/zones` | Add affected zone |
| GET | `/api/v1/cat-events/{eventId}/teams` | List deployment teams |
| POST | `/api/v1/cat-events/{eventId}/teams` | Create deployment team |
| GET | `/api/v1/cat-events/{eventId}/financials` | Get financial summary |
| GET | `/api/v1/cat-events/{eventId}/dashboard` | Get real-time dashboard data |
| POST | `/api/v1/cat-events/{eventId}/claims/{claimId}/triage` | Triage a claim |
| POST | `/api/v1/cat-events/{eventId}/claims/{claimId}/fast-track` | Fast-track a claim |
| GET | `/api/v1/cat-events/{eventId}/surge-adjusters` | List surge adjusters |
| POST | `/api/v1/cat-events/{eventId}/surge-adjusters` | Deploy surge adjuster |

---

## 25. Technology Platform Requirements for CAT Scalability

### Auto-Scaling Architecture

```
+-------------------------------------------------------------------+
|                    CAT SCALABILITY ARCHITECTURE                     |
+-------------------------------------------------------------------+
|                                                                     |
|  NORMAL STATE                    CAT STATE                         |
|  ============                    =========                         |
|                                                                     |
|  Web Tier:                       Web Tier:                         |
|  2 instances (t3.xlarge)    -->  20 instances (c5.2xlarge)         |
|                                                                     |
|  API Tier:                       API Tier:                         |
|  4 pods (2 CPU/4GB)        -->  40 pods (4 CPU/8GB)               |
|                                                                     |
|  FNOL Service:                   FNOL Service:                     |
|  2 pods                    -->  20 pods                            |
|                                                                     |
|  Database:                       Database:                         |
|  1 writer + 2 readers      -->  1 writer + 8 readers              |
|  (db.r5.2xlarge)                (db.r5.4xlarge)                   |
|                                                                     |
|  Message Queue:                  Message Queue:                    |
|  Standard throughput        -->  Enhanced throughput, extra partns |
|                                                                     |
|  Storage:                        Storage:                          |
|  Standard S3               -->  S3 + CloudFront for imagery       |
|                                                                     |
+-------------------------------------------------------------------+
```

### Offline Capability Requirements

During CAT events, field adjusters often work in areas with no or degraded connectivity:

| Capability | Offline Requirement | Sync Strategy |
|------------|-------------------|---------------|
| Claim view | Full claim data cached locally | Sync on connectivity |
| Photo capture | Store locally with GPS metadata | Background upload on connectivity |
| Estimate writing | Full Xactimate offline mode | Manual sync |
| FNOL creation | Create offline, queue for sync | Auto-sync with conflict resolution |
| Payment authorization | Cache authorization, execute online | Queue-based execution |
| Maps/navigation | Offline map tiles pre-downloaded | Pre-load before deployment |
| Reference data | Price lists, code tables cached | Periodic refresh |

### Cloud Auto-Scaling Configuration (AWS Example)

```json
{
  "autoScalingPolicy": {
    "serviceName": "fnol-service",
    "normalState": {
      "minInstances": 2,
      "maxInstances": 10,
      "targetCpuUtilization": 60,
      "targetRequestsPerInstance": 100
    },
    "catState": {
      "minInstances": 20,
      "maxInstances": 100,
      "targetCpuUtilization": 50,
      "targetRequestsPerInstance": 80,
      "scaleUpCooldown": 60,
      "scaleDownCooldown": 300
    },
    "catTrigger": {
      "type": "CUSTOM_METRIC",
      "metric": "cat_event_active",
      "threshold": 1,
      "action": "SWITCH_TO_CAT_STATE"
    },
    "scalingMetrics": [
      {
        "metric": "CPUUtilization",
        "targetValue": 50,
        "weight": 0.4
      },
      {
        "metric": "RequestCountPerTarget",
        "targetValue": 80,
        "weight": 0.3
      },
      {
        "metric": "QueueDepth",
        "targetValue": 100,
        "weight": 0.3
      }
    ]
  }
}
```

### Technology Checklist for CAT Readiness

| Area | Requirement | Validation |
|------|------------|------------|
| Load testing | Test 10x–20x normal volume | Quarterly load test |
| Auto-scaling | Verified scaling policies | Test scale-up in staging |
| Database | Read replica promotion, connection pooling | Failover test |
| CDN | Static assets cached globally | Cache warming test |
| Queue | Dead letter queue, retry policies | Message backlog test |
| Mobile | Offline sync tested, battery optimization | Field test |
| Monitoring | Dashboards, alerts, runbooks | Drill exercise |
| DR | Multi-region failover | Annual DR test |
| Data | Backup/restore tested | Monthly backup verification |
| Security | DDoS protection, rate limiting | Penetration test |

---

## 26. Post-CAT Analysis & Lessons Learned

### Post-CAT Review Process

```
+------------------+     +------------------+     +------------------+
| 1. Data          |---->| 2. Performance   |---->| 3. Financial     |
|    Collection    |     |    Analysis      |     |    Analysis      |
| (30 days post)   |     | (45 days post)   |     | (60 days post)   |
+------------------+     +------------------+     +------------------+
         |                        |                        |
         v                        v                        v
+------------------+     +------------------+     +------------------+
| 4. Lessons       |---->| 5. Action Plan   |---->| 6. Implementation|
|    Learned       |     |    Development   |     |    & Tracking    |
|    Workshop      |     | (90 days post)   |     | (Ongoing)        |
| (75 days post)   |     |                  |     |                  |
+------------------+     +------------------+     +------------------+
```

### Key Metrics for Post-CAT Analysis

| Category | Metric | Target | Actual (Example) |
|----------|--------|--------|-----------------|
| **FNOL** | Avg wait time (phone) | < 5 min | 12 min (Day 2) |
| **FNOL** | Abandon rate | < 10% | 18% (Day 1-3) |
| **FNOL** | Digital FNOL % | > 40% | 35% |
| **Triage** | P1 contact within 4 hrs | > 95% | 91% |
| **Inspection** | Avg days FNOL to inspection | < 5 days | 7.2 days |
| **Cycle time** | Avg days FNOL to first payment | < 15 days | 18.5 days |
| **Cycle time** | Avg days FNOL to close | < 60 days | 74 days |
| **Financial** | Reserve adequacy at 30 days | Within 10% | -15% (under-reserved) |
| **Financial** | Expense ratio | < 12% | 10.8% |
| **Customer** | NPS (CAT claimants) | > 30 | 24 |
| **Customer** | CSAT | > 3.5/5 | 3.2/5 |
| **Customer** | DOI complaints | < 1% of claims | 0.8% |
| **Vendor** | IA quality score | > 4.0/5 | 3.8/5 |
| **Vendor** | Contractor completion rate | > 90% | 87% |

---

## 27. CAT Claims Dashboards & Real-Time Monitoring

### Executive CAT Dashboard

```
+===================================================================+
|  HURRICANE MILTON - CAT RESPONSE DASHBOARD                  [LIVE] |
+===================================================================+
|                                                                     |
|  EVENT STATUS: ACTIVE (Day 12)  |  CAT LEVEL: 3  |  PCS: 2024-015 |
|                                                                     |
|  +---------------------------+  +---------------------------+       |
|  | CLAIMS VOLUME             |  | TODAY'S ACTIVITY          |       |
|  |  Reported:    45,231      |  |  New FNOL:     1,234      |       |
|  |  Open:        38,456      |  |  Inspections:    456      |       |
|  |  Closed:       6,775      |  |  Payments:       312      |       |
|  |  Close Rate:   15.0%      |  |  Closures:       289      |       |
|  +---------------------------+  +---------------------------+       |
|                                                                     |
|  +---------------------------+  +---------------------------+       |
|  | FINANCIAL                 |  | RESOURCES                 |       |
|  |  Gross Incurred: $1.24B   |  |  Active Adjusters:  342   |       |
|  |  Paid:          $312M     |  |  Daily Inspections:  456  |       |
|  |  Outstanding:   $928M     |  |  Insp per Adjuster: 1.3   |       |
|  |  Avg Severity:  $27.4K    |  |  IA Firms Active:     5   |       |
|  +---------------------------+  +---------------------------+       |
|                                                                     |
|  +---------------------------+  +---------------------------+       |
|  | SLA COMPLIANCE            |  | CUSTOMER                  |       |
|  |  P1 4hr Contact:   91%   |  |  NPS:              24     |       |
|  |  14-day Inspection: 78%   |  |  CSAT:            3.2     |       |
|  |  30-day Payment:    85%   |  |  DOI Complaints:  127     |       |
|  |  Regulatory:        94%   |  |  Callback Queue:  456     |       |
|  +---------------------------+  +---------------------------+       |
|                                                                     |
|  CLAIM VOLUME TREND (DAILY NEW FNOL)                               |
|  5000|                                                              |
|  4000|     X                                                        |
|  3000|   X   X                                                      |
|  2000| X       X   X                                                |
|  1000|             X   X   X                                        |
|   500|                       X   X   X   X   X                      |
|      +--+--+--+--+--+--+--+--+--+--+--+--+--+-->                  |
|       D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12                     |
|                                                                     |
|  GEOGRAPHIC HEAT MAP                                                |
|  [Interactive map showing claim density by zip code]               |
|  Legend: ■ >500 claims  ■ 100-500  ■ 50-100  ■ <50               |
|                                                                     |
+===================================================================+
```

### Dashboard Technology Architecture

```
+-------------------------------------------------------------------+
|                   REAL-TIME DASHBOARD ARCHITECTURE                  |
+-------------------------------------------------------------------+
|                                                                     |
|  +---------------+     +-------------------+                        |
|  | Claims DB     |---->| CDC (Change Data  |                        |
|  | (PostgreSQL)  |     |  Capture - Debezium)|                      |
|  +---------------+     +--------+----------+                        |
|                                  |                                   |
|                         +--------v----------+                        |
|                         | Kafka / Kinesis   |                        |
|                         | (Event Stream)    |                        |
|                         +--------+----------+                        |
|                                  |                                   |
|                    +-------------+-------------+                     |
|                    |                           |                     |
|           +--------v----------+    +-----------v--------+           |
|           | Stream Processing |    | Analytics DB       |           |
|           | (Flink / Spark    |    | (ClickHouse /      |           |
|           |  Streaming)       |    |  Druid / Redshift) |           |
|           +--------+----------+    +-----------+--------+           |
|                    |                           |                     |
|           +--------v----------+    +-----------v--------+           |
|           | Real-time Cache   |    | BI Tool            |           |
|           | (Redis /          |    | (Tableau / Power BI|           |
|           |  ElastiCache)     |    |  / Grafana)        |           |
|           +--------+----------+    +--------------------+           |
|                    |                                                 |
|           +--------v----------+                                      |
|           | WebSocket Server  |                                      |
|           | (Push updates to  |                                      |
|           |  dashboard clients)|                                     |
|           +-------------------+                                      |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 28. Historical CAT Event Case Studies

### Case Study 1: Hurricane Katrina (2005)

| Attribute | Detail |
|-----------|--------|
| PCS Serial | PCS-2005-025 |
| Insured Losses | ~$65 billion (2005 dollars) |
| Total Claims | ~1.7 million |
| Key Issues | NFIP underfunding, wind vs. water disputes, adjuster shortage |
| Lessons | Need for clear wind/water delineation, NFIP reform, surge capacity planning |

**Technology Lessons:**
- Paper-based processes collapsed under volume
- Limited mobile technology hampered field operations
- GPS/mapping technology was immature
- Claims systems were not designed for volume

### Case Study 2: Hurricane Harvey (2017)

| Attribute | Detail |
|-----------|--------|
| PCS Serial | PCS-2017-017 |
| Insured Losses | ~$30 billion |
| Total Claims | ~790,000 |
| Key Issues | Unprecedented rainfall (60+ inches), flooding in non-flood-zone areas, NFIP claims volume |
| Lessons | Flood risk beyond flood zones, need for real-time weather/claim correlation, digital FNOL importance |

**Technology Lessons:**
- Digital FNOL channels performed well under surge
- Aerial imagery (drones + satellites) proved transformational
- Data analytics enabled better triage and prioritization
- Still significant adjuster deployment challenges

### Case Study 3: 2020 Derecho / COVID-19

| Attribute | Detail |
|-----------|--------|
| Events | Iowa Derecho (Aug 2020) + COVID-19 Pandemic |
| Unique Challenge | CAT event during pandemic lockdown |
| Insured Losses | ~$11 billion (Derecho) |
| Key Issues | No in-person inspections possible, adjuster travel restrictions, supply chain disruption |
| Lessons | Virtual inspection capability essential, remote adjuster workforce, digital-first claims |

**Technology Lessons:**
- Virtual inspection via video call became standard
- Photo-based AI estimation enabled desk adjusting
- Cloud-based systems enabled remote workforce
- Supply chain visibility tools needed for repair timelines

### Case Study 4: Marshall Fire, Colorado (2021)

| Attribute | Detail |
|-----------|--------|
| Event | Marshall Fire (December 2021) |
| Insured Losses | ~$2 billion |
| Total Losses | 1,084 homes destroyed, 149 damaged |
| Unique Challenge | Urban-wildland interface fire, winter fire, rapid spread |
| Lessons | Wildfire risk in unexpected areas, total loss processing at scale, code upgrade complexity |

**Technology Lessons:**
- Satellite pre/post comparison crucial for total loss confirmation
- Inventory documentation tech (home inventory apps) helped contents claims
- Code upgrade estimating tools needed (significant code changes since original build)
- ALE management platform essential for long-term displacement

### Evolving CAT Landscape

| Trend | Impact on Claims | Technology Response |
|-------|-----------------|-------------------|
| Climate change | More frequent/severe events | Better predictive models, scalable platforms |
| Urbanization | Higher concentration of insured values | Granular geocoding, exposure analytics |
| Construction costs | Higher severity per claim | Real-time pricing integration |
| Technology advances | Better detection, faster response | AI, drones, satellite, IoT |
| Regulatory evolution | Stricter consumer protection | Automated compliance monitoring |
| Workforce changes | Aging adjuster workforce | Virtual inspection, AI-assisted adjusting |

---

## Appendix A: CAT Response Checklist

```
PRE-EVENT (72 Hours Before)
[ ] Weather monitoring activated
[ ] Exposure analysis run for potential impact zone
[ ] IA firms notified and on standby
[ ] Call center surge plan activated
[ ] Technology scaling runbook reviewed
[ ] Customer pre-event communications sent
[ ] Reinsurance team notified
[ ] Regulatory contact list updated

EVENT DECLARATION (T+0)
[ ] CAT level determined and declared
[ ] Command center activated (physical/virtual)
[ ] CAT Director assigned and briefed
[ ] IA firms activated with volume commitments
[ ] Technology auto-scaling triggered
[ ] Call center overflow activated
[ ] Customer post-event communications queued
[ ] Regulatory notifications sent
[ ] Media/PR response prepared

FIRST 72 HOURS
[ ] FNOL surge channels operational
[ ] Triage rules activated
[ ] P1 claims identified and prioritized
[ ] Emergency services dispatched (board-up, water mitigation)
[ ] ALE hotline operational
[ ] Field deployment logistics confirmed
[ ] Reinsurance formal notification sent
[ ] Financial reserves established (bulk IBNR)

FIRST 2 WEEKS
[ ] Field adjusters deployed and inspecting
[ ] Fast-track processing active
[ ] Managed repair network activated
[ ] ALE long-term housing coordination
[ ] Daily financial reporting operational
[ ] Regulatory compliance monitoring active
[ ] Customer communication cadence established
[ ] Vendor performance monitoring active

WIND-DOWN (30+ Days)
[ ] Volume returning to manageable levels
[ ] IA release planning initiated
[ ] Open claim inventory management
[ ] Supplement/reopening process established
[ ] Financial reconciliation underway
[ ] Lessons learned planning initiated
```

---

## Appendix B: Glossary of CAT Terms

| Term | Definition |
|------|-----------|
| ALE | Additional Living Expense - Coverage D in homeowners policies |
| AOB | Assignment of Benefits - transfer of insurance claim rights to third party |
| CAT | Catastrophe - large-scale disaster event |
| CEA | California Earthquake Authority |
| DRP | Direct Repair Program |
| FEMA | Federal Emergency Management Agency |
| FNOL | First Notice of Loss |
| IA | Independent Adjuster |
| IBNR | Incurred But Not Reported - reserve for claims not yet filed |
| ICC | Increased Cost of Compliance (NFIP) |
| MMI | Modified Mercalli Intensity (earthquake) |
| NFIP | National Flood Insurance Program |
| PCS | Property Claim Services (Verisk) |
| PML | Probable Maximum Loss |
| RCV | Replacement Cost Value |
| TIV | Total Insured Value |
| TRIA | Terrorism Risk Insurance Act |
| WYO | Write Your Own (NFIP) |

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 17 (Vendor & Partner Ecosystem), Article 20 (Claims Analytics), and Article 14 (Fraud Detection).*
