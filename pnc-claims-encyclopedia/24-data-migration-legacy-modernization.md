# Data Migration & Legacy System Modernization for Claims

## Table of Contents

1. [Legacy Claims System Landscape](#1-legacy-claims-system-landscape)
2. [Modernization Drivers and Business Case](#2-modernization-drivers-and-business-case)
3. [Modernization Strategies](#3-modernization-strategies)
4. [Strangler Fig Pattern for Claims](#4-strangler-fig-pattern-for-claims)
5. [Claims Data Migration Strategy](#5-claims-data-migration-strategy)
6. [Source System Analysis and Data Profiling](#6-source-system-analysis-and-data-profiling)
7. [Data Mapping Methodology](#7-data-mapping-methodology)
8. [Claims Data Migration Scope](#8-claims-data-migration-scope)
9. [ETL/ELT Pipeline Design](#9-etlelt-pipeline-design)
10. [Data Validation and Reconciliation](#10-data-validation-and-reconciliation)
11. [Migration Testing Strategy](#11-migration-testing-strategy)
12. [Cutover Planning](#12-cutover-planning)
13. [Co-existence Patterns](#13-co-existence-patterns)
14. [Legacy Integration Patterns](#14-legacy-integration-patterns)
15. [Common Migration Challenges](#15-common-migration-challenges)
16. [Post-Migration Validation and Support](#16-post-migration-validation-and-support)
17. [Claims Migration Data Model Mapping Templates](#17-claims-migration-data-model-mapping-templates)
18. [Migration Project Plan Template](#18-migration-project-plan-template)
19. [Risk Register for Claims Migration](#19-risk-register-for-claims-migration)
20. [Lessons Learned from Industry Migrations](#20-lessons-learned-from-industry-migrations)

---

## 1. Legacy Claims System Landscape

### 1.1 Common Legacy Platforms

```
LEGACY CLAIMS SYSTEM GENERATIONS:
+====================================================================+
|                                                                    |
|  MAINFRAME COBOL SYSTEMS (1970s-1990s)                             |
|  +--------------------------------------------------------------+  |
|  |  Characteristics:                                             |  |
|  |  ├── COBOL/CICS/IMS-DB or COBOL/CICS/DB2                     |  |
|  |  ├── VSAM files for data storage                              |  |
|  |  ├── JCL batch processing for nightly cycles                  |  |
|  |  ├── 3270 green screen terminal UI                            |  |
|  |  ├── Fixed-length record formats                              |  |
|  |  ├── Copybooks define data structures                         |  |
|  |  ├── Millions of lines of COBOL code                          |  |
|  |  ├── Business rules embedded in procedural code               |  |
|  |  └── Typically highly customized over decades                 |  |
|  |                                                               |  |
|  |  Common platforms:                                            |  |
|  |  ├── Custom-built COBOL systems (most large carriers)         |  |
|  |  ├── CSC (now DXC) Cyberlife/Vantage                          |  |
|  |  ├── AMS (Applied Microsystems) mainframe                     |  |
|  |  └── Various vendor mainframe systems                         |  |
|  |                                                               |  |
|  |  Data challenges:                                             |  |
|  |  ├── EBCDIC character encoding                                |  |
|  |  ├── Packed decimal numeric fields                            |  |
|  |  ├── Redefines/variant records                                |  |
|  |  ├── Hierarchical data (IMS segments)                         |  |
|  |  ├── No referential integrity enforcement                     |  |
|  |  └── Cryptic field names (6-8 character limits)               |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  AS/400 (IBM iSeries) SYSTEMS (1980s-2000s)                       |
|  +--------------------------------------------------------------+  |
|  |  Characteristics:                                             |  |
|  |  ├── RPG or COBOL on OS/400                                   |  |
|  |  ├── DB2/400 integrated database                              |  |
|  |  ├── 5250 terminal UI (green screen)                          |  |
|  |  ├── Record-level locking                                     |  |
|  |  ├── Physical/logical file architecture                       |  |
|  |  └── CL (Control Language) for job scheduling                 |  |
|  |                                                               |  |
|  |  Data challenges:                                             |  |
|  |  ├── Physical file structures (non-relational)                |  |
|  |  ├── Logical files as "views"                                 |  |
|  |  ├── DDS-defined data structures                              |  |
|  |  └── Packed/zoned decimal fields                              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  CLIENT-SERVER SYSTEMS (1990s-2000s)                               |
|  +--------------------------------------------------------------+  |
|  |  Characteristics:                                             |  |
|  |  ├── Visual Basic 6, PowerBuilder, Delphi, C++                |  |
|  |  ├── Oracle, SQL Server, Sybase databases                     |  |
|  |  ├── Windows desktop thick-client UI                          |  |
|  |  ├── Two-tier or three-tier architecture                      |  |
|  |  ├── COM/DCOM middleware                                      |  |
|  |  └── Crystal Reports for reporting                            |  |
|  |                                                               |  |
|  |  Common platforms:                                            |  |
|  |  ├── CCC Information Services (now CCC Intelligent Solutions) |  |
|  |  ├── Mitchell (now Enlyte)                                    |  |
|  |  ├── Valley Oak / Innovation Group                            |  |
|  |  ├── Custom VB/PowerBuilder systems                           |  |
|  |  └── Early Guidewire (ClaimCenter 2-4)                        |  |
|  |                                                               |  |
|  |  Data challenges:                                             |  |
|  |  ├── Denormalized database schemas                            |  |
|  |  ├── Stored procedures containing business logic              |  |
|  |  ├── Inconsistent data types across tables                    |  |
|  |  └── Client-side business rules (VB code)                     |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  EARLY WEB SYSTEMS (2000s-2010s)                                   |
|  +--------------------------------------------------------------+  |
|  |  Characteristics:                                             |  |
|  |  ├── Java EE (J2EE), .NET Framework                           |  |
|  |  ├── Oracle, SQL Server databases                             |  |
|  |  ├── JSP/Struts, ASP.NET WebForms UI                          |  |
|  |  ├── EJB or WCF service layers                                |  |
|  |  ├── SOAP web services                                        |  |
|  |  └── Application server: WebSphere, WebLogic, JBoss           |  |
|  |                                                               |  |
|  |  Common platforms:                                            |  |
|  |  ├── Guidewire ClaimCenter (5-8)                              |  |
|  |  ├── Duck Creek Claims                                        |  |
|  |  ├── Majesco Claims                                           |  |
|  |  ├── Insurity Claims                                          |  |
|  |  └── Custom Java/.NET systems                                 |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

---

## 2. Modernization Drivers and Business Case

### 2.1 Why Modernize

```
MODERNIZATION DRIVERS:
+------------------------------------------------------------------+
|                                                                  |
|  BUSINESS DRIVERS:                                               |
|  ├── Digital customer expectations (self-service, mobile)        |
|  ├── Speed to market for new products and coverages              |
|  ├── Regulatory compliance (new reporting requirements)          |
|  ├── Competitive pressure (insurtechs)                           |
|  ├── Analytics and AI capabilities                               |
|  ├── Merger/acquisition integration challenges                   |
|  └── Operational efficiency and automation                       |
|                                                                  |
|  TECHNOLOGY DRIVERS:                                             |
|  ├── End-of-support for legacy platforms (VB6, PowerBuilder)     |
|  ├── Mainframe talent shortage (aging workforce)                 |
|  ├── High mainframe operating costs (MIPS pricing)              |
|  ├── Security vulnerabilities in unsupported software            |
|  ├── Integration limitations (no APIs)                           |
|  ├── Cloud adoption benefits (scalability, cost, agility)        |
|  └── Data architecture limitations (siloed, redundant)           |
|                                                                  |
|  COST DRIVERS:                                                   |
|  ├── Mainframe MIPS costs: $1,000-$3,000+ per MIPS/month        |
|  ├── Legacy maintenance: 70-80% of IT budget on "keep lights on" |
|  ├── Integration costs: custom point-to-point connections         |
|  ├── Vendor lock-in: limited negotiating leverage                |
|  └── Technical debt: exponential cost of change                  |
|                                                                  |
+------------------------------------------------------------------+
```

### 2.2 Business Case Framework

```
ROI CALCULATION FOR CLAIMS MODERNIZATION:
+------------------------------------------------------------------+
|                                                                  |
|  COST CATEGORIES:                                                |
|  +------------------------------------------------------------+  |
|  | Category              | Typical Range                      |  |
|  +------------------------------------------------------------+  |
|  | Software license/sub  | $2M - $15M (depending on size)     |  |
|  | Implementation SI     | $10M - $50M+                       |  |
|  | Data migration        | $2M - $10M                         |  |
|  | Testing               | $1M - $5M                          |  |
|  | Training              | $500K - $2M                        |  |
|  | Change management     | $500K - $2M                        |  |
|  | Infrastructure/cloud  | $1M - $5M (first year)             |  |
|  | Contingency (20-30%)  | $3M - $15M                         |  |
|  | TOTAL                 | $20M - $100M+                      |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  BENEFIT CATEGORIES:                                             |
|  +------------------------------------------------------------+  |
|  | Category              | Typical Annual Benefit              |  |
|  +------------------------------------------------------------+  |
|  | Legacy cost reduction | $3M - $10M/year                    |  |
|  | Operational efficiency| $2M - $8M/year                     |  |
|  | Faster claim handling | $1M - $5M/year                     |  |
|  | Reduced leakage       | $2M - $10M/year                    |  |
|  | Improved subrogation  | $1M - $3M/year                     |  |
|  | Better fraud detect.  | $1M - $5M/year                     |  |
|  | Regulatory compliance | Risk mitigation (hard to quantify) |  |
|  | Customer retention    | $1M - $5M/year                     |  |
|  | TOTAL                 | $10M - $40M+/year                  |  |
|  +------------------------------------------------------------+  |
|                                                                  |
|  TYPICAL PAYBACK: 3-5 years                                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 3. Modernization Strategies

### 3.1 Strategy Comparison

```
MODERNIZATION STRATEGY COMPARISON:
+====================================================================+
|                                                                    |
|  STRATEGY          | DESCRIPTION         | RISK | DURATION | COST |
|  ══════════════════════════════════════════════════════════════════ |
|                                                                    |
|  BIG BANG           | Replace entire       | HIGH | 2-4 yrs  | $$$$ |
|  REPLACEMENT        | system at once       |      |          |      |
|  ├── All features built before cutover                             |
|  ├── Single cutover event                                          |
|  ├── Maximum risk: all-or-nothing                                  |
|  └── Requires extensive parallel testing                           |
|                                                                    |
|  PHASED /           | Incrementally        | MED  | 3-6 yrs  | $$$$+|
|  STRANGLER FIG      | replace components   |      |          |      |
|  ├── Build new capabilities around legacy                          |
|  ├── Gradually redirect traffic to new system                      |
|  ├── Legacy shrinks over time until decommissioned                 |
|  └── RECOMMENDED for most claims modernizations                    |
|                                                                    |
|  ENCAPSULATION      | Wrap legacy with     | LOW  | 1-2 yrs  | $$   |
|  (API WRAPPING)     | modern APIs          |      |          |      |
|  ├── Legacy continues processing                                   |
|  ├── New APIs expose legacy functionality                          |
|  ├── New digital channels connect via APIs                         |
|  └── Tactical: buys time but doesn't solve root problems          |
|                                                                    |
|  RE-PLATFORMING     | Move to modern       | MED  | 1-3 yrs  | $$$  |
|  (LIFT AND SHIFT)   | infrastructure       |      |          |      |
|  ├── Move legacy code to cloud/containers                          |
|  ├── Minimal code changes                                          |
|  ├── Modernize infrastructure, not application                     |
|  └── Reduces infra costs but carries forward tech debt             |
|                                                                    |
|  RE-HOSTING         | Move to new          | LOW  | 6-12 mos | $$   |
|  (LIFT AND SHIFT)   | hardware/cloud       |      |          |      |
|  ├── Move VMs or containers to cloud                               |
|  ├── No application changes                                        |
|  ├── Quick win for infrastructure modernization                    |
|  └── No business benefit beyond cost reduction                     |
|                                                                    |
+====================================================================+
```

---

## 4. Strangler Fig Pattern for Claims

### 4.1 Implementation Approach

```
STRANGLER FIG PATTERN FOR CLAIMS MODERNIZATION:
+====================================================================+
|                                                                    |
|  PHASE 1: COEXISTENCE FOUNDATION (Months 1-6)                     |
|  +--------------------------------------------------------------+  |
|  │                                                              │  |
|  │  ┌──────────┐    ┌───────────┐    ┌──────────────────┐      │  |
|  │  │ Channels │───>│ API       │───>│ LEGACY CLAIMS    │      │  |
|  │  │          │    │ Gateway   │    │ SYSTEM           │      │  |
|  │  └──────────┘    └───────────┘    └──────────────────┘      │  |
|  │                                                              │  |
|  │  Actions:                                                    │  |
|  │  ├── Deploy API gateway in front of legacy                   │  |
|  │  ├── Create API wrappers for legacy functions                │  |
|  │  ├── Implement event capture from legacy (CDC)               │  |
|  │  ├── Set up data synchronization infrastructure              │  |
|  │  └── Build integration layer                                 │  |
|  │                                                              │  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  PHASE 2: NEW FNOL (Months 6-12)                                   |
|  +--------------------------------------------------------------+  |
|  │                                                              │  |
|  │  ┌──────────┐    ┌───────────┐    ┌──────────┐              │  |
|  │  │ Digital  │───>│ API       │───>│ NEW FNOL │              │  |
|  │  │ Channels │    │ Gateway   │    │ SERVICE  │              │  |
|  │  └──────────┘    │           │    └────┬─────┘              │  |
|  │                  │           │         │                     │  |
|  │  ┌──────────┐    │           │    ┌────▼─────────────┐      │  |
|  │  │ Existing │───>│           │───>│ LEGACY CLAIMS    │      │  |
|  │  │ Channels │    │           │    │ SYSTEM           │      │  |
|  │  └──────────┘    └───────────┘    └──────────────────┘      │  |
|  │                                                              │  |
|  │  New FNOL service handles intake, then syncs to legacy       │  |
|  │  for claim handling until new handling is ready              │  |
|  │                                                              │  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  PHASE 3: NEW CLAIM HANDLING (Months 12-24)                        |
|  +--------------------------------------------------------------+  |
|  │                                                              │  |
|  │  ┌──────────┐    ┌───────────┐    ┌──────────────────┐      │  |
|  │  │ All      │───>│ API       │───>│ NEW CLAIMS       │      │  |
|  │  │ Channels │    │ Gateway   │    │ PLATFORM         │      │  |
|  │  └──────────┘    │           │    │ (new claims)     │      │  |
|  │                  │           │    └──────────────────┘      │  |
|  │                  │           │    ┌──────────────────┐      │  |
|  │                  │           │───>│ LEGACY CLAIMS    │      │  |
|  │                  │           │    │ (existing claims) │      │  |
|  │                  └───────────┘    └──────────────────┘      │  |
|  │                                                              │  |
|  │  New claims go to new platform                               │  |
|  │  Existing open claims remain in legacy                       │  |
|  │  Data sync between systems                                   │  |
|  │                                                              │  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  PHASE 4: FULL MIGRATION (Months 24-36)                            |
|  +--------------------------------------------------------------+  |
|  │                                                              │  |
|  │  ┌──────────┐    ┌───────────┐    ┌──────────────────┐      │  |
|  │  │ All      │───>│ API       │───>│ NEW CLAIMS       │      │  |
|  │  │ Channels │    │ Gateway   │    │ PLATFORM         │      │  |
|  │  └──────────┘    └───────────┘    │ (all claims)     │      │  |
|  │                                   └──────────────────┘      │  |
|  │                                                              │  |
|  │                  ┌──────────────────┐                        │  |
|  │                  │ LEGACY           │  DECOMMISSIONED        │  |
|  │                  │ (archived)       │                        │  |
|  │                  └──────────────────┘                        │  |
|  │                                                              │  |
|  │  All open claims migrated to new platform                    │  |
|  │  Legacy archived for historical reference                    │  |
|  │  Legacy system decommissioned                                │  |
|  │                                                              │  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

### 4.2 Routing Logic

```
API GATEWAY ROUTING DURING STRANGLER MIGRATION:
+------------------------------------------------------------------+
|                                                                  |
|  ROUTING RULES:                                                  |
|                                                                  |
|  // FNOL submission                                              |
|  IF request.path == "/fnol" AND phase >= 2:                      |
|    route → new-fnol-service                                      |
|  ELSE:                                                           |
|    route → legacy-api-wrapper                                    |
|                                                                  |
|  // Claim operations                                             |
|  IF request.path == "/claims/{id}" :                             |
|    claim = lookup(id)                                            |
|    IF claim.system == "NEW":                                     |
|      route → new-claim-service                                   |
|    ELSE:                                                         |
|      route → legacy-api-wrapper                                  |
|                                                                  |
|  // New claim creation (phase 3+)                                |
|  IF request.path == "/claims" AND method == POST AND phase >= 3: |
|    route → new-claim-service                                     |
|                                                                  |
|  // Search (aggregated)                                          |
|  IF request.path == "/claims/search":                            |
|    results = merge(                                              |
|      new-search-service.search(query),                           |
|      legacy-search-adapter.search(query)                         |
|    )                                                             |
|    return results                                                |
|                                                                  |
|  CLAIM REGISTRY:                                                 |
|  +------------------------------------------------------------+  |
|  | claim_id | system  | migrated_date | legacy_id             |  |
|  +------------------------------------------------------------+  |
|  | CLM-001  | LEGACY  | null          | L-12345               |  |
|  | CLM-002  | NEW     | null          | null (born in new)    |  |
|  | CLM-003  | NEW     | 2025-06-15    | L-67890 (migrated)    |  |
|  +------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 5. Claims Data Migration Strategy

### 5.1 Migration Approach Selection

```
DATA MIGRATION APPROACHES:
+------------------------------------------------------------------+
|                                                                  |
|  APPROACH 1: BIG BANG DATA MIGRATION                             |
|  ├── All data migrated in one weekend/cutover window             |
|  ├── Requires complete data readiness before cutover             |
|  ├── High risk but clean cutover                                 |
|  └── Suitable for smaller books of business (< 50K claims)      |
|                                                                  |
|  APPROACH 2: PHASED DATA MIGRATION                               |
|  ├── Data migrated in waves by LOB, state, or claim type         |
|  ├── Each wave has its own testing and validation                |
|  ├── Reduces risk but extends co-existence period                |
|  └── RECOMMENDED for most claims migrations                      |
|                                                                  |
|  APPROACH 3: TRICKLE MIGRATION                                   |
|  ├── Claims migrated individually as they are touched            |
|  ├── When adjuster opens claim in new system, it's migrated     |
|  ├── No formal cutover window                                    |
|  ├── Long co-existence but very low risk                         |
|  └── Suitable for long-tail claims                               |
|                                                                  |
|  APPROACH 4: BORN-IN-NEW + GRADUAL MIGRATION                    |
|  ├── New claims enter new system from day 1                      |
|  ├── Open claims migrated in waves                               |
|  ├── Closed claims archived or summary-migrated                  |
|  └── RECOMMENDED combined with strangler fig                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 6. Source System Analysis and Data Profiling

### 6.1 Data Quality Assessment Framework

```
DATA QUALITY DIMENSIONS:
+------------------------------------------------------------------+
|                                                                  |
|  COMPLETENESS:                                                   |
|  ├── What percentage of required fields are populated?           |
|  ├── Which fields have high null/blank rates?                    |
|  ├── Are there claims missing critical data elements?            |
|  └── Tools: SQL queries, profiling scripts                       |
|                                                                  |
|  ACCURACY:                                                       |
|  ├── Are values within expected ranges?                          |
|  ├── Do dates make logical sense (DOL < report date < today)?   |
|  ├── Are financial values consistent (paid + OS = incurred)?     |
|  └── Are code values valid (state codes, LOB codes)?             |
|                                                                  |
|  CONSISTENCY:                                                    |
|  ├── Are the same entities represented the same way?             |
|  ├── Are there conflicting records across tables?                |
|  ├── Do cross-references match (FK integrity)?                   |
|  └── Are business rules consistently applied?                    |
|                                                                  |
|  TIMELINESS:                                                     |
|  ├── Is the data up-to-date?                                    |
|  ├── Are there stale records that should have been updated?      |
|  └── How often is data refreshed?                                |
|                                                                  |
|  UNIQUENESS:                                                     |
|  ├── Are there duplicate claims?                                 |
|  ├── Are there duplicate parties/contacts?                       |
|  └── Can unique keys be reliably identified?                     |
|                                                                  |
+------------------------------------------------------------------+
```

### 6.2 Common Data Quality Issues

```
TYPICAL LEGACY CLAIMS DATA ISSUES:
+------------------------------------------------------------------+
| Issue                      | Frequency | Impact | Mitigation      |
+------------------------------------------------------------------+
| Missing SSN/FEIN           | 5-15%     | High   | Default/lookup  |
| Invalid state codes        | 1-3%      | Medium | Code translation|
| Orphaned payments          | 2-5%      | High   | Manual mapping  |
| Duplicate claimants        | 10-20%    | Medium | Dedup algorithm |
| Inconsistent date formats  | 5-10%     | Medium | Parse/normalize |
| Missing policy reference   | 3-8%      | High   | Cross-reference |
| Incorrect reserves (neg)   | 1-2%      | High   | Business rules  |
| Missing injury codes       | 5-15%     | Medium | Default mapping |
| Truncated descriptions     | 10-20%    | Low    | Accept as-is    |
| Non-standard codes         | 5-15%     | Medium | Translation tbl |
| Historical code changes    | Varies    | Medium | Version mapping |
| Missing financial history  | 2-5%      | High   | GL reconcile    |
| Denormalized redundancy    | 20-40%    | Medium | Normalization   |
+------------------------------------------------------------------+
```

### 6.3 Data Profiling Approach

```sql
-- SAMPLE DATA PROFILING QUERIES:

-- 1. Completeness analysis for claims table
SELECT
  COUNT(*) as total_records,
  COUNT(claim_number) as has_claim_number,
  COUNT(policy_number) as has_policy_number,
  COUNT(date_of_loss) as has_dol,
  COUNT(claimant_ssn) as has_ssn,
  COUNT(adjuster_code) as has_adjuster,
  COUNT(cause_of_loss) as has_cause,
  ROUND(100.0 * COUNT(claimant_ssn) / COUNT(*), 2) as ssn_pct,
  ROUND(100.0 * COUNT(policy_number) / COUNT(*), 2) as policy_pct
FROM legacy_claims;

-- 2. Date validity check
SELECT
  COUNT(*) as total,
  COUNT(CASE WHEN date_of_loss > CURRENT_DATE THEN 1 END) as future_dol,
  COUNT(CASE WHEN date_of_loss < '1950-01-01' THEN 1 END) as ancient_dol,
  COUNT(CASE WHEN date_reported < date_of_loss THEN 1 END) as report_before_dol,
  COUNT(CASE WHEN date_closed < date_of_loss THEN 1 END) as closed_before_dol
FROM legacy_claims;

-- 3. Financial consistency check
SELECT
  claim_number,
  total_paid,
  total_reserved,
  total_incurred,
  (total_paid + total_reserved) as calculated_incurred,
  (total_paid + total_reserved) - total_incurred as variance
FROM legacy_claims
WHERE ABS((total_paid + total_reserved) - total_incurred) > 1.00;

-- 4. Code value distribution
SELECT
  cause_of_loss_code,
  COUNT(*) as claim_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) as pct
FROM legacy_claims
GROUP BY cause_of_loss_code
ORDER BY claim_count DESC;

-- 5. Orphan detection (payments without valid claims)
SELECT p.*
FROM legacy_payments p
LEFT JOIN legacy_claims c ON p.claim_number = c.claim_number
WHERE c.claim_number IS NULL;
```

---

## 7. Data Mapping Methodology

### 7.1 Source-to-Target Mapping Document

```
SOURCE-TO-TARGET MAPPING TEMPLATE:
+====================================================================+
| Map ID | Source Table | Source Field  | Target Table | Target Field |
|        | (Legacy)     | (Legacy)      | (New System) | (New System) |
+====================================================================+
| M-001  | CLMMASTER    | CLM-NBR       | claim        | claim_number |
| M-002  | CLMMASTER    | POL-NBR       | claim        | policy_id    |
|        |              |               |              | (FK lookup)  |
| M-003  | CLMMASTER    | DOL-DT        | claim        | date_of_loss |
|        |              | (YYYYMMDD)    |              | (DATE ISO)   |
| M-004  | CLMMASTER    | RPT-DT        | claim        | date_reported|
| M-005  | CLMMASTER    | CLM-STS       | claim        | claim_status |
|        |              | (O/C/R/D)     |              | (OPEN/CLOSED |
|        |              |               |              |  /REOPEN/DENY)|
| M-006  | CLMMASTER    | LOB-CD        | claim        | lob_code     |
|        |              | (01/02/03)    |              | (AUTO/PROP/  |
|        |              |               |              |  GL)         |
| M-007  | CLMMASTER    | ADJ-CD        | claim        | adjuster_id  |
|        |              |               |              | (FK lookup)  |
| M-008  | CLMMASTER    | TOT-PD-LS     | claim        | total_paid_  |
|        |              | (packed 9,2)  |              | loss(decimal)|
| M-009  | CLMMASTER    | TOT-PD-EX     | claim        | total_paid_  |
|        |              | (packed 9,2)  |              | expense      |
| M-010  | CLMMASTER    | TOT-OS-LS     | claim        | total_reserve|
|        |              | (packed 9,2)  |              | _loss        |
+====================================================================+

TRANSFORMATION RULES:
+====================================================================+
| Map ID | Rule                                                      |
+====================================================================+
| M-002  | Lookup policy_id from new policy table using legacy       |
|        | POL-NBR. If not found, create orphan reference record.   |
| M-003  | Convert YYYYMMDD to ISO date format (YYYY-MM-DD).        |
|        | If invalid date, set to '1900-01-01' and flag for review.|
| M-005  | Code translation: O→OPEN, C→CLOSED, R→REOPENED, D→DENIED |
|        | If code not in set, default to OPEN and flag for review. |
| M-006  | Code translation: 01→AUTO, 02→PROPERTY, 03→GL,           |
|        | 04→WC, 05→PROF_LIAB. Unknown codes → flag for review.   |
| M-007  | Lookup adjuster_id from new user table using legacy       |
|        | ADJ-CD. If not found, assign to 'UNASSIGNED' pool.      |
| M-008  | Convert packed decimal to standard decimal. If negative   |
|        | and claim is open, flag for review.                      |
+====================================================================+
```

### 7.2 Code/Value Translation Tables

```
SAMPLE CODE TRANSLATION TABLE:
+------------------------------------------------------------------+
| Legacy System | Legacy Code | New System  | New Code              |
+------------------------------------------------------------------+
| CLAIM STATUS  | O           | claim_status| OPEN                  |
|               | C           |             | CLOSED                |
|               | R           |             | REOPENED              |
|               | D           |             | DENIED                |
|               | P           |             | OPEN (map to OPEN)    |
|               | V           |             | VOID                  |
+------------------------------------------------------------------+
| LINE OF BUS   | 01          | lob_code    | PERSONAL_AUTO         |
|               | 02          |             | HOMEOWNERS            |
|               | 03          |             | COMMERCIAL_PROPERTY   |
|               | 04          |             | COMMERCIAL_GL         |
|               | 05          |             | WORKERS_COMP          |
|               | 06          |             | COMMERCIAL_AUTO       |
|               | 07          |             | UMBRELLA              |
|               | 08          |             | PROFESSIONAL_LIAB     |
+------------------------------------------------------------------+
| CAUSE OF LOSS | 01          | cause_code  | FIRE                  |
|               | 02          |             | WATER_DAMAGE          |
|               | 03          |             | THEFT                 |
|               | 04          |             | COLLISION             |
|               | 05          |             | WIND_HAIL             |
|               | 06          |             | SLIP_FALL             |
|               | 07          |             | PRODUCT_DEFECT        |
|               | 99          |             | OTHER                 |
+------------------------------------------------------------------+
| BODY PART     | HD          | body_part   | HEAD                  |
|               | NK          |             | NECK                  |
|               | UB          |             | UPPER_BACK            |
|               | LB          |             | LOWER_BACK            |
|               | RS          |             | RIGHT_SHOULDER        |
|               | LS          |             | LEFT_SHOULDER         |
|               | RK          |             | RIGHT_KNEE            |
|               | LK          |             | LEFT_KNEE             |
|               | ML          |             | MULTIPLE              |
+------------------------------------------------------------------+
```

---

## 8. Claims Data Migration Scope

### 8.1 What to Migrate vs Archive

```
MIGRATION SCOPE DECISION MATRIX:
+====================================================================+
|                                                                    |
|  FULL MIGRATION (to new system with complete data):                |
|  +--------------------------------------------------------------+  |
|  | Category              | Criteria                              |  |
|  +--------------------------------------------------------------+  |
|  | Open claims           | ALL open claims regardless of age     |  |
|  | Recently closed       | Closed within last 3-5 years          |  |
|  | High-value closed     | Closed with incurred > $100K          |  |
|  | Litigated closed      | Closed with litigation history        |  |
|  | Subrogation active    | Claims with pending recoveries        |  |
|  | Reopenable claims     | Within statutory reopening period     |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  SUMMARY MIGRATION (header + financials, minimal detail):          |
|  +--------------------------------------------------------------+  |
|  | Category              | Criteria                              |  |
|  +--------------------------------------------------------------+  |
|  | Older closed claims   | Closed 5-10 years ago                 |  |
|  | Low-value closed      | Closed with incurred < $25K           |  |
|  | Denied claims         | Denied claims > 2 years old           |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  ARCHIVE ONLY (read-only access, not in new system):               |
|  +--------------------------------------------------------------+  |
|  | Category              | Criteria                              |  |
|  +--------------------------------------------------------------+  |
|  | Very old closed claims| Closed > 10 years ago                 |  |
|  | Voided/duplicate      | Voided or duplicate claims            |  |
|  | Document images only  | No structured data needed             |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  VOLUME ESTIMATION EXAMPLE:                                        |
|  +--------------------------------------------------------------+  |
|  | Category          | Count    | % of Total | Migration Type    |  |
|  +--------------------------------------------------------------+  |
|  | Open claims       | 25,000   | 2.5%       | Full              |  |
|  | Closed < 3 years  | 150,000  | 15%        | Full              |  |
|  | Closed 3-5 years  | 200,000  | 20%        | Full              |  |
|  | Closed 5-10 years | 350,000  | 35%        | Summary           |  |
|  | Closed > 10 years | 275,000  | 27.5%      | Archive           |  |
|  | TOTAL             | 1,000,000| 100%       |                   |  |
|  +--------------------------------------------------------------+  |
|  | Full migration: 375,000 claims                                |  |
|  | Summary migration: 350,000 claims                             |  |
|  | Archive only: 275,000 claims                                  |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

### 8.2 Data Entities to Migrate

```
MIGRATION SCOPE BY ENTITY:
+------------------------------------------------------------------+
| Entity              | Full Migrate | Summary | Archive | Notes    |
+------------------------------------------------------------------+
| Claim header        | ✓            | ✓       | ✓       |          |
| Claimant/parties    | ✓            | ✓ (name)| ✗       |          |
| Exposures/coverages | ✓            | ✗       | ✗       |          |
| Reserves (current)  | ✓            | ✓       | ✗       |          |
| Reserve history     | ✓            | ✗       | ✗       | 2yr hist |
| Payments            | ✓            | ✓ (sum) | ✗       |          |
| Payment details     | ✓            | ✗       | ✗       |          |
| Recoveries          | ✓            | ✓ (sum) | ✗       |          |
| Activities/notes    | ✓            | ✗       | ✗       | Last 2yr |
| Documents           | ✓            | ✗       | ✓ (ref) | Key docs |
| Diary entries       | ✓ (open)     | ✗       | ✗       |          |
| Attorney info       | ✓            | ✗       | ✗       |          |
| Medical records(WC) | ✓            | ✗       | ✗       |          |
| Subrogation data    | ✓            | ✗       | ✗       |          |
| Reinsurance data    | ✓            | ✓       | ✗       |          |
| Adjuster assignment | ✓            | ✗       | ✗       |          |
| Financial summary   | ✓            | ✓       | ✓       |          |
+------------------------------------------------------------------+
```

---

## 9. ETL/ELT Pipeline Design

### 9.1 Pipeline Architecture

```
ETL PIPELINE ARCHITECTURE:
+====================================================================+
|                                                                    |
|  SOURCE SYSTEMS                                                    |
|  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐             |
|  │Mainframe │ │ AS/400   │ │SQL Server│ │ Files/   │             |
|  │ (COBOL)  │ │ (RPG)    │ │ (VB app) │ │ Images   │             |
|  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘             |
|       │             │             │             │                   |
|       ▼             ▼             ▼             ▼                   |
|  ┌─────────────────────────────────────────────────────┐           |
|  │              EXTRACTION LAYER                        │           |
|  │  ├── COBOL copybook parser → flat file extract       │           |
|  │  ├── AS/400 ODBC → SQL extract                       │           |
|  │  ├── SQL Server → database link / CDC                │           |
|  │  ├── File system scan → document inventory            │           |
|  │  └── Output: staging area (raw data lake)             │           |
|  └──────────────────────┬──────────────────────────────┘           |
|                         │                                          |
|                         ▼                                          |
|  ┌─────────────────────────────────────────────────────┐           |
|  │              STAGING AREA (Landing Zone)              │           |
|  │  ├── Raw extracted data (no transformations)          │           |
|  │  ├── Stored as-is for audit and reprocessing          │           |
|  │  ├── Profiling and validation scripts run here        │           |
|  │  └── Storage: S3 / Azure Blob / staging database      │           |
|  └──────────────────────┬──────────────────────────────┘           |
|                         │                                          |
|                         ▼                                          |
|  ┌─────────────────────────────────────────────────────┐           |
|  │              TRANSFORMATION LAYER                    │           |
|  │  ├── Data type conversions (EBCDIC, packed decimal)   │           |
|  │  ├── Code translation (legacy→new system codes)       │           |
|  │  ├── Data enrichment (lookups, defaults)              │           |
|  │  ├── Data cleansing (invalid values, nulls)           │           |
|  │  ├── Deduplication                                    │           |
|  │  ├── Relationship resolution (FK mapping)             │           |
|  │  ├── Financial reconciliation checks                  │           |
|  │  └── Business rule validation                         │           |
|  └──────────────────────┬──────────────────────────────┘           |
|                         │                                          |
|                         ▼                                          |
|  ┌─────────────────────────────────────────────────────┐           |
|  │              LOAD LAYER                              │           |
|  │  ├── Bulk load to target database                     │           |
|  │  ├── Referential integrity validation                 │           |
|  │  ├── Index creation after bulk load                   │           |
|  │  ├── Sequence/ID generation                           │           |
|  │  └── Post-load validation                             │           |
|  └──────────────────────┬──────────────────────────────┘           |
|                         │                                          |
|                         ▼                                          |
|  ┌─────────────────────────────────────────────────────┐           |
|  │              TARGET SYSTEM                           │           |
|  │  New Claims Platform (PostgreSQL)                     │           |
|  └─────────────────────────────────────────────────────┘           |
|                                                                    |
+====================================================================+
```

### 9.2 Pipeline Orchestration

```
ORCHESTRATION WITH APACHE AIRFLOW:
+------------------------------------------------------------------+
|                                                                  |
|  DAG: claims_migration_pipeline                                  |
|                                                                  |
|  [extract_mainframe] → [extract_as400] → [extract_sql_server]   |
|         ↓                    ↓                    ↓               |
|  [stage_mainframe]    [stage_as400]      [stage_sql_server]      |
|         ↓                    ↓                    ↓               |
|  [profile_data] ←───────────┴────────────────────┘               |
|         ↓                                                        |
|  [validate_source_data]                                          |
|         ↓                                                        |
|  <quality_gate> ──FAIL──→ [alert_team] → [halt_pipeline]        |
|         │ PASS                                                   |
|         ▼                                                        |
|  [transform_claims] → [transform_parties] → [transform_payments]|
|         ↓                    ↓                    ↓               |
|  [transform_reserves] → [transform_documents] → [transform_notes]|
|         ↓                                                        |
|  [load_parties]     (load in dependency order)                   |
|         ↓                                                        |
|  [load_claims]                                                   |
|         ↓                                                        |
|  [load_reserves]                                                 |
|         ↓                                                        |
|  [load_payments]                                                 |
|         ↓                                                        |
|  [load_documents]                                                |
|         ↓                                                        |
|  [post_load_validation]                                          |
|         ↓                                                        |
|  [reconciliation_report]                                         |
|         ↓                                                        |
|  [notify_team]                                                   |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 10. Data Validation and Reconciliation

### 10.1 Reconciliation Framework

```
RECONCILIATION LAYERS:
+====================================================================+
|                                                                    |
|  LEVEL 1: RECORD COUNT RECONCILIATION                              |
|  +--------------------------------------------------------------+  |
|  | Source Table      | Source Count | Target Count | Variance    |  |
|  +--------------------------------------------------------------+  |
|  | Claims            | 375,000      | 375,000      | 0 (0.00%)  |  |
|  | Parties           | 520,000      | 518,500      | -1,500*    |  |
|  | Reserves          | 450,000      | 450,000      | 0 (0.00%)  |  |
|  | Payments          | 1,200,000    | 1,199,850    | -150*      |  |
|  | Documents         | 2,500,000    | 2,500,000    | 0 (0.00%)  |  |
|  | Notes/Activities  | 5,000,000    | 4,998,000    | -2,000*    |  |
|  +--------------------------------------------------------------+  |
|  | * Variances explained: duplicates removed, orphans excluded   |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  LEVEL 2: FINANCIAL RECONCILIATION                                 |
|  +--------------------------------------------------------------+  |
|  | Metric              | Source       | Target       | Variance  |  |
|  +--------------------------------------------------------------+  |
|  | Total Paid Loss     | $450,000,000 | $450,000,000 | $0.00     |  |
|  | Total Paid ALAE     | $85,000,000  | $85,000,000  | $0.00     |  |
|  | Total O/S Loss Res  | $125,000,000 | $125,000,000 | $0.00     |  |
|  | Total O/S ALAE Res  | $22,000,000  | $22,000,000  | $0.00     |  |
|  | Total Incurred      | $682,000,000 | $682,000,000 | $0.00     |  |
|  | Total Recoveries    | $35,000,000  | $35,000,000  | $0.00     |  |
|  | Net Incurred        | $647,000,000 | $647,000,000 | $0.00     |  |
|  +--------------------------------------------------------------+  |
|  | TOLERANCE: $0.00 variance for financials (must be exact)      |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  LEVEL 3: BUSINESS RULE VALIDATION                                 |
|  +--------------------------------------------------------------+  |
|  | Rule                              | Pass  | Fail | % Pass    |  |
|  +--------------------------------------------------------------+  |
|  | Open claims have reserves > 0     | 24,800| 200  | 99.2%     |  |
|  | Closed claims have $0 O/S reserve  | 349,500| 500 | 99.9%     |  |
|  | Paid ≤ Incurred for all claims     | 374,900| 100 | 99.97%    |  |
|  | DOL ≤ Report Date ≤ Today          | 374,000| 1,000| 99.73%   |  |
|  | All claims have valid LOB code      | 375,000| 0   | 100.0%   |  |
|  | All open claims have adjuster       | 24,950| 50   | 99.8%    |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  LEVEL 4: SAMPLE-BASED MANUAL VERIFICATION                        |
|  +--------------------------------------------------------------+  |
|  | Sample Size | Method    | Verified By | Findings              |  |
|  +--------------------------------------------------------------+  |
|  | 100 open    | Random    | Adjusters   | 3 data issues found   |  |
|  | 50 large    | Targeted  | Supervisors | 1 reserve discrepancy |  |
|  | 25 litigated| Targeted  | Legal       | All verified correct  |  |
|  | 50 WC       | Random    | WC team     | 2 code mapping issues |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

---

## 11. Migration Testing Strategy

### 11.1 Testing Layers

```
MIGRATION TESTING PYRAMID:
+------------------------------------------------------------------+
|                                                                  |
|              /\                                                  |
|             /  \                                                 |
|            / UAT \     User Acceptance Testing                   |
|           / (50+  \    Adjusters test real claims                |
|          / claims) \   in new system                             |
|         /──────────\                                             |
|        / Performance \   Full volume load testing                |
|       /  Testing      \  Concurrent user simulation              |
|      /  (full dataset) \                                        |
|     /──────────────────\                                        |
|    / Integration Testing \  End-to-end migration pipeline       |
|   /  (1000 claims sample) \ Cross-system data validation        |
|  /────────────────────────\                                     |
| / Unit Testing of           \  Individual transformation rules  |
|/  Transformations (per rule) \  Code translation tables         |
|──────────────────────────────                                   |
|                                                                  |
+------------------------------------------------------------------+
```

### 11.2 Test Scenarios

```
MIGRATION TEST CASE CATEGORIES:
+------------------------------------------------------------------+
|                                                                  |
|  TRANSFORMATION UNIT TESTS:                                      |
|  ├── Date format conversion (all edge cases)                     |
|  ├── Code translation (every legacy code mapped correctly)       |
|  ├── Numeric conversion (packed decimal, signed, overflow)       |
|  ├── Name parsing (split combined name fields)                   |
|  ├── Address standardization                                     |
|  ├── Financial calculation verification                          |
|  └── Null/default handling for each field                        |
|                                                                  |
|  INTEGRATION TESTS:                                              |
|  ├── Full claim migration (all related entities)                 |
|  ├── Cross-reference integrity (claim→policy, claim→party)       |
|  ├── Financial rollup verification (detail→summary)              |
|  ├── Document link verification (migrated docs accessible)       |
|  └── Reinsurance allocation verification                         |
|                                                                  |
|  EDGE CASE TESTS:                                                |
|  ├── Claims with maximum number of payments (500+)              |
|  ├── Claims with zero reserves                                   |
|  ├── Claims spanning multiple policy periods                     |
|  ├── Claims with complex party relationships                     |
|  ├── WC claims with multiple injury codes                        |
|  ├── Claims with negative recoveries                             |
|  ├── Claims with missing required fields                         |
|  └── Claims with non-standard characters in text fields          |
|                                                                  |
|  USER ACCEPTANCE TESTS:                                          |
|  ├── Adjuster can find migrated claim                            |
|  ├── All claim detail displays correctly                         |
|  ├── Financial summary matches legacy                            |
|  ├── Documents are accessible                                    |
|  ├── Notes and history are readable                              |
|  ├── Adjuster can continue handling migrated claim               |
|  ├── Payments can be made on migrated claims                     |
|  └── Reports include migrated claim data correctly               |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 12. Cutover Planning

### 12.1 Cutover Timeline

```
CUTOVER WEEKEND TIMELINE (Big Bang Example):
+====================================================================+
|                                                                    |
|  FRIDAY 6:00 PM - SUNDAY 11:00 PM                                 |
|                                                                    |
|  FRIDAY:                                                           |
|  18:00  Legacy system access restricted (read-only)                |
|  18:30  Final extract from legacy system initiated                 |
|  19:00  Incremental delta extract (changes since last full run)    |
|  20:00  Delta extraction complete                                  |
|  20:30  Delta transformation pipeline started                      |
|  22:00  Delta transformation complete                              |
|  22:30  Delta load to target system initiated                      |
|  23:30  Delta load complete                                        |
|  23:45  Post-load validation scripts started                       |
|                                                                    |
|  SATURDAY:                                                         |
|  01:00  Level 1 reconciliation (record counts) complete            |
|  02:00  Level 2 reconciliation (financials) complete               |
|  03:00  Level 3 reconciliation (business rules) complete           |
|  04:00  ─── GO/NO-GO DECISION POINT #1 ───                        |
|         Review reconciliation results                              |
|         Decision: PROCEED or ROLLBACK                              |
|  06:00  System integration testing (payments, documents)           |
|  08:00  Integration testing complete                               |
|  09:00  Smoke testing by claims team leads                         |
|  12:00  Smoke testing complete                                     |
|  13:00  ─── GO/NO-GO DECISION POINT #2 ───                        |
|         Review all test results                                    |
|         Decision: PROCEED or ROLLBACK                              |
|  14:00  DNS/routing switch to new system                           |
|  14:30  External integrations activated (EDI, vendors)             |
|  15:00  Monitoring activated                                       |
|                                                                    |
|  SUNDAY:                                                           |
|  09:00  Extended team testing                                      |
|  14:00  ─── GO/NO-GO DECISION POINT #3 ───                        |
|         Final decision: PROCEED or ROLLBACK                        |
|  15:00  If PROCEED: legacy system access terminated                |
|  15:00  If ROLLBACK: revert DNS, restore legacy                    |
|                                                                    |
|  MONDAY:                                                           |
|  06:00  War room staffed for go-live support                       |
|  07:00  Users begin accessing new system                           |
|  07:00  Hyper-care support period begins (2-4 weeks)              |
|                                                                    |
+====================================================================+
```

### 12.2 Rollback Plan

```
ROLLBACK SCENARIOS AND PROCEDURES:
+------------------------------------------------------------------+
|                                                                  |
|  TRIGGER CONDITIONS FOR ROLLBACK:                                |
|  ├── Financial reconciliation variance > $10,000                 |
|  ├── Record count discrepancy > 0.5%                             |
|  ├── Critical business rule failures > 1%                        |
|  ├── System performance below acceptable thresholds              |
|  ├── Integration failures (payments, EDI)                        |
|  └── Executive decision (risk too high)                          |
|                                                                  |
|  ROLLBACK PROCEDURE:                                             |
|  ├── 1. Decision made by migration lead + business sponsor       |
|  ├── 2. Notify all stakeholders (email blast)                    |
|  ├── 3. Revert DNS/routing to legacy system                      |
|  ├── 4. Re-enable legacy system write access                     |
|  ├── 5. Disable new system access                                |
|  ├── 6. If any transactions occurred in new system:              |
|  │   ├── Extract transactions from new system                    |
|  │   ├── Replay critical transactions in legacy                  |
|  │   └── Reconcile both systems                                  |
|  ├── 7. Communicate rollback to all users                        |
|  └── 8. Post-mortem and remediation plan                         |
|                                                                  |
|  POINT-OF-NO-RETURN:                                             |
|  ├── Once external transactions processed in new system          |
|  │   (EDI filings, payments cleared, etc.)                       |
|  ├── Rollback becomes significantly more complex                 |
|  └── May require manual reconciliation period                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 13. Co-existence Patterns

### 13.1 Dual-Write Pattern

```
DUAL-WRITE DURING CO-EXISTENCE:
+------------------------------------------------------------------+
|                                                                  |
|  SCENARIO: Both systems active during transition                 |
|                                                                  |
|  OPTION A: PRIMARY WRITE TO NEW, SYNC TO LEGACY                 |
|  ┌──────────┐  write  ┌──────────┐  CDC/sync  ┌──────────┐     |
|  │ User     │────────>│ NEW      │──────────>│ LEGACY   │     |
|  │          │         │ SYSTEM   │           │ SYSTEM   │     |
|  └──────────┘         └──────────┘           └──────────┘     |
|  Use when: New system is primary, legacy needs data for         |
|  reporting or downstream systems not yet migrated               |
|                                                                  |
|  OPTION B: PRIMARY WRITE TO LEGACY, SYNC TO NEW                 |
|  ┌──────────┐  write  ┌──────────┐  CDC/sync  ┌──────────┐     |
|  │ User     │────────>│ LEGACY   │──────────>│ NEW      │     |
|  │          │         │ SYSTEM   │           │ SYSTEM   │     |
|  └──────────┘         └──────────┘           └──────────┘     |
|  Use when: Legacy is still primary, new system being            |
|  populated for testing and parallel running                     |
|                                                                  |
|  OPTION C: SPLIT BY CLAIM (Strangler Pattern)                   |
|  ┌──────────┐         ┌──────────┐                              |
|  │ User     │────────>│ ROUTER   │                              |
|  │          │         │          │                              |
|  └──────────┘         └─────┬────┘                              |
|                        ┌────┴────┐                              |
|                        ▼         ▼                              |
|                  ┌──────────┐ ┌──────────┐                      |
|                  │ NEW      │ │ LEGACY   │                      |
|                  │ (new clms)│ │ (old clms)│                     |
|                  └──────────┘ └──────────┘                      |
|  Use when: New claims in new system, existing in legacy         |
|  RECOMMENDED approach                                           |
|                                                                  |
+------------------------------------------------------------------+
```

### 13.2 Reporting During Transition

```
REPORTING ARCHITECTURE DURING CO-EXISTENCE:
+------------------------------------------------------------------+
|                                                                  |
|  CHALLENGE: Reporting must include data from both systems        |
|                                                                  |
|  SOLUTION: Unified Reporting Layer                               |
|                                                                  |
|  ┌──────────┐         ┌──────────┐                              |
|  │ NEW      │──CDC──>│          │                              |
|  │ SYSTEM   │        │ UNIFIED  │──>│ REPORTING  │             |
|  └──────────┘        │ DATA     │   │ PLATFORM   │             |
|                      │ LAYER    │   │(Snowflake/ │             |
|  ┌──────────┐        │(Snowflake│   │ Power BI)  │             |
|  │ LEGACY   │──ETL──>│  / Data  │   │            │             |
|  │ SYSTEM   │        │  Lake)   │   └────────────┘             |
|  └──────────┘        └──────────┘                              |
|                                                                  |
|  KEY REQUIREMENTS:                                               |
|  ├── Unified claim identifier mapping                            |
|  ├── Consistent code values across systems                       |
|  ├── Financial aggregation from both sources                     |
|  ├── Deduplication (no double-counting)                          |
|  └── Clear data source labeling                                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 14. Legacy Integration Patterns

### 14.1 Integration Approaches

```
LEGACY INTEGRATION PATTERNS:
+====================================================================+
|                                                                    |
|  SCREEN SCRAPING / RPA:                                            |
|  ├── Use: When no APIs or database access available                |
|  ├── Tools: UiPath, Automation Anywhere, Blue Prism               |
|  ├── Approach: Automate terminal/UI interactions                   |
|  ├── PRO: No changes to legacy system                              |
|  ├── CON: Fragile (UI changes break scripts), slow                 |
|  └── Best for: Temporary integration during migration              |
|                                                                    |
|  DATABASE-LEVEL INTEGRATION:                                       |
|  ├── Use: When database access is available                        |
|  ├── Tools: CDC (Debezium), database links, JDBC/ODBC             |
|  ├── Approach: Read/write directly to legacy database              |
|  ├── PRO: Reliable, performant, well-understood                    |
|  ├── CON: Bypasses business logic, tight coupling                  |
|  └── Best for: Data synchronization, reporting                     |
|                                                                    |
|  FILE-BASED INTEGRATION:                                           |
|  ├── Use: When batch processing is primary interface               |
|  ├── Tools: SFTP, S3, message queues with file payloads            |
|  ├── Approach: Extract files from legacy, process in new system    |
|  ├── PRO: Decoupled, familiar to legacy teams                      |
|  ├── CON: Batch latency, file format management                    |
|  └── Best for: Mainframe integration, EDI processing               |
|                                                                    |
|  API WRAPPING:                                                     |
|  ├── Use: When legacy can be exposed through APIs                  |
|  ├── Tools: MuleSoft, API gateway + adapter layer                  |
|  ├── Approach: Build REST/SOAP API layer over legacy               |
|  ├── PRO: Clean interface, reusable                                |
|  ├── CON: Performance overhead, limited by legacy capability       |
|  └── Best for: Long-term co-existence, gradual migration           |
|                                                                    |
+====================================================================+
```

---

## 15. Common Migration Challenges

### 15.1 Challenge Catalog

```
COMMON CLAIMS MIGRATION CHALLENGES:
+====================================================================+
|                                                                    |
|  CHALLENGE 1: DATA MODEL MISMATCH                                  |
|  +--------------------------------------------------------------+  |
|  | Problem: Legacy and target have fundamentally different       |  |
|  |          data structures                                      |  |
|  | Examples:                                                     |  |
|  | ├── Legacy: single claim record with multiple coverages       |  |
|  | │   New: separate exposure entities per coverage              |  |
|  | ├── Legacy: flat party list                                   |  |
|  | │   New: hierarchical party-role model                        |  |
|  | └── Legacy: combined loss/expense reserves                    |  |
|  |     New: separate loss, ALAE, ULAE reserves                   |  |
|  | Solution:                                                     |  |
|  | ├── Complex transformation logic in ETL                       |  |
|  | ├── Default values for missing structural elements            |  |
|  | └── Post-migration manual cleanup for edge cases              |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  CHALLENGE 2: HISTORICAL DATA WITHOUT SOURCE POLICY                |
|  +--------------------------------------------------------------+  |
|  | Problem: Old claims reference policies no longer in any system|  |
|  | Examples:                                                     |  |
|  | ├── Policy system was replaced, old policies not migrated     |  |
|  | ├── Acquired book of business, policies never converted       |  |
|  | └── Claims from programs no longer written                    |  |
|  | Solution:                                                     |  |
|  | ├── Create "shell" policies with minimum required data        |  |
|  | ├── Flag claims as "legacy policy" for special handling       |  |
|  | └── Maintain separate reference table for historical policies |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  CHALLENGE 3: ORPHANED FINANCIAL RECORDS                           |
|  +--------------------------------------------------------------+  |
|  | Problem: Payments/reserves that don't tie to valid claims     |  |
|  | Examples:                                                     |  |
|  | ├── Payments posted to wrong claim numbers                    |  |
|  | ├── Reserve entries without corresponding claim records       |  |
|  | └── Recovery records without source claim reference           |  |
|  | Solution:                                                     |  |
|  | ├── Pre-migration reconciliation with GL                      |  |
|  | ├── Create suspense claims for orphaned financials            |  |
|  | └── Manual resolution queue for post-migration cleanup        |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  CHALLENGE 4: DOCUMENT MIGRATION                                   |
|  +--------------------------------------------------------------+  |
|  | Problem: Documents in various formats and storage systems     |  |
|  | Examples:                                                     |  |
|  | ├── TIFF images from document scanning systems                |  |
|  | ├── Microfilm/microfiche not yet digitized                    |  |
|  | ├── Documents stored on network file shares                   |  |
|  | ├── Documents embedded in proprietary DMS (FileNet, OnBase)   |  |
|  | └── Email attachments stored in exchange servers              |  |
|  | Solution:                                                     |  |
|  | ├── Document inventory and format analysis                    |  |
|  | ├── Batch conversion to standard format (PDF)                 |  |
|  | ├── S3/blob storage for target                                |  |
|  | ├── Metadata mapping and enrichment                           |  |
|  | └── Phased document migration (priority by claim status)      |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
|  CHALLENGE 5: CUSTOM BUSINESS LOGIC                                |
|  +--------------------------------------------------------------+  |
|  | Problem: Decades of custom code implementing business rules   |  |
|  | Examples:                                                     |  |
|  | ├── State-specific calculations in COBOL code                 |  |
|  | ├── Custom workflow logic in stored procedures                |  |
|  | ├── Business rules embedded in VB6 client code               |  |
|  | └── Undocumented override logic                               |  |
|  | Solution:                                                     |  |
|  | ├── Legacy code analysis and documentation                    |  |
|  | ├── Side-by-side testing (same inputs, compare outputs)       |  |
|  | ├── Externalize rules in rules engine                         |  |
|  | └── Accept some functional regression as modernization cost   |  |
|  +--------------------------------------------------------------+  |
|                                                                    |
+====================================================================+
```

---

## 16. Post-Migration Validation and Support

### 16.1 Hyper-Care Period

```
POST-MIGRATION HYPER-CARE PLAN:
+------------------------------------------------------------------+
|                                                                  |
|  WEEK 1: CRITICAL SUPPORT                                        |
|  ├── War room staffed 12+ hours/day                              |
|  ├── All migration team members on-call                          |
|  ├── Dedicated support channel (chat/phone)                      |
|  ├── Hourly monitoring of system health                          |
|  ├── Daily reconciliation runs (financial)                       |
|  ├── Issue tracking and priority triage                          |
|  ├── Known issue list maintained and communicated                |
|  └── Daily status reports to leadership                          |
|                                                                  |
|  WEEKS 2-4: ELEVATED SUPPORT                                    |
|  ├── Support desk staffed extended hours                         |
|  ├── Daily monitoring of key metrics                             |
|  ├── Weekly reconciliation runs                                  |
|  ├── Bug fix releases as needed                                  |
|  ├── User feedback collection and response                      |
|  └── Weekly status reports to leadership                         |
|                                                                  |
|  MONTHS 2-3: STABILIZATION                                      |
|  ├── Normal support levels with migration expertise available    |
|  ├── Monthly reconciliation runs                                 |
|  ├── Performance tuning based on real-world usage                |
|  ├── Training reinforcement sessions                             |
|  └── Monthly status reports                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 17. Claims Migration Data Model Mapping Templates

### 17.1 Claim Header Mapping

```
CLAIM HEADER MAPPING TEMPLATE:
+====================================================================+
| #   | Source         | Source       | Target       | Target        |
|     | Table          | Field        | Table        | Field         |
+====================================================================+
| 1   | CLMMASTER      | CLM-NBR      | claim        | claim_number  |
| 2   | CLMMASTER      | (derived)    | claim        | claim_id (UUID)|
| 3   | CLMMASTER      | POL-NBR      | claim        | policy_id     |
| 4   | CLMMASTER      | DOL-DT       | claim        | date_of_loss  |
| 5   | CLMMASTER      | RPT-DT       | claim        | date_reported |
| 6   | CLMMASTER      | CLM-STS-CD   | claim        | claim_status  |
| 7   | CLMMASTER      | LOB-CD       | claim        | lob_code      |
| 8   | CLMMASTER      | CSE-OF-LS    | claim        | cause_of_loss |
| 9   | CLMMASTER      | ST-CD        | claim        | state         |
| 10  | CLMMASTER      | ADJ-CD       | claim        | adjuster_id   |
| 11  | CLMMASTER      | TOT-PD-LS    | claim        | total_paid_loss|
| 12  | CLMMASTER      | TOT-PD-EX    | claim        | total_paid_exp|
| 13  | CLMMASTER      | TOT-OS-LS    | claim        | total_os_loss |
| 14  | CLMMASTER      | TOT-OS-EX    | claim        | total_os_exp  |
| 15  | CLMMASTER      | TOT-RCV      | claim        | total_recovery|
| 16  | CLMMASTER      | LITIGATION   | claim        | litigated     |
| 17  | CLMMASTER      | ATY-IND      | claim        | attorney_rep  |
| 18  | CLMMASTER      | CLS-DT       | claim        | date_closed   |
| 19  | CLMMASTER      | CRT-DT       | claim        | created_date  |
| 20  | (generated)    | NOW()        | claim        | migrated_date |
| 21  | (constant)     | 'MIGRATION'  | claim        | created_by    |
| 22  | (constant)     | 'LEGACY'     | claim        | source_system |
| 23  | CLMMASTER      | CLM-NBR      | claim        | legacy_claim_id|
+====================================================================+
```

---

## 18. Migration Project Plan Template

### 18.1 High-Level Timeline

```
CLAIMS MIGRATION PROJECT PHASES:
+====================================================================+
|                                                                    |
|  PHASE 1: DISCOVERY & PLANNING (8-12 weeks)                       |
|  ├── Source system analysis and data profiling                     |
|  ├── Data quality assessment                                      |
|  ├── Migration scope definition                                   |
|  ├── Source-to-target mapping (first draft)                        |
|  ├── Technical architecture design                                |
|  ├── Risk assessment                                              |
|  ├── Migration strategy selection                                  |
|  └── Detailed project plan and resource plan                      |
|                                                                    |
|  PHASE 2: BUILD (12-20 weeks)                                      |
|  ├── ETL pipeline development                                     |
|  ├── Transformation rule implementation                           |
|  ├── Code translation table creation                              |
|  ├── Validation/reconciliation framework build                    |
|  ├── Legacy integration adapters                                  |
|  ├── Data cleansing rule implementation                           |
|  └── Unit testing of all transformations                          |
|                                                                    |
|  PHASE 3: ITERATE & TEST (12-16 weeks)                             |
|  ├── Mock migration #1 (sample data)                              |
|  ├── Reconciliation and issue resolution                          |
|  ├── Mock migration #2 (larger sample)                            |
|  ├── UAT with claims adjusters                                    |
|  ├── Mock migration #3 (full volume)                              |
|  ├── Performance testing at full volume                           |
|  ├── Integration testing with downstream systems                  |
|  └── Final reconciliation validation                              |
|                                                                    |
|  PHASE 4: CUTOVER (1-2 weeks)                                      |
|  ├── Final data extract                                           |
|  ├── Transformation and load                                      |
|  ├── Reconciliation (all levels)                                  |
|  ├── Go/no-go decision                                            |
|  ├── System cutover                                               |
|  └── Go-live verification                                         |
|                                                                    |
|  PHASE 5: HYPER-CARE (4-8 weeks)                                   |
|  ├── Post-migration support                                       |
|  ├── Issue resolution                                             |
|  ├── Data cleanup                                                 |
|  ├── Performance optimization                                     |
|  └── Knowledge transfer to operations                             |
|                                                                    |
|  TOTAL DURATION: 9-14 months (typical claims migration)            |
|                                                                    |
+====================================================================+
```

---

## 19. Risk Register for Claims Migration

### 19.1 Risk Categories

```
MIGRATION RISK REGISTER:
+====================================================================+
| ID  | Risk                    | Prob | Impact | Mitigation          |
+====================================================================+
| R01 | Data quality worse      | HIGH | HIGH   | Early profiling,    |
|     | than expected           |      |        | cleansing budget    |
+--------------------------------------------------------------------+
| R02 | Financial reconciliation| MED  | CRIT   | Multiple mock runs, |
|     | failures                |      |        | GL cross-check      |
+--------------------------------------------------------------------+
| R03 | Legacy system changes   | MED  | HIGH   | Change freeze on    |
|     | during migration        |      |        | legacy, CDC approach|
+--------------------------------------------------------------------+
| R04 | Performance issues      | MED  | HIGH   | Full-volume testing,|
|     | at production scale     |      |        | performance budget  |
+--------------------------------------------------------------------+
| R05 | Key personnel           | MED  | HIGH   | Knowledge docs,     |
|     | turnover                |      |        | cross-training      |
+--------------------------------------------------------------------+
| R06 | Scope creep (more data  | HIGH | MED    | Firm scope baseline,|
|     | entities added)         |      |        | change control      |
+--------------------------------------------------------------------+
| R07 | Integration failures    | MED  | HIGH   | Early integration   |
|     | with downstream         |      |        | testing             |
+--------------------------------------------------------------------+
| R08 | Regulatory deadlines    | LOW  | CRIT   | Parallel filing from|
|     | missed during cutover   |      |        | both systems        |
+--------------------------------------------------------------------+
| R09 | Document migration      | HIGH | MED    | Phased doc migration|
|     | volume/performance      |      |        | separate from data  |
+--------------------------------------------------------------------+
| R10 | User resistance to      | MED  | MED    | Change management,  |
|     | new system              |      |        | early involvement   |
+====================================================================+
```

---

## 20. Lessons Learned from Industry Migrations

### 20.1 Key Lessons

```
INDUSTRY LESSONS LEARNED:
+====================================================================+
|                                                                    |
|  LESSON 1: Data is always worse than you think                     |
|  ├── Plan for 2-3x the expected data cleanup effort                |
|  ├── Start data profiling in week 1 of the project                 |
|  ├── Allocate dedicated data quality resources                     |
|  └── Expect to find issues in every mock migration                 |
|                                                                    |
|  LESSON 2: Mock migrations are essential                           |
|  ├── Run at least 3 full mock migrations before cutover            |
|  ├── Each mock reveals new issues                                  |
|  ├── Time the full process end-to-end                              |
|  └── Use mock results to refine cutover timeline                   |
|                                                                    |
|  LESSON 3: Financial reconciliation is non-negotiable              |
|  ├── $0 tolerance for financial variances                          |
|  ├── Reconcile to GL, not just source system                       |
|  ├── Actuarial team must validate reserve migration                |
|  └── Finance team sign-off before cutover                          |
|                                                                    |
|  LESSON 4: Involve claims adjusters early and often                |
|  ├── Adjusters find issues that testing scripts miss               |
|  ├── UAT with real adjusters on real claims                        |
|  ├── Include adjusters in data mapping review                      |
|  └── Their buy-in is critical for go-live success                  |
|                                                                    |
|  LESSON 5: Plan for co-existence longer than expected              |
|  ├── Budget for 6-12 months of co-existence                       |
|  ├── Reporting during co-existence is complex and expensive        |
|  ├── Data sync between systems needs ongoing maintenance           |
|  └── Legacy decommission always takes longer than planned          |
|                                                                    |
|  LESSON 6: Documents are a separate migration stream               |
|  ├── Document migration can take longer than data migration        |
|  ├── Don't let document migration hold up go-live                  |
|  ├── Phase document migration by claim priority                    |
|  └── Keep legacy document access for 1-2 years post-migration     |
|                                                                    |
|  LESSON 7: Performance testing at scale is critical                |
|  ├── Test with full production data volume                         |
|  ├── Simulate concurrent user load during peak hours               |
|  ├── Test search and reporting with full migrated dataset          |
|  └── Database indexing strategy must account for migrated data     |
|                                                                    |
|  LESSON 8: Change management is underinvested                      |
|  ├── Technical migration is only half the challenge                |
|  ├── User training must cover "claims in new system" not just UI   |
|  ├── Process changes alongside system changes cause confusion      |
|  └── Communicate early, often, and transparently                   |
|                                                                    |
+====================================================================+
```

---

## Summary

Claims data migration and legacy modernization is one of the most challenging initiatives an insurance company can undertake. The claims system is the operational heart of the organization — it touches every policyholder interaction, financial transaction, and regulatory filing.

Key architectural takeaways for solutions architects:

1. **Choose the right modernization strategy** — Strangler fig with phased migration is the lowest-risk approach for most carriers
2. **Data quality is the #1 risk** — invest heavily in profiling, cleansing, and validation
3. **Financial reconciliation must be exact** — regulators and auditors will verify
4. **Plan for co-existence** — both systems will run in parallel longer than expected
5. **Mock migrations are essential** — run at least 3 full rehearsals
6. **Separate document migration** — don't let it block data migration
7. **Involve users early** — adjusters are the ultimate validators
8. **Build for rollback** — every phase must have a revert plan
9. **Legacy integration bridges** — invest in adapters for the co-existence period
10. **Post-migration support** — plan for 2-3 months of hyper-care
