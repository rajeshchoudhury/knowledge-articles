# PnC Claims Domain: Complete Overview & Taxonomy

> **Audience:** Solutions Architects designing and building Property & Casualty claims systems.
> **Version:** 1.0 | **Last Updated:** 2026-04-16

---

## Table of Contents

1. [What Is Property & Casualty Insurance](#1-what-is-property--casualty-insurance)
2. [Lines of Business — Comprehensive Catalog](#2-lines-of-business--comprehensive-catalog)
3. [Complete Taxonomy of Claim Types by Line of Business](#3-complete-taxonomy-of-claim-types-by-line-of-business)
4. [Key Stakeholders & Their Roles](#4-key-stakeholders--their-roles)
5. [Insurance Policy Structure Relevant to Claims](#5-insurance-policy-structure-relevant-to-claims)
6. [Coverage Types & How They Map to Claims](#6-coverage-types--how-they-map-to-claims)
7. [Deductibles, Limits, Sublimits & Self-Insured Retentions](#7-deductibles-limits-sublimits--self-insured-retentions)
8. [Key Industry Bodies](#8-key-industry-bodies)
9. [Domain Entity Relationship Diagram](#9-domain-entity-relationship-diagram)
10. [Complete Data Dictionary of Core Claims Entities](#10-complete-data-dictionary-of-core-claims-entities)
11. [Glossary of 100+ PnC Claims Terms](#11-glossary-of-100-pnc-claims-terms)
12. [Architectural Considerations for Claims Systems](#12-architectural-considerations-for-claims-systems)

---

## 1. What Is Property & Casualty Insurance

### 1.1 Definition

Property and Casualty (P&C or PnC) insurance is a broad category of insurance that covers two fundamental risk domains:

- **Property Insurance** — protects against financial loss caused by damage to, destruction of, or loss of physical assets (real property, personal property, business property).
- **Casualty Insurance** — protects against financial loss caused by legal liability arising from injuries or damage to other people or their property.

P&C insurance is also referred to as **General Insurance** in many international markets. It encompasses every insurance product that is *not* life insurance, health insurance, or annuities.

### 1.2 Market Context

| Metric | Value (US Market, Approximate) |
|---|---|
| Total DWP (Direct Written Premium) | ~$800B+ annually |
| Number of P&C Carriers | ~2,500+ |
| Number of Claims Annually | ~40-50 million |
| Largest Line by Premium | Private Passenger Auto (~$300B) |
| Combined Ratio Industry Average | ~98-102% |
| Loss Ratio Average | ~65-72% |
| Expense Ratio Average | ~26-30% |

### 1.3 The Role of Claims in P&C

Claims is the **fulfillment function** of insurance. It is where the insurer delivers on its promise. Claims represents:

- **60-80%** of total insurer costs (loss payments + loss adjustment expenses)
- The primary touchpoint that determines policyholder satisfaction and retention
- A core source of data for underwriting, pricing, and actuarial functions
- The domain where fraud detection, litigation management, and regulatory compliance converge

### 1.4 Claims System as an Enterprise System

A modern claims system is one of the most complex enterprise applications in any industry. It must:

- Handle hundreds of distinct workflows varying by line of business, jurisdiction, and claim type
- Integrate with 50+ external systems and data providers
- Enforce thousands of business rules that change by state, coverage, and carrier
- Maintain regulatory compliance across all 50 US states plus territories
- Process billions of dollars in financial transactions
- Support real-time and batch operations simultaneously
- Maintain complete audit trails for litigation and regulatory examination

---

## 2. Lines of Business — Comprehensive Catalog

### 2.1 Personal Lines

Personal lines cover individual consumers and families.

#### 2.1.1 Personal Auto (Private Passenger Auto)

| Attribute | Detail |
|---|---|
| ISO Line Code | 19.1 |
| NAIC Line Code | 19.4 (Private Passenger Auto Liability), 21.1 (Private Passenger Auto Physical Damage) |
| Annual Premium (US) | ~$300B |
| Annual Claims Volume | ~20M+ |
| Typical Policy Term | 6 months or 12 months |
| Key Coverages | Bodily Injury Liability, Property Damage Liability, Collision, Comprehensive (Other-Than-Collision), Uninsured/Underinsured Motorist, PIP/No-Fault, Medical Payments |
| Rating Factors | Driver age, gender, driving record, vehicle make/model/year, territory, credit score, mileage, usage |
| Key Claim Types | Collision, Comprehensive (theft, weather, animal strikes, vandalism), Bodily Injury, Property Damage, UM/UIM, PIP, Glass, Towing |

#### 2.1.2 Homeowners

| Attribute | Detail |
|---|---|
| ISO Form Series | HO-1 (Basic), HO-2 (Broad), HO-3 (Special), HO-4 (Renters), HO-5 (Comprehensive), HO-6 (Condo), HO-8 (Modified) |
| NAIC Line Code | 4.0 (Homeowners Multi-Peril) |
| Annual Premium (US) | ~$120B |
| Key Coverages | Coverage A (Dwelling), Coverage B (Other Structures), Coverage C (Personal Property), Coverage D (Loss of Use), Coverage E (Personal Liability), Coverage F (Medical Payments to Others) |
| Key Claim Types | Fire/smoke, water damage, wind/hail, theft/burglary, liability (slip/fall), tree fall, lightning, vandalism, collapse, frozen pipes |
| Key Exclusions | Flood, earthquake, wear and tear, intentional acts, nuclear hazard, government action, neglect |

#### 2.1.3 Renters Insurance

| Attribute | Detail |
|---|---|
| ISO Form | HO-4 |
| Coverage Focus | Personal property, liability, additional living expenses |
| Claim Characteristics | Lower severity, high frequency of theft and water damage claims |
| Typical Limits | $20K-$100K personal property |

#### 2.1.4 Personal Umbrella / Excess Liability

| Attribute | Detail |
|---|---|
| Purpose | Provides excess liability coverage above auto and homeowners limits |
| Typical Limits | $1M-$10M |
| Claim Trigger | Underlying policy limits exhausted |
| Claims Handling | Follows underlying claim; adjuster monitors for excess exposure |

#### 2.1.5 Personal Inland Marine

| Attribute | Detail |
|---|---|
| Purpose | Covers scheduled personal property (jewelry, fine art, musical instruments, cameras) |
| Claim Types | Theft, accidental damage, mysterious disappearance |
| Valuation | Agreed value, replacement cost, actual cash value |

#### 2.1.6 Dwelling Fire

| Attribute | Detail |
|---|---|
| ISO Form Series | DP-1 (Basic), DP-2 (Broad), DP-3 (Special) |
| Purpose | Covers rental properties and dwellings not eligible for homeowners |
| Claim Handling | Similar to homeowners but without personal property coverage typically |

### 2.2 Commercial Lines

Commercial lines cover businesses, organizations, and commercial operations.

#### 2.2.1 Commercial Auto (Business Auto)

| Attribute | Detail |
|---|---|
| ISO Form | CA 00 01 (Business Auto Coverage Form) |
| NAIC Line Code | 19.3 (Commercial Auto Liability), 21.2 (Commercial Auto Physical Damage) |
| Covered Vehicles | Owned autos, hired autos, non-owned autos, specific scheduled autos |
| Symbol System | 1-9 covered auto designation symbols |
| Key Claim Types | At-fault collision, not-at-fault collision, cargo damage, fleet incidents, hired auto accidents |
| Complexity Factors | Multiple vehicles, driver screening, DOT compliance, cargo claims, fleet management |

#### 2.2.2 Commercial Property

| Attribute | Detail |
|---|---|
| ISO Form | CP 00 10 (Building and Personal Property Coverage Form) |
| NAIC Line Code | 5.1 (Commercial Multi-Peril) |
| Covered Property | Buildings, business personal property (BPP), property of others |
| Valuation Methods | Replacement cost, actual cash value, functional replacement cost, agreed value |
| Key Coverages | Building, BPP, Business Income (BI), Extra Expense, Builders Risk |
| Key Claim Types | Fire, windstorm, water damage, theft, electrical surge, equipment breakdown |
| Coinsurance | 80%, 90%, or 100% coinsurance clauses with penalty calculations |

#### 2.2.3 Commercial General Liability (CGL)

| Attribute | Detail |
|---|---|
| ISO Form | CG 00 01 (Occurrence), CG 00 02 (Claims-Made) |
| NAIC Line Code | 17.1 (Other Liability - Occurrence), 17.2 (Other Liability - Claims Made) |
| Coverage Parts | Coverage A (Bodily Injury and Property Damage), Coverage B (Personal and Advertising Injury), Coverage C (Medical Payments) |
| Key Claim Types | Slip/fall, product liability, completed operations, advertising injury, tenant liability |
| Trigger Issues | Occurrence vs. Claims-Made trigger, retroactive date, extended reporting period (tail) |
| Aggregate Limits | General aggregate, products/completed operations aggregate, per-occurrence limit |

#### 2.2.4 Workers' Compensation

| Attribute | Detail |
|---|---|
| Regulatory Framework | State-mandated; each state has its own Workers Comp statute |
| NAIC Line Code | 16.0 |
| Key Benefits | Medical treatment, temporary disability (TTD/TPD), permanent disability (PPD/PTD), vocational rehab, death benefits |
| Unique Characteristics | No-fault system, statutory benefits, employer is the insured but employee is the claimant |
| Key Claim Types | Lost-time claims, medical-only claims, indemnity claims, fatality claims |
| Classification | NCCI classification codes (600+ class codes) |
| Experience Rating | Experience modification rate (EMR/MOD) |
| Key Integrations | State WC boards, NCCI/state rating bureaus, medical bill review vendors, pharmacy benefit managers, nurse case managers |

#### 2.2.5 Professional Liability (Errors & Omissions)

| Attribute | Detail |
|---|---|
| Common Types | Medical malpractice, legal malpractice, architects/engineers E&O, technology E&O, insurance agents E&O |
| Trigger | Claims-made (nearly always) |
| Key Claim Types | Allegations of negligent acts, errors, or omissions in professional services |
| Defense | Duty to defend vs. duty to indemnify varies by form |
| Long-Tail Nature | Claims may be reported years after the alleged act |

#### 2.2.6 Directors & Officers (D&O) Liability

| Attribute | Detail |
|---|---|
| Coverage Parts | Side A (individual directors/officers when corp cannot indemnify), Side B (corporate reimbursement), Side C (entity coverage for securities claims) |
| Key Claims | Shareholder derivative suits, SEC investigations, breach of fiduciary duty, mismanagement |
| Claims-Made | Yes, with retroactive dates |

#### 2.2.7 Employment Practices Liability (EPLI)

| Attribute | Detail |
|---|---|
| Covered Claims | Wrongful termination, discrimination, sexual harassment, retaliation, failure to promote, wage/hour disputes |
| Trigger | Claims-made |
| Typical Deductible | $5K-$100K+ |

#### 2.2.8 Commercial Umbrella / Excess Liability

| Attribute | Detail |
|---|---|
| Purpose | Provides excess limits above CGL, commercial auto, employers liability |
| Following Form | Follows terms of underlying policies |
| Drop-Down | May drop down if underlying aggregate is exhausted |
| Claims Handling | Monitor underlying claims; engage when limits approach or are breached |

#### 2.2.9 Ocean Marine

| Attribute | Detail |
|---|---|
| Coverage Types | Hull (vessel), Cargo, Protection & Indemnity (P&I), Freight |
| Key Claims | Vessel damage, cargo loss/damage, collision liability, pollution liability, crew injury |
| Regulatory | Admiralty law, Jones Act, Longshore and Harbor Workers' Compensation Act |
| Unique Aspects | General average, salvage, sue and labor |

#### 2.2.10 Inland Marine

| Attribute | Detail |
|---|---|
| Coverage Types | Contractors equipment, builders risk, transportation/cargo, electronic data processing, installation floater, bailee coverage |
| Key Claims | Equipment theft, transit damage, installation losses |
| Rating | Inland Marine is largely independently filed (non-ISO) |

#### 2.2.11 Aviation Insurance

| Attribute | Detail |
|---|---|
| Coverage Types | Hull (aircraft physical damage), liability (passengers, third party), hangarkeepers, products liability (manufacturers) |
| Key Claims | Accidents, ground damage, product defect, passenger injury |
| Regulatory | FAA, NTSB investigation requirements |

#### 2.2.12 Surety Bonds

| Attribute | Detail |
|---|---|
| Nature | Three-party agreement: Principal, Obligee, Surety |
| Types | Contract surety (bid bonds, performance bonds, payment bonds), commercial surety (license bonds, permit bonds, court bonds, fiduciary bonds) |
| Claim Process | Obligee makes claim on bond; surety investigates; surety has right of recovery against principal |
| Key Difference | Not traditional "insurance" — surety expects zero losses; principal is expected to perform |

#### 2.2.13 Fidelity / Crime Insurance

| Attribute | Detail |
|---|---|
| ISO Form | CR 00 21 (Commercial Crime Coverage Form) |
| Covered Perils | Employee theft, forgery/alteration, computer fraud, funds transfer fraud, money/securities theft |
| Key Claims | Embezzlement, check fraud, wire transfer fraud, social engineering |
| Discovery vs. Loss Sustained | Two trigger options |

#### 2.2.14 Boiler & Machinery / Equipment Breakdown

| Attribute | Detail |
|---|---|
| Coverage | Sudden and accidental breakdown of covered equipment |
| Equipment Types | HVAC, boilers, electrical systems, production machinery, computer equipment |
| Key Claims | Motor burnout, compressor failure, electrical arcing, mechanical breakdown |
| Unique Aspect | Inspection services paired with coverage |

#### 2.2.15 Cyber Liability

| Attribute | Detail |
|---|---|
| First-Party Coverages | Data breach response costs, business interruption, cyber extortion, data restoration |
| Third-Party Coverages | Network security liability, privacy liability, media liability, regulatory defense |
| Key Claims | Ransomware, data breaches, business email compromise, denial of service |
| Rapidly Evolving | Coverage forms, exclusions, and pricing change frequently |

#### 2.2.16 Product Liability

| Attribute | Detail |
|---|---|
| Covered Under | CGL (Coverage A) or standalone product liability policies |
| Theories of Liability | Strict liability, negligence, breach of warranty |
| Key Claims | Manufacturing defect, design defect, failure to warn, product recall |
| Mass Tort Potential | Single product defect can generate thousands of claims |

### 2.3 Specialty Lines

| Line | Description |
|---|---|
| Crop Insurance | Federally subsidized; covers yield/revenue losses |
| Flood Insurance (NFIP/WYO) | National Flood Insurance Program; Write Your Own carriers |
| Earthquake Insurance | Often separate policy or endorsement |
| Title Insurance | Covers defects in property title |
| Pet Insurance | Veterinary care coverage |
| Travel Insurance | Trip cancellation, medical, baggage |
| Event Cancellation | Covers financial loss from event cancellation |
| Kidnap & Ransom | Response costs and ransom payments |
| Political Risk | Expropriation, political violence, currency inconvertibility |
| Environmental / Pollution Liability | Cleanup costs, third-party liability for pollution |

---

## 3. Complete Taxonomy of Claim Types by Line of Business

### 3.1 Personal Auto Claim Types

```
Personal Auto Claims
├── First-Party Claims (insured's own policy)
│   ├── Collision
│   │   ├── Single-vehicle accident
│   │   ├── Multi-vehicle accident (at-fault)
│   │   ├── Multi-vehicle accident (not-at-fault)
│   │   ├── Hit-and-run (insured is victim)
│   │   └── Parked vehicle struck
│   ├── Comprehensive (Other-Than-Collision)
│   │   ├── Theft (total theft, partial theft)
│   │   ├── Vandalism
│   │   ├── Weather (hail, flood, wind, tornado, hurricane)
│   │   ├── Fire
│   │   ├── Animal strike (deer, etc.)
│   │   ├── Falling objects
│   │   ├── Glass breakage (windshield, side/rear glass)
│   │   ├── Missile/flying object
│   │   └── Civil disturbance / riot
│   ├── Uninsured Motorist (UM)
│   │   ├── UM Bodily Injury (UMBI)
│   │   └── UM Property Damage (UMPD)
│   ├── Underinsured Motorist (UIM)
│   │   ├── UIM Bodily Injury (UIMBI)
│   │   └── UIM Property Damage (varies by state)
│   ├── Personal Injury Protection (PIP) / No-Fault
│   │   ├── Medical expenses
│   │   ├── Lost wages
│   │   ├── Essential services
│   │   ├── Funeral expenses
│   │   └── Survivors' loss benefits
│   ├── Medical Payments (MedPay)
│   ├── Towing & Labor
│   ├── Rental Reimbursement
│   └── Custom Equipment / Aftermarket Parts
│
├── Third-Party Claims (against insured's policy by others)
│   ├── Bodily Injury Liability (BI)
│   │   ├── Soft tissue injury
│   │   ├── Fractures / broken bones
│   │   ├── Head / brain injury (TBI)
│   │   ├── Spinal cord injury
│   │   ├── Internal organ damage
│   │   ├── Disfigurement / scarring
│   │   ├── Wrongful death
│   │   └── Emotional distress
│   └── Property Damage Liability (PD)
│       ├── Vehicle damage
│       ├── Fixed property damage (guardrail, building, fence)
│       └── Personal property damage
│
└── Subrogation Claims (recovery from third party)
    ├── Inter-company arbitration
    ├── Direct recovery (demand)
    └── Litigation-based recovery
```

### 3.2 Homeowners Claim Types

```
Homeowners Claims
├── Property Claims (Coverages A, B, C)
│   ├── Fire & Smoke Damage
│   │   ├── Structure fire (total/partial loss)
│   │   ├── Smoke damage only
│   │   ├── Lightning strike fire
│   │   └── Neighboring property fire spread
│   ├── Water Damage
│   │   ├── Burst/frozen pipes
│   │   ├── Appliance overflow (washing machine, dishwasher, water heater)
│   │   ├── Roof leak (sudden vs. gradual)
│   │   ├── Sewer/drain backup (if endorsed)
│   │   ├── Ice dam damage
│   │   └── Accidental discharge
│   ├── Wind & Hail
│   │   ├── Roof damage (shingles, tiles, structural)
│   │   ├── Siding damage
│   │   ├── Window damage
│   │   ├── Fence/outbuilding damage
│   │   └── Tree fall on structure
│   ├── Theft & Burglary
│   │   ├── Forcible entry theft
│   │   ├── Mysterious disappearance (if covered)
│   │   └── Theft away from premises
│   ├── Vandalism & Malicious Mischief
│   ├── Weight of Ice/Snow/Sleet
│   ├── Electrical Surge / Power Fluctuation
│   ├── Vehicle/Aircraft Striking Structure
│   ├── Falling Objects
│   ├── Volcanic Eruption
│   └── Collapse (limited coverage)
│
├── Loss of Use Claims (Coverage D)
│   ├── Additional Living Expenses (ALE)
│   │   ├── Temporary housing
│   │   ├── Increased food costs
│   │   ├── Storage costs
│   │   └── Transportation costs
│   └── Fair Rental Value (if applicable)
│
├── Liability Claims (Coverage E)
│   ├── Premises Liability
│   │   ├── Slip and fall
│   │   ├── Dog bite
│   │   ├── Swimming pool injury
│   │   ├── Trampoline injury
│   │   └── Falling tree/branch
│   ├── Personal Liability (off-premises)
│   │   ├── Sports injury caused by insured
│   │   └── Accidental property damage by insured
│   └── Damage to Property of Others (Coverage E sublimit)
│
└── Medical Payments Claims (Coverage F)
    ├── Guest medical expenses (regardless of fault)
    └── Typically $1K-$5K per person
```

### 3.3 Commercial Property Claim Types

```
Commercial Property Claims
├── Building Damage
│   ├── Fire / Lightning
│   ├── Windstorm / Hail
│   ├── Explosion
│   ├── Riot / Civil Commotion
│   ├── Aircraft / Vehicle Impact
│   ├── Smoke Damage
│   ├── Vandalism
│   ├── Sprinkler Leakage
│   ├── Sinkhole Collapse
│   ├── Volcanic Action
│   └── Water Damage (non-flood)
├── Business Personal Property (BPP)
│   ├── Contents damage
│   ├── Stock / Inventory loss
│   ├── Equipment damage
│   └── Tenant improvements & betterments
├── Business Income (BI) / Time Element
│   ├── Lost revenue during restoration
│   ├── Continuing expenses
│   ├── Extended business income (post-restoration)
│   └── Extra expense to reduce BI loss
├── Inland Marine / Specialized Property
│   ├── Contractors equipment
│   ├── Electronic data processing
│   ├── Signs
│   ├── Valuable papers and records
│   └── Accounts receivable
└── Catastrophe Claims
    ├── Named windstorm (hurricane)
    ├── Tornado
    ├── Wildfire
    ├── Hail event
    └── Winter storm / ice storm
```

### 3.4 General Liability Claim Types

```
CGL Claims
├── Coverage A — Bodily Injury & Property Damage
│   ├── Premises Liability
│   │   ├── Slip / trip / fall
│   │   ├── Falling merchandise
│   │   ├── Inadequate security
│   │   └── Structural defect
│   ├── Operations Liability
│   │   ├── Injury during active work
│   │   └── Property damage during operations
│   ├── Products Liability
│   │   ├── Manufacturing defect
│   │   ├── Design defect
│   │   ├── Failure to warn
│   │   └── Product recall (if endorsed)
│   └── Completed Operations
│       ├── Post-completion property damage
│       └── Post-completion bodily injury
├── Coverage B — Personal & Advertising Injury
│   ├── Defamation (libel/slander)
│   ├── False arrest / false imprisonment
│   ├── Malicious prosecution
│   ├── Wrongful eviction
│   ├── Invasion of privacy
│   └── Copyright infringement in advertising
└── Coverage C — Medical Payments
    └── Minor injury medical expenses (regardless of fault)
```

### 3.5 Workers' Compensation Claim Types

```
Workers' Compensation Claims
├── Medical-Only Claims
│   ├── Minor injury — treatment, no lost time
│   └── Typically close within 30-90 days
├── Lost-Time / Indemnity Claims
│   ├── Temporary Total Disability (TTD)
│   ├── Temporary Partial Disability (TPD)
│   ├── Permanent Partial Disability (PPD)
│   │   ├── Scheduled (loss of body part per statute)
│   │   └── Unscheduled (percentage of whole person)
│   ├── Permanent Total Disability (PTD)
│   └── Disfigurement benefits
├── Fatality Claims
│   ├── Death benefits to dependents
│   ├── Funeral/burial expenses
│   └── Potential for third-party suit
├── Occupational Disease Claims
│   ├── Repetitive motion / cumulative trauma
│   ├── Hearing loss
│   ├── Respiratory disease
│   ├── Toxic exposure
│   └── Mental-mental claims (jurisdiction dependent)
└── Vocational Rehabilitation Claims
    ├── Retraining
    └── Job placement services
```

---

## 4. Key Stakeholders & Their Roles

### 4.1 Stakeholder Map

```
                        ┌──────────────────────────────────────┐
                        │         INSURANCE CARRIER             │
                        │   (Underwriting, Claims, Finance)     │
                        └──────────┬───────────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
  ┌─────▼─────┐            ┌──────▼──────┐           ┌───────▼──────┐
  │  INSURED   │            │   ADJUSTER   │           │   CLAIMANT   │
  │ (Named     │            │ (Staff, IA,  │           │ (Third Party │
  │  Insured)  │            │  Cat, Desk)  │           │  injured or  │
  └─────┬──────┘            └──────┬───────┘           │  damaged)    │
        │                          │                    └──────┬───────┘
        │                   ┌──────┴────────┐                  │
        │                   │               │                  │
  ┌─────▼──────┐     ┌─────▼────┐   ┌──────▼─────┐    ┌──────▼──────┐
  │   AGENT /   │     │  VENDOR   │   │EXAMINER /  │    │  ATTORNEY   │
  │   BROKER    │     │ NETWORK   │   │SUPERVISOR  │    │ (Plaintiff  │
  └─────────────┘     └─────┬─────┘   └────────────┘    │  or Defense)│
                            │                            └─────────────┘
              ┌─────────────┼─────────────────┐
              │             │                 │
        ┌─────▼────┐ ┌─────▼─────┐    ┌──────▼──────┐
        │  REPAIR   │ │ MEDICAL   │    │  EXPERT     │
        │  SHOP /   │ │ PROVIDER  │    │ (Engineer,  │
        │CONTRACTOR │ │           │    │  Appraiser) │
        └───────────┘ └───────────┘    └─────────────┘
```

### 4.2 Detailed Stakeholder Descriptions

#### 4.2.1 Insured (Named Insured / Policyholder)

| Aspect | Detail |
|---|---|
| Definition | The person or entity named on the insurance policy declarations page |
| Role in Claims | Reports loss, provides documentation, cooperates with investigation, receives indemnification |
| Data Captured | Name, address, phone, email, policy number, date of birth, SSN/TIN (for tax reporting), occupation |
| System Interactions | FNOL submission, document upload, status inquiry, payment receipt |
| Key Obligations | Timely notice of loss, cooperation with investigation, mitigation of further damage, submission of proof of loss |
| Additional Insureds | Entities added to policy by endorsement; may have separate claim rights |

#### 4.2.2 Claimant (Third-Party Claimant)

| Aspect | Detail |
|---|---|
| Definition | A person or entity making a claim against the insured's policy who is not the policyholder |
| Role in Claims | Reports injury/damage, provides documentation, negotiates settlement |
| Data Captured | Name, address, phone, email, DOB, SSN (if applicable), injury details, representation status |
| Representation | May be represented by an attorney; once represented, all communication goes through attorney |
| Multiple Claimants | A single occurrence can generate many claimants (e.g., multi-vehicle accident, mass tort) |

#### 4.2.3 Staff Adjuster

| Aspect | Detail |
|---|---|
| Definition | An employee of the insurance company who investigates and settles claims |
| Licensing | Must hold adjuster license in the state(s) where handling claims |
| Authority Level | Has defined settlement authority limits (e.g., $15K for entry-level, $50K for senior) |
| Workload | Typically manages 100-250 open claims depending on complexity |
| Specializations | Auto physical damage, auto injury, property, liability, workers comp, complex/litigation |

#### 4.2.4 Claims Examiner / Supervisor

| Aspect | Detail |
|---|---|
| Definition | Senior claims professional who reviews, approves, and supervises claim handling |
| Responsibilities | Authority approvals, quality audits, coaching, reserve reviews, litigation oversight |
| Authority | Higher settlement authority than adjusters; may approve up to $250K-$1M+ |
| System Role | Approval workflow participant, audit reviewer, dashboard consumer |

#### 4.2.5 Independent Adjuster (IA)

| Aspect | Detail |
|---|---|
| Definition | A licensed adjuster who works as a contractor for insurance companies, not as an employee |
| Engagement Model | Assigned per-claim or per-event; paid per assignment or hourly/daily |
| Common Use | Catastrophe response, geographic coverage gaps, overflow capacity, specialty claims |
| Firms | Crawford & Company, Sedgwick, McLarens, Engle Martin, etc. |
| Data Exchange | Assignments sent via ACORD standards or vendor-specific APIs |

#### 4.2.6 Catastrophe (CAT) Adjuster

| Aspect | Detail |
|---|---|
| Definition | Specialized IA deployed to handle claims from catastrophic events (hurricanes, earthquakes, wildfires) |
| Deployment | Deployed to disaster zones; handles high-volume field inspections |
| Tools | Xactimate, drones, satellite imagery, mobile estimating platforms |
| Volume | May handle 5-15 inspections per day during CAT events |

#### 4.2.7 Public Adjuster

| Aspect | Detail |
|---|---|
| Definition | A licensed adjuster hired by the policyholder (not the insurance company) to advocate for the insured |
| Fee Structure | Typically 10-20% of the claim settlement |
| Impact on Claims | May result in higher claim payments; carrier adjuster must deal with PA as insured's representative |
| State Regulation | Licensed and regulated by state DOI |

#### 4.2.8 Third Party Administrator (TPA)

| Aspect | Detail |
|---|---|
| Definition | An organization that handles claims on behalf of self-insured entities or insurance companies |
| Common in | Workers' compensation, large commercial accounts, self-insured programs |
| Services | FNOL intake, claim investigation, reserve setting, payment processing, reporting |
| Major TPAs | Sedgwick, Gallagher Bassett, Broadspire, CorVel, ESIS |
| Data Exchange | Requires extensive data feeds between TPA system and carrier/self-insured entity |

#### 4.2.9 Special Investigations Unit (SIU)

| Aspect | Detail |
|---|---|
| Definition | A unit within the insurance company dedicated to detecting and investigating fraud |
| Referral Triggers | Red flags during claim handling (inconsistent statements, prior claim history, suspicious timing) |
| Investigation Tools | Database searches (ISO ClaimSearch, NICB), surveillance, social media analysis, recorded statements |
| Outcomes | Claim denial, referral to law enforcement, civil recovery |
| Regulatory | Many states mandate SIU programs; NICB provides industry coordination |

#### 4.2.10 Defense Attorney

| Aspect | Detail |
|---|---|
| Definition | Attorney hired by the insurer to defend the insured against third-party claims |
| Engagement | Insurer has duty to defend under the policy; selects and pays defense counsel |
| Panel Counsel | Insurers maintain approved lists (panels) of defense firms |
| Reporting | Provides status reports, budget estimates, trial strategy, settlement recommendations |
| Billing | Reviewed against litigation billing guidelines; e-billing platforms (Legal Tracker, CounselLink) |

#### 4.2.11 Plaintiff Attorney

| Aspect | Detail |
|---|---|
| Definition | Attorney representing the claimant against the insured/insurer |
| Fee Structure | Typically contingency fee (33-40% of settlement/verdict) |
| Impact | Represented claims are significantly more expensive on average |
| Communications | Once an attorney letter of representation (LOR) is received, all contact must go through attorney |

#### 4.2.12 Medical Provider

| Aspect | Detail |
|---|---|
| Definition | Healthcare providers who treat injured parties (hospitals, physicians, chiropractors, physical therapists) |
| Data Exchange | Medical records, bills (HCFA/CMS-1500, UB-04), treatment plans |
| Formats | HL7, X12 837/835, paper |
| Bill Review | Medical bills are reviewed for reasonableness, relatedness, and necessity (R&N) |
| Networks | PPO networks for workers comp and PIP; network discounts reduce costs |

#### 4.2.13 Repair Shop / Body Shop

| Aspect | Detail |
|---|---|
| Definition | Facilities that repair damaged vehicles |
| Network Types | Direct Repair Program (DRP), non-DRP, insured's choice |
| Estimating Platforms | CCC ONE, Mitchell, Audatex |
| Process | Initial estimate → supplement if needed → repair → quality inspection → payment |
| Data Exchange | Estimate files (EMS format), photos, status updates |

#### 4.2.14 Contractor (Property Repair)

| Aspect | Detail |
|---|---|
| Definition | General contractors, specialty contractors (roofers, plumbers, electricians) who perform property repairs |
| Managed Repair | Some carriers have contractor networks with pre-negotiated rates |
| Estimating | Xactimate pricing, contractor bids, scope of loss documentation |
| Quality Control | Completion inspections, warranty tracking |

#### 4.2.15 Salvage Company

| Aspect | Detail |
|---|---|
| Definition | Companies that handle and sell damaged/totaled vehicles and property |
| Auto Salvage | Copart, IAA (Insurance Auto Auctions) |
| Process | Vehicle pickup → storage → auction/sale → net salvage recovery |
| Integration | Title transfer, salvage value estimation, auction results feeds |

#### 4.2.16 Subrogation Specialist

| Aspect | Detail |
|---|---|
| Definition | Claims professional specializing in recovering payments from responsible third parties |
| Processes | Demand letters, inter-company arbitration (Arbitration Forums), litigation |
| Data Needs | Liability determination, payment amounts, third-party insurance info, statute of limitations tracking |
| Recovery Methods | Direct billing, arbitration, small claims court, civil litigation |

---

## 5. Insurance Policy Structure Relevant to Claims

### 5.1 Policy Components

A P&C insurance policy has a standard structure that directly impacts claims handling:

```
┌─────────────────────────────────────────────────────┐
│                  INSURANCE POLICY                     │
├─────────────────────────────────────────────────────┤
│                                                       │
│  1. DECLARATIONS PAGE (DEC PAGE)                     │
│     - Named Insured                                  │
│     - Policy Number                                  │
│     - Policy Period (Effective → Expiration)          │
│     - Covered Property / Vehicles / Locations         │
│     - Coverage Limits                                │
│     - Deductibles                                    │
│     - Premium                                        │
│     - Forms and Endorsements Schedule                │
│                                                       │
│  2. INSURING AGREEMENT                               │
│     - What the insurer promises to pay               │
│     - Trigger of coverage (occurrence, claims-made)  │
│     - Scope of covered perils                        │
│                                                       │
│  3. DEFINITIONS                                      │
│     - Defined terms used throughout the policy       │
│     - "You," "We," "Insured," "Occurrence," etc.    │
│                                                       │
│  4. CONDITIONS                                       │
│     - Duties after loss                              │
│     - Notice requirements                            │
│     - Cooperation clause                             │
│     - Subrogation rights                             │
│     - Suit against us (statute of limitations)       │
│     - Appraisal clause                               │
│     - Other insurance clause                         │
│     - Cancellation provisions                        │
│     - Concealment/fraud clause                       │
│                                                       │
│  5. EXCLUSIONS                                       │
│     - Perils not covered                             │
│     - Property not covered                           │
│     - Activities not covered                         │
│     - Intentional acts exclusion                     │
│     - War/terrorism exclusion                        │
│     - Nuclear exclusion                              │
│     - Pollution exclusion                            │
│     - Business pursuits exclusion (HO)               │
│     - Expected/intended exclusion                    │
│                                                       │
│  6. ENDORSEMENTS / RIDERS                            │
│     - Modifications to standard form                 │
│     - Additional coverages                           │
│     - Coverage restrictions                          │
│     - State-specific mandatory endorsements          │
│                                                       │
└─────────────────────────────────────────────────────┘
```

### 5.2 Declarations Page — Claims-Relevant Fields

| Field | Claims Impact |
|---|---|
| Named Insured | Determines who is entitled to coverage; must match claimant or be additional insured |
| Policy Number | Primary key linking claim to policy |
| Policy Period | Determines if loss date falls within coverage period |
| Effective Date | Start of coverage |
| Expiration Date | End of coverage |
| Coverage Limits | Maximum payable per occurrence, per person, aggregate |
| Deductibles | Amount insured must pay before coverage applies |
| Premium Status | If policy is cancelled for non-payment, no coverage exists |
| Covered Locations | Addresses of insured property (property claims) |
| Covered Vehicles | VIN, year, make, model (auto claims) |
| Mortgage/Lienholder | Loss payee who must be included on property damage payments |
| Forms Schedule | Lists all forms and endorsements that make up the policy contract |

### 5.3 How Claims Systems Use Policy Data

```
┌───────────────┐     Real-time API      ┌───────────────────┐
│  CLAIMS SYSTEM │◄────────────────────►│  POLICY ADMIN       │
│                │                       │  SYSTEM (PAS)       │
│  - Claim FNOL  │    Policy Inquiry     │                     │
│  - Coverage    │◄───────────────────  │  - Policy Master    │
│    Verification│                       │  - Coverage Detail  │
│  - Reserve     │    Status Updates     │  - Billing Status   │
│    Calculation │───────────────────►  │  - Endorsement Hx   │
│                │                       │  - Claims History   │
└───────────────┘                       └───────────────────┘

Key Integration Points:
1. FNOL — verify policy exists and is in-force
2. Coverage Check — retrieve coverages, limits, deductibles
3. Party Verification — match insured/vehicle/property to policy
4. Billing Status — confirm no cancellation for non-payment
5. Endorsement History — check mid-term changes affecting coverage
6. Prior Claims — policy-level claims history
7. Loss Payee/Mortgagee — required payees for property claims
```

---

## 6. Coverage Types & How They Map to Claims

### 6.1 Homeowners Coverage Mapping

| Coverage | ISO Designation | What It Covers | Claim Examples | Typical Limits |
|---|---|---|---|---|
| Dwelling | Coverage A | The house structure itself | Fire damage, roof damage from hail | Policy face amount (e.g., $350K) |
| Other Structures | Coverage B | Detached structures (garage, shed, fence) | Fence blown down, detached garage damaged | 10% of Coverage A |
| Personal Property | Coverage C | Contents / belongings | Stolen electronics, furniture damaged by water | 50-75% of Coverage A |
| Loss of Use | Coverage D | Additional living expenses if home uninhabitable | Hotel, restaurant meals, storage | 20-30% of Coverage A |
| Personal Liability | Coverage E | Liability for bodily injury or property damage | Visitor falls on icy sidewalk | $100K-$500K |
| Medical Payments | Coverage F | Medical expenses for injured guests (no-fault) | Guest trips on stairs | $1K-$5K per person |

### 6.2 Personal Auto Coverage Mapping

| Coverage | What It Covers | Claim Type | Typical Limits |
|---|---|---|---|
| Bodily Injury Liability (BI) | Injuries insured causes to others | Third-party BI claim | $25K/$50K to $500K/$500K (per person/per accident) |
| Property Damage Liability (PD) | Damage insured causes to others' property | Third-party PD claim | $25K to $500K |
| Collision | Damage to insured's vehicle from collision | First-party auto damage | ACV minus deductible ($250-$2,000) |
| Comprehensive (OTC) | Damage to insured's vehicle from non-collision | First-party auto damage (theft, weather, animal) | ACV minus deductible ($100-$1,000) |
| Uninsured Motorist BI (UMBI) | Injuries to insured from uninsured driver | First-party BI | Varies by state; often matches BI limits |
| Underinsured Motorist BI (UIMBI) | Injuries to insured from underinsured driver | First-party BI | Varies by state |
| UM Property Damage (UMPD) | Damage to insured's vehicle from uninsured driver | First-party PD | Varies by state; some states only |
| Personal Injury Protection (PIP) | Medical, lost wages, essential services (no-fault) | First-party PIP | $10K-$250K (varies significantly by state) |
| Medical Payments (MedPay) | Medical expenses for insured/passengers | First-party medical | $1K-$25K per person |
| Rental Reimbursement | Rental car while insured's vehicle is being repaired | First-party rental | $30-$75/day, max 30 days |
| Towing & Labor | Towing and roadside assistance | First-party towing | $50-$200 per occurrence |
| Gap Coverage | Difference between ACV and loan balance | Total loss | Loan/lease balance minus ACV |

### 6.3 Commercial Property Coverage Mapping

| Coverage | What It Covers | Claim Type |
|---|---|---|
| Building | The building structure at covered location | Direct property damage to building |
| Business Personal Property (BPP) | Contents, stock, equipment owned by insured | Direct property damage to contents |
| Business Income (BI) | Lost income during period of restoration | Time-element / consequential loss |
| Extra Expense | Expenses to minimize business interruption | Time-element / consequential loss |
| Tenant's Improvements & Betterments | Improvements made by tenant to landlord's building | Tenant's property damage |
| Property of Others | Property of others in insured's care, custody, or control | Bailee-type claim |

### 6.4 CGL Coverage Mapping

| Coverage Part | What It Covers | Claim Type |
|---|---|---|
| Coverage A – BI | Bodily injury caused by insured's operations or products | Premises liability, products liability, completed operations |
| Coverage A – PD | Property damage caused by insured's operations or products | Operations liability, products liability |
| Coverage B – Personal Injury | Defamation, false arrest, wrongful eviction, invasion of privacy | Personal injury claims |
| Coverage B – Advertising Injury | Copyright infringement, misappropriation of advertising ideas | Advertising injury claims |
| Coverage C – Medical Payments | Minor medical expenses regardless of fault | Medical payments (no-fault, low limit) |

### 6.5 Coverage-to-Feature Mapping for Claims System Design

| Coverage Concept | Claims System Feature Required |
|---|---|
| Per-occurrence limit | Track total payments per occurrence across all features/claimants |
| Per-person limit | Track total payments per individual claimant |
| Aggregate limit | Track policy-period cumulative payments; alert when approaching |
| Deductible | Apply before payment calculation; track deductible satisfaction |
| Sublimit | Enforce coverage-specific maximums (e.g., $5K jewelry sublimit in HO) |
| Self-Insured Retention (SIR) | Insured pays first; track SIR satisfaction before carrier pays |
| Coinsurance | Calculate coinsurance penalty if underinsured at time of loss |
| Other Insurance | Coordinate with other applicable policies; contribution/excess/primary rules |
| Occurrence trigger | Coverage applies to loss date; verify loss date within policy period |
| Claims-made trigger | Coverage applies to date claim is made AND reported; check retroactive date |
| Stacking | Whether coverage limits can be combined from multiple policies/vehicles |

---

## 7. Deductibles, Limits, Sublimits & Self-Insured Retentions

### 7.1 Deductible Types

| Deductible Type | Description | Example | Claims System Logic |
|---|---|---|---|
| Flat Dollar | Fixed dollar amount per claim/occurrence | $500 collision deductible | Subtract from loss amount before payment |
| Percentage | Percentage of insured value or limit | 2% hurricane deductible on $400K dwelling = $8K | Calculate based on Coverage A amount |
| Split | Different deductibles for different perils | $1K all-peril, $2.5K wind/hail | Map cause of loss to applicable deductible |
| Disappearing | Deductible reduces as loss increases until it disappears | $500 deductible at $500 loss; $0 deductible at $5K loss | Apply formula: Deductible = Max(0, D - (L - D) × factor) |
| Aggregate | Annual aggregate deductible across all claims | $25K annual aggregate in commercial | Track cumulative deductible satisfaction across claims |
| Per-claim vs Per-occurrence | Applied per claim or per occurrence | Workers comp: per-claim; CGL: per-occurrence | Group claims by occurrence for deductible application |
| Waiting Period | Time-based deductible (for business income) | 72-hour waiting period for BI coverage | Calculate BI loss only after waiting period expires |
| Franchise | Full coverage once threshold met; no deductible | Marine franchise: $10K; loss of $9K = $0; loss of $11K = $11K | Binary: if loss > franchise, pay full; if less, pay nothing |

### 7.2 Limits Structure

```
Policy Limits Architecture
│
├── Per-Occurrence Limit
│   ├── Per-Person Sublimit (BI)
│   └── Per-Occurrence Maximum
│
├── General Aggregate Limit
│   └── Total payable in policy period across all occurrences
│
├── Products/Completed Operations Aggregate
│   └── Separate aggregate for products/completed operations claims
│
├── Personal & Advertising Injury Limit
│   └── Per-person, per-occurrence
│
├── Medical Payments Limit
│   └── Per-person
│
├── Fire Damage Legal Liability Limit
│   └── Per-fire (CGL)
│
├── Damage to Premises Rented to You
│   └── Per-occurrence sublimit
│
└── Employee Benefits Liability Limit
    └── Per-employee, aggregate
```

### 7.3 Sublimits

Sublimits are maximum amounts payable for specific types of property or perils, nested within the broader coverage limit.

| Line | Sublimit Category | Typical Amount | System Logic |
|---|---|---|---|
| Homeowners | Cash/currency | $200 | Cap payment at sublimit for category |
| Homeowners | Jewelry/watches | $1,500 | Cap unless scheduled |
| Homeowners | Firearms | $2,500 | Cap unless scheduled |
| Homeowners | Silverware | $2,500 | Cap unless scheduled |
| Homeowners | Electronics (portable) | $1,500 | Cap unless scheduled |
| Homeowners | Business property on premises | $2,500 | Cap per policy form |
| Homeowners | Ordinance or law | 10% of Coverage A | Calculate based on Coverage A limit |
| Commercial Property | Outdoor signs | $2,500 | Standard sublimit |
| Commercial Property | Valuable papers | $2,500 | Standard sublimit |
| Commercial Property | Electronic data | $2,500 | Standard sublimit |

### 7.4 Self-Insured Retention (SIR)

| Aspect | Detail |
|---|---|
| Definition | Amount the insured must pay before the insurer's obligation begins |
| Difference from Deductible | With SIR, insured controls the claim until SIR is met; with deductible, insurer controls from start |
| Common in | Large commercial, excess liability, D&O, E&O |
| Claims System Impact | Must track insured's SIR payments; coverage only triggers after SIR satisfied |
| Erosion Tracking | Some SIRs erode by both indemnity and expense; others by indemnity only |

---

## 8. Key Industry Bodies

### 8.1 ACORD (Association for Cooperative Operations Research and Development)

| Aspect | Detail |
|---|---|
| Founded | 1970 |
| Purpose | Develops data standards for the insurance industry |
| Key Standards | ACORD Forms (paper/PDF), ACORD XML, ACORD AL3, ACORD Data Model |
| Claims Relevance | Standard forms for loss reporting (ACORD 1, 2, 3), XML schemas for electronic claims data exchange, canonical data model |
| Website | acord.org |
| Membership | 900+ member organizations globally |
| Data Model | PC Data Model covers policy, claims, billing, reinsurance with 1000+ entities |

### 8.2 ISO (Insurance Services Office) — now Verisk

| Aspect | Detail |
|---|---|
| Purpose | Provides statistical, actuarial, and data services for P&C insurers |
| Key Products | Advisory forms and rates, ISO ClaimSearch, statistical plans, cause of loss codes |
| Claims Relevance | ClaimSearch (industry claims database), standard cause of loss codes, Electronic Claim File (ECF), statistical reporting requirements |
| ISO ClaimSearch | Matches claims across insurers for fraud detection (30B+ claims records) |
| Code Systems | Cause of loss codes, coverage codes, construction class codes |

### 8.3 NAIC (National Association of Insurance Commissioners)

| Aspect | Detail |
|---|---|
| Purpose | Organization of insurance regulators from all 50 states, DC, and territories |
| Key Functions | Model laws and regulations, statutory reporting requirements, market conduct oversight |
| Claims Relevance | Claims handling regulations, unfair claims settlement practices acts, data calls, complaint tracking |
| Annual Statement | Statutory financial reporting including loss reserves, paid losses, IBNR |
| Data Calls | Ad-hoc and periodic data requests from regulators about claims activity |

### 8.4 NCCI (National Council on Compensation Insurance)

| Aspect | Detail |
|---|---|
| Purpose | Develops and administers workers' compensation insurance rating, data collection, and analysis |
| Coverage | Operates in ~38 states (some states have independent bureaus) |
| Claims Relevance | Classification codes, experience rating, EDI standards for WC claims reporting, statistical plans |
| WCIO | Workers Compensation Insurance Organizations — coordinates WC data standards |
| EDI Standards | Electronic Data Interchange for reporting claims to states and NCCI |

### 8.5 AAIS (American Association of Insurance Services)

| Aspect | Detail |
|---|---|
| Purpose | Advisory organization providing policy forms, rating information, and data services |
| Difference from ISO | Alternative to ISO; smaller market share but used by many regional/mutual carriers |
| Claims Relevance | Alternative policy forms that claims systems must handle |
| Products | openIDL (open Insurance Data Link) — blockchain-based data exchange |

### 8.6 Other Important Bodies

| Organization | Purpose | Claims Relevance |
|---|---|---|
| NICB (National Insurance Crime Bureau) | Insurance fraud detection and prevention | Questionable claims referrals, VIN checks, theft database |
| III (Insurance Information Institute) | Industry research and communications | Industry statistics, catastrophe data |
| IRMI (International Risk Management Institute) | Education and reference materials | Coverage interpretation resources |
| Arbitration Forums (AF) | Inter-company arbitration and subrogation | Handles inter-company auto subrogation disputes |
| NAIC/CIAB | Agents and brokers associations | Channel-related claims process standards |
| CLM (Claims and Litigation Management Alliance) | Claims professional education | Best practices, certifications |
| CPCU Society | Chartered Property Casualty Underwriter | Professional designation and education |
| PLRB / LIRB | Property / Liability Research Bureaus | Claims handling research and guidance |

---

## 9. Domain Entity Relationship Diagram

### 9.1 High-Level Entity Relationship Diagram

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                     PnC CLAIMS DOMAIN - ENTITY RELATIONSHIPS                  │
└──────────────────────────────────────────────────────────────────────────────┘

                            ┌──────────┐
                            │  POLICY   │
                            │──────────│
                            │PolicyNum  │
                            │EffDate    │
                            │ExpDate    │
                            │Status     │
                            │LOB        │
                            └────┬──┬──┘
                   has coverages │  │  has parties
                 ┌───────────────┘  └────────────────┐
                 │                                    │
          ┌──────▼──────┐                    ┌────────▼───────┐
          │  COVERAGE    │                    │  POLICY_PARTY  │
          │─────────────│                    │───────────────│
          │CoverageCode  │                    │PartyRole       │
          │Limit         │                    │InsuredType     │
          │Deductible    │                    └────────┬───────┘
          │Sublimit      │                             │
          └──────┬───────┘                    ┌────────▼───────┐
                 │                            │    PARTY        │
                 │ covers                     │───────────────│
                 │                            │PartyID         │
    ┌────────────▼────────────┐               │PartyType       │
    │         CLAIM            │◄──────────── │Name            │
    │─────────────────────────│  reported by  │Address         │
    │ClaimNumber               │               │Phone           │
    │LossDate                  │               │Email           │
    │ReportDate                │               │TaxID           │
    │Status                    │               └───────┬────────┘
    │ClaimType                 │                       │
    │CatastropheCode           │              ┌────────▼───────┐
    │Jurisdiction               │              │  CLAIM_PARTY   │
    │AssignedAdjuster           │              │───────────────│
    │TotalIncurred              │              │PartyRole       │
    │TotalPaid                  │              │RepresentedBy   │
    │TotalReserve               │              │InjuryFlag      │
    └──┬───┬───┬───┬───┬───┬──┘              └────────────────┘
       │   │   │   │   │   │
       │   │   │   │   │   └──────────────────────────────────────┐
       │   │   │   │   └──────────────────────────────┐           │
       │   │   │   └──────────────────────┐           │           │
       │   │   └──────────────┐           │           │           │
       │   └──────┐           │           │           │           │
       │          │           │           │           │           │
  ┌────▼───┐ ┌───▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼────┐ ┌───▼────┐
  │FEATURE │ │RESERVE │ │PAYMENT │ │ACTIVITY│ │  NOTE  │ │DOCUMENT│
  │────────│ │────────│ │────────│ │────────│ │────────│ │────────│
  │CovCode │ │Type    │ │Type    │ │Type    │ │NoteText│ │DocType │
  │Claimant│ │Amount  │ │Amount  │ │DueDate │ │Author  │ │FileRef │
  │Status  │ │AsOf    │ │Payee   │ │Status  │ │DateTime│ │MimeType│
  │Exposure│ │Category│ │CheckNum│ │Priority│ │Category│ │Source  │
  └────────┘ └────────┘ │Method  │ │Assigned│ └────────┘ └────────┘
                         │Date    │ │Diary   │
                         └────────┘ └────────┘
```

### 9.2 Detailed Relationship Descriptions

| Relationship | Cardinality | Description |
|---|---|---|
| Policy → Coverage | 1:N | A policy contains multiple coverages |
| Policy → Claim | 1:N | A policy can have multiple claims |
| Claim → Feature | 1:N | A claim has multiple features (coverage exposures) |
| Claim → Reserve | 1:N | A claim has multiple reserve transactions (at feature level) |
| Claim → Payment | 1:N | A claim has multiple payments |
| Claim → Activity | 1:N | A claim has multiple activities/tasks |
| Claim → Note | 1:N | A claim has multiple notes |
| Claim → Document | 1:N | A claim has multiple documents |
| Claim → Claim_Party | 1:N | A claim involves multiple parties in different roles |
| Party → Claim_Party | 1:N | A party can be involved in multiple claims |
| Feature → Reserve | 1:N | Reserves are set at the feature level |
| Feature → Payment | 1:N | Payments are made at the feature level |
| Claim → Occurrence | N:1 | Multiple claims can share one occurrence |
| Occurrence → Catastrophe | N:1 | Multiple occurrences can be linked to one catastrophe event |
| Claim → Subrogation | 1:1 | A claim may have subrogation recovery tracking |
| Payment → Recovery | 1:N | A payment may have associated recoveries |

### 9.3 Occurrence vs. Claim vs. Feature Model

```
┌──────────────────────────────────────────────────────────┐
│                     OCCURRENCE                            │
│ (The event/incident that caused loss)                     │
│ OccurrenceID: OCC-2026-00001                             │
│ Date: 2026-03-15                                         │
│ Description: Multi-vehicle accident at Hwy 101 & Main    │
│ CatastropheCode: NULL                                    │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────────────────┐  ┌────────────────────────┐ │
│  │     CLAIM #1             │  │     CLAIM #2            │ │
│  │ Policy: PAP-001          │  │ Policy: PAP-002         │ │
│  │ Insured: John Smith      │  │ Insured: Jane Doe       │ │
│  │ ClaimNum: CLM-2026-0001  │  │ ClaimNum: CLM-2026-0002 │ │
│  │                          │  │                         │ │
│  │  Features:               │  │  Features:              │ │
│  │  ├─ COLL (Collision)     │  │  ├─ COLL (Collision)    │ │
│  │  ├─ BI-1 (BI Claimant 1) │  │  ├─ RENTAL              │ │
│  │  ├─ BI-2 (BI Claimant 2) │  │  └─ MEDPAY              │ │
│  │  ├─ PD (Prop Damage)     │  │                         │ │
│  │  └─ RENTAL               │  │                         │ │
│  └─────────────────────────┘  └────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

The three-tier model (Occurrence → Claim → Feature) is the standard architectural pattern for claims systems:

- **Occurrence** — the event (accident, storm, incident) that triggered losses
- **Claim** — the contractual unit linking one policy to one occurrence; one claim per policy per occurrence
- **Feature** (also called Exposure, Coverage Feature, or Claim Unit) — a specific coverage/claimant combination within a claim; this is where reserves and payments are tracked

---

## 10. Complete Data Dictionary of Core Claims Entities

### 10.1 CLAIM Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| claim_id | UUID | 36 | Yes | System-generated unique identifier |
| claim_number | VARCHAR | 20 | Yes | Business-facing claim number (e.g., CLM-2026-000001) |
| occurrence_id | UUID | 36 | No | Link to occurrence/incident record |
| policy_id | UUID | 36 | Yes | Link to the policy providing coverage |
| policy_number | VARCHAR | 20 | Yes | Denormalized policy number for display |
| line_of_business | VARCHAR | 10 | Yes | LOB code (PA, HO, CP, CGL, WC, etc.) |
| claim_type | VARCHAR | 20 | Yes | Type classification (see taxonomy) |
| status | VARCHAR | 20 | Yes | Current claim status (Open, Closed, Reopened, etc.) |
| sub_status | VARCHAR | 30 | No | Detailed sub-status (Under Investigation, Pending Payment, etc.) |
| loss_date | DATETIME | - | Yes | Date and time of the loss/occurrence |
| report_date | DATETIME | - | Yes | Date and time the claim was reported to the carrier |
| entry_date | DATETIME | - | Yes | Date and time the claim was entered into the system |
| close_date | DATETIME | - | No | Date and time the claim was closed |
| reopen_date | DATETIME | - | No | Date and time the claim was most recently reopened |
| catastrophe_code | VARCHAR | 10 | No | CAT event code if applicable (e.g., PCS serial number) |
| cause_of_loss | VARCHAR | 10 | Yes | ISO cause of loss code |
| cause_of_loss_desc | VARCHAR | 100 | No | Description of cause of loss |
| loss_location_address1 | VARCHAR | 100 | No | Street address of loss location |
| loss_location_address2 | VARCHAR | 100 | No | Address line 2 |
| loss_location_city | VARCHAR | 50 | No | City of loss location |
| loss_location_state | VARCHAR | 2 | Yes | State code of loss location |
| loss_location_zip | VARCHAR | 10 | No | ZIP code of loss location |
| loss_location_county | VARCHAR | 50 | No | County (important for jurisdiction) |
| loss_location_country | VARCHAR | 3 | No | Country code (ISO 3166) |
| loss_description | TEXT | 4000 | Yes | Free-text description of the loss |
| jurisdiction | VARCHAR | 2 | Yes | Regulatory jurisdiction governing the claim |
| assigned_adjuster_id | UUID | 36 | No | Currently assigned adjuster |
| assigned_unit | VARCHAR | 20 | No | Claims unit/team assignment |
| supervisor_id | UUID | 36 | No | Supervising examiner |
| handling_office | VARCHAR | 10 | No | Office handling the claim |
| complexity_score | DECIMAL | 5,2 | No | Calculated complexity score |
| severity_score | DECIMAL | 5,2 | No | Calculated severity score |
| litigation_flag | BOOLEAN | - | No | Whether claim is in litigation |
| fraud_flag | BOOLEAN | - | No | Whether SIU referral has been made |
| subrogation_flag | BOOLEAN | - | No | Whether subrogation potential exists |
| total_incurred | DECIMAL | 15,2 | No | Total incurred (reserves + paid) |
| total_paid | DECIMAL | 15,2 | No | Total paid to date |
| total_reserve | DECIMAL | 15,2 | No | Total outstanding reserves |
| total_recovery | DECIMAL | 15,2 | No | Total recoveries (subrogation, salvage) |
| net_incurred | DECIMAL | 15,2 | No | Total incurred minus recoveries |
| created_by | VARCHAR | 50 | Yes | User who created the claim |
| created_date | DATETIME | - | Yes | Timestamp of creation |
| modified_by | VARCHAR | 50 | Yes | User who last modified |
| modified_date | DATETIME | - | Yes | Timestamp of last modification |
| version | INTEGER | - | Yes | Optimistic locking version number |

### 10.2 POLICY Entity (Claims System View)

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| policy_id | UUID | 36 | Yes | Unique identifier |
| policy_number | VARCHAR | 20 | Yes | Policy number from PAS |
| policy_type | VARCHAR | 10 | Yes | Type (HO3, HO5, PAP, CPP, CGL, etc.) |
| line_of_business | VARCHAR | 10 | Yes | Line of business code |
| effective_date | DATE | - | Yes | Policy inception date |
| expiration_date | DATE | - | Yes | Policy expiration date |
| status | VARCHAR | 15 | Yes | Policy status (Active, Cancelled, Expired, etc.) |
| cancellation_date | DATE | - | No | Date policy was cancelled, if applicable |
| cancellation_reason | VARCHAR | 30 | No | Reason for cancellation |
| named_insured_id | UUID | 36 | Yes | Primary named insured party |
| named_insured_name | VARCHAR | 200 | Yes | Denormalized insured name |
| agent_code | VARCHAR | 20 | No | Producing agent/broker code |
| underwriting_company | VARCHAR | 10 | Yes | Legal entity / NAIC company code |
| program_code | VARCHAR | 10 | No | Program or product identifier |
| billing_status | VARCHAR | 15 | No | Current billing status |
| total_premium | DECIMAL | 12,2 | No | Total policy premium |
| state | VARCHAR | 2 | Yes | Policy state |
| source_system | VARCHAR | 20 | Yes | Originating PAS system identifier |
| last_sync_date | DATETIME | - | Yes | Last time policy data was synced from PAS |

### 10.3 PARTY Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| party_id | UUID | 36 | Yes | Unique identifier |
| party_type | VARCHAR | 10 | Yes | Individual, Organization |
| first_name | VARCHAR | 50 | Cond | Required for individuals |
| middle_name | VARCHAR | 50 | No | Middle name |
| last_name | VARCHAR | 100 | Cond | Required for individuals |
| name_suffix | VARCHAR | 10 | No | Jr., Sr., III, etc. |
| organization_name | VARCHAR | 200 | Cond | Required for organizations |
| date_of_birth | DATE | - | No | Date of birth (individuals) |
| gender | VARCHAR | 1 | No | M, F, X, U |
| ssn_tin | VARCHAR | 11 | No | SSN or TIN (encrypted) |
| drivers_license_number | VARCHAR | 20 | No | Driver's license number |
| drivers_license_state | VARCHAR | 2 | No | State of issuance |
| primary_phone | VARCHAR | 15 | No | Primary phone number |
| secondary_phone | VARCHAR | 15 | No | Secondary phone number |
| email | VARCHAR | 100 | No | Email address |
| address_line1 | VARCHAR | 100 | No | Street address line 1 |
| address_line2 | VARCHAR | 100 | No | Street address line 2 |
| city | VARCHAR | 50 | No | City |
| state | VARCHAR | 2 | No | State code |
| zip_code | VARCHAR | 10 | No | ZIP code |
| country | VARCHAR | 3 | No | Country code |
| preferred_language | VARCHAR | 5 | No | ISO 639 language code |
| created_date | DATETIME | - | Yes | Record creation timestamp |
| modified_date | DATETIME | - | Yes | Last modification timestamp |

### 10.4 CLAIM_PARTY Entity (Intersection)

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| claim_party_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| party_id | UUID | 36 | Yes | Link to party |
| party_role | VARCHAR | 20 | Yes | Role in this claim (Insured, Claimant, Witness, Attorney, Adjuster, etc.) |
| is_primary | BOOLEAN | - | No | Whether this is the primary party in this role |
| represented_by_party_id | UUID | 36 | No | Attorney party ID if represented |
| injury_flag | BOOLEAN | - | No | Whether this party has injuries |
| injury_description | TEXT | 2000 | No | Description of injuries |
| vehicle_id | UUID | 36 | No | Link to vehicle if applicable |
| property_id | UUID | 36 | No | Link to property if applicable |

### 10.5 COVERAGE Entity (Claims-Side)

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| coverage_id | UUID | 36 | Yes | Unique identifier |
| policy_id | UUID | 36 | Yes | Link to policy |
| coverage_code | VARCHAR | 20 | Yes | Coverage code (COLL, COMP, BI, PD, UMBI, PIP, COV_A, etc.) |
| coverage_description | VARCHAR | 100 | No | Human-readable description |
| per_person_limit | DECIMAL | 15,2 | No | Per-person limit |
| per_occurrence_limit | DECIMAL | 15,2 | No | Per-occurrence limit |
| aggregate_limit | DECIMAL | 15,2 | No | Aggregate limit |
| deductible_amount | DECIMAL | 12,2 | No | Deductible amount |
| deductible_type | VARCHAR | 20 | No | Flat, Percentage, Aggregate |
| effective_date | DATE | - | Yes | Coverage effective date |
| expiration_date | DATE | - | Yes | Coverage expiration date |
| coverage_form | VARCHAR | 30 | No | ISO/AAIS form number |
| coinsurance_pct | DECIMAL | 5,2 | No | Coinsurance percentage |
| valuation_method | VARCHAR | 20 | No | RCV, ACV, AgreedValue, Functional |

### 10.6 FEATURE Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| feature_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_number | VARCHAR | 10 | Yes | Feature sequence number within claim |
| coverage_code | VARCHAR | 20 | Yes | Coverage code for this feature |
| claimant_party_id | UUID | 36 | No | Claimant for this feature |
| feature_type | VARCHAR | 20 | Yes | First-party, Third-party |
| status | VARCHAR | 20 | Yes | Open, Closed, Reopened |
| close_date | DATETIME | - | No | Feature close date |
| close_reason | VARCHAR | 30 | No | Reason for closing |
| loss_reserve | DECIMAL | 15,2 | Yes | Outstanding loss reserve |
| expense_reserve | DECIMAL | 15,2 | Yes | Outstanding expense reserve (ALAE/ULAE) |
| loss_paid | DECIMAL | 15,2 | Yes | Total loss paid |
| expense_paid | DECIMAL | 15,2 | Yes | Total expense paid |
| total_incurred | DECIMAL | 15,2 | Yes | Total incurred (reserves + paid) |
| recovery_amount | DECIMAL | 15,2 | No | Total recoveries |
| deductible_applied | DECIMAL | 12,2 | No | Deductible amount applied |
| limit_amount | DECIMAL | 15,2 | No | Applicable coverage limit |
| body_part_code | VARCHAR | 10 | No | Body part injured (injury features) |
| nature_of_injury_code | VARCHAR | 10 | No | Nature of injury code |

### 10.7 RESERVE Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| reserve_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_id | UUID | 36 | Yes | Link to feature |
| reserve_type | VARCHAR | 10 | Yes | Loss, ALAE, ULAE |
| transaction_type | VARCHAR | 15 | Yes | Initial, Change, Override |
| previous_amount | DECIMAL | 15,2 | Yes | Reserve before this transaction |
| new_amount | DECIMAL | 15,2 | Yes | Reserve after this transaction |
| change_amount | DECIMAL | 15,2 | Yes | Amount of change |
| reason_code | VARCHAR | 20 | No | Reason for reserve change |
| reason_description | TEXT | 500 | No | Free-text reason |
| effective_date | DATETIME | - | Yes | When the reserve change takes effect |
| approved_by | VARCHAR | 50 | No | Approver (if required by authority level) |
| created_by | VARCHAR | 50 | Yes | User who created the transaction |
| created_date | DATETIME | - | Yes | Transaction timestamp |
| authority_level_required | VARCHAR | 10 | No | Authority level needed for this change |
| auto_generated | BOOLEAN | - | No | Whether this was system-generated |

### 10.8 PAYMENT Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| payment_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_id | UUID | 36 | Yes | Link to feature |
| payment_type | VARCHAR | 15 | Yes | Loss, ALAE, ULAE |
| payment_category | VARCHAR | 30 | Yes | Indemnity, Medical, Legal, Expert, Repair, Rental, etc. |
| payee_party_id | UUID | 36 | Yes | Link to payee party |
| payee_name | VARCHAR | 200 | Yes | Payee name as printed on check |
| co_payee_name | VARCHAR | 200 | No | Co-payee / loss payee name |
| amount | DECIMAL | 15,2 | Yes | Payment amount |
| payment_method | VARCHAR | 15 | Yes | Check, EFT/ACH, Wire, Virtual Card |
| check_number | VARCHAR | 15 | No | Check number if applicable |
| payment_date | DATE | - | Yes | Date payment was issued |
| cleared_date | DATE | - | No | Date payment was cashed/cleared |
| voided_date | DATE | - | No | Date payment was voided, if applicable |
| stop_pay_date | DATE | - | No | Date stop payment was issued |
| status | VARCHAR | 15 | Yes | Pending, Approved, Issued, Cleared, Voided, Stopped |
| memo | VARCHAR | 500 | No | Payment memo line |
| tax_reportable | BOOLEAN | - | No | Whether this payment is 1099 reportable |
| tax_form_type | VARCHAR | 10 | No | 1099-MISC, 1099-NEC, etc. |
| approved_by | VARCHAR | 50 | No | Approver |
| approval_date | DATETIME | - | No | Approval timestamp |
| invoice_number | VARCHAR | 30 | No | Vendor invoice number |
| service_from_date | DATE | - | No | Service period start date |
| service_to_date | DATE | - | No | Service period end date |
| created_by | VARCHAR | 50 | Yes | User who created |
| created_date | DATETIME | - | Yes | Creation timestamp |

### 10.9 ACTIVITY Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| activity_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_id | UUID | 36 | No | Link to feature (if feature-specific) |
| activity_type | VARCHAR | 30 | Yes | Type code (Contact, Inspect, ReviewRecords, ObtainStatement, etc.) |
| activity_pattern | VARCHAR | 20 | No | System-generated or Manual |
| subject | VARCHAR | 200 | Yes | Activity subject line |
| description | TEXT | 4000 | No | Activity description |
| priority | VARCHAR | 10 | Yes | High, Medium, Low |
| status | VARCHAR | 15 | Yes | Open, In Progress, Completed, Cancelled, Skipped |
| assigned_to | VARCHAR | 50 | Yes | Assigned user/role |
| assigned_group | VARCHAR | 30 | No | Assigned team/group |
| due_date | DATETIME | - | Yes | When the activity is due |
| completion_date | DATETIME | - | No | When the activity was completed |
| escalation_date | DATETIME | - | No | When the activity will escalate |
| related_party_id | UUID | 36 | No | Related party for this activity |
| recurring | BOOLEAN | - | No | Whether this is a recurring diary activity |
| recurrence_pattern | VARCHAR | 30 | No | Daily, Weekly, Bi-weekly, Monthly, etc. |
| created_by | VARCHAR | 50 | Yes | Creator |
| created_date | DATETIME | - | Yes | Creation timestamp |

### 10.10 NOTE Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| note_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_id | UUID | 36 | No | Link to feature (optional) |
| note_type | VARCHAR | 20 | Yes | General, ContactLog, SupervisorReview, Legal, Medical, Financial, etc. |
| subject | VARCHAR | 200 | No | Note subject |
| body | TEXT | 32000 | Yes | Note content |
| author | VARCHAR | 50 | Yes | Note author |
| confidential | BOOLEAN | - | No | Whether note is restricted access |
| security_level | VARCHAR | 10 | No | Public, Internal, Confidential, SIU |
| created_date | DATETIME | - | Yes | Creation timestamp |
| modified_date | DATETIME | - | No | Last modification timestamp |

### 10.11 DOCUMENT Entity

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| document_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| feature_id | UUID | 36 | No | Link to feature (optional) |
| document_type | VARCHAR | 30 | Yes | Type (PoliceReport, MedicalRecord, Estimate, Photo, Invoice, ProofOfLoss, etc.) |
| document_name | VARCHAR | 200 | Yes | File name |
| description | VARCHAR | 500 | No | Description |
| mime_type | VARCHAR | 50 | Yes | MIME type (application/pdf, image/jpeg, etc.) |
| file_size | BIGINT | - | No | File size in bytes |
| storage_reference | VARCHAR | 500 | Yes | Object storage key/URL |
| source | VARCHAR | 20 | Yes | Source (Uploaded, Generated, Received, Scanned) |
| received_from | VARCHAR | 200 | No | Who provided the document |
| received_date | DATE | - | No | Date received |
| security_level | VARCHAR | 10 | No | Access restriction level |
| ocr_text | TEXT | - | No | Extracted text from OCR |
| created_by | VARCHAR | 50 | Yes | Uploader |
| created_date | DATETIME | - | Yes | Upload timestamp |

### 10.12 VEHICLE Entity (Auto Claims)

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| vehicle_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| vehicle_role | VARCHAR | 15 | Yes | InsuredVehicle, ClaimantVehicle, OtherVehicle |
| vin | VARCHAR | 17 | Yes | Vehicle Identification Number |
| year | INTEGER | 4 | Yes | Model year |
| make | VARCHAR | 30 | Yes | Manufacturer |
| model | VARCHAR | 30 | Yes | Model |
| body_style | VARCHAR | 20 | No | Sedan, SUV, Truck, Van, etc. |
| color | VARCHAR | 20 | No | Vehicle color |
| mileage | INTEGER | - | No | Odometer reading at time of loss |
| license_plate | VARCHAR | 15 | No | License plate number |
| license_state | VARCHAR | 2 | No | State of registration |
| owner_party_id | UUID | 36 | No | Link to vehicle owner party |
| driver_party_id | UUID | 36 | No | Link to driver party at time of loss |
| pre_loss_condition | VARCHAR | 20 | No | Excellent, Good, Fair, Poor |
| damage_description | TEXT | 2000 | No | Description of damage |
| point_of_impact | VARCHAR | 30 | No | Front, Rear, Left, Right, Rollover, etc. |
| drivable | BOOLEAN | - | No | Whether vehicle is drivable after loss |
| airbag_deployed | BOOLEAN | - | No | Whether airbags deployed |
| towed | BOOLEAN | - | No | Whether vehicle was towed |
| tow_location | VARCHAR | 200 | No | Where vehicle was towed to |
| total_loss_flag | BOOLEAN | - | No | Whether vehicle is a total loss |
| actual_cash_value | DECIMAL | 12,2 | No | ACV determination |
| salvage_value | DECIMAL | 12,2 | No | Salvage value |
| estimate_amount | DECIMAL | 12,2 | No | Repair estimate amount |

### 10.13 PROPERTY Entity (Property Claims)

| Field Name | Data Type | Length | Required | Description |
|---|---|---|---|---|
| property_id | UUID | 36 | Yes | Unique identifier |
| claim_id | UUID | 36 | Yes | Link to claim |
| property_type | VARCHAR | 20 | Yes | Dwelling, OtherStructure, PersonalProperty, CommercialBuilding, BPP |
| address_line1 | VARCHAR | 100 | Yes | Property address |
| address_line2 | VARCHAR | 100 | No | Address line 2 |
| city | VARCHAR | 50 | Yes | City |
| state | VARCHAR | 2 | Yes | State |
| zip_code | VARCHAR | 10 | Yes | ZIP |
| construction_type | VARCHAR | 20 | No | Frame, Masonry, Steel, etc. |
| year_built | INTEGER | 4 | No | Year constructed |
| square_footage | INTEGER | - | No | Building square footage |
| number_of_stories | INTEGER | - | No | Number of stories |
| occupancy_type | VARCHAR | 20 | No | Owner-occupied, Tenant, Vacant |
| roof_type | VARCHAR | 30 | No | Asphalt shingle, Tile, Metal, etc. |
| damage_description | TEXT | 4000 | No | Description of property damage |
| damaged_area | VARCHAR | 50 | No | Specific area damaged |
| habitability_status | VARCHAR | 15 | No | Habitable, Uninhabitable |
| mortgage_company | VARCHAR | 100 | No | Mortgagee name |
| mortgage_loan_number | VARCHAR | 30 | No | Mortgage loan number |

---

## 11. Glossary of 100+ PnC Claims Terms

| # | Term | Definition |
|---|---|---|
| 1 | **Accident Year** | A method of organizing claims data by the year in which the loss occurred, regardless of when reported or paid |
| 2 | **Actual Cash Value (ACV)** | The value of property at the time of loss, typically replacement cost minus depreciation |
| 3 | **Additional Living Expenses (ALE)** | Coverage for increased costs of living when a home is uninhabitable due to a covered loss |
| 4 | **Adjuster** | A person who investigates, evaluates, and settles insurance claims |
| 5 | **Adverse Development** | When actual losses exceed previously established reserves |
| 6 | **ALAE (Allocated Loss Adjustment Expense)** | Claim-specific expenses such as defense attorney fees, expert fees, and independent adjuster fees |
| 7 | **Appraisal** | A policy provision allowing either party to demand an independent valuation of loss amount through a formal process |
| 8 | **Arbitration** | A dispute resolution process (inter-company or insured vs. insurer) using a neutral third party |
| 9 | **Assignment** | The process of assigning a claim to a specific adjuster or handling unit |
| 10 | **Blanket Coverage** | A single coverage limit that applies to multiple items or locations |
| 11 | **Bodily Injury (BI)** | Physical injury, sickness, or disease sustained by a person, including death |
| 12 | **Business Income (BI)** | Coverage for lost revenue and continuing expenses when operations are interrupted by a covered loss |
| 13 | **Catastrophe (CAT)** | A single event causing widespread losses; PCS defines as $25M+ in insured losses |
| 14 | **Cause of Loss** | The peril or event that caused the damage (fire, wind, theft, collision, etc.) |
| 15 | **Claim** | A demand by an insured or third party for payment under an insurance policy |
| 16 | **Claim Number** | A unique identifier assigned to each claim for tracking purposes |
| 17 | **Claims-Made Policy** | A policy that covers claims made (reported) during the policy period, regardless of when the loss occurred |
| 18 | **Claimant** | A person or entity making a claim for damages; may be the insured or a third party |
| 19 | **CLUE (Comprehensive Loss Underwriting Exchange)** | A LexisNexis database of consumer insurance claims history |
| 20 | **Coinsurance** | A provision requiring the insured to maintain coverage at a specified percentage of value; penalty applies if underinsured |
| 21 | **Collision Coverage** | Auto coverage for damage to the insured's vehicle caused by collision with another object |
| 22 | **Combined Ratio** | Loss ratio + expense ratio; measures underwriting profitability (below 100% = profit) |
| 23 | **Comparative Negligence** | A liability system where fault is apportioned among parties; damages reduced by claimant's percentage of fault |
| 24 | **Comprehensive Coverage** | Auto coverage for damage from non-collision events (theft, weather, animals, vandalism) |
| 25 | **Conditions** | Policy provisions that outline duties and obligations of both parties |
| 26 | **Contributory Negligence** | A liability system where a claimant who is even 1% at fault recovers nothing (used in few states) |
| 27 | **Coverage** | The scope of protection provided by an insurance policy |
| 28 | **Coverage Denial** | A formal determination that a loss is not covered under the policy |
| 29 | **Coverage Opinion** | A legal analysis of whether a particular loss is covered under the policy |
| 30 | **Declarations Page** | The page of the policy summarizing key information: named insured, policy period, coverages, limits, deductibles |
| 31 | **Deductible** | The amount the insured must pay out of pocket before insurance coverage applies |
| 32 | **Demand** | A formal request for payment from a claimant or their attorney |
| 33 | **Depreciation** | Reduction in value of property due to age, wear, and obsolescence |
| 34 | **Diary** | A scheduled follow-up date/reminder for the adjuster to review a claim |
| 35 | **Direct Repair Program (DRP)** | A network of repair shops with pre-negotiated rates and service agreements with the insurer |
| 36 | **Discovery Period** | In claims-made policies, an extended period after policy expiration during which claims can still be reported |
| 37 | **Dwelling Coverage** | Homeowners Coverage A; covers the physical structure of the home |
| 38 | **Earned Premium** | The portion of premium that corresponds to the expired portion of the policy period |
| 39 | **Endorsement** | A modification to the standard policy form that adds, removes, or changes coverage |
| 40 | **Examination Under Oath (EUO)** | A formal, sworn statement taken from the insured as a condition of the policy |
| 41 | **Excess Insurance** | Insurance that pays only after an underlying policy's limits have been exhausted |
| 42 | **Exclusion** | A policy provision that eliminates coverage for specific perils, property, or circumstances |
| 43 | **Experience Modification Rate (EMR)** | A workers' comp rating factor based on an employer's claim history relative to expected losses |
| 44 | **Exposure** | See Feature; also used to describe the potential for loss |
| 45 | **Extra Expense** | Coverage for expenses above normal to continue operations after a covered property loss |
| 46 | **Feature** | A coverage-claimant combination within a claim; the level at which reserves and payments are tracked |
| 47 | **First Party Claim** | A claim made by the insured against their own policy |
| 48 | **FNOL (First Notice of Loss)** | The initial report of a loss to the insurance company |
| 49 | **Fraud** | Intentional misrepresentation or deception to obtain insurance benefits |
| 50 | **General Aggregate** | The maximum total amount an insurer will pay for all covered losses during a policy period |
| 51 | **General Damages** | Non-economic damages such as pain and suffering, loss of consortium, emotional distress |
| 52 | **Good Faith** | The legal obligation of an insurer to deal fairly and honestly with its insureds |
| 53 | **Gross Reserve** | Total outstanding reserve amount before any anticipated recoveries |
| 54 | **Hold Harmless** | A contractual provision where one party assumes liability for the other |
| 55 | **IBNR (Incurred But Not Reported)** | An actuarial estimate of claims that have occurred but have not yet been reported to the insurer |
| 56 | **Indemnify** | To restore the insured to the financial position they were in before the loss |
| 57 | **Independent Adjuster (IA)** | A claims adjuster who works as an independent contractor, not as an employee of the insurer |
| 58 | **Independent Medical Examination (IME)** | A medical evaluation of a claimant by a physician chosen by the insurer |
| 59 | **Inland Marine** | Coverage for property in transit or movable property |
| 60 | **Insurable Interest** | A financial interest in property or a person that would be harmed by a loss |
| 61 | **Insuring Agreement** | The policy provision that states what the insurer agrees to do (the promise to pay) |
| 62 | **Inter-Company Arbitration** | A process for resolving subrogation disputes between insurance companies (e.g., Arbitration Forums) |
| 63 | **ISO** | Insurance Services Office (now Verisk); provides standard forms, rates, and data services |
| 64 | **Jurisdiction** | The state or territory whose laws govern the claim |
| 65 | **LAE (Loss Adjustment Expense)** | Costs incurred to investigate and settle claims (ALAE + ULAE) |
| 66 | **Liability** | Legal responsibility for damages or injuries |
| 67 | **Limit of Liability** | The maximum amount an insurer will pay under a coverage |
| 68 | **Litigation** | The process of resolving a claim through the court system |
| 69 | **Loss** | The amount of financial damage resulting from an insured event |
| 70 | **Loss Date** | The date on which the loss or occurrence happened |
| 71 | **Loss of Use** | Coverage for the inability to use property due to a covered loss (Coverage D in homeowners) |
| 72 | **Loss Payee** | A party (typically a mortgagee or lienholder) who is entitled to receive loss payments |
| 73 | **Loss Ratio** | Incurred losses divided by earned premium; measures claims cost relative to premium |
| 74 | **Loss Reserve** | The estimated amount that will be paid for a particular claim |
| 75 | **Material Damage** | Physical damage to property (vehicles, buildings, contents) |
| 76 | **MedPay (Medical Payments)** | Coverage that pays medical expenses for injuries regardless of fault |
| 77 | **Mitigation** | Actions taken to minimize further damage after a loss |
| 78 | **Named Peril** | A policy that covers only the perils specifically listed |
| 79 | **Negligence** | Failure to exercise reasonable care, resulting in damage or injury to another |
| 80 | **Net Incurred** | Total incurred losses minus recoveries (subrogation, salvage, reinsurance) |
| 81 | **No-Fault** | An auto insurance system where each party's own insurer pays regardless of who caused the accident |
| 82 | **Occurrence** | An accident or event, including continuous or repeated exposure to conditions, that results in loss |
| 83 | **Open Peril** | A policy that covers all perils except those specifically excluded (also called "Special" or "All-Risk") |
| 84 | **Other Insurance** | A policy condition addressing how coverage applies when multiple policies cover the same loss |
| 85 | **PCS (Property Claim Services)** | A Verisk unit that assigns catastrophe serial numbers and tracks insured losses |
| 86 | **Per Diem** | A method of calculating general damages by assigning a daily dollar value to pain and suffering |
| 87 | **Peril** | A cause of loss (fire, theft, windstorm, etc.) |
| 88 | **PIP (Personal Injury Protection)** | No-fault auto coverage for medical expenses, lost wages, and other benefits |
| 89 | **Policy Period** | The time frame during which the insurance policy provides coverage |
| 90 | **Proof of Loss** | A formal, sworn statement by the insured documenting the amount and circumstances of the loss |
| 91 | **Property Damage (PD)** | Physical injury to or destruction of tangible property |
| 92 | **Proximate Cause** | The direct cause of a loss; the event that sets the loss in motion without interruption |
| 93 | **Public Adjuster** | A licensed adjuster who represents the insured (not the insurer) in claim negotiations |
| 94 | **Punitive Damages** | Damages awarded to punish wrongful conduct; typically not insurable |
| 95 | **Recorded Statement** | A statement given by a party to the claim, recorded (usually audio) for documentation |
| 96 | **Recovery** | Money received back by the insurer through subrogation, salvage, or other means |
| 97 | **Reinsurance** | Insurance purchased by an insurer to transfer risk; impacts large/catastrophe claims |
| 98 | **Replacement Cost Value (RCV)** | The cost to replace damaged property with like kind and quality without deduction for depreciation |
| 99 | **Reservation of Rights (ROR)** | A letter from the insurer informing the insured that coverage questions exist; insurer will investigate but reserves the right to deny coverage |
| 100 | **Reserve** | The estimated amount set aside for future payment on a claim |
| 101 | **Retroactive Date** | In claims-made policies, the date before which occurrences are not covered |
| 102 | **Salvage** | The recovery of value from damaged property (e.g., selling a totaled vehicle) |
| 103 | **Schedule** | A list of specifically identified items covered under the policy (scheduled jewelry, vehicles, etc.) |
| 104 | **Self-Insured Retention (SIR)** | The amount the insured must pay before the insurer's coverage applies (differs from deductible in control of claim) |
| 105 | **SIU (Special Investigations Unit)** | Insurance company unit that investigates potentially fraudulent claims |
| 106 | **Special Damages** | Quantifiable economic damages: medical bills, lost wages, property repair costs |
| 107 | **Statute of Limitations** | The time period within which a lawsuit must be filed |
| 108 | **Straight-Through Processing (STP)** | Automated claim handling from FNOL to payment without human intervention |
| 109 | **Sublimit** | A limit within a coverage that caps payment for specific types of property or perils |
| 110 | **Subrogation** | The insurer's right to recover from a responsible third party after paying a claim |
| 111 | **Supplement** | An additional estimate or payment added to an existing claim after initial settlement |
| 112 | **Surplus Lines** | Insurance placed with non-admitted insurers for risks that admitted market won't cover |
| 113 | **Tail Coverage** | Extended reporting period coverage purchased after a claims-made policy terminates |
| 114 | **Third Party Claim** | A claim made by someone other than the insured against the insured's policy |
| 115 | **Total Loss** | When property is damaged beyond economical repair (ACV < repair cost) |
| 116 | **TPA (Third Party Administrator)** | An organization that handles claims on behalf of self-insured entities or insurers |
| 117 | **ULAE (Unallocated Loss Adjustment Expense)** | Claim handling expenses not attributable to a specific claim (e.g., adjuster salaries, office overhead) |
| 118 | **UM/UIM (Uninsured/Underinsured Motorist)** | Auto coverage protecting the insured when the at-fault party has no insurance or insufficient insurance |
| 119 | **Umbrella Policy** | Provides excess liability coverage above underlying policy limits |
| 120 | **Unfair Claims Settlement Practices** | State laws (based on NAIC model) prohibiting deceptive or unfair claim handling |
| 121 | **Valuation** | The process of determining the monetary value of a loss |
| 122 | **Void** | To cancel a payment (check void, stop payment) |
| 123 | **Waiver** | The voluntary relinquishment of a known right |
| 124 | **Workers' Compensation** | Statutory no-fault coverage for work-related injuries and illnesses |
| 125 | **Written Premium** | The total premium charged for policies written during a given period |

---

## 12. Architectural Considerations for Claims Systems

### 12.1 System Architecture Patterns

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CLAIMS SYSTEM - TARGET ARCHITECTURE               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │  Web Portal   │  │  Mobile App  │  │  Agent Portal│   CHANNELS   │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘              │
│         │                  │                  │                      │
│  ┌──────▼──────────────────▼──────────────────▼───────┐             │
│  │              API GATEWAY / BFF Layer                │             │
│  └──────────────────────┬─────────────────────────────┘             │
│                         │                                           │
│  ┌──────────────────────▼─────────────────────────────┐             │
│  │           CLAIMS MICROSERVICES / MODULES            │             │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────────┐  │             │
│  │  │  FNOL  │ │ Claims │ │Reserve │ │  Payment   │  │             │
│  │  │Service │ │Lifecycle│ │Service │ │  Service   │  │             │
│  │  └────────┘ └────────┘ └────────┘ └────────────┘  │             │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────────┐  │             │
│  │  │Activity│ │Document│ │ Party  │ │ Coverage   │  │             │
│  │  │Service │ │Service │ │Service │ │Verification│  │             │
│  │  └────────┘ └────────┘ └────────┘ └────────────┘  │             │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────────┐  │             │
│  │  │ Subrog │ │  SIU   │ │Vendor  │ │ Litigation │  │             │
│  │  │Service │ │Service │ │Mgmt    │ │ Management │  │             │
│  │  └────────┘ └────────┘ └────────┘ └────────────┘  │             │
│  └────────────────────────────────────────────────────┘             │
│                         │                                           │
│  ┌──────────────────────▼─────────────────────────────┐             │
│  │           BUSINESS RULES ENGINE                     │             │
│  │  (Assignment, Triage, Authority, Compliance)        │             │
│  └────────────────────────────────────────────────────┘             │
│                         │                                           │
│  ┌──────────────────────▼─────────────────────────────┐             │
│  │           EVENT BUS / MESSAGE BROKER                │             │
│  │  (Kafka, RabbitMQ, AWS EventBridge)                 │             │
│  └────────────────────────────────────────────────────┘             │
│                         │                                           │
│  ┌──────────────────────▼─────────────────────────────┐             │
│  │           INTEGRATION LAYER                         │             │
│  │  Policy Admin │ Billing │ Estimatics │ Vendors      │             │
│  │  ISO ClaimSearch │ NCCI EDI │ Payment Systems        │             │
│  └────────────────────────────────────────────────────┘             │
│                         │                                           │
│  ┌──────────────────────▼─────────────────────────────┐             │
│  │           DATA LAYER                                │             │
│  │  Operational DB │ Document Store │ Analytics DW      │             │
│  │  Search Index │ Cache │ Object Storage               │             │
│  └────────────────────────────────────────────────────┘             │
└─────────────────────────────────────────────────────────────────────┘
```

### 12.2 Key Design Decisions

| Decision Area | Options | Recommendation |
|---|---|---|
| Claim Number Generation | Sequential, GUID-based, policy-based prefix | Sequential with LOB prefix for readability + internal UUID |
| Feature Model | Flat (features at claim level) vs. Hierarchical (claim → sub-claim → feature) | Flat with feature-level reserves and payments |
| Reserve Tracking | Point-in-time snapshots vs. Transaction log | Transaction log (append-only) with materialized current view |
| Payment Processing | Real-time vs. Batch | Hybrid: real-time approval workflow, batch check/EFT disbursement |
| Business Rules | Hard-coded vs. Rules engine | Rules engine for configurable rules; hard-code only immutable logic |
| Document Management | Built-in vs. External ECM | External ECM (e.g., OnBase, FileNet) integrated via API |
| Search | RDBMS search vs. Search engine | Search engine (Elasticsearch/OpenSearch) for full-text claim search |
| Multi-tenancy | Single-tenant vs. Multi-tenant | Multi-tenant with tenant-level configuration for carrier groups |
| Workflow Engine | Custom vs. BPM platform | BPM platform (Camunda, Pega) for complex workflows; custom for simple |

### 12.3 Integration Points Summary

| Integration | Direction | Protocol | Purpose |
|---|---|---|---|
| Policy Admin System | Claims → PAS | REST API / ACORD XML | Policy verification, coverage details |
| Billing System | Claims → Billing | REST API | Premium status, payment coordination |
| CCC / Mitchell / Audatex | Bidirectional | Proprietary API / EMS | Auto damage estimates |
| Xactimate / Symbility | Bidirectional | Proprietary API | Property damage estimates |
| ISO ClaimSearch | Claims → ISO | ACORD XML / API | Claims history search, fraud detection |
| NCCI EDI | Claims → NCCI | X12 EDI | Workers' comp claims reporting |
| State DOI | Claims → State | Various (EDI, file, API) | Regulatory reporting |
| Payment Systems | Claims → Bank | ACH/Check/Wire | Disbursements |
| IRS | Claims → IRS | 1099 file | Tax reporting for payments |
| Reinsurance | Claims → RI | ACORD / Custom | Large loss notification, recoveries |
| Vendor Management | Bidirectional | REST API | Assignment, status, invoicing |
| Analytics / Data Warehouse | Claims → DW | ETL / CDC | Reporting, actuarial analysis |
| Correspondence | Claims → Print/Email | API | Letters, emails, notices |
| Telephony / IVR | Claims ← Phone | CTI / SIP | Inbound FNOL calls |
| Customer Portal | Bidirectional | REST API | Self-service claim status, FNOL |
| Agent Portal | Bidirectional | REST API | Agent claim submission, status |

### 12.4 Data Volumes and Performance Considerations

| Metric | Small Carrier | Mid-Size Carrier | Large Carrier |
|---|---|---|---|
| Annual New Claims | 10K-50K | 50K-500K | 500K-5M+ |
| Open Claims at Any Time | 5K-25K | 25K-200K | 200K-2M+ |
| Reserve Transactions/Year | 100K-500K | 500K-5M | 5M-50M+ |
| Payments/Year | 50K-250K | 250K-2M | 2M-20M+ |
| Documents/Year | 100K-1M | 1M-10M | 10M-100M+ |
| Notes/Year | 200K-2M | 2M-20M | 20M-200M+ |
| Peak FNOL Volume (CAT) | 100-500/day | 500-5K/day | 5K-50K/day |
| Concurrent Users | 50-200 | 200-2K | 2K-20K |

### 12.5 Security and Compliance Requirements

| Requirement | Detail |
|---|---|
| PII/PHI Protection | SSN, medical records, financial data must be encrypted at rest and in transit |
| HIPAA | Medical data in injury claims subject to HIPAA regulations |
| State Privacy Laws | CCPA, state-specific data protection requirements |
| Audit Trail | Every data change must be logged with user, timestamp, before/after values |
| Role-Based Access | SIU notes restricted; medical records restricted; financial authority by role |
| Data Retention | Claims data retention per state requirements (varies; some indefinite for long-tail) |
| Regulatory Reporting | State-specific claims data calls, NAIC reporting, market conduct exams |
| SOX Compliance | Financial controls for publicly traded carriers |
| Payment Controls | Segregation of duties for payment approval (maker/checker) |

---

*End of Article 1 — PnC Claims Domain: Complete Overview & Taxonomy*
