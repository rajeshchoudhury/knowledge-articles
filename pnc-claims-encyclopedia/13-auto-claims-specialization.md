# Article 13: Auto Claims — Complete Specialization Guide

## Table of Contents

1. [Auto Insurance Coverage Types](#1-auto-insurance-coverage-types)
2. [Auto Claim Types](#2-auto-claim-types)
3. [Auto FNOL Data Requirements](#3-auto-fnol-data-requirements)
4. [Liability Determination](#4-liability-determination)
5. [Auto Damage Estimation Workflow](#5-auto-damage-estimation-workflow)
6. [Estimatics Platforms Deep Dive](#6-estimatics-platforms-deep-dive)
7. [Photo-Based Estimation and AI](#7-photo-based-estimation-and-ai)
8. [Repair vs Replace Decision Logic](#8-repair-vs-replace-decision-logic)
9. [Parts Decisions and Regulations](#9-parts-decisions-and-regulations)
10. [Labor Rate Negotiations](#10-labor-rate-negotiations)
11. [Total Loss Determination](#11-total-loss-determination)
12. [Salvage Process](#12-salvage-process)
13. [Diminished Value Claims](#13-diminished-value-claims)
14. [Rental Car Management](#14-rental-car-management)
15. [Bodily Injury Claims](#15-bodily-injury-claims)
16. [PIP / No-Fault Processing](#16-pip--no-fault-processing)
17. [Medical Bill Review](#17-medical-bill-review)
18. [Attorney Representation and Litigation](#18-attorney-representation-and-litigation)
19. [UM/UIM Claim Processing](#19-umuim-claim-processing)
20. [Glass Claims](#20-glass-claims)
21. [Telematics and Connected Cars](#21-telematics-and-connected-cars)
22. [ADAS and Autonomous Vehicles](#22-adas-and-autonomous-vehicles)
23. [Rideshare / TNC Claims](#23-rideshare--tnc-claims)
24. [Fleet / Commercial Auto](#24-fleet--commercial-auto)
25. [Auto Claims Data Model](#25-auto-claims-data-model)
26. [Integration Architecture](#26-integration-architecture)
27. [Auto Claims Performance Metrics](#27-auto-claims-performance-metrics)

---

## 1. Auto Insurance Coverage Types

### 1.1 Coverage Structure Overview

```
  PERSONAL AUTO POLICY COVERAGE STRUCTURE
  ═══════════════════════════════════════

  ┌──────────────────────────────────────────────────────────────┐
  │                   PERSONAL AUTO POLICY                        │
  │                                                               │
  │  PART A: LIABILITY                                            │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │ Bodily Injury (BI)          Per person / Per accident   │ │
  │  │ Example: $100K / $300K      Covers injuries to others   │ │
  │  │                                                          │ │
  │  │ Property Damage (PD)        Per accident                │ │
  │  │ Example: $100K              Covers damage to others'    │ │
  │  │                             property                    │ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                               │
  │  PART B: MEDICAL PAYMENTS / PIP                               │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │ Medical Payments (MedPay)   Per person                  │ │
  │  │ Example: $5,000             Regardless of fault         │ │
  │  │                                                          │ │
  │  │ Personal Injury Protection  Per person (no-fault states)│ │
  │  │ Example: $10,000            Medical + lost wages + etc. │ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                               │
  │  PART C: UNINSURED / UNDERINSURED MOTORIST                   │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │ UM Bodily Injury            Per person / Per accident   │ │
  │  │ Example: $100K / $300K      When at-fault driver is     │ │
  │  │                             uninsured                   │ │
  │  │ UIM Bodily Injury           Per person / Per accident   │ │
  │  │ Example: $100K / $300K      When at-fault driver has    │ │
  │  │                             insufficient limits         │ │
  │  │ UM Property Damage          Per accident (some states)  │ │
  │  │ Example: $25K               Damage from uninsured driver│ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                               │
  │  PART D: PHYSICAL DAMAGE                                      │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │ Collision                   ACV minus deductible        │ │
  │  │ Deductible: $500            Covers own vehicle damage   │ │
  │  │                             from collision              │ │
  │  │                                                          │ │
  │  │ Comprehensive (Other-Than-  ACV minus deductible        │ │
  │  │ Collision)                  Theft, vandalism, weather,  │ │
  │  │ Deductible: $250            animal strike, glass, etc.  │ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                               │
  │  OPTIONAL COVERAGES                                           │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │ Rental Reimbursement        Per day / Max days          │ │
  │  │ Example: $50/day, 30 days   Rental while car repaired   │ │
  │  │                                                          │ │
  │  │ Towing & Labor              Per occurrence              │ │
  │  │ Example: $100               Tow to nearest shop         │ │
  │  │                                                          │ │
  │  │ Gap Coverage                ACV to loan balance          │ │
  │  │                             Covers "gap" when upside     │ │
  │  │                             down on loan                │ │
  │  │                                                          │ │
  │  │ Custom Equipment            Scheduled amount            │ │
  │  │ Example: $5,000             Aftermarket parts/equipment │ │
  │  │                                                          │ │
  │  │ Rideshare Endorsement       Extends coverage            │ │
  │  │                             During TNC periods          │ │
  │  └─────────────────────────────────────────────────────────┘ │
  └──────────────────────────────────────────────────────────────┘
```

### 1.2 Coverage Decision Matrix

| Scenario | Coverage Triggered | Deductible | Limit Applies |
|---|---|---|---|
| Insured at fault, hits another car | Collision (own damage), BI/PD Liability (other party) | Yes (Collision) | BI/PD per policy |
| Insured not at fault, hit by other | Other party's liability OR Collision (if pursued under own policy) | Yes if Collision used | ACV for own vehicle |
| Deer strike | Comprehensive | Yes | ACV |
| Vehicle stolen | Comprehensive | Yes | ACV |
| Hail damage | Comprehensive | Yes | ACV |
| Windshield crack | Comprehensive (glass) | Maybe $0 in some states | ACV |
| Insured hit by uninsured driver | UM (injuries), UMPD (damage in some states), Collision (own damage) | Varies by state | UM per policy |
| Passenger in insured's car injured | MedPay/PIP (own), BI Liability (if at fault) | No (MedPay/PIP) | Per person limit |
| Parked car vandalized | Comprehensive | Yes | ACV |
| Flood damage | Comprehensive | Yes | ACV |

---

## 2. Auto Claim Types

### 2.1 Collision Claim Types

| Claim Type | Description | Typical Severity | Key Investigation Points |
|---|---|---|---|
| Rear-end collision | Vehicle struck from behind | Low-High | Speed, following distance, distraction |
| Intersection accident | T-bone, broadside, red-light | High | Traffic signals, right of way, witnesses |
| Single vehicle | Departed road, struck object | Variable | Speed, impairment, road conditions |
| Multi-vehicle pileup | Chain-reaction (3+ vehicles) | Very High | Each impact point, causation chain |
| Head-on collision | Frontal impact between vehicles | Very High | Lane departure, impairment |
| Sideswipe | Lateral contact between vehicles | Low-Medium | Lane change, merge, blind spot |
| Backing accident | Collision while reversing | Low | Parking lot, driveway, visibility |
| Rollover | Vehicle overturns | High | Speed, terrain, vehicle center of gravity |

### 2.2 Non-Collision Claim Types

| Claim Type | Coverage | Typical Severity | Special Handling |
|---|---|---|---|
| Theft (entire vehicle) | Comprehensive | ACV of vehicle | Police report required, waiting period |
| Theft (partial) | Comprehensive | Low-Medium | Catalytic converter, wheels, electronics |
| Vandalism | Comprehensive | Low-Medium | Police report, neighborhood canvass |
| Hail damage | Comprehensive | Low-High | Weather verification, mass inspection |
| Flood / Water damage | Comprehensive | Total loss likely | Contamination assessment, water line |
| Animal strike | Comprehensive | Low-High | Most commonly deer |
| Falling objects | Comprehensive | Variable | Tree, building debris, cargo |
| Fire | Comprehensive | Total loss likely | Origin & cause investigation, arson check |
| Glass only | Comprehensive (glass) | Low | Often $0 deductible; AGRSS standards |
| Wind/tornado | Comprehensive | Variable | Weather verification, structural damage |

---

## 3. Auto FNOL Data Requirements

### 3.1 FNOL Field Categories

```
  AUTO FNOL DATA REQUIREMENTS (150+ FIELDS)
  ═════════════════════════════════════════

  CATEGORY 1: CLAIM IDENTIFIERS (15 fields)
  ┌──────────────────────────────────────────────────────────┐
  │ Field Name               │ Type     │ Required │ Source  │
  │──────────────────────────│──────────│──────────│─────────│
  │ claimNumber              │ String   │ Auto-gen │ System  │
  │ policyNumber             │ String   │ Yes      │ Caller  │
  │ fnolSource               │ Code     │ Yes      │ System  │
  │ fnolChannel              │ Code     │ Yes      │ System  │
  │ reportedDate             │ DateTime │ Yes      │ System  │
  │ reportedBy               │ String   │ Yes      │ Caller  │
  │ reportedByRelationship   │ Code     │ Yes      │ Caller  │
  │ reporterPhone            │ Phone    │ Yes      │ Caller  │
  │ reporterEmail            │ Email    │ No       │ Caller  │
  │ claimantRepresented      │ Boolean  │ Yes      │ Caller  │
  │ attorneyName             │ String   │ Cond     │ Caller  │
  │ attorneyFirm             │ String   │ Cond     │ Caller  │
  │ attorneyPhone            │ Phone    │ Cond     │ Caller  │
  │ policeReportFiled        │ Boolean  │ Yes      │ Caller  │
  │ policeReportNumber       │ String   │ Cond     │ Caller  │
  └──────────────────────────────────────────────────────────┘

  CATEGORY 2: LOSS INFORMATION (25 fields)
  ┌──────────────────────────────────────────────────────────┐
  │ lossDate                 │ DateTime │ Yes      │ Caller  │
  │ lossTime                 │ Time     │ Yes      │ Caller  │
  │ lossDescription          │ Text     │ Yes      │ Caller  │
  │ lossCauseCode            │ Code     │ Yes      │ System  │
  │ lossTypeCode             │ Code     │ Yes      │ System  │
  │ lossLocationAddress      │ Address  │ Yes      │ Caller  │
  │ lossLocationCity         │ String   │ Yes      │ Caller  │
  │ lossLocationState        │ Code     │ Yes      │ Caller  │
  │ lossLocationZip          │ String   │ Yes      │ Caller  │
  │ lossLocationCounty       │ String   │ No       │ Derived │
  │ lossLocationLatitude     │ Decimal  │ No       │ Geocode │
  │ lossLocationLongitude    │ Decimal  │ No       │ Geocode │
  │ lossLocationType         │ Code     │ No       │ Caller  │
  │ roadConditions           │ Code     │ No       │ Caller  │
  │ weatherConditions        │ Code     │ No       │ Caller  │
  │ lightConditions          │ Code     │ No       │ Caller  │
  │ speedLimit               │ Integer  │ No       │ Caller  │
  │ estimatedSpeed           │ Integer  │ No       │ Caller  │
  │ impactType               │ Code     │ No       │ Caller  │
  │ pointOfImpact            │ Code     │ Yes      │ Caller  │
  │ numberOfVehicles         │ Integer  │ Yes      │ Caller  │
  │ trafficControls          │ Code     │ No       │ Caller  │
  │ catastropheCode          │ String   │ No       │ System  │
  │ hitAndRun                │ Boolean  │ Yes      │ Caller  │
  │ alcoholDrugInvolved      │ Boolean  │ No       │ Caller  │
  └──────────────────────────────────────────────────────────┘

  CATEGORY 3: INSURED VEHICLE (30 fields)
  ┌──────────────────────────────────────────────────────────┐
  │ vehicleVIN               │ String   │ Yes      │ Policy  │
  │ vehicleYear              │ Integer  │ Yes      │ VIN     │
  │ vehicleMake              │ String   │ Yes      │ VIN     │
  │ vehicleModel             │ String   │ Yes      │ VIN     │
  │ vehicleTrim              │ String   │ No       │ VIN     │
  │ vehicleBodyStyle         │ Code     │ Yes      │ VIN     │
  │ vehicleColor             │ String   │ Yes      │ Caller  │
  │ vehicleMileage           │ Integer  │ Yes      │ Caller  │
  │ vehiclePlateNumber       │ String   │ No       │ Caller  │
  │ vehiclePlateState        │ Code     │ No       │ Caller  │
  │ vehicleConditionPreLoss  │ Code     │ No       │ Caller  │
  │ vehicleDriveable         │ Boolean  │ Yes      │ Caller  │
  │ vehicleCurrentLocation   │ Address  │ Yes      │ Caller  │
  │ vehicleLocationPhone     │ Phone    │ No       │ Caller  │
  │ towUsed                  │ Boolean  │ Yes      │ Caller  │
  │ towCompanyName           │ String   │ Cond     │ Caller  │
  │ primaryDamageArea        │ Code     │ Yes      │ Caller  │
  │ secondaryDamageArea      │ Code     │ No       │ Caller  │
  │ damageSeverity           │ Code     │ Yes      │ Caller  │
  │ airbagDeployed           │ Boolean  │ No       │ Caller  │
  │ preExistingDamage        │ Boolean  │ No       │ Caller  │
  │ preExistingDamageDesc    │ Text     │ Cond     │ Caller  │
  │ customEquipment          │ Boolean  │ No       │ Caller  │
  │ customEquipmentDesc      │ Text     │ Cond     │ Caller  │
  │ lienholderName           │ String   │ No       │ Policy  │
  │ lienholderAddress        │ Address  │ No       │ Policy  │
  │ ADAS features            │ List     │ No       │ VIN     │
  │ telematicsEquipped       │ Boolean  │ No       │ Policy  │
  │ rentalNeeded             │ Boolean  │ Yes      │ Caller  │
  │ rentalCoverageOnPolicy   │ Boolean  │ Yes      │ Policy  │
  └──────────────────────────────────────────────────────────┘

  CATEGORY 4: INSURED DRIVER (20 fields)
  ┌──────────────────────────────────────────────────────────┐
  │ driverFirstName          │ String   │ Yes      │ Caller  │
  │ driverLastName           │ String   │ Yes      │ Caller  │
  │ driverDOB                │ Date     │ Yes      │ Policy  │
  │ driverGender             │ Code     │ No       │ Policy  │
  │ driverLicenseNumber      │ String   │ Yes      │ Caller  │
  │ driverLicenseState       │ Code     │ Yes      │ Caller  │
  │ driverRelationToInsured  │ Code     │ Yes      │ Policy  │
  │ driverListedOnPolicy     │ Boolean  │ Yes      │ Policy  │
  │ driverPermission         │ Code     │ Yes      │ Caller  │
  │ driverPhone              │ Phone    │ Yes      │ Caller  │
  │ driverEmail              │ Email    │ No       │ Caller  │
  │ driverAddress            │ Address  │ Yes      │ Policy  │
  │ driverInjured            │ Boolean  │ Yes      │ Caller  │
  │ driverInjuryDesc         │ Text     │ Cond     │ Caller  │
  │ driverHospitalized       │ Boolean  │ Cond     │ Caller  │
  │ driverSeatbeltUsed       │ Boolean  │ No       │ Caller  │
  │ driverDistracted         │ Boolean  │ No       │ Caller  │
  │ driverImpaired           │ Boolean  │ No       │ Caller  │
  │ driverCitationIssued     │ Boolean  │ No       │ Caller  │
  │ driverCitationType       │ Text     │ Cond     │ Caller  │
  └──────────────────────────────────────────────────────────┘

  CATEGORY 5: PASSENGERS (15 fields per passenger)
  CATEGORY 6: OTHER VEHICLES (25 fields per vehicle)
  CATEGORY 7: OTHER PARTIES/DRIVERS (20 fields per party)
  CATEGORY 8: WITNESSES (10 fields per witness)
  CATEGORY 9: INJURY DETAILS (20 fields per injured party)
  CATEGORY 10: COVERAGE SELECTION (15 fields)
```

---

## 4. Liability Determination

### 4.1 Fault Determination Frameworks

```
  LIABILITY DETERMINATION SYSTEMS
  ═══════════════════════════════

  PURE CONTRIBUTORY NEGLIGENCE (plaintiff barred if any fault):
  States: AL, DC, MD, NC, VA
  Rule: If claimant is even 1% at fault → NO recovery

  PURE COMPARATIVE NEGLIGENCE (recovery reduced by fault %):
  States: AK, AZ, CA, FL, KY, LA, MS, MO, NM, NY, RI, SD, WA
  Rule: 30% at fault → recover 70% of damages

  MODIFIED COMPARATIVE - 50% BAR:
  States: AR, CO, GA, ID, KS, ME, NE, ND, OK, SC, TN, UT, WV
  Rule: 50% or more at fault → NO recovery

  MODIFIED COMPARATIVE - 51% BAR:
  States: CT, DE, HI, IL, IN, IA, MA, MI, MN, MT, NV, NH,
          NJ, OH, OR, PA, TX, VT, WI, WY
  Rule: 51% or more at fault → NO recovery

  NO-FAULT (PIP threshold / limited tort):
  States: FL, HI, KS, KY, MA, MI, MN, NJ, NY, ND, PA, UT
  Rule: PIP covers own injuries up to threshold; tort recovery
        only if injuries exceed verbal/monetary threshold
```

### 4.2 Fault Determination Rules (Common Scenarios)

| Scenario | Typical Fault Assignment | Key Factors |
|---|---|---|
| Rear-end collision | 100% striking vehicle | Presumption of following too closely |
| Left-turn collision | 80-100% turning vehicle | Duty to yield; oncoming speed |
| Red light violation | 100% violating vehicle | Signal timing, witness, camera |
| Lane change | 70-100% lane changer | Signal use, blind spot, speed |
| Parking lot (backing) | 50-100% backing vehicle | Right of way in travel lane |
| Multi-vehicle chain | Varies per impact | Each impact analyzed separately |
| Uncontrolled intersection | Comparative | Right-of-way rules, speed |
| Single vehicle (ice) | 100% driver | Road conditions, speed for conditions |
| T-bone at stop sign | 90-100% sign violator | Stop sign compliance, view obstruction |
| Head-on (center line) | 100% crossing vehicle | Lane departure, impairment |

### 4.3 Liability Decision Data Model

```json
{
  "LiabilityDetermination": {
    "claimNumber": "CLM-2025-00001234",
    "determinationDate": "2025-03-20",
    "determinedBy": "adjuster.jsmith",
    "jurisdiction": "CA",
    "negligenceStandard": "PURE_COMPARATIVE",
    "faultAssessment": [
      {
        "partyId": "PARTY-001",
        "partyRole": "INSURED_DRIVER",
        "faultPercentage": 20,
        "faultBasis": [
          "Following at safe distance but excess speed for conditions"
        ],
        "evidenceSources": [
          "POLICE_REPORT",
          "WITNESS_STATEMENT_1",
          "TELEMATICS_DATA"
        ]
      },
      {
        "partyId": "PARTY-002",
        "partyRole": "THIRD_PARTY_DRIVER",
        "faultPercentage": 80,
        "faultBasis": [
          "Failed to stop at red light",
          "Distracted driving (cell phone per witness)"
        ],
        "evidenceSources": [
          "POLICE_REPORT",
          "WITNESS_STATEMENT_1",
          "WITNESS_STATEMENT_2",
          "TRAFFIC_CAMERA"
        ]
      }
    ],
    "totalFault": 100,
    "liabilityStatus": "ACCEPTED",
    "disputeStatus": "NONE",
    "subrogationPotential": {
      "exists": true,
      "adverseCarrier": "Other Insurance Co.",
      "adversePolicyNumber": "OTH-2025-99999",
      "estimatedRecovery": 12000.00,
      "faultBasisForRecovery": "80% adverse driver fault"
    }
  }
}
```

---

## 5. Auto Damage Estimation Workflow

### 5.1 End-to-End Estimation Process

```
  AUTO DAMAGE ESTIMATION WORKFLOW
  ═══════════════════════════════

  FNOL          Assignment      Inspection      Estimate        Approval
  ────          ──────────      ──────────      ────────        ────────
   │                │               │               │               │
   │ Claim created  │               │               │               │
   │ with damage    │               │               │               │
   │ details        │               │               │               │
   │───────────────▶│               │               │               │
   │                │               │               │               │
   │                │ Route based   │               │               │
   │                │ on:           │               │               │
   │                │ - Severity    │               │               │
   │                │ - Location    │               │               │
   │                │ - DRP status  │               │               │
   │                │ - Driveable?  │               │               │
   │                │───────────────▶               │               │
   │                │               │               │               │
   │                │               │ Inspect:      │               │
   │                │               │ - Visual exam │               │
   │                │               │ - Photos      │               │
   │                │               │ - Damage doc  │               │
   │                │               │ - Hidden dmg  │               │
   │                │               │───────────────▶               │
   │                │               │               │               │
   │                │               │               │ Write estimate│
   │                │               │               │ using:        │
   │                │               │               │ - CCC/Mitchell│
   │                │               │               │ - OEM proced. │
   │                │               │               │ - P&L rates   │
   │                │               │               │ - Parts price │
   │                │               │               │───────────────▶
   │                │               │               │               │
   │                │               │               │               │
   │                │               │               │               │

  Supplement       Repair          QA              Close
  ──────────       ──────          ──              ─────
       │               │               │               │
       │  Additional   │               │               │
       │  damage found │               │               │
       │  during tear- │               │               │
       │  down         │               │               │
       │───────────────▶               │               │
       │               │               │               │
       │               │ Repair per   │               │
       │               │ approved     │               │
       │               │ estimate     │               │
       │               │──────────────▶│               │
       │               │               │               │
       │               │               │ Quality check│
       │               │               │ Photos       │
       │               │               │ Test drive   │
       │               │               │──────────────▶
       │               │               │               │
       │               │               │               │ Release
       │               │               │               │ vehicle
       │               │               │               │ Close
       │               │               │               │ exposure
```

### 5.2 Assignment Routing Logic

```
  ASSIGNMENT ROUTING DECISION TREE
  ═════════════════════════════════

  ┌─── Is vehicle driveable? ───┐
  │                              │
  YES                           NO
  │                              │
  ├── Damage < $2,500?          ├── Total loss likely?
  │   │                         │   │
  │   YES → Photo Estimate      │   YES → Total Loss
  │   │     (AI/Virtual)        │   │     Assignment
  │   │                         │   │     (Desk review)
  │   NO → DRP Shop?            │   │
  │       │                     │   NO → Tow to DRP
  │       YES → Direct to       │       or Inspection
  │       │     DRP Shop        │       Site
  │       │                     │
  │       NO → Field            │
  │           Appraiser         │
  │           Assignment        │
  │                              │
  └──────────────────────────────┘
```

---

## 6. Estimatics Platforms Deep Dive

### 6.1 CCC ONE

```
  CCC ONE PLATFORM OVERVIEW
  ═════════════════════════

  ┌──────────────────────────────────────────────────────────┐
  │                      CCC ONE                              │
  │                                                           │
  │  MODULES:                                                 │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ CCC ONE         │  │ CCC Smart        │             │
  │  │ Estimating      │  │ Estimate         │             │
  │  │ (Full platform) │  │ (Photo AI)       │             │
  │  └──────────────────┘  └──────────────────┘             │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ CCC ONE Total   │  │ CCC Secure       │             │
  │  │ Loss            │  │ Share            │             │
  │  │ (Valuation)     │  │ (Communication)  │             │
  │  └──────────────────┘  └──────────────────┘             │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ CCC ONE         │  │ CCC Casualty     │             │
  │  │ Workflow        │  │ (BI/Med)         │             │
  │  │ (Assignment)    │  │                  │             │
  │  └──────────────────┘  └──────────────────┘             │
  │                                                           │
  │  INTEGRATION:                                             │
  │  • BMS/CIECA XML for assignment and estimate exchange    │
  │  • REST APIs for real-time data                          │
  │  • SFTP for batch file exchange                          │
  │  • Webhooks for status notifications                     │
  │                                                           │
  │  DATA:                                                    │
  │  • 300M+ historical repair records                       │
  │  • Real-time parts pricing                               │
  │  • Labor rate databases                                  │
  │  • Total loss valuations (market-based)                  │
  │  • OEM repair procedures                                 │
  │  • Paint/materials calculators                           │
  └──────────────────────────────────────────────────────────┘
```

### 6.2 Mitchell International

```
  MITCHELL PLATFORM OVERVIEW
  ══════════════════════════

  ┌──────────────────────────────────────────────────────────┐
  │                     MITCHELL                              │
  │                                                           │
  │  MODULES:                                                 │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ Mitchell Cloud   │  │ Mitchell AI      │             │
  │  │ Estimating       │  │ Smart Review     │             │
  │  └──────────────────┘  └──────────────────┘             │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ Mitchell         │  │ Mitchell         │             │
  │  │ WorkCenter       │  │ RepairCenter     │             │
  │  │ (Claims WF)      │  │ (Shop Mgmt)      │             │
  │  └──────────────────┘  └──────────────────┘             │
  │  ┌──────────────────┐  ┌──────────────────┐             │
  │  │ Mitchell TotalLoss│ │ Mitchell         │             │
  │  │ (Valuation)       │ │ Medical          │             │
  │  └──────────────────┘  └──────────────────┘             │
  │                                                           │
  │  DATA FORMATS:                                           │
  │  • CIECA BMS XML                                         │
  │  • Mitchell MDL (Mitchell Data Language)                 │
  │  • REST API                                              │
  │  • SFTP batch                                            │
  └──────────────────────────────────────────────────────────┘
```

### 6.3 Audatex (Solera)

```
  AUDATEX PLATFORM OVERVIEW
  ═════════════════════════

  ┌──────────────────────────────────────────────────────────┐
  │                    AUDATEX (Solera)                        │
  │                                                           │
  │  • Primarily European and international market           │
  │  • Growing US presence via Solera/Qapter                 │
  │  • AI-powered photo damage assessment                    │
  │  • 3D vehicle models for damage mapping                  │
  │  • Real-time OEM parts pricing                           │
  │  • Multi-language, multi-currency support                │
  │                                                           │
  │  Integration:                                             │
  │  • REST API (modern)                                     │
  │  • SOAP/XML (legacy)                                     │
  │  • Flat file (batch)                                     │
  └──────────────────────────────────────────────────────────┘
```

### 6.4 Estimate Data Format (CIECA BMS)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<BMS xmlns="http://www.cieca.com/BMS">
  <EstimateRs>
    <RsUID>EST-2025-00045678</RsUID>
    <EstimateInfo>
      <EstimateDate>2025-03-18</EstimateDate>
      <EstimateType>Original</EstimateType>
      <VehicleInfo>
        <VIN>1HGBH41JXMN109186</VIN>
        <Year>2023</Year>
        <Make>Honda</Make>
        <Model>Accord</Model>
        <Mileage>28500</Mileage>
      </VehicleInfo>
      <DamageInfo>
        <PrimaryDamage>RearEnd</PrimaryDamage>
        <DamageSeverity>Moderate</DamageSeverity>
      </DamageInfo>
      <LineItems>
        <LineItem>
          <LineType>Replace</LineType>
          <PartDescription>Rear Bumper Cover</PartDescription>
          <PartNumber>04715-TVA-A00ZZ</PartNumber>
          <PartType>OEM</PartType>
          <PartPrice>485.00</PartPrice>
          <LaborType>Body</LaborType>
          <LaborHours>1.5</LaborHours>
          <LaborRate>52.00</LaborRate>
          <LaborAmount>78.00</LaborAmount>
          <PaintHours>2.0</PaintHours>
          <PaintRate>52.00</PaintRate>
          <PaintAmount>104.00</PaintAmount>
        </LineItem>
        <LineItem>
          <LineType>Replace</LineType>
          <PartDescription>Trunk Lid</PartDescription>
          <PartNumber>68100-TVA-A00ZZ</PartNumber>
          <PartType>OEM</PartType>
          <PartPrice>892.00</PartPrice>
          <LaborType>Body</LaborType>
          <LaborHours>3.0</LaborHours>
          <LaborRate>52.00</LaborRate>
          <LaborAmount>156.00</LaborAmount>
          <PaintHours>3.5</PaintHours>
          <PaintRate>52.00</PaintRate>
          <PaintAmount>182.00</PaintAmount>
        </LineItem>
        <LineItem>
          <LineType>Repair</LineType>
          <PartDescription>Rear Body Panel</PartDescription>
          <LaborType>Body</LaborType>
          <LaborHours>4.0</LaborHours>
          <LaborRate>52.00</LaborRate>
          <LaborAmount>208.00</LaborAmount>
          <PaintHours>2.5</PaintHours>
          <PaintRate>52.00</PaintRate>
          <PaintAmount>130.00</PaintAmount>
        </LineItem>
      </LineItems>
      <Totals>
        <PartsTotal>1377.00</PartsTotal>
        <LaborTotal>442.00</LaborTotal>
        <PaintTotal>416.00</PaintTotal>
        <PaintMaterialsTotal>198.50</PaintMaterialsTotal>
        <MiscCharges>45.00</MiscCharges>
        <SubletTotal>0.00</SubletTotal>
        <BettermentDeduction>0.00</BettermentDeduction>
        <GrossTotal>2478.50</GrossTotal>
        <TaxTotal>198.28</TaxTotal>
        <NetTotal>2676.78</NetTotal>
      </Totals>
    </EstimateInfo>
  </EstimateRs>
</BMS>
```

---

## 7. Photo-Based Estimation and AI

### 7.1 AI Damage Assessment Pipeline

```
  AI PHOTO ESTIMATION PIPELINE
  ═══════════════════════════

  Photo Capture     Upload &          AI Processing        Output
  ─────────────     Validation        ─────────────        ──────
      │                │                   │                  │
      │ Customer takes │                   │                  │
      │ photos via     │                   │                  │
      │ mobile app     │                   │                  │
      │ (guided flow)  │                   │                  │
      │───────────────▶│                   │                  │
      │                │                   │                  │
      │                │ Validate:         │                  │
      │                │ - Image quality   │                  │
      │                │ - Vehicle visible │                  │
      │                │ - Damage visible  │                  │
      │                │ - All angles      │                  │
      │                │──────────────────▶│                  │
      │                │                   │                  │
      │                │                   │ 1. Vehicle ID    │
      │                │                   │    (make/model)  │
      │                │                   │                  │
      │                │                   │ 2. Damage        │
      │                │                   │    Detection     │
      │                │                   │    (bounding box)│
      │                │                   │                  │
      │                │                   │ 3. Damage        │
      │                │                   │    Classification│
      │                │                   │    (dent, scratch,│
      │                │                   │     crack, etc.) │
      │                │                   │                  │
      │                │                   │ 4. Severity      │
      │                │                   │    Assessment    │
      │                │                   │    (repair/      │
      │                │                   │     replace)     │
      │                │                   │                  │
      │                │                   │ 5. Cost          │
      │                │                   │    Estimation    │
      │                │                   │──────────────────▶
      │                │                   │                  │
      │                │                   │                  │ Estimate
      │                │                   │                  │ + Confidence
      │                │                   │                  │ Score

  Required Photos (minimum 7):
  1. Full front view
  2. Full rear view
  3. Full left side
  4. Full right side
  5. Damage close-up (primary)
  6. Damage close-up (secondary)
  7. VIN plate / Odometer
  
  Optional but valuable:
  8-12. Additional damage angles
  13. Interior damage (if applicable)
  14. Undercarriage (if accessible)
```

### 7.2 AI Confidence and Routing

| Confidence Score | Action | Accuracy (Industry Avg) |
|---|---|---|
| 95%+ | Auto-approve estimate | ~90% within 10% of final |
| 80-95% | Desk review by adjuster | ~75% within 15% of final |
| 60-80% | Virtual inspection with customer | ~60% within 20% of final |
| < 60% | Field inspection required | Insufficient for auto-estimate |

---

## 8. Repair vs Replace Decision Logic

### 8.1 Decision Rules

```
  REPAIR vs REPLACE DECISION MATRIX
  ═══════════════════════════════════

  For each damaged component:

  ┌─── Is repair technically feasible? ───┐
  │                                        │
  NO → REPLACE                            YES
  │                                        │
  │    Safety-critical part?               │
  │    ┌─────────────────┐                 │
  │    YES → REPLACE     │                 │
  │    │    (OEM usually) │                 │
  │    └─────────────────┘                 │
  │                                        │
  │                              ├── Repair cost vs replacement cost?
  │                              │
  │                         Repair < Replace → REPAIR
  │                         │
  │                         Repair ≥ Replace → REPLACE
  │                              │
  │                              ├── Structural component?
  │                              │   YES → Follow OEM procedures
  │                              │         (may require replacement)
  │                              │
  │                              ├── Paint blend required?
  │                              │   Factor into total repair cost
  │                              │
  │                              └── Prior damage exists?
  │                                  Factor into betterment
```

---

## 9. Parts Decisions and Regulations

### 9.1 Parts Type Hierarchy

| Part Type | Abbreviation | Description | Price (vs OEM) | Quality |
|---|---|---|---|---|
| OEM (Original Equipment) | OEM | From vehicle manufacturer | 100% (baseline) | Guaranteed fit |
| Opt-OEM | O-OEM | OEM surplus/discontinued | 70-90% | OEM quality |
| Aftermarket (CAPA certified) | A/M CAPA | Third-party, certified quality | 40-70% | Certified fit |
| Aftermarket (non-certified) | A/M | Third-party, not certified | 30-60% | Variable |
| Like Kind and Quality (recycled) | LKQ | Salvage yard, used OEM | 30-60% | Variable condition |
| Reconditioned | Recon | Refurbished used part | 40-70% | Inspected |
| Remanufactured | Reman | Factory rebuilt to spec | 50-80% | Warranted |

### 9.2 State-by-State Parts Rules (Key States)

```
  PARTS REGULATION SUMMARY
  ═══════════════════════

  CALIFORNIA (strict):
  • Written notice required when non-OEM parts used
  • Parts must be "at least equal in like, kind, and quality"
  • Consumer consent recommended (not explicitly required)
  • No aftermarket on vehicles < 3 years (best practice)

  FLORIDA (strict):
  • Written consent required for non-OEM parts on vehicles < 36 months
  • Aftermarket crash parts must meet CAPA or equivalent standards
  • Must disclose in writing on estimate

  TEXAS (strict):
  • Written notice required before using non-OEM parts
  • Must meet quality standards "equal to or exceeding" OEM
  • Consumer can request OEM at their expense difference

  NEW YORK (strict):
  • Disclosure required on every estimate
  • Must identify each non-OEM part
  • Cannot require aftermarket parts

  MASSACHUSETTS (strict):
  • No aftermarket parts on vehicles < 3 years old
  • Written disclosure required
  • LKQ with quality verification

  ILLINOIS:
  • Written disclosure of non-OEM parts
  • Must be of "like kind and quality"
  • Consumer can refuse aftermarket
```

---

## 10. Labor Rate Negotiations

### 10.1 Labor Rate Categories

| Labor Type | Description | Typical Rate Range |
|---|---|---|
| Body Labor | Sheet metal repair, panel replacement | $48 - $75/hr |
| Paint Labor | Surface prep, painting, blending | $48 - $75/hr |
| Mechanical Labor | Engine, transmission, suspension | $80 - $150/hr |
| Frame Labor | Unibody/frame straightening | $55 - $85/hr |
| Aluminum/Specialty | Aluminum panel work | $65 - $100/hr |
| Glass Labor | Windshield, side glass | Included in flat rate |
| Diagnostic | Computer diagnostics, ADAS calibration | $100 - $200/hr |
| Detail/Clean | Interior cleaning, final detail | $40 - $60/hr |

### 10.2 Prevailing Rate Determination

```
  LABOR RATE DETERMINATION PROCESS
  ═════════════════════════════════

  ┌──────────────────────────────────────────────────────────┐
  │ Geographic Market Survey                                  │
  │                                                           │
  │ 1. Define market area (e.g., 15-mile radius from loss)   │
  │ 2. Survey competitive shops in market area                │
  │ 3. Determine prevailing rate (mode or majority rate)      │
  │ 4. Document rate basis                                    │
  │                                                           │
  │ Market Rate Factors:                                      │
  │ • Metropolitan vs rural                                   │
  │ • Shop certification level (OEM certified, I-CAR Gold)    │
  │ • Equipment investment (aluminum, ADAS)                   │
  │ • Technician training and certification                   │
  │ • Regional cost of living                                 │
  │ • Supply and demand for repair capacity                   │
  └──────────────────────────────────────────────────────────┘
```

---

## 11. Total Loss Determination

### 11.1 Total Loss Threshold by State

```
  TOTAL LOSS THRESHOLD MAP
  ═══════════════════════

  PERCENTAGE-BASED THRESHOLDS:
  ┌──────────────────────────────────────────────────────────┐
  │ 60% │ OK                                                 │
  │ 65% │ NV                                                 │
  │ 70% │ AR, IN, IA, MN, OH, WI                            │
  │ 75% │ AL, AZ, CT, DE, GA, HI, ID, KS, KY, ME, MD, MS, │
  │     │ NE, NH, NC, ND, RI, SC, SD, TN, VA, DC            │
  │ 80% │ AK, CA, FL, MI, NJ, NM, NY, OR, WA, WV, WY      │
  │ 90% │ UT                                                 │
  │ 100%│ CO, TX (Total Loss Formula: cost to repair ≥ ACV) │
  └──────────────────────────────────────────────────────────┘

  TOTAL LOSS FORMULA (TLF) STATES:
  ┌──────────────────────────────────────────────────────────┐
  │ IL, MT, PA, VT: Cost of repair + Salvage value ≥ ACV    │
  │                                                           │
  │ Formula: If (Repair Cost + Salvage Value) >= ACV          │
  │          Then → Total Loss                                │
  │                                                           │
  │ Example:                                                  │
  │ ACV = $25,000                                             │
  │ Repair Cost = $18,000                                     │
  │ Salvage Value = $8,000                                    │
  │ $18,000 + $8,000 = $26,000 ≥ $25,000 → Total Loss       │
  └──────────────────────────────────────────────────────────┘
```

### 11.2 Actual Cash Value (ACV) Determination

```
  ACV DETERMINATION METHODS
  ═════════════════════════

  METHOD 1: COMPARABLE VEHICLE SEARCH (Most Common)
  ┌──────────────────────────────────────────────────────────┐
  │ Sources: CCC Valuescope, Mitchell WorkCenter,            │
  │          JD Power (NADA), Kelley Blue Book, Black Book   │
  │                                                           │
  │ Process:                                                  │
  │ 1. Identify base vehicle (YMM, trim, options)            │
  │ 2. Search for comparable vehicles in market               │
  │    (within 100-150 mile radius typically)                 │
  │ 3. Adjust for condition, mileage, options                │
  │ 4. Remove outliers                                        │
  │ 5. Calculate weighted average                             │
  │ 6. Apply condition adjustment                             │
  │                                                           │
  │ Sample Comparable Search:                                 │
  │ ┌────────────────────────────────────────────────────┐  │
  │ │ Comp # │ Source    │ Price   │ Miles  │ Condition  │  │
  │ │ 1      │ Dealer A  │ $27,500 │ 25,000 │ Good       │  │
  │ │ 2      │ Dealer B  │ $26,800 │ 30,000 │ Good       │  │
  │ │ 3      │ Dealer C  │ $28,200 │ 22,000 │ Excellent  │  │
  │ │ 4      │ Private   │ $25,500 │ 32,000 │ Good       │  │
  │ │ 5      │ Dealer D  │ $27,100 │ 28,000 │ Good       │  │
  │ │────────│───────────│─────────│────────│────────────│  │
  │ │ Avg    │           │ $27,020 │ 27,400 │            │  │
  │ └────────────────────────────────────────────────────┘  │
  │                                                           │
  │ Subject vehicle: 28,500 miles, Good condition            │
  │ Mileage adjustment: +$200 (slightly above average)       │
  │ Condition adjustment: $0 (matches comps)                 │
  │ ACV = $27,020 + $200 = $27,220                          │
  └──────────────────────────────────────────────────────────┘
```

### 11.3 Total Loss Settlement Calculation

```json
{
  "TotalLossSettlement": {
    "claimNumber": "CLM-2025-00001234",
    "vehicleVIN": "1HGBH41JXMN109186",
    "vehicleDescription": "2023 Honda Accord EX-L",
    "actualCashValue": 27220.00,
    "adjustments": {
      "positiveAdjustments": [
        { "type": "DEALER_MARKUP", "amount": 0 },
        { "type": "TAX_TITLE_LICENSE", "amount": 2450.00 },
        { "type": "CUSTOM_EQUIPMENT", "amount": 0 }
      ],
      "negativeAdjustments": [
        { "type": "PRIOR_DAMAGE", "amount": -500.00 },
        { "type": "BETTERMENT", "amount": 0 }
      ]
    },
    "grossSettlement": 29170.00,
    "deductible": 500.00,
    "netSettlement": 28670.00,
    "salvage": {
      "retainedByOwner": false,
      "salvageValue": 8500.00,
      "salvageBuyer": "Copart",
      "titleBrand": "SALVAGE"
    },
    "lienPayoff": {
      "lienholderName": "Chase Auto Finance",
      "payoffAmount": 22000.00,
      "payoffGoodThrough": "2025-04-15"
    },
    "paymentBreakdown": [
      {
        "payee": "Chase Auto Finance (lienholder)",
        "amount": 22000.00,
        "paymentMethod": "CHECK"
      },
      {
        "payee": "John A. Smith (insured - equity)",
        "amount": 6670.00,
        "paymentMethod": "ACH"
      }
    ],
    "gapAnalysis": {
      "gapCoverageApplicable": false,
      "loanBalance": 22000.00,
      "settlementToLienholder": 22000.00,
      "gapAmount": 0
    },
    "state": "CA",
    "totalLossThreshold": "80%",
    "repairCostEstimate": 22500.00,
    "repairCostToACVRatio": 0.827,
    "totalLossDecision": "TOTAL_LOSS"
  }
}
```

---

## 12. Salvage Process

### 12.1 Salvage Workflow

```
  SALVAGE PROCESS FLOW
  ═══════════════════

  Total Loss       Title          Salvage          Auction
  Decision         Processing     Assignment       Sale
  ──────────       ──────────     ──────────       ───────
      │                │              │               │
      │ TL declared    │              │               │
      │───────────────▶│              │               │
      │                │              │               │
      │                │ Obtain title │               │
      │                │ from:        │               │
      │                │ - Owner      │               │
      │                │ - Lienholder │               │
      │                │ - DMV        │               │
      │                │──────────────▶               │
      │                │              │               │
      │                │              │ Assign to     │
      │                │              │ auction:      │
      │                │              │ - Copart      │
      │                │              │ - IAA         │
      │                │              │ - Other       │
      │                │              │───────────────▶
      │                │              │               │
      │                │              │               │ Pick up
      │                │              │               │ vehicle
      │                │              │               │
      │                │              │               │ List for
      │                │              │               │ online
      │                │              │               │ auction
      │                │              │               │
      │                │              │               │ Sell
      │                │              │               │ vehicle
      │                │              │               │
      │                │              │  Sale proceeds│
      │                │              │◀──────────────│
      │                │              │               │
      │  Reconcile     │              │               │
      │  salvage       │              │               │
      │◀──────────────────────────────│               │
```

### 12.2 Title Brand Types

| Brand | Description | State Application |
|---|---|---|
| Salvage | Damage exceeds state TL threshold | All states |
| Rebuilt | Salvage vehicle restored and inspected | All states |
| Flood | Vehicle damaged by flood/submersion | Many states |
| Junk | Not economically repairable | Many states |
| Dismantled | Parts-only vehicle | Some states |
| Lemon Law Buyback | Manufacturer repurchase | Some states |
| Theft Recovery | Recovered after theft | Some states |

---

## 13. Diminished Value Claims

### 13.1 Diminished Value Types

| Type | Description | When Applicable |
|---|---|---|
| Inherent DV | Loss of value due to accident history alone | Most common; vehicle repaired to pre-loss condition but still worth less |
| Repair-Related DV | Loss due to imperfect repair quality | When repair quality is demonstrably inferior |
| Immediate DV | Difference in ACV before and after accident (before repair) | Pre-repair valuation difference |

### 13.2 DV Calculation Methods

```
  DIMINISHED VALUE CALCULATION (17c Formula / Common Method)
  ═══════════════════════════════════════════════════════════

  Step 1: Base Value = ACV of vehicle (pre-loss)
  Step 2: Apply 10% cap (industry standard)
          Base DV = ACV × 10% = $27,220 × 10% = $2,722

  Step 3: Apply Damage Severity Multiplier
  ┌──────────────────────────────────────────────────┐
  │ Severity        │ Multiplier │ Description        │
  │─────────────────│────────────│────────────────────│
  │ Severe structural│ 1.00      │ Frame damage, major│
  │ Major panels     │ 0.75      │ Multiple panels    │
  │ Moderate panels  │ 0.50      │ Fender, door, etc. │
  │ Minor damage     │ 0.25      │ Bumper only        │
  │ No structural    │ 0.00      │ Superficial only   │
  └──────────────────────────────────────────────────┘

  Step 4: Apply Mileage Multiplier
  ┌──────────────────────────────────────────────────┐
  │ Mileage Range    │ Multiplier                    │
  │──────────────────│───────────────────────────────│
  │ 0 - 19,999       │ 1.00                          │
  │ 20,000 - 39,999  │ 0.80                          │
  │ 40,000 - 59,999  │ 0.60                          │
  │ 60,000 - 79,999  │ 0.40                          │
  │ 80,000 - 99,999  │ 0.20                          │
  │ 100,000+          │ 0.00                          │
  └──────────────────────────────────────────────────┘

  Example:
  ACV: $27,220
  Base DV: $2,722 (10% of ACV)
  Severity: Moderate panels (0.50)
  Mileage: 28,500 (0.80)
  
  DV = $2,722 × 0.50 × 0.80 = $1,088.80

  Note: Many states (e.g., GA - State Farm v. Mabry) have
  established that DV claims are legitimate first-party claims.
```

---

## 14. Rental Car Management

### 14.1 Rental Authorization Logic

```
  RENTAL CAR DECISION TREE
  ═══════════════════════

  ┌─── Does insured have rental coverage? ───┐
  │                                           │
  YES                                        NO
  │                                           │
  ├── What are the limits?                    ├── Is insured the claimant
  │   $30/day × 30 days = $900              │   (other party at fault)?
  │   $50/day × 30 days = $1,500            │   │
  │                                           │   YES → Third party rental
  │                                           │   │     (charged to at-fault
  │                                           │   │      carrier)
  │                                           │   │
  │                                           │   NO → No rental coverage
  │                                           │        available
  │
  ├── Repairable vehicle?
  │   YES → Authorize for repair duration
  │         + reasonable delivery time
  │
  │   NO (Total Loss) → Authorize for:
  │         Settlement negotiation period
  │         + reasonable time to find replacement
  │         (typically 3-7 days after settlement offer)
  │
  └── Comparable vehicle class
      (same or lower class as insured vehicle)
```

### 14.2 Rental Duration Rules

| State | First-Party Rental (Own Coverage) | Third-Party Rental (Claimant) |
|---|---|---|
| CA | Per policy limits | Reasonable repair time + search time |
| FL | Per policy limits | Reasonable; duty to mitigate |
| TX | Per policy limits | Repair time or TL settlement + 5 days |
| NY | Per policy limits | Until vehicle repaired or replaced |
| GA | Per policy limits | Reasonable time |

---

## 15. Bodily Injury Claims

### 15.1 BI Claim Evaluation Framework

```
  BODILY INJURY CLAIM EVALUATION
  ═══════════════════════════════

  SPECIAL DAMAGES (Economic / Objective)
  ┌──────────────────────────────────────────────────────────┐
  │ Category                │ Components                     │
  │─────────────────────────│────────────────────────────────│
  │ Medical Expenses        │ ER, hospital, surgery,         │
  │                         │ physician, PT, chiropractic,   │
  │                         │ prescription, DME, diagnostic  │
  │                         │                                │
  │ Lost Wages              │ Current lost income,           │
  │                         │ future lost earnings capacity  │
  │                         │                                │
  │ Property Damage         │ Vehicle, personal property     │
  │                         │                                │
  │ Out-of-Pocket           │ Transportation, household      │
  │                         │ services, accommodations       │
  └──────────────────────────────────────────────────────────┘

  GENERAL DAMAGES (Non-Economic / Subjective)
  ┌──────────────────────────────────────────────────────────┐
  │ Category                │ Factors                        │
  │─────────────────────────│────────────────────────────────│
  │ Pain and Suffering      │ Severity, duration, nature     │
  │                         │ of treatment, permanency       │
  │                         │                                │
  │ Mental Anguish          │ Emotional distress, anxiety,   │
  │                         │ depression, PTSD               │
  │                         │                                │
  │ Loss of Consortium      │ Impact on spousal relationship │
  │                         │                                │
  │ Loss of Enjoyment       │ Inability to participate in    │
  │                         │ life activities                │
  │                         │                                │
  │ Disfigurement/Scarring  │ Visible scarring, disability   │
  │                         │                                │
  │ Permanent Impairment    │ Ongoing functional limitations │
  └──────────────────────────────────────────────────────────┘
```

### 15.2 Injury Valuation Methods

| Method | Description | Usage |
|---|---|---|
| Multiplier Method | General damages = Special damages × multiplier (1.5x - 5x) | Simple claims, soft tissue |
| Per Diem Method | Daily rate × number of days of pain/recovery | Supporting evidence for general damages |
| Colossus/Claims IQ | AI-based valuation using injury codes, treatment, demographics | Large carriers, standardized evaluation |
| Verdict Analysis | Comparable jury verdicts in jurisdiction | Litigated claims, demand evaluation |
| Round Table | Panel of experienced adjusters review and value | Complex/high-value claims |

### 15.3 Injury Severity Scale

```
  INJURY SEVERITY AND TYPICAL VALUE RANGES
  ═════════════════════════════════════════

  MINOR (Soft Tissue, Full Recovery Expected)
  ┌──────────────────────────────────────────────────────────┐
  │ • Cervical/lumbar strain (whiplash)                      │
  │ • Minor contusions and abrasions                         │
  │ • Treatment: 4-12 weeks, chiropractic/PT                │
  │ • Typical specials: $3,000 - $15,000                     │
  │ • Typical general damages: $5,000 - $25,000              │
  │ • Total value range: $8,000 - $40,000                    │
  └──────────────────────────────────────────────────────────┘

  MODERATE (Requires Significant Treatment)
  ┌──────────────────────────────────────────────────────────┐
  │ • Herniated disc (without surgery)                       │
  │ • Fractures (simple, non-surgical)                       │
  │ • Torn ligaments (non-surgical)                          │
  │ • Concussion / mild TBI                                  │
  │ • Treatment: 3-12 months                                 │
  │ • Typical specials: $15,000 - $75,000                    │
  │ • Typical general damages: $25,000 - $150,000            │
  │ • Total value range: $40,000 - $225,000                  │
  └──────────────────────────────────────────────────────────┘

  SEVERE (Surgery / Permanent Impairment)
  ┌──────────────────────────────────────────────────────────┐
  │ • Spinal fusion surgery                                  │
  │ • Joint replacement                                      │
  │ • Compound fractures with surgery                        │
  │ • Moderate TBI                                           │
  │ • Permanent impairment / disability rating               │
  │ • Treatment: 1-3+ years                                  │
  │ • Typical specials: $75,000 - $500,000                   │
  │ • Typical general damages: $150,000 - $1,000,000+       │
  │ • Total value range: $225,000 - $1,500,000+              │
  └──────────────────────────────────────────────────────────┘

  CATASTROPHIC (Life-Altering)
  ┌──────────────────────────────────────────────────────────┐
  │ • Spinal cord injury (paralysis)                         │
  │ • Severe TBI / brain damage                              │
  │ • Amputation                                             │
  │ • Severe burns                                           │
  │ • Wrongful death                                         │
  │ • Treatment: Lifetime care                               │
  │ • Total value: $1,000,000 - $50,000,000+                │
  └──────────────────────────────────────────────────────────┘
```

---

## 16. PIP / No-Fault Processing

### 16.1 No-Fault States and PIP Requirements

| State | PIP Mandatory | PIP Minimum | Covers | Tort Threshold |
|---|---|---|---|---|
| FL | Yes | $10,000 | Med 80%, Lost wages 60% | Verbal (serious injury) |
| MI | Yes | Unlimited medical (pre-reform) | Med, Lost wages, Replacement services | Serious impairment |
| NJ | Yes (choice) | $15,000 | Med, Lost wages | Verbal (lawsuit option) |
| NY | Yes | $50,000 | Med, Lost wages 80%, $25/day other | Serious injury |
| PA | Yes (choice) | $5,000 | Med, Lost wages, Funeral | $75K/serious (limited tort) |
| KY | Yes (choice) | $10,000 | Med, Lost wages 80% | $1,000 medical or serious |
| HI | Yes | $10,000 | Med, Lost wages, Funeral | Serious injury |
| KS | Yes | $4,500 | Med, Rehab, Lost wages | $2,000 medical |
| MA | Yes | $8,000 | Med, Lost wages 75% | $2,000 medical or serious |
| MN | Yes | $20,000 Med / $20,000 LW | Med, Lost wages, Replacement | $4,000 medical or 60-day disability |
| ND | Yes | $30,000 | Med, Lost wages 85%, Funeral | Serious injury |
| UT | Yes | $3,000 | Med, Lost wages 85% | $3,000 medical or serious |

### 16.2 PIP Claim Processing Flow

```
  PIP CLAIM PROCESSING
  ═══════════════════

  Bill Received    Review &          Adjudication     Payment
  ─────────────    Verification      ────────────     ───────
      │                │                  │              │
      │ Medical bill   │                  │              │
      │ (837P/HCFA)    │                  │              │
      │───────────────▶│                  │              │
      │                │                  │              │
      │                │ Verify:          │              │
      │                │ - Provider valid │              │
      │                │ - CPT codes valid│              │
      │                │ - Dates within   │              │
      │                │   coverage period│              │
      │                │ - Not duplicate  │              │
      │                │                  │              │
      │                │ Fee Schedule:    │              │
      │                │ - Apply state    │              │
      │                │   fee schedule   │              │
      │                │   (FL: 200%      │              │
      │                │    Medicare)     │              │
      │                │ - Or UCR check   │              │
      │                │──────────────────▶              │
      │                │                  │              │
      │                │                  │ Determine:   │
      │                │                  │ - Causal     │
      │                │                  │   relation   │
      │                │                  │ - Reasonable │
      │                │                  │ - Necessary  │
      │                │                  │ - Related    │
      │                │                  │──────────────▶
      │                │                  │              │
      │                │                  │              │ Pay per PIP:
      │                │                  │              │ - 80% of med
      │                │                  │              │   (FL)
      │                │                  │              │ - Subject to
      │                │                  │              │   deductible
      │                │                  │              │ - Apply fee
      │                │                  │              │   schedule
```

---

## 17. Medical Bill Review

### 17.1 Medical Bill Review Process

| Step | Action | Tools/Data |
|---|---|---|
| 1. Receipt | Log incoming bill | EDI 837, HCFA 1500, UB-04 |
| 2. Verification | Verify provider, CPT/ICD codes | Provider database, CMS code sets |
| 3. Duplicate Check | Match against prior payments | Claim payment history |
| 4. Fee Schedule | Apply state fee schedule or UCR | State PIP schedules, Medicare RBRVS |
| 5. Reasonableness | Compare to usual and customary | Fair Health, PHCS databases |
| 6. Relatedness | Verify treatment relates to accident | Medical records review, IME |
| 7. Necessity | Assess medical necessity | Clinical guidelines, peer review |
| 8. Adjudication | Approve/reduce/deny | Business rules engine |
| 9. EOB | Generate Explanation of Benefits | Template engine |
| 10. Payment | Issue payment to provider | Payment system |

### 17.2 Fee Schedule Comparison

```
  MEDICAL FEE SCHEDULE APPROACHES
  ═══════════════════════════════

  STATE-MANDATED FEE SCHEDULES (PIP states):
  ┌──────────────────────────────────────────────────────────┐
  │ State │ Fee Schedule Basis               │ % of Medicare │
  │───────│──────────────────────────────────│───────────────│
  │ FL    │ 200% of Medicare (most services) │ 200%          │
  │       │ 80% of charges for hospitals     │               │
  │ NY    │ State-set fee schedule           │ ~180-200%     │
  │ NJ    │ No specific fee schedule         │ UCR based     │
  │ MI    │ No fee schedule (pre-reform)     │ Charges       │
  │ KY    │ No specific fee schedule         │ UCR based     │
  │ MA    │ No specific fee schedule         │ UCR based     │
  │ HI    │ State-set fee schedule           │ ~110%         │
  │ KS    │ No specific fee schedule         │ UCR based     │
  │ MN    │ 85% of provider's UCR            │ Variable      │
  │ UT    │ No specific fee schedule         │ UCR based     │
  └──────────────────────────────────────────────────────────┘
```

---

## 18. Attorney Representation and Litigation

### 18.1 Attorney Representation Handling

```
  ATTORNEY REPRESENTATION WORKFLOW
  ═══════════════════════════════

  Notice of            Redirect All        Demand           Settlement /
  Representation       Communication       Received         Litigation
  ──────────────       ──────────────      ────────         ──────────
      │                    │                  │                │
      │ Attorney letter    │                  │                │
      │ of representation  │                  │                │
      │───────────────────▶│                  │                │
      │                    │                  │                │
      │                    │ STOP direct      │                │
      │                    │ contact with     │                │
      │                    │ claimant         │                │
      │                    │                  │                │
      │                    │ All comms go     │                │
      │                    │ through attorney │                │
      │                    │─────────────────▶│                │
      │                    │                  │                │
      │                    │                  │ Demand package:│
      │                    │                  │ - Med records  │
      │                    │                  │ - Med bills    │
      │                    │                  │ - Lost wages   │
      │                    │                  │ - Demand amount│
      │                    │                  │───────────────▶│
      │                    │                  │                │
      │                    │                  │                │ Evaluate:
      │                    │                  │                │ - Verify
      │                    │                  │                │   specials
      │                    │                  │                │ - Value
      │                    │                  │                │   claim
      │                    │                  │                │ - Counter
      │                    │                  │                │   offer
      │                    │                  │                │ - Negotiate
      │                    │                  │                │ - Settle or
      │                    │                  │                │   litigate
```

### 18.2 Litigation Management

| Phase | Duration | Key Activities | Defense Costs (Typical) |
|---|---|---|---|
| Pre-Suit | 6-18 months | Demand, negotiation | $0 - $5,000 |
| Filing/Answer | 1-3 months | Complaint, answer, initial disclosures | $5,000 - $15,000 |
| Discovery | 6-18 months | Interrogatories, depositions, IME | $15,000 - $75,000 |
| Mediation | 1 day - 1 month | Mediation conference, settlement attempt | $5,000 - $15,000 |
| Trial Prep | 2-6 months | Motions, expert reports, trial prep | $25,000 - $100,000 |
| Trial | 3-10 days | Jury selection, testimony, verdict | $50,000 - $250,000+ |
| Appeal | 6-24 months | Brief writing, oral argument | $25,000 - $100,000+ |

---

## 19. UM/UIM Claim Processing

### 19.1 UM/UIM Coverage Trigger Conditions

```
  UM/UIM COVERAGE ANALYSIS
  ════════════════════════

  UNINSURED MOTORIST (UM):
  Triggers when at-fault driver:
  ├── Has no auto insurance at all
  ├── Has insurance that was cancelled before the accident
  ├── Is a hit-and-run driver (in most states, contact required)
  └── Has insurance company that is insolvent

  UNDERINSURED MOTORIST (UIM):
  Triggers when at-fault driver has insurance but:
  ├── Their limits are less than insured's damages (most states)
  └── Their limits are less than insured's UIM limits (some states)

  UIM CALCULATION METHODS:
  ┌──────────────────────────────────────────────────────────┐
  │ "OFFSET" METHOD (most states):                           │
  │ UIM Payment = MIN(UIM Limit, Damages) - TP Insurance    │
  │                                                           │
  │ Example:                                                  │
  │ Damages: $200,000                                        │
  │ TP BI Limits: $50,000                                    │
  │ Insured's UIM: $100,000                                  │
  │ UIM Payment = MIN($100K, $200K) - $50K = $50,000        │
  └──────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────────┐
  │ "ADD-ON" / "EXCESS" METHOD (fewer states):               │
  │ UIM Payment = MIN(UIM Limit, Damages - TP Insurance)     │
  │                                                           │
  │ Example (same facts):                                     │
  │ UIM Payment = MIN($100K, $200K - $50K) = $100,000       │
  └──────────────────────────────────────────────────────────┘
```

---

## 20. Glass Claims

### 20.1 Glass Claim Workflow

```
  GLASS CLAIM PROCESSING
  ═══════════════════════

  Report           Vendor           Repair /         Close
  ──────           Assignment       Replace          ─────
     │                │                │               │
     │ Customer       │                │               │
     │ reports glass  │                │               │
     │ damage         │                │               │
     │───────────────▶│                │               │
     │                │                │               │
     │                │ Route to glass │               │
     │                │ network vendor │               │
     │                │ (Safelite,     │               │
     │                │  Glass America,│               │
     │                │  Caliber,etc.) │               │
     │                │───────────────▶│               │
     │                │                │               │
     │                │                │ Repair if:    │
     │                │                │ - Chip < $1   │
     │                │                │ - Not in      │
     │                │                │   driver view │
     │                │                │ - No cracks   │
     │                │                │               │
     │                │                │ Replace if:   │
     │                │                │ - Crack       │
     │                │                │ - Large chip  │
     │                │                │ - Multiple dmg│
     │                │                │ - Edge damage │
     │                │                │               │
     │                │                │ ADAS Calibrate│
     │                │                │ if camera     │
     │                │                │ mounted on    │
     │                │                │ windshield    │
     │                │                │───────────────▶
     │                │                │               │
     │                │                │               │ Close
     │                │                │               │ file
```

### 20.2 ADAS Calibration After Glass Replacement

| Vehicle Feature | Calibration Required | Type | Approximate Cost |
|---|---|---|---|
| Forward camera (windshield) | Yes | Static or Dynamic | $150 - $600 |
| Rain sensor | Yes (reconnect) | Included in replacement | Included |
| Head-up display | Yes (recalibrate) | Static | $100 - $300 |
| Lane departure | Yes (if camera-based) | Dynamic | $100 - $400 |
| Auto high beam | Yes (if camera-based) | Dynamic | $100 - $300 |
| No ADAS features | No | N/A | N/A |

---

## 21. Telematics and Connected Cars

### 21.1 Telematics Data in Claims

```
  TELEMATICS DATA CATEGORIES FOR CLAIMS
  ═════════════════════════════════════

  CRASH DETECTION DATA:
  ┌──────────────────────────────────────────────────────────┐
  │ • Accelerometer data (G-force at impact)                 │
  │ • Impact direction and severity                          │
  │ • Airbag deployment signal                               │
  │ • GPS coordinates at time of impact                      │
  │ • Speed at impact                                        │
  │ • Pre-impact speed profile (5 seconds before)            │
  │ • Braking before impact (ABS activation)                 │
  │ • Steering input before impact                           │
  │ • Vehicle orientation (yaw, pitch, roll)                 │
  │ • Post-crash vehicle status                              │
  └──────────────────────────────────────────────────────────┘

  DRIVING BEHAVIOR DATA:
  ┌──────────────────────────────────────────────────────────┐
  │ • Speed vs speed limit                                   │
  │ • Hard braking events                                    │
  │ • Hard acceleration events                               │
  │ • Cornering G-force                                      │
  │ • Phone distraction (if detected)                        │
  │ • Time of day driving                                    │
  │ • Route and trip history                                 │
  │ • Total miles driven                                     │
  └──────────────────────────────────────────────────────────┘

  VEHICLE DIAGNOSTIC DATA:
  ┌──────────────────────────────────────────────────────────┐
  │ • OBD-II diagnostic trouble codes (DTCs)                 │
  │ • Engine status                                          │
  │ • Battery voltage                                        │
  │ • Tire pressure (TPMS)                                   │
  │ • Fluid levels                                           │
  │ • Mileage/odometer                                       │
  └──────────────────────────────────────────────────────────┘
```

### 21.2 Telematics-Enabled Claims Process

| Stage | Telematics Benefit | Data Used |
|---|---|---|
| FNOL | Automatic crash notification (ACN) → proactive FNOL | G-force, GPS, airbag |
| Triage | Severity assessment from impact data | G-force, speed, direction |
| Liability | Speed, braking, and driving data as evidence | Speed, brake, GPS |
| Fraud Detection | Verify accident circumstances vs claim | GPS, speed, route history |
| Estimation | Pre-assess damage severity | Impact force, direction |
| Total Loss | Mileage verification | Odometer reading |
| Subrogation | Evidence for fault determination | Speed, braking, GPS |

---

## 22. ADAS and Autonomous Vehicles

### 22.1 ADAS Impact on Claims

```
  ADAS FEATURES AND CLAIMS IMPLICATIONS
  ═════════════════════════════════════

  FEATURE                    CLAIMS IMPACT
  ───────                    ─────────────
  Automatic Emergency        • Reduced rear-end frequency
  Braking (AEB)              • May increase repair cost (sensors)

  Lane Departure             • Reduced single-vehicle accidents
  Warning/Assist             • Sensor recalibration after repair

  Adaptive Cruise            • Reduced rear-end frequency
  Control                    • Complex liability if malfunction

  Blind Spot                 • Reduced lane-change accidents
  Detection                  • Sensor in mirrors/bumpers

  Parking Assist /           • Reduced parking lot claims
  Auto Park                  • Liability questions

  Forward Collision          • Reduced overall severity
  Warning                    • Camera/radar recalibration

  Backup Camera              • Reduced backing accidents
  (mandatory since 2018)     • Camera replacement cost

  SENSOR COSTS:
  ┌──────────────────────────────────────────────────────────┐
  │ Sensor Type          │ Typical Replacement Cost          │
  │──────────────────────│──────────────────────────────────│
  │ Front radar          │ $500 - $2,000                    │
  │ Front camera         │ $300 - $1,500                    │
  │ Side radar           │ $300 - $1,000 per side           │
  │ Rear camera          │ $200 - $800                      │
  │ Ultrasonic sensors   │ $100 - $400 per sensor           │
  │ LiDAR (if equipped)  │ $1,000 - $10,000+               │
  │ Calibration (static) │ $200 - $600                      │
  │ Calibration (dynamic)│ $100 - $400                      │
  └──────────────────────────────────────────────────────────┘
```

---

## 23. Rideshare / TNC Claims

### 23.1 Rideshare Coverage Periods

```
  RIDESHARE COVERAGE PERIODS
  ═══════════════════════════

  Period 0: App OFF
  ┌──────────────────────────────────────────────────────────┐
  │ Personal auto policy applies (no rideshare activity)     │
  └──────────────────────────────────────────────────────────┘

  Period 1: App ON, waiting for ride request
  ┌──────────────────────────────────────────────────────────┐
  │ TNC provides contingent liability coverage:              │
  │ • $50,000 BI per person                                  │
  │ • $100,000 BI per accident                               │
  │ • $25,000 PD per accident                                │
  │ Personal policy may have exclusion ("TNC exclusion")     │
  │ Rideshare endorsement fills gap                          │
  └──────────────────────────────────────────────────────────┘

  Period 2: Ride accepted, en route to passenger
  ┌──────────────────────────────────────────────────────────┐
  │ TNC provides primary coverage:                           │
  │ • $1,000,000 combined single limit (BI + PD)            │
  │ • Contingent comprehensive/collision ($2,500 deductible) │
  │ Personal policy usually excluded                         │
  └──────────────────────────────────────────────────────────┘

  Period 3: Passenger in vehicle, during trip
  ┌──────────────────────────────────────────────────────────┐
  │ TNC provides primary coverage:                           │
  │ • $1,000,000 combined single limit (BI + PD)            │
  │ • Contingent comprehensive/collision ($2,500 deductible) │
  │ • UM/UIM coverage                                        │
  │ Personal policy usually excluded                         │
  └──────────────────────────────────────────────────────────┘
```

---

## 24. Fleet / Commercial Auto

### 24.1 Commercial Auto Claim Differences

| Aspect | Personal Auto | Commercial Auto |
|---|---|---|
| Policy Structure | Personal Auto Policy (PAP) | Business Auto Policy (BAP) |
| Covered Vehicles | Scheduled vehicles | Symbol-based (any auto, owned, hired, non-owned) |
| Limits | Typically split limits | Often CSL (Combined Single Limit) |
| Regulatory | State minimum | DOT/FMCSA for trucking |
| Driver | Named insured + household | Any authorized employee/driver |
| Medical | PIP/MedPay | Workers Comp (if employee) |
| Subrogation | Against other party | May involve inter-company/inter-fleet |
| Reporting | Standard | DOT recordable, OSHA if injury |
| Fleet Discounts | N/A | Fleet safety programs, experience mods |

### 24.2 DOT/FMCSA Requirements for Commercial Vehicle Claims

```
  FMCSA CLAIMS REQUIREMENTS (Interstate Trucking)
  ═══════════════════════════════════════════════

  Minimum Insurance Requirements:
  ┌──────────────────────────────────────────────────────────┐
  │ Vehicle Type                │ Minimum BI/PD Liability    │
  │─────────────────────────────│────────────────────────────│
  │ For-hire (general freight)  │ $750,000 CSL               │
  │ For-hire (household goods)  │ $750,000 CSL               │
  │ For-hire (passengers, ≤15)  │ $1,500,000 CSL             │
  │ For-hire (passengers, >15)  │ $5,000,000 CSL             │
  │ Hazmat carriers             │ $1,000,000 - $5,000,000    │
  │ Private carriers            │ $750,000 (if hazmat)       │
  └──────────────────────────────────────────────────────────┘

  Crash Reporting Thresholds:
  • Fatality
  • Injury requiring immediate medical treatment away from scene
  • Disabling damage requiring tow-away
  → Must file within 30 days to FMCSA
```

---

## 25. Auto Claims Data Model

### 25.1 Entity Relationship Diagram

```
  AUTO CLAIMS DATA MODEL (ERD)
  ═══════════════════════════

  ┌──────────────┐        ┌──────────────┐
  │    CLAIM     │        │   POLICY     │
  │──────────────│ 1    1 │──────────────│
  │ claimId (PK) │────────│ policyId(PK) │
  │ claimNumber  │        │ policyNumber │
  │ status       │        │ effectiveDate│
  │ lossDate     │        │ expirationDt │
  │ reportDate   │        │ policyType   │
  │ lossState    │        │ insuredId    │
  │ lossCause    │        └──────────────┘
  │ catCode      │
  └──────┬───────┘
         │
         │ 1:N
         │
  ┌──────▼───────┐        ┌──────────────┐
  │   VEHICLE    │        │   DRIVER     │
  │──────────────│ 1    1 │──────────────│
  │ vehicleId(PK)│────────│ driverId(PK) │
  │ claimId (FK) │        │ vehicleId(FK)│
  │ vin          │        │ firstName    │
  │ year         │        │ lastName     │
  │ make         │        │ dob          │
  │ model        │        │ licenseNum   │
  │ trim         │        │ licenseState │
  │ color        │        │ faultPercent │
  │ mileage      │        │ injured      │
  │ driveable    │        └──────────────┘
  │ currentLoc   │
  │ damageArea   │        ┌──────────────┐
  │ damageSev    │ 1    N │  PASSENGER   │
  │ acv          │────────│──────────────│
  │ totalLoss    │        │ passengerId  │
  └──────┬───────┘        │ vehicleId(FK)│
         │                │ name         │
         │ 1:N            │ seatPosition │
         │                │ injured      │
  ┌──────▼───────┐        │ injuryDesc   │
  │  ESTIMATE    │        └──────────────┘
  │──────────────│
  │ estimateId   │        ┌──────────────┐
  │ vehicleId(FK)│        │   INJURY     │
  │ vendorSource │ 1    N │──────────────│
  │ estimateDate │────────│ injuryId(PK) │
  │ estimateType │        │ personId(FK) │
  │ laborTotal   │        │ bodyPart     │
  │ partsTotal   │        │ injuryType   │
  │ paintTotal   │        │ severity     │
  │ miscTotal    │        │ treatment    │
  │ grossTotal   │        │ provider     │
  │ netTotal     │        │ medExpense   │
  │ lineItems[]  │        │ lostWages    │
  └──────────────┘        └──────────────┘

  ┌──────────────┐        ┌──────────────┐
  │ REPAIR_SHOP  │        │  RENTAL_CAR  │
  │──────────────│        │──────────────│
  │ shopId (PK)  │        │ rentalId(PK) │
  │ shopName     │        │ claimId (FK) │
  │ isDRP        │        │ vendorName   │
  │ address      │        │ vehicleClass │
  │ certifications│       │ startDate    │
  │ rating       │        │ endDate      │
  └──────────────┘        │ dailyRate    │
                          │ totalCost    │
  ┌──────────────┐        └──────────────┘
  │ TOTAL_LOSS   │
  │──────────────│        ┌──────────────┐
  │ totalLossId  │        │SALVAGE_VEHICLE│
  │ vehicleId(FK)│ 1    1 │──────────────│
  │ acv          │────────│ salvageId(PK)│
  │ deductible   │        │ totalLossId  │
  │ netSettlement│        │ auctionCo    │
  │ lienPayoff   │        │ titleBrand   │
  │ lienHolder   │        │ salvageValue │
  │ gapAmount    │        │ saleDate     │
  │ comparables[]│        │ salePrice    │
  └──────────────┘        └──────────────┘
```

---

## 26. Integration Architecture

### 26.1 Auto Claims Integration Ecosystem

```
  AUTO CLAIMS INTEGRATION MAP
  ═══════════════════════════

  ┌──────────────────────────────────────────────────────────────┐
  │                    CLAIMS CORE SYSTEM                         │
  │                                                               │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
  │  │  FNOL    │  │Coverage  │  │ Payment  │  │Subrogation│   │
  │  │ Module   │  │ Module   │  │ Module   │  │ Module    │   │
  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
  │       │              │              │              │         │
  └───────┼──────────────┼──────────────┼──────────────┼─────────┘
          │              │              │              │
     ┌────▼────────────┐ │              │              │
     │ ESTIMATICS      │ │              │              │
     │ ┌─────────┐     │ │              │              │
     │ │ CCC ONE │     │ │              │              │
     │ └─────────┘     │ │              │              │
     │ ┌─────────┐     │ │              │              │
     │ │ Mitchell│     │ │              │              │
     │ └─────────┘     │ │              │              │
     │ ┌─────────┐     │ │              │              │
     │ │ Audatex │     │ │         ┌────▼──────────┐  │
     │ └─────────┘     │ │         │ PAYMENT       │  │
     └────────────────┘ │         │ PROCESSORS    │  │
                         │         │ ┌───────────┐ │  │
     ┌────────────────┐ │         │ │ Bank/ACH  │ │  │
     │ SALVAGE        │ │         │ └───────────┘ │  │
     │ ┌─────────┐   │ │         │ ┌───────────┐ │  │
     │ │ Copart  │   │ │         │ │ VirtualCard│ │  │
     │ └─────────┘   │ │         │ └───────────┘ │  │
     │ ┌─────────┐   │ │         └───────────────┘  │
     │ │ IAA     │   │ │                             │
     │ └─────────┘   │ │                             │
     └────────────────┘ │         ┌─────────────────┐│
                         │         │ RENTAL          ││
     ┌────────────────┐ │         │ ┌─────────────┐ ││
     │ GLASS NETWORK  │ │         │ │ Enterprise  │ ││
     │ ┌─────────┐   │ │         │ └─────────────┘ ││
     │ │Safelite │   │ │         │ ┌─────────────┐ ││
     │ └─────────┘   │ │         │ │ Hertz       │ ││
     └────────────────┘ │         │ └─────────────┘ ││
                         │         └─────────────────┘│
     ┌────────────────┐ │                             │
     │ DATA PROVIDERS │ │                             │
     │ ┌───────────┐  │ │                             │
     │ │ISO ClmSrch│  │ │                             │
     │ └───────────┘  │ │                             │
     │ ┌───────────┐  │ │         ┌─────────────────┐│
     │ │ LexisNexis│  │ │         │ TELEMATICS      ││
     │ └───────────┘  │ │         │ ┌─────────────┐ ││
     │ ┌───────────┐  │ │         │ │ OEM Data    │ ││
     │ │ CLUE      │  │ │         │ └─────────────┘ ││
     │ └───────────┘  │ │         │ ┌─────────────┐ ││
     │ ┌───────────┐  │ │         │ │ UBI Device  │ ││
     │ │ MVR       │  │ │         │ └─────────────┘ ││
     │ └───────────┘  │ │         └─────────────────┘│
     └────────────────┘ │                             │
                         │                             │
  ───────────────────────┴─────────────────────────────┘
```

---

## 27. Auto Claims Performance Metrics

### 27.1 Key Performance Indicators

| Metric | Definition | Target | Industry Benchmark |
|---|---|---|---|
| Cycle Time (Repairable) | FNOL to vehicle returned | < 15 days | 12-18 days |
| Cycle Time (Total Loss) | FNOL to settlement paid | < 20 days | 18-25 days |
| Customer Satisfaction | NPS or CSAT score | > 80% | 75-85% |
| Estimate Accuracy | % of initial estimates within 10% of final | > 75% | 65-80% |
| Supplement Ratio | % of estimates requiring supplement | < 30% | 25-40% |
| Severity (Avg Paid) | Average paid per claim (physical damage) | Trending | $4,000-$6,000 |
| Loss Ratio | Incurred losses / Earned premium | < 65% | 60-70% |
| Expense Ratio | Claims expenses / Earned premium | < 12% | 10-15% |
| Subrogation Recovery Rate | Recoveries / Paid losses (recoverable) | > 35% | 30-40% |
| Total Loss Rate | % of PD claims declared total loss | 15-25% | 19-22% |
| Touch Count | Avg number of adjuster touches per claim | < 8 | 6-12 |
| DRP Utilization | % of repairs through DRP shops | > 60% | 50-70% |
| Rental Duration (Repair) | Avg rental days for repairable vehicle | < 12 days | 10-15 days |
| First Contact Resolution | % resolved in single contact | > 25% | 20-30% |
| Litigation Rate (BI) | % of BI claims entering litigation | < 15% | 10-20% |
| Average BI Severity | Average paid per BI claim | Trending | $18,000-$25,000 |
| PIP Leakage | Overpayment on PIP claims | < 5% | 3-8% |

### 27.2 Performance Dashboard Metrics

```
  AUTO CLAIMS PERFORMANCE DASHBOARD
  ═══════════════════════════════════

  ┌─────────────────────────────────────────────────────────────┐
  │                  CURRENT MONTH: March 2025                   │
  │                                                              │
  │  VOLUME              CYCLE TIME           FINANCIAL          │
  │  ┌─────────────┐    ┌─────────────┐     ┌─────────────┐   │
  │  │ New Claims  │    │ Repair Avg  │     │ Loss Ratio  │   │
  │  │ 2,450       │    │ 13.2 days   │     │ 63.5%       │   │
  │  │ [↑ 5% MoM] │    │ [↓ 0.8 days]│     │ [↓ 1.2 pts] │   │
  │  └─────────────┘    └─────────────┘     └─────────────┘   │
  │                                                              │
  │  ┌─────────────┐    ┌─────────────┐     ┌─────────────┐   │
  │  │ Open Claims │    │ TL Avg      │     │ Avg Severity│   │
  │  │ 4,890       │    │ 18.5 days   │     │ $5,230      │   │
  │  │ [↑ 2%]     │    │ [↓ 1.2 days]│     │ [↑ 3.2%]   │   │
  │  └─────────────┘    └─────────────┘     └─────────────┘   │
  │                                                              │
  │  ┌─────────────┐    ┌─────────────┐     ┌─────────────┐   │
  │  │ Closed      │    │ BI Avg      │     │ Subro Rate  │   │
  │  │ 2,280       │    │ 245 days    │     │ 37.2%       │   │
  │  │ [↑ 8%]     │    │ [↓ 12 days] │     │ [↑ 2.1 pts] │   │
  │  └─────────────┘    └─────────────┘     └─────────────┘   │
  └─────────────────────────────────────────────────────────────┘
```

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 14 (Property Claims), Article 5 (Fraud Detection), and Article 11 (Integration Patterns).*
