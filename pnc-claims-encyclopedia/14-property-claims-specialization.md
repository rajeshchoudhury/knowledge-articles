# Article 14: Property Claims — Complete Specialization Guide

## Table of Contents

1. [Homeowners Coverage Structure](#1-homeowners-coverage-structure)
2. [Commercial Property Coverage](#2-commercial-property-coverage)
3. [Covered and Excluded Perils](#3-covered-and-excluded-perils)
4. [Property FNOL Data Requirements](#4-property-fnol-data-requirements)
5. [Coverage A-F Analysis](#5-coverage-a-f-analysis)
6. [Replacement Cost vs Actual Cash Value](#6-replacement-cost-vs-actual-cash-value)
7. [Coinsurance Requirements](#7-coinsurance-requirements)
8. [Ordinance or Law Coverage](#8-ordinance-or-law-coverage)
9. [Scope of Loss Documentation](#9-scope-of-loss-documentation)
10. [Property Estimation Platforms](#10-property-estimation-platforms)
11. [Xactimate Deep Dive](#11-xactimate-deep-dive)
12. [Contents / Personal Property Inventory](#12-contents--personal-property-inventory)
13. [Water Damage Claims](#13-water-damage-claims)
14. [Fire Damage Claims](#14-fire-damage-claims)
15. [Wind and Hail Claims](#15-wind-and-hail-claims)
16. [Theft Claims](#16-theft-claims)
17. [Additional Living Expense (ALE)](#17-additional-living-expense-ale)
18. [Mold Claims](#18-mold-claims)
19. [Contractor Management](#19-contractor-management)
20. [Managed Repair Programs](#20-managed-repair-programs)
21. [Public Adjuster Interaction](#21-public-adjuster-interaction)
22. [Mortgage Company Interests](#22-mortgage-company-interests)
23. [Property Claims Data Model](#23-property-claims-data-model)
24. [Catastrophe Property Claims](#24-catastrophe-property-claims)
25. [Commercial Property Specifics](#25-commercial-property-specifics)
26. [Inland Marine Claims](#26-inland-marine-claims)
27. [Property Claims Performance Metrics](#27-property-claims-performance-metrics)

---

## 1. Homeowners Coverage Structure

### 1.1 Homeowners Policy Forms

```
  HOMEOWNERS POLICY FORMS
  ═══════════════════════

  ┌──────────────────────────────────────────────────────────────┐
  │ FORM   │ NAME                    │ COVERAGE TYPE             │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-1   │ Basic Form              │ Named Perils only (10)   │
  │        │ (rarely used)           │                           │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-2   │ Broad Form              │ Named Perils (16)        │
  │        │                         │ Broader than HO-1        │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-3   │ Special Form            │ OPEN PERIL (dwelling)    │
  │        │ (MOST COMMON - ~80%)    │ Named Peril (contents)   │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-4   │ Contents Broad Form     │ Named Perils (contents)  │
  │        │ (Renters Insurance)     │ No dwelling coverage     │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-5   │ Comprehensive Form      │ OPEN PERIL (dwelling)    │
  │        │ (Premium coverage)      │ OPEN PERIL (contents)    │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-6   │ Unit Owners Form        │ Named Perils             │
  │        │ (Condo Insurance)       │ Interior only            │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-7   │ Mobile Home Form        │ Similar to HO-3          │
  │        │                         │ For manufactured homes   │
  │────────│─────────────────────────│──────────────────────────│
  │ HO-8   │ Modified Coverage Form  │ Named Perils             │
  │        │ (Older homes)           │ Functional replacement   │
  │        │                         │ cost basis               │
  └──────────────────────────────────────────────────────────────┘

  DWELLING FIRE FORMS:
  ┌──────────────────────────────────────────────────────────────┐
  │ DP-1   │ Basic Form              │ Named Perils (limited)   │
  │        │ (Rental properties)     │ ACV basis               │
  │────────│─────────────────────────│──────────────────────────│
  │ DP-2   │ Broad Form              │ Named Perils (broad)     │
  │        │ (Rental properties)     │ RC or ACV               │
  │────────│─────────────────────────│──────────────────────────│
  │ DP-3   │ Special Form            │ OPEN PERIL (dwelling)    │
  │        │ (Investment property)   │ Named Peril (contents)   │
  └──────────────────────────────────────────────────────────────┘
```

### 1.2 HO-3 Named Perils (16 Perils for Personal Property)

| # | Peril | Description |
|---|---|---|
| 1 | Fire or Lightning | Direct damage from fire or lightning strike |
| 2 | Windstorm or Hail | Wind-driven damage; hail impact |
| 3 | Explosion | Gas, chemical, or other explosion |
| 4 | Riot or Civil Commotion | Damage during civil disturbance |
| 5 | Aircraft | Damage from aircraft or objects falling from aircraft |
| 6 | Vehicles | Damage from vehicles striking the dwelling |
| 7 | Smoke | Sudden and accidental smoke damage |
| 8 | Vandalism or Malicious Mischief | Intentional damage by others |
| 9 | Theft | Stolen property (on and off premises) |
| 10 | Falling Objects | Trees, branches, exterior objects |
| 11 | Weight of Ice, Snow, Sleet | Structural collapse from accumulated weight |
| 12 | Accidental Discharge of Water | Sudden pipe burst, appliance overflow |
| 13 | Sudden Tearing/Cracking/Burning | Of heating, AC, fire protection systems |
| 14 | Freezing | Of plumbing, heating, AC systems |
| 15 | Sudden Damage from Electrical Current | Power surge (excluding electronics in some forms) |
| 16 | Volcanic Eruption | Direct volcanic activity (not earthquake) |

---

## 2. Commercial Property Coverage

### 2.1 Commercial Property Policy Types

```
  COMMERCIAL PROPERTY COVERAGE HIERARCHY
  ═══════════════════════════════════════

  ┌──────────────────────────────────────────────────────────────┐
  │ BUSINESS OWNERS POLICY (BOP)                                 │
  │ • Small business package policy                              │
  │ • Combined property + liability                              │
  │ • Simplified coverage for eligible businesses                │
  │ • Named perils or special cause of loss                      │
  │ • Building + BPP + Business Income (often included)         │
  └──────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────────────┐
  │ COMMERCIAL PACKAGE POLICY (CPP)                              │
  │ ┌──────────────────────────────────────────────────────────┐│
  │ │ Commercial Property Coverage Part                        ││
  │ │ • Building                                                ││
  │ │ • Business Personal Property (BPP)                       ││
  │ │ • Personal Property of Others                            ││
  │ │ • Business Income with Extra Expense                     ││
  │ │                                                           ││
  │ │ Cause of Loss Forms:                                     ││
  │ │ • Basic Form (named perils)                              ││
  │ │ • Broad Form (expanded named perils)                     ││
  │ │ • Special Form (open perils - most common)               ││
  │ └──────────────────────────────────────────────────────────┘│
  │ ┌──────────────────────────────────────────────────────────┐│
  │ │ Commercial General Liability Part                        ││
  │ └──────────────────────────────────────────────────────────┘│
  │ ┌──────────────────────────────────────────────────────────┐│
  │ │ Commercial Auto Part                                     ││
  │ └──────────────────────────────────────────────────────────┘│
  │ ┌──────────────────────────────────────────────────────────┐│
  │ │ Commercial Umbrella/Excess                               ││
  │ └──────────────────────────────────────────────────────────┘│
  └──────────────────────────────────────────────────────────────┘

  ┌──────────────────────────────────────────────────────────────┐
  │ SPECIALTY PROPERTY COVERAGES                                 │
  │                                                               │
  │ • Inland Marine       - Property in transit, mobile equipment│
  │ • Builders Risk       - Construction in progress             │
  │ • Equipment Breakdown - Mechanical/electrical failure        │
  │ • Flood (NFIP/private)- Flood damage                        │
  │ • Earthquake          - Seismic damage                       │
  │ • Difference in Conditions (DIC) - Gap filler               │
  └──────────────────────────────────────────────────────────────┘
```

---

## 3. Covered and Excluded Perils

### 3.1 Open Peril vs Named Peril Coverage

```
  COVERAGE COMPARISON
  ═══════════════════

  OPEN PERIL (Special Form - HO-3 Dwelling, CP Special):
  ┌──────────────────────────────────────────────────────────┐
  │ Covers ALL causes of loss EXCEPT those specifically      │
  │ excluded in the policy.                                  │
  │                                                          │
  │ Burden of proof: INSURER must prove an exclusion applies │
  │                                                          │
  │ STANDARD EXCLUSIONS:                                     │
  │ • Ordinance or law (unless endorsed)                     │
  │ • Earth movement (earthquake, landslide, sinkhole)       │
  │ • Water (flood, surface water, sewer backup)             │
  │ • Power failure (off premises)                           │
  │ • Neglect (failure to protect property)                  │
  │ • War and nuclear hazard                                 │
  │ • Intentional loss                                       │
  │ • Governmental action                                    │
  │ • Faulty workmanship / materials / design                │
  │ • Wear and tear / deterioration                          │
  │ • Mold, fungus, wet rot (unless endorsed)                │
  │ • Insects, vermin, animals (nesting, chewing)            │
  │ • Smog, rust, corrosion                                  │
  │ • Settling, cracking, shrinking                          │
  │ • Mechanical breakdown (unless endorsed)                 │
  └──────────────────────────────────────────────────────────┘

  NAMED PERIL (HO-2, HO-4, CP Basic/Broad):
  ┌──────────────────────────────────────────────────────────┐
  │ Covers ONLY causes of loss specifically listed in policy │
  │                                                          │
  │ Burden of proof: INSURED must prove a named peril caused │
  │ the damage                                               │
  └──────────────────────────────────────────────────────────┘
```

### 3.2 Common Endorsements

| Endorsement | Description | Typical Premium Impact |
|---|---|---|
| Flood (NFIP or private) | Covers flood damage | Varies widely ($500 - $10,000+) |
| Earthquake | Covers earthquake damage | 1-5% of dwelling coverage |
| Sewer/Drain Backup | Covers sewer/drain backup water damage | $50 - $200/year |
| Ordinance or Law | Covers cost to comply with building codes | $50 - $200/year |
| Scheduled Personal Property | Specific high-value items (jewelry, art) | Varies by item value |
| Water Backup | Covers sump pump failure and backup | $50 - $150/year |
| Identity Theft | Covers ID theft expenses | $25 - $75/year |
| Home Business | Covers business property and liability at home | $100 - $500/year |
| Equipment Breakdown | Covers mechanical/electrical failure | $30 - $100/year |
| Service Line | Covers underground utility lines | $30 - $75/year |
| Mold Coverage | Adds or increases mold coverage | $100 - $500/year |

---

## 4. Property FNOL Data Requirements

### 4.1 Property FNOL Fields

```
  PROPERTY FNOL DATA REQUIREMENTS
  ═══════════════════════════════

  PROPERTY INFORMATION (30 fields):
  ┌──────────────────────────────────────────────────────────┐
  │ propertyAddress          │ Address  │ Yes      │ Policy  │
  │ propertyCity             │ String   │ Yes      │ Policy  │
  │ propertyState            │ Code     │ Yes      │ Policy  │
  │ propertyZip              │ String   │ Yes      │ Policy  │
  │ propertyType             │ Code     │ Yes      │ Policy  │
  │ constructionType         │ Code     │ Yes      │ Policy  │
  │ yearBuilt                │ Integer  │ Yes      │ Policy  │
  │ squareFootage            │ Integer  │ No       │ Policy  │
  │ numberOfStories          │ Integer  │ Yes      │ Policy  │
  │ roofType                 │ Code     │ No       │ Policy  │
  │ roofMaterial             │ Code     │ No       │ Policy  │
  │ roofAge                  │ Integer  │ No       │ Caller  │
  │ basementPresent          │ Boolean  │ Yes      │ Policy  │
  │ basementFinished         │ Boolean  │ Cond     │ Caller  │
  │ occupancyStatus          │ Code     │ Yes      │ Caller  │
  │ propertyVacant           │ Boolean  │ Yes      │ Caller  │
  │ vacantDuration           │ Integer  │ Cond     │ Caller  │
  │ mortgageeCompany         │ String   │ No       │ Policy  │
  │ mortgageeLoanNumber      │ String   │ No       │ Policy  │
  │ propertyAccessible       │ Boolean  │ Yes      │ Caller  │
  │ utilities_status         │ Code     │ Yes      │ Caller  │
  │ emergencyServicesContacted│ Boolean │ Yes      │ Caller  │
  │ emergencyMitigationDone  │ Boolean  │ Yes      │ Caller  │
  │ mitigationCompanyName    │ String   │ Cond     │ Caller  │
  │ mitigationCompanyPhone   │ Phone    │ Cond     │ Caller  │
  └──────────────────────────────────────────────────────────┘

  DAMAGE INFORMATION (25 fields):
  ┌──────────────────────────────────────────────────────────┐
  │ perilType                │ Code     │ Yes      │ Caller  │
  │ damageDescription        │ Text     │ Yes      │ Caller  │
  │ areasAffected            │ List     │ Yes      │ Caller  │
  │ structuralDamage         │ Boolean  │ Yes      │ Caller  │
  │ roofDamage               │ Boolean  │ Yes      │ Caller  │
  │ interiorDamage           │ Boolean  │ Yes      │ Caller  │
  │ waterPresent             │ Boolean  │ Yes      │ Caller  │
  │ waterSource              │ Code     │ Cond     │ Caller  │
  │ waterStanding            │ Boolean  │ Cond     │ Caller  │
  │ waterDepthInches         │ Integer  │ Cond     │ Caller  │
  │ contentsDamaged          │ Boolean  │ Yes      │ Caller  │
  │ contentsDamageDesc       │ Text     │ Cond     │ Caller  │
  │ habitableStatus          │ Code     │ Yes      │ Caller  │
  │ needsTemporaryHousing    │ Boolean  │ Yes      │ Caller  │
  │ numberOfDisplaced        │ Integer  │ Cond     │ Caller  │
  │ treeDamage               │ Boolean  │ No       │ Caller  │
  │ debrisPresent            │ Boolean  │ No       │ Caller  │
  │ estimatedDamageSeverity  │ Code     │ Yes      │ Caller  │
  │ priorClaimsOnProperty    │ Integer  │ No       │ System  │
  │ priorDamageExisting      │ Boolean  │ No       │ Caller  │
  │ fireMarshallInvestigating│ Boolean  │ Cond     │ Caller  │
  │ policeReportFiled        │ Boolean  │ Cond     │ Caller  │
  │ boardUpNeeded            │ Boolean  │ Yes      │ Caller  │
  │ tarpsNeeded              │ Boolean  │ Yes      │ Caller  │
  │ weatherAtLoss            │ Code     │ Yes      │ Caller  │
  └──────────────────────────────────────────────────────────┘
```

---

## 5. Coverage A-F Analysis

### 5.1 Homeowners Coverage Sections

```
  HO-3 COVERAGE SECTIONS
  ═══════════════════════

  COVERAGE A: DWELLING
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: The dwelling structure itself                    │
  │ • Main house structure (walls, roof, foundation)         │
  │ • Attached structures (garage, deck, porch)              │
  │ • Built-in appliances                                    │
  │ • Permanently installed carpet                           │
  │ • Materials for repair/construction on premises          │
  │                                                          │
  │ Limit: Policy declarations amount                        │
  │ Valuation: Replacement Cost (typically)                  │
  │ Deductible: Per-occurrence (standard or hurricane %)     │
  └──────────────────────────────────────────────────────────┘

  COVERAGE B: OTHER STRUCTURES
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: Structures separated from dwelling               │
  │ • Detached garage                                        │
  │ • Tool shed, barn                                        │
  │ • Fence, retaining wall                                  │
  │ • Swimming pool, hot tub                                 │
  │ • Guest house (if not rented)                            │
  │                                                          │
  │ Limit: 10% of Coverage A (standard)                     │
  │ Valuation: Replacement Cost                              │
  └──────────────────────────────────────────────────────────┘

  COVERAGE C: PERSONAL PROPERTY (CONTENTS)
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: Personal belongings                              │
  │ • Furniture, clothing, electronics                       │
  │ • Kitchen appliances (non-built-in)                      │
  │ • Sports equipment, tools                                │
  │ • Property temporarily away from home                    │
  │                                                          │
  │ Limit: 50-70% of Coverage A (standard)                  │
  │ Valuation: ACV (standard) or RC (if endorsed)           │
  │                                                          │
  │ SUBLIMITS (typical):                                     │
  │ • Cash/securities: $200                                  │
  │ • Jewelry/watches: $1,500                                │
  │ • Firearms: $2,500                                       │
  │ • Silverware: $2,500                                     │
  │ • Business property: $2,500                              │
  │ • Electronics: $5,000                                    │
  │ • Watercraft: $1,500                                     │
  └──────────────────────────────────────────────────────────┘

  COVERAGE D: LOSS OF USE / ADDITIONAL LIVING EXPENSE (ALE)
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: Additional costs when home is uninhabitable      │
  │ • Hotel/temporary housing                                │
  │ • Restaurant meals (above normal cost)                   │
  │ • Storage for contents                                   │
  │ • Additional transportation costs                        │
  │ • Laundry expenses                                       │
  │                                                          │
  │ Limit: 20-30% of Coverage A (standard)                  │
  │ Duration: Until home is repaired or "reasonable" period  │
  └──────────────────────────────────────────────────────────┘

  COVERAGE E: PERSONAL LIABILITY
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: Legal liability for bodily injury/property damage│
  │ Limit: $100K - $500K per occurrence (standard)          │
  └──────────────────────────────────────────────────────────┘

  COVERAGE F: MEDICAL PAYMENTS TO OTHERS
  ┌──────────────────────────────────────────────────────────┐
  │ Covers: Medical expenses for non-household members       │
  │ injured on your property, regardless of fault            │
  │ Limit: $1K - $5K per person (standard)                  │
  └──────────────────────────────────────────────────────────┘
```

---

## 6. Replacement Cost vs Actual Cash Value

### 6.1 Valuation Methods

```
  PROPERTY VALUATION METHODS
  ══════════════════════════

  REPLACEMENT COST VALUE (RCV):
  ┌──────────────────────────────────────────────────────────┐
  │ Definition: Cost to repair/replace with materials of     │
  │ like kind and quality, without deduction for depreciation│
  │                                                          │
  │ Payment Process (typical):                               │
  │ 1. Initial payment = ACV (RCV - depreciation)           │
  │ 2. Insured completes repairs                            │
  │ 3. Insured submits proof of repair/replacement          │
  │ 4. Carrier pays recoverable depreciation                │
  │                                                          │
  │ Example:                                                 │
  │ New roof cost (RCV):        $15,000                     │
  │ Depreciation (10yr/25yr):   -$6,000                     │
  │ ACV:                        $9,000                      │
  │                                                          │
  │ Initial payment (ACV - ded): $9,000 - $2,500 = $6,500  │
  │ After repair completion:     $6,000 (recoverable dep)   │
  │ Total received:              $12,500                    │
  └──────────────────────────────────────────────────────────┘

  ACTUAL CASH VALUE (ACV):
  ┌──────────────────────────────────────────────────────────┐
  │ Definition: Replacement Cost minus depreciation          │
  │ (Fair market value / what item is worth today)           │
  │                                                          │
  │ Methods to determine ACV:                                │
  │ 1. RCV - Depreciation (most common)                     │
  │ 2. Fair market value (comparable sales)                  │
  │ 3. Broad evidence rule (considers all relevant factors)  │
  │                                                          │
  │ Depreciation Factors:                                    │
  │ • Age of item                                            │
  │ • Expected useful life                                   │
  │ • Condition prior to loss                                │
  │ • Maintenance history                                    │
  │ • Obsolescence                                           │
  └──────────────────────────────────────────────────────────┘

  FUNCTIONAL REPLACEMENT COST (HO-8):
  ┌──────────────────────────────────────────────────────────┐
  │ Definition: Cost to repair/replace using modern methods  │
  │ and materials that serve the same function               │
  │                                                          │
  │ Used for older homes where exact replica replacement     │
  │ would be prohibitively expensive                         │
  │                                                          │
  │ Example: Plaster walls replaced with drywall             │
  └──────────────────────────────────────────────────────────┘
```

### 6.2 Depreciation Schedules

| Item Category | Useful Life | Depreciation Rate |
|---|---|---|
| Asphalt shingle roof | 20-30 years | 3.3% - 5% per year |
| Wood shake roof | 25-30 years | 3.3% - 4% per year |
| Metal roof | 40-70 years | 1.4% - 2.5% per year |
| Carpet | 8-10 years | 10% - 12.5% per year |
| Hardwood flooring | 25-50 years | 2% - 4% per year |
| Interior paint | 5-7 years | 14% - 20% per year |
| Exterior paint | 7-10 years | 10% - 14% per year |
| Water heater | 10-15 years | 6.7% - 10% per year |
| HVAC system | 15-25 years | 4% - 6.7% per year |
| Plumbing | 20-50 years | 2% - 5% per year |
| Electrical wiring | 30-50 years | 2% - 3.3% per year |
| Appliances | 8-15 years | 6.7% - 12.5% per year |
| Furniture | 10-15 years | 6.7% - 10% per year |
| Electronics | 3-7 years | 14% - 33% per year |
| Clothing | 2-5 years | 20% - 50% per year |

---

## 7. Coinsurance Requirements

### 7.1 Coinsurance Concept

```
  COINSURANCE IN PROPERTY INSURANCE
  ═══════════════════════════════════

  Concept: Insured must carry coverage equal to a specified
  percentage (typically 80%) of the property's replacement
  cost, or face a penalty at claim time.

  FORMULA:
  ┌──────────────────────────────────────────────────────────┐
  │                                                          │
  │                Amount of Insurance Carried               │
  │ Payment = ────────────────────────────────── × Loss      │
  │           Amount of Insurance Required                   │
  │                                                          │
  │ Where:                                                   │
  │   Required = Coinsurance % × Replacement Cost Value      │
  │                                                          │
  └──────────────────────────────────────────────────────────┘

  EXAMPLE (Compliant):
  Building RCV:     $500,000
  Coinsurance %:    80%
  Required:         $400,000
  Carried:          $450,000
  Loss:             $100,000
  Deductible:       $5,000
  
  Payment = ($450,000 / $400,000) × $100,000 = $100,000
  (Ratio > 1.0, so full payment: $100,000 - $5,000 = $95,000)

  EXAMPLE (Non-Compliant - PENALTY):
  Building RCV:     $500,000
  Coinsurance %:    80%
  Required:         $400,000
  Carried:          $300,000  ← Underinsured!
  Loss:             $100,000
  Deductible:       $5,000
  
  Payment = ($300,000 / $400,000) × $100,000 = $75,000
  Net payment: $75,000 - $5,000 = $70,000
  
  Penalty: Insured bears $25,000 of the loss as coinsurance penalty
```

---

## 8. Ordinance or Law Coverage

### 8.1 O&L Coverage Components

```
  ORDINANCE OR LAW COVERAGE
  ═════════════════════════

  COVERAGE A: Loss to Undamaged Portion
  ┌──────────────────────────────────────────────────────────┐
  │ When building codes require demolition of undamaged      │
  │ portion due to extent of damage (e.g., > 50% damaged    │
  │ requires full teardown per local code)                   │
  │                                                          │
  │ Example:                                                 │
  │ Building: $500,000 RCV                                   │
  │ Fire damages 60% of building ($300,000)                  │
  │ City code: > 50% damage → full demolition required       │
  │ Remaining 40% ($200,000) must be demolished              │
  │ O&L Coverage A covers the $200,000 undamaged portion    │
  └──────────────────────────────────────────────────────────┘

  COVERAGE B: Demolition Cost
  ┌──────────────────────────────────────────────────────────┐
  │ Cost to demolish the damaged and/or undamaged portions   │
  │ and remove debris as required by building code           │
  │                                                          │
  │ Example:                                                 │
  │ Demolition and debris removal: $35,000                   │
  └──────────────────────────────────────────────────────────┘

  COVERAGE C: Increased Cost of Construction
  ┌──────────────────────────────────────────────────────────┐
  │ Additional cost to rebuild to current building codes     │
  │ that didn't exist when building was originally built     │
  │                                                          │
  │ Examples:                                                 │
  │ • Updated electrical to current NEC                      │
  │ • ADA compliance upgrades                                │
  │ • Energy code compliance (insulation, windows)           │
  │ • Seismic retrofitting requirements                      │
  │ • Wind resistance upgrades (Florida Building Code)       │
  │ • Sprinkler system addition                              │
  │                                                          │
  │ Increased cost: $75,000                                  │
  └──────────────────────────────────────────────────────────┘
```

---

## 9. Scope of Loss Documentation

### 9.1 Property Inspection Process

```
  SCOPE OF LOSS DOCUMENTATION WORKFLOW
  ═════════════════════════════════════

  Initial Inspection    Detailed Scope      Documentation
  ──────────────────    ──────────────      ─────────────
      │                     │                    │
      │ Exterior survey:    │                    │
      │ - Roof inspection   │                    │
      │ - Siding/cladding   │                    │
      │ - Windows/doors     │                    │
      │ - Foundation        │                    │
      │ - Other structures  │                    │
      │ - Landscaping       │                    │
      │─────────────────────▶                    │
      │                     │                    │
      │ Interior survey:    │ Room-by-room       │
      │ - Room by room      │ documentation:     │
      │ - Floor to ceiling  │ - Measurements     │
      │ - Left to right     │ - Materials ID     │
      │ - Document all      │ - Damage extent    │
      │   damage            │ - Repair method    │
      │─────────────────────▶──────────────────▶│
      │                     │                    │
      │                     │                    │ Photos:
      │                     │                    │ - Overview (4 ext)
      │                     │                    │ - Each room (wide)
      │                     │                    │ - Each damage (close)
      │                     │                    │ - Measurements
      │                     │                    │ - Labels/tags
      │                     │                    │ 
      │                     │                    │ Moisture readings:
      │                     │                    │ - Moisture meter
      │                     │                    │ - Thermal imaging
      │                     │                    │ - Humidity readings
```

---

## 10. Property Estimation Platforms

### 10.1 Platform Comparison

| Feature | Xactimate | Symbility (CoreLogic) | XactAnalysis |
|---|---|---|---|
| Market Share | ~80% (dominant) | ~15% | Companion to Xactimate |
| Pricing Data | Xactware price lists | CoreLogic data | Xactware |
| Sketch Tool | Sketch (built-in) | Sketch tool | N/A |
| Mobile | Xactimate Mobile | Mobile app | N/A |
| AI Features | AI-assisted estimating | ClaimXperience | N/A |
| Data Format | ESX (proprietary), XML | XML, JSON | ESX/XML |
| Integration | API, file exchange | API, file exchange | API |
| Training | Extensive certification | Moderate | N/A |
| Deployment | Desktop + Cloud | Cloud-primary | Cloud |
| Carrier Adoption | Universal | Growing | Carrier-side review |

---

## 11. Xactimate Deep Dive

### 11.1 Xactimate Architecture

```
  XACTIMATE PLATFORM ARCHITECTURE
  ═══════════════════════════════

  ┌──────────────────────────────────────────────────────────────┐
  │                    XACTIMATE ECOSYSTEM                        │
  │                                                               │
  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
  │  │ Xactimate    │  │ Xactimate    │  │ XactAnalysis │      │
  │  │ Desktop      │  │ Online       │  │ (Review)     │      │
  │  │ (Appraiser)  │  │ (Browser)    │  │ (Carrier)    │      │
  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
  │         │                  │                  │              │
  │         └──────────────────┼──────────────────┘              │
  │                            │                                 │
  │  ┌─────────────────────────▼─────────────────────────────┐  │
  │  │              XACTWARE CLOUD SERVICES                   │  │
  │  │                                                        │  │
  │  │  ┌────────────────┐  ┌────────────────┐              │  │
  │  │  │ Price Lists    │  │ Sketch Engine  │              │  │
  │  │  │ (monthly       │  │ (measurements, │              │  │
  │  │  │  updated)      │  │  floor plans)  │              │  │
  │  │  └────────────────┘  └────────────────┘              │  │
  │  │  ┌────────────────┐  ┌────────────────┐              │  │
  │  │  │ Macros /       │  │ Integration    │              │  │
  │  │  │ Templates      │  │ APIs           │              │  │
  │  │  └────────────────┘  └────────────────┘              │  │
  │  └────────────────────────────────────────────────────────┘  │
  └──────────────────────────────────────────────────────────────┘

  Price List Components:
  ┌──────────────────────────────────────────────────────────┐
  │ Category          │ Examples                             │
  │───────────────────│──────────────────────────────────────│
  │ Roofing (RFG)     │ Shingles, underlayment, flashing   │
  │ Siding (SDG)      │ Vinyl, wood, fiber cement           │
  │ Drywall (DRW)     │ Hang, tape, finish, texture        │
  │ Painting (PNT)    │ Interior/exterior, prep, prime     │
  │ Flooring (FLR)    │ Carpet, tile, hardwood, laminate   │
  │ Plumbing (PLB)    │ Fixtures, piping, valves           │
  │ Electrical (ELC)  │ Wiring, outlets, fixtures          │
  │ HVAC (HVC)        │ Units, ductwork, registers         │
  │ Cabinetry (CAB)   │ Kitchen, bath, vanities            │
  │ Appliances (APL)  │ All household appliances           │
  │ Cleanup (CLN)     │ Demo, haul, clean                  │
  │ General (GNL)     │ Permits, overhead, supervision     │
  └──────────────────────────────────────────────────────────┘
```

### 11.2 Xactimate Estimate Line Item Example

```
  SAMPLE XACTIMATE ESTIMATE (Partial - Kitchen Water Damage)
  ═══════════════════════════════════════════════════════════

  ROOM: Kitchen (12' x 14' = 168 SF)
  ┌────────────────────────────────────────────────────────────────────┐
  │ Line │ Category │ Description                  │ Qty  │ Unit │ Total│
  │──────│──────────│──────────────────────────────│──────│──────│──────│
  │ 1    │ CLN      │ Contents manipulation -      │ 168  │ SF   │$504  │
  │      │          │ move out/reset (kitchen)     │      │      │      │
  │ 2    │ DRW      │ Remove drywall - walls       │ 192  │ SF   │$154  │
  │      │          │ (4' flood cut)               │      │      │      │
  │ 3    │ CLN      │ Haul debris - drywall        │ 1    │ EA   │$225  │
  │ 4    │ DRW      │ Drywall - hung, taped,       │ 192  │ SF   │$538  │
  │      │          │ ready for paint              │      │      │      │
  │ 5    │ PNT      │ Seal/prime walls (moisture   │ 192  │ SF   │$154  │
  │      │          │ barrier)                     │      │      │      │
  │ 6    │ PNT      │ Paint walls - 2 coats        │ 540  │ SF   │$432  │
  │      │          │ (entire room for color match)│      │      │      │
  │ 7    │ FLR      │ Remove vinyl floor           │ 168  │ SF   │$118  │
  │ 8    │ FLR      │ Install luxury vinyl plank   │ 168  │ SF   │$1,260│
  │      │          │ (like kind & quality)        │      │      │      │
  │ 9    │ CAB      │ Remove base cabinets -       │ 16   │ LF   │$288  │
  │      │          │ standard grade               │      │      │      │
  │ 10   │ CAB      │ Replace base cabinets -      │ 16   │ LF   │$4,800│
  │      │          │ standard oak                 │      │      │      │
  │ 11   │ PLB      │ Reconnect plumbing -         │ 1    │ EA   │$185  │
  │      │          │ kitchen sink                 │      │      │      │
  │ 12   │ ELC      │ Reconnect electrical -       │ 4    │ EA   │$340  │
  │      │          │ outlets (GFCI)               │      │      │      │
  │ 13   │ APL      │ Replace dishwasher -         │ 1    │ EA   │$650  │
  │      │          │ standard grade               │      │      │      │
  │──────│──────────│──────────────────────────────│──────│──────│──────│
  │      │          │ ROOM SUBTOTAL                │      │      │$9,648│
  │      │          │ O&P (20%)                    │      │      │$1,930│
  │      │          │ ROOM TOTAL                   │      │      │$11,578│
  └────────────────────────────────────────────────────────────────────┘

  ESTIMATE SUMMARY:
  ┌──────────────────────────────────────────────────────────┐
  │ Kitchen:                              $11,578           │
  │ Hallway:                              $3,245            │
  │ Living Room:                          $6,890            │
  │ Emergency Services (Water Extraction): $2,800           │
  │ Mold Prevention Treatment:            $1,500            │
  │                                       ──────           │
  │ GROSS TOTAL:                          $26,013           │
  │ Sales Tax:                            $1,561            │
  │ TOTAL:                                $27,574           │
  │ Deductible:                           -$2,500           │
  │ NET PAYABLE:                          $25,074           │
  │                                                         │
  │ RCV:                                  $27,574           │
  │ Depreciation (recoverable):           -$4,890           │
  │ ACV:                                  $22,684           │
  │ ACV - Deductible:                     $20,184           │
  │                                                         │
  │ Initial Payment (ACV - deductible):   $20,184           │
  │ Holdback (recoverable depreciation):  $4,890            │
  └──────────────────────────────────────────────────────────┘
```

---

## 12. Contents / Personal Property Inventory

### 12.1 Contents Claim Processing

```
  CONTENTS INVENTORY PROCESS
  ══════════════════════════

  Notification    Inventory      Valuation      Settlement
  ────────────    ─────────      ─────────      ──────────
      │               │              │               │
      │ Provide       │              │               │
      │ inventory     │              │               │
      │ form to       │              │               │
      │ insured       │              │               │
      │──────────────▶│              │               │
      │               │              │               │
      │               │ Insured      │               │
      │               │ documents:   │               │
      │               │ - Item desc  │               │
      │               │ - Qty        │               │
      │               │ - Purchase   │               │
      │               │   date       │               │
      │               │ - Purchase   │               │
      │               │   price      │               │
      │               │ - Room       │               │
      │               │ - Proof of   │               │
      │               │   ownership  │               │
      │               │──────────────▶               │
      │               │              │               │
      │               │              │ For each item:│
      │               │              │ - Research RCV│
      │               │              │ - Apply dep   │
      │               │              │ - Determine   │
      │               │              │   ACV         │
      │               │              │──────────────▶│
      │               │              │               │
      │               │              │               │ Pay ACV
      │               │              │               │ less ded
      │               │              │               │
      │               │              │               │ After
      │               │              │               │ replacement:
      │               │              │               │ Pay recov.
      │               │              │               │ depreciation
```

### 12.2 Contents Inventory Data Model

```json
{
  "ContentsInventory": {
    "claimNumber": "CLM-2025-00002345",
    "inventoryId": "INV-2025-00001234",
    "submittedBy": "insured",
    "submittedDate": "2025-03-20",
    "totalItems": 47,
    "items": [
      {
        "lineNumber": 1,
        "room": "LIVING_ROOM",
        "description": "Samsung 65\" 4K QLED TV",
        "category": "ELECTRONICS",
        "quantity": 1,
        "purchaseDate": "2023-06-15",
        "purchasePrice": 1299.99,
        "proofOfOwnership": "RECEIPT",
        "replacementCostValue": 1199.99,
        "usefulLife": 7,
        "age": 1.75,
        "depreciationRate": 14.3,
        "depreciationAmount": 299.93,
        "actualCashValue": 900.06,
        "itemStatus": "APPROVED",
        "adjustorNotes": "Current model comparable; price verified on Samsung.com"
      },
      {
        "lineNumber": 2,
        "room": "LIVING_ROOM",
        "description": "Leather sectional sofa",
        "category": "FURNITURE",
        "quantity": 1,
        "purchaseDate": "2021-01-10",
        "purchasePrice": 3500.00,
        "proofOfOwnership": "CREDIT_CARD_STATEMENT",
        "replacementCostValue": 3800.00,
        "usefulLife": 12,
        "age": 4.17,
        "depreciationRate": 8.3,
        "depreciationAmount": 1319.26,
        "actualCashValue": 2480.74,
        "itemStatus": "APPROVED",
        "adjustorNotes": "Like kind leather sectional priced at Ashley Furniture"
      }
    ],
    "summary": {
      "totalRCV": 87500.00,
      "totalDepreciation": 23400.00,
      "totalACV": 64100.00,
      "deductible": 2500.00,
      "initialPayment": 61600.00,
      "recoverableDepreciation": 23400.00,
      "sublimitApplied": [
        { "category": "JEWELRY", "limit": 1500.00, "claimedAmount": 4500.00, "paid": 1500.00 }
      ]
    }
  }
}
```

---

## 13. Water Damage Claims

### 13.1 Water Damage Categories and Classes

```
  IICRC WATER DAMAGE CLASSIFICATION
  ═══════════════════════════════════

  WATER CATEGORIES (Source Contamination):
  ┌──────────────────────────────────────────────────────────┐
  │ Category 1: CLEAN WATER                                  │
  │ • Broken water supply line                               │
  │ • Tub/sink overflow (no contaminants)                    │
  │ • Appliance malfunction (supply line)                    │
  │ • Melting ice/snow                                       │
  │ • Rainwater (direct entry)                               │
  │                                                          │
  │ Category 2: GRAY WATER                                   │
  │ • Washing machine overflow                               │
  │ • Dishwasher overflow                                    │
  │ • Toilet overflow (urine, no feces)                      │
  │ • Sump pump failure                                      │
  │ • Water bed leak (with additives)                        │
  │ • Aquarium leak                                          │
  │ Note: Cat 1 can become Cat 2 after 48-72 hours          │
  │                                                          │
  │ Category 3: BLACK WATER                                  │
  │ • Sewage backup                                          │
  │ • Toilet overflow (with feces)                           │
  │ • Rising floodwater (ground surface water)               │
  │ • River/stream overflow                                  │
  │ • Wind-driven rain through damaged structure             │
  │ Note: Cat 2 can become Cat 3 after 48-72 hours          │
  └──────────────────────────────────────────────────────────┘

  WATER CLASSES (Extent of Saturation):
  ┌──────────────────────────────────────────────────────────┐
  │ Class 1: LEAST AMOUNT                                    │
  │ • Least amount of water, absorption, and evaporation     │
  │ • Affects only part of a room                            │
  │ • Carpet and cushion may be wet, but not entire room     │
  │                                                          │
  │ Class 2: SIGNIFICANT AMOUNT                              │
  │ • Entire room of carpet and cushion                      │
  │ • Water has wicked up walls < 24 inches                  │
  │ • Structural saturation moderate                         │
  │                                                          │
  │ Class 3: GREATEST AMOUNT                                 │
  │ • Water from overhead (ceiling, walls saturated)         │
  │ • Carpet, cushion, and subfloor saturated                │
  │ • Walls saturated above 24 inches                        │
  │                                                          │
  │ Class 4: SPECIALTY DRYING                                │
  │ • Saturated materials with very low porosity             │
  │ • Hardwood floors, plaster, concrete, stone              │
  │ • Requires low specific humidity (desiccant drying)      │
  └──────────────────────────────────────────────────────────┘
```

### 13.2 Water Mitigation Process

```
  WATER DAMAGE MITIGATION TIMELINE
  ═════════════════════════════════

  Hour 0:    Water event occurs
  Hour 0-1:  Emergency water extraction
  Hour 1-4:  Setup drying equipment
             - Dehumidifiers (LGR type)
             - Air movers
             - Moisture monitoring equipment
  Day 1:     Initial moisture readings documented
  Day 1-3:   Monitor and adjust equipment
             - Daily moisture readings
             - Humidity readings
             - Temperature monitoring
  Day 3-5:   Evaluate drying progress
             - Adjust equipment placement
             - Category assessment (upgrading?)
  Day 5-7:   Target drying completion (most cases)
             - Final moisture readings
             - Document to dry standard
  Day 7+:    Complex drying (Class 4, large loss)

  DRYING LOG DATA POINTS:
  ┌──────────────────────────────────────────────────────────┐
  │ Date/Time │ Location │ Material │ Moisture% │ Target% │
  │───────────│──────────│──────────│───────────│─────────│
  │ 03/16 0800│ Kitchen  │ Subfloor │ 45%       │ < 15%   │
  │ 03/16 0800│ Kitchen  │ Drywall  │ 38%       │ < 12%   │
  │ 03/16 0800│ Kitchen  │ Cabinet  │ 42%       │ < 15%   │
  │ 03/17 0800│ Kitchen  │ Subfloor │ 32%       │ < 15%   │
  │ 03/17 0800│ Kitchen  │ Drywall  │ 24%       │ < 12%   │
  │ 03/17 0800│ Kitchen  │ Cabinet  │ 28%       │ < 15%   │
  │ 03/18 0800│ Kitchen  │ Subfloor │ 20%       │ < 15%   │
  │ 03/18 0800│ Kitchen  │ Drywall  │ 14%       │ < 12%   │
  │ 03/19 0800│ Kitchen  │ Subfloor │ 14%       │ < 15%   │ ✓
  │ 03/19 0800│ Kitchen  │ Drywall  │ 11%       │ < 12%   │ ✓
  │ 03/19 0800│ Kitchen  │ Cabinet  │ 14%       │ < 15%   │ ✓
  └──────────────────────────────────────────────────────────┘
```

---

## 14. Fire Damage Claims

### 14.1 Fire Claim Investigation Process

```
  FIRE CLAIM LIFECYCLE
  ═══════════════════

  Notification    Investigation    Coverage       Estimate &
  & Emergency     & Cause          Decision       Repair
  ────────────    ─────────────    ────────       ──────────
      │                │               │              │
      │ FNOL           │               │              │
      │ Emergency:     │               │              │
      │ - Board up     │               │              │
      │ - Tarp roof    │               │              │
      │ - Secure site  │              │              │
      │───────────────▶│               │              │
      │                │               │              │
      │                │ Origin &      │              │
      │                │ Cause:        │              │
      │                │ - Fire marshal│              │
      │                │   report      │              │
      │                │ - Private     │              │
      │                │   investigator│              │
      │                │   (if needed) │              │
      │                │ - Examine     │              │
      │                │   evidence    │              │
      │                │ - Interview   │              │
      │                │   witnesses   │              │
      │                │               │              │
      │                │ Arson check:  │              │
      │                │ - V-patterns  │              │
      │                │ - Accelerants │              │
      │                │ - Multiple    │              │
      │                │   origin pts  │              │
      │                │ - Motive      │              │
      │                │───────────────▶              │
      │                │               │              │
      │                │               │ Coverage:    │
      │                │               │ - Peril      │
      │                │               │   covered?   │
      │                │               │ - Arson      │
      │                │               │   exclusion? │
      │                │               │ - Vacancy    │
      │                │               │   exclusion? │
      │                │               │──────────────▶
      │                │               │              │
      │                │               │              │ Estimate:
      │                │               │              │ - Structure
      │                │               │              │ - Contents
      │                │               │              │ - ALE
      │                │               │              │ - Debris
      │                │               │              │   removal
      │                │               │              │ - Smoke/soot
      │                │               │              │   cleaning
```

### 14.2 Fire Damage Cost Components

| Component | Description | Typical % of Total |
|---|---|---|
| Structural repair/rebuild | Framing, drywall, roofing, etc. | 40-60% |
| Contents replacement | Personal property | 15-25% |
| Smoke and soot cleaning | Professional cleaning, ozone treatment | 5-10% |
| Debris removal | Demolition and hauling | 5-10% |
| ALE / Loss of Use | Temporary housing, meals | 10-20% |
| Ordinance or Law | Code upgrade compliance | 0-15% |
| Landscaping | Tree removal, replanting | 1-5% |
| Personal property cleaning | Dry cleaning, restoration | 2-5% |

---

## 15. Wind and Hail Claims

### 15.1 Wind/Hail Damage Assessment

```
  WIND/HAIL DAMAGE INSPECTION PROTOCOL
  ═════════════════════════════════════

  ROOF INSPECTION:
  ┌──────────────────────────────────────────────────────────┐
  │ 1. GROUND-LEVEL SURVEY                                   │
  │    • Photograph all 4 sides of structure                 │
  │    • Look for visible damage from ground                 │
  │    • Note any displaced materials                        │
  │    • Document gutter/downspout damage                    │
  │    • Check for soft metals (mailbox, AC unit, vents)     │
  │                                                          │
  │ 2. ROOF INSPECTION (ladder or drone)                     │
  │    • Walk entire roof surface (if safe)                  │
  │    • Identify hail strikes on shingles                   │
  │    • Mark hail strikes with chalk                        │
  │    • Test tab integrity (can shingle be lifted?)         │
  │    • Check for bruising (soft spots under granules)      │
  │    • Inspect flashing, vents, ridge caps                 │
  │    • Document wind creasing/lifting                      │
  │    • Count strikes per "test square" (10' × 10')        │
  │                                                          │
  │ 3. HAIL DAMAGE INDICATORS                                │
  │    • Random pattern of damage (not aligned)              │
  │    • Exposed fiberglass mat                              │
  │    • Loss of granules in impact area                     │
  │    • Soft spot / bruise when pressed                     │
  │    • Split in shingle (cracking)                         │
  │    • Dents in soft metals (gutters, vents, AC fins)      │
  │                                                          │
  │ 4. WIND DAMAGE INDICATORS                                │
  │    • Missing shingles or tabs                            │
  │    • Creased/folded shingles                             │
  │    • Lifted shingles (unsealed tabs)                     │
  │    • Exposed underlayment                                │
  │    • Damage pattern follows wind direction               │
  └──────────────────────────────────────────────────────────┘
```

### 15.2 Hail Size and Damage Correlation

| Hail Size | Diameter | Description | Typical Roof Damage |
|---|---|---|---|
| Pea | 0.25" | Very small | Minimal; may ding gutters |
| Marble | 0.50" | Small | Minor granule loss |
| Dime | 0.75" | | Moderate granule loss |
| Penny | 0.75" | | Moderate granule loss |
| Nickel | 0.88" | | Significant granule loss |
| Quarter | 1.00" | Severe weather criteria | Functional damage likely |
| Half Dollar | 1.25" | | Significant damage expected |
| Golf Ball | 1.75" | | Major damage; likely replacement |
| Tennis Ball | 2.50" | | Severe damage; full replacement |
| Baseball | 2.75" | | Catastrophic damage |
| Softball | 4.00"+ | | Total destruction |

---

## 16. Theft Claims

### 16.1 Theft Claim Investigation

| Step | Action | Purpose |
|---|---|---|
| 1 | Obtain police report | Verify theft was reported to authorities |
| 2 | Recorded statement | Document circumstances of discovery |
| 3 | Proof of ownership | Receipts, photos, appraisals, serial numbers |
| 4 | Inventory verification | Review claimed items for reasonableness |
| 5 | Prior claims check | ISO ClaimSearch for pattern |
| 6 | Financial review | Assess motive (financial stress indicators) |
| 7 | Scene inspection | Forced entry evidence, security system review |
| 8 | Neighborhood canvass | Witness statements, surveillance video |
| 9 | Valuation | Research replacement cost for each item |
| 10 | Settlement | Pay per policy terms (ACV or RCV) |

---

## 17. Additional Living Expense (ALE)

### 17.1 ALE Calculation

```
  ALE CALCULATION METHOD
  ═══════════════════════

  Principle: Pay the DIFFERENCE between normal living costs
  and costs incurred due to displacement.

  ┌──────────────────────────────────────────────────────────┐
  │ ALE Expense         │ Displaced │ Normal │ ALE Payment  │
  │─────────────────────│───────────│────────│──────────────│
  │ Housing (hotel/apt) │ $4,500/mo │ $0*    │ $4,500/mo    │
  │ Meals               │ $1,800/mo │ $800/mo│ $1,000/mo    │
  │ Laundry             │ $200/mo   │ $50/mo │ $150/mo      │
  │ Storage (contents)  │ $300/mo   │ $0     │ $300/mo      │
  │ Additional commute  │ $150/mo   │ $0     │ $150/mo      │
  │ Pet boarding        │ $400/mo   │ $0     │ $400/mo      │
  │─────────────────────│───────────│────────│──────────────│
  │ TOTAL ALE           │           │        │ $6,500/mo    │
  │                     │           │        │              │
  │ * Mortgage not offset if still being paid               │
  │   (debatable; varies by jurisdiction)                   │
  └──────────────────────────────────────────────────────────┘

  Duration: Until property is restored to habitable condition,
  OR a reasonable period for the insured to find permanent
  replacement housing (if total loss), whichever is shorter.
```

---

## 18. Mold Claims

### 18.1 Mold Coverage Analysis

```
  MOLD COVERAGE DECISION TREE
  ═══════════════════════════

  ┌─── Was there a covered water loss? ───┐
  │                                        │
  YES                                     NO
  │                                        │
  ├── Did mold result from                 ├── Is there a mold
  │   the covered water loss?              │   endorsement?
  │   │                                    │   │
  │   YES → Typically covered              │   NO → Not covered
  │   │     as resulting damage            │   │     (mold excluded)
  │   │     from covered peril             │   │
  │   │                                    │   YES → Covered per
  │   │                                    │         endorsement
  │   NO → Was it pre-existing mold?       │         limits
  │       │                                │
  │       YES → Not covered                │
  │       │     (wear and tear, maintenance)│
  │       │                                │
  │       NO → Review timeline             │
  │           (was mold addressed timely?)  │
  │                                        │
  └── Check policy mold sublimit ──────────┘
      (many policies cap mold at $5K-$25K)
```

---

## 19. Contractor Management

### 19.1 Preferred Vendor Network

```
  CONTRACTOR MANAGEMENT FRAMEWORK
  ═══════════════════════════════

  VENDOR TIERS:
  ┌──────────────────────────────────────────────────────────┐
  │ TIER 1: PREFERRED / DRP CONTRACTORS                      │
  │ • Pre-negotiated pricing                                 │
  │ • Background checked and insured                         │
  │ • Performance metrics tracked                            │
  │ • Guaranteed workmanship                                 │
  │ • Volume commitments                                     │
  │ • Carrier-managed quality program                        │
  │                                                          │
  │ TIER 2: APPROVED CONTRACTORS                             │
  │ • Vetted but no volume commitment                        │
  │ • Standard pricing                                       │
  │ • Background checked                                     │
  │ • Used for overflow or specialty work                    │
  │                                                          │
  │ TIER 3: INSURED'S CHOICE                                 │
  │ • Contractor selected by insured                         │
  │ • Must provide valid license and insurance               │
  │ • Carrier pays per estimate (may negotiate)              │
  │ • No guaranteed workmanship from carrier                 │
  └──────────────────────────────────────────────────────────┘
```

---

## 20. Managed Repair Programs

### 20.1 Program Structure

| Component | Description | Benefit |
|---|---|---|
| Contractor network | Pre-qualified, pre-negotiated contractors | Cost savings 10-20% |
| Direct assignment | Claims system assigns contractor directly | Faster cycle time |
| Guaranteed repairs | Carrier guarantees workmanship | Customer satisfaction |
| Materials pricing | Pre-negotiated material pricing | Cost consistency |
| Quality inspections | Random and targeted quality reviews | Quality assurance |
| Customer satisfaction | Post-repair survey | Performance tracking |
| Payment integration | Direct-pay to contractor | Administrative efficiency |

---

## 21. Public Adjuster Interaction

### 21.1 Public Adjuster Protocols

```
  PUBLIC ADJUSTER HANDLING PROTOCOL
  ═════════════════════════════════

  PA Engagement          Scope Agreement      Estimate         Settlement
  ─────────────          ───────────────      ────────         ──────────
      │                       │                  │                │
      │ PA retained by        │                  │                │
      │ insured (letter       │                  │                │
      │ of representation)    │                  │                │
      │──────────────────────▶│                  │                │
      │                       │                  │                │
      │ Carrier acknowledges: │                  │                │
      │ - Verify PA license   │                  │                │
      │ - Direct comms to PA  │                  │                │
      │ - Document PA fee     │                  │                │
      │   agreement (public   │                  │                │
      │   record in some      │                  │                │
      │   states)             │                  │                │
      │                       │                  │                │
      │ Joint inspection:     │                  │                │
      │ - Carrier adjuster    │                  │                │
      │ - Public adjuster     │                  │                │
      │ - Agree on scope      │                  │                │
      │ - Document damages    │                  │                │
      │───────────────────────▶                  │                │
      │                       │                  │                │
      │                       │ PA submits       │                │
      │                       │ estimate         │                │
      │                       │ (Xactimate)      │                │
      │                       │──────────────────▶                │
      │                       │                  │                │
      │                       │ Carrier reviews: │                │
      │                       │ - Line-by-line   │                │
      │                       │ - Identify       │                │
      │                       │   differences    │                │
      │                       │ - Negotiate      │                │
      │                       │──────────────────▶────────────────▶
      │                       │                  │                │
      │                       │                  │   If cannot    │
      │                       │                  │   agree:       │
      │                       │                  │   → Appraisal  │
      │                       │                  │     process    │

  PA Fees (varies by state):
  Typically 10-15% of settlement (non-CAT)
  Some states: 20% for CAT claims
  Some states cap PA fees (FL: 20% for CAT, 10% non-CAT re-opened)
```

---

## 22. Mortgage Company Interests

### 22.1 Mortgagee Claim Handling

```
  MORTGAGE COMPANY INVOLVEMENT IN CLAIMS
  ═══════════════════════════════════════

  SMALL CLAIMS (typically < $20,000-$40,000):
  ┌──────────────────────────────────────────────────────────┐
  │ Payment made jointly to: Insured AND Mortgagee           │
  │ Mortgagee may endorse check directly to insured          │
  │ (Some carriers have agreements for direct-pay below      │
  │  threshold)                                              │
  └──────────────────────────────────────────────────────────┘

  LARGE CLAIMS (> threshold):
  ┌──────────────────────────────────────────────────────────┐
  │ Payment made jointly to: Insured AND Mortgagee           │
  │ Mortgagee may:                                           │
  │ • Hold funds in escrow                                   │
  │ • Disburse in stages as repairs progress:                │
  │   - 1/3 at start of work                                │
  │   - 1/3 at 50% completion                               │
  │   - 1/3 at completion (after inspection)                 │
  │ • Require inspection at each disbursement stage          │
  │ • Apply funds to mortgage payoff if property abandoned   │
  └──────────────────────────────────────────────────────────┘

  TOTAL LOSS:
  ┌──────────────────────────────────────────────────────────┐
  │ Payment made to Mortgagee FIRST (up to mortgage balance) │
  │ Remainder (equity) paid to Insured                       │
  │                                                          │
  │ Example:                                                 │
  │ Dwelling Coverage A: $400,000                            │
  │ Mortgage Balance: $275,000                               │
  │ Settlement: $400,000                                     │
  │ → Mortgagee receives: $275,000                           │
  │ → Insured receives: $125,000                             │
  └──────────────────────────────────────────────────────────┘
```

---

## 23. Property Claims Data Model

### 23.1 Property Claims ERD

```
  PROPERTY CLAIMS DATA MODEL
  ══════════════════════════

  ┌──────────────┐        ┌──────────────┐
  │    CLAIM     │ 1    1 │   PROPERTY   │
  │──────────────│────────│──────────────│
  │ claimId (PK) │        │ propertyId   │
  │ claimNumber  │        │ claimId (FK) │
  │ status       │        │ address      │
  │ lossDate     │        │ propertyType │
  │ perilType    │        │ constructType│
  │ catCode      │        │ yearBuilt    │
  │ totalIncurred│        │ sqFootage    │
  └──────┬───────┘        │ stories      │
         │                │ roofType     │
         │ 1:N            │ mortgagee    │
         │                └──────┬───────┘
  ┌──────▼───────┐               │
  │  STRUCTURE   │               │ 1:N
  │──────────────│               │
  │ structureId  │        ┌──────▼───────┐
  │ propertyId   │        │    ROOM      │
  │ structureType│        │──────────────│
  │ (dwelling,   │        │ roomId (PK)  │
  │  garage, etc)│        │ propertyId   │
  │ covAmount    │        │ roomName     │
  │ deductible   │        │ floor        │
  └──────────────┘        │ length       │
                          │ width        │
                          │ height       │
                          │ sqFootage    │
                          └──────┬───────┘
                                 │
                                 │ 1:N
                          ┌──────▼───────┐
                          │ DAMAGE_AREA  │
                          │──────────────│
                          │ damageAreaId │
                          │ roomId (FK)  │
                          │ damageType   │
                          │ damageCause  │
                          │ severity     │
                          │ measurements │
                          │ estimateRef  │
                          └──────────────┘

  ┌──────────────┐        ┌──────────────┐
  │  ESTIMATE    │        │CONTENTS_ITEM │
  │──────────────│        │──────────────│
  │ estimateId   │        │ itemId (PK)  │
  │ claimId (FK) │        │ claimId (FK) │
  │ estimateType │        │ room         │
  │ vendor       │        │ description  │
  │ estimateDate │        │ quantity     │
  │ structureAmt │        │ purchaseDate │
  │ contentsAmt  │        │ purchasePrice│
  │ aleAmt       │        │ rcv          │
  │ debrisRemoval│        │ depreciation │
  │ grossTotal   │        │ acv          │
  │ depreciation │        │ status       │
  │ acvTotal     │        └──────────────┘
  │ netPayable   │
  └──────────────┘        ┌──────────────┐
                          │     ALE      │
  ┌──────────────┐        │──────────────│
  │ CONTRACTOR   │        │ aleId (PK)   │
  │──────────────│        │ claimId (FK) │
  │ contractorId │        │ expenseType  │
  │ companyName  │        │ vendor       │
  │ licenseNumber│        │ amount       │
  │ insuranceCert│        │ dateIncurred │
  │ tier         │        │ normalCost   │
  │ rating       │        │ aleCovered   │
  │ specialties  │        │ status       │
  └──────────────┘        └──────────────┘
```

---

## 24. Catastrophe Property Claims

### 24.1 CAT Claims Operations

```
  CATASTROPHE CLAIMS OPERATION
  ═══════════════════════════

  PRE-EVENT (Hurricane approaching):
  ┌──────────────────────────────────────────────────────────┐
  │ T-72h: Activate CAT plan                                 │
  │ T-48h: Deploy CAT adjusters to staging area              │
  │ T-24h: Pre-position supplies, equipment, mobile units    │
  │ T-0:   Event makes landfall                              │
  └──────────────────────────────────────────────────────────┘

  POST-EVENT:
  ┌──────────────────────────────────────────────────────────┐
  │ T+0-24h:  Assess damage zone; setup command center       │
  │ T+24-72h: Begin FNOL intake (10x-50x normal volume)     │
  │ T+3-7d:   Begin field inspections (triage by severity)   │
  │ T+7-14d:  Issue emergency advance payments               │
  │ T+14-30d: Full estimate writing and settlement           │
  │ T+30-90d: Supplements, rebuilds, ALE management          │
  │ T+90d+:   Long-tail claims, litigation, regulatory       │
  └──────────────────────────────────────────────────────────┘

  CAT STAFFING MODEL:
  ┌──────────────────────────────────────────────────────────┐
  │ Resource Type        │ Normal  │ CAT Mode               │
  │──────────────────────│─────────│────────────────────────│
  │ Staff adjusters      │ 50      │ 50 (redeployed)       │
  │ IA (Independent adj) │ 20      │ 200-500               │
  │ Desk adjusters       │ 30      │ 100 (temp staff)      │
  │ CAT team managers    │ 0       │ 20                    │
  │ Vendor coordinators  │ 5       │ 30                    │
  │ Customer service     │ 20      │ 100 (overflow center) │
  └──────────────────────────────────────────────────────────┘
```

---

## 25. Commercial Property Specifics

### 25.1 Business Income Coverage

```
  BUSINESS INCOME (BI) CLAIM CALCULATION
  ═══════════════════════════════════════

  FORMULA:
  Business Income Loss = Net Income Lost + Continuing Expenses

  Where:
  Net Income Lost = (Revenue Lost) - (Variable Expenses Saved)

  EXAMPLE:
  ┌──────────────────────────────────────────────────────────┐
  │ Restaurant closed 60 days due to fire damage             │
  │                                                          │
  │ Monthly Revenue (pre-loss):         $150,000             │
  │ Monthly Fixed Expenses:             $80,000              │
  │  (rent, insurance, loan payments, salaries)              │
  │ Monthly Variable Expenses:          $50,000              │
  │  (food/supplies, hourly labor, utilities variable)       │
  │ Monthly Net Income:                 $20,000              │
  │                                                          │
  │ Period of Restoration: 60 days (2 months)                │
  │                                                          │
  │ Revenue Lost (2 months):            $300,000             │
  │ Variable Expenses Saved (2 months): -$100,000            │
  │ Net Loss of Income (2 months):      $40,000              │
  │ Continuing Fixed Expenses (2 mo):   $160,000             │
  │                                     ────────             │
  │ Total Business Income Loss:         $200,000             │
  │                                                          │
  │ EXTRA EXPENSE (to minimize BI loss):                     │
  │ Temporary location rent:            $15,000              │
  │ Equipment rental:                   $8,000               │
  │ Moving/setup costs:                 $5,000               │
  │ Total Extra Expense:                $28,000              │
  │                                                          │
  │ TOTAL BI + EE CLAIM:               $228,000             │
  └──────────────────────────────────────────────────────────┘
```

### 25.2 Builders Risk Claims

| Coverage Aspect | Description |
|---|---|
| What's Covered | Building under construction + materials on site + in transit |
| Valuation | Completed value or reporting form |
| Perils | Typically open peril (special form) |
| Common Claims | Fire during construction, theft of materials, wind damage, water damage |
| Unique Issues | Soft costs (architect, permits, financing), delay in completion |
| Named Insured | Owner, general contractor, or both |
| Duration | Until construction complete or occupancy, whichever first |

### 25.3 Equipment Breakdown Claims

| Component | Description |
|---|---|
| Coverage Trigger | Sudden and accidental breakdown of covered equipment |
| Covered Equipment | Boilers, pressure vessels, HVAC, electrical, mechanical, electronics, computers |
| Not Covered | Wear and tear, gradual deterioration, maintenance failure |
| Unique Feature | Spoilage coverage (food, pharmaceuticals lost due to equipment failure) |
| Inspection Services | Regular equipment inspection as part of coverage |
| Business Income | Often includes BI for equipment breakdown |

---

## 26. Inland Marine Claims

### 26.1 Inland Marine Coverage Types

| Coverage Form | Description | Common Claims |
|---|---|---|
| Builders Risk | Construction projects | Fire, theft, wind during build |
| Contractors Equipment | Mobile equipment, tools | Theft, damage on jobsite |
| Motor Truck Cargo | Goods in transit | Damage during transport |
| Installation Floater | Equipment being installed | Damage during installation |
| EDP/Technology | Computer equipment | Physical damage, power surge |
| Fine Arts | Artwork, collectibles | Breakage, theft, transit damage |
| Jewelers Block | Jewelry inventory | Theft, mysterious disappearance |
| Signs | Business signs | Wind, vandalism, vehicle strike |
| Accounts Receivable | Lost/damaged A/R records | Fire destroying records |
| Valuable Papers | Important documents | Fire, flood destroying records |

---

## 27. Property Claims Performance Metrics

### 27.1 Key Performance Indicators

| Metric | Definition | Target | Industry Benchmark |
|---|---|---|---|
| Cycle Time (Non-CAT) | FNOL to final payment | < 30 days | 25-45 days |
| Cycle Time (CAT) | FNOL to final payment | < 60 days | 45-90 days |
| Emergency Response | Time to first contact | < 24 hours | 24-48 hours |
| Inspection Turnaround | Assignment to inspection complete | < 5 days | 3-7 days |
| Customer Satisfaction | NPS or CSAT | > 80% | 70-85% |
| Estimate Accuracy | Within 10% of final | > 70% | 60-75% |
| Supplement Rate | % requiring supplement | < 25% | 20-35% |
| Average Severity | Average paid per claim | Trending | $12,000-$18,000 |
| DRP Utilization | % using managed repair | > 40% | 30-50% |
| Recoverable Dep Collection | % of holdback collected by insured | 55-65% | 50-65% |
| ALE Duration | Average days on ALE | < 90 days | 60-120 days |
| Contents Settlement Time | FNOL to contents payment | < 45 days | 30-60 days |
| Loss Ratio | Incurred / Earned premium | < 60% | 55-70% |
| Litigation Rate | % entering litigation | < 5% | 3-8% |
| Public Adjuster Rate | % with PA involvement | < 15% | 10-25% (varies) |
| Fraud Referral Rate | % referred to SIU | 5-10% | 5-12% |

### 27.2 Property Claims Dashboard

```
  PROPERTY CLAIMS DASHBOARD
  ═════════════════════════

  ┌─────────────────────────────────────────────────────────────┐
  │  CURRENT MONTH: March 2025                                   │
  │                                                              │
  │  VOLUME              CYCLE TIME           FINANCIAL          │
  │  ┌─────────────┐    ┌─────────────┐     ┌─────────────┐   │
  │  │ New Claims  │    │ Non-CAT Avg │     │ Loss Ratio  │   │
  │  │ 850         │    │ 28 days     │     │ 58.2%       │   │
  │  │ [↑ 12% MoM]│    │ [↓ 2 days]  │     │ [↓ 1.5 pts] │   │
  │  └─────────────┘    └─────────────┘     └─────────────┘   │
  │                                                              │
  │  PERIL BREAKDOWN:                                            │
  │  ┌────────────────────────────────────────────────────────┐ │
  │  │ Water Damage:    35%  ████████████████████             │ │
  │  │ Wind/Hail:       25%  ██████████████                   │ │
  │  │ Fire:            15%  ████████                         │ │
  │  │ Theft:           10%  █████                            │ │
  │  │ Liability (E/F): 8%   ████                             │ │
  │  │ Other:           7%   ███                              │ │
  │  └────────────────────────────────────────────────────────┘ │
  └─────────────────────────────────────────────────────────────┘
```

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 13 (Auto Claims), Article 15 (Liability Claims), and Article 11 (Integration Patterns).*
