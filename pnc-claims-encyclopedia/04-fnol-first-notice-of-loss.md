# First Notice of Loss (FNOL): Complete Deep Dive

> **Audience:** Solutions Architects designing and building Property & Casualty claims systems.
> **Version:** 1.0 | **Last Updated:** 2026-04-16

---

## Table of Contents

1. [FNOL Definition & Business Importance](#1-fnol-definition--business-importance)
2. [FNOL Intake Channels](#2-fnol-intake-channels)
3. [Channel-Specific Data Capture & UX](#3-channel-specific-data-capture--ux)
4. [Complete FNOL Data Model (200+ Fields)](#4-complete-fnol-data-model-200-fields)
5. [Field-Level Validation Rules](#5-field-level-validation-rules)
6. [Business Rules Engine Integration](#6-business-rules-engine-integration)
7. [Auto-Assignment Rules & Algorithms](#7-auto-assignment-rules--algorithms)
8. [Coverage Verification During FNOL](#8-coverage-verification-during-fnol)
9. [Duplicate Detection Algorithms](#9-duplicate-detection-algorithms)
10. [FNOL Scoring Models](#10-fnol-scoring-models)
11. [Straight-Through Processing (STP)](#11-straight-through-processing-stp)
12. [FNOL-to-Claim Creation Logic](#12-fnol-to-claim-creation-logic)
13. [Multi-Claimant & Multi-Vehicle Handling](#13-multi-claimant--multi-vehicle-handling)
14. [Catastrophe FNOL Surge Handling](#14-catastrophe-fnol-surge-handling)
15. [IVR & Telephony Integration](#15-ivr--telephony-integration)
16. [Speech-to-Text & NLP for FNOL](#16-speech-to-text--nlp-for-fnol)
17. [FNOL API Design](#17-fnol-api-design)
18. [FNOL Workflow State Machine](#18-fnol-workflow-state-machine)
19. [Performance Metrics & KPIs](#19-performance-metrics--kpis)
20. [FNOL Data Quality Scoring](#20-fnol-data-quality-scoring)
21. [Policy Admin System Integration](#21-policy-admin-system-integration)
22. [Sample FNOL JSON Payloads](#22-sample-fnol-json-payloads)

---

## 1. FNOL Definition & Business Importance

### 1.1 Definition

**First Notice of Loss (FNOL)** is the initial report of a loss, damage, or injury made by (or on behalf of) the insured to the insurance company. It is the event that triggers the entire claims process and creates the foundational record upon which all subsequent claims handling is built.

### 1.2 Business Importance

| Dimension | Impact |
|---|---|
| **Customer Experience** | FNOL is the insured's first interaction with the claims process and often their most stressful moment. A smooth, empathetic FNOL experience directly impacts NPS and retention. |
| **Cycle Time** | FNOL data quality determines how quickly the claim can progress. Incomplete FNOLs cause delays, callbacks, and rework. |
| **Fraud Detection** | Early detection of fraud indicators at FNOL dramatically reduces loss. First-party fraud is 10-20% of all claims. |
| **Reserve Accuracy** | Initial FNOL data feeds initial reserving algorithms. Better FNOL data = better initial reserves = better financial projections. |
| **Assignment Quality** | FNOL data drives triage and assignment. The right adjuster gets the right claim at the right time. |
| **Straight-Through Processing** | High-quality, complete FNOLs enable automated handling of simple claims, reducing cost per claim from $200+ to <$20. |
| **Regulatory Compliance** | Many states mandate acknowledgment timelines measured from FNOL receipt. The FNOL timestamp starts the regulatory clock. |
| **Catastrophe Response** | FNOL volume and patterns during catastrophes drive resource deployment and reinsurance notifications. |

### 1.3 FNOL Cost Metrics

| Metric | Industry Average |
|---|---|
| Cost per phone FNOL | $30-$50 |
| Cost per web/mobile FNOL | $5-$10 |
| Cost per automated (STP) FNOL | $1-$3 |
| Average FNOL call duration | 12-18 minutes |
| Average FNOL web session | 8-15 minutes |
| FNOL-to-contact time (SLA) | 24-48 hours |
| Percentage of FNOLs requiring callback for missing info | 20-40% |
| Percentage of FNOLs eligible for STP | 5-15% (varies widely) |

---

## 2. FNOL Intake Channels

### 2.1 Channel Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                     FNOL INTAKE CHANNELS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                │
│  │ PHONE /      │ │  WEB PORTAL  │ │  MOBILE APP  │                │
│  │ CALL CENTER  │ │              │ │              │                │
│  │  (~50-65%)   │ │  (~15-25%)   │ │  (~10-20%)   │                │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘                │
│         │                │                │                         │
│  ┌──────▼───────┐ ┌──────▼───────┐ ┌──────▼───────┐                │
│  │ AGENT/BROKER │ │   EMAIL      │ │  EDI/API     │                │
│  │  PORTAL      │ │              │ │              │                │
│  │  (~5-10%)    │ │  (~2-5%)     │ │  (~3-5%)     │                │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘                │
│         │                │                │                         │
│  ┌──────▼───────┐ ┌──────▼───────┐ ┌──────▼───────┐                │
│  │  IoT /       │ │  CHAT /      │ │  SOCIAL      │                │
│  │ TELEMATICS   │ │  CHATBOT     │ │  MEDIA       │                │
│  │  (~1-5%)     │ │  (~2-5%)     │ │  (<1%)       │                │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘                │
│         │                │                │                         │
│         └────────────────┼────────────────┘                         │
│                          │                                          │
│                   ┌──────▼──────────────┐                           │
│                   │  FNOL ORCHESTRATION  │                           │
│                   │  ENGINE              │                           │
│                   │  (Normalize, Enrich, │                           │
│                   │   Validate, Route)   │                           │
│                   └─────────────────────┘                           │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Channel Characteristics

| Channel | Volume | Data Quality | Cost | Speed | Best For |
|---|---|---|---|---|---|
| Phone/Call Center | Highest | High (CSR-guided) | $30-50 | Real-time | Complex claims, elderly, immediate needs |
| Web Portal | Growing | Medium-High | $5-10 | Self-service | Tech-savvy insureds, simple claims |
| Mobile App | Growing fast | Medium-High | $3-8 | Self-service | Auto claims (photos from scene), quick report |
| Agent/Broker Portal | Moderate | High | $15-25 | Same-day | Commercial lines, agent-managed accounts |
| Email | Declining | Low (unstructured) | $20-40 | Delayed | Documentary evidence, follow-up |
| EDI/API | Moderate | Very High (structured) | $1-5 | Automated | TPA, fleet, telematics |
| IoT/Telematics | Emerging | Varies | $1-3 | Automatic | Auto collision detection, smart home |
| Chat/Chatbot | Growing | Medium | $5-15 | Real-time | Simple claims, initial triage |
| Social Media | Rare | Low | $25+ | Variable | Brand monitoring, outreach |
| Walk-in | Rare | High | $50+ | Same-day | Local/mutual carriers |

---

## 3. Channel-Specific Data Capture & UX

### 3.1 Phone / Call Center FNOL

```
Call Flow — FNOL Phone Intake:

1. CALLER IDENTIFICATION
   ├── Caller name and relationship to insured
   ├── Policy number (or name + address + DOB lookup)
   └── Callback number

2. POLICY VERIFICATION (real-time PAS lookup)
   ├── Confirm named insured
   ├── Verify policy in-force
   └── Display coverages/vehicles/properties

3. LOSS DETAILS (guided interview)
   ├── What happened? (narrative)
   ├── When did it happen? (date/time)
   ├── Where did it happen? (address/location)
   ├── How did it happen? (cause of loss)
   └── Who was involved? (parties, witnesses)

4. LINE-SPECIFIC QUESTIONS
   ├── Auto: vehicles, drivers, passengers, injuries, police report
   ├── Property: type of damage, habitability, emergency repairs needed
   ├── Liability: injured parties, witness info, incident description
   └── WC: employer, employee, injury type, body part, medical treatment

5. IMMEDIATE NEEDS ASSESSMENT
   ├── Emergency services needed?
   ├── Rental car needed?
   ├── Emergency repairs authorized?
   ├── Temporary housing needed?
   └── Medical referral needed?

6. CLAIM CREATION & CONFIRMATION
   ├── Read back key information for verification
   ├── Provide claim number
   ├── Explain next steps and timeline
   ├── Provide adjuster contact info (if assigned)
   └── Provide self-service portal info

CSR Screen Design Considerations:
  - Policy and coverage info pre-populated after lookup
  - Dynamic questions based on LOB and cause of loss
  - Required field indicators clearly visible
  - Duplicate detection running in background during entry
  - Fraud scoring running in background
  - Real-time ISO ClaimSearch during data entry
  - Script prompts for empathy statements
  - One-click emergency service dispatch
```

### 3.2 Web Portal FNOL

```
Web FNOL User Experience:

Page 1: GET STARTED
  ├── Policy number or login
  ├── Brief: "What happened?" (auto, property, injury, other)
  └── Date of loss

Page 2: POLICY CONFIRMATION
  ├── Display policy summary (auto-populated from PAS)
  ├── Confirm named insured
  ├── Select applicable vehicle/property/location
  └── Error handling for expired/cancelled policies

Page 3: LOSS DETAILS
  ├── Date and time selector
  ├── Location (address autocomplete, map integration)
  ├── Cause of loss dropdown (context-sensitive by LOB)
  ├── Description (text area, 500+ characters, with guided prompts)
  └── Police/fire report information

Page 4: PARTIES & VEHICLES (dynamic based on claim type)
  ├── Other party information form (repeatable)
  ├── Other vehicle information (repeatable)
  ├── Injured party information (repeatable)
  ├── Witness information (repeatable)
  └── "Add another" functionality

Page 5: DAMAGE DETAILS
  ├── Auto: point of impact selector (visual diagram), drivable?, towed?, airbags?
  ├── Property: affected areas checklist, habitability, photos upload
  ├── Photo/document upload (drag-and-drop, camera integration)
  └── Estimated damage amount (optional)

Page 6: REVIEW & SUBMIT
  ├── Summary of all entered information
  ├── Edit capability for each section
  ├── Consent / attestation checkbox
  └── Submit button

Page 7: CONFIRMATION
  ├── Claim number prominently displayed
  ├── Expected next steps and timeline
  ├── Assigned adjuster info (if auto-assigned)
  ├── Link to track claim status
  ├── Email confirmation sent
  └── Save/print confirmation

UX Design Principles:
  ✓ Progressive disclosure (don't overwhelm)
  ✓ Context-sensitive fields (show only what's relevant)
  ✓ Auto-save (don't lose data on browser crash)
  ✓ Mobile-responsive (many start on phone, finish on desktop)
  ✓ Accessibility (WCAG 2.1 AA compliance)
  ✓ Multi-language support
  ✓ Photo upload from device camera
  ✓ Address autocomplete (Google Places / SmartyStreets)
  ✓ VIN decoder (auto-populate year/make/model from VIN)
  ✓ Estimated completion time displayed
  ✓ Save and continue later capability
```

### 3.3 Mobile App FNOL

```
Mobile FNOL Features:

UNIQUE MOBILE CAPABILITIES:
├── GPS auto-detect loss location
├── Camera-first: photo/video capture of scene and damage
├── VIN scan via camera (barcode/OCR)
├── Insurance card photo capture (other party)
├── Driver's license scan (OCR extraction)
├── Police report number scan
├── Voice-to-text for loss description
├── Push notifications for claim updates
├── Crash detection (accelerometer/gyroscope)
├── Digital ID card sharing
└── Telematics trip reconstruction

MOBILE FNOL FLOW:
1. "Report a Claim" (one-tap from home screen)
2. Select type: Car Accident | Home Damage | Injury | Other
3. Are you safe? (safety-first screen)
4. If emergency: one-tap 911 + roadside assistance
5. Take photos (guided: front, back, left, right, close-up, VIN, odometer)
6. Location auto-detected (confirm or adjust)
7. Quick questions (cause, date/time, police report)
8. Other party info (scan their license + insurance card)
9. Injury check (anyone hurt? ambulance called?)
10. Review and submit
11. Confirmation + claim number + next steps
```

### 3.4 IoT / Telematics FNOL

```
Telematics-Triggered FNOL:

EVENT DETECTION:
  Telematics device (OBD-II, phone app, or embedded) detects:
  ├── Hard impact event (accelerometer threshold exceeded)
  ├── Airbag deployment signal
  ├── Sudden deceleration pattern
  └── Vehicle inoperability after event

AUTO-FNOL CREATION:
  Data automatically captured:
  ├── Timestamp (exact to millisecond)
  ├── GPS coordinates (loss location)
  ├── Speed at time of impact
  ├── Impact force and direction
  ├── Pre-impact driving behavior
  ├── VIN (from device registration)
  ├── Policy number (linked to device)
  └── Trip data (route, duration, stops)

PROCESS:
  1. Event detected by device
  2. Data transmitted to telematics platform
  3. Platform evaluates: is this a claimable event?
  4. If YES → auto-create FNOL with enriched data
  5. Contact insured: "We detected a possible incident. Are you OK?"
  6. Insured confirms/denies, adds details
  7. If confirmed → full claim created
  8. If false positive → FNOL cancelled

BENEFITS:
  ✓ Instant notification (minutes, not days)
  ✓ Precise loss location and time
  ✓ Speed/force data supports investigation
  ✓ Reduces fraud (objective data)
  ✓ Enables automatic emergency services dispatch
  ✓ Improves customer experience in crisis moments
```

---

## 4. Complete FNOL Data Model (200+ Fields)

### 4.1 Section 1: Reporter Information

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 1 | reporter_first_name | VARCHAR | 50 | Yes | Reporter's first name |
| 2 | reporter_last_name | VARCHAR | 100 | Yes | Reporter's last name |
| 3 | reporter_relationship | VARCHAR | 20 | Yes | Relationship to insured (Self, Spouse, Agent, Attorney, Other) |
| 4 | reporter_phone | VARCHAR | 15 | Yes | Reporter callback number |
| 5 | reporter_alt_phone | VARCHAR | 15 | No | Alternate phone |
| 6 | reporter_email | VARCHAR | 100 | No | Reporter email |
| 7 | reporter_preferred_contact | VARCHAR | 10 | No | Phone, Email, Text |
| 8 | reporter_preferred_language | VARCHAR | 5 | No | ISO 639 language code |
| 9 | report_channel | VARCHAR | 15 | Yes | Phone, Web, Mobile, Agent, EDI, Chat, IoT |
| 10 | report_date_time | DATETIME | - | Yes | When the loss was reported |
| 11 | report_reference_number | VARCHAR | 30 | No | External reference (agent ref, TPA ref) |

### 4.2 Section 2: Insured / Policyholder Information

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 12 | insured_first_name | VARCHAR | 50 | Yes | Named insured first name |
| 13 | insured_middle_name | VARCHAR | 50 | No | Named insured middle name |
| 14 | insured_last_name | VARCHAR | 100 | Yes | Named insured last name |
| 15 | insured_suffix | VARCHAR | 10 | No | Jr., Sr., III |
| 16 | insured_org_name | VARCHAR | 200 | Cond | Organization name (commercial) |
| 17 | insured_dob | DATE | - | No | Date of birth |
| 18 | insured_gender | VARCHAR | 1 | No | M, F, X, U |
| 19 | insured_ssn | VARCHAR | 11 | No | SSN (encrypted) |
| 20 | insured_address_line1 | VARCHAR | 100 | Yes | Street address |
| 21 | insured_address_line2 | VARCHAR | 100 | No | Address line 2 |
| 22 | insured_city | VARCHAR | 50 | Yes | City |
| 23 | insured_state | VARCHAR | 2 | Yes | State code |
| 24 | insured_zip | VARCHAR | 10 | Yes | ZIP code |
| 25 | insured_country | VARCHAR | 3 | No | Country code |
| 26 | insured_phone_home | VARCHAR | 15 | No | Home phone |
| 27 | insured_phone_work | VARCHAR | 15 | No | Work phone |
| 28 | insured_phone_mobile | VARCHAR | 15 | No | Mobile phone |
| 29 | insured_email | VARCHAR | 100 | No | Email address |

### 4.3 Section 3: Policy Information

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 30 | policy_number | VARCHAR | 20 | Yes | Policy number |
| 31 | policy_type | VARCHAR | 10 | No | HO3, HO5, PAP, CPP, etc. |
| 32 | line_of_business | VARCHAR | 10 | Yes | PA, HO, CA, CP, CGL, WC |
| 33 | policy_effective_date | DATE | - | No | Auto-populated from PAS |
| 34 | policy_expiration_date | DATE | - | No | Auto-populated from PAS |
| 35 | policy_status | VARCHAR | 15 | No | Auto-populated from PAS |
| 36 | agent_code | VARCHAR | 20 | No | Producing agent code |
| 37 | agent_name | VARCHAR | 100 | No | Agent name |
| 38 | agent_phone | VARCHAR | 15 | No | Agent phone |
| 39 | carrier_code | VARCHAR | 10 | No | NAIC company code |
| 40 | program_code | VARCHAR | 10 | No | Product/program identifier |

### 4.4 Section 4: Loss / Occurrence Details

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 41 | loss_date | DATE | - | Yes | Date of loss |
| 42 | loss_time | TIME | - | No | Time of loss |
| 43 | loss_date_estimated | BOOLEAN | - | No | Is the loss date approximate? |
| 44 | discovery_date | DATE | - | No | Date loss was discovered (if different from loss date) |
| 45 | loss_location_address1 | VARCHAR | 100 | No | Loss location street address |
| 46 | loss_location_address2 | VARCHAR | 100 | No | Address line 2 |
| 47 | loss_location_city | VARCHAR | 50 | Yes | City |
| 48 | loss_location_state | VARCHAR | 2 | Yes | State code |
| 49 | loss_location_zip | VARCHAR | 10 | No | ZIP code |
| 50 | loss_location_county | VARCHAR | 50 | No | County (important for jurisdiction) |
| 51 | loss_location_country | VARCHAR | 3 | No | Country code |
| 52 | loss_latitude | DECIMAL | 10,7 | No | GPS latitude |
| 53 | loss_longitude | DECIMAL | 10,7 | No | GPS longitude |
| 54 | loss_location_desc | VARCHAR | 200 | No | Description of location (e.g., "Intersection of Main & Elm") |
| 55 | cause_of_loss_code | VARCHAR | 10 | Yes | ISO cause of loss code |
| 56 | cause_of_loss_desc | VARCHAR | 100 | No | Cause of loss description |
| 57 | loss_description | TEXT | 4000 | Yes | Narrative description of the loss |
| 58 | catastrophe_indicator | BOOLEAN | - | No | Possible catastrophe event? |
| 59 | catastrophe_code | VARCHAR | 10 | No | PCS catastrophe code |
| 60 | weather_conditions | VARCHAR | 30 | No | Clear, Rain, Snow, Fog, etc. |
| 61 | light_conditions | VARCHAR | 20 | No | Daylight, Dusk, Dark, Dawn |
| 62 | road_conditions | VARCHAR | 30 | No | Dry, Wet, Ice, Snow, Gravel |
| 63 | road_type | VARCHAR | 30 | No | Highway, Urban, Rural, Parking Lot |

### 4.5 Section 5: Police / Fire / EMS Report Information

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 64 | police_notified | BOOLEAN | - | No | Were police notified? |
| 65 | police_department | VARCHAR | 100 | No | Department name |
| 66 | police_report_number | VARCHAR | 30 | No | Report number |
| 67 | police_officer_name | VARCHAR | 100 | No | Officer name |
| 68 | police_officer_badge | VARCHAR | 20 | No | Badge number |
| 69 | fire_department_notified | BOOLEAN | - | No | Fire department notified? |
| 70 | fire_department_name | VARCHAR | 100 | No | Fire department name |
| 71 | fire_report_number | VARCHAR | 30 | No | Fire report number |
| 72 | ems_dispatched | BOOLEAN | - | No | EMS dispatched to scene? |
| 73 | ems_transport | BOOLEAN | - | No | Was anyone transported by EMS? |
| 74 | citations_issued | BOOLEAN | - | No | Were citations/tickets issued? |
| 75 | citation_to_whom | VARCHAR | 50 | No | Who received citation |
| 76 | citation_violation | VARCHAR | 100 | No | Violation type |

### 4.6 Section 6: Vehicle Information (Auto Claims)

*Repeatable section — one per vehicle involved*

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 77 | vehicle_role | VARCHAR | 15 | Yes | InsuredVehicle, OtherVehicle |
| 78 | vin | VARCHAR | 17 | Cond | Vehicle Identification Number |
| 79 | year | INTEGER | 4 | Yes | Model year |
| 80 | make | VARCHAR | 30 | Yes | Manufacturer |
| 81 | model | VARCHAR | 30 | Yes | Model |
| 82 | body_style | VARCHAR | 20 | No | Sedan, SUV, Truck, Van |
| 83 | color | VARCHAR | 20 | No | Vehicle color |
| 84 | license_plate | VARCHAR | 15 | No | License plate number |
| 85 | license_state | VARCHAR | 2 | No | Registration state |
| 86 | mileage | INTEGER | - | No | Odometer reading |
| 87 | point_of_impact | VARCHAR | 30 | Yes | Front, Rear, Left, Right, Rollover, Top, Undercarriage |
| 88 | damage_description | TEXT | 2000 | No | Description of damage |
| 89 | damage_severity | VARCHAR | 10 | No | Minor, Moderate, Severe, Total Loss |
| 90 | drivable | BOOLEAN | - | No | Is vehicle drivable? |
| 91 | airbag_deployed | BOOLEAN | - | No | Airbags deployed? |
| 92 | towed | BOOLEAN | - | No | Was vehicle towed? |
| 93 | tow_destination | VARCHAR | 200 | No | Where vehicle was towed |
| 94 | current_vehicle_location | VARCHAR | 200 | No | Current location of vehicle |
| 95 | pre_existing_damage | BOOLEAN | - | No | Any pre-existing damage? |
| 96 | pre_existing_damage_desc | VARCHAR | 500 | No | Description of pre-existing damage |
| 97 | owner_same_as_driver | BOOLEAN | - | No | Is the owner also the driver? |

### 4.7 Section 7: Driver Information (Auto Claims)

*Repeatable section — one per driver*

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 98 | driver_first_name | VARCHAR | 50 | Yes | Driver first name |
| 99 | driver_last_name | VARCHAR | 100 | Yes | Driver last name |
| 100 | driver_dob | DATE | - | No | Date of birth |
| 101 | driver_gender | VARCHAR | 1 | No | M, F, X |
| 102 | driver_license_number | VARCHAR | 20 | No | Driver's license number |
| 103 | driver_license_state | VARCHAR | 2 | No | DL state |
| 104 | driver_address_line1 | VARCHAR | 100 | No | Address |
| 105 | driver_city | VARCHAR | 50 | No | City |
| 106 | driver_state | VARCHAR | 2 | No | State |
| 107 | driver_zip | VARCHAR | 10 | No | ZIP |
| 108 | driver_phone | VARCHAR | 15 | No | Phone |
| 109 | driver_relationship_to_insured | VARCHAR | 20 | No | Self, Spouse, Child, Permissive User, Employee, Other |
| 110 | driver_vehicle_ref | INTEGER | - | No | Reference to which vehicle this person was driving |

### 4.8 Section 8: Property Information (Property Claims)

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 111 | property_type | VARCHAR | 20 | Yes | Dwelling, OtherStructure, Contents, CommBuilding, BPP |
| 112 | property_address_line1 | VARCHAR | 100 | Yes | Property address |
| 113 | property_address_line2 | VARCHAR | 100 | No | Address line 2 |
| 114 | property_city | VARCHAR | 50 | Yes | City |
| 115 | property_state | VARCHAR | 2 | Yes | State |
| 116 | property_zip | VARCHAR | 10 | Yes | ZIP |
| 117 | construction_type | VARCHAR | 20 | No | Frame, Masonry, Steel, etc. |
| 118 | year_built | INTEGER | 4 | No | Year constructed |
| 119 | square_footage | INTEGER | - | No | Square footage |
| 120 | number_of_stories | INTEGER | - | No | Number of stories |
| 121 | occupancy_type | VARCHAR | 20 | No | OwnerOccupied, Tenant, Vacant |
| 122 | roof_type | VARCHAR | 30 | No | Asphalt Shingle, Tile, Metal, Flat |
| 123 | damage_description | TEXT | 4000 | Yes | Description of property damage |
| 124 | damaged_areas | VARCHAR | 500 | No | Rooms/areas affected (comma-separated) |
| 125 | habitability | VARCHAR | 15 | No | Habitable, Uninhabitable |
| 126 | emergency_repairs_needed | BOOLEAN | - | No | Emergency repairs required? |
| 127 | emergency_repairs_authorized | BOOLEAN | - | No | Emergency repairs authorized? |
| 128 | mitigation_company_contacted | BOOLEAN | - | No | Water mitigation company contacted? |
| 129 | estimated_building_damage | DECIMAL | 12,2 | No | Estimated building damage |
| 130 | estimated_contents_damage | DECIMAL | 12,2 | No | Estimated contents damage |
| 131 | mortgage_company_name | VARCHAR | 100 | No | Mortgage company |
| 132 | mortgage_loan_number | VARCHAR | 30 | No | Mortgage loan number |

### 4.9 Section 9: Injury Information

*Repeatable section — one per injured person*

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 133 | injured_party_first_name | VARCHAR | 50 | Yes | First name |
| 134 | injured_party_last_name | VARCHAR | 100 | Yes | Last name |
| 135 | injured_party_dob | DATE | - | No | Date of birth |
| 136 | injured_party_gender | VARCHAR | 1 | No | Gender |
| 137 | injured_party_address | VARCHAR | 200 | No | Address |
| 138 | injured_party_phone | VARCHAR | 15 | No | Phone |
| 139 | injured_party_relationship | VARCHAR | 20 | Yes | Insured, Passenger, OtherDriver, Pedestrian, Employee |
| 140 | injury_description | TEXT | 2000 | Yes | Description of injuries |
| 141 | body_part_code | VARCHAR | 10 | No | NCCI body part code |
| 142 | body_part_description | VARCHAR | 50 | No | Body part description |
| 143 | nature_of_injury_code | VARCHAR | 10 | No | Nature of injury code |
| 144 | injury_severity | VARCHAR | 10 | No | Minor, Moderate, Severe, Critical, Fatal |
| 145 | transported_to_hospital | BOOLEAN | - | No | Was person transported to hospital? |
| 146 | hospital_name | VARCHAR | 100 | No | Hospital name |
| 147 | treated_and_released | BOOLEAN | - | No | Treated and released from ER? |
| 148 | admitted_to_hospital | BOOLEAN | - | No | Admitted as inpatient? |
| 149 | ambulance_dispatched | BOOLEAN | - | No | Ambulance dispatched? |
| 150 | death_indicator | BOOLEAN | - | No | Fatality? |
| 151 | treating_physician_name | VARCHAR | 100 | No | Treating physician |
| 152 | treating_physician_phone | VARCHAR | 15 | No | Physician phone |
| 153 | lost_time_from_work | BOOLEAN | - | No | Missing work due to injury? |
| 154 | return_to_work_date | DATE | - | No | Expected or actual RTW date |

### 4.10 Section 10: Witness Information

*Repeatable section — one per witness*

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 155 | witness_first_name | VARCHAR | 50 | Yes | First name |
| 156 | witness_last_name | VARCHAR | 100 | Yes | Last name |
| 157 | witness_address | VARCHAR | 200 | No | Address |
| 158 | witness_phone | VARCHAR | 15 | No | Phone |
| 159 | witness_email | VARCHAR | 100 | No | Email |
| 160 | witness_statement_summary | TEXT | 2000 | No | Brief statement |

### 4.11 Section 11: Other Party Information

*Repeatable section — one per other party*

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 161 | other_party_first_name | VARCHAR | 50 | Yes | First name |
| 162 | other_party_last_name | VARCHAR | 100 | Yes | Last name |
| 163 | other_party_address | VARCHAR | 200 | No | Address |
| 164 | other_party_phone | VARCHAR | 15 | No | Phone |
| 165 | other_party_dob | DATE | - | No | Date of birth |
| 166 | other_party_dl_number | VARCHAR | 20 | No | Driver's license number |
| 167 | other_party_dl_state | VARCHAR | 2 | No | DL state |
| 168 | other_party_insurer | VARCHAR | 100 | No | Insurance company name |
| 169 | other_party_policy_number | VARCHAR | 20 | No | Policy number |
| 170 | other_party_claim_number | VARCHAR | 20 | No | Claim number (if already filed) |
| 171 | other_party_attorney_name | VARCHAR | 100 | No | Attorney name (if represented) |
| 172 | other_party_attorney_phone | VARCHAR | 15 | No | Attorney phone |

### 4.12 Section 12: Workers Comp Specific

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 173 | employer_name | VARCHAR | 200 | Yes | Employer name |
| 174 | employer_fein | VARCHAR | 15 | No | Federal Employer ID |
| 175 | employer_address | VARCHAR | 200 | No | Employer address |
| 176 | employer_contact_name | VARCHAR | 100 | No | Employer contact |
| 177 | employer_contact_phone | VARCHAR | 15 | No | Contact phone |
| 178 | employee_hire_date | DATE | - | No | Date of hire |
| 179 | employee_occupation | VARCHAR | 100 | No | Job title/occupation |
| 180 | employee_class_code | VARCHAR | 10 | No | NCCI classification code |
| 181 | employee_department | VARCHAR | 50 | No | Department |
| 182 | employee_shift | VARCHAR | 20 | No | Day, Night, Swing |
| 183 | injury_on_employer_premises | BOOLEAN | - | No | On employer premises? |
| 184 | activity_at_time_of_injury | VARCHAR | 200 | No | What employee was doing |
| 185 | object_causing_injury | VARCHAR | 200 | No | Object/substance causing injury |
| 186 | supervisor_name | VARCHAR | 100 | No | Supervisor at time of injury |
| 187 | date_employer_notified | DATE | - | No | When employer was told |
| 188 | average_weekly_wage | DECIMAL | 10,2 | No | AWW for benefit calculation |
| 189 | days_worked_per_week | INTEGER | - | No | Typical work days |
| 190 | full_wages_paid_doi | BOOLEAN | - | No | Full wages paid on date of injury? |
| 191 | date_disability_began | DATE | - | No | First date of disability/lost time |
| 192 | initial_treatment_type | VARCHAR | 30 | No | Minor, ER, Admitted, NoMedical |

### 4.13 Section 13: Coverage Selection & Immediate Needs

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 193 | coverage_collision | BOOLEAN | - | No | Collision claim? |
| 194 | coverage_comprehensive | BOOLEAN | - | No | Comprehensive claim? |
| 195 | coverage_bi_liability | BOOLEAN | - | No | BI liability claim? |
| 196 | coverage_pd_liability | BOOLEAN | - | No | PD liability claim? |
| 197 | coverage_um_uim | BOOLEAN | - | No | UM/UIM claim? |
| 198 | coverage_pip | BOOLEAN | - | No | PIP claim? |
| 199 | coverage_medpay | BOOLEAN | - | No | MedPay claim? |
| 200 | coverage_rental | BOOLEAN | - | No | Rental reimbursement needed? |
| 201 | coverage_towing | BOOLEAN | - | No | Towing coverage needed? |
| 202 | coverage_dwelling | BOOLEAN | - | No | Dwelling damage claim? |
| 203 | coverage_contents | BOOLEAN | - | No | Contents claim? |
| 204 | coverage_loss_of_use | BOOLEAN | - | No | ALE/Loss of use? |
| 205 | coverage_liability | BOOLEAN | - | No | Personal liability? |
| 206 | rental_needed | BOOLEAN | - | No | Rental car needed now? |
| 207 | towing_needed | BOOLEAN | - | No | Towing needed now? |
| 208 | emergency_housing_needed | BOOLEAN | - | No | Emergency housing needed? |
| 209 | emergency_repairs_needed | BOOLEAN | - | No | Emergency repairs needed? |
| 210 | glass_only_claim | BOOLEAN | - | No | Glass-only claim? |

### 4.14 Section 14: System / Processing Fields

| # | Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|---|
| 211 | fnol_id | UUID | 36 | Yes | FNOL record identifier |
| 212 | fnol_status | VARCHAR | 15 | Yes | Draft, Submitted, Processing, Complete, Failed |
| 213 | fnol_source_system | VARCHAR | 30 | Yes | System that originated the FNOL |
| 214 | fnol_session_id | VARCHAR | 50 | No | Session tracking ID |
| 215 | created_by | VARCHAR | 50 | Yes | User/system that created |
| 216 | created_date | DATETIME | - | Yes | Creation timestamp |
| 217 | submitted_date | DATETIME | - | No | Submission timestamp |
| 218 | claim_number | VARCHAR | 20 | No | Generated claim number (after creation) |
| 219 | claim_id | UUID | 36 | No | Link to created claim |
| 220 | duplicate_check_result | VARCHAR | 20 | No | NoDuplicate, PotentialDuplicate, ConfirmedDuplicate |
| 221 | duplicate_claim_numbers | VARCHAR | 200 | No | Matched claim numbers |
| 222 | complexity_score | DECIMAL | 5,2 | No | Calculated complexity |
| 223 | severity_score | DECIMAL | 5,2 | No | Calculated severity |
| 224 | fraud_score | DECIMAL | 5,2 | No | Calculated fraud risk |
| 225 | stp_eligible | BOOLEAN | - | No | Straight-through processing eligible? |
| 226 | assigned_adjuster_id | UUID | 36 | No | Auto-assigned adjuster |
| 227 | assigned_queue | VARCHAR | 30 | No | Assignment queue |
| 228 | data_quality_score | DECIMAL | 5,2 | No | FNOL completeness/quality score |

---

## 5. Field-Level Validation Rules

### 5.1 Core Validation Rules

| Rule ID | Field(s) | Rule | Severity | Message |
|---|---|---|---|---|
| VAL-001 | loss_date | loss_date ≤ current_date | Error | Loss date cannot be in the future |
| VAL-002 | loss_date | loss_date ≥ policy_effective_date | Error | Loss date is before policy effective date |
| VAL-003 | loss_date | loss_date ≤ policy_expiration_date (with grace) | Warning | Loss date may be after policy expiration |
| VAL-004 | report_date | report_date ≥ loss_date | Error | Report date cannot precede loss date |
| VAL-005 | policy_number | Valid format per carrier convention | Error | Invalid policy number format |
| VAL-006 | policy_number | Must exist in PAS and be in-force on loss_date | Error | Policy not found or not in force |
| VAL-007 | vin | 17 characters, valid check digit | Warning | Invalid VIN format |
| VAL-008 | vin | Must match a vehicle on the policy | Warning | VIN not found on policy |
| VAL-009 | phone | Valid phone number format (E.164) | Warning | Invalid phone number |
| VAL-010 | email | Valid email format (RFC 5322) | Warning | Invalid email format |
| VAL-011 | zip_code | Valid 5-digit or ZIP+4 format | Warning | Invalid ZIP code |
| VAL-012 | state_code | Must be valid US state/territory code | Error | Invalid state code |
| VAL-013 | cause_of_loss | Must be valid ISO cause of loss code | Error | Invalid cause of loss code |
| VAL-014 | loss_description | Minimum 20 characters | Warning | Loss description too brief |
| VAL-015 | ssn | Must be valid SSN format (XXX-XX-XXXX) | Warning | Invalid SSN format |
| VAL-016 | loss_date vs. report_date | report_date - loss_date ≤ 365 days (configurable) | Warning | Late-reported claim — flag for review |
| VAL-017 | injury.death_indicator | If true, severity must be Fatal | Error | Inconsistent death/severity data |
| VAL-018 | vehicle.drivable + vehicle.towed | If not drivable, tow destination should be provided | Warning | Non-drivable vehicle — tow location missing |
| VAL-019 | property.habitability | If Uninhabitable, emergency_housing_needed should be assessed | Warning | Uninhabitable property — assess ALE needs |
| VAL-020 | wc.average_weekly_wage | Must be > 0 if lost_time_from_work = true | Error | AWW required for lost-time claims |

### 5.2 Cross-Field Validation Rules

| Rule ID | Fields | Rule | Description |
|---|---|---|---|
| XVAL-001 | loss_date, vehicle.year | vehicle.year ≤ loss_date.year + 1 | Vehicle year shouldn't be far future |
| XVAL-002 | cause_of_loss, line_of_business | Cause must be valid for LOB | Collision code invalid for homeowners |
| XVAL-003 | injury_count, police_notified | If injuries > 0, police should be notified | Flag if injuries but no police |
| XVAL-004 | damage_severity, estimate | If Total Loss, estimate should approximate ACV | Consistency check |
| XVAL-005 | coverage selections, policy coverages | Selected coverages must exist on policy | Can't claim collision if no collision coverage |

---

## 6. Business Rules Engine Integration

### 6.1 Rules Categories

```
FNOL Business Rules Engine
│
├── TRIAGE RULES
│   ├── Complexity scoring rules (20+ rules)
│   ├── Severity scoring rules (15+ rules)
│   ├── STP eligibility rules (10+ rules)
│   └── Priority classification rules
│
├── ASSIGNMENT RULES
│   ├── Unit/team routing rules (by LOB, type, jurisdiction)
│   ├── Adjuster selection rules (skill, authority, workload)
│   ├── Special handling rules (VIP, large loss, CAT)
│   └── Round-robin / load balancing rules
│
├── COVERAGE RULES
│   ├── Coverage mapping rules (cause of loss → coverage)
│   ├── Exclusion identification rules
│   └── Deductible application rules
│
├── FRAUD RULES
│   ├── Red flag detection rules (50+ rules)
│   ├── Scoring model integration
│   └── SIU referral threshold rules
│
├── INITIAL RESERVE RULES
│   ├── Table-driven reserve rules by type/severity
│   ├── Jurisdictional multiplier rules
│   └── Inflation adjustment rules
│
├── ACTIVITY GENERATION RULES
│   ├── Investigation checklist rules (by LOB/type)
│   ├── Contact SLA rules
│   ├── Documentation request rules
│   └── Diary scheduling rules
│
├── NOTIFICATION RULES
│   ├── Large loss notification rules
│   ├── Reinsurance notification rules
│   ├── Regulatory notification rules
│   └── Stakeholder notification rules
│
└── CATASTROPHE RULES
    ├── CAT identification rules (date + location + cause)
    ├── CAT workflow rules (simplified handling)
    └── CAT resource deployment rules
```

### 6.2 Sample Triage Rules (Pseudocode)

```
RULE: Complexity Scoring

  complexity_score = 0

  // Party complexity
  IF injury_count > 0 THEN complexity_score += 20
  IF injury_count > 2 THEN complexity_score += 10
  IF fatality = TRUE THEN complexity_score += 40
  IF other_party_count > 1 THEN complexity_score += 10
  IF attorney_involved = TRUE THEN complexity_score += 15

  // Coverage complexity
  IF coverage_count > 3 THEN complexity_score += 10
  IF um_uim_claim = TRUE THEN complexity_score += 15
  IF coverage_question_flagged = TRUE THEN complexity_score += 20

  // Damage complexity
  IF estimated_damage > $50,000 THEN complexity_score += 15
  IF estimated_damage > $250,000 THEN complexity_score += 25
  IF total_loss_likely = TRUE THEN complexity_score += 5
  IF uninhabitable = TRUE THEN complexity_score += 10

  // Historical complexity
  IF prior_claims_same_policy > 2 THEN complexity_score += 10
  IF fraud_score > 60 THEN complexity_score += 20

  // Classify
  IF complexity_score >= 80 THEN tier = "COMPLEX"
  ELSE IF complexity_score >= 50 THEN tier = "MODERATE"
  ELSE IF complexity_score >= 25 THEN tier = "STANDARD"
  ELSE tier = "SIMPLE"

  RETURN { score: complexity_score, tier: tier }
```

---

## 7. Auto-Assignment Rules & Algorithms

### 7.1 Assignment Decision Tree

```
FNOL RECEIVED
│
▼
DETERMINE CLAIM TYPE & ATTRIBUTES
│
├── Is this a CAT event?
│   YES → Route to CAT queue / deploy CAT adjusters
│
├── Is this a VIP / Key Account?
│   YES → Route to Key Account handler
│
├── Is this a glass-only claim?
│   YES → Route to Glass vendor (Safelite, etc.) for STP
│
├── Is litigation already flagged?
│   YES → Route to Litigation unit
│
├── Determine LOB + Claim Type
│   ├── Auto PD only → Auto PD Unit
│   ├── Auto PD + BI → Auto Injury Unit
│   ├── Auto BI only → Auto Injury Unit
│   ├── Homeowners Property → Property Unit
│   ├── Commercial Property → Commercial Property Unit
│   ├── CGL → Liability Unit
│   ├── Workers Comp → WC Unit
│   └── Professional Liability → Specialty Unit
│
├── Within Unit, apply assignment algorithm:
│   ├── Match jurisdiction (adjuster licensed in claim state)
│   ├── Match skill level (complexity tier ≤ adjuster tier)
│   ├── Check authority level (severity ≤ adjuster authority)
│   ├── Check workload (below capacity threshold)
│   └── Apply round-robin within matching pool
│
▼
ADJUSTER ASSIGNED → Notification sent
```

---

## 8. Coverage Verification During FNOL

### 8.1 Real-Time Coverage Check

```
FNOL Data Entered:
  Policy Number: PAP-2026-001234
  Loss Date: 2026-04-15
  Cause of Loss: Collision (20)
  Vehicle VIN: 1HGBH41JXMN109186

STEP 1: POLICY LOOKUP (real-time API to PAS)
  → Policy found
  → Status: Active
  → Effective: 2026-01-15, Expires: 2026-07-15
  → Loss date within policy period: YES ✓

STEP 2: BILLING CHECK
  → Premium paid through: 2026-04-15
  → No cancellation pending: YES ✓

STEP 3: VEHICLE MATCH
  → VIN 1HGBH41JXMN109186 found on policy: YES ✓
  → 2024 Honda Civic — matches

STEP 4: COVERAGE IDENTIFICATION
  → Collision: $500 deductible, ACV ✓
  → Comprehensive: $250 deductible, ACV ✓
  → BI Liability: $100K/$300K ✓
  → PD Liability: $100K ✓
  → UMBI: $100K/$300K ✓
  → UMPD: $3,500 ✓
  → MedPay: $5,000 ✓
  → Rental: $40/day, 30 days max ✓
  → Towing: $100 per occurrence ✓

STEP 5: APPLICABLE COVERAGES FOR THIS LOSS
  → Cause = Collision
  → Applicable: Collision ($500 ded), Rental, Towing
  → Also check: if other party injured → BI Liability
  → Also check: if insured injured → MedPay, PIP (state dependent)
  → Also check: if other party property damaged → PD Liability

RESULT: Coverage verified. Features to create:
  1. COLL (Collision) — $500 deductible
  2. RENTAL — $40/day, 30 days
  3. BI-1 (if claimant injured) — $100K/$300K limit
  4. PD (if other property damaged) — $100K limit
```

---

## 9. Duplicate Detection Algorithms

### 9.1 Duplicate Detection Logic

```
Duplicate Detection at FNOL Time:

ALGORITHM: WEIGHTED MATCH SCORING

Match Candidates: All claims with matching policy number OR matching party 
  within past 365 days

Scoring:
  +40 points: Same policy number AND loss date within ±3 days
  +30 points: Same VIN (auto claims)
  +25 points: Same property address (property claims)
  +20 points: Same named insured AND loss date within ±7 days
  +15 points: Same insured last name + first initial AND same loss state
  +10 points: Same insured phone number
  +10 points: Same insured email
  +10 points: Same cause of loss code AND loss date within ±1 day
  +5 points: Same loss location (within 0.5 miles)

Threshold: 
  Score ≥ 70: PROBABLE DUPLICATE → Block submission, present existing claim
  Score 40-69: POSSIBLE DUPLICATE → Warn, allow override with reason
  Score < 40: NO DUPLICATE → Proceed normally

Additional Rules:
  - Exact match: same policy + same loss date + same VIN → automatic block
  - CAT override: during declared CAT events, allow more lenient duplicate thresholds
    (same insured may file separate claims for different properties in same CAT)
```

### 9.2 Match Result Handling

| Result | System Action | User Experience |
|---|---|---|
| Probable Duplicate | Block FNOL submission | Display existing claim details; options: View existing, Add to existing, Override |
| Possible Duplicate | Warn but allow | Display warning banner with match details; require acknowledge/override |
| No Duplicate | Proceed | No interruption; score logged for audit |

---

## 10. FNOL Scoring Models

### 10.1 Severity Score

```
Auto Claim Severity Score (0-100):

  score = 0

  // Vehicle damage indicators
  IF airbag_deployed THEN score += 15
  IF NOT drivable THEN score += 10
  IF total_loss_likely THEN score += 15
  IF estimated_damage > $10K THEN score += 10
  IF estimated_damage > $25K THEN score += 10

  // Injury indicators
  IF any_injuries THEN score += 15
  IF hospitalized THEN score += 15
  IF fatality THEN score += 30
  IF injury_severity = "Severe" OR "Critical" THEN score += 20
  IF number_of_injured > 2 THEN score += 10

  // Other indicators
  IF commercial_vehicle_involved THEN score += 5
  IF pedestrian_involved THEN score += 10
  IF multiple_vehicles > 2 THEN score += 5

  RETURN min(score, 100)
```

### 10.2 Fraud Score

```
FNOL Fraud Scoring (0-100):

  score = 0

  // Timing indicators
  IF report_date - loss_date > 30 days THEN score += 10
  IF loss_time between 22:00-05:00 THEN score += 5
  IF loss_date < policy_effective_date + 30 days THEN score += 10 (new policy)
  IF loss_date within 30 days of policy expiration THEN score += 5

  // Financial indicators
  IF policy in grace period or recent reinstatement THEN score += 15
  IF recent coverage increase THEN score += 10
  IF premium payment delinquent THEN score += 10

  // Claims history
  IF prior_claims_count >= 3 in past 3 years THEN score += 10
  IF prior_theft_claim THEN score += 10
  IF prior_fire_claim AND current = fire THEN score += 15
  IF prior_claim_same_type within 12 months THEN score += 10

  // FNOL indicators
  IF reporter is not insured (third party report) THEN score += 5
  IF inconsistencies in description detected THEN score += 10
  IF no police report for injury accident THEN score += 5
  IF PO Box address THEN score += 3
  IF disconnected phone number THEN score += 5
  IF no witnesses for significant accident THEN score += 5

  // ISO ClaimSearch indicators
  IF ISO match on SSN with multiple recent claims THEN score += 15
  IF ISO match on address with different identity THEN score += 10

  RETURN min(score, 100)

  IF score >= 75 THEN flag = "HIGH_RISK" → Auto SIU referral
  IF score >= 50 THEN flag = "MEDIUM_RISK" → SIU review queue
  IF score >= 25 THEN flag = "LOW_RISK" → Adjuster awareness flag
  IF score < 25 THEN flag = "NORMAL"
```

---

## 11. Straight-Through Processing (STP)

### 11.1 STP Eligibility Criteria

| Criterion | Auto PD (Glass) | Auto PD (Minor Collision) | Property (Minor) |
|---|---|---|---|
| Claim type | Glass-only | Collision, repairable | Non-catastrophe, single peril |
| Estimated amount | < $1,500 | < $3,000 | < $5,000 |
| Injuries | None | None | None |
| Number of parties | 1 (first-party only) | 1 (first-party only) | 1 (insured only) |
| Fraud score | < 25 | < 20 | < 20 |
| Prior claims (12 mo) | 0-1 | 0 | 0 |
| Coverage | Verified, no issues | Verified, no issues | Verified, no issues |
| Deductible | Applies | Applies | Applies |
| Attorney involved | No | No | No |
| Public adjuster | No | No | No |
| Policy status | Active, current | Active, current | Active, current |
| Special handling flags | None | None | None |

### 11.2 STP Process Flow

```
FNOL SUBMITTED
│
▼
STP ELIGIBILITY ENGINE
├── Check all criteria above
├── If ALL criteria met → STP ELIGIBLE
└── If ANY criteria fails → STANDARD PROCESSING

IF STP ELIGIBLE:
  │
  ├── Auto-create claim with features
  ├── Auto-set reserves (table-driven)
  ├── Auto-generate payment:
  │   ├── Amount = estimate - deductible
  │   ├── Payee = insured (or DRP shop for glass)
  │   └── Method = EFT (if on file) or check
  ├── Route payment for auto-approval (system authority)
  ├── Issue payment
  ├── Send confirmation to insured
  ├── Auto-close claim
  └── Flag for random quality audit (10% sample)

RESULT: Claim opened and closed within minutes, not days
```

---

## 12. FNOL-to-Claim Creation Logic

### 12.1 Claim Creation Process

```
FNOL SUBMISSION → CLAIM CREATION

STEP 1: GENERATE CLAIM NUMBER
  Format: {LOB}-{YEAR}-{SEQUENCE}
  Example: PA-2026-000001
  Rule: Thread-safe sequence generation; no gaps; unique across system

STEP 2: CREATE CLAIM RECORD
  Map FNOL fields → Claim fields
  Set initial status: OPEN - UNASSIGNED
  Set entry_date: current timestamp
  Set report_date: from FNOL
  Set loss_date: from FNOL

STEP 3: CREATE PARTY RECORDS
  For each party in FNOL:
    ├── Search existing party database (match on name + DOB, SSN, DL, etc.)
    ├── If found → link existing party record
    └── If not found → create new party record
  Create claim_party records with appropriate roles

STEP 4: CREATE VEHICLE/PROPERTY RECORDS
  For each vehicle/property in FNOL → create entity record

STEP 5: CREATE FEATURES (Coverage Exposures)
  Based on coverages selected and coverage verification:
  ├── Map each applicable coverage to a feature
  ├── Link feature to claimant party (for third-party features)
  ├── Set feature status: OPEN
  └── Features represent the financial tracking units

STEP 6: SET INITIAL RESERVES
  For each feature:
  ├── Apply initial reserve rules (table-driven or model-based)
  ├── Create reserve transaction (type: Initial)
  └── Sum features for claim-level totals

STEP 7: GENERATE INITIAL ACTIVITIES
  Based on claim type and triage:
  ├── Contact insured (due: 24 hrs)
  ├── Contact claimant (due: 48 hrs)
  ├── Verify coverage (due: 5 days)
  ├── Request police report (due: 7 days)
  ├── Inspect vehicle/property (due: 5-7 days)
  └── Set reserve review diary (due: 30 days)

STEP 8: SEND NOTIFICATIONS
  ├── Acknowledgment letter/email to insured
  ├── Assignment notification to adjuster
  ├── Agent notification
  ├── Large loss notification (if applicable)
  └── CAT notification (if applicable)

STEP 9: SUBMIT TO ISO ClaimSearch
  Report new claim to ISO ClaimSearch for industry matching

STEP 10: UPDATE FNOL RECORD
  Link FNOL to claim (claim_number, claim_id)
  Set FNOL status: COMPLETE
```

---

## 13. Multi-Claimant & Multi-Vehicle Handling

### 13.1 Multi-Vehicle FNOL Structure

```
FNOL: 4-Vehicle Accident

Occurrence: OCC-2026-00001
├── Vehicle 1: Insured's 2024 Honda Civic (driven by insured)
│   Policy: PAP-2026-001234
│   → Claim 1: CLM-2026-00001
│     ├── Feature: COLL (Collision - first party)
│     ├── Feature: RENTAL
│     ├── Feature: BI-1 (for claimant = Vehicle 2 driver)
│     ├── Feature: BI-2 (for claimant = Vehicle 2 passenger)
│     ├── Feature: PD-1 (for Vehicle 2 damage)
│     └── Feature: PD-2 (for Vehicle 3 damage)
│
├── Vehicle 2: 2023 Toyota Camry (other party)
│   Other party's insurance: StateFarm PAP-SF-789012
│   Driver: Robert Johnson (injured)
│   Passenger: Lisa Johnson (injured)
│
├── Vehicle 3: 2025 Ford F-150 (other party)
│   Other party's insurance: AllState PAP-AS-456789
│   Driver: Michael Chen (no injury)
│
└── Vehicle 4: Parked — 2022 Chevy Malibu (other party)
    Owner: James Wilson
    Insurance: GEICO PAP-GE-321098
    No driver (parked vehicle)

System Must Handle:
  - One FNOL creates one occurrence and one claim
  - Multiple features (one per coverage-claimant combination)
  - Each claimant tracked separately with their own:
    - Contact information
    - Injury details
    - Attorney representation status
    - Negotiation history
    - Settlement
  - Other party insurance information captured for subrogation
  - Each vehicle tracked separately with:
    - Damage details
    - Estimate
    - Repair/total loss status
```

---

## 14. Catastrophe FNOL Surge Handling

### 14.1 CAT FNOL Volume Patterns

```
Normal Daily FNOL Volume: ~500/day (example mid-size carrier)

CAT Event FNOL Surge:
Day 0 (event): ~200 (many can't report yet)
Day 1: ~2,000
Day 2: ~5,000 (PEAK)
Day 3: ~4,000
Day 4: ~3,000
Day 5: ~2,000
Day 6-10: ~1,000/day declining
Day 11-30: ~500/day tapering to normal

Total CAT FNOLs: ~25,000 from one event (mid-size carrier)

SURGE CAPACITY REQUIREMENTS:
Normal: 100 CSRs handling 500 FNOLs/day (5 per CSR per day)
Peak CAT: Need 1,000 CSR equivalents for 5,000 FNOLs/day
Gap: 900 additional CSR equivalents needed
```

### 14.2 CAT Surge Strategies

| Strategy | Description | Lead Time |
|---|---|---|
| Overflow call center | Pre-contracted BPO for surge capacity | Hours |
| Cross-trained staff | Underwriting, service staff trained for basic FNOL | Immediate |
| Simplified FNOL form | Minimum viable data capture during surge | Pre-configured |
| Web/mobile push | Proactive push notifications encouraging self-service | Hours |
| IVR self-service | Automated FNOL capture via phone | Pre-configured |
| Chatbot escalation | AI chatbot handles basic intake, escalates complex | Immediate |
| Extended hours | 24/7 operations during CAT | Hours |
| Agent portal | Agents submit FNOLs directly (bulk upload) | Pre-configured |
| Auto-tagging | System auto-tags FNOLs matching CAT geography/date | Pre-configured |
| Deferred assignment | Accept FNOL without immediate adjuster assignment | Immediate |

---

## 15. IVR & Telephony Integration

### 15.1 IVR Call Flow for FNOL

```
INBOUND CALL TO CLAIMS HOTLINE
│
▼
IVR GREETING
"Thank you for calling Acme Insurance Claims. 
 Para español, oprima dos."
│
├── [1] Report a New Claim
├── [2] Existing Claim Status
├── [3] Roadside Assistance
├── [4] Speak with an Agent
│
▼ (Pressed 1)
│
"Are you calling to report:"
├── [1] An Auto Accident
├── [2] Home or Property Damage
├── [3] A Work-Related Injury
├── [4] Another Type of Claim
│
▼ (Pressed 1 — Auto)
│
"Is this an emergency? Is anyone injured and in need of 
 immediate medical attention?"
├── [1] Yes (EMERGENCY) → Transfer to 911 bridge / emergency line
├── [2] No → Continue
│
▼ (No emergency)
│
"Please enter your policy number, or press star to search by name."
│
├── (Policy number entered) → Lookup in PAS
│   ├── Found → "I found a policy for John Smith at 123 Main Street. 
│   │           Is this correct?"
│   │   ├── [1] Yes → Route to CSR with policy pre-populated
│   │   └── [2] No → Re-enter or route to CSR
│   └── Not found → Route to CSR for manual lookup
│
├── (*) Search by name → "Please say your last name"
│   └── Speech recognition → Lookup → Confirm → Route to CSR
│
▼
ROUTE TO AVAILABLE CSR (with CTI screen-pop)
├── Policy data pre-populated on CSR screen
├── Caller ID matched to policy phone number
├── Priority routing for:
│   ├── High-value policies
│   ├── Known CAT affected areas
│   └── Previously started FNOLs (save and continue)
```

### 15.2 CTI (Computer Telephony Integration) Requirements

| Feature | Description |
|---|---|
| Screen Pop | Caller ID matched to policy; CSR screen pre-populated |
| ANI/DNIS | Automatic Number Identification and Dialed Number |
| Call Recording | All FNOL calls recorded; linked to claim record |
| Skills-Based Routing | Route to appropriate CSR pool (auto, property, WC) |
| Queue Management | Display wait times, callback options, priority queuing |
| IVR-to-Agent Transfer | All IVR-collected data passed to agent screen |
| Call Disposition | CSR logs outcome (FNOL created, transferred, abandoned) |
| Callback Scheduling | If wait time > threshold, offer scheduled callback |
| Whisper Announcement | Announce policy info to CSR before connecting caller |

---

## 16. Speech-to-Text & NLP for FNOL

### 16.1 AI-Assisted FNOL Capabilities

```
AI CAPABILITIES IN FNOL:

1. SPEECH-TO-TEXT (Real-time transcription)
   - Transcribe FNOL phone calls in real-time
   - Support multiple languages
   - Handle insurance terminology
   - Accuracy target: >95% for insurance domain

2. NLP ENTITY EXTRACTION
   From transcribed narrative, extract:
   ├── Date/Time: "last Tuesday around 3 PM" → 2026-04-14T15:00
   ├── Location: "at the corner of Main and Elm" → geocode
   ├── Vehicle: "my 2024 Honda Civic" → Year: 2024, Make: Honda, Model: Civic
   ├── Persons: "the other driver, Robert" → Party: Robert, Role: OtherDriver
   ├── Injuries: "he said his neck hurt" → Body Part: Neck, Nature: Pain
   ├── Damage: "the whole back end is smashed" → Point of Impact: Rear
   ├── Cause: "rear-ended me" → Cause Code: 20 (Collision)
   └── Authorities: "the police came and filed a report" → police_notified: true

3. SENTIMENT ANALYSIS
   - Detect caller distress level
   - Flag escalation-needed calls
   - Adapt script recommendations

4. REAL-TIME SUGGESTIONS
   - Suggest follow-up questions based on captured data
   - Identify missing required fields
   - Suggest cause of loss code from narrative
   - Pre-fill fields from extracted entities

5. AUTOMATED FNOL CREATION
   - Bot-led FNOL through conversational interface
   - Guide caller through questions naturally
   - Confirm extracted data points
   - Create FNOL without human CSR
```

---

## 17. FNOL API Design

### 17.1 FNOL API Endpoints

```
Base URL: /api/v1/fnol

POST   /api/v1/fnol                         — Submit new FNOL
GET    /api/v1/fnol/{fnolId}                — Get FNOL by ID
PUT    /api/v1/fnol/{fnolId}                — Update draft FNOL
POST   /api/v1/fnol/{fnolId}/submit         — Submit draft FNOL for processing
GET    /api/v1/fnol/{fnolId}/status          — Get FNOL processing status
DELETE /api/v1/fnol/{fnolId}                — Cancel draft FNOL
POST   /api/v1/fnol/{fnolId}/documents      — Attach document to FNOL
GET    /api/v1/fnol/search                   — Search FNOLs
POST   /api/v1/fnol/validate                — Validate FNOL data without submitting
POST   /api/v1/fnol/duplicate-check          — Check for duplicates
GET    /api/v1/fnol/{fnolId}/claim           — Get resulting claim from FNOL
```

### 17.2 FNOL Submit Request Schema

```json
{
  "fnol": {
    "reportChannel": "WEB_PORTAL",
    "reportDateTime": "2026-04-16T14:30:00-05:00",
    "reporter": {
      "firstName": "John",
      "lastName": "Smith",
      "relationshipToInsured": "SELF",
      "phone": "+15551234567",
      "email": "john.smith@email.com"
    },
    "policy": {
      "policyNumber": "PAP-2026-001234"
    },
    "lossDetails": {
      "lossDate": "2026-04-15",
      "lossTime": "17:45:00",
      "lossLocation": {
        "line1": "Intersection of Elm St and Oak Ave",
        "city": "Anytown",
        "stateCode": "CA",
        "postalCode": "90210",
        "latitude": 34.0522,
        "longitude": -118.2437
      },
      "causeOfLossCode": "20",
      "description": "I was stopped at a red light when another vehicle rear-ended me. The impact was moderate. I am not injured but the other driver said his neck hurt.",
      "weatherConditions": "CLEAR",
      "lightConditions": "DAYLIGHT"
    },
    "policeReport": {
      "policeNotified": true,
      "departmentName": "Anytown Police Department",
      "reportNumber": "2026-APD-045678"
    },
    "vehicles": [
      {
        "vehicleRole": "INSURED_VEHICLE",
        "vin": "1HGBH41JXMN109186",
        "year": 2024,
        "make": "Honda",
        "model": "Civic",
        "color": "Silver",
        "licensePlate": "8ABC123",
        "licenseState": "CA",
        "mileage": 28500,
        "pointOfImpact": "REAR",
        "damageDescription": "Rear bumper, trunk lid, tail lights damaged",
        "damageSeverity": "MODERATE",
        "drivable": true,
        "airbagDeployed": false,
        "towed": false,
        "driver": {
          "sameAsInsured": true
        }
      },
      {
        "vehicleRole": "OTHER_VEHICLE",
        "year": 2023,
        "make": "Toyota",
        "model": "Corolla",
        "color": "Blue",
        "pointOfImpact": "FRONT",
        "damageDescription": "Front bumper and hood damage",
        "drivable": true,
        "driver": {
          "firstName": "Robert",
          "lastName": "Johnson",
          "phone": "+15559876543",
          "address": {
            "line1": "456 Oak Lane",
            "city": "Anytown",
            "stateCode": "CA",
            "postalCode": "90211"
          },
          "insuranceCompany": "StateWide Insurance Co",
          "insurancePolicyNumber": "SW-PAP-789012"
        }
      }
    ],
    "injuries": [
      {
        "injuredParty": {
          "firstName": "Robert",
          "lastName": "Johnson",
          "relationship": "OTHER_DRIVER"
        },
        "injuryDescription": "Complained of neck pain at scene",
        "bodyPartCode": "20",
        "severity": "MINOR",
        "transportedToHospital": false,
        "lostTimeFromWork": false
      }
    ],
    "coverageSelections": {
      "collision": true,
      "bodilyInjuryLiability": true,
      "propertyDamageLiability": true,
      "rentalReimbursement": false
    },
    "immediateNeeds": {
      "rentalCarNeeded": false,
      "towingNeeded": false
    }
  }
}
```

### 17.3 FNOL Submit Response Schema

```json
{
  "fnolId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "status": "COMPLETE",
  "claimNumber": "PA-2026-000142",
  "claimId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "assignedAdjuster": {
    "name": "Maria Garcia",
    "phone": "+15557654321",
    "email": "maria.garcia@acmeinsurance.com"
  },
  "features": [
    {
      "featureNumber": "001",
      "coverageCode": "COLL",
      "coverageDescription": "Collision",
      "featureType": "FIRST_PARTY",
      "deductible": 500.00,
      "initialReserve": 4500.00
    },
    {
      "featureNumber": "002",
      "coverageCode": "BI",
      "coverageDescription": "Bodily Injury Liability",
      "featureType": "THIRD_PARTY",
      "claimant": "Robert Johnson",
      "initialReserve": 15000.00
    },
    {
      "featureNumber": "003",
      "coverageCode": "PD",
      "coverageDescription": "Property Damage Liability",
      "featureType": "THIRD_PARTY",
      "initialReserve": 5000.00
    }
  ],
  "nextSteps": [
    "Your adjuster Maria Garcia will contact you within 24 hours.",
    "Please do not dispose of any damaged property.",
    "If you need a rental car, contact us at 1-800-555-RENT.",
    "Track your claim status at portal.acmeinsurance.com"
  ],
  "duplicateCheckResult": "NO_DUPLICATE",
  "dataQualityScore": 87.5,
  "processingTime": "2.3 seconds",
  "_links": {
    "self": "/api/v1/fnol/f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "claim": "/api/v1/claims/a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "documents": "/api/v1/claims/a1b2c3d4-e5f6-7890-abcd-ef1234567890/documents",
    "status": "/api/v1/claims/a1b2c3d4-e5f6-7890-abcd-ef1234567890/status"
  }
}
```

---

## 18. FNOL Workflow State Machine

```
┌────────────┐
│   DRAFT    │ (Save and continue later)
└─────┬──────┘
      │ Submit
      ▼
┌────────────┐
│ SUBMITTED  │
└─────┬──────┘
      │ Processing begins
      ▼
┌────────────┐     ┌──────────────┐
│ VALIDATING │────►│ VALIDATION   │ (Errors found)
│            │     │ FAILED       │
└─────┬──────┘     └──────┬───────┘
      │ Valid              │ Corrected & resubmitted
      ▼                    │
┌────────────┐◄────────────┘
│ ENRICHING  │ (Policy lookup, dup check, scoring)
└─────┬──────┘
      │
      ├── Duplicate found ──► DUPLICATE (linked to existing claim)
      │
      ▼
┌────────────┐
│ CREATING   │ (Claim creation in progress)
│ CLAIM      │
└─────┬──────┘
      │
      ├── Claim creation error ──► ERROR (retry or manual intervention)
      │
      ▼
┌────────────┐
│ COMPLETE   │ (Claim created, FNOL linked)
└────────────┘

Additional terminal states:
  CANCELLED (user cancelled draft)
  ERROR (system error during processing)
```

---

## 19. Performance Metrics & KPIs

### 19.1 FNOL Operations Metrics

| Metric | Definition | Target | Measurement |
|---|---|---|---|
| FNOL Volume | Total FNOLs received per period | N/A (trend monitoring) | Daily/weekly/monthly |
| Channel Mix | % of FNOLs by channel | > 30% digital | Monthly |
| Average Handle Time (AHT) | Average duration of phone FNOL | < 15 minutes | Per call |
| First Call Resolution | % of FNOLs complete in one call | > 80% | Monthly |
| Abandonment Rate | % of callers who hang up | < 5% | Daily |
| Average Speed of Answer (ASA) | Wait time before CSR answers | < 60 seconds | Real-time |
| FNOL Completion Rate (Web) | % of web FNOLs started vs. completed | > 60% | Monthly |
| STP Rate | % of FNOLs processed straight-through | > 10% (growing) | Monthly |
| Data Quality Score (avg) | Average FNOL data quality score | > 85% | Monthly |
| Callback Rate | % of FNOLs requiring callback for missing info | < 20% | Monthly |
| FNOL-to-Claim Time | Time from FNOL submit to claim created | < 5 minutes | Per FNOL |
| FNOL-to-Contact Time | Time from FNOL to first insured contact | < 24 hours | Per claim |
| Duplicate Detection Accuracy | True positive rate for duplicate matches | > 95% | Monthly audit |
| Fraud Flag Accuracy | True positive rate for fraud scoring | > 60% | Quarterly audit |

---

## 20. FNOL Data Quality Scoring

### 20.1 Data Quality Scoring Algorithm

```
DATA QUALITY SCORE (0-100):

SECTION WEIGHTS:
  Reporter Information:    5%
  Policy Information:      10%
  Loss Details:            25%
  Vehicle Information:     20% (auto) / 0% (non-auto)
  Property Information:    20% (property) / 0% (non-property)
  Injury Information:      15% (if injuries) / 0% (no injuries)
  Other Party Information: 15%
  Documentation:           10%

FIELD SCORING within each section:
  Required field present and valid: 100%
  Required field present but unvalidated: 70%
  Optional field present and valid: 100% (bonus toward section score)
  Required field missing: 0%
  Optional field missing: N/A (not penalized)

EXAMPLE — Auto Collision FNOL:

  Reporter (5%):
    Name: present ✓ (100%), Phone: present ✓ (100%), Relationship: present ✓ (100%)
    Section score: 100% → weighted: 5.0

  Policy (10%):
    Policy Number: present and verified ✓ (100%), LOB: present ✓ (100%)
    Section score: 100% → weighted: 10.0

  Loss Details (25%):
    Date: ✓, Time: ✓, Location: ✓, Cause: ✓, Description: ✓ (detailed)
    Section score: 100% → weighted: 25.0

  Vehicle (20%):
    VIN: ✓, YMM: ✓, Impact: ✓, Drivable: ✓, Damage desc: ✓
    Other vehicle: partial (no VIN, has YMM)
    Section score: 85% → weighted: 17.0

  Injury (15%):
    Injured party name: ✓, Body part: ✓, Severity: ✓
    Hospital: ✓, Treatment: missing
    Section score: 80% → weighted: 12.0

  Other Party (15%):
    Name: ✓, Phone: ✓, Insurance: ✓, DL: missing
    Section score: 75% → weighted: 11.25

  Documentation (10%):
    Police report: ✓, Photos: not yet
    Section score: 50% → weighted: 5.0

  TOTAL DATA QUALITY SCORE: 85.25 / 100
  RATING: GOOD (>80 = Good, 60-80 = Fair, <60 = Poor)
```

---

## 21. Policy Admin System Integration

### 21.1 Real-Time PAS Integration Architecture

```
┌───────────────────┐                ┌───────────────────┐
│   CLAIMS / FNOL   │   REST API     │   POLICY ADMIN    │
│   SYSTEM          │◄──────────────►│   SYSTEM (PAS)    │
│                   │                │                   │
│  FNOL Module      │   Operations:  │  Policy Master    │
│  ┌─────────────┐  │                │  ┌─────────────┐  │
│  │Policy Lookup │──┼───────────────┼─►│Search Policy │  │
│  │             │  │  PolicySearch  │  │by Number,   │  │
│  │Coverage     │◄─┼───────────────┼──│Name, VIN    │  │
│  │Verification │  │  PolicyInquiry│  │             │  │
│  │             │  │                │  │Get Coverages│  │
│  │Billing      │◄─┼───────────────┼──│Get Billing  │  │
│  │Status Check │  │  BillingInq   │  │Status       │  │
│  │             │  │                │  │             │  │
│  │Vehicle/Prop │◄─┼───────────────┼──│Get Scheduled│  │
│  │Match        │  │  ItemInquiry  │  │Items        │  │
│  └─────────────┘  │                │  └─────────────┘  │
└───────────────────┘                └───────────────────┘

API Contract:
  GET /api/v1/policies/{policyNumber}
    ?lossDate=2026-04-15
    &includeCoverages=true
    &includeBilling=true
    &includeScheduledItems=true

Response includes:
  - Policy status and period
  - Named insured(s) with addresses
  - All active coverages with limits and deductibles
  - Billing status (current, grace period, cancelled)
  - Scheduled vehicles (VIN, YMM) or scheduled properties (addresses)
  - Endorsement history
  - Agent/broker information
  - Loss payees / mortgagees
  - Additional insureds
```

### 21.2 Integration Failure Handling

| Failure Scenario | Handling Strategy |
|---|---|
| PAS timeout | Retry 3x with exponential backoff; if still failing, allow FNOL with manual policy entry (flag for verification) |
| PAS returns no match | Allow CSR to enter policy info manually; flag for policy verification activity |
| PAS returns cancelled policy | Display warning to CSR; allow FNOL creation with coverage verification flag |
| PAS unavailable (outage) | Switch to cached policy data (refreshed daily); flag all FNOLs for PAS verification when restored |
| Data mismatch | Display both FNOL-entered and PAS data; CSR confirms which is correct |

---

## 22. Sample FNOL JSON Payloads

### 22.1 Property Claim (Homeowner Water Damage)

```json
{
  "fnol": {
    "reportChannel": "PHONE",
    "reportDateTime": "2026-04-16T07:15:00-05:00",
    "reporter": {
      "firstName": "Sarah",
      "lastName": "Williams",
      "relationshipToInsured": "SELF",
      "phone": "+12175551234",
      "email": "sarah.williams@email.com",
      "preferredLanguage": "en"
    },
    "policy": {
      "policyNumber": "HO3-2026-005678"
    },
    "lossDetails": {
      "lossDate": "2026-04-14",
      "lossTime": "23:30:00",
      "discoveryDate": "2026-04-14",
      "lossLocation": {
        "line1": "789 Maple Drive",
        "city": "Springfield",
        "stateCode": "IL",
        "postalCode": "62701",
        "countyName": "Sangamon"
      },
      "causeOfLossCode": "13",
      "description": "I came home and found water all over my kitchen floor. A pipe under the kitchen sink had burst. Water had been flowing for approximately 2-3 hours. The kitchen hardwood floor is buckled, lower cabinets are warped, baseboards are damaged, and drywall is water-stained about 18 inches up. Some contents in lower cabinets are also damaged."
    },
    "properties": [
      {
        "propertyType": "DWELLING",
        "address": {
          "line1": "789 Maple Drive",
          "city": "Springfield",
          "stateCode": "IL",
          "postalCode": "62701"
        },
        "constructionType": "FRAME",
        "yearBuilt": 1998,
        "squareFootage": 2200,
        "numberOfStories": 2,
        "occupancyType": "OWNER_OCCUPIED",
        "damageDescription": "Kitchen hardwood floor buckled, lower cabinets warped, baseboards damaged, drywall water stained up to 18 inches, contents in lower cabinets affected.",
        "damagedAreas": ["KITCHEN"],
        "habitability": "HABITABLE",
        "emergencyRepairsNeeded": true,
        "mitigationCompanyContacted": true,
        "estimatedBuildingDamage": 15000.00,
        "estimatedContentsDamage": 2000.00,
        "mortgageCompany": "First National Bank",
        "mortgageLoanNumber": "FNB-123456789"
      }
    ],
    "coverageSelections": {
      "dwelling": true,
      "personalProperty": true,
      "lossOfUse": false
    },
    "immediateNeeds": {
      "emergencyRepairsNeeded": true,
      "emergencyRepairsAuthorized": true,
      "emergencyHousingNeeded": false
    }
  }
}
```

### 22.2 Liability Claim (CGL Slip and Fall)

```json
{
  "fnol": {
    "reportChannel": "AGENT_PORTAL",
    "reportDateTime": "2026-04-16T10:00:00-05:00",
    "reporter": {
      "firstName": "David",
      "lastName": "Thompson",
      "relationshipToInsured": "AGENT",
      "phone": "+13125559876",
      "agentCode": "AGT-5432"
    },
    "policy": {
      "policyNumber": "CGL-2026-002345"
    },
    "lossDetails": {
      "lossDate": "2026-04-12",
      "lossTime": "14:20:00",
      "lossLocation": {
        "line1": "200 Commerce Drive",
        "city": "Chicago",
        "stateCode": "IL",
        "postalCode": "60601",
        "countyName": "Cook"
      },
      "causeOfLossCode": "30",
      "description": "A customer slipped and fell on a wet floor in the main retail area of the insured's store. The customer reports the floor was recently mopped but no wet floor signs were placed. The customer fell backwards, hitting her head on the floor. She complained of back and head pain. An ambulance was called and she was transported to Northwestern Memorial Hospital."
    },
    "policeReport": {
      "policeNotified": false,
      "emsDispatched": true,
      "emsTransported": true
    },
    "injuries": [
      {
        "injuredParty": {
          "firstName": "Patricia",
          "lastName": "Anderson",
          "dateOfBirth": "1962-08-15",
          "phone": "+13125554321",
          "address": {
            "line1": "890 Lake Shore Drive",
            "city": "Chicago",
            "stateCode": "IL",
            "postalCode": "60611"
          },
          "relationship": "CLAIMANT"
        },
        "injuryDescription": "Fell backwards on wet floor. Head struck floor. Complains of severe lower back pain and headache. Was conscious and alert at scene.",
        "bodyPartCode": "42",
        "additionalBodyParts": ["12"],
        "severity": "MODERATE",
        "transportedToHospital": true,
        "hospitalName": "Northwestern Memorial Hospital",
        "admittedToHospital": false,
        "treatedAndReleased": true
      }
    ],
    "witnesses": [
      {
        "firstName": "Emily",
        "lastName": "Rodriguez",
        "phone": "+13125551111",
        "statementSummary": "Was standing nearby when the customer fell. Confirmed the floor was wet and she did not see any warning signs."
      }
    ],
    "coverageSelections": {
      "bodilyInjuryLiability": true,
      "medicalPayments": true
    }
  }
}
```

---

*End of Article 4 — First Notice of Loss (FNOL): Complete Deep Dive*
