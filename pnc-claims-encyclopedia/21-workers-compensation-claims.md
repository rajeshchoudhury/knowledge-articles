# Workers Compensation Claims: Complete Specialization Guide

## Table of Contents

1. [Workers Compensation System Overview](#1-workers-compensation-system-overview)
2. [WC Coverage Types](#2-wc-coverage-types)
3. [WC Policy Structure](#3-wc-policy-structure)
4. [Classification Codes and Rating](#4-classification-codes-and-rating)
5. [WC Claim Types](#5-wc-claim-types)
6. [WC FNOL Requirements](#6-wc-fnol-requirements)
7. [FROI/SROI Electronic Reporting](#7-froisroi-electronic-reporting)
8. [State-Specific Filing Requirements](#8-state-specific-filing-requirements)
9. [WC Claims Investigation](#9-wc-claims-investigation)
10. [Medical Management](#10-medical-management)
11. [Pharmacy Benefit Management in WC](#11-pharmacy-benefit-management-in-wc)
12. [Return-to-Work Programs](#12-return-to-work-programs)
13. [Disability Duration Management](#13-disability-duration-management)
14. [Permanent Impairment Rating](#14-permanent-impairment-rating)
15. [Indemnity Calculation](#15-indemnity-calculation)
16. [State-Specific Benefit Calculations](#16-state-specific-benefit-calculations)
17. [Medicare Set-Aside (MSA)](#17-medicare-set-aside-msa)
18. [Settlements](#18-settlements)
19. [Second Injury Funds](#19-second-injury-funds)
20. [Subrogation in WC](#20-subrogation-in-wc)
21. [WC Fraud](#21-wc-fraud)
22. [Experience Modification Rating](#22-experience-modification-rating)
23. [Large Deductible and Self-Insured Programs](#23-large-deductible-and-self-insured-programs)
24. [TPA Management for WC Claims](#24-tpa-management-for-wc-claims)
25. [WC Regulatory Reporting](#25-wc-regulatory-reporting)
26. [OSHA Reporting Requirements](#26-osha-reporting-requirements)
27. [WC Data Standards](#27-wc-data-standards)
28. [WC Claims Data Model](#28-wc-claims-data-model)
29. [Integration with Medical Provider Networks](#29-integration-with-medical-provider-networks)
30. [Integration with Pharmacy Benefit Managers](#30-integration-with-pharmacy-benefit-managers)
31. [Integration with State WC Boards](#31-integration-with-state-wc-boards)
32. [NCCI EDI Data Formats](#32-ncci-edi-data-formats)
33. [WC Claims Performance Metrics](#33-wc-claims-performance-metrics)
34. [Technology Platform Requirements](#34-technology-platform-requirements)

---

## 1. Workers Compensation System Overview

### 1.1 Historical Foundation

Workers compensation is the oldest social insurance program in the United States, dating back to state-level enactments beginning with Wisconsin in 1911. The system was designed as a "grand bargain" between employers and employees—workers gave up the right to sue their employers in tort in exchange for guaranteed, no-fault benefits for workplace injuries and illnesses.

### 1.2 The No-Fault Principle

Unlike general liability or auto insurance, workers compensation operates on a strict no-fault basis:

```
+-------------------------------------------------------------------+
|                    NO-FAULT PRINCIPLE                              |
+-------------------------------------------------------------------+
|                                                                   |
|  Employee does NOT need to prove employer negligence               |
|  Employee receives benefits regardless of who was at fault         |
|  Employee cannot be denied benefits for own carelessness           |
|  (except in specific statutory exceptions)                        |
|                                                                   |
|  EXCEPTIONS (vary by state):                                      |
|  - Willful misconduct / intentional self-injury                   |
|  - Intoxication (alcohol / drugs)                                 |
|  - Violation of safety rules (some states)                        |
|  - Horseplay / deviation from employment                          |
|  - Injury during commission of a crime                            |
|                                                                   |
+-------------------------------------------------------------------+
```

### 1.3 Exclusive Remedy Doctrine

The exclusive remedy doctrine is the employer's side of the bargain:

| Aspect | Description |
|--------|-------------|
| **Core Principle** | Workers compensation is the exclusive remedy for workplace injuries |
| **Effect** | Employee cannot sue employer in tort for covered injuries |
| **Exceptions** | Intentional torts by employer, dual-capacity doctrine, third-party claims |
| **State Variations** | Some states allow tort action for gross negligence or willful misconduct |
| **Co-employee Liability** | Most states extend exclusive remedy to co-employees |

### 1.4 State-Regulated System

Workers compensation is primarily regulated at the state level, creating a patchwork of different laws, benefits, and requirements:

```
+-----------------------------------------------------------------------+
|                   STATE REGULATORY FRAMEWORK                          |
+-----------------------------------------------------------------------+
|                                                                       |
|  MONOPOLISTIC STATE FUNDS (must buy from state):                      |
|  - Ohio, Washington, Wyoming, North Dakota                            |
|                                                                       |
|  COMPETITIVE STATE FUNDS (state fund competes with private):          |
|  - California (SCIF), New York (NYSIF), Texas (TSIA),                |
|  - Arizona, Colorado, Idaho, Kentucky, Louisiana, Maryland,           |
|  - Maine, Minnesota, Missouri, Montana, New Mexico, Oklahoma,         |
|  - Oregon, Pennsylvania, Rhode Island, Utah                           |
|                                                                       |
|  PRIVATE MARKET ONLY (no state fund):                                 |
|  - Remaining states                                                   |
|                                                                       |
|  FEDERAL PROGRAMS:                                                    |
|  - FECA (Federal Employees' Compensation Act)                         |
|  - Longshore & Harbor Workers (LHWCA)                                 |
|  - Jones Act (maritime)                                               |
|  - Black Lung                                                         |
|  - EEOICPA (Energy Employees)                                         |
|                                                                       |
+-----------------------------------------------------------------------+
```

### 1.5 Key Stakeholders

```
                        +-------------------+
                        |   STATE WC BOARD  |
                        |  / COMMISSION     |
                        +--------+----------+
                                 |
          +----------+-----------+-----------+-----------+
          |          |           |           |           |
     +----+----+ +---+---+ +----+----+ +----+----+ +---+----+
     |EMPLOYER | |EMPLOYEE| |INSURER/ | |MEDICAL  | |LEGAL   |
     |         | |/WORKER | |TPA      | |PROVIDER | |COUNSEL |
     +---------+ +--------+ +---------+ +---------+ +--------+
          |                      |
     +----+----+            +----+----+
     |SAFETY   |            |REINSURER|
     |MANAGER  |            |         |
     +---------+            +---------+
```

---

## 2. WC Coverage Types

### 2.1 Medical Benefits

Medical benefits cover all reasonable and necessary medical treatment related to the work injury:

| Benefit Component | Description |
|-------------------|-------------|
| **Emergency Treatment** | Immediate medical care following injury |
| **Hospital/Surgical** | Inpatient and outpatient facility charges |
| **Physician Services** | Office visits, consultations, procedures |
| **Prescription Drugs** | Medications related to the injury |
| **Physical Therapy** | Rehabilitation services |
| **Durable Medical Equipment** | Braces, crutches, prosthetics, wheelchairs |
| **Diagnostic Testing** | X-rays, MRIs, CT scans, lab work |
| **Mileage/Transportation** | Travel to and from medical appointments |
| **Home Health Care** | Nursing services, attendant care |
| **Prosthetics/Orthotics** | Artificial limbs, custom supports |

**Medical Fee Schedules**: Most states impose fee schedules that cap reimbursement rates:

```
STATE MEDICAL FEE SCHEDULE APPROACHES:
+------------------------------------------------------------------+
| APPROACH            | STATES           | BASIS                   |
+------------------------------------------------------------------+
| RBRVS-based         | CA, FL, TX, etc. | Medicare RBRVS x factor |
| Own schedule        | NY, PA, etc.     | State-developed fees    |
| Usual & Customary   | Some states      | Market-rate based       |
| Medicare multiplier | Many states      | % of Medicare rates     |
+------------------------------------------------------------------+

Example: California Official Medical Fee Schedule (OMFS)
  - Physician services: 120% of Medicare RBRVS
  - Hospital outpatient: 120% of Medicare APC
  - Hospital inpatient: DRG-based with per-diem outlier
  - Pharmacy: AWP-based with state-specific formula
```

### 2.2 Temporary Disability Benefits

Temporary disability benefits replace a portion of lost wages during the healing period:

**Temporary Total Disability (TTD)**:
- Paid when employee is completely unable to work due to injury
- Typically calculated as 2/3 of pre-injury average weekly wage (AWW)
- Subject to state maximum and minimum weekly rates
- Duration: from date of disability until Maximum Medical Improvement (MMI)

**Temporary Partial Disability (TPD)**:
- Paid when employee can work but at reduced capacity/earnings
- Typically calculated as 2/3 of the difference between pre-injury and post-injury wages
- Encourages return to modified or light duty work

```
TTD CALCULATION FLOW:
+------------------------------------------------------------------+
|                                                                  |
|  1. Calculate Average Weekly Wage (AWW)                          |
|     AWW = Total wages in 52 weeks prior / 52                    |
|     (various methods depending on state and employment pattern)  |
|                                                                  |
|  2. Apply Compensation Rate                                      |
|     Comp Rate = AWW × State Percentage (typically 66.67%)       |
|                                                                  |
|  3. Apply State Caps                                             |
|     If Comp Rate > State Maximum → use State Maximum             |
|     If Comp Rate < State Minimum → use State Minimum             |
|                                                                  |
|  4. Apply Waiting Period                                         |
|     Most states: 3-7 day waiting period before benefits begin   |
|     If disability exceeds retroactive period (14-28 days),      |
|     waiting period days are paid retroactively                   |
|                                                                  |
|  5. Payment continues until:                                     |
|     - Return to full duty                                        |
|     - Maximum Medical Improvement (MMI)                          |
|     - State statutory maximum duration                           |
|     - Conversion to permanent disability                         |
|                                                                  |
+------------------------------------------------------------------+
```

### 2.3 Permanent Disability Benefits

**Permanent Partial Disability (PPD)**:
- Paid when employee reaches MMI with permanent residual impairment
- Does not fully prevent employee from working
- Two approaches:
  - **Scheduled**: Based on body part (e.g., loss of finger = X weeks)
  - **Unscheduled**: Based on loss of wage-earning capacity

**Permanent Total Disability (PTD)**:
- Paid when employee is permanently and totally unable to work
- Typically paid for life or until retirement age
- Some states have scheduled PTD conditions (e.g., loss of both eyes, both hands)

```
PERMANENT DISABILITY CLASSIFICATION:
+---------------------------------------------------------------------+
|                                                                     |
|  SCHEDULED INJURIES (body part specific):                            |
|  +-------------------+------------------+-------------------------+ |
|  | Body Part         | Typical Weeks    | Example Rate (at $500)  | |
|  +-------------------+------------------+-------------------------+ |
|  | Thumb             | 60-75 weeks      | $30,000 - $37,500       | |
|  | Index Finger      | 35-46 weeks      | $17,500 - $23,000       | |
|  | Hand              | 150-244 weeks    | $75,000 - $122,000      | |
|  | Arm               | 200-312 weeks    | $100,000 - $156,000     | |
|  | Foot              | 125-205 weeks    | $62,500 - $102,500      | |
|  | Leg               | 175-288 weeks    | $87,500 - $144,000      | |
|  | Eye               | 100-275 weeks    | $50,000 - $137,500      | |
|  | Hearing (one ear) | 50-150 weeks     | $25,000 - $75,000       | |
|  +-------------------+------------------+-------------------------+ |
|                                                                     |
|  UNSCHEDULED INJURIES (wage-loss or impairment based):              |
|  - Back injuries                                                     |
|  - Head/brain injuries                                               |
|  - Internal organ injuries                                           |
|  - Occupational diseases                                             |
|  - Psychological injuries                                            |
|  Calculation: % impairment × maximum weeks × comp rate              |
|                                                                     |
+---------------------------------------------------------------------+
```

### 2.4 Death Benefits

Death benefits are payable when a work-related injury or illness results in employee death:

| Component | Description |
|-----------|-------------|
| **Burial Expenses** | Fixed statutory amount ($5,000 - $15,000 typical) |
| **Surviving Spouse** | Weekly benefits (typically 60-67% of AWW), may be lifetime or fixed duration |
| **Dependent Children** | Additional weekly benefits per child, until age 18/23 |
| **Other Dependents** | Parents or other dependents in some states |
| **Maximum Total** | Some states cap total death benefits, others pay for life |

### 2.5 Vocational Rehabilitation

Vocational rehabilitation services help injured workers return to employment:

```
VOCATIONAL REHABILITATION SERVICES:
+------------------------------------------------------------------+
|                                                                  |
|  EVALUATION SERVICES:                                            |
|  - Transferable skills analysis                                  |
|  - Labor market survey                                           |
|  - Vocational testing and assessment                             |
|  - Functional capacity evaluation (FCE)                          |
|                                                                  |
|  RETRAINING SERVICES:                                            |
|  - On-the-job training                                           |
|  - Formal education/certification programs                       |
|  - Skills training                                               |
|  - Job placement assistance                                      |
|                                                                  |
|  SUPPLEMENTAL BENEFITS:                                          |
|  - Maintenance allowance during retraining                       |
|  - Tuition and supplies                                          |
|  - Transportation assistance                                     |
|                                                                  |
|  STATE EXAMPLES:                                                 |
|  - CA: Supplemental Job Displacement Benefit (SJDB) voucher      |
|    ($6,000 voucher for retraining)                               |
|  - WA: Comprehensive vocational rehabilitation program           |
|  - OR: Extensive retraining with maintenance benefits            |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 3. WC Policy Structure

### 3.1 Standard Workers Compensation Policy

The standard WC policy (NCCI form) consists of two parts:

```
WORKERS COMPENSATION POLICY STRUCTURE:
+======================================================================+
|                                                                      |
|  PART ONE: WORKERS COMPENSATION INSURANCE (STATUTORY)                |
|  +----------------------------------------------------------------+  |
|  | - Covers statutory obligations under the WC law of each state  |  |
|  |   listed on the Information Page                                |  |
|  | - No policy limit (pays whatever the statute requires)          |  |
|  | - Benefits determined entirely by state law                     |  |
|  | - Insurer agrees to pay all compensation and benefits required  |  |
|  | - Includes medical benefits, disability, death benefits          |  |
|  | - Insurer has right and duty to defend claims                   |  |
|  | - Employer must comply with WC law                              |  |
|  +----------------------------------------------------------------+  |
|                                                                      |
|  PART TWO: EMPLOYERS LIABILITY INSURANCE                             |
|  +----------------------------------------------------------------+  |
|  | - Covers employer's common law liability for employee injuries  |  |
|  |   NOT covered under WC statute                                  |  |
|  | - Subject to policy limits:                                      |  |
|  |   - Bodily Injury by Accident: $_____ each accident             |  |
|  |   - Bodily Injury by Disease: $_____ policy limit               |  |
|  |   - Bodily Injury by Disease: $_____ each employee              |  |
|  | - Standard minimum: $100,000 / $500,000 / $100,000              |  |
|  | - Common higher limits: $500K/$500K/$500K, $1M/$1M/$1M          |  |
|  | - Covers third-party over actions, dual capacity, consequential |  |
|  |   bodily injury to spouse/family                                |  |
|  +----------------------------------------------------------------+  |
|                                                                      |
|  PART THREE: OTHER STATES INSURANCE                                  |
|  +----------------------------------------------------------------+  |
|  | - Provides coverage if employee injured in state not listed     |  |
|  |   on Information Page                                           |  |
|  | - "Other states" designated by endorsement                      |  |
|  +----------------------------------------------------------------+  |
|                                                                      |
+======================================================================+
```

### 3.2 Information Page (Declarations)

```
INFORMATION PAGE KEY FIELDS:
+------------------------------------------------------------------+
| Field                    | Description                            |
+------------------------------------------------------------------+
| Named Insured            | Employer legal entity name             |
| Policy Number            | Unique identifier                      |
| Policy Period            | Effective and expiration dates         |
| States Covered           | Part One applicable states             |
| Classification Codes     | NCCI or state bureau class codes       |
| Premium Basis            | Estimated annual remuneration per class|
| Rates                    | Rate per $100 of payroll per class     |
| Experience Mod           | Experience modification factor         |
| Premium Discount         | Volume discount schedule               |
| Minimum Premium          | Minimum policy premium                 |
| Retrospective Rating     | If applicable                          |
| Deductible               | If applicable (amount and type)        |
| Designated Medical       | Medical provider arrangement           |
| EL Limits                | Part Two limits                        |
+------------------------------------------------------------------+
```

### 3.3 Common Endorsements

| Endorsement | Form # | Description |
|-------------|--------|-------------|
| Other States | WC 00 03 | Extends coverage to designated other states |
| Waiver of Subrogation | WC 00 03 13 | Waives insurer's right to subrogate against named party |
| Alternate Employer | WC 00 03 01A | Extends coverage to staffing client employers |
| Voluntary Compensation | WC 00 03 11 | Covers employees excluded from WC law |
| USL&H Coverage | WC 00 01 06A | Adds Longshore & Harbor Workers coverage |
| Federal Employees | Various | FECA, Defense Base Act coverage |
| Deductible | WC 00 04 22 | Per-claim deductible endorsement |
| Experience Rating Mod | WC 00 04 03 | Applies experience modification factor |
| Retrospective Rating | WC 00 05 series | Retrospective premium plan |

---

## 4. Classification Codes and Rating

### 4.1 NCCI Classification System

The National Council on Compensation Insurance (NCCI) administers the classification system used in 38 states:

```
CLASSIFICATION CODE STRUCTURE:
+------------------------------------------------------------------+
|                                                                  |
|  CODE FORMAT: 4-digit numeric code                               |
|                                                                  |
|  EXAMPLES:                                                       |
|  +--------+----------------------------------------------+------+|
|  | Code   | Description                                  | Rate ||
|  +--------+----------------------------------------------+------+|
|  | 8810   | Clerical Office Employees                    | 0.18 ||
|  | 8742   | Salespersons - Outside                       | 0.38 ||
|  | 5190   | Electrical Wiring - Within Buildings          | 3.47 ||
|  | 5403   | Carpentry - Residential/Commercial           | 7.11 ||
|  | 5213   | Concrete Construction                        | 4.89 ||
|  | 7380   | Drivers, Chauffeurs, Delivery                | 5.90 ||
|  | 8017   | Store - Retail                               | 1.29 ||
|  | 9014   | Building Operations (janitors)               | 2.55 ||
|  | 8832   | Physician and Clerical                       | 0.27 ||
|  | 7219   | Trucking - Long Distance                     | 8.12 ||
|  +--------+----------------------------------------------+------+|
|                                                                  |
|  RATE BASIS: Per $100 of remuneration (payroll)                  |
|  RATE EXAMPLE: Code 5190 at $3.47 rate                           |
|    Annual payroll = $500,000                                     |
|    Manual premium = ($500,000 / $100) × $3.47 = $17,350         |
|                                                                  |
+------------------------------------------------------------------+
```

### 4.2 Independent Bureau States

Several states maintain their own classification and rating systems:

| State | Bureau | Notes |
|-------|--------|-------|
| California | WCIRB (Workers' Comp Insurance Rating Bureau) | Own classification system |
| Delaware | DCRB (Delaware Compensation Rating Bureau) | Follows NCCI with modifications |
| Indiana | IICRB | Independent bureau |
| Massachusetts | WCRIBMA | Independent bureau |
| Michigan | NCCI administers but state-specific | Modified classifications |
| Minnesota | MWCIA (Minnesota Workers' Comp Insurers Assoc) | Independent bureau |
| New Jersey | NJCRIB | Independent bureau |
| New York | NYCIRB (New York Compensation Insurance Rating Board) | Own classification system |
| North Carolina | NCRB | Independent bureau |
| Pennsylvania | PCRB (Pennsylvania Compensation Rating Bureau) | Independent bureau |
| Texas | TDI (Texas Department of Insurance) | Independent bureau |
| Wisconsin | WCRB (Wisconsin Compensation Rating Bureau) | Independent bureau |

### 4.3 Premium Calculation

```
PREMIUM CALCULATION FLOW:
+------------------------------------------------------------------+
|                                                                  |
|  Step 1: MANUAL PREMIUM                                          |
|    Payroll per class × Rate per $100 = Manual Premium per class  |
|    Sum all class manual premiums = Total Manual Premium           |
|                                                                  |
|  Step 2: EXPERIENCE MODIFICATION                                 |
|    Total Manual Premium × Experience Mod Factor = Modified Prem  |
|                                                                  |
|  Step 3: SCHEDULE RATING (where applicable)                      |
|    Modified Premium × (1 +/- Schedule Credit/Debit) = Sched Prem|
|                                                                  |
|  Step 4: PREMIUM DISCOUNT                                        |
|    Apply graduated discount table based on premium size          |
|    (larger policies get larger discounts)                         |
|                                                                  |
|  Step 5: EXPENSE CONSTANT                                        |
|    Add flat expense constant per policy                          |
|                                                                  |
|  Step 6: OTHER ADJUSTMENTS                                       |
|    + Terrorism surcharge (TRIA)                                  |
|    + Catastrophe provisions                                      |
|    + State assessments                                           |
|    + Other endorsement charges                                   |
|                                                                  |
|  = STANDARD PREMIUM (Final)                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 5. WC Claim Types

### 5.1 Classification by Severity

```
WC CLAIM TYPE HIERARCHY:
+------------------------------------------------------------------+
|                                                                  |
|  MEDICAL-ONLY CLAIMS                                             |
|  ├── No lost time beyond date of injury                          |
|  ├── Medical treatment only                                      |
|  ├── Typically 70-75% of all WC claims                           |
|  ├── Average cost: $800 - $2,000                                 |
|  └── Auto-adjudicated in many systems                            |
|                                                                  |
|  LOST-TIME / INDEMNITY CLAIMS                                    |
|  ├── TEMPORARY TOTAL DISABILITY (TTD)                            |
|  │   ├── Complete inability to work, temporary                   |
|  │   ├── Most common indemnity type                              |
|  │   ├── Average cost: $20,000 - $40,000                        |
|  │   └── Duration: weeks to months                               |
|  ├── TEMPORARY PARTIAL DISABILITY (TPD)                          |
|  │   ├── Reduced work capacity, temporary                        |
|  │   ├── Often during return-to-work transition                  |
|  │   └── Lower cost, shorter duration                            |
|  ├── PERMANENT PARTIAL DISABILITY (PPD)                          |
|  │   ├── Permanent impairment, partial loss of function          |
|  │   ├── Average cost: $50,000 - $150,000+                      |
|  │   └── Scheduled (body part) or unscheduled                    |
|  ├── PERMANENT TOTAL DISABILITY (PTD)                            |
|  │   ├── Complete permanent inability to work                    |
|  │   ├── Lifetime benefits in most states                        |
|  │   ├── Average cost: $500,000 - $2,000,000+                   |
|  │   └── May include statutory presumptions                      |
|  └── FATALITY CLAIMS                                             |
|      ├── Work-related death                                      |
|      ├── Burial benefits + survivor benefits                     |
|      ├── Average cost: $300,000 - $750,000+                     |
|      └── Complex dependent determination                         |
|                                                                  |
+------------------------------------------------------------------+
```

### 5.2 Classification by Nature of Injury

| Category | Examples | Coding |
|----------|----------|--------|
| **Traumatic** | Fractures, lacerations, contusions, burns | ANSI Z16.2, OSHA nature codes |
| **Cumulative Trauma** | Carpal tunnel, repetitive strain, hearing loss | Often denied initially; complex causation |
| **Occupational Disease** | Mesothelioma, silicosis, lead poisoning | Long latency, complex medical evidence |
| **Mental/Psychological** | PTSD, stress claims, mental-mental | Strict compensability rules in most states |
| **Aggravation** | Pre-existing condition worsened by work | Apportionment issues |

---

## 6. WC FNOL Requirements

### 6.1 Employer's First Report of Injury

The injury reporting chain begins with the employer:

```
WC INJURY REPORTING CHAIN:
+------------------------------------------------------------------+
|                                                                  |
|  STEP 1: EMPLOYEE REPORTS INJURY TO EMPLOYER                     |
|  ├── Verbal or written notice                                    |
|  ├── State deadline: typically 30-90 days from injury            |
|  └── Failure to report may bar claim (but rarely enforced)       |
|                                                                  |
|  STEP 2: EMPLOYER REPORTS TO INSURER/TPA                         |
|  ├── Complete employer's first report of injury form             |
|  ├── Timeline: within 24-48 hours recommended                   |
|  ├── Includes: employee info, injury details, witness info       |
|  └── Also directs employee to medical treatment                  |
|                                                                  |
|  STEP 3: EMPLOYER FILES WITH STATE                               |
|  ├── FROI form filed with state WC board                         |
|  ├── Deadline varies by state (3-30 days from knowledge)         |
|  ├── May be filed electronically (EDI) or paper                  |
|  └── Penalties for late filing                                   |
|                                                                  |
|  STEP 4: INSURER/TPA CREATES CLAIM                               |
|  ├── Assigns claim number                                        |
|  ├── Assigns adjuster                                            |
|  ├── Sets initial reserves                                       |
|  └── Begins compensability investigation                         |
|                                                                  |
|  STEP 5: INSURER FILES FROI TO STATE (if required)               |
|  ├── Electronic filing via IAIABC EDI                             |
|  ├── Confirms claim acceptance or denial                          |
|  └── Ongoing SROI reporting as events occur                      |
|                                                                  |
+------------------------------------------------------------------+
```

### 6.2 FNOL Data Requirements

```
WC FNOL DATA FIELDS (Comprehensive):
+------------------------------------------------------------------+
| SECTION              | FIELDS                                    |
+------------------------------------------------------------------+
| EMPLOYER INFO        | - Legal name                              |
|                      | - FEIN (Federal Employer ID)              |
|                      | - Policy number                           |
|                      | - SIC/NAICS code                          |
|                      | - Location address                        |
|                      | - Contact name and phone                  |
|                      | - Number of employees                     |
+------------------------------------------------------------------+
| EMPLOYEE INFO        | - Full legal name                         |
|                      | - SSN                                     |
|                      | - Date of birth                           |
|                      | - Gender                                  |
|                      | - Address                                 |
|                      | - Phone number                            |
|                      | - Hire date                               |
|                      | - Job title / occupation                  |
|                      | - Classification code                     |
|                      | - Marital status                          |
|                      | - Number of dependents                    |
|                      | - Average weekly wage                     |
|                      | - Employment status (FT/PT/seasonal)      |
+------------------------------------------------------------------+
| INJURY DETAILS       | - Date of injury                          |
|                      | - Time of injury                          |
|                      | - Date employer notified                  |
|                      | - Location of injury                      |
|                      | - County of injury                        |
|                      | - State of injury                         |
|                      | - Cause of injury code                    |
|                      | - Nature of injury code                   |
|                      | - Body part affected code                 |
|                      | - Description of accident                 |
|                      | - Witnesses (names, contacts)             |
|                      | - OSHA recordable (yes/no)               |
|                      | - Safety equipment in use                 |
+------------------------------------------------------------------+
| MEDICAL INFO         | - Initial treating physician              |
|                      | - Hospital/facility name                  |
|                      | - Initial diagnosis                       |
|                      | - Treatment date                          |
|                      | - Was employee hospitalized overnight?    |
|                      | - Return-to-work date (actual/estimated)  |
|                      | - Work restrictions                       |
+------------------------------------------------------------------+
| WAGE INFO            | - Wages for 52 weeks prior                |
|                      | - Pay frequency                           |
|                      | - Days/hours worked per week              |
|                      | - Overtime rate                           |
|                      | - Concurrent employment                   |
|                      | - Salary continuation (yes/no)            |
|                      | - Date last worked                        |
|                      | - Date disability began                   |
+------------------------------------------------------------------+
```

---

## 7. FROI/SROI Electronic Reporting

### 7.1 IAIABC EDI Standards

The International Association of Industrial Accident Boards and Commissions (IAIABC) developed the Claims Electronic Data Interchange (EDI) standard for WC claims reporting:

```
IAIABC EDI CLAIMS RELEASES:
+------------------------------------------------------------------+
| Release | Year  | Key Features                                  |
+------------------------------------------------------------------+
| R1      | 1990s | Initial electronic reporting standard          |
| R2      | 2000s | Expanded data elements, improved structure     |
| R3      | 2010+ | Current standard, most widely adopted          |
|         |       | - 3.0: FROI/SROI core                         |
|         |       | - 3.1: Enhanced features                       |
+------------------------------------------------------------------+
```

### 7.2 FROI (First Report of Injury) Transactions

```
FROI MAINTENANCE TYPE CODES:
+------------------------------------------------------------------+
| MTC  | Description                     | When Used               |
+------------------------------------------------------------------+
| 00   | Original First Report           | Initial claim filing     |
| 01   | Cancel                          | Cancel previously filed  |
| 02   | Change (Correction/Amendment)   | Correct data errors      |
| 04   | Denial                          | Deny the claim           |
| AU   | Acquired/Unallocated            | Acquired claims          |
| CO   | Change of Ownership             | Policy transfer          |
+------------------------------------------------------------------+

FROI DATA SEGMENTS (R3.0):
+------------------------------------------------------------------+
| Segment                  | Key Data Elements                     |
+------------------------------------------------------------------+
| Header                   | Sender/receiver, transaction info      |
| Claim Administrator      | TPA/insurer identifier, address        |
| Employer                 | FEIN, name, address, SIC code          |
| Employee                 | SSN, name, DOB, address, hire date     |
| Policy/Coverage          | Policy number, effective dates          |
| Injury/Illness           | Date, cause, nature, body part codes   |
| Wage                     | AWW, employment status, pay rate       |
| Medical                  | Initial treating provider, diagnosis    |
| Jurisdiction             | Filing state, jurisdiction claim number |
| Narrative                | Accident description                   |
+------------------------------------------------------------------+
```

### 7.3 SROI (Subsequent Report of Injury) Transactions

```
SROI MAINTENANCE TYPE CODES:
+------------------------------------------------------------------+
| MTC  | Description                        | Trigger               |
+------------------------------------------------------------------+
| 00   | Original Subsequent Report         | Initial status report   |
| 01   | Cancel                             | Cancel prior SROI       |
| 02   | Change/Correction                  | Correct data errors     |
| 04   | Denial                             | Claim denial            |
| AB   | Acquired Claim Benefits            | Assumed from prior carrier|
| AP   | Amended/Revised Payment            | Payment correction      |
| CA   | Claim Activity (Full Denial)       | Full claim denial       |
| CB   | Claim Activity (Partial Denial)    | Partial denial          |
| EP   | Employer Paid                      | Employer-paid claim     |
| ER   | Employer Reimbursement             | Employer paid, seeking reimb |
| FN   | Final Payment                      | Last indemnity payment  |
| IP   | Initial Payment                    | First indemnity payment |
| PD   | Payment (Ongoing)                  | Ongoing benefit status  |
| PY   | Payment Report                     | Payment details         |
| RB   | Reinstatement of Benefits          | Benefits reinstated     |
| RE   | Reopened                           | Claim reopened          |
| RJ   | Rejection                          | State rejected filing   |
| SA   | Suspension/Administrative          | Benefits suspended      |
| SD   | Suspension/Dependency              | Dependency change       |
| SE   | Suspension/Employee                | Employee action         |
| SF   | Suspension/Fraud                   | Fraud-related           |
| SI   | Suspension/Incarceration           | Employee incarcerated   |
| SM   | Suspension/Maximum                 | Max benefits reached    |
| SN   | Suspension/Non-cooperation         | Employee non-compliance |
| SR   | Suspension/Return to Work          | RTW-related suspension  |
| SS   | Settlement                         | Claim settled           |
| SX   | Suspension/Other                   | Other suspension reason |
| UR   | Unallocated Received               | Unallocated claim data  |
+------------------------------------------------------------------+
```

### 7.4 EDI File Structure

```
SAMPLE EDI TRANSACTION STRUCTURE (Simplified R3):
+------------------------------------------------------------------+
|                                                                  |
| ISA*00*          *00*          *ZZ*SENDER    *ZZ*RECEIVER  *...  |
| GS*HP*SENDERID*RECEIVERID*20250416*1234*1*X*005010...           |
| ST*148*0001                                                      |
|   BGN*11*123456789*20250416*1234                                 |
|   REF*SY*WC123456789          (Jurisdiction Claim Number)        |
|   REF*Y4*ADJ-001              (Claim Administrator Claim Number) |
|   DTP*431*D8*20250415          (Date of Injury)                  |
|   N1*31*EMPLOYER NAME*FI*123456789                               |
|   N1*IN*INJURED WORKER*SY*987654321                              |
|   DTP*336*D8*19850101          (Date of Birth)                   |
|   STC*P4:XX:X*20250416        (Status Code)                     |
|   ... additional segments ...                                    |
| SE*25*0001                                                       |
| GE*1*1                                                           |
| IEA*1*000000001                                                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 8. State-Specific Filing Requirements

### 8.1 Filing Deadlines by State (Selected)

| State | FROI Deadline | SROI Requirements | Filing Method | Penalty for Late Filing |
|-------|---------------|-------------------|---------------|------------------------|
| **CA** | Within 5 days of knowledge | When payments begin/end | EDI or paper | Up to $10,000 per violation |
| **TX** | Within 8 days of knowledge | Various SROIs required | EDI (mandatory) | Administrative penalties |
| **FL** | Within 7 days of knowledge | IP, FN, other SROIs | EDI (mandatory) | $500 per day late |
| **NY** | Within 18 days of disability | C-2F (employer), C-4 (physician) | Paper + EDI | Civil penalties |
| **IL** | Within 30 days | Various forms required | EDI or paper | Administrative penalties |
| **PA** | Within 21 days (disability) | Various SROIs | EDI (mandatory) | Up to $1,000 per day |
| **OH** | Within 14 days (BWC) | State fund reporting | BWC portal | Claim processing delays |
| **NJ** | Within 21 days | When benefits begin/change | EDI | Penalties per late filing |
| **GA** | Within 21 days | WC-1 (employer form) | EDI or paper | Up to $1,000 per violation |
| **NC** | Within 5 days of knowledge | Form 19 (employer) | EDI | $50/day late, max $2,500 |

### 8.2 State-Specific Form Requirements

```
STATE FORM EXAMPLES:
+------------------------------------------------------------------+
|                                                                  |
|  CALIFORNIA:                                                     |
|  - DWC-1 (Workers' Comp Claim Form - given to employee)          |
|  - 5020 (Employer's Report of Occupational Injury/Illness)       |
|  - 5021 (Insurer's Report)                                       |
|                                                                  |
|  NEW YORK:                                                       |
|  - C-2 (Employer's Report of Injury/Illness)                     |
|  - C-2F (Employer's Supplemental Report)                         |
|  - C-3 (Employee Claim form)                                     |
|  - C-4 (Doctor's Initial Report)                                 |
|  - C-4.2 (Doctor's Progress Report)                              |
|  - C-7 (Notice of Carrier/Employer Compliance)                   |
|  - C-8/C-8.1 (Notice of Dispute/Denial)                         |
|                                                                  |
|  TEXAS:                                                          |
|  - DWC Form-001 (Employee's Claim)                               |
|  - DWC Form-006 (Employer's First Report)                        |
|  - DWC Form-073 (Payment of Compensation)                        |
|  - PLN-1 (Payment of Income Benefits)                            |
|                                                                  |
|  FLORIDA:                                                        |
|  - DWC-1 (First Report of Injury/Illness)                        |
|  - DFS-F2-DWC-9 (Notice of Denial)                               |
|  - DFS-F2-DWC-6 (Wage Statement)                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 9. WC Claims Investigation

### 9.1 Compensability Determination

The primary investigation question in WC is compensability—whether the injury arises from and occurs in the course of employment:

```
COMPENSABILITY ANALYSIS FRAMEWORK:
+------------------------------------------------------------------+
|                                                                  |
|  AOE/COE DETERMINATION:                                          |
|  +------------------------------------------------------------+  |
|  |                                                            |  |
|  |  AOE (Arising Out of Employment):                          |  |
|  |  - Was the injury CAUSED by the employment?                |  |
|  |  - Causal connection between work and injury               |  |
|  |  - Tests: Peculiar Risk, Increased Risk, Positional Risk   |  |
|  |                                                            |  |
|  |  COE (Course of Employment):                               |  |
|  |  - Was the injury within the SCOPE of employment?          |  |
|  |  - Time, place, and circumstances of injury                |  |
|  |  - Was employee performing job duties?                      |  |
|  |                                                            |  |
|  |  BOTH must be satisfied for compensability                  |  |
|  |                                                            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  COMMON COMPENSABILITY ISSUES:                                   |
|  ├── Going and coming rule (generally not compensable)           |
|  │   ├── Exceptions: traveling employees, special mission        |
|  │   ├── Exceptions: employer-provided transport                  |
|  │   └── Exceptions: dual purpose trip                           |
|  ├── Lunch break injuries (generally not compensable)            |
|  │   ├── Exception: employer premises                            |
|  │   └── Exception: employer benefit                             |
|  ├── Horseplay (depends on extent of deviation)                  |
|  ├── Personal comfort doctrine (usually compensable)             |
|  ├── Acts of God (generally compensable if employment exposure)  |
|  ├── Idiopathic conditions (falls from personal medical cause)   |
|  ├── Pre-existing conditions (aggravation is compensable)        |
|  └── Mental injuries:                                            |
|      ├── Physical-mental (physical injury → mental condition)    |
|      ├── Mental-physical (mental stress → physical condition)    |
|      └── Mental-mental (mental stress → mental condition)        |
|          └── Most restrictive; many states don't cover           |
|                                                                  |
+------------------------------------------------------------------+
```

### 9.2 Investigation Process

```
WC INVESTIGATION WORKFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  1. THREE-POINT CONTACT (within 24 hours)                        |
|     ├── Contact employer for accident details                    |
|     ├── Contact employee for injury statement                    |
|     └── Contact treating physician for medical status            |
|                                                                  |
|  2. DOCUMENT COLLECTION                                          |
|     ├── Employer's first report of injury                        |
|     ├── Witness statements                                       |
|     ├── Surveillance video (if available)                        |
|     ├── Safety/incident investigation report                     |
|     ├── OSHA log entries                                         |
|     ├── Medical records (authorized release required)            |
|     ├── Wage records (52 weeks prior)                            |
|     └── Job description and physical requirements                |
|                                                                  |
|  3. MEDICAL REVIEW                                               |
|     ├── Verify diagnosis is consistent with mechanism            |
|     ├── Review pre-existing medical history                      |
|     ├── Confirm treatment is reasonable and necessary            |
|     └── Assess expected disability duration                      |
|                                                                  |
|  4. COMPENSABILITY DECISION                                      |
|     ├── Accept claim → begin benefits                            |
|     ├── Deny claim → issue denial notice with reasons            |
|     └── Investigate further → request additional information     |
|                                                                  |
|  5. STATE NOTIFICATION                                           |
|     ├── File acceptance via SROI-IP                              |
|     ├── File denial via FROI-04 or SROI-04                      |
|     └── Comply with state-specific notification requirements     |
|                                                                  |
+------------------------------------------------------------------+
```

### 9.3 Compensability Decision Timeline

Most states impose strict deadlines for accepting or denying claims:

| State | Decision Deadline | Consequences of Missing |
|-------|-------------------|------------------------|
| CA | 90 days from employer knowledge | Presumption of compensability |
| TX | 60 days (7 days for initial benefits) | Administrative penalties |
| FL | 120 days from FROI filing | Presumption |
| NY | No specific deadline, but prompt response required | WCB penalties |
| IL | Reasonable time | Penalties, attorney involvement |
| PA | 21 days (Notice of Compensation Payable) | Presumption of acceptance |
| OH | State fund determines | BWC timeline |

---

## 10. Medical Management

### 10.1 Treatment Guidelines

```
WC MEDICAL TREATMENT GUIDELINES:
+------------------------------------------------------------------+
|                                                                  |
|  ODG (Official Disability Guidelines by MCG):                    |
|  ├── Evidence-based treatment guidelines                         |
|  ├── Used by many states as default or mandatory standard        |
|  ├── Covers: treatment modalities, frequency, duration           |
|  ├── Disability duration benchmarks                              |
|  ├── Drug formulary recommendations                              |
|  └── Adopted in: TX, NY, and others                              |
|                                                                  |
|  ACOEM (American College of Occupational Medicine):              |
|  ├── Practice Guidelines                                         |
|  ├── Evidence-based occupational medicine standards              |
|  ├── Used as treatment standard in many states                   |
|  ├── Adopted as mandatory in CA (MTUS basis)                     |
|  └── Covers initial treatment through return to work             |
|                                                                  |
|  STATE-SPECIFIC GUIDELINES:                                      |
|  ├── CA: Medical Treatment Utilization Schedule (MTUS)           |
|  ├── TX: ODG adopted as state standard                           |
|  ├── NY: Medical Treatment Guidelines (MTG)                      |
|  ├── CO: Medical Treatment Guidelines Rule 17                    |
|  └── WA: Medical Treatment Guidelines (L&I)                      |
|                                                                  |
+------------------------------------------------------------------+
```

### 10.2 Utilization Review (UR)

```
UTILIZATION REVIEW PROCESS:
+------------------------------------------------------------------+
|                                                                  |
|  PROSPECTIVE UR (before treatment):                              |
|  ├── Provider requests pre-authorization                         |
|  ├── UR nurse/physician reviews against guidelines               |
|  ├── Decision: Approve / Modify / Deny                           |
|  ├── Timeline: 5 business days (non-urgent); 72 hours (urgent)  |
|  └── Denial requires peer-to-peer review opportunity             |
|                                                                  |
|  CONCURRENT UR (during treatment):                               |
|  ├── Review of ongoing treatment plan                            |
|  ├── Extension or modification of approved treatment             |
|  ├── Monitor treatment progress and outcomes                     |
|  └── Common for: inpatient stays, PT sessions, chronic care      |
|                                                                  |
|  RETROSPECTIVE UR (after treatment):                             |
|  ├── Review of treatment already rendered                        |
|  ├── Determine medical necessity after the fact                  |
|  ├── May result in payment denial or adjustment                  |
|  └── Limited in some states (CA restricts retrospective UR)      |
|                                                                  |
|  INDEPENDENT MEDICAL REVIEW (IMR):                               |
|  ├── When UR denial is disputed                                  |
|  ├── Independent physician reviews medical records               |
|  ├── Decision is typically binding                               |
|  └── CA: MAXIMUS administers IMR program                         |
|                                                                  |
+------------------------------------------------------------------+
```

### 10.3 Medical Case Management

| Type | Description | When Used |
|------|-------------|-----------|
| **Telephonic Case Management** | Phone-based coordination of care | Moderate complexity claims |
| **Field Case Management** | On-site nurse attends appointments | Severe injuries, complex cases |
| **Medical Bill Review** | Review bills against fee schedules | All claims with medical bills |
| **Peer Review** | Physician-to-physician review | Disputed treatment, UR denials |
| **IME (Independent Medical Examination)** | Examination by insurer-selected physician | Disputes over diagnosis, causation, MMI, impairment |
| **Functional Capacity Evaluation** | Objective physical abilities testing | Return-to-work determination, impairment rating |
| **Medical Director Review** | Internal medical director oversight | Complex medical decisions |

### 10.4 Medical Provider Networks

```
WC MEDICAL PROVIDER NETWORK MODELS:
+------------------------------------------------------------------+
|                                                                  |
|  MPN (Medical Provider Network) - California Model:              |
|  ├── Employer/insurer establishes network of WC providers        |
|  ├── Employee must treat within MPN after initial visit           |
|  ├── Employee can change physicians within network                |
|  ├── Network must include adequate specialties                   |
|  ├── Geographic accessibility requirements                       |
|  └── DWC approval required                                       |
|                                                                  |
|  EMPLOYER-DIRECTED CARE (many states):                           |
|  ├── Employer selects treating physician for initial period       |
|  ├── Employee may change after X days (e.g., 90 days)            |
|  └── Some states: employee always has free choice                 |
|                                                                  |
|  PPO NETWORKS:                                                   |
|  ├── Preferred provider organization for WC                      |
|  ├── Discounted fee schedules                                    |
|  ├── Network management and credentialing                        |
|  └── Employee may treat out-of-network at higher cost            |
|                                                                  |
|  STATE MODELS FOR PROVIDER CHOICE:                               |
|  ├── Employer chooses: AL, GA, IN, SC, TN, etc.                 |
|  ├── Employee chooses: AK, HI, LA, MA, NY, etc.                 |
|  ├── Hybrid (initial employer, then employee): CA, CO, FL, etc.  |
|  └── Panel: MD, PA, VA (employer provides panel of physicians)   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 11. Pharmacy Benefit Management in WC

### 11.1 WC Pharmacy Overview

```
WC PHARMACY MANAGEMENT:
+------------------------------------------------------------------+
|                                                                  |
|  KEY DIFFERENCES FROM GROUP HEALTH PHARMACY:                     |
|  ├── No patient co-pay (employer/insurer pays 100%)              |
|  ├── State fee schedules apply (not PBM negotiated rates)        |
|  ├── First fill often from emergency room or retail pharmacy     |
|  ├── Formulary requirements vary by state                        |
|  ├── Longer duration prescriptions common (chronic pain)         |
|  └── Higher opioid utilization historically                      |
|                                                                  |
|  PBM SERVICES IN WC:                                             |
|  ├── Pharmacy network management                                 |
|  ├── Drug utilization review (DUR)                               |
|  ├── Prior authorization for non-formulary drugs                 |
|  ├── Generic substitution enforcement                            |
|  ├── Compound medication review                                  |
|  ├── Retrospective bill review                                   |
|  ├── Opioid management programs                                  |
|  └── Reporting and analytics                                     |
|                                                                  |
|  MAJOR WC PBMs:                                                  |
|  ├── Optum (formerly CompPharma)                                 |
|  ├── myMatrixx                                                   |
|  ├── Express Scripts WC                                          |
|  ├── Coventry Workers' Comp                                      |
|  └── Various regional PBMs                                       |
|                                                                  |
|  STATE FORMULARY REQUIREMENTS:                                   |
|  ├── TX: Closed formulary (ODG-based)                            |
|  ├── CA: MTUS Drug Formulary (mandatory as of 2018)              |
|  ├── NY: Formulary (mandatory as of 2019)                        |
|  ├── OH: BWC formulary                                           |
|  └── Most other states: open formulary with UR                   |
|                                                                  |
+------------------------------------------------------------------+
```

### 11.2 Opioid Management

```
OPIOID MANAGEMENT IN WC:
+------------------------------------------------------------------+
|                                                                  |
|  REGULATORY CONTROLS:                                            |
|  ├── PDMP (Prescription Drug Monitoring Program) checks          |
|  ├── Morphine Equivalent Dose (MED) monitoring                   |
|  ├── Duration limits for initial opioid prescriptions            |
|  ├── Prior authorization for extended use                        |
|  ├── Urine drug testing requirements                             |
|  └── State-specific opioid prescribing guidelines                |
|                                                                  |
|  SYSTEM REQUIREMENTS:                                            |
|  ├── Real-time alerting when MED exceeds thresholds              |
|  ├── Automatic PDMP query integration                            |
|  ├── Doctor shopping detection                                   |
|  ├── Early refill alerting                                       |
|  ├── Dangerous drug combination flagging                         |
|  └── Opioid weaning protocol support                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 12. Return-to-Work Programs

### 12.1 RTW Program Framework

```
RETURN-TO-WORK PROGRAM STRUCTURE:
+------------------------------------------------------------------+
|                                                                  |
|  EARLY INTERVENTION (Day 1-3):                                   |
|  ├── Contact employee to show concern and gather information     |
|  ├── Contact treating physician for restrictions                 |
|  ├── Assess transitional duty availability                       |
|  └── Communicate RTW expectations                                |
|                                                                  |
|  TRANSITIONAL DUTY (Modified Work):                              |
|  ├── Temporary work assignment within medical restrictions        |
|  ├── Must be productive, meaningful work                         |
|  ├── May be same job with modifications                          |
|  ├── May be different job within restrictions                    |
|  ├── Typically limited to 60-90 days                             |
|  └── Requires physician approval of job description              |
|                                                                  |
|  WORKPLACE ACCOMMODATION:                                        |
|  ├── Physical modifications to workstation                       |
|  ├── Schedule modifications (reduced hours, flexible schedule)   |
|  ├── Equipment or tool modifications                             |
|  ├── Job restructuring                                           |
|  └── May overlap with ADA reasonable accommodation               |
|                                                                  |
|  VOCATIONAL REHABILITATION (if cannot return to employer):       |
|  ├── Transferable skills analysis                                |
|  ├── Job retraining                                              |
|  ├── Job placement services                                      |
|  └── State-mandated vocational rehab benefits                    |
|                                                                  |
+------------------------------------------------------------------+
```

### 12.2 RTW Data Model

```
RTW TRACKING DATA ELEMENTS:
+------------------------------------------------------------------+
| Field                     | Type     | Description                |
+------------------------------------------------------------------+
| rtw_plan_id              | UUID     | Unique plan identifier      |
| claim_id                 | UUID     | Associated claim            |
| plan_type                | ENUM     | Full/Modified/Transitional  |
| plan_status              | ENUM     | Active/Completed/Failed     |
| target_rtw_date          | DATE     | Expected return date        |
| actual_rtw_date          | DATE     | Actual return date          |
| duty_type                | ENUM     | Full/Light/Modified/Sedentary|
| hours_per_day            | DECIMAL  | Work hours per day          |
| days_per_week            | INTEGER  | Work days per week          |
| restrictions             | TEXT[]   | List of medical restrictions |
| accommodations           | TEXT[]   | Workplace accommodations    |
| employer_contact         | VARCHAR  | RTW coordinator at employer |
| physician_approval_date  | DATE     | When physician approved plan|
| plan_start_date          | DATE     | Transitional duty start     |
| plan_end_date            | DATE     | Transitional duty end       |
| outcome                  | ENUM     | Successful/Unsuccessful/Ongoing|
| wage_during_rtw          | DECIMAL  | Earnings during RTW period  |
+------------------------------------------------------------------+
```

---

## 13. Disability Duration Management

### 13.1 Disability Duration Guidelines

```
DISABILITY DURATION MANAGEMENT:
+------------------------------------------------------------------+
|                                                                  |
|  MDG (Medical Disability Guidelines) / ODG Disability Duration:  |
|  ├── Evidence-based expected disability durations                |
|  ├── By diagnosis (ICD-10) and job demands                      |
|  ├── Provides: minimum, optimum, maximum durations              |
|  ├── Factors: age, comorbidities, treatment, job physical demand |
|  └── Used to benchmark and manage claim durations                |
|                                                                  |
|  DURATION CATEGORIES:                                            |
|  +------------------------------------------------------------+  |
|  | Diagnosis               | Min   | Optimal| Max   | Job    |  |
|  +------------------------------------------------------------+  |
|  | Ankle sprain (mild)     | 1 day | 3 days | 14 days| Sed   |  |
|  | Ankle sprain (mild)     | 3 days| 7 days | 28 days| Heavy |  |
|  | Lumbar strain            | 1 day | 7 days | 49 days| Sed   |  |
|  | Lumbar strain            | 7 days| 28 days| 91 days| Heavy |  |
|  | Carpal tunnel (surgery)  | 14 d  | 28 days| 42 days| Sed   |  |
|  | Carpal tunnel (surgery)  | 21 d  | 42 days| 91 days| Heavy |  |
|  | Rotator cuff repair      | 42 d  | 91 days| 182 d | Sed   |  |
|  | Rotator cuff repair      | 91 d  | 182 d | 365 d | Heavy |  |
|  | Total knee replacement   | 28 d  | 42 days| 182 d | Sed   |  |
|  | Total knee replacement   | 91 d  | 182 d | 365 d | Heavy |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.2 TTD to MMI Progression

```
DISABILITY PROGRESSION TIMELINE:
+------------------------------------------------------------------+
|                                                                  |
|  INJURY → ACUTE PHASE → RECOVERY → MMI → PERMANENT RATING       |
|                                                                  |
|  Day 0-3:    WAITING PERIOD (no indemnity benefits)              |
|              Medical benefits begin immediately                   |
|                                                                  |
|  Day 4+:     TTD BENEFITS BEGIN                                  |
|              (if disability exceeds waiting period)               |
|                                                                  |
|  Day 14-28:  RETROACTIVE PERIOD                                  |
|              (waiting period days paid retroactively              |
|              if disability exceeds this threshold)                |
|                                                                  |
|  Weeks 1-12: ACUTE TREATMENT PHASE                               |
|              Active medical treatment                             |
|              Regular physician visits                             |
|              Physical therapy                                     |
|                                                                  |
|  Weeks 12-52: RECOVERY PHASE                                     |
|              Continued treatment if needed                        |
|              Disability duration benchmarking                     |
|              Consider IME if extended beyond guidelines           |
|              RTW planning                                         |
|                                                                  |
|  MAXIMUM MEDICAL IMPROVEMENT (MMI):                              |
|  ├── Point where condition is stable                             |
|  ├── No further significant improvement expected                 |
|  ├── Determined by treating physician or IME                     |
|  ├── Triggers permanent impairment evaluation                    |
|  └── TTD benefits convert to PPD or PTD                          |
|                                                                  |
|  POST-MMI:                                                       |
|  ├── Permanent impairment rating                                 |
|  ├── PPD or PTD benefits calculation                             |
|  ├── Ongoing medical maintenance (if needed)                     |
|  └── Case closure or settlement negotiation                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 14. Permanent Impairment Rating

### 14.1 AMA Guides to the Evaluation of Permanent Impairment

```
AMA GUIDES EDITIONS AND STATE ADOPTION:
+------------------------------------------------------------------+
| Edition | Year  | States Using                                   |
+------------------------------------------------------------------+
| 4th     | 1993  | AR, CO, GA, IN, KS, MO, MT, NE, NV, RI, WV   |
| 5th     | 2000  | AK, AZ, CT, FL, HI, ID, ME, MN, ND, NH, NM,  |
|         |       | OK, OR, SD, TN, UT, WI, WY, most other states |
| 6th     | 2008  | DE, LA, MT (some), very limited adoption       |
+------------------------------------------------------------------+
| States NOT using AMA Guides:                                     |
| CA - Uses own Permanent Disability Rating Schedule (PDRS)        |
| NY - Uses own impairment guidelines                              |
| TX - AMA 4th + state-specific modifications                      |
| IL - Uses AMA Guides but with own methodology                    |
| NJ - Uses own guidelines based on disability %                   |
+------------------------------------------------------------------+
```

### 14.2 Impairment Rating Process

```
IMPAIRMENT RATING WORKFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  1. PATIENT REACHES MMI                                          |
|     └── Declared by treating physician or IME physician          |
|                                                                  |
|  2. IMPAIRMENT EVALUATION                                        |
|     ├── Review medical records and imaging                       |
|     ├── Physical examination                                     |
|     ├── Measurement of loss (ROM, strength, sensation)           |
|     ├── Apply applicable AMA Guides edition                      |
|     └── Calculate Whole Person Impairment (WPI) percentage       |
|                                                                  |
|  3. RATING CALCULATION                                           |
|     ├── AMA Guides 5th Edition approach:                         |
|     │   ├── Identify body system chapter                         |
|     │   ├── Apply diagnosis-based or ROM-based method            |
|     │   ├── Determine regional impairment                        |
|     │   ├── Convert to whole person impairment                   |
|     │   └── Combine multiple impairments (Combined Values Chart) |
|     │                                                            |
|     ├── AMA Guides 6th Edition approach:                         |
|     │   ├── Identify diagnosis-based impairment (DBI) class      |
|     │   ├── Apply grade modifiers (GMFH, GMPE, GMCS)            |
|     │   ├── Calculate Net Adjustment                             |
|     │   └── Determine final WPI                                  |
|     │                                                            |
|     └── State-specific modifications:                            |
|         ├── Apportionment (pre-existing conditions)              |
|         ├── Age adjustments                                      |
|         ├── Occupation adjustments                               |
|         └── Loss of earning capacity factors                     |
|                                                                  |
|  4. CONVERT WPI TO DISABILITY RATING                             |
|     └── State-specific formula (WPI → weeks of benefits)          |
|                                                                  |
|  5. DISPUTE RESOLUTION (if rating is disputed)                   |
|     ├── IME with different physician                             |
|     ├── State medical board review                               |
|     ├── Administrative hearing                                   |
|     └── Agreed medical examination (AME in CA)                   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 15. Indemnity Calculation

### 15.1 Average Weekly Wage (AWW) Calculation

```
AWW CALCULATION METHODS:
+------------------------------------------------------------------+
|                                                                  |
|  METHOD 1: STANDARD CALCULATION                                  |
|  AWW = Total wages in 52 weeks before injury / 52               |
|  (or lesser period if employed < 52 weeks)                       |
|                                                                  |
|  METHOD 2: SIMILAR EMPLOYEE METHOD                               |
|  Used when employee worked < full year or irregular schedule     |
|  AWW based on earnings of similar employee in same job           |
|                                                                  |
|  METHOD 3: CONCURRENT EMPLOYMENT                                 |
|  Combined wages from all concurrent employment                   |
|  (not adopted in all states)                                     |
|                                                                  |
|  METHOD 4: SEASONAL WORKER                                       |
|  May annualize seasonal earnings or use actual work period       |
|                                                                  |
|  WAGE INCLUSIONS:                                                |
|  ├── Base salary/hourly wages                                    |
|  ├── Overtime (varies: some states include, some average)        |
|  ├── Tips and gratuities                                         |
|  ├── Commissions                                                 |
|  ├── Bonuses (may be averaged)                                   |
|  ├── Employer-provided housing/meals (value)                     |
|  └── Other fringe benefits (state-specific)                      |
|                                                                  |
|  WAGE EXCLUSIONS:                                                |
|  ├── One-time bonuses (generally)                                |
|  ├── Employer contributions to retirement (generally)            |
|  └── Reimbursed expenses                                         |
|                                                                  |
+------------------------------------------------------------------+
```

### 15.2 Compensation Rate Calculation

```
COMPENSATION RATE FORMULA:
+------------------------------------------------------------------+
|                                                                  |
|  TEMPORARY TOTAL DISABILITY (TTD):                               |
|  Comp Rate = AWW × State Percentage                              |
|  Most states: 66.67% (2/3)                                      |
|  Subject to: State Maximum and State Minimum weekly rates        |
|                                                                  |
|  TEMPORARY PARTIAL DISABILITY (TPD):                             |
|  Comp Rate = (Pre-injury AWW - Current Earnings) × State %      |
|  OR: Fixed percentage of wage difference                         |
|                                                                  |
|  PERMANENT PARTIAL DISABILITY (PPD):                             |
|  Varies dramatically by state:                                   |
|  - Scheduled: Rate × Number of scheduled weeks for body part    |
|  - Unscheduled: Rate × Number of weeks based on impairment %    |
|  - Wage loss: Based on actual post-injury wage loss              |
|  - Bifurcated: Some states pay different rates for PPD           |
|                                                                  |
|  PERMANENT TOTAL DISABILITY (PTD):                               |
|  Typically same rate as TTD                                      |
|  Duration: lifetime in most states (some have caps)              |
|  May be offset by Social Security Disability Income (SSDI)       |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  Surviving spouse: typically 60-67% of AWW                       |
|  Dependent children: additional % per child                      |
|  Total: often capped at 80% of AWW or 100% of state maximum     |
|                                                                  |
+------------------------------------------------------------------+
```

### 15.3 Waiting Period and Retroactive Period

| State | Waiting Period | Retroactive Period |
|-------|---------------|-------------------|
| CA | 3 days | 14 days |
| TX | 7 days | 28 days |
| FL | 7 days | 21 days |
| NY | 7 days | 14 days |
| IL | 3 days | 14 days |
| PA | 7 days | 14 days |
| OH | 7 days | 14 days |
| NJ | 7 days | 21 days |
| GA | 7 days | 21 days |
| NC | 7 days | 21 days |

---

## 16. State-Specific Benefit Calculations

### 16.1 California

```
CALIFORNIA WC BENEFITS (2025):
+------------------------------------------------------------------+
|                                                                  |
|  TTD RATE:                                                       |
|  - 2/3 of AWW                                                   |
|  - Maximum: $1,619.15/week (2025)                               |
|  - Minimum: $242.86/week                                        |
|  - Duration: 104 weeks within 5 years from DOI                  |
|  - Extended to 240 weeks for certain injuries                    |
|                                                                  |
|  PPD RATE:                                                       |
|  - Based on PDRS (Permanent Disability Rating Schedule)          |
|  - Formula: FEC × Occupation × Age × WPI                        |
|  - Maximum: $290/week (injury after 1/1/2014)                   |
|  - Minimum: $160/week                                           |
|                                                                  |
|  PTD RATE:                                                       |
|  - Same as TTD rate                                              |
|  - Lifetime benefits                                             |
|  - COLA adjustments                                              |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  - Total dependents: $250,000 (1 dependent)                     |
|  - $290,000 (2 dependents), $320,000 (3+ dependents)            |
|  - Plus burial expense: up to $10,000                            |
|                                                                  |
|  UNIQUE CA FEATURES:                                             |
|  - PDRS based on AMA Guides 5th with state modifications        |
|  - Apportionment of permanent disability (LC 4663, 4664)        |
|  - Supplemental Job Displacement Benefit (SJDB) voucher         |
|  - QME (Qualified Medical Examiner) system                      |
|  - AME (Agreed Medical Examiner) option                          |
|                                                                  |
+------------------------------------------------------------------+
```

### 16.2 Texas

```
TEXAS WC BENEFITS (2025):
+------------------------------------------------------------------+
|                                                                  |
|  TTD (Temporary Income Benefits - TIBs):                         |
|  - 70% of difference between AWW and post-injury earnings        |
|  - First 26 weeks: 70% of AWW if not earning                    |
|  - After 26 weeks: 70% of difference between AWW and ability    |
|  - Maximum: 100% of SAWW ($1,111.00/week for FY2025)            |
|  - Minimum: 15% of SAWW                                         |
|  - Duration: 104 weeks maximum                                   |
|                                                                  |
|  IIBs (Impairment Income Benefits):                              |
|  - After MMI with impairment rating                              |
|  - 70% of AWW × 3 weeks per percent impairment                  |
|  - Maximum: 100% of SAWW                                        |
|                                                                  |
|  SIBs (Supplemental Income Benefits):                            |
|  - After IIBs exhausted with ≥15% impairment                    |
|  - Must demonstrate ongoing wage loss                            |
|  - 80% of difference between 80% AWW and post-injury earnings   |
|                                                                  |
|  LIBs (Lifetime Income Benefits):                                |
|  - Specific catastrophic injuries (e.g., total blindness,        |
|    loss of both hands/feet, spinal cord injury with paralysis)   |
|  - 75% of AWW for life                                           |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  - Eligible dependents: 75% of AWW                               |
|  - Duration: based on dependency (spouse/children)               |
|  - Burial: up to $10,000                                         |
|                                                                  |
+------------------------------------------------------------------+
```

### 16.3 Florida

```
FLORIDA WC BENEFITS (2025):
+------------------------------------------------------------------+
|                                                                  |
|  TTD RATE:                                                       |
|  - 66.67% of AWW                                                |
|  - Maximum: $1,197.00/week (2025)                               |
|  - Duration: 104 weeks maximum                                   |
|  - First 104 weeks = 66.67%, then 0% (no extended temp benefits)|
|                                                                  |
|  TPD RATE:                                                       |
|  - 80% of 80% of AWW minus actual wages earned                  |
|  - Maximum: $1,197.00/week                                      |
|  - Duration: 104 weeks maximum                                   |
|                                                                  |
|  IMPAIRMENT BENEFITS:                                            |
|  - 75% of TTD rate × 2 weeks per 1% impairment                  |
|  - After MMI with impairment rating                              |
|  - AMA Guides 5th Edition (Florida edition)                      |
|                                                                  |
|  PTD RATE:                                                       |
|  - 66.67% of AWW                                                |
|  - Lifetime benefits                                             |
|  - Annual COLA adjustment: 3% per year                           |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  - Spouse only: 50% of AWW                                      |
|  - Spouse + children: 66.67% of AWW                              |
|  - Duration: lifetime for spouse (until remarriage), children    |
|    until age 18 (25 if full-time student)                        |
|  - Burial: up to $7,500                                          |
|                                                                  |
+------------------------------------------------------------------+
```

### 16.4 New York

```
NEW YORK WC BENEFITS (2025):
+------------------------------------------------------------------+
|                                                                  |
|  TTD RATE:                                                       |
|  - 2/3 of AWW                                                   |
|  - Maximum: $1,145.43/week (7/1/2024 - 6/30/2025)              |
|  - Duration: no statutory cap (until MMI)                        |
|                                                                  |
|  SCHEDULE LOSS OF USE (SLU):                                     |
|  - Scheduled body part awards                                    |
|  - Number of weeks × 2/3 of AWW                                 |
|  - Weeks by body part: Arm=312, Leg=288, Hand=244, Foot=205,    |
|    Thumb=75, Index finger=46, Eye=160, Hearing(both)=150        |
|  - Based on percentage of loss of use                            |
|  - Example: 50% loss of use of arm = 156 weeks × comp rate      |
|                                                                  |
|  NON-SCHEDULE PERMANENT DISABILITY:                              |
|  - Classification disability (back, brain, etc.)                 |
|  - Based on loss of wage-earning capacity                        |
|  - Duration: varies (can be extensive)                           |
|                                                                  |
|  PTD RATE:                                                       |
|  - 2/3 of AWW (subject to maximum)                              |
|  - Lifetime benefits                                             |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  - Spouse: 2/3 of AWW for life (or until remarriage +           |
|    2 years lump sum)                                             |
|  - Children: additional amounts                                  |
|  - Burial: actual funeral expenses                               |
|                                                                  |
|  UNIQUE NY FEATURES:                                             |
|  - Workers' Compensation Board administers all claims            |
|  - Mandatory pre-hearing conference program                      |
|  - Section 32 settlement (full compromise and release)           |
|  - C-forms system for reporting                                  |
|  - WCB online portal for electronic filings                      |
|                                                                  |
+------------------------------------------------------------------+
```

### 16.5 Illinois

```
ILLINOIS WC BENEFITS (2025):
+------------------------------------------------------------------+
|                                                                  |
|  TTD RATE:                                                       |
|  - 2/3 of AWW                                                   |
|  - No statutory maximum (based on AWW)                           |
|  - Minimum: $250.00/week (approximately)                        |
|  - Duration: until employee returns to work, is released,        |
|    or reaches MMI                                                |
|                                                                  |
|  PPD RATE:                                                       |
|  - Scheduled injuries: 60% of AWW × weeks per body part         |
|  - Weeks: Thumb=76, Hand=205, Arm=253, Great Toe=38,            |
|    Foot=167, Leg=215, Eye=162, Hearing=one=54                   |
|  - Non-scheduled: based on AMA Guides + other factors            |
|  - Duration: # of weeks per impairment percentage                |
|                                                                  |
|  PTD RATE:                                                       |
|  - 2/3 of AWW                                                   |
|  - Lifetime benefits                                             |
|  - Annual COLA after 6 months of PTD                             |
|                                                                  |
|  DEATH BENEFITS:                                                 |
|  - Surviving spouse and children: 66.67% of AWW                 |
|  - Duration: 25 years or $500,000 (whichever greater)            |
|  - Burial: $8,000                                                |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 17. Medicare Set-Aside (MSA)

### 17.1 MSA Overview

```
MEDICARE SET-ASIDE REQUIREMENTS:
+------------------------------------------------------------------+
|                                                                  |
|  WHAT IS AN MSA?                                                 |
|  ├── Allocation of settlement funds to cover future medical      |
|  │   expenses that would otherwise be covered by Medicare        |
|  ├── Required when settling WC claims involving Medicare         |
|  │   beneficiaries or near-beneficiaries                         |
|  ├── Protects Medicare's interests as secondary payer            |
|  └── CMS (Centers for Medicare & Medicaid Services) oversight    |
|                                                                  |
|  WHEN IS MSA REQUIRED?                                           |
|  ├── CMS "review thresholds" (workload review thresholds):      |
|  │   ├── Current Medicare beneficiary: settlement > $25,000      |
|  │   ├── Reasonable expectation of Medicare within 30 months:    |
|  │   │   └── Settlement > $250,000                               |
|  │   └── These are CMS review thresholds, not legal mandates    |
|  ├── MSA obligation exists regardless of CMS review              |
|  └── Best practice: consider MSA on any significant settlement   |
|                                                                  |
|  MSA CALCULATION COMPONENTS:                                     |
|  ├── Future medical treatment related to injury                  |
|  │   ├── Based on treating physician's recommended treatment     |
|  │   ├── Medications (annual cost projected)                     |
|  │   ├── Future surgeries (probability-weighted)                 |
|  │   ├── Office visits and therapy                               |
|  │   └── Durable medical equipment                               |
|  ├── Life expectancy (CDC life tables or rated age)              |
|  ├── Projected costs at Medicare rates                           |
|  └── Present value calculation (if annuity used)                 |
|                                                                  |
|  MSA ADMINISTRATION:                                             |
|  ├── Lump sum MSA: full amount deposited at settlement           |
|  ├── Structured MSA: annual payments (annuity funded)            |
|  ├── Professional MSA administration services                    |
|  ├── Annual accounting to CMS required                           |
|  └── When MSA is exhausted, Medicare becomes primary             |
|                                                                  |
+------------------------------------------------------------------+
```

### 17.2 MSA Data Requirements

| Data Element | Description |
|-------------|-------------|
| Claimant demographics | Name, DOB, SSN, Medicare HICN/MBI |
| Medicare status | Current beneficiary, entitlement basis |
| Injury information | DOI, body parts, diagnoses |
| Treatment history | All WC-related treatment received |
| Current medications | Drug name, dosage, frequency, cost |
| Future treatment plan | Recommended treatment by treating physician |
| Life expectancy | Standard or rated age |
| Medical costs | Projected annual medical expenses |
| Pharmacy costs | Projected annual drug expenses |
| Surgery projections | Future surgical procedures with probability |
| Settlement amount | Total settlement value |

---

## 18. Settlements

### 18.1 Settlement Types

```
WC SETTLEMENT TYPES:
+------------------------------------------------------------------+
|                                                                  |
|  COMPROMISE AND RELEASE (C&R):                                   |
|  ├── Also called: Full and Final Settlement                      |
|  ├── Lump sum payment to close all or part of claim              |
|  ├── May close out future medical and/or indemnity               |
|  ├── Employee releases all future rights to benefits             |
|  ├── Requires administrative or judicial approval (most states)  |
|  ├── Must consider Medicare interests (MSA if applicable)        |
|  └── Most common settlement type                                 |
|                                                                  |
|  STIPULATED FINDINGS AND AWARD (STIP):                           |
|  ├── Also called: Stipulation, Agreed Order                      |
|  ├── Parties agree on facts and disability level                 |
|  ├── Award is ordered for specific benefits                      |
|  ├── Does NOT close future medical (in most implementations)     |
|  ├── Employer/insurer remains liable for future medical care     |
|  ├── Can be modified if condition changes                        |
|  └── Common in CA for PPD awards                                 |
|                                                                  |
|  SECTION 32 AGREEMENT (New York):                                |
|  ├── Named after WCL Section 32                                  |
|  ├── Unique to New York                                          |
|  ├── Lump sum settlement closing all benefits                    |
|  ├── Must be approved by WCB Administrative Law Judge            |
|  ├── Employee has 10 business days to rescind                    |
|  └── Medicare/Medicaid interests must be considered              |
|                                                                  |
|  REDEMPTION (Michigan):                                          |
|  ├── Lump sum payment for permanent disabilities                 |
|  ├── Closes out indemnity benefits                               |
|  ├── May or may not close medical                                |
|  └── Common in MI workers comp                                   |
|                                                                  |
|  WASHOUT / NUISANCE VALUE SETTLEMENT:                            |
|  ├── Small settlement amount to close questionable claims        |
|  ├── Cost-of-defense consideration                               |
|  └── No admission of liability                                   |
|                                                                  |
+------------------------------------------------------------------+
```

### 18.2 Settlement Calculation Factors

```
SETTLEMENT VALUE CALCULATION:
+------------------------------------------------------------------+
|                                                                  |
|  INDEMNITY COMPONENT:                                            |
|  ├── Present value of remaining TTD/TPD                          |
|  ├── PPD award value (scheduled weeks × comp rate)               |
|  ├── Future wage loss (if applicable)                            |
|  ├── Vocational rehabilitation benefits                          |
|  └── Penalty or interest on late payments                        |
|                                                                  |
|  MEDICAL COMPONENT:                                              |
|  ├── Future medical costs (present value)                        |
|  ├── Future surgeries (probability adjusted)                     |
|  ├── Ongoing medication costs                                    |
|  ├── DME replacement costs                                       |
|  └── MSA requirement (if Medicare involved)                      |
|                                                                  |
|  RISK FACTORS:                                                   |
|  ├── Compensability issues (strength of defense)                 |
|  ├── Medical causation disputes                                  |
|  ├── Apportionment potential                                     |
|  ├── Litigation risk and cost                                    |
|  ├── Claimant attorney involvement                               |
|  ├── Jurisdictional favorability                                 |
|  └── Judge tendencies (if known)                                 |
|                                                                  |
|  DISCOUNT RATE:                                                  |
|  ├── Present value discount for future payments                  |
|  ├── Typically 2-4% depending on investment rates                |
|  └── Life expectancy for duration of future benefits             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 19. Second Injury Funds

### 19.1 Overview

```
SECOND INJURY FUND CONCEPT:
+------------------------------------------------------------------+
|                                                                  |
|  PURPOSE:                                                        |
|  ├── Encourage employers to hire workers with disabilities       |
|  ├── Prevent unfair cost burden on employers for pre-existing    |
|  │   conditions                                                  |
|  └── Spread cost of disproportionate disability across system    |
|                                                                  |
|  HOW IT WORKS:                                                   |
|  ├── Worker with pre-existing condition suffers new work injury  |
|  ├── Combined disability is greater than new injury alone        |
|  ├── Employer/insurer pays for new injury portion                |
|  ├── Second injury fund pays the excess disability               |
|  └── Fund financed by assessments on insurers/employers          |
|                                                                  |
|  EXAMPLE:                                                        |
|  ├── Worker lost one eye in prior non-work accident (50% eye)   |
|  ├── Worker injures remaining eye at work (50% eye)             |
|  ├── Combined: total blindness (PTD)                             |
|  ├── Without fund: Employer pays for PTD                         |
|  ├── With fund: Employer pays for 50% loss of one eye (PPD)     |
|  └── Second Injury Fund pays difference to PTD                   |
|                                                                  |
|  STATUS:                                                         |
|  ├── Many states have eliminated or are phasing out SIFs         |
|  ├── Remaining active SIFs: fewer than 20 states                 |
|  ├── Complex claims process for SIF reimbursement                |
|  └── Data requirements: proof of pre-existing condition,         |
|      employer knowledge, disproportionate disability              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 20. Subrogation in WC

### 20.1 Third-Party Recovery

```
WC SUBROGATION FRAMEWORK:
+------------------------------------------------------------------+
|                                                                  |
|  WHEN SUBROGATION APPLIES:                                       |
|  ├── Work injury caused by negligent third party                 |
|  ├── Examples:                                                   |
|  │   ├── Motor vehicle accident (other driver at fault)          |
|  │   ├── Defective product/equipment (manufacturer liable)       |
|  │   ├── Premises liability (property owner)                     |
|  │   ├── Professional malpractice (treating physician)           |
|  │   └── Toxic exposure (chemical manufacturer)                  |
|  └── Employer/insurer has RIGHT to recover WC benefits paid      |
|                                                                  |
|  SUBROGATION APPROACHES BY STATE:                                |
|  ├── LIEN APPROACH (CA, TX, etc.):                               |
|  │   ├── Insurer has lien against employee's third-party recovery|
|  │   ├── Employee pursues tort claim                              |
|  │   ├── Insurer may intervene                                   |
|  │   └── Recovery shared per state formula                        |
|  │                                                                |
|  ├── MADE-WHOLE DOCTRINE:                                        |
|  │   ├── Employee must be fully compensated first                |
|  │   ├── Insurer recovers only from excess                       |
|  │   └── Adopted in some states                                  |
|  │                                                                |
|  ├── FORMULA APPROACH:                                           |
|  │   ├── Statutory formula for sharing third-party recovery      |
|  │   ├── Example: 1/3 to insurer, 1/3 to employee, 1/3 to atty |
|  │   └── Varies significantly by state                           |
|  │                                                                |
|  └── JOINT PROSECUTION:                                          |
|      ├── Insurer and employee jointly pursue third party          |
|      ├── Recovery shared proportionally                           |
|      └── Used in some states                                     |
|                                                                  |
|  SUBROGATION DATA REQUIREMENTS:                                  |
|  ├── Third party identification                                  |
|  ├── Liability assessment                                        |
|  ├── Total WC benefits paid (by category)                        |
|  ├── Future WC benefits estimated                                |
|  ├── Third-party insurance information                            |
|  ├── Attorney information (both sides)                           |
|  ├── Settlement or verdict amount                                |
|  ├── Recovery amount and allocation                              |
|  └── State-specific lien calculations                            |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 21. WC Fraud

### 21.1 Common Fraud Schemes

```
WC FRAUD CATEGORIES:
+------------------------------------------------------------------+
|                                                                  |
|  EMPLOYEE FRAUD:                                                 |
|  ├── Fabricated injury (no injury occurred)                      |
|  ├── Exaggerated injury (injury exists but overstated)           |
|  ├── Non-work injury claimed as work-related                    |
|  ├── Working while collecting TTD benefits                       |
|  ├── Malingering (symptom exaggeration or fabrication)           |
|  └── Prior injury claimed as new injury                          |
|                                                                  |
|  EMPLOYER FRAUD:                                                 |
|  ├── Misclassification of employees (lower-risk codes)           |
|  ├── Underreporting payroll                                      |
|  ├── Misrepresenting employee as independent contractor          |
|  ├── Failing to maintain WC coverage (going bare)                |
|  ├── Premium fraud                                               |
|  └── Concealing claims / not reporting injuries                  |
|                                                                  |
|  MEDICAL PROVIDER FRAUD:                                         |
|  ├── Billing for services not rendered                           |
|  ├── Upcoding (billing for more expensive procedure)             |
|  ├── Unbundling (separate billing for bundled services)          |
|  ├── Unnecessary treatment to increase billings                  |
|  ├── Referral kickbacks                                          |
|  └── Fraud rings (organized provider-claimant schemes)           |
|                                                                  |
|  ATTORNEY FRAUD:                                                 |
|  ├── Claim mills (recruiting injured workers)                    |
|  ├── Exaggerating claims for higher fees                         |
|  └── Collusion with medical providers                            |
|                                                                  |
+------------------------------------------------------------------+
```

### 21.2 Fraud Detection Methods

```
FRAUD DETECTION TECHNIQUES:
+------------------------------------------------------------------+
|                                                                  |
|  PREDICTIVE ANALYTICS:                                           |
|  ├── Machine learning models scoring claim fraud probability     |
|  ├── Features: claim characteristics, medical patterns,          |
|  │   provider history, claimant history                          |
|  ├── Real-time scoring at FNOL and throughout claim life         |
|  └── SIU referral triggered at threshold score                   |
|                                                                  |
|  RED FLAG INDICATORS:                                            |
|  ├── Monday morning claims                                       |
|  ├── Injury coincides with termination/layoff/strike             |
|  ├── No witnesses to injury                                      |
|  ├── Delayed reporting                                           |
|  ├── Attorney involved at outset                                 |
|  ├── Prior claims history (multiple prior WC claims)             |
|  ├── Inconsistent injury descriptions                            |
|  ├── Treatment inconsistent with injury mechanism                |
|  ├── Claimant difficult to reach / avoids contact                |
|  └── Conflicting medical opinions                                |
|                                                                  |
|  INVESTIGATION TOOLS:                                            |
|  ├── Surveillance (video, social media)                          |
|  ├── Background checks                                           |
|  ├── Medical record review                                       |
|  ├── Recorded statements                                         |
|  ├── Activity checks                                             |
|  ├── Database searches (ISO ClaimSearch, NICB, prior claims)     |
|  └── SIU investigation                                           |
|                                                                  |
|  MEDICAL PROVIDER FRAUD DETECTION:                               |
|  ├── Bill review analytics (pattern analysis)                    |
|  ├── Provider profiling (treatment patterns vs. peers)           |
|  ├── Network analysis (unusual referral patterns)                |
|  ├── Geo-spatial analysis (provider-claimant distance patterns)  |
|  └── Text mining of medical reports                              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 22. Experience Modification Rating

### 22.1 EMR/MOD Calculation

```
EXPERIENCE MODIFICATION CALCULATION:
+------------------------------------------------------------------+
|                                                                  |
|  PURPOSE:                                                        |
|  ├── Adjust premium based on employer's actual loss experience   |
|  ├── Reward employers with better-than-average experience        |
|  ├── Penalize employers with worse-than-average experience       |
|  └── EMR = 1.00 means average; <1.00 = better; >1.00 = worse   |
|                                                                  |
|  CALCULATION PERIOD:                                             |
|  ├── Based on 3 years of experience (policy years)               |
|  ├── Excluding the most recent completed year                    |
|  ├── Example for 2025 policy: uses 2021, 2022, 2023 data        |
|  └── Called the "experience period"                              |
|                                                                  |
|  FORMULA (NCCI simplified):                                      |
|                                                                  |
|  EMR = (Actual Primary Losses + W × Actual Excess Losses         |
|         + Ballast)                                               |
|         ÷                                                        |
|        (Expected Primary Losses + W × Expected Excess Losses     |
|         + Ballast)                                               |
|                                                                  |
|  WHERE:                                                          |
|  ├── Actual Primary Losses: first $X of each claim (capped)     |
|  ├── Actual Excess Losses: amounts above primary threshold       |
|  ├── Expected Losses: based on class code expected loss rates    |
|  ├── W: weighting factor (reduces impact of excess losses)       |
|  └── Ballast: stabilizing factor based on expected losses        |
|                                                                  |
|  SPLIT POINT (2025):                                             |
|  ├── Primary loss limit: $18,500 (NCCI; adjusted annually)      |
|  ├── Losses below split point = primary (fully credible)         |
|  ├── Losses above split point = excess (partially credible)      |
|  └── Heavy emphasis on FREQUENCY (many small claims hurt more)   |
|                                                                  |
|  IMPACT ON PREMIUM:                                              |
|  ├── EMR of 0.80 = 20% premium credit                           |
|  ├── EMR of 1.00 = no modification                               |
|  ├── EMR of 1.25 = 25% premium surcharge                        |
|  └── Range typically: 0.60 to 2.00+                              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 23. Large Deductible and Self-Insured Programs

### 23.1 Program Types

```
WC FUNDING MECHANISMS:
+------------------------------------------------------------------+
|                                                                  |
|  GUARANTEED COST:                                                |
|  ├── Standard WC policy                                          |
|  ├── Fixed premium; insurer bears all loss risk                  |
|  ├── Best for: small employers, low risk tolerance               |
|  └── No loss-sensitive premium adjustments                       |
|                                                                  |
|  LARGE DEDUCTIBLE:                                               |
|  ├── Employer retains loss up to deductible per claim            |
|  ├── Typical deductible: $100K, $250K, $500K per claim           |
|  ├── Insurer pays claims and bills back to employer              |
|  ├── Requires collateral (LOC, surety bond, trust)               |
|  ├── Significant premium savings (30-50% vs guaranteed cost)     |
|  ├── Employer benefits from loss control investment              |
|  └── Complex accounting: paid vs incurred deductible basis       |
|                                                                  |
|  RETROSPECTIVE RATING:                                           |
|  ├── Premium adjusted based on actual loss experience             |
|  ├── Basic premium + (losses × LCF) = retro premium             |
|  ├── Subject to minimum and maximum premium                      |
|  ├── Multiple year and single year plans available               |
|  └── Good for: mid-size employers with some risk tolerance       |
|                                                                  |
|  SELF-INSURANCE:                                                 |
|  ├── Employer retains all WC risk                                |
|  ├── Must qualify with state (financial ability, claims handling)|
|  ├── Security deposit required (bond, LOC, cash)                 |
|  ├── May purchase excess insurance for catastrophic losses       |
|  ├── Self-insured groups: smaller employers pool together        |
|  ├── Requires dedicated claims management (internal or TPA)      |
|  └── Significant state regulatory requirements                   |
|                                                                  |
|  CAPTIVE INSURANCE:                                              |
|  ├── Employer-owned insurance company                            |
|  ├── Single-parent or group captive                              |
|  ├── Writes WC policy for parent company                         |
|  ├── Often domiciled in favorable jurisdictions (VT, HI, etc.)  |
|  ├── Access to reinsurance market                                |
|  └── Tax and risk management advantages                          |
|                                                                  |
+------------------------------------------------------------------+
```

### 23.2 Claims Handling for Self-Insured/Large Deductible

| Aspect | Guaranteed Cost | Large Deductible | Self-Insured |
|--------|----------------|-------------------|-------------|
| Claims Handler | Insurer | Insurer or TPA | TPA or in-house |
| Employer Involvement | Minimal | Moderate (reserves/strategy) | Maximum |
| Reserve Setting | Insurer | Insurer (employer reviews) | TPA/employer |
| Payment Authority | Insurer | Insurer (within deductible) | TPA/employer |
| Settlement Authority | Insurer | Shared (deductible claims) | TPA/employer |
| Financial Reporting | To insurer | Deductible billing reports | Direct to employer |
| State Reporting | Insurer | Insurer | TPA/employer |
| Actuarial Analysis | Insurer | Both | Employer's actuary |

---

## 24. TPA Management for WC Claims

### 24.1 TPA Selection and Management

```
TPA MANAGEMENT FRAMEWORK:
+------------------------------------------------------------------+
|                                                                  |
|  TPA SERVICES:                                                   |
|  ├── Claims administration and adjudication                      |
|  ├── FNOL intake                                                 |
|  ├── Investigation and compensability determination              |
|  ├── Reserve setting and management                              |
|  ├── Payment processing                                          |
|  ├── Medical management (UR, case management)                    |
|  ├── Pharmacy management (or PBM coordination)                   |
|  ├── RTW coordination                                            |
|  ├── Subrogation pursuit                                         |
|  ├── State regulatory filings (FROI/SROI)                        |
|  ├── Litigation management                                       |
|  └── Reporting and analytics                                     |
|                                                                  |
|  TPA PERFORMANCE METRICS:                                        |
|  ├── Three-point contact rate and timeliness                     |
|  ├── Initial reserve accuracy                                    |
|  ├── Average claim duration                                      |
|  ├── TTD duration vs benchmarks                                  |
|  ├── Medical cost per claim                                      |
|  ├── Indemnity cost per claim                                    |
|  ├── Litigation rate                                              |
|  ├── Return-to-work rate                                         |
|  ├── Closure rate                                                |
|  ├── Subrogation recovery rate                                   |
|  ├── Regulatory compliance (filing timeliness)                   |
|  ├── Customer satisfaction scores                                |
|  └── Adjuster caseload and turnover                              |
|                                                                  |
|  TPA CONTRACT ELEMENTS:                                          |
|  ├── Scope of services                                           |
|  ├── Fee structure (per claim, flat fee, or hybrid)              |
|  ├── Authority levels (reserve, payment, settlement)             |
|  ├── Reporting requirements and frequency                        |
|  ├── Data ownership and access                                   |
|  ├── Technology/system requirements                              |
|  ├── Performance guarantees and SLAs                             |
|  ├── Audit rights                                                |
|  ├── Runoff provisions                                           |
|  └── Termination provisions and transition plan                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 25. WC Regulatory Reporting

### 25.1 FROI/SROI EDI Reporting

```
EDI REPORTING WORKFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIM EVENT → IDENTIFY REQUIRED FILING → PREPARE EDI TRANSACTION|
|  → VALIDATE DATA → SUBMIT TO STATE → RECEIVE ACKNOWLEDGMENT     |
|  → PROCESS ERRORS/REJECTIONS → CORRECT AND RESUBMIT             |
|                                                                  |
|  REPORTING TRIGGERS:                                             |
|  +------+---------------------------------+-------------------+  |
|  | Type | Trigger Event                   | Deadline          |  |
|  +------+---------------------------------+-------------------+  |
|  | FROI | New claim reported              | State-specific    |  |
|  | SROI | First payment                   | Within X days     |  |
|  | SROI | Payment change/suspension       | Within X days     |  |
|  | SROI | RTW (return to work)            | Within X days     |  |
|  | SROI | Denial                          | Within X days     |  |
|  | SROI | Claim reopened                  | Within X days     |  |
|  | SROI | Settlement                      | Within X days     |  |
|  | SROI | Final payment                   | Within X days     |  |
|  | SROI | Benefit rate change             | Within X days     |  |
|  +------+---------------------------------+-------------------+  |
|                                                                  |
|  ERROR HANDLING:                                                 |
|  ├── TA (Transaction Accepted): No errors                        |
|  ├── TW (Transaction Accepted with Warnings): Non-critical       |
|  ├── TR (Transaction Rejected): Must correct and resubmit        |
|  ├── TE (Transaction Error): Invalid format or data              |
|  └── DN (Duplicate Notification): Previously filed               |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 26. OSHA Reporting Requirements

### 26.1 OSHA Recordkeeping and WC Integration

```
OSHA REPORTING REQUIREMENTS:
+------------------------------------------------------------------+
|                                                                  |
|  OSHA 300 LOG:                                                   |
|  ├── Log of Work-Related Injuries and Illnesses                  |
|  ├── Must record within 7 calendar days of receiving info        |
|  ├── Maintained for 5 years                                      |
|  ├── Recordable criteria:                                        |
|  │   ├── Death                                                   |
|  │   ├── Days away from work                                     |
|  │   ├── Restricted work or job transfer                         |
|  │   ├── Medical treatment beyond first aid                      |
|  │   ├── Loss of consciousness                                   |
|  │   ├── Significant injury/illness diagnosed by physician       |
|  │   └── Specific conditions (e.g., needlestick, hearing loss)  |
|  └── Must post annual summary (OSHA 300A) February 1 - April 30 |
|                                                                  |
|  OSHA 301 (Injury & Illness Incident Report):                    |
|  ├── Detailed report for each recordable incident                |
|  ├── Must be completed within 7 calendar days                    |
|  └── WC First Report of Injury may substitute if it contains    |
|      all required OSHA 301 information                           |
|                                                                  |
|  IMMEDIATE REPORTING (to OSHA directly):                         |
|  ├── Fatality: within 8 hours                                    |
|  ├── Inpatient hospitalization: within 24 hours                  |
|  ├── Amputation: within 24 hours                                 |
|  └── Loss of an eye: within 24 hours                             |
|                                                                  |
|  ELECTRONIC SUBMISSION (since 2017):                             |
|  ├── Establishments with 250+ employees: submit 300A annually    |
|  ├── High-hazard establishments with 20-249 employees: 300A      |
|  ├── Submission via ITA (Injury Tracking Application)            |
|  └── Data available publicly on OSHA website                     |
|                                                                  |
|  WC SYSTEM INTEGRATION:                                          |
|  ├── WC claim data should feed OSHA 300 log                      |
|  ├── Map WC injury codes to OSHA nature/body part codes          |
|  ├── Track OSHA-specific fields (restricted duty days, etc.)     |
|  ├── Alert for immediate reporting triggers                      |
|  └── Generate OSHA 300A summary from WC claims data              |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 27. WC Data Standards

### 27.1 IAIABC Standards

```
IAIABC DATA STANDARDS:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIMS EDI (Primary Standard):                                  |
|  ├── FROI/SROI transaction sets                                  |
|  ├── Release 3.0 / 3.1 (current)                                |
|  ├── Based on ANSI X12 EDI format                                |
|  ├── Jurisdiction-specific implementation guides                 |
|  └── Data dictionary with standardized codes                     |
|                                                                  |
|  MEDICAL EDI:                                                    |
|  ├── Medical bill submission (837 Health Care Claim)             |
|  ├── Electronic Remittance Advice (835 Payment)                  |
|  ├── Eligibility Inquiry (270/271)                               |
|  └── HL7 integration for clinical data                           |
|                                                                  |
|  PROOF OF COVERAGE (POC):                                        |
|  ├── Electronic proof of WC insurance coverage                   |
|  ├── Used by states to verify employer compliance                |
|  ├── Submission from insurers to state databases                 |
|  └── Standardized transaction format                             |
|                                                                  |
+------------------------------------------------------------------+
```

### 27.2 NCCI Standards

| Standard | Description |
|----------|-------------|
| **Classification System** | 4-digit class codes for risk classification |
| **Experience Rating** | Experience modification calculation methodology |
| **Statistical Plan** | Annual call for data from insurers (unit stat, financial data) |
| **Policy Data** | Standard policy information reporting |
| **Detailed Claim Information** | Individual claim-level data submission |
| **Medical Data** | Medical bill and treatment data reporting |
| **EDI Implementation** | NCCI-specific EDI guides for states administered by NCCI |

### 27.3 ISO Standards

```
ISO WC DATA:
+------------------------------------------------------------------+
|                                                                  |
|  ISO ClaimSearch:                                                |
|  ├── Industry-wide claims database                               |
|  ├── Cross-reference claims across carriers                      |
|  ├── Prior claims history for fraud detection                    |
|  ├── All-claims reporting: auto, WC, GL, property, disability   |
|  └── Used by insurers, SIU, and law enforcement                  |
|                                                                  |
|  ISO Coding:                                                     |
|  ├── Nature of Injury codes                                      |
|  ├── Cause of Injury codes                                       |
|  ├── Body Part codes                                             |
|  └── Used alongside ANSI Z16.2 coding                           |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 28. WC Claims Data Model

### 28.1 Core Entity Model

```
WC CLAIMS ENTITY RELATIONSHIP DIAGRAM:
+------------------------------------------------------------------+
|                                                                  |
|  +------------------+     +------------------+                    |
|  | WorkersCompPolicy|---->| Employer         |                    |
|  | policy_id        |     | employer_id      |                    |
|  | policy_number    |     | legal_name       |                    |
|  | effective_date   |     | fein             |                    |
|  | expiration_date  |     | sic_code         |                    |
|  | carrier_id       |     | naics_code       |                    |
|  | experience_mod   |     | address          |                    |
|  +--------+---------+     +--------+---------+                    |
|           |                         |                             |
|           v                         v                             |
|  +------------------+     +------------------+                    |
|  | ClassCode        |     | WorkersCompClaim |<---------+        |
|  | class_code       |     | claim_id         |          |        |
|  | description      |     | claim_number     |          |        |
|  | rate             |     | policy_id (FK)   |          |        |
|  | payroll_amount   |     | employer_id (FK) |          |        |
|  | state            |     | employee_id (FK) |          |        |
|  +------------------+     | date_of_injury   |          |        |
|                           | date_reported    |          |        |
|                           | jurisdiction_state|          |        |
|                           | claim_status     |          |        |
|                           | claim_type       |          |        |
|                           | compensability   |          |        |
|                           +--------+---------+          |        |
|                                    |                    |        |
|           +----------+-------------+-----------+--------+        |
|           |          |             |           |                  |
|           v          v             v           v                  |
|  +--------+--+ +----+------+ +----+------+ +--+----------+      |
|  | Injury     | | Medical   | | Disability| | Indemnity   |      |
|  | injury_id  | | Treatment | | Period    | | Payment     |      |
|  | claim_id   | | tx_id     | | period_id | | payment_id  |      |
|  | body_part  | | claim_id  | | claim_id  | | claim_id    |      |
|  | nature     | | provider  | | type(TTD/ | | type        |      |
|  | cause      | | date      | |  TPD/PPD/ | | amount      |      |
|  | icd10_code | | type      | |  PTD)     | | period_from |      |
|  | severity   | | cpt_code  | | start_date| | period_to   |      |
|  | body_side  | | diagnosis | | end_date  | | comp_rate   |      |
|  +------------+ | amount    | | status    | | check_number|      |
|                 | status    | | days_lost | | payment_date|      |
|                 +-----+-----+ +-----+-----+ +------+------+      |
|                       |             |               |             |
|                       v             v               v             |
|  +------------------+ +----+------+ +-----------+                |
|  | MedicalBill      | | Impairment| | Reserve   |                |
|  | bill_id          | | Rating    | | reserve_id|                |
|  | treatment_id(FK) | | rating_id | | claim_id  |                |
|  | provider_id      | | claim_id  | | type      |                |
|  | billed_amount    | | ama_edition| | category |                |
|  | allowed_amount   | | body_part | | amount    |                |
|  | paid_amount      | | wpi_pct   | | effective |                |
|  | fee_schedule     | | method    | |  _date    |                |
|  | review_status    | | mmi_date  | | set_by    |                |
|  | eob_code         | | physician | +--------+--+                |
|  +------------------+ +-----+-----+          |                   |
|                             |                 v                   |
|                             v        +--------+--------+          |
|  +------------------+      |        | ReturnToWork    |          |
|  | MSA              |      |        | rtw_id          |          |
|  | msa_id           |      |        | claim_id        |          |
|  | claim_id         |      |        | rtw_type        |          |
|  | msa_amount       |      |        | rtw_date        |          |
|  | annual_amount    |      |        | duty_status     |          |
|  | admin_type       |      |        | restrictions    |          |
|  | cms_approval     |      |        | employer_contact|          |
|  | submission_date  |      |        +-----------------+          |
|  | approval_date    |      |                                     |
|  +------------------+      v                                     |
|                    +--------+--------+                            |
|                    | Settlement      |                            |
|                    | settlement_id   |                            |
|                    | claim_id        |                            |
|                    | type (C&R/Stip) |                            |
|                    | total_amount    |                            |
|                    | indemnity_amount|                            |
|                    | medical_amount  |                            |
|                    | msa_amount      |                            |
|                    | approval_date   |                            |
|                    | effective_date  |                            |
|                    +-----------------+                            |
|                                                                  |
+------------------------------------------------------------------+
```

### 28.2 WorkersCompClaim Entity Detail

```sql
CREATE TABLE workers_comp_claim (
    claim_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_number            VARCHAR(30) NOT NULL UNIQUE,
    policy_id               UUID NOT NULL REFERENCES wc_policy(policy_id),
    employer_id             UUID NOT NULL REFERENCES employer(employer_id),
    employee_id             UUID NOT NULL REFERENCES employee(employee_id),
    
    -- Injury Information
    date_of_injury          DATE NOT NULL,
    time_of_injury          TIME,
    date_employer_notified  DATE,
    date_insurer_notified   DATE,
    date_reported_to_state  DATE,
    
    -- Location
    injury_state            CHAR(2) NOT NULL,
    injury_county           VARCHAR(50),
    injury_location_desc    TEXT,
    employer_premises       BOOLEAN DEFAULT TRUE,
    
    -- Jurisdiction
    jurisdiction_state      CHAR(2) NOT NULL,
    jurisdiction_claim_no   VARCHAR(30),
    
    -- Classification
    claim_type              VARCHAR(20) NOT NULL CHECK (claim_type IN (
                                'MEDICAL_ONLY', 'LOST_TIME', 'PPD', 'PTD', 'FATALITY')),
    claim_status            VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (claim_status IN (
                                'OPEN', 'CLOSED', 'REOPENED', 'DENIED', 'PENDING')),
    compensability_status   VARCHAR(20) DEFAULT 'PENDING' CHECK (compensability_status IN (
                                'ACCEPTED', 'DENIED', 'PENDING', 'PARTIAL')),
    compensability_date     DATE,
    
    -- Injury Coding
    nature_of_injury_code   VARCHAR(5),
    cause_of_injury_code    VARCHAR(5),
    body_part_code          VARCHAR(5),
    body_side               VARCHAR(5) CHECK (body_side IN ('LEFT', 'RIGHT', 'BILATERAL', 'NA')),
    icd10_primary           VARCHAR(10),
    icd10_secondary         VARCHAR(10)[],
    osha_recordable         BOOLEAN DEFAULT FALSE,
    
    -- Accident Description
    accident_description    TEXT,
    
    -- Wage Information
    average_weekly_wage     DECIMAL(10,2),
    aww_calculation_method  VARCHAR(20),
    compensation_rate       DECIMAL(10,2),
    days_per_week           INTEGER DEFAULT 5,
    
    -- Key Dates
    date_disability_began   DATE,
    date_last_worked        DATE,
    date_returned_to_work   DATE,
    date_mmi                DATE,
    date_claim_closed       DATE,
    
    -- Assignment
    adjuster_id             UUID REFERENCES adjuster(adjuster_id),
    supervisor_id           UUID REFERENCES adjuster(adjuster_id),
    nurse_case_manager_id   UUID,
    
    -- Financial Summaries
    total_paid_medical      DECIMAL(12,2) DEFAULT 0,
    total_paid_indemnity    DECIMAL(12,2) DEFAULT 0,
    total_paid_expense      DECIMAL(12,2) DEFAULT 0,
    total_reserved_medical  DECIMAL(12,2) DEFAULT 0,
    total_reserved_indemnity DECIMAL(12,2) DEFAULT 0,
    total_reserved_expense  DECIMAL(12,2) DEFAULT 0,
    total_incurred          DECIMAL(12,2) GENERATED ALWAYS AS (
        total_paid_medical + total_paid_indemnity + total_paid_expense +
        total_reserved_medical + total_reserved_indemnity + total_reserved_expense
    ) STORED,
    total_recovery          DECIMAL(12,2) DEFAULT 0,
    net_incurred            DECIMAL(12,2) GENERATED ALWAYS AS (
        total_paid_medical + total_paid_indemnity + total_paid_expense +
        total_reserved_medical + total_reserved_indemnity + total_reserved_expense -
        total_recovery
    ) STORED,
    
    -- Flags
    attorney_involved       BOOLEAN DEFAULT FALSE,
    litigation_flag         BOOLEAN DEFAULT FALSE,
    siu_referral            BOOLEAN DEFAULT FALSE,
    subrogation_flag        BOOLEAN DEFAULT FALSE,
    msa_required            BOOLEAN DEFAULT FALSE,
    second_injury_fund      BOOLEAN DEFAULT FALSE,
    
    -- Audit
    created_at              TIMESTAMP DEFAULT NOW(),
    created_by              VARCHAR(50),
    updated_at              TIMESTAMP DEFAULT NOW(),
    updated_by              VARCHAR(50),
    version                 INTEGER DEFAULT 1
);
```

### 28.3 Supporting Entities

```sql
CREATE TABLE injury (
    injury_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    body_part_code          VARCHAR(5) NOT NULL,
    body_part_description   VARCHAR(100),
    body_side               VARCHAR(10),
    nature_of_injury_code   VARCHAR(5) NOT NULL,
    nature_description      VARCHAR(100),
    cause_of_injury_code    VARCHAR(5) NOT NULL,
    cause_description       VARCHAR(100),
    icd10_code              VARCHAR(10),
    icd10_description       VARCHAR(200),
    severity                VARCHAR(10) CHECK (severity IN ('MINOR', 'MODERATE', 'SEVERE', 'CATASTROPHIC')),
    is_primary              BOOLEAN DEFAULT FALSE,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE TABLE medical_treatment (
    treatment_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    injury_id               UUID REFERENCES injury(injury_id),
    provider_id             UUID REFERENCES medical_provider(provider_id),
    treatment_date          DATE NOT NULL,
    treatment_type          VARCHAR(20) CHECK (treatment_type IN (
                                'EMERGENCY', 'OFFICE_VISIT', 'SURGERY', 'THERAPY', 
                                'DIAGNOSTIC', 'DME', 'PHARMACY', 'HOME_HEALTH')),
    cpt_code                VARCHAR(10),
    cpt_description         VARCHAR(200),
    diagnosis_codes         VARCHAR(10)[],
    facility_type           VARCHAR(20),
    billed_amount           DECIMAL(10,2),
    allowed_amount          DECIMAL(10,2),
    paid_amount             DECIMAL(10,2),
    fee_schedule_applied    VARCHAR(30),
    ur_status               VARCHAR(20) CHECK (ur_status IN (
                                'APPROVED', 'DENIED', 'PENDING', 'MODIFIED', 'NOT_REQUIRED')),
    ur_review_date          DATE,
    eob_codes               VARCHAR(10)[],
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE TABLE disability_period (
    period_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    disability_type         VARCHAR(5) NOT NULL CHECK (disability_type IN (
                                'TTD', 'TPD', 'PPD', 'PTD')),
    period_status           VARCHAR(15) DEFAULT 'ACTIVE' CHECK (period_status IN (
                                'ACTIVE', 'SUSPENDED', 'TERMINATED', 'CONVERTED')),
    start_date              DATE NOT NULL,
    end_date                DATE,
    suspension_date         DATE,
    suspension_reason       VARCHAR(50),
    days_paid               INTEGER DEFAULT 0,
    weeks_paid              DECIMAL(8,2) DEFAULT 0,
    comp_rate               DECIMAL(10,2),
    total_paid              DECIMAL(12,2) DEFAULT 0,
    waiting_period_applied  BOOLEAN DEFAULT FALSE,
    retroactive_paid        BOOLEAN DEFAULT FALSE,
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE TABLE impairment_rating (
    rating_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    rating_date             DATE NOT NULL,
    mmi_date                DATE,
    evaluating_physician_id UUID,
    physician_type          VARCHAR(20) CHECK (physician_type IN (
                                'TREATING', 'IME', 'QME', 'AME', 'PEER_REVIEW')),
    ama_guides_edition      VARCHAR(5),
    body_part_rated         VARCHAR(50),
    regional_impairment_pct DECIMAL(5,2),
    whole_person_impairment DECIMAL(5,2),
    combined_wpi            DECIMAL(5,2),
    apportionment_pct       DECIMAL(5,2) DEFAULT 0,
    net_impairment_pct      DECIMAL(5,2),
    rating_method           VARCHAR(30),
    disability_rating_pct   DECIMAL(5,2),
    ppd_weeks               DECIMAL(8,2),
    ppd_amount              DECIMAL(12,2),
    is_disputed             BOOLEAN DEFAULT FALSE,
    dispute_reason          TEXT,
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE TABLE return_to_work (
    rtw_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    rtw_type                VARCHAR(20) CHECK (rtw_type IN (
                                'FULL_DUTY', 'MODIFIED_DUTY', 'TRANSITIONAL', 
                                'LIGHT_DUTY', 'SEDENTARY', 'TERMINATED')),
    rtw_status              VARCHAR(15) CHECK (rtw_status IN (
                                'PLANNED', 'ACTIVE', 'COMPLETED', 'FAILED', 'CANCELLED')),
    planned_rtw_date        DATE,
    actual_rtw_date         DATE,
    end_date                DATE,
    employer_name           VARCHAR(100),
    is_same_employer        BOOLEAN DEFAULT TRUE,
    job_title               VARCHAR(100),
    hours_per_day           DECIMAL(4,1),
    days_per_week           INTEGER,
    wage_during_rtw         DECIMAL(10,2),
    restrictions            JSONB,
    accommodations          JSONB,
    physician_approval_date DATE,
    outcome                 VARCHAR(20) CHECK (outcome IN (
                                'SUCCESSFUL', 'UNSUCCESSFUL', 'ONGOING', 'PENDING')),
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE TABLE medicare_set_aside (
    msa_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_id                UUID NOT NULL REFERENCES workers_comp_claim(claim_id),
    msa_type                VARCHAR(20) CHECK (msa_type IN (
                                'LUMP_SUM', 'STRUCTURED', 'HYBRID')),
    msa_status              VARCHAR(20) CHECK (msa_status IN (
                                'CALCULATION', 'SUBMITTED', 'APPROVED', 'DENIED',
                                'MODIFIED', 'FUNDED', 'EXHAUSTED')),
    msa_amount              DECIMAL(12,2),
    annual_deposit          DECIMAL(10,2),
    life_expectancy_years   DECIMAL(4,1),
    rated_age               INTEGER,
    future_medical_cost     DECIMAL(12,2),
    future_pharmacy_cost    DECIMAL(12,2),
    future_surgery_cost     DECIMAL(12,2),
    cms_submission_date     DATE,
    cms_approval_date       DATE,
    cms_approved_amount     DECIMAL(12,2),
    administrator_name      VARCHAR(100),
    administrator_type      VARCHAR(20) CHECK (administrator_type IN (
                                'PROFESSIONAL', 'SELF', 'NONE')),
    seed_amount             DECIMAL(12,2),
    annuity_cost            DECIMAL(12,2),
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);
```

---

## 29. Integration with Medical Provider Networks

### 29.1 MPN Integration Architecture

```
MPN INTEGRATION POINTS:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIMS SYSTEM ←→ MPN MANAGEMENT SYSTEM                         |
|  +------------------------------------------------------------+  |
|  |                                                            |  |
|  |  PROVIDER DIRECTORY:                                       |  |
|  |  ├── Provider search API (specialty, location, network)    |  |
|  |  ├── Provider eligibility verification                     |  |
|  |  ├── Provider credential verification                      |  |
|  |  └── Referral management                                   |  |
|  |                                                            |  |
|  |  AUTHORIZATION:                                            |  |
|  |  ├── Pre-authorization request/response                    |  |
|  |  ├── Referral authorization                                |  |
|  |  └── Authorization status inquiry                          |  |
|  |                                                            |  |
|  |  BILLING:                                                  |  |
|  |  ├── Eligibility verification (270/271)                    |  |
|  |  ├── Medical bill submission (837P/837I)                   |  |
|  |  ├── Payment/remittance (835)                              |  |
|  |  └── Fee schedule application                              |  |
|  |                                                            |  |
|  |  CLINICAL:                                                 |  |
|  |  ├── HL7/FHIR clinical data exchange                       |  |
|  |  ├── Treatment plan submission                             |  |
|  |  ├── Progress notes                                        |  |
|  |  └── Work status reports (abilities/restrictions)          |  |
|  |                                                            |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  DATA STANDARDS:                                                 |
|  ├── HIPAA EDI: 837, 835, 270/271, 276/277, 278               |  |
|  ├── HL7 v2.x / FHIR R4                                       |  |
|  ├── NCPDP (pharmacy)                                          |  |
|  ├── IAIABC Medical EDI                                        |  |
|  └── State-specific medical bill formats                       |  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 30. Integration with Pharmacy Benefit Managers

### 30.1 PBM Integration Architecture

```
PBM INTEGRATION:
+------------------------------------------------------------------+
|                                                                  |
|  CLAIMS SYSTEM ←→ PBM SYSTEM                                    |
|                                                                  |
|  REAL-TIME ADJUDICATION:                                         |
|  ├── Pharmacy submits claim via NCPDP at point of sale           |
|  ├── PBM checks eligibility (is claim accepted?)                 |
|  ├── PBM checks formulary (is drug approved?)                    |
|  ├── PBM checks prior authorization                              |
|  ├── PBM calculates pricing per state fee schedule               |
|  └── Response: approved/denied with explanation                   |
|                                                                  |
|  DATA EXCHANGE:                                                  |
|  ├── Claim eligibility file → PBM (daily/real-time)              |
|  ├── Pharmacy claims data → Claims system (daily batch)          |
|  ├── Drug utilization reports → Claims system (weekly/monthly)   |
|  ├── Clinical alert notifications → Claims system (real-time)    |
|  └── Financial reconciliation files (monthly)                    |
|                                                                  |
|  INTEGRATION INTERFACES:                                         |
|  ├── NCPDP Telecommunication Standard (real-time)                |
|  ├── NCPDP Batch Standard (file-based)                           |
|  ├── REST APIs for clinical programs                              |
|  ├── SFTP for bulk file exchange                                 |
|  └── Web portal for adjuster access to pharmacy data             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 31. Integration with State WC Boards

### 31.1 State Board Integration

```
STATE WC BOARD INTEGRATIONS:
+------------------------------------------------------------------+
|                                                                  |
|  ELECTRONIC FILING:                                              |
|  ├── FROI/SROI via IAIABC EDI                                   |
|  │   ├── Direct submission to state                              |
|  │   ├── Via NCCI as intermediary (NCCI-administered states)     |
|  │   └── Via state-specific portal/clearinghouse                 |
|  ├── Medical dispute filings                                     |
|  ├── Hearing/conference scheduling                               |
|  ├── Settlement approval requests                                |
|  └── Proof of coverage reporting                                 |
|                                                                  |
|  STATE PORTAL INTEGRATION:                                       |
|  ├── Web service APIs (state-provided)                           |
|  ├── Batch file upload                                           |
|  ├── Screen scraping / RPA (legacy portals)                      |
|  └── Email-based filings (few remaining states)                  |
|                                                                  |
|  RESPONSE PROCESSING:                                            |
|  ├── Acknowledgments (TA/TW/TR/TE/DN)                           |
|  ├── Hearing notices                                             |
|  ├── Awards and orders                                           |
|  ├── Compliance notices                                          |
|  └── Penalty notices                                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 32. NCCI EDI Data Formats

### 32.1 NCCI Statistical Plan Data

```
NCCI STATISTICAL REPORTING:
+------------------------------------------------------------------+
|                                                                  |
|  UNIT STATISTICAL PLAN (Unit Stat):                              |
|  ├── Annual data submission from insurers to NCCI                |
|  ├── Policy-level premium and loss data                          |
|  ├── By classification code and state                            |
|  ├── Used for rate-making and experience rating                  |
|  ├── Call periods: 1st report, 2nd report, ... 10th report      |
|  └── Format: NCCI-specified fixed-length file                    |
|                                                                  |
|  DETAILED CLAIM INFORMATION (DCI):                               |
|  ├── Individual claim-level data                                 |
|  ├── For all claims above threshold (e.g., > $2,000 paid)       |
|  ├── Includes: paid, reserved, nature, cause, body part          |
|  ├── Updated annually with each unit stat call                   |
|  └── Used for detailed actuarial analysis                        |
|                                                                  |
|  FINANCIAL DATA CALL:                                            |
|  ├── Aggregate financial results by state                        |
|  ├── Premium, losses, LAE by year                                |
|  ├── Used for rate level analysis                                |
|  └── Quarterly and annual submissions                            |
|                                                                  |
|  MEDICAL DATA:                                                   |
|  ├── WC medical treatment data reporting                         |
|  ├── Procedure codes, diagnoses, charges, payments               |
|  ├── Used for fee schedule analysis and treatment guidelines     |
|  └── Submitted via NCCI Medical Data Call                        |
|                                                                  |
+------------------------------------------------------------------+
```

### 32.2 Data Format Examples

```
NCCI UNIT STAT RECORD LAYOUT (Simplified):
+------------------------------------------------------------------+
| Field                    | Pos  | Length | Description            |
+------------------------------------------------------------------+
| Record Type              | 1    | 2      | Header/Detail/Trailer  |
| Carrier Code             | 3    | 5      | NAIC carrier code      |
| Policy Number            | 8    | 18     | Policy identifier      |
| Policy Effective Date    | 26   | 8      | MMDDYYYY               |
| State Code               | 34   | 2      | FIPS state code        |
| Class Code               | 36   | 4      | NCCI class code        |
| Exposure (Payroll)       | 40   | 11     | Payroll in dollars     |
| Manual Premium           | 51   | 11     | Calculated premium     |
| Claim Count              | 62   | 5      | Number of claims       |
| Incurred Medical         | 67   | 11     | Medical incurred       |
| Incurred Indemnity       | 78   | 11     | Indemnity incurred     |
| Paid Medical             | 89   | 11     | Medical paid           |
| Paid Indemnity           | 100  | 11     | Indemnity paid         |
| Outstanding Medical      | 111  | 11     | Medical reserves       |
| Outstanding Indemnity    | 122  | 11     | Indemnity reserves     |
| Valuation Date           | 133  | 8      | As-of date             |
+------------------------------------------------------------------+
```

---

## 33. WC Claims Performance Metrics

### 33.1 Key Performance Indicators

```
WC CLAIMS KPIs:
+------------------------------------------------------------------+
|                                                                  |
|  FINANCIAL METRICS:                                              |
|  +------------------------------------------------------------+  |
|  | Metric                        | Target/Benchmark           |  |
|  +------------------------------------------------------------+  |
|  | Average Medical Cost/Claim    | Industry median ± 10%      |  |
|  | Average Indemnity Cost/Claim  | Industry median ± 10%      |  |
|  | Average Total Incurred/Claim  | Industry median ± 10%      |  |
|  | Medical Severity              | Trend < CPI-Medical        |  |
|  | Indemnity Severity            | Trend < AWW growth         |  |
|  | Frequency (claims per payroll)| < Industry average          |  |
|  | Loss Ratio                    | < Planned loss ratio       |  |
|  | ALAE Ratio                    | < 12-15% of losses         |  |
|  | Subrogation Recovery Rate     | > 5% of total paid         |  |
|  | Reserve Adequacy              | Within ± 5% at closure     |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  OPERATIONAL METRICS:                                            |
|  +------------------------------------------------------------+  |
|  | Metric                        | Target/Benchmark           |  |
|  +------------------------------------------------------------+  |
|  | Three-Point Contact Rate      | > 90% within 24 hours      |  |
|  | Avg Days to First Payment     | < 14 days from FNOL        |  |
|  | FROI Filing Timeliness        | > 95% within deadline      |  |
|  | SROI Filing Timeliness        | > 95% within deadline      |  |
|  | Avg Adjuster Caseload         | 125-150 indemnity claims   |  |
|  | Claim Closure Rate            | Track monthly/quarterly    |  |
|  | Reopened Claim Rate           | < 5%                       |  |
|  | Pending Claim Inventory       | Stable or declining        |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  CLINICAL/OUTCOMES METRICS:                                      |
|  +------------------------------------------------------------+  |
|  | Metric                        | Target/Benchmark           |  |
|  +------------------------------------------------------------+  |
|  | Average TTD Duration          | < ODG/MDG benchmark        |  |
|  | Return-to-Work Rate (30 days) | > 80%                      |  |
|  | Return-to-Work Rate (90 days) | > 90%                      |  |
|  | Litigation Rate               | < 10-15% of indemnity      |  |
|  | Opioid Prescription Rate      | Declining trend            |  |
|  | Med-Only Percentage           | > 70% of all claims        |  |
|  | Surgery Rate                  | < Industry average         |  |
|  | PPD Rate                      | Stable or declining        |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  COMPLIANCE METRICS:                                             |
|  +------------------------------------------------------------+  |
|  | Metric                        | Target/Benchmark           |  |
|  +------------------------------------------------------------+  |
|  | Compensability Decision Time  | < State deadline           |  |
|  | EDI Acceptance Rate           | > 95% accepted first time  |  |
|  | State Penalty Rate            | < 1% of claims             |  |
|  | Audit Compliance Score        | > 90%                      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 34. Technology Platform Requirements

### 34.1 WC Claims System Capabilities

```
WC CLAIMS PLATFORM REQUIREMENTS:
+------------------------------------------------------------------+
|                                                                  |
|  CORE CLAIMS PROCESSING:                                         |
|  ├── Multi-state claims management                               |
|  ├── State-specific benefit calculation engine                   |
|  ├── Configurable per-state rules (50 states + territories)      |
|  ├── AWW and compensation rate calculators                       |
|  ├── Waiting period and retroactive period management            |
|  ├── Disability type tracking and conversion                     |
|  ├── Scheduled and unscheduled benefit management                |
|  └── Settlement calculation and tracking                         |
|                                                                  |
|  MEDICAL MANAGEMENT:                                             |
|  ├── Medical bill review integration                             |
|  ├── Utilization review workflow                                 |
|  ├── Case management tracking                                   |
|  ├── Treatment guideline integration (ODG/ACOEM)                |
|  ├── Medical fee schedule application (per state)                |
|  ├── Provider network management integration                    |
|  ├── IME scheduling and tracking                                 |
|  └── Pharmacy integration                                       |
|                                                                  |
|  EDI/REGULATORY:                                                 |
|  ├── IAIABC EDI R3 FROI/SROI generation                         |
|  ├── Multi-state EDI filing and acknowledgment processing        |
|  ├── NCCI unit stat and DCI reporting                            |
|  ├── State-specific form generation                              |
|  ├── OSHA recordkeeping integration                              |
|  ├── EDI error management and correction workflow                |
|  └── Filing deadline tracking and alerting                       |
|                                                                  |
|  INDEMNITY MANAGEMENT:                                           |
|  ├── Automated TTD/TPD/PPD/PTD payment calculations              |
|  ├── State maximum/minimum rate tables (auto-updated annually)   |
|  ├── COLA adjustment management                                  |
|  ├── Payment scheduling (weekly, bi-weekly)                      |
|  ├── Overpayment detection and recovery                          |
|  ├── Offset management (SSDI, pension, other benefits)           |
|  └── Tax reporting (no federal tax on WC benefits, but 1099)     |
|                                                                  |
|  RETURN-TO-WORK:                                                 |
|  ├── RTW plan creation and tracking                              |
|  ├── Modified duty management                                    |
|  ├── Restriction matching to job requirements                    |
|  ├── RTW date tracking and alerts                                |
|  └── Vocational rehabilitation tracking                          |
|                                                                  |
|  IMPAIRMENT/RATING:                                              |
|  ├── AMA Guides calculation support (4th, 5th, 6th editions)    |
|  ├── State-specific rating methods                               |
|  ├── Combined values calculator                                  |
|  ├── Scheduled loss calculators (per state)                      |
|  └── Apportionment tracking                                      |
|                                                                  |
|  MSA MANAGEMENT:                                                 |
|  ├── MSA requirement determination                               |
|  ├── MSA calculation support                                     |
|  ├── CMS submission tracking                                     |
|  ├── MSA administration tracking                                 |
|  └── MSA depletion monitoring                                    |
|                                                                  |
|  ANALYTICS:                                                      |
|  ├── Experience mod projection                                   |
|  ├── Loss development analysis                                   |
|  ├── Benchmarking against industry data                          |
|  ├── Predictive analytics (claim severity, litigation risk)      |
|  ├── Return-to-work analytics                                    |
|  ├── Medical cost drivers analysis                               |
|  └── Employer-level reporting                                    |
|                                                                  |
|  INTEGRATIONS:                                                   |
|  ├── Medical bill review vendors                                 |
|  ├── PBM systems                                                 |
|  ├── MPN/PPO networks                                            |
|  ├── State WC board portals                                      |
|  ├── NCCI/state bureau systems                                   |
|  ├── Payroll systems (wage verification)                         |
|  ├── HR systems (employee data, job info)                        |
|  ├── Safety/risk management systems                              |
|  ├── ISO ClaimSearch                                             |
|  ├── OSHA reporting systems                                      |
|  ├── CMS (Medicare) systems for MSA                              |
|  └── Reinsurance systems (for large loss reporting)              |
|                                                                  |
+------------------------------------------------------------------+
```

### 34.2 Technology Stack for WC Claims

```
RECOMMENDED TECHNOLOGY STACK:
+------------------------------------------------------------------+
| Component              | Options                                  |
+------------------------------------------------------------------+
| Claims Engine          | Guidewire ClaimCenter, Duck Creek Claims, |
|                        | Majesco Claims, custom platform           |
| Rules Engine           | Drools, Red Hat Decision Manager,         |
|                        | Corticon, or embedded in claims platform  |
| EDI Processing         | Custom EDI engine, Jitterbit, Dell Boomi, |
|                        | or claims platform built-in               |
| Medical Bill Review    | Mitchell, Conduent, CorVel, Coventry,     |
|                        | or integrated platform                    |
| PBM Integration        | myMatrixx, Optum, Express Scripts          |
| Case Management        | Genex, CorVel, Coventry, custom           |
| Document Management    | OnBase, FileNet, AWS S3 + metadata        |
| Analytics              | Tableau, Power BI, Snowflake, Databricks  |
| Integration Platform   | MuleSoft, Dell Boomi, Apache Camel, Kong  |
| Database               | PostgreSQL, Oracle, SQL Server             |
| Cloud                  | AWS, Azure, GCP                           |
| Monitoring             | Datadog, New Relic, Prometheus + Grafana  |
+------------------------------------------------------------------+
```

### 34.3 Architectural Considerations for WC Claims

```
KEY ARCHITECTURAL DECISIONS:
+------------------------------------------------------------------+
|                                                                  |
|  1. STATE RULE ENGINE DESIGN:                                    |
|     ├── Must support 50+ jurisdictions simultaneously            |
|     ├── Rules change frequently (annual legislative changes)     |
|     ├── Need effective-date-based rule versioning                |
|     ├── Consider: externalized rule engine with state configs    |
|     └── Testing: comprehensive state-specific test suites        |
|                                                                  |
|  2. BENEFIT CALCULATION ENGINE:                                  |
|     ├── Parameterized by state, injury date, claim type          |
|     ├── AWW calculation varies by state                          |
|     ├── Comp rate calculation varies by state and benefit type   |
|     ├── Must handle rate changes mid-claim (annual updates)      |
|     └── Audit trail for all calculations                         |
|                                                                  |
|  3. EDI PROCESSING:                                              |
|     ├── Must generate compliant FROI/SROI per state             |
|     ├── Handle state-specific data requirements                  |
|     ├── Process acknowledgments and error corrections            |
|     ├── Track filing deadlines and compliance                    |
|     └── Support both NCCI and independent bureau states          |
|                                                                  |
|  4. MULTI-LINE INTEGRATION:                                      |
|     ├── WC claims often trigger GL or auto claims (subrogation)  |
|     ├── Shared claimant/employer data with other lines           |
|     ├── Cross-line analytics and reporting                       |
|     └── Unified document and communication management            |
|                                                                  |
|  5. SCALABILITY CONSIDERATIONS:                                  |
|     ├── Open claim inventory can be 100K+ for large carriers     |
|     ├── Historical data: millions of closed claims                |
|     ├── Annual NCCI reporting: massive data extracts              |
|     ├── Concurrent user: hundreds of adjusters                   |
|     └── Peak processing: year-end, audit season                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## Summary

Workers compensation claims represent one of the most complex specializations in P&C insurance. The combination of state-specific regulations, medical management, disability duration tracking, and regulatory reporting requirements creates a uniquely challenging domain for systems architects.

Key architectural takeaways:
1. **State configurability** is paramount — the system must handle 50+ jurisdictions with different rules
2. **Medical integration** is critical — WC is fundamentally a medical management line
3. **EDI compliance** is non-negotiable — electronic reporting to states is mandatory
4. **Benefit calculations** must be precise and auditable — errors trigger penalties and litigation
5. **Return-to-work** capabilities drive outcomes — early RTW reduces claim costs by 50%+
6. **Fraud detection** must be embedded — WC fraud costs billions annually
7. **Analytics** enable proactive management — predictive models improve outcomes

The data model must accommodate the full lifecycle from injury through recovery, impairment rating, settlement, and regulatory reporting, while maintaining the flexibility to adapt to annual legislative changes across all jurisdictions.
