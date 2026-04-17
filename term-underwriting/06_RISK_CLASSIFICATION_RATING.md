# Risk Classification, Rating & Mortality — Complete Technical Reference

> An exhaustive encyclopedia for solution architects building automated underwriting systems. Covers risk classification criteria, debit/credit scoring, table ratings, flat extras, mortality tables, premium calculation mechanics, actuarial pricing, experience studies, and every nuance required to implement a production-grade risk classification engine.

---

## Table of Contents

1. [Risk Classification System](#1-risk-classification-system)
2. [Detailed Risk Class Criteria](#2-detailed-risk-class-criteria)
3. [The Debit/Credit System](#3-the-debitcredit-system)
4. [Table Rating (Substandard) System](#4-table-rating-substandard-system)
5. [Flat Extra Premiums](#5-flat-extra-premiums)
6. [Exclusion Riders](#6-exclusion-riders)
7. [Mortality Tables Deep Dive](#7-mortality-tables-deep-dive)
8. [Premium Calculation — From Mortality Rate to Gross Premium](#8-premium-calculation--from-mortality-rate-to-gross-premium)
9. [Actuarial Pricing Concepts](#9-actuarial-pricing-concepts)
10. [Experience Studies & A/E Analysis](#10-experience-studies--ae-analysis)
11. [Smoker vs Non-Smoker Classification](#11-smoker-vs-non-smoker-classification)
12. [Preferred Criteria Comparison Across Carriers](#12-preferred-criteria-comparison-across-carriers)
13. [Age and Gender Rating](#13-age-and-gender-rating)
14. [Multi-Life / Group vs Individual Pricing](#14-multi-life--group-vs-individual-pricing)
15. [Conversion Risk & Anti-Selection](#15-conversion-risk--anti-selection)
16. [Risk Class Migration](#16-risk-class-migration)

---

## 1. Risk Classification System

### 1.1 Purpose of Risk Classification

Risk classification is the process of assigning an applicant to a **rating class** that groups individuals with similar expected mortality. The rating class directly determines the premium charged. A well-designed classification system achieves three goals:

- **Actuarial equity** — each class pays premiums commensurate with expected claims.
- **Competitive positioning** — preferred classes attract low-risk applicants from competitors.
- **Anti-selection control** — boundaries between classes prevent adverse migration.

### 1.2 Evolution of Risk Classes

| Era | Classes Available | Notes |
|-----|------------------|-------|
| Pre-1980 | Standard, Substandard | Binary: qualify or pay extra |
| 1980–1995 | Standard, Preferred, Substandard | Smoker/Non-Smoker distinction introduced ~1984 |
| 1995–2010 | Preferred Best, Preferred, Standard+, Standard (× Smoker/NS) | Multi-tier preferred classes emerge |
| 2010–Present | 4–6 Non-Smoker + 2–3 Smoker classes | Up to 9 total classes at some carriers |

### 1.3 Standard Risk Class Hierarchy (Most Common 6-Class System)

Most carriers use a variant of the following six-class system for non-tobacco and tobacco applicants:

```
NON-TOBACCO CLASSES                    TOBACCO CLASSES
───────────────────                    ───────────────
Preferred Plus (PP / Super Preferred)  Preferred Tobacco (PT)
Preferred (PF)                         Standard Tobacco (ST)
Standard Plus (SP)
Standard Non-Tobacco (SNT)
```

Each class carries a **relative mortality expectation** expressed as a percentage of the base (Standard Non-Tobacco = 100%):

| Risk Class | Abbreviation | Relative Mortality (% of SNT) | Typical Premium Multiple |
|------------|-------------|-------------------------------|-------------------------|
| Preferred Plus | PP | 40–55% | 0.45× |
| Preferred | PF | 60–75% | 0.65× |
| Standard Plus | SP | 80–90% | 0.85× |
| Standard Non-Tobacco | SNT | 100% (base) | 1.00× |
| Preferred Tobacco | PT | 150–180% | 1.60× |
| Standard Tobacco | ST | 200–300% | 2.50× |

### 1.4 Why Multiple Preferred Classes Exist

The introduction of preferred classes was driven by:

1. **Competitive pressure** — Carriers discovered that ~30–40% of Standard applicants had mortality well below 100% expected. Offering a preferred rate attracted this profitable segment.
2. **Reinsurer innovation** — Reinsurers (Swiss Re, Munich Re, RGA, SCOR) developed preferred criteria guidelines and offered favorable reinsurance rates for qualifying applicants.
3. **Distribution demand** — Agents and brokers could "shop" preferred rates across carriers, making preferred qualification a key competitive differentiator.
4. **Mortality segmentation** — Actuarial studies showed that splitting Standard into finer buckets (PP, PF, SP, SNT) improved pricing accuracy and reduced cross-subsidization.

### 1.5 System Architecture: Modeling Risk Classes

In an automated underwriting engine, risk classes are typically modeled as:

```
RiskClassDefinition {
  code:           String        // "PP", "PF", "SP", "SNT", "PT", "ST"
  displayName:    String        // "Preferred Plus"
  tobaccoStatus:  Enum          // NON_TOBACCO | TOBACCO
  relMortality:   Decimal       // 0.45
  sortOrder:      Integer       // 1 (best) through 6 (worst)
  eligibleAges:   Range<Int>    // 18–70
  eligibleAmounts: Range<Money> // $100K–$10M
  maxDebits:      Integer       // threshold for debit/credit system
  active:         Boolean
  effectiveDate:  Date
}
```

The classification engine evaluates all criteria and returns the **best qualifying class** that the applicant meets.

---

## 2. Detailed Risk Class Criteria

### 2.1 Preferred Plus (Super Preferred) Non-Tobacco

This is the **best available class**, reserved for applicants in exceptional health with pristine histories.

#### 2.1.1 Build (BMI) Requirements

| Metric | Male | Female |
|--------|------|--------|
| **BMI Range** | 18.0–25.9 | 18.0–25.9 |
| **Height 5'10" Weight Range** | 132–180 lbs | N/A |
| **Height 5'5" Weight Range** | N/A | 114–155 lbs |
| **Maximum BMI (hard stop)** | 26.0 | 26.0 |
| **Minimum BMI (hard stop)** | 17.5 | 17.5 |

Detailed build chart (height in inches, weight in pounds):

| Height | Min Weight | Max Weight (Male) | Max Weight (Female) |
|--------|-----------|-------------------|---------------------|
| 60" | 97 | 131 | 131 |
| 62" | 104 | 141 | 141 |
| 64" | 110 | 149 | 149 |
| 66" | 118 | 161 | 161 |
| 68" | 125 | 170 | 170 |
| 70" | 132 | 180 | 180 |
| 72" | 140 | 194 | 190 |
| 74" | 148 | 204 | 200 |
| 76" | 156 | 213 | 210 |

#### 2.1.2 Blood Pressure

| Metric | Threshold |
|--------|-----------|
| **Systolic** | ≤ 130 mmHg |
| **Diastolic** | ≤ 80 mmHg |
| **Treatment** | No current anti-hypertensive medication |
| **History** | No prior diagnosis of hypertension |

#### 2.1.3 Cholesterol / Lipid Panel

| Metric | Threshold |
|--------|-----------|
| **Total Cholesterol** | ≤ 220 mg/dL |
| **HDL Cholesterol** | ≥ 45 mg/dL (Male), ≥ 50 mg/dL (Female) |
| **TC/HDL Ratio** | ≤ 4.5 |
| **LDL Cholesterol** | ≤ 150 mg/dL |
| **Triglycerides** | ≤ 200 mg/dL |
| **Cholesterol Medication** | Not permitted for PP |

#### 2.1.4 HbA1c / Glucose

| Metric | Threshold |
|--------|-----------|
| **HbA1c** | ≤ 5.6% |
| **Fasting Glucose** | ≤ 99 mg/dL |
| **Non-Fasting Glucose** | ≤ 140 mg/dL |
| **Diabetes History** | None |

#### 2.1.5 Family History

| Requirement | Detail |
|-------------|--------|
| **Definition of Family** | Biological parents and siblings |
| **Cardiovascular Death** | No parent or sibling death from cardiovascular disease before age 60 |
| **Cancer Death** | No parent or sibling death from cancer before age 60 |
| **Stroke** | No parent or sibling death from stroke before age 60 |
| **Diabetes** | No parent diagnosed with diabetes before age 60 |
| **Multiple Family Deaths** | No more than 1 first-degree relative death from any cause before age 65 |

#### 2.1.6 Driving Record

| Requirement | Threshold |
|-------------|-----------|
| **Lookback Period** | 5 years |
| **DUI/DWI** | None in past 10 years |
| **Moving Violations** | ≤ 1 in past 3 years |
| **Reckless Driving** | None in past 5 years |
| **License Suspensions** | None in past 5 years |
| **At-Fault Accidents** | ≤ 1 in past 5 years |
| **Speed > 25 mph over** | None in past 5 years |

#### 2.1.7 Lifestyle / Avocation

| Activity | PP Eligible? |
|----------|-------------|
| Private Aviation (licensed pilot) | No |
| Skydiving (> 10 jumps/year) | No |
| Scuba Diving (> 100 ft) | No |
| Rock Climbing (technical/lead) | No |
| Auto/Motorcycle Racing | No |
| Base Jumping | No |
| Recreational Skydiving (≤ 5/year) | Possible with flat extra |
| Recreational Scuba (≤ 100 ft, certified) | Yes |

#### 2.1.8 Other Requirements

| Criterion | Requirement |
|-----------|------------|
| **Tobacco/Nicotine** | None in past 5 years (any form) |
| **Alcohol** | No history of treatment for alcohol abuse; no current abuse indicators |
| **Drug Use** | No current or recent illicit drug use; no history of IV drug use |
| **Criminal History** | No felony convictions |
| **Bankruptcy** | No bankruptcy in past 5 years |
| **Foreign Travel** | No planned travel to high-risk countries |
| **Hazardous Occupation** | Not employed in high-risk occupation |
| **Age Eligibility** | 18–65 (some carriers 18–70) |
| **Minimum Face Amount** | $100,000 typically required |

---

### 2.2 Preferred Non-Tobacco

Second-best class. Allows slightly relaxed thresholds compared to PP.

#### 2.2.1 Build (BMI)

| Metric | Male | Female |
|--------|------|--------|
| **BMI Range** | 18.0–28.9 | 18.0–28.9 |
| **Maximum BMI** | 29.0 | 29.0 |

Detailed build chart:

| Height | Min Weight | Max Weight |
|--------|-----------|-----------|
| 60" | 97 | 148 |
| 62" | 104 | 158 |
| 64" | 110 | 169 |
| 66" | 118 | 180 |
| 68" | 125 | 191 |
| 70" | 132 | 202 |
| 72" | 140 | 214 |
| 74" | 148 | 226 |
| 76" | 156 | 237 |

#### 2.2.2 Blood Pressure

| Metric | Threshold |
|--------|-----------|
| **Systolic** | ≤ 140 mmHg |
| **Diastolic** | ≤ 85 mmHg |
| **Treatment** | Permitted: up to 1 well-controlled anti-hypertensive medication |
| **Control Requirement** | Must be well-controlled with treatment for ≥ 6 months |

#### 2.2.3 Cholesterol / Lipid Panel

| Metric | Threshold |
|--------|-----------|
| **Total Cholesterol** | ≤ 250 mg/dL |
| **HDL Cholesterol** | ≥ 40 mg/dL (Male), ≥ 45 mg/dL (Female) |
| **TC/HDL Ratio** | ≤ 5.0 |
| **LDL Cholesterol** | ≤ 170 mg/dL |
| **Triglycerides** | ≤ 250 mg/dL |
| **Cholesterol Medication** | Permitted: 1 statin if well-controlled, no adverse effects |

#### 2.2.4 HbA1c / Glucose

| Metric | Threshold |
|--------|-----------|
| **HbA1c** | ≤ 5.9% |
| **Fasting Glucose** | ≤ 115 mg/dL |
| **Non-Fasting Glucose** | ≤ 160 mg/dL |

#### 2.2.5 Family History

| Requirement | Detail |
|-------------|--------|
| **Cardiovascular Death** | No parent or sibling death before age 55 |
| **Cancer Death** | No parent or sibling death from same cancer type before age 55 |
| **Multiple Deaths** | Allows 1 first-degree relative death from any cause before 60 |

#### 2.2.6 Driving Record

| Requirement | Threshold |
|-------------|-----------|
| **DUI/DWI** | None in past 7 years |
| **Moving Violations** | ≤ 2 in past 3 years |
| **Reckless Driving** | None in past 3 years |
| **At-Fault Accidents** | ≤ 1 in past 3 years |

---

### 2.3 Standard Plus Non-Tobacco

Third-tier non-tobacco class. Catches applicants who narrowly miss Preferred.

#### 2.3.1 Build (BMI)

| Metric | Threshold |
|--------|-----------|
| **BMI Range** | 17.5–31.9 |
| **Maximum BMI** | 32.0 |

| Height | Max Weight |
|--------|-----------|
| 60" | 164 |
| 62" | 175 |
| 64" | 186 |
| 66" | 198 |
| 68" | 210 |
| 70" | 223 |
| 72" | 236 |
| 74" | 249 |
| 76" | 262 |

#### 2.3.2 Blood Pressure

| Metric | Threshold |
|--------|-----------|
| **Systolic** | ≤ 145 mmHg |
| **Diastolic** | ≤ 90 mmHg |
| **Treatment** | Up to 2 anti-hypertensive medications permitted |

#### 2.3.3 Cholesterol / Lipid Panel

| Metric | Threshold |
|--------|-----------|
| **Total Cholesterol** | ≤ 280 mg/dL |
| **HDL Cholesterol** | ≥ 35 mg/dL |
| **TC/HDL Ratio** | ≤ 5.5 |
| **Triglycerides** | ≤ 300 mg/dL |

#### 2.3.4 HbA1c / Glucose

| Metric | Threshold |
|--------|-----------|
| **HbA1c** | ≤ 6.1% |
| **Fasting Glucose** | ≤ 125 mg/dL |

#### 2.3.5 Family History

| Requirement | Detail |
|-------------|--------|
| **Cardiovascular Death** | Allows 1 parent death before age 50, or 2 before age 60 |
| **Cancer Death** | Allows parental cancer death before age 50 |

#### 2.3.6 Driving Record

| Requirement | Threshold |
|-------------|-----------|
| **DUI/DWI** | None in past 5 years |
| **Moving Violations** | ≤ 3 in past 3 years |
| **Reckless Driving** | None in past 2 years |

---

### 2.4 Standard Non-Tobacco

Base non-tobacco class. Applicants who meet health and lifestyle standards but exceed preferred thresholds.

#### 2.4.1 Build (BMI)

| Metric | Threshold |
|--------|-----------|
| **BMI Range** | 16.0–36.9 |
| **Maximum BMI** | 37.0 |

| Height | Max Weight |
|--------|-----------|
| 60" | 189 |
| 62" | 202 |
| 64" | 216 |
| 66" | 229 |
| 68" | 243 |
| 70" | 258 |
| 72" | 273 |
| 74" | 288 |
| 76" | 303 |

#### 2.4.2 Blood Pressure

| Metric | Threshold |
|--------|-----------|
| **Systolic** | ≤ 150 mmHg |
| **Diastolic** | ≤ 95 mmHg |
| **Treatment** | Multiple medications permitted |
| **History** | Hypertension diagnosis acceptable |

#### 2.4.3 Cholesterol / Lipid Panel

| Metric | Threshold |
|--------|-----------|
| **Total Cholesterol** | ≤ 300 mg/dL |
| **HDL Cholesterol** | ≥ 30 mg/dL |
| **TC/HDL Ratio** | ≤ 6.5 |
| **Triglycerides** | ≤ 400 mg/dL |

#### 2.4.4 HbA1c / Glucose

| Metric | Threshold |
|--------|-----------|
| **HbA1c** | ≤ 6.4% (≥ 6.5% = diabetes diagnosis, likely substandard) |
| **Fasting Glucose** | ≤ 140 mg/dL |

#### 2.4.5 Other Criteria

| Criterion | Standard Allows |
|-----------|----------------|
| **Family History** | No restrictions beyond general reasonableness |
| **DUI/DWI** | 1 in past 5 years (no more than 2 lifetime) |
| **Moving Violations** | ≤ 4 in past 3 years |
| **Cholesterol Medication** | Multiple medications permitted |
| **Mild Conditions** | Controlled asthma, mild sleep apnea (treated), anxiety/depression (stable, medicated) |

---

### 2.5 Preferred Tobacco

Best tobacco class. For applicants who use tobacco/nicotine but are otherwise in very good health.

#### 2.5.1 Tobacco Definition for Preferred Tobacco

| Product | Classification |
|---------|---------------|
| Cigarettes | Tobacco — disqualifies from PT if > 12 per day or > 1 pack/day equivalent |
| Cigars (≤ 1/month, ceremonial) | May qualify for Non-Tobacco at some carriers; others: PT |
| Pipe | Tobacco |
| Chewing Tobacco / Snuff | Tobacco |
| Nicotine Gum / Patch (active use) | Tobacco |
| E-Cigarettes / Vaping | Tobacco (most carriers since 2019) |
| Marijuana (no nicotine) | Varies — see Section 11 |

#### 2.5.2 Build (BMI)

| Metric | Threshold |
|--------|-----------|
| **BMI Range** | 18.0–28.9 |
| **Maximum BMI** | 29.0 |

#### 2.5.3 Blood Pressure

| Metric | Threshold |
|--------|-----------|
| **Systolic** | ≤ 140 mmHg |
| **Diastolic** | ≤ 85 mmHg |
| **Treatment** | Up to 1 anti-hypertensive medication |

#### 2.5.4 Cholesterol / Lipid Panel

| Metric | Threshold |
|--------|-----------|
| **Total Cholesterol** | ≤ 250 mg/dL |
| **HDL Cholesterol** | ≥ 40 mg/dL |
| **TC/HDL Ratio** | ≤ 5.5 |

#### 2.5.5 Other Criteria

| Criterion | Requirement |
|-----------|------------|
| **HbA1c** | ≤ 5.9% |
| **Family History** | Same as Preferred Non-Tobacco |
| **DUI/DWI** | None in past 7 years |
| **Hazardous Avocations** | None |
| **Alcohol** | No abuse history |

---

### 2.6 Standard Tobacco

Base tobacco class. Any tobacco user who doesn't qualify for Preferred Tobacco.

#### 2.6.1 Criteria

| Criterion | Threshold |
|-----------|-----------|
| **BMI Range** | 16.0–36.9 |
| **Systolic BP** | ≤ 150 mmHg |
| **Diastolic BP** | ≤ 95 mmHg |
| **Total Cholesterol** | ≤ 300 mg/dL |
| **TC/HDL Ratio** | ≤ 6.5 |
| **HbA1c** | ≤ 6.4% |
| **DUI** | ≤ 1 in past 5 years |
| **Tobacco Amount** | Any amount/type |
| **Medications** | Multiple BP and cholesterol meds OK |

---

### 2.7 Comprehensive Risk Class Threshold Summary

| Criterion | PP | PF | SP | SNT | PT | ST |
|-----------|-----|-----|-----|------|-----|-----|
| **Max BMI** | 26.0 | 29.0 | 32.0 | 37.0 | 29.0 | 37.0 |
| **Systolic BP** | ≤130 | ≤140 | ≤145 | ≤150 | ≤140 | ≤150 |
| **Diastolic BP** | ≤80 | ≤85 | ≤90 | ≤95 | ≤85 | ≤95 |
| **Total Cholesterol** | ≤220 | ≤250 | ≤280 | ≤300 | ≤250 | ≤300 |
| **HDL (Male)** | ≥45 | ≥40 | ≥35 | ≥30 | ≥40 | ≥30 |
| **TC/HDL Ratio** | ≤4.5 | ≤5.0 | ≤5.5 | ≤6.5 | ≤5.5 | ≤6.5 |
| **HbA1c** | ≤5.6% | ≤5.9% | ≤6.1% | ≤6.4% | ≤5.9% | ≤6.4% |
| **Fasting Glucose** | ≤99 | ≤115 | ≤125 | ≤140 | ≤115 | ≤140 |
| **BP Meds** | None | 1 | 2 | Multiple | 1 | Multiple |
| **Chol Meds** | None | 1 statin | Allowed | Allowed | 1 statin | Allowed |
| **Family Hx CV Death** | >60 | >55 | >50 | Any | >55 | Any |
| **DUI Lookback** | 10yr | 7yr | 5yr | 5yr | 7yr | 5yr |
| **Max Violations/3yr** | 1 | 2 | 3 | 4 | 2 | 4 |
| **Tobacco** | 5yr free | 5yr free | 5yr free | 5yr free | Current OK | Current OK |
| **Typical Age Range** | 18–65 | 18–70 | 18–70 | 18–80 | 18–70 | 18–80 |

---

## 3. The Debit/Credit System

### 3.1 Overview

The debit/credit system is a **point-based methodology** used by underwriters (and automated engines) to quantify the cumulative mortality impact of multiple risk factors. Each factor is assigned a positive value (debit, indicating increased mortality) or negative value (credit, indicating decreased mortality). The net sum determines the risk class.

### 3.2 How It Works

```
STARTING POINT: Preferred Plus (Best Class)
                      │
        Evaluate each risk factor
                      │
        Assign debits (+) or credits (-)
                      │
        Sum all debits and credits
                      │
        NET SCORE determines risk class
                      │
    ┌─────────────────┼─────────────────┐
    │                 │                 │
 Net ≤ 50         51–125           126–200         201–300         >300
    │                 │                 │               │               │
   PP                PF               SP             SNT          Substandard
```

### 3.3 Standard Debit/Credit Point Schedule

#### 3.3.1 Build (BMI) Debits

| BMI Range | Debits |
|-----------|--------|
| 18.0–20.9 | +15 (underweight) |
| 21.0–23.9 | 0 |
| 24.0–25.9 | +10 |
| 26.0–27.9 | +35 |
| 28.0–29.9 | +75 |
| 30.0–31.9 | +100 |
| 32.0–34.9 | +150 |
| 35.0–37.9 | +200 |
| 38.0–39.9 | +275 |
| 40.0+ | +350 (decline at many carriers) |

#### 3.3.2 Blood Pressure Debits

| Systolic/Diastolic Range | Debits |
|--------------------------|--------|
| ≤120/≤75 | 0 |
| 121–130/76–80 | +15 |
| 131–135/81–85 | +50 |
| 136–140/86–90 | +75 |
| 141–145/91–95 | +125 |
| 146–150/96–100 | +175 |
| >150/>100 | +250+ (often decline) |

*Note: higher of systolic or diastolic reading determines debits.*

#### 3.3.3 Blood Pressure Treatment Debits

| Treatment Status | Debits |
|-----------------|--------|
| No treatment, BP within normal | 0 |
| 1 medication, well-controlled | +50 |
| 2 medications, well-controlled | +100 |
| 3+ medications | +175 |
| Poorly controlled on medication | +250 |

#### 3.3.4 Cholesterol Debits

| Total Cholesterol | Debits |
|-------------------|--------|
| ≤199 | 0 |
| 200–219 | +10 |
| 220–239 | +25 |
| 240–259 | +50 |
| 260–279 | +75 |
| 280–299 | +125 |
| 300–319 | +175 |
| ≥320 | +225 |

| TC/HDL Ratio | Debits |
|-------------|--------|
| ≤3.5 | -25 (credit) |
| 3.6–4.0 | -10 (credit) |
| 4.1–4.5 | 0 |
| 4.6–5.0 | +25 |
| 5.1–5.5 | +50 |
| 5.6–6.0 | +75 |
| 6.1–6.5 | +125 |
| >6.5 | +175 |

#### 3.3.5 HbA1c / Glucose Debits

| HbA1c | Debits |
|-------|--------|
| ≤5.4% | 0 |
| 5.5–5.6% | +15 |
| 5.7–5.9% | +40 |
| 6.0–6.1% | +75 |
| 6.2–6.4% | +125 |
| 6.5–6.9% | +200 (substandard likely) |
| ≥7.0% | +300+ (Table B+ or decline) |

#### 3.3.6 Family History Debits

| Scenario | Debits |
|----------|--------|
| No adverse family history | 0 |
| 1 parent CV death age 55–60 | +25 |
| 1 parent CV death age 50–54 | +50 |
| 1 parent CV death before 50 | +75 |
| 2 parents CV death before 60 | +100 |
| 1 parent cancer death before 60 | +30 |
| 1 parent + 1 sibling same cancer before 60 | +75 |
| Multiple family deaths (3+) before 60 | +125 |
| Huntington's disease in parent | +200 (or decline) |

#### 3.3.7 Driving Record Debits

| Scenario | Debits |
|----------|--------|
| Clean record (0 violations, 0 accidents) | -15 (credit) |
| 1 minor violation in 3 years | +10 |
| 2 minor violations in 3 years | +30 |
| 3 minor violations in 3 years | +60 |
| 1 at-fault accident (no injury) | +25 |
| 1 DUI, 5+ years ago | +75 |
| 1 DUI, 3–5 years ago | +125 |
| 1 DUI, within 3 years | +200 (often decline) |
| 2+ DUI lifetime | +250 (often decline) |
| Reckless driving, past 3 years | +100 |
| License suspension, past 5 years | +75 |

#### 3.3.8 Lifestyle / Avocation Debits

| Activity | Debits |
|----------|--------|
| Private pilot (licensed, IFR rated, >200 hrs) | +50 |
| Private pilot (VFR only, <100 hrs) | +125 |
| Commercial pilot | 0 |
| Skydiving (>25 jumps/year) | +100 |
| Skydiving (≤10 jumps/year) | +50 |
| Scuba diving (>150 ft) | +75 |
| Rock climbing (technical) | +75 |
| Auto racing (amateur) | +100 |
| Motorcycle racing | +125 |
| Hang gliding | +100 |
| Base jumping | Decline |
| Mountain climbing (>18,000 ft) | +125 |

#### 3.3.9 Credits (Favorable Factors)

| Factor | Credit |
|--------|--------|
| Regular exercise (≥3×/week, documented) | -15 |
| Excellent build (BMI 21–23) | -10 |
| Excellent TC/HDL ratio (≤3.5) | -25 |
| No family history of any significance | -15 |
| Clean driving record | -15 |
| Professional/executive occupation | -10 |
| Non-hazardous occupation, stable employment | -5 |
| No prescription medications | -10 |
| Previous favorable insurance history | -10 |
| Regular physician visits with normal results | -10 |

### 3.4 Risk Class Determination from Net Score

| Net Debit Score | Assigned Risk Class |
|----------------|-------------------|
| ≤ 50 | Preferred Plus |
| 51–125 | Preferred |
| 126–200 | Standard Plus |
| 201–300 | Standard Non-Tobacco |
| 301–425 | Table A–B (substandard) |
| 426–550 | Table C–D |
| 551–700 | Table E–H |
| >700 | Table H+ or Decline |

### 3.5 Worked Examples

#### Example 1: Healthy 35-Year-Old Male — Preferred Plus

```
Applicant: Male, age 35, 5'10", 168 lbs
BMI: 24.1 → +10
Blood Pressure: 118/74, no meds → 0
Total Cholesterol: 195, HDL 55, TC/HDL 3.5 → 0 + (-25) = -25
HbA1c: 5.2% → 0
Family History: No adverse → 0
Driving: Clean record → -15
Occupation: Software engineer → -5
Exercise: Runs 4×/week → -15
No meds → -10

TOTAL: +10 + 0 + (-25) + 0 + 0 + (-15) + (-5) + (-15) + (-10) = -60

Net score: -60 → well within PP threshold (≤50)
RESULT: PREFERRED PLUS
```

#### Example 2: 42-Year-Old Female — Preferred

```
Applicant: Female, age 42, 5'6", 162 lbs
BMI: 26.2 → +35
Blood Pressure: 128/78, no meds → +15
Total Cholesterol: 235, HDL 52, TC/HDL 4.5 → +25 + 0 = +25
HbA1c: 5.5% → +15
Family History: Father died of MI at age 58 → +25
Driving: 1 speeding ticket → +10
Occupation: Attorney → -10
No meds → -10

TOTAL: +35 + 15 + 25 + 15 + 25 + 10 + (-10) + (-10) = +105

Net score: 105 → Preferred range (51–125)
RESULT: PREFERRED
```

#### Example 3: 50-Year-Old Male — Standard Plus

```
Applicant: Male, age 50, 5'11", 205 lbs
BMI: 28.6 → +75
Blood Pressure: 138/86, on lisinopril → +50 (treated) + 50 (1 med) = +100
  Wait — use the HIGHER of: reading debits (136-140 range = +75) or treatment debits (+50).
  Typical approach: take treated BP debits = +50 for 1 med, and the reading is within
  controlled range, so: +50 (controlled on 1 med)
Total Cholesterol: 248, HDL 42, TC/HDL 5.9 → +50 + 75 = +125
HbA1c: 5.8% → +40
Family History: Mother breast cancer at 62 (> 60, no debit) → 0
Driving: Clean → -15
Occupation: Construction foreman → +10
No exercise credit, some meds → 0

TOTAL: +75 + 50 + 125 + 40 + 0 + (-15) + 10 = +285

Net score: 285 → Standard Non-Tobacco range (201–300)
RESULT: STANDARD NON-TOBACCO

But wait: this applicant is close to the boundary. An underwriter might grant
Standard Plus if there are offsetting factors. This is where judgment applies.
```

#### Example 4: 38-Year-Old Male Smoker — Preferred Tobacco

```
Applicant: Male, age 38, 5'9", 170 lbs, smokes 5 cigarettes/day
BMI: 25.1 → +10
Blood Pressure: 126/78, no meds → +15
Total Cholesterol: 215, HDL 48, TC/HDL 4.5 → +10 + 0 = +10
HbA1c: 5.3% → 0
Family History: No adverse → 0
Driving: 1 ticket in 3 years → +10
Tobacco: Yes — classified as TOBACCO first
  Within tobacco classes, debits recalculated for PT vs ST
  Light smoker (<10/day) → eligible for PT consideration

TOBACCO DEBIT SCORE: +10 + 15 + 10 + 0 + 0 + 10 = +45
PT threshold: ≤125 for tobacco classes

Net score: 45 → within PT threshold
RESULT: PREFERRED TOBACCO
```

#### Example 5: 55-Year-Old Female — Substandard (Table B)

```
Applicant: Female, age 55, 5'4", 210 lbs
BMI: 36.0 → +200
Blood Pressure: 146/92, on 2 medications → +100 (2 meds) + elevated reading = +150
  (Higher of: reading at 146/92 = +175; treatment 2 meds = +100; take +175)
Total Cholesterol: 285, HDL 38, TC/HDL 7.5 → +125 + 175 = +300
HbA1c: 6.3% → +125
Family History: Father MI at 52, mother stroke at 58 → +50 + 25 = +75
Driving: 1 DUI 6 years ago → +75
Occupation: Office worker → -5

TOTAL: +200 + 175 + 300 + 125 + 75 + 75 + (-5) = +945

Net score: 945 → well into substandard territory (>700)

However, the underwriter would evaluate holistically. Likely outcome:
- If recent labs trending better: Table D–F
- If stable/worsening: Table H or possible decline
- Many carriers would offer Table D (100% extra mortality) with conditions

RESULT: SUBSTANDARD — TABLE D–F depending on holistic review
```

### 3.6 Implementation Notes for the Debit/Credit Engine

```
DebitCreditEngine {
  evaluate(applicantProfile: ApplicantProfile): RiskClassResult {

    score = 0
    details = []

    // Evaluate each factor
    score += evaluateBuild(profile.height, profile.weight)
    score += evaluateBloodPressure(profile.systolic, profile.diastolic, profile.bpMeds)
    score += evaluateCholesterol(profile.totalChol, profile.hdl, profile.ldl, profile.trig)
    score += evaluateGlucose(profile.hba1c, profile.fastingGlucose)
    score += evaluateFamilyHistory(profile.familyHistory[])
    score += evaluateDriving(profile.drivingRecord)
    score += evaluateLifestyle(profile.avocations[])
    score += evaluateCredits(profile)

    // Apply knockout rules (hard stops that override scoring)
    knockouts = evaluateKnockouts(profile)
    if (knockouts.any()) {
      return applyKnockouts(knockouts, score)
    }

    // Map score to risk class
    riskClass = mapScoreToClass(score, profile.tobaccoStatus)

    // Apply age-based restrictions
    riskClass = applyAgeRestrictions(riskClass, profile.age)

    return RiskClassResult {
      class: riskClass,
      score: score,
      details: details,
      knockouts: knockouts,
      overrideEligible: isOverrideEligible(score, riskClass)
    }
  }
}
```

### 3.7 Knockout Rules (Hard Stops)

Certain conditions bypass the debit/credit system entirely and force a minimum class or decline:

| Knockout Condition | Minimum Class | Notes |
|-------------------|---------------|-------|
| Active cancer treatment | Decline or Postpone | Review 1–5 years post-treatment |
| Insulin-dependent diabetes, Type 1 | Table B minimum | With excellent control |
| Type 2 diabetes (HbA1c > 8.0) | Table D minimum | |
| AIDS diagnosis | Decline | Some carriers offer rated with viral suppression |
| HIV positive (viral suppression) | Table D–H | Carrier-specific; emerging market |
| Organ transplant recipient | Table D minimum | Depends on organ, time since |
| Cirrhosis | Table D–H or Decline | Depends on etiology |
| Active substance abuse | Decline or Postpone | |
| Bipolar disorder with hospitalization | Table B–D | Depends on stability |
| Suicide attempt, past 5 years | Decline | |
| Chronic kidney disease Stage 3+ | Table B–D | |
| COPD (moderate-severe) | Table B–F | Based on FEV1 |
| Sleep apnea (untreated) | Standard minimum | |
| BMI > 45 | Decline | |
| Felony conviction, past 5 years | Standard minimum | |

---

## 4. Table Rating (Substandard) System

### 4.1 Overview

Table ratings are used for applicants whose mortality risk exceeds Standard but who are still insurable. The system adds a **percentage of extra mortality** to the base (Standard) rate.

### 4.2 Table Rating Structure

Each table represents an additional 25% of standard mortality:

| Table | Letter | Extra Mortality | Total Mortality (% of Standard) | Typical Premium Impact |
|-------|--------|-----------------|-------------------------------|----------------------|
| 1 | A | +25% | 125% | 1.25× Standard |
| 2 | B | +50% | 150% | 1.50× Standard |
| 3 | C | +75% | 175% | 1.75× Standard |
| 4 | D | +100% | 200% | 2.00× Standard |
| 5 | E | +125% | 225% | 2.25× Standard |
| 6 | F | +150% | 250% | 2.50× Standard |
| 7 | G | +175% | 275% | 2.75× Standard |
| 8 | H | +200% | 300% | 3.00× Standard |
| 9 | I (rare) | +225% | 325% | 3.25× Standard |
| 10 | J (rare) | +250% | 350% | 3.50× Standard |
| 11 | K | +275% | 375% | 3.75× Standard |
| 12 | L | +300% | 400% | 4.00× Standard |
| 13 | M | +325% | 425% | 4.25× Standard |
| 14 | N | +350% | 450% | 4.50× Standard |
| 15 | O | +375% | 475% | 4.75× Standard |
| 16 | P | +400% | 500% | 5.00× Standard |

### 4.3 When to Use Each Table — Common Impairments

| Impairment | Typical Table Rating | Duration |
|------------|---------------------|----------|
| Type 2 Diabetes, well-controlled (HbA1c 7.0–7.5) | B–C | Permanent |
| Type 2 Diabetes, moderate control (HbA1c 7.5–8.5) | D–F | Permanent |
| Type 1 Diabetes, excellent control | B–D | Permanent |
| Coronary Artery Disease (1-vessel, treated, stable) | C–D | Permanent |
| Coronary Artery Disease (multi-vessel, post-CABG) | D–H | Permanent |
| Atrial Fibrillation (controlled) | B–C | Permanent |
| Stroke/TIA (1 event, >2 years, no residual) | C–D | Permanent |
| Hepatitis C (treated, SVR achieved) | A–B | May improve to Standard |
| Chronic Kidney Disease Stage 3a | B–C | Permanent |
| Bipolar Disorder (stable, medicated, no hospitalization) | B–C | Permanent |
| Depression with multiple hospitalizations | C–D | Permanent |
| Crohn's Disease / Ulcerative Colitis (moderate) | A–B | Permanent |
| Sleep Apnea (treated with CPAP, compliant) | Standard | No table needed |
| Sleep Apnea (untreated) | A–B | Until treated |
| Obesity (BMI 35–39) | A–C | Weight-dependent |
| Obesity (BMI 40–45) | D–F | Weight-dependent |
| Alcohol Abuse History (sober 5+ years) | A–B | May improve |
| Alcohol Abuse History (sober 2–5 years) | C–D | |
| Cancer — breast Stage I (5+ years post-treatment) | A | May remove at 10 years |
| Cancer — colon Stage II (3+ years post-treatment) | B–D | |
| Cancer — melanoma in situ (>1 year) | Standard | |
| Cancer — prostate (Gleason ≤6, treated) | Standard–A | |
| Cancer — lung (treated, 5+ years) | D–H | |
| HIV (well-managed, undetectable viral load) | D–H | Emerging guidelines |

### 4.4 Premium Calculation with Table Ratings

#### Worked Example: Table C Rating

```
Base Information:
  Applicant: Male, Age 45
  Face Amount: $500,000
  Term: 20 years
  Standard Non-Tobacco Annual Premium: $1,200

Table C = 175% of Standard mortality

Premium Calculation:
  The extra mortality portion only applies to the mortality cost component.
  Typically, mortality cost ≈ 60–70% of total premium.

  Method 1: Simple (used by many carriers)
    Table C Premium = Standard Premium × 1.75
    = $1,200 × 1.75
    = $2,100/year

  Method 2: Component-Based (more precise)
    Standard Premium breakdown:
      Mortality cost: $780 (65% of $1,200)
      Expenses: $240 (20%)
      Profit/contingency: $180 (15%)

    Table C Mortality = $780 × 1.75 = $1,365
    Expenses: $240 (unchanged)
    Profit: $180 × 1.10 = $198 (slight increase for higher risk)

    Table C Premium = $1,365 + $240 + $198 = $1,803/year

  Reality: Most carriers use a blend, often closer to Method 1 for
  simplicity, resulting in $1,900–$2,100 for this example.
```

#### Worked Example: Table F Rating

```
Base Information:
  Applicant: Female, Age 52
  Face Amount: $300,000
  Term: 20 years
  Standard Non-Tobacco Annual Premium: $1,050

Table F = 250% of Standard mortality

  Table F Premium = Standard Premium × 2.50
  = $1,050 × 2.50
  = $2,625/year

  Monthly: $2,625 / 12 × 1.05 (modal factor) = $229.69/month
```

### 4.5 Table Rating vs. Flat Extra — Decision Framework

| Factor | Use Table Rating | Use Flat Extra |
|--------|-----------------|---------------|
| **Risk Nature** | Permanent, increasing with age | Temporary, constant over time |
| **Mortality Pattern** | Extra mortality proportional to base mortality | Extra mortality constant (does not increase with age) |
| **Typical Conditions** | Chronic diseases, genetic conditions | Avocations, recent cancer history, foreign travel |
| **Age Sensitivity** | Yes — cost increases with age | No — fixed per $1,000 |
| **Duration** | Usually permanent | Often temporary (3–10 years) |
| **Reinsurance** | Standard reinsurance treatment | May require facultative placement |
| **Premium Impact** | Multiplicative | Additive |
| **Example** | Diabetes → Table B (permanent) | Cancer remission → $5/1000 flat extra for 5 years |

### 4.6 Multiple Table Ratings

When an applicant has multiple impairments, tables may be **combined**:

```
Method: Additive (most common)
  Impairment 1: Type 2 Diabetes → Table C (+75%)
  Impairment 2: Sleep Apnea (untreated) → Table A (+25%)
  Combined: Table D (+100%)

Method: Multiplicative (less common, used by some reinsurers)
  Impairment 1: 175% mortality
  Impairment 2: 125% mortality
  Combined: 175% × 125% = 219% → Table D–E

Note: The additive method is more generous to the applicant and is
the industry standard for most carriers.
```

### 4.7 Maximum Table Rating Limits

| Carrier Type | Typical Maximum Table | Notes |
|-------------|----------------------|-------|
| Large National Carrier | Table H (300%) | Above H → Decline |
| Specialty/Impaired Risk Carrier | Table P (500%) | Niche market |
| Reinsurer Automatic Limit | Table D–F | Above requires facultative |
| Group/Worksite | Table B (150%) | Simplified UW limits |

---

## 5. Flat Extra Premiums

### 5.1 Definition

A flat extra premium is a **fixed additional charge per $1,000 of face amount** added to the base premium. Unlike table ratings, flat extras do not increase with age.

### 5.2 Types of Flat Extras

#### 5.2.1 Temporary Flat Extra

- Applied for a **defined period** (typically 1–10 years).
- Used when the extra risk is expected to **diminish over time**.
- Examples: cancer in remission, recent surgery recovery, time-limited foreign travel.

#### 5.2.2 Permanent Flat Extra

- Applied for the **entire policy duration**.
- Used when the extra risk is **constant** regardless of age progression.
- Examples: hazardous avocation (ongoing), certain chronic conditions.

### 5.3 Common Flat Extra Scenarios

| Scenario | Flat Extra (per $1,000) | Duration | Notes |
|----------|------------------------|----------|-------|
| **Aviation — Private Pilot (IFR, >500 hrs)** | $2.50/1000 | Permanent | Removes if pilot stops flying |
| **Aviation — Private Pilot (VFR, <200 hrs)** | $5.00/1000 | Permanent | Higher risk profile |
| **Aviation — Student Pilot** | $7.50/1000 | Until licensed + 100 hrs | Re-evaluate after |
| **Aviation — Commercial/ATP Rated** | $0 | N/A | Standard rates |
| **Skydiving (≤25 jumps/year)** | $3.50/1000 | Permanent | |
| **Skydiving (>25 jumps/year)** | $5.00–$7.50/1000 | Permanent | |
| **Scuba (>150 ft depth)** | $2.50/1000 | Permanent | |
| **Rock Climbing (technical/lead)** | $3.00/1000 | Permanent | |
| **Auto/Motorcycle Racing** | $5.00–$10.00/1000 | Permanent | |
| **Mountain Climbing (>14,000 ft)** | $3.00/1000 | Permanent | |
| **Mountain Climbing (>20,000 ft)** | $7.50/1000 | Permanent | |
| **Cancer — Breast Stage I (2–5 yrs post)** | $5.00/1000 | 5 years | May reduce to $2.50 after 5 yrs |
| **Cancer — Breast Stage I (5–10 yrs post)** | $2.50/1000 | 5 years | May remove at 10 years |
| **Cancer — Colon Stage II (3–5 yrs post)** | $7.50/1000 | 7 years | |
| **Cancer — Prostate (Gleason ≤6, 2+ yrs)** | $2.50/1000 | 5 years | |
| **Cancer — Melanoma (thin, treated)** | $2.50/1000 | 3 years | |
| **Foreign Travel — Moderate Risk Country** | $3.00/1000 | Temporary (trip duration + 1 yr) | |
| **Foreign Travel — High Risk Country** | $7.50–$15.00/1000 | Temporary | War zone travel may be declined |
| **Military — Active Duty (non-combat)** | $2.50/1000 | Duration of service | |
| **Military — Combat Zone** | $7.50–$15.00/1000 | Duration of deployment | Often excluded instead |
| **Recent DUI (3–5 years ago)** | $2.50/1000 | 3–5 years | Concurrent with class downgrade |

### 5.4 Flat Extra Premium Calculation

#### Worked Example: Flat Extra for Aviation

```
Applicant: Male, Age 40
Face Amount: $1,000,000
Term: 20 years
Risk Class: Preferred Non-Tobacco
Base Annual Premium: $1,450

Flat Extra: $2.50 per $1,000 (permanent, private pilot)

Flat Extra Annual Cost = Face Amount / 1,000 × Flat Extra Rate
  = $1,000,000 / 1,000 × $2.50
  = $2,500/year

Total Annual Premium = Base + Flat Extra
  = $1,450 + $2,500
  = $3,950/year

Impact: The flat extra nearly triples the premium — a significant
consideration for the applicant and agent.
```

#### Worked Example: Temporary Flat Extra for Cancer History

```
Applicant: Female, Age 45
Face Amount: $500,000
Term: 20 years
Risk Class: Standard Non-Tobacco (downgraded from Preferred due to cancer history)
Base Annual Premium: $980

Flat Extra: $5.00 per $1,000 for 5 years (breast cancer Stage I, 3 years post-treatment)

Flat Extra Annual Cost = $500,000 / 1,000 × $5.00 = $2,500/year

Premium Structure:
  Years 1–5:  $980 + $2,500 = $3,480/year
  Years 6–20: $980/year (flat extra removed)

Total Premium over 20 years:
  = (5 × $3,480) + (15 × $980)
  = $17,400 + $14,700
  = $32,100

Compare to 20 years at base: 20 × $980 = $19,600
Total flat extra impact: $12,500 additional premium
```

### 5.5 Flat Extra Combined with Table Rating

Some applicants receive **both** a table rating and a flat extra:

```
Example: Male, Age 48, Type 2 Diabetes (well-controlled) + Private Pilot

Table Rating: Table B (+50%) for diabetes → permanent
Flat Extra: $2.50/1000 for aviation → permanent

Standard Annual Premium (20-year, $500K): $1,400

Table B Premium: $1,400 × 1.50 = $2,100
Aviation Flat Extra: $500,000 / 1,000 × $2.50 = $1,250

Total Annual Premium: $2,100 + $1,250 = $3,350/year
```

### 5.6 Flat Extra Administration

| Aspect | Detail |
|--------|--------|
| **Billing** | Flat extra is a separate line item on premium notice |
| **Commission** | Agents typically earn commission on flat extra (same rate as base) |
| **Reinsurance** | Flat extra is passed through to reinsurer at same rate or facultative |
| **Renewal** | Temporary flat extras auto-expire; system must track expiry date |
| **Reconsideration** | Insured can request removal after specified period with evidence |
| **Conversion** | Flat extras typically carry over to converted permanent policy |

---

## 6. Exclusion Riders

### 6.1 Definition

An exclusion rider **eliminates coverage** for death resulting from a specific cause or activity. The insured pays standard (or rated) premiums but receives no death benefit if death results from the excluded activity.

### 6.2 When to Use Exclusions vs. Ratings

| Factor | Exclusion | Rating (Table/Flat Extra) |
|--------|-----------|--------------------------|
| **Risk is binary** | Yes — death either is or isn't from the activity | No |
| **Risk is quantifiable** | Difficult to price precisely | Can be priced actuarially |
| **Applicant preference** | Avoids high premium | Maintains full coverage |
| **Claim adjudication** | Complex — must determine cause of death | Simple — full coverage |
| **State restrictions** | Some states limit exclusions | Generally permitted |
| **Common use** | Aviation, specific avocations | Medical conditions |

### 6.3 Types of Exclusion Riders

#### 6.3.1 Aviation Exclusion

- Excludes death while operating, learning to operate, or serving as a crew member of any aircraft.
- Does **NOT** exclude death as a fare-paying passenger on a commercial airline.
- Variants:
  - **Broad aviation exclusion**: all non-commercial aviation
  - **Specific aircraft exclusion**: excludes only certain types (e.g., ultralight, experimental)
  - **Pilot-only exclusion**: excludes only when serving as pilot-in-command

#### 6.3.2 Avocation Exclusion

- Excludes death resulting from participation in a specific hazardous activity.
- Common exclusions: skydiving, base jumping, hang gliding, auto racing, mountain climbing above certain altitude.
- Must be **specifically named** — cannot be a blanket "hazardous activity" exclusion in most states.

#### 6.3.3 Foreign Travel/Residence Exclusion

- Excludes death occurring in or resulting from travel to a specified country or region.
- Used for applicants with regular travel to high-risk regions.
- May be temporary (tied to specific planned travel) or permanent.

#### 6.3.4 Military/War Exclusion

- Rare in individual policies since the Servicemembers' Group Life Insurance (SGLI) program exists.
- Some carriers exclude death resulting from act of war or military combat.
- Limited by state regulation in many jurisdictions.

#### 6.3.5 Illegal Activity Exclusion

- Standard in most policies (not a rider but a policy provision).
- Excludes death while committing a felony.

### 6.4 State Restrictions on Exclusion Riders

| State Category | Restrictions |
|---------------|-------------|
| **Restrictive States** (CA, NY, NJ, FL, MA, CT) | Aviation exclusions limited or prohibited; avocation exclusions must be specific; some require minimum coverage regardless |
| **Moderate States** (TX, PA, IL, OH, GA) | Aviation exclusions permitted; avocation exclusions require specific naming; foreign travel exclusions limited |
| **Permissive States** (Most other states) | Broad exclusion authority; carrier discretion on exclusion type |

Specific state examples:

| State | Restriction |
|-------|------------|
| **New York** | Aviation exclusions prohibited for policies issued in NY; avocation exclusions limited |
| **California** | Aviation exclusions must include "learning to operate" exception for licensed pilots; cannot exclude commercial aviation passengers |
| **Florida** | Foreign travel exclusions limited to specific named countries; cannot exclude entire continents |
| **Connecticut** | War exclusions prohibited in individual life policies |
| **Montana** | Exclusion riders must be approved by state insurance department individually |

### 6.5 Exclusion Rider Implementation

```
ExclusionRider {
  type:          Enum    // AVIATION | AVOCATION | FOREIGN_TRAVEL | MILITARY | OTHER
  description:   String  // Specific activity excluded
  effective:     Date
  expiry:        Date?   // null = permanent
  stateApproval: Map<State, Boolean>  // Track state-by-state approval status
  claimImpact:   String  // "Death benefit denied if death results from [description]"
}

// Claim adjudication logic
evaluateExclusion(claim: Claim, rider: ExclusionRider): ExclusionResult {
  if (claim.causeOfDeath.relatedTo(rider.description)) {
    return EXCLUDED  // No death benefit paid
  }
  return COVERED  // Normal claim payment
}
```

---

## 7. Mortality Tables Deep Dive

### 7.1 What Are Mortality Tables?

Mortality tables (also called life tables) provide the **probability of death** at each age for a defined population. They are the foundation of life insurance pricing.

### 7.2 Key Mortality Tables Used in US Life Insurance

| Table | Year | Purpose | Issued By |
|-------|------|---------|-----------|
| **2017 CSO** | 2017 (effective 2020) | Statutory reserves and nonforfeiture values | NAIC / SOA |
| **2015 VBT** | 2015 | Pricing and risk classification | SOA |
| **2008 VBT** | 2008 | Pricing (legacy) | SOA |
| **2001 VBT** | 2001 | Pricing (legacy) | SOA |
| **2001 CSO** | 2001 | Statutory reserves (prior standard) | NAIC |
| **1980 CSO** | 1980 | Historical reference only | NAIC |

### 7.3 CSO vs. VBT — Critical Distinction

| Aspect | CSO (Commissioners Standard Ordinary) | VBT (Valuation Basic Table) |
|--------|--------------------------------------|----------------------------|
| **Purpose** | Minimum statutory reserves, cash values, nonforfeiture | Pricing, risk selection, product design |
| **Mandated by** | State regulators via NAIC model law | Not mandated; industry best practice |
| **Mortality Basis** | Loaded (margins added for conservatism) | Unloaded (best-estimate mortality) |
| **Who Uses** | Valuation actuaries, compliance | Pricing actuaries, underwriters |
| **Risk Classes** | Smoker/Non-Smoker, Male/Female (limited classes) | Multi-class: PP, PF, SP, SNT, PT, ST and more |
| **Relevance to UW** | Indirect (sets floor for reserves) | Direct (drives premium calculation) |

### 7.4 2017 CSO Mortality Table — Sample Rates

Rates shown as deaths per 1,000 lives (qx):

#### 7.4.1 Male Non-Smoker (2017 CSO)

| Age | qx (per 1,000) | Age | qx (per 1,000) |
|-----|----------------|-----|----------------|
| 20 | 0.49 | 50 | 2.23 |
| 25 | 0.52 | 55 | 3.73 |
| 30 | 0.56 | 60 | 6.34 |
| 35 | 0.68 | 65 | 10.78 |
| 40 | 0.92 | 70 | 17.44 |
| 45 | 1.42 | 75 | 28.93 |

#### 7.4.2 Female Non-Smoker (2017 CSO)

| Age | qx (per 1,000) | Age | qx (per 1,000) |
|-----|----------------|-----|----------------|
| 20 | 0.23 | 50 | 1.34 |
| 25 | 0.26 | 55 | 2.18 |
| 30 | 0.30 | 60 | 3.62 |
| 35 | 0.38 | 65 | 6.12 |
| 40 | 0.54 | 70 | 10.53 |
| 45 | 0.84 | 75 | 18.46 |

#### 7.4.3 Male Smoker (2017 CSO)

| Age | qx (per 1,000) | Age | qx (per 1,000) |
|-----|----------------|-----|----------------|
| 20 | 0.98 | 50 | 5.58 |
| 25 | 1.12 | 55 | 9.33 |
| 30 | 1.25 | 60 | 15.21 |
| 35 | 1.56 | 65 | 24.17 |
| 40 | 2.21 | 70 | 38.60 |
| 45 | 3.44 | 75 | 60.85 |

### 7.5 2015 VBT — Select and Ultimate Structure

The 2015 VBT uses a **select and ultimate** structure:

- **Select period**: The first 25 years after policy issue, mortality rates are **lower** because recently underwritten lives are healthier than the general population (the "underwriting selection effect").
- **Ultimate period**: After the select period, mortality rates converge to the general insured population rates.

Select and ultimate rates, Male Non-Smoker Preferred (2015 VBT, per 1,000):

| Issue Age | Duration 1 | Duration 5 | Duration 10 | Duration 15 | Duration 20 | Ultimate |
|-----------|-----------|-----------|------------|------------|------------|---------|
| 25 | 0.12 | 0.16 | 0.28 | 0.52 | 1.04 | 2.15 |
| 30 | 0.13 | 0.19 | 0.35 | 0.68 | 1.38 | 2.85 |
| 35 | 0.16 | 0.24 | 0.48 | 0.95 | 1.89 | 3.92 |
| 40 | 0.22 | 0.35 | 0.72 | 1.42 | 2.78 | 5.75 |
| 45 | 0.32 | 0.55 | 1.12 | 2.18 | 4.24 | 8.78 |
| 50 | 0.48 | 0.85 | 1.75 | 3.42 | 6.65 | 13.75 |
| 55 | 0.76 | 1.35 | 2.82 | 5.48 | 10.52 | 21.82 |
| 60 | 1.22 | 2.25 | 4.72 | 9.12 | 17.18 | 35.62 |

### 7.6 Mortality Rates by Risk Class (2015 VBT Derived)

Male, Issue Age 35, Duration 1 (first year after underwriting):

| Risk Class | qx (per 1,000) | Ratio to Standard |
|------------|----------------|-------------------|
| Preferred Plus | 0.12 | 0.36 |
| Preferred | 0.18 | 0.55 |
| Standard Plus | 0.25 | 0.76 |
| Standard NS | 0.33 | 1.00 |
| Preferred Tobacco | 0.52 | 1.58 |
| Standard Tobacco | 0.85 | 2.58 |

Male, Issue Age 35, Duration 10:

| Risk Class | qx (per 1,000) | Ratio to Standard |
|------------|----------------|-------------------|
| Preferred Plus | 0.32 | 0.42 |
| Preferred | 0.44 | 0.58 |
| Standard Plus | 0.58 | 0.76 |
| Standard NS | 0.76 | 1.00 |
| Preferred Tobacco | 1.38 | 1.82 |
| Standard Tobacco | 2.25 | 2.96 |

### 7.7 Mortality Improvement Factors

Mortality rates generally **improve** over time due to medical advances, better treatments, and healthier lifestyles. Actuaries apply **mortality improvement factors** to adjust base table rates.

| Source | Improvement Factor | Notes |
|--------|-------------------|-------|
| **SOA Scale MP-2021** | Age/gender-specific | Updated annually; 2D model (age × calendar year) |
| **SOA Scale AA** | ~1% per year average | Older scale, simpler |
| **Carrier-Specific** | Varies 0.5–2.0% per year | Based on proprietary experience |

Example of mortality improvement application:

```
Base Rate (2015 VBT): Male Age 45 Non-Smoker Preferred = 0.55 per 1,000
Improvement Factor: 1.2% per year
Years since table: 10 (pricing for 2025 policy)

Improved Rate = 0.55 × (1 - 0.012)^10
             = 0.55 × 0.8864
             = 0.488 per 1,000

The 10 years of improvement reduced expected mortality by ~11%.
```

### 7.8 Aggregate vs. Select & Ultimate Mortality

| Approach | Description | Use Case |
|----------|-------------|----------|
| **Aggregate** | Single mortality rate at each age, regardless of policy duration | Simplified pricing, regulatory reserves |
| **Select & Ultimate** | Different rates by duration since issue + age | Accurate term pricing, reinsurance |
| **Select Period** | Typically 15–25 years; recently underwritten lives have lower mortality | Critical for term products (10, 20, 30 year) |
| **Wear-Off** | Select advantage diminishes over time as underwriting "wears off" | Models lapse-supported pricing |

### 7.9 Gender-Based Mortality Differences

| Age | Male qx (per 1,000) | Female qx (per 1,000) | Male/Female Ratio |
|-----|---------------------|----------------------|-------------------|
| 25 | 0.52 | 0.26 | 2.00 |
| 35 | 0.68 | 0.38 | 1.79 |
| 45 | 1.42 | 0.84 | 1.69 |
| 55 | 3.73 | 2.18 | 1.71 |
| 65 | 10.78 | 6.12 | 1.76 |
| 75 | 28.93 | 18.46 | 1.57 |

Males have consistently higher mortality than females across all ages, with the ratio narrowing at advanced ages.

---

## 8. Premium Calculation — From Mortality Rate to Gross Premium

### 8.1 Premium Components

Every life insurance premium consists of:

```
GROSS PREMIUM = Mortality Cost
              + Expense Loading
              + Profit Margin
              + Contingency / Risk Charge
              + Commission Loading
              - Investment Income Credit
              + Premium Tax Loading
```

### 8.2 Component Breakdown

| Component | Typical % of Premium | Description |
|-----------|---------------------|-------------|
| **Mortality Cost** | 30–55% | Expected death claims |
| **Expense Loading** | 15–25% | Administrative costs: underwriting, issue, maintenance |
| **Commission** | 15–30% | Agent/broker compensation (first year higher) |
| **Profit Margin** | 5–10% | Target profit for the carrier |
| **Contingency** | 2–5% | Buffer for adverse experience deviation |
| **Premium Tax** | 2–3% | State premium tax (avg ~2.25%) |
| **Investment Credit** | -5 to -15% | Offset from investing reserves |

### 8.3 Worked Example: 35-Year-Old Male, Preferred, $500K, 20-Year Term

#### Step 1: Determine Expected Mortality Cost

Using 2015 VBT Select rates for Male Preferred, Issue Age 35:

| Policy Year | Age | qx (per 1,000) | Expected Claims per $500K | Discount Factor (4.5%) | PV of Claims |
|-------------|-----|----------------|--------------------------|----------------------|-------------|
| 1 | 35 | 0.16 | $80.00 | 0.9569 | $76.55 |
| 2 | 36 | 0.17 | $85.00 | 0.9157 | $77.83 |
| 3 | 37 | 0.18 | $90.00 | 0.8763 | $78.87 |
| 4 | 38 | 0.20 | $100.00 | 0.8386 | $83.86 |
| 5 | 39 | 0.22 | $110.00 | 0.8025 | $88.27 |
| 6 | 40 | 0.25 | $125.00 | 0.7679 | $95.99 |
| 7 | 41 | 0.28 | $140.00 | 0.7348 | $102.87 |
| 8 | 42 | 0.32 | $160.00 | 0.7032 | $112.51 |
| 9 | 43 | 0.37 | $185.00 | 0.6729 | $124.49 |
| 10 | 44 | 0.42 | $210.00 | 0.6439 | $135.22 |
| 11 | 45 | 0.49 | $245.00 | 0.6162 | $150.97 |
| 12 | 46 | 0.56 | $280.00 | 0.5897 | $165.12 |
| 13 | 47 | 0.65 | $325.00 | 0.5643 | $183.40 |
| 14 | 48 | 0.75 | $375.00 | 0.5400 | $202.50 |
| 15 | 49 | 0.87 | $435.00 | 0.5167 | $224.76 |
| 16 | 50 | 1.01 | $505.00 | 0.4945 | $249.72 |
| 17 | 51 | 1.18 | $590.00 | 0.4732 | $279.19 |
| 18 | 52 | 1.37 | $685.00 | 0.4528 | $310.17 |
| 19 | 53 | 1.58 | $790.00 | 0.4333 | $342.31 |
| 20 | 54 | 1.82 | $910.00 | 0.4146 | $377.29 |

**Total PV of Expected Claims = $3,461.89**

#### Step 2: Convert to Level Annual Premium (Net Premium)

PV of annuity-due factor for 20 years at 4.5% = 13.5903

```
Net Annual Premium = PV of Expected Claims / Annuity Factor
                   = $3,461.89 / 13.5903
                   = $254.73/year
```

#### Step 3: Add Expense Loading

| Expense Category | Amount | Basis |
|-----------------|--------|-------|
| First-year acquisition (medical, APS, inspection) | $150 | Per policy |
| Annual administration | $60 | Per policy per year |
| Policy issue cost | $100 | One-time |
| Technology/data costs | $25 | Per policy per year |

```
PV of Expenses = $150 + $100 + ($60 + $25) × Annuity Factor
               = $250 + $85 × 13.5903
               = $250 + $1,155.18
               = $1,405.18

Expense Loading per Year = $1,405.18 / 13.5903 = $103.38/year
```

#### Step 4: Add Commission Loading

| Year | Commission Rate | Level Premium Equivalent |
|------|----------------|------------------------|
| Year 1 | 100% of annual premium | Spread over 20 years |
| Years 2–10 | 5% of annual premium | |
| Years 11–20 | 2% of annual premium | |

Commission is typically embedded as a percentage loading. For this example, assume 22% of gross premium is commission:

```
Commission Loading Factor = 1 / (1 - 0.22) = 1.2821
```

#### Step 5: Add Profit, Contingency, and Tax

| Item | Loading Factor |
|------|---------------|
| Profit margin | 7% |
| Contingency | 3% |
| Premium tax | 2.25% |
| **Total additional** | **12.25%** |

```
Loading Factor = 1 / (1 - 0.1225) = 1.1396
```

#### Step 6: Calculate Gross Premium

```
Gross Annual Premium = (Net Premium + Expense Loading) × Commission Factor × Other Loadings
                     = ($254.73 + $103.38) × 1.2821 × 1.1396
                     = $358.11 × 1.2821 × 1.1396
                     = $358.11 × 1.4612
                     = $523.25/year

Rounded to nearest $5: $525/year
Monthly equivalent: $525 / 12 × 1.0833 (modal factor) = $47.40/month
```

#### Step 7: Competitive Adjustment

The actuarial premium is then compared against competitive market rates:

| Carrier | 35M PF $500K 20yr Annual Premium |
|---------|----------------------------------|
| Carrier A | $485 |
| Carrier B | $510 |
| Carrier C | $535 |
| **Our Calculation** | **$525** |
| Carrier D | $545 |
| Carrier E | $560 |

The calculated premium of $525 is competitive. The pricing actuary may adjust to $510–$520 to improve market position.

### 8.4 Premium Rate Bands

Face amount affects per-unit cost due to **fixed expenses being spread** over more coverage:

| Face Amount Band | Per-$1,000 Rate (35M PF 20yr) | Annual Premium |
|-----------------|-------------------------------|----------------|
| $100K–$249K | $1.25 | $125–$311 |
| $250K–$499K | $1.10 | $275–$549 |
| $500K–$999K | $1.05 | $525–$1,049 |
| $1M–$2.49M | $0.95 | $950–$2,368 |
| $2.5M–$4.99M | $0.88 | $2,200–$4,395 |
| $5M+ | $0.82 | $4,100+ |

### 8.5 Premium by Risk Class — Full Rate Card Example

Male, Age 35, $500,000, 20-Year Level Term:

| Risk Class | Annual Premium | Monthly Premium | Per $1,000/yr |
|------------|---------------|----------------|---------------|
| Preferred Plus | $365 | $32.95 | $0.73 |
| Preferred | $525 | $47.40 | $1.05 |
| Standard Plus | $685 | $61.85 | $1.37 |
| Standard NT | $845 | $76.30 | $1.69 |
| Preferred Tobacco | $1,350 | $121.85 | $2.70 |
| Standard Tobacco | $2,125 | $191.85 | $4.25 |
| Table A (SNT + 25%) | $1,056 | $95.35 | $2.11 |
| Table B (SNT + 50%) | $1,268 | $114.45 | $2.54 |
| Table D (SNT + 100%) | $1,690 | $152.60 | $3.38 |
| Table H (SNT + 200%) | $2,535 | $228.90 | $5.07 |

---

## 9. Actuarial Pricing Concepts

### 9.1 Expected Claims

```
Expected Claims in Year t = Number of Lives in Force × qx(t) × Average Face Amount

For a cohort of 10,000 policies, Male Age 35 Preferred, $500K:
  Year 1: 10,000 × 0.00016 × $500,000 = $800,000
  Year 10: 9,980 × 0.00042 × $500,000 = $2,095,800
  Year 20: 6,500* × 0.00182 × $500,000 = $5,915,000

  * Reduced by lapses (assumes 65% persistency at year 20)
```

### 9.2 Present Value of Future Benefits (PVFB)

The actuarial present value accounts for both mortality and the time value of money:

```
PVFB = Σ (from t=1 to n) [ tpx × qx+t × v^t × Face Amount ]

Where:
  tpx  = probability of surviving t years from issue
  qx+t = probability of death in year t+1
  v    = discount factor = 1/(1+i)
  i    = investment yield assumption
  n    = policy term
```

### 9.3 Net Premium (Benefit Premium)

The net premium is the amount needed each year to fund expected death benefits exactly:

```
Net Premium × äx:n⌉ = PVFB

Where:
  äx:n⌉ = present value of annuity-due for n years
        = Σ (from t=0 to n-1) [ tpx × v^t ]

Net Premium = PVFB / äx:n⌉
```

### 9.4 Gross Premium

The gross premium adds all expense, profit, and commission loadings to the net premium:

```
Gross Premium = Net Premium / (1 - total loading percentage)

Or equivalently:

G × äx:n⌉ = PVFB + PVFE (PV of Future Expenses) + Profit Target

Where:
  PVFE = PV of per-policy expenses + PV of percentage-of-premium expenses
```

### 9.5 Modal Factors

Premiums can be paid at different frequencies. Modal factors account for lost investment income and administrative cost:

| Payment Mode | Modal Factor | Annual Premium → Mode Premium |
|-------------|-------------|------------------------------|
| Annual | 1.000 | $1,000 → $1,000 |
| Semi-Annual | 0.515 | $1,000 → $515 × 2 = $1,030 |
| Quarterly | 0.263 | $1,000 → $263 × 4 = $1,052 |
| Monthly (list bill) | 0.0875 | $1,000 → $87.50 × 12 = $1,050 |
| Monthly (PAC/EFT) | 0.0850 | $1,000 → $85.00 × 12 = $1,020 |

PAC (Pre-Authorized Check) / EFT gets a lower modal factor due to reduced billing costs and better persistency.

### 9.6 Policy Fee

Many carriers charge a flat **policy fee** in addition to the per-$1,000 rate:

| Carrier | Annual Policy Fee | Notes |
|---------|------------------|-------|
| Typical Range | $50–$100 | Added to annual premium |
| High Face (≥$1M) | Often waived | Competitive consideration |
| Small Face (<$100K) | $75–$120 | Higher fee to cover fixed costs |

```
Total Annual Premium = (Per-$1,000 Rate × Face Amount / 1,000) + Policy Fee

Example: $1.05/1000 × 500 + $75 = $525 + $75 = $600
```

### 9.7 Lapse Rate Assumptions

Lapse rates profoundly affect term pricing. Level-premium term products are "lapse-supported" — premiums assume a certain percentage of policies will lapse, especially healthy lives:

| Policy Year | Typical Lapse Rate | Cumulative Persistency |
|-------------|-------------------|----------------------|
| 1 | 6–8% | 92–94% |
| 2 | 5–7% | 86–88% |
| 3 | 4–6% | 82–84% |
| 4 | 3–5% | 79–81% |
| 5 | 3–5% | 75–78% |
| 6–10 | 3–4% per year | 60–70% |
| 11–15 | 2–3% per year | 50–62% |
| 16–19 | 2–3% per year | 42–55% |
| 20 (term end) | 80–95% shock lapse | 3–10% remaining |

The **shock lapse** at term end is critical: nearly all policyholders lapse or convert when level premiums expire and post-level rates spike (often 5–10× the level premium).

### 9.8 Reserve Methodology

| Reserve Type | Standard | Description |
|-------------|----------|-------------|
| **Net Premium Reserve** | CRVM (Commissioners Reserve Valuation Method) | Statutory minimum reserve |
| **Deficiency Reserve** | If gross premium < net premium by CSO | Additional reserve required |
| **GAAP Reserve** | ASC 944 (FAS 60/97) | GAAP financial reporting |
| **Tax Reserve** | IRC Section 807 | Federal income tax basis |
| **Economic Reserve** | Internal, best-estimate | Management decision-making |

### 9.9 Profit Metrics

| Metric | Target | Description |
|--------|--------|-------------|
| **IRR (Internal Rate of Return)** | 12–18% | Return on statutory capital deployed |
| **ROE (Return on Equity)** | 10–15% | After-tax return on required capital |
| **Profit Margin** | 5–10% of premium | Pre-tax profit as % of gross premium |
| **Break-Even Year** | Year 5–8 | When cumulative profits turn positive |
| **Embedded Value** | Varies | PV of future distributable earnings |
| **New Business Strain** | -150 to -250% of first year premium | Negative profit in year 1 due to acquisition costs |

---

## 10. Experience Studies & A/E Analysis

### 10.1 What Is A/E?

**A/E (Actual-to-Expected) ratio** measures observed mortality against expected mortality predicted by the pricing basis:

```
A/E Ratio = Actual Claims ($ or count) / Expected Claims ($ or count)

Interpretation:
  A/E < 100% → Favorable: fewer deaths than expected (good for carrier)
  A/E = 100% → Exactly as priced
  A/E > 100% → Adverse: more deaths than expected (bad for carrier)
```

### 10.2 A/E by Risk Class — Industry Benchmarks

| Risk Class | Target A/E (Amount Basis) | Acceptable Range | Action Trigger |
|------------|--------------------------|-----------------|----------------|
| Preferred Plus | 85–95% | 75–110% | >115% |
| Preferred | 90–100% | 80–110% | >115% |
| Standard Plus | 90–100% | 80–115% | >120% |
| Standard NT | 95–105% | 85–115% | >120% |
| Preferred Tobacco | 95–105% | 85–120% | >125% |
| Standard Tobacco | 95–105% | 85–120% | >125% |
| Substandard (all tables) | 95–110% | 85–125% | >130% |

### 10.3 Experience Study Dimensions

Carriers analyze A/E across multiple dimensions:

| Dimension | Typical Splits | What It Reveals |
|-----------|---------------|-----------------|
| **Risk Class** | PP, PF, SP, SNT, PT, ST, Table A–H | Class boundary accuracy |
| **Issue Age Band** | 18–29, 30–39, 40–49, 50–59, 60–69, 70+ | Age-related pricing accuracy |
| **Gender** | Male, Female | Gender mortality differential |
| **Policy Duration** | Select years 1–5, 6–10, 11–15, 16–20, 21–25, Ultimate | Select period wear-off |
| **Face Amount Band** | <$100K, $100K–$249K, $250K–$499K, $500K–$999K, $1M+ | Jumbo anti-selection |
| **Underwriting Era** | 2015–2017, 2018–2020, 2021–2023, 2024+ | Process changes impact |
| **Distribution Channel** | Career agent, independent broker, DTC digital, bank, worksite | Channel-specific selection |
| **Product** | 10-yr term, 20-yr term, 30-yr term, ROP term | Product mix effects |
| **Underwriting Method** | Full UW, accelerated UW (no fluids), simplified issue | Evidence sufficiency |
| **Geography** | State or region | Regional health disparities |
| **Cause of Death** | Cancer, cardiovascular, accident, suicide, other | COD trends |

### 10.4 Experience Study Sample Output

Hypothetical carrier experience study (2020–2024 exposure, amount basis):

| Risk Class | Exposure ($M) | Expected Claims ($M) | Actual Claims ($M) | A/E Ratio | Trend |
|------------|--------------|---------------------|--------------------|-----------| ----- |
| Preferred Plus | $45,200 | $18.5 | $16.2 | 87.6% | Stable |
| Preferred | $62,800 | $38.4 | $36.8 | 95.8% | Slight adverse |
| Standard Plus | $28,600 | $22.1 | $23.4 | 105.9% | Adverse ⚠️ |
| Standard NT | $35,400 | $33.8 | $34.2 | 101.2% | Stable |
| Preferred Tobacco | $8,200 | $10.4 | $9.8 | 94.2% | Favorable |
| Standard Tobacco | $12,100 | $22.6 | $24.1 | 106.6% | Adverse ⚠️ |
| Substandard | $6,800 | $14.2 | $15.8 | 111.3% | Adverse ⚠️ |

### 10.5 Accelerated UW vs. Full UW Experience

One of the most closely watched splits in modern experience studies:

| Metric | Full UW (fluids + APS) | Accelerated UW (no fluids) | Delta |
|--------|----------------------|---------------------------|-------|
| A/E — Preferred Plus | 84% | 92% | +8 pts |
| A/E — Preferred | 93% | 101% | +8 pts |
| A/E — Standard | 98% | 107% | +9 pts |
| Overall A/E | 94% | 103% | +9 pts |
| Fraud/Misrepresentation Rate | 0.5% | 1.2% | +0.7 pts |
| Rescission Rate (2-year) | 0.3% | 0.8% | +0.5 pts |

Accelerated UW consistently shows 5–10 points worse A/E compared to full underwriting with fluids, driven by undetected conditions (especially diabetes, liver disease, and tobacco misrepresentation).

### 10.6 What Triggers Repricing

| Trigger | Threshold | Action |
|---------|-----------|--------|
| A/E > 110% for 2+ consecutive years in a risk class | Persistent adverse | Tighten class criteria or increase rates |
| A/E < 80% in a risk class | Persistent favorable | Consider broadening criteria or lowering rates |
| Lapse rates 20%+ below assumed | Adverse persistency | Anti-selection concern; may need rate increase |
| Lapse rates 20%+ above assumed | May be positive or negative | Review competitiveness and distribution |
| New mortality table published | Regulatory | Must adopt for new business within transition period |
| Competitor rate action | Market shift | May trigger competitive repricing |
| Reinsurance rate change | Reinsurer action | Pass-through to direct pricing |
| COVID-19 or pandemic excess mortality | Catastrophic | Reserve strengthening; may adjust future pricing |

### 10.7 Experience Study Cadence

| Study Type | Frequency | Scope |
|-----------|-----------|-------|
| **Annual mortality study** | Annually | Full in-force block by risk class |
| **Quarterly flash study** | Quarterly | High-level A/E tracking |
| **Product-specific study** | Every 2–3 years | Deep dive by product |
| **UW method study** | Annually | Accelerated vs. full UW comparison |
| **Lapse study** | Annually | Persistency by duration, class, channel |
| **Conversion study** | Annually | Conversion take-up rates and mortality |
| **Intercompany study** | Every 5–7 years | SOA industry-wide study |

---

## 11. Smoker vs Non-Smoker Classification

### 11.1 Why Smoker Classification Matters

Tobacco use is the single most powerful mortality predictor available to underwriters. Smokers have **2–3× the mortality rate** of non-smokers at most ages. The introduction of smoker/non-smoker distinctions in the 1980s was the most significant pricing innovation in modern life insurance.

### 11.2 Cotinine Testing — The Gold Standard

Cotinine is the primary metabolite of nicotine and the standard biomarker for tobacco use:

| Test Medium | Cotinine Positive Threshold | Detection Window |
|------------|---------------------------|-----------------|
| **Urine** | ≥ 200 ng/mL (most carriers) | 3–7 days |
| | Some carriers: ≥ 100 ng/mL | |
| **Blood (Serum)** | ≥ 15 ng/mL | 1–3 days |
| **Saliva** | ≥ 20 ng/mL | 1–3 days |
| **Hair** | Not standard in insurance | Up to 90 days |

#### Cotinine Level Interpretation

| Cotinine Level (Urine) | Interpretation | Classification |
|------------------------|----------------|----------------|
| 0–50 ng/mL | Non-user or very remote exposure | Non-Tobacco |
| 51–100 ng/mL | Possible passive exposure, NRT, or recent cessation | Gray zone — carrier-specific |
| 101–200 ng/mL | Likely nicotine user (NRT, very light smoker) | Tobacco at most carriers |
| 201–500 ng/mL | Active light tobacco user | Tobacco |
| 501–2000 ng/mL | Active moderate tobacco user | Tobacco |
| >2000 ng/mL | Active heavy tobacco user | Tobacco |

### 11.3 Look-Back Periods

| Tobacco Product | Typical Look-Back for Non-Tobacco Rate | Notes |
|----------------|---------------------------------------|-------|
| **Cigarettes** | 12–60 months (carrier varies) | Most common: 12 months for Standard NT, 36–60 months for Preferred |
| **Cigars** | 0–12 months (see cigar rules) | |
| **Pipe** | 12–36 months | |
| **Chewing Tobacco / Snuff** | 12–36 months | |
| **Nicotine Gum/Patch** | 12–36 months | Must not be using for cessation |
| **E-Cigarettes / Vaping** | 12–60 months | Treated same as cigarettes by most carriers |

### 11.4 Cigar Rules — Special Category

Occasional cigar use is treated differently by many carriers:

| Cigar Frequency | Common Classification | Carrier Variation |
|----------------|----------------------|-------------------|
| 0 cigars/year | Non-Tobacco | Universal |
| 1–12 cigars/year (≤1/month), ceremonial only | Non-Tobacco rates | ~40% of carriers |
| 1–12 cigars/year | Preferred Tobacco | ~30% of carriers |
| 1–12 cigars/year | Standard Tobacco | ~30% of carriers |
| 13–24 cigars/year | Preferred Tobacco or Standard Tobacco | Most carriers: Tobacco |
| >24 cigars/year | Standard Tobacco | Universal |

Key considerations for cigar underwriting:
- Cotinine test may be **negative** for infrequent cigar users (1–2 per month)
- Self-reported cigar use combined with negative cotinine: some carriers give non-tobacco rates
- Positive cotinine with claimed "cigar only": most carriers apply tobacco rates regardless

### 11.5 Marijuana / Cannabis Rules

Marijuana classification has evolved significantly since legalization:

| Usage Pattern | Common Classification (2024+) | Notes |
|--------------|-------------------------------|-------|
| Never used | Non-Tobacco | N/A |
| Past use, >12 months ago | Non-Tobacco | No THC concern; cotinine negative |
| Occasional (≤2×/month), non-smoker | Non-Tobacco at many carriers | Edibles/gummies preferred over smoking |
| Moderate (weekly), non-smoker | Standard Non-Tobacco | Some carriers: Tobacco |
| Daily use | Tobacco or Standard NT (carrier varies) | Concern about impaired judgment, mental health |
| Smoked marijuana (any frequency) | Tobacco at most carriers | Combustion is the concern |
| Edible/vaporized (≤2×/week) | Non-Tobacco at progressive carriers | Growing acceptance |
| Medical marijuana with Rx | Non-Tobacco if condition qualifies | Underlying condition may rate separately |
| Marijuana + Tobacco | Always Tobacco | |

**Implementation note**: THC is not detected by standard cotinine tests. A separate drug screen is needed for THC detection. Most carriers ask about marijuana use on the application and verify via drug panel if ordered.

### 11.6 E-Cigarettes / Vaping

| Policy Position (2024+) | Carrier Adoption |
|-------------------------|-----------------|
| E-cigarettes = cigarettes (tobacco rates) | ~65% of carriers |
| E-cigarettes = tobacco, but eligible for PT | ~20% of carriers |
| E-cigarettes = non-tobacco if nicotine-free pods | ~10% of carriers |
| Case-by-case evaluation | ~5% of carriers |

Vaping generates positive cotinine results (if nicotine-containing), so lab tests alone classify vapers as tobacco users regardless of carrier policy on application questions.

### 11.7 Nicotine Replacement Therapy (NRT)

| NRT Scenario | Classification |
|-------------|----------------|
| Using NRT for cessation, quit smoking < 12 months ago | Tobacco |
| Using NRT for cessation, quit smoking 12–36 months ago | Tobacco (most carriers) or Non-Tobacco (some) |
| Completed NRT, tobacco-free > 12 months, cotinine negative | Non-Tobacco |
| Long-term NRT use (nicotine gum > 2 years, no cigarettes) | Tobacco at most carriers (nicotine is present) |
| Completed NRT, cotinine negative, no tobacco 36+ months | Eligible for Preferred (look-back dependent) |

### 11.8 System Implementation for Tobacco Classification

```
TobaccoClassifier {
  classify(applicant: ApplicantProfile): TobaccoStatus {

    // Step 1: Check lab results
    if (applicant.cotinine >= POSITIVE_THRESHOLD) {
      return TOBACCO  // Hard stop — labs override self-report
    }

    // Step 2: Check self-reported tobacco use
    if (applicant.currentTobaccoUse == true) {
      return TOBACCO
    }

    // Step 3: Apply look-back period
    if (applicant.lastTobaccoUseDate != null) {
      monthsSinceUse = monthsBetween(applicant.lastTobaccoUseDate, today)

      if (monthsSinceUse < PREFERRED_PLUS_LOOKBACK) {  // typically 60 months
        applicant.maxClass = STANDARD_NT  // Cannot qualify for PP even if NT
      }
      if (monthsSinceUse < NON_TOBACCO_LOOKBACK) {  // typically 12 months
        return TOBACCO
      }
    }

    // Step 4: Special cigar rules
    if (applicant.cigarFrequency > 0 && applicant.cigarFrequency <= 12) {
      if (CARRIER_ALLOWS_CIGAR_NT && applicant.cotinine < POSITIVE_THRESHOLD) {
        return NON_TOBACCO  // with possible class restriction
      }
    }

    // Step 5: E-cigarette / vaping check
    if (applicant.usesEcig == true) {
      if (CARRIER_ECIG_POLICY == TOBACCO) return TOBACCO
      // else case-by-case
    }

    // Step 6: Marijuana check
    if (applicant.marijuanaUse == SMOKED) {
      return TOBACCO  // combustion = tobacco at most carriers
    }
    if (applicant.marijuanaUse == EDIBLE && applicant.marijuanaFrequency <= MODERATE) {
      return NON_TOBACCO  // carrier-specific
    }

    return NON_TOBACCO
  }
}
```

---

## 12. Preferred Criteria Comparison Across Carriers

### 12.1 Why Criteria Vary

No two carriers have identical preferred criteria. Variations reflect:
- Different mortality experience and A/E results
- Reinsurance treaty requirements
- Target market and competitive positioning
- Actuarial philosophy (aggressive vs. conservative)
- Distribution channel (DTC digital may have tighter criteria than broker channel)

### 12.2 Preferred Plus (Super Preferred) Criteria — 10 Carrier Comparison

| Criterion | Carrier A | Carrier B | Carrier C | Carrier D | Carrier E |
|-----------|-----------|-----------|-----------|-----------|-----------|
| **Max BMI** | 25.9 | 27.0 | 26.0 | 25.0 | 28.0 |
| **Systolic BP** | ≤130 | ≤135 | ≤130 | ≤128 | ≤140 |
| **Diastolic BP** | ≤80 | ≤85 | ≤82 | ≤80 | ≤85 |
| **BP Meds** | None | None | None | None | 1 OK |
| **Total Chol** | ≤220 | ≤240 | ≤225 | ≤210 | ≤250 |
| **TC/HDL** | ≤4.5 | ≤5.0 | ≤4.5 | ≤4.0 | ≤5.0 |
| **HbA1c** | ≤5.6 | ≤5.7 | ≤5.6 | ≤5.5 | ≤5.8 |
| **Tobacco-Free** | 5 yr | 5 yr | 3 yr | 5 yr | 5 yr |
| **Family Hx Age** | >60 | >60 | >55 | >65 | >60 |
| **DUI Lookback** | 10 yr | 10 yr | 7 yr | 10 yr | 7 yr |
| **Max Violations** | 1/3yr | 2/3yr | 1/3yr | 0/3yr | 2/3yr |
| **Chol Meds** | No | No | No | No | Yes (1) |
| **Aviation** | No | No | Flat extra | No | Flat extra |
| **Max Age** | 65 | 70 | 65 | 60 | 70 |

| Criterion | Carrier F | Carrier G | Carrier H | Carrier I | Carrier J |
|-----------|-----------|-----------|-----------|-----------|-----------|
| **Max BMI** | 26.5 | 27.5 | 25.5 | 29.0 | 26.0 |
| **Systolic BP** | ≤132 | ≤138 | ≤130 | ≤140 | ≤130 |
| **Diastolic BP** | ≤82 | ≤86 | ≤80 | ≤88 | ≤80 |
| **BP Meds** | None | 1 OK | None | 1 OK | None |
| **Total Chol** | ≤230 | ≤250 | ≤215 | ≤260 | ≤220 |
| **TC/HDL** | ≤4.5 | ≤5.0 | ≤4.0 | ≤5.5 | ≤4.5 |
| **HbA1c** | ≤5.7 | ≤5.8 | ≤5.5 | ≤5.9 | ≤5.6 |
| **Tobacco-Free** | 5 yr | 3 yr | 5 yr | 3 yr | 5 yr |
| **Family Hx Age** | >60 | >55 | >65 | >55 | >60 |
| **DUI Lookback** | 10 yr | 5 yr | 10 yr | 5 yr | 10 yr |
| **Max Violations** | 1/3yr | 2/3yr | 0/3yr | 3/3yr | 1/3yr |
| **Chol Meds** | No | Yes (1) | No | Yes (1) | No |
| **Aviation** | No | Flat extra | No | Yes (rated) | No |
| **Max Age** | 65 | 70 | 60 | 75 | 65 |

### 12.3 Analysis: Most Restrictive vs. Most Lenient

| Criterion | Most Restrictive | Carrier | Most Lenient | Carrier |
|-----------|-----------------|---------|-------------|---------|
| BMI | ≤25.0 | D | ≤29.0 | I |
| Systolic | ≤128 | D | ≤140 | E, I |
| Total Chol | ≤210 | D | ≤260 | I |
| HbA1c | ≤5.5 | D, H | ≤5.9 | I |
| TC/HDL | ≤4.0 | D, H | ≤5.5 | I |
| Tobacco-Free | 5 yr | A,D,F,H,J | 3 yr | C,G,I |
| Family Hx | >65 | D, H | >55 | C, G, I |
| DUI | 10 yr | A,B,D,F,H,J | 5 yr | G, I |

**Observation**: Carrier I is the most lenient across nearly all dimensions, suggesting an aggressive competitive strategy to capture preferred volume. Carrier D and H are most restrictive, likely reflecting conservative mortality targets.

### 12.4 Impact on Automated UW

When building a multi-carrier quoting or underwriting engine, the system must:

1. Store carrier-specific criteria thresholds in a **configuration layer** (not hard-coded).
2. Support **carrier-specific tobacco definitions** (cigar rules, marijuana, vaping).
3. Model criteria as **versioned rules** — carriers update criteria 1–3 times per year.
4. Handle the **preferred look-back period difference** (3 yr vs 5 yr for tobacco) in classification logic.
5. Implement a **carrier ranking algorithm** that identifies the best carrier/class combination for each applicant.

---

## 13. Age and Gender Rating

### 13.1 Age Determination Methods

| Method | Formula | Used By |
|--------|---------|---------|
| **Age Nearest Birthday (ANB)** | If birthday is within 6 months (before or after), use that age | ~65% of carriers |
| **Age Last Birthday (ALB)** | Use current age as of last birthday | ~35% of carriers |
| **Age Next Birthday** | Rare — use next birthday age | Very few carriers |

#### ANB vs ALB Impact Example

```
Applicant Date of Birth: July 15, 1990
Application Date: March 1, 2025

Age Last Birthday: 34 (turned 34 on July 15, 2024)
Age Nearest Birthday: 35 (closer to July 15, 2025 than July 15, 2024)
  (March 1 to July 15 = 4.5 months — within 6 months of next birthday)

If Applicant Date of Birth: July 15, 1990
Application Date: November 1, 2024

Age Last Birthday: 34
Age Nearest Birthday: 34 (closer to July 15, 2024 than July 15, 2025)
  (November 1 back to July 15 = 3.5 months — within 6 months of last birthday)
```

**Pricing impact**: At older ages, each year can add $50–$200+ to annual premium. An applicant with an imminent birthday (ANB carrier) or a recent birthday (ALB carrier) should time their application carefully.

### 13.2 Age Bands vs. Exact Age Pricing

| Approach | Description | Prevalence |
|----------|-------------|------------|
| **Exact Age Pricing** | Unique rate for each age (25, 26, 27...) | Standard for individual term |
| **5-Year Age Bands** | Same rate for ages 25–29, 30–34, etc. | Common for group/worksite |
| **Quinquennial** | Pricing at ages 25, 30, 35, 40... with interpolation | Legacy approach |

### 13.3 Gender Rating

#### 13.3.1 Standard Gender-Distinct Pricing

Most states permit **gender-distinct pricing** for life insurance. Males pay higher premiums because male mortality exceeds female mortality at all ages.

| Age | Male Annual Premium (PF $500K 20yr) | Female Annual Premium (PF $500K 20yr) | Male/Female Ratio |
|-----|--------------------------------------|---------------------------------------|-------------------|
| 25 | $310 | $255 | 1.22 |
| 30 | $360 | $295 | 1.22 |
| 35 | $525 | $420 | 1.25 |
| 40 | $730 | $585 | 1.25 |
| 45 | $1,050 | $835 | 1.26 |
| 50 | $1,580 | $1,240 | 1.27 |
| 55 | $2,380 | $1,820 | 1.31 |
| 60 | $3,850 | $2,890 | 1.33 |
| 65 | $6,200 | $4,580 | 1.35 |

#### 13.3.2 Unisex Pricing

Montana is the only US state that requires **unisex pricing** for individual life insurance (Montana Human Rights Act, Gender-Neutral Insurance). The EU also requires unisex pricing since 2012.

| Aspect | Unisex Implementation |
|--------|----------------------|
| **Rate Basis** | Blended rate using assumed male/female mix (typically 55/45 or 60/40) |
| **Premium Impact** | Males pay less, females pay more vs. gender-distinct |
| **Anti-Selection** | Males disproportionately buy (arbitrage), worsening pool mortality |
| **State** | Montana (US), all EU member states |
| **Implementation** | `unisexRate = maleRate × maleMixPct + femaleRate × femaleMixPct` |

### 13.4 Age-Based Risk Class Restrictions

Many carriers restrict access to the best classes at advanced ages:

| Age Range | Typical Available Classes |
|-----------|--------------------------|
| 18–50 | All classes: PP, PF, SP, SNT, PT, ST |
| 51–60 | PP (some carriers remove), PF, SP, SNT, PT, ST |
| 61–65 | PF, SP, SNT, PT, ST (many carriers remove PP) |
| 66–70 | PF or SP as best available; some carriers merge PP/PF |
| 71–75 | SP or SNT as best available; limited carriers offer Preferred |
| 76–80 | SNT only for non-tobacco; ST only for tobacco |
| 81+ | Typically not available for new term policies |

Rationale: At older ages, the mortality difference between Preferred Plus and Preferred narrows, making the cost of maintaining separate classes greater than the pricing benefit.

### 13.5 Age-Setback Method (Alternative Gender Approach)

Some actuaries use an **age setback** for females instead of separate rates:

```
Female Rate at Age X = Male Rate at Age (X - 3)

Example: Female age 45 priced like Male age 42

This approximation works because female mortality at age 45 ≈ male mortality at age 42.
The setback is typically 3–5 years depending on age range.
```

This is a simplified approach used in some older pricing systems and is less precise than full gender-distinct tables.

---

## 14. Multi-Life / Group vs Individual Pricing

### 14.1 Fundamental Differences

| Aspect | Individual Term | Group Term (Employer-Sponsored) | Multi-Life / Voluntary |
|--------|----------------|-------------------------------|----------------------|
| **Underwriting** | Full individual UW (medical, labs, APS) | Guaranteed issue (GI) or simplified issue (SI) | Simplified issue or GI with medical questions |
| **Risk Classes** | 4–6 non-tobacco + 2–3 tobacco | Typically 1–2 classes (S/NS only) | 2–4 classes |
| **Premium Basis** | Age + gender + risk class + face amount | Age-banded + volume-based | Age-banded + risk class |
| **Experience Rating** | N/A (individual risk) | Yes — group experience drives renewal rates | Sometimes — depends on group size |
| **Portability** | Policy is owned by individual | Coverage tied to employment | May have portability option |
| **Anti-Selection** | Controlled by underwriting | Controlled by participation requirements | Moderate control |
| **Minimum Participation** | N/A | 75% for contributory, 100% for non-contributory | 25–30% minimum |
| **Maximum Benefit** | $50M+ (jumbo with facultative) | Typically $500K–$1M without EOI | $500K–$2M |
| **Evidence of Insurability (EOI)** | Always required (the application IS the EOI) | Required above GI max | Required above GI max |

### 14.2 Group Term Risk Classification

Group term typically uses simplified classification:

| Group Size | Classification Approach |
|-----------|----------------------|
| **Small Group (2–50)** | 2 classes: Smoker/Non-Smoker; possibly single class |
| **Medium Group (51–500)** | 2 classes: Smoker/Non-Smoker |
| **Large Group (501–5,000)** | 2 classes with experience rating |
| **Jumbo Group (5,000+)** | Self-funded or 2 classes with full experience rating |

### 14.3 Guaranteed Issue (GI) Maximums

| Group Size | Typical GI Maximum | EOI Threshold |
|-----------|-------------------|---------------|
| 10–24 employees | $10,000–$25,000 | Above GI max |
| 25–99 | $25,000–$50,000 | Above GI max |
| 100–499 | $50,000–$100,000 | Above GI max |
| 500–999 | $100,000–$150,000 | Above GI max |
| 1,000–4,999 | $150,000–$250,000 | Above GI max |
| 5,000+ | $250,000–$500,000 | Above GI max |

### 14.4 Group vs Individual Mortality Comparison

| Factor | Individual UW | Group GI |
|--------|--------------|---------|
| Expected mortality (% of population) | 60–80% (select, healthy population) | 90–110% (active employee population) |
| Anti-selection risk | Low (controlled by underwriting) | Moderate (healthy opt out, unhealthy enroll) |
| Moral hazard | Low (individual screened) | Higher (employer relationship) |
| Typical A/E (first 5 years) | 85–95% | 95–110% |
| Premium differential (same age/face) | 1.0× (base) | 1.3–1.8× (higher per $1,000 rate) |

### 14.5 Multi-Life Discounts

For employer-sponsored voluntary term or multi-life individual term:

| Number of Lives | Premium Discount |
|----------------|-----------------|
| 3–9 | 5% |
| 10–24 | 10% |
| 25–49 | 15% |
| 50–99 | 20% |
| 100–249 | 25% |
| 250–499 | 30% |
| 500+ | 35%+ (negotiated) |

Discounts reflect:
- Lower acquisition cost per policy (batch enrollment)
- Reduced anti-selection (employer group provides diversification)
- Higher persistency (payroll deduction)
- Lower administrative cost (group billing)

---

## 15. Conversion Risk & Anti-Selection

### 15.1 What Is Conversion?

Most term policies include a **conversion privilege** — the right to convert the term policy to a permanent (whole life or universal life) policy without evidence of insurability (no medical underwriting required).

### 15.2 Conversion Mechanics

| Feature | Typical Terms |
|---------|---------------|
| **Conversion Period** | First 10–20 years of term, or up to age 65–70 |
| **Eligible Products** | Whole life, universal life (carrier's current permanent products) |
| **Medical Underwriting** | None required (guaranteed acceptance) |
| **Premium Basis** | Based on attained age at conversion and the original risk class |
| **Face Amount** | Up to the full term face amount |
| **Partial Conversion** | Usually permitted (convert $250K of a $500K term) |

### 15.3 The Anti-Selection Problem

Conversion creates a significant adverse selection issue:

```
HEALTHY POLICYHOLDERS          UNHEALTHY POLICYHOLDERS
─────────────────────          ───────────────────────
• Term expires → drop coverage  • Term expires → CONVERT
• Can buy new coverage at       • Cannot get new coverage
  preferred rates                 without conversion privilege
• No incentive to convert       • Strong incentive to convert
  (can get better rates)          (cannot get any coverage otherwise)

RESULT: Conversion pool is adversely selected
        Mortality on converted policies >> Standard mortality
```

### 15.4 Conversion Experience Data

Industry conversion studies consistently show:

| Metric | Non-Converted Block | Converted Block | Ratio |
|--------|-------------------|-----------------|-------|
| A/E (years 1–5 post-conversion) | 95% | 200–350% | 2.1–3.7× |
| A/E (years 6–10 post-conversion) | 100% | 175–250% | 1.8–2.5× |
| A/E (years 11+ post-conversion) | 105% | 150–200% | 1.4–1.9× |
| Cancer claims (% of total) | 25% | 40–50% | 1.6–2.0× |
| Cardiovascular claims (% of total) | 30% | 25–30% | ~1.0× |

### 15.5 Conversion Take-Up Rates

| Policy Duration at Conversion | Take-Up Rate | Mortality Quality |
|-------------------------------|-------------|------------------|
| Years 1–5 | 2–4% | Moderate anti-selection |
| Years 6–10 | 5–10% | High anti-selection |
| Years 11–15 | 8–15% | Very high anti-selection |
| Years 16–20 | 10–20% | Extreme anti-selection |
| Final year of conversion window | 15–30% | Maximum anti-selection |

### 15.6 Conversion Risk Pricing

Carriers must price the conversion option into the original term premium:

```
Term Premium = Base Mortality Cost + Conversion Option Cost + Expenses + Profit

Conversion Option Cost = PV of (Conversion Take-Up Rate × Excess Mortality on Converted Block)

Example:
  20-year term, $500K, Male Age 35 Preferred
  Assume 8% cumulative conversion rate over 20 years
  Excess mortality on converted: 200% of expected
  PV of conversion cost: ~$35–$55/year

  This adds ~5–8% to the level term premium.
```

### 15.7 Carrier Strategies to Manage Conversion Risk

| Strategy | Description | Trade-Off |
|----------|-------------|-----------|
| **Limited conversion window** | Allow conversion only in first 10 years (not full 20) | Reduces anti-selection but less competitive |
| **Conversion age cap** | No conversion after age 65 | Standard in industry |
| **Limited product selection** | Convert only to specific (less rich) permanent products | Reduces adverse selection by limiting product arbitrage |
| **Original age vs. attained age** | Attained age pricing (higher premium) vs. original age (carrier eats the cost) | Original age is rare but most generous to consumer |
| **Conversion credits** | Offer credit toward permanent premium if converting within first 5 years | Encourages early conversion (less anti-selected) |
| **Dedicated conversion product** | Create a permanent product specifically designed for conversions with adjusted mortality | Best practice for managing conversion block separately |

### 15.8 Conversion Impact on Reserves

| Reserve Consideration | Impact |
|----------------------|--------|
| Term policy reserves must anticipate conversion option value | Increases statutory reserves |
| Converted policy reserves are based on permanent product valuation | Typically higher reserves than term |
| GAAP reporting requires recognizing conversion option as embedded derivative (some interpretations) | Complex accounting |
| Reinsurance treaties may exclude conversion risk or price it separately | Must be negotiated |

---

## 16. Risk Class Migration

### 16.1 What Is Risk Class Migration?

Risk class migration occurs when a policyholder's health or risk profile changes after policy issue such that they would qualify for a **different risk class** if re-underwritten today.

### 16.2 Types of Migration

| Migration Direction | Description | Impact on Carrier |
|--------------------|-------------|------------------|
| **Favorable Migration** | Policyholder becomes healthier (e.g., quits smoking, loses weight, cholesterol improves) | Positive — may lapse to buy cheaper coverage elsewhere |
| **Adverse Migration** | Policyholder becomes less healthy (e.g., develops diabetes, gains weight, diagnosed with cancer) | Negative — policyholder persists, paying below-risk premium |

### 16.3 Migration and Anti-Selection Cycle

```
Issue at Preferred Plus rate
           │
    ┌──────┴──────┐
    │             │
 STAYS HEALTHY   BECOMES LESS HEALTHY
    │             │
 After 10 yrs:   After 10 yrs:
 Can get new PP  Cannot get new coverage
 rate elsewhere  Must keep current policy
    │             │
    ▼             ▼
 LAPSES          PERSISTS
 (favorable to   (adverse to carrier:
  carrier: no    paying PP rate for
  more risk)     Standard+ risk)
```

### 16.4 Migration Impact on Persistency

| Risk Class at Issue | 10-Year Persistency (Healthy) | 10-Year Persistency (Deteriorated Health) |
|--------------------|------------------------------|------------------------------------------|
| Preferred Plus | 55% | 85% |
| Preferred | 58% | 82% |
| Standard Plus | 62% | 80% |
| Standard NT | 65% | 78% |
| Preferred Tobacco | 50% | 80% |
| Standard Tobacco | 48% | 75% |

The differential persistency between healthy and unhealthy lives creates adverse selection within the in-force block.

### 16.5 Quantifying Migration

Hypothetical 10-year migration matrix (cohort of 10,000 policies issued as PP):

| Status at Year 10 | Percentage | Count | Current Mortality Profile |
|-------------------|-----------|-------|--------------------------|
| Still qualifies for PP | 62% | 6,200 | 0.45× Standard — many will lapse |
| Would qualify for PF | 18% | 1,800 | 0.65× Standard |
| Would qualify for SP | 8% | 800 | 0.85× Standard |
| Would qualify for SNT | 6% | 600 | 1.00× Standard |
| Would be Substandard | 4% | 400 | 1.50× Standard — will persist |
| Would be Uninsurable | 2% | 200 | Very high — will persist |

### 16.6 Impact on Profitability

```
At issue: 10,000 PP policies, average mortality = 0.45× Standard ✓

At year 10 (in-force, after lapses):
  Of 10,000 original:
    ~3,800 lapsed (mostly healthy)
    ~6,200 remain in force

  Of 6,200 remaining:
    3,100 still PP health → some will lapse soon
    1,200 now PF health → staying
    700 now SP health → staying
    600 now SNT health → staying
    400 now substandard → definitely staying
    200 now uninsurable → definitely staying

  Average mortality of in-force at year 10: ~0.72× Standard
  But they're paying PP rate (priced for 0.45×)

  Gap: 0.72 - 0.45 = 0.27× Standard → ADVERSE to carrier
  This is partially anticipated in pricing (select period wear-off),
  but if migration is worse than assumed, profitability suffers.
```

### 16.7 Reconsideration Programs

Some carriers offer **risk class reconsideration** — allowing in-force policyholders to request re-evaluation for a better class:

| Feature | Detail |
|---------|--------|
| **Eligibility** | Policies in force ≥ 2 years |
| **Evidence Required** | New paramedical exam + labs |
| **Possible Outcome** | Class upgrade (e.g., Standard → Preferred) |
| **Cannot Get Worse** | Reconsideration never results in downgrade |
| **Cost to Insured** | Free or nominal ($50–$100 exam fee) |
| **Carrier Motivation** | Retain policyholders who would otherwise lapse to a competitor |

### 16.8 Modeling Migration in Pricing

Modern pricing models incorporate migration assumptions:

```
For each policy year t:
  mortalityRate(t) = Σ [migrationProbability(originalClass → currentClass, t)
                       × mortalityRate(currentClass, age + t)]

  This produces a blended mortality rate that increases faster than the
  select table alone would suggest, because:
  1. Healthy lives lapse (removing favorable mortality)
  2. Deteriorated lives persist (adding adverse mortality)
  3. The select advantage wears off naturally
```

### 16.9 Migration and Reinsurance

| Reinsurance Aspect | Impact |
|-------------------|--------|
| **YRT (Yearly Renewable Term) treaties** | Reinsurer shares migration risk — rates adjust with experience |
| **Coinsurance treaties** | Reinsurer fully shares migration risk |
| **Quota share with experience refund** | Migration impacts refund calculation |
| **Retention limits** | Migration doesn't change retention; risk class at issue is permanent for reinsurance |

---

## Appendix A: Glossary of Key Terms

| Term | Definition |
|------|-----------|
| **A/E Ratio** | Actual-to-Expected mortality ratio |
| **ALB** | Age Last Birthday |
| **ANB** | Age Nearest Birthday |
| **APS** | Attending Physician Statement |
| **BMI** | Body Mass Index (weight in kg / height in m²) |
| **CABG** | Coronary Artery Bypass Graft |
| **COD** | Cause of Death |
| **COPD** | Chronic Obstructive Pulmonary Disease |
| **CRVM** | Commissioners Reserve Valuation Method |
| **CSO** | Commissioners Standard Ordinary (mortality table) |
| **DUI/DWI** | Driving Under the Influence / Driving While Intoxicated |
| **EOI** | Evidence of Insurability |
| **FEV1** | Forced Expiratory Volume in 1 second (lung function test) |
| **GI** | Guaranteed Issue |
| **HbA1c** | Hemoglobin A1c (glycated hemoglobin; diabetes marker) |
| **HDL** | High-Density Lipoprotein ("good" cholesterol) |
| **IFR** | Instrument Flight Rules (aviation) |
| **IRR** | Internal Rate of Return |
| **LDL** | Low-Density Lipoprotein ("bad" cholesterol) |
| **MI** | Myocardial Infarction (heart attack) |
| **NRT** | Nicotine Replacement Therapy |
| **PAC** | Pre-Authorized Check |
| **PP** | Preferred Plus (Super Preferred) |
| **PF** | Preferred |
| **PT** | Preferred Tobacco |
| **PVFB** | Present Value of Future Benefits |
| **PVFE** | Present Value of Future Expenses |
| **qx** | Probability of death at age x within one year |
| **ROE** | Return on Equity |
| **ROP** | Return of Premium |
| **SGLI** | Servicemembers' Group Life Insurance |
| **SI** | Simplified Issue |
| **SNT** | Standard Non-Tobacco |
| **SOA** | Society of Actuaries |
| **SP** | Standard Plus |
| **ST** | Standard Tobacco |
| **STP** | Straight-Through Processing |
| **SVR** | Sustained Virologic Response (Hepatitis C cure indicator) |
| **TC/HDL** | Total Cholesterol to HDL Cholesterol ratio |
| **TIA** | Transient Ischemic Attack (mini-stroke) |
| **VBT** | Valuation Basic Table |
| **VFR** | Visual Flight Rules (aviation) |
| **YRT** | Yearly Renewable Term (reinsurance) |

---

## Appendix B: Sample Rate Tables

### B.1 Male Non-Tobacco — Annual Premium per $1,000 Face Amount, 20-Year Level Term

| Issue Age | PP | PF | SP | SNT |
|-----------|------|------|------|------|
| 25 | $0.50 | $0.62 | $0.78 | $0.95 |
| 30 | $0.55 | $0.70 | $0.88 | $1.08 |
| 35 | $0.73 | $1.05 | $1.37 | $1.69 |
| 40 | $1.05 | $1.46 | $1.92 | $2.42 |
| 45 | $1.62 | $2.10 | $2.78 | $3.52 |
| 50 | $2.65 | $3.16 | $4.18 | $5.35 |
| 55 | $4.32 | $4.76 | $6.28 | $8.12 |
| 60 | $7.10 | $7.70 | $10.15 | $13.25 |
| 65 | $11.85 | $12.40 | $16.32 | $21.50 |

### B.2 Female Non-Tobacco — Annual Premium per $1,000 Face Amount, 20-Year Level Term

| Issue Age | PP | PF | SP | SNT |
|-----------|------|------|------|------|
| 25 | $0.40 | $0.51 | $0.65 | $0.80 |
| 30 | $0.44 | $0.57 | $0.72 | $0.90 |
| 35 | $0.58 | $0.84 | $1.10 | $1.38 |
| 40 | $0.82 | $1.17 | $1.55 | $1.98 |
| 45 | $1.28 | $1.67 | $2.22 | $2.85 |
| 50 | $2.05 | $2.48 | $3.28 | $4.22 |
| 55 | $3.30 | $3.64 | $4.82 | $6.28 |
| 60 | $5.35 | $5.78 | $7.65 | $10.05 |
| 65 | $8.80 | $9.16 | $12.10 | $16.05 |

### B.3 Male Tobacco — Annual Premium per $1,000 Face Amount, 20-Year Level Term

| Issue Age | PT | ST |
|-----------|------|------|
| 25 | $1.42 | $2.10 |
| 30 | $1.58 | $2.35 |
| 35 | $2.70 | $4.25 |
| 40 | $3.85 | $6.10 |
| 45 | $5.52 | $8.85 |
| 50 | $8.35 | $13.45 |
| 55 | $12.55 | $20.40 |
| 60 | $19.85 | $32.85 |
| 65 | $31.20 | $52.50 |

---

## Appendix C: Decision Tree for Risk Classification

```
START: New Application Received
  │
  ├─ Is applicant a tobacco/nicotine user?
  │    ├─ YES → TOBACCO TRACK
  │    │    ├─ Cotinine positive or self-reported?
  │    │    │    ├─ YES → Evaluate for Preferred Tobacco
  │    │    │    │    ├─ Meets all PT criteria? → PREFERRED TOBACCO
  │    │    │    │    └─ Does not meet PT → STANDARD TOBACCO
  │    │    │    └─ Edge case (cigar only, <12/year, cotinine negative)
  │    │    │         ├─ Carrier allows cigar NT? → NON-TOBACCO TRACK
  │    │    │         └─ Carrier does not → TOBACCO TRACK
  │    │    │
  │    └─ NO → NON-TOBACCO TRACK
  │         ├─ Any knockout conditions? (See Section 3.7)
  │         │    ├─ YES → Apply knockout minimum class or DECLINE
  │         │    └─ NO → Continue
  │         │
  │         ├─ Calculate debit/credit score
  │         │    ├─ Score ≤ 50 → Check PP eligibility
  │         │    │    ├─ Age within PP range? → PREFERRED PLUS
  │         │    │    └─ Age exceeds PP limit → PREFERRED
  │         │    │
  │         │    ├─ Score 51–125 → PREFERRED
  │         │    ├─ Score 126–200 → STANDARD PLUS
  │         │    ├─ Score 201–300 → STANDARD NON-TOBACCO
  │         │    ├─ Score 301–700 → SUBSTANDARD (Table A–H)
  │         │    │    ├─ Determine table from score
  │         │    │    ├─ Apply flat extras if applicable
  │         │    │    └─ Check maximum table for carrier
  │         │    │
  │         │    └─ Score > 700 → DECLINE (or refer to specialty carrier)
  │         │
  │         ├─ Apply exclusion riders if applicable
  │         ├─ Apply flat extras if applicable
  │         └─ Return final classification + premium
```

---

## Appendix D: Implementation Checklist for Automated Risk Classification

| # | Requirement | Priority | Notes |
|---|------------|----------|-------|
| 1 | Build table (height/weight to BMI) per carrier | P0 | Must support both imperial and metric |
| 2 | Debit/credit scoring engine | P0 | Configurable thresholds per carrier |
| 3 | Knockout rule engine (hard stops) | P0 | Must override debit/credit score |
| 4 | Tobacco classification logic | P0 | Cotinine thresholds, cigar rules, marijuana rules |
| 5 | Risk class mapping (score → class) | P0 | Including age restrictions |
| 6 | Table rating calculation | P0 | Tables A–P, premium calculation |
| 7 | Flat extra calculation | P0 | Temporary and permanent, per $1,000 |
| 8 | Exclusion rider management | P1 | State-specific restrictions |
| 9 | Multi-carrier criteria configuration | P1 | Version-controlled, effective-dated |
| 10 | Override/exception handling | P1 | Allow underwriter to override engine decision |
| 11 | Audit trail / explainability | P0 | Every factor, every debit/credit, full reasoning |
| 12 | Premium calculation engine | P0 | Net → gross, modal factors, policy fees |
| 13 | Experience study data pipeline | P2 | A/E tracking by all dimensions |
| 14 | Conversion option pricing | P2 | Anti-selection modeling |
| 15 | Migration modeling | P2 | Persistency-adjusted mortality |
| 16 | Regulatory compliance | P0 | State-specific rating restrictions, unisex pricing |
| 17 | Reinsurance interface | P1 | Pass-through of table ratings, flat extras |
| 18 | Rate band / volume discount logic | P1 | Face amount breakpoints |
| 19 | Gender rating / age calculation | P0 | ANB vs ALB, unisex for Montana |
| 20 | Preferred criteria comparison tool | P2 | For multi-carrier quoting engines |

---

## Cross-References

This article is part of a comprehensive series on term life insurance underwriting for solution architects:

- **[01 — Term Underwriting Fundamentals](01_TERM_UNDERWRITING_FUNDAMENTALS.md)** — Complete overview of term life insurance, the underwriting function, risk assessment pillars, and the end-to-end process.
- **[02 — Automated Underwriting Engine](02_AUTOMATED_UNDERWRITING_ENGINE.md)** — Architecture deep dive covering decision engines, data pipelines, scoring models, API design, and straight-through processing.
- **[06 — Risk Classification, Rating & Mortality](06_RISK_CLASSIFICATION_RATING.md)** — *(this article)* — Risk classes, debit/credit system, table ratings, flat extras, mortality tables, premium calculation, and actuarial pricing.

---

*Last updated: April 2026. Content reflects industry practices as of 2024–2026. Specific carrier criteria, mortality rates, and premium figures are illustrative and representative of industry norms; actual values vary by carrier, state, and product filing.*
