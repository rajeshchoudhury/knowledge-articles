# P&C Claims Workflows — Detailed Process Diagrams

> Visual reference for every major claims workflow, sub-process, and decision tree. Each diagram shows actors, decision gates, system interactions, and exception paths.

---

## Table of Contents

1. [Master Claims Lifecycle](#1-master-claims-lifecycle)
2. [FNOL Intake — Multi-Channel](#2-fnol-intake--multi-channel)
3. [FNOL Data Capture — Detailed Fields](#3-fnol-data-capture--detailed-fields)
4. [Triage & Segmentation Engine](#4-triage--segmentation-engine)
5. [Assignment & Workload Balancing](#5-assignment--workload-balancing)
6. [Coverage Verification](#6-coverage-verification)
7. [Auto Physical Damage — Full Workflow](#7-auto-physical-damage--full-workflow)
8. [Auto Bodily Injury — Full Workflow](#8-auto-bodily-injury--full-workflow)
9. [Homeowners Property Claim — Full Workflow](#9-homeowners-property-claim--full-workflow)
10. [Workers' Compensation — Full Workflow](#10-workers-compensation--full-workflow)
11. [Commercial General Liability — Full Workflow](#11-commercial-general-liability--full-workflow)
12. [Reserving Process](#12-reserving-process)
13. [Payment & Disbursement](#13-payment--disbursement)
14. [Subrogation & Recovery](#14-subrogation--recovery)
15. [Fraud Detection (SIU) Pipeline](#15-fraud-detection-siu-pipeline)
16. [Litigation Management](#16-litigation-management)
17. [Catastrophe (CAT) Operations](#17-catastrophe-cat-operations)
18. [Total Loss — Vehicle](#18-total-loss--vehicle)
19. [Straight-Through Processing (STP)](#19-straight-through-processing-stp)
20. [Vendor Management Lifecycle](#20-vendor-management-lifecycle)
21. [Document & Correspondence Flow](#21-document--correspondence-flow)
22. [Reinsurance Notification & Recovery](#22-reinsurance-notification--recovery)
23. [Claim Closure & Reopen](#23-claim-closure--reopen)
24. [Regulatory Compliance — Diary & Deadlines](#24-regulatory-compliance--diary--deadlines)
25. [Data Flow — End to End System Integration](#25-data-flow--end-to-end-system-integration)
26. [AI/ML Pipeline in Claims](#26-aiml-pipeline-in-claims)
27. [Cyber Liability Claim — Incident Response](#27-cyber-liability-claim--incident-response)
28. [Medicare Section 111 Reporting](#28-medicare-section-111-reporting)

---

## 1. Master Claims Lifecycle

```
                            ╔═══════════════════════════════════════════════════════════════╗
                            ║              MASTER CLAIMS LIFECYCLE                          ║
                            ╚═══════════════════════════════════════════════════════════════╝

     ┌─────────┐      ┌─────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐
     │  LOSS   │      │  FNOL   │      │ TRIAGE & │      │ COVERAGE │      │ INVESTI- │
     │  EVENT  │─────▶│ INTAKE  │─────▶│ ASSIGN   │─────▶│ ANALYSIS │─────▶│ GATION   │
     │         │      │         │      │          │      │          │      │          │
     └─────────┘      └────┬────┘      └──────────┘      └────┬─────┘      └────┬─────┘
                           │                                   │                 │
                    ┌──────▼──────┐                    ┌───────▼──────┐   ┌──────▼───────┐
                    │ Channels:   │                    │  Covered?    │   │  Gather:     │
                    │ • Phone     │                    │  ┌───┐ ┌───┐│   │  • Statements│
                    │ • Web       │                    │  │YES│ │NO ││   │  • Reports   │
                    │ • Mobile    │                    │  └─┬─┘ └─┬─┘│   │  • Photos    │
                    │ • Agent     │                    │    │     │   │   │  • Experts   │
                    │ • IoT/Auto  │                    │    ▼     ▼   │   │  • Inspectns │
                    │ • Chat      │                    │ Proceed Deny │   └──────┬───────┘
                    └─────────────┘                    │         + ROR│          │
                                                      └──────────────┘          │
                                                                                │
     ┌─────────┐      ┌─────────┐      ┌──────────┐      ┌──────────┐   ┌──────▼──────┐
     │  CLOSE  │      │RECOVERY │      │ PAYMENT  │      │ SETTLE-  │   │  RESERVE &  │
     │         │◀─────│ & SUBRO │◀─────│          │◀─────│  MENT    │◀──│  EVALUATE   │
     │         │      │         │      │          │      │          │   │             │
     └────┬────┘      └─────────┘      └──────────┘      └──────────┘   └─────────────┘
          │
          │   ┌──────────────────────────────────────────────────────────┐
          │   │ PARALLEL PROCESSES (active throughout lifecycle):        │
          │   │                                                         │
          │   │  ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌──────────┐ │
          │   │  │  FRAUD  │  │ LITIGA- │  │ DIARY &  │  │REINSUR-  │ │
          │   │  │ SCORING │  │  TION   │  │COMPLIANCE│  │  ANCE    │ │
          │   │  │  (SIU)  │  │  MGMT   │  │ TRACKING │  │ NOTIFIC. │ │
          │   │  └─────────┘  └─────────┘  └──────────┘  └──────────┘ │
          │   └──────────────────────────────────────────────────────────┘
          │
          ▼
     ┌─────────┐
     │ REOPEN? │──── YES ──▶ Returns to INVESTIGATION stage
     │         │
     └────┬────┘
          │ NO
          ▼
      [FINAL CLOSE]
```

---

## 2. FNOL Intake — Multi-Channel

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                        FNOL INTAKE — MULTI-CHANNEL FLOW                        ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────────────────── INTAKE CHANNELS ────────────────────────────────┐
  │                                                                                     │
  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────────┐ │
  │  │  PHONE   │ │   WEB    │ │  MOBILE  │ │  AGENT   │ │  EMAIL/  │ │ IoT / TELE- │ │
  │  │  (IVR +  │ │  PORTAL  │ │   APP    │ │ REPORTED │ │   FAX    │ │  MATICS     │ │
  │  │  Agent)  │ │          │ │          │ │          │ │          │ │ AUTO-FNOL   │ │
  │  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └──────┬──────┘ │
  │       │            │            │            │            │               │        │
  │       │     ┌──────┘    ┌───────┘     ┌──────┘     ┌──────┘        ┌──────┘        │
  └───────┼─────┼───────────┼─────────────┼────────────┼───────────────┼────────────────┘
          │     │           │             │            │               │
          ▼     ▼           ▼             ▼            ▼               ▼
      ┌─────────────────────────────────────────────────────────────────────┐
      │                       API GATEWAY / ESB                             │
      │            (Message normalization to ACORD format)                  │
      └──────────────────────────────┬──────────────────────────────────────┘
                                     │
                                     ▼
      ┌─────────────────────────────────────────────────────────────────────┐
      │                    FNOL ORCHESTRATION SERVICE                       │
      │                                                                     │
      │  ┌─────────────┐  ┌──────────────┐  ┌───────────────────────────┐  │
      │  │ 1. VALIDATE │  │ 2. ENRICH    │  │ 3. DUPLICATE CHECK        │  │
      │  │    INPUT     │  │    DATA      │  │    (ClaimSearch + internal│  │
      │  │              │  │              │  │     matching)             │  │
      │  │ • Required   │  │ • VIN decode │  │                           │  │
      │  │   fields     │  │ • Address    │  │ ┌──────┐    ┌──────────┐ │  │
      │  │ • Format     │  │   validate   │  │ │ DUP  │    │ NEW CLAIM│ │  │
      │  │   checks     │  │ • Policy     │  │ │FOUND │    │          │ │  │
      │  │ • Policy#    │  │   lookup     │  │ └──┬───┘    └────┬─────┘ │  │
      │  │   verify     │  │ • Weather    │  │    │             │       │  │
      │  └──────────────┘  │   data       │  │    ▼             ▼       │  │
      │                    │ • Geocode    │  │  Link to       Proceed   │  │
      │                    └──────────────┘  │  existing                │  │
      │                                      └───────────────────────────┘  │
      └──────────────────────────────┬──────────────────────────────────────┘
                                     │
                                     ▼
      ┌─────────────────────────────────────────────────────────────────────┐
      │                    CLAIMS SYSTEM (ClaimCenter)                      │
      │                                                                     │
      │  ┌──────────────────────────────────────────────────────────────┐   │
      │  │                    CLAIM CREATED                              │   │
      │  │                                                              │   │
      │  │  Claim# ──▶ Generated (format: CLM-2026-XXXXXXX)           │   │
      │  │  Status ──▶ "Open - New"                                    │   │
      │  │  LOB    ──▶ Auto / Home / WC / GL / etc.                    │   │
      │  │                                                              │   │
      │  └──────────────────────────────────────────────────────────────┘   │
      │                          │                                          │
      │           ┌──────────────┼──────────────┐                          │
      │           ▼              ▼              ▼                          │
      │  ┌──────────────┐ ┌───────────┐ ┌──────────────┐                  │
      │  │ FRAUD SCORE  │ │  TRIAGE   │ │ ACKNOWLEDGE  │                  │
      │  │ (async)      │ │  SCORE    │ │ LETTER/EMAIL │                  │
      │  │              │ │ (segment) │ │ (auto-gen)   │                  │
      │  └──────────────┘ └───────────┘ └──────────────┘                  │
      └─────────────────────────────────────────────────────────────────────┘
```

---

## 3. FNOL Data Capture — Detailed Fields

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                        FNOL DATA MODEL — FIELD MAP                             ║
╚══════════════════════════════════════════════════════════════════════════════════╝

┌────────────────────────── CLAIM HEADER ──────────────────────────┐
│                                                                   │
│  ClaimNumber ............. System-generated unique ID              │
│  PolicyNumber ............ Linked to Policy Admin System          │
│  LossDate ................ Date the loss occurred (YYYY-MM-DD)    │
│  LossTime ................ Time of loss (HH:MM, 24hr)             │
│  ReportedDate ............ Date FNOL received                     │
│  ReportedByType .......... [Insured|Agent|ThirdParty|Attorney]    │
│  LossDescription ......... Free-text narrative (max 4000 chars)   │
│  CauseOfLossCd ........... ACORD/ISO standard code                │
│  LOBCode ................. [PersonalAuto|Homeowners|WC|GL|...]    │
│  CatastropheCode ......... PCS serial # (if applicable)          │
│  JurisdictionState ....... Two-letter state code                  │
│                                                                   │
│  ┌──────────────── LOSS LOCATION ──────────────────┐             │
│  │  Street ............ 123 Main St                 │             │
│  │  City .............. Springfield                  │             │
│  │  State ............. IL                           │             │
│  │  ZIP ............... 62701                        │             │
│  │  County ............ Sangamon                     │             │
│  │  Latitude .......... 39.7817                      │             │
│  │  Longitude ......... -89.6501                     │             │
│  │  LocationType ....... [AtInsuredPremises|Roadway|  │             │
│  │                        ThirdPartyPremises|Other]   │             │
│  └────────────────────────────────────────────────────┘             │
└───────────────────────────────────────────────────────────────────────┘

┌────────────────────── INSURED / CLAIMANT(S) ─────────────────────┐
│                                                                   │
│  For EACH party:                                                  │
│  ┌────────────────────────────────────────────────────────┐      │
│  │  PartyRole ......... [NamedInsured|Claimant|Witness|   │      │
│  │                       Passenger|Pedestrian|OtherDriver] │      │
│  │  FirstName ......... John                               │      │
│  │  LastName .......... Smith                              │      │
│  │  DOB ............... 1985-03-15                         │      │
│  │  SSN (masked) ...... XXX-XX-1234                       │      │
│  │  Phone ............. 217-555-0123                       │      │
│  │  Email ............. jsmith@email.com                   │      │
│  │  Address ........... [Full address block]               │      │
│  │  AtRepresented ..... [Yes|No]                          │      │
│  │  AttorneyName ...... (if represented)                   │      │
│  │  AttorneyFirm ...... (if represented)                   │      │
│  └────────────────────────────────────────────────────────┘      │
└───────────────────────────────────────────────────────────────────────┘

┌────────────────────── VEHICLE INFO (Auto) ───────────────────────┐
│                                                                   │
│  For EACH vehicle involved:                                       │
│  ┌────────────────────────────────────────────────────────┐      │
│  │  VIN ............... 1HGBH41JXMN109186                 │      │
│  │  Year .............. 2024                               │      │
│  │  Make .............. Honda                              │      │
│  │  Model ............. Accord                             │      │
│  │  Color ............. Silver                             │      │
│  │  Mileage ........... 34,500                             │      │
│  │  PointOfImpact ..... [Front|Rear|LeftSide|RightSide|   │      │
│  │                       Rollover|Undercarriage|Multiple]  │      │
│  │  Driveable ......... [Yes|No]                          │      │
│  │  AirbagsDeployed ... [Yes|No|Unknown]                  │      │
│  │  VehicleLocation ... [Address or body shop name]        │      │
│  │  OwnerSameAsDriver . [Yes|No]                          │      │
│  │  LienholderName .... (if financed/leased)              │      │
│  └────────────────────────────────────────────────────────┘      │
└───────────────────────────────────────────────────────────────────────┘

┌────────────────────── INJURY INFO ───────────────────────────────┐
│                                                                   │
│  For EACH injured party:                                          │
│  ┌────────────────────────────────────────────────────────┐      │
│  │  InjuredPartyRef ... Link to ClaimParty record          │      │
│  │  BodyPartCode ...... ICD-10 (e.g., S13.4 — Cervical    │      │
│  │                      sprain)                            │      │
│  │  InjuryNature ...... [Strain|Fracture|Laceration|       │      │
│  │                       Concussion|Burn|Internal|Other]   │      │
│  │  InjurySeverity .... [Minor|Moderate|Severe|Critical|   │      │
│  │                       Fatal]                            │      │
│  │  TransportedToER ... [Yes|No]                          │      │
│  │  Hospitalized ...... [Yes|No]                          │      │
│  │  HospitalName ...... Memorial Medical Center            │      │
│  │  TreatingPhysician . Dr. Jane Wilson                   │      │
│  │  LostTimeFromWork .. [Yes|No]                          │      │
│  │  PreExistingCond ... [Yes|No|Unknown]                  │      │
│  └────────────────────────────────────────────────────────┘      │
└───────────────────────────────────────────────────────────────────────┘

┌────────────────────── PROPERTY INFO (Homeowners) ────────────────┐
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐      │
│  │  DwellingType ...... [SingleFamily|Condo|Townhouse|     │      │
│  │                       Mobile|Multi-Family]              │      │
│  │  Construction ...... [Frame|Masonry|Steel|Mixed]        │      │
│  │  YearBuilt ......... 1998                               │      │
│  │  RoofType .......... [Asphalt|Tile|Metal|Flat|Slate]   │      │
│  │  SquareFootage ..... 2,400                              │      │
│  │  DamageAreas ....... [Roof|Kitchen|Basement|Exterior|   │      │
│  │                       Multiple rooms — list each]       │      │
│  │  EmergencyMitigation [Yes|No]                          │      │
│  │  MitigationCompany . ServPro Springfield                │      │
│  │  Habitable ......... [Yes|No]                          │      │
│  │  ContentsAffected .. [Yes|No]                          │      │
│  │  MortgageeOnPolicy . [Yes|No]                          │      │
│  │  MortgageeName ..... First National Bank                │      │
│  └────────────────────────────────────────────────────────┘      │
└───────────────────────────────────────────────────────────────────────┘

┌────────────────────── POLICE / AUTHORITY REPORT ─────────────────┐
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐      │
│  │  PoliceReportFiled . [Yes|No|Unknown]                  │      │
│  │  ReportNumber ...... SPD-2026-045678                    │      │
│  │  Department ........ Springfield PD                     │      │
│  │  OfficerName ....... Ofc. Rodriguez                    │      │
│  │  CitationsIssued ... [Yes|No]                          │      │
│  │  CitedParty ........ [Insured|OtherDriver|Both|Neither]│      │
│  │  FireReportFiled ... [Yes|No] (Property claims)        │      │
│  │  FireReportNumber .. FD-2026-001234                     │      │
│  └────────────────────────────────────────────────────────┘      │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 4. Triage & Segmentation Engine

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    TRIAGE & SEGMENTATION ENGINE                                ║
╚══════════════════════════════════════════════════════════════════════════════════╝

                         ┌───────────────────────┐
                         │    NEW CLAIM CREATED   │
                         │    (FNOL Complete)      │
                         └───────────┬─────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    ▼                ▼                ▼
          ┌─────────────┐  ┌──────────────┐  ┌──────────────┐
          │  RULES      │  │  ML SEVERITY │  │  FRAUD       │
          │  ENGINE     │  │  MODEL       │  │  SCORING     │
          │             │  │              │  │  MODEL       │
          │ • LOB       │  │ • Historical │  │              │
          │ • Cause     │  │   patterns   │  │ • Known      │
          │ • Injury?   │  │ • Loss desc  │  │   patterns   │
          │ • Attorney? │  │   NLP        │  │ • Social     │
          │ • Police?   │  │ • Location   │  │   network    │
          │ • Limits    │  │ • Vehicle/   │  │ • Claimant   │
          │ • Juris-    │  │   Property   │  │   history    │
          │   diction   │  │   data       │  │ • Provider   │
          │             │  │ • Claimant   │  │   patterns   │
          │             │  │   profile    │  │              │
          └──────┬──────┘  └──────┬───────┘  └──────┬───────┘
                 │                │                  │
                 └────────┬───────┘                  │
                          ▼                          │
                 ┌────────────────┐                  │
                 │  COMPOSITE     │◀─────────────────┘
                 │  SCORE         │
                 │                │
                 │  Severity:  S  │
                 │  Complexity:C  │
                 │  Litigation:L  │
                 │  Fraud:     F  │
                 └───────┬────────┘
                         │
          ┌──────────────┼──────────────┬──────────────┐
          ▼              ▼              ▼              ▼
   ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
   │ FAST TRACK │ │  STANDARD  │ │  COMPLEX   │ │   SEVERE   │
   │            │ │            │ │            │ │   / MAJOR  │
   │ S < 30     │ │ 30 ≤ S < 60│ │ 60 ≤ S < 85│ │ S ≥ 85     │
   │ C < 20     │ │ 20 ≤ C < 50│ │ 50 ≤ C < 75│ │ C ≥ 75     │
   │ L < 15     │ │ 15 ≤ L < 40│ │ 40 ≤ L < 70│ │ L ≥ 70     │
   │ F < 300    │ │ F < 500    │ │ F < 750    │ │ ANY F ≥ 750│
   │            │ │            │ │            │ │ = SIU REF  │
   ├────────────┤ ├────────────┤ ├────────────┤ ├────────────┤
   │ Handling:  │ │ Handling:  │ │ Handling:  │ │ Handling:  │
   │ • STP or   │ │ • Exp'd    │ │ • Senior   │ │ • Specialist│
   │   Jr Adj   │ │   adjuster │ │   examiner │ │   unit     │
   │ • Auto-    │ │ • Standard │ │ • Coverage │ │ • Exec     │
   │   reserve  │ │   workflow │ │   counsel  │ │   oversight│
   │ • Target:  │ │ • Target:  │ │ • Target:  │ │ • Reinsurer│
   │   <15 days │ │   30-60 d  │ │   90-180 d │ │   notice   │
   └────────────┘ └────────────┘ └────────────┘ └────────────┘
```

---

## 5. Assignment & Workload Balancing

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    ASSIGNMENT & WORKLOAD BALANCING                              ║
╚══════════════════════════════════════════════════════════════════════════════════╝

                    ┌────────────────────────┐
                    │ SEGMENTED CLAIM        │
                    │ (Tier + LOB + State)   │
                    └───────────┬────────────┘
                                │
                                ▼
                    ┌────────────────────────┐
                    │  ASSIGNMENT RULES      │
                    │  ENGINE                │
                    └───────────┬────────────┘
                                │
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                 ▼
     ┌────────────────┐ ┌──────────────┐ ┌──────────────────┐
     │  ROUND ROBIN   │ │  WEIGHTED    │ │  SPECIALTY       │
     │  (Default)     │ │  LOAD        │ │  ROUTING         │
     │                │ │  BALANCE     │ │                  │
     │ Next available │ │              │ │ Specific rules:  │
     │ adjuster in    │ │ Factors:     │ │ • Litigated →    │
     │ matching pool  │ │ • Open count │ │   Litigation Unit│
     │                │ │ • Avg age    │ │ • WC → WC Team   │
     │                │ │ • Complexity │ │ • Fraud flag →   │
     │                │ │   weight     │ │   SIU queue      │
     │                │ │ • PTO/OOO    │ │ • Large loss →   │
     │                │ │ • Skill lvl  │ │   Major Loss Unit│
     │                │ │ • Geography  │ │ • Cyber → Cyber  │
     └───────┬────────┘ └──────┬───────┘ │   Specialist     │
             │                 │         └────────┬─────────┘
             └────────┬────────┘                  │
                      │                           │
                      ▼                           │
         ┌─────────────────────────┐              │
         │  ADJUSTER POOL MATCH   │◀─────────────┘
         │                        │
         │  Criteria:             │
         │  ├── LOB match         │
         │  ├── State license     │
         │  ├── Authority level   │
         │  ├── Skill tier match  │
         │  └── Capacity check    │
         └───────────┬────────────┘
                     │
            ┌────────┴────────┐
            ▼                 ▼
   ┌──────────────┐  ┌──────────────┐
   │  MATCH FOUND │  │  NO MATCH    │
   │              │  │              │
   │  Assign to   │  │  Escalate to │
   │  adjuster    │  │  supervisor  │
   │              │  │  queue       │
   │  Create      │  │              │
   │  activities: │  │  OR overflow │
   │  • Contact   │  │  to IA firm  │
   │    insured   │  │  / TPA       │
   │  • Review    │  │              │
   │    coverage  │  └──────────────┘
   │  • Set diary │
   └──────────────┘
```

---

## 6. Coverage Verification

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                        COVERAGE VERIFICATION WORKFLOW                          ║
╚══════════════════════════════════════════════════════════════════════════════════╝

              ┌────────────────────────────┐
              │  CLAIM ASSIGNED TO         │
              │  ADJUSTER                  │
              └──────────────┬─────────────┘
                             │
                             ▼
              ┌────────────────────────────┐
              │  RETRIEVE POLICY FROM PAS  │◀──── API call to Policy Admin
              │                            │      System (real-time)
              │  Policy# ──▶ Coverage data │
              └──────────────┬─────────────┘
                             │
                ┌────────────┼────────────┐
                ▼            ▼            ▼
       ┌──────────────┐ ┌──────────┐ ┌──────────────┐
       │  POLICY IN   │ │ COVERAGE │ │  EXCLUSIONS  │
       │  FORCE?      │ │  APPLIES?│ │  APPLY?      │
       │              │ │          │ │              │
       │ Check:       │ │ Check:   │ │ Check:       │
       │ • Effective  │ │ • LOB    │ │ • Named      │
       │   date       │ │ • Peril/ │ │   exclusions │
       │ • Expiration │ │   cause  │ │ • Property   │
       │   date       │ │   of loss│ │   excluded   │
       │ • Loss date  │ │ • Vehicle│ │ • Business   │
       │   within?    │ │   /prop  │ │   activity   │
       │ • Cancelled? │ │   listed │ │ • Intentional│
       │ • Premium    │ │ • Limits │ │   acts       │
       │   paid?      │ │ • Deduct │ │ • Wear &     │
       │              │ │ • SIR    │ │   tear       │
       └──────┬───────┘ └────┬─────┘ └──────┬───────┘
              │              │              │
              ▼              ▼              ▼
       ┌─────────────────────────────────────────────┐
       │           COVERAGE DECISION MATRIX          │
       └──────────────────┬──────────────────────────┘
                          │
          ┌───────────────┼───────────────┬──────────────────┐
          ▼               ▼               ▼                  ▼
  ┌──────────────┐ ┌────────────┐ ┌──────────────┐ ┌──────────────┐
  │   COVERED    │ │  COVERAGE  │ │  RESERVATION │ │   DENIED     │
  │              │ │  QUESTION  │ │  OF RIGHTS   │ │              │
  │ All coverage │ │            │ │  (ROR)       │ │ Not covered  │
  │ confirmed;   │ │ Gray area; │ │              │ │ under policy │
  │ proceed with │ │ refer to   │ │ Letter sent  │ │              │
  │ claim        │ │ coverage   │ │ to insured;  │ │ Denial letter│
  │ handling     │ │ counsel    │ │ investigation│ │ issued with  │
  │              │ │            │ │ continues    │ │ specific     │
  │ Create       │ │ ┌────────┐ │ │ under ROR    │ │ policy       │
  │ Exposure(s)  │ │ │Coverage│ │ │              │ │ language     │
  │ per coverage │ │ │Counsel │ │ │ May lead to: │ │ cited        │
  │ + claimant   │ │ │Opinion │ │ │ • Coverage   │ │              │
  │              │ │ └───┬────┘ │ │   granted    │ │ Close claim  │
  │              │ │     │      │ │ • Denial     │ │ (no payment) │
  │              │ │     ▼      │ │ • Declaratory│ │              │
  │              │ │  Decision  │ │   judgment   │ │ Claimant may │
  │              │ │  returned  │ │   action     │ │ invoke       │
  └──────────────┘ └────────────┘ └──────────────┘ │ Appraisal or│
                                                    │ file suit    │
                                                    └──────────────┘
```

---

## 7. Auto Physical Damage — Full Workflow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                   AUTO PHYSICAL DAMAGE — COMPLETE WORKFLOW                      ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌───────────┐
  │   FNOL    │
  │ (Auto PD) │
  └─────┬─────┘
        │
        ▼
  ┌─────────────────────────────────────────────────────────┐
  │  INITIAL ASSESSMENT                                     │
  │                                                         │
  │  Insured uploads photos via mobile app (min 4 angles)   │
  │  OR adjuster orders field inspection                    │
  └─────────────────────────┬───────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
  ┌──────────────────────┐   ┌──────────────────────┐
  │  AI PHOTO ANALYSIS   │   │  FIELD / VIRTUAL     │
  │  (CCC / Tractable)   │   │  INSPECTION          │
  │                      │   │                      │
  │  • Component ID      │   │  • Adjuster / IA     │
  │  • Severity classify │   │    inspects vehicle   │
  │  • Preliminary est   │   │  • Writes estimate   │
  │  • Repairable?       │   │  • Photos + notes    │
  └──────────┬───────────┘   └──────────┬───────────┘
             │                          │
             └────────────┬─────────────┘
                          │
                          ▼
               ┌─────────────────────┐
               │   TOTAL LOSS        │
               │   THRESHOLD CHECK   │
               │                     │
               │   Repair estimate   │
               │   vs. ACV           │
               │                     │
               │   Threshold: 70-80% │
               │   (varies by state) │
               └──────────┬──────────┘
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
  ┌──────────────────┐     ┌──────────────────────┐
  │   REPAIRABLE     │     │   TOTAL LOSS         │
  │                  │     │   (see Section 18)   │
  │                  │     └──────────────────────┘
  └────────┬─────────┘
           │
           ▼
  ┌─────────────────────────────────────────────────────────┐
  │  REPAIR AUTHORIZATION                                   │
  │                                                         │
  │  ┌───────────────────────┐   ┌────────────────────────┐ │
  │  │  DRP (Direct Repair   │   │  NON-DRP SHOP         │ │
  │  │  Program) Shop        │   │  (Customer's choice)   │ │
  │  │                       │   │                        │ │
  │  │  • Pre-negotiated     │   │  • Estimate review     │ │
  │  │    labor rates        │   │    required            │ │
  │  │  • OEM/aftermarket    │   │  • Rate negotiation    │ │
  │  │    parts agreement    │   │    may be needed       │ │
  │  │  • Guaranteed repairs │   │  • Re-inspection may   │ │
  │  │  • Direct assignment  │   │    be ordered          │ │
  │  │    via EMS/CIECA      │   │                        │ │
  │  └───────────┬───────────┘   └───────────┬────────────┘ │
  │              └───────────┬───────────────┘              │
  └──────────────────────────┼──────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────┐
  │  REPAIR IN PROGRESS                                     │
  │                                                         │
  │  Shop performs teardown ──▶ Hidden damage found?        │
  │                              │                          │
  │                    ┌─────────┴─────────┐                │
  │                    ▼                   ▼                │
  │           ┌──────────────┐    ┌──────────────┐         │
  │           │   YES        │    │    NO        │         │
  │           │              │    │              │         │
  │           │  SUPPLEMENT  │    │  Continue    │         │
  │           │  REQUEST     │    │  repair per  │         │
  │           │              │    │  original    │         │
  │           │  • Shop      │    │  estimate    │         │
  │           │    submits   │    │              │         │
  │           │    photos +  │    └──────────────┘         │
  │           │    revised   │                              │
  │           │    estimate  │                              │
  │           │  • Adjuster  │                              │
  │           │    reviews   │                              │
  │           │    + approves│                              │
  │           │    or denies │                              │
  │           └──────┬───────┘                              │
  │                  │                                      │
  │                  ▼                                      │
  │         ┌──────────────────┐                            │
  │         │  Re-check total  │                            │
  │         │  loss threshold  │                            │
  │         │  with supplement │                            │
  │         └────────┬─────────┘                            │
  │           Still  │  Now exceeds                         │
  │         repair   │  threshold                           │
  │           │      │    │                                 │
  │           ▼      │    ▼                                 │
  │     [Continue]   │  [Total Loss                         │
  │                  │   Process]                            │
  └──────────────────┼──────────────────────────────────────┘
                     │
                     ▼
  ┌─────────────────────────────────────────────────────────┐
  │  REPAIR COMPLETE                                        │
  │                                                         │
  │  Shop submits final invoice ──▶ Adjuster reviews        │
  │                                                         │
  │  ┌──────────────────────────────────────────────┐      │
  │  │  PAYMENT CALCULATION                          │      │
  │  │                                               │      │
  │  │  Final repair cost ........... $4,350         │      │
  │  │  (-) Deductible .............. $  500         │      │
  │  │  ──────────────────────────────────────       │      │
  │  │  Net payment to shop ......... $3,850         │      │
  │  │                                               │      │
  │  │  Payment method: vCard to DRP shop            │      │
  │  │  OR check/EFT to non-DRP                     │      │
  │  └──────────────────────────────────────────────┘      │
  └────────────────────────────┬────────────────────────────┘
                               │
                               ▼
  ┌─────────────────────────────────────────────────────────┐
  │  RENTAL / LOSS OF USE                                   │
  │                                                         │
  │  If rental coverage applies:                            │
  │  • Rental authorized from date of loss                  │
  │  • Enterprise / Hertz direct bill program               │
  │  • Duration: repair days + reasonable buffer             │
  │  • Daily limit per policy (e.g., $40/day)               │
  │  • Total capped (e.g., $1,200 or 30 days)              │
  │  • Payment issued to rental company                     │
  └────────────────────────────┬────────────────────────────┘
                               │
                               ▼
  ┌─────────────────────────────────────────────────────────┐
  │  SUBROGATION CHECK                                      │
  │                                                         │
  │  Is a third party at fault?                             │
  │      │                                                  │
  │      ├── YES ──▶ Refer to Subro Unit                   │
  │      │           • Demand to at-fault carrier           │
  │      │           • Recover paid amount + deductible     │
  │      │                                                  │
  │      └── NO ──▶ Close (first-party only)               │
  └────────────────────────────┬────────────────────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    CLOSE CLAIM      │
                    └─────────────────────┘
```

---

## 8. Auto Bodily Injury — Full Workflow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                   AUTO BODILY INJURY — COMPLETE WORKFLOW                        ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────┐
  │  FNOL        │
  │  (BI Claim)  │
  └──────┬───────┘
         │
         ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  LIABILITY INVESTIGATION                                     │
  │                                                              │
  │  ┌─────────────┐  ┌────────────┐  ┌──────────────────────┐ │
  │  │ Recorded    │  │ Police     │  │ Scene Investigation  │ │
  │  │ Statements  │  │ Report     │  │ (if complex)         │ │
  │  │ • Insured   │  │ • Obtain   │  │ • Photos             │ │
  │  │ • Claimant  │  │ • Review   │  │ • Witness canvass    │ │
  │  │ • Witnesses │  │ • Citations│  │ • Accident recon     │ │
  │  └──────┬──────┘  └─────┬──────┘  └──────────┬───────────┘ │
  │         └───────────────┼─────────────────────┘             │
  │                         ▼                                    │
  │               ┌──────────────────┐                          │
  │               │  LIABILITY       │                          │
  │               │  DETERMINATION   │                          │
  │               │                  │                          │
  │               │  Insured: ___%   │                          │
  │               │  Claimant: ___%  │                          │
  │               │                  │                          │
  │               │  Jurisdiction:   │                          │
  │               │  • Contributory  │                          │
  │               │  • Comparative   │                          │
  │               │    (Pure/50/51)  │                          │
  │               └────────┬─────────┘                          │
  └────────────────────────┼────────────────────────────────────┘
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
    ┌─────────────┐ ┌───────────┐ ┌──────────────┐
    │  INSURED    │ │  SHARED   │ │  INSURED NOT │
    │  LIABLE     │ │  LIABILITY│ │  LIABLE       │
    │  (≥51%)    │ │  (mixed)  │ │  (0%)        │
    │             │ │           │ │              │
    │  Proceed   │ │ Negotiate │ │  Deny claim  │
    │  with BI   │ │ based on  │ │  (close      │
    │  eval      │ │ comp fault│ │   exposure)  │
    └──────┬──────┘ └─────┬─────┘ └──────────────┘
           │              │
           └──────┬───────┘
                  │
                  ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  MEDICAL TREATMENT MONITORING                                │
  │                                                              │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │  TIMELINE                                                │ │
  │  │                                                          │ │
  │  │  Loss ──▶ ER Visit ──▶ Follow-up MD ──▶ Diagnostics    │ │
  │  │  Date          │             │         (MRI/CT/X-ray)   │ │
  │  │                │             │              │            │ │
  │  │                ▼             ▼              ▼            │ │
  │  │          Acute Care    Treatment Plan   Results         │ │
  │  │                │             │              │            │ │
  │  │                ▼             ▼              ▼            │ │
  │  │          Discharge    Physical Therapy   Surgery?       │ │
  │  │                       (weeks/months)      │             │ │
  │  │                            │          ┌───┴───┐         │ │
  │  │                            │          No     Yes        │ │
  │  │                            │          │       │         │ │
  │  │                            ▼          │    Post-Op      │ │
  │  │                     Treatment         │    Recovery     │ │
  │  │                     Plateau           │       │         │ │
  │  │                            │          │       │         │ │
  │  │                            └──────────┼───────┘         │ │
  │  │                                       ▼                 │ │
  │  │                              ┌──────────────────┐       │ │
  │  │                              │  MMI (Maximum    │       │ │
  │  │                              │  Medical         │       │ │
  │  │                              │  Improvement)    │       │ │
  │  │                              └────────┬─────────┘       │ │
  │  └───────────────────────────────────────┼─────────────────┘ │
  └──────────────────────────────────────────┼───────────────────┘
                                             │
                                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  DAMAGE EVALUATION                                           │
  │                                                              │
  │  ┌───────────────────────────────────────────────────────┐   │
  │  │  SPECIAL DAMAGES (Economic)                            │   │
  │  │                                                        │   │
  │  │  Medical Specials:                                     │   │
  │  │    ER visit ..................... $  3,500              │   │
  │  │    MRI .......................... $  2,200              │   │
  │  │    Orthopedic visits (8) ........ $  2,400              │   │
  │  │    Physical Therapy (24 sess) ... $  4,800              │   │
  │  │    Prescriptions ................ $    600              │   │
  │  │    ─────────────────────────────────────               │   │
  │  │    Total Medical Specials ....... $ 13,500              │   │
  │  │                                                        │   │
  │  │  Lost Wages:                                           │   │
  │  │    Missed work (6 weeks) ........ $  7,200              │   │
  │  │                                                        │   │
  │  │  Total Specials ................. $ 20,700              │   │
  │  └───────────────────────────────────────────────────────┘   │
  │                                                              │
  │  ┌───────────────────────────────────────────────────────┐   │
  │  │  GENERAL DAMAGES (Non-Economic)                        │   │
  │  │                                                        │   │
  │  │  Method 1: Multiplier                                  │   │
  │  │    Specials × 1.5-5.0 factor                          │   │
  │  │    $20,700 × 2.5 = $51,750                            │   │
  │  │                                                        │   │
  │  │  Method 2: Colossus / Claims Outcome Advisor           │   │
  │  │    Input injury details ──▶ Range: $35K - $55K         │   │
  │  │                                                        │   │
  │  │  Method 3: Verdict Research                            │   │
  │  │    Similar cases in jurisdiction ──▶ Median: $45K      │   │
  │  └───────────────────────────────────────────────────────┘   │
  │                                                              │
  │  ┌───────────────────────────────────────────────────────┐   │
  │  │  TOTAL EVALUATION RANGE                                │   │
  │  │                                                        │   │
  │  │  Low .............. $35,000                            │   │
  │  │  Midpoint ......... $45,000                            │   │
  │  │  High ............. $55,000                            │   │
  │  │                                                        │   │
  │  │  Reserve set at: ... $45,000                           │   │
  │  └───────────────────────────────────────────────────────┘   │
  └──────────────────────────────┬───────────────────────────────┘
                                 │
                                 ▼
               ┌────────────────────────────────┐
               │  CLAIMANT REPRESENTED          │
               │  BY ATTORNEY?                  │
               └──────────┬─────────────────────┘
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
     ┌──────────────┐       ┌──────────────────┐
     │  NO ATTORNEY │       │  ATTORNEY        │
     │              │       │  REPRESENTED     │
     │  Negotiate   │       │                  │
     │  directly    │       │  Demand letter   │
     │  with        │       │  received        │
     │  claimant    │       │  ($150,000)      │
     └──────┬───────┘       │                  │
            │               │  Counter offer:  │
            │               │  $35,000         │
            │               │        │         │
            │               │        ▼         │
            │               │  Negotiation     │
            │               │  rounds          │
            │               │  (2-5 rounds     │
            │               │   typical)       │
            │               └────────┬─────────┘
            │                        │
            │               ┌────────┴────────┐
            │               ▼                 ▼
            │      ┌──────────────┐  ┌──────────────┐
            │      │  SETTLED     │  │  IMPASSE     │
            │      │              │  │              │
            │      │  $45,000     │  │  Options:    │
            │      │  agreed      │  │  • Mediation │
            │      │              │  │  • Arbitratn │
            │      │              │  │  • Litigation│
            │      └──────┬───────┘  └──────┬───────┘
            │             │                 │
            └──────┬──────┘                 │
                   │                        │
                   ▼                        ▼
  ┌────────────────────────┐    ┌──────────────────────┐
  │  SETTLEMENT EXECUTION  │    │  LITIGATION          │
  │                        │    │  (see Section 16)    │
  │  • Release signed      │    │                      │
  │  • Medicare query      │    │  May settle during   │
  │    (Section 111)       │    │  discovery or at     │
  │  • Payment processed   │    │  mediation           │
  │  • 1099 issued if >$600│    │                      │
  └────────────┬───────────┘    └──────────────────────┘
               │
               ▼
       ┌──────────────┐
       │  CLOSE CLAIM │
       └──────────────┘
```

---

## 9. Homeowners Property Claim — Full Workflow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                 HOMEOWNERS PROPERTY CLAIM — COMPLETE WORKFLOW                   ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────┐
  │  LOSS EVENT          │
  │  (Fire/Wind/Water/   │
  │   Hail/Theft/Other)  │
  └──────────┬───────────┘
             │
             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  EMERGENCY RESPONSE (if applicable)                          │
  │                                                              │
  │  • Call 911 (fire/crime)                                    │
  │  • Emergency board-up / tarp (prevent further damage)        │
  │  • Water extraction / drying (if water damage)               │
  │  • Temporary housing (if uninhabitable)                      │
  │                                                              │
  │  Insured's duty: mitigate further damage (policy condition)  │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  FNOL FILED                                                  │
  │                                                              │
  │  Channel: Phone (most common for property) or Mobile App     │
  │  CAT code assigned if catastrophe-related                    │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  COVERAGE ANALYSIS                                           │
  │                                                              │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │  HO-3 (Special Form) Coverage Breakdown:                │ │
  │  │                                                          │ │
  │  │  Coverage A: Dwelling ............... $350,000            │ │
  │  │  Coverage B: Other Structures ........ $ 35,000 (10% A)  │ │
  │  │  Coverage C: Personal Property ....... $175,000 (50% A)  │ │
  │  │  Coverage D: Loss of Use (ALE) ....... $ 70,000 (20% A)  │ │
  │  │  Coverage E: Personal Liability ...... $300,000           │ │
  │  │  Coverage F: Medical Payments ........ $  5,000           │ │
  │  │                                                          │ │
  │  │  Deductible: $1,000 (or 2% wind/hail in CAT-prone area) │ │
  │  │                                                          │ │
  │  │  Key Exclusions Check:                                   │ │
  │  │  □ Flood (excluded — requires NFIP or private flood)     │ │
  │  │  □ Earth movement (excluded unless endorsed)              │ │
  │  │  □ Mold (sublimited in most states)                      │ │
  │  │  □ Wear and tear / maintenance                           │ │
  │  │  □ Ordinance or law (sublimited unless endorsed)         │ │
  │  └─────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  INSPECTION METHOD DECISION                                  │
  │                                                              │
  │           ┌──────────────────────────────────┐               │
  │           │  SEVERITY / COMPLEXITY           │               │
  │           └──────────┬───────────────────────┘               │
  │                      │                                       │
  │       ┌──────────────┼──────────────┬──────────────┐        │
  │       ▼              ▼              ▼              ▼        │
  │  ┌─────────┐  ┌───────────┐  ┌───────────┐  ┌──────────┐  │
  │  │ VIRTUAL │  │  AERIAL   │  │  FIELD    │  │ COMBINED │  │
  │  │ INSPECT │  │  IMAGERY  │  │ INSPECT   │  │ (Multi-  │  │
  │  │         │  │           │  │           │  │  method) │  │
  │  │ Video   │  │ EagleView │  │ Adjuster  │  │          │  │
  │  │ call w/ │  │ or HOVER  │  │ or IA on  │  │ Aerial + │  │
  │  │ insured │  │ for roof  │  │ site      │  │ Field +  │  │
  │  │         │  │ measure   │  │           │  │ Virtual  │  │
  │  │ <$10K   │  │           │  │ >$25K or  │  │          │  │
  │  │ simple  │  │ Roof only │  │ complex   │  │ Large    │  │
  │  │ damage  │  │ claims    │  │ claims    │  │ losses   │  │
  │  └────┬────┘  └─────┬─────┘  └─────┬─────┘  └────┬─────┘  │
  │       └─────────────┼──────────────┼──────────────┘        │
  └─────────────────────┼──────────────┼────────────────────────┘
                        │              │
                        └──────┬───────┘
                               │
                               ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  ESTIMATE CREATION (Xactimate)                               │
  │                                                              │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │  DWELLING DAMAGE                                         │ │
  │  │                                                          │ │
  │  │  Line Items:                            RCV      ACV    │ │
  │  │  ├── Roof (tear-off + replace, 22 sq). $11,000  $ 7,700 │ │
  │  │  ├── Siding (remove + replace, 400sf).  $ 4,800  $ 3,360 │ │
  │  │  ├── Interior drywall (kitchen) .......  $ 2,200  $ 2,200 │ │
  │  │  ├── Kitchen cabinets (water damaged) .  $ 8,500  $ 5,950 │ │
  │  │  ├── Flooring (hardwood, 300sf) .......  $ 5,400  $ 3,780 │ │
  │  │  ├── Paint (kitchen + hallway) ........  $ 1,800  $ 1,800 │ │
  │  │  ├── Electrical (outlet replacement) ..  $   600  $   600 │ │
  │  │  └── General conditions (dumpster, etc)  $ 1,200  $ 1,200 │ │
  │  │  ─────────────────────────────────────  ───────  ─────── │ │
  │  │  Dwelling Subtotal ...................  $35,500  $26,590 │ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                              │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │  CONTENTS / PERSONAL PROPERTY                            │ │
  │  │                                                          │ │
  │  │  Room-by-room inventory:               RCV      ACV    │ │
  │  │  ├── Kitchen appliances .............. $ 3,200  $ 1,920 │ │
  │  │  ├── Kitchen contents (dishes, etc) .. $ 1,500  $   900 │ │
  │  │  ├── Basement storage items .......... $ 2,800  $ 1,400 │ │
  │  │  └── Electronics (basement) .......... $ 1,200  $   720 │ │
  │  │  ─────────────────────────────────────  ───────  ─────── │ │
  │  │  Contents Subtotal ...................  $ 8,700  $ 4,940 │ │
  │  └─────────────────────────────────────────────────────────┘ │
  │                                                              │
  │  ┌─────────────────────────────────────────────────────────┐ │
  │  │  ALE (Additional Living Expenses)                        │ │
  │  │                                                          │ │
  │  │  Hotel (14 nights × $150/night) ...... $ 2,100           │ │
  │  │  Meals (14 days × $75/day) ........... $ 1,050           │ │
  │  │  Laundry / misc ...................... $   200           │ │
  │  │  ─────────────────────────────────────  ───────          │ │
  │  │  ALE Subtotal ........................ $ 3,350           │ │
  │  └─────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  PAYMENT SEQUENCE (Replacement Cost Policy)                  │
  │                                                              │
  │  STEP 1: ALE Advance Payment                                │
  │  ┌──────────────────────────────────────────────┐           │
  │  │  ALE: $3,350 (no deductible on ALE)         │           │
  │  │  Paid immediately upon verified displacement │           │
  │  └──────────────────────────────────────────────┘           │
  │                                                              │
  │  STEP 2: ACV Payment (Initial)                              │
  │  ┌──────────────────────────────────────────────┐           │
  │  │  Dwelling ACV .............. $26,590          │           │
  │  │  Contents ACV .............. $ 4,940          │           │
  │  │  ────────────────────────────────────         │           │
  │  │  Subtotal .................. $31,530          │           │
  │  │  (-) Deductible ............ $ 1,000          │           │
  │  │  ════════════════════════════════════         │           │
  │  │  ACV Payment ............... $30,530          │           │
  │  │                                               │           │
  │  │  Two-party check (insured + mortgagee)       │           │
  │  └──────────────────────────────────────────────┘           │
  │                                                              │
  │  STEP 3: Recoverable Depreciation (upon proof of repair)    │
  │  ┌──────────────────────────────────────────────┐           │
  │  │  Dwelling RCV - ACV ......... $ 8,910         │           │
  │  │  Contents RCV - ACV ......... $ 3,760         │           │
  │  │  ────────────────────────────────────         │           │
  │  │  Depreciation Holdback ...... $12,670         │           │
  │  │                                               │           │
  │  │  Released upon receipts / proof of repair     │           │
  │  │  (within policy time limit, typically 1-2 yr) │           │
  │  └──────────────────────────────────────────────┘           │
  │                                                              │
  │  TOTAL CLAIM PAYOUT: $3,350 + $30,530 + $12,670 = $46,550  │
  └──────────────────────────────────────────────────────────────┘
```

---

## 10. Workers' Compensation — Full Workflow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║              WORKERS' COMPENSATION — COMPLETE WORKFLOW                          ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌───────────────────────┐
  │  WORKPLACE INJURY     │
  │  OR ILLNESS           │
  └───────────┬───────────┘
              │
              ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  EMPLOYER ACTIONS (Within 24-72 hours per state law)            │
  │                                                                 │
  │  1. Provide first aid / medical care                           │
  │  2. Complete Employer's First Report of Injury (FROI)          │
  │  3. File with carrier AND state WC board/commission             │
  │  4. Provide employee with rights documentation                  │
  │  5. Identify witnesses                                          │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  THREE-POINT CONTACT (Within 24 hours of FNOL)                 │
  │                                                                 │
  │  ┌─────────────────┐  ┌──────────────────┐  ┌────────────────┐ │
  │  │  1. EMPLOYER     │  │  2. EMPLOYEE      │  │ 3. TREATING   │ │
  │  │                  │  │     (Injured      │  │    PHYSICIAN  │ │
  │  │  • Job duties    │  │      Worker)      │  │               │ │
  │  │  • Date/time     │  │                   │  │  • Diagnosis  │ │
  │  │  • Witnesses     │  │  • How it         │  │  • Treatment  │ │
  │  │  • Modified      │  │    happened       │  │    plan       │ │
  │  │    duty avail?   │  │  • Body part      │  │  • Prognosis  │ │
  │  │  • RTW plan      │  │  • Treatment      │  │  • Work       │ │
  │  │  • Safety        │  │  • Prior injuries │  │    restrictions│ │
  │  │    incident rpt  │  │  • Concerns       │  │  • Expected   │ │
  │  │                  │  │                   │  │    duration   │ │
  │  └─────────────────┘  └──────────────────┘  └────────────────┘ │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  COMPENSABILITY DETERMINATION                                   │
  │                                                                 │
  │  Was the injury:                                                │
  │  ├── Arising out of employment (AOE)?                          │
  │  ├── In the course of employment (COE)?                        │
  │  ├── Within statute of limitations?                            │
  │  └── Not subject to exclusion (intoxication, self-inflicted)?  │
  │                                                                 │
  │       ┌──────────────────────────────┐                         │
  │       │        ALL YES?              │                         │
  │       └──────────────┬───────────────┘                         │
  │              ┌───────┴───────┐                                 │
  │              ▼               ▼                                 │
  │     ┌──────────────┐  ┌──────────────┐                        │
  │     │  COMPENSABLE  │  │  DENY CLAIM  │                        │
  │     │  (Accept)     │  │              │                        │
  │     │               │  │  Written     │                        │
  │     │  Accept       │  │  denial to   │                        │
  │     │  letter sent  │  │  employee +  │                        │
  │     │               │  │  employer    │                        │
  │     │               │  │              │                        │
  │     │               │  │  Employee    │                        │
  │     │               │  │  may contest │                        │
  │     │               │  │  before WC   │                        │
  │     │               │  │  board       │                        │
  │     └──────┬────────┘  └──────────────┘                        │
  └────────────┼────────────────────────────────────────────────────┘
               │
               ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  CLAIM TYPE DETERMINATION                                       │
  │                                                                 │
  │              ┌───────────────────────────────┐                 │
  │              │  LOST TIME FROM WORK?         │                 │
  │              └──────────────┬────────────────┘                 │
  │                   ┌────────┴────────┐                          │
  │                   ▼                 ▼                          │
  │          ┌──────────────┐  ┌──────────────────────┐           │
  │          │ MEDICAL ONLY │  │   LOST TIME (INDEM)  │           │
  │          │              │  │                      │           │
  │          │ Only medical │  │  Medical + Indemnity │           │
  │          │ treatment    │  │  benefits             │           │
  │          │ No lost work │  │                      │           │
  │          │ (or < wait-  │  │  Waiting period:     │           │
  │          │  ing period) │  │  3-7 days (by state) │           │
  │          │              │  │                      │           │
  │          │ Simpler      │  │  If disability >     │           │
  │          │ handling     │  │  retroactive period  │           │
  │          │ Higher STP   │  │  (14-21 days),       │           │
  │          │              │  │  waiting period paid  │           │
  │          └──────┬───────┘  └──────────┬───────────┘           │
  └─────────────────┼─────────────────────┼─────────────────────────┘
                    │                     │
                    │                     ▼
                    │  ┌─────────────────────────────────────────┐
                    │  │  INDEMNITY BENEFIT CALCULATION           │
                    │  │                                         │
                    │  │  AWW (Average Weekly Wage):              │
                    │  │    52-week earnings ÷ 52 = $950/week    │
                    │  │                                         │
                    │  │  Compensation Rate:                      │
                    │  │    2/3 × AWW = $633.33/week              │
                    │  │    (subject to state min/max)            │
                    │  │                                         │
                    │  │  ┌───────────────────────────────────┐  │
                    │  │  │ DISABILITY TYPES                   │  │
                    │  │  │                                    │  │
                    │  │  │ TTD (Temporary Total)              │  │
                    │  │  │  └─ Cannot work at all             │  │
                    │  │  │     2/3 AWW, state max cap         │  │
                    │  │  │     Until RTW or MMI               │  │
                    │  │  │                                    │  │
                    │  │  │ TPD (Temporary Partial)            │  │
                    │  │  │  └─ Can work, reduced capacity     │  │
                    │  │  │     2/3 × (pre-injury wage -       │  │
                    │  │  │           current earnings)        │  │
                    │  │  │                                    │  │
                    │  │  │ PPD (Permanent Partial)            │  │
                    │  │  │  └─ Permanent impairment but       │  │
                    │  │  │     can still work                 │  │
                    │  │  │     Rated by % impairment          │  │
                    │  │  │     Scheduled (body part) or       │  │
                    │  │  │     unscheduled (whole person)     │  │
                    │  │  │                                    │  │
                    │  │  │ PTD (Permanent Total)              │  │
                    │  │  │  └─ Cannot return to any work      │  │
                    │  │  │     Lifetime benefits in most      │  │
                    │  │  │     states (or until age 65/67)    │  │
                    │  │  └───────────────────────────────────┘  │
                    │  └─────────────────────────────────────────┘
                    │                     │
                    └──────────┬──────────┘
                               │
                               ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  MEDICAL MANAGEMENT                                             │
  │                                                                 │
  │  ┌────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
  │  │ BILL REVIEW    │  │ UTILIZATION     │  │ NURSE CASE      │ │
  │  │                │  │ REVIEW (UR)     │  │ MANAGEMENT      │ │
  │  │ Every medical  │  │                 │  │                 │ │
  │  │ bill checked:  │  │ Pre-auth for:   │  │ Assigned for    │ │
  │  │ • Fee schedule │  │ • Surgery       │  │ complex cases:  │ │
  │  │   compliance   │  │ • MRI/CT        │  │ • Coordinate    │ │
  │  │ • UCR rates    │  │ • Specialist    │  │   care          │ │
  │  │ • Duplicate    │  │   referrals     │  │ • Monitor       │ │
  │  │   billing      │  │ • DME           │  │   treatment     │ │
  │  │ • Unbundling   │  │ • Extended PT   │  │ • Facilitate    │ │
  │  │ • Network      │  │                 │  │   RTW           │ │
  │  │   repricing    │  │ Evidence-based  │  │ • Attend MD     │ │
  │  │                │  │ guidelines      │  │   appointments  │ │
  │  │ Savings: 30-50%│  │ (ODG/ACOEM)    │  │                 │ │
  │  └────────────────┘  └─────────────────┘  └─────────────────┘ │
  │                                                                 │
  │  ┌───────────────────────────────────────────────────────────┐ │
  │  │ PHARMACY (Rx) MANAGEMENT                                   │ │
  │  │                                                            │ │
  │  │ • PBM (Pharmacy Benefit Manager) for WC scripts           │ │
  │  │ • Formulary compliance (state-specific)                    │ │
  │  │ • Opioid monitoring (PDMP checks, morphine equivalent      │ │
  │  │   dose tracking, taper protocols)                          │ │
  │  │ • Generic substitution when available                      │ │
  │  │ • Compound medication review                               │ │
  │  └───────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  RETURN TO WORK (RTW)                                           │
  │                                                                 │
  │  ┌──────────────────────────────────────────────────────────┐  │
  │  │                                                          │  │
  │  │   Full      Modified    Light     Transitional   Unable  │  │
  │  │   Duty ◀─── Duty ◀──── Duty ◀──── Duty ◀─────── to     │  │
  │  │   (Goal)    (Progress)  (Early)   (Earliest)     Work    │  │
  │  │                                                          │  │
  │  │   RTW Plan developed with:                               │  │
  │  │   • Employer (available positions)                       │  │
  │  │   • Treating physician (restrictions)                    │  │
  │  │   • Employee (willingness/ability)                       │  │
  │  │   • Vocational rehab counselor (if needed)               │  │
  │  │                                                          │  │
  │  └──────────────────────────────────────────────────────────┘  │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  CLAIM RESOLUTION                                               │
  │                                                                 │
  │  Option A: Voluntary Closure                                    │
  │   └── Employee returns to work, treatment complete              │
  │       Final medical report confirms MMI                         │
  │       All bills paid, indemnity ceased                          │
  │                                                                 │
  │  Option B: Compromise & Release (C&R)                           │
  │   └── Lump sum settlement                                      │
  │       Closes out ALL future benefits (medical + indemnity)     │
  │       Requires state approval (WC board hearing)               │
  │       Medicare Set-Aside if Medicare eligible                   │
  │                                                                 │
  │  Option C: Stipulation with Request for Award                   │
  │   └── Agreed PPD rating and payment                            │
  │       Future medical LEFT OPEN                                  │
  │       Common when ongoing treatment expected                    │
  │                                                                 │
  │  Option D: Contested (Hearing/Trial)                            │
  │   └── Disputes go before WC Administrative Law Judge            │
  │       Issues: compensability, degree of disability, MMI,        │
  │       medical treatment necessity                                │
  └─────────────────────────────────────────────────────────────────┘
```

---

## 11. Commercial General Liability — Full Workflow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║           COMMERCIAL GENERAL LIABILITY — COMPLETE WORKFLOW                      ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────┐
  │  OCCURRENCE                │
  │  (Slip-and-fall, Product   │
  │   Defect, Completed Ops,   │
  │   Advertising Injury)      │
  └──────────────┬─────────────┘
                 │
                 ▼
  ┌──────────────────────────────────────────┐
  │  NOTICE TO CARRIER                       │
  │                                          │
  │  Sources:                                │
  │  • Insured reports incident              │
  │  • Demand letter from claimant attorney  │
  │  • Summons & Complaint served            │
  │  • Broker/agent forwards notice          │
  └──────────────────┬───────────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  COVERAGE ANALYSIS (CGL — ISO Form CG 00 01)                    │
  │                                                                  │
  │  ┌───────────────────────────────────────────────────────────┐  │
  │  │  Coverage A: Bodily Injury & Property Damage              │  │
  │  │  Coverage B: Personal & Advertising Injury                 │  │
  │  │  Coverage C: Medical Payments                              │  │
  │  │                                                            │  │
  │  │  Limits:                                                   │  │
  │  │  ├── Each Occurrence .............. $1,000,000             │  │
  │  │  ├── General Aggregate ............ $2,000,000             │  │
  │  │  ├── Products-Completed Ops Agg ... $2,000,000             │  │
  │  │  ├── Personal & Advertising Injury  $1,000,000             │  │
  │  │  ├── Fire Damage .................. $  100,000             │  │
  │  │  └── Medical Expense .............. $    5,000             │  │
  │  │                                                            │  │
  │  │  KEY COVERAGE QUESTIONS:                                   │  │
  │  │  □ Is there an "occurrence" (accident)?                    │  │
  │  │  □ Did it happen during the policy period?                 │  │
  │  │  □ Did it happen in the coverage territory?                │  │
  │  │  □ Is the insured the named insured or additional insured? │  │
  │  │  □ Do any exclusions apply?                                │  │
  │  │     • Expected/intended injury                             │  │
  │  │     • Contractual liability (limited exception)            │  │
  │  │     • Liquor liability                                     │  │
  │  │     • Workers' compensation                                │  │
  │  │     • Pollution                                            │  │
  │  │     • Professional services (E&O needed)                   │  │
  │  │     • Employment practices (EPLI needed)                   │  │
  │  │  □ Is aggregate eroded by prior claims?                    │  │
  │  └───────────────────────────────────────────────────────────┘  │
  └──────────────────────────┬───────────────────────────────────────┘
                             │
             ┌───────────────┴───────────────┐
             ▼                               ▼
  ┌──────────────────┐            ┌──────────────────────┐
  │  DUTY TO DEFEND  │            │  NO DUTY TO DEFEND   │
  │  TRIGGERED       │            │                      │
  │                  │            │  Decline defense      │
  │  (Broader than   │            │  (must clearly fall   │
  │   duty to        │            │   outside all coverage│
  │   indemnify)     │            │   based on complaint) │
  │                  │            │                      │
  │  Assign defense  │            │  Issue denial or ROR │
  │  counsel         │            │  letter              │
  └────────┬─────────┘            └──────────────────────┘
           │
           ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  INVESTIGATION                                                   │
  │                                                                  │
  │  ┌───────────┐  ┌──────────┐  ┌─────────────┐  ┌────────────┐ │
  │  │ Recorded  │  │ Scene    │  │ Surveillance │  │ Expert     │ │
  │  │ Statements│  │ Evidence │  │ Video /      │  │ Retention  │ │
  │  │           │  │          │  │ Security Cam │  │            │ │
  │  │ • Insured │  │ • Photos │  │              │  │ • Biomech  │ │
  │  │ • Claimant│  │ • Video  │  │ Maintenance  │  │ • Safety   │ │
  │  │ • Witness │  │ • Defect │  │ Records      │  │ • Medical  │ │
  │  │ • Emplyee │  │   sample │  │              │  │ • Econ/    │ │
  │  │   who saw │  │          │  │ Prior similar│  │   Vocatnl  │ │
  │  │   incident│  │          │  │ incidents    │  │            │ │
  │  └───────────┘  └──────────┘  └─────────────┘  └────────────┘ │
  │                                                                  │
  │  LIABILITY ASSESSMENT:                                           │
  │  ┌────────────────────────────────────────────────────────────┐ │
  │  │  Negligence Elements:                                      │ │
  │  │  1. DUTY — Did insured owe a duty of care?                │ │
  │  │  2. BREACH — Did insured breach that duty?                │ │
  │  │  3. CAUSATION — Did the breach cause the injury?          │ │
  │  │  4. DAMAGES — What are the actual damages?                │ │
  │  │                                                            │ │
  │  │  Comparative Fault Analysis:                               │ │
  │  │  Insured: ___% │ Claimant: ___% │ Third Party: ___%      │ │
  │  └────────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  RESOLUTION PATH                                                 │
  │                                                                  │
  │           ┌──────────────────────────────────┐                  │
  │           │  CLAIM IN LITIGATION?             │                  │
  │           └──────────────┬───────────────────┘                  │
  │                  ┌───────┴───────┐                              │
  │                  ▼               ▼                              │
  │        ┌──────────────┐  ┌──────────────────────────────┐      │
  │        │  PRE-SUIT    │  │  IN SUIT                      │      │
  │        │              │  │                                │      │
  │        │  Negotiate   │  │  Discovery ──▶ Depositions    │      │
  │        │  directly    │  │       │            │          │      │
  │        │  with        │  │       ▼            ▼          │      │
  │        │  claimant/   │  │  Expert Reports  Motions      │      │
  │        │  attorney    │  │       │            │          │      │
  │        │              │  │       ▼            ▼          │      │
  │        │              │  │  Mediation ──▶ Settlement?    │      │
  │        │              │  │       │         ┌──┴──┐       │      │
  │        │              │  │       │        YES    NO      │      │
  │        │              │  │       │         │      │      │      │
  │        │              │  │       │         │   Trial     │      │
  │        │              │  │       │         │      │      │      │
  │        │              │  │       │         │   Verdict   │      │
  │        │              │  │       │         │   or MSJ    │      │
  │        └──────┬───────┘  └───────┼─────────┼──────┼──────┘      │
  │               │                  │         │      │             │
  │               └──────────────────┼─────────┘      │             │
  │                                  │                │             │
  │                                  ▼                ▼             │
  │                        ┌──────────────────────────────┐        │
  │                        │  SETTLEMENT / JUDGMENT        │        │
  │                        │                               │        │
  │                        │  • Execute release            │        │
  │                        │  • Medicare Section 111 query │        │
  │                        │  • Resolve conditional pymts  │        │
  │                        │  • Issue payment              │        │
  │                        │  • Report to reinsurer        │        │
  │                        │    (if > retention)           │        │
  │                        └──────────────────────────────┘        │
  └──────────────────────────────────────────────────────────────────┘
```

---

## 12. Reserving Process

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                         RESERVING PROCESS                                      ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────┐
  │  CLAIM CREATED   │
  │  (FNOL)          │
  └────────┬─────────┘
           │
           ▼
  ┌────────────────────────────────────────────────────────────┐
  │  INITIAL RESERVE (Day 0-2)                                 │
  │                                                            │
  │  Method 1: FORMULA RESERVE (Auto-set)                     │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  Based on:                                        │     │
  │  │  • LOB + Cause of Loss + State                   │     │
  │  │  • Historical average by segment                  │     │
  │  │  • Example: Auto PD in IL, rear-end = $4,500     │     │
  │  └──────────────────────────────────────────────────┘     │
  │                                                            │
  │  Method 2: ML PREDICTED RESERVE (Emerging)                │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  Model inputs: FNOL text, photos, claimant data   │     │
  │  │  Output: P10 = $2,800, P50 = $4,200, P90 = $8,500│     │
  │  │  P50 used as initial reserve                      │     │
  │  └──────────────────────────────────────────────────┘     │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  ADJUSTER RESERVE REVIEW (Day 1-15)                       │
  │                                                            │
  │  Adjuster reviews formula/ML reserve and adjusts:          │
  │                                                            │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  INDEMNITY RESERVE                                │     │
  │  │  ├── Property Damage ......... $XX,XXX            │     │
  │  │  ├── Bodily Injury ........... $XX,XXX            │     │
  │  │  ├── Medical (WC) ............ $XX,XXX            │     │
  │  │  └── Indemnity (WC) .......... $XX,XXX            │     │
  │  │                                                    │     │
  │  │  EXPENSE RESERVE (ALAE)                            │     │
  │  │  ├── Defense Counsel ......... $XX,XXX             │     │
  │  │  ├── Expert Fees ............. $ X,XXX             │     │
  │  │  └── IME / Other ............ $ X,XXX             │     │
  │  └──────────────────────────────────────────────────┘     │
  │                                                            │
  │  Set at ULTIMATE EXPECTED VALUE (avoid staircase)          │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  RESERVE CHANGE TRIGGERS (Ongoing)                        │
  │                                                            │
  │  ┌─────────────────┐  ┌─────────────────────────────────┐ │
  │  │ INCREASE when:  │  │ DECREASE when:                   │ │
  │  │                 │  │                                   │ │
  │  │ • Injuries more │  │ • Liability shifts to claimant   │ │
  │  │   severe than   │  │ • Injuries less severe           │ │
  │  │   expected      │  │ • Treatment plateau reached      │ │
  │  │ • Attorney      │  │ • Subrogation potential          │ │
  │  │   retained      │  │   identified                     │ │
  │  │ • Litigation    │  │ • Settlement below reserve       │ │
  │  │   filed         │  │ • Favorable medical records      │ │
  │  │ • Supplement    │  │ • Partial recovery received      │ │
  │  │   received      │  │                                   │ │
  │  │ • Adverse       │  │                                   │ │
  │  │   jurisdiction  │  │                                   │ │
  │  │ • Expert report │  │                                   │ │
  │  │   unfavorable   │  │                                   │ │
  │  └─────────────────┘  └─────────────────────────────────┘ │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  AUTHORITY & APPROVAL                                      │
  │                                                            │
  │  ┌─────────────────────────────────────────────────────┐  │
  │  │          RESERVE AUTHORITY MATRIX                     │  │
  │  │                                                      │  │
  │  │  Role               │  Authority Limit               │  │
  │  │  ════════════════════│══════════════════════           │  │
  │  │  Junior Adjuster    │  up to $25,000                  │  │
  │  │  Senior Adjuster    │  up to $75,000                  │  │
  │  │  Examiner           │  up to $150,000                 │  │
  │  │  Supervisor         │  up to $250,000                 │  │
  │  │  Manager            │  up to $500,000                 │  │
  │  │  Director           │  up to $1,000,000               │  │
  │  │  VP                 │  up to $5,000,000               │  │
  │  │  Reserve Committee  │  above $5,000,000               │  │
  │  │                                                      │  │
  │  │  Exceeds authority ──▶ Escalation to next level      │  │
  │  └─────────────────────────────────────────────────────┘  │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  MANDATORY RESERVE REVIEWS                                 │
  │                                                            │
  │  ┌──────────────────────────────────────────────────────┐ │
  │  │                                                       │ │
  │  │  Day 30 ──▶ First formal review                      │ │
  │  │  Day 60 ──▶ Second review (complex+)                 │ │
  │  │  Day 90 ──▶ Quarterly review (all open)              │ │
  │  │                                                       │ │
  │  │  Also triggered by:                                   │ │
  │  │  ├── Receipt of medical records / bills              │ │
  │  │  ├── Litigation status change                        │ │
  │  │  ├── Settlement negotiation threshold                │ │
  │  │  ├── Reinsurance notification threshold              │ │
  │  │  └── Supervisor file review                          │ │
  │  │                                                       │ │
  │  └──────────────────────────────────────────────────────┘ │
  └────────────────────────────────────────────────────────────┘
```

---

## 13. Payment & Disbursement

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      PAYMENT & DISBURSEMENT FLOW                               ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────┐
  │  ADJUSTER        │
  │  CREATES PAYMENT │
  │  REQUEST         │
  └────────┬─────────┘
           │
           ▼
  ┌────────────────────────────────────────────────────────────┐
  │  PAYMENT VALIDATION ENGINE                                 │
  │                                                            │
  │  ┌─ CHECK 1: Authority ──────────────────────────────────┐ │
  │  │  Payment amount ≤ adjuster's payment authority?       │ │
  │  │  YES → proceed │ NO → route to supervisor approval    │ │
  │  └──────────────────────────────────────────────────────┘ │
  │                                                            │
  │  ┌─ CHECK 2: Reserve Sufficiency ────────────────────────┐ │
  │  │  Payment ≤ available reserve on exposure?             │ │
  │  │  YES → proceed │ NO → reserve increase required first │ │
  │  └──────────────────────────────────────────────────────┘ │
  │                                                            │
  │  ┌─ CHECK 3: Duplicate Detection ────────────────────────┐ │
  │  │  Same payee + amount + date combination exists?       │ │
  │  │  NO → proceed │ YES → flag for review                 │ │
  │  └──────────────────────────────────────────────────────┘ │
  │                                                            │
  │  ┌─ CHECK 4: OFAC Screening ─────────────────────────────┐ │
  │  │  Payee name/address against OFAC SDN list             │ │
  │  │  CLEAR → proceed │ HIT → hold for compliance review   │ │
  │  └──────────────────────────────────────────────────────┘ │
  │                                                            │
  │  ┌─ CHECK 5: Litigation Hold ────────────────────────────┐ │
  │  │  Claim in active litigation? Payment type = settlement?│ │
  │  │  Requires litigation manager sign-off                  │ │
  │  └──────────────────────────────────────────────────────┘ │
  │                                                            │
  │  ┌─ CHECK 6: Medicare Query ─────────────────────────────┐ │
  │  │  BI settlement ≥ threshold? Claimant Medicare eligible?│ │
  │  │  Must resolve conditional payments before disbursement │ │
  │  └──────────────────────────────────────────────────────┘ │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  APPROVAL ROUTING                                          │
  │                                                            │
  │  Amount < $X,000 ──────────────────▶ Auto-approved         │
  │  Amount $X,001 - $XX,000 ──────────▶ Supervisor approval   │
  │  Amount $XX,001 - $XXX,000 ────────▶ Manager approval      │
  │  Amount > $XXX,000 ────────────────▶ VP / Committee        │
  │                                                            │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  APPROVAL STATUS                                  │     │
  │  │                                                    │     │
  │  │  ┌──────────┐  ┌──────────┐  ┌────────────────┐  │     │
  │  │  │ APPROVED │  │ RETURNED │  │ REJECTED       │  │     │
  │  │  │          │  │          │  │                │  │     │
  │  │  │ Proceed  │  │ Adjuster │  │ Document       │  │     │
  │  │  │ to       │  │ revise & │  │ reason;        │  │     │
  │  │  │ payment  │  │ resubmit │  │ adjuster       │  │     │
  │  │  │          │  │          │  │ reworks claim  │  │     │
  │  │  └──────────┘  └──────────┘  └────────────────┘  │     │
  │  └──────────────────────────────────────────────────┘     │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  DISBURSEMENT                                              │
  │                                                            │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  SELECT PAYMENT METHOD                            │     │
  │  │                                                    │     │
  │  │  ┌──────────┐  ┌────────┐  ┌────────┐  ┌───────┐ │     │
  │  │  │  CHECK   │  │  ACH/  │  │ vCARD  │  │ PUSH  │ │     │
  │  │  │          │  │  EFT   │  │        │  │ TO    │ │     │
  │  │  │ Print &  │  │        │  │ Virtual│  │ DEBIT │ │     │
  │  │  │ mail     │  │ Direct │  │ card # │  │       │ │     │
  │  │  │          │  │ deposit│  │ to     │  │ Real- │ │     │
  │  │  │ 5-10 day │  │        │  │ vendor │  │ time  │ │     │
  │  │  │ delivery │  │ 1-3 day│  │        │  │ to    │ │     │
  │  │  │          │  │        │  │ Instant│  │ debit │ │     │
  │  │  │ Two-party│  │ Saves  │  │        │  │ card  │ │     │
  │  │  │ (+ lien- │  │ $3-8   │  │ Earns  │  │       │ │     │
  │  │  │  holder) │  │ per pmt│  │ rebate │  │ $1-3  │ │     │
  │  │  └──────────┘  └────────┘  └────────┘  └───────┘ │     │
  │  └──────────────────────────────────────────────────┘     │
  │                                                            │
  │  POST-PAYMENT:                                             │
  │  • GL entry posted (debit loss reserve, credit cash)       │
  │  • 1099 tracking updated (if applicable)                   │
  │  • Payment confirmation sent to payee                      │
  │  • Reserve reduced by payment amount                       │
  │  • Reinsurance recovery calculated (if above retention)    │
  └────────────────────────────────────────────────────────────┘
```

---

## 14. Subrogation & Recovery

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      SUBROGATION & RECOVERY FLOW                               ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────┐
  │  CLAIM PAYMENT ISSUED  │
  │  (or during claim)     │
  └──────────┬─────────────┘
             │
             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  SUBROGATION POTENTIAL IDENTIFICATION                        │
  │                                                              │
  │  Auto-Detection Rules:                                       │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │  □ Third party identified at fault (liability > 0%)    │ │
  │  │  □ Police report assigns fault to other party          │ │
  │  │  □ Cause of loss = product defect (mfr identified)     │ │
  │  │  □ Cause of loss = fire with identified origin         │ │
  │  │  □ Property damage caused by contractor/tenant         │ │
  │  │  □ Telematics data shows other-party fault             │ │
  │  │                                                         │ │
  │  │  ANY box checked ──▶ AUTO-REFER to Subro Unit          │ │
  │  └────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  SUBROGATION DEMAND PROCESS                                  │
  │                                                              │
  │  Step 1: Identify responsible party's insurance             │
  │          (via police report, claimant statement,             │
  │           ISO ClaimSearch, CLUE report)                      │
  │                              │                               │
  │                              ▼                               │
  │  Step 2: Send Demand Letter                                 │
  │          ┌──────────────────────────────────────────┐       │
  │          │  TO: Adverse Carrier                      │       │
  │          │  RE: Our insured's claim                  │       │
  │          │  DEMAND: Paid indemnity + deductible      │       │
  │          │          + rental/ALE + LAE (if allowed)  │       │
  │          │  EVIDENCE: Police report, estimate,       │       │
  │          │            photos, payment proof           │       │
  │          │  RESPONSE DUE: 30 days                    │       │
  │          └──────────────────────────────────────────┘       │
  │                              │                               │
  │                              ▼                               │
  │  Step 3: Response Received                                  │
  │          ┌────────────────────────────────────┐             │
  │          │                                     │             │
  │          ▼              ▼              ▼       ▼             │
  │  ┌────────────┐ ┌───────────┐ ┌──────────┐ ┌──────────┐   │
  │  │ FULL PAY   │ │ PARTIAL   │ │ DISPUTE  │ │ NO       │   │
  │  │            │ │ PAY       │ │          │ │ RESPONSE │   │
  │  │ Recovery   │ │           │ │ Liability│ │          │   │
  │  │ received   │ │ Negotiate │ │ or amount│ │ Escalate │   │
  │  │            │ │ or accept │ │ disputed │ │ or file  │   │
  │  │ Apply to   │ │           │ │          │ │ arbitrtn │   │
  │  │ claim      │ │           │ │          │ │          │   │
  │  └─────┬──────┘ └─────┬─────┘ └────┬─────┘ └────┬─────┘   │
  │        │              │            │             │          │
  │        │              │            └──────┬──────┘          │
  │        │              │                   │                 │
  │        │              │                   ▼                 │
  │        │              │   ┌───────────────────────────────┐│
  │        │              │   │  ARBITRATION                   ││
  │        │              │   │                                ││
  │        │              │   │  ┌──────────────────────────┐ ││
  │        │              │   │  │ Arbitration Forums, Inc. │ ││
  │        │              │   │  │ (Member companies)        │ ││
  │        │              │   │  │                           │ ││
  │        │              │   │  │ • Auto: AF Demand Filing │ ││
  │        │              │   │  │ • Property: Special Arb  │ ││
  │        │              │   │  │ • UM PD: UMPIRE program  │ ││
  │        │              │   │  │                           │ ││
  │        │              │   │  │ Decision: Binding on     │ ││
  │        │              │   │  │ both parties             │ ││
  │        │              │   │  └──────────────────────────┘ ││
  │        │              │   └──────────────┬────────────────┘│
  │        │              │                  │                 │
  └────────┼──────────────┼──────────────────┼─────────────────┘
           │              │                  │
           └──────────────┼──────────────────┘
                          │
                          ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  RECOVERY APPLICATION                                        │
  │                                                              │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │  Total Recovery Received .......... $5,200              │ │
  │  │                                                         │ │
  │  │  Application:                                           │ │
  │  │  ├── Insured's Deductible Refund ... $  500             │ │
  │  │  │   (returned to policyholder)                         │ │
  │  │  ├── Carrier Recovery .............. $4,200             │ │
  │  │  │   (offsets paid loss)                                │ │
  │  │  └── Subro Expense Offset .......... $  500             │ │
  │  │      (legal/arb fees if recovered)                      │ │
  │  │                                                         │ │
  │  │  Net incurred on claim reduced by $4,700                │ │
  │  └────────────────────────────────────────────────────────┘ │
  └──────────────────────────────────────────────────────────────┘
```

---

## 15. Fraud Detection (SIU) Pipeline

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                     FRAUD DETECTION (SIU) PIPELINE                             ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────┐
  │  EVERY NEW CLAIM │
  └────────┬─────────┘
           │
           ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  LAYER 1: AUTOMATED SCORING (Real-time at FNOL)               │
  │                                                                │
  │  ┌─────────────────────────────────────────────────────────┐  │
  │  │  INPUT FEATURES                                          │  │
  │  │                                                          │  │
  │  │  ┌──────────────┐ ┌──────────────┐ ┌────────────────┐  │  │
  │  │  │ Claim Data   │ │ Policy Data  │ │ External Data  │  │  │
  │  │  │              │ │              │ │                │  │  │
  │  │  │ • Loss desc  │ │ • Policy age │ │ • ClaimSearch  │  │  │
  │  │  │ • Cause      │ │ • Premium    │ │   prior claims │  │  │
  │  │  │ • Injuries   │ │ • Coverage   │ │ • Credit score │  │  │
  │  │  │ • Time of    │ │   changes    │ │ • Address      │  │  │
  │  │  │   loss       │ │ • Lapse hx   │ │   verification │  │  │
  │  │  │ • Location   │ │ • Bind-to-   │ │ • Social media │  │  │
  │  │  │ • Parties    │ │   loss days  │ │ • Weather data │  │  │
  │  │  └──────────────┘ └──────────────┘ └────────────────┘  │  │
  │  │                         │                                │  │
  │  │                         ▼                                │  │
  │  │  ┌──────────────────────────────────────────────────┐   │  │
  │  │  │  ML MODEL (Gradient Boosting / Neural Network)    │   │  │
  │  │  │                                                    │   │  │
  │  │  │  Output: Fraud Score 0-1000                       │   │  │
  │  │  │  + Top contributing factors                       │   │  │
  │  │  └──────────────────────────────────────────────────┘   │  │
  │  └─────────────────────────────────────────────────────────┘  │
  └──────────────────────────┬─────────────────────────────────────┘
                             │
                ┌────────────┼────────────┐
                ▼            ▼            ▼
     ┌──────────────┐ ┌───────────┐ ┌──────────────┐
     │  LOW RISK    │ │  MEDIUM   │ │  HIGH RISK   │
     │  (0-499)     │ │  (500-749)│ │  (750-1000)  │
     │              │ │           │ │              │
     │  Normal      │ │  SIU WATCH│ │  SIU REFERRAL│
     │  processing  │ │           │ │              │
     │              │ │  Flag on  │ │  Auto-routed │
     │              │ │  claim    │ │  to SIU queue│
     │              │ │  file     │ │              │
     └──────────────┘ └───────────┘ └──────┬───────┘
                                           │
                                           ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  LAYER 2: SIU TRIAGE (SIU Analyst review within 48 hours)    │
  │                                                                │
  │  Analyst reviews:                                              │
  │  ├── Fraud score + contributing factors                       │
  │  ├── ClaimSearch report (prior claims, addresses, parties)    │
  │  ├── NICB alerts (if any)                                     │
  │  ├── Policy history and underwriting data                     │
  │  └── Initial adjuster notes                                   │
  │                                                                │
  │  Decision:                                                     │
  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
  │  │ CLEAR        │  │ INVESTIGATE  │  │ PRIORITY INVESTIGATE │ │
  │  │ (False pos)  │  │ (Standard)   │  │ (Organized ring /    │ │
  │  │              │  │              │  │  large loss fraud)   │ │
  │  │ Return to    │  │ Open SIU     │  │                      │ │
  │  │ normal       │  │ investigation│  │  Dedicated SIU       │ │
  │  │ handling     │  │ file         │  │  investigator        │ │
  │  └──────────────┘  └──────┬───────┘  └──────────┬───────────┘ │
  └────────────────────────────┼─────────────────────┼─────────────┘
                               │                     │
                               └──────────┬──────────┘
                                          │
                                          ▼
  ┌────────────────────────────────────────────────────────────────┐
  │  LAYER 3: SIU INVESTIGATION                                    │
  │                                                                │
  │  ┌────────────┐  ┌──────────────┐  ┌────────────────────────┐ │
  │  │ Recorded   │  │ Social Media │  │ Surveillance           │ │
  │  │ Statement  │  │ / OSINT      │  │ (Physical / Digital)   │ │
  │  │ Analysis   │  │ Investigation│  │                        │ │
  │  └─────┬──────┘  └──────┬───────┘  └───────────┬────────────┘ │
  │        │                │                       │              │
  │  ┌─────▼──────┐  ┌──────▼───────┐  ┌───────────▼────────────┐ │
  │  │ Financial  │  │ Network      │  │ EUO (Examination       │ │
  │  │ Analysis   │  │ Analysis     │  │ Under Oath)            │ │
  │  │ (motive)   │  │ (graph DB)   │  │                        │ │
  │  └─────┬──────┘  └──────┬───────┘  └───────────┬────────────┘ │
  │        └────────────────┼───────────────────────┘              │
  │                         ▼                                      │
  │              ┌──────────────────────┐                          │
  │              │  SIU DETERMINATION   │                          │
  │              └──────────┬───────────┘                          │
  │                         │                                      │
  │          ┌──────────────┼──────────────┐                      │
  │          ▼              ▼              ▼                      │
  │  ┌──────────────┐ ┌───────────┐ ┌──────────────┐            │
  │  │ NO FRAUD     │ │ FRAUD     │ │ FRAUD        │            │
  │  │ FOUND        │ │ CONFIRMED │ │ CONFIRMED    │            │
  │  │              │ │ (Civil)   │ │ (Criminal)   │            │
  │  │ Resume       │ │           │ │              │            │
  │  │ normal       │ │ Deny claim│ │ Deny claim   │            │
  │  │ handling     │ │ Void/     │ │ Refer to     │            │
  │  │              │ │ rescind   │ │ State Fraud   │            │
  │  │              │ │ policy    │ │ Bureau + law  │            │
  │  │              │ │           │ │ enforcement   │            │
  │  │              │ │ Civil     │ │              │            │
  │  │              │ │ recovery  │ │ NICB referral│            │
  │  │              │ │ action    │ │              │            │
  │  └──────────────┘ └───────────┘ └──────────────┘            │
  └────────────────────────────────────────────────────────────────┘
```

---

## 16. Litigation Management

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      LITIGATION MANAGEMENT FLOW                                ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────────────────┐
  │  SUIT PAPERS RECEIVED            │
  │  (Summons + Complaint served     │
  │   on insured or carrier)         │
  └────────────────┬─────────────────┘
                   │
                   ▼
  ┌────────────────────────────────────────────────────────────┐
  │  SUIT INTAKE (Day 0)                                       │
  │                                                            │
  │  1. Log suit in claims system (status → "In Litigation")   │
  │  2. Record court, case #, judge, jurisdiction              │
  │  3. Note answer deadline (typically 20-30 days)            │
  │  4. Perform conflict check on potential defense counsel    │
  │  5. Assign to litigation adjuster/examiner if not already  │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  DEFENSE COUNSEL SELECTION                                 │
  │                                                            │
  │  ┌─────────────────────────────────────────────────────┐  │
  │  │  PANEL SELECTION CRITERIA                            │  │
  │  │                                                      │  │
  │  │  Tier 1 (Routine): Standard BI, simple PD           │  │
  │  │    → Lower-cost panel firm, AFA preferred            │  │
  │  │                                                      │  │
  │  │  Tier 2 (Complex): Multi-party, high exposure        │  │
  │  │    → Experienced litigation firm                     │  │
  │  │                                                      │  │
  │  │  Tier 3 (Trial/Appellate): Trial-ready, appeals      │  │
  │  │    → Top-tier trial counsel                          │  │
  │  │                                                      │  │
  │  │  Tier 4 (Specialty): Coverage, bad faith, class actn │  │
  │  │    → Coverage counsel or specialist firm              │  │
  │  │                                                      │  │
  │  │  Selection factors:                                   │  │
  │  │  • Jurisdiction expertise                            │  │
  │  │  • Subject matter expertise                          │  │
  │  │  • Historical outcomes                               │  │
  │  │  • Cost efficiency                                    │  │
  │  │  • Diversity (many carriers track)                    │  │
  │  └─────────────────────────────────────────────────────┘  │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  INITIAL CASE ASSESSMENT (ICA) — Within 60 days           │
  │                                                            │
  │  Defense counsel submits:                                   │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  1. Liability assessment (% split)                │     │
  │  │  2. Damages evaluation (range: low-mid-high)      │     │
  │  │  3. Coverage issues identified                    │     │
  │  │  4. Key witnesses list                            │     │
  │  │  5. Discovery plan + budget                       │     │
  │  │  6. Recommended resolution strategy               │     │
  │  │  7. Estimated defense cost budget                  │     │
  │  │  8. Trial date (if set)                           │     │
  │  └──────────────────────────────────────────────────┘     │
  └──────────────────────────┬─────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────┐
  │  LITIGATION LIFECYCLE                                      │
  │                                                            │
  │  ┌──────────┐   ┌───────────┐   ┌───────────┐            │
  │  │ PLEADINGS│──▶│ DISCOVERY │──▶│ EXPERT    │            │
  │  │          │   │           │   │ PHASE     │            │
  │  │ Answer   │   │ Interrog  │   │           │            │
  │  │ filed    │   │ Doc req   │   │ Retained  │            │
  │  │          │   │ Depos     │   │ Reports   │            │
  │  │ Counter/ │   │ IME/DME   │   │ Rebuttal  │            │
  │  │ Cross-   │   │ Subpoenas │   │           │            │
  │  │ claim    │   │           │   │           │            │
  │  └──────────┘   └───────────┘   └─────┬─────┘            │
  │                                       │                    │
  │                                       ▼                    │
  │  ┌────────────────────────────────────────────────────┐   │
  │  │  MEDIATION (Often court-ordered or voluntary)       │   │
  │  │                                                      │   │
  │  │  Parties: Carrier rep, insured, claimant, attorneys  │   │
  │  │  Mediator: Neutral third party                       │   │
  │  │  Duration: Typically 1 day                           │   │
  │  │  Success rate: ~60-70% settle at mediation           │   │
  │  │                                                      │   │
  │  │       ┌──────────────────────────────────┐           │   │
  │  │       │         OUTCOME                   │           │   │
  │  │       └───────────────┬──────────────────┘           │   │
  │  │              ┌────────┴────────┐                     │   │
  │  │              ▼                 ▼                     │   │
  │  │     ┌──────────────┐  ┌──────────────┐              │   │
  │  │     │   SETTLED    │  │   IMPASSE    │              │   │
  │  │     │   AT         │  │              │              │   │
  │  │     │   MEDIATION  │  │   Proceed to │              │   │
  │  │     │              │  │   pre-trial  │              │   │
  │  │     │   [Execute   │  │   → trial    │              │   │
  │  │     │    release]  │  │              │              │   │
  │  │     └──────────────┘  └──────┬───────┘              │   │
  │  └──────────────────────────────┼──────────────────────┘   │
  │                                 │                           │
  │                                 ▼                           │
  │  ┌────────────────────────────────────────────────────┐   │
  │  │  TRIAL                                              │   │
  │  │                                                      │   │
  │  │  Pre-Trial ──▶ Jury Selection ──▶ Opening Stmts    │   │
  │  │       │                                              │   │
  │  │       ▼                                              │   │
  │  │  Plaintiff's ──▶ Defendant's ──▶ Closing ──▶ Jury  │   │
  │  │  Case            Case           Arguments   Verdict │   │
  │  │                                                      │   │
  │  │  Post-Verdict:                                       │   │
  │  │  • Accept verdict                                    │   │
  │  │  • Post-trial motions (JNOV, new trial)              │   │
  │  │  • Appeal                                            │   │
  │  └────────────────────────────────────────────────────┘   │
  │                                                            │
  │  LEGAL SPEND TRACKING (throughout):                       │
  │  ┌──────────────────────────────────────────────────┐     │
  │  │  Every invoice reviewed against LMGs:             │     │
  │  │  • Billing rates within guidelines                │     │
  │  │  • Task codes (UTBMS/LEDES format)               │     │
  │  │  • No block billing                               │     │
  │  │  • No excessive research                          │     │
  │  │  • Staffing per litigation plan                   │     │
  │  │  • Budget vs. actual tracking                     │     │
  │  └──────────────────────────────────────────────────┘     │
  └────────────────────────────────────────────────────────────┘
```

---

## 17. Catastrophe (CAT) Operations

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      CATASTROPHE (CAT) OPERATIONS TIMELINE                     ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ════════════════ PRE-EVENT (T-72 to T-0 hours) ════════════════

  ┌────────────────────────────────────────────────────────────────┐
  │  MONITORING & PREPARATION                                      │
  │                                                                │
  │  T-72h  Weather monitoring (NHC, SPC, NWS alerts)             │
  │  T-48h  CAT team activated; war room established               │
  │         Geo-fence affected zip codes against policy database   │
  │         Estimate exposed policies + insured values             │
  │  T-24h  Pre-position resources:                                │
  │         ├── IA firm contracts activated                        │
  │         ├── Managed repair vendor networks alerted             │
  │         ├── Emergency mitigation companies staged              │
  │         └── Mobile claims offices prepared                     │
  │  T-12h  Proactive outreach to policyholders:                   │
  │         ├── SMS/email: "Storm approaching — here's how to     │
  │         │   file a claim"                                      │
  │         ├── Social media posts with safety info                │
  │         └── IVR message updated with CAT info                  │
  │  T-0    EVENT MAKES LANDFALL / OCCURS                         │
  └────────────────────────────────────────────────────────────────┘


  ════════════════ IMMEDIATE RESPONSE (T+0 to T+72 hours) ════════

  ┌────────────────────────────────────────────────────────────────┐
  │  SURGE INTAKE                                                  │
  │                                                                │
  │  Normal daily FNOL:    ~500 claims/day                        │
  │  CAT day 1-3 FNOL:    5,000-50,000+ claims/day               │
  │                                                                │
  │  ┌─────────────────────────────────────────────────────────┐  │
  │  │  INTAKE SCALING                                          │  │
  │  │                                                          │  │
  │  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │  │
  │  │  │ IVR Self-Svc │  │ Chatbot FNOL │  │ Mobile App   │  │  │
  │  │  │ (overflow)   │  │ (AI-guided)  │  │ (photo FNOL) │  │  │
  │  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │  │
  │  │         │                 │                  │          │  │
  │  │         └─────────────────┼──────────────────┘          │  │
  │  │                           ▼                              │  │
  │  │                  ┌──────────────────┐                    │  │
  │  │                  │ Overflow Call     │                    │  │
  │  │                  │ Center (BPO)     │                    │  │
  │  │                  │ activated for    │                    │  │
  │  │                  │ phone volume     │                    │  │
  │  │                  └──────────────────┘                    │  │
  │  └─────────────────────────────────────────────────────────┘  │
  │                                                                │
  │  CAT CODE: PCS-2026-XXXX assigned to all claims from event    │
  │  AUTO-TRIAGE: Aerial imagery pre-scored for severity           │
  └────────────────────────────────────────────────────────────────┘


  ════════════════ SUSTAINED RESPONSE (T+3 to T+90 days) ═════════

  ┌────────────────────────────────────────────────────────────────┐
  │  FIELD OPERATIONS                                              │
  │                                                                │
  │  ┌─────────────────────────────────────────────────────────┐  │
  │  │  ADJUSTER DEPLOYMENT                                     │  │
  │  │                                                          │  │
  │  │  Staff Adjusters ──▶ Handle complex / high-value         │  │
  │  │  IA Firms:                                               │  │
  │  │  ├── Crawford & Company                                  │  │
  │  │  ├── Sedgwick                                            │  │
  │  │  ├── Engle Martin                                        │  │
  │  │  ├── Pilot Catastrophe Services                          │  │
  │  │  └── Various regional IAs                                │  │
  │  │                                                          │  │
  │  │  Daily deployment: 200-2,000 field adjusters             │  │
  │  │  Inspections per adjuster per day: 4-8 (property)        │  │
  │  └─────────────────────────────────────────────────────────┘  │
  │                                                                │
  │  ┌─────────────────────────────────────────────────────────┐  │
  │  │  VIRTUAL vs. FIELD TRIAGE                                │  │
  │  │                                                          │  │
  │  │  Claim Severity    │  Inspection Method                  │  │
  │  │  ══════════════════│═════════════════════════             │  │
  │  │  < $10K estimate   │  Virtual (video/photo)              │  │
  │  │  $10K - $50K       │  Aerial + virtual                   │  │
  │  │  $50K - $250K      │  Field inspection required          │  │
  │  │  > $250K           │  Field + engineering expert          │  │
  │  └─────────────────────────────────────────────────────────┘  │
  │                                                                │
  │  ADVANCE PAYMENTS:                                             │
  │  ┌──────────────────────────────────────────────────────┐     │
  │  │  Emergency ALE advance: $2,000-$5,000 (within 48 hrs)│     │
  │  │  Emergency repairs advance: up to $10,000             │     │
  │  │  (Against policy limits, deducted from final payment) │     │
  │  └──────────────────────────────────────────────────────┘     │
  └────────────────────────────────────────────────────────────────┘


  ════════════════ CLOSEOUT (T+90 to T+365+ days) ════════════════

  ┌────────────────────────────────────────────────────────────────┐
  │  LONG-TAIL MANAGEMENT                                          │
  │                                                                │
  │  • Monitor open inventory daily (target: 80% closed by day 90)│
  │  • Escalate stalled claims (public adjuster disputes,          │
  │    contractor delays, coverage disputes)                       │
  │  • Manage supplemental estimate requests                      │
  │  • Handle recoverable depreciation releases                   │
  │  • Process reinsurance recoveries                              │
  │  • Conduct post-CAT reserving reviews (actuarial)             │
  │  • Capture lessons learned for next event                      │
  │  • Feed data to pricing/underwriting for rate adjustments      │
  │                                                                │
  │  KEY METRICS TRACKED:                                          │
  │  ├── Total FNOL count by day                                  │
  │  ├── Open vs. closed inventory curve                          │
  │  ├── Average cycle time (target: <45 days for simple)         │
  │  ├── Advance payment issuance rate                            │
  │  ├── Customer NPS (post-CAT)                                   │
  │  ├── IA quality scores                                         │
  │  ├── Total incurred vs. initial reserve estimate              │
  │  └── Reinsurance recovery progress                             │
  └────────────────────────────────────────────────────────────────┘
```

---

## 18. Total Loss — Vehicle

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      VEHICLE TOTAL LOSS WORKFLOW                               ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────────┐
  │  TOTAL LOSS THRESHOLD    │
  │  EXCEEDED                │
  │                          │
  │  Repair estimate ≥ 70-80%│
  │  of vehicle ACV          │
  │  (varies by state)       │
  └──────────────┬───────────┘
                 │
                 ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  VEHICLE VALUATION                                           │
  │                                                              │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │  VALUATION METHOD: Comparable Vehicle Analysis          │ │
  │  │                                                         │ │
  │  │  Tools: CCC Valuescope, Mitchell WorkCenter,            │ │
  │  │         JD Power, Kelley Blue Book                      │ │
  │  │                                                         │ │
  │  │  Process:                                               │ │
  │  │  1. Identify 3-5 comparable vehicles within 100mi       │ │
  │  │  2. Match: Year, Make, Model, Trim, Mileage, Options   │ │
  │  │  3. Adjust for:                                         │ │
  │  │     ├── Mileage differential (+/- per mile)             │ │
  │  │     ├── Condition (excellent/good/fair/poor)            │ │
  │  │     ├── Options/equipment differences                   │ │
  │  │     ├── Regional market adjustments                     │ │
  │  │     └── Prior damage (if any, per Carfax/AutoCheck)     │ │
  │  │  4. Average adjusted comparables = ACV                  │ │
  │  │                                                         │ │
  │  │  Example:                                               │ │
  │  │  ┌───────────────────────────────────────────────────┐  │ │
  │  │  │ Comp 1: $22,500 (adj: $22,100)                    │  │ │
  │  │  │ Comp 2: $23,200 (adj: $22,800)                    │  │ │
  │  │  │ Comp 3: $21,800 (adj: $22,300)                    │  │ │
  │  │  │ Comp 4: $22,900 (adj: $22,500)                    │  │ │
  │  │  │ ──────────────────────────────                    │  │ │
  │  │  │ Average ACV: $22,425                              │  │ │
  │  │  └───────────────────────────────────────────────────┘  │ │
  │  └────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  SETTLEMENT CALCULATION                                      │
  │                                                              │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │                                                         │ │
  │  │  ACV ............................ $22,425                │ │
  │  │  (+) Applicable taxes & fees ..... $ 1,682               │ │
  │  │      (sales tax, title, registration — varies by state) │ │
  │  │  (-) Deductible .................. $   500               │ │
  │  │  (-) Prior unrepaired damage ...... $     0               │ │
  │  │  ═══════════════════════════════════════════             │ │
  │  │  TOTAL LOSS SETTLEMENT ........... $23,607               │ │
  │  │                                                         │ │
  │  │  IF LIENHOLDER:                                         │ │
  │  │  ├── Payoff amount: $18,000                             │ │
  │  │  ├── Payment to lienholder: $18,000                     │ │
  │  │  ├── Remaining to insured: $5,607                       │ │
  │  │  │                                                      │ │
  │  │  IF PAYOFF > ACV (Negative equity):                     │ │
  │  │  ├── Payment to lienholder: $23,607 (full ACV)         │ │
  │  │  ├── Insured owes gap: lienholder balance - ACV         │ │
  │  │  └── GAP insurance covers this (if purchased)           │ │
  │  └────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  OWNER NOTIFICATION & NEGOTIATION                            │
  │                                                              │
  │  1. Total loss offer letter sent to insured                  │
  │  2. Valuation report provided (comparables shown)            │
  │  3. Owner has right to:                                      │
  │     ├── Accept offer                                        │
  │     ├── Negotiate (provide own comparables)                 │
  │     ├── Invoke Appraisal clause (if in policy)              │
  │     └── Retain salvage (owner-retained salvage)             │
  │                                                              │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │  OWNER-RETAINED SALVAGE OPTION                          │ │
  │  │                                                         │ │
  │  │  Settlement = ACV - Salvage Value - Deductible          │ │
  │  │  Example:   $22,425 - $4,500 - $500 = $17,425          │ │
  │  │                                                         │ │
  │  │  Owner keeps vehicle; branded title issued               │ │
  │  └────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────┐
  │  TITLE & SALVAGE PROCESS                                     │
  │                                                              │
  │  1. Owner signs title over to carrier                       │
  │  2. Payment issued (to owner and/or lienholder)              │
  │  3. Vehicle picked up by salvage company                     │
  │  4. Title transferred to salvage buyer                       │
  │                                                              │
  │  SALVAGE DISPOSITION:                                        │
  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
  │  │  AUCTION     │  │  DIRECT SALE │  │  PARTS       │      │
  │  │  (Copart /   │  │  (to salvage │  │  RECYCLER    │      │
  │  │   IAA)       │  │   yard)      │  │              │      │
  │  │              │  │              │  │              │      │
  │  │  Most common │  │  When auction│  │  Older /     │      │
  │  │  method      │  │  not viable  │  │  low-value   │      │
  │  │              │  │              │  │  vehicles    │      │
  │  │  Net proceeds│  │              │  │              │      │
  │  │  offset paid │  │              │  │              │      │
  │  │  loss        │  │              │  │              │      │
  │  └──────────────┘  └──────────────┘  └──────────────┘      │
  │                                                              │
  │  DIMINISHED VALUE (Some states — e.g., Georgia):             │
  │  └── Claimant may seek diminished value on third-party      │
  │      claims even for repairable vehicles (post-repair        │
  │      market value reduction)                                 │
  └──────────────────────────────────────────────────────────────┘
```

---

## 19. Straight-Through Processing (STP)

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    STRAIGHT-THROUGH PROCESSING (STP) ENGINE                    ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌───────────────────────────────┐
  │  NEW CLAIM (FNOL COMPLETED)  │
  └──────────────┬────────────────┘
                 │
                 ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  STP ELIGIBILITY GATE                                              │
  │                                                                    │
  │  All conditions must be TRUE to proceed with auto-adjudication:    │
  │                                                                    │
  │  ┌──────────────────────────────────────────────────────────────┐ │
  │  │  □ Policy active and in force on date of loss               │ │
  │  │  □ Coverage confirmed for reported loss type                │ │
  │  │  □ No injuries reported (PD-only claim)                     │ │
  │  │  □ Single vehicle / single peril (no multi-party)           │ │
  │  │  □ Estimated severity below STP threshold ($X,XXX)          │ │
  │  │  □ Fraud score < 300 (low risk)                             │ │
  │  │  □ No prior open claim on same policy                       │ │
  │  │  □ No attorney representation                               │ │
  │  │  □ Claim type in STP-eligible list:                         │ │
  │  │     ├── Auto glass (windshield repair/replace)              │ │
  │  │     ├── Auto comprehensive (theft recovery, animal strike)  │ │
  │  │     ├── Simple auto collision (single vehicle, PD only)     │ │
  │  │     ├── Small water damage (HO, non-CAT)                   │ │
  │  │     ├── WC medical-only (first aid, single visit)           │ │
  │  │     └── Rental reimbursement                                │ │
  │  │  □ All required FNOL fields populated                       │ │
  │  │  □ No SIU referral flag                                     │ │
  │  └──────────────────────────────────────────────────────────────┘ │
  │                                                                    │
  │         ┌─────────────────────────────────────┐                   │
  │         │    ALL CONDITIONS MET?               │                   │
  │         └──────────────────┬──────────────────┘                   │
  │                   ┌────────┴────────┐                              │
  │                   ▼                 ▼                              │
  │          ┌──────────────┐  ┌──────────────┐                       │
  │          │     YES      │  │     NO       │                       │
  │          │  (STP PATH)  │  │  (MANUAL)    │                       │
  │          └──────┬───────┘  └──────┬───────┘                       │
  └─────────────────┼─────────────────┼────────────────────────────────┘
                    │                 │
                    │                 └──▶ Route to adjuster
                    │                     (standard workflow)
                    ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  AUTOMATED PROCESSING (No human touch)                             │
  │                                                                    │
  │  STEP 1: AUTO-RESERVE                                             │
  │  ┌───────────────────────────────────────────┐                    │
  │  │  ML model or rule-based formula sets       │                    │
  │  │  reserve automatically                     │                    │
  │  └───────────────────────────────────────────┘                    │
  │                                                                    │
  │  STEP 2: AUTO-ESTIMATE (for eligible claim types)                 │
  │  ┌───────────────────────────────────────────┐                    │
  │  │  • Glass: Safelite/vendor pricing API      │                    │
  │  │  • Auto PD: AI photo estimate              │                    │
  │  │  • Property: Xactimate auto-estimate       │                    │
  │  └───────────────────────────────────────────┘                    │
  │                                                                    │
  │  STEP 3: AUTO-PAYMENT CALCULATION                                 │
  │  ┌───────────────────────────────────────────┐                    │
  │  │  Estimate amount - Deductible = Payment    │                    │
  │  └───────────────────────────────────────────┘                    │
  │                                                                    │
  │  STEP 4: AUTO-DISBURSE                                            │
  │  ┌───────────────────────────────────────────┐                    │
  │  │  Push-to-debit or ACH to insured           │                    │
  │  │  (or vCard to vendor if DRP/glass shop)    │                    │
  │  └───────────────────────────────────────────┘                    │
  │                                                                    │
  │  STEP 5: AUTO-CLOSE                                               │
  │  ┌───────────────────────────────────────────┐                    │
  │  │  Claim closed with STP flag                │                    │
  │  │  Confirmation sent to insured (email/SMS)  │                    │
  │  │  NPS survey triggered                      │                    │
  │  └───────────────────────────────────────────┘                    │
  │                                                                    │
  │  TOTAL ELAPSED TIME: 15 minutes to 24 hours                       │
  │  (vs. 15-30 days manual)                                           │
  └────────────────────────────────────────────────────────────────────┘
```

---

## 20. Vendor Management Lifecycle

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    VENDOR MANAGEMENT LIFECYCLE                                 ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────┐
  │  VENDOR TYPES IN CLAIMS                                        │
  │                                                                │
  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐          │
  │  │ Auto Body    │ │ Restoration  │ │ Independent  │          │
  │  │ Shops (DRP)  │ │ Contractors  │ │ Adjusters    │          │
  │  └──────────────┘ └──────────────┘ └──────────────┘          │
  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐          │
  │  │ Defense      │ │ Medical      │ │ Salvage      │          │
  │  │ Counsel      │ │ Providers    │ │ (Copart/IAA) │          │
  │  └──────────────┘ └──────────────┘ └──────────────┘          │
  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐          │
  │  │ Appraisers   │ │ Engineers /  │ │ Rental Car   │          │
  │  │              │ │ Experts      │ │ Companies    │          │
  │  └──────────────┘ └──────────────┘ └──────────────┘          │
  └────────────────────────────────────────────────────────────────┘

  VENDOR ASSIGNMENT WORKFLOW:

  ┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
  │  Adjuster    │────▶│  Service Request  │────▶│  Vendor Selected │
  │  Identifies  │     │  Created in       │     │  (Auto-match or  │
  │  Need        │     │  Claims System    │     │   manual)        │
  └──────────────┘     └──────────────────┘     └────────┬─────────┘
                                                          │
       ┌──────────────────────────────────────────────────┘
       │
       ▼
  ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
  │  Assignment Sent │────▶│  Vendor Performs  │────▶│  Deliverable     │
  │  Electronically  │     │  Service          │     │  Received        │
  │  (API / Portal)  │     │  (Inspect, Repair,│     │  (Report, Est,   │
  │                  │     │   Evaluate, etc.) │     │   Invoice)       │
  └──────────────────┘     └──────────────────┘     └────────┬─────────┘
                                                              │
       ┌──────────────────────────────────────────────────────┘
       │
       ▼
  ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
  │  QA Review       │────▶│  Invoice         │────▶│  Payment to      │
  │  (Adjuster       │     │  Approved        │     │  Vendor          │
  │   reviews work)  │     │                  │     │  (vCard / EFT)   │
  └──────────────────┘     └──────────────────┘     └──────────────────┘

  VENDOR SCORECARD METRICS:
  ┌────────────────────────────────────────────────────────────────┐
  │                                                                │
  │  Metric                    │  Target      │  Measured          │
  │  ═════════════════════════ │ ════════════ │ ═══════════════    │
  │  Response Time             │  < 4 hours   │  Monthly           │
  │  Cycle Time (assign→done)  │  < 5 days    │  Monthly           │
  │  Quality Score             │  > 4.0/5.0   │  Random audit      │
  │  Supplement Rate           │  < 20%       │  Monthly           │
  │  Customer Satisfaction     │  > 4.5/5.0   │  Post-service surv │
  │  Cost per Service          │  ≤ benchmark │  Quarterly         │
  │  Compliance Rate           │  100%        │  Continuous        │
  │                                                                │
  └────────────────────────────────────────────────────────────────┘
```

---

## 21. Document & Correspondence Flow

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    DOCUMENT & CORRESPONDENCE FLOW                              ║
╚══════════════════════════════════════════════════════════════════════════════════╝

                    INBOUND DOCUMENTS                    OUTBOUND CORRESPONDENCE
                    ═══════════════                      ═══════════════════════

  ┌──────────────────────┐                   ┌──────────────────────────┐
  │  SOURCES             │                   │  AUTO-GENERATED          │
  │                      │                   │                          │
  │  • Mobile photo      │                   │  • Acknowledgement letter│
  │    upload             │                   │  • Status update letters │
  │  • Email attachments │                   │  • Reservation of Rights │
  │  • Fax (→ eFax)      │                   │  • Denial letters        │
  │  • Postal mail       │                   │  • Settlement offers     │
  │    (→ scan/OCR)      │                   │  • Payment notifications │
  │  • Vendor portals    │                   │  • Release / settlement  │
  │  • Web portal upload │                   │    agreements            │
  │  • EDI / API feeds   │                   │  • Subrogation demands   │
  │                      │                   │  • 1099 forms            │
  └──────────┬───────────┘                   └─────────────┬────────────┘
             │                                              │
             ▼                                              ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │                    DOCUMENT MANAGEMENT SYSTEM                    │
  │                    (Hyland OnBase / OpenText / S3)               │
  │                                                                  │
  │  ┌────────────────────────────────────────────────────────────┐ │
  │  │  PROCESSING PIPELINE                                       │ │
  │  │                                                            │ │
  │  │  Receive ──▶ Classify ──▶ Extract ──▶ Index ──▶ Store     │ │
  │  │     │           │            │           │          │      │ │
  │  │     │      OCR / IDP    Key-value     Metadata    S3 /    │ │
  │  │     │      (ABBYY,     extraction     tagging    Blob     │ │
  │  │  Ingest    Textract)   (NLP/ML)    (claim#,type) Storage  │ │
  │  │                                                            │ │
  │  │  Document Types:                                           │ │
  │  │  ├── Police Reports                                       │ │
  │  │  ├── Medical Records / Bills                              │ │
  │  │  ├── Demand Letters                                       │ │
  │  │  ├── Damage Photos                                        │ │
  │  │  ├── Estimates (CCC/Mitchell/Xactimate)                   │ │
  │  │  ├── Recorded Statements (audio + transcript)             │ │
  │  │  ├── Expert Reports (engineering, IME, forensic)          │ │
  │  │  ├── Legal Pleadings                                      │ │
  │  │  ├── Subpoenas                                            │ │
  │  │  └── Signed Releases                                      │ │
  │  └────────────────────────────────────────────────────────────┘ │
  │                                                                  │
  │  ┌────────────────────────────────────────────────────────────┐ │
  │  │  CORRESPONDENCE GENERATION                                  │ │
  │  │                                                            │ │
  │  │  Template Engine ──▶ Merge claim data ──▶ Generate PDF     │ │
  │  │  (Exstream /         (policy#, name,      ──▶ Send via:   │ │
  │  │   Quadient /          loss details,         ├── Email     │ │
  │  │   Docmosis)           payment amounts)      ├── Portal   │ │
  │  │                                              ├── Print+   │ │
  │  │  GenAI Enhancement:                          │   Mail     │ │
  │  │  LLM drafts custom letters;                  └── SMS link │ │
  │  │  Adjuster reviews + sends                                  │ │
  │  └────────────────────────────────────────────────────────────┘ │
  └──────────────────────────────────────────────────────────────────┘
```

---

## 22. Reinsurance Notification & Recovery

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                  REINSURANCE NOTIFICATION & RECOVERY                           ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────────┐
  │  CLAIM RESERVE SET       │
  │  OR UPDATED              │
  └──────────────┬───────────┘
                 │
                 ▼
  ┌──────────────────────────────────────────────────────┐
  │  THRESHOLD CHECK                                     │
  │                                                      │
  │  Total incurred (reserve + paid) exceeds:           │
  │  ├── Treaty retention? (e.g., $500K per occurrence) │
  │  ├── Facultative attachment? (specific placement)   │
  │  └── CAT treaty trigger? (aggregate event losses)   │
  └──────────────────┬───────────────────────────────────┘
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
  ┌──────────────┐      ┌──────────────────────────────┐
  │  BELOW       │      │  EXCEEDS THRESHOLD            │
  │  THRESHOLD   │      │                               │
  │              │      │  1. Notify reinsurer(s)       │
  │  No action   │      │     within 72 hours           │
  │  required    │      │                               │
  │              │      │  2. Provide:                  │
  │              │      │     • Claim summary           │
  │              │      │     • Current reserves        │
  │              │      │     • Investigation status    │
  │              │      │     • Coverage analysis       │
  │              │      │                               │
  │              │      │  3. Ongoing updates:          │
  │              │      │     • Reserve changes         │
  │              │      │     • Payment activity        │
  │              │      │     • Settlement authority    │
  │              │      │       requests                │
  │              │      │                               │
  │              │      │  4. Recovery billing:         │
  │              │      │     Submit bordereau or       │
  │              │      │     individual claim bills    │
  │              │      │     per treaty terms          │
  └──────────────┘      └──────────────────────────────┘
```

---

## 23. Claim Closure & Reopen

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                      CLAIM CLOSURE & REOPEN WORKFLOW                           ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌───────────────────────────────────────────────────────────────┐
  │  CLOSURE READINESS CHECKLIST                                  │
  │                                                               │
  │  □ All coverage decisions made and documented                │
  │  □ All exposures resolved (paid, denied, or withdrawn)       │
  │  □ All reserves = $0 (reserve equals paid, or excess zeroed) │
  │  □ All payments issued and cleared                           │
  │  □ All subrogation pursued or waived (documented)            │
  │  □ All salvage disposed                                      │
  │  □ No outstanding activities or diary items                  │
  │  □ Medicare Section 111 reporting complete (if applicable)   │
  │  □ 1099 generated (if applicable)                            │
  │  □ File documentation complete (notes, photos, reports)      │
  │  □ Reinsurance reporting current                             │
  │  □ Supervisor review completed (if required by authority)    │
  └──────────────────────────────┬────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
          ┌──────────────────┐      ┌──────────────────┐
          │  ALL ITEMS       │      │  ITEMS REMAIN    │
          │  COMPLETE        │      │  OUTSTANDING     │
          │                  │      │                  │
          │  Close claim     │      │  Return to       │
          │  Status → CLOSED │      │  adjuster;       │
          │                  │      │  complete items   │
          └────────┬─────────┘      └──────────────────┘
                   │
                   ▼
          ┌──────────────────────────────────────────────┐
          │  POST-CLOSURE                                 │
          │                                               │
          │  • Financial records finalized                │
          │  • Claim data feeds to:                      │
          │    ├── Data warehouse (analytics)             │
          │    ├── Actuarial triangles (development)      │
          │    ├── ISO statistical reporting              │
          │    └── NCCI unit statistical (WC)             │
          │  • Quality audit eligible (random selection)  │
          │  • NPS / CSAT survey sent to policyholder    │
          └──────────────────┬───────────────────────────┘
                             │
                             ▼
          ┌──────────────────────────────────────────────┐
          │  REOPEN TRIGGERS                              │
          │                                               │
          │  ┌─────────────────────────────────────────┐ │
          │  │  • Supplemental damage discovered        │ │
          │  │  • New medical treatment (WC)            │ │
          │  │  • Lawsuit filed after closure           │ │
          │  │  • Additional claimant surfaces          │ │
          │  │  • Subrogation recovery received         │ │
          │  │  • Regulatory complaint requires review  │ │
          │  │  • Audit finding requires correction     │ │
          │  │  • Reinsurer requests additional info    │ │
          │  └─────────────────────────────────────────┘ │
          │                                               │
          │  REOPEN PROCESS:                              │
          │  1. Adjuster/supervisor reopens claim         │
          │  2. Status → REOPENED                         │
          │  3. New reserve established if needed         │
          │  4. New exposure created if new claimant      │
          │  5. Investigation resumes                     │
          │  6. Reopen reason documented                  │
          │  7. Reopen rate tracked as KPI (target: <5%)  │
          └──────────────────────────────────────────────┘
```

---

## 24. Regulatory Compliance — Diary & Deadlines

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                 REGULATORY COMPLIANCE — DIARY ENGINE                           ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────────────────┐
  │  AUTOMATED DIARY SYSTEM (Tracks all regulatory deadlines per state)       │
  │                                                                           │
  │  ┌─────────────────────────────────────────────────────────────────────┐  │
  │  │                                                                      │  │
  │  │  EVENT                        DIARY CREATED          DEADLINE        │  │
  │  │  ═════                        ═════════════          ════════        │  │
  │  │                                                                      │  │
  │  │  FNOL Received ──────────────▶ Acknowledge claim ──▶ +15 cal days   │  │
  │  │                                                                      │  │
  │  │  FNOL Received ──────────────▶ First contact ──────▶ +24 hours      │  │
  │  │                               with insured           (best practice)│  │
  │  │                                                                      │  │
  │  │  Coverage Issue ─────────────▶ Issue ROR letter ───▶ +15 cal days   │  │
  │  │  Identified                                          (ASAP)         │  │
  │  │                                                                      │  │
  │  │  Investigation ──────────────▶ Coverage decision ──▶ +30 cal days   │  │
  │  │  Complete                                            (varies)       │  │
  │  │                                                                      │  │
  │  │  No Activity ────────────────▶ Status update to ───▶ Every 30 days  │  │
  │  │  on File                      insured/claimant       (some: 45 days)│  │
  │  │                                                                      │  │
  │  │  Settlement ─────────────────▶ Issue payment ──────▶ +30 cal days   │  │
  │  │  Agreed                                              (some: +15)    │  │
  │  │                                                                      │  │
  │  │  Claim Denied ───────────────▶ Written denial ─────▶ Immediately    │  │
  │  │                               with policy language   with decision  │  │
  │  │                                                                      │  │
  │  │  Fraud Indicators ──────────▶ SIU referral ────────▶ +5 bus days    │  │
  │  │  Identified                                                          │  │
  │  │                                                                      │  │
  │  │  Claim Opened ───────────────▶ Track Statute of ───▶ Per state law  │  │
  │  │                               Limitations            (2-6 years)    │  │
  │  │                                                                      │  │
  │  │  DOI Complaint ──────────────▶ Response to DOI ────▶ +15-30 cal days│  │
  │  │  Received                                                            │  │
  │  │                                                                      │  │
  │  │  BI Settlement ─────────────▶ Medicare query ──────▶ Before payment │  │
  │  │  Pending                      (Section 111)                          │  │
  │  │                                                                      │  │
  │  │  Reserve > $X ───────────────▶ Supervisor review ──▶ Per authority  │  │
  │  │                                                      matrix         │  │
  │  │                                                                      │  │
  │  │  Year End ───────────────────▶ Annual reserve ─────▶ Dec 31        │  │
  │  │                               adequacy review                       │  │
  │  └─────────────────────────────────────────────────────────────────────┘  │
  │                                                                           │
  │  ESCALATION PATH (when deadline approaching):                            │
  │                                                                           │
  │  Day-5 ──▶ Yellow alert to adjuster                                     │
  │  Day-2 ──▶ Orange alert to adjuster + supervisor                        │
  │  Day-0 ──▶ Red alert to supervisor + manager                            │
  │  Overdue ─▶ Executive notification + compliance log entry               │
  │                                                                           │
  └────────────────────────────────────────────────────────────────────────────┘
```

---

## 25. Data Flow — End to End System Integration

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║               END-TO-END SYSTEM DATA FLOW                                      ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │  MOBILE  │  │   WEB    │  │  PHONE   │  │  AGENT   │  │   EDI    │
  │   APP    │  │  PORTAL  │  │  (IVR+   │  │  PORTAL  │  │  FEEDS   │
  │          │  │          │  │  Agent)   │  │          │  │          │
  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘
       │             │             │             │             │
       └─────────────┴─────────────┴──────┬──────┴─────────────┘
                                          │
                                          ▼
                              ┌────────────────────┐
                              │   API GATEWAY       │
                              │   (Kong / AWS APIGW)│
                              └─────────┬──────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    │                   │                   │
                    ▼                   ▼                   ▼
          ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
          │    FNOL      │   │   CLAIMS     │   │   PAYMENT    │
          │   SERVICE    │   │   CORE       │   │   SERVICE    │
          │              │   │  (ClaimCtr)  │   │              │
          └──────┬───────┘   └──────┬───────┘   └──────┬───────┘
                 │                  │                   │
       ┌─────────┘    ┌─────────────┼─────────────┐    └──────────┐
       ▼              ▼             ▼             ▼               ▼
  ┌─────────┐  ┌───────────┐ ┌───────────┐ ┌───────────┐  ┌──────────┐
  │ POLICY  │  │   ISO     │ │  FRAUD    │ │  VENDOR   │  │ BANK /   │
  │ ADMIN   │  │  CLAIM    │ │  SCORING  │ │  MGMT     │  │ TREASURY │
  │ SYSTEM  │  │  SEARCH   │ │  ENGINE   │ │  PLATFORM │  │          │
  │         │  │           │ │  (ML)     │ │           │  │ ACH/Check│
  │ Coverage│  │ Prior     │ │           │ │ CCC /     │  │ Wire /   │
  │ Limits  │  │ claims    │ │ Score +   │ │ Mitchell /│  │ vCard    │
  │ Deduct  │  │ Fraud     │ │ factors   │ │ Xactimate │  │          │
  └─────────┘  │ flags     │ │           │ │ Legal     │  └──────────┘
               └───────────┘ └───────────┘ │ Medical   │
                                           └───────────┘
                                    │
                                    │ All events published to:
                                    ▼
                    ┌──────────────────────────────────┐
                    │       EVENT BUS (KAFKA)           │
                    │                                    │
                    │  Topics:                           │
                    │  • claim.created                   │
                    │  • claim.updated                   │
                    │  • exposure.created                │
                    │  • reserve.changed                 │
                    │  • payment.issued                  │
                    │  • document.uploaded                │
                    │  • fraud.score.computed             │
                    │  • vendor.assignment.completed      │
                    │  • claim.closed                     │
                    └───────────────┬──────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
          ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
          │   DATA       │ │  REAL-TIME   │ │  REGULATORY  │
          │   WAREHOUSE  │ │  DASHBOARDS  │ │  REPORTING   │
          │  (Snowflake) │ │  (Tableau/   │ │              │
          │              │ │   PowerBI)   │ │  ISO Stat    │
          │  Actuarial   │ │              │ │  NCCI        │
          │  Analytics   │ │  Ops metrics │ │  CMS Sec 111 │
          │  ML Training │ │  Exec KPIs   │ │  State filings│
          │  BI Reports  │ │  CAT tracker │ │              │
          └──────────────┘ └──────────────┘ └──────────────┘
```

---

## 26. AI/ML Pipeline in Claims

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                       AI/ML PIPELINE IN CLAIMS                                 ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌────────────────────────────────────────────────────────────────────┐
  │  DATA SOURCES                                                      │
  │                                                                    │
  │  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌──────────────┐  │
  │  │ Claims DB  │ │ Documents  │ │ Photos /   │ │ External     │  │
  │  │ (structure)│ │ (text)     │ │ Images     │ │ Data         │  │
  │  │            │ │            │ │            │ │              │  │
  │  │ Financials │ │ Adj notes  │ │ Vehicle    │ │ ClaimSearch  │  │
  │  │ Parties    │ │ Med records│ │ damage     │ │ Weather      │  │
  │  │ Coverages  │ │ Police rpts│ │ Property   │ │ Telematics   │  │
  │  │ Codes      │ │ Demands    │ │ damage     │ │ Aerial img   │  │
  │  └──────┬─────┘ └──────┬─────┘ └──────┬─────┘ └──────┬───────┘  │
  └─────────┼──────────────┼──────────────┼──────────────┼────────────┘
            └──────────────┼──────────────┼──────────────┘
                           │              │
                           ▼              ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  FEATURE ENGINEERING & STORE                                       │
  │                                                                    │
  │  ┌──────────────────────────────────────────────────────────────┐ │
  │  │  Feature Store (Feast / Tecton / SageMaker Feature Store)    │ │
  │  │                                                              │ │
  │  │  Features:                                                    │ │
  │  │  ├── Claim features: cause, LOB, state, loss_amount          │ │
  │  │  ├── Party features: age, prior_claims, credit_score         │ │
  │  │  ├── Text features: NLP embeddings from loss description     │ │
  │  │  ├── Image features: CNN embeddings from damage photos       │ │
  │  │  ├── Temporal: day_of_week, month, time_since_policy_start   │ │
  │  │  ├── Network: connected_parties_count, shared_addresses      │ │
  │  │  └── External: weather_severity, traffic_density             │ │
  │  └──────────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  MODEL TRAINING & REGISTRY                                         │
  │                                                                    │
  │  ┌──────────────────┐  ┌──────────────────┐  ┌────────────────┐  │
  │  │ FRAUD MODEL      │  │ SEVERITY MODEL   │  │ LITIGATION     │  │
  │  │                  │  │                  │  │ PROPENSITY     │  │
  │  │ XGBoost /        │  │ Gradient Boost / │  │ MODEL          │  │
  │  │ Neural Net       │  │ Random Forest    │  │                │  │
  │  │                  │  │                  │  │ Logistic Reg / │  │
  │  │ Output: Score    │  │ Output: $ range  │  │ GBM            │  │
  │  │ 0-1000           │  │ P10, P50, P90    │  │                │  │
  │  │                  │  │                  │  │ Output: Prob   │  │
  │  │ Retrain: Monthly │  │ Retrain: Qtrly   │  │ 0.0-1.0        │  │
  │  └──────────────────┘  └──────────────────┘  └────────────────┘  │
  │                                                                    │
  │  ┌──────────────────┐  ┌──────────────────┐  ┌────────────────┐  │
  │  │ PHOTO AI         │  │ NLP EXTRACTION   │  │ RESERVE        │  │
  │  │ (Computer Vision)│  │                  │  │ PREDICTION     │  │
  │  │                  │  │ Transformer /    │  │                │  │
  │  │ CNN / Vision     │  │ BERT fine-tuned  │  │ Gradient Boost │  │
  │  │ Transformer      │  │                  │  │ + Deep Learning│  │
  │  │                  │  │ Output: Entities,│  │                │  │
  │  │ Output: Damage   │  │ classifications, │  │ Output:        │  │
  │  │ components +     │  │ sentiment        │  │ Ultimate cost  │  │
  │  │ severity         │  │                  │  │ prediction     │  │
  │  └──────────────────┘  └──────────────────┘  └────────────────┘  │
  │                                                                    │
  │  All models registered in MLflow / SageMaker Model Registry       │
  │  Versioned, A/B tested, champion-challenger framework              │
  └──────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  MODEL SERVING (Real-time + Batch)                                 │
  │                                                                    │
  │  Real-time API:                                                    │
  │  ┌──────────────────────────────────────────────────────────────┐ │
  │  │  POST /api/v1/score                                          │ │
  │  │  {                                                           │ │
  │  │    "claim_id": "CLM-2026-0001234",                          │ │
  │  │    "model": "fraud_v3.2",                                    │ │
  │  │    "features": { ... }                                       │ │
  │  │  }                                                           │ │
  │  │  ──▶ Response: { "score": 782, "risk": "HIGH",              │ │
  │  │        "top_factors": ["new_policy", "high_severity",        │ │
  │  │         "prior_claims_3yr"] }                                │ │
  │  └──────────────────────────────────────────────────────────────┘ │
  │                                                                    │
  │  Batch scoring: Nightly re-score open inventory for               │
  │  reserve adequacy, severity changes, fraud re-evaluation          │
  └──────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────────────────┐
  │  MONITORING & DRIFT DETECTION                                      │
  │                                                                    │
  │  ┌──────────────────────────────────────────────────────────────┐ │
  │  │  METRICS TRACKED                                              │ │
  │  │                                                              │ │
  │  │  • Prediction accuracy (AUC, F1, MAE) vs. actuals           │ │
  │  │  • Feature drift (population stability index - PSI)         │ │
  │  │  • Concept drift (actual fraud rate vs. predicted)          │ │
  │  │  • Latency (P50, P99 response time)                        │ │
  │  │  • Throughput (scores per second)                           │ │
  │  │  • False positive / false negative rates                    │ │
  │  │  • Override rate (adjuster disagrees with model)            │ │
  │  │                                                              │ │
  │  │  Alert if PSI > 0.2 or AUC drops > 5% ──▶ Retrain trigger  │ │
  │  └──────────────────────────────────────────────────────────────┘ │
  └────────────────────────────────────────────────────────────────────┘
```

---

## 27. Cyber Liability Claim — Incident Response

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                 CYBER LIABILITY — INCIDENT RESPONSE WORKFLOW                   ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌───────────────────┐
  │  CYBER INCIDENT   │
  │  DETECTED         │
  │  (Ransomware,     │
  │   Data Breach,    │
  │   BEC, DDoS)      │
  └─────────┬─────────┘
            │
            ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  HOUR 0-4: IMMEDIATE RESPONSE                                  │
  │                                                                 │
  │  1. Insured calls 24/7 cyber claim hotline                    │
  │  2. FNOL created with CRITICAL priority flag                   │
  │  3. Breach Coach (attorney) engaged immediately                │
  │     └── Attorney-client privilege established                  │
  │         (all communications through counsel)                    │
  │  4. Forensics vendor deployed                                  │
  │     ├── CrowdStrike, Mandiant, Kroll, Secureworks             │
  │     └── Remote containment begins                              │
  │  5. Coverage analysis initiated:                               │
  │     ├── Policy form reviewed (claims-made trigger)             │
  │     ├── Sublimits identified (ransomware, BI, notification)   │
  │     ├── Retroactive date verified                              │
  │     └── Prior knowledge exclusion assessed                     │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  HOUR 4-72: CONTAINMENT & INVESTIGATION                        │
  │                                                                 │
  │  ┌──────────────────┐  ┌──────────────────┐                   │
  │  │  FORENSICS       │  │  RANSOM HANDLING  │                   │
  │  │                  │  │  (if ransomware)  │                   │
  │  │  • Identify      │  │                   │                   │
  │  │    attack vector │  │  • OFAC screening │                   │
  │  │  • Contain       │  │    of threat      │                   │
  │  │    spread        │  │    actor group    │                   │
  │  │  • Preserve      │  │  • Ransom         │                   │
  │  │    evidence      │  │    negotiation    │                   │
  │  │  • Determine     │  │    specialist     │                   │
  │  │    data exposure │  │    engaged        │                   │
  │  │  • Timeline      │  │  • Negotiate      │                   │
  │  │    reconstruction│  │    demand down    │                   │
  │  │                  │  │  • Carrier        │                   │
  │  └──────────────────┘  │    approves       │                   │
  │                        │    payment        │                   │
  │                        │  • Cryptocurrency │                   │
  │                        │    payment        │                   │
  │                        │    facilitated    │                   │
  │                        └──────────────────┘                   │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  DAY 3-30: REMEDIATION & NOTIFICATION                          │
  │                                                                 │
  │  ┌───────────────────────────────────────────────────────────┐ │
  │  │  SYSTEM RESTORATION                                        │ │
  │  │  • Decrypt systems (if ransom paid + decryption key)      │ │
  │  │  • Restore from clean backups                              │ │
  │  │  • Patch vulnerabilities                                   │ │
  │  │  • Rebuild compromised systems                             │ │
  │  │  • Validate integrity before reconnection                  │ │
  │  └───────────────────────────────────────────────────────────┘ │
  │                                                                 │
  │  ┌───────────────────────────────────────────────────────────┐ │
  │  │  DATA BREACH NOTIFICATION (if PII/PHI exposed)            │ │
  │  │                                                            │ │
  │  │  Privacy counsel determines:                               │ │
  │  │  ├── Which state laws triggered (50 state patchwork)      │ │
  │  │  ├── Federal laws (HIPAA if PHI, GLBA if financial)       │ │
  │  │  ├── International (GDPR if EU data subjects)             │ │
  │  │  └── Notification timeline (30-90 days depending on state)│ │
  │  │                                                            │ │
  │  │  Notification vendor engaged:                              │ │
  │  │  ├── Mail notification letters to affected individuals    │ │
  │  │  ├── Set up call center for inquiries                     │ │
  │  │  ├── Provide credit monitoring (12-24 months)             │ │
  │  │  └── Identity theft insurance offered                      │ │
  │  │                                                            │ │
  │  │  Regulatory notifications:                                 │ │
  │  │  ├── State Attorneys General                               │ │
  │  │  ├── HHS (if HIPAA breach > 500 records)                  │ │
  │  │  ├── SEC (if publicly traded, material impact)            │ │
  │  │  └── FTC / CFPB (if consumer financial data)              │ │
  │  └───────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬──────────────────────────────────────┘
                             │
                             ▼
  ┌─────────────────────────────────────────────────────────────────┐
  │  DAY 30-365+: LONG-TAIL MANAGEMENT                             │
  │                                                                 │
  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
  │  │ BUSINESS INCOME  │  │ REGULATORY       │  │ THIRD-PARTY  │ │
  │  │ LOSS             │  │ PROCEEDINGS      │  │ LAWSUITS     │ │
  │  │                  │  │                  │  │              │ │
  │  │ Forensic acct    │  │ State AG         │  │ Class action │ │
  │  │ calculates BI:   │  │ investigations   │  │ by affected  │ │
  │  │ • Revenue loss   │  │ Defense costs    │  │ individuals  │ │
  │  │ • Extra expense  │  │ Potential fines  │  │ Shareholder  │ │
  │  │ • Waiting period │  │ Consent orders   │  │ derivative   │ │
  │  │ • Period of      │  │                  │  │ suits        │ │
  │  │   restoration    │  │                  │  │              │ │
  │  └──────────────────┘  └──────────────────┘  └──────────────┘ │
  │                                                                 │
  │  TOTAL CLAIM COMPONENTS:                                       │
  │  ┌──────────────────────────────────────────────────────────┐  │
  │  │  Forensics ........................ $  400,000            │  │
  │  │  Ransom payment ................... $  800,000            │  │
  │  │  Business income loss ............. $1,200,000            │  │
  │  │  Notification costs ............... $2,250,000            │  │
  │  │  Credit monitoring ................ $  500,000            │  │
  │  │  Legal / breach coach ............. $  350,000            │  │
  │  │  Crisis PR / communications ....... $  100,000            │  │
  │  │  Regulatory defense ............... $  200,000            │  │
  │  │  Third-party lawsuit defense ...... $  500,000            │  │
  │  │  ──────────────────────────────────────────────          │  │
  │  │  TOTAL CLAIM ...................... $6,300,000            │  │
  │  └──────────────────────────────────────────────────────────┘  │
  └─────────────────────────────────────────────────────────────────┘
```

---

## 28. Medicare Section 111 Reporting

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                   MEDICARE SECTION 111 REPORTING WORKFLOW                       ║
╚══════════════════════════════════════════════════════════════════════════════════╝

  ┌──────────────────────────────────────┐
  │  BI or WC CLAIM WITH SETTLEMENT     │
  │  PENDING                             │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  STEP 1: MEDICARE ELIGIBILITY QUERY                              │
  │                                                                  │
  │  Query CMS (Centers for Medicare & Medicaid Services):          │
  │  ├── Claimant SSN + DOB + Name + Gender                        │
  │  ├── Submit via MMSEA Section 111 query process                 │
  │  └── Response: Medicare beneficiary? [YES / NO]                 │
  │                                                                  │
  │       ┌──────────────────────────────────┐                      │
  │       │    MEDICARE BENEFICIARY?          │                      │
  │       └──────────────────┬───────────────┘                      │
  │                ┌─────────┴─────────┐                            │
  │                ▼                   ▼                            │
  │       ┌──────────────┐    ┌──────────────┐                     │
  │       │     YES      │    │     NO       │                     │
  │       │              │    │              │                     │
  │       │  Additional  │    │  Proceed     │                     │
  │       │  steps       │    │  with normal │                     │
  │       │  required    │    │  settlement  │                     │
  │       └──────┬───────┘    └──────────────┘                     │
  └──────────────┼──────────────────────────────────────────────────┘
                 │
                 ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  STEP 2: CONDITIONAL PAYMENT CHECK                               │
  │                                                                  │
  │  Has Medicare paid any medical bills related to this injury?    │
  │                                                                  │
  │  Query BCRC (Benefits Coordination & Recovery Center):          │
  │  ├── Request conditional payment information                    │
  │  ├── BCRC provides list of payments Medicare made               │
  │  └── These must be repaid from settlement proceeds              │
  │                                                                  │
  │  ┌────────────────────────────────────────────────────────────┐ │
  │  │  CONDITIONAL PAYMENT SUMMARY                                │ │
  │  │                                                             │ │
  │  │  Medicare paid:                                             │ │
  │  │  ├── ER visit ..................... $ 3,200                  │ │
  │  │  ├── Orthopedic surgery ........... $12,500                  │ │
  │  │  ├── Physical therapy (12 visits) . $ 2,400                  │ │
  │  │  ├── MRI .......................... $ 1,800                  │ │
  │  │  ──────────────────────────────────────────                 │ │
  │  │  Total conditional payments: $19,900                        │ │
  │  │                                                             │ │
  │  │  Carrier must resolve these before or at settlement         │ │
  │  └────────────────────────────────────────────────────────────┘ │
  └──────────────────────────┬───────────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  STEP 3: MEDICARE SET-ASIDE (MSA) — If Applicable               │
  │                                                                  │
  │  Required when:                                                  │
  │  ├── Workers' Comp settlement closing future medical            │
  │  ├── Certain liability settlements with ongoing treatment       │
  │  └── Claimant is Medicare-eligible or will be within 30 months  │
  │                                                                  │
  │  Process:                                                        │
  │  1. Engage MSA vendor (MSAA, Ametros, Garretson)               │
  │  2. Vendor projects future Medicare-covered treatment costs     │
  │  3. MSA amount calculated and funds set aside                   │
  │  4. Optional: Submit to CMS for review/approval                │
  │     (recommended for WC settlements > $250K if beneficiary,    │
  │      or > $25K if future beneficiary within 30 months)         │
  │  5. MSA funds placed in trust or self-administered account     │
  │  6. Claimant uses MSA funds for Medicare-covered treatment     │
  │     before Medicare pays                                        │
  └──────────────────────────┬───────────────────────────────────────┘
                             │
                             ▼
  ┌──────────────────────────────────────────────────────────────────┐
  │  STEP 4: SECTION 111 REPORTING TO CMS                           │
  │                                                                  │
  │  Carrier (as RRE — Responsible Reporting Entity) must:          │
  │                                                                  │
  │  Report quarterly to CMS:                                        │
  │  ┌────────────────────────────────────────────────────────────┐ │
  │  │  CLAIM INFORMATION REPORTED                                 │ │
  │  │                                                             │ │
  │  │  • RRE ID and TIN                                          │ │
  │  │  • Claimant: SSN, DOB, Name, Gender                       │ │
  │  │  • Claim type (WC, Liability, No-Fault)                    │ │
  │  │  • Date of incident                                        │ │
  │  │  • ICD diagnosis codes                                     │ │
  │  │  • Settlement date and amount                               │ │
  │  │  • ORM (Ongoing Responsibility for Medical) indicator      │ │
  │  │  • ORM termination date                                     │ │
  │  │  • TPOC (Total Payment Obligation to Claimant) amount      │ │
  │  │  • TPOC date                                                │ │
  │  │  • No-fault insurance limit (if applicable)                 │ │
  │  │  • Exhaust date (if applicable)                             │ │
  │  └────────────────────────────────────────────────────────────┘ │
  │                                                                  │
  │  Format: Electronic file per CMS specifications                 │
  │  Timing: Quarterly submission windows                           │
  │  Penalties: Up to $1,000/day per unreported claim               │
  └──────────────────────────────────────────────────────────────────┘
```

---

*This document provides visual workflow references for all major P&C claims processes. Use alongside the main [README.md](README.md) for comprehensive interview preparation and domain understanding.*
