# Underwriting Process Flows & Workflows

## Term Life Insurance — Architecture & Engineering Reference

This document provides an exhaustive reference for every process flow encountered
in automated term life insurance underwriting. Each flow is presented with ASCII
diagrams suitable for direct translation into BPMN, state-machine definitions, or
orchestration engine configurations. The target audience is solution architects
building or modernizing underwriting platforms.

---

## Table of Contents

1. [Master Underwriting Workflow](#1-master-underwriting-workflow)
2. [Application Intake Flow](#2-application-intake-flow)
3. [Evidence Ordering Orchestration](#3-evidence-ordering-orchestration)
4. [Accelerated Underwriting Path](#4-accelerated-underwriting-path)
5. [Traditional Full Underwriting Path](#5-traditional-full-underwriting-path)
6. [Triage & Assignment Flow](#6-triage--assignment-flow)
7. [Medical Underwriting Decision Flow](#7-medical-underwriting-decision-flow)
8. [Financial Underwriting Flow](#8-financial-underwriting-flow)
9. [Reinsurance Cession Flow](#9-reinsurance-cession-flow)
10. [Policy Issue & Delivery Flow](#10-policy-issue--delivery-flow)
11. [Exception Handling Flows](#11-exception-handling-flows)
12. [Counter-Offer Flow](#12-counter-offer-flow)
13. [Decline & Adverse Action Flow](#13-decline--adverse-action-flow)
14. [Amendment & Reconsideration Flow](#14-amendment--reconsideration-flow)
15. [State Machine Diagrams](#15-state-machine-diagrams)
16. [SLA Tracking & Escalation](#16-sla-tracking--escalation)
17. [Quality Assurance Audit Flow](#17-quality-assurance-audit-flow)

---

## 1. Master Underwriting Workflow

The master workflow governs the full lifecycle of a term life application from
the moment a consumer or agent initiates the process through policy delivery and
the start of the free-look period. Every sub-flow described later in this
document plugs into a specific phase of this master workflow.

### 1.1 High-Level Phases

```
Phase 1        Phase 2          Phase 3        Phase 4         Phase 5
APPLICATION    EVIDENCE         UNDERWRITING   POLICY          IN-FORCE
INTAKE         GATHERING        DECISION       ISSUE           SERVICE
+-----------+  +-------------+  +-----------+  +-----------+  +-----------+
| Collect   |  | Order &     |  | Risk      |  | Compliance|  | Welcome   |
| app data, |->| assemble    |->| assess,   |->| checks,   |->| kit,      |
| validate, |  | all medical |  | classify, |  | premium   |  | free-look |
| e-sign    |  | & financial |  | decide    |  | collect,  |  | period,   |
|           |  | evidence    |  |           |  | deliver   |  | persist   |
+-----------+  +-------------+  +-----------+  +-----------+  +-----------+
     |               |               |               |              |
     v               v               v               v              v
  Abandon/       Incomplete/      Decline/       Issue fail/    Lapse/
  NIGO            timeout        counter-offer   rescind       cancel
```

### 1.2 Detailed Master Flow

```
                            +------------------+
                            |   APPLICATION    |
                            |   RECEIVED       |
                            +--------+---------+
                                     |
                                     v
                          +----------+----------+
                          | CHANNEL DETECTION   |
                          | (Agent/DTC/API/Tele)|
                          +----------+----------+
                                     |
                    +----------------+----------------+
                    |                |                 |
                    v                v                 v
             +------+----+   +------+-----+   +------+------+
             | Agent     |   | Direct-to- |   | Partner     |
             | Portal    |   | Consumer   |   | API         |
             | Intake    |   | Web/Mobile |   | Integration |
             +------+----+   +------+-----+   +------+------+
                    |                |                 |
                    +----------------+-----------------+
                                     |
                                     v
                          +----------+----------+
                          | APPLICATION         |
                          | VALIDATION          |
                          | - Completeness      |
                          | - Eligibility       |
                          | - Duplicate check   |
                          | - Fraud screening   |
                          +----------+----------+
                                     |
                              +------+------+
                              | Valid?      |
                              +------+------+
                              |  Yes  |  No |
                              +--+----+--+--+
                                 |       |
                                 |       v
                                 |  +----+--------+
                                 |  | NIGO / PEND |
                                 |  | Notify      |
                                 |  | applicant   |
                                 |  +----+--------+
                                 |       |
                                 |       v
                                 |  +---------+
                                 |  | Info    |-----> ABANDON
                                 |  | rcvd?   |      (after SLA)
                                 |  +----+----+
                                 |       | Yes
                                 |       |
                                 +-------+
                                     |
                                     v
                          +----------+----------+
                          | RISK PRE-SCREENING  |
                          | - Quick knockout    |
                          |   rules             |
                          | - Eligibility for   |
                          |   accelerated UW    |
                          +----------+----------+
                                     |
                           +---------+---------+
                           |                   |
                           v                   v
                 +---------+------+   +--------+--------+
                 | ACCELERATED    |   | TRADITIONAL     |
                 | UW PATH        |   | FULL UW PATH    |
                 | (Sections 4)   |   | (Section 5)     |
                 +---------+------+   +--------+--------+
                           |                   |
                           v                   v
                 +---------+------+   +--------+--------+
                 | Rules Engine   |   | Evidence        |
                 | Auto-Decision  |   | Ordering &      |
                 |                |   | Assembly        |
                 +---------+------+   +--------+--------+
                           |                   |
                           |                   v
                           |          +--------+--------+
                           |          | TRIAGE &        |
                           |          | ASSIGNMENT      |
                           |          | (Section 6)     |
                           |          +--------+--------+
                           |                   |
                           |                   v
                           |          +--------+--------+
                           |          | MANUAL UW       |
                           |          | REVIEW          |
                           |          | (Section 7)     |
                           |          +--------+--------+
                           |                   |
                           +-------+-----------+
                                   |
                            +------+------+
                            | DECISION    |
                            +------+------+
                            |      |      |
                     +------+ +----+---+ +------+
                     |        |        |        |
                     v        v        v        v
               +-----+-+ +---+---+ +--+---+ +--+------+
               |APPROVE| |COUNTER| |DECLINE| |POSTPONE |
               |       | |OFFER  | |       | |         |
               +---+---+ +---+---+ +---+---+ +----+----+
                   |          |        |           |
                   |          v        v           v
                   |     Sec 12   Sec 13     Reapply
                   |                          window
                   v
          +--------+--------+
          | FINANCIAL UW    |
          | (Section 8)     |
          +--------+--------+
                   |
            +------+------+
            | Financial   |
            | OK?         |
            +------+------+
             Yes |    | No
                 |    +-------> Counter-offer / Decline
                 v
          +------+----------+
          | REINSURANCE     |
          | CESSION         |
          | (Section 9)     |
          +--------+--------+
                   |
                   v
          +--------+--------+
          | POLICY ISSUE &  |
          | DELIVERY        |
          | (Section 10)    |
          +--------+--------+
                   |
                   v
          +--------+--------+
          | IN-FORCE        |
          | Free-look       |
          | period active   |
          +-----------------+
```

### 1.3 Master Flow Timing Targets

| Phase                      | SLA Target (Calendar Days) | Stretch Goal |
|----------------------------|----------------------------|--------------|
| Application → Validation   | < 1 hour (real-time)       | < 5 min      |
| Validation → Evidence Ord. | < 4 hours                  | < 1 hour     |
| Evidence Assembly          | 5–21 days (APS dependent)  | 3 days (accel.)|
| UW Decision                | 2–5 days (manual)          | < 60 sec (auto)|
| Decision → Policy Issue    | 1–3 days                   | Same day     |
| Issue → Delivery           | 1–5 days                   | Instant (e-del)|
| **End-to-End (Accelerated)** | **< 24 hours**           | **< 15 min** |
| **End-to-End (Traditional)** | **15–30 days**           | **10 days**  |

---

## 2. Application Intake Flow

Application intake is the first critical phase. It must handle multiple channels,
perform real-time validation, support reflexive questioning logic, and secure
legally binding e-signatures.

### 2.1 Multi-Channel Intake Architecture

```
+================+    +================+    +================+
||  AGENT        ||    ||  DTC WEB /   ||    ||  PARTNER     ||
||  PORTAL       ||    ||  MOBILE APP  ||    ||  API (B2B)   ||
||               ||    ||              ||    ||              ||
|| - Pre-fill    ||    || - Interview  ||    || - ACORD XML/ ||
||   from CRM    ||    ||   wizard     ||    ||   JSON       ||
|| - Guided data ||    || - Reflexive  ||    || - Bulk       ||
||   entry       ||    ||   questions  ||    ||   submission ||
|| - Split app   ||    || - Real-time  ||    || - Webhook    ||
||   (Part1/2)   ||    ||   quotes     ||    ||   callbacks  ||
+========+=======+    +========+=======+    +========+=======+
         |                     |                     |
         +---------------------+---------------------+
                               |
                               v
                  +------------+-------------+
                  |   API GATEWAY /          |
                  |   INTAKE ORCHESTRATOR    |
                  |                          |
                  |  - Rate limiting         |
                  |  - Auth (OAuth2/SAML)    |
                  |  - Channel detection     |
                  |  - Request enrichment    |
                  +------------+-------------+
                               |
                               v
                  +------------+-------------+
                  |   CANONICAL APPLICATION  |
                  |   MODEL (NORMALIZED)     |
                  |                          |
                  |  Regardless of source    |
                  |  channel, data is mapped |
                  |  to a single domain      |
                  |  model                   |
                  +------------+-------------+
                               |
                               v
                  +------------+-------------+
                  |   VALIDATION ENGINE      |
                  +------------+-------------+
                               |
         +---------------------+---------------------+
         |                     |                      |
         v                     v                      v
  +------+------+     +-------+------+      +--------+-------+
  | FIELD-LEVEL |     | BUSINESS     |      | CROSS-FIELD    |
  | VALIDATION  |     | RULES        |      | VALIDATION     |
  |             |     |              |      |                |
  | - Type      |     | - Age 18-80  |      | - Bene != owner|
  | - Format    |     | - Min face   |      |   (if minor)   |
  | - Required  |     |   $25,000    |      | - State +      |
  | - Range     |     | - Max face   |      |   product avail|
  |             |     |   by age     |      | - Tobacco +    |
  |             |     | - State elig.|      |   build consist.|
  +------+------+     +-------+------+      +--------+-------+
         |                     |                      |
         +---------------------+----------------------+
                               |
                        +------+------+
                        | ALL VALID?  |
                        +------+------+
                         Yes |    | No
                             |    v
                             |  +---------+--------+
                             |  | RETURN ERRORS    |
                             |  | - Field-level    |
                             |  |   error codes    |
                             |  | - Suggested      |
                             |  |   corrections    |
                             |  +------------------+
                             v
                  +----------+-----------+
                  | DUPLICATE / FRAUD    |
                  | SCREENING            |
                  |                      |
                  | - SSN match (prior   |
                  |   apps within 90d)   |
                  | - Name + DOB fuzzy   |
                  |   match              |
                  | - Device fingerprint |
                  |   (DTC channel)      |
                  | - IP geolocation vs  |
                  |   stated address     |
                  | - Velocity checks    |
                  +----------+-----------+
                             |
                      +------+------+
                      | CLEAN?      |
                      +------+------+
                       Yes |    | Flag
                           |    v
                           | +--+----------+
                           | | QUEUE FOR   |
                           | | SIU REVIEW  |
                           | +--+----------+
                           |    |
                           |    v (Continue with flag)
                           +----+
                                |
                                v
                  +-------------+----------+
                  | REFLEXIVE QUESTION     |
                  | ENGINE                 |
                  |                        |
                  | IF tobacco = yes THEN  |
                  |   ask frequency, type  |
                  | IF aviation = yes THEN |
                  |   ask hours, license   |
                  | IF Rx = yes THEN       |
                  |   ask condition detail |
                  +-------------+----------+
                                |
                                v
                  +-------------+----------+
                  | E-SIGNATURE CEREMONY   |
                  |                        |
                  | 1. Generate signing    |
                  |    package             |
                  | 2. Applicant signs     |
                  |    (Part 1 & Part 2)   |
                  | 3. Owner signs (if !=  |
                  |    insured)            |
                  | 4. Agent signs (if     |
                  |    agent channel)      |
                  | 5. Capture audit trail |
                  |    (IP, timestamp,     |
                  |    device)             |
                  +-------------+----------+
                                |
                                v
                  +-------------+----------+
                  | INITIAL PREMIUM        |
                  | COLLECTION             |
                  |                        |
                  | - Credit card auth     |
                  | - ACH setup + first    |
                  |   draft                |
                  | - No-payment allowed   |
                  |   (COD states)         |
                  +-------------+----------+
                                |
                                v
                  +-------------+----------+
                  | CASE CREATED           |
                  | Status: SUBMITTED      |
                  | Event: CaseCreated     |
                  | -> Evidence Ordering   |
                  +-----------------------+
```

### 2.2 Reflexive Questioning Logic Tree (Partial Example)

```
Q: "Have you used tobacco in the past 12 months?"
|
+-- [Yes] --> Q: "What type of tobacco?"
|               |
|               +-- [Cigarettes] --> Q: "How many per day?"
|               |                      |
|               |                      +-- [< 10] --> Class: TOBACCO_LIGHT
|               |                      +-- [10-20] -> Class: TOBACCO_MODERATE
|               |                      +-- [> 20] --> Class: TOBACCO_HEAVY
|               |
|               +-- [Cigars only] --> Q: "How many per month?"
|               |                      |
|               |                      +-- [< 4] --> MAY qualify non-tobacco
|               |                      +-- [>= 4] -> Class: TOBACCO_CIGAR
|               |
|               +-- [Chewing] --> Class: TOBACCO_SMOKELESS
|               +-- [Vaping]  --> Q: "Contains nicotine?"
|                                  |
|                                  +-- [Yes] --> TOBACCO_VAPE
|                                  +-- [No]  --> Carrier-specific rules
|
+-- [No] --> Q: "Have you used tobacco in the past 5 years?"
              |
              +-- [Yes] --> Non-tobacco class with recency surcharge
              +-- [No]  --> Eligible for preferred non-tobacco
```

### 2.3 Tele-Application Sub-Flow

```
+-------------------+
| SCHEDULE CALL     |
| (Inbound/Outbound)|
+--------+----------+
         |
         v
+--------+----------+
| IDENTITY          |
| VERIFICATION      |
| - DOB             |
| - Last 4 SSN      |
| - Address confirm  |
+--------+----------+
         |
         v
+--------+----------+
| SCRIPTED INTERVIEW|
| (State-approved   |
|  script required) |
|                   |
| - Part 1 questions|
| - Part 2 medical  |
| - Reflexive Qs    |
+--------+----------+
         |
         v
+--------+----------+
| VOICE SIGNATURE   |
| CAPTURE           |
| - Record consent  |
| - Timestamp        |
| - Call recording   |
|   archived         |
+--------+----------+
         |
         v
+--------+----------+
| AGENT ATTESTATION |
| - Did applicant   |
|   appear coherent?|
| - Were answers    |
|   given freely?   |
+--------+----------+
         |
         v
   Case Created
```

---

## 3. Evidence Ordering Orchestration

Evidence ordering is the most operationally complex phase. The system must
decide which evidence to order, manage parallel vendor integrations, handle
failures gracefully, and minimize cost by ordering conditionally.

### 3.1 Evidence Ordering Decision Matrix

```
+----------+----------+---------+--------+----------+---------+--------+
| Face Amt |   Age    |   MIB   |   Rx   |   MVR    |  APS    | Paramed|
+----------+----------+---------+--------+----------+---------+--------+
| < $100K  | 18 - 45  |   Yes   |  Yes   |   Yes    |  Cond.  |   No   |
| < $100K  | 46 - 60  |   Yes   |  Yes   |   Yes    |  Cond.  |  Cond. |
| < $100K  | 61+      |   Yes   |  Yes   |   Yes    |  Yes    |  Yes   |
| $100-250K| 18 - 45  |   Yes   |  Yes   |   Yes    |  Cond.  |   No   |
| $100-250K| 46 - 60  |   Yes   |  Yes   |   Yes    |  Cond.  |  Yes   |
| $100-250K| 61+      |   Yes   |  Yes   |   Yes    |  Yes    |  Yes   |
| $250-500K| 18 - 50  |   Yes   |  Yes   |   Yes    |  Cond.  |  Cond. |
| $250-500K| 51+      |   Yes   |  Yes   |   Yes    |  Yes    |  Yes   |
| $500K-1M | All ages |   Yes   |  Yes   |   Yes    |  Yes    |  Yes   |
| > $1M    | All ages |   Yes   |  Yes   |   Yes    |  Yes    |  Yes   |
+----------+----------+---------+--------+----------+---------+--------+

Cond. = Conditional — ordered only if triggered by results from other sources
```

### 3.2 Parallel vs Sequential Ordering Strategy

```
                        +------------------+
                        | CASE SUBMITTED   |
                        +--------+---------+
                                 |
                                 v
                   +-------------+-------------+
                   | EVIDENCE ORCHESTRATOR     |
                   | Determine ordering plan   |
                   +-------------+-------------+
                                 |
              +------------------+-------------------+
              |                  |                    |
    +---------+------+ +--------+--------+ +---------+---------+
    | WAVE 1         | | WAVE 1          | | WAVE 1            |
    | (Parallel)     | | (Parallel)      | | (Parallel)        |
    |                | |                 | |                   |
    | MIB Inquiry    | | Rx Database     | | MVR Report        |
    | (AURA/MIB)     | | (Milliman       | | (LexisNexis)      |
    |                | |  IntelliScript) | |                   |
    | SLA: < 5 sec   | | SLA: < 10 sec   | | SLA: < 30 sec     |
    +--------+-------+ +--------+--------+ +---------+---------+
             |                  |                     |
             +------------------+---------------------+
                                |
                                v
                   +------------+------------+
                   | WAVE 1 RESULTS          |
                   | ANALYSIS                |
                   |                         |
                   | Apply conditional       |
                   | ordering rules          |
                   +------------+------------+
                                |
          +---------------------+---------------------+
          |                     |                      |
          v                     v                      v
  +-------+--------+  +--------+--------+  +----------+---------+
  | IF MIB hit for |  | IF Rx shows     |  | IF MVR shows       |
  | cardiac history|  | controlled      |  | DUI in last 5yr    |
  | THEN order APS |  | substance       |  | THEN order         |
  | from cardiolog.|  | THEN order      |  | detailed driving   |
  |                |  | tox screen      |  | abstract           |
  +-------+--------+  +--------+--------+  +----------+---------+
          |                     |                      |
          +---------------------+----------------------+
                                |
                                v
                   +------------+------------+
                   | WAVE 2                  |
                   | (Conditional orders)    |
                   |                         |
                   | - APS (if triggered)    |
                   | - Credit report         |
                   | - Paramedical exam      |
                   |   (if required)         |
                   | - Inspection report     |
                   |   (if face > $1M)       |
                   +------------+------------+
                                |
                                v
                   +------------+------------+
                   | EVIDENCE ASSEMBLY       |
                   | All required evidence   |
                   | received or timed out   |
                   +-------------------------+
```

### 3.3 Vendor Retry & Fallback Logic

```
                    +-------------------+
                    | ORDER EVIDENCE    |
                    | (Vendor Request)  |
                    +--------+----------+
                             |
                             v
                    +--------+----------+
                    | SEND TO PRIMARY   |
                    | VENDOR            |
                    +--------+----------+
                             |
                      +------+------+
                      | Response    |
                      | received?   |
                      +------+------+
                       Yes |    | Timeout
                           |    v
                           | +--+------------+
                           | | RETRY LOGIC   |
                           | |               |
                           | | Attempt 2     |
                           | | (wait 30s)    |
                           | +--+------------+
                           |    |
                           |    +-- Success? --+
                           |    |              |
                           |    | No           | Yes
                           |    v              |
                           | +--+------------+ |
                           | | Attempt 3     | |
                           | | (wait 60s)    | |
                           | +--+------------+ |
                           |    |              |
                           |    +-- Success? --+
                           |    |              |
                           |    | No           |
                           |    v              |
                           | +--+------------+ |
                           | | FAILOVER TO   | |
                           | | SECONDARY     | |
                           | | VENDOR        | |
                           | +--+------------+ |
                           |    |              |
                           |    +-- Success? --+
                           |    |              |
                           |    | No           |
                           |    v              |
                           | +--+------------+ |
                           | | MANUAL        | |
                           | | INTERVENTION  | |
                           | | QUEUE         | |
                           | | Alert ops     | |
                           | +--+------------+ |
                           |    |              |
                           +----+--------------+
                                |
                                v
                       +--------+--------+
                       | VALIDATE        |
                       | RESPONSE        |
                       |                 |
                       | - Schema check  |
                       | - SSN/DOB match |
                       | - Completeness  |
                       +--------+--------+
                                |
                         +------+------+
                         | Valid?      |
                         +------+------+
                          Yes |    | No
                              |    v
                              | +--+------------+
                              | | REORDER or    |
                              | | flag for      |
                              | | manual review |
                              | +---------------+
                              v
                       +------+----------+
                       | STORE IN        |
                       | EVIDENCE VAULT  |
                       | (immutable)     |
                       +-----------------+
```

### 3.4 APS Ordering Sub-Flow

The Attending Physician Statement is the highest-latency evidence source. It
requires special handling including provider lookup, HIPAA authorization
management, and persistent follow-up.

```
+----------------------+
| APS ORDER INITIATED  |
+----------+-----------+
           |
           v
+----------+-----------+
| PROVIDER LOOKUP      |
| - NPI registry       |
| - Carrier provider DB|
| - Applicant-provided |
|   physician info     |
+----------+-----------+
           |
    +------+------+
    | Provider     |
    | found?       |
    +------+------+
     Yes |    | No
         |    v
         | +--+------------+
         | | Contact       |
         | | applicant for |
         | | updated info  |
         | +--+------------+
         |    |
         |    +-- Received? --> Retry lookup
         |    |
         |    +-- Timeout ----> Proceed without
         |                      (flag for UW)
         v
+--------+----------+
| HIPAA AUTH CHECK   |
| - Valid auth on    |
|   file?            |
| - Auth not expired?|
+--------+----------+
         |
  +------+------+
  | Auth valid?  |
  +------+------+
   Yes |    | No
       |    v
       | +--+------------------+
       | | Request new auth    |
       | | from applicant      |
       | | (e-sign or wet-sign)|
       | +--+------------------+
       |    |
       +----+
            |
            v
+--------+--+--------+
| SUBMIT APS REQUEST |
| - Fax to provider  |
| - Electronic (if   |
|   available via EMR |
|   integration)      |
+--------+-----------+
         |
         v
+--------+-----------+
| FOLLOW-UP SCHEDULE |
|                    |
| Day 7:  1st follow-up call  |
| Day 14: 2nd follow-up + fax |
| Day 21: Escalation to       |
|         applicant (ask them  |
|         to contact MD)       |
| Day 30: Final attempt        |
| Day 35: Abandon or decide   |
|         without APS          |
+--------+-----------+
         |
         v
+--------+-----------+
| APS RECEIVED       |
| - Digitize/OCR     |
| - Structured data   |
|   extraction        |
| - Medical coding    |
|   (ICD-10 tagging)  |
+--------------------+
```

---

## 4. Accelerated Underwriting Path

Accelerated (or "fluidless") underwriting bypasses traditional medical exams
by relying on third-party data sources and predictive models to approximate
mortality risk. This is the fastest path and represents the competitive
frontier for carriers.

### 4.1 Eligibility Gate

```
                     +---------------------+
                     | CASE SUBMITTED      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | ACCELERATED UW      |
                     | ELIGIBILITY CHECK   |
                     +----------+----------+
                                |
            +-------------------+-------------------+
            |         |         |         |         |
            v         v         v         v         v
       +----+--+ +---+---+ +---+---+ +---+---+ +---+---+
       |Age    | |Face   | |Product| |State  | |Prior  |
       |18-60? | |<=$1M? | |Term?  | |Avail? | |Decline|
       +---+---+ +---+---+ +---+---+ +---+---+ +--+----+
           |          |         |         |        |
           +----------+---------+---------+--------+
                                |
                         +------+------+
                         | ALL PASS?   |
                         +------+------+
                          Yes |    | No
                              |    +---> Route to TRADITIONAL path
                              v
                     +--------+----------+
                     | ENTER ACCELERATED |
                     | UW PIPELINE       |
                     +-------------------+
```

### 4.2 Real-Time Data Waterfall

```
   +--------------------------------------------------------------------+
   |                 ACCELERATED UW PIPELINE                            |
   |                 (Target: < 60 seconds end-to-end)                  |
   +--------------------------------------------------------------------+
   |                                                                    |
   |  STEP 1: MIB CHECK (< 3 sec)                                      |
   |  +------------------+                                              |
   |  | Query MIB AURA   +---> Hit? --+                                 |
   |  | (code match on   |            |                                 |
   |  |  insured SSN+DOB)|     +------+------+                          |
   |  +------------------+     | Impairment  |                          |
   |                           | code in     |                          |
   |                           | knockout    |                          |
   |                           | list?       |                          |
   |                           +------+------+                          |
   |                            No |     | Yes                          |
   |                               |     +----> DIVERT to Traditional   |
   |                               v                                    |
   |  STEP 2: Rx HISTORY (< 5 sec)                                     |
   |  +------------------+                                              |
   |  | Query Rx DB      +---> Matches? --+                             |
   |  | (Milliman        |                |                             |
   |  |  IntelliScript   |    +-----------+-----------+                 |
   |  |  or ExamOne)     |    | Score Rx profile      |                 |
   |  +------------------+    | - Drug classification  |                 |
   |                          | - Duration of therapy  |                 |
   |                          | - Compliance patterns  |                 |
   |                          | - Contraindications    |                 |
   |                          +-----------+-----------+                 |
   |                                      |                             |
   |                               +------+------+                      |
   |                               | Rx risk     |                      |
   |                               | score > 75? |                      |
   |                               +------+------+                      |
   |                                No |     | Yes                      |
   |                                   |     +----> DIVERT              |
   |                                   v                                |
   |  STEP 3: MVR (< 15 sec)                                           |
   |  +------------------+                                              |
   |  | Query Motor      +---> Violations? --+                          |
   |  | Vehicle Records  |                   |                          |
   |  | (LexisNexis)     |    +--------------+----------+               |
   |  +------------------+    | Evaluate:               |               |
   |                          | - DUI/DWI count         |               |
   |                          | - Reckless driving      |               |
   |                          | - License suspensions   |               |
   |                          | - Moving violations     |               |
   |                          +--------------+----------+               |
   |                                         |                          |
   |                                  +------+------+                   |
   |                                  | MVR risk    |                   |
   |                                  | exceeds     |                   |
   |                                  | threshold?  |                   |
   |                                  +------+------+                   |
   |                                   No |     | Yes                   |
   |                                      |     +----> DIVERT           |
   |                                      v                             |
   |  STEP 4: CREDIT / PUBLIC RECORDS (< 10 sec)                       |
   |  +------------------+                                              |
   |  | Query credit     +---> Score + attributes --+                   |
   |  | bureau           |                          |                   |
   |  | (TransUnion /    |    +---------------------+-----+             |
   |  |  LexisNexis)     |    | Extract:                  |             |
   |  +------------------+    | - Credit-based insurance  |             |
   |                          |   score                   |             |
   |                          | - Bankruptcy history      |             |
   |                          | - Liens / judgments       |             |
   |                          | - Address stability       |             |
   |                          +---------------------+-----+             |
   |                                                |                   |
   |                                                v                   |
   |  STEP 5: PREDICTIVE MODEL SCORING (< 2 sec)                       |
   |  +--------------------------------------------------+             |
   |  | INPUTS:                   | OUTPUT:               |             |
   |  | - Application answers     | - Mortality risk      |             |
   |  | - MIB results             |   score (0-1000)      |             |
   |  | - Rx profile              | - Confidence level    |             |
   |  | - MVR results             | - Recommended class   |             |
   |  | - Credit attributes       | - Auto-decision       |             |
   |  | - Demographic data        |   eligibility flag    |             |
   |  +--------------------------------------------------+             |
   |                                                |                   |
   |                                         +------+------+           |
   |                                         | Score in    |           |
   |                                         | auto-approve|           |
   |                                         | band?       |           |
   |                                         +------+------+           |
   |                                          Yes |     | No           |
   |                                              |     +-> DIVERT     |
   |                                              v                    |
   |  STEP 6: RULES ENGINE DECISION (< 1 sec)                         |
   |  +--------------------------------------------------+            |
   |  | Apply underwriting rules:                         |            |
   |  | - State-specific requirements                     |            |
   |  | - Product eligibility                             |            |
   |  | - Rate class assignment                           |            |
   |  | - Face amount limits by class                     |            |
   |  |                                                   |            |
   |  | DECISION: APPROVE at [class] or DIVERT            |            |
   |  +--------------------------------------------------+            |
   |                                                                   |
   +-------------------------------------------------------------------+
```

### 4.3 Accelerated UW Diversion Logic

When a case is diverted from accelerated to traditional, the system must
preserve all evidence already gathered and determine what additional evidence
is needed.

```
+-------------------+
| DIVERT TRIGGERED  |
| (from any step)   |
+--------+----------+
         |
         v
+--------+----------+
| PRESERVE EXISTING |
| EVIDENCE          |
| - MIB results     |
| - Rx data         |
| - MVR data        |
| - Credit data     |
| - Model scores    |
+--------+----------+
         |
         v
+--------+-----------+
| DETERMINE GAP      |
| What additional     |
| evidence is needed? |
|                     |
| - Paramedical exam? |
| - APS required?     |
| - Lab panel?        |
| - Inspection?       |
+--------+-----------+
         |
         v
+--------+-----------+
| ROUTE TO           |
| TRADITIONAL PATH   |
| (Section 5)        |
| Status: DIVERTED   |
+--------------------+
```

---

## 5. Traditional Full Underwriting Path

When a case does not qualify for accelerated underwriting — or is diverted from
it — it enters the traditional path. This involves physical exams, lab work,
and physician records.

### 5.1 Traditional Evidence Collection Flow

```
                     +---------------------+
                     | CASE ENTERS         |
                     | TRADITIONAL PATH    |
                     +----------+----------+
                                |
          +---------------------+---------------------+
          |                     |                      |
          v                     v                      v
+---------+---------+ +---------+---------+ +----------+---------+
| PARAMEDICAL EXAM  | | LABORATORY WORK   | | APS ORDERING       |
| SCHEDULING        | | (if separate from | | (See Section 3.4)  |
|                   | |  paramedical)     | |                    |
| 1. Find examiner  | |                   | | - Primary MD       |
|    near applicant | | - Blood profile   | | - Specialists      |
| 2. Schedule appt  | |   (chem panel,    | |   (cardiologist,   |
|    (mobile or     | |    CBC, lipids)   | |    oncologist, etc.)|
|    clinic)        | | - Urine specimen  | |                    |
| 3. Confirm with   | | - HbA1c (if age  | |                    |
|    applicant      | |   > 50 or BMI>30) | |                    |
| 4. Reminder       | | - HIV screen      | |                    |
|    notifications  | | - PSA (male > 50) | |                    |
|    (SMS/email)    | | - NT-proBNP       | |                    |
|                   | |   (age > 60,      | |                    |
|                   | |    face > $500K)  | |                    |
+---------+---------+ +---------+---------+ +----------+---------+
          |                     |                      |
          v                     v                      |
+---------+---------+ +---------+---------+            |
| EXAM COMPLETED    | | LAB RESULTS       |            |
|                   | | RECEIVED          |            |
| - Height/Weight   | |                   |            |
| - Blood pressure  | | - Values within   |            |
|   (2 readings)    | |   normal range?   |            |
| - Pulse           | | - Abnormal flags  |            |
| - Medical history | | - Critical values |            |
|   verification    | |   (immediate      |            |
| - Specimen        | |    alert)         |            |
|   collection      | |                   |            |
+---------+---------+ +---------+---------+            |
          |                     |                      |
          +---------------------+----------------------+
                                |
                                v
                   +------------+------------+
                   | EVIDENCE ASSEMBLY       |
                   |                         |
                   | All items received?     |
                   | - Paramedical report    |
                   | - Lab results           |
                   | - APS (all ordered)     |
                   | - MIB                   |
                   | - Rx                    |
                   | - MVR                   |
                   | - Inspection (if any)   |
                   | - Financial docs        |
                   +------------+------------+
                                |
                         +------+------+
                         | COMPLETE?   |
                         +------+------+
                          Yes |    | No
                              |    v
                              | +--+-------------+
                              | | OUTSTANDING    |
                              | | REQUIREMENTS   |
                              | | TRACKING       |
                              | | (Section 11)   |
                              | +----------------+
                              v
                   +----------+----------+
                   | READY FOR           |
                   | UNDERWRITING REVIEW |
                   | Status: IN_REVIEW   |
                   +---------------------+
```

### 5.2 Paramedical Exam Scheduling State Machine

```
    +----------+      Schedule      +----------+
    |          +--------------------> SCHEDULED |
    | ORDERED  |                    |          |
    |          <----+               +-----+----+
    +----------+    |                     |
                    |              +------+------+
              Reschedule          | Exam window |
                    |             | approaching |
                    |             +------+------+
                    |                    |
                    |           +--------+--------+
                    |           | Applicant       |
                    |           | confirmed?      |
                    |           +--------+--------+
                    |            Yes |       | No
                    |                |       v
                    |                | +-----+--------+
                    |                | | Send reminder|
                    |                | | (SMS/email)  |
                    |                | +-----+--------+
                    |                |       |
                    |                |  +----+-----+
                    |                |  | Response? |
                    |                |  +----+-----+
                    |                |   Yes | | No (x3)
                    |                +------+ |
                    +-------------------------+
                                     |        |
                              +------+  +-----+-------+
                              |         | ABANDONED    |
                              v         | (NIGO)       |
                    +---------+---+     +--------------+
                    | COMPLETED   |
                    +-------------+
```

---

## 6. Triage & Assignment Flow

Once evidence is assembled, the case must be routed to the correct underwriter.
Automated triage evaluates case complexity and matches it to underwriter
skill level and current workload.

### 6.1 Triage Scoring Model

```
                     +---------------------+
                     | EVIDENCE ASSEMBLED  |
                     | Case ready for UW   |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | AUTOMATED TRIAGE    |
                     | SCORING ENGINE      |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
     +--------+------+  +------+--------+  +------+--------+
     | MEDICAL       |  | FINANCIAL     |  | OPERATIONAL   |
     | COMPLEXITY    |  | COMPLEXITY    |  | COMPLEXITY    |
     | SCORE         |  | SCORE         |  | SCORE         |
     |               |  |               |  |               |
     | Factors:      |  | Factors:      |  | Factors:      |
     | - # of MIB    |  | - Face amount |  | - # of APS    |
     |   hits        |  | - Income      |  |   docs        |
     | - Rx severity |  |   multiple    |  | - Evidence    |
     | - Lab abnorm. |  | - Existing    |  |   gaps        |
     | - # of Rx     |  |   insurance   |  | - Case age    |
     |   drugs       |  | - Net worth   |  | - Reinsurance |
     | - BMI range   |  |   verification|  |   required?   |
     | - Age factor  |  |   needed      |  | - State-spec. |
     |               |  |               |  |   complexity  |
     | Score: 0-100  |  | Score: 0-100  |  | Score: 0-100  |
     +--------+------+  +------+--------+  +------+--------+
              |                 |                  |
              +-----------------+-----------------+
                                |
                                v
                     +----------+----------+
                     | COMPOSITE TRIAGE    |
                     | SCORE               |
                     | = 0.5*Med + 0.3*Fin |
                     |   + 0.2*Ops         |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
     +--------+------+  +------+--------+  +------+--------+
     | TIER 1        |  | TIER 2        |  | TIER 3        |
     | Score: 0-30   |  | Score: 31-65  |  | Score: 66-100 |
     |               |  |               |  |               |
     | Junior UW     |  | Senior UW     |  | Chief UW /    |
     | Auto-assist   |  | Full manual   |  | Medical Dir.  |
     | rules         |  | review        |  | Complex cases |
     +--------+------+  +------+--------+  +------+--------+
              |                 |                  |
              v                 v                  v
         ASSIGNMENT        ASSIGNMENT         ASSIGNMENT
```

### 6.2 Workload-Balanced Assignment

```
                     +---------------------+
                     | TIER DETERMINED     |
                     | (e.g., Tier 2)      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | ELIGIBLE UW POOL    |
                     | Query: active UWs   |
                     | with Tier 2 skill   |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | FOR EACH UW,        |
                     | CALCULATE:          |
                     |                     |
                     | capacity_score =    |
                     |   max_cases         |
                     |   - current_cases   |
                     |                     |
                     | skill_match =       |
                     |   match(case_flags, |
                     |   uw_specialties)   |
                     |                     |
                     | priority_boost =    |
                     |   case_age_penalty  |
                     |   + sla_urgency     |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | RANK UWs by:        |
                     | 1. Skill match      |
                     | 2. Available cap.   |
                     | 3. Round-robin tiebrk|
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | ASSIGN TO TOP-      |
                     | RANKED UW           |
                     |                     |
                     | Status: ASSIGNED    |
                     | Event: CaseAssigned |
                     | Notify UW via       |
                     | workbench alert     |
                     +---------------------+
```

### 6.3 Skill-Based Routing Categories

```
+-------------------+--------------------------------------------+
| Specialty         | Case Characteristics Routed Here           |
+-------------------+--------------------------------------------+
| Cardiac           | MIB cardiac codes, Rx beta-blockers,       |
|                   | statins, abnormal lipids/BP                |
+-------------------+--------------------------------------------+
| Oncology          | Cancer history, MIB cancer codes,          |
|                   | surveillance Rx patterns                   |
+-------------------+--------------------------------------------+
| Psychiatric /     | Psych Rx profile, substance use history,   |
| Behavioral        | MIB mental health codes                    |
+-------------------+--------------------------------------------+
| Diabetes /        | Elevated HbA1c, insulin/metformin Rx,      |
| Metabolic         | BMI > 35, metabolic syndrome indicators    |
+-------------------+--------------------------------------------+
| Aviation / Avoc.  | Pilot, scuba, skydiving, rock climbing     |
+-------------------+--------------------------------------------+
| Foreign Travel /  | Residence or travel to high-risk regions   |
| Residence         |                                            |
+-------------------+--------------------------------------------+
| Financial /       | Face > $5M, business insurance, trust-     |
| High Net Worth    | owned, estate planning cases               |
+-------------------+--------------------------------------------+
| Jumbo Cases       | Face > $10M, multiple carrier coordination |
+-------------------+--------------------------------------------+
```

---

## 7. Medical Underwriting Decision Flow

This section details the cognitive workflow a human underwriter follows when
evaluating a case, translated into system-supported process steps.

### 7.1 Underwriter Case Review Flow

```
                     +---------------------+
                     | CASE ASSIGNED       |
                     | TO UNDERWRITER      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | OPEN CASE IN        |
                     | UW WORKBENCH        |
                     |                     |
                     | Display:            |
                     | - Summary dashboard |
                     | - Risk indicators   |
                     | - Pre-scored flags  |
                     +----------+----------+
                                |
                                v
             +------------------+-------------------+
             |                  |                    |
             v                  v                    v
    +--------+------+  +-------+--------+  +--------+--------+
    | REVIEW        |  | REVIEW         |  | REVIEW          |
    | APPLICATION   |  | MEDICAL        |  | FINANCIAL       |
    | DATA          |  | EVIDENCE       |  | DATA            |
    |               |  |                |  |                 |
    | - Personal    |  | - Lab results  |  | - Income stated |
    |   info        |  | - APS records  |  |   vs verified   |
    | - Occupation  |  | - Rx history   |  | - Existing      |
    | - Avocations  |  | - MIB codes    |  |   coverage      |
    | - Travel      |  | - Exam results |  | - Net worth     |
    | - Family hx   |  | - MVR          |  | - Need analysis |
    +--------+------+  +-------+--------+  +--------+--------+
             |                  |                    |
             +------------------+--------------------+
                                |
                                v
                     +----------+----------+
                     | IMPAIRMENT          |
                     | ASSESSMENT          |
                     |                     |
                     | For EACH identified |
                     | impairment:         |
                     | 1. Classify (ICD-10)|
                     | 2. Assess severity  |
                     | 3. Determine        |
                     |    stability        |
                     | 4. Check treatment  |
                     |    compliance       |
                     | 5. Look up in       |
                     |    mortality table  |
                     | 6. Assign debit     |
                     |    (extra mortality)|
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | DEBIT / CREDIT      |
                     | CALCULATION         |
                     |                     |
                     | DEBITS (add risk):  |
                     | + Cardiac hx: +150  |
                     | + Controlled DM:+75 |
                     | + BMI 32: +25       |
                     | + MVR (2 tickets):  |
                     |   +25               |
                     |                     |
                     | CREDITS (reduce):   |
                     | - Non-smoker: -25   |
                     | - Exercise: -10     |
                     | - Favorable labs:-15|
                     |                     |
                     | NET DEBITS: +225    |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | MORTALITY           |
                     | CLASSIFICATION      |
                     |                     |
                     | Net debits map:     |
                     | 0-75    -> Preferred |
                     | 76-125  -> Standard+|
                     | 126-175 -> Standard |
                     | 176-250 -> Table B  |
                     | 251-350 -> Table D  |
                     | 351-500 -> Table H  |
                     | > 500   -> Decline  |
                     +----------+----------+
                                |
                         +------+------+
                         | Class <=    |
                         | Table H?    |
                         +------+------+
                          Yes |    | No
                              |    +---> DECLINE (Section 13)
                              v
                     +--------+----------+
                     | DETERMINE FINAL    |
                     | OFFER              |
                     |                    |
                     | Compare:           |
                     | - Applied-for class|
                     | - Assessed class   |
                     +--------+----------+
                              |
                    +---------+---------+
                    |                   |
                    v                   v
           +-------+------+    +-------+------+
           | ASSESSED <=  |    | ASSESSED >   |
           | APPLIED-FOR  |    | APPLIED-FOR  |
           |              |    |              |
           | APPROVE at   |    | COUNTER-OFFER|
           | applied-for  |    | (Section 12) |
           | class (or    |    |              |
           | upgrade!)    |    |              |
           +--------------+    +--------------+
```

### 7.2 Multi-Impairment Interaction Rules

```
+-------------------------------------------------------------------+
| IMPAIRMENT INTERACTION MATRIX                                     |
+-------------------------------------------------------------------+
|                                                                   |
| When multiple impairments coexist, debits may compound:           |
|                                                                   |
|   Diabetes + Hypertension                                         |
|   Individual: DM = +75, HTN = +50                                 |
|   Combined:   +75 + +50 + interaction_penalty(+50) = +175         |
|                                                                   |
|   Diabetes + Obesity + Hypertension                               |
|   Individual: DM = +75, Obesity = +50, HTN = +50                  |
|   Combined:   +75 + +50 + +50 + metabolic_syndrome_penalty(+100)  |
|              = +275 (not simple addition of +175)                  |
|                                                                   |
|   Cancer (remission) + Depression                                 |
|   Individual: Cancer = +150, Depression = +50                     |
|   Combined:   +150 + +50 (no interaction — independent risks)     |
|              = +200                                                |
|                                                                   |
| System implementation: maintain an interaction rule table          |
| keyed by ICD-10 code pairs with additive penalty values.          |
+-------------------------------------------------------------------+
```

---

## 8. Financial Underwriting Flow

Financial underwriting ensures the amount of insurance applied for is
economically justified and guards against moral hazard, speculation, and
anti-selection.

### 8.1 Financial Underwriting Decision Flow

```
                     +---------------------+
                     | MEDICAL UW          |
                     | APPROVED/CLASSED    |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | FINANCIAL UW        |
                     | EVALUATION          |
                     +----------+----------+
                                |
         +----------------------+----------------------+
         |                      |                       |
         v                      v                       v
+--------+--------+   +---------+---------+   +---------+---------+
| INCOME          |   | EXISTING COVERAGE |   | PURPOSE / NEED    |
| VERIFICATION    |   | CHECK             |   | ANALYSIS          |
|                 |   |                   |   |                   |
| Sources:        |   | - MIB coverage    |   | - Income          |
| - Tax returns   |   |   codes           |   |   replacement     |
| - Employer      |   | - Application     |   |   (10-20x annual) |
|   verification  |   |   disclosure      |   | - Mortgage         |
| - Business      |   | - Industry DB     |   |   protection      |
|   financials    |   |   (CLUE, LENS)    |   | - Business needs  |
|   (if owner)    |   |                   |   | - Estate planning |
| - Net worth     |   | Total existing +  |   | - Charitable      |
|   statement     |   | applied = Total   |   |   intent          |
|                 |   | coverage          |   |                   |
+--------+--------+   +---------+---------+   +---------+---------+
         |                      |                       |
         +----------------------+-----------------------+
                                |
                                v
                     +----------+----------+
                     | JUSTIFICATION       |
                     | CALCULATION         |
                     |                     |
                     | Earned income:      |
                     |   Multiple = 20x    |
                     |   (age < 40)        |
                     |   Multiple = 15x    |
                     |   (age 40-50)       |
                     |   Multiple = 10x    |
                     |   (age 50+)         |
                     |                     |
                     | Max justified =     |
                     |   Income * Multiple |
                     |   + Net worth adj   |
                     |   - Existing cov    |
                     +----------+----------+
                                |
                         +------+------+
                         | Applied <=  |
                         | Max just.?  |
                         +------+------+
                          Yes |    | No
                              |    v
                              |  +-+---------------+
                              |  | OPTIONS:        |
                              |  | 1. Request add'l|
                              |  |    financial    |
                              |  |    docs         |
                              |  | 2. Counter-offer|
                              |  |    reduced face |
                              |  | 3. Decline      |
                              |  +-----------------+
                              v
                     +--------+----------+
                     | JUMBO CASE        |
                     | THRESHOLD CHECK   |
                     |                   |
                     | Face > $5M?       |
                     +--------+----------+
                              |
                    +---------+---------+
                    |  No               | Yes
                    v                   v
             +------+------+    +------+----------+
             | FINANCIAL   |    | JUMBO REVIEW    |
             | APPROVED    |    |                 |
             |             |    | - 2nd UW review |
             | Proceed to  |    | - Fin. docs req.|
             | reinsurance |    | - Net worth     |
             |             |    |   verification  |
             +-------------+    | - Source of     |
                                |   wealth        |
                                | - Trust review  |
                                |   (if ILIT)     |
                                +------+----------+
                                       |
                                       v
                                +------+------+
                                | Jumbo       |
                                | approved?   |
                                +------+------+
                                 Yes |    | No
                                     |    +---> Counter / Decline
                                     v
                                PROCEED TO
                                REINSURANCE
```

### 8.2 Income Multiple Guidelines

```
+-------------------+------------------+-------------------+
| Age Band          | Earned Income    | Unearned Income   |
|                   | Multiple         | Multiple          |
+-------------------+------------------+-------------------+
| 18-25             | 25x              | 10x               |
| 26-35             | 25x              | 10x               |
| 36-40             | 20x              | 8x                |
| 41-45             | 18x              | 7x                |
| 46-50             | 15x              | 6x                |
| 51-55             | 12x              | 5x                |
| 56-60             | 10x              | 4x                |
| 61-65             | 8x               | 3x                |
| 66-70             | 5x               | 2x                |
| 71+               | 3x               | 1x                |
+-------------------+------------------+-------------------+

Non-working spouse: 50-100% of working spouse coverage, capped at $1M
Key-person: 5-10x annual contribution to business, based on revenue impact
Buy-sell: proportionate share of business value, independently appraised
```

---

## 9. Reinsurance Cession Flow

Reinsurance offloads a portion of mortality risk to a reinsurer. Cases within
the automatic treaty binding limits are ceded automatically. Cases exceeding
those limits require facultative submission.

### 9.1 Reinsurance Decision Flow

```
                     +---------------------+
                     | UW DECISION:        |
                     | APPROVE at [class]  |
                     | Face: $X            |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | CALCULATE RETENTION |
                     |                     |
                     | Carrier retention   |
                     | limit (per life):   |
                     |   Preferred: $5M    |
                     |   Standard:  $3M    |
                     |   Substandard: $1M  |
                     +----------+----------+
                                |
                         +------+------+
                         | Face >      |
                         | retention?  |
                         +------+------+
                          No  |    | Yes
                              |    v
                              | +--+-------------------+
                              | | CESSION REQUIRED     |
                              | +--+-------------------+
                              |    |
                              |    v
                              | +--+-------------------+
                              | | Net amount at risk   |
                              | | = Face - retention   |
                              | +--+-------------------+
                              |    |
                              |    v
                              | +--+-------------------+
                              | | NAR <= Automatic     |
                              | | binding limit?       |
                              | +--+---+---------------+
                              |   Yes  |  No
                              |    |   v
                              |    | +-+-------------------+
                              |    | | FACULTATIVE        |
                              |    | | SUBMISSION         |
                              |    | | (See 9.2)          |
                              |    | +--+------------------+
                              |    |    |
                              |    v    |
                              | +--+----+--+
                              | | AUTO     |
                              | | TREATY   |
                              | | CESSION  |
                              | |          |
                              | | - Apply  |
                              | |   treaty |
                              | |   terms  |
                              | | - Report |
                              | |   to     |
                              | |   reins. |
                              | |   in     |
                              | |   monthly|
                              | |   border-|
                              | |   eau    |
                              | +--+-------+
                              |    |
                              +----+
                                   |
                                   v
                          +--------+--------+
                          | PROCEED TO      |
                          | POLICY ISSUE    |
                          +-----------------+
```

### 9.2 Facultative Submission Flow

```
                     +---------------------+
                     | FACULTATIVE         |
                     | REQUIRED            |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | PREPARE SUBMISSION  |
                     | PACKAGE             |
                     |                     |
                     | - Cover letter      |
                     | - Application copy  |
                     | - All medical       |
                     |   evidence          |
                     | - UW assessment     |
                     |   & classification  |
                     | - Financial summary |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | SELECT REINSURER(S) |
                     |                     |
                     | Strategy:           |
                     | - Primary treaty    |
                     |   reinsurer first   |
                     | - If capacity       |
                     |   insufficient,     |
                     |   split across      |
                     |   multiple          |
                     | - Simultaneous vs   |
                     |   sequential offers |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | SUBMIT TO           |
                     | REINSURER(S)        |
                     |                     |
                     | Channel:            |
                     | - FACPRO / EDGE     |
                     |   (electronic)      |
                     | - Email (fallback)  |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | AWAIT RESPONSE      |
                     | SLA: 3-5 bus. days  |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
     +--------+------+ +-------+--------+ +-------+--------+
     | ACCEPTED      | | COUNTER-OFFER  | | DECLINED       |
     |               | |                | |                |
     | Proceed with  | | Reinsurer      | | Try alternate  |
     | cession at    | | offers diff.   | | reinsurer or   |
     | quoted terms  | | rate/terms     | | reduce face to |
     |               | |                | | within auto    |
     |               | | Evaluate and   | | binding limit  |
     |               | | accept/reject  | |                |
     +---------------+ +----------------+ +----------------+
```

---

## 10. Policy Issue & Delivery Flow

After underwriting approval and reinsurance cession, the case moves to policy
issue. This phase performs final compliance checks, collects premium, assembles
the policy document, and delivers it to the applicant.

### 10.1 Policy Issue Flow

```
                     +---------------------+
                     | UW APPROVED &       |
                     | REINSURANCE CEDED   |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | PRE-ISSUE           |
                     | COMPLIANCE CHECKS   |
                     |                     |
                     | 1. OFAC / SDN       |
                     |    screening        |
                     | 2. State-specific   |
                     |    requirements     |
                     | 3. Replacements /   |
                     |    1035 exchange    |
                     |    forms complete?  |
                     | 4. Suitability      |
                     |    review (if req.) |
                     | 5. Illustration     |
                     |    accuracy         |
                     +----------+----------+
                                |
                         +------+------+
                         | All clear?  |
                         +------+------+
                          Yes |    | No
                              |    v
                              | +--+--------------------+
                              | | HOLD - resolve        |
                              | | compliance issues     |
                              | | before proceeding     |
                              | +--+--------------------+
                              |    |
                              +----+
                                   |
                                   v
                     +-------------+----------+
                     | PREMIUM VERIFICATION   |
                     |                        |
                     | 1. Calculate final     |
                     |    premium at issued   |
                     |    class               |
                     | 2. Compare to quoted   |
                     |    premium             |
                     | 3. Adjust payment      |
                     |    (if class changed)  |
                     | 4. Collect / refund    |
                     |    difference          |
                     +-------------+----------+
                                   |
                            +------+------+
                            | Premium     |
                            | collected?  |
                            +------+------+
                             Yes |    | No
                                 |    v
                                 | +--+-----------------------+
                                 | | PAYMENT PENDING         |
                                 | | - Send payment link     |
                                 | | - ACH re-authorization  |
                                 | | - Agent premium collection|
                                 | +--+-----------------------+
                                 |    |
                                 +----+
                                      |
                                      v
                     +----------------+----------+
                     | POLICY ASSEMBLY            |
                     |                            |
                     | Generate:                  |
                     | - Policy face page         |
                     | - Schedule of benefits     |
                     | - Riders & endorsements    |
                     | - State-mandated notices   |
                     | - Privacy notice           |
                     | - Beneficiary designation  |
                     | - Premium schedule         |
                     | - Conversion privilege      |
                     |   notice                   |
                     +----------------+-----------+
                                      |
                                      v
                     +----------------+-----------+
                     | QUALITY CHECK              |
                     |                            |
                     | - Name/DOB accuracy        |
                     | - Face amount correct      |
                     | - Premium correct          |
                     | - Riders match application |
                     | - Beneficiaries correct    |
                     | - State filing approved    |
                     +----------------+-----------+
                                      |
                                      v
                     +----------------+-----------+
                     | DELIVERY                   |
                     +----------------+-----------+
                                      |
                    +-----------------+-----------------+
                    |                                   |
                    v                                   v
           +-------+--------+                 +--------+--------+
           | E-DELIVERY     |                 | PAPER DELIVERY  |
           |                |                 |                 |
           | - Email with   |                 | - Print & mail  |
           |   secure link  |                 |   to agent or   |
           | - DocuSign     |                 |   applicant     |
           |   delivery     |                 | - Delivery      |
           |   receipt      |                 |   receipt via   |
           | - In-app       |                 |   agent upload  |
           |   notification |                 |   or POD        |
           |                |                 |                 |
           +-------+--------+                 +--------+--------+
                   |                                   |
                   +-----------------------------------+
                                      |
                                      v
                     +----------------+-----------+
                     | DELIVERY RECEIPT           |
                     | CONFIRMATION               |
                     |                            |
                     | Start free-look clock      |
                     | (10 or 30 days by state)   |
                     +----------------+-----------+
                                      |
                                      v
                     +----------------+-----------+
                     | POLICY STATUS: IN FORCE   |
                     | Event: PolicyIssued        |
                     | Notify: Agent, applicant,  |
                     |   admin systems            |
                     +----------------------------+
```

### 10.2 Free-Look Period Handling

```
                     +--------------------+
                     | POLICY DELIVERED   |
                     | Free-look starts   |
                     +--------+-----------+
                              |
                    +---------+---------+
                    |                   |
                    v                   v
           +-------+--------+  +-------+--------+
           | NO ACTION BY   |  | APPLICANT      |
           | APPLICANT      |  | RETURNS POLICY |
           |                |  |                |
           | Free-look      |  | - Full premium |
           | expires ->     |  |   refund       |
           | Policy binding |  | - Void policy  |
           |                |  | - Release       |
           |                |  |   reinsurance  |
           |                |  | - No adverse   |
           |                |  |   coding       |
           +----------------+  +----------------+
```

---

## 11. Exception Handling Flows

Real-world underwriting involves many exception scenarios. Robust handling of
these exceptions is critical for operational efficiency and applicant experience.

### 11.1 Outstanding Requirements Tracking

```
                     +---------------------+
                     | EVIDENCE GAP        |
                     | DETECTED            |
                     | (Missing item)      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | CREATE REQUIREMENT  |
                     | RECORD              |
                     |                     |
                     | - Type: APS / Exam /|
                     |   Financial / Form  |
                     | - Owner: Applicant /|
                     |   Agent / Vendor /  |
                     |   Internal          |
                     | - Due date          |
                     | - Priority          |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | SEND NOTIFICATION   |
                     |                     |
                     | To owner via:       |
                     | - Email             |
                     | - SMS               |
                     | - Agent portal alert|
                     | - API callback      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | FOLLOW-UP           |
                     | SCHEDULE            |
                     |                     |
                     | Day 0:  Initial req |
                     | Day 5:  Reminder 1  |
                     | Day 10: Reminder 2  |
                     | Day 15: Escalation  |
                     |   (to agent / mgr)  |
                     | Day 20: Final notice|
                     | Day 25: Incomplete  |
                     |   decision          |
                     +----------+----------+
                                |
                         +------+------+
                         | Received?   |
                         +------+------+
                          Yes |    | No (past SLA)
                              |    v
                              | +--+------------------+
                              | | DISPOSITION:        |
                              | | 1. Decide without   |
                              | |    (if possible)    |
                              | | 2. Postpone case    |
                              | | 3. Close as         |
                              | |    incomplete       |
                              | +---------+-----------+
                              |           |
                              +-----------+
                                          |
                                          v
                                   Continue flow
```

### 11.2 Vendor Failure Recovery

```
                     +---------------------+
                     | VENDOR SYSTEM       |
                     | ERROR / OUTAGE      |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | CLASSIFY FAILURE    |
                     +----------+----------+
                                |
         +----------------------+----------------------+
         |                      |                       |
         v                      v                       v
+--------+--------+   +---------+---------+   +---------+---------+
| TRANSIENT       |   | VENDOR OUTAGE     |   | DATA QUALITY      |
| ERROR           |   |                   |   | ERROR             |
| (timeout, 5xx)  |   | (scheduled or     |   | (bad SSN, no      |
|                 |   |  unplanned)       |   |  match, corrupted)|
| Action:         |   |                   |   |                   |
| Retry with      |   | Action:           |   | Action:           |
| exponential     |   | 1. Check status   |   | 1. Validate input |
| backoff         |   |    page           |   | 2. Correct and    |
| (3 attempts)    |   | 2. Queue for      |   |    resubmit       |
|                 |   |    retry when     |   | 3. Manual order   |
|                 |   |    restored       |   |    if persists     |
|                 |   | 3. Switch to      |   |                   |
|                 |   |    backup vendor  |   |                   |
+---------+-------+   +---------+---------+   +---------+---------+
          |                     |                       |
          +---------------------+-----------------------+
                                |
                         +------+------+
                         | Resolved?   |
                         +------+------+
                          Yes |    | No
                              |    v
                              | +--+------------------+
                              | | ESCALATE TO         |
                              | | OPERATIONS TEAM     |
                              | | - Page on-call      |
                              | | - Create incident   |
                              | | - Manual workaround |
                              | +---------------------+
                              v
                        Continue flow
```

### 11.3 Applicant Non-Response Flow

```
                     +---------------------+
                     | APPLICANT ACTION    |
                     | REQUIRED            |
                     | (exam, docs, etc.)  |
                     +----------+----------+
                                |
                                v
              +-----------------+-----------------+
              | MULTI-CHANNEL OUTREACH            |
              |                                   |
              | Day 0: Email + SMS notification   |
              | Day 3: Email reminder             |
              | Day 5: SMS reminder               |
              | Day 7: Agent notification (if     |
              |        agent channel)             |
              | Day 10: Phone call attempt 1      |
              | Day 14: Phone call attempt 2      |
              | Day 18: Final notice (registered  |
              |         mail if state requires)   |
              +-----------------+-----------------+
                                |
                         +------+------+
                         | Response    |
                         | received?   |
                         +------+------+
                          Yes |    | No (Day 25+)
                              |    v
                              | +--+------------------+
                              | | CLOSE CASE          |
                              | | Status: INCOMPLETE  |
                              | | Reason: APPLICANT   |
                              | |   NON-RESPONSE      |
                              | |                     |
                              | | Actions:            |
                              | | - Refund premium    |
                              | | - Release MIB hold  |
                              | | - Notify agent      |
                              | | - Archive case      |
                              | +---------------------+
                              v
                        Continue flow
```

---

## 12. Counter-Offer Flow

When the underwriting assessment results in a different risk classification than
what the applicant applied for, the carrier must present a counter-offer and
manage the applicant's response.

### 12.1 Counter-Offer Decision & Communication

```
                     +---------------------+
                     | UW DECISION:        |
                     | Assessed class !=   |
                     | Applied-for class   |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | DETERMINE COUNTER-  |
                     | OFFER TYPE          |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                                   |
              v                                   v
     +--------+--------+                 +--------+--------+
     | RATE CLASS       |                 | FACE AMOUNT     |
     | MODIFICATION     |                 | MODIFICATION    |
     |                  |                 |                  |
     | Applied: Pref NT |                 | Applied: $1M   |
     | Offered: Std NT  |                 | Offered: $500K |
     |                  |                 |                  |
     | Premium impact:  |                 | Same class but  |
     | Calculate new    |                 | reduced face    |
     | premium at       |                 | (financial UW   |
     | offered class    |                 | justification)  |
     +--------+---------+                 +--------+--------+
              |                                    |
              +------------------------------------+
                                |
                                v
                     +----------+----------+
                     | GENERATE COUNTER-   |
                     | OFFER PACKAGE       |
                     |                     |
                     | - Offer letter      |
                     | - New premium quote |
                     | - Reason for change |
                     |   (if disclosable)  |
                     | - Accept/reject form|
                     | - Expiration date   |
                     |   (typically 30 days)|
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | DELIVER TO          |
                     | APPLICANT & AGENT   |
                     |                     |
                     | - Email to applicant|
                     | - Agent portal notif|
                     | - Portal counter-   |
                     |   offer acceptance  |
                     |   workflow          |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | AWAIT RESPONSE      |
                     | SLA: 30 calendar    |
                     | days                |
                     +----------+----------+
                                |
              +-----------------+------------------+
              |                 |                   |
              v                 v                   v
     +--------+------+ +-------+--------+  +-------+--------+
     | ACCEPT        | | REJECT         |  | NO RESPONSE    |
     |               | |                |  |                |
     | - Update      | | - Close case   |  | - Close case   |
     |   class/face  | | - Refund prem  |  |   (after SLA)  |
     | - Re-calculate| | - Adverse      |  | - Same as      |
     |   premium     | |   action if    |  |   reject       |
     | - Amendment   | |   applicable   |  |                |
     |   signed      | | - No MIB code  |  |                |
     | - Proceed to  | |   for carrier- |  |                |
     |   issue       | |   initiated    |  |                |
     |               | |   change       |  |                |
     +-------+-------+ +-------+--------+  +-------+--------+
             |                  |                   |
             v                  +-------------------+
        Policy Issue                    |
        (Section 10)                    v
                               Case Closed
                               Status: NOT_TAKEN
```

---

## 13. Decline & Adverse Action Flow

When a case cannot be approved at any insurable classification, the carrier must
decline and issue legally mandated adverse action notices.

### 13.1 Decline Processing Flow

```
                     +---------------------+
                     | UW DECISION:        |
                     | DECLINE             |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | CLASSIFY DECLINE    |
                     | REASON              |
                     +----------+----------+
                                |
         +----------------------+----------------------+
         |                      |                       |
         v                      v                       v
+--------+--------+   +---------+---------+   +---------+---------+
| MEDICAL         |   | FINANCIAL         |   | NON-MEDICAL       |
| DECLINE         |   | DECLINE           |   | DECLINE           |
|                 |   |                   |   |                   |
| - Uninsurable   |   | - Cannot justify  |   | - Criminal hx     |
|   medical       |   |   face amount     |   | - Aviation risk   |
|   condition     |   | - Income insuffic.|   | - Foreign travel  |
| - Aggregate     |   | - Suspicious      |   | - Occupation      |
|   risk too      |   |   financial       |   | - Avocation       |
|   high          |   |   pattern         |   |                   |
+---------+-------+   +---------+---------+   +---------+---------+
          |                     |                       |
          +---------------------+-----------------------+
                                |
                                v
                     +----------+----------+
                     | ADVERSE ACTION      |
                     | NOTICE REQUIRED?    |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                                   |
              v                                   v
     +--------+--------+                 +--------+--------+
     | FCRA TRIGGERED   |                 | NON-FCRA       |
     | (decision used   |                 | (decision based|
     |  consumer report |                 |  solely on     |
     |  data: credit,   |                 |  application   |
     |  MIB, MVR, Rx)   |                 |  answers or    |
     |                  |                 |  medical exam) |
     | MUST provide:    |                 |                |
     | - Specific       |                 | Provide:       |
     |   report(s) used |                 | - Decline      |
     | - CRA name &     |                 |   letter       |
     |   address        |                 | - General      |
     | - Right to free  |                 |   reason       |
     |   copy (60 days) |                 |                |
     | - Right to       |                 |                |
     |   dispute        |                 |                |
     | - Score + factors|                 |                |
     |   (if used)      |                 |                |
     +--------+---------+                 +--------+-------+
              |                                    |
              +------------------------------------+
                                |
                                v
                     +----------+----------+
                     | MIB CODING          |
                     |                     |
                     | Report to MIB:      |
                     | - Condition codes   |
                     |   (standardized)    |
                     | - Do NOT report     |
                     |   the decline       |
                     |   decision itself   |
                     |   (industry rule)   |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | CLOSE CASE          |
                     |                     |
                     | Status: DECLINED    |
                     | - Refund all        |
                     |   premiums          |
                     | - Archive case      |
                     | - Notify agent      |
                     | - Compliance audit  |
                     |   trail complete    |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | REAPPLICATION       |
                     | RULES              |
                     |                     |
                     | - Standard: 6 mo   |
                     |   waiting period   |
                     | - With new evidence:|
                     |   immediate reconsid|
                     |   (Section 14)      |
                     +---------------------+
```

---

## 14. Amendment & Reconsideration Flow

When an applicant or agent provides additional information after a decline or
counter-offer — or when circumstances change — the case may be reconsidered.

### 14.1 Reconsideration Flow

```
                     +---------------------+
                     | RECONSIDERATION     |
                     | REQUEST RECEIVED    |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | VALIDATE REQUEST    |
                     |                     |
                     | - Within reconsider |
                     |   window? (typ.     |
                     |   90 days from      |
                     |   decline/counter)  |
                     | - Contains new      |
                     |   material info?    |
                     | - Authorized        |
                     |   requestor?        |
                     +----------+----------+
                                |
                         +------+------+
                         | Valid?      |
                         +------+------+
                          Yes |    | No
                              |    v
                              | +--+------------------+
                              | | REJECT REQUEST      |
                              | | Notify requestor:   |
                              | | - Outside window    |
                              | | - No new info       |
                              | | - Must file new app |
                              | +---------------------+
                              v
                     +--------+----------+
                     | REOPEN CASE        |
                     | Status: RECONSIDER |
                     +--------+----------+
                              |
                              v
                     +--------+----------+
                     | IDENTIFY NEW       |
                     | INFORMATION        |
                     +--------+----------+
                              |
         +--------------------+--------------------+
         |                    |                     |
         v                    v                     v
+--------+--------+ +---------+--------+ +---------+---------+
| NEW MEDICAL     | | UPDATED         | | CORRECTED         |
| EVIDENCE        | | FINANCIAL DATA  | | APPLICATION       |
|                 | |                 | | DATA              |
| - Follow-up APS| | - New tax return| | - Misstatement    |
| - Updated labs  | | - Updated income| |   correction      |
| - Specialist    | |   verification  | | - Missing answers |
|   report        | | - Business      | | - Clarification   |
| - Treatment     | |   valuation     | |                   |
|   records       | |                 | |                   |
+---------+-------+ +---------+-------+ +---------+---------+
          |                   |                    |
          +-------------------+--------------------+
                              |
                              v
                     +--------+----------+
                     | REASSIGN TO       |
                     | UNDERWRITER       |
                     |                   |
                     | Preference: same  |
                     | UW who made       |
                     | original decision |
                     | (consistency)     |
                     +--------+----------+
                              |
                              v
                     +--------+----------+
                     | RE-EVALUATE       |
                     |                   |
                     | - Review new info |
                     | - Recalculate     |
                     |   debits/credits  |
                     | - New risk class  |
                     +--------+----------+
                              |
                              v
                     +--------+----------+
                     | REVISED DECISION  |
                     +--------+----------+
                              |
              +---------------+---------------+
              |               |               |
              v               v               v
     +--------+----+ +-------+------+ +------+-------+
     | APPROVE     | | COUNTER-OFFER| | UPHOLD       |
     | (upgraded   | | (revised     | | ORIGINAL     |
     |  from orig) | |  terms)      | | DECISION     |
     +-------------+ +--------------+ +--------------+
```

### 14.2 Amendment Types

```
+---------------------------+--------------------------------------------+
| Amendment Type            | Trigger & Handling                         |
+---------------------------+--------------------------------------------+
| Rate class upgrade        | New evidence supports better class.        |
| request                   | Re-score and re-classify.                  |
+---------------------------+--------------------------------------------+
| Face amount change        | Applicant wants different amount.          |
| (increase)                | May require additional financial UW.       |
+---------------------------+--------------------------------------------+
| Face amount change        | Applicant wants less coverage.             |
| (decrease)                | Usually approved; update reinsurance.      |
+---------------------------+--------------------------------------------+
| Beneficiary change        | Pre-issue: update application.             |
|                           | Post-issue: endorsement.                   |
+---------------------------+--------------------------------------------+
| Owner change              | Requires new signature, may trigger        |
|                           | insurable interest review.                 |
+---------------------------+--------------------------------------------+
| Rider add/remove          | Recalculate premium, verify eligibility.   |
+---------------------------+--------------------------------------------+
| Term length change        | New product quote, may require new         |
|                           | application if materially different.       |
+---------------------------+--------------------------------------------+
```

---

## 15. State Machine Diagrams

Every underwriting case follows a deterministic set of states with explicit
valid transitions. The state machine below is the canonical definition for
implementing workflow engines.

### 15.1 Case Lifecycle State Machine

```
                                   +-----------+
                          +------->| ABANDONED |
                          |        +-----------+
                          |
+--------+     +----------+---+     +----------+
| NEW    +---->| SUBMITTED    +---->| VALIDATED|
+--------+     +---------+----+     +-----+----+
                         |                |
                    (validation           |
                     failure)             v
                         |        +-------+--------+
                         +------->| NIGO           |
                                  | (Not In Good   |
                                  |  Order)        |
                                  +---+-----+------+
                                      |     |
                              (fixed) |     | (timeout)
                                      v     v
                              VALIDATED  ABANDONED
```

### 15.2 Complete State Transition Table

```
+---------------------+----------------------------+---------------------+
| FROM STATE          | EVENT / TRIGGER            | TO STATE            |
+---------------------+----------------------------+---------------------+
| NEW                 | Application received       | SUBMITTED           |
| SUBMITTED           | Passes validation          | VALIDATED           |
| SUBMITTED           | Fails validation           | NIGO                |
| NIGO                | Missing info provided      | VALIDATED           |
| NIGO                | No response (25 days)      | ABANDONED           |
| VALIDATED           | Pre-screen pass (accel.)   | ACCEL_UW            |
| VALIDATED           | Pre-screen fail / diverted | EVIDENCE_ORDERING   |
| ACCEL_UW            | Auto-approve               | APPROVED            |
| ACCEL_UW            | Divert to traditional      | EVIDENCE_ORDERING   |
| ACCEL_UW            | Auto-decline               | DECLINED            |
| EVIDENCE_ORDERING   | All orders placed          | EVIDENCE_GATHERING  |
| EVIDENCE_GATHERING  | All evidence received      | READY_FOR_REVIEW    |
| EVIDENCE_GATHERING  | Partial timeout            | READY_FOR_REVIEW *  |
| EVIDENCE_GATHERING  | Full timeout               | INCOMPLETE          |
| READY_FOR_REVIEW    | Triage + assign to UW      | IN_REVIEW           |
| IN_REVIEW           | UW requests more evidence  | EVIDENCE_GATHERING  |
| IN_REVIEW           | UW approves                | APPROVED            |
| IN_REVIEW           | UW declines                | DECLINED            |
| IN_REVIEW           | UW counter-offers          | COUNTER_OFFERED     |
| IN_REVIEW           | UW postpones               | POSTPONED           |
| COUNTER_OFFERED     | Applicant accepts          | APPROVED            |
| COUNTER_OFFERED     | Applicant rejects          | NOT_TAKEN           |
| COUNTER_OFFERED     | No response (30 days)      | NOT_TAKEN           |
| APPROVED            | Financial UW pass          | READY_TO_ISSUE      |
| APPROVED            | Financial UW fail          | COUNTER_OFFERED     |
| APPROVED            | Reinsurance declined       | COUNTER_OFFERED     |
| READY_TO_ISSUE      | Compliance pass            | ISSUING             |
| READY_TO_ISSUE      | Compliance hold            | ISSUE_HOLD          |
| ISSUE_HOLD          | Hold resolved              | ISSUING             |
| ISSUING             | Policy generated           | ISSUED              |
| ISSUED              | Delivered & premium paid    | IN_FORCE            |
| ISSUED              | Delivery failed            | DELIVERY_PENDING    |
| DELIVERY_PENDING    | Re-delivered                | IN_FORCE            |
| DELIVERY_PENDING    | Timeout (60 days)          | NOT_TAKEN           |
| IN_FORCE            | Free-look return           | RESCINDED           |
| IN_FORCE            | Premium paid               | IN_FORCE            |
| IN_FORCE            | Grace period lapse         | LAPSED              |
| DECLINED            | Reconsideration filed      | RECONSIDERATION     |
| POSTPONED           | Reapplication received     | SUBMITTED           |
| RECONSIDERATION     | New decision: approve      | APPROVED            |
| RECONSIDERATION     | New decision: decline      | DECLINED            |
| RECONSIDERATION     | New decision: counter      | COUNTER_OFFERED     |
| INCOMPLETE          | Applicant provides info    | EVIDENCE_GATHERING  |
| INCOMPLETE          | Timeout (90 days)          | CLOSED              |
+---------------------+----------------------------+---------------------+

* READY_FOR_REVIEW with partial evidence: UW may decide with available info
  or request additional time.
```

### 15.3 State Diagram (Visual)

```
                                         +----------+
                                    +--->| ABANDONED|
                                    |    +----------+
                                    |
  +-----+    +----------+    +------+----+    +------------------+
  | NEW  +--->|SUBMITTED +--->| VALIDATED +--->| ACCEL_UW         |
  +-----+    +----+-----+    +------+----+    +---+---------+----+
                   |                |             |         |
                   v                |        Auto |    Divert|
              +----+---+            |      approve|         |
              | NIGO   |            |             v         |
              +---+----+            |     +-------+---+    |
                  |                 |     | APPROVED  |    |
                  v                 v     +-----+-----+    |
            VALIDATED /     +------+--------+   |          |
            ABANDONED       | EVIDENCE      |<--+----------+
                            | ORDERING      |   |
                            +------+--------+   |
                                   |            |
                                   v            |
                            +------+--------+   |
                            | EVIDENCE      +---+
                            | GATHERING     |   (UW requests more)
                            +------+--------+
                                   |
                                   v
                            +------+--------+
                            | READY_FOR     |
                            | REVIEW        |
                            +------+--------+
                                   |
                                   v
                            +------+--------+
                            | IN_REVIEW     |
                            +---+--+--+-----+
                                |  |  |
                 +--------------+  |  +------------+
                 |                 |                |
                 v                 v                v
          +------+---+    +-------+-----+   +------+------+
          | APPROVED |    | COUNTER_    |   | DECLINED    |
          +------+---+    | OFFERED     |   +------+------+
                 |        +------+------+          |
                 v               |                 v
          +------+-------+      |          +------+--------+
          | READY_TO     |      v          | RECONSIDER-   |
          | ISSUE        |   APPROVED /    | ATION         |
          +------+-------+   NOT_TAKEN     +---------------+
                 |
                 v
          +------+-------+
          | ISSUING      |
          +------+-------+
                 |
                 v
          +------+-------+
          | ISSUED       |
          +------+-------+
                 |
                 v
          +------+-------+
          | IN_FORCE     |
          +--------------+
```

---

## 16. SLA Tracking & Escalation

Automated SLA tracking ensures cases don't stall. Every case state has
associated touch-time targets and escalation rules.

### 16.1 SLA Targets by State

```
+---------------------+-----------+-----------+-----------+-------------+
| State               | Green     | Yellow    | Red       | Escalation  |
|                     | (on time) | (warning) | (breach)  | Action      |
+---------------------+-----------+-----------+-----------+-------------+
| SUBMITTED           | < 4 hrs   | 4-8 hrs   | > 8 hrs   | Auto-route  |
|                     |           |           |           | to validator|
+---------------------+-----------+-----------+-----------+-------------+
| NIGO                | < 5 days  | 5-10 days | > 10 days | Supervisor  |
|                     |           |           |           | review      |
+---------------------+-----------+-----------+-----------+-------------+
| EVIDENCE_ORDERING   | < 1 day   | 1-2 days  | > 2 days  | Ops manager |
|                     |           |           |           | alert       |
+---------------------+-----------+-----------+-----------+-------------+
| EVIDENCE_GATHERING  | < 14 days | 14-21 d   | > 21 days | Escalate    |
| (non-APS)           |           |           |           | follow-up   |
+---------------------+-----------+-----------+-----------+-------------+
| EVIDENCE_GATHERING  | < 21 days | 21-30 d   | > 30 days | Medical     |
| (APS)               |           |           |           | director    |
+---------------------+-----------+-----------+-----------+-------------+
| READY_FOR_REVIEW    | < 2 days  | 2-4 days  | > 4 days  | Reassign UW |
+---------------------+-----------+-----------+-----------+-------------+
| IN_REVIEW           | < 3 days  | 3-5 days  | > 5 days  | Chief UW    |
|                     |           |           |           | escalation  |
+---------------------+-----------+-----------+-----------+-------------+
| COUNTER_OFFERED     | < 15 days | 15-25 d   | > 25 days | Close       |
|                     |           |           |           | warning     |
+---------------------+-----------+-----------+-----------+-------------+
| READY_TO_ISSUE      | < 1 day   | 1-2 days  | > 2 days  | Issue mgr   |
+---------------------+-----------+-----------+-----------+-------------+
| ISSUED (delivery)   | < 5 days  | 5-10 days | > 10 days | Agent mgr   |
+---------------------+-----------+-----------+-----------+-------------+
```

### 16.2 Escalation Path

```
                     +---------------------+
                     | SLA THRESHOLD       |
                     | BREACHED            |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | DETERMINE           |
                     | ESCALATION LEVEL    |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
     +--------+------+  +------+--------+  +------+--------+
     | LEVEL 1       |  | LEVEL 2       |  | LEVEL 3       |
     | Yellow SLA    |  | Red SLA       |  | Critical      |
     |               |  |               |  | (2x Red)      |
     | Actions:      |  | Actions:      |  | Actions:      |
     | - Dashboard   |  | - Email to    |  | - VP / CMO    |
     |   highlight   |  |   supervisor  |  |   notification|
     | - Assignee    |  | - Case        |  | - Compliance  |
     |   reminder    |  |   reassignment|  |   reporting   |
     | - Workbench   |  |   option      |  | - Root cause  |
     |   alert       |  | - Priority    |  |   analysis    |
     |               |  |   queue bump  |  |   triggered   |
     +--------+------+  +------+--------+  +------+--------+
              |                 |                  |
              v                 v                  v
     +--------+------+  +------+--------+  +------+--------+
     | TRACK:        |  | TRACK:        |  | TRACK:        |
     | Escalation    |  | Escalation    |  | Escalation    |
     | logged,       |  | logged,       |  | logged,       |
     | timer reset   |  | timer reset,  |  | timer reset,  |
     | for next      |  | next level    |  | watch list    |
     | threshold     |  | armed         |  | added         |
     +---------------+  +---------------+  +---------------+
```

### 16.3 Touch Time vs Calendar Time

```
+-----------------------------------------------------------------------+
| IMPORTANT DISTINCTION                                                 |
+-----------------------------------------------------------------------+
|                                                                       |
| Touch Time: Time the case is actively within the carrier's control    |
|   - Clock pauses when waiting on external parties (applicant,         |
|     physician, vendor)                                                |
|   - Used for internal performance metrics and UW productivity         |
|                                                                       |
| Calendar Time: Wall-clock time from submission to decision            |
|   - Includes all wait times                                           |
|   - Used for customer-facing SLAs and competitive benchmarking        |
|                                                                       |
| Example:                                                              |
|   Case submitted:          Day 0                                      |
|   Evidence ordered:        Day 0  (touch: 2 hrs)                      |
|   APS requested:           Day 0  (touch: 2.5 hrs)                    |
|   -- Waiting for APS --    Day 1-18 (touch clock paused)              |
|   APS received:            Day 18 (touch: 2.5 hrs)                    |
|   Assigned to UW:          Day 18 (touch: 3 hrs)                      |
|   UW reviews:              Day 19-20 (touch: 7 hrs)                   |
|   Decision made:           Day 20 (touch: 7 hrs)                      |
|                                                                       |
|   Calendar time: 20 days                                              |
|   Touch time: 7 hours                                                 |
|                                                                       |
+-----------------------------------------------------------------------+
```

### 16.4 Aging Dashboard Metrics

```
+--------------------------+
| AGING BUCKET DASHBOARD   |
+--------------------------+

  Cases by Age (Calendar Days):

  0-5 days    ████████████████████  (42%)   Target: > 40%
  6-10 days   ████████████          (25%)   Target: > 20%
  11-15 days  ██████████            (18%)   Target: < 20%
  16-20 days  ████                  (8%)    Target: < 10%
  21-30 days  ██                    (5%)    Warning: investigate
  31+ days    █                     (2%)    Critical: escalate all

  Key Metrics:
  +-------------------------------+--------+--------+
  | Metric                        | Actual | Target |
  +-------------------------------+--------+--------+
  | Median cycle time (all)       | 12 d   | 10 d   |
  | Median cycle time (accel.)    | 0.5 d  | 1 d    |
  | % auto-decided                | 38%    | 50%    |
  | % in force within 15 days    | 62%    | 70%    |
  | APS avg receipt time          | 16 d   | 14 d   |
  | UW avg touch time per case    | 45 min | 40 min |
  +-------------------------------+--------+--------+
```

---

## 17. Quality Assurance Audit Flow

QA auditing ensures underwriting decisions are accurate, consistent, and
compliant with carrier guidelines and regulatory requirements.

### 17.1 Audit Selection Process

```
                     +---------------------+
                     | CASE DECIDED        |
                     | (any outcome)       |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | AUDIT SELECTION     |
                     | ENGINE              |
                     +----------+----------+
                                |
         +----------------------+----------------------+
         |                      |                       |
         v                      v                       v
+--------+--------+   +---------+---------+   +---------+---------+
| MANDATORY       |   | RANDOM SAMPLE     |   | RISK-BASED        |
| AUDIT           |   |                   |   | SELECTION         |
|                 |   | - 5% of all       |   |                   |
| Triggers:       |   |   approved cases  |   | Triggers:         |
| - All declines  |   | - 10% of counter- |   | - New UW (<6 mo)  |
| - Jumbo cases   |   |   offers          |   | - Complex case    |
|   (>$5M)        |   | - Stratified by   |   |   (score > 80)    |
| - Substandard   |   |   UW, product,    |   | - Outlier class   |
|   (Table D+)    |   |   state           |   |   (vs model pred.)|
| - Complaints    |   |                   |   | - Speed outlier   |
| - Fraud flags   |   |                   |   |   (too fast)      |
+---------+-------+   +---------+---------+   +---------+---------+
          |                     |                       |
          +---------------------+-----------------------+
                                |
                                v
                     +----------+----------+
                     | CASE ADDED TO       |
                     | AUDIT QUEUE         |
                     | Status: AUDIT_PEND  |
                     +---------------------+
```

### 17.2 Audit Review Flow

```
                     +---------------------+
                     | CASE IN AUDIT       |
                     | QUEUE               |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | ASSIGN TO QA       |
                     | AUDITOR             |
                     |                     |
                     | (Must be senior to  |
                     |  original UW; may   |
                     |  not audit own      |
                     |  decisions)         |
                     +----------+----------+
                                |
                                v
                     +----------+----------+
                     | AUDITOR REVIEWS:    |
                     +----------+----------+
                                |
         +----------------------+----------------------+
         |                      |                       |
         v                      v                       v
+--------+--------+   +---------+---------+   +---------+---------+
| DECISION        |   | PROCESS           |   | DOCUMENTATION     |
| ACCURACY        |   | COMPLIANCE        |   | COMPLETENESS      |
|                 |   |                   |   |                   |
| - Correct risk  |   | - All evidence    |   | - Rationale       |
|   class?        |   |   reviewed?       |   |   documented?     |
| - Debits/credits|   | - Guidelines      |   | - All impairments |
|   correct?      |   |   followed?       |   |   addressed?      |
| - Financial UW  |   | - State regs      |   | - Notes clear     |
|   justified?    |   |   satisfied?      |   |   and complete?   |
| - Reinsurance   |   | - Adverse action  |   | - Evidence        |
|   handled right?|   |   compliant?      |   |   properly filed? |
+---------+-------+   +---------+---------+   +---------+---------+
          |                     |                       |
          +---------------------+-----------------------+
                                |
                                v
                     +----------+----------+
                     | AUDIT FINDING       |
                     +----------+----------+
                                |
              +-----------------+-----------------+
              |                 |                  |
              v                 v                  v
     +--------+------+  +------+--------+  +------+--------+
     | PASS          |  | MINOR FINDING |  | MAJOR FINDING |
     | No issues     |  |               |  |               |
     |               |  | - Doc gaps    |  | - Wrong class |
     | Close audit   |  | - Process     |  | - Missed      |
     |               |  |   deviation   |  |   impairment  |
     |               |  | - Non-material|  | - Compliance  |
     |               |  |   errors      |  |   violation   |
     |               |  |               |  | - Material    |
     |               |  | Action:       |  |   error       |
     |               |  | - Feedback to |  |               |
     |               |  |   UW          |  | Action:       |
     |               |  | - Coaching    |  | - Case re-    |
     |               |  |   logged      |  |   review      |
     |               |  |               |  | - Decision    |
     |               |  |               |  |   correction  |
     |               |  |               |  | - UW          |
     |               |  |               |  |   counseling  |
     |               |  |               |  | - Pattern     |
     |               |  |               |  |   analysis    |
     +--------+------+  +------+--------+  +------+--------+
              |                 |                  |
              +-----+----------+------------------+
                    |
                    v
           +--------+----------+
           | AGGREGATE         |
           | REPORTING         |
           |                   |
           | - UW scorecards   |
           | - Error rate      |
           |   trending        |
           | - Guideline       |
           |   change recs     |
           | - Training needs  |
           |   identification  |
           +-------------------+
```

### 17.3 Audit Metrics & Scorecard

```
+-----------------------------------------------------------------------+
| QUARTERLY UW QUALITY SCORECARD                                        |
+-----------------------------------------------------------------------+
|                                                                       |
| ACCURACY RATE                                                         |
| Target: >= 95%                                                        |
|                                                                       |
| +---+--------+--------+--------+--------+                             |
| |UW | Cases  | Pass   | Minor  | Major  | Accuracy                   |
| |   | Audited|        |        |        | Rate                       |
| +---+--------+--------+--------+--------+--------+                    |
| | A |   42   |   39   |    2   |    1   |  92.9% | << Below target   |
| | B |   38   |   37   |    1   |    0   |  97.4% |                    |
| | C |   45   |   43   |    2   |    0   |  95.6% |                    |
| | D |   31   |   29   |    1   |    1   |  93.5% | << Below target   |
| | E |   50   |   48   |    2   |    0   |  96.0% |                    |
| +---+--------+--------+--------+--------+--------+                    |
|                                                                       |
| COMMON ERROR CATEGORIES (this quarter)                                |
| +---------------------------------------------+--------+             |
| | Category                                    | Count  |             |
| +---------------------------------------------+--------+             |
| | Build chart misread                         |    3   |             |
| | Rx interaction not evaluated                |    2   |             |
| | Financial justification calc error          |    2   |             |
| | APS finding overlooked                      |    1   |             |
| | State requirement not met                   |    1   |             |
| +---------------------------------------------+--------+             |
|                                                                       |
| RECOMMENDED ACTIONS                                                   |
| 1. Refresher training on build chart interpretation                   |
| 2. Enhance Rx interaction rules in decision support system            |
| 3. Add financial calc validation to UW workbench                      |
+-----------------------------------------------------------------------+
```

---

## Appendix A: Event-Driven Architecture Integration

Each state transition in the underwriting workflow emits a domain event that
downstream systems can subscribe to. This enables loose coupling between the
underwriting engine and dependent systems.

### Key Domain Events

```
+-------------------------------+------------------------------------------+
| Event                         | Consumers                                |
+-------------------------------+------------------------------------------+
| CaseCreated                   | Evidence orchestrator, CRM, agent portal |
| CaseValidated                 | Risk pre-screener, evidence orchestrator |
| EvidenceOrdered               | Vendor integration, SLA tracker          |
| EvidenceReceived              | Evidence assembler, UW workbench         |
| CaseAssigned                  | UW workbench, SLA tracker                |
| DecisionMade                  | Policy admin, reinsurance, compliance    |
| CounterOfferSent              | Agent portal, applicant notifications    |
| CounterOfferAccepted          | Policy admin, premium billing            |
| PolicyIssued                  | Delivery system, billing, reinsurance    |
| PolicyDelivered               | Free-look timer, admin system            |
| CaseDeclined                  | Adverse action, MIB reporting, CRM      |
| CaseClosed                    | Archive, analytics, commission system    |
| SLABreached                   | Escalation engine, management dashboard  |
| AuditCompleted                | UW scorecard, training system            |
+-------------------------------+------------------------------------------+
```

### Event Payload Pattern

```
{
  "eventId":       "uuid-v4",
  "eventType":     "DecisionMade",
  "timestamp":     "2025-03-15T14:30:00Z",
  "caseId":        "CASE-2025-0012345",
  "correlationId": "CORR-uuid",
  "payload": {
    "decision":    "APPROVE",
    "riskClass":   "STANDARD_NT",
    "faceAmount":  500000,
    "annualPrem":  1250.00,
    "decidedBy":   "RULES_ENGINE | UW-ID-4567",
    "autoDecided": true
  },
  "metadata": {
    "source":      "underwriting-engine",
    "version":     "2.4.1",
    "environment": "production"
  }
}
```

---

## Appendix B: System Integration Touchpoints

```
+-----------------------------------------------------------------------+
|                        SYSTEM LANDSCAPE                               |
+-----------------------------------------------------------------------+
|                                                                       |
|  +-----------+     +----------------+     +------------------+        |
|  | Agent     |     | DTC Web /      |     | Partner API      |        |
|  | Portal    |     | Mobile App     |     | Gateway          |        |
|  +-----+-----+     +-------+--------+     +--------+---------+        |
|        |                    |                       |                  |
|        +--------------------+-----------------------+                  |
|                             |                                         |
|                    +--------+--------+                                 |
|                    | INTAKE SERVICE  |                                 |
|                    +--------+--------+                                 |
|                             |                                         |
|              +--------------+--------------+                          |
|              |                             |                          |
|     +--------+--------+          +--------+--------+                  |
|     | RULES ENGINE    |          | EVIDENCE        |                  |
|     | (Decisioning)   |          | ORCHESTRATOR    |                  |
|     +--------+--------+          +--------+--------+                  |
|              |                            |                           |
|              |               +------------+------------+              |
|              |               |            |            |              |
|              |        +------+---+ +------+---+ +-----+----+         |
|              |        | MIB API  | | Rx API   | | MVR API  |         |
|              |        +----------+ +----------+ +----------+         |
|              |        | Credit   | | APS Svc  | | Lab Svc  |         |
|              |        | API      | |          | |          |         |
|              |        +----------+ +----------+ +----------+         |
|              |                                                        |
|     +--------+--------+                                               |
|     | UW WORKBENCH    |                                               |
|     | (Case mgmt UI)  |                                               |
|     +--------+--------+                                               |
|              |                                                        |
|     +--------+--------+          +------------------+                 |
|     | POLICY ADMIN    |          | REINSURANCE      |                 |
|     | SYSTEM (PAS)    +----------+ ADMIN SYSTEM     |                 |
|     +--------+--------+          +------------------+                 |
|              |                                                        |
|     +--------+--------+          +------------------+                 |
|     | BILLING /       |          | DOCUMENT         |                 |
|     | PREMIUM SYSTEM  |          | GENERATION       |                 |
|     +-----------------+          +------------------+                 |
|                                                                       |
+-----------------------------------------------------------------------+
```

---

## Appendix C: Glossary of Status Codes

```
+---------------------+----------------------------------------------------+
| Status              | Description                                        |
+---------------------+----------------------------------------------------+
| NEW                 | Application received, not yet processed             |
| SUBMITTED           | Entered intake pipeline                            |
| VALIDATED           | Passed all validation checks                       |
| NIGO                | Not In Good Order — missing/invalid data            |
| ACCEL_UW            | In accelerated underwriting pipeline                |
| EVIDENCE_ORDERING   | Evidence orders being placed with vendors           |
| EVIDENCE_GATHERING  | Waiting for evidence from external sources          |
| READY_FOR_REVIEW    | All evidence assembled, awaiting UW assignment      |
| IN_REVIEW           | Underwriter actively evaluating case                |
| APPROVED            | Underwriting decision: approved at a risk class     |
| COUNTER_OFFERED     | Carrier offering different terms than applied for   |
| DECLINED            | Underwriting decision: not insurable                |
| POSTPONED           | Decision deferred — reapply after specified period   |
| NOT_TAKEN           | Applicant chose not to accept offered terms          |
| RECONSIDERATION     | Previously decided case under re-evaluation         |
| READY_TO_ISSUE      | Approved, financials clear, reinsurance ceded        |
| ISSUE_HOLD          | Compliance hold preventing policy generation         |
| ISSUING             | Policy document being generated                     |
| ISSUED              | Policy generated, pending delivery                  |
| DELIVERY_PENDING    | Policy sent but delivery not confirmed               |
| IN_FORCE            | Policy delivered, premium collected, coverage active |
| RESCINDED           | Policy returned during free-look period              |
| LAPSED              | Premium not paid within grace period                 |
| INCOMPLETE          | Required info never received, case closed            |
| ABANDONED           | Applicant abandoned process                          |
| CLOSED              | Terminal state — case fully resolved and archived    |
| AUDIT_PENDING       | Case selected for QA review                          |
| AUDIT_COMPLETE      | QA review finished                                   |
+---------------------+----------------------------------------------------+
```

---

## Appendix D: Process Optimization Metrics

Key performance indicators to track when evaluating and improving the
underwriting workflow:

```
+-------------------------------------------+----------+----------------+
| KPI                                       | Formula  | Benchmark      |
+-------------------------------------------+----------+----------------+
| Straight-Through Processing Rate          | Auto-    | 30-50%         |
|                                           | decided /|                |
|                                           | total    |                |
+-------------------------------------------+----------+----------------+
| Accelerated UW Approval Rate              | Accel    | 50-70%         |
|                                           | approved/|                |
|                                           | accel    |                |
|                                           | eligible |                |
+-------------------------------------------+----------+----------------+
| Average Cycle Time (submission to issue)  | Sum(days)| 15 days (trad) |
|                                           | / cases  | <1 day (accel) |
+-------------------------------------------+----------+----------------+
| Not-Taken Rate                            | Not taken| < 10%          |
|                                           | / offered|                |
+-------------------------------------------+----------+----------------+
| Placement Rate                            | In-force | > 80%          |
|                                           | / submit |                |
+-------------------------------------------+----------+----------------+
| UW Productivity (cases/day)               | Decided /| 8-12           |
|                                           | UW-days  |                |
+-------------------------------------------+----------+----------------+
| Evidence Cost per Case                    | Total    | $50-150 (accel)|
|                                           | evidence | $200-400 (trad)|
|                                           | cost /   |                |
|                                           | cases    |                |
+-------------------------------------------+----------+----------------+
| APS Turnaround Time                       | Avg days | 14 days        |
|                                           | to       |                |
|                                           | receipt  |                |
+-------------------------------------------+----------+----------------+
| QA Error Rate                             | Audit    | < 5%           |
|                                           | findings/|                |
|                                           | audited  |                |
+-------------------------------------------+----------+----------------+
```

---

## Series Navigation

This article is part of a comprehensive series on term life insurance
underwriting for technology teams. See the companion documents for full coverage:

| #  | Document                                           | Focus Area                          |
|----|----------------------------------------------------|-------------------------------------|
| 01 | `01_UNDERWRITING_FUNDAMENTALS.md`                  | Core concepts, mortality theory, risk classification basics |
| 02 | `02_MEDICAL_UNDERWRITING.md`                       | Medical evidence, lab interpretation, impairment assessment |
| 03 | `03_FINANCIAL_UNDERWRITING.md`                     | Income multiples, need analysis, jumbo case handling |
| 04 | `04_RISK_CLASSIFICATION.md`                        | Rate classes, build charts, debit/credit methodology |
| **05** | **`05_UNDERWRITING_PROCESS_FLOWS.md`** *(this document)* | **End-to-end workflows, state machines, orchestration** |
| 06 | `06_REGULATORY_COMPLIANCE.md`                      | State regulations, FCRA, HIPAA, adverse action |
| 07 | `07_REINSURANCE.md`                                | Treaty structures, facultative flows, retention |
| 08 | `08_DATA_MODELS.md`                                | Domain entities, canonical schemas, event payloads |
| 09 | `09_VENDOR_INTEGRATIONS.md`                        | MIB, Rx, MVR, credit, lab, APS vendor APIs |
| 10 | `10_RULES_ENGINE_DESIGN.md`                        | Decision tables, rule authoring, versioning |
| 11 | `11_ACCELERATED_UW_MODELS.md`                      | Predictive models, scoring, fluidless decisioning |
| 12 | `12_SYSTEM_ARCHITECTURE.md`                        | Platform design, microservices, event sourcing |

---

*Document version: 2.0 — Last updated: 2026-04-16*
*Maintained by: Underwriting Technology Architecture Team*
