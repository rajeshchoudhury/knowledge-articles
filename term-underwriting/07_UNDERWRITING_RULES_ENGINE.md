# Underwriting Rules Engine — Architecture, Decision Tables & Implementation

> **Series**: Term Life Insurance — Automated Underwriting Deep-Dive
> **Document**: 07 of 09
> **Audience**: Solution Architects, Rules Engineers, Underwriting Systems Leads
> **Version**: 1.0 — April 2026

---

## Table of Contents

1. [Rules Engine Architecture Patterns](#1-rules-engine-architecture-patterns)
2. [Technology Selection](#2-technology-selection)
3. [Rule Categories with Pseudocode](#3-rule-categories-with-pseudocode)
4. [Complete Decision Tables (DMN-Style)](#4-complete-decision-tables-dmn-style)
5. [Implementing the Debit/Credit System](#5-implementing-the-debitcredit-system)
6. [Rx-to-Condition Mapping Engine](#6-rx-to-condition-mapping-engine)
7. [Lab Value Interpretation Engine](#7-lab-value-interpretation-engine)
8. [Rule Versioning & Governance](#8-rule-versioning--governance)
9. [Rule Testing Strategy](#9-rule-testing-strategy)
10. [Performance Optimization](#10-performance-optimization)

---

## 1. Rules Engine Architecture Patterns

### 1.1 Why a Rules Engine for Underwriting?

Term life underwriting involves thousands of interacting business rules that change frequently—sometimes weekly—driven by reinsurer guideline updates, regulatory changes, and competitive positioning. Embedding these rules in application code creates a maintenance nightmare where every rule change requires a full development cycle. A rules engine externalizes this logic, enabling:

- **Business ownership**: Actuaries and chief underwriters modify rules without developer intervention.
- **Auditability**: Every rule firing is logged, satisfying state regulatory examination requirements.
- **Consistency**: Identical fact patterns always produce identical decisions—eliminating adjuster variance.
- **Velocity**: Rule changes deploy in hours rather than sprint cycles.

### 1.2 Forward Chaining (Data-Driven)

Forward chaining starts with known facts and applies rules to derive new facts until a goal state is reached. This is the dominant pattern for underwriting because the process naturally flows from application data to derived risk factors to classification.

```
Algorithm: Forward Chaining
-------------------------------------
1. LOAD working memory with applicant facts
   - demographics, medical history, labs, Rx, MIB, MVR, financials
2. REPEAT
   a. MATCH: find all rules whose conditions are satisfied by working memory
   b. CONFLICT RESOLUTION: select highest-priority rule from match set
   c. FIRE: execute the selected rule action (assert new fact, modify, or retract)
   d. UPDATE working memory
3. UNTIL no more rules can fire (quiescence)
4. READ terminal facts from working memory -> underwriting decision
```

**Advantages for underwriting:**
- Natural fit—data arrives incrementally (app, then labs, then MIB hits)
- Efficient with Rete algorithm optimization
- Easily handles rule interdependencies (e.g., BMI calculation feeds build chart which feeds risk class ceiling)

### 1.3 Backward Chaining (Goal-Driven)

Backward chaining starts with a hypothesis (e.g., "Is this applicant Preferred Plus?") and works backward to find supporting facts.

```
Algorithm: Backward Chaining
-------------------------------------
1. SET goal = "Applicant qualifies for Preferred Plus"
2. FIND rules whose conclusion matches the goal
3. FOR each such rule:
   a. CHECK if all conditions are satisfied
   b. IF a condition is unknown:
      - SET it as a new sub-goal
      - RECURSE to step 2
   c. IF all conditions satisfied -> goal is PROVEN
   d. IF any condition fails -> try next rule
4. IF no rule proves the goal -> goal FAILS
```

**Use in underwriting**: Backward chaining is useful for "what-if" scenarios—e.g., "What conditions must change for this applicant to qualify for a better risk class?" This powers reconsideration engines and agent quoting tools.

### 1.4 The Rete Algorithm

The Rete algorithm (Latin for "net") is the foundational optimization for production rule systems. It avoids re-evaluating all rules against all facts on every cycle by building a discrimination network.

```
                    +--------------------------------------------------+
                    |              RETE NETWORK                         |
                    |                                                   |
  Facts ---------> |  Alpha Network        Beta Network                |
  (Working         |  +-----------+        +------------+              |
   Memory)         |  | Type      |        | Join       |              |
                   |  | Tests     |------->| Nodes      |---> Agenda   |
                   |  | (single   |        | (multi-    |   (conflict  |
                   |  |  fact)    |        |  fact      |    set)      |
                   |  +-----------+        |  joins)    |              |
                   |                       +------------+              |
                   +---------------------------------------------------+

Alpha Network:
  - Each alpha node tests ONE condition on ONE fact type
  - Example: age > 18, state != "NY", diagnosis_code STARTS_WITH "C"
  - Alpha memories store facts that pass each test

Beta Network:
  - Join nodes combine facts from multiple alpha memories
  - Example: applicant.age > 60 AND labResult.cholesterol > 280
  - Partial matches propagate incrementally

Agenda:
  - Collects fully matched rule instantiations
  - Conflict resolution strategy selects which rule fires next
  - Common strategies: priority (salience), recency, specificity
```

**Performance characteristics for underwriting workloads:**

| Metric | Brute Force | Rete | Improvement |
|--------|-------------|------|-------------|
| Rules evaluated per fact change | All (5,000+) | Only affected (~20-50) | 100x |
| Memory usage | O(1) | O(R x F) where R=rules, F=facts | Trade-off |
| Throughput (decisions/sec) | ~50 | ~2,000 | 40x |
| Incremental fact addition | Full re-evaluation | Partial network update | Orders of magnitude |

### 1.5 Production Rule Systems

A production rule follows the pattern:

```
WHEN <conditions>    -- the Left-Hand Side (LHS)
THEN <actions>       -- the Right-Hand Side (RHS)
```

In underwriting, the LHS tests applicant attributes and derived facts; the RHS asserts risk findings, modifies risk class ceilings, assigns table ratings, or triggers evidence requirements.

**Rule anatomy for underwriting:**

```drools
rule "Elevated-BMI-Age-50-Plus"
  salience 100                          // priority
  activation-group "build-assessment"   // mutual exclusion group
  date-effective "2025-01-01"           // versioning
  date-expires "2026-12-31"
  when
    $app : Applicant(age >= 50)
    $build : BuildAssessment(bmi >= 30.0, bmi < 35.0, applicantId == $app.id)
  then
    modify($build) { setRiskClassCeiling("STANDARD") };
    insert(new DebitEntry($app.id, "BUILD", 75, "BMI 30-35 age 50+"));
    logRule("Elevated-BMI-Age-50-Plus", $app.id);
end
```

### 1.6 Decision Tables (DMN Standard)

The Decision Model and Notation (DMN) standard provides a tabular format for expressing rules that is directly readable by business users. DMN tables use hit policies to control how multiple matching rows interact.

**Hit Policies relevant to underwriting:**

| Policy | Symbol | Behavior | UW Use Case |
|--------|--------|----------|-------------|
| Unique | U | Exactly one row matches | Blood pressure classification |
| First | F | First matching row wins (order matters) | Knock-out rules (first decline wins) |
| Priority | P | Highest-priority match wins | Risk class assignment |
| Collect+ | C+ | Sum all matching outputs | Debit/credit accumulation |
| Collect Min | C< | Minimum of all matching outputs | Most restrictive risk class ceiling |
| Rule Order | R | All matches, in table order | Evidence requirement gathering |

**Example DMN Table — Smoking Status Classification:**

| **U** | Nicotine Test | Self-Reported Tobacco | Last Use (months) | -> Smoking Class |
|-------|---------------|----------------------|-------------------|----------------|
| 1 | Positive | — | — | Smoker |
| 2 | Negative | Yes | < 12 | Smoker |
| 3 | Negative | Yes | 12-36 | Smoker |
| 4 | Negative | Yes | 36-60 | Preferred Non-Smoker |
| 5 | Negative | Yes | > 60 | Non-Smoker |
| 6 | Negative | No | — | Non-Smoker |

### 1.7 Scoring Models (Debit/Credit)

Many carriers use a points-based system where risk factors accumulate debits (negative) and protective factors accumulate credits (positive). The net score maps to a risk classification.

```
+------------------------------------------------------+
|              DEBIT/CREDIT SCORING FLOW                 |
|                                                       |
|  Applicant Facts                                      |
|       |                                               |
|       v                                               |
|  +----------+  +----------+  +----------+             |
|  | Medical  |  | Lifestyle|  | Financial|             |
|  | Rules    |  | Rules    |  | Rules    |             |
|  | +debits  |  | +debits  |  | +debits  |             |
|  | +credits |  | +credits |  | +credits |             |
|  +----+-----+  +----+-----+  +----+-----+             |
|       |              |              |                  |
|       +--------------+--------------+                  |
|                      v                                 |
|              +--------------+                          |
|              |  Aggregate   |                          |
|              |  Net Score   |                          |
|              +------+-------+                          |
|                     v                                  |
|         +-----------------------+                      |
|         | Score-to-Class Map    |                      |
|         | <= -150 -> Decline    |                      |
|         | -149 to 0 -> Table    |                      |
|         |  1-50  -> Standard    |                      |
|         | 51-80  -> Std Plus    |                      |
|         | 81-100 -> Preferred   |                      |
|         | 101+   -> Pref Plus   |                      |
|         +-----------------------+                      |
+-------------------------------------------------------+
```

### 1.8 Hybrid Architecture (Recommended)

Production underwriting engines typically combine all patterns:

```
+-----------------------------------------------------------+
|                HYBRID RULES ENGINE                         |
|                                                           |
|  Layer 1: Decision Tables (DMN)                           |
|  +-- Eligibility gates (age, state, product)              |
|  +-- Evidence requirements (age x amount matrix)          |
|  +-- Build chart, BP classification, lab thresholds       |
|                                                           |
|  Layer 2: Production Rules (Forward Chaining / Rete)      |
|  +-- Complex medical impairment rules                     |
|  +-- Multi-factor Rx interpretation                       |
|  +-- Condition interaction rules                          |
|                                                           |
|  Layer 3: Scoring Model (Debit/Credit)                    |
|  +-- Accumulate debits/credits from all rule firings      |
|  +-- Map net score -> risk classification                 |
|                                                           |
|  Layer 4: Backward Chaining (Optional)                    |
|  +-- "What-if" class improvement analysis                 |
|  +-- Reconsideration guidance                             |
|                                                           |
|  Orchestrator: Stateful session manages rule firing order  |
|  and ensures layers execute in correct sequence            |
+-----------------------------------------------------------+
```

---

## 2. Technology Selection

### 2.1 Drools (Red Hat Decision Manager)

Drools is the most widely adopted open-source rules engine in insurance. It implements the Rete algorithm with extensions (Phreak algorithm in Drools 7+).

**DRL Syntax — Basic Underwriting Rule:**

```drools
package com.carrier.underwriting.rules.eligibility

import com.carrier.underwriting.model.Applicant
import com.carrier.underwriting.model.Application
import com.carrier.underwriting.model.UnderwritingDecision
import com.carrier.underwriting.model.EligibilityResult

rule "Age-Eligibility-Check"
    salience 1000
    when
        $app : Applicant(age < 18 || age > 80)
        $decision : UnderwritingDecision(applicantId == $app.id)
    then
        modify($decision) {
            setEligible(false),
            setDeclineReason("Applicant age " + $app.getAge() +
                " outside eligible range 18-80"),
            setDecisionCode("ELIG_AGE_001")
        };
        insert(new EligibilityResult($app.getId(), false, "AGE_RANGE"));
end

rule "State-Product-Eligibility"
    salience 999
    when
        $app : Applicant()
        $application : Application(
            applicantId == $app.id,
            state memberOf {"NY", "CA", "TX", "FL"},
            productCode == "TERM20"
        )
        not EligibilityResult(applicantId == $app.id, eligible == false)
    then
        insert(new EligibilityResult($app.getId(), true, "STATE_PRODUCT_OK"));
end
```

**DRL Syntax — Decision Table (Spreadsheet-Driven):**

Drools supports Excel-based decision tables that compile to DRL:

```
RuleTable BuildChartMale
CONDITION          CONDITION           CONDITION        ACTION               ACTION
$app : Applicant   $build : Build      $build           $build               DebitEntry
age >= $param      height == $param    weight <= $param setClassCeiling      points
Age Min            Height (in)         Max Weight       Risk Class Ceiling   Debits
18                 60                  164              PREFERRED_PLUS       0
18                 60                  177              PREFERRED            25
18                 60                  195              STANDARD_PLUS        50
18                 60                  215              STANDARD             75
18                 60                  250              TABLE_2              125
18                 61                  169              PREFERRED_PLUS       0
18                 61                  183              PREFERRED            25
...
```

**Drools Architecture for Underwriting:**

```
+-----------------------------------------------------+
|              DROOLS DEPLOYMENT                       |
|                                                     |
|  KIE Server (Decision Manager)                      |
|  +---------------------------------------------+   |
|  |  KIE Container                               |   |
|  |  +---------+ +---------+ +----------+        |   |
|  |  |Eligibil-| | Medical | |  Risk    |        |   |
|  |  |ity Rules| | Rules   | |  Class   |        |   |
|  |  | (v2.3)  | | (v4.1)  | |  (v3.0)  |        |   |
|  |  +---------+ +---------+ +----------+        |   |
|  +---------------------------------------------+   |
|                      |                              |
|  REST API: POST /kie-server/services/rest/server/   |
|            containers/{id}/dmn                      |
|                                                     |
|  +---------------------------------------------+   |
|  | Workbench (Business Central)                 |   |
|  | - Visual rule editing                        |   |
|  | - Decision table management                  |   |
|  | - Test scenarios                             |   |
|  | - Version control (Git-backed)               |   |
|  +---------------------------------------------+   |
+-----------------------------------------------------+
```

### 2.2 IBM Operational Decision Manager (ODM)

IBM ODM is the enterprise standard in large carrier environments. It uses Business Action Language (BAL) for rules.

```
// IBM ODM BAL Rule
define rule "Diabetes-Type2-Rating"
  set the properties of this rule to priority = 500;
  when
    there is an applicant where
      the medical history contains a condition where
        the ICD code starts with "E11" and
        the diagnosis date is before 5 years ago
    and the latest HbA1c result is less than 7.0
    and there are no complications where the type is "retinopathy"
  then
    set the table rating of the applicant to "Table B (+50%)";
    add 100 to the debits of the applicant with reason "T2DM controlled";
    log "Diabetes Type 2 -- controlled, no complications -> Table B";
end
```

**ODM Decision Center features relevant to UW:**
- Vocabulary mapping (business terms <-> data model)
- Decision governance framework (review -> approve -> deploy)
- Simulation testing with production-like datasets
- Hot deployment without application restart

### 2.3 FICO Blaze Advisor

FICO Blaze is dominant in credit-adjacent insurance products. Its strength is predictive analytics integration.

```
// FICO Blaze Rule Template
Rulesheet: MedicalImpairmentRating
  Conditions:
    Applicant.conditions CONTAINS condition
    condition.icdCode IN ${icdRange}
    condition.severity = ${severity}
    condition.yearsStable >= ${minStableYears}
  Actions:
    SET Applicant.riskClassCeiling = ${ceiling}
    ADD DebitCredit(category=${category}, points=${points})
    SET Applicant.requiresReview = ${needsReview}
```

### 2.4 Camunda DMN Engine

Camunda provides a lightweight, embeddable DMN engine ideal for microservices architectures.

```xml
<!-- Camunda DMN -- Blood Pressure Classification -->
<definitions xmlns="https://www.omg.org/spec/DMN/20191111/MODEL/"
             id="bp-classification" name="Blood Pressure Classification"
             namespace="com.carrier.uw">
  <decision id="bp_class" name="BP Classification">
    <decisionTable id="bp_table" hitPolicy="FIRST">
      <input id="systolic" label="Systolic">
        <inputExpression typeRef="integer"><text>systolicBP</text></inputExpression>
      </input>
      <input id="diastolic" label="Diastolic">
        <inputExpression typeRef="integer"><text>diastolicBP</text></inputExpression>
      </input>
      <output id="classification" label="BP Class" typeRef="string"/>
      <output id="debits" label="Debits" typeRef="integer"/>
      <rule id="bp_1">
        <inputEntry><text><![CDATA[< 120]]></text></inputEntry>
        <inputEntry><text><![CDATA[< 80]]></text></inputEntry>
        <outputEntry><text>"Optimal"</text></outputEntry>
        <outputEntry><text>0</text></outputEntry>
      </rule>
      <rule id="bp_2">
        <inputEntry><text>[120..129]</text></inputEntry>
        <inputEntry><text><![CDATA[< 80]]></text></inputEntry>
        <outputEntry><text>"Elevated"</text></outputEntry>
        <outputEntry><text>25</text></outputEntry>
      </rule>
      <rule id="bp_3">
        <inputEntry><text>[130..139]</text></inputEntry>
        <inputEntry><text>[80..89]</text></inputEntry>
        <outputEntry><text>"Stage1_HTN"</text></outputEntry>
        <outputEntry><text>75</text></outputEntry>
      </rule>
      <rule id="bp_4">
        <inputEntry><text>[140..159]</text></inputEntry>
        <inputEntry><text>[90..99]</text></inputEntry>
        <outputEntry><text>"Stage2_HTN"</text></outputEntry>
        <outputEntry><text>150</text></outputEntry>
      </rule>
      <rule id="bp_5">
        <inputEntry><text>&gt;= 160</text></inputEntry>
        <inputEntry><text>&gt;= 100</text></inputEntry>
        <outputEntry><text>"Stage3_HTN"</text></outputEntry>
        <outputEntry><text>-1</text></outputEntry>
      </rule>
    </decisionTable>
  </decision>
</definitions>
```

### 2.5 Custom Python Engine

For carriers building cloud-native platforms, a custom Python engine offers maximum flexibility.

```python
from dataclasses import dataclass, field
from typing import List, Callable, Optional
from enum import Enum
import logging

logger = logging.getLogger("uw_rules_engine")


class RiskClass(Enum):
    PREFERRED_PLUS = 5
    PREFERRED = 4
    STANDARD_PLUS = 3
    STANDARD = 2
    TABLE_RATED = 1
    DECLINE = 0


class RuleCategory(Enum):
    ELIGIBILITY = "eligibility"
    KNOCKOUT = "knockout"
    EVIDENCE = "evidence"
    BUILD = "build"
    BLOOD_PRESSURE = "blood_pressure"
    LAB = "lab"
    RX = "rx"
    MEDICAL = "medical"
    FINANCIAL = "financial"
    CLASSIFICATION = "classification"


@dataclass
class RuleFiring:
    rule_id: str
    rule_name: str
    category: RuleCategory
    debits: int = 0
    credits: int = 0
    risk_class_ceiling: Optional[RiskClass] = None
    action: Optional[str] = None
    explanation: str = ""


@dataclass
class UnderwritingContext:
    applicant: dict
    application: dict
    medical_history: list = field(default_factory=list)
    lab_results: dict = field(default_factory=dict)
    rx_history: list = field(default_factory=list)
    mib_hits: list = field(default_factory=list)
    mvr_record: dict = field(default_factory=dict)
    financial: dict = field(default_factory=dict)
    firings: list = field(default_factory=list)
    derived_facts: dict = field(default_factory=dict)
    eligible: bool = True
    declined: bool = False
    decline_reason: str = ""
    evidence_requirements: list = field(default_factory=list)
    risk_class_ceiling: RiskClass = RiskClass.PREFERRED_PLUS
    total_debits: int = 0
    total_credits: int = 0


class Rule:
    def __init__(self, rule_id, name, category, salience, condition, action,
                 effective_date=None, expiry_date=None):
        self.rule_id = rule_id
        self.name = name
        self.category = category
        self.salience = salience
        self.condition = condition
        self.action = action

    def evaluate(self, ctx):
        if self.condition(ctx):
            return self.action(ctx)
        return None


class UnderwritingRulesEngine:
    def __init__(self):
        self.rules = []
        self._sorted = False

    def register(self, rule):
        self.rules.append(rule)
        self._sorted = False

    def execute(self, ctx):
        if not self._sorted:
            self.rules.sort(key=lambda r: -r.salience)
            self._sorted = True
        for rule in self.rules:
            if ctx.declined:
                break
            firing = rule.evaluate(ctx)
            if firing:
                ctx.firings.append(firing)
                ctx.total_debits += firing.debits
                ctx.total_credits += firing.credits
                if firing.risk_class_ceiling is not None:
                    if firing.risk_class_ceiling.value < ctx.risk_class_ceiling.value:
                        ctx.risk_class_ceiling = firing.risk_class_ceiling
        return ctx
```

### 2.6 Technology Comparison Matrix

| Criterion | Drools | IBM ODM | FICO Blaze | Camunda DMN | Custom Python | Custom Java |
|-----------|--------|---------|------------|-------------|---------------|-------------|
| **Algorithm** | Phreak (Rete3) | Rete-II | Rete-II | DMN FEEL | Sequential | Sequential/Rete |
| **Rule Authoring** | DRL + Spreadsheet | BAL + Decision Center | Rulesheet | DMN XML + Modeler | Python/YAML | Java/YAML |
| **Business User Friendly** | Medium | High | High | High | Low | Low |
| **DMN Support** | Full | Full | Partial | Native | Custom | Custom |
| **Performance (rules/sec)** | 50K+ | 30K+ | 40K+ | 20K+ | 10K+ | 40K+ |
| **Cloud Native** | Via Kogito | Via CP4BA | Cloud | Zeebe | Native | Native |
| **License Cost** | Open Source / $$ | $$$$$ | $$$$ | Open Source / $$ | Free | Free |
| **Vendor Lock-in** | Low | High | High | Low | None | None |
| **Hot Deployment** | Yes | Yes | Yes | Yes | Custom | Custom |
| **Audit Trail** | Built-in | Built-in | Built-in | Via history | Custom | Custom |
| **Typical Carrier Size** | Mid-Large | Large | Large | Mid | Insurtech/Startup | Mid |
| **Learning Curve** | Medium | High | High | Low | Low (if Python shop) | Medium |

### 2.7 Recommendation by Carrier Profile

```
Decision Tree -- Technology Selection:

[Start]
  |
  +- Greenfield cloud-native Insurtech?
  |   +- Yes -> Python/Go custom engine + Camunda DMN for decision tables
  |   +- No  v
  +- Existing IBM mainframe / COBOL estate?
  |   +- Yes -> IBM ODM (integrates with existing IBM middleware)
  |   +- No  v
  +- Heavy predictive analytics / credit scoring?
  |   +- Yes -> FICO Blaze Advisor
  |   +- No  v
  +- Budget-conscious, Java shop?
  |   +- Yes -> Drools (open-source core) + Business Central
  |   +- No  v
  +- Microservices, process orchestration focus?
  |   +- Yes -> Camunda DMN + Zeebe orchestrator
  |   +- No  v
  +- Default -> Drools (best community, most UW-specific examples)
```

---

## 3. Rule Categories with Pseudocode

### 3.1 Eligibility Rules

Eligibility rules are the first gate—they determine whether the applicant can even be considered for the product. These are typically simple, high-salience rules implemented as decision tables.

**Drools DRL — Eligibility Rules:**

```drools
package com.carrier.uw.rules.eligibility

rule "ELIG-001: Minimum Age"
    salience 10000
    when $a : Applicant(age < 18)
    then decline($a, "ELIG_AGE_MIN", "Applicant under minimum age of 18");
end

rule "ELIG-002: Maximum Age Term-10"
    salience 10000
    when
        $a : Applicant(age > 75)
        $p : Application(productCode == "TERM10", applicantId == $a.id)
    then decline($a, "ELIG_AGE_MAX_T10", "Age exceeds 75 for Term-10");
end

rule "ELIG-003: Maximum Age Term-20"
    salience 10000
    when
        $a : Applicant(age > 70)
        $p : Application(productCode == "TERM20", applicantId == $a.id)
    then decline($a, "ELIG_AGE_MAX_T20", "Age exceeds 70 for Term-20");
end

rule "ELIG-004: Maximum Age Term-30"
    salience 10000
    when
        $a : Applicant(age > 60)
        $p : Application(productCode == "TERM30", applicantId == $a.id)
    then decline($a, "ELIG_AGE_MAX_T30", "Age exceeds 60 for Term-30");
end

rule "ELIG-005: Product Not Filed in State"
    salience 10000
    when
        $a : Applicant()
        $p : Application(applicantId == $a.id)
        not ProductFiling(productCode == $p.productCode, state == $p.state)
    then decline($a, "ELIG_STATE", "Product not approved in " + $p.getState());
end

rule "ELIG-007: Minimum Face Amount"
    salience 10000
    when $p : Application(faceAmount < 25000)
    then decline($p, "ELIG_FACE_MIN", "Face amount below $25,000 minimum");
end

rule "ELIG-008: Maximum Face Amount"
    salience 10000
    when $p : Application(faceAmount > 10000000)
    then decline($p, "ELIG_FACE_MAX", "Face amount exceeds $10M maximum");
end

rule "ELIG-009: Maximum Face for Age 70+"
    salience 10000
    when
        $a : Applicant(age >= 70)
        $p : Application(applicantId == $a.id, faceAmount > 1000000)
    then decline($a, "ELIG_FACE_AGE", "Face amount exceeds $1M for age 70+");
end
```

**Complete Eligibility Rules Catalog (50 rules):**

| # | Rule ID | Description | Condition | Action |
|---|---------|-------------|-----------|--------|
| 1 | ELIG-001 | Minimum age | age < 18 | Decline |
| 2 | ELIG-002 | Max age Term-10 | age > 75 | Decline |
| 3 | ELIG-003 | Max age Term-20 | age > 70 | Decline |
| 4 | ELIG-004 | Max age Term-30 | age > 60 | Decline |
| 5 | ELIG-005 | Max age ROP-Term | age > 65 | Decline |
| 6 | ELIG-006 | Product not filed in state | no filing record | Decline |
| 7 | ELIG-007 | Minimum face amount | face < $25K | Decline |
| 8 | ELIG-008 | Maximum face amount | face > $10M | Decline |
| 9 | ELIG-009 | Max face age 70+ | age >= 70 AND face > $1M | Decline |
| 10 | ELIG-010 | Max face age 18-25 | age 18-25 AND face > $2M | Decline |
| 11 | ELIG-011 | Non-US resident | residency != US | Decline |
| 12 | ELIG-012 | Foreign national travel risk | citizenship risk country | Decline/Refer |
| 13 | ELIG-013 | Active military combat zone | deployment = combat | Decline |
| 14 | ELIG-014 | Existing coverage replacement | replacement AND state in {NY,NJ} | Add 1035 forms |
| 15 | ELIG-015 | Total in-force + applied > limit | totalCoverage > $20M | Refer |
| 16 | ELIG-016 | Prior declined < 12 months | priorDecline AND months < 12 | Decline |
| 17 | ELIG-017 | Missing SSN | SSN is null | Pend |
| 18 | ELIG-018 | Missing beneficiary | beneficiary is null | Pend |
| 19 | ELIG-019 | Duplicate application | same SSN + product within 30 days | Reject |
| 20 | ELIG-020 | OFAC/SDN list match | name/DOB matches OFAC | Decline + SAR |
| 21 | ELIG-021 | Minor child rider age | child age < 15 days | Decline rider |
| 22 | ELIG-022 | Conversion eligibility | beyond conversion window | Decline |
| 23 | ELIG-023 | Group conversion max face | conversion face > 2x group | Cap face |
| 24 | ELIG-024 | Backdating limit | backdate > 6 months | Reject |
| 25 | ELIG-025 | Premium frequency | face < $100K AND monthly | Allow with modal |
| 26 | ELIG-026 | Agent not appointed | agent state != app state | Reject |
| 27 | ELIG-027 | E-sig validation | e-sig missing | Pend |
| 28 | ELIG-028 | Insurable interest (BOLI) | no business relationship | Decline |
| 29 | ELIG-029 | Trust-owned verification | owner = trust AND no docs | Pend |
| 30 | ELIG-030 | Juvenile needs parent | age < 18 AND no parent sig | Pend |
| 31 | ELIG-031 | Product age band | age not in bands | Decline |
| 32 | ELIG-032 | Tobacco reclassification | nicotine+ but applied NT | Reclassify |
| 33 | ELIG-033 | Missing height/weight | null values | Pend |
| 34 | ELIG-034 | State waiting period | days since app < 30 | Hold |
| 35 | ELIG-035 | Premium > income ratio | premium > 10% income | Refer |
| 36 | ELIG-036 | STOLI threshold | face > $5M AND age > 70 | Investigate |
| 37 | ELIG-037 | Multi-policy aggregate | carrier total > $15M | Refer |
| 38 | ELIG-038 | ROP age limit | ROP AND age > 55 | Decline rider |
| 39 | ELIG-039 | ADB rider state | ADB AND state = WA | Not available |
| 40 | ELIG-040 | WOP rider age | WOP AND age > 60 | Decline rider |
| 41 | ELIG-041 | Children rider max | #children > 10 | Cap at 10 |
| 42 | ELIG-042 | Flat extra max | years > 10 | Cap at 10 |
| 43 | ELIG-043 | Table rating max | > Table P (250%) | Decline |
| 44 | ELIG-044 | Fraud indicators | material misrep flags | SIU referral |
| 45 | ELIG-045 | International face limit | non-US AND face > $500K | Decline |
| 46 | ELIG-046 | Application staleness | app > 90 days old | Re-apply |
| 47 | ELIG-047 | IDV failure | identity verification failed | Pend |
| 48 | ELIG-048 | Sanctions screening | PEP or sanctions hit | Refer compliance |
| 49 | ELIG-049 | Min premium threshold | annual premium < $100 | Decline |
| 50 | ELIG-050 | Max riders per policy | rider count > 5 | Decline excess |

### 3.2 Knock-Out Rules (~100 Triggers)

Knock-out rules trigger immediate decline, postponement, or mandatory referral. These are high-priority rules that short-circuit remaining evaluation.

| # | Rule ID | Description | Condition | Action |
|---|---------|-------------|-----------|--------|
| 1 | KO-001 | Active cancer (any site) | ICD C0x-C9x AND active | DECLINE |
| 2 | KO-002 | Metastatic cancer | ICD C78.x or C79.x | DECLINE |
| 3 | KO-003 | ALS / Motor neuron disease | ICD G12.21 | DECLINE |
| 4 | KO-004 | End-stage renal disease | ICD N18.6 | DECLINE |
| 5 | KO-005 | Organ transplant waiting list | ICD Z76.82 | POSTPONE |
| 6 | KO-006 | Active AIDS | ICD B20 AND active | DECLINE |
| 7 | KO-007 | Hepatitis C active viremia | ICD B18.2, no SVR | DECLINE |
| 8 | KO-008 | Cirrhosis of liver | ICD K74.x | DECLINE |
| 9 | KO-009 | Cardiomyopathy (dilated) | ICD I42.0 | DECLINE |
| 10 | KO-010 | Aortic aneurysm > 5cm | ICD I71.x, size > 5 | DECLINE |
| 11 | KO-011 | Active IV drug use | iv_drug_use = current | DECLINE |
| 12 | KO-012 | Alcohol abuse (current tx) | ICD F10.x, active | POSTPONE 2yr |
| 13 | KO-013 | Drug rehab < 2 years | ICD F11-F15, recent | POSTPONE |
| 14 | KO-014 | Positive cocaine screen | cocaine = positive | DECLINE |
| 15 | KO-015 | Positive amphetamine (no Rx) | amphetamine+, no ADHD Rx | DECLINE |
| 16 | KO-016 | Felony conviction < 5 years | felony, years < 5 | DECLINE |
| 17 | KO-017 | Currently incarcerated | incarcerated = true | DECLINE |
| 18 | KO-018 | Pending felony charges | pending_felony | POSTPONE |
| 19 | KO-019 | DUI/DWI 2+ in 5 years | dui_count_5yr >= 2 | DECLINE |
| 20 | KO-020 | Reckless driving < 3 years | reckless < 3yr | DECLINE |
| 21 | KO-021 | Skydiving 50+ jumps/year | jumps >= 50 | DECLINE |
| 22 | KO-022 | Professional racing | occupation = racer | DECLINE |
| 23 | KO-023 | Private pilot < 100 hours | pilot AND hours < 100 | DECLINE |
| 24 | KO-024 | Scuba diving 150+ ft | depth >= 150ft | DECLINE |
| 25 | KO-025 | Rock climbing solo/free | type = free_solo | DECLINE |
| 26 | KO-026 | Suicide attempt < 2 years | ICD T14.91, < 2yr | DECLINE |
| 27 | KO-027 | Active psychosis | ICD F20.x, active | DECLINE |
| 28 | KO-028 | Bipolar I uncontrolled | ICD F31.9, hospitalized | POSTPONE |
| 29 | KO-029 | Heart failure NYHA III/IV | ICD I50.x, class >= 3 | DECLINE |
| 30 | KO-030 | MI < 6 months | ICD I21.x, < 6mo | POSTPONE |
| 31 | KO-031 | Stroke/CVA < 6 months | ICD I63.x, < 6mo | POSTPONE |
| 32 | KO-032 | Pulmonary embolism < 12mo | ICD I26.99, < 12mo | POSTPONE |
| 33 | KO-033 | COPD oxygen dependent | ICD J44.x, on O2 | DECLINE |
| 34 | KO-034 | Pulmonary fibrosis | ICD J84.10 | DECLINE |
| 35 | KO-035 | Cystic fibrosis | ICD E84.9 | DECLINE |
| 36 | KO-036 | Alzheimer's / dementia | ICD G30, F01-F03 | DECLINE |
| 37 | KO-037 | Parkinson's advanced | ICD G20, stage >= 3 | DECLINE |
| 38 | KO-038 | MS progressive | ICD G35, progressive | DECLINE |
| 39 | KO-039 | Epilepsy uncontrolled | ICD G40.x, > 3 seizures/yr | DECLINE |
| 40 | KO-040 | Type 1 DM HbA1c > 10 | ICD E10.x, A1c > 10 | DECLINE |
| 41 | KO-041 | Diabetic nephropathy stg 4+ | ICD E11.22, CKD >= 4 | DECLINE |
| 42 | KO-042 | Lupus renal involvement | ICD M32.14 | DECLINE |
| 43 | KO-043 | Scleroderma diffuse | ICD M34.0 | DECLINE |
| 44 | KO-044 | Huntington's disease | ICD G10 | DECLINE |
| 45 | KO-045 | Marfan syndrome | ICD Q87.40 | DECLINE |
| 46 | KO-046 | Active tuberculosis | ICD A15.x, active | POSTPONE |
| 47 | KO-047 | Chronic Hepatitis B | ICD B18.1, active | DECLINE |
| 48 | KO-048 | Morbid obesity BMI > 50 | BMI > 50 | DECLINE |
| 49 | KO-049 | CKD Stage 5 | ICD N18.5 | DECLINE |
| 50 | KO-050 | Sickle cell severe | ICD D57.1, > 2 crises/yr | DECLINE |
| 51 | KO-051 | Pancreatic cancer | ICD C25.x | DECLINE |
| 52 | KO-052 | Brain tumor malignant | ICD C71.x | DECLINE |
| 53 | KO-053 | Leukemia active | ICD C91-C95, active | DECLINE |
| 54 | KO-054 | Lymphoma active | ICD C81-C85, active | POSTPONE |
| 55 | KO-055 | Myelodysplastic syndrome | ICD D46.x | DECLINE |
| 56 | KO-056 | Aplastic anemia | ICD D61.9 | DECLINE |
| 57 | KO-057 | Liver failure | ICD K72.x | DECLINE |
| 58 | KO-058 | Portal hypertension | ICD K76.6 | DECLINE |
| 59 | KO-059 | Pulmonary hypertension | ICD I27.x | DECLINE |
| 60 | KO-060 | Sustained V-tach | ICD I47.2 | DECLINE |
| 61 | KO-061 | AAA > 5.5cm | ICD I71.4, > 5.5cm | DECLINE |
| 62 | KO-062 | Recurrent DVT | ICD I82.40, >= 2 episodes | DECLINE |
| 63 | KO-063 | Muscular dystrophy | ICD G71.0x | DECLINE |
| 64 | KO-064 | Myasthenia gravis severe | ICD G70.00, severe | DECLINE |
| 65 | KO-065 | Chronic pancreatitis | ICD K86.1 | DECLINE |
| 66 | KO-066 | Systemic amyloidosis | ICD E85.9 | DECLINE |
| 67 | KO-067 | Addison's adrenal crisis | ICD E27.1, crisis hx | DECLINE |
| 68 | KO-068 | Cushing's active | ICD E24.9, active | POSTPONE |
| 69 | KO-069 | Acromegaly uncontrolled | ICD E22.0, active | DECLINE |
| 70 | KO-070 | Mountaineering > 20K ft | altitude > 20000 | DECLINE |
| 71 | KO-071 | BASE jumping | base_jumping = true | DECLINE |
| 72 | KO-072 | Underground mining | occupation | DECLINE |
| 73 | KO-073 | Offshore oil rig | occupation | FLAT EXTRA |
| 74 | KO-074 | Deep sea fishing | occupation | FLAT EXTRA |
| 75 | KO-075 | License suspended | current suspension | DECLINE |
| 76 | KO-076 | Vehicular manslaughter | on record | DECLINE |
| 77 | KO-077 | 3+ violations in 3 years | violations >= 3 | TABLE RATE |
| 78 | KO-078 | At-fault fatality accident | on record | DECLINE |
| 79 | KO-079 | Speed > 100mph violation | on record | DECLINE |
| 80 | KO-080 | Undisclosed prior app | MIB hit, undisclosed | REFER |
| 81 | KO-081 | Material misrepresentation | detected | DECLINE |
| 82 | KO-082 | MIB 099 multi-carrier | 2+ carriers declined | DECLINE |
| 83 | KO-083 | Active bankruptcy | current | POSTPONE |
| 84 | KO-084 | STOLI indicators | stoli_score >= 3 | DECLINE |
| 85 | KO-085 | Face > 30x income | no justification | DECLINE |
| 86 | KO-086 | 2+ ADL limitations | adl >= 2 | DECLINE |
| 87 | KO-087 | Nursing home resident | residence type | DECLINE |
| 88 | KO-088 | Wheelchair dependent | documented | REFER |
| 89 | KO-089 | Cognitive impairment | ICD R41.8x | REFER |
| 90 | KO-090 | Currently pregnant | pregnant = true | POSTPONE |
| 91 | KO-091 | OFAC country travel | planned | DECLINE |
| 92 | KO-092 | High-risk travel > 6mo | months > 6 | DECLINE |
| 93 | KO-093 | Conflict zone travel | planned | DECLINE |
| 94 | KO-094 | Age+tobacco+DM+CAD combo | all present, age > 65 | DECLINE |
| 95 | KO-095 | Chemical exposure | occupational | REFER |
| 96 | KO-096 | Total disability claim | active | DECLINE |
| 97 | KO-097 | Opioid dependency | ICD F11.2x | DECLINE |
| 98 | KO-098 | Sleep apnea untreated AHI>30 | no CPAP, AHI > 30 | DECLINE |
| 99 | KO-099 | BMI < 16 severe underweight | BMI < 16 | DECLINE |
| 100 | KO-100 | Esophageal varices | ICD I85.x | DECLINE |

### 3.3 Evidence Requirement Rules (Age x Amount Matrix)

**Complete Evidence Requirement Matrix (Decision Table):**

| Age Band | <= $100K | $100K-$250K | $250K-$500K | $500K-$1M | $1M-$3M | $3M-$5M | $5M-$10M | > $10M |
|----------|---------|-------------|-------------|-----------|----------|----------|----------|--------|
| **18-30** | App | App | App | Para+Blood | Para+Blood+UA | Para+Blood+UA+EKG | Full Med+Inspect | Full+Inspect+Fin |
| **31-40** | App | App | Para+Blood | Para+Blood+UA | Para+Blood+UA+EKG | Full Med+Inspect | Full+Inspect+Fin | Full+Inspect+Fin |
| **41-50** | App | Para+Blood | Para+Blood+UA | Para+Blood+UA+EKG | Full+EKG+Inspect | Full+EKG+Inspect+Fin | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin |
| **51-60** | Para+Blood | Para+Blood+UA | Para+Blood+UA+EKG | Full Med+EKG | Full+EKG+Inspect+Fin | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin |
| **61-70** | Para+Blood+UA | Para+Blood+UA+EKG | Full Med+EKG | Full+EKG+Inspect | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin | N/A |
| **71-80** | Full Med+EKG | Full+EKG+Inspect | Full+EKG+Inspect+Fin | Full+Stress+Inspect+Fin | Full+Stress+Inspect+Fin | N/A | N/A | N/A |

**Legend:** App=Application+MIB+MVR+Rx, Para=Paramedical, Blood=Blood profile, UA=Urinalysis+drug screen, EKG=Electrocardiogram, Full Med=Full medical exam, Stress=Exercise stress test, Inspect=Inspection report, Fin=Financial documentation

### 3.4 Build Chart Rules (BMI by Age/Gender)

```python
def calculate_bmi(height_inches, weight_lbs):
    return (weight_lbs * 703) / (height_inches ** 2)

BUILD_CHART_MALE = {
    (18, 29): [
        (24.9, "PREFERRED_PLUS", 0), (27.4, "PREFERRED", 15),
        (29.9, "STANDARD_PLUS", 35), (32.4, "STANDARD", 75),
        (34.9, "TABLE_B", 125), (37.4, "TABLE_D", 175),
        (39.9, "TABLE_F", 225), (44.9, "TABLE_H", 300),
        (49.9, "TABLE_L", 400), (999, "DECLINE", -1),
    ],
    (30, 39): [
        (25.4, "PREFERRED_PLUS", 0), (27.9, "PREFERRED", 15),
        (30.4, "STANDARD_PLUS", 35), (32.9, "STANDARD", 75),
        (35.4, "TABLE_B", 125), (37.9, "TABLE_D", 175),
        (40.4, "TABLE_F", 225), (45.4, "TABLE_H", 300),
        (49.9, "TABLE_L", 400), (999, "DECLINE", -1),
    ],
    (40, 49): [
        (25.9, "PREFERRED_PLUS", 0), (28.4, "PREFERRED", 20),
        (30.9, "STANDARD_PLUS", 40), (33.4, "STANDARD", 80),
        (35.9, "TABLE_B", 130), (38.4, "TABLE_D", 180),
        (40.9, "TABLE_F", 230), (45.9, "TABLE_H", 310),
        (49.9, "TABLE_L", 400), (999, "DECLINE", -1),
    ],
    (50, 59): [
        (26.4, "PREFERRED_PLUS", 0), (28.9, "PREFERRED", 25),
        (31.4, "STANDARD_PLUS", 50), (33.9, "STANDARD", 90),
        (36.4, "TABLE_B", 140), (38.9, "TABLE_D", 190),
        (41.4, "TABLE_F", 240), (46.4, "TABLE_H", 320),
        (49.9, "TABLE_P", 450), (999, "DECLINE", -1),
    ],
    (60, 69): [
        (26.9, "PREFERRED_PLUS", 0), (29.4, "PREFERRED", 25),
        (31.9, "STANDARD_PLUS", 50), (34.4, "STANDARD", 100),
        (36.9, "TABLE_B", 150), (39.4, "TABLE_D", 200),
        (41.9, "TABLE_F", 250), (46.9, "TABLE_H", 350),
        (999, "DECLINE", -1),
    ],
    (70, 80): [
        (27.4, "PREFERRED_PLUS", 0), (29.9, "PREFERRED", 30),
        (32.4, "STANDARD_PLUS", 60), (34.9, "STANDARD", 110),
        (37.4, "TABLE_B", 160), (39.9, "TABLE_D", 210),
        (42.4, "TABLE_F", 260), (999, "DECLINE", -1),
    ],
}

def evaluate_build(age, gender, height_in, weight_lbs):
    bmi = calculate_bmi(height_in, weight_lbs)
    chart = BUILD_CHART_MALE if gender == "M" else BUILD_CHART_FEMALE
    for (age_min, age_max), thresholds in chart.items():
        if age_min <= age <= age_max:
            for bmi_max, risk_class, debits in thresholds:
                if bmi <= bmi_max:
                    return {"bmi": round(bmi, 1), "risk_class_ceiling": risk_class,
                            "debits": debits, "age_band": f"{age_min}-{age_max}"}
    return {"bmi": round(bmi, 1), "risk_class_ceiling": "DECLINE", "debits": -1}
```

### 3.5 Blood Pressure Rules

```drools
rule "BP-001: Optimal"
    activation-group "bp-classification"
    salience 100
    when $bp : BloodPressure(systolic < 120, diastolic < 80)
    then
        modify($bp) { setClassification("OPTIMAL") };
        insert(new DebitEntry($bp.getApplicantId(), "BP", 0, "BP Optimal"));
end

rule "BP-002: Normal"
    activation-group "bp-classification"
    salience 90
    when $bp : BloodPressure((systolic >= 120 && systolic <= 129) || (diastolic >= 80 && diastolic <= 84))
    then
        modify($bp) { setClassification("NORMAL") };
        insert(new DebitEntry($bp.getApplicantId(), "BP", 10, "BP Normal-High"));
end

rule "BP-003: High Normal"
    activation-group "bp-classification"
    salience 80
    when $bp : BloodPressure((systolic >= 130 && systolic <= 139) || (diastolic >= 85 && diastolic <= 89))
    then
        modify($bp) { setClassification("HIGH_NORMAL") };
        insert(new RiskClassCeiling($bp.getApplicantId(), RiskClass.STANDARD_PLUS));
        insert(new DebitEntry($bp.getApplicantId(), "BP", 50, "BP High-Normal"));
end

rule "BP-004: Stage 1 Hypertension"
    activation-group "bp-classification"
    salience 70
    when $bp : BloodPressure((systolic >= 140 && systolic <= 159) || (diastolic >= 90 && diastolic <= 99))
    then
        modify($bp) { setClassification("STAGE1_HTN") };
        insert(new RiskClassCeiling($bp.getApplicantId(), RiskClass.STANDARD));
        insert(new DebitEntry($bp.getApplicantId(), "BP", 100, "Stage 1 HTN"));
end

rule "BP-005: Stage 2 Hypertension"
    activation-group "bp-classification"
    salience 60
    when $bp : BloodPressure((systolic >= 160 && systolic <= 179) || (diastolic >= 100 && diastolic <= 109))
    then
        modify($bp) { setClassification("STAGE2_HTN") };
        insert(new TableRating($bp.getApplicantId(), "TABLE_D", "Stage 2 HTN"));
end

rule "BP-006: Stage 3 Hypertension -- Decline"
    activation-group "bp-classification"
    salience 50
    when $bp : BloodPressure(systolic >= 180 || diastolic >= 110)
    then
        insert(new DeclineAction($bp.getApplicantId(), "BP_SEVERE",
            "Systolic >= 180 or Diastolic >= 110"));
end
```

### 3.6 Medical Impairment Rules

```drools
rule "MED-CAD-001: CAD single vessel, revascularized, 2+ years, normal stress"
    when
        $a : Applicant()
        $c : MedicalCondition(applicantId == $a.id, icdCode matches "I25.*",
            vesselCount == 1, revascularized == true, yearsSinceProcedure >= 2)
        $stress : StressTest(applicantId == $a.id, result == "NORMAL")
    then
        insert(new TableRating($a.getId(), "TABLE_B", "CAD single vessel"));
        insert(new DebitEntry($a.getId(), "MEDICAL", 100, "CAD-single-revasc"));
end

rule "MED-DM-001: Type 2 DM controlled, no complications, onset after 40"
    when
        $a : Applicant(age > 40)
        $c : MedicalCondition(applicantId == $a.id, icdCode matches "E11.*",
            onsetAge >= 40, complications == false)
        $lab : LabResult(applicantId == $a.id, testCode == "HBA1C", value <= 7.0)
    then
        insert(new TableRating($a.getId(), "TABLE_B", "T2DM controlled"));
        insert(new DebitEntry($a.getId(), "MEDICAL", 100, "T2DM-controlled"));
end

rule "MED-AFIB-001: AFib paroxysmal, anticoagulated"
    when
        $a : Applicant()
        $c : MedicalCondition(applicantId == $a.id, icdCode == "I48.0",
            structural_heart_disease == false)
        $rx : RxHistory(applicantId == $a.id, therapeuticClass memberOf {"anticoagulant"})
    then
        insert(new TableRating($a.getId(), "TABLE_B", "Paroxysmal AFib"));
        insert(new DebitEntry($a.getId(), "MEDICAL", 100, "AFib-paroxysmal"));
end

rule "MED-OSA-001: Sleep Apnea mild, CPAP compliant"
    when
        $a : Applicant()
        $c : MedicalCondition(applicantId == $a.id, icdCode == "G47.33",
            ahi > 5, ahi <= 15, cpapCompliant == true)
    then
        insert(new RiskClassCeiling($a.getId(), RiskClass.PREFERRED));
        insert(new DebitEntry($a.getId(), "MEDICAL", 25, "OSA-mild"));
end

rule "MED-ASTHMA-001: Asthma mild intermittent"
    when
        $a : Applicant()
        $c : MedicalCondition(applicantId == $a.id, icdCode matches "J45.2*",
            hospitalizations == 0)
    then
        insert(new RiskClassCeiling($a.getId(), RiskClass.PREFERRED));
        insert(new DebitEntry($a.getId(), "MEDICAL", 15, "Asthma-mild"));
end
```

### 3.7 Financial Justification Rules

```python
FINANCIAL_RULES = {
    "age_18_40": {"earned_income_multiple": 25, "net_worth_multiple": 1.0},
    "age_41_50": {"earned_income_multiple": 20, "net_worth_multiple": 0.8},
    "age_51_60": {"earned_income_multiple": 15, "net_worth_multiple": 0.6},
    "age_61_70": {"earned_income_multiple": 10, "net_worth_multiple": 0.5},
    "age_71_plus": {"earned_income_multiple": 5, "net_worth_multiple": 0.3},
}

def evaluate_financial_justification(applicant, application, financial):
    age = applicant["age"]
    face = application["faceAmount"]
    existing = financial.get("existing_coverage", 0)
    total = face + existing

    if age <= 40: rules = FINANCIAL_RULES["age_18_40"]
    elif age <= 50: rules = FINANCIAL_RULES["age_41_50"]
    elif age <= 60: rules = FINANCIAL_RULES["age_51_60"]
    elif age <= 70: rules = FINANCIAL_RULES["age_61_70"]
    else: rules = FINANCIAL_RULES["age_71_plus"]

    max_justified = (financial.get("earned_income", 0) * rules["earned_income_multiple"]
                     + financial.get("net_worth", 0) * rules["net_worth_multiple"])

    return {
        "total_coverage": total,
        "max_justified": max_justified,
        "justified": total <= max_justified,
        "action": "REFER" if total > max_justified else "OK",
    }
```

### 3.8 Risk Classification Aggregation

```python
def aggregate_risk_classification(ctx):
    if ctx.declined:
        return {"final_class": "DECLINE", "reason": ctx.decline_reason}

    net_score = ctx.total_credits - ctx.total_debits
    ceiling = ctx.risk_class_ceiling

    SCORE_MAP = [
        (101, RiskClass.PREFERRED_PLUS), (81, RiskClass.PREFERRED),
        (51, RiskClass.STANDARD_PLUS), (1, RiskClass.STANDARD),
        (-24, RiskClass.TABLE_RATED),
    ]
    score_class = RiskClass.DECLINE
    for threshold, rc in SCORE_MAP:
        if net_score >= threshold:
            score_class = rc
            break

    final = RiskClass(min(score_class.value, ceiling.value))
    return {
        "final_class": final.name,
        "net_score": net_score,
        "score_based_class": score_class.name,
        "ceiling_class": ceiling.name,
        "ceiling_was_limiting": score_class.value > ceiling.value,
    }
```

### 3.9 Accelerated Underwriting Eligibility Rules

```drools
rule "ACCEL-001: Age/Amount within AUW limits"
    salience 500
    when
        $a : Applicant(age >= 18, age <= 55)
        $p : Application(applicantId == $a.id, faceAmount >= 100000, faceAmount <= 1000000)
        not EligibilityResult(applicantId == $a.id, eligible == false)
    then insert(new AccelEligibility($a.getId(), true, "AGE_AMOUNT_OK"));
end

rule "ACCEL-002: No knock-out conditions"
    salience 499
    when
        $a : Applicant()
        $accel : AccelEligibility(applicantId == $a.id, eligible == true)
        not KnockoutFiring(applicantId == $a.id)
    then modify($accel) { addPassedGate("NO_KNOCKOUTS") };
end

rule "ACCEL-003: Clean MIB"
    salience 498
    when
        $accel : AccelEligibility(applicantId == $a.id, eligible == true)
        not MibHit(applicantId == $a.id, significanceLevel memberOf {"HIGH", "CRITICAL"})
    then modify($accel) { addPassedGate("CLEAN_MIB") };
end

rule "ACCEL-004: Clean Rx profile"
    salience 497
    when
        $accel : AccelEligibility(applicantId == $a.id, eligible == true)
        not RxFinding(applicantId == $a.id, severity memberOf {"HIGH", "CRITICAL"})
    then modify($accel) { addPassedGate("CLEAN_RX") };
end

rule "ACCEL-005: All gates passed -- approve for accelerated"
    salience 400
    when
        $accel : AccelEligibility(applicantId == $a.id, eligible == true,
            passedGates contains "NO_KNOCKOUTS",
            passedGates contains "CLEAN_MIB",
            passedGates contains "CLEAN_RX")
    then
        modify($accel) { setAccelApproved(true) };
        insert(new EvidenceWaiver($a.getId(), "PARAMEDICAL", "Accel UW approved"));
end
```

---

## 4. Complete Decision Tables (DMN-Style)

### 4.1 Full Build Chart Table (Male, Selected Heights)

| **F** | Age | Height (in) | Max Weight (lbs) | -> Risk Class Ceiling | -> Debits |
|-------|-----|-------------|-------------------|----------------------|----------|
| 1 | 18-29 | 64 | 148 | Preferred Plus | 0 |
| 2 | 18-29 | 64 | 160 | Preferred | 15 |
| 3 | 18-29 | 64 | 176 | Standard Plus | 35 |
| 4 | 18-29 | 64 | 194 | Standard | 75 |
| 5 | 18-29 | 64 | 212 | Table B | 125 |
| 6 | 18-29 | 64 | 232 | Table D | 175 |
| 7 | 18-29 | 66 | 157 | Preferred Plus | 0 |
| 8 | 18-29 | 66 | 170 | Preferred | 15 |
| 9 | 18-29 | 66 | 187 | Standard Plus | 35 |
| 10 | 18-29 | 66 | 206 | Standard | 75 |
| 11 | 18-29 | 66 | 225 | Table B | 125 |
| 12 | 18-29 | 68 | 166 | Preferred Plus | 0 |
| 13 | 18-29 | 68 | 180 | Preferred | 15 |
| 14 | 18-29 | 68 | 198 | Standard Plus | 35 |
| 15 | 18-29 | 68 | 218 | Standard | 75 |
| 16 | 18-29 | 68 | 238 | Table B | 125 |
| 17 | 18-29 | 70 | 176 | Preferred Plus | 0 |
| 18 | 18-29 | 70 | 191 | Preferred | 15 |
| 19 | 18-29 | 70 | 210 | Standard Plus | 35 |
| 20 | 18-29 | 70 | 232 | Standard | 75 |
| 21 | 18-29 | 70 | 253 | Table B | 125 |
| 22 | 18-29 | 72 | 186 | Preferred Plus | 0 |
| 23 | 18-29 | 72 | 202 | Preferred | 15 |
| 24 | 18-29 | 72 | 222 | Standard Plus | 35 |
| 25 | 18-29 | 72 | 245 | Standard | 75 |
| 26 | 18-29 | 72 | 267 | Table B | 125 |
| 27 | 40-49 | 66 | 161 | Preferred Plus | 0 |
| 28 | 40-49 | 66 | 175 | Preferred | 20 |
| 29 | 40-49 | 66 | 193 | Standard Plus | 40 |
| 30 | 40-49 | 66 | 212 | Standard | 80 |
| 31 | 40-49 | 68 | 170 | Preferred Plus | 0 |
| 32 | 40-49 | 68 | 185 | Preferred | 20 |
| 33 | 40-49 | 68 | 204 | Standard Plus | 40 |
| 34 | 40-49 | 68 | 225 | Standard | 80 |
| 35 | 40-49 | 70 | 181 | Preferred Plus | 0 |
| 36 | 40-49 | 70 | 197 | Preferred | 20 |
| 37 | 40-49 | 70 | 216 | Standard Plus | 40 |
| 38 | 40-49 | 70 | 238 | Standard | 80 |
| 39 | 50-59 | 70 | 185 | Preferred Plus | 0 |
| 40 | 50-59 | 70 | 202 | Preferred | 25 |
| 41 | 50-59 | 70 | 222 | Standard Plus | 50 |
| 42 | 50-59 | 70 | 245 | Standard | 90 |
| 43 | 60-69 | 70 | 189 | Preferred Plus | 0 |
| 44 | 60-69 | 70 | 206 | Preferred | 25 |
| 45 | 60-69 | 70 | 226 | Standard Plus | 50 |
| 46 | 60-69 | 70 | 249 | Standard | 100 |

### 4.2 Blood Pressure Classification Table

| **F** | Systolic | Diastolic | -> BP Class | -> Risk Ceiling | -> Debits |
|-------|----------|-----------|------------|----------------|----------|
| 1 | < 120 | < 80 | Optimal | Preferred Plus | 0 |
| 2 | 120-129 | < 80 | Elevated | Preferred | 15 |
| 3 | 120-129 | 80-84 | Normal-High | Preferred | 25 |
| 4 | 130-134 | 80-84 | High-Normal | Standard Plus | 40 |
| 5 | 130-139 | 85-89 | High-Normal | Standard Plus | 50 |
| 6 | 140-144 | 90-94 | Stage 1 HTN Low | Standard | 100 |
| 7 | 145-149 | 90-94 | Stage 1 HTN Mid | Standard | 125 |
| 8 | 150-159 | 95-99 | Stage 1 HTN High | Table B | 150 |
| 9 | 160-169 | 100-104 | Stage 2 HTN Low | Table D | 200 |
| 10 | 170-179 | 105-109 | Stage 2 HTN High | Table F | 250 |
| 11 | >= 180 | >= 110 | Stage 3 / Crisis | Decline | -- |

**BP Adjustments:**

| Condition | Adjustment |
|-----------|------------|
| On BP medication, well-controlled (< 130/85) | Remove 25 debits |
| On 3+ BP medications | Add 50 debits; ceiling = Standard |
| History of hypertensive emergency | Add 100 debits; ceiling = Table D |
| End-organ damage (LVH, retinopathy) | Add 150 debits; ceiling = Table F |
| BP medication + diabetic | Add 75 debits on top of individual ratings |

### 4.3 Cholesterol Assessment Table

| **C+** | Total Chol | HDL | TC/HDL Ratio | LDL | -> Debits | -> Ceiling |
|--------|-----------|-----|-------------|-----|----------|-----------|
| 1 | < 200 | >= 60 | < 3.5 | < 100 | Credit +20 | Pref Plus |
| 2 | < 200 | 50-59 | 3.5-4.5 | < 130 | 0 | Preferred |
| 3 | 200-219 | 40-49 | 4.5-5.5 | 130-159 | 25 | Std Plus |
| 4 | 220-239 | 35-39 | 5.5-6.5 | 160-189 | 75 | Standard |
| 5 | 240-259 | 30-34 | 6.5-7.5 | 190-219 | 125 | Table B |
| 6 | 260-279 | < 30 | > 7.5 | > 220 | 200 | Table D |
| 7 | >= 280 | -- | -- | -- | -- | Decline |

### 4.4 Diabetes Rating Table (HbA1c x Complications)

| **P** | DM Type | HbA1c | Complications | Duration | Insulin | -> Rating | -> Debits |
|-------|---------|-------|---------------|----------|---------|----------|----------|
| 1 | Type 2 | <= 6.5 | None | Any | No | Standard | 75 |
| 2 | Type 2 | <= 6.5 | None | Any | Yes | Std Plus deb | 100 |
| 3 | Type 2 | 6.6-7.0 | None | < 10yr | No | Table B | 125 |
| 4 | Type 2 | 6.6-7.0 | None | < 10yr | Yes | Table B | 150 |
| 5 | Type 2 | 6.6-7.0 | Microalbumin | Any | Any | Table D | 200 |
| 6 | Type 2 | 7.1-8.0 | None | < 5yr | No | Table D | 200 |
| 7 | Type 2 | 7.1-8.0 | None | < 5yr | Yes | Table F | 250 |
| 8 | Type 2 | 7.1-8.0 | Retinopathy | Any | Any | Table H | 325 |
| 9 | Type 2 | 7.1-8.0 | Neuropathy | Any | Any | Table H | 325 |
| 10 | Type 2 | 8.1-9.0 | None | Any | Any | Table H | 325 |
| 11 | Type 2 | 8.1-9.0 | Any | Any | Any | Decline | -- |
| 12 | Type 2 | > 9.0 | -- | -- | -- | Decline | -- |
| 13 | Type 1 | <= 7.0 | None | > 5yr | Yes | Table D | 200 |
| 14 | Type 1 | 7.1-8.0 | None | > 5yr | Yes | Table F | 275 |
| 15 | Type 1 | 7.1-8.0 | Microalbumin | Any | Yes | Table H | 350 |
| 16 | Type 1 | 8.1-9.0 | None | Any | Yes | Table H | 350 |
| 17 | Type 1 | > 9.0 | -- | -- | -- | Decline | -- |
| 18 | Any | Any | Dialysis | Any | Any | Decline | -- |
| 19 | Any | Any | Amputation | Any | Any | Decline | -- |
| 20 | Any | Any | Gastroparesis | Any | Any | Decline | -- |

### 4.5 Family History Assessment Table

| **C+** | Relationship | Condition | Age at Dx/Death | -> Debits | -> Ceiling Impact |
|--------|-------------|-----------|-----------------|----------|-----------------|
| 1 | Parent | Heart disease death | < 60 | 75 | Max: Standard Plus |
| 2 | Parent | Heart disease death | 60-65 | 50 | Max: Preferred |
| 3 | Parent | Heart disease death | > 65 | 25 | No ceiling impact |
| 4 | Sibling | Heart disease death | < 60 | 50 | Max: Standard Plus |
| 5 | Parent | Stroke death | < 60 | 50 | Max: Standard Plus |
| 6 | Parent | Cancer death | < 60 | 50 | Max: Standard Plus |
| 7 | Parent | Cancer death | 60-65 | 25 | Max: Preferred |
| 8 | Parent | Cancer death | > 65 | 0 | No impact |
| 9 | Parent | Diabetes Type 1 | < 50 | 25 | Max: Preferred |
| 10 | 2+ Parents | Any CV death | < 60 | 125 | Max: Standard |
| 11 | Parent | Hereditary cancer | Any | 75 | Max: Standard; refer |
| 12 | No adverse FH | -- | -- | Credit: -25 | Eligible: Pref Plus |

### 4.6 Financial Justification Table

| **F** | Age Band | Purpose | Income/Asset | -> Max Multiple |
|-------|----------|---------|-------------|---------------|
| 1 | 18-30 | Personal/Family | Earned income | 30x |
| 2 | 31-40 | Personal/Family | Earned income | 25x |
| 3 | 41-50 | Personal/Family | Earned income | 20x |
| 4 | 51-60 | Personal/Family | Earned income | 15x |
| 5 | 61-65 | Personal/Family | Earned income | 10x |
| 6 | 66-70 | Personal/Family | Earned income | 8x |
| 7 | 71+ | Personal/Family | Earned income | 5x |
| 8 | Any | Estate planning | Net worth | 1x |
| 9 | Any | Key person | Revenue contribution | 10x |
| 10 | Any | Buy-sell | Business value | % ownership |
| 11 | Any | Loan protection | Loan balance | 1x |
| 12 | Any | Alimony/support | Annual obligation | Remaining years |
| 13 | Any | Mortgage | Mortgage balance | 1x |
| 14 | 18-25 | Student/entry | -- | Max $500K presumptive |

---

## 5. Implementing the Debit/Credit System

### 5.1 System Architecture

```
+------------------------------------------------------------+
|                  DEBIT/CREDIT SYSTEM                        |
|                                                             |
|  +--------------------------------------------------+      |
|  |  Debit/Credit Accumulator                         |      |
|  |                                                   |      |
|  |  Category         | Debits  | Credits | Net       |      |
|  |  -----------------+---------+---------+---------- |      |
|  |  Build/BMI        |  D_bmi  |   0     | D_bmi     |      |
|  |  Blood Pressure   |  D_bp   |  C_bp   | net_bp    |      |
|  |  Cholesterol      |  D_chol |  C_chol | net_chol  |      |
|  |  Labs (other)     |  D_lab  |   0     | D_lab     |      |
|  |  Medical History  |  D_med  |   0     | D_med     |      |
|  |  Rx Profile       |  D_rx   |   0     | D_rx      |      |
|  |  Family History   |  D_fh   |  C_fh   | net_fh    |      |
|  |  Driving Record   |  D_mvr  |  C_mvr  | net_mvr   |      |
|  |  Lifestyle        |  D_life |   0     | D_life    |      |
|  |  Tobacco          |  D_tob  |   0     | D_tob     |      |
|  |  -----------------+---------+---------+---------- |      |
|  |  TOTALS           | Sum_D   | Sum_C   | Net       |      |
|  +--------------------------------------------------+      |
|                           |                                 |
|                           v                                 |
|  +--------------------------------------------------+      |
|  |  Score-to-Class Mapping                           |      |
|  |  >= 101  -> Preferred Plus                        |      |
|  |  81-100  -> Preferred                             |      |
|  |  51-80   -> Standard Plus                         |      |
|  |  1-50    -> Standard                              |      |
|  |  -24 to 0 -> Table B                              |      |
|  |  -49 to -25 -> Table D                            |      |
|  |  -74 to -50 -> Table F                            |      |
|  |  -99 to -75 -> Table H                            |      |
|  |  <= -150 -> Decline                               |      |
|  +--------------------------------------------------+      |
|                           |                                 |
|  Final = min(Score-Based Class, Rule Ceiling)               |
+-------------------------------------------------------------+
```

### 5.2 Worked Examples — Five Applicant Scenarios

#### Scenario 1: Healthy 35-Year-Old — Preferred Plus

```
Applicant: Male, Age 35, Non-Smoker, 5'10" (70"), 175 lbs
           No medical history, no medications, clean MVR, clean family history
           Income: $150K, Applied: $1M Term-20

DEBITS: Build BMI 25.1 (0), BP 118/76 (0), Labs normal (0) = 0 total

CREDITS: Optimal BP +10, Excellent lipid ratio +20, Clean FH +25,
         Clean MVR +10, Non-smoker +50 = +115 total

NET SCORE: +115
Ceiling: Preferred Plus (no ceiling rules fired)
FINAL: PREFERRED PLUS NON-TOBACCO
```

#### Scenario 2: 45-Year-Old with Controlled HTN — Standard

```
Applicant: Male, Age 45, Non-Smoker, 5'9" (69"), 205 lbs
           Hypertension (on lisinopril), father MI age 58
           Income: $120K, Applied: $750K Term-20

DEBITS: Build BMI 30.3 (15), BP 132/84 on med (10), Cholesterol borderline (10),
        Glucose 105 (5), Family hx father MI<60 (30), MVR 1 ticket (5) = 75 total

CREDITS: Non-smoker +50, Other clean labs +5 = +55 total

NET SCORE: 55 - 75 = -20
Ceilings: Standard Plus (build), Standard Plus (family hx)
Score maps to: Standard (net -20)
FINAL: STANDARD NON-TOBACCO
```

#### Scenario 3: 52-Year-Old Diabetic — Table Rated

```
Applicant: Female, Age 52, Non-Smoker, 5'5" (65"), 190 lbs
           Type 2 DM (HbA1c 7.2, retinopathy), HTN on 2 meds
           Income: $85K, Applied: $500K Term-20

Key: DM Decision Table -> T2DM + HbA1c 7.1-8.0 + retinopathy = Table H (325 debits)
     This table rating overrides the net score calculation.

FINAL: TABLE H (+200%) NON-TOBACCO
```

#### Scenario 4: 28-Year-Old Smoker with Depression — Standard Tobacco

```
Applicant: Male, Age 28, Smoker, 6'0" (72"), 170 lbs
           Depression (sertraline 50mg, stable 3+ years)
           Income: $65K, Applied: $250K Term-20

DEBITS: Build (0), BP 122/78 (5), Depression mild (25) = 30 total
CREDITS: Clean FH +25, Good lipids +20, Good BMI +10 = +55 total

NET SCORE: +25 -> Standard Tobacco range
Ceiling: Preferred (depression)
FINAL: STANDARD TOBACCO
```

#### Scenario 5: 62-Year-Old Multiple Conditions — Decline

```
Applicant: Male, Age 62, Non-Smoker, 5'8" (68"), 250 lbs
           T2DM (HbA1c 8.5, neuropathy), CAD (2-vessel stented),
           Sleep apnea (AHI 35, CPAP non-compliant), HTN on 3 meds

DM Decision Table: T2DM + HbA1c 8.1-9.0 + complication = DECLINE
Multiple independent decline triggers present.

FINAL: DECLINE
  Primary: Diabetes Type 2 with complications, HbA1c > 8.0
  Secondary: Aggregate risk exceeds maximum insurable threshold
```

---

## 6. Rx-to-Condition Mapping Engine

### 6.1 Architecture

```
+------------------------------------------------------------------+
|              RX-TO-CONDITION MAPPING ENGINE                        |
|                                                                   |
|  +------------+    +-----------------+    +------------------+    |
|  | NDC/Drug   |--->| Therapeutic     |--->| Implied          |    |
|  | Identifier |    | Class Mapper    |    | Condition(s)     |    |
|  +------------+    +-----------------+    +--------+---------+    |
|                                                     |             |
|                                           +------------------+    |
|                                           | UW Action        |    |
|                                           | - Debits/Ceiling |    |
|                                           | - Evidence req   |    |
|                                           | - Refer/Flag     |    |
|                                           +------------------+    |
+-------------------------------------------------------------------+
```

### 6.2 Drug Mapping Database (50+ Medications)

| # | Drug | Therapeutic Class | Implied Condition | Debits | Ceiling |
|---|------|-------------------|-------------------|--------|---------|
| 1 | Lisinopril | ACE Inhibitor | Hypertension | 25 | Std Plus |
| 2 | Losartan | ARB | Hypertension | 25 | Std Plus |
| 3 | Amlodipine | CCB | Hypertension | 25 | Std Plus |
| 4 | Metoprolol | Beta Blocker | HTN / cardiac | 30 | Std Plus |
| 5 | Atenolol | Beta Blocker | Hypertension | 25 | Std Plus |
| 6 | Carvedilol | Alpha/Beta Blocker | Heart failure | 100 | Table D |
| 7 | Atorvastatin | Statin | Hyperlipidemia | 15 | Preferred |
| 8 | Rosuvastatin | Statin | Hyperlipidemia | 15 | Preferred |
| 9 | Simvastatin | Statin | Hyperlipidemia | 15 | Preferred |
| 10 | Clopidogrel | Antiplatelet | CAD | 75 | Table B |
| 11 | Warfarin | Anticoagulant | AFib / DVT | 75 | Table B |
| 12 | Apixaban | DOAC | AFib / DVT | 60 | Table B |
| 13 | Rivaroxaban | DOAC | AFib / PE | 60 | Table B |
| 14 | Digoxin | Cardiac Glycoside | Heart failure | 100 | Table D |
| 15 | Nitroglycerin | Nitrate | Angina | 100 | Table D |
| 16 | Furosemide | Loop Diuretic | Heart failure | 75 | Table B |
| 17 | Spironolactone | Aldosterone Antag | HF / cirrhosis | 50 | Standard |
| 18 | Metformin | Biguanide | Type 2 DM | 50 | Standard |
| 19 | Glipizide | Sulfonylurea | Type 2 DM | 75 | Table B |
| 20 | Glimepiride | Sulfonylurea | Type 2 DM | 75 | Table B |
| 21 | Sitagliptin | DPP-4 Inhibitor | Type 2 DM | 60 | Table B |
| 22 | Empagliflozin | SGLT2 Inhibitor | Type 2 DM / HF | 60 | Table B |
| 23 | Semaglutide | GLP-1 Agonist | Type 2 DM / obesity | 60 | Table B |
| 24 | Liraglutide | GLP-1 Agonist | Type 2 DM | 60 | Table B |
| 25 | Insulin Glargine | Long-Acting Insulin | DM insulin-dep | 100 | Table D |
| 26 | Insulin Lispro | Rapid-Acting Insulin | DM insulin-dep | 100 | Table D |
| 27 | Sertraline | SSRI | Depression | 25 | Preferred |
| 28 | Escitalopram | SSRI | Depression | 25 | Preferred |
| 29 | Fluoxetine | SSRI | Depression | 25 | Preferred |
| 30 | Venlafaxine | SNRI | Depression | 30 | Std Plus |
| 31 | Duloxetine | SNRI | Depression / pain | 30 | Std Plus |
| 32 | Bupropion | NDRI | Depression / cessation | 20 | Preferred |
| 33 | Quetiapine | Atypical Antipsychotic | Bipolar / insomnia | 75 | Standard |
| 34 | Lithium | Mood Stabilizer | Bipolar | 100 | Table B |
| 35 | Lamotrigine | Anticonvulsant | Bipolar / epilepsy | 50 | Standard |
| 36 | Clonazepam | Benzodiazepine | Anxiety | 50 | Standard |
| 37 | Alprazolam | Benzodiazepine | Anxiety / panic | 50 | Standard |
| 38 | Gabapentin | Anticonvulsant | Neuropathic pain | 25 | Std Plus |
| 39 | Pregabalin | Anticonvulsant | Neuropathic pain | 30 | Std Plus |
| 40 | Sumatriptan | Triptan | Migraine | 15 | Preferred |
| 41 | Topiramate | Anticonvulsant | Epilepsy / migraine | 40 | Standard |
| 42 | Albuterol | SABA | Asthma | 10 | Preferred |
| 43 | Fluticasone/Salmeterol | ICS/LABA | Asthma moderate | 30 | Std Plus |
| 44 | Tiotropium | LAMA | COPD | 75 | Table B |
| 45 | Montelukast | Leukotriene Mod | Asthma / allergy | 10 | Preferred |
| 46 | Oxycodone | Opioid | Chronic pain | 100 | Table D |
| 47 | Hydrocodone | Opioid | Chronic pain | 75 | Table B |
| 48 | Tramadol | Weak Opioid | Chronic pain | 40 | Standard |
| 49 | Buprenorphine | Opioid MAT | Opioid use disorder | 150 | Table H |
| 50 | Naltrexone | Opioid Antagonist | Substance use | 125 | Table F |
| 51 | Levothyroxine | Thyroid Replacement | Hypothyroidism | 0 | Pref Plus |
| 52 | Omeprazole | PPI | GERD | 0 | Pref Plus |
| 53 | Allopurinol | XO Inhibitor | Gout | 15 | Preferred |
| 54 | Tamoxifen | SERM | Breast cancer adj | 150 | Table F |
| 55 | Finasteride | 5-ARI | BPH / hair loss | 0 | Pref Plus |

---

## 7. Lab Value Interpretation Engine

### 7.1 Complete Lab Threshold Reference Table

| Lab Test | Unit | Pref Plus | Preferred | Std Plus | Standard | Table B | Table D | Decline |
|----------|------|-----------|-----------|----------|----------|---------|---------|---------|
| Total Cholesterol | mg/dL | <= 199 | 200-219 | 220-239 | 240-259 | 260-279 | 280-299 | >= 300 |
| HDL (Male) | mg/dL | >= 60 | 50-59 | 40-49 | 35-39 | 30-34 | -- | < 30 |
| HDL (Female) | mg/dL | >= 70 | 55-69 | 45-54 | 40-44 | 35-39 | -- | < 35 |
| LDL | mg/dL | <= 99 | 100-129 | 130-159 | 160-189 | 190-219 | -- | >= 220 |
| TC/HDL Ratio | ratio | <= 3.5 | 3.6-4.5 | 4.6-5.5 | 5.6-6.5 | 6.6-7.5 | > 7.5 | -- |
| Triglycerides | mg/dL | <= 149 | 150-199 | -- | 200-299 | 300-499 | -- | >= 500 |
| Fasting Glucose | mg/dL | <= 99 | 100-109 | 110-125 | 126-150 | -- | 151-200 | > 200 |
| HbA1c | % | <= 5.6 | 5.7-5.9 | 6.0-6.4 | 6.5-7.0 | -- | 7.1-8.0 | > 10.0 |
| Creatinine (M) | mg/dL | <= 1.2 | 1.3-1.4 | -- | 1.5-1.7 | -- | 1.8-2.0 | > 2.0 |
| Creatinine (F) | mg/dL | <= 1.0 | 1.1-1.2 | -- | 1.3-1.5 | -- | 1.6-1.8 | > 1.8 |
| GGT | U/L | <= 45 | 46-75 | -- | 76-150 | -- | 151-300 | > 500 |
| ALT (SGPT) | U/L | <= 40 | 41-60 | -- | 61-100 | -- | 101-200 | > 200 |
| AST (SGOT) | U/L | <= 35 | 36-55 | -- | 56-90 | -- | 91-180 | > 180 |
| Alk Phos | U/L | <= 120 | 121-180 | -- | 181-250 | -- | 251-400 | > 400 |
| Total Bilirubin | mg/dL | <= 1.2 | 1.3-2.0 | -- | 2.1-3.0 | -- | 3.1-5.0 | > 5.0 |
| Albumin | g/dL | >= 4.0 | 3.5-3.9 | -- | 3.0-3.4 | -- | 2.5-2.9 | < 2.5 |
| BUN | mg/dL | <= 20 | 21-25 | -- | 26-35 | -- | 36-50 | > 50 |
| Uric Acid (M) | mg/dL | <= 7.0 | -- | -- | 7.1-8.5 | 8.6-10 | > 10 | -- |
| Hemoglobin (M) | g/dL | 14-17.5 | 13-18 | -- | 12-19 | -- | 10-20 | <10/>20 |
| Hemoglobin (F) | g/dL | 12-15.5 | 11-16 | -- | 10-17 | -- | 8-18 | <8/>18 |
| PSA (age<50) | ng/mL | <= 2.5 | -- | -- | -- | -- | 2.6-4 | > 4.0 |
| PSA (age 50-59) | ng/mL | <= 3.5 | -- | -- | -- | -- | 3.6-5 | > 5.0 |
| Cotinine | ng/mL | <= 10 | -- | -- | -- | -- | -- | >10=Tobacco |
| HIV | qual | Negative | -- | -- | -- | -- | -- | Positive |
| Hep C Ab | qual | Negative | -- | -- | -- | -- | -- | Positive |
| Cocaine met | ng/mL | <= 150 | -- | -- | -- | -- | -- | >150=Decline |

### 7.2 Multi-Variate Lab Interaction Rules

```python
class LabInteractionChecker:
    def check_interactions(self, labs):
        interactions = []

        alt = labs.get("alt_sgpt", {}).get("value", 0)
        ast = labs.get("ast_sgot", {}).get("value", 0)
        ggt = labs.get("ggt", {}).get("value", 0)
        if alt > 60 and ast > 55 and ggt > 100:
            interactions.append({
                "type": "LIVER_PANEL_PATTERN",
                "desc": "ALT + AST + GGT all elevated",
                "action": "REFER", "extra_debits": 100,
            })

        glucose = labs.get("fasting_glucose", {}).get("value", 0)
        hba1c = labs.get("hba1c", {}).get("value", 0)
        if glucose > 125 and hba1c > 6.4:
            interactions.append({
                "type": "DIABETES_CONFIRMATION",
                "desc": "Both glucose and HbA1c in diabetic range",
                "action": "APPLY_DM_RATING",
            })

        tc = labs.get("total_cholesterol", {}).get("value", 0)
        tg = labs.get("triglycerides", {}).get("value", 0)
        hdl = labs.get("hdl_cholesterol", {}).get("value", 0)
        if tc > 240 and tg > 300 and hdl < 35:
            interactions.append({
                "type": "METABOLIC_SYNDROME",
                "desc": "Dyslipidemia pattern",
                "action": "ADD_DEBITS", "extra_debits": 50,
            })

        creatinine = labs.get("creatinine", {}).get("value", 0)
        bun = labs.get("bun", {}).get("value", 0)
        if creatinine > 1.5 and bun > 30:
            interactions.append({
                "type": "RENAL_IMPAIRMENT",
                "desc": "BUN + Creatinine elevated",
                "action": "REFER", "extra_debits": 75,
            })

        if ast > 0 and alt > 0 and ast / max(alt, 1) > 2.0:
            interactions.append({
                "type": "AST_ALT_RATIO",
                "desc": "Ratio > 2.0 -- possible alcoholic liver disease",
                "action": "REFER", "extra_debits": 75,
            })

        return interactions
```

---

## 8. Rule Versioning & Governance

### 8.1 Version Control Architecture

```
Git Repository (source of truth)
+-- rules/
|   +-- eligibility/     (age-limits.drl v2.3, state-product.drl v1.8)
|   +-- knockout/         (medical-ko.drl v4.2, lifestyle-ko.drl v2.0)
|   +-- medical/          (cardiac.drl v5.1, diabetes.drl v3.4)
|   +-- decision-tables/  (build-chart.xlsx v6.0, bp-class.dmn v3.0)
|   +-- scoring/          (debit-credit-map.drl v2.1, class-mapping.drl v1.3)
+-- tests/                (unit/, integration/, regression/)
+-- config/               (rule-metadata.yaml, deployment-config.yaml)
```

### 8.2 Rule Metadata Schema

```yaml
rules:
  - id: "MED-DM-001"
    name: "Type 2 DM controlled, no complications"
    version: "3.4.0"
    effective_date: "2025-06-01"
    author: "jane.smith@carrier.com"
    reviewer: "chief.uw@carrier.com"
    reinsurer_alignment: ["Swiss Re", "Munich Re"]
    change_history:
      - version: "3.4.0"
        change: "Revised HbA1c threshold from 7.5 to 7.0 for Table B"
        reason: "Swiss Re guideline update Q2-2025"
        impact: "~2% of diabetic applicants affected"
    dependencies: ["LAB-HBA1C-001", "LAB-GLUCOSE-001"]
```

### 8.3 Promotion Pipeline

```
DEV -> QA -> STAGING -> CANARY (5%) -> PROD (100%)

Gates:
  DEV->QA:      Peer review + actuarial sign-off
  QA->STAGING:  100% unit + integration tests pass
  STAGING->CANARY: Zero regression failures + perf benchmarks met
  CANARY->PROD:    No anomalies in 48 hours of 5% traffic
```

### 8.4 Rollback Strategy

```python
class RuleRollbackManager:
    def rollback(self, rule_group, target_version, reason):
        current = self.kie.get_active_version(rule_group)
        self.repo.tag(rule_group, current, f"rollback-from-{current}")
        artifact = self.repo.get_artifact(rule_group, target_version)
        self.kie.deploy_container(f"{rule_group}-{target_version}", artifact, replace=True)
        self.kie.verify_deployment(rule_group, target_version)
        self._notify_stakeholders(rule_group, current, target_version, reason)

    def auto_rollback_on_anomaly(self, rule_group, metrics):
        thresholds = {
            "decline_rate_change": 0.05, "approval_rate_change": 0.10,
            "avg_processing_time_increase": 2.0, "error_rate": 0.001,
        }
        for metric, max_delta in thresholds.items():
            if abs(metrics.get(metric, 0)) > max_delta:
                previous = self.repo.get_previous_version(rule_group)
                self.rollback(rule_group, previous,
                    f"Auto-rollback: {metric} exceeded threshold")
                return True
        return False
```

---

## 9. Rule Testing Strategy

### 9.1 Testing Pyramid

```
                /\            E2E Scenarios (10)
               /  \           Full applicant profiles through entire engine
              /----\
             /      \         Integration Tests (50)
            /        \        Rule groups interacting (Rx -> Medical -> Score)
           /----------\
          /            \      Unit Tests (500+)
         /              \     Individual rule verification + boundary values
        /----------------\
       /                  \   Decision Table Tests (2000+)
      /                    \  Every row in every decision table validated
     /----------------------\
```

### 9.2 Boundary Value Tests

```python
BOUNDARY_TESTS = [
    {"test": "BP", "systolic": 119, "diastolic": 79, "expected": "OPTIMAL"},
    {"test": "BP", "systolic": 120, "diastolic": 79, "expected": "ELEVATED"},
    {"test": "BP", "systolic": 139, "diastolic": 89, "expected": "HIGH_NORMAL"},
    {"test": "BP", "systolic": 140, "diastolic": 90, "expected": "STAGE1_HTN"},
    {"test": "BP", "systolic": 180, "diastolic": 110, "expected": "STAGE3_HTN"},
    {"test": "AGE", "age": 17, "expected": "DECLINE"},
    {"test": "AGE", "age": 18, "expected": "ELIGIBLE"},
    {"test": "BMI", "bmi": 25.4, "age": 35, "gender": "M", "expected": "PREF_PLUS"},
    {"test": "BMI", "bmi": 25.5, "age": 35, "gender": "M", "expected": "PREFERRED"},
    {"test": "HBA1C", "value": 5.6, "expected": "PREF_PLUS"},
    {"test": "HBA1C", "value": 5.7, "expected": "PREFERRED"},
    {"test": "HBA1C", "value": 6.5, "expected": "STANDARD"},
    {"test": "HBA1C", "value": 7.1, "expected": "TABLE_D"},
]
```

### 9.3 Regression Suite

```python
class RuleRegressionSuite:
    def __init__(self, engine, golden_dataset_path):
        self.engine = engine
        self.golden = self._load(golden_dataset_path)

    def run(self):
        results = {"total": len(self.golden), "passed": 0, "failed": 0, "failures": []}
        for case in self.golden:
            decision = self.engine.execute(self._build_context(case["input"]))
            if decision["final_class"] == case["expected"]["risk_class"]:
                results["passed"] += 1
            else:
                results["failed"] += 1
                results["failures"].append({
                    "case_id": case["id"],
                    "expected": case["expected"]["risk_class"],
                    "actual": decision["final_class"],
                })
        results["pass_rate"] = results["passed"] / max(results["total"], 1)
        return results
```

### 9.4 Unit Testing with JUnit + Drools

```java
public class BloodPressureRulesTest {
    private KieSession kieSession;

    @Before
    public void setUp() {
        KieServices ks = KieServices.Factory.get();
        kieSession = ks.getKieClasspathContainer().newKieSession("bp-rules-session");
    }

    @Test
    public void testOptimalBP() {
        BloodPressure bp = new BloodPressure("APP-001", 115, 75);
        kieSession.insert(bp);
        kieSession.fireAllRules();
        assertEquals("OPTIMAL", bp.getClassification());
    }

    @Test
    public void testBoundary_139_89_IsHighNormal() {
        BloodPressure bp = new BloodPressure("APP-004", 139, 89);
        kieSession.insert(bp);
        kieSession.fireAllRules();
        assertEquals("HIGH_NORMAL", bp.getClassification());
    }

    @Test
    public void testBoundary_140_90_IsStage1() {
        BloodPressure bp = new BloodPressure("APP-005", 140, 90);
        kieSession.insert(bp);
        kieSession.fireAllRules();
        assertEquals("STAGE1_HTN", bp.getClassification());
    }

    @Test
    public void testDeclineThreshold() {
        BloodPressure bp = new BloodPressure("APP-007", 185, 115);
        kieSession.insert(bp);
        kieSession.fireAllRules();
        assertEquals("STAGE3_HTN", bp.getClassification());
        assertFalse(getFactsOfType(kieSession, DeclineAction.class).isEmpty());
    }

    @After
    public void tearDown() { kieSession.dispose(); }
}
```

---

## 10. Performance Optimization

### 10.1 Rule Compilation

```java
public class RuleEngineFactory {
    private static volatile KieBase kieBase;

    public static KieBase getKieBase() {
        if (kieBase == null) {
            synchronized (RuleEngineFactory.class) {
                if (kieBase == null) {
                    KieServices ks = KieServices.Factory.get();
                    KieFileSystem kfs = ks.newKieFileSystem();
                    kfs.write("src/main/resources/rules/eligibility.drl",
                        ks.getResources().newClassPathResource("rules/eligibility.drl"));
                    kfs.write("src/main/resources/rules/knockout.drl",
                        ks.getResources().newClassPathResource("rules/knockout.drl"));
                    kfs.write("src/main/resources/rules/medical.drl",
                        ks.getResources().newClassPathResource("rules/medical.drl"));
                    KieBuilder kb = ks.newKieBuilder(kfs).buildAll();
                    kieBase = ks.newKieContainer(kb.getKieModule().getReleaseId()).getKieBase();
                }
            }
        }
        return kieBase;
    }
}
```

### 10.2 Stateless vs Stateful Sessions

| Aspect | Stateless | Stateful |
|--------|-----------|----------|
| Thread safety | One session per request | One per applicant (not shared) |
| Memory leaks | No risk | Must dispose properly |
| Incremental facts | No — all facts upfront | Yes — add facts over time |
| Rete maintenance | Rebuilt each time | Maintained across insertions |
| Best for | Synchronous decisions | Multi-stage async UW |
| Lifecycle | Simple | Complex (pool or per-request) |

**Recommendation**: Stateless for API-driven instant decisions; stateful for multi-stage underwriting where data arrives incrementally.

### 10.3 Caching Strategy

```python
class RuleEngineCache:
    def __init__(self, redis_client):
        self.redis = redis_client
        self.TTL = 3600

    def get_or_compute(self, data, version, compute_fn):
        key = self._key(data, version)
        cached = self.redis.get(key)
        if cached:
            return json.loads(cached)
        result = compute_fn(data)
        self.redis.setex(key, self.TTL, json.dumps(result))
        return result

    def _key(self, data, version):
        fields = {
            "age": data.get("age"), "gender": data.get("gender"),
            "height": data.get("height_inches"), "weight": data.get("weight_lbs"),
            "bp": data.get("bp"), "labs": data.get("lab_results"),
            "conditions": sorted([c["icd"] for c in data.get("conditions", [])]),
            "meds": sorted([m["drug_name"] for m in data.get("medications", [])]),
            "smoker": data.get("smoker"), "face": data.get("face_amount"),
        }
        h = hashlib.sha256(json.dumps(fields, sort_keys=True).encode()).hexdigest()[:16]
        return f"uw:decision:{version}:{h}"
```

### 10.4 Performance Benchmarks

| Scenario | Rules | Facts | Engine | Avg Latency | P99 Latency | Throughput |
|----------|-------|-------|--------|-------------|-------------|------------|
| Eligibility only | 50 | 5 | Drools | 2ms | 8ms | 15,000/sec |
| Full UW healthy | 2,000 | 25 | Drools | 15ms | 45ms | 3,000/sec |
| Full UW complex | 2,000 | 80 | Drools | 35ms | 120ms | 1,200/sec |
| Full UW healthy | 500 | 25 | Python | 25ms | 80ms | 2,000/sec |
| Full UW complex | 500 | 80 | Python | 60ms | 200ms | 800/sec |
| DMN tables only | 200 rows | 10 | Camunda | 5ms | 15ms | 10,000/sec |
| Batch (1000 apps) | 2,000 | 25K | Drools | 8s total | -- | 125/sec |

### 10.5 Optimization Techniques

1. **Rule ordering by selectivity** — Place most selective rules first; use salience for eligibility -> knockout -> evidence -> medical -> scoring order
2. **Fact type indexing** — Use `@key` on frequently joined fields (applicantId); ensure alpha network indexing
3. **Activation groups** — Mutually exclusive rules (BP classification) in same group; only one fires
4. **Agenda group sequencing** — Phase rules: eligibility -> knockout -> derive -> rate -> score
5. **Decision table compression** — Convert 500 DRL rules to 1 spreadsheet = 10x faster compilation
6. **Lazy derived facts** — Don't compute BMI/ratios until rules need them; use `@watch` annotations
7. **Connection pooling** — Pool NDC lookups, MIB queries; cache external results per session
8. **JVM tuning** — `-Xmx2g -Xms2g`, G1GC with 50ms pause target, tiered compilation

### 10.6 Monitoring Metrics

```yaml
metrics:
  - name: uw_decision_duration_seconds
    type: histogram
    buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0]
    labels: [product, risk_class, decision_path]
  - name: uw_rules_fired_total
    type: counter
    labels: [category, rule_id]
  - name: uw_decision_outcome_total
    type: counter
    labels: [risk_class, tobacco_class, referred]
  - name: uw_knockout_triggers_total
    type: counter
    labels: [rule_id, action]
  - name: uw_cache_hit_ratio
    type: gauge
  - name: uw_rule_errors_total
    type: counter
    labels: [rule_id, error_type]
  - name: uw_accel_eligible_ratio
    type: gauge
```

---

## Appendix A: Glossary

| Term | Definition |
|------|-----------|
| **APS** | Attending Physician Statement — medical records from doctor |
| **BMI** | Body Mass Index — weight(kg) / height(m)^2 |
| **DMN** | Decision Model and Notation — OMG standard for decision tables |
| **DRL** | Drools Rule Language |
| **FEEL** | Friendly Enough Expression Language — DMN expression language |
| **KIE** | Knowledge Is Everything — Drools project umbrella |
| **LHS/RHS** | Left/Right-Hand Side — rule condition/action |
| **MIB** | Medical Information Bureau — inter-carrier data exchange |
| **MVR** | Motor Vehicle Report — driving history |
| **NDC** | National Drug Code — unique drug identifier |
| **Rete** | Algorithm for efficient pattern matching in production rule systems |
| **SIU** | Special Investigations Unit — fraud investigation |
| **STOLI** | Stranger-Originated Life Insurance — fraudulent ownership pattern |
| **Table Rating** | Extra mortality charge (Table A=+25%, Table B=+50%, etc.) |

## Appendix B: Table Rating Equivalents

| Table | Extra Mortality | % of Standard | Typical Conditions |
|-------|----------------|---------------|-------------------|
| Table A (1) | +25% | 125% | Mild asthma, treated anxiety |
| Table B (2) | +50% | 150% | Controlled HTN, mild OSA on CPAP |
| Table D (4) | +100% | 200% | Type 2 DM controlled, single-vessel CAD |
| Table F (6) | +150% | 250% | Type 1 DM, moderate COPD |
| Table H (8) | +200% | 300% | Multi-vessel CAD, uncontrolled DM |
| Table J (10) | +250% | 350% | Severe impairments, borderline insurable |
| Table L (12) | +300% | 400% | Multiple severe impairments |
| Table P (16) | +400% | 500% | Maximum table rating before decline |

---

> **Next in Series**: [08 — Integrations & Vendor Ecosystem](./08_INTEGRATIONS_VENDOR_ECOSYSTEM.md)
> **Previous**: [06 — Risk Classification & Rating](./06_RISK_CLASSIFICATION_RATING.md)
