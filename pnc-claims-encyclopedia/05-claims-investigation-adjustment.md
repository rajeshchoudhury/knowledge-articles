# Claims Investigation & Adjustment: Complete Guide

> **Audience:** Solutions Architects designing and building Property & Casualty claims systems.
> **Version:** 1.0 | **Last Updated:** 2026-04-16

---

## Table of Contents

1. [Investigation Process Overview](#1-investigation-process-overview)
2. [Adjuster Types & Specializations](#2-adjuster-types--specializations)
3. [Assignment & Workload Management](#3-assignment--workload-management)
4. [Investigation Checklists by Claim Type](#4-investigation-checklists-by-claim-type)
5. [Recorded Statement Process](#5-recorded-statement-process)
6. [Scene Inspection & Documentation](#6-scene-inspection--documentation)
7. [Evidence Collection & Chain of Custody](#7-evidence-collection--chain-of-custody)
8. [Police Report Integration](#8-police-report-integration)
9. [Medical Record Review for Injury Claims](#9-medical-record-review-for-injury-claims)
10. [Independent Medical Examination (IME)](#10-independent-medical-examination-ime)
11. [Damage Estimation — Auto](#11-damage-estimation--auto)
12. [Damage Estimation — Property](#12-damage-estimation--property)
13. [Bodily Injury Evaluation](#13-bodily-injury-evaluation)
14. [Liability Determination Frameworks](#14-liability-determination-frameworks)
15. [Statement Analysis & Consistency Checking](#15-statement-analysis--consistency-checking)
16. [Timeline Reconstruction](#16-timeline-reconstruction)
17. [Expert Engagement](#17-expert-engagement)
18. [Investigation Technology](#18-investigation-technology)
19. [Activity Tracking & Diary Management](#19-activity-tracking--diary-management)
20. [Authority Levels & Approval Workflows](#20-authority-levels--approval-workflows)
21. [Investigation Report Templates & Data Structures](#21-investigation-report-templates--data-structures)
22. [Quality Assurance & Audit Processes](#22-quality-assurance--audit-processes)
23. [Performance Metrics for Adjusters](#23-performance-metrics-for-adjusters)

---

## 1. Investigation Process Overview

### 1.1 Investigation Types

| Type | Description | When Used | Duration |
|---|---|---|---|
| **Desk Review** | Investigation conducted from the office using phone, email, documents, photos | Simple/moderate claims; initial review of all claims | Days to weeks |
| **Field Investigation** | On-site inspection by adjuster at loss location | Property damage (moderate/large), auto damage (complex), liability claims | Days to weeks |
| **Specialist Investigation** | Investigation by subject matter expert (engineer, forensic accountant, etc.) | Complex causation, large losses, disputed claims | Weeks to months |
| **SIU Investigation** | Formal fraud investigation by Special Investigations Unit | Claims with fraud indicators above threshold | Weeks to months |
| **Litigation Investigation** | Investigation conducted in context of pending or anticipated litigation | Litigated claims, pre-suit investigation of complex claims | Months to years |

### 1.2 Investigation Process Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│                    INVESTIGATION MASTER FLOW                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────┐   ┌──────────────┐   ┌──────────────┐                │
│  │ RECEIVE  │──►│ PLAN         │──►│ EXECUTE      │                │
│  │ASSIGNMENT│   │INVESTIGATION │   │INVESTIGATION │                │
│  └──────────┘   └──────────────┘   └──────┬───────┘                │
│                                           │                         │
│                            ┌──────────────┼──────────────┐          │
│                            │              │              │          │
│                    ┌───────▼──────┐ ┌─────▼──────┐ ┌────▼───────┐  │
│                    │ GATHER       │ │ ASSESS     │ │ DETERMINE  │  │
│                    │ EVIDENCE     │ │ DAMAGES    │ │ LIABILITY  │  │
│                    │              │ │            │ │            │  │
│                    │ • Statements │ │ • Inspect  │ │ • Facts    │  │
│                    │ • Documents  │ │ • Estimate │ │ • Law      │  │
│                    │ • Photos     │ │ • Value    │ │ • Fault %  │  │
│                    │ • Records    │ │ • Expert   │ │ • Defense  │  │
│                    │ • Experts    │ │   opinion  │ │   position │  │
│                    └───────┬──────┘ └─────┬──────┘ └────┬───────┘  │
│                            │              │              │          │
│                            └──────────────┼──────────────┘          │
│                                           │                         │
│                                    ┌──────▼───────┐                 │
│                                    │ SYNTHESIZE   │                 │
│                                    │ & REPORT     │                 │
│                                    │              │                 │
│                                    │ • Document   │                 │
│                                    │   findings   │                 │
│                                    │ • Set/update │                 │
│                                    │   reserves   │                 │
│                                    │ • Recommend  │                 │
│                                    │   action     │                 │
│                                    └──────┬───────┘                 │
│                                           │                         │
│                                    ┌──────▼───────┐                 │
│                                    │ PROCEED TO   │                 │
│                                    │ EVALUATION / │                 │
│                                    │ NEGOTIATION  │                 │
│                                    └──────────────┘                 │
└──────────────────────────────────────────────────────────────────────┘
```

### 1.3 Investigation Principles

| Principle | Description |
|---|---|
| **Prompt Contact** | Contact all parties within SLA (typically 24-48 hours) |
| **Thorough Documentation** | Every investigation action documented in claim notes |
| **Objective Analysis** | Gather facts before forming conclusions; avoid confirmation bias |
| **Proportional Investigation** | Investigation depth proportional to claim complexity/severity |
| **Fair Dealing** | Good faith obligation to insured; fair treatment of all parties |
| **Privacy Protection** | Medical and personal information handled per HIPAA/state law |
| **Preserve Evidence** | Advise parties to preserve evidence; document chain of custody |
| **Regulatory Compliance** | Meet all state-specific timing and handling requirements |

---

## 2. Adjuster Types & Specializations

### 2.1 Adjuster Classification Matrix

| Adjuster Type | Employment | Typical Claims | License | Authority Range |
|---|---|---|---|---|
| **Entry-Level Staff Adjuster** | Carrier employee | Simple auto PD, glass, minor property | Required in most states | $5K-$15K |
| **Experienced Staff Adjuster** | Carrier employee | Standard auto PD/BI, homeowner property | Required | $15K-$50K |
| **Senior Staff Adjuster** | Carrier employee | Complex auto BI, large property, liability | Required | $50K-$150K |
| **Claims Examiner** | Carrier employee | Supervisory review; handles highest-value claims | Required | $150K-$500K+ |
| **Independent Adjuster (IA)** | Contractor (IA firm) | Overflow, geographic gaps, specialty | Required | Per carrier agreement |
| **Catastrophe Adjuster** | Contractor (IA firm) | CAT-declared events (hurricane, tornado, wildfire) | Required | Per carrier agreement |
| **Public Adjuster** | Self-employed or firm | Represents policyholder (not the carrier) | Required | N/A (represents insured) |
| **Marine Surveyor** | Contractor (specialty) | Ocean/inland marine losses, cargo | Varies | Per carrier agreement |
| **Aviation Adjuster** | Contractor (specialty) | Aircraft damage, aviation liability | Specialized | Per carrier agreement |
| **Farm/Agricultural Adjuster** | Carrier or contractor | Crop, farm equipment, livestock | Specialized | Per carrier agreement |

### 2.2 Adjuster Skill Tiers

```
SKILL TIER ARCHITECTURE:

TIER 1: ENTRY (Trainee/Junior)
  Claims handled: Simple auto PD, glass, minor theft, routine property
  Authority: Up to $15K
  Required experience: 0-2 years
  Required certifications: Adjuster license, company training
  Supervision level: Close supervision, weekly reviews

TIER 2: STANDARD (Mid-Level)
  Claims handled: Standard auto PD/BI (soft tissue), moderate property,
                  simple liability, medical-only WC
  Authority: Up to $50K
  Required experience: 2-5 years
  Required certifications: AIC or equivalent
  Supervision level: Regular supervision, monthly reviews

TIER 3: ADVANCED (Senior)
  Claims handled: Complex auto BI, large property, complex liability,
                  multi-party, contested liability, lost-time WC
  Authority: Up to $150K
  Required experience: 5-10 years
  Required certifications: AIC, CPCU (preferred)
  Supervision level: Light supervision, quarterly reviews

TIER 4: SPECIALIST (Expert)
  Claims handled: Large/complex commercial, severe injury, construction defect,
                  environmental, professional liability, mass tort
  Authority: Up to $500K
  Required experience: 10+ years
  Required certifications: CPCU, specialized training
  Supervision level: Peer review, semi-annual

TIER 5: EXAMINER (Management)
  Claims handled: Oversight of all tiers; handles policy-limits cases,
                  bad faith exposure, excess notice situations
  Authority: Up to $1M+
  Required experience: 15+ years
  Required certifications: CPCU, management training
  Supervision level: VP-level oversight
```

### 2.3 Adjuster Data Model

| Field | Type | Description |
|---|---|---|
| adjuster_id | UUID | Unique identifier |
| employee_id | VARCHAR | HR employee ID (staff) or vendor ID (IA) |
| adjuster_type | VARCHAR | Staff, IA, CAT, Examiner |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| email | VARCHAR | Email address |
| phone | VARCHAR | Phone number |
| mobile | VARCHAR | Mobile phone |
| skill_tier | INTEGER | 1-5 |
| handling_unit | VARCHAR | Auto PD, Auto BI, Property, Liability, WC, etc. |
| office_code | VARCHAR | Assigned office |
| supervisor_id | UUID | Direct supervisor |
| settlement_authority | DECIMAL | Maximum settlement amount |
| reserve_authority | DECIMAL | Maximum reserve amount |
| licensed_states | TEXT | Comma-separated state codes |
| license_numbers | JSON | State → license number mapping |
| certifications | TEXT | AIC, CPCU, etc. |
| max_open_claims | INTEGER | Maximum concurrent caseload |
| current_open_claims | INTEGER | Current number of open claims |
| specializations | TEXT | Fire, Water, Total Loss, Catastrophe, etc. |
| languages | TEXT | Languages spoken |
| availability_status | VARCHAR | Active, OnLeave, Vacation, Training |
| hire_date | DATE | Date started in role |
| last_assignment_date | DATETIME | When last claim was assigned |

---

## 3. Assignment & Workload Management

### 3.1 Workload Capacity Model

```
ADJUSTER WORKLOAD CAPACITY CALCULATION:

Capacity Points per Adjuster per Month: 100 points (standard)

Point Values by Claim Type:
  Simple Auto PD:         2 points
  Standard Auto PD:       3 points
  Auto Total Loss:        4 points
  Auto BI (soft tissue):  5 points
  Auto BI (moderate):     8 points
  Auto BI (severe/lit):   15 points
  Simple Property:        3 points
  Moderate Property:      5 points
  Large/Complex Property: 12 points
  Simple GL:              4 points
  Complex GL:             10 points
  GL with Litigation:     15 points
  WC Medical Only:        2 points
  WC Lost Time:           5 points
  WC Complex/Permanent:   10 points

Example: Standard Auto BI Adjuster (Tier 2)
  Capacity: 100 points/month
  Mix: 10 Auto BI (soft tissue) @ 5 + 5 Auto PD @ 3 = 50 + 15 = 65 points
  Available capacity: 35 points
  Can accept: ~7 more soft-tissue BI claims or 11 auto PD claims

OVERLOAD THRESHOLD: 90% of capacity → new assignments paused
UNDERLOAD THRESHOLD: 50% of capacity → priority for new assignments
```

### 3.2 Assignment Queue Management

```
QUEUE SYSTEM DESIGN:

┌────────────────────────────────────────────────────────────┐
│                  ASSIGNMENT QUEUES                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ AUTO PD      │  │ AUTO BI      │  │ PROPERTY     │     │
│  │ QUEUE        │  │ QUEUE        │  │ QUEUE        │     │
│  │ Age: 0-2 hrs │  │ Age: 0-4 hrs │  │ Age: 0-4 hrs │     │
│  │ Count: 12    │  │ Count: 8     │  │ Count: 5     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ LIABILITY    │  │ WORKERS COMP │  │ LARGE LOSS   │     │
│  │ QUEUE        │  │ QUEUE        │  │ QUEUE        │     │
│  │ Age: 0-4 hrs │  │ Age: 0-2 hrs │  │ Age: 0-1 hrs │     │
│  │ Count: 3     │  │ Count: 7     │  │ Count: 1     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                            │
│  ┌──────────────┐  ┌──────────────┐                       │
│  │ CAT QUEUE    │  │ LITIGATION   │                       │
│  │              │  │ QUEUE        │                       │
│  │ Age: 0-8 hrs │  │ Age: 0-24hrs │                       │
│  │ Count: 45    │  │ Count: 2     │                       │
│  └──────────────┘  └──────────────┘                       │
│                                                            │
│  QUEUE AGING ALERTS:                                       │
│  Yellow: > 4 hours unassigned                              │
│  Red: > 8 hours unassigned                                 │
│  Critical: > 24 hours unassigned → auto-escalate           │
└────────────────────────────────────────────────────────────┘
```

### 3.3 Reassignment Triggers

| Trigger | Action | System Behavior |
|---|---|---|
| Adjuster on leave | Auto-reassign | Reassign to backup adjuster or queue |
| Adjuster terminated | Mass reassign | Redistribute entire caseload |
| Claim upgraded (complexity) | Manual reassign | Supervisor moves to higher-tier adjuster |
| Attorney LOR received | Auto-reroute | Move from PD unit to BI/Litigation unit |
| CAT declared | Selective reassign | Non-CAT claims reassigned to free up CAT capacity |
| Workload imbalance | System-driven | Balance claims across adjusters based on capacity |
| Adjuster conflict of interest | Manual reassign | COI detected, move to different adjuster |
| Quality issue | Manual reassign | Audit reveals mishandling; reassign to senior |
| Jurisdiction mismatch | Auto-reassign | Adjuster not licensed in claim's state |

---

## 4. Investigation Checklists by Claim Type

### 4.1 Auto Physical Damage Checklist

| Step | Activity | SLA | System Support |
|---|---|---|---|
| 1 | Review FNOL data completeness | Assignment + 1 hr | Auto data quality check |
| 2 | Contact insured — verify facts, arrange inspection | 24 hours | Activity with timer |
| 3 | Verify VIN matches policy | During contact | Auto VIN verification |
| 4 | Confirm coverage and deductible | 24 hours | PAS integration |
| 5 | Determine inspection method (DRP, IA, photo, desk) | 24 hours | Assignment rules |
| 6 | Order/conduct vehicle inspection | 3-5 business days | Vendor assignment |
| 7 | Review damage estimate for completeness/accuracy | 2 business days | Estimatics integration |
| 8 | Check for prior unrelated damage | During review | ISO ClaimSearch, prior claim review |
| 9 | Determine if total loss (repair cost vs. ACV threshold) | After estimate | Auto TL calculation |
| 10 | If repairable: authorize repairs | After estimate | Payment workflow |
| 11 | If total loss: determine ACV, handle salvage | After TL declaration | Valuation tools, salvage vendor |
| 12 | Process rental reimbursement | Concurrent | Rental tracking |
| 13 | Arrange towing/storage if needed | Immediate | Vendor dispatch |
| 14 | Evaluate subrogation potential | After liability | Subrog referral rules |
| 15 | Set/update reserves | Throughout | Reserve workflow |
| 16 | Issue payment(s) | After settlement | Payment workflow |
| 17 | Close claim/feature(s) | After final payment | Closure validation |

### 4.2 Auto Bodily Injury Checklist

| Step | Activity | SLA | System Support |
|---|---|---|---|
| 1 | Contact insured — recorded statement | 24-48 hours | Statement recording system |
| 2 | Contact claimant or attorney | 48-72 hours | Activity with compliance rules |
| 3 | Obtain police report | 7-14 days | Police report vendor/API |
| 4 | Obtain medical authorization | During contact | HIPAA auth form |
| 5 | Review medical records as received | Ongoing | Medical records management |
| 6 | Determine liability position | 30 days | Liability analysis template |
| 7 | Contact witnesses | 7-14 days | Activity tracking |
| 8 | Review scene photos / obtain if needed | 14 days | Photo management |
| 9 | Document liability analysis | 30 days | Note template |
| 10 | Monitor medical treatment progress | Every 30 days | Diary system |
| 11 | Evaluate need for IME | Ongoing | IME referral workflow |
| 12 | Request and review IME report | As needed | Vendor management |
| 13 | Total medical specials | After treatment concludes | BI evaluation tool |
| 14 | Evaluate general damages | After treatment | Evaluation methodology |
| 15 | Request settlement authority | Before negotiation | Authority workflow |
| 16 | Negotiate settlement | Ongoing | Negotiation tracker |
| 17 | Obtain signed release | At settlement | Document management |
| 18 | Process settlement payment | After release | Payment workflow |
| 19 | Close feature | After payment | Closure validation |

### 4.3 Homeowners Property Damage Checklist

| Step | Activity | SLA | System Support |
|---|---|---|---|
| 1 | Contact insured — verify facts, assess immediate needs | 24 hours | Activity tracking |
| 2 | Advise on mitigation of further damage | During first contact | Script/checklist |
| 3 | Authorize emergency repairs/mitigation if needed | Immediately | Emergency auth workflow |
| 4 | Verify coverage — cause of loss vs. policy perils | 48 hours | Coverage analysis tool |
| 5 | Check for applicable exclusions | 48 hours | Exclusion checklist |
| 6 | Schedule field inspection | 3-5 business days | Inspection scheduling |
| 7 | Conduct field inspection / scope of loss | Per schedule | Mobile inspection app |
| 8 | Prepare Xactimate estimate | 5-10 business days | Xactimate integration |
| 9 | Review mitigation vendor invoice | As received | Invoice review |
| 10 | Document personal property (contents inventory) | Ongoing (insured prepares) | Contents tool |
| 11 | Calculate depreciation (if ACV settlement) | After estimate | Depreciation calculator |
| 12 | Apply coinsurance clause (if applicable) | After estimate | Coinsurance calculator |
| 13 | Apply deductible | After estimate | Auto-applied |
| 14 | Determine loss payee (mortgage company) | During review | Policy/PAS lookup |
| 15 | Issue initial ACV payment | After agreement | Two-party check workflow |
| 16 | Process supplement(s) as repairs reveal additional damage | As reported | Supplement workflow |
| 17 | Process recoverable depreciation after repairs complete | After repair receipts | RCV holdback workflow |
| 18 | Evaluate subrogation potential | After cause determined | Subrog referral |
| 19 | Close claim | After all payments | Closure validation |

### 4.4 Workers' Compensation Checklist

| Step | Activity | SLA | System Support |
|---|---|---|---|
| 1 | Contact employer — verify employment and incident details | 24 hours | Employer portal/API |
| 2 | Contact injured worker — explain rights and benefits | 24-48 hours | WC-specific scripts |
| 3 | Verify compensability (arising out of / in course of employment) | 3-14 days (state-specific) | Compensability decision tool |
| 4 | Accept or deny claim — file state forms | Per state deadline | State EDI filing |
| 5 | Direct employee to authorized medical provider | During first contact | Provider network lookup |
| 6 | Authorize initial treatment | Immediately | Treatment auth workflow |
| 7 | Calculate Average Weekly Wage (AWW) | Within 14 days | AWW calculator |
| 8 | Calculate benefit rate (state-specific formula) | Within 14 days | Benefit rate calculator |
| 9 | Begin indemnity payments (if lost time exceeds waiting period) | Per state law | Auto-payment scheduler |
| 10 | Monitor medical treatment and progress | Every 30 days | Medical management |
| 11 | Review medical bills (bill review vendor) | As received | Bill review integration |
| 12 | Apply fee schedule and PPO repricing | Automatic | Fee schedule engine |
| 13 | Assign nurse case manager (complex cases) | As needed | NCM assignment |
| 14 | Monitor return-to-work status | Every 14 days | RTW tracking |
| 15 | Coordinate light duty with employer | Ongoing | Employer communication |
| 16 | Obtain MMI determination from treating physician | When appropriate | Medical status tracking |
| 17 | Obtain impairment rating (if permanent) | At MMI | Impairment rating tool |
| 18 | Calculate permanent disability benefits | After rating | PPD/PTD calculator |
| 19 | Negotiate settlement (Compromise & Release) | If appropriate | Settlement workflow |
| 20 | Evaluate Medicare Set-Aside requirement | Before settlement | MSA evaluation tool |
| 21 | File state closing forms | At closure | State EDI filing |
| 22 | Report to NCCI | Per schedule | NCCI EDI integration |

---

## 5. Recorded Statement Process

### 5.1 Statement Types

| Type | When | Who | Legal Status |
|---|---|---|---|
| **Recorded Statement** | During investigation (phone or in-person) | Insured, claimant, witness | Admissible; insured has duty to cooperate |
| **Written Statement** | During investigation | Insured, claimant, witness | Signed by declarant |
| **Examination Under Oath (EUO)** | When fraud suspected or policy requires | Insured only | Under oath; typically with court reporter; attorney may be present |
| **Deposition** | During litigation | Any party or witness | Under oath; court reporter; both attorneys present |

### 5.2 Recorded Statement Data Capture

| Field | Type | Description |
|---|---|---|
| statement_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| party_id | UUID | Party giving statement |
| statement_type | VARCHAR | Recorded, Written, EUO, Deposition |
| statement_date | DATETIME | When statement was taken |
| statement_location | VARCHAR | Where (phone, in-person address) |
| taken_by | UUID | Adjuster who took statement |
| interpreter_used | BOOLEAN | Was an interpreter used? |
| interpreter_language | VARCHAR | Language interpreted |
| duration_minutes | INTEGER | Length of statement |
| audio_file_ref | VARCHAR | Reference to audio recording file |
| transcript_doc_ref | VARCHAR | Reference to transcript document |
| summary | TEXT | Adjuster's summary of key points |
| key_admissions | TEXT | Significant admissions or inconsistencies noted |
| consent_obtained | BOOLEAN | Was consent to record obtained? |
| consent_on_recording | BOOLEAN | Is consent documented on the recording itself? |

### 5.3 Statement Question Framework — Auto Accident

```
RECORDED STATEMENT OUTLINE — AUTO ACCIDENT:

1. IDENTIFICATION & CONSENT
   - Full legal name, DOB, address
   - Consent to record (legally required in many states)
   - Relationship to claim

2. PRE-ACCIDENT
   - Where were you coming from / going to?
   - What road/highway were you on?
   - How fast were you traveling?
   - Were you familiar with the area?
   - What were traffic conditions?
   - What were weather/road conditions?
   - Were you using a phone/GPS/radio?
   - Were you wearing a seatbelt?
   - Had you consumed alcohol or medication?

3. THE ACCIDENT
   - In your own words, describe what happened
   - What did you see just before the collision?
   - Where exactly were you when you first saw the other vehicle?
   - What did you do to try to avoid the accident?
   - How fast were you going at impact?
   - What part of your vehicle was struck?
   - What part of the other vehicle made contact?
   - Did you hear the other vehicle brake?
   - Were there any traffic signals or signs at the location?

4. POST-ACCIDENT
   - What happened immediately after the collision?
   - Did you exit your vehicle?
   - Did you speak with the other driver? What was said?
   - Were the police called? Report number?
   - Was anyone injured? Describe.
   - Were there any witnesses?
   - Was your vehicle drivable?
   - Where is your vehicle now?

5. INJURIES (if applicable)
   - Were you injured in the accident?
   - Describe your injuries
   - When did symptoms first appear?
   - Have you seen a doctor? Who?
   - What treatment have you received?
   - Are you still treating?
   - Any prior injuries to the same body parts?
   - Are you currently working?

6. VEHICLE / DAMAGE
   - Describe the damage to your vehicle
   - Was there any prior damage?
   - Have you obtained a repair estimate?
   - Were there any aftermarket modifications?

7. CLOSING
   - Is everything you've told me today true and accurate?
   - Is there anything you want to add?
   - Thank and end recording
```

---

## 6. Scene Inspection & Documentation

### 6.1 Property Inspection Protocol

```
PROPERTY INSPECTION WORKFLOW:

PRE-INSPECTION:
  ├── Review FNOL and claim file
  ├── Review policy coverages and limits
  ├── Schedule with insured (confirm access)
  ├── Prepare equipment (camera, moisture meter, ladder, etc.)
  └── Review prior claims at this property

ON-SITE INSPECTION:
  ├── 1. EXTERIOR SURVEY
  │   ├── Overall property photos (4 corners + street view)
  │   ├── General condition assessment
  │   ├── External damage documentation
  │   ├── Roof inspection (ground level, ladder, drone)
  │   ├── Foundation/structure check
  │   └── Other structures (garage, shed, fence)
  │
  ├── 2. INTERIOR SURVEY
  │   ├── Room-by-room walkthrough
  │   ├── Photo each affected room (wide + detail)
  │   ├── Identify all affected areas
  │   ├── Moisture readings (water claims)
  │   ├── Mold assessment (water claims)
  │   ├── Measure affected areas
  │   ├── Document building materials (flooring, drywall, paint)
  │   └── Assess structural vs. cosmetic damage
  │
  ├── 3. CAUSE DETERMINATION
  │   ├── Identify source/origin of damage
  │   ├── Assess sudden vs. gradual (coverage implication)
  │   ├── Document evidence of maintenance/neglect
  │   ├── Assess pre-existing conditions
  │   └── Take samples if needed (mold, asbestos, lead)
  │
  ├── 4. SCOPE OF LOSS
  │   ├── Measure all damaged areas
  │   ├── Note room dimensions
  │   ├── Identify materials to be replaced
  │   ├── Note code upgrade requirements
  │   └── Sketch/diagram affected areas
  │
  └── 5. CONTENTS (if applicable)
      ├── Document damaged contents with photos
      ├── Provide inventory form to insured
      └── Note any high-value items (sublimit check)

POST-INSPECTION:
  ├── Upload all photos to claim file
  ├── Document findings in claim notes
  ├── Prepare Xactimate estimate
  ├── Report to insured on findings
  └── Identify any additional investigation needed
```

### 6.2 Photo Documentation Standards

| Subject | Minimum Photos | Requirements |
|---|---|---|
| Overall property exterior | 4 | Each side of structure |
| Each damaged area (wide shot) | 1 per area | Full room/area visible |
| Each damaged area (detail) | 2-5 per area | Close-up of damage |
| Damage source/origin | 2-3 | Where damage started |
| Pre-existing conditions | As needed | Separate from new damage |
| Measurements | With measuring tape visible | Scale reference |
| Contents damage | 1 per major item | Show condition |
| Roof damage | 4+ | Overall + detail of each damaged area |
| VIN (auto claims) | 1 | Dashboard VIN plate |
| Odometer (auto claims) | 1 | Current mileage reading |
| Vehicle damage (all angles) | 8-12 | All 4 sides + close-ups of damage |
| License plate | 1 per vehicle | Readable plate number |

### 6.3 Photo Metadata Requirements

| Metadata | Captured Automatically | Purpose |
|---|---|---|
| Timestamp | Yes (EXIF) | Prove when photo was taken |
| GPS coordinates | Yes (if enabled) | Prove where photo was taken |
| Device ID | Yes | Chain of custody |
| Resolution | Yes | Ensure quality sufficient for review |
| Photographer | Manual tag | Accountability |
| Subject tag | Manual tag | Categorize in document management |

---

## 7. Evidence Collection & Chain of Custody

### 7.1 Evidence Types in Claims

| Evidence Type | Examples | Preservation Method |
|---|---|---|
| Physical evidence | Damaged property, failed parts, surveillance video | Retain/photograph; do not alter |
| Documentary evidence | Contracts, invoices, receipts, financial records | Copies obtained; originals preserved |
| Photographic evidence | Scene photos, damage photos, satellite imagery | Stored in claim document management |
| Audio/video evidence | Recorded statements, surveillance footage, dashcam | Stored in secure media management |
| Digital evidence | Telematics data, IoT sensor data, social media posts | Captured and preserved promptly |
| Expert reports | Engineering, medical, forensic accounting | Stored as claim documents |
| Witness statements | Recorded or written statements | Stored in claim file |
| Medical records | Treatment records, bills, diagnostic reports | Stored per HIPAA requirements |
| Public records | Police reports, fire reports, court records | Copies obtained and filed |

### 7.2 Chain of Custody Data Model

| Field | Type | Description |
|---|---|---|
| evidence_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| evidence_type | VARCHAR | Physical, Documentary, Photographic, etc. |
| description | TEXT | Description of the evidence |
| source | VARCHAR | Where/from whom obtained |
| obtained_date | DATETIME | When obtained |
| obtained_by | VARCHAR | Who obtained it |
| current_custodian | VARCHAR | Current holder |
| storage_location | VARCHAR | Physical or digital location |
| integrity_status | VARCHAR | Intact, Compromised, Returned, Destroyed |

### 7.3 Chain of Custody Transfer Log

| Field | Type | Description |
|---|---|---|
| transfer_id | UUID | Unique identifier |
| evidence_id | UUID | Link to evidence |
| from_custodian | VARCHAR | Transferring party |
| to_custodian | VARCHAR | Receiving party |
| transfer_date | DATETIME | When transferred |
| purpose | VARCHAR | Inspection, Analysis, Storage, Return |
| condition_at_transfer | VARCHAR | Condition noted at time of transfer |
| witnessed_by | VARCHAR | Witness to transfer |
| signature_ref | VARCHAR | Reference to digital/physical signatures |

---

## 8. Police Report Integration

### 8.1 Police Report Data Extraction

```
POLICE REPORT INTEGRATION:

DATA SOURCES:
├── Manual entry (adjuster reads paper report, enters data)
├── LexisNexis Police Report Retrieval (electronic)
├── State DOT crash report databases (API/batch)
├── CopLogic / other online report portals
└── OCR/AI extraction from scanned PDF reports

KEY DATA ELEMENTS EXTRACTED:
├── Report Number
├── Investigating Agency
├── Officer Name and Badge
├── Date/Time of Accident
├── Location (exact)
├── Weather/Road/Light Conditions
├── Driver Information (all vehicles)
│   ├── Name, DOB, Address
│   ├── Driver's License
│   ├── Insurance Information
│   └── Citations Issued
├── Vehicle Information (all vehicles)
│   ├── VIN, Year, Make, Model
│   ├── Registration
│   ├── Damage description
│   └── Tow destination
├── Passenger Information
├── Injury Information (each person)
│   ├── Injury type
│   ├── Transport to hospital
│   └── EMS run number
├── Narrative (officer's description of events)
├── Diagram (accident scene diagram)
├── Contributing Factors
│   ├── Speed, Following Too Close, Improper Lane Change
│   ├── DUI/Impairment
│   ├── Distracted Driving
│   └── Traffic Control Disobeyed
├── Fault Determination (if stated by officer)
└── Witness Information
```

### 8.2 Police Report Data Model

| Field | Type | Description |
|---|---|---|
| report_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| report_number | VARCHAR | Official report number |
| agency_name | VARCHAR | Police department name |
| agency_ori | VARCHAR | Originating Agency Identifier |
| officer_name | VARCHAR | Investigating officer |
| officer_badge | VARCHAR | Badge number |
| report_date | DATE | Date of report |
| accident_date | DATETIME | Date/time of accident |
| location_description | TEXT | Exact location |
| narrative | TEXT | Officer's narrative |
| diagram_doc_ref | VARCHAR | Reference to diagram document |
| contributing_factors | JSON | Array of contributing factor codes |
| fault_determination | VARCHAR | Officer's fault determination (if stated) |
| citations | JSON | Array of citations issued |
| hit_and_run | BOOLEAN | Hit and run incident? |
| dui_involved | BOOLEAN | DUI/impairment involved? |
| fatality | BOOLEAN | Any fatalities? |
| source | VARCHAR | Manual, LexisNexis, StateAPI, OCR |
| retrieval_date | DATETIME | When report was obtained |
| document_ref | VARCHAR | Reference to PDF/scan of report |

---

## 9. Medical Record Review for Injury Claims

### 9.1 Medical Record Review Process

```
MEDICAL RECORD MANAGEMENT:

1. AUTHORIZATION
   ├── Obtain HIPAA-compliant medical authorization from claimant
   ├── Authorization must be specific (providers, date range)
   ├── Time-limited per HIPAA (typically 12-24 months)
   └── System tracks auth status and expiration

2. RECORD RETRIEVAL
   ├── Request records from treating providers
   ├── Track requests and follow up on outstanding
   ├── Methods: mail, fax, electronic (via vendor like Verisma, Ciox)
   ├── Common delay: 15-45 days for records
   └── Cost: $0.50-$1.00 per page (state-regulated)

3. RECORD REVIEW
   ├── Adjuster review for standard claims
   ├── Nurse reviewer for complex medical
   ├── Key review elements:
   │   ├── Diagnosis (ICD-10 codes)
   │   ├── Treatment plan
   │   ├── Causal relationship to accident
   │   ├── Pre-existing conditions
   │   ├── Prognosis
   │   ├── Work restrictions
   │   ├── Maximum Medical Improvement (MMI) date
   │   └── Permanent impairment rating
   │
   └── Red flags in medical records:
       ├── Treatment gap (weeks without treatment)
       ├── Pre-existing diagnosis matching claimed injury
       ├── Excessive treatment duration
       ├── Non-standard treatment protocols
       ├── Patient non-compliance noted
       └── Inconsistency between subjective complaints and objective findings

4. MEDICAL BILL REVIEW
   ├── Bill review vendor processes all medical bills
   ├── Apply: fee schedule (WC), UCR (usual/customary/reasonable), PPO repricing
   ├── Check: procedure code validity, diagnosis/procedure match, duplicate bills
   ├── Nurse review for medical necessity
   └── Explanation of Review (EOR) generated
```

### 9.2 Medical Summary Data Model

| Field | Type | Description |
|---|---|---|
| medical_summary_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| feature_id | UUID | Link to feature |
| party_id | UUID | Injured party |
| provider_name | VARCHAR | Treating provider |
| provider_type | VARCHAR | ER, Orthopedist, Chiropractor, PT, etc. |
| first_visit_date | DATE | First treatment date |
| last_visit_date | DATE | Most recent treatment |
| total_visits | INTEGER | Number of visits |
| primary_diagnosis | VARCHAR | Primary ICD-10 code |
| secondary_diagnoses | JSON | Additional ICD-10 codes |
| treatment_type | VARCHAR | Conservative, Surgical, Chiropractic, PT |
| surgery_performed | BOOLEAN | Was surgery performed? |
| surgery_description | VARCHAR | Type of surgery |
| mmi_date | DATE | Maximum Medical Improvement date |
| impairment_rating | DECIMAL | Whole person impairment percentage |
| work_restrictions | TEXT | Permanent work restrictions |
| prognosis | VARCHAR | Full recovery, Partial recovery, Permanent |
| total_medical_specials | DECIMAL | Total medical charges |
| related_to_accident | VARCHAR | Related, Not Related, Partially Related |
| pre_existing_noted | BOOLEAN | Pre-existing condition identified |
| pre_existing_description | TEXT | Description of pre-existing condition |
| reviewed_by | VARCHAR | Reviewer name |
| review_date | DATE | Review completion date |

---

## 10. Independent Medical Examination (IME)

### 10.1 IME Process Flow

```
IME PROCESS:

1. DETERMINE IME NEEDED
   ├── Claimant's treatment duration exceeds guidelines
   ├── Treatment plan appears excessive or non-standard
   ├── Causation is disputed
   ├── Permanent impairment rating disputed
   ├── Return to work status disputed
   └── Defense counsel recommends (litigation)

2. SELECT IME PHYSICIAN
   ├── Must be appropriate specialty for injury type
   ├── Must be licensed in claimant's state
   ├── Must not have treated the claimant previously
   ├── Consider peer review by same specialty
   └── Manage through IME vendor (Exam Works, MES, etc.)

3. SCHEDULE IME
   ├── Notify claimant/attorney of IME date, time, location
   ├── State-specific notice requirements (days in advance)
   ├── Provide claimant with travel reimbursement info
   ├── Provide all medical records to IME physician
   └── Prepare specific questions for IME physician

4. IME EXAMINATION
   ├── Physical examination by IME physician
   ├── Review of medical records provided
   ├── Assessment against specific questions:
   │   ├── Is current condition causally related to the accident?
   │   ├── Is current treatment reasonable and necessary?
   │   ├── Has claimant reached MMI?
   │   ├── What is the impairment rating?
   │   ├── What are work restrictions?
   │   └── Is future treatment needed?
   └── IME physician prepares written report

5. IME REPORT REVIEW
   ├── Review report for completeness
   ├── Incorporate findings into claim evaluation
   ├── Share report per state requirements
   └── Use findings in negotiation/litigation

IME Data Fields:
  - ime_id, claim_id, feature_id, party_id
  - physician_name, physician_specialty, physician_npi
  - exam_date, exam_location
  - questions_submitted (array)
  - report_date, report_document_ref
  - findings_summary
  - causation_opinion: Related / Not Related / Partially
  - mmi_opinion: At MMI / Not at MMI
  - impairment_rating: percentage
  - work_status_opinion: Full Duty / Modified / No Work
  - future_treatment_needed: Yes / No / Limited
  - vendor_name, vendor_invoice_amount
```

---

## 11. Damage Estimation — Auto

### 11.1 Estimatics Platform Overview

| Platform | Market Share | Key Features |
|---|---|---|
| **CCC Intelligent Solutions** | ~50% | CCC ONE platform; AI photo estimation; OEM procedures; total loss valuation; repair workflow |
| **Mitchell International** | ~30% | Mitchell Cloud platform; WorkCenter; estimating; parts; valuation |
| **Audatex (Solera)** | ~20% | Audatex estimating; Qapter (AI photo); global presence |

### 11.2 Auto Damage Estimate Structure

```
AUTO DAMAGE ESTIMATE DATA MODEL:

Estimate Header:
├── estimate_id: UUID
├── claim_id: UUID
├── vehicle_id: UUID
├── estimate_type: Original, Supplement, Reinspection
├── estimator_name: VARCHAR
├── estimator_company: VARCHAR
├── estimate_date: DATE
├── estimate_source: CCC, Mitchell, Audatex, Manual
├── labor_rate_body: DECIMAL ($/hour)
├── labor_rate_paint: DECIMAL ($/hour)
├── labor_rate_mechanical: DECIMAL ($/hour)
├── labor_rate_frame: DECIMAL ($/hour)
├── paint_material_rate: DECIMAL (per refinish hour)
├── tax_rate: DECIMAL (%)
└── estimate_status: Draft, Approved, Disputed

Estimate Lines (one per operation):
├── line_id: UUID
├── line_number: INTEGER
├── operation_type: Remove/Replace, Repair, Refinish, Blend, Overhaul
├── part_description: VARCHAR (e.g., "Rear Bumper Cover")
├── part_number: VARCHAR (OEM or aftermarket)
├── part_type: OEM, Aftermarket, Used/LKQ, Reconditioned
├── part_price: DECIMAL
├── labor_hours: DECIMAL
├── labor_type: Body, Paint, Mechanical, Frame, Structural
├── labor_amount: DECIMAL (hours × rate)
├── paint_material: DECIMAL
├── sublet_amount: DECIMAL (outsourced operations)
├── additional_costs: DECIMAL (supplies, hazmat, etc.)
└── line_total: DECIMAL

Estimate Summary:
├── total_parts: DECIMAL
├── total_labor: DECIMAL
├── total_paint_materials: DECIMAL
├── total_sublet: DECIMAL
├── total_other: DECIMAL
├── subtotal: DECIMAL
├── sales_tax: DECIMAL
├── grand_total: DECIMAL
└── supplement_amount: DECIMAL (if supplement)
```

### 11.3 Total Loss Valuation Process

```
TOTAL LOSS DETERMINATION AND VALUATION:

Step 1: THRESHOLD TEST
  repair_estimate / actual_cash_value >= state_threshold%
  
  State thresholds (examples):
    Alabama: 75%    California: No fixed %    Colorado: 100%
    Florida: 80%    Georgia: 75%              Illinois: No fixed %
    Michigan: 75%   New York: 75%             Texas: 100%

Step 2: ACV DETERMINATION
  Methods:
  ├── CCC Market Valuation (most common)
  │   └── Comparable vehicle sales in local market
  ├── Mitchell WorkCenter Total Loss
  │   └── Market-based comparable methodology
  ├── NADA/KBB (guide-based, less common)
  │   └── Published values with adjustments
  └── Independent Appraisal
      └── Certified appraiser evaluation

  ACV Components:
    Base value (comparable sales data)
    + Mileage adjustment (above/below average)
    + Condition adjustment (excellent/good/fair/poor)
    + Equipment adjustment (options, packages)
    + Regional market adjustment
    - Prior damage deduction (if applicable)
    = Actual Cash Value

Step 3: TOTAL LOSS SETTLEMENT CALCULATION
  ACV
  - Deductible
  + Sales tax (state-specific: some include, some don't)
  + Title/registration fees (transfer costs)
  - Prior damage adjustment (if any)
  - Salvage value (if owner retains)
  = Net Settlement Amount

Step 4: SALVAGE DISPOSITION
  Options:
  ├── Carrier takes possession → sell through Copart/IAA auction
  ├── Owner retains → deduct salvage value; title branded as salvage
  └── Charity donation (rare)

  Salvage Data:
    salvage_vendor: Copart, IAA, other
    salvage_location: pickup location
    salvage_value: estimated salvage proceeds
    salvage_sold_date: auction date
    salvage_sold_amount: actual proceeds
    title_status: transferred, branded, pending
```

### 11.4 AI/Photo-Based Estimation

```
AI PHOTO ESTIMATION WORKFLOW:

1. Insured/Claimant takes guided photos via mobile app
   (front, rear, left, right, damage detail, VIN, odometer)

2. Photos uploaded to AI estimation platform

3. AI MODEL PROCESSING:
   ├── Vehicle identification (year/make/model from photos or VIN)
   ├── Damage detection (computer vision identifies damaged areas)
   ├── Damage classification (dent, scratch, crack, tear, deform)
   ├── Severity assessment (minor, moderate, severe)
   ├── Part identification (which parts need repair/replace)
   ├── Repair vs. replace recommendation
   └── Cost estimation (parts + labor)

4. AI estimate generated:
   ├── Confidence score per line item
   ├── Overall estimate confidence: High (>85%), Medium (60-85%), Low (<60%)
   └── Flag for human review if confidence < threshold

5. DECISION:
   ├── High confidence + below STP threshold → auto-approve
   ├── High confidence + above STP threshold → route to adjuster for review
   ├── Medium confidence → route to adjuster for desk review
   └── Low confidence → traditional inspection required

ACCURACY METRICS:
  AI estimate vs. final repair cost (after supplements):
  Within 10%: ~70% of simple claims
  Within 20%: ~85% of simple claims
  Supplement rate: still ~30-40% (hidden damage)
```

---

## 12. Damage Estimation — Property

### 12.1 Xactimate Overview

**Xactimate** (by Verisk/Xactware) is the industry-standard property damage estimation platform used by >90% of carriers for property claims.

### 12.2 Xactimate Estimate Structure

```
XACTIMATE ESTIMATE DATA MODEL:

Project Information:
├── project_name: Claim number + insured name
├── estimate_date: DATE
├── estimator: Adjuster name
├── price_list: Region-specific Xactimate price list (e.g., TXDA26 = Texas, Dallas, April 2026)
├── property_address: Full address
├── policy_info: Policy number, coverages, limits, deductibles
└── scope_type: Emergency, Preliminary, Final

Room/Area (repeatable for each room):
├── room_name: Kitchen, Master Bedroom, etc.
├── dimensions: Length × Width × Height
├── perimeter: Calculated
├── floor_area: Calculated
├── wall_area: Calculated
├── ceiling_area: Calculated
└── line_items: []

Line Items (within each room):
├── category: Code (e.g., WTR = Water extraction, DRY = Drying, FLR = Flooring)
├── selector: Specific item code (e.g., FLR_HRWD = Hardwood flooring)
├── description: "Remove and replace hardwood flooring - oak, prefinished"
├── quantity: Numeric (SF, LF, EA, etc.)
├── unit_of_measure: SF, LF, SY, EA, HR
├── unit_price: Price from Xactimate price list
├── overhead_and_profit: O&P percentage (typically 10% + 10%)
├── depreciation_pct: Depreciation percentage for this item
├── line_rcv: Replacement Cost Value
├── line_depreciation: Depreciation amount
├── line_acv: Actual Cash Value (RCV - depreciation)
└── tax_applicable: Boolean

Estimate Summary:
├── total_rcv: Sum of all line items (replacement cost)
├── total_depreciation: Sum of all depreciation
├── total_acv: Total actual cash value
├── overhead_and_profit: O&P amount
├── sales_tax: Applicable tax
├── deductible: Policy deductible
├── net_claim_rcv: Total RCV - deductible
├── net_claim_acv: Total ACV - deductible
├── recoverable_depreciation: Total RCV - Total ACV (held back, paid later)
└── coverage_limits_applied: Any coverage limits that cap payment
```

### 12.3 Scope of Loss — Common Items by Cause

| Cause of Loss | Common Xactimate Categories |
|---|---|
| Water Damage | WTR (water extraction), DRY (dehumidifiers/fans), DEM (demo), FLR (flooring), DRW (drywall), CAB (cabinetry), PNT (paint), BSB (baseboard) |
| Fire/Smoke | DEM (demo), FRM (framing), DRW (drywall), RFG (roofing), ELC (electrical), PLB (plumbing), FLR (flooring), PNT (paint), CLN (cleaning), CONT (contents cleaning) |
| Wind/Hail | RFG (roofing), SDG (siding), GTR (gutters), WND (windows), FNC (fencing), SCR (screens) |
| Theft/Vandalism | DOR (doors), LCK (locks), WND (windows), RPR (repair), CLN (cleaning) |
| Falling Tree | RFG (roofing), FRM (framing), DRW (drywall), FNC (fencing), LND (landscaping) |

---

## 13. Bodily Injury Evaluation

### 13.1 BI Evaluation Framework

```
BODILY INJURY EVALUATION COMPONENTS:

┌─────────────────────────────────────────────────────────┐
│               TOTAL CLAIM VALUE                          │
│                                                          │
│  ┌───────────────────────────────────┐                   │
│  │ SPECIAL DAMAGES (Economic)        │                   │
│  │                                   │                   │
│  │ ├── Past Medical Expenses         │                   │
│  │ │   (bills incurred to date)      │                   │
│  │ ├── Future Medical Expenses       │                   │
│  │ │   (projected future treatment)  │                   │
│  │ ├── Past Lost Wages               │                   │
│  │ │   (documented lost income)      │                   │
│  │ ├── Future Lost Earnings          │                   │
│  │ │   (if permanent disability)     │                   │
│  │ ├── Loss of Earning Capacity      │                   │
│  │ │   (reduced ability to earn)     │                   │
│  │ └── Other Economic Losses         │                   │
│  │     (household services, etc.)    │                   │
│  └───────────────────────────────────┘                   │
│                                                          │
│  ┌───────────────────────────────────┐                   │
│  │ GENERAL DAMAGES (Non-Economic)    │                   │
│  │                                   │                   │
│  │ ├── Pain and Suffering            │                   │
│  │ │   (physical and mental)         │                   │
│  │ ├── Emotional Distress            │                   │
│  │ ├── Loss of Enjoyment of Life     │                   │
│  │ ├── Disfigurement / Scarring      │                   │
│  │ ├── Loss of Consortium            │                   │
│  │ │   (spouse's claim)              │                   │
│  │ ├── Inconvenience                 │                   │
│  │ └── Future Pain and Suffering     │                   │
│  └───────────────────────────────────┘                   │
│                                                          │
│  × LIABILITY FACTOR (Fault %)                            │
│  = NET EXPOSURE                                          │
│                                                          │
│  Subject to: Policy Limits, Other Insurance, Offsets     │
└─────────────────────────────────────────────────────────┘
```

### 13.2 BI Evaluation Data Model

| Field | Type | Description |
|---|---|---|
| evaluation_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| feature_id | UUID | Link to BI feature |
| claimant_party_id | UUID | Claimant |
| evaluation_date | DATE | When evaluation performed |
| evaluated_by | VARCHAR | Adjuster name |
| past_medical_specials | DECIMAL | Total past medical bills |
| future_medical_estimate | DECIMAL | Estimated future medical |
| past_lost_wages | DECIMAL | Documented past lost wages |
| future_lost_earnings | DECIMAL | Estimated future lost earnings |
| other_economic_damages | DECIMAL | Other specials |
| total_specials | DECIMAL | Sum of all economic damages |
| general_damages_low | DECIMAL | Low end of GD range |
| general_damages_mid | DECIMAL | Mid-point GD estimate |
| general_damages_high | DECIMAL | High end of GD range |
| evaluation_method | VARCHAR | Multiplier, PerDiem, Software, VerdictResearch |
| multiplier_used | DECIMAL | Multiplier value (if method = Multiplier) |
| per_diem_rate | DECIMAL | Daily rate (if method = PerDiem) |
| per_diem_days | INTEGER | Number of days (if method = PerDiem) |
| full_value_low | DECIMAL | Total value low range |
| full_value_mid | DECIMAL | Total value mid range |
| full_value_high | DECIMAL | Total value high range |
| liability_percentage | DECIMAL | Insured's liability % |
| comparative_negligence_pct | DECIMAL | Claimant's negligence % |
| adjusted_value_low | DECIMAL | After liability adjustment — low |
| adjusted_value_mid | DECIMAL | After liability adjustment — mid |
| adjusted_value_high | DECIMAL | After liability adjustment — high |
| policy_limit | DECIMAL | Applicable BI policy limit |
| settlement_authority_requested | DECIMAL | Authority sought |
| settlement_target | DECIMAL | Target settlement amount |
| notes | TEXT | Evaluation narrative |

### 13.3 Severity Classification for BI

| Tier | Injury Examples | Medical Range | Treatment Duration | Multiplier Range | Typical Value Range |
|---|---|---|---|---|---|
| 1 - Minor | Soft tissue, minor strain, bruising | $1K-$5K | 1-3 months | 1.5x-2.0x | $2K-$10K |
| 2 - Moderate | Herniated disc (conservative), fractures (simple), moderate sprain | $5K-$25K | 3-6 months | 2.0x-3.0x | $10K-$75K |
| 3 - Serious | Surgery required, complex fractures, TBI (mild), disc surgery | $25K-$100K | 6-18 months | 2.5x-4.0x | $75K-$400K |
| 4 - Severe | Multiple surgeries, spinal cord injury, severe TBI, amputation | $100K-$500K | 18+ months | 3.5x-5.0x | $350K-$2.5M |
| 5 - Catastrophic | Paralysis, severe brain damage, permanent total disability, death | $500K+ | Permanent | 4.0x-6.0x+ | $1M-$10M+ |

---

## 14. Liability Determination Frameworks

### 14.1 Negligence Analysis Framework

```
NEGLIGENCE ANALYSIS — FOUR ELEMENTS:

1. DUTY: Did the defendant owe a duty of care to the plaintiff?
   ├── Motorist: duty to drive safely, obey traffic laws
   ├── Property owner: duty to maintain safe premises
   ├── Manufacturer: duty to produce safe products
   └── Employer: duty to provide safe workplace

2. BREACH: Did the defendant breach that duty?
   ├── What would a "reasonable person" have done?
   ├── Did defendant's conduct fall below that standard?
   └── What evidence shows the breach?

3. CAUSATION: Did the breach cause the plaintiff's injuries?
   ├── Actual cause ("but for" test): But for defendant's action,
   │   would injury have occurred?
   └── Proximate cause: Was the injury a foreseeable result
       of the breach?

4. DAMAGES: Did the plaintiff suffer actual damages?
   ├── Medical expenses
   ├── Lost wages
   ├── Pain and suffering
   └── Property damage
```

### 14.2 Liability Systems by Jurisdiction

| System | Description | States |
|---|---|---|
| **Pure Comparative Negligence** | Plaintiff recovers even if 99% at fault; recovery reduced by fault % | CA, NY, FL, AZ, NM, WA, and ~8 others |
| **Modified Comparative (50% Bar)** | Plaintiff recovers only if ≤ 50% at fault | AR, CO, GA, ID, KS, ME, NE, ND, OK, TN, UT, WV |
| **Modified Comparative (51% Bar)** | Plaintiff recovers only if ≤ 51% at fault | CT, DE, HI, IL, IN, IA, MA, MI, MN, MT, NV, NH, NJ, OH, OR, PA, SC, TX, VT, WI, WY |
| **Pure Contributory Negligence** | Plaintiff who is even 1% at fault recovers nothing | AL, DC, MD, NC, VA |
| **No-Fault (Auto)** | Each party's own insurer pays regardless of fault (PIP) | FL, MI, NJ, NY, PA, HI, KS, KY, MA, MN, ND, UT |
| **Strict Liability** | Defendant liable regardless of fault for certain activities | Product liability, inherently dangerous activities |

### 14.3 Liability Determination Data Model

| Field | Type | Description |
|---|---|---|
| liability_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| determination_date | DATE | When liability was determined |
| determined_by | VARCHAR | Adjuster name |
| approved_by | VARCHAR | Supervisor/examiner (if required) |
| liability_framework | VARCHAR | ComparativeNeg, ContributoryNeg, NoFault, StrictLiability |
| insured_fault_pct | DECIMAL | Insured's fault percentage (0-100) |
| claimant_fault_pct | DECIMAL | Claimant's fault percentage (0-100) |
| other_party_fault | JSON | Array of {party_id, fault_pct} for additional parties |
| duty_analysis | TEXT | Duty of care analysis |
| breach_analysis | TEXT | Breach analysis |
| causation_analysis | TEXT | Causation analysis |
| damages_analysis | TEXT | Damages analysis |
| contributing_factors | JSON | Array of factor codes |
| evidence_supporting | JSON | Array of evidence references |
| evidence_against | JSON | Array of evidence against insured |
| liability_status | VARCHAR | Pending, Determined, Disputed, Arbitrated |
| dispute_basis | TEXT | If disputed, basis for dispute |

### 14.4 Common Liability Scenarios — Auto

| Scenario | Typical Liability | Key Evidence |
|---|---|---|
| Rear-end collision | Striking vehicle 100% at fault (rebuttable presumption) | Following distance, brake lights, sudden stop |
| Left turn accident | Left-turning vehicle typically at fault | Right-of-way, signal timing, visibility |
| Intersection (no signal) | Right-of-way rules apply | First to arrive, right-side priority |
| Lane change | Changing vehicle at fault | Mirror check, signal usage, blind spot |
| Parking lot | Generally shared fault | Speed, right-of-way, marked lanes |
| Backing | Backing vehicle at fault | Visibility, lookout, speed |
| DUI involvement | Impaired driver presumed at fault | BAC, police report, witness |
| Multi-vehicle chain reaction | Complex — each link analyzed separately | Impact sequence, following distances |

---

## 15. Statement Analysis & Consistency Checking

### 15.1 Consistency Analysis Framework

```
STATEMENT CONSISTENCY CHECKING:

COMPARE ACROSS:
├── Insured statement vs. Claimant statement
├── Statement vs. Police report
├── Statement vs. Physical evidence (damage patterns)
├── Statement vs. Medical records (injury mechanism)
├── Statement vs. Witness statements
├── Statement vs. Telematics/IoT data
├── Statement vs. Social media posts
└── Multiple statements from same party (temporal consistency)

RED FLAGS:
├── Material inconsistencies between statements
├── Statement contradicts physical evidence
├── Vague or evasive answers on key facts
├── Rehearsed or overly precise language
├── Inability to provide basic details
├── Story changes between first and subsequent accounts
├── Medical records show different mechanism of injury
├── Social media shows activity inconsistent with claimed injuries
├── Prior claims with similar facts/circumstances
└── Statement inconsistent with independent data (weather, traffic, etc.)

DOCUMENTATION:
  For each inconsistency:
  ├── Source A: [specific quote/data point]
  ├── Source B: [conflicting quote/data point]
  ├── Significance: Material / Minor
  ├── Possible explanations: Honest error / Mistaken recollection / Deception
  └── Follow-up action: Re-interview / Expert consultation / SIU referral
```

---

## 16. Timeline Reconstruction

### 16.1 Timeline Data Model

| Field | Type | Description |
|---|---|---|
| timeline_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| event_sequence | INTEGER | Order number |
| event_datetime | DATETIME | When event occurred (or estimated) |
| event_datetime_precision | VARCHAR | Exact, Approximate, Estimated |
| event_description | TEXT | Description of event |
| event_source | VARCHAR | Statement, PoliceReport, MedicalRecord, Telematics, Witness, Photo |
| event_source_ref | UUID | Reference to source document |
| event_location | VARCHAR | Location description or coordinates |
| parties_involved | JSON | Array of party_ids involved |
| verified | BOOLEAN | Has this event been independently verified? |
| disputed | BOOLEAN | Is this event's timing/occurrence disputed? |
| notes | TEXT | Additional context |

### 16.2 Sample Timeline — Auto Accident

```
CLAIM: CLM-2026-00200 — Multi-Vehicle Accident

TIME          EVENT                                    SOURCE
─────────────────────────────────────────────────────────────────
17:30:00   Insured leaves office at 500 Commerce Dr   Insured stmt
17:38:00   Insured enters Hwy 101 South              Telematics
17:42:00   Traffic slowing at mile marker 45          Telematics (speed drop)
17:43:15   Insured brakes hard (deceleration event)   Telematics
17:43:17   Impact detected — rear-end collision        Telematics
17:43:17   Airbags NOT deployed                        Vehicle data
17:43:30   Vehicle comes to stop                       Telematics
17:44:00   Insured exits vehicle                       Insured stmt
17:45:00   Other driver exits, complains of neck pain  Insured stmt
17:48:00   911 called by witness                       Police report
17:55:00   Police arrive on scene                      Police report
18:05:00   EMS arrives (no transport)                  Police report
18:10:00   Other driver refuses EMS transport          Police/EMS report
18:20:00   Police take statements                      Police report
18:30:00   Vehicles moved off roadway                  Police report
18:40:00   Police report completed, parties released   Police report
18:45:00   Insured drives home                         Insured stmt
20:00:00   Insured calls insurance company (FNOL)      FNOL record
─────────────────────────────────────────────────────────────────

NEXT DAY:
09:00:00   Other driver visits ER for neck pain        Medical records
09:30:00   X-ray: negative for fracture                Medical records
09:45:00   Diagnosis: cervical strain (ICD-10: S13.4)  Medical records
10:00:00   Rx: muscle relaxant, pain medication         Medical records
10:15:00   Discharged with PT referral                  Medical records
11:00:00   Other driver retains attorney Smith & Jones  Attorney LOR
```

---

## 17. Expert Engagement

### 17.1 Expert Types and Use Cases

| Expert Type | When Engaged | Deliverable | Typical Cost |
|---|---|---|---|
| **Structural Engineer** | Building damage causation, collapse, foundation | Engineering report with opinion | $2K-$15K |
| **Fire Investigator** | Origin and cause of fire | Fire investigation report | $3K-$20K |
| **Forensic Accountant** | Business income claims, fraud investigation | Financial analysis report | $5K-$50K+ |
| **Accident Reconstructionist** | Complex auto accidents, disputed liability | Reconstruction report with diagrams | $5K-$25K |
| **Meteorologist** | Weather-related claims, wind speed verification | Weather certification | $500-$3K |
| **Marine Surveyor** | Marine/cargo claims | Survey report | $2K-$10K |
| **Medical Expert (IME)** | Injury causation, treatment reasonableness | IME report | $1K-$5K per exam |
| **Life Care Planner** | Severe injury claims (future medical projection) | Life care plan | $5K-$15K |
| **Vocational Expert** | Lost earning capacity | Vocational assessment | $3K-$10K |
| **Economist** | Present value calculations for future damages | Economic analysis | $5K-$20K |
| **Environmental Consultant** | Pollution, mold, asbestos, lead | Environmental assessment | $3K-$25K |
| **Appraiser** | Property/vehicle valuation disputes | Appraisal report | $1K-$5K |
| **Arborist** | Tree damage/removal claims | Tree assessment | $500-$2K |
| **Roofing Expert** | Roof damage causation (hail vs. wear) | Inspection report | $1K-$5K |
| **Plumber** | Water damage source/causation | Inspection report | $500-$2K |
| **Electrical Engineer** | Electrical fire causation, equipment damage | Engineering report | $3K-$15K |

### 17.2 Expert Engagement Data Model

| Field | Type | Description |
|---|---|---|
| engagement_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| feature_id | UUID | Link to feature (if feature-specific) |
| expert_type | VARCHAR | Type of expert |
| expert_name | VARCHAR | Expert name |
| expert_company | VARCHAR | Company/firm |
| expert_specialty | VARCHAR | Specific specialty |
| engagement_date | DATE | Date engaged |
| purpose | TEXT | Specific questions/purpose |
| scope_of_work | TEXT | Defined scope |
| estimated_cost | DECIMAL | Cost estimate |
| authorized_by | VARCHAR | Who authorized engagement |
| report_due_date | DATE | Expected report date |
| report_received_date | DATE | Actual report received |
| report_document_ref | VARCHAR | Link to report document |
| findings_summary | TEXT | Summary of expert findings |
| opinion | TEXT | Expert's opinion/conclusions |
| invoice_amount | DECIMAL | Actual cost |
| payment_id | UUID | Link to payment record |
| status | VARCHAR | Requested, Engaged, Report Pending, Complete, Cancelled |

---

## 18. Investigation Technology

### 18.1 Technology Capabilities

| Technology | Application | Claims System Integration |
|---|---|---|
| **Drones** | Roof inspection (property), large loss aerial views, inaccessible areas | Photos/video uploaded to document management; tagged to claim |
| **Satellite Imagery** | Pre/post-event comparison (CAT), verifying structures existed, damage extent | Imagery integrated into claims dashboard; before/after comparison |
| **IoT / Smart Home** | Water leak detection, security cameras, smart smoke detectors | Event data feeds into FNOL; sensor data as evidence |
| **Telematics** | Crash detection, speed/force data, driver behavior | Trip data as evidence; auto-FNOL trigger |
| **Social Media Analysis** | Claimant activity monitoring (SIU), fraud detection | OSINT tools integrated with SIU workflow |
| **AI/ML Image Analysis** | Damage detection from photos, severity assessment, fraud detection | Photo analysis API in FNOL and estimation workflows |
| **Predictive Analytics** | Reserve forecasting, claim outcome prediction, fraud scoring | Models integrated into triage and evaluation |
| **Natural Language Processing** | Statement analysis, document extraction, FNOL automation | NLP pipeline processes notes, statements, medical records |
| **Geospatial Analysis** | Loss location mapping, CAT impact assessment, weather overlay | GIS layer in claims dashboard |
| **Video Analysis** | Surveillance footage review, dashcam analysis | Video management integrated with claim file |

### 18.2 Technology Integration Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│               INVESTIGATION TECHNOLOGY STACK                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────┐               │
│  │            CLAIMS CORE SYSTEM                 │               │
│  │  (Investigation Module)                       │               │
│  └──────────────┬───────────────────────────────┘               │
│                 │                                               │
│     ┌───────────┼───────────┬────────────┬───────────┐          │
│     │           │           │            │           │          │
│ ┌───▼───┐  ┌───▼───┐  ┌───▼───┐   ┌────▼────┐  ┌──▼──────┐   │
│ │Drone  │  │Satell.│  │IoT /  │   │AI Photo │  │Social  │   │
│ │Platform│  │Imagery│  │Telemat│   │Analysis │  │Media   │   │
│ │(DJI,  │  │(Planet│  │(CCC,  │   │(Tractable│ │Monitor │   │
│ │Betterv│  │ Maxar)│  │Verisk)│   │ CCC)    │  │(Babel- │   │
│ │iew)   │  │       │  │       │   │         │  │street) │   │
│ └───────┘  └───────┘  └───────┘   └─────────┘  └────────┘   │
│                                                                 │
│ All outputs → Claims Document Management + Evidence Store       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 19. Activity Tracking & Diary Management

### 19.1 Activity Pattern Library

```
SYSTEM-GENERATED ACTIVITIES (by claim type):

AUTO PHYSICAL DAMAGE:
  ACT-001: Contact insured (Due: Assignment + 24h)
  ACT-002: Verify coverage (Due: Assignment + 48h)
  ACT-003: Arrange vehicle inspection (Due: Assignment + 3 days)
  ACT-004: Review estimate (Due: Estimate receipt + 2 days)
  ACT-005: Set/review reserves (Due: Assignment + 5 days)
  ACT-006: Authorize repairs / process payment (Due: Estimate + 3 days)
  ACT-007: Rental monitoring (Due: Every 14 days while rental active)
  ACT-008: Subrogation referral (Due: Payment + 5 days)
  ACT-009: Close claim review (Due: Payment clear + 5 days)

AUTO BODILY INJURY:
  ACT-101: Contact insured (Due: Assignment + 24h)
  ACT-102: Contact claimant/attorney (Due: Assignment + 48h)
  ACT-103: Request police report (Due: Assignment + 3 days)
  ACT-104: Obtain recorded statement - insured (Due: Assignment + 7 days)
  ACT-105: Obtain medical authorization (Due: First contact + 5 days)
  ACT-106: Review initial medical records (Due: Receipt + 5 days)
  ACT-107: Liability determination (Due: Assignment + 30 days)
  ACT-108: Reserve review (Due: Every 30 days)
  ACT-109: Medical status follow-up (Due: Every 30 days)
  ACT-110: BI evaluation (Due: Treatment conclusion + 15 days)
  ACT-111: Settlement negotiation (Due: After evaluation)
  ACT-112: Supervisor review (Due: Every 90 days)

HOMEOWNERS PROPERTY:
  ACT-201: Contact insured (Due: Assignment + 24h)
  ACT-202: Emergency mitigation authorization (Due: IMMEDIATE if needed)
  ACT-203: Verify coverage (Due: Assignment + 48h)
  ACT-204: Schedule inspection (Due: Assignment + 3 days)
  ACT-205: Prepare Xactimate estimate (Due: Inspection + 5 days)
  ACT-206: Contents inventory follow-up (Due: Inspection + 14 days)
  ACT-207: Reserve setting (Due: Estimate completion)
  ACT-208: Issue ACV payment (Due: Agreement + 5 days)
  ACT-209: Supplement review (Due: As received + 3 days)
  ACT-210: Recoverable depreciation follow-up (Due: 90 days)
  ACT-211: Mortgage company coordination (Due: Payment issuance)
  ACT-212: Close claim review (Due: Final payment + 10 days)
```

### 19.2 Activity Escalation Rules

| Condition | Action | Notification |
|---|---|---|
| Activity 1 day overdue | Highlight in adjuster dashboard (yellow) | Email to adjuster |
| Activity 3 days overdue | Flag in supervisor dashboard (orange) | Email to supervisor |
| Activity 7 days overdue | Auto-escalate to supervisor queue (red) | Email to adjuster + supervisor |
| Activity 14 days overdue | Manager notification | Email to manager |
| 3+ activities overdue on single claim | Automatic supervisor review trigger | Email to supervisor |
| 5+ activities overdue for single adjuster | Workload review trigger | Notification to manager |

---

## 20. Authority Levels & Approval Workflows

### 20.1 Authority Matrix Implementation

```
AUTHORITY ENFORCEMENT IN CLAIMS SYSTEM:

1. TRANSACTION AUTHORITY CHECK
   Every reserve change and payment request checks:
   
   IF transaction_amount <= user.authority_limit
     AND user.authority_type includes transaction_type
     AND claim.special_flags not requiring higher authority
   THEN → AUTO-APPROVE (no approval workflow triggered)
   ELSE → ROUTE TO APPROVAL WORKFLOW

2. APPROVAL WORKFLOW
   ┌──────────────┐
   │  Transaction  │
   │  Submitted    │
   └──────┬───────┘
          │
   ┌──────▼───────┐     ┌──────────────────┐
   │  Authority    │ NO  │  Find Appropriate │
   │  Check: OK?   │────►│  Approver         │
   └──────┬───────┘     │  (next level up    │
          │ YES         │   with sufficient  │
          ▼              │   authority)       │
   ┌──────────────┐     └──────┬───────────┘
   │  Execute     │            │
   │  Transaction │     ┌──────▼───────────┐
   └──────────────┘     │  Send Approval    │
                        │  Request          │
                        └──────┬───────────┘
                               │
                        ┌──────▼───────────┐
                        │  Approver Reviews │
                        │  ├── Approve      │
                        │  ├── Reject       │
                        │  ├── Modify       │
                        │  └── Escalate     │
                        └──────────────────┘

3. APPROVAL LEVELS (example)
   Level 1: Adjuster Tier 1 (up to $15K)
   Level 2: Adjuster Tier 2 (up to $50K)
   Level 3: Senior Adjuster (up to $100K)
   Level 4: Examiner (up to $250K)
   Level 5: Claims Manager (up to $500K)
   Level 6: VP Claims (up to $2M)
   Level 7: Claims Committee / C-Suite (unlimited)
```

### 20.2 Approval Data Model

| Field | Type | Description |
|---|---|---|
| approval_id | UUID | Unique identifier |
| claim_id | UUID | Link to claim |
| transaction_type | VARCHAR | Reserve, Payment, Settlement, Denial, Closure |
| transaction_id | UUID | Link to specific transaction |
| amount | DECIMAL | Amount requiring approval |
| requested_by | UUID | User who submitted |
| requested_date | DATETIME | When submitted |
| approver_id | UUID | User who should approve |
| approver_role | VARCHAR | Supervisor, Examiner, Manager, VP |
| authority_level_required | INTEGER | Minimum authority level needed |
| status | VARCHAR | Pending, Approved, Rejected, Escalated, Withdrawn |
| decision_date | DATETIME | When decision made |
| decision_comments | TEXT | Approver's comments |
| auto_escalation_date | DATETIME | When auto-escalation triggers |

---

## 21. Investigation Report Templates & Data Structures

### 21.1 Investigation Report — Auto Claim

```
INVESTIGATION REPORT TEMPLATE:

CLAIM INFORMATION
  Claim Number: _______________
  Policy Number: _______________
  Insured: _______________
  Loss Date: _______________
  Report Date: _______________
  Adjuster: _______________

LOSS FACTS
  Description: _______________________________________________
  Location: _________________________________________________
  Cause of Loss: ____________________________________________
  Weather/Road/Visibility: ___________________________________

COVERAGE ANALYSIS
  Applicable Coverages: ______________________________________
  Limits: ___________________________________________________
  Deductible: _______________________________________________
  Coverage Issues: ___________________________________________
  Determination: Covered / Partially Covered / Denied / ROR

LIABILITY ANALYSIS
  Insured Fault %: _________
  Claimant Fault %: ________
  Basis: ____________________________________________________
  Framework: Comparative Negligence / Contributory / No-Fault
  Supporting Evidence: _______________________________________
  Adverse Evidence: __________________________________________

DAMAGE ASSESSMENT
  Vehicle Damage: ____________________________________________
  Repair Estimate: $__________
  Total Loss: Yes / No
  ACV (if TL): $__________

INJURY ASSESSMENT (per claimant)
  Claimant: __________________________________________________
  Injuries: __________________________________________________
  Medical Treatment: __________________________________________
  Medical Specials: $__________
  Prognosis: _________________________________________________
  Attorney: __________________________________________________

FINANCIAL SUMMARY
  Feature         Reserve     Paid     Total Incurred
  COLL            $________   $______  $________
  BI-1            $________   $______  $________
  PD              $________   $______  $________
  RENTAL          $________   $______  $________
  ALAE            $________   $______  $________
  TOTAL           $________   $______  $________

SUBROGATION
  Potential: Yes / No
  Recovery Estimate: $__________
  Status: ___________________________________________________

SIU REVIEW
  Fraud Indicators: __________________________________________
  SIU Referred: Yes / No

PLAN OF ACTION
  1. ________________________________________________________
  2. ________________________________________________________
  3. ________________________________________________________

RECOMMENDATIONS
  ___________________________________________________________
  ___________________________________________________________
```

---

## 22. Quality Assurance & Audit Processes

### 22.1 Claims QA Framework

```
QUALITY ASSURANCE PROGRAM:

AUDIT TYPES:
├── File Review (Desk Audit)
│   ├── Random sample: 5-10% of closed claims per adjuster per quarter
│   ├── Targeted: 100% of large losses, denials, complaints
│   └── Conducted by: QA specialist or supervisor
│
├── Reinspection
│   ├── Random sample: 3-5% of field inspections
│   ├── Conducted by: Senior adjuster or IA
│   └── Compares original estimate to reinspection findings
│
├── Payment Audit
│   ├── Random sample: 2-5% of payments
│   ├── Verify: correct payee, amount, coding, authority
│   └── Conducted by: Finance/Compliance
│
└── Regulatory Compliance Audit
    ├── Timing compliance (SLAs met per state law)
    ├── Communication compliance (proper notices sent)
    ├── File documentation completeness
    └── Conducted by: Compliance unit

SCORING METHODOLOGY:
  Each audited claim scored on scale of 1-5 (or 0-100):
  
  Categories:
  1. Coverage Analysis (20%)
     - Policy verified, coverage correctly identified
     - Exclusions properly analyzed
     - Determination documented
  
  2. Investigation Quality (25%)
     - Timely contact
     - All parties contacted
     - Evidence gathered
     - Liability properly determined
  
  3. Reserve Accuracy (15%)
     - Reserves set timely
     - Reserves reflect investigation findings
     - Reserves updated as claim develops
  
  4. Payment Accuracy (15%)
     - Correct amount
     - Correct payee
     - Proper authorization
     - Correct coding
  
  5. Documentation (10%)
     - Claim notes complete and timely
     - All activities documented
     - File tells the story
  
  6. Regulatory Compliance (15%)
     - SLAs met
     - Required notices sent
     - State-specific requirements
```

### 22.2 Audit Data Model

| Field | Type | Description |
|---|---|---|
| audit_id | UUID | Unique identifier |
| claim_id | UUID | Audited claim |
| audit_type | VARCHAR | FileReview, Reinspection, PaymentAudit, Compliance |
| audit_date | DATE | When audit performed |
| auditor_id | UUID | Who performed audit |
| adjuster_id | UUID | Adjuster whose work is audited |
| overall_score | DECIMAL | Overall audit score (0-100) |
| coverage_score | DECIMAL | Coverage analysis score |
| investigation_score | DECIMAL | Investigation quality score |
| reserve_score | DECIMAL | Reserve accuracy score |
| payment_score | DECIMAL | Payment accuracy score |
| documentation_score | DECIMAL | Documentation score |
| compliance_score | DECIMAL | Regulatory compliance score |
| findings | JSON | Array of specific findings |
| recommendations | TEXT | Recommendations for improvement |
| action_required | BOOLEAN | Are corrective actions needed? |
| corrective_actions | JSON | Array of required corrective actions |
| adjuster_response | TEXT | Adjuster's response to findings |
| follow_up_date | DATE | Date to verify corrections |
| status | VARCHAR | Completed, ActionRequired, Resolved |

---

## 23. Performance Metrics for Adjusters

### 23.1 Adjuster Performance Dashboard

| Metric Category | Metric | Formula | Target |
|---|---|---|---|
| **Volume** | Open Caseload | Current open claims | Within capacity tier |
| **Volume** | Claims Closed per Month | Count closed in period | 25-50 (varies by type) |
| **Volume** | Closing Ratio | Closed / Opened in period | > 1.0 |
| **Timeliness** | Contact SLA Compliance | % claims contacted within SLA | > 95% |
| **Timeliness** | Average Cycle Time | Avg (Close Date - Report Date) | Below LOB benchmark |
| **Timeliness** | Diary Compliance | % diaries completed on time | > 90% |
| **Timeliness** | Reserve Timeliness | % reserves set within 48 hours | > 95% |
| **Quality** | QA Audit Score | Average audit score | > 85% |
| **Quality** | Reserve Accuracy | Actual Ultimate / Initial Reserve | 0.90-1.10 |
| **Quality** | Complaint Rate | DOI complaints / claims handled | < 0.1% |
| **Quality** | Reopening Rate | Reopened claims / Closed claims | < 5% |
| **Financial** | Average Paid per Claim | Total Paid / Claim Count | At or below benchmark |
| **Financial** | ALAE per Claim | ALAE / Claim Count | Below benchmark |
| **Financial** | Subrogation Referral Rate | Subrog referrals / eligible claims | > 80% of eligible |
| **Financial** | Recovery Rate | Recoveries / Total Paid | Benchmark by LOB |
| **Satisfaction** | Customer NPS | Survey-based | > 50 |
| **Satisfaction** | Policyholder Retention | Retention rate for claims customers | > 80% |
| **Compliance** | State SLA Compliance | % meeting state-mandated timelines | 100% |
| **Compliance** | Litigation Rate | Claims entering litigation / Total claims | Below benchmark |
| **Compliance** | Bad Faith Allegations | Count in period | Zero is target |

### 23.2 Performance Scoring Algorithm

```
ADJUSTER PERFORMANCE SCORE (0-100):

score = (
    volume_score × 0.15
  + timeliness_score × 0.25
  + quality_score × 0.30
  + financial_score × 0.20
  + satisfaction_score × 0.10
)

Where each component is 0-100 based on metric targets:
  100 = exceeds all targets
  80  = meets all targets
  60  = meets most targets
  40  = below targets
  20  = significantly below targets

Ratings:
  90-100: Exceptional
  80-89:  Exceeds Expectations
  70-79:  Meets Expectations
  60-69:  Needs Improvement
  <60:    Performance Action Required
```

### 23.3 Adjuster Scorecard Data Model

| Field | Type | Description |
|---|---|---|
| scorecard_id | UUID | Unique identifier |
| adjuster_id | UUID | Adjuster |
| period_start | DATE | Scoring period start |
| period_end | DATE | Scoring period end |
| open_caseload_avg | DECIMAL | Average open claims |
| claims_closed | INTEGER | Claims closed in period |
| closing_ratio | DECIMAL | Closed/Opened ratio |
| contact_sla_pct | DECIMAL | % meeting contact SLA |
| avg_cycle_time_days | DECIMAL | Average cycle time |
| diary_compliance_pct | DECIMAL | % diaries on time |
| qa_score_avg | DECIMAL | Average audit score |
| reserve_accuracy | DECIMAL | Reserve accuracy ratio |
| complaint_count | INTEGER | DOI complaints |
| reopen_rate_pct | DECIMAL | Reopening rate |
| avg_paid_per_claim | DECIMAL | Average paid |
| alae_per_claim | DECIMAL | Average ALAE |
| subrog_referral_rate | DECIMAL | Subrogation referral rate |
| nps_score | DECIMAL | Net Promoter Score |
| state_sla_compliance | DECIMAL | State mandate compliance |
| litigation_rate | DECIMAL | Litigation rate |
| overall_score | DECIMAL | Composite performance score |
| rating | VARCHAR | Exceptional/Exceeds/Meets/NeedsImprovement/ActionRequired |
| manager_comments | TEXT | Manager commentary |
| improvement_plan | TEXT | If needed, specific plan |

---

*End of Article 5 — Claims Investigation & Adjustment: Complete Guide*
