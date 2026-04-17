# Underwriting Rules Engine — Architecture, Decision Tables & Implementation

> An exhaustive solutions architect's guide to designing, building, and operating a production-grade rules engine for term life insurance automated underwriting. Covers architecture patterns, technology selection, hundreds of real rule examples, decision table design, governance, testing, and performance optimization.

---

## Table of Contents

1. [Rules Engine Architecture Patterns](#1-rules-engine-architecture-patterns)
2. [Rules Engine Technology Selection](#2-rules-engine-technology-selection)
3. [Rule Categories for Life Underwriting](#3-rule-categories-for-life-underwriting)
4. [Decision Table Design](#4-decision-table-design)
5. [Rule Versioning & Governance](#5-rule-versioning--governance)
6. [Rule Conflict Resolution](#6-rule-conflict-resolution)
7. [Rule Testing Strategy](#7-rule-testing-strategy)
8. [Performance Optimization](#8-performance-optimization)
9. [Business User Rule Management](#9-business-user-rule-management)
10. [Implementing the Debit/Credit System in Rules](#10-implementing-the-debitcredit-system-in-rules)
11. [Rx-to-Condition Mapping Engine](#11-rx-to-condition-mapping-engine)
12. [Lab Value Interpretation Engine](#12-lab-value-interpretation-engine)
13. [Related Articles](#13-related-articles)

---

## 1. Rules Engine Architecture Patterns

### 1.1 Why a Rules Engine for Life Underwriting?

Life underwriting is fundamentally a **rule-driven** domain. A single underwriting decision may evaluate 500–2,000 discrete rules spanning medical history, lab results, prescription drugs, financial justification, build charts, and risk aggregation. Hard-coding these rules inside application logic creates an unmaintainable monolith where every rule change requires a code deployment, QA cycle, and regression risk.

A rules engine externalizes business logic from application code, providing:

| Benefit | Description |
|---------|-------------|
| **Separation of concerns** | Business rules live outside application code; developers manage infrastructure, underwriters manage logic |
| **Rapid iteration** | Rule changes deploy in minutes, not weeks |
| **Auditability** | Every rule execution is traceable for regulatory compliance (state DOI, NAIC) |
| **Explainability** | The engine can produce a human-readable explanation of every decision |
| **Consistency** | Identical inputs always produce identical outputs — eliminating inter-underwriter variability |
| **Testability** | Rules can be unit-tested independently of the application |
| **Governance** | Approval workflows, version control, and rollback are first-class features |

### 1.2 Forward Chaining vs. Backward Chaining

#### 1.2.1 Forward Chaining (Data-Driven)

Forward chaining starts with **known facts** and applies rules to derive new facts until a goal is reached or no more rules fire. This is the dominant paradigm for underwriting engines.

```
Algorithm: Forward Chaining

1. INITIALIZE working memory with all known facts
   - applicant_age = 45
   - smoker_status = "never"
   - total_cholesterol = 240
   - systolic_bp = 142
   - face_amount = 500000

2. REPEAT
     FOR each rule R in rule base:
       IF R.conditions are satisfied by working memory:
         FIRE R
         ADD R.conclusions to working memory
         ADD R to fired-rules list
   UNTIL no new facts are derived (quiescence)

3. EXTRACT final decision from working memory
```

**Execution trace example:**

```
Cycle 1:
  FACT: total_cholesterol = 240
  RULE: "If total_cholesterol > 239 then cholesterol_class = BORDERLINE_HIGH"
  → NEW FACT: cholesterol_class = BORDERLINE_HIGH

Cycle 2:
  FACT: cholesterol_class = BORDERLINE_HIGH
  RULE: "If cholesterol_class = BORDERLINE_HIGH then add debit(CHOLESTEROL, +50)"
  → NEW FACT: debit(CHOLESTEROL, +50)

Cycle 3:
  FACT: systolic_bp = 142
  RULE: "If systolic_bp between 140-159 then bp_class = STAGE1_HYPERTENSION"
  → NEW FACT: bp_class = STAGE1_HYPERTENSION

Cycle 4:
  FACT: bp_class = STAGE1_HYPERTENSION
  RULE: "If bp_class = STAGE1_HYPERTENSION then add debit(BP, +75)"
  → NEW FACT: debit(BP, +75)

...quiescence reached after N cycles...

Final: aggregate debits → risk classification
```

**Advantages for underwriting:**
- Natural fit — underwriting starts with applicant data and derives a decision
- All applicable rules fire automatically
- New rules can be added without restructuring the inference chain
- Parallel rule evaluation is straightforward

**Disadvantages:**
- Can fire unnecessary rules (mitigated by Rete optimization)
- Rule ordering can cause unexpected interactions
- Debugging requires trace analysis

#### 1.2.2 Backward Chaining (Goal-Driven)

Backward chaining starts with a **goal** (e.g., "determine risk class") and works backward to find rules that can satisfy the goal, recursively resolving sub-goals.

```
Algorithm: Backward Chaining

1. SET goal = "risk_classification"

2. FIND rules whose THEN clause produces "risk_classification"
   → Rule: "If total_debits < 75 then risk_classification = PREFERRED_PLUS"
   → Rule: "If total_debits >= 75 AND total_debits < 150 then risk_classification = PREFERRED"
   ...

3. FOR each candidate rule:
     FOR each condition in rule:
       IF condition fact is unknown:
         SET sub-goal = condition fact
         RECURSE to step 2

4. WHEN all conditions resolved, FIRE the matching rule
```

**When backward chaining is useful in underwriting:**
- Targeted queries: "Why was this applicant rated Table 4?"
- Explanation generation (trace backward from decision to triggering facts)
- On-demand evaluation when only a subset of rules is needed

**Disadvantages for underwriting:**
- Does not naturally fire all applicable rules (may miss debits)
- Complex when multiple goals interact
- Less intuitive for underwriting rule authors

#### 1.2.3 Hybrid Approach (Recommended)

Production underwriting engines use **forward chaining for rule execution** and **backward chaining for explanation generation**.

```
┌─────────────────────────────────────────────────┐
│           HYBRID RULES ENGINE                   │
│                                                 │
│  ┌──────────────────┐  ┌─────────────────────┐  │
│  │ FORWARD CHAINING │  │ BACKWARD CHAINING   │  │
│  │                  │  │                     │  │
│  │ Execute all      │  │ Generate            │  │
│  │ applicable rules │  │ explanations        │  │
│  │ Data → Decision  │  │ Decision → Evidence │  │
│  │                  │  │                     │  │
│  │ Primary path     │  │ Audit / Appeals     │  │
│  └──────────────────┘  └─────────────────────┘  │
│                                                 │
│  Shared: Working Memory, Rule Repository        │
└─────────────────────────────────────────────────┘
```

### 1.3 The Rete Algorithm

The **Rete algorithm** (from Latin "rete" = net) is the foundational algorithm for efficient rule matching in production rule systems. It was invented by Charles Forgy at Carnegie Mellon in 1979 and remains the basis for Drools, OPS5, CLIPS, and many modern engines.

#### 1.3.1 The Problem Rete Solves

Naive forward chaining has O(R × F^C) complexity per cycle where R = rules, F = facts, C = average conditions per rule. For an underwriting engine with 2,000 rules, 500 facts, and 3 conditions per rule, that is 2,000 × 500^3 = 250 billion checks per cycle — impossibly slow.

Rete reduces this to near-constant time per cycle by exploiting two key observations:

1. **Temporal redundancy**: Between cycles, most facts do not change. Only re-evaluate rules whose conditions are affected by changed facts.
2. **Structural similarity**: Many rules share common conditions. Evaluate shared conditions once and reuse results.

#### 1.3.2 Rete Network Structure

```
                    ROOT NODE
                       │
            ┌──────────┴──────────┐
            ▼                     ▼
      ┌──────────┐         ┌──────────┐
      │ Type Node│         │ Type Node│
      │ Applicant│         │ LabResult│
      └────┬─────┘         └────┬─────┘
           │                    │
     ┌─────┴─────┐        ┌────┴────┐
     ▼           ▼        ▼         ▼
┌─────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Alpha    │ │Alpha   │ │Alpha   │ │Alpha   │
│age > 40 │ │smoker= │ │chol >  │ │HbA1c > │
│         │ │"never" │ │239     │ │6.4     │
└────┬────┘ └───┬────┘ └───┬────┘ └───┬────┘
     │          │          │          │
     ▼          ▼          ▼          ▼
   Alpha      Alpha      Alpha      Alpha
   Memory     Memory     Memory     Memory
     │          │          │          │
     └────┬─────┘          └────┬─────┘
          ▼                     ▼
     ┌─────────┐          ┌─────────┐
     │  Beta   │          │  Beta   │
     │  Join   │          │  Join   │
     │ Node    │          │ Node    │
     └────┬────┘          └────┬────┘
          │                    │
          ▼                    ▼
     Beta Memory          Beta Memory
          │                    │
          ▼                    ▼
     ┌─────────┐          ┌─────────┐
     │Terminal │          │Terminal │
     │ Node    │          │ Node    │
     │Rule: R1 │          │Rule: R2 │
     └─────────┘          └─────────┘
```

**Node types:**

| Node | Function |
|------|----------|
| **Root** | Entry point; all facts enter here |
| **Type (Object Type)** | Filters by fact type (Applicant, LabResult, MedicalCondition, etc.) |
| **Alpha** | Single-fact condition tests (e.g., age > 40) |
| **Alpha Memory** | Stores facts that passed alpha tests |
| **Beta (Join)** | Multi-fact condition tests (joins across fact types) |
| **Beta Memory** | Stores partial matches (tuples of facts) |
| **Terminal** | Represents a fully matched rule — added to the agenda |

#### 1.3.3 Rete Execution in Underwriting Context

```
Step 1: ASSERT facts into working memory
  assert(Applicant(age=45, gender="M", smokerStatus="never", height=70, weight=195))
  assert(LabResult(type="CHOLESTEROL", value=240, unit="mg/dL"))
  assert(LabResult(type="HBA1C", value=5.8, unit="%"))
  assert(RxHistory(ndc="00006-0072-31", drugName="Lisinopril", daysSupply=90))

Step 2: Each fact propagates through the Rete network
  Applicant fact → Type Node (Applicant) → Alpha nodes (age>40 ✓, smoker="never" ✓)
  LabResult(CHOLESTEROL) → Type Node (LabResult) → Alpha node (chol>239 ✓)
  LabResult(HBA1C) → Type Node (LabResult) → Alpha node (HbA1c>6.4 ✗ — does not pass)

Step 3: Beta joins combine partial matches
  (Applicant age>40, smoker=never) → Beta Join → Beta Memory
  → Terminal Node → Rule R1 fires (non-smoker over 40 preferred eligibility)

Step 4: Agenda populated with matched rules
  Agenda: [R1(salience=100), R47(salience=50), R203(salience=75)]

Step 5: Conflict resolution selects next rule to fire
  Fire R1 (highest salience) → may assert new facts → propagate → repeat
```

#### 1.3.4 Rete Performance Characteristics

| Metric | Naive | Rete | Improvement |
|--------|-------|------|-------------|
| Initial load (2000 rules, 500 facts) | ~250B comparisons | ~50K comparisons | ~5,000,000× |
| Incremental fact change | ~250B comparisons | ~100 comparisons | ~2,500,000,000× |
| Memory usage | O(1) | O(R × F) | Trade-off |
| Rule addition | O(1) | O(depth of network) | Slightly slower |

### 1.4 Production Rule Systems

A production rule system consists of three components:

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRODUCTION RULE SYSTEM                       │
│                                                                 │
│  ┌─────────────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │ WORKING MEMORY  │  │ RULE BASE    │  │ INFERENCE ENGINE  │  │
│  │                 │  │              │  │                   │  │
│  │ Current facts   │  │ IF-THEN      │  │ Match-Resolve-Act │  │
│  │ about the case  │  │ rules        │  │ cycle             │  │
│  │                 │  │              │  │                   │  │
│  │ • Applicant     │  │ • 500-2000   │  │ • Rete algorithm  │  │
│  │ • Lab results   │  │   rules      │  │ • Conflict        │  │
│  │ • Rx history    │  │ • Organized  │  │   resolution      │  │
│  │ • MIB hits      │  │   in rule    │  │ • Agenda mgmt     │  │
│  │ • MVR records   │  │   packages   │  │ • Truth            │  │
│  │ • Build data    │  │              │  │   maintenance     │  │
│  │ • Debits/credits│  │              │  │                   │  │
│  └─────────────────┘  └──────────────┘  └───────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**The Match-Resolve-Act cycle:**

```
REPEAT:
  1. MATCH: Find all rules whose conditions are satisfied (using Rete)
     → Produces the "conflict set" (agenda)

  2. RESOLVE: Select one rule from the conflict set to fire
     → Uses conflict resolution strategy (priority, specificity, recency)

  3. ACT: Execute the selected rule's action
     → May assert/retract/modify facts in working memory
     → May trigger external actions (set risk class, order evidence)

UNTIL: No rules in conflict set OR explicit halt
```

### 1.5 Decision Tables (DMN Standard)

Decision tables provide a **tabular** representation of rules, ideal for business users. The DMN (Decision Model and Notation) standard from OMG provides a formal specification.

#### 1.5.1 DMN Decision Table Structure

```
┌──────────────────────────────────────────────────────────────────┐
│  Decision Table: Build Chart Assessment                          │
│  Hit Policy: UNIQUE (U)                                          │
├──────────┬──────────┬───────────────┬───────────────────────────┤
│  Rule #  │  Gender  │  BMI Range    │  Assessment               │
├──────────┼──────────┼───────────────┼───────────────────────────┤
│  1       │  M       │  < 18.5       │  DECLINE                  │
│  2       │  M       │  18.5 - 25.9  │  PREFERRED_PLUS eligible  │
│  3       │  M       │  26.0 - 29.9  │  PREFERRED eligible       │
│  4       │  M       │  30.0 - 32.9  │  STANDARD                 │
│  5       │  M       │  33.0 - 37.9  │  TABLE_2                  │
│  6       │  M       │  38.0 - 42.9  │  TABLE_4                  │
│  7       │  M       │  >= 43.0      │  DECLINE                  │
│  8       │  F       │  < 17.5       │  DECLINE                  │
│  9       │  F       │  17.5 - 26.9  │  PREFERRED_PLUS eligible  │
│  10      │  F       │  27.0 - 30.9  │  PREFERRED eligible       │
│  11      │  F       │  31.0 - 34.9  │  STANDARD                 │
│  12      │  F       │  35.0 - 39.9  │  TABLE_2                  │
│  13      │  F       │  40.0 - 44.9  │  TABLE_4                  │
│  14      │  F       │  >= 45.0      │  DECLINE                  │
└──────────┴──────────┴───────────────┴───────────────────────────┘
```

#### 1.5.2 DMN Hit Policies

| Hit Policy | Symbol | Description | UW Use Case |
|------------|--------|-------------|-------------|
| **Unique** | U | Exactly one rule matches | Build chart, BP classification |
| **First** | F | First matching rule wins (ordered) | Knockout rules (first decline wins) |
| **Any** | A | Multiple rules may match, all must produce same output | Validation rules |
| **Priority** | P | Multiple match, highest priority output wins | Risk class determination |
| **Collect** | C | All matching rules fire, outputs collected | Debit/credit accumulation |
| **Collect Sum** | C+ | Sum of all matching outputs | Total debit calculation |
| **Collect Min** | C< | Minimum of all matching outputs | Best possible risk class |
| **Collect Max** | C> | Maximum of all matching outputs | Worst risk class cap |
| **Rule Order** | R | All matching, in table order | Ordered evidence requirements |
| **Output Order** | O | All matching, by output priority | Sorted recommendation list |

### 1.6 Decision Trees

Decision trees encode rules as a hierarchical branching structure. They are naturally suited for sequential, exclusionary logic.

```
                        ┌─────────────────┐
                        │ Application     │
                        │ Received        │
                        └────────┬────────┘
                                 │
                        ┌────────▼────────┐
                        │ Age ≤ 70?       │
                        └───┬─────────┬───┘
                          YES         NO
                           │           │
                           │     ┌─────▼─────┐
                           │     │  DECLINE   │
                           │     │ (age limit)│
                           │     └────────────┘
                  ┌────────▼────────┐
                  │ Face Amount     │
                  │ ≤ Fin. Max?     │
                  └───┬─────────┬───┘
                    YES         NO
                     │           │
                     │     ┌─────▼───────────┐
                     │     │ REQUEST          │
                     │     │ FINANCIAL DOCS   │
                     │     └─────────────────┘
            ┌────────▼────────┐
            │ Knockout        │
            │ Conditions?     │
            └───┬─────────┬───┘
              NO          YES
               │           │
               │     ┌─────▼─────┐
               │     │  DECLINE   │
               │     └───────────┘
      ┌────────▼────────┐
      │ Accelerated UW  │
      │ Eligible?       │
      └───┬─────────┬───┘
        YES         NO
         │           │
    ┌────▼────┐  ┌───▼───────┐
    │ ACCEL   │  │ FULL UW   │
    │ PATH    │  │ PATH      │
    └─────────┘  └───────────┘
```

### 1.7 Scoring Models

Scoring models assign numerical values (debits/credits) to risk factors and aggregate them into a final score that maps to a risk classification.

```
Scoring Model Architecture:

┌──────────────────────────────────────────────────────────────┐
│                    SCORING PIPELINE                            │
│                                                                │
│  ┌─────────┐   ┌──────────┐   ┌──────────┐   ┌────────────┐ │
│  │ CATEGORY│   │ CATEGORY │   │ CATEGORY │   │ CATEGORY   │ │
│  │ SCORING │   │ SCORING  │   │ SCORING  │   │ SCORING    │ │
│  │         │   │          │   │          │   │            │ │
│  │ Medical │   │ Build/   │   │ Labs     │   │ Lifestyle/ │ │
│  │ History │   │ Vitals   │   │          │   │ Financial  │ │
│  │         │   │          │   │          │   │            │ │
│  │ +75 pts │   │ +25 pts  │   │ +50 pts  │   │ +0 pts     │ │
│  └────┬────┘   └────┬─────┘   └────┬─────┘   └─────┬──────┘ │
│       │             │              │                │        │
│       └──────┬──────┴──────────────┴────────┬───────┘        │
│              ▼                               │                │
│  ┌───────────────────────┐                  │                │
│  │  CATEGORY CAPS &      │◄─────────────────┘                │
│  │  INTERACTIONS         │                                    │
│  │  (max per category,   │                                    │
│  │   interactions        │                                    │
│  │   between categories) │                                    │
│  └───────────┬───────────┘                                    │
│              ▼                                                │
│  ┌───────────────────────┐                                    │
│  │  AGGREGATE SCORE      │                                    │
│  │  Total: 150 debits    │                                    │
│  └───────────┬───────────┘                                    │
│              ▼                                                │
│  ┌───────────────────────┐                                    │
│  │  RISK CLASS MAPPING   │                                    │
│  │                       │                                    │
│  │  0-75  → Pref Plus    │                                    │
│  │  76-125 → Preferred   │                                    │
│  │  126-175 → Std Plus   │                                    │
│  │  176-250 → Standard   │                                    │
│  │  251-350 → Table 2    │                                    │
│  │  351-500 → Table 4    │                                    │
│  │  501+    → Decline    │                                    │
│  └───────────────────────┘                                    │
└──────────────────────────────────────────────────────────────┘
```

### 1.8 Choosing the Right Pattern

| Pattern | Best For | Complexity | Business User Friendliness | Performance |
|---------|----------|------------|---------------------------|-------------|
| **Production Rules (Rete)** | Complex, interacting rules | High | Low (needs developer) | Excellent (Rete) |
| **Decision Tables** | Tabular, independent rules | Low | Very High | Good |
| **Decision Trees** | Sequential, exclusionary logic | Medium | Medium | Excellent |
| **Scoring Models** | Accumulative risk assessment | Medium | High | Excellent |
| **Hybrid** | Full underwriting engine | High | Medium | Excellent |

**Recommended architecture for life underwriting:**

```
┌─────────────────────────────────────────────────────────────────┐
│                HYBRID RULES ARCHITECTURE                         │
│                                                                  │
│  Layer 1: DECISION TREES          → Eligibility & Routing       │
│  Layer 2: DECISION TABLES (DMN)   → Lookups (build, BP, labs)   │
│  Layer 3: PRODUCTION RULES (Rete) → Complex medical impairments │
│  Layer 4: SCORING MODEL           → Debit/credit aggregation    │
│  Layer 5: DECISION TABLES (DMN)   → Score → Risk class mapping  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Rules Engine Technology Selection

### 2.1 Drools (Red Hat / Community)

**Overview:** Open-source Business Rules Management System (BRMS) based on the Rete algorithm (enhanced as ReteOO and later PHREAK). Java-based, mature, widely adopted in insurance.

#### 2.1.1 DRL Syntax — Underwriting Examples

**Fact model (Java POJOs):**

```java
public class Applicant {
    private int age;
    private String gender;
    private String smokerStatus;
    private double heightInches;
    private double weightLbs;
    private double bmi;
    private int faceAmount;
    private String state;
    private String occupation;
    private List<MedicalCondition> conditions;
    private List<RxRecord> prescriptions;
    // getters/setters
}

public class LabResult {
    private String testCode;
    private String testName;
    private double value;
    private String unit;
    private LocalDate collectionDate;
    // getters/setters
}

public class UnderwritingDecision {
    private String riskClass;
    private List<Debit> debits;
    private List<String> referralReasons;
    private List<String> knockoutReasons;
    private boolean eligible;
    private int totalDebitPoints;
    // getters/setters
}

public class Debit {
    private String category;
    private String reason;
    private int points;
    private String ruleId;
    // getters/setters
}
```

**Rule Package — Eligibility:**

```drools
package com.insurance.uw.rules.eligibility

import com.insurance.uw.model.*

rule "ELIG-001: Minimum Age"
    salience 1000
    when
        $app : Applicant(age < 18)
        $dec : UnderwritingDecision()
    then
        $dec.setEligible(false);
        $dec.addKnockout("Applicant below minimum issue age of 18");
        update($dec);
end

rule "ELIG-002: Maximum Age"
    salience 1000
    when
        $app : Applicant(age > 75)
        $dec : UnderwritingDecision()
    then
        $dec.setEligible(false);
        $dec.addKnockout("Applicant exceeds maximum issue age of 75");
        update($dec);
end

rule "ELIG-003: Minimum Face Amount"
    salience 1000
    when
        $app : Applicant(faceAmount < 25000)
        $dec : UnderwritingDecision()
    then
        $dec.setEligible(false);
        $dec.addKnockout("Face amount below minimum of $25,000");
        update($dec);
end

rule "ELIG-004: Maximum Face Amount by Age"
    salience 1000
    when
        $app : Applicant(age >= 65, faceAmount > 500000)
        $dec : UnderwritingDecision()
    then
        $dec.setEligible(false);
        $dec.addKnockout("Face amount exceeds maximum $500K for ages 65+");
        update($dec);
end

rule "ELIG-005: State Availability"
    salience 1000
    when
        $app : Applicant(state == "NY" || state == "CT")
        $dec : UnderwritingDecision()
    then
        $dec.addReferral("State-specific product filing required");
        update($dec);
end
```

**Rule Package — Build Chart:**

```drools
package com.insurance.uw.rules.build

rule "BUILD-001: Calculate BMI"
    salience 900
    when
        $app : Applicant(bmi == 0, heightInches > 0, weightLbs > 0)
    then
        double bmi = ($app.getWeightLbs() * 703.0) /
                     ($app.getHeightInches() * $app.getHeightInches());
        $app.setBmi(Math.round(bmi * 10.0) / 10.0);
        update($app);
end

rule "BUILD-002: Male Underweight Decline"
    salience 800
    when
        $app : Applicant(gender == "M", bmi < 18.5)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BUILD", "Male BMI < 18.5 — underweight", 999, "BUILD-002"));
        $dec.addKnockout("BMI below minimum threshold");
        update($dec);
end

rule "BUILD-003: Male Preferred Plus Build"
    salience 800
    when
        $app : Applicant(gender == "M", bmi >= 18.5, bmi <= 25.9)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BUILD", "Male BMI 18.5-25.9 — optimal", 0, "BUILD-003"));
        update($dec);
end

rule "BUILD-004: Male Preferred Build"
    salience 800
    when
        $app : Applicant(gender == "M", bmi >= 26.0, bmi <= 29.9)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BUILD", "Male BMI 26.0-29.9 — overweight", 25, "BUILD-004"));
        update($dec);
end

rule "BUILD-005: Male Standard Build"
    salience 800
    when
        $app : Applicant(gender == "M", bmi >= 30.0, bmi <= 32.9)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BUILD", "Male BMI 30.0-32.9 — obese class I", 75, "BUILD-005"));
        update($dec);
end

rule "BUILD-006: Male Table 2 Build"
    salience 800
    when
        $app : Applicant(gender == "M", bmi >= 33.0, bmi <= 37.9)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BUILD", "Male BMI 33.0-37.9 — obese class I/II", 150, "BUILD-006"));
        update($dec);
end
```

**Rule Package — Blood Pressure:**

```drools
package com.insurance.uw.rules.vitals

rule "BP-001: Optimal Blood Pressure"
    when
        $app : Applicant(systolicBP < 120, diastolicBP < 80)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Optimal BP <120/80", 0, "BP-001"));
        update($dec);
end

rule "BP-002: Normal Blood Pressure"
    when
        $app : Applicant(systolicBP >= 120, systolicBP <= 129, diastolicBP < 80)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Elevated BP 120-129/<80", 15, "BP-002"));
        update($dec);
end

rule "BP-003: Stage 1 Hypertension"
    when
        $app : Applicant(systolicBP >= 130, systolicBP <= 139)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Stage 1 HTN systolic 130-139", 50, "BP-003"));
        update($dec);
end

rule "BP-004: Stage 1 Hypertension Diastolic"
    when
        $app : Applicant(diastolicBP >= 80, diastolicBP <= 89)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Stage 1 HTN diastolic 80-89", 50, "BP-004"));
        update($dec);
end

rule "BP-005: Stage 2 Hypertension"
    when
        $app : Applicant(systolicBP >= 140, systolicBP <= 159)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Stage 2 HTN systolic 140-159", 100, "BP-005"));
        update($dec);
end

rule "BP-006: Stage 2 Hypertension - Severe"
    when
        $app : Applicant(systolicBP >= 160)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("BP", "Severe HTN systolic 160+", 200, "BP-006"));
        $dec.addReferral("Severe hypertension — manual review required");
        update($dec);
end

rule "BP-007: Hypertensive Crisis"
    when
        $app : Applicant(systolicBP >= 180 || diastolicBP >= 120)
        $dec : UnderwritingDecision()
    then
        $dec.addKnockout("Hypertensive crisis — systolic ≥180 or diastolic ≥120");
        update($dec);
end
```

#### 2.1.2 Drools Architecture for Underwriting

```
┌──────────────────────────────────────────────────────────────────────┐
│                    DROOLS DEPLOYMENT ARCHITECTURE                    │
│                                                                      │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────────────┐ │
│  │ RULE AUTHORS │     │ RULE REPO    │     │ KIE SERVER           │ │
│  │              │────▶│ (Git-based)  │────▶│ (Execution Engine)   │ │
│  │ Business     │     │              │     │                      │ │
│  │ Central /    │     │ • DRL files  │     │ • KieContainer       │ │
│  │ Workbench    │     │ • Decision   │     │ • KieSession per     │ │
│  │              │     │   tables     │     │   request            │ │
│  │              │     │ • Test cases │     │ • REST API           │ │
│  └──────────────┘     │ • KJAR       │     │ • Hot-deploy         │ │
│                       │   artifacts  │     │                      │ │
│                       └──────────────┘     └──────────────────────┘ │
│                                                                      │
│  Deployment: KJAR (Knowledge JAR) → Maven repository → KIE Server   │
│  Hot reload: KIE Scanner checks for new KJAR versions every N secs  │
└──────────────────────────────────────────────────────────────────────┘
```

### 2.2 IBM Operational Decision Manager (ODM)

| Aspect | Details |
|--------|---------|
| **Core engine** | IBM ILOG JRules (Rete-based, now called Decision Engine) |
| **Rule authoring** | Decision Center — web-based, collaborative |
| **Rule language** | BAL (Business Action Language) — English-like |
| **Decision tables** | Full DMN support, Excel-based import |
| **Deployment** | Decision Server (J2EE), cloud-native on OpenShift |
| **Strengths** | Enterprise-grade, audit trail, rule governance, versioning |
| **Weaknesses** | Expensive licensing ($500K+/year), vendor lock-in, complex setup |
| **UW adoption** | Major carriers (MetLife, Prudential, MassMutual historical) |

**BAL rule example:**

```
definitions
  set 'the applicant' to the applicant of 'the case';
  set 'the lab results' to the lab results of 'the case';

if
  the age of 'the applicant' is more than 70
  and the face amount of 'the case' is more than 1000000
then
  add "Age 70+ with face amount exceeding $1M — decline"
    to the knockout reasons of 'the decision';
  set the eligible flag of 'the decision' to false;
```

### 2.3 FICO Blaze Advisor

| Aspect | Details |
|--------|---------|
| **Core engine** | FICO proprietary inference engine |
| **Rule authoring** | Blaze Advisor IDE, web-based Decision Modeler |
| **Rule language** | SRL (Structured Rule Language) |
| **Decision models** | Decision trees, scorecards, decision tables |
| **Deployment** | Embedded, server, cloud |
| **Strengths** | Scorecard integration (FICO heritage), analytics-first |
| **Weaknesses** | Expensive, smaller community than Drools/ODM |
| **UW adoption** | Lincoln Financial, Transamerica, RGA |

### 2.4 Camunda DMN

| Aspect | Details |
|--------|---------|
| **Core engine** | FEEL (Friendly Enough Expression Language) based DMN engine |
| **Rule authoring** | Camunda Modeler (desktop), Cockpit (web) |
| **Rule language** | DMN FEEL expressions |
| **Decision tables** | Native DMN support, all hit policies |
| **Deployment** | Embedded Java, Camunda Platform (Spring Boot), Camunda 8 (Zeebe/cloud) |
| **Strengths** | BPMN integration, lightweight, open-source core, cloud-native |
| **Weaknesses** | Less powerful for complex Rete-style rules, no forward chaining |
| **UW adoption** | Growing — mid-market carriers, InsurTechs |

**Camunda FEEL expression example:**

```
Decision Table: cholesterol_assessment
Hit Policy: UNIQUE

Input: total_cholesterol (number)
Input: ldl (number)
Input: hdl (number)
Output: cholesterol_class (string)
Output: debit_points (number)

| total_cholesterol | ldl     | hdl    | cholesterol_class  | debit_points |
|-------------------|---------|--------|--------------------|--------------|
| < 200             | < 100   | >= 60  | "Optimal"          | 0            |
| < 200             | < 100   | 40..59 | "Desirable"        | 10           |
| < 200             | 100..129| >= 40  | "Near Optimal"     | 15           |
| 200..239          | < 130   | >= 40  | "Borderline"       | 35           |
| 200..239          | 130..159| >= 40  | "Borderline High"  | 60           |
| 240..279          | -       | -      | "High"             | 100          |
| >= 280            | -       | -      | "Very High"        | 175          |
| -                 | >= 190  | -      | "Very High LDL"    | 200          |
| -                 | -       | < 35   | "Critical Low HDL" | 125          |
```

### 2.5 Custom Engines (Python / Java)

For InsurTechs and greenfield builds, custom rules engines offer maximum flexibility.

#### 2.5.1 Python Rules Engine

```python
from dataclasses import dataclass, field
from typing import List, Dict, Callable, Any, Optional
from enum import Enum
import json

class RiskClass(Enum):
    PREFERRED_PLUS = "Preferred Plus"
    PREFERRED = "Preferred"
    STANDARD_PLUS = "Standard Plus"
    STANDARD = "Standard"
    TABLE_2 = "Table 2"
    TABLE_4 = "Table 4"
    TABLE_6 = "Table 6"
    TABLE_8 = "Table 8"
    DECLINE = "Decline"
    REFER = "Refer to Underwriter"

@dataclass
class Debit:
    category: str
    reason: str
    points: int
    rule_id: str

@dataclass
class RuleResult:
    rule_id: str
    fired: bool
    debits: List[Debit] = field(default_factory=list)
    knockouts: List[str] = field(default_factory=list)
    referrals: List[str] = field(default_factory=list)
    evidence_required: List[str] = field(default_factory=list)

@dataclass
class UnderwritingCase:
    applicant_age: int
    gender: str
    smoker_status: str
    height_inches: float
    weight_lbs: float
    bmi: float
    face_amount: int
    annual_income: int
    state: str
    systolic_bp: int
    diastolic_bp: int
    lab_results: Dict[str, float]
    rx_history: List[Dict]
    medical_conditions: List[Dict]
    family_history: List[Dict]
    mvr_violations: List[Dict]

class Rule:
    def __init__(self, rule_id: str, category: str, description: str,
                 salience: int, condition: Callable, action: Callable):
        self.rule_id = rule_id
        self.category = category
        self.description = description
        self.salience = salience
        self.condition = condition
        self.action = action
        self.version = "1.0"
        self.effective_date = None
        self.expiration_date = None

class RulesEngine:
    def __init__(self):
        self.rules: List[Rule] = []
        self.execution_log: List[Dict] = []

    def add_rule(self, rule: Rule):
        self.rules.append(rule)
        self.rules.sort(key=lambda r: r.salience, reverse=True)

    def execute(self, case: UnderwritingCase) -> Dict:
        results = []
        total_debits = 0
        knockouts = []
        referrals = []
        evidence = []

        for rule in self.rules:
            try:
                if rule.condition(case):
                    result = rule.action(case)
                    result.rule_id = rule.rule_id
                    result.fired = True
                    results.append(result)

                    total_debits += sum(d.points for d in result.debits)
                    knockouts.extend(result.knockouts)
                    referrals.extend(result.referrals)
                    evidence.extend(result.evidence_required)

                    self.execution_log.append({
                        "rule_id": rule.rule_id,
                        "category": rule.category,
                        "fired": True,
                        "debits": [(d.category, d.points) for d in result.debits],
                        "knockouts": result.knockouts
                    })
            except Exception as e:
                self.execution_log.append({
                    "rule_id": rule.rule_id,
                    "error": str(e)
                })

        if knockouts:
            risk_class = RiskClass.DECLINE
        elif referrals:
            risk_class = RiskClass.REFER
        else:
            risk_class = self._map_score_to_class(total_debits)

        return {
            "risk_class": risk_class.value,
            "total_debits": total_debits,
            "knockouts": knockouts,
            "referrals": referrals,
            "evidence_required": evidence,
            "rules_fired": len(results),
            "execution_log": self.execution_log
        }

    def _map_score_to_class(self, total: int) -> RiskClass:
        if total <= 75:
            return RiskClass.PREFERRED_PLUS
        elif total <= 125:
            return RiskClass.PREFERRED
        elif total <= 175:
            return RiskClass.STANDARD_PLUS
        elif total <= 250:
            return RiskClass.STANDARD
        elif total <= 350:
            return RiskClass.TABLE_2
        elif total <= 500:
            return RiskClass.TABLE_4
        elif total <= 650:
            return RiskClass.TABLE_6
        elif total <= 800:
            return RiskClass.TABLE_8
        else:
            return RiskClass.DECLINE


# --- Define rules ---

def age_eligibility_condition(case):
    return case.applicant_age < 18 or case.applicant_age > 75

def age_eligibility_action(case):
    result = RuleResult(rule_id="", fired=True)
    result.knockouts.append(
        f"Age {case.applicant_age} outside eligible range 18-75")
    return result

def bmi_assessment_condition(case):
    return case.bmi > 0

def bmi_assessment_action(case):
    result = RuleResult(rule_id="", fired=True)
    if case.gender == "M":
        if case.bmi < 18.5:
            result.knockouts.append(f"Male BMI {case.bmi} below minimum 18.5")
        elif case.bmi <= 25.9:
            result.debits.append(Debit("BUILD", "Optimal BMI", 0, ""))
        elif case.bmi <= 29.9:
            result.debits.append(Debit("BUILD", "Overweight", 25, ""))
        elif case.bmi <= 32.9:
            result.debits.append(Debit("BUILD", "Obese Class I", 75, ""))
        elif case.bmi <= 37.9:
            result.debits.append(Debit("BUILD", "Obese Class I/II", 150, ""))
        elif case.bmi <= 42.9:
            result.debits.append(Debit("BUILD", "Obese Class II/III", 250, ""))
        else:
            result.knockouts.append(f"Male BMI {case.bmi} exceeds maximum 43.0")
    return result

engine = RulesEngine()
engine.add_rule(Rule("ELIG-AGE", "ELIGIBILITY", "Age check", 1000,
                     age_eligibility_condition, age_eligibility_action))
engine.add_rule(Rule("BUILD-BMI", "BUILD", "BMI assessment", 900,
                     bmi_assessment_condition, bmi_assessment_action))
```

#### 2.5.2 Serverless Rules Engine (AWS Lambda)

```python
# lambda_handler.py — Serverless underwriting rule execution

import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
rules_table = dynamodb.Table('underwriting-rules')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    case_data = json.loads(event['body'])

    rule_version = event.get('queryStringParameters', {}).get('version', 'LATEST')
    rules = load_rules(rule_version)

    engine = RulesEngine()
    for rule_def in rules:
        engine.add_rule(deserialize_rule(rule_def))

    result = engine.execute(build_case(case_data))

    # Persist audit trail
    audit_record = {
        'case_id': case_data['case_id'],
        'timestamp': datetime.utcnow().isoformat(),
        'rule_version': rule_version,
        'result': result,
        'input_hash': hash(json.dumps(case_data, sort_keys=True))
    }
    s3.put_object(
        Bucket='uw-audit-trail',
        Key=f"decisions/{case_data['case_id']}/{datetime.utcnow().isoformat()}.json",
        Body=json.dumps(audit_record)
    )

    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }
```

### 2.6 Technology Comparison Matrix

| Criteria | Drools | IBM ODM | FICO Blaze | Camunda DMN | Custom (Python) | Custom (Java) | Serverless |
|----------|--------|---------|------------|-------------|-----------------|--------------|------------|
| **License Cost** | Free (OSS) | $$$$ | $$$$ | Free (core) | Free | Free | Pay-per-use |
| **Learning Curve** | Medium | High | High | Low | Low | Medium | Low |
| **Rete Support** | Yes (PHREAK) | Yes | Proprietary | No | DIY | DIY | DIY |
| **DMN Support** | Yes | Yes | Partial | Native | DIY | DIY | DIY |
| **Business User UI** | Workbench | Decision Center | Decision Modeler | Modeler | DIY | DIY | DIY |
| **Rule Versioning** | Git + KJAR | Built-in | Built-in | Git | Git | Git | S3/DynamoDB |
| **Performance** | Excellent | Excellent | Excellent | Good | Good | Excellent | Variable |
| **Cloud-Native** | Medium | Medium | Medium | Excellent | Excellent | Good | Native |
| **Community** | Large | Small | Small | Growing | Huge (Python) | Huge (Java) | Large |
| **Max Rules** | 10K+ | 10K+ | 10K+ | 1K | 5K | 10K+ | 1K per Lambda |
| **Auditability** | Good | Excellent | Good | Good | DIY | DIY | DIY |
| **Integration** | Java ecosystem | IBM stack | FICO stack | Spring/BPMN | Any | Java ecosystem | AWS/Azure/GCP |
| **Vendor Support** | Red Hat | IBM | FICO | Camunda | None | None | Cloud vendor |
| **Recommended For** | Enterprise carriers | Large carriers | Analytics-heavy | BPM-centric | InsurTechs | Enterprise custom | Startups/API |

---

## 3. Rule Categories for Life Underwriting

### 3.1 Eligibility Rules

Eligibility rules determine whether an application can be accepted for processing. These are always evaluated first (highest salience).

```
ELIGIBILITY RULES — COMPREHENSIVE LIST

ELIG-001: Age minimum (18 years)
ELIG-002: Age maximum (75 years for most products; 80 for simplified issue)
ELIG-003: Age maximum for term length (e.g., age + term ≤ 85)
ELIG-004: Minimum face amount ($25,000)
ELIG-005: Maximum face amount by age band
ELIG-006: Maximum face amount by product
ELIG-007: State availability (product filed in applicant's state)
ELIG-008: US citizenship or permanent residency
ELIG-009: Replacement regulation check (1035 exchange rules)
ELIG-010: Existing coverage check (total in-force limits)
ELIG-011: Prior application check (declined within last 12 months)
ELIG-012: Prior application check (withdrawn within last 6 months)
ELIG-013: Occupation eligibility (excluded occupations list)
ELIG-014: Military status (active deployment exclusion)
ELIG-015: Incarceration status
ELIG-016: Foreign residence/travel (country risk list)
ELIG-017: Aviation — private pilot hours minimum
ELIG-018: Hazardous avocation check (skydiving, BASE jumping, etc.)
ELIG-019: Term length availability by age
ELIG-020: Rider eligibility by product/state
ELIG-021: Minimum annual income for face amount requested
ELIG-022: Maximum face amount multiple of income by age
ELIG-023: Juvenile applicant guardian verification
ELIG-024: Trust-owned policy eligibility
ELIG-025: Business-owned policy (BOLI) eligibility
ELIG-026: Key person eligibility documentation
ELIG-027: Charitable ownership eligibility
ELIG-028: Multiple policy limit (same carrier)
ELIG-029: Conversion eligibility (term-to-perm)
ELIG-030: Reinstatement eligibility (lapsed policy)
ELIG-031: Gender identity compliance (state-specific)
ELIG-032: Tobacco definition compliance (state-specific)
ELIG-033: Financial justification — net worth check
ELIG-034: Financial justification — alimony/child support
ELIG-035: Financial justification — estate tax liability
ELIG-036: Financial justification — business valuation
ELIG-037: Financial justification — key person valuation
ELIG-038: Premium financing eligibility
ELIG-039: Stranger-owned life insurance (STOLI) screen
ELIG-040: Insurable interest verification
ELIG-041: Beneficiary relationship validation
ELIG-042: Application completeness check
ELIG-043: e-Signature state compliance
ELIG-044: Agent licensing verification (state of sale)
ELIG-045: Commission schedule eligibility
ELIG-046: Reinsurance facultative requirement check
ELIG-047: Automatic binding limit check
ELIG-048: Jumbo limit check (face amount > $10M)
ELIG-049: Foreign national eligibility (visa type)
ELIG-050: Contestability period awareness (replacement)
ELIG-051: Child term rider age eligibility (14 days–18 years)
ELIG-052: Waiver of premium rider eligibility (age < 60)
ELIG-053: Accelerated death benefit rider eligibility (state)
ELIG-054: Return of premium rider eligibility (age + term)
ELIG-055: Guaranteed insurability option eligibility
```

**Pseudocode for financial justification eligibility:**

```
RULE ELIG-021: Income-Based Face Amount Limit
  INPUT: applicant_age, annual_income, face_amount
  
  IF applicant_age < 40:
    max_multiple = 30
  ELIF applicant_age < 50:
    max_multiple = 20
  ELIF applicant_age < 60:
    max_multiple = 15
  ELIF applicant_age < 65:
    max_multiple = 10
  ELSE:
    max_multiple = 5
  
  max_face = annual_income * max_multiple
  
  IF face_amount > max_face:
    IF face_amount > max_face * 1.5:
      KNOCKOUT("Face amount exceeds 150% of maximum income multiple")
    ELSE:
      REQUIRE_EVIDENCE("Financial questionnaire")
      REFERRAL("Face amount exceeds income multiple — needs financial UW review")
```

### 3.2 Knockout Rules

Knockout rules result in immediate decline or referral. They represent conditions that are non-negotiable in automated processing.

```
KNOCKOUT RULES — COMPREHENSIVE TRIGGER LIST

MEDICAL KNOCKOUTS:
KO-001: Active cancer (any type, diagnosed within last 5 years)
KO-002: Metastatic cancer (any history)
KO-003: HIV/AIDS diagnosis
KO-004: Organ transplant recipient (within last 2 years)
KO-005: Awaiting organ transplant
KO-006: End-stage renal disease / dialysis
KO-007: ALS (Lou Gehrig's disease) — any history
KO-008: Huntington's disease — diagnosed
KO-009: Cirrhosis of the liver
KO-010: Hepatitis C — active/untreated
KO-011: Current IV drug use
KO-012: Active alcohol abuse / treatment within 2 years
KO-013: Drug abuse / treatment within 3 years
KO-014: Hospitalized for mental health within 1 year
KO-015: Attempted suicide within 5 years
KO-016: Alzheimer's disease / dementia diagnosis
KO-017: Multiple sclerosis — progressive form
KO-018: Systemic lupus (SLE) with organ involvement
KO-019: Scleroderma — diffuse
KO-020: Pulmonary fibrosis (IPF)
KO-021: Primary pulmonary hypertension
KO-022: Cardiomyopathy (dilated or restrictive)
KO-023: Heart failure (NYHA Class III or IV)
KO-024: Aortic aneurysm (untreated, > 5cm)
KO-025: Stroke within last 12 months
KO-026: Insulin-dependent diabetes diagnosed before age 25 (Type 1)
KO-027: Diabetes with amputation
KO-028: Diabetes with diabetic retinopathy (proliferative)
KO-029: Chronic pancreatitis
KO-030: Crohn's disease with bowel resection within 2 years
KO-031: Cystic fibrosis
KO-032: Sickle cell disease (not trait)
KO-033: Hemophilia
KO-034: Currently receiving chemotherapy
KO-035: Currently receiving radiation therapy
KO-036: Oxygen therapy / home oxygen
KO-037: Wheelchair-bound (non-temporary)
KO-038: Unable to perform 2+ ADLs (Activities of Daily Living)
KO-039: Cognitive impairment requiring assistance
KO-040: Parkinson's disease — advanced (Hoehn & Yahr stage 4-5)

LIFESTYLE KNOCKOUTS:
KO-041: Criminal history — felony conviction within 5 years
KO-042: Criminal history — currently on probation/parole
KO-043: DUI/DWI — 3+ occurrences in last 10 years
KO-044: DUI/DWI — within last 12 months
KO-045: Reckless driving — within last 3 years
KO-046: License suspension — current
KO-047: Hazardous occupation — underground mining
KO-048: Hazardous occupation — offshore oil rig
KO-049: Hazardous occupation — professional combat sports
KO-050: Hazardous occupation — explosive handling
KO-051: Hazardous avocation — BASE jumping (regular)
KO-052: Hazardous avocation — free solo rock climbing
KO-053: Hazardous avocation — cave diving
KO-054: Aviation — unlicensed pilot
KO-055: Aviation — experimental aircraft
KO-056: Travel — active war zone within 12 months
KO-057: Travel — CDC Level 4 country planned
KO-058: Foreign residence — sanctioned country
KO-059: Marijuana — commercial grower/distributor
KO-060: Positive drug test for illegal substances

LAB/VITALS KNOCKOUTS:
KO-061: HbA1c > 10.0%
KO-062: Fasting glucose > 300 mg/dL
KO-063: eGFR < 30 mL/min (Stage 4-5 CKD)
KO-064: Creatinine > 2.5 mg/dL
KO-065: ALT/AST > 5x upper limit of normal
KO-066: Total bilirubin > 3.0 mg/dL (non-Gilbert's)
KO-067: Urine protein > 300 mg/dL (persistent)
KO-068: PSA > 10.0 ng/mL
KO-069: Troponin elevated (acute)
KO-070: BNP > 400 pg/mL
KO-071: HIV test positive
KO-072: Hepatitis B surface antigen positive
KO-073: Cocaine metabolite positive
KO-074: Amphetamine positive (without prescription)
KO-075: Cotinine > 200 ng/mL (when declared non-smoker)
KO-076: CDT > 2.5% (carbohydrate-deficient transferrin — alcohol marker)

FINANCIAL/FRAUD KNOCKOUTS:
KO-077: OFAC/SDN list match
KO-078: Failed identity verification
KO-079: SSN associated with death record
KO-080: Multiple applications with different health histories (same SSN)
KO-081: Application within 30 days of policy loan on existing policy
KO-082: Beneficiary is unrelated non-business entity
KO-083: Face amount > 50x annual income (no business justification)
KO-084: Premium financing with no insurable interest demonstration
KO-085: MIB code match indicating prior decline for fraud

MIB/DATA KNOCKOUTS:
KO-086: MIB code 001 — prior decline (undisclosed)
KO-087: MIB code indicating undisclosed cancer history
KO-088: MIB code indicating undisclosed substance abuse
KO-089: MIB code indicating undisclosed heart condition
KO-090: MIB discrepancy — material misrepresentation on application

PRESCRIPTION KNOCKOUTS:
KO-091: Methadone or buprenorphine (opioid dependence treatment)
KO-092: Antiretroviral medications (HIV)
KO-093: Chemotherapy agents (active cancer treatment)
KO-094: Immunosuppressants (organ transplant)
KO-095: Dialysis-related medications

AGE/AMOUNT KNOCKOUTS:
KO-096: Age 71+ with face amount > $1M
KO-097: Age 66-70 with face amount > $2M
KO-098: Age 0-17 (below minimum issue age)
KO-099: Age 76+ (above maximum issue age)
KO-100: Face amount < $25,000 (below minimum)
```

**Drools implementation for knockout rules:**

```drools
package com.insurance.uw.rules.knockout

rule "KO-001: Active Cancer"
    salience 10000
    when
        $cond : MedicalCondition(
            conditionCode matches "C[0-9]{2}.*",
            diagnosisDate > today(-5y),
            status == "ACTIVE"
        )
        $dec : UnderwritingDecision()
    then
        $dec.addKnockout("Active cancer diagnosed within 5 years: " +
            $cond.getDescription());
        $dec.setEligible(false);
        update($dec);
end

rule "KO-006: ESRD / Dialysis"
    salience 10000
    when
        (
            MedicalCondition(conditionCode == "N18.6") or
            MedicalCondition(conditionCode == "Z99.2") or
            Procedure(cptCode in ("90935", "90937", "90940", "90945"))
        )
        $dec : UnderwritingDecision()
    then
        $dec.addKnockout("End-stage renal disease or dialysis");
        $dec.setEligible(false);
        update($dec);
end

rule "KO-075: Cotinine Mismatch"
    salience 10000
    when
        $app : Applicant(smokerStatus == "never" || smokerStatus == "former")
        $lab : LabResult(testCode == "COTININE", value > 200)
        $dec : UnderwritingDecision()
    then
        $dec.addKnockout("Cotinine " + $lab.getValue() +
            " ng/mL inconsistent with declared " + $app.getSmokerStatus() +
            " smoker status — possible misrepresentation");
        $dec.setEligible(false);
        update($dec);
end
```

### 3.3 Evidence Requirement Rules (Age × Amount Matrix)

Evidence requirements determine what documentation is needed based on age band and face amount.

```
EVIDENCE REQUIREMENT MATRIX (AGE × FACE AMOUNT)

┌──────────┬─────────────┬─────────────┬──────────────┬──────────────┬──────────────┐
│ Age Band │  $25K-$99K  │ $100K-$249K │ $250K-$499K  │ $500K-$999K  │   $1M+       │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 18-30    │ App, MIB    │ App, MIB    │ App, MIB,    │ App, MIB,    │ App, MIB,    │
│          │             │             │ Rx, MVR      │ Rx, MVR,     │ Rx, MVR,     │
│          │             │             │              │ Labs         │ Labs, APS,   │
│          │             │             │              │              │ Inspect, Fin │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 31-40    │ App, MIB    │ App, MIB,   │ App, MIB,    │ App, MIB,    │ App, MIB,    │
│          │             │ Rx          │ Rx, MVR      │ Rx, MVR,     │ Rx, MVR,     │
│          │             │             │              │ Labs         │ Labs, APS,   │
│          │             │             │              │              │ Inspect, Fin │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 41-50    │ App, MIB,   │ App, MIB,   │ App, MIB,    │ App, MIB,    │ App, MIB,    │
│          │ Rx          │ Rx, MVR     │ Rx, MVR,     │ Rx, MVR,     │ Rx, MVR,     │
│          │             │             │ Labs         │ Labs, APS    │ Labs, APS,   │
│          │             │             │              │              │ EKG, Inspect,│
│          │             │             │              │              │ Fin          │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 51-60    │ App, MIB,   │ App, MIB,   │ App, MIB,    │ App, MIB,    │ App, MIB,    │
│          │ Rx, MVR     │ Rx, MVR,    │ Rx, MVR,     │ Rx, MVR,     │ Rx, MVR,     │
│          │             │ Labs        │ Labs, APS    │ Labs, APS,   │ Labs, APS,   │
│          │             │             │              │ EKG          │ EKG, Stress, │
│          │             │             │              │              │ Inspect, Fin │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 61-70    │ App, MIB,   │ App, MIB,   │ App, MIB,    │ App, MIB,    │ App, MIB,    │
│          │ Rx, MVR,    │ Rx, MVR,    │ Rx, MVR,     │ Rx, MVR,     │ Rx, MVR,     │
│          │ Labs        │ Labs, APS   │ Labs, APS,   │ Labs, APS,   │ Labs, APS,   │
│          │             │             │ EKG          │ EKG, Stress  │ EKG, Stress, │
│          │             │             │              │              │ Inspect, Fin,│
│          │             │             │              │              │ Cognitive    │
├──────────┼─────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ 71-75    │ App, MIB,   │ App, MIB,   │ App, MIB,    │ App, MIB,    │ NOT          │
│          │ Rx, MVR,    │ Rx, MVR,    │ Rx, MVR,     │ Rx, MVR,     │ ELIGIBLE     │
│          │ Labs, APS   │ Labs, APS,  │ Labs, APS,   │ Labs, APS,   │              │
│          │             │ EKG         │ EKG, Stress  │ EKG, Stress, │              │
│          │             │             │              │ Inspect, Fin,│              │
│          │             │             │              │ Cognitive    │              │
└──────────┴─────────────┴─────────────┴──────────────┴──────────────┴──────────────┘

LEGEND:
  App     = Application (Part 1 & 2)
  MIB     = MIB check
  Rx      = Prescription history (Milliman IntelliScript / ExamOne)
  MVR     = Motor vehicle report
  Labs    = Blood & urine panel (lipids, CBC, CMP, HbA1c, HIV, Hep B/C, cotinine, CDT)
  APS     = Attending Physician Statement
  EKG     = Resting electrocardiogram
  Stress  = Exercise stress test / stress echo
  Inspect = Inspection report (face-to-face or phone)
  Fin     = Financial documentation (tax returns, financial statement)
  Cognitive = Cognitive screening (ages 70+)
```

**DRL implementation:**

```drools
rule "EVID-001: Base Requirements All Applications"
    salience 950
    when
        $app : Applicant()
        $case : UnderwritingCase()
    then
        $case.requireEvidence("APPLICATION");
        $case.requireEvidence("MIB_CHECK");
        update($case);
end

rule "EVID-010: Rx History Required Age 41+ or Amount 250K+"
    salience 940
    when
        $app : Applicant(age >= 41 || $case.faceAmount >= 250000)
        $case : UnderwritingCase()
    then
        $case.requireEvidence("RX_HISTORY");
        update($case);
end

rule "EVID-020: Labs Required Age 51+ or Amount 500K+"
    salience 930
    when
        $app : Applicant()
        $case : UnderwritingCase(
            applicantAge >= 51 || faceAmount >= 500000
        )
    then
        $case.requireEvidence("BLOOD_PANEL");
        $case.requireEvidence("URINE_PANEL");
        update($case);
end

rule "EVID-030: APS Required Age 51+ Amount 250K+ or Age 61+"
    salience 920
    when
        $app : Applicant()
        $case : UnderwritingCase(
            (applicantAge >= 51 && faceAmount >= 250000) ||
            applicantAge >= 61
        )
    then
        $case.requireEvidence("APS");
        update($case);
end

rule "EVID-040: EKG Required Age 51+ Amount 1M+ or Age 61+ Amount 250K+"
    salience 910
    when
        $app : Applicant()
        $case : UnderwritingCase(
            (applicantAge >= 51 && faceAmount >= 1000000) ||
            (applicantAge >= 61 && faceAmount >= 250000)
        )
    then
        $case.requireEvidence("EKG");
        update($case);
end
```

### 3.4 Build Chart Rules (Complete Height/Weight Table)

```
MALE BUILD CHART — HEIGHT × WEIGHT → RISK CLASS LIMIT

Height  │  Pref Plus    │  Preferred    │  Standard     │  Table 2      │  Table 4      │  Decline
(in.)   │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Above
────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┼─────────
60      │  136          │  155          │  170          │  190          │  215          │  215+
61      │  140          │  159          │  175          │  196          │  222          │  222+
62      │  144          │  164          │  181          │  202          │  229          │  229+
63      │  149          │  169          │  187          │  209          │  236          │  236+
64      │  153          │  174          │  193          │  215          │  244          │  244+
65      │  158          │  180          │  199          │  222          │  252          │  252+
66      │  163          │  185          │  205          │  229          │  260          │  260+
67      │  168          │  191          │  212          │  236          │  268          │  268+
68      │  173          │  197          │  218          │  244          │  276          │  276+
69      │  178          │  203          │  225          │  251          │  285          │  285+
70      │  184          │  209          │  232          │  259          │  294          │  294+
71      │  189          │  215          │  239          │  267          │  303          │  303+
72      │  195          │  222          │  246          │  275          │  312          │  312+
73      │  201          │  228          │  253          │  283          │  322          │  322+
74      │  207          │  235          │  261          │  292          │  331          │  331+
75      │  213          │  242          │  269          │  300          │  341          │  341+
76      │  219          │  249          │  277          │  309          │  351          │  351+
78      │  232          │  264          │  293          │  327          │  371          │  371+

FEMALE BUILD CHART — HEIGHT × WEIGHT → RISK CLASS LIMIT

Height  │  Pref Plus    │  Preferred    │  Standard     │  Table 2      │  Table 4      │  Decline
(in.)   │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Max Wt (lbs) │  Above
────────┼───────────────┼───────────────┼───────────────┼───────────────┼───────────────┼─────────
58      │  121          │  138          │  155          │  175          │  199          │  199+
59      │  125          │  142          │  159          │  180          │  205          │  205+
60      │  128          │  146          │  164          │  186          │  211          │  211+
61      │  132          │  150          │  169          │  191          │  217          │  217+
62      │  136          │  155          │  174          │  197          │  224          │  224+
63      │  140          │  159          │  179          │  203          │  231          │  231+
64      │  144          │  164          │  185          │  209          │  238          │  238+
65      │  149          │  169          │  190          │  215          │  245          │  245+
66      │  153          │  174          │  196          │  222          │  252          │  252+
67      │  158          │  179          │  202          │  228          │  260          │  260+
68      │  162          │  185          │  208          │  235          │  267          │  267+
69      │  167          │  190          │  214          │  242          │  275          │  275+
70      │  172          │  196          │  220          │  249          │  283          │  283+
71      │  177          │  201          │  227          │  256          │  291          │  291+
72      │  182          │  207          │  233          │  264          │  300          │  300+
73      │  187          │  213          │  240          │  271          │  309          │  309+
```

### 3.5 Lab Interpretation Rules — Every Lab Value with Ranges

```
COMPLETE LAB VALUE INTERPRETATION TABLE

TEST                │ UNITS     │ OPTIMAL       │ NORMAL        │ BORDERLINE      │ ABNORMAL        │ CRITICAL        │ DEBITS
────────────────────┼───────────┼───────────────┼───────────────┼─────────────────┼─────────────────┼─────────────────┼────────
LIPID PANEL:        │           │               │               │                 │                 │                 │
Total Cholesterol   │ mg/dL     │ < 200         │ 200-219       │ 220-239         │ 240-279         │ ≥ 280           │ 0/10/35/100/175
LDL Cholesterol     │ mg/dL     │ < 100         │ 100-129       │ 130-159         │ 160-189         │ ≥ 190           │ 0/15/50/125/200
HDL Cholesterol     │ mg/dL     │ ≥ 60          │ 40-59         │ 35-39           │ < 35            │ < 25            │ 0/10/50/125/200
Triglycerides       │ mg/dL     │ < 150         │ 150-199       │ 200-299         │ 300-499         │ ≥ 500           │ 0/10/35/75/KO
Chol/HDL Ratio      │ ratio     │ < 4.0         │ 4.0-4.9       │ 5.0-5.9         │ 6.0-6.9         │ ≥ 7.0           │ 0/10/35/75/125
                    │           │               │               │                 │                 │                 │
GLUCOSE/DIABETES:   │           │               │               │                 │                 │                 │
Fasting Glucose     │ mg/dL     │ < 100         │ 100-109       │ 110-125         │ 126-199         │ ≥ 200           │ 0/15/50/125/KO
HbA1c               │ %         │ < 5.7         │ 5.7-5.9       │ 6.0-6.4         │ 6.5-7.9         │ ≥ 8.0           │ 0/15/50/125/200
Fructosamine        │ µmol/L    │ < 270         │ 270-299       │ 300-349         │ 350-399         │ ≥ 400           │ 0/15/50/100/175
                    │           │               │               │                 │                 │                 │
KIDNEY FUNCTION:    │           │               │               │                 │                 │                 │
Creatinine          │ mg/dL (M) │ 0.7-1.2       │ 1.3-1.4       │ 1.5-1.8         │ 1.9-2.5         │ > 2.5           │ 0/15/50/125/KO
Creatinine          │ mg/dL (F) │ 0.5-1.0       │ 1.1-1.2       │ 1.3-1.5         │ 1.6-2.0         │ > 2.0           │ 0/15/50/125/KO
eGFR                │ mL/min    │ ≥ 90          │ 60-89         │ 45-59           │ 30-44           │ < 30            │ 0/15/75/150/KO
BUN                 │ mg/dL     │ 7-20          │ 21-25         │ 26-30           │ 31-40           │ > 40            │ 0/10/25/75/125
BUN/Creatinine      │ ratio     │ 10-20         │ 21-25         │ > 25            │ —               │ —               │ 0/10/25
Urine Protein       │ mg/dL     │ Negative      │ Trace         │ 30 (1+)         │ 100 (2+)        │ ≥ 300 (3+)      │ 0/10/50/100/KO
Urine Glucose       │ mg/dL     │ Negative      │ Trace         │ 1+              │ 2+              │ ≥ 3+            │ 0/15/50/100/150
Microalbumin/Creat  │ mg/g      │ < 30          │ 30-99         │ 100-299         │ ≥ 300           │ —               │ 0/25/75/KO
                    │           │               │               │                 │                 │                 │
LIVER FUNCTION:     │           │               │               │                 │                 │                 │
ALT (SGPT)          │ U/L       │ < 35          │ 35-49         │ 50-69           │ 70-175          │ > 175           │ 0/15/50/100/KO
AST (SGOT)          │ U/L       │ < 35          │ 35-49         │ 50-69           │ 70-175          │ > 175           │ 0/15/50/100/KO
GGT                 │ U/L (M)   │ < 45          │ 45-64         │ 65-99           │ 100-199         │ ≥ 200           │ 0/15/35/75/150
GGT                 │ U/L (F)   │ < 35          │ 35-54         │ 55-84           │ 85-149          │ ≥ 150           │ 0/15/35/75/150
Alk Phosphatase     │ U/L       │ 44-147        │ 148-180       │ 181-220         │ 221-300         │ > 300           │ 0/10/25/75/KO
Total Bilirubin     │ mg/dL     │ 0.1-1.0       │ 1.1-1.5       │ 1.6-2.0         │ 2.1-3.0         │ > 3.0           │ 0/10/25/75/KO
Albumin             │ g/dL      │ 3.5-5.5       │ 3.2-3.4       │ 2.8-3.1         │ < 2.8           │ —               │ 0/10/50/125
                    │           │               │               │                 │                 │                 │
CBC:                │           │               │               │                 │                 │                 │
Hemoglobin          │ g/dL (M)  │ 14.0-18.0     │ 13.0-13.9     │ 11.0-12.9       │ < 11.0          │ < 8.0           │ 0/15/50/KO/KO
Hemoglobin          │ g/dL (F)  │ 12.0-16.0     │ 11.0-11.9     │ 9.5-10.9        │ < 9.5           │ < 7.0           │ 0/15/50/KO/KO
Hematocrit          │ % (M)     │ 42-52         │ 38-41         │ 35-37           │ < 35            │ > 55            │ 0/15/50/KO/KO
WBC Count           │ K/µL      │ 4.5-11.0      │ 3.5-4.4       │ 11.1-14.9       │ 15.0-20.0       │ > 20 or < 3.0   │ 0/10/25/75/KO
Platelet Count      │ K/µL      │ 150-400       │ 120-149       │ 100-119         │ 50-99           │ < 50            │ 0/10/25/75/KO
                    │           │               │               │                 │                 │                 │
CARDIAC MARKERS:    │           │               │               │                 │                 │                 │
NT-proBNP           │ pg/mL     │ < 125         │ 125-299       │ 300-449         │ 450-900         │ > 900           │ 0/25/75/150/KO
hs-CRP              │ mg/L      │ < 1.0         │ 1.0-2.9       │ 3.0-4.9         │ 5.0-9.9         │ ≥ 10.0          │ 0/10/25/50/100
Troponin I          │ ng/mL     │ < 0.04        │ —             │ —               │ ≥ 0.04          │ —               │ 0/—/—/KO
                    │           │               │               │                 │                 │                 │
THYROID:            │           │               │               │                 │                 │                 │
TSH                 │ mIU/L     │ 0.4-4.0       │ 4.1-6.0       │ 6.1-10.0        │ > 10 or < 0.1   │ —               │ 0/10/25/75
                    │           │               │               │                 │                 │                 │
PROSTATE (M only):  │           │               │               │                 │                 │                 │
PSA                 │ ng/mL     │ < 2.5 (≤50y)  │ 2.5-4.0       │ 4.1-6.0         │ 6.1-10.0        │ > 10.0          │ 0/15/REFER/REFER/KO
                    │           │               │               │                 │                 │                 │
SUBSTANCE MARKERS:  │           │               │               │                 │                 │                 │
Cotinine            │ ng/mL     │ < 10          │ 10-49 (nicotine│ 50-200 (smoker) │ > 200           │ —               │ 0/RECLASSIFY/RECLASS/KO if non-smoker
CDT                 │ %         │ < 1.7         │ 1.7-2.0       │ 2.0-2.5         │ > 2.5           │ —               │ 0/25/75/KO
Urine Drug Screen   │ qual      │ Negative all  │ —             │ —               │ Positive        │ —               │ 0/—/—/See KO rules
```

### 3.6 Rx Interpretation Rules (Drug → Condition Mapping — 50+ Medications)

```
PRESCRIPTION DRUG → CONDITION MAPPING TABLE

DRUG NAME           │ GENERIC/CLASS          │ IMPLIED CONDITION(S)           │ UW ACTION                    │ DEBITS
────────────────────┼────────────────────────┼────────────────────────────────┼──────────────────────────────┼────────
Metformin           │ Biguanide              │ Type 2 Diabetes                │ Request HbA1c, glucose       │ 50-150
Insulin (any)       │ Insulin                │ Diabetes (Type 1 or 2)         │ Full diabetic workup         │ 100-300
Glipizide           │ Sulfonylurea           │ Type 2 Diabetes                │ Request HbA1c, glucose       │ 50-150
Januvia (sitagliptin)│ DPP-4 Inhibitor       │ Type 2 Diabetes                │ Request HbA1c, glucose       │ 50-150
Ozempic (semaglutide)│ GLP-1 RA              │ Type 2 Diabetes/Obesity        │ Request HbA1c, BMI context   │ 50-125
Lisinopril          │ ACE Inhibitor          │ Hypertension, Heart Failure    │ Request BP readings, BMP     │ 25-75
Losartan            │ ARB                    │ Hypertension                   │ Request BP readings          │ 25-75
Amlodipine          │ CCB                    │ Hypertension, Angina           │ Request BP, cardiac hx       │ 25-75
Metoprolol          │ Beta-blocker           │ HTN, Arrhythmia, CHF, Angina   │ Request cardiac workup       │ 25-100
Atenolol            │ Beta-blocker           │ HTN, Arrhythmia                │ Request BP, EKG              │ 25-75
Carvedilol          │ Alpha/Beta-blocker     │ Heart Failure, HTN             │ Request echo, cardiac hx     │ 50-150
Hydrochlorothiazide │ Thiazide Diuretic      │ Hypertension, Edema            │ Request BP, BMP              │ 15-50
Furosemide          │ Loop Diuretic          │ CHF, Edema, Renal              │ Request cardiac/renal workup │ 50-150
Spironolactone      │ K-sparing Diuretic     │ CHF, Ascites, Aldosteronism    │ Request cardiac/liver workup │ 50-125
Atorvastatin        │ Statin                 │ Hyperlipidemia                 │ Request lipid panel          │ 15-50
Rosuvastatin        │ Statin                 │ Hyperlipidemia                 │ Request lipid panel          │ 15-50
Clopidogrel (Plavix)│ Antiplatelet           │ CAD, Stroke, PAD               │ Request cardiac hx, APS      │ 75-200
Warfarin (Coumadin) │ Anticoagulant          │ AFib, DVT/PE, Valve            │ Request cardiac hx, INR      │ 75-200
Apixaban (Eliquis)  │ DOAC                   │ AFib, DVT/PE                   │ Request cardiac hx           │ 50-150
Rivaroxaban (Xarelto)│ DOAC                  │ AFib, DVT/PE                   │ Request cardiac hx           │ 50-150
Nitroglycerin       │ Nitrate                │ Angina, CAD                    │ Request cardiac workup       │ 100-250
Digoxin             │ Cardiac Glycoside      │ CHF, AFib                      │ Request echo, cardiac hx     │ 75-200
Levothyroxine       │ Thyroid Hormone        │ Hypothyroidism                 │ Request TSH                  │ 0-25
Methimazole         │ Anti-thyroid           │ Hyperthyroidism/Graves'        │ Request thyroid panel        │ 25-75
Albuterol           │ SABA                   │ Asthma, COPD                   │ Request PFTs if daily use    │ 15-75
Fluticasone/Salmet. │ ICS/LABA               │ Asthma (moderate-severe)       │ Request PFTs, ER visits      │ 25-100
Tiotropium (Spiriva)│ LAMA                   │ COPD                           │ Request PFTs, APS            │ 50-200
Montelukast         │ Leukotriene Modifier   │ Asthma (mild-moderate)         │ Request frequency of use     │ 10-50
Omeprazole          │ PPI                    │ GERD, Peptic Ulcer             │ Benign if no complications   │ 0-15
Sertraline (Zoloft) │ SSRI                   │ Depression, Anxiety, OCD       │ Request mental health hx     │ 15-75
Fluoxetine (Prozac) │ SSRI                   │ Depression, Anxiety, OCD       │ Request mental health hx     │ 15-75
Escitalopram        │ SSRI                   │ Depression, Anxiety             │ Request mental health hx     │ 15-75
Duloxetine (Cymbalta)│ SNRI                  │ Depression, Neuropathy, Pain   │ Request mental health hx     │ 15-75
Venlafaxine         │ SNRI                   │ Depression, Anxiety             │ Request mental health hx     │ 15-75
Bupropion           │ NDRI                   │ Depression, Smoking Cessation  │ Request mental health hx     │ 10-50
Lithium             │ Mood Stabilizer        │ Bipolar Disorder               │ Request psych APS, TSH, renal│ 75-200
Valproic Acid       │ Anticonvulsant/Mood    │ Epilepsy, Bipolar              │ Request neuro/psych APS      │ 50-150
Lamotrigine         │ Anticonvulsant/Mood    │ Epilepsy, Bipolar              │ Request neuro/psych APS      │ 25-100
Gabapentin          │ Anticonvulsant/Pain    │ Neuropathy, Seizures, Pain     │ Clarify indication           │ 10-75
Pregabalin (Lyrica) │ Anticonvulsant/Pain    │ Neuropathy, Fibromyalgia       │ Clarify indication           │ 10-75
Alprazolam (Xanax)  │ Benzodiazepine         │ Anxiety, Panic Disorder        │ Request mental health hx     │ 25-100
Clonazepam          │ Benzodiazepine         │ Anxiety, Seizures              │ Request mental health hx     │ 25-100
Zolpidem (Ambien)   │ Sleep Aid              │ Insomnia                       │ Assess for underlying cause  │ 10-25
Prednisone          │ Corticosteroid         │ Autoimmune, Inflammatory       │ Request diagnosis/APS        │ 25-150
Methotrexate        │ DMARD                  │ RA, Psoriasis, Cancer          │ Request diagnosis/APS        │ 50-200
Humira (adalimumab) │ TNF Inhibitor/Biologic │ RA, Crohn's, Psoriasis        │ Request diagnosis/APS        │ 50-150
Tamoxifen           │ SERM                   │ Breast Cancer (adj/prev)       │ Request oncology APS         │ 75-250
Anastrozole         │ Aromatase Inhibitor    │ Breast Cancer (adjuvant)       │ Request oncology APS         │ 75-250
Oxycodone           │ Opioid                 │ Chronic Pain                   │ Scrutinize — abuse risk      │ 50-200
Hydrocodone         │ Opioid                 │ Acute/Chronic Pain             │ Assess duration, frequency   │ 25-150
Tramadol            │ Opioid (weak)          │ Pain Management                │ Assess duration              │ 15-75
Suboxone            │ Buprenorphine/Naloxone │ Opioid Use Disorder            │ KNOCKOUT or heavy rating     │ KO/300
Naltrexone          │ Opioid Antagonist      │ Alcohol/Opioid Use Disorder    │ Request addiction hx         │ 100-250
Sildenafil (Viagra) │ PDE5 Inhibitor         │ ED (possible cardiac)          │ Assess cardiac risk factors  │ 0-25
Finasteride         │ 5-AR Inhibitor         │ BPH, Hair Loss                 │ Benign if for hair loss      │ 0-10
Testosterone        │ Androgen               │ Hypogonadism                   │ Request labs, PSA            │ 15-50
Estradiol           │ Estrogen               │ Menopause, HRT                 │ Assess duration              │ 0-15
```

### 3.7 Medical Impairment Rules (Per-Condition Ratings)

```
MEDICAL IMPAIRMENT RATING TABLE

CONDITION                    │ BEST CLASS    │ TYPICAL RATING    │ WORST CLASS   │ KEY FACTORS
─────────────────────────────┼───────────────┼───────────────────┼───────────────┼────────────────────────────────
CARDIOVASCULAR:              │               │                   │               │
Hypertension (controlled)    │ Preferred     │ Standard          │ Table 4       │ # of meds, BP readings, duration
Hypertension (uncontrolled)  │ Standard      │ Table 2-4         │ Decline       │ BP levels, end-organ damage
Coronary Artery Disease      │ Table 2       │ Table 4-8         │ Decline       │ # vessels, ejection fraction
MI (heart attack) > 2yr      │ Table 2       │ Table 4-6         │ Decline       │ EF, subsequent events, risk factors
MI (heart attack) < 2yr      │ Table 8       │ Decline           │ Decline       │ Too recent for auto-UW
Atrial Fibrillation          │ Standard      │ Table 2-4         │ Table 8       │ Lone AFib vs structural, CHADS2
CABG Surgery > 2yr           │ Table 2       │ Table 4-8         │ Decline       │ # grafts, EF, subsequent events
Stent (PCI) > 1yr            │ Table 2       │ Table 4-6         │ Decline       │ # stents, EF, risk factors
Heart Valve Replacement      │ Table 2       │ Table 4-8         │ Decline       │ Valve type, EF, complications
Cardiomyopathy               │ Decline       │ Decline           │ Decline       │ KO rule
                             │               │                   │               │
DIABETES:                    │               │                   │               │
Type 2, diet controlled      │ Standard      │ Standard Plus     │ Table 2       │ HbA1c, duration, complications
Type 2, oral meds            │ Standard      │ Table 2           │ Table 4       │ HbA1c, # meds, complications
Type 2, insulin              │ Table 2       │ Table 4-6         │ Decline       │ HbA1c, complications, duration
Type 1                       │ Table 4       │ Table 6-8         │ Decline       │ HbA1c, complications, age onset
                             │               │                   │               │
CANCER (5+ years post-treatment):
Basal Cell Carcinoma         │ Preferred     │ Preferred         │ Standard      │ Almost always non-rated
Melanoma (Stage IA)          │ Standard      │ Standard Plus     │ Table 2       │ Breslow depth, clean margins
Melanoma (Stage IB-IIA)      │ Table 2       │ Table 4           │ Table 8       │ Stage, sentinel node, time since
Breast Cancer (Stage I)      │ Standard      │ Standard Plus     │ Table 2       │ Grade, ER/PR+, time since
Breast Cancer (Stage II)     │ Table 2       │ Table 4           │ Table 8       │ Node involvement, grade, time
Prostate Cancer (Gleason ≤6) │ Standard      │ Standard Plus     │ Table 2       │ PSA, Gleason, treatment
Prostate Cancer (Gleason 7+) │ Table 2       │ Table 4-8         │ Decline       │ Gleason, stage, PSA trajectory
Thyroid Cancer (papillary)   │ Preferred     │ Standard          │ Table 2       │ Stage, treatment response
Colon Cancer (Stage I)       │ Standard      │ Table 2           │ Table 4       │ Stage, margins, follow-up
Lung Cancer                  │ Table 4       │ Table 8           │ Decline       │ Type, stage, very poor prognosis
                             │               │                   │               │
RESPIRATORY:                 │               │                   │               │
Asthma (mild, controlled)    │ Preferred     │ Preferred         │ Standard      │ Meds, ER visits, PFTs
Asthma (moderate)            │ Standard      │ Standard Plus     │ Table 2       │ Daily meds, hospitalizations
COPD (mild, FEV1 > 80%)     │ Standard      │ Table 2           │ Table 4       │ FEV1, smoking status
COPD (moderate, FEV1 50-79%)│ Table 4       │ Table 6-8         │ Decline       │ FEV1, O2 use, exacerbations
Sleep Apnea (treated/CPAP)   │ Preferred     │ Standard          │ Table 2       │ BMI, compliance, AHI
Sleep Apnea (untreated)      │ Table 2       │ Table 4           │ Decline       │ Severity, BMI, comorbidities
                             │               │                   │               │
NEUROLOGICAL:                │               │                   │               │
Epilepsy (controlled)        │ Standard      │ Standard Plus     │ Table 4       │ Seizure-free years, # meds
Epilepsy (uncontrolled)      │ Table 4       │ Table 6-8         │ Decline       │ Seizure frequency, cause
Multiple Sclerosis (RRMS)    │ Table 2       │ Table 4-6         │ Decline       │ Relapse rate, disability
TIA (> 2 years)              │ Standard      │ Table 2           │ Table 4       │ Time since, risk factors
Stroke (> 2 years)           │ Table 2       │ Table 4-6         │ Decline       │ Type, residual deficit, time
Parkinson's (early)          │ Table 4       │ Table 6-8         │ Decline       │ Stage, functional status
                             │               │                   │               │
MENTAL HEALTH:               │               │                   │               │
Depression (mild, treated)   │ Preferred     │ Standard          │ Table 2       │ Hospitalizations, medications
Depression (severe)          │ Table 2       │ Table 4           │ Decline       │ Hospitalizations, SI, duration
Anxiety (treated)            │ Preferred     │ Standard          │ Table 2       │ Medications, functional impact
Bipolar Disorder             │ Table 2       │ Table 4-8         │ Decline       │ Hospitalizations, stability, meds
Schizophrenia                │ Table 8       │ Decline           │ Decline       │ Almost always decline auto-UW
                             │               │                   │               │
GASTROINTESTINAL:            │               │                   │               │
GERD                         │ Preferred     │ Preferred Plus    │ Standard      │ Almost always non-rated
Crohn's Disease (remission)  │ Standard      │ Table 2           │ Table 4       │ Surgeries, medications
Ulcerative Colitis (remiss.) │ Standard      │ Table 2           │ Table 4       │ Duration, extent, medications
Hepatitis B (recovered)      │ Standard      │ Standard          │ Table 2       │ Viral load, liver enzymes
Hepatitis C (cured/SVR)      │ Standard      │ Table 2           │ Table 4       │ Fibrosis stage, SVR confirmed
Fatty Liver (NAFLD)          │ Preferred     │ Standard          │ Table 2       │ Enzymes, BMI, progression
```

### 3.8 Financial Justification Rules

```
FINANCIAL JUSTIFICATION RULES

RULE FIN-001: Income Replacement Multiple
  IF purpose = "INCOME_REPLACEMENT":
    max_face = annual_income × age_factor
    WHERE age_factor:
      Age 18-35: 30×
      Age 36-45: 25×
      Age 46-55: 20×
      Age 56-60: 15×
      Age 61-65: 10×
      Age 66-70: 5×
      Age 71+:   3×

RULE FIN-002: Stay-at-Home Spouse
  IF purpose = "INCOME_REPLACEMENT" AND annual_income = 0
     AND marital_status = "MARRIED":
    max_face = MIN(spouse_income × 10, $1,000,000)

RULE FIN-003: Mortgage Protection
  IF purpose = "DEBT_COVERAGE":
    max_face = outstanding_mortgage × 1.1

RULE FIN-004: Business Loan Coverage
  IF purpose = "DEBT_COVERAGE" AND loan_type = "BUSINESS":
    max_face = outstanding_loan_balance
    REQUIRE_EVIDENCE("Business loan documentation")

RULE FIN-005: Key Person Coverage
  IF purpose = "KEY_PERSON":
    max_face = MIN(annual_revenue × 2, key_person_salary × 10)
    REQUIRE_EVIDENCE("Business financials", "Key person documentation")

RULE FIN-006: Buy-Sell Agreement
  IF purpose = "BUY_SELL":
    max_face = business_valuation × ownership_percentage
    REQUIRE_EVIDENCE("Buy-sell agreement", "Business valuation")

RULE FIN-007: Estate Tax Coverage
  IF purpose = "ESTATE_TAX":
    max_face = estimated_estate_tax_liability × 1.1
    REQUIRE_EVIDENCE("Estate planning documents", "Net worth statement")

RULE FIN-008: Total In-Force Check
  IF (existing_coverage + face_amount_requested) > max_face × 1.25:
    REFERRAL("Total coverage exceeds 125% of financial justification")

RULE FIN-009: STOLI Screening
  IF face_amount > 2,000,000
     AND (applicant_age > 70
          OR premium_financing = TRUE
          OR beneficiary_type = "TRUST" with trust_age < 6_months):
    REFERRAL("STOLI screening triggered")
    REQUIRE_EVIDENCE("Financial questionnaire", "Trust documents")
```

### 3.9 Risk Classification Aggregation Rules

```drools
package com.insurance.uw.rules.classification

rule "CLASS-001: Preferred Plus Eligibility"
    salience 100
    when
        $dec : UnderwritingDecision(
            totalDebitPoints <= 75,
            knockoutReasons.size() == 0,
            referralReasons.size() == 0
        )
        $app : Applicant(
            smokerStatus == "never",
            age <= 70
        )
        not MedicalCondition(rated == true)
        not Debit(category == "BUILD", points > 0)
        not Debit(category == "BP", points > 25)
        not Debit(category == "CHOLESTEROL", points > 25)
        not FamilyHistory(earlyCardiacDeath == true)
    then
        $dec.setRiskClass("PREFERRED_PLUS");
        update($dec);
end

rule "CLASS-002: Preferred Eligibility"
    salience 90
    when
        $dec : UnderwritingDecision(
            totalDebitPoints > 75,
            totalDebitPoints <= 150,
            knockoutReasons.size() == 0,
            referralReasons.size() == 0,
            riskClass == null
        )
        $app : Applicant(smokerStatus == "never")
    then
        $dec.setRiskClass("PREFERRED");
        update($dec);
end

rule "CLASS-003: Standard Plus"
    salience 80
    when
        $dec : UnderwritingDecision(
            totalDebitPoints > 150,
            totalDebitPoints <= 225,
            knockoutReasons.size() == 0,
            riskClass == null
        )
    then
        $dec.setRiskClass("STANDARD_PLUS");
        update($dec);
end

rule "CLASS-004: Standard"
    salience 70
    when
        $dec : UnderwritingDecision(
            totalDebitPoints > 225,
            totalDebitPoints <= 325,
            knockoutReasons.size() == 0,
            riskClass == null
        )
    then
        $dec.setRiskClass("STANDARD");
        update($dec);
end

rule "CLASS-010: Smoker Preferred Smoker"
    salience 95
    when
        $dec : UnderwritingDecision(
            totalDebitPoints <= 100,
            knockoutReasons.size() == 0,
            riskClass == null
        )
        $app : Applicant(
            smokerStatus in ("current", "recent"),
            cigarettesPerDay <= 20
        )
        not Debit(category == "RESPIRATORY", points > 50)
    then
        $dec.setRiskClass("PREFERRED_SMOKER");
        update($dec);
end

rule "CLASS-011: Smoker Standard Smoker"
    salience 85
    when
        $dec : UnderwritingDecision(
            totalDebitPoints > 100,
            totalDebitPoints <= 250,
            knockoutReasons.size() == 0,
            riskClass == null
        )
        $app : Applicant(smokerStatus in ("current", "recent"))
    then
        $dec.setRiskClass("STANDARD_SMOKER");
        update($dec);
end
```

### 3.10 Accelerated Underwriting Eligibility Rules

```
ACCELERATED UW ELIGIBILITY RULES

ACCEL-001: Age range (18-60)
ACCEL-002: Face amount ($25K-$1M)
ACCEL-003: No tobacco use within 5 years
ACCEL-004: BMI 18.5-32.0
ACCEL-005: No hazardous occupation
ACCEL-006: No hazardous avocation
ACCEL-007: No foreign travel (high-risk countries) planned
ACCEL-008: No MIB hits (significant codes)
ACCEL-009: No Rx for: insulin, anticoagulants, chemotherapy, opioids, antipsychotics
ACCEL-010: No Rx for more than 3 chronic conditions
ACCEL-011: No history of: cancer, heart disease, stroke, diabetes (insulin)
ACCEL-012: No hospitalization within 2 years
ACCEL-013: No surgery within 1 year
ACCEL-014: No DUI/DWI within 5 years
ACCEL-015: No felony conviction
ACCEL-016: No prior decline/postpone within 2 years
ACCEL-017: Credit-based mortality score in acceptable range
ACCEL-018: Rx-based risk score in acceptable range
ACCEL-019: Clinical data score (electronic health records) in acceptable range
ACCEL-020: Reflexive interview completed with no red flags
ACCEL-021: No inconsistencies between application and third-party data
ACCEL-022: No existing coverage exceeding financial justification
ACCEL-023: US citizen or permanent resident
ACCEL-024: Application completed within 30 days
ACCEL-025: Identity verification passed
```

**Decision logic:**

```python
def evaluate_accelerated_eligibility(case: UnderwritingCase) -> dict:
    disqualifiers = []

    if case.applicant_age < 18 or case.applicant_age > 60:
        disqualifiers.append("ACCEL-001: Age outside 18-60")

    if case.face_amount > 1_000_000:
        disqualifiers.append("ACCEL-002: Face amount exceeds $1M")

    if case.smoker_status in ("current", "recent"):
        disqualifiers.append("ACCEL-003: Tobacco use within 5 years")

    if case.bmi < 18.5 or case.bmi > 32.0:
        disqualifiers.append(f"ACCEL-004: BMI {case.bmi} outside 18.5-32.0")

    knockout_rx_classes = [
        "INSULIN", "ANTICOAGULANT", "CHEMOTHERAPY",
        "OPIOID", "ANTIPSYCHOTIC"
    ]
    for rx in case.rx_history:
        if rx['therapeutic_class'] in knockout_rx_classes:
            disqualifiers.append(f"ACCEL-009: Rx {rx['drug_name']} "
                                 f"in excluded class {rx['therapeutic_class']}")

    knockout_conditions = [
        "CANCER", "CAD", "MI", "STROKE", "CVA",
        "DIABETES_TYPE1", "INSULIN_DIABETES"
    ]
    for cond in case.medical_conditions:
        if cond['category'] in knockout_conditions:
            disqualifiers.append(f"ACCEL-011: Condition {cond['description']} "
                                 f"disqualifies accelerated UW")

    if case.credit_mortality_score > 750:
        disqualifiers.append("ACCEL-017: Credit mortality score exceeds threshold")

    if case.rx_risk_score > 80:
        disqualifiers.append("ACCEL-018: Rx risk score exceeds threshold")

    return {
        "eligible": len(disqualifiers) == 0,
        "disqualifiers": disqualifiers,
        "path": "ACCELERATED" if len(disqualifiers) == 0 else "FULL_UW"
    }
```

---

## 4. Decision Table Design

### 4.1 Build Chart Decision Table (Full DMN)

```
╔══════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Build Assessment                                               ║
║  Hit Policy: UNIQUE (U)                                                         ║
║  Input: gender (string), height_inches (number), weight_lbs (number)            ║
║  Output: build_class (string), build_debits (number)                            ║
╠══════╦════════╦══════════════════╦══════════════════╦═══════════════╦════════════╣
║ Rule ║ Gender ║ Height (inches)  ║ Weight (lbs)     ║ Build Class   ║ Debits    ║
╠══════╬════════╬══════════════════╬══════════════════╬═══════════════╬════════════╣
║  1   ║  "M"   ║  [60..78]        ║  < min_pp(h)     ║ "DECLINE_UW"  ║  999      ║
║  2   ║  "M"   ║  [60..78]        ║  [min_pp(h)..    ║ "PREF_PLUS"   ║  0        ║
║      ║        ║                  ║   max_pp(h)]     ║               ║           ║
║  3   ║  "M"   ║  [60..78]        ║  (max_pp(h)..    ║ "PREFERRED"   ║  25       ║
║      ║        ║                  ║   max_pf(h)]     ║               ║           ║
║  4   ║  "M"   ║  [60..78]        ║  (max_pf(h)..    ║ "STANDARD"    ║  75       ║
║      ║        ║                  ║   max_std(h)]    ║               ║           ║
║  5   ║  "M"   ║  [60..78]        ║  (max_std(h)..   ║ "TABLE_2"     ║  150      ║
║      ║        ║                  ║   max_t2(h)]     ║               ║           ║
║  6   ║  "M"   ║  [60..78]        ║  (max_t2(h)..    ║ "TABLE_4"     ║  250      ║
║      ║        ║                  ║   max_t4(h)]     ║               ║           ║
║  7   ║  "M"   ║  [60..78]        ║  > max_t4(h)     ║ "DECLINE_BLD" ║  999      ║
║  8   ║  "F"   ║  [58..73]        ║  < min_pp(h)     ║ "DECLINE_UW"  ║  999      ║
║  9   ║  "F"   ║  [58..73]        ║  [min_pp(h)..    ║ "PREF_PLUS"   ║  0        ║
║      ║        ║                  ║   max_pp(h)]     ║               ║           ║
║ 10   ║  "F"   ║  [58..73]        ║  (max_pp(h)..    ║ "PREFERRED"   ║  25       ║
║      ║        ║                  ║   max_pf(h)]     ║               ║           ║
║ 11   ║  "F"   ║  [58..73]        ║  (max_pf(h)..    ║ "STANDARD"    ║  75       ║
║      ║        ║                  ║   max_std(h)]    ║               ║           ║
║ 12   ║  "F"   ║  [58..73]        ║  (max_std(h)..   ║ "TABLE_2"     ║  150      ║
║      ║        ║                  ║   max_t2(h)]     ║               ║           ║
║ 13   ║  "F"   ║  [58..73]        ║  (max_t2(h)..    ║ "TABLE_4"     ║  250      ║
║      ║        ║                  ║   max_t4(h)]     ║               ║           ║
║ 14   ║  "F"   ║  [58..73]        ║  > max_t4(h)     ║ "DECLINE_BLD" ║  999      ║
╚══════╩════════╩══════════════════╩══════════════════╩═══════════════╩════════════╝

NOTE: min_pp(h), max_pp(h), etc. are lookup functions into the build chart
      reference table (Section 3.4) keyed on height.
```

### 4.2 Blood Pressure Classification Decision Table

```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Blood Pressure Classification                                      ║
║  Hit Policy: FIRST (F) — use HIGHEST classification when both systolic/diastolic hit║
║  Input: systolic_bp (number), diastolic_bp (number)                                 ║
║  Output: bp_class (string), bp_debits (number), bp_action (string)                  ║
╠══════╦════════════════╦═════════════════╦══════════════════╦══════════╦══════════════╣
║ Rule ║ Systolic       ║ Diastolic       ║ BP Class         ║ Debits   ║ Action       ║
╠══════╬════════════════╬═════════════════╬══════════════════╬══════════╬══════════════╣
║  1   ║ >= 180         ║ -               ║ "CRISIS"         ║  999     ║ "KNOCKOUT"   ║
║  2   ║ -              ║ >= 120          ║ "CRISIS"         ║  999     ║ "KNOCKOUT"   ║
║  3   ║ [160..179]     ║ -               ║ "STAGE2_SEVERE"  ║  200     ║ "REFER"      ║
║  4   ║ -              ║ [100..119]      ║ "STAGE2_SEVERE"  ║  200     ║ "REFER"      ║
║  5   ║ [140..159]     ║ -               ║ "STAGE2"         ║  100     ║ "RATE"       ║
║  6   ║ -              ║ [90..99]        ║ "STAGE2"         ║  100     ║ "RATE"       ║
║  7   ║ [130..139]     ║ -               ║ "STAGE1"         ║  50      ║ "RATE"       ║
║  8   ║ -              ║ [80..89]        ║ "STAGE1"         ║  50      ║ "RATE"       ║
║  9   ║ [120..129]     ║ < 80            ║ "ELEVATED"       ║  15      ║ "NOTE"       ║
║ 10   ║ < 120          ║ < 80            ║ "OPTIMAL"        ║  0       ║ "NONE"       ║
║ 11   ║ < 90           ║ < 60            ║ "HYPOTENSION"    ║  25      ║ "INVESTIGATE"║
╚══════╩════════════════╩═════════════════╩══════════════════╩══════════╩══════════════╝

AGGREGATION RULE: When systolic and diastolic produce different classes,
use the WORSE (higher debit) classification.
```

### 4.3 Cholesterol Assessment Decision Table

```
╔══════════════════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Cholesterol Assessment                                                      ║
║  Hit Policy: UNIQUE (U) — multi-dimensional                                                  ║
║  Input: total_chol (mg/dL), ldl (mg/dL), hdl (mg/dL), ratio (total/hdl)                    ║
║  Output: chol_class (string), chol_debits (number)                                           ║
╠══════╦══════════════╦═══════════╦═══════════╦══════════╦═══════════════════╦══════════════════╣
║ Rule ║ Total Chol   ║ LDL       ║ HDL       ║ Ratio    ║ Chol Class        ║ Debits           ║
╠══════╬══════════════╬═══════════╬═══════════╬══════════╬═══════════════════╬══════════════════╣
║  1   ║ < 200        ║ < 100     ║ >= 60     ║ < 4.0    ║ "OPTIMAL"         ║ 0                ║
║  2   ║ < 200        ║ < 130     ║ >= 40     ║ < 5.0    ║ "DESIRABLE"       ║ 10               ║
║  3   ║ 200..239     ║ < 130     ║ >= 40     ║ < 5.0    ║ "BORDERLINE_OK"   ║ 25               ║
║  4   ║ 200..239     ║ 130..159  ║ >= 40     ║ 5.0..5.9 ║ "BORDERLINE_HIGH" ║ 50               ║
║  5   ║ 200..239     ║ 130..159  ║ < 40      ║ >= 6.0   ║ "HIGH_RISK"       ║ 100              ║
║  6   ║ 240..279     ║ < 160     ║ >= 40     ║ < 6.0    ║ "HIGH_MANAGED"    ║ 75               ║
║  7   ║ 240..279     ║ 160..189  ║ -         ║ -        ║ "HIGH"            ║ 125              ║
║  8   ║ >= 280       ║ -         ║ -         ║ -        ║ "VERY_HIGH"       ║ 175              ║
║  9   ║ -            ║ >= 190    ║ -         ║ -        ║ "CRITICAL_LDL"    ║ 200              ║
║ 10   ║ -            ║ -         ║ < 35(M)   ║ -        ║ "CRITICAL_LOW_HDL"║ 125              ║
║ 11   ║ -            ║ -         ║ < 40(F)   ║ -        ║ "CRITICAL_LOW_HDL"║ 125              ║
║ 12   ║ -            ║ -         ║ -         ║ >= 7.0   ║ "CRITICAL_RATIO"  ║ 150              ║
╚══════╩══════════════╩═══════════╩═══════════╩══════════╩═══════════════════╩══════════════════╝
```

### 4.4 Diabetes Rating Decision Table

```
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Diabetes Assessment & Rating                                                                ║
║  Hit Policy: UNIQUE (U)                                                                                      ║
║  Input: diabetes_type, hba1c, years_since_dx, treatment, complications                                      ║
║  Output: diabetes_class (string), diabetes_debits (number), action (string)                                  ║
╠══════╦══════════╦═══════════╦══════════════╦═══════════════╦══════════════════╦═══════════╦════════╦══════════╣
║ Rule ║ Type     ║ HbA1c (%) ║ Years Since  ║ Treatment     ║ Complications    ║ Class     ║ Debits ║ Action   ║
╠══════╬══════════╬═══════════╬══════════════╬═══════════════╬══════════════════╬═══════════╬════════╬══════════╣
║  1   ║ PreDM    ║ 5.7-6.4   ║ -            ║ "NONE"/"DIET" ║ None             ║ STD_PLUS  ║ 25     ║ Monitor  ║
║  2   ║ Type 2   ║ < 6.5     ║ > 2          ║ "DIET"        ║ None             ║ STD_PLUS  ║ 50     ║ -        ║
║  3   ║ Type 2   ║ 6.5-6.9   ║ > 2          ║ "DIET"        ║ None             ║ STANDARD  ║ 75     ║ -        ║
║  4   ║ Type 2   ║ < 7.0     ║ > 2          ║ "ORAL_MONO"   ║ None             ║ STANDARD  ║ 100    ║ -        ║
║  5   ║ Type 2   ║ 7.0-7.4   ║ > 2          ║ "ORAL_MONO"   ║ None             ║ TABLE_2   ║ 150    ║ -        ║
║  6   ║ Type 2   ║ 7.0-7.4   ║ > 2          ║ "ORAL_MULTI"  ║ None             ║ TABLE_2   ║ 175    ║ -        ║
║  7   ║ Type 2   ║ 7.5-7.9   ║ > 2          ║ "ORAL_MULTI"  ║ None             ║ TABLE_4   ║ 225    ║ -        ║
║  8   ║ Type 2   ║ < 7.5     ║ > 2          ║ "INSULIN"     ║ None             ║ TABLE_4   ║ 250    ║ -        ║
║  9   ║ Type 2   ║ 7.5-8.0   ║ -            ║ "INSULIN"     ║ None             ║ TABLE_6   ║ 350    ║ -        ║
║ 10   ║ Type 2   ║ > 8.0     ║ -            ║ any           ║ None             ║ TABLE_8   ║ 500    ║ REFER    ║
║ 11   ║ Type 2   ║ -         ║ -            ║ any           ║ Neuropathy       ║ +TABLE_2  ║ +100   ║ REFER    ║
║ 12   ║ Type 2   ║ -         ║ -            ║ any           ║ Retinopathy(NP)  ║ +TABLE_2  ║ +100   ║ REFER    ║
║ 13   ║ Type 2   ║ -         ║ -            ║ any           ║ Retinopathy(P)   ║ DECLINE   ║ 999    ║ KNOCKOUT ║
║ 14   ║ Type 2   ║ -         ║ -            ║ any           ║ Nephropathy      ║ +TABLE_4  ║ +200   ║ REFER    ║
║ 15   ║ Type 2   ║ -         ║ < 1          ║ any           ║ any              ║ POSTPONE  ║ 999    ║ POSTPONE ║
║ 16   ║ Type 1   ║ < 7.0     ║ > 5          ║ "INSULIN"     ║ None             ║ TABLE_4   ║ 250    ║ -        ║
║ 17   ║ Type 1   ║ 7.0-8.0   ║ > 5          ║ "INSULIN"     ║ None             ║ TABLE_6   ║ 375    ║ -        ║
║ 18   ║ Type 1   ║ > 8.0     ║ -            ║ "INSULIN"     ║ None             ║ TABLE_8   ║ 500    ║ REFER    ║
║ 19   ║ Type 1   ║ -         ║ -            ║ "INSULIN"     ║ Any              ║ DECLINE   ║ 999    ║ KNOCKOUT ║
║ 20   ║ Type 1   ║ -         ║ < 2          ║ any           ║ any              ║ POSTPONE  ║ 999    ║ POSTPONE ║
║ 21   ║ any      ║ > 10.0    ║ -            ║ any           ║ -                ║ DECLINE   ║ 999    ║ KNOCKOUT ║
╚══════╩══════════╩═══════════╩══════════════╩═══════════════╩══════════════════╩═══════════╩════════╩══════════╝
```

### 4.5 Family History Assessment Decision Table

```
╔════════════════════════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Family History Assessment                                                        ║
║  Hit Policy: COLLECT SUM (C+) — debits from all matching family members                          ║
║  Input: relationship, condition, age_at_event                                                     ║
║  Output: fh_debits (number), fh_action (string)                                                  ║
╠══════╦════════════════╦═══════════════════════════╦═══════════════════╦═══════════╦═══════════════╣
║ Rule ║ Relationship   ║ Condition                 ║ Age at Event      ║ Debits    ║ Action        ║
╠══════╬════════════════╬═══════════════════════════╬═══════════════════╬═══════════╬═══════════════╣
║  1   ║ Parent         ║ Cardiac death             ║ < 60              ║ 75        ║ RATE          ║
║  2   ║ Parent         ║ Cardiac death             ║ 60-65             ║ 50        ║ RATE          ║
║  3   ║ Parent         ║ Cardiac death             ║ > 65              ║ 0         ║ -             ║
║  4   ║ Sibling        ║ Cardiac death             ║ < 60              ║ 75        ║ RATE          ║
║  5   ║ Sibling        ║ Cardiac death             ║ 60-65             ║ 50        ║ RATE          ║
║  6   ║ Parent         ║ Stroke                    ║ < 60              ║ 50        ║ RATE          ║
║  7   ║ Parent         ║ Cancer (any)              ║ < 50              ║ 50        ║ RATE          ║
║  8   ║ Parent         ║ Cancer (any)              ║ 50-60             ║ 25        ║ NOTE          ║
║  9   ║ Parent         ║ Diabetes (Type 1)         ║ any               ║ 25        ║ NOTE          ║
║ 10   ║ Sibling        ║ Diabetes (Type 1)         ║ any               ║ 25        ║ NOTE          ║
║ 11   ║ Parent         ║ Huntington's              ║ any               ║ REFER     ║ REFER         ║
║ 12   ║ 2+ 1st degree  ║ Cardiac death             ║ Both < 60         ║ 125       ║ RATE/REFER    ║
║ 13   ║ 2+ 1st degree  ║ Same cancer type          ║ Both < 50         ║ 100       ║ RATE/REFER    ║
║ 14   ║ Parent         ║ Polycystic Kidney Disease  ║ any               ║ 50        ║ REQUEST_TEST  ║
║ 15   ║ Parent         ║ BRCA-related cancer        ║ < 50              ║ 75        ║ RATE/REFER    ║
╚══════╩════════════════╩═══════════════════════════╩═══════════════════╩═══════════╩═══════════════╝

CAPS:
  - Maximum family history debits: 150 (per carrier guidelines)
  - Family history alone cannot decline — only rate or refer
  - 2+ first-degree relatives with same condition: consider referral
```

### 4.6 Financial Justification Decision Table

```
╔══════════════════════════════════════════════════════════════════════════════════════════════════╗
║  DECISION TABLE: Financial Justification                                                        ║
║  Hit Policy: FIRST (F) — first match determines maximum face amount                            ║
║  Input: age, annual_income, net_worth, purpose, existing_coverage                               ║
║  Output: max_face (number), fin_action (string)                                                 ║
╠══════╦══════════╦═══════════════╦═══════════════╦══════════════════╦════════════╦═══════════════╣
║ Rule ║ Age      ║ Annual Income ║ Net Worth     ║ Purpose          ║ Max Face   ║ Action        ║
╠══════╬══════════╬═══════════════╬═══════════════╬══════════════════╬════════════╬═══════════════╣
║  1   ║ 18-35    ║ >= $50K       ║ -             ║ INCOME_REPLACE   ║ 30× income ║ AUTO          ║
║  2   ║ 36-45    ║ >= $50K       ║ -             ║ INCOME_REPLACE   ║ 25× income ║ AUTO          ║
║  3   ║ 46-50    ║ >= $50K       ║ -             ║ INCOME_REPLACE   ║ 20× income ║ AUTO          ║
║  4   ║ 51-55    ║ >= $50K       ║ -             ║ INCOME_REPLACE   ║ 15× income ║ AUTO          ║
║  5   ║ 56-60    ║ >= $75K       ║ -             ║ INCOME_REPLACE   ║ 12× income ║ AUTO          ║
║  6   ║ 61-65    ║ >= $100K      ║ -             ║ INCOME_REPLACE   ║ 10× income ║ REQ_FIN_DOCS  ║
║  7   ║ 66-70    ║ >= $100K      ║ -             ║ INCOME_REPLACE   ║ 5× income  ║ REQ_FIN_DOCS  ║
║  8   ║ 71+      ║ -             ║ >= $1M        ║ ESTATE_PLAN      ║ est. tax   ║ REQ_FIN_DOCS  ║
║  9   ║ -        ║ -             ║ -             ║ MORTGAGE         ║ 110% of bal║ REQ_MORTGAGE  ║
║ 10   ║ -        ║ -             ║ -             ║ KEY_PERSON       ║ see formula║ REQ_BIZ_DOCS  ║
║ 11   ║ -        ║ -             ║ -             ║ BUY_SELL         ║ valuation  ║ REQ_BUY_SELL  ║
║ 12   ║ -        ║ < $25K        ║ < $100K       ║ INCOME_REPLACE   ║ $250K cap  ║ SIMPLIFIED    ║
║ 13   ║ -        ║ $25K-$49K     ║ -             ║ INCOME_REPLACE   ║ $500K cap  ║ AUTO          ║
╚══════╩══════════╩═══════════════╩═══════════════╩══════════════════╩════════════╩═══════════════╝
```

---

## 5. Rule Versioning & Governance

### 5.1 Version Control Strategy

```
RULE VERSIONING MODEL

┌─────────────────────────────────────────────────────────────────────────────┐
│                         RULE VERSION LIFECYCLE                              │
│                                                                             │
│  DRAFT ──▶ REVIEW ──▶ APPROVED ──▶ STAGED ──▶ ACTIVE ──▶ DEPRECATED       │
│    │          │          │           │          │            │               │
│    │          │          │           │          │            ▼               │
│    │          ▼          │           │          │        ARCHIVED            │
│    │       REJECTED      │           │          │                            │
│    │          │          │           │          │                            │
│    └──────────┘          │           │          │                            │
│  (back to draft)         │           │          │                            │
│                          │           │          │                            │
│  Effective Date ─────────┘           │          │                            │
│  A/B Assignment ─────────────────────┘          │                            │
│  Sunset Date ───────────────────────────────────┘                            │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Version schema:**

```json
{
  "rule_id": "BUILD-003",
  "version": "2.1.0",
  "semantic_version": {
    "major": 2,
    "minor": 1,
    "patch": 0
  },
  "status": "ACTIVE",
  "effective_date": "2025-01-15T00:00:00Z",
  "expiration_date": null,
  "author": "jane.smith@insurance.com",
  "approver": "john.doe@insurance.com",
  "approval_date": "2025-01-10T14:30:00Z",
  "change_description": "Updated male preferred plus BMI range from 18.5-25.0 to 18.5-25.9",
  "change_category": "MEDICAL_GUIDELINES_UPDATE",
  "impact_analysis": {
    "estimated_cases_affected_pct": 3.2,
    "estimated_stp_impact": "+0.5%",
    "estimated_mortality_impact": "Neutral",
    "regression_tests_passed": true,
    "backward_compatible": true
  },
  "rollback_version": "2.0.0",
  "ab_test_group": null,
  "rule_content_hash": "sha256:a1b2c3d4..."
}
```

### 5.2 A/B Testing Rules

```python
class RuleABTest:
    def __init__(self, test_id: str, control_version: str,
                 treatment_version: str, traffic_pct: float):
        self.test_id = test_id
        self.control_version = control_version
        self.treatment_version = treatment_version
        self.traffic_pct = traffic_pct
        self.start_date = None
        self.end_date = None
        self.metrics = {
            "stp_rate": {"control": [], "treatment": []},
            "average_debits": {"control": [], "treatment": []},
            "decline_rate": {"control": [], "treatment": []},
            "referral_rate": {"control": [], "treatment": []},
            "cycle_time": {"control": [], "treatment": []}
        }

    def assign_group(self, case_id: str) -> str:
        hash_val = int(hashlib.md5(
            f"{self.test_id}:{case_id}".encode()).hexdigest(), 16)
        if (hash_val % 100) < (self.traffic_pct * 100):
            return "treatment"
        return "control"

    def get_rule_version(self, case_id: str) -> str:
        group = self.assign_group(case_id)
        if group == "treatment":
            return self.treatment_version
        return self.control_version
```

### 5.3 Rule Promotion Pipeline

```
RULE PROMOTION PIPELINE

┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│   DEV    │───▶│   TEST   │───▶│ STAGING  │───▶│   PROD   │
│          │    │          │    │          │    │          │
│ Author   │    │ Auto +   │    │ Pre-prod │    │ Canary   │
│ edits    │    │ manual   │    │ UAT      │    │ → Full   │
│ rules    │    │ testing  │    │          │    │ rollout  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │               │               │
     ▼               ▼               ▼               ▼
  Peer Review    Unit Tests      Regression      Canary (5%)
  Lint Check     Integration     Parallel Run    Monitoring
  Impact Est.    Boundary        Actuarial       Full (100%)
                 Golden Cases    Sign-off        Post-deploy
                                                 monitoring
```

**Gate criteria between stages:**

| Gate | Criteria |
|------|----------|
| DEV → TEST | Peer review approved, rule syntax valid, no conflicting rules detected |
| TEST → STAGING | All unit tests pass, boundary tests pass, golden case regression < 1% deviation |
| STAGING → PROD | UAT sign-off, actuarial review (if mortality-impacting), compliance review (if state-specific), parallel run results acceptable |
| PROD Canary → Full | Canary STP rate within 2% of baseline, no unexpected knockouts, no error rate increase, monitoring dashboards green for 24 hours |

### 5.4 Rollback Strategy

```
ROLLBACK PROCEDURES

IMMEDIATE ROLLBACK (< 5 minutes):
  1. Rule engine maintains previous KJAR/rule package in hot standby
  2. Feature flag switches rule version instantly
  3. No redeployment needed — runtime version switch
  4. Audit log records rollback event with reason

  Trigger conditions:
  - STP rate drops > 5% from baseline
  - Decline rate increases > 2% from baseline
  - Error rate exceeds 0.1%
  - Manual trigger by rule admin

SCHEDULED ROLLBACK (planned):
  1. Create rollback ticket with justification
  2. Test rollback version in staging
  3. Schedule deployment window
  4. Execute rollback with full audit trail
  5. Notify stakeholders

RULE VERSION COEXISTENCE:
  - Active rules coexist with previous version for N days
  - New applications use new version
  - In-flight applications continue with version they started
  - Ensures consistency within a single application lifecycle
```

### 5.5 Rule Change Impact Analysis

```python
def analyze_rule_change_impact(old_rule, new_rule, test_population):
    """
    Runs both rule versions against a test population
    and compares outcomes.
    """
    results = {
        "population_size": len(test_population),
        "cases_affected": 0,
        "class_changes": defaultdict(int),
        "debit_delta_distribution": [],
        "new_knockouts": 0,
        "removed_knockouts": 0,
        "stp_impact": 0
    }

    for case in test_population:
        old_result = execute_rule(old_rule, case)
        new_result = execute_rule(new_rule, case)

        if old_result != new_result:
            results["cases_affected"] += 1

            if old_result.risk_class != new_result.risk_class:
                change_key = f"{old_result.risk_class} → {new_result.risk_class}"
                results["class_changes"][change_key] += 1

            debit_delta = new_result.total_debits - old_result.total_debits
            results["debit_delta_distribution"].append(debit_delta)

            if new_result.knocked_out and not old_result.knocked_out:
                results["new_knockouts"] += 1
            elif old_result.knocked_out and not new_result.knocked_out:
                results["removed_knockouts"] += 1

    results["affected_pct"] = (results["cases_affected"] /
                               results["population_size"]) * 100
    results["avg_debit_delta"] = (
        sum(results["debit_delta_distribution"]) /
        max(len(results["debit_delta_distribution"]), 1)
    )

    return results
```

---

## 6. Rule Conflict Resolution

### 6.1 Types of Rule Conflicts in Underwriting

| Conflict Type | Example | Resolution Strategy |
|--------------|---------|-------------------|
| **Contradictory** | Rule A says "Preferred" and Rule B says "Decline" for same condition | Priority-based |
| **Overlapping** | Two BP rules both fire for systolic=135, diastolic=85 | Specificity-based |
| **Redundant** | Both a diabetes rule and a general HbA1c rule fire and assign debits | Category cap |
| **Interaction** | Smoking + hypertension together are worse than sum of individual debits | Interaction rules |
| **Temporal** | Old rule still active while new rule should replace it | Version precedence |

### 6.2 Priority-Based Resolution

```drools
// Higher salience = higher priority
rule "KO-001: Active Cancer — KNOCKOUT"
    salience 10000    // Knockouts always win
    when ...
    then ...
end

rule "BUILD-003: Male Preferred Plus Build"
    salience 800      // Build rules medium priority
    when ...
    then ...
end

rule "CLASS-001: Preferred Plus Eligibility"
    salience 100      // Classification runs last
    when ...
    then ...
end

// Salience ranges:
//   10000-9000: Knockout rules (absolute priority)
//    9000-8000: Eligibility rules
//    8000-7000: Evidence requirement rules
//    7000-6000: Data validation/normalization rules
//    6000-5000: Medical condition assessment rules
//    5000-4000: Lab interpretation rules
//    4000-3000: Rx interpretation rules
//    3000-2000: Lifestyle/financial rules
//    2000-1000: Debit aggregation rules
//    1000-500:  Risk class determination rules
//     500-100:  Override/exception rules
//     100-0:    Reporting/audit rules
```

### 6.3 Specificity-Based Resolution

```
SPECIFICITY RESOLUTION EXAMPLE

RULE A (general):
  IF smoker_status = "current" THEN add_debit(TOBACCO, 100)

RULE B (specific):
  IF smoker_status = "current" AND cigarettes_per_day <= 10
     AND last_smoke_date > 1_year_ago
  THEN add_debit(TOBACCO, 50)

RESOLUTION: Rule B is MORE specific (more conditions).
            When both match, Rule B takes precedence.
            Rule A only fires when Rule B does NOT match.

IMPLEMENTATION in Drools:
  rule "TOBACCO-001: General Smoker"
      salience 500
      when
          $app : Applicant(smokerStatus == "current")
          not Debit(category == "TOBACCO")  // Only if no TOBACCO debit yet
          $dec : UnderwritingDecision()
      then
          $dec.addDebit(new Debit("TOBACCO", "Current smoker", 100, "TOBACCO-001"));
          update($dec);
  end

  rule "TOBACCO-002: Light Smoker"
      salience 600  // Higher priority than general
      when
          $app : Applicant(
              smokerStatus == "current",
              cigarettesPerDay <= 10
          )
          $dec : UnderwritingDecision()
      then
          $dec.addDebit(new Debit("TOBACCO", "Light smoker ≤10/day", 50, "TOBACCO-002"));
          update($dec);
  end
```

### 6.4 Category Caps and Interaction Handling

```python
CATEGORY_CAPS = {
    "BUILD": 250,
    "BP": 200,
    "CHOLESTEROL": 200,
    "DIABETES": 500,
    "CARDIAC": 500,
    "RESPIRATORY": 300,
    "CANCER": 500,
    "MENTAL_HEALTH": 200,
    "LIVER": 200,
    "KIDNEY": 300,
    "FAMILY_HISTORY": 150,
    "LIFESTYLE": 200,
    "TOBACCO": 150,
    "MVR": 150,
    "FINANCIAL": 0,
}

INTERACTION_RULES = [
    {
        "id": "INTER-001",
        "name": "Smoking + Hypertension Interaction",
        "conditions": ["TOBACCO > 0", "BP > 50"],
        "action": "MULTIPLY",
        "factor": 1.25,
        "description": "Smoking with hypertension — 25% multiplicative penalty"
    },
    {
        "id": "INTER-002",
        "name": "Diabetes + Obesity Interaction",
        "conditions": ["DIABETES > 0", "BUILD > 50"],
        "action": "ADD",
        "additional_debits": 50,
        "description": "Diabetes with obesity — 50 additional debits"
    },
    {
        "id": "INTER-003",
        "name": "Smoking + Cholesterol Interaction",
        "conditions": ["TOBACCO > 0", "CHOLESTEROL > 35"],
        "action": "MULTIPLY",
        "factor": 1.15,
        "description": "Smoking with elevated cholesterol — 15% multiplicative penalty"
    },
    {
        "id": "INTER-004",
        "name": "Cardiac + Diabetes Interaction",
        "conditions": ["CARDIAC > 50", "DIABETES > 50"],
        "action": "ADD",
        "additional_debits": 100,
        "description": "Cardiac condition with diabetes — 100 additional debits"
    },
    {
        "id": "INTER-005",
        "name": "Multiple Family History Credit",
        "conditions": ["FAMILY_HISTORY == 0"],
        "action": "CREDIT",
        "credit_points": -25,
        "description": "Clean family history — 25 point credit"
    }
]

def apply_caps_and_interactions(debits_by_category):
    # Apply per-category caps
    capped = {}
    for category, points in debits_by_category.items():
        cap = CATEGORY_CAPS.get(category, 999)
        capped[category] = min(points, cap)

    # Apply interaction rules
    total = sum(capped.values())
    interaction_adjustments = 0

    for rule in INTERACTION_RULES:
        if evaluate_interaction_conditions(rule["conditions"], capped):
            if rule["action"] == "MULTIPLY":
                categories = extract_categories(rule["conditions"])
                for cat in categories:
                    adjustment = int(capped[cat] * (rule["factor"] - 1))
                    interaction_adjustments += adjustment
            elif rule["action"] == "ADD":
                interaction_adjustments += rule["additional_debits"]
            elif rule["action"] == "CREDIT":
                interaction_adjustments += rule["credit_points"]

    return total + interaction_adjustments
```

---

## 7. Rule Testing Strategy

### 7.1 Unit Testing Rules

```java
public class BuildRuleTest {

    private KieSession session;

    @Before
    public void setup() {
        KieServices ks = KieServices.Factory.get();
        KieContainer kc = ks.getKieClasspathContainer();
        session = kc.newKieSession("BuildRulesSession");
    }

    @After
    public void tearDown() {
        session.dispose();
    }

    @Test
    public void testMaleOptimalBMI() {
        Applicant app = new Applicant();
        app.setGender("M");
        app.setHeightInches(70);
        app.setWeightLbs(170);
        // BMI = (170 * 703) / (70 * 70) = 24.4

        UnderwritingDecision dec = new UnderwritingDecision();
        session.insert(app);
        session.insert(dec);
        session.fireAllRules();

        assertEquals(0, dec.getBuildDebits());
        assertFalse(dec.getKnockoutReasons().stream()
            .anyMatch(k -> k.contains("BMI")));
    }

    @Test
    public void testMaleOverweightBMI() {
        Applicant app = new Applicant();
        app.setGender("M");
        app.setHeightInches(70);
        app.setWeightLbs(200);
        // BMI = (200 * 703) / (70 * 70) = 28.7

        UnderwritingDecision dec = new UnderwritingDecision();
        session.insert(app);
        session.insert(dec);
        session.fireAllRules();

        assertEquals(25, dec.getBuildDebits());
    }

    @Test
    public void testMaleDeclineBMI() {
        Applicant app = new Applicant();
        app.setGender("M");
        app.setHeightInches(70);
        app.setWeightLbs(120);
        // BMI = (120 * 703) / (70 * 70) = 17.2

        UnderwritingDecision dec = new UnderwritingDecision();
        session.insert(app);
        session.insert(dec);
        session.fireAllRules();

        assertTrue(dec.getKnockoutReasons().stream()
            .anyMatch(k -> k.contains("underweight")));
    }

    @Test
    public void testBMIBoundary_25_9() {
        Applicant app = new Applicant();
        app.setGender("M");
        app.setBmi(25.9);

        UnderwritingDecision dec = new UnderwritingDecision();
        session.insert(app);
        session.insert(dec);
        session.fireAllRules();

        assertEquals(0, dec.getBuildDebits());
    }

    @Test
    public void testBMIBoundary_26_0() {
        Applicant app = new Applicant();
        app.setGender("M");
        app.setBmi(26.0);

        UnderwritingDecision dec = new UnderwritingDecision();
        session.insert(app);
        session.insert(dec);
        session.fireAllRules();

        assertEquals(25, dec.getBuildDebits());
    }
}
```

### 7.2 Golden Case Regression Testing

```python
GOLDEN_CASES = [
    {
        "case_id": "GC-001",
        "description": "Healthy 35M non-smoker — Preferred Plus",
        "input": {
            "age": 35, "gender": "M", "smoker": "never",
            "bmi": 24.0, "systolic": 118, "diastolic": 76,
            "total_chol": 185, "ldl": 95, "hdl": 62,
            "hba1c": 5.2, "face_amount": 500000,
            "conditions": [], "rx": []
        },
        "expected": {
            "risk_class": "PREFERRED_PLUS",
            "total_debits_range": [0, 50],
            "knockouts": 0,
            "stp": True
        }
    },
    {
        "case_id": "GC-002",
        "description": "45M controlled HTN on lisinopril — Standard",
        "input": {
            "age": 45, "gender": "M", "smoker": "never",
            "bmi": 28.5, "systolic": 132, "diastolic": 84,
            "total_chol": 220, "ldl": 135, "hdl": 48,
            "hba1c": 5.5, "face_amount": 500000,
            "conditions": [{"code": "I10", "desc": "Hypertension"}],
            "rx": [{"name": "Lisinopril", "class": "ACE_INHIBITOR"}]
        },
        "expected": {
            "risk_class": "STANDARD",
            "total_debits_range": [175, 275],
            "knockouts": 0,
            "stp": True
        }
    },
    {
        "case_id": "GC-003",
        "description": "55F Type 2 DM on metformin — Table 2",
        "input": {
            "age": 55, "gender": "F", "smoker": "never",
            "bmi": 31.0, "systolic": 128, "diastolic": 78,
            "total_chol": 195, "ldl": 110, "hdl": 55,
            "hba1c": 6.8, "face_amount": 250000,
            "conditions": [{"code": "E11", "desc": "Type 2 Diabetes"}],
            "rx": [{"name": "Metformin", "class": "BIGUANIDE"}]
        },
        "expected": {
            "risk_class": "TABLE_2",
            "total_debits_range": [250, 375],
            "knockouts": 0,
            "stp": True
        }
    },
    {
        "case_id": "GC-004",
        "description": "40M active cancer — Decline",
        "input": {
            "age": 40, "gender": "M", "smoker": "never",
            "bmi": 25.0, "systolic": 120, "diastolic": 78,
            "face_amount": 500000,
            "conditions": [{"code": "C34", "desc": "Lung cancer",
                           "dx_date": "2024-06-15", "status": "ACTIVE"}],
            "rx": [{"name": "Pembrolizumab", "class": "CHEMOTHERAPY"}]
        },
        "expected": {
            "risk_class": "DECLINE",
            "knockouts": 1,
            "stp": False
        }
    }
]

def run_golden_case_regression(engine, golden_cases):
    results = {"passed": 0, "failed": 0, "failures": []}

    for gc in golden_cases:
        case = build_case(gc["input"])
        actual = engine.execute(case)

        passed = True
        failures = []

        if actual["risk_class"] != gc["expected"]["risk_class"]:
            passed = False
            failures.append(
                f"Risk class: expected {gc['expected']['risk_class']}, "
                f"got {actual['risk_class']}")

        expected_range = gc["expected"].get("total_debits_range")
        if expected_range:
            if not (expected_range[0] <= actual["total_debits"] <= expected_range[1]):
                passed = False
                failures.append(
                    f"Debits: expected {expected_range}, "
                    f"got {actual['total_debits']}")

        if passed:
            results["passed"] += 1
        else:
            results["failed"] += 1
            results["failures"].append({
                "case_id": gc["case_id"],
                "description": gc["description"],
                "failures": failures
            })

    return results
```

### 7.3 Boundary Value Testing

```
BOUNDARY VALUE TEST MATRIX

BMI BOUNDARIES (Male):
  Test: BMI = 18.4 → Expected: DECLINE (underweight)
  Test: BMI = 18.5 → Expected: PREFERRED_PLUS (lower bound)
  Test: BMI = 25.9 → Expected: PREFERRED_PLUS (upper bound)
  Test: BMI = 26.0 → Expected: PREFERRED (lower bound)
  Test: BMI = 29.9 → Expected: PREFERRED (upper bound)
  Test: BMI = 30.0 → Expected: STANDARD (lower bound)
  Test: BMI = 32.9 → Expected: STANDARD (upper bound)
  Test: BMI = 33.0 → Expected: TABLE_2 (lower bound)
  Test: BMI = 37.9 → Expected: TABLE_2 (upper bound)
  Test: BMI = 38.0 → Expected: TABLE_4 (lower bound)
  Test: BMI = 42.9 → Expected: TABLE_4 (upper bound)
  Test: BMI = 43.0 → Expected: DECLINE (overweight)

BLOOD PRESSURE BOUNDARIES:
  Test: 119/79 → Expected: OPTIMAL (0 debits)
  Test: 120/79 → Expected: ELEVATED (15 debits)
  Test: 129/79 → Expected: ELEVATED (15 debits)
  Test: 130/79 → Expected: STAGE_1 (50 debits)
  Test: 139/79 → Expected: STAGE_1 (50 debits)
  Test: 140/79 → Expected: STAGE_2 (100 debits)
  Test: 159/79 → Expected: STAGE_2 (100 debits)
  Test: 160/79 → Expected: STAGE_2_SEVERE (200 debits)
  Test: 179/79 → Expected: STAGE_2_SEVERE (200 debits)
  Test: 180/79 → Expected: CRISIS (KNOCKOUT)
  Test: 119/80 → Expected: STAGE_1 (50 debits)
  Test: 119/89 → Expected: STAGE_1 (50 debits)
  Test: 119/90 → Expected: STAGE_2 (100 debits)
  Test: 119/120 → Expected: CRISIS (KNOCKOUT)

AGE BOUNDARIES:
  Test: age = 17 → Expected: INELIGIBLE
  Test: age = 18 → Expected: ELIGIBLE
  Test: age = 75 → Expected: ELIGIBLE
  Test: age = 76 → Expected: INELIGIBLE

HbA1c BOUNDARIES:
  Test: 5.69 → Expected: NORMAL (0 debits)
  Test: 5.70 → Expected: PRE-DIABETES (25 debits)
  Test: 6.49 → Expected: PRE-DIABETES (50 debits)
  Test: 6.50 → Expected: DIABETES (100+ debits)
  Test: 9.99 → Expected: SEVERE (500 debits)
  Test: 10.00 → Expected: KNOCKOUT
```

### 7.4 Test Data Generation

```python
import random
from itertools import product

def generate_boundary_test_cases():
    """Generate test cases at every boundary of every decision table."""
    cases = []

    bmi_boundaries = [18.4, 18.5, 25.9, 26.0, 29.9, 30.0, 32.9, 33.0,
                      37.9, 38.0, 42.9, 43.0]
    bp_systolic = [89, 90, 119, 120, 129, 130, 139, 140, 159, 160, 179, 180]
    bp_diastolic = [59, 60, 79, 80, 89, 90, 99, 100, 119, 120]
    ages = [17, 18, 30, 40, 50, 60, 65, 70, 75, 76]
    hba1c_vals = [5.0, 5.69, 5.7, 6.0, 6.4, 6.5, 7.0, 7.5, 8.0, 10.0, 10.1]
    cholesterol = [199, 200, 219, 220, 239, 240, 279, 280]
    genders = ["M", "F"]
    smoker = ["never", "former", "current"]

    for bmi in bmi_boundaries:
        for gender in genders:
            cases.append({
                "type": "BOUNDARY_BMI",
                "gender": gender,
                "bmi": bmi,
                "age": 35,
                "systolic": 118, "diastolic": 76,
                "smoker": "never"
            })

    for sys in bp_systolic:
        for dia in bp_diastolic:
            cases.append({
                "type": "BOUNDARY_BP",
                "systolic": sys,
                "diastolic": dia,
                "age": 40, "gender": "M",
                "bmi": 24.0, "smoker": "never"
            })

    return cases

def generate_combinatorial_test_cases(sample_size=10000):
    """Generate random cases covering the full input space."""
    cases = []
    for _ in range(sample_size):
        cases.append({
            "age": random.randint(18, 80),
            "gender": random.choice(["M", "F"]),
            "smoker": random.choice(["never", "former", "current"]),
            "bmi": round(random.uniform(15, 50), 1),
            "systolic": random.randint(80, 200),
            "diastolic": random.randint(50, 130),
            "total_chol": random.randint(120, 350),
            "ldl": random.randint(40, 250),
            "hdl": random.randint(20, 100),
            "hba1c": round(random.uniform(4.0, 12.0), 1),
            "face_amount": random.choice(
                [50000, 100000, 250000, 500000, 1000000, 2000000]),
            "annual_income": random.choice(
                [30000, 50000, 75000, 100000, 150000, 250000, 500000])
        })
    return cases
```

---

## 8. Performance Optimization

### 8.1 Rule Compilation

```
RULE COMPILATION PIPELINE

Source Rules (DRL/DMN)
       │
       ▼
┌──────────────────┐
│  PARSE            │  DRL → AST (Abstract Syntax Tree)
│  (Drools Compiler)│  Validate syntax, type-check constraints
└────────┬─────────┘
         ▼
┌──────────────────┐
│  BUILD RETE       │  AST → Rete Network
│  NETWORK          │  Identify shared conditions (alpha sharing)
│                   │  Build join nodes (beta network)
└────────┬─────────┘
         ▼
┌──────────────────┐
│  OPTIMIZE         │  Node merging, hash indexing
│                   │  Constraint reordering (most selective first)
│                   │  Dead branch elimination
└────────┬─────────┘
         ▼
┌──────────────────┐
│  SERIALIZE        │  Compiled network → KJAR / binary
│  (KJAR Package)   │  Store in Maven repository
│                   │  Version with semantic versioning
└──────────────────┘

PRE-COMPILATION BENEFITS:
  - Rule parsing: 2-5 seconds for 2000 rules
  - Pre-compiled load: 50-200 milliseconds
  - 10-100× faster startup
  - Cache compiled artifacts across deployments
```

### 8.2 Indexing Strategies

```
ALPHA NODE INDEXING:

Without indexing: Each fact checked against every alpha node → O(N × A)
With hash indexing: Facts routed by hash → O(1) per lookup

Example:
  Alpha nodes for Applicant.smokerStatus:
    Hash index: {
      "never"   → [Node_PP_Elig, Node_Pref_Elig, Node_Accel_Elig],
      "former"  → [Node_Former_Smoker, Node_Recent_Quit],
      "current" → [Node_Smoker_Rating, Node_Smoker_Table]
    }

  When Applicant(smokerStatus="never") is asserted:
    Lookup hash["never"] → directly route to 3 nodes
    Skip all smoker-related nodes → significant savings

BETA JOIN INDEXING:

Without indexing: Nested loop join → O(L × R)
With hash join: Index on join key → O(L + R)

Example:
  Join: Applicant.id == LabResult.applicantId
  Build hash on LabResult.applicantId
  For each Applicant, look up matching LabResults in O(1)
```

### 8.3 Stateless vs. Stateful Sessions

```
STATELESS SESSION (Recommended for Underwriting):

  KieSession session = kieContainer.newStatelessKieSession();

  Characteristics:
  - Created per request, no state between invocations
  - Thread-safe (can be pooled)
  - No event processing, no temporal reasoning
  - Insert all facts → fireAllRules → extract results → dispose
  - Typical lifecycle: 10-100ms

  Underwriting fit:
  - Each application is independent
  - No need to track state between applications
  - Scales horizontally trivially
  - Lower memory footprint

STATEFUL SESSION (Use sparingly):

  KieSession session = kieContainer.newKieSession();

  Characteristics:
  - Maintained across interactions
  - Supports incremental fact changes
  - Supports event processing / temporal reasoning
  - Must be explicitly disposed
  - Higher memory, not inherently thread-safe

  Underwriting use cases:
  - Multi-step reflexive interviews (maintain state between questions)
  - Continuous underwriting (policy lifecycle monitoring)
  - Complex event processing (claims + UW correlation)
```

### 8.4 Performance Benchmarks

```
BENCHMARK: 2,000 UNDERWRITING RULES, TYPICAL CASE

┌─────────────────────────────┬──────────┬──────────┬──────────┐
│ Metric                      │ Drools   │ Custom   │ Camunda  │
│                             │ (PHREAK) │ (Python) │ (DMN)    │
├─────────────────────────────┼──────────┼──────────┼──────────┤
│ Rule compilation (cold)     │ 3.2s     │ N/A      │ 1.1s     │
│ Rule loading (pre-compiled) │ 180ms    │ 50ms     │ 120ms    │
│ Session creation            │ 2ms      │ 0.5ms    │ 1ms      │
│ Fact insertion (50 facts)   │ 1.5ms    │ 0.2ms    │ 0.5ms    │
│ Rule execution              │ 8ms      │ 15ms     │ 5ms      │
│ Total per-case latency      │ 12ms     │ 16ms     │ 7ms      │
│ Throughput (cases/sec)      │ ~80      │ ~60      │ ~140     │
│ Memory per session          │ 2MB      │ 0.5MB    │ 1MB      │
│ Memory for rule base        │ 50MB     │ 10MB     │ 20MB     │
│ P99 latency                 │ 25ms     │ 45ms     │ 15ms     │
│ Max tested rules            │ 15,000   │ 5,000    │ 2,000    │
└─────────────────────────────┴──────────┴──────────┴──────────┘

OPTIMIZATION TECHNIQUES IMPACT:
  - Alpha node indexing: 40-60% latency reduction
  - Beta join indexing: 30-50% latency reduction
  - Constraint reordering: 10-20% latency reduction
  - Rule pre-compilation: 90%+ startup reduction
  - Session pooling: 80% session creation overhead eliminated
  - Fact batch insertion: 20-30% vs individual inserts
```

### 8.5 Caching Strategy

```
CACHING LAYERS FOR UNDERWRITING RULES

Layer 1: COMPILED RULE CACHE
  - Cache pre-compiled Rete network / KJAR
  - Invalidate on rule version change
  - TTL: Until new version deployed

Layer 2: REFERENCE DATA CACHE
  - Build chart tables, ICD-10 code mappings, drug databases
  - Cache in application memory (Redis or in-process)
  - TTL: 24 hours or until data refresh

Layer 3: DECISION CACHE
  - Cache full UW decisions by input hash
  - Use for: requote, what-if analysis, duplicate submissions
  - TTL: 1 hour (short — inputs may have changed)
  - Cache key: SHA-256 of normalized, sorted input JSON

Layer 4: PARTIAL RESULT CACHE
  - Cache sub-decision results (lab interpretation, Rx interpretation)
  - Useful when same lab/Rx data is used across multiple rule packages
  - TTL: Per session (discard after case complete)

CACHE INVALIDATION:
  - Rule version change → Invalidate Layer 1 + Layer 3
  - Reference data update → Invalidate Layer 2 + Layer 3
  - Never cache knockout/decline decisions for requote
  - Always log cache hits for audit trail
```

---

## 9. Business User Rule Management

### 9.1 Rule Authoring UI Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                    RULE MANAGEMENT PLATFORM                                  │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │                       WEB UI (React/Angular)                          │    │
│  │                                                                       │    │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  ┌─────────────┐ │    │
│  │  │ Decision    │  │ Rule         │  │ Test Case  │  │ Version     │ │    │
│  │  │ Table       │  │ Template     │  │ Manager    │  │ History     │ │    │
│  │  │ Editor      │  │ Editor       │  │            │  │ & Diff      │ │    │
│  │  │             │  │              │  │            │  │             │ │    │
│  │  │ Excel-like  │  │ Fill-in-the  │  │ Upload CSV │  │ Side-by-side│ │    │
│  │  │ grid edit   │  │ blank forms  │  │ test data  │  │ diff view   │ │    │
│  │  └─────────────┘  └──────────────┘  └────────────┘  └─────────────┘ │    │
│  │                                                                       │    │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  ┌─────────────┐ │    │
│  │  │ Impact      │  │ Approval     │  │ Deployment │  │ Audit       │ │    │
│  │  │ Analyzer    │  │ Workflow     │  │ Pipeline   │  │ Dashboard   │ │    │
│  │  │             │  │              │  │            │  │             │ │    │
│  │  │ Before/     │  │ Submit →     │  │ Dev → Test │  │ Who/When/   │ │    │
│  │  │ After       │  │ Review →     │  │ → Stage → │  │ What        │ │    │
│  │  │ comparison  │  │ Approve      │  │ Prod       │  │ changed     │ │    │
│  │  └─────────────┘  └──────────────┘  └────────────┘  └─────────────┘ │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │                       BACKEND SERVICES                                │    │
│  │                                                                       │    │
│  │  Rule Repository   Rule Compiler   Test Runner   Deployment Manager  │    │
│  │  (Git-backed)      (DRL/DMN→KJAR)  (JUnit/Pytest) (CI/CD pipeline)  │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 9.2 Role-Based Access Control

```
RBAC MODEL FOR RULE MANAGEMENT

ROLES:
┌──────────────────┬────────────────────────────────────────────────────────┐
│ Role             │ Permissions                                            │
├──────────────────┼────────────────────────────────────────────────────────┤
│ Rule Viewer      │ View rules, view decision tables, view test results    │
│ Rule Author      │ + Create/edit rules in DRAFT, run tests                │
│ Rule Reviewer    │ + Approve/reject rules, view impact analysis           │
│ Rule Admin       │ + Deploy rules, manage versions, rollback              │
│ Actuary          │ + Approve mortality-impacting changes                  │
│ Compliance       │ + Approve state-specific / regulatory rules            │
│ System Admin     │ + Manage users, configure engine, manage environments  │
└──────────────────┴────────────────────────────────────────────────────────┘

APPROVAL WORKFLOWS:
  Standard rule change: Author → Reviewer → Deploy
  Mortality-impacting: Author → Reviewer → Actuary → Deploy
  State-specific: Author → Reviewer → Compliance → Deploy
  Knockout/Decline: Author → Reviewer → Actuary → Compliance → Deploy
  Emergency hotfix: Author → Rule Admin (bypass) → Post-deploy review
```

### 9.3 Audit Trail Schema

```json
{
  "audit_id": "AUD-2025-001234",
  "timestamp": "2025-03-15T10:30:00Z",
  "actor": "jane.smith@insurance.com",
  "actor_role": "Rule Author",
  "action": "RULE_MODIFIED",
  "rule_id": "BUILD-003",
  "old_version": "2.0.0",
  "new_version": "2.1.0",
  "change_type": "THRESHOLD_UPDATE",
  "change_detail": {
    "field": "bmi_upper_bound",
    "old_value": 25.0,
    "new_value": 25.9,
    "scope": "MALE_PREFERRED_PLUS"
  },
  "justification": "Updated per 2025 AUA mortality study showing BMI 25.0-25.9 does not materially impact mortality in males under 50",
  "approval_chain": [
    {"approver": "john.doe@insurance.com", "role": "Reviewer", "timestamp": "2025-03-15T14:00:00Z", "action": "APPROVED"},
    {"approver": "sarah.jones@insurance.com", "role": "Actuary", "timestamp": "2025-03-15T16:30:00Z", "action": "APPROVED"}
  ],
  "impact_analysis_id": "IMP-2025-000567",
  "deployment_id": "DEP-2025-000890",
  "environment": "PRODUCTION",
  "rollback_available": true
}
```

---

## 10. Implementing the Debit/Credit System in Rules

### 10.1 Debit/Credit Architecture

The debit/credit system is the numerical backbone of rule-based underwriting. Each risk factor generates debits (penalties) or credits (bonuses), which are aggregated to determine the final risk classification.

```
DEBIT/CREDIT FLOW

┌────────────────────────────────────────────────────────────────────┐
│                    DEBIT/CREDIT PIPELINE                            │
│                                                                     │
│  ┌─────────────┐                                                   │
│  │ RULE        │  Rule fires → Debit(category, points, reason)     │
│  │ EXECUTION   │  Example: Debit("BP", 50, "Stage 1 HTN")         │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ DEBIT       │  Collect all debits into category buckets          │
│  │ ACCUMULATOR │                                                   │
│  │             │  BUILD:       25                                   │
│  │             │  BP:          50                                   │
│  │             │  CHOLESTEROL: 35                                   │
│  │             │  DIABETES:    0                                    │
│  │             │  CARDIAC:     0                                    │
│  │             │  Rx:          25 (ACE inhibitor → HTN implied)     │
│  │             │  FH:          75 (father cardiac death at 55)      │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ CATEGORY    │  Apply per-category maximum caps                   │
│  │ CAPS        │  BP capped at 200, FH capped at 150, etc.        │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ CREDIT      │  Apply credits for positive risk factors           │
│  │ APPLICATION │                                                   │
│  │             │  EXERCISE:    -15 (regular exercise program)       │
│  │             │  CLEAN_FH:   0 (not applicable — FH debits > 0)  │
│  │             │  NON_SMOKER: -10 (10+ year non-smoker bonus)      │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ INTERACTION │  Apply multi-factor interaction adjustments        │
│  │ RULES       │  No interactions triggered in this case           │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ AGGREGATE   │  Total = 25+50+35+0+0+25+75 -15-10 = 185         │
│  │ SCORE       │                                                   │
│  └──────┬──────┘                                                   │
│         ▼                                                          │
│  ┌─────────────┐                                                   │
│  │ RISK CLASS  │  185 debits → STANDARD (range 176-250)            │
│  │ MAPPING     │                                                   │
│  └─────────────┘                                                   │
└────────────────────────────────────────────────────────────────────┘
```

### 10.2 Drools Implementation

```drools
package com.insurance.uw.rules.debitcredit

// Accumulate debits by category
rule "DC-ACCUMULATE: Sum debits by category"
    salience 50
    when
        $category : String() from accumulate(
            Debit($cat : category),
            collectSet($cat)
        )
        $total : Number() from accumulate(
            Debit(category == $category, $pts : points),
            sum($pts)
        )
        $dec : UnderwritingDecision()
    then
        $dec.setCategoryTotal($category, $total.intValue());
        update($dec);
end

// Apply category caps
rule "DC-CAP: Apply category maximum"
    salience 45
    when
        $dec : UnderwritingDecision()
        $cap : CategoryCap($category : category, $maxPoints : maxPoints)
        eval($dec.getCategoryTotal($category) > $maxPoints)
    then
        $dec.setCategoryTotal($category, $maxPoints);
        $dec.addNote("Category " + $category + " capped at " + $maxPoints);
        update($dec);
end

// Credits
rule "DC-CREDIT-001: Non-smoker 10+ years"
    salience 40
    when
        $app : Applicant(
            smokerStatus == "never" ||
            (smokerStatus == "former" && yearsSinceQuit >= 10)
        )
        $dec : UnderwritingDecision()
    then
        $dec.addCredit(new Credit("TOBACCO_FREE", "Non-smoker 10+ years", -10));
        update($dec);
end

rule "DC-CREDIT-002: Optimal build"
    salience 40
    when
        $app : Applicant(bmi >= 19.0, bmi <= 24.9)
        $dec : UnderwritingDecision()
    then
        $dec.addCredit(new Credit("BUILD", "Optimal build credit", -10));
        update($dec);
end

rule "DC-CREDIT-003: Excellent cholesterol profile"
    salience 40
    when
        LabResult(testCode == "TOTAL_CHOL", value < 200)
        LabResult(testCode == "LDL", value < 100)
        LabResult(testCode == "HDL", value >= 60)
        $dec : UnderwritingDecision()
    then
        $dec.addCredit(new Credit("CHOLESTEROL", "Excellent lipid profile", -15));
        update($dec);
end

// Aggregate and map
rule "DC-AGGREGATE: Calculate final score"
    salience 30
    when
        $dec : UnderwritingDecision(aggregated == false)
        $totalDebits : Number() from accumulate(
            Debit($pts : points),
            sum($pts)
        )
        $totalCredits : Number() from accumulate(
            Credit($pts : points),
            sum($pts)
        )
    then
        int finalScore = $totalDebits.intValue() + $totalCredits.intValue();
        finalScore = Math.max(0, finalScore);
        $dec.setTotalDebitPoints(finalScore);
        $dec.setAggregated(true);
        update($dec);
end
```

### 10.3 Credit Rules Catalog

```
CREDIT RULES:

CR-001: Non-smoker 10+ years                    → -10 debits
CR-002: Optimal BMI (19.0-24.9)                 → -10 debits
CR-003: Excellent cholesterol (TC<200, LDL<100)  → -15 debits
CR-004: Optimal blood pressure (<120/80)         → -10 debits
CR-005: Regular exercise (documented)            → -15 debits
CR-006: Clean family history (no 1st-deg death <60) → -25 debits
CR-007: No medications                           → -10 debits
CR-008: No hospitalizations in 10+ years         → -10 debits
CR-009: Favorable occupation (low risk)          → -5 debits
CR-010: Preferred financial profile (stable)     → -5 debits
CR-011: Clean MVR (no violations in 5 years)     → -5 debits
CR-012: HbA1c < 5.5 (no diabetes risk)          → -5 debits
CR-013: eGFR > 90 (excellent kidney function)    → -5 debits
CR-014: All liver enzymes normal                 → -5 debits

MAXIMUM TOTAL CREDITS: -100 debits (floor)
CREDITS CANNOT REDUCE TOTAL BELOW 0
```

---

## 11. Rx-to-Condition Mapping Engine

### 11.1 Architecture

```
RX-TO-CONDITION MAPPING PIPELINE

┌─────────────┐    ┌─────────────┐    ┌──────────────┐    ┌──────────────┐
│ RAW Rx DATA │───▶│ NDC LOOKUP  │───▶│ THERAPEUTIC  │───▶│ IMPLIED      │
│             │    │             │    │ CLASS MAP    │    │ CONDITION    │
│ NDC code    │    │ Drug name   │    │             │    │ ASSESSMENT   │
│ Days supply │    │ Strength    │    │ ATC/USP     │    │             │
│ Fill dates  │    │ Route       │    │ class code  │    │ ICD-10 code │
│ Prescriber  │    │ Dosage form │    │             │    │ Severity    │
│             │    │             │    │             │    │ Duration    │
└─────────────┘    └─────────────┘    └──────────────┘    └──────────────┘
                                                                │
                                                                ▼
                                                         ┌──────────────┐
                                                         │ UW           │
                                                         │ ASSESSMENT   │
                                                         │              │
                                                         │ Debits       │
                                                         │ Evidence req │
                                                         │ Referrals    │
                                                         └──────────────┘
```

### 11.2 NDC Code Resolution

```python
class NDCResolver:
    """Resolves NDC (National Drug Code) to drug information."""

    def __init__(self, fda_database_path: str):
        self.ndc_lookup = {}
        self.load_fda_database(fda_database_path)

    def load_fda_database(self, path: str):
        """
        Load FDA NDC Directory (updated monthly).
        Source: https://www.fda.gov/drugs/drug-approvals-and-databases/
                national-drug-code-directory
        ~300,000 NDC codes in active use.
        """
        pass

    def resolve(self, ndc_code: str) -> dict:
        """
        NDC format: 5-4-2 (labeler-product-package) or
                     10-digit, 11-digit variants
        Returns: {
            "ndc": "00006-0072-31",
            "proprietary_name": "Lisinopril",
            "nonproprietary_name": "Lisinopril",
            "labeler": "Merck Sharp & Dohme",
            "strength": "10mg",
            "dosage_form": "TABLET",
            "route": "ORAL",
            "dea_schedule": null,
            "atc_codes": ["C09AA03"],
            "usp_class": "ACE Inhibitors",
            "therapeutic_class": "CARDIOVASCULAR",
            "sub_class": "ACE_INHIBITOR"
        }
        """
        return self.ndc_lookup.get(self._normalize_ndc(ndc_code))

    def _normalize_ndc(self, ndc: str) -> str:
        return ndc.replace("-", "").zfill(11)
```

### 11.3 Therapeutic Class to Condition Mapping

```python
THERAPEUTIC_CLASS_TO_CONDITIONS = {
    "ACE_INHIBITOR": {
        "primary_conditions": ["I10 Hypertension"],
        "secondary_conditions": ["I50 Heart Failure", "N18 CKD"],
        "uw_action": "REQUEST_BP_READINGS",
        "base_debits": 25,
        "severity_modifiers": {
            "monotherapy": 0,
            "combination_with_other_antihypertensive": 15,
            "high_dose": 10
        }
    },
    "STATIN": {
        "primary_conditions": ["E78 Hyperlipidemia"],
        "secondary_conditions": ["I25 CAD (prevention)"],
        "uw_action": "REQUEST_LIPID_PANEL",
        "base_debits": 15,
        "severity_modifiers": {
            "low_dose": 0,
            "moderate_dose": 5,
            "high_dose": 15
        }
    },
    "INSULIN": {
        "primary_conditions": ["E10 Type 1 Diabetes", "E11 Type 2 Diabetes"],
        "secondary_conditions": [],
        "uw_action": "FULL_DIABETIC_WORKUP",
        "base_debits": 100,
        "severity_modifiers": {
            "basal_only": 0,
            "basal_bolus": 25,
            "insulin_pump": 25,
            "high_total_daily_dose": 50
        }
    },
    "BIGUANIDE": {
        "primary_conditions": ["E11 Type 2 Diabetes"],
        "secondary_conditions": ["E66 Obesity (off-label)"],
        "uw_action": "REQUEST_HBA1C",
        "base_debits": 50,
        "severity_modifiers": {
            "monotherapy": 0,
            "combination": 15
        }
    },
    "SSRI": {
        "primary_conditions": ["F32 Depression", "F41 Anxiety"],
        "secondary_conditions": ["F42 OCD", "F43 PTSD"],
        "uw_action": "REQUEST_MENTAL_HEALTH_HISTORY",
        "base_debits": 15,
        "severity_modifiers": {
            "single_agent_low_dose": 0,
            "single_agent_high_dose": 10,
            "augmented_with_another": 25,
            "with_hospitalization_history": 75
        }
    },
    "OPIOID": {
        "primary_conditions": ["G89 Chronic Pain"],
        "secondary_conditions": ["F11 Opioid Use Disorder"],
        "uw_action": "SCRUTINIZE_ADDICTION_RISK",
        "base_debits": 50,
        "severity_modifiers": {
            "short_term_acute": -25,
            "long_term_chronic": 50,
            "high_dose_mme": 100,
            "multiple_prescribers": 100
        }
    },
    "ANTICOAGULANT": {
        "primary_conditions": ["I48 Atrial Fibrillation", "I26 PE", "I82 DVT"],
        "secondary_conditions": ["Z95 Mechanical valve"],
        "uw_action": "REQUEST_CARDIAC_WORKUP",
        "base_debits": 75,
        "severity_modifiers": {
            "afib_controlled": 0,
            "recurrent_dvt_pe": 75,
            "mechanical_valve": 100
        }
    },
    "ANTIPSYCHOTIC": {
        "primary_conditions": ["F20 Schizophrenia", "F31 Bipolar"],
        "secondary_conditions": ["F32 Depression (augmentation)"],
        "uw_action": "REQUEST_PSYCHIATRIC_APS",
        "base_debits": 100,
        "severity_modifiers": {
            "augmentation_low_dose": -50,
            "bipolar_maintenance": 25,
            "schizophrenia": 150
        }
    }
}
```

### 11.4 Drug Database Update Procedures

```
DRUG DATABASE UPDATE WORKFLOW

FREQUENCY: Monthly (aligned with FDA NDC Directory updates)

┌──────────────────────────────────────────────────────────────┐
│                  MONTHLY UPDATE PROCEDURE                     │
│                                                              │
│  Week 1: FDA releases updated NDC Directory                  │
│          Download from: https://open.fda.gov/apis/drug/ndc/  │
│                                                              │
│  Week 2: Delta analysis                                      │
│          - Identify new NDC codes                            │
│          - Identify discontinued NDC codes                   │
│          - Map new drugs to therapeutic classes               │
│          - Flag new drugs requiring UW rule creation          │
│                                                              │
│  Week 3: Rule updates                                        │
│          - Create UW rules for new drug classes              │
│          - Update condition mappings if needed                │
│          - Peer review all changes                           │
│          - Run regression tests                              │
│                                                              │
│  Week 4: Deployment                                          │
│          - Deploy to staging                                  │
│          - UAT verification                                  │
│          - Production deployment                             │
│          - Monitor for 72 hours                              │
└──────────────────────────────────────────────────────────────┘

SUPPLEMENTAL DATA SOURCES:
  - First Databank (FDB): Drug classification, interactions
  - Medi-Span: NDC-to-GPI mapping
  - RxNorm (NLM): Normalized drug names, relationships
  - Milliman IntelliScript: Rx history interpretation engine
  - ExamOne/Quest: Rx data from PBM claims

VERSIONING:
  - Drug database version: YYYY.MM (e.g., 2025.03)
  - Each case records the drug database version used
  - Historical lookups always use the version active at case date
```

### 11.5 Multi-Drug Interaction Assessment

```python
def assess_rx_profile(rx_history: list, drug_db: dict) -> dict:
    """Assess full prescription profile for underwriting implications."""
    results = {
        "implied_conditions": {},
        "total_rx_debits": 0,
        "evidence_required": set(),
        "red_flags": [],
        "chronic_condition_count": 0,
        "polypharmacy_flag": False
    }

    resolved_drugs = []
    for rx in rx_history:
        drug_info = drug_db.resolve(rx["ndc"])
        if drug_info:
            drug_info["days_supply"] = rx.get("days_supply", 30)
            drug_info["fill_count"] = rx.get("fill_count", 1)
            drug_info["prescriber_specialty"] = rx.get("prescriber_specialty")
            resolved_drugs.append(drug_info)

    for drug in resolved_drugs:
        mapping = THERAPEUTIC_CLASS_TO_CONDITIONS.get(drug["sub_class"])
        if mapping:
            for condition in mapping["primary_conditions"]:
                if condition not in results["implied_conditions"]:
                    results["implied_conditions"][condition] = {
                        "drugs": [], "debits": mapping["base_debits"],
                        "evidence": mapping["uw_action"]
                    }
                results["implied_conditions"][condition]["drugs"].append(
                    drug["proprietary_name"])

            results["total_rx_debits"] += mapping["base_debits"]
            if mapping["uw_action"]:
                results["evidence_required"].add(mapping["uw_action"])

    if len(resolved_drugs) >= 8:
        results["polypharmacy_flag"] = True
        results["red_flags"].append(
            f"Polypharmacy: {len(resolved_drugs)} concurrent medications")
        results["total_rx_debits"] += 50

    chronic_classes = set()
    for drug in resolved_drugs:
        if drug.get("fill_count", 0) >= 3:
            chronic_classes.add(drug.get("sub_class"))
    results["chronic_condition_count"] = len(chronic_classes)

    if results["chronic_condition_count"] >= 5:
        results["red_flags"].append(
            f"Multiple chronic conditions: {results['chronic_condition_count']}")
        results["total_rx_debits"] += 75

    same_class_drugs = {}
    for drug in resolved_drugs:
        cls = drug.get("sub_class")
        if cls in same_class_drugs:
            results["red_flags"].append(
                f"Duplicate therapy: {drug['proprietary_name']} and "
                f"{same_class_drugs[cls]} both in class {cls}")
        same_class_drugs[cls] = drug["proprietary_name"]

    return results
```

---

## 12. Lab Value Interpretation Engine

### 12.1 Multi-Variate Lab Interpretation Architecture

Lab values cannot be interpreted in isolation. Age, gender, other lab values, and medical context all modify the interpretation.

```
MULTI-VARIATE LAB INTERPRETATION PIPELINE

┌──────────────┐
│ RAW LAB DATA │
│              │
│ Test code    │
│ Value        │
│ Units        │
│ Collection   │
│ date         │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ NORMALIZE    │
│              │
│ Unit convert │
│ (SI → US)   │
│ Flag outliers│
│ Validate     │
│ ranges       │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────────────────────────┐
│ SINGLE-VALUE INTERPRETATION (age/gender-adjusted)        │
│                                                          │
│ For each lab value:                                      │
│   1. Look up reference range by (test, age_band, gender) │
│   2. Classify: OPTIMAL / NORMAL / BORDERLINE / ABNORMAL  │
│   3. Assign base debits from classification               │
└──────────────────────────┬───────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────┐
│ MULTI-VARIATE INTERPRETATION (cross-lab correlations)    │
│                                                          │
│ Pattern rules:                                           │
│   - Elevated ALT + AST + GGT → Liver panel abnormality  │
│   - Elevated creatinine + low eGFR → Renal impairment   │
│   - Elevated glucose + elevated HbA1c → Diabetes         │
│   - Low HDL + High TG + High glucose → Metabolic synd.  │
│   - Elevated AST/ALT ratio > 2 + elevated GGT → Alcohol │
│   - Low albumin + elevated bilirubin → Liver failure     │
│                                                          │
│ Adjustment: Increase/decrease debits based on patterns   │
└──────────────────────────┬───────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────┐
│ CLINICAL CONTEXT ADJUSTMENT                              │
│                                                          │
│ If applicant reports condition AND labs confirm:         │
│   → Use condition-specific lab thresholds                │
│   → Example: Diabetic with HbA1c 7.2 → "controlled"    │
│              Non-diabetic with HbA1c 7.2 → "new finding"│
│                                                          │
│ If applicant on medication AND labs improved:            │
│   → Apply treatment credit                              │
│   → Example: On statin, LDL went from 180 → 110        │
│              → Acknowledge controlled hyperlipidemia     │
└──────────────────────────┬───────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────┐
│ FINAL LAB ASSESSMENT                                     │
│                                                          │
│ Per-lab debits (capped by category)                      │
│ Cross-lab interaction debits                             │
│ Clinical context adjustments                             │
│ Evidence requirements (if abnormal)                      │
│ Referral triggers (if critical)                          │
└──────────────────────────────────────────────────────────┘
```

### 12.2 Age/Gender-Adjusted Reference Ranges

```python
AGE_GENDER_REFERENCE_RANGES = {
    "CREATININE": {
        ("M", 18, 39): {"optimal": (0.7, 1.2), "normal": (0.7, 1.3),
                        "borderline": (1.3, 1.6), "abnormal": (1.6, 2.5), "critical": 2.5},
        ("M", 40, 59): {"optimal": (0.7, 1.2), "normal": (0.7, 1.4),
                        "borderline": (1.4, 1.8), "abnormal": (1.8, 2.5), "critical": 2.5},
        ("M", 60, 99): {"optimal": (0.7, 1.3), "normal": (0.7, 1.5),
                        "borderline": (1.5, 2.0), "abnormal": (2.0, 2.5), "critical": 2.5},
        ("F", 18, 39): {"optimal": (0.5, 1.0), "normal": (0.5, 1.1),
                        "borderline": (1.1, 1.3), "abnormal": (1.3, 2.0), "critical": 2.0},
        ("F", 40, 59): {"optimal": (0.5, 1.0), "normal": (0.5, 1.2),
                        "borderline": (1.2, 1.5), "abnormal": (1.5, 2.0), "critical": 2.0},
        ("F", 60, 99): {"optimal": (0.5, 1.1), "normal": (0.5, 1.3),
                        "borderline": (1.3, 1.7), "abnormal": (1.7, 2.0), "critical": 2.0},
    },
    "HEMOGLOBIN": {
        ("M", 18, 49): {"optimal": (14.0, 18.0), "normal": (13.5, 18.5),
                        "borderline": (12.0, 13.5), "abnormal": (10.0, 12.0), "critical": 8.0},
        ("M", 50, 99): {"optimal": (13.5, 17.5), "normal": (13.0, 18.0),
                        "borderline": (11.5, 13.0), "abnormal": (9.5, 11.5), "critical": 8.0},
        ("F", 18, 49): {"optimal": (12.0, 16.0), "normal": (11.5, 16.5),
                        "borderline": (10.0, 11.5), "abnormal": (8.0, 10.0), "critical": 7.0},
        ("F", 50, 99): {"optimal": (11.5, 15.5), "normal": (11.0, 16.0),
                        "borderline": (10.0, 11.0), "abnormal": (8.0, 10.0), "critical": 7.0},
    },
    "PSA": {
        ("M", 18, 39): {"optimal": (0, 2.5), "normal": (0, 2.5),
                        "borderline": (2.5, 4.0), "abnormal": (4.0, 10.0), "critical": 10.0},
        ("M", 40, 49): {"optimal": (0, 2.5), "normal": (0, 2.5),
                        "borderline": (2.5, 4.0), "abnormal": (4.0, 10.0), "critical": 10.0},
        ("M", 50, 59): {"optimal": (0, 3.5), "normal": (0, 3.5),
                        "borderline": (3.5, 5.0), "abnormal": (5.0, 10.0), "critical": 10.0},
        ("M", 60, 69): {"optimal": (0, 4.5), "normal": (0, 4.5),
                        "borderline": (4.5, 6.5), "abnormal": (6.5, 10.0), "critical": 10.0},
        ("M", 70, 99): {"optimal": (0, 6.5), "normal": (0, 6.5),
                        "borderline": (6.5, 8.0), "abnormal": (8.0, 10.0), "critical": 10.0},
    },
    "GGT": {
        ("M", 18, 99): {"optimal": (0, 45), "normal": (0, 55),
                        "borderline": (55, 100), "abnormal": (100, 200), "critical": 200},
        ("F", 18, 99): {"optimal": (0, 35), "normal": (0, 45),
                        "borderline": (45, 85), "abnormal": (85, 150), "critical": 150},
    },
    "EGFR": {
        ("M", 18, 39): {"optimal": (90, 200), "normal": (75, 200),
                        "borderline": (60, 75), "abnormal": (30, 60), "critical": 30},
        ("M", 40, 59): {"optimal": (85, 200), "normal": (70, 200),
                        "borderline": (55, 70), "abnormal": (30, 55), "critical": 30},
        ("M", 60, 99): {"optimal": (75, 200), "normal": (60, 200),
                        "borderline": (45, 60), "abnormal": (30, 45), "critical": 30},
        ("F", 18, 39): {"optimal": (90, 200), "normal": (75, 200),
                        "borderline": (60, 75), "abnormal": (30, 60), "critical": 30},
        ("F", 40, 59): {"optimal": (85, 200), "normal": (70, 200),
                        "borderline": (55, 70), "abnormal": (30, 55), "critical": 30},
        ("F", 60, 99): {"optimal": (75, 200), "normal": (60, 200),
                        "borderline": (45, 60), "abnormal": (30, 45), "critical": 30},
    }
}

def interpret_lab_value(test_code: str, value: float, gender: str,
                        age: int) -> dict:
    ranges = AGE_GENDER_REFERENCE_RANGES.get(test_code, {})

    matched_range = None
    for (g, age_low, age_high), ref in ranges.items():
        if g == gender and age_low <= age <= age_high:
            matched_range = ref
            break

    if not matched_range:
        return {"classification": "UNKNOWN", "debits": 0,
                "note": "No reference range for this test/age/gender"}

    if isinstance(matched_range["critical"], (int, float)):
        critical_val = matched_range["critical"]
        opt_low, opt_high = matched_range["optimal"]

        if critical_val > opt_high:
            if value >= critical_val:
                return {"classification": "CRITICAL", "debits": 999,
                        "action": "KNOCKOUT"}
        else:
            if value <= critical_val:
                return {"classification": "CRITICAL", "debits": 999,
                        "action": "KNOCKOUT"}

    opt_low, opt_high = matched_range["optimal"]
    if opt_low <= value <= opt_high:
        return {"classification": "OPTIMAL", "debits": 0}

    norm_low, norm_high = matched_range["normal"]
    if norm_low <= value <= norm_high:
        return {"classification": "NORMAL", "debits": 10}

    bord_low, bord_high = matched_range["borderline"]
    if bord_low <= value <= bord_high:
        return {"classification": "BORDERLINE", "debits": 50}

    abn_low, abn_high = matched_range["abnormal"]
    if abn_low <= value <= abn_high:
        return {"classification": "ABNORMAL", "debits": 125,
                "action": "REFER"}

    return {"classification": "OUT_OF_RANGE", "debits": 125,
            "action": "REFER"}
```

### 12.3 Multi-Variate Pattern Rules

```drools
package com.insurance.uw.rules.labs.multivariate

rule "LAB-MV-001: Metabolic Syndrome Pattern"
    when
        LabResult(testCode == "HDL", value < 40, $hdl : value)
        LabResult(testCode == "TRIGLYCERIDES", value > 150, $tg : value)
        LabResult(testCode == "FASTING_GLUCOSE", value > 100, $glu : value)
        $app : Applicant(bmi > 30)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("METABOLIC_SYNDROME",
            "Metabolic syndrome pattern: Low HDL(" + $hdl +
            "), High TG(" + $tg + "), High glucose(" + $glu +
            "), Obesity(BMI " + $app.getBmi() + ")",
            75, "LAB-MV-001"));
        $dec.addReferral("Metabolic syndrome — multi-factor cardiac risk");
        update($dec);
end

rule "LAB-MV-002: Liver Disease Pattern"
    when
        LabResult(testCode == "ALT", value > 50, $alt : value)
        LabResult(testCode == "AST", value > 50, $ast : value)
        LabResult(testCode == "GGT", value > 65, $ggt : value)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("LIVER_PATTERN",
            "Multi-enzyme liver elevation: ALT(" + $alt +
            "), AST(" + $ast + "), GGT(" + $ggt + ")",
            100, "LAB-MV-002"));
        $dec.requireEvidence("LIVER_ULTRASOUND");
        $dec.requireEvidence("HEPATITIS_PANEL");
        update($dec);
end

rule "LAB-MV-003: Alcohol Abuse Pattern (De Ritis Ratio)"
    when
        LabResult(testCode == "AST", $ast : value)
        LabResult(testCode == "ALT", $alt : value, value > 0)
        eval($ast / $alt > 2.0)
        LabResult(testCode == "GGT", value > 100)
        LabResult(testCode == "CDT", value > 2.0)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("ALCOHOL_PATTERN",
            "Alcohol abuse lab pattern: AST/ALT ratio > 2.0 with elevated GGT and CDT",
            200, "LAB-MV-003"));
        $dec.addReferral("Lab pattern consistent with significant alcohol use");
        update($dec);
end

rule "LAB-MV-004: Renal Impairment Pattern"
    when
        LabResult(testCode == "CREATININE", value > 1.5, $cr : value)
        LabResult(testCode == "EGFR", value < 60, $egfr : value)
        LabResult(testCode == "BUN", value > 25, $bun : value)
        $dec : UnderwritingDecision()
    then
        int severity;
        if ($egfr.doubleValue() < 30) {
            severity = 999;
            $dec.addKnockout("Severe renal impairment: eGFR " + $egfr +
                " (Stage 4-5 CKD)");
        } else if ($egfr.doubleValue() < 45) {
            severity = 150;
            $dec.addReferral("Moderate renal impairment: eGFR " + $egfr);
        } else {
            severity = 75;
        }
        $dec.addDebit(new Debit("RENAL_PATTERN",
            "Renal impairment: Cr(" + $cr + "), eGFR(" + $egfr +
            "), BUN(" + $bun + ")",
            severity, "LAB-MV-004"));
        update($dec);
end

rule "LAB-MV-005: New Diabetes Discovery"
    when
        LabResult(testCode == "HBA1C", value >= 6.5, $hba1c : value)
        LabResult(testCode == "FASTING_GLUCOSE", value >= 126, $glu : value)
        not MedicalCondition(conditionCode matches "E1[01].*")
        not RxRecord(therapeuticClass in ("BIGUANIDE", "SULFONYLUREA",
            "INSULIN", "DPP4_INHIBITOR", "GLP1_RA", "SGLT2_INHIBITOR"))
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("NEW_DIABETES",
            "Undisclosed diabetes: HbA1c " + $hba1c +
            "%, Glucose " + $glu + " mg/dL — not reported on application",
            200, "LAB-MV-005"));
        $dec.addReferral(
            "New diabetes finding not disclosed — possible misrepresentation");
        $dec.requireEvidence("APS_DIABETES");
        update($dec);
end

rule "LAB-MV-006: Controlled Diabetes Credit"
    when
        MedicalCondition(conditionCode matches "E11.*")
        LabResult(testCode == "HBA1C", value < 7.0, $hba1c : value)
        LabResult(testCode == "CREATININE", $cr : value)
        eval($cr < 1.3)
        LabResult(testCode == "EGFR", value >= 60)
        not MedicalCondition(conditionCode matches "H35.0[1-9].*")
        $dec : UnderwritingDecision()
    then
        $dec.addCredit(new Credit("DIABETES_CONTROLLED",
            "Well-controlled Type 2 DM: HbA1c " + $hba1c +
            "%, normal renal function, no retinopathy",
            -25));
        update($dec);
end

rule "LAB-MV-007: Cardiac Risk Pattern"
    when
        LabResult(testCode == "NT_PROBNP", value > 300, $bnp : value)
        LabResult(testCode == "HS_CRP", value > 3.0, $crp : value)
        LabResult(testCode == "TOTAL_CHOL", value > 240)
        $app : Applicant(systolicBP > 140)
        $dec : UnderwritingDecision()
    then
        $dec.addDebit(new Debit("CARDIAC_RISK_PATTERN",
            "Multi-marker cardiac risk: NT-proBNP(" + $bnp +
            "), hs-CRP(" + $crp +
            "), Elevated cholesterol, Hypertension",
            150, "LAB-MV-007"));
        $dec.addReferral("High cardiac risk — multi-marker pattern");
        $dec.requireEvidence("ECHOCARDIOGRAM");
        $dec.requireEvidence("STRESS_TEST");
        update($dec);
end
```

### 12.4 Lab Interpretation Configuration

```json
{
  "lab_interpretation_config": {
    "version": "2025.03",
    "effective_date": "2025-03-01",
    "tests": [
      {
        "test_code": "TOTAL_CHOL",
        "display_name": "Total Cholesterol",
        "unit": "mg/dL",
        "si_unit": "mmol/L",
        "conversion_factor": 0.02586,
        "age_gender_specific": false,
        "categories": [
          {"label": "OPTIMAL",    "range": "[0, 200)",   "debits": 0},
          {"label": "BORDERLINE", "range": "[200, 240)", "debits": 35},
          {"label": "HIGH",       "range": "[240, 280)", "debits": 100},
          {"label": "VERY_HIGH",  "range": "[280, ∞)",   "debits": 175}
        ],
        "multi_variate_rules": ["LAB-MV-001", "LAB-MV-007"],
        "evidence_on_abnormal": ["LIPID_PANEL_REPEAT", "STATIN_HISTORY"],
        "special_considerations": [
          "If on statin therapy: evaluate pre-treatment vs current",
          "If familial hypercholesterolemia suspected: refer"
        ]
      },
      {
        "test_code": "HBA1C",
        "display_name": "Hemoglobin A1c",
        "unit": "%",
        "age_gender_specific": false,
        "categories": [
          {"label": "NORMAL",       "range": "[0, 5.7)",   "debits": 0},
          {"label": "PRE_DIABETES", "range": "[5.7, 6.5)", "debits": 25},
          {"label": "DIABETES",     "range": "[6.5, 8.0)", "debits": 100},
          {"label": "UNCONTROLLED", "range": "[8.0, 10.0)","debits": 200},
          {"label": "CRITICAL",     "range": "[10.0, ∞)",  "debits": 999,
           "action": "KNOCKOUT"}
        ],
        "context_modifiers": [
          {
            "condition": "KNOWN_DIABETIC_ON_TREATMENT",
            "adjustment": "Use diabetes-specific rating table instead",
            "override_categories": true
          },
          {
            "condition": "SICKLE_CELL_TRAIT",
            "adjustment": "HbA1c may be falsely low — request fructosamine",
            "evidence": "FRUCTOSAMINE"
          }
        ]
      }
    ]
  }
}
```

---

## 13. Related Articles

- [01 — Term Life Insurance Underwriting Fundamentals](./01_TERM_UNDERWRITING_FUNDAMENTALS.md) — Complete domain encyclopedia covering risk assessment pillars, classification systems, and underwriting philosophy.
- [02 — Automated Underwriting Engine Architecture](./02_AUTOMATED_UNDERWRITING_ENGINE.md) — Reference architecture for decision engines, data pipelines, scoring models, API design, and deployment strategies.
- 03 — Data Integration & Third-Party Sources *(coming soon)* — MIB, Rx databases, MVR, credit-based mortality scores, EHR integration, and data normalization pipelines.
- 04 — Predictive Modeling in Underwriting *(coming soon)* — ML models for mortality prediction, accelerated UW scoring, fraud detection, and model governance.
- 05 — Regulatory Compliance & Fair Underwriting *(coming soon)* — State DOI requirements, NAIC guidelines, unfair discrimination testing, disparate impact analysis, and model explainability.
- 06 — Reinsurance & Treaty Automation *(coming soon)* — Automatic vs. facultative placement, treaty terms, cession rules, and reinsurer API integration.
- 08 — Case Management & Workflow Orchestration *(coming soon)* — BPMN workflows, case lifecycle state machines, SLA management, and human-in-the-loop design patterns.

---

> **Document version:** 1.0.0 | **Last updated:** April 2026 | **Author:** Underwriting Technology Architecture Team
