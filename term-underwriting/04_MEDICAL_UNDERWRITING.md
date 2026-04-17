# Medical Underwriting Deep Dive

> An exhaustive technical reference covering every aspect of medical underwriting for term life insurance — from paramedical exams and lab panels through impairment assessment, prescription drug interpretation, and automated rule implementation. Written for solution architects building automated underwriting systems.

---

## Table of Contents

1. [Medical Underwriting Principles](#1-medical-underwriting-principles)
2. [The Paramedical Examination](#2-the-paramedical-examination)
3. [Blood Profile Laboratory Testing](#3-blood-profile-laboratory-testing)
4. [Attending Physician Statement (APS)](#4-attending-physician-statement-aps)
5. [Resting ECG](#5-resting-ecg)
6. [Medical Impairment Guide — Top 30 Conditions](#6-medical-impairment-guide--top-30-conditions)
7. [Prescription Drug Interpretation](#7-prescription-drug-interpretation)
8. [Family History Assessment](#8-family-history-assessment)
9. [Build Charts — BMI, Height & Weight](#9-build-charts--bmi-height--weight)
10. [Tobacco & Nicotine Assessment](#10-tobacco--nicotine-assessment)
11. [Implementing Medical Rules in Code](#11-implementing-medical-rules-in-code)
12. [AI/ML in Medical Underwriting](#12-aiml-in-medical-underwriting)
13. [Cross-References & Further Reading](#13-cross-references--further-reading)

---

## 1. Medical Underwriting Principles

### 1.1 The Central Question

Medical underwriting answers a single question: **How does this applicant's health profile change their expected mortality relative to a standard-risk population of the same age and gender?**

Every medical data point — a lab value, a diagnosis, a prescription — is evaluated against this question. The output is either:

- **No impact** — the applicant meets standard or preferred criteria.
- **Extra mortality** — the applicant carries quantifiable excess risk, expressed as a percentage or flat extra premium.
- **Uninsurable** — the risk exceeds the carrier's appetite and the application is declined.

### 1.2 Mortality Ratio and Extra Mortality

The **mortality ratio (MR)** is the primary metric. It compares expected deaths in a group of similarly-impaired individuals to expected deaths in a standard population.

| Mortality Ratio | Interpretation | Typical UW Action |
|-----------------|---------------|-------------------|
| 100% | Standard mortality — matches pricing assumptions | Standard class |
| 75% | Better than standard (lower risk) | Preferred or Preferred Plus |
| 125% | 25% excess mortality | Table B (substandard) |
| 150% | 50% excess mortality | Table D |
| 200% | Double mortality | Table H |
| 300% | Triple mortality | Table P or Decline |
| 500%+ | Extreme excess mortality | Decline or Postpone |

**Flat extra** is an alternative to table ratings. It adds a fixed dollar amount per $1,000 of coverage for a defined period (e.g., $5.00 per $1,000 for 5 years). Flat extras are used when:

- Risk is temporary (e.g., recent cancer treatment with good prognosis).
- Risk is constant (not increasing with age) — e.g., hazardous occupation.
- Risk is difficult to table-rate precisely.

### 1.3 Standard vs. Substandard Risk

Modern term life carriers use a multi-tier classification system:

| Risk Class | Mortality Ratio Range | Typical Population % | Key Characteristics |
|-----------|----------------------|---------------------|-------------------|
| **Preferred Plus (Super Preferred)** | 40–60% | 10–15% | Optimal health, no family history, ideal build, no tobacco, perfect labs |
| **Preferred** | 60–80% | 20–25% | Very good health, minor issues allowed, excellent labs |
| **Standard Plus** | 80–100% | 15–20% | Good health, well-controlled minor conditions |
| **Standard** | 100% | 20–25% | Baseline — average insurable health |
| **Table A (Substandard 1)** | 125% | 3–5% | Mild impairments |
| **Table B (Substandard 2)** | 150% | 2–4% | Moderate impairments |
| **Table C–D** | 175–200% | 2–3% | Significant impairments |
| **Table E–H** | 225–300% | 1–3% | Severe impairments |
| **Table J–P** | 325–500% | <1% | Very severe impairments |
| **Decline** | >500% or unquantifiable | 3–8% | Risk exceeds appetite |

### 1.4 The Debits-and-Credits System

Most underwriting manuals use a **debits-and-credits** approach:

- Each medical finding carries a **debit** (adds to mortality) or **credit** (subtracts from mortality).
- Credits are given for favorable contra-indicators: well-controlled condition, excellent compliance, long duration since treatment.
- Final mortality = **base mortality ± sum of all debits and credits**.

Example:

```
Base mortality:                      100%
Hypertension (controlled, 3 meds):   +50 debits
Excellent compliance:                 -10 credits
Normal ECG:                           -15 credits
Family history of CVD:                +25 debits
Regular exercise:                     -10 credits
──────────────────────────────────────────────────
Net mortality:                        140% → Table C
```

### 1.5 Temporal Considerations

Medical risk is not static. Underwriting applies **durational adjustments**:

- **Recency** — A heart attack 6 months ago is vastly different from one 10 years ago.
- **Stability** — 5 years of stable HbA1c readings carry more weight than a single value.
- **Trend** — Improving cholesterol over 3 readings is more favorable than a single normal reading.
- **Postponement** — Some conditions require a waiting period before the applicant is insurable (e.g., 12 months post-cancer treatment).

| Time-Since-Event | Typical Impact on Rating |
|------------------|------------------------|
| < 6 months | Decline or Postpone |
| 6–12 months | Table H–P or Postpone |
| 1–2 years | Table D–H |
| 2–5 years | Table A–D or Standard (depending on condition) |
| 5–10 years | Standard or Preferred (if no recurrence) |
| > 10 years | Possible Preferred (condition-dependent) |

### 1.6 Interplay of Multiple Impairments

When an applicant has multiple medical conditions, underwriting does **not** simply add debits. The industry uses two approaches:

1. **Additive method** — Sum all debits for independent conditions (e.g., hypertension + high cholesterol). Used when conditions are unrelated.
2. **Multiplicative method** — Multiply mortality ratios for synergistic conditions (e.g., diabetes + smoking). Used when conditions compound risk.

Many automated systems use a hybrid: additive for unrelated conditions, multiplicative when a known synergy exists (as defined in the impairment guide).

### 1.7 Sources of Medical Evidence

| Evidence Source | Cost per Case | Turnaround | Reliability | When Required |
|----------------|--------------|-----------|------------|--------------|
| Application medical questions | $0 | Immediate | Low–Medium (self-reported) | Always |
| Paramedical exam | $50–$100 | 3–7 days | High | Face amount > $100K or age > 50 (varies) |
| Blood/urine labs | $30–$60 | 2–5 days | Very High | Bundled with paramedical |
| APS (Attending Physician Statement) | $150–$400 | 10–30 days | Very High | Disclosed conditions, age/amount triggers |
| Prescription drug database (Rx) | $5–$15 | Real-time | High | Nearly always (MIB, Milliman IntelliScript) |
| MIB (Medical Information Bureau) | $3–$8 | Real-time | Medium (coded) | Always |
| Motor Vehicle Report (MVR) | $5–$10 | Real-time | High | Always or age/amount triggered |
| Resting ECG | $30–$50 | 3–7 days | High | Age > 50–60 and face amount thresholds |
| Exercise stress test | $200–$500 | 7–14 days | Very High | Rare; specific cardiac concerns |
| Inspection report | $100–$200 | 5–10 days | Medium | High face amounts |

---

## 2. The Paramedical Examination

### 2.1 Purpose

The paramedical exam is a **standardized health screening** performed by a trained examiner (paramedic, nurse, or phlebotomist). It provides objective, independently-collected physical measurements and fluid specimens that supplement self-reported application data.

### 2.2 Who Performs It

| Provider Type | Certification | Typical Use |
|--------------|--------------|-------------|
| Licensed paramedic | State-licensed, AAIM-certified | Most common for mobile exams |
| Registered Nurse (RN) | State nursing license | Higher face amounts, complex cases |
| Licensed Practical Nurse (LPN) | State LPN license | Standard exams |
| Phlebotomist | Certified (CPT) | Specimen-only collections |

Major exam companies in the US market:

| Vendor | Coverage | Electronic Integration | Specialty |
|--------|---------|----------------------|-----------|
| **ExamOne** (Quest Diagnostics) | National | HL7, API, XML | Full-service exam + labs |
| **APPS/Paramed** (Hooper Holmes) | National | Proprietary API, XML | Mobile exams |
| **EMSI** | National | REST API, XML | Paramedical + lab |
| **Portamedic** | National | XML feeds | Long-established network |
| **CRL (Clinical Reference Laboratory)** | National | HL7, REST API | Lab-only and full exam |

### 2.3 Scheduling & Fulfillment Flow

```
┌──────────────┐    ┌──────────────────┐    ┌────────────────┐
│  UW System   │───▶│  Exam Vendor     │───▶│  Examiner      │
│  Order Placed│    │  Portal/API      │    │  Dispatch      │
└──────────────┘    └──────────────────┘    └────────┬───────┘
                                                      │
                                                      ▼
                                            ┌────────────────┐
                                            │  Applicant     │
                                            │  Contact &     │
                                            │  Scheduling    │
                                            └────────┬───────┘
                                                      │
                                                      ▼
                                            ┌────────────────┐
                                            │  Exam Performed│
                                            │  (Home/Office) │
                                            └────────┬───────┘
                                                      │
                    ┌─────────────────────────────────┤
                    ▼                                  ▼
          ┌──────────────────┐              ┌──────────────────┐
          │  Specimens to    │              │  Exam Form       │
          │  Laboratory      │              │  Transmitted     │
          │  (Overnight ship)│              │  Electronically  │
          └────────┬─────────┘              └────────┬─────────┘
                   │                                  │
                   ▼                                  ▼
          ┌──────────────────┐              ┌──────────────────┐
          │  Lab Results     │              │  Exam Data       │
          │  Returned (HL7)  │              │  Returned (XML)  │
          └────────┬─────────┘              └────────┬─────────┘
                   │                                  │
                   └──────────────┬───────────────────┘
                                  ▼
                        ┌──────────────────┐
                        │  UW System       │
                        │  Data Ingestion  │
                        │  & Rules Engine  │
                        └──────────────────┘
```

### 2.4 Data Captured During the Exam

#### 2.4.1 Physical Measurements

| Measurement | Method | Normal Range | UW Significance |
|------------|--------|-------------|-----------------|
| **Height** | Stadiometer or self-report verified | N/A | Build chart input |
| **Weight** | Calibrated scale | N/A | Build chart input; BMI calculation |
| **Blood Pressure — Systolic** | Sphygmomanometer (2–3 readings, averaged) | 90–120 mmHg | >140 = Stage 1 HTN; >160 = Stage 2 |
| **Blood Pressure — Diastolic** | Sphygmomanometer | 60–80 mmHg | >90 = Stage 1 HTN; >100 = Stage 2 |
| **Resting Pulse** | Palpation or automatic cuff (60 seconds) | 60–100 bpm | <50 or >100 may require ECG follow-up |
| **Waist Circumference** | Tape measure at navel | M: <40 in; F: <35 in | Metabolic syndrome indicator |

#### 2.4.2 Blood Pressure Classification (per ACC/AHA Guidelines)

| Category | Systolic (mmHg) | Diastolic (mmHg) | UW Impact |
|----------|----------------|------------------|-----------|
| Normal | < 120 | < 80 | Best class eligible |
| Elevated | 120–129 | < 80 | Preferred possible; monitor |
| Stage 1 Hypertension | 130–139 | 80–89 | Standard or Preferred (if controlled, no meds or 1 med) |
| Stage 2 Hypertension | ≥ 140 | ≥ 90 | Standard at best; substandard if uncontrolled |
| Hypertensive Crisis | > 180 | > 120 | Decline or Postpone; refer to physician |

**Multiple Reading Protocol:**

Most carriers require **2–3 readings** taken 5 minutes apart. The underwriting system should:

1. Discard the first reading if it is significantly higher (white coat effect).
2. Average the remaining readings.
3. Use the averaged value for classification.
4. If readings vary by > 20 mmHg systolic, flag for follow-up or re-exam.

#### 2.4.3 Specimen Collection

| Specimen | Collection Method | Chain of Custody | Testing Performed |
|----------|------------------|-----------------|-------------------|
| **Blood** (venipuncture) | 2–3 tubes (EDTA, SST, gray-top) | Sealed, labeled, witnessed | CBC, CMP, lipids, HbA1c, HIV, HepB/C, PSA, cotinine, CDT |
| **Urine** (clean-catch mid-stream) | Single specimen cup | Sealed, temp-verified | Drug screen (10-panel), protein, glucose, specific gravity, cotinine |
| **Oral fluid** (alternative) | Swab collection | Sealed kit | HIV, cotinine, drugs (limited panel) |

#### 2.4.4 Medical History Interview

The examiner conducts a structured interview covering:

| Section | Questions Covered | Data Format |
|---------|------------------|-------------|
| Personal medical history | All diagnosed conditions, surgeries, hospitalizations | Free text + coded conditions |
| Current medications | Name, dose, frequency, prescribing physician | Structured list |
| Physician information | PCP name, address, last visit date | Structured fields |
| Family history | Parents, siblings — cause of death, age at diagnosis | Structured per-relative |
| Tobacco/alcohol/drug use | Current use, history, amounts, last use date | Coded + numeric |
| Female-specific | Pregnancy status, complications, mammogram results | Conditional fields |
| Mental health | Diagnoses, treatment, hospitalizations, suicidal ideation | Coded + free text |

### 2.5 Electronic Data Transmission Formats

| Format | Standard | Usage |
|--------|---------|-------|
| **ACORD XML** | ACORD TXLife (103/121 transactions) | Industry-standard for exam results |
| **HL7 v2.x** | HL7 ORU (Observation Result) | Lab results from reference labs |
| **HL7 FHIR R4** | FHIR DiagnosticReport, Observation | Modern API-based integrations |
| **Proprietary XML/JSON** | Vendor-specific schemas | Legacy exam vendor feeds |
| **PDF** | Scanned forms | Fallback when electronic fails |

### 2.6 Exam Completion SLAs

| Metric | Target | Acceptable | Escalation Trigger |
|--------|--------|-----------|-------------------|
| Applicant contact within | 24 hours of order | 48 hours | > 72 hours |
| Exam scheduled within | 3 business days | 5 business days | > 7 business days |
| Exam completed within | 7 calendar days of order | 10 calendar days | > 14 calendar days |
| Lab results returned | 2–3 business days from receipt | 5 business days | > 7 business days |
| Exam form transmitted | Same day as exam | Next business day | > 2 business days |

---

## 3. Blood Profile Laboratory Testing

### 3.1 Overview

The underwriting blood panel is the **single most objective medical evidence** available. It screens for undisclosed conditions, verifies self-reported information, and quantifies known conditions. A standard underwriting panel includes 40–60 individual analytes.

### 3.2 Complete Blood Count (CBC)

The CBC evaluates the cellular components of blood. It screens for anemia, infection, clotting disorders, and hematological malignancies.

| Analyte | Normal Range | Low Value Indicates | High Value Indicates | UW Action |
|---------|-------------|--------------------|--------------------|-----------|
| **WBC (White Blood Cells)** | 4,000–11,000 /µL | Immunosuppression, bone marrow failure, viral infection | Infection, inflammation, leukemia, stress response | WBC > 15,000: investigate; > 20,000: APS or decline |
| **RBC (Red Blood Cells)** | M: 4.5–5.5 M/µL; F: 4.0–5.0 M/µL | Anemia, hemorrhage, nutritional deficiency | Polycythemia, dehydration, chronic hypoxia | Low: assess cause; High: evaluate for polycythemia vera |
| **Hemoglobin (Hgb)** | M: 13.5–17.5 g/dL; F: 12.0–16.0 g/dL | Anemia (iron, B12, folate, chronic disease) | Polycythemia, dehydration | < 10: APS required; investigate malignancy |
| **Hematocrit (Hct)** | M: 38–50%; F: 36–44% | Anemia, overhydration | Dehydration, polycythemia | Correlates with Hgb; evaluate together |
| **MCV (Mean Corpuscular Volume)** | 80–100 fL | Iron deficiency, thalassemia (microcytic) | B12/folate deficiency, liver disease, alcohol abuse (macrocytic) | MCV > 100: evaluate for alcohol abuse + CDT |
| **MCH** | 27–33 pg | Microcytic anemia | Macrocytic anemia | Correlates with MCV |
| **MCHC** | 32–36 g/dL | Hypochromic anemia | Spherocytosis (rare) | Supportive metric |
| **RDW** | 11.5–14.5% | N/A (low is normal) | Mixed anemia, nutritional deficiency, myelodysplasia | Elevated: supports further anemia workup |
| **Platelet Count** | 150,000–400,000 /µL | Thrombocytopenia (bleeding risk, liver disease, bone marrow) | Thrombocytosis (inflammation, iron deficiency, myeloproliferative) | < 100K: APS required; < 50K: Decline |

### 3.3 Comprehensive Metabolic Panel (CMP / Chem-20)

The CMP evaluates organ function: kidneys, liver, electrolytes, and glucose metabolism.

#### 3.3.1 Electrolytes

| Analyte | Normal Range | Low Value | High Value | UW Significance |
|---------|-------------|-----------|-----------|----------------|
| **Sodium (Na)** | 136–145 mEq/L | Hyponatremia: SIADH, heart failure, liver cirrhosis, diuretic use | Hypernatremia: dehydration, diabetes insipidus | Mildly abnormal: usually benign; severely low (< 125): investigate |
| **Potassium (K)** | 3.5–5.0 mEq/L | Hypokalemia: diuretics, GI loss, renal tubular acidosis | Hyperkalemia: kidney disease, ACE inhibitors, hemolyzed specimen | K > 5.5: may be hemolyzed specimen — request redraw; true elevation suggests renal impairment |
| **Chloride (Cl)** | 98–106 mEq/L | Metabolic alkalosis, vomiting | Metabolic acidosis, renal tubular acidosis | Rarely triggers UW action alone; interpreted with other electrolytes |
| **CO₂ (Bicarbonate)** | 23–29 mEq/L | Metabolic acidosis (DKA, renal failure, lactic acidosis) | Metabolic alkalosis (vomiting, diuretics) | Low CO₂ with elevated glucose: screen for DKA; with elevated creatinine: CKD |

#### 3.3.2 Renal Function

| Analyte | Normal Range | Abnormal Interpretation | UW Action |
|---------|-------------|------------------------|-----------|
| **BUN (Blood Urea Nitrogen)** | 7–20 mg/dL | Elevated: kidney disease, dehydration, high-protein diet, GI bleeding. Low: liver disease, malnutrition | BUN > 30: evaluate creatinine and eGFR |
| **Creatinine** | M: 0.7–1.3 mg/dL; F: 0.6–1.1 mg/dL | Elevated: kidney dysfunction, muscle mass variation. Low: low muscle mass | Cr > 1.5 (M) / > 1.3 (F): calculate eGFR; if eGFR < 60 → CKD staging |
| **eGFR (calculated)** | > 90 mL/min/1.73m² | < 60: CKD Stage 3+; < 30: CKD Stage 4; < 15: CKD Stage 5 (ESRD) | See CKD section in Impairment Guide |
| **BUN/Creatinine Ratio** | 10:1 to 20:1 | > 20:1: dehydration, GI bleed, high protein. < 10:1: liver disease, malnutrition | Contextual metric |

**eGFR Calculation (CKD-EPI 2021 formula):**

```
eGFR = 142 × min(Scr/κ, 1)^α × max(Scr/κ, 1)^(-1.200) × 0.9938^age [× 1.012 if female]

Where:
  Scr = serum creatinine (mg/dL)
  κ   = 0.7 (female) or 0.9 (male)
  α   = -0.241 (female) or -0.302 (male)
```

#### 3.3.3 Glucose & Diabetes Markers

| Analyte | Normal Range | Pre-Diabetes | Diabetes | UW Action |
|---------|-------------|-------------|---------|-----------|
| **Fasting Glucose** | 70–99 mg/dL | 100–125 mg/dL (IFG) | ≥ 126 mg/dL | ≥ 126 on two occasions = diabetes diagnosis |
| **Random Glucose** | 70–140 mg/dL | 140–199 mg/dL | ≥ 200 mg/dL | Non-fasting > 200: probable diabetes; request HbA1c |
| **HbA1c** | < 5.7% | 5.7–6.4% | ≥ 6.5% | See detailed HbA1c thresholds in Diabetes section |

#### 3.3.4 Liver Function

| Analyte | Normal Range | Mild Elevation (1–2× ULN) | Moderate (2–5× ULN) | Severe (> 5× ULN) | UW Significance |
|---------|-------------|--------------------------|--------------------|--------------------|----------------|
| **Total Bilirubin** | 0.1–1.2 mg/dL | Gilbert's syndrome (benign), mild hemolysis | Hepatitis, biliary obstruction | Severe hepatic disease, biliary obstruction | > 2.0 with elevated ALT/AST: APS for liver disease |
| **ALP (Alkaline Phosphatase)** | 44–147 IU/L | Bone growth, mild liver congestion | Biliary obstruction, bone disease, Paget's | Biliary obstruction, metastatic cancer | Isolated ALP elevation: may be bone origin; with elevated GGT confirms hepatic |
| **ALT (Alanine Aminotransferase)** | 7–56 IU/L | NAFLD, medications, obesity | Hepatitis (viral, toxic, autoimmune) | Acute hepatitis, drug toxicity | ALT is most liver-specific; > 2× ULN: APS; > 5× ULN: Postpone |
| **AST (Aspartate Aminotransferase)** | 10–40 IU/L | Liver, muscle, cardiac source | Hepatitis, myocardial injury, rhabdomyolysis | Acute hepatitis, acetaminophen toxicity | AST/ALT ratio > 2:1 suggests alcoholic liver disease |
| **GGT (Gamma-Glutamyl Transferase)** | M: 8–61 IU/L; F: 5–36 IU/L | Alcohol use, medications, obesity | Alcohol abuse, biliary disease, pancreatic disease | Severe hepatic disease, biliary obstruction | GGT > 3× ULN: strong marker for alcohol abuse; correlate with CDT |
| **Total Protein** | 6.0–8.3 g/dL | Malnutrition, liver disease, nephrotic syndrome | Chronic inflammation, multiple myeloma, dehydration | N/A | Low: evaluate for liver/kidney disease; High: evaluate for myeloma |
| **Albumin** | 3.5–5.0 g/dL | Liver disease, malnutrition, nephrotic syndrome, chronic inflammation | Dehydration (relative elevation) | N/A | Albumin < 3.0: significant marker for liver synthetic failure; high mortality predictor |
| **Calcium** | 8.5–10.5 mg/dL | Hypoparathyroidism, vitamin D deficiency, renal disease | Hyperparathyroidism, malignancy, vitamin D excess, sarcoidosis | Malignancy (hypercalcemia of malignancy) | Ca > 11.0: evaluate for malignancy and hyperparathyroidism |

**Liver Enzyme Pattern Recognition for UW Systems:**

| Pattern | AST | ALT | GGT | ALP | Bilirubin | Likely Cause | UW Approach |
|---------|-----|-----|-----|-----|-----------|-------------|-------------|
| Hepatocellular | ↑↑ | ↑↑↑ | ↑ | Normal/↑ | ↑ | Viral hepatitis, NAFLD, drug toxicity | APS; rate based on cause and chronicity |
| Cholestatic | Normal/↑ | Normal/↑ | ↑↑↑ | ↑↑↑ | ↑↑ | Biliary obstruction, PBC, PSC | APS; evaluate for malignancy |
| Alcoholic | ↑↑ | ↑ | ↑↑↑ | ↑ | ↑ | Alcohol abuse (AST/ALT > 2:1) | CDT confirmation; alcohol questionnaire; Table B–D minimum |
| Isolated GGT | Normal | Normal | ↑↑ | Normal | Normal | Alcohol, medications, obesity | If CDT normal: may be benign; monitor |
| Infiltrative | Normal/↑ | Normal/↑ | ↑↑ | ↑↑↑ | Normal/↑ | Metastatic cancer, granulomatous disease | Urgent APS; evaluate for malignancy |

### 3.4 Lipid Panel

| Analyte | Optimal | Borderline | High Risk | UW Threshold for Best Class |
|---------|---------|-----------|-----------|---------------------------|
| **Total Cholesterol** | < 200 mg/dL | 200–239 mg/dL | ≥ 240 mg/dL | < 250 for Preferred; < 300 for Standard |
| **HDL Cholesterol** | M: > 40 mg/dL; F: > 50 mg/dL | M: 35–40; F: 45–50 | M: < 35; F: < 45 | > 45 for Preferred Plus (male) |
| **LDL Cholesterol** | < 100 mg/dL | 100–159 mg/dL | ≥ 160 mg/dL | < 160 for Preferred; < 190 for Standard |
| **Triglycerides** | < 150 mg/dL | 150–199 mg/dL | ≥ 200 mg/dL (Very high: ≥ 500) | < 200 for Preferred; < 400 for Standard |
| **TC/HDL Ratio** | < 3.5 | 3.5–5.0 | > 5.0 | < 4.5 for Preferred Plus; < 5.5 for Preferred |

**Lipid Panel UW Decision Matrix:**

| Scenario | Total Chol | HDL | LDL | Trig | TC/HDL | Statin Use | UW Class Ceiling |
|----------|-----------|-----|-----|------|--------|-----------|-----------------|
| Optimal | < 200 | > 60 | < 100 | < 100 | < 3.0 | No | Preferred Plus |
| Good | < 240 | > 45 | < 130 | < 150 | < 4.5 | No | Preferred |
| Managed | < 260 | > 40 | < 160 | < 200 | < 5.5 | Yes | Standard Plus (some carriers) |
| Borderline | < 300 | > 35 | < 190 | < 300 | < 6.5 | Yes/No | Standard |
| Elevated | 300+ | < 35 | 190+ | 300–499 | > 6.5 | Yes/No | Table A–B |
| Severe | 350+ | < 30 | 220+ | ≥ 500 | > 7.5 | Any | Table C+ or Decline |

### 3.5 HbA1c (Glycated Hemoglobin)

HbA1c reflects average blood glucose over the prior **8–12 weeks**. It is the single most important test for diabetes screening and monitoring.

| HbA1c Value | Interpretation | UW Classification (No known DM) | UW Classification (Known DM) |
|------------|---------------|--------------------------------|------------------------------|
| < 5.7% | Normal | No impact | Excellent control — best available class |
| 5.7–6.0% | Low-end pre-diabetes | No impact (most carriers) | Good control |
| 6.0–6.4% | Pre-diabetes | Standard (some carriers Table A) | Good control |
| 6.5–6.9% | Diabetes diagnostic threshold | Table A–B (new finding); APS | Fair control — Standard to Table B |
| 7.0–7.4% | Diabetes — moderate control | Table B–D; APS required | Table A–C |
| 7.5–7.9% | Diabetes — suboptimal control | Table D–F; APS required | Table C–D |
| 8.0–8.9% | Diabetes — poor control | Table F–H | Table D–H |
| 9.0–9.9% | Diabetes — very poor control | Table H–P or Decline | Table H or Decline |
| ≥ 10.0% | Diabetes — uncontrolled | Decline | Decline |

### 3.6 Prostate-Specific Antigen (PSA)

Required for males typically age 50+ (some carriers 40+).

| PSA Value (ng/mL) | Age < 50 | Age 50–59 | Age 60–69 | Age 70+ | UW Action |
|-------------------|----------|----------|----------|---------|-----------|
| 0.0–2.5 | Normal | Normal | Normal | Normal | No impact |
| 2.5–4.0 | Elevated for age | Normal | Normal | Normal | Monitor; no action for 50+ |
| 4.0–7.0 | Significantly elevated | Mildly elevated | Borderline | Normal/age-appropriate | APS; evaluate for BPH vs. cancer |
| 7.0–10.0 | Highly suspicious | Elevated | Elevated | Elevated | APS required; postpone pending biopsy |
| > 10.0 | Very high cancer risk | Very high | Very high | High | Postpone until prostate workup complete |

**PSA velocity** (rate of change) > 0.75 ng/mL per year is an independent risk factor even if absolute PSA is normal.

### 3.7 Infectious Disease Screening

| Test | Method | Positive Interpretation | Window Period | UW Action |
|------|--------|----------------------|--------------|-----------|
| **HIV-1/2 Antibody + p24 Antigen** | 4th-gen immunoassay (ELISA) | HIV infection | 2–4 weeks (4th gen) | Confirmed positive: Decline (most carriers) or highly rated; evolving with ART outcomes |
| **Hepatitis B Surface Antigen (HBsAg)** | Immunoassay | Active/chronic HBV infection | 4–10 weeks | Positive: APS, viral load, liver function; rate based on disease activity |
| **Hepatitis C Antibody (Anti-HCV)** | Immunoassay | Past or present HCV exposure | 4–10 weeks | Positive: APS, confirm with RNA/PCR; if treated (SVR): insurable with rating |

**HIV Underwriting (Evolving Landscape):**

With modern antiretroviral therapy (ART), HIV+ individuals with undetectable viral loads and CD4 > 500 are approaching near-normal life expectancy. Some carriers now offer rated coverage:

| HIV Status | CD4 Count | Viral Load | UW Action (Progressive Carriers) |
|-----------|----------|-----------|--------------------------------|
| HIV+ on ART | > 500 | Undetectable (< 20 copies/mL) | Table D–H (age-dependent) |
| HIV+ on ART | 200–500 | Undetectable | Table H–P |
| HIV+ on ART | < 200 | Any | Decline |
| HIV+ not on ART | Any | Detectable | Decline |
| HIV+ | Any | > 10,000 copies/mL | Decline |

### 3.8 Substance Use Markers

#### 3.8.1 Cotinine (Nicotine Metabolite)

| Specimen | Cutoff Level | Detection Window | Interpretation |
|----------|-------------|-----------------|---------------|
| **Serum/Blood** | ≥ 10 ng/mL (positive for tobacco use) | 1–3 days | Most common UW test for tobacco |
| **Urine** | ≥ 200 ng/mL (immunoassay) | 3–7 days | Confirmatory |
| **Oral Fluid** | ≥ 30 ng/mL | 1–3 days | Used in non-invasive exams |

| Cotinine Level (Serum) | Interpretation | UW Class Impact |
|------------------------|---------------|----------------|
| < 5 ng/mL | Non-user | Non-tobacco classes eligible |
| 5–10 ng/mL | Possible NRT or secondhand exposure | Investigate; may allow non-tobacco with explanation |
| 10–100 ng/mL | Light tobacco/nicotine use | Tobacco/smoker rates |
| > 100 ng/mL | Active tobacco/heavy nicotine use | Tobacco/smoker rates |

#### 3.8.2 CDT (Carbohydrate-Deficient Transferrin)

CDT is the most specific blood marker for **chronic heavy alcohol consumption** (≥ 60g alcohol/day for ≥ 2 weeks).

| CDT % | Interpretation | UW Action |
|-------|---------------|-----------|
| < 1.7% | Normal | No alcohol concern |
| 1.7–2.0% | Borderline | Evaluate with GGT, MCV, liver enzymes; may be normal variant |
| 2.0–3.0% | Elevated — probable heavy drinking | APS; alcohol questionnaire; Table B–D minimum |
| > 3.0% | Significantly elevated — chronic heavy drinking | Table D–H or Decline; APS; substance abuse evaluation |

#### 3.8.3 Urine Drug Screen (Immunoassay)

Standard **10-panel** urine drug screen:

| Drug Class | Cutoff (ng/mL) | Detection Window | UW Action if Positive |
|-----------|----------------|-----------------|---------------------|
| **Amphetamines** | 500 | 2–4 days | Decline unless valid Rx (e.g., ADHD); APS |
| **Barbiturates** | 200 | 2–10 days (short-acting: 2; long-acting: 10) | Evaluate for prescribed use; decline if illicit |
| **Benzodiazepines** | 200 | 3–7 days | Common Rx; evaluate for anxiety/mental health |
| **Cocaine metabolite** | 150 | 2–4 days | Decline; minimum 2-year lookback for re-evaluation |
| **Marijuana (THC)** | 50 | 3–30 days (frequency-dependent) | Carrier-specific: some allow with limits; some Table A–B; some decline |
| **Methadone** | 300 | 3–5 days | Evaluate for pain management vs. MAT |
| **Opiates** (morphine, codeine) | 2000 | 2–3 days | Evaluate for prescribed use; APS if unexpected |
| **Oxycodone** | 100 | 2–4 days | Evaluate for chronic pain; APS |
| **Phencyclidine (PCP)** | 25 | 3–7 days | Decline |
| **Propoxyphene** | 300 | 2–4 days | Discontinued drug; unexpected finding — investigate |

#### 3.8.4 Urine Biochemistry

| Analyte | Normal | Abnormal | UW Significance |
|---------|--------|---------|----------------|
| **Protein (dipstick)** | Negative or Trace | 1+ to 4+ | Kidney disease; 2+ or higher: quantify protein/creatinine ratio; APS |
| **Glucose** | Negative | Positive | Diabetes screening; requires blood glucose/HbA1c correlation |
| **Specific Gravity** | 1.005–1.030 | < 1.003 (dilute) or > 1.030 (concentrated) | Very dilute specimen may indicate adulteration; request redraw |
| **pH** | 4.5–8.0 | Outside range | May indicate specimen tampering; evaluate clinically |
| **Creatinine (urine)** | 20–300 mg/dL | < 20 mg/dL | Specimen may be dilute/substituted; request new specimen |
| **Nitrite** | Negative | Positive | Specimen adulteration (oxidizing agent) | Reject specimen; new collection |

---

## 4. Attending Physician Statement (APS)

### 4.1 What Is an APS

The APS is a **copy of the applicant's medical records** obtained from their treating physician(s). It is the single most comprehensive source of medical underwriting data and often the most time-consuming evidence to obtain.

An APS typically includes:

- **Office visit notes** — encounter documentation, symptoms, exam findings, assessments, treatment plans
- **Problem lists** — active and resolved diagnoses with ICD-10 codes
- **Medication lists** — current and historical prescriptions
- **Lab results** — historical labs ordered by the treating physician
- **Imaging reports** — X-ray, MRI, CT scan, ultrasound interpretations
- **Specialist consultation notes** — cardiology, oncology, endocrinology, etc.
- **Surgical/procedure reports** — operative notes, pathology results
- **Hospitalization records** — discharge summaries, admission notes
- **Mental health notes** — may be separately released (state-specific consent laws)

### 4.2 When an APS Is Ordered

| Trigger | Condition | Typical Threshold |
|---------|----------|------------------|
| **Age/Amount** | Routine based on face amount and age | $1M+ at any age; $500K+ age 50+; $250K+ age 60+ |
| **Disclosed condition** | Applicant reports a significant medical history | Any cancer history, heart disease, diabetes, mental health hospitalization |
| **Abnormal labs** | Blood/urine results outside acceptable range | eGFR < 60, HbA1c > 6.5%, elevated PSA, positive HIV/HCV |
| **Rx flag** | Prescription database reveals concerning medications | Insulin, anticoagulants, chemotherapy drugs, multiple psychiatric medications |
| **MIB hit** | MIB code indicates prior medical disclosure | Any coded impairment from prior applications |
| **MVR flag** | Motor vehicle report shows DUI/DWI | Any alcohol/drug-related driving offense |

### 4.3 APS Ordering Methods

| Method | Turnaround | Cost | Data Format | Advantages | Disadvantages |
|--------|-----------|------|-------------|-----------|---------------|
| **Electronic (Clareto/EHR)** | 1–5 days | $50–$150 | Structured (FHIR, CCD, C-CDA) | Fast, structured data, lower cost | Limited adoption (30–40% of providers); requires patient consent via digital identity |
| **Electronic (Verisma, MRO, ChartSwap)** | 3–10 days | $75–$200 | PDF + partial structured | Faster than fax; tracking visibility | Often returns PDFs requiring extraction |
| **Fax** | 10–25 days | $100–$250 | Scanned PDF/TIFF | Universally accepted | Slow, illegible, manual processing |
| **Mail** | 15–30+ days | $150–$400 | Paper → scanned | Required by some small practices | Slowest; handling costs; lost records risk |

### 4.4 Electronic APS — Clareto and Health Data Exchange

Clareto (a Verisk subsidiary) is the leading electronic health record retrieval platform for life insurance underwriting.

**Clareto Flow:**

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  UW System   │────▶│  Clareto Hub │────▶│  EHR Systems  │
│  (API Call)  │     │  (Router)    │     │  (Epic, Cerner│
│              │     │              │     │   Athena, etc)│
└──────────────┘     └──────┬───────┘     └──────┬───────┘
                            │                     │
                            │    C-CDA / FHIR     │
                            │◀────────────────────┘
                            │
                     ┌──────▼───────┐
                     │  Structured  │
                     │  Medical     │
                     │  Summary     │
                     └──────┬───────┘
                            │
                     ┌──────▼───────┐
                     │  UW System   │
                     │  Ingestion   │
                     │  & Rules     │
                     └──────────────┘
```

**C-CDA Sections Relevant to Underwriting:**

| C-CDA Section | UW Data Extracted | LOINC/SNOMED Codes |
|--------------|-------------------|-------------------|
| Problems | Active diagnoses with ICD-10, onset dates | SNOMED CT problem codes |
| Medications | Current prescriptions (name, dose, frequency) | RxNorm codes |
| Results | Lab values with dates, reference ranges | LOINC codes |
| Procedures | Surgeries, biopsies, interventions with dates | CPT/SNOMED codes |
| Vital Signs | BP, weight, BMI over time | LOINC vital sign codes |
| Social History | Smoking status, alcohol, occupation | SNOMED social history |
| Encounters | Visit dates, types, providers | CPT E/M codes |
| Immunizations | Vaccination history | CVX codes |

### 4.5 NLP/AI Extraction from Unstructured APS

70–80% of APS records arrive as unstructured PDFs (scanned documents, faxed records). AI/NLP extraction is critical for automated processing.

**NLP Pipeline Architecture:**

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Scanned PDF │────▶│  OCR Engine  │────▶│  NLP Pipeline │────▶│  Structured  │
│  (APS)       │     │  (Tesseract, │     │  (Entity      │     │  Medical     │
│              │     │   Amazon     │     │   Extraction, │     │  Summary     │
│              │     │   Textract,  │     │   Relation    │     │  (JSON/FHIR) │
│              │     │   Google     │     │   Extraction, │     │              │
│              │     │   Vision)    │     │   Temporal    │     │              │
│              │     │              │     │   Reasoning)  │     │              │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
```

**Key NLP Tasks for APS Processing:**

| Task | Description | Model Approaches | Accuracy Target |
|------|-----------|-----------------|----------------|
| **Medical NER** | Extract condition names, medications, lab values, dates | BioBERT, Clinical BERT, Med7, SpaCy custom | > 92% F1 |
| **Negation Detection** | Distinguish "patient denies chest pain" from "patient has chest pain" | NegEx, NegBERT, rule-based patterns | > 95% precision |
| **Temporal Extraction** | Extract dates, durations, relative time ("3 years ago") | SUTime, HeidelTime, custom temporal models | > 88% F1 |
| **Relation Extraction** | Link conditions to dates, medications to conditions, lab values to dates | Transformer-based RE models, dependency parsing | > 85% F1 |
| **Section Classification** | Identify which part of the record a finding belongs to (HPI, assessment, plan, etc.) | Document layout models, rule + ML hybrid | > 90% accuracy |
| **Severity Assessment** | Determine condition severity (mild/moderate/severe) from narrative | Classification models, ontology-based inference | > 80% accuracy |
| **Medication-Condition Mapping** | Infer undisclosed conditions from medications | RxNorm + ontology-based rules | > 90% accuracy |

**Key Entities Extracted:**

| Entity Type | Examples | Standardization |
|------------|---------|----------------|
| Diagnoses | "Type 2 diabetes mellitus", "HTN", "afib" | ICD-10-CM codes |
| Medications | "metformin 500mg BID", "Lipitor 20mg daily" | RxNorm CUI |
| Lab Results | "HbA1c 7.2%", "eGFR 45", "PSA 3.1" | LOINC codes + numeric values |
| Procedures | "CABG x3 (2019)", "colonoscopy — no polyps" | CPT codes |
| Dates | "diagnosed in March 2018", "2 years ago" | ISO 8601 dates |
| Vitals | "BP 138/88", "BMI 32.4" | LOINC vital sign codes |
| Social History | "former smoker, quit 2015", "2 drinks/week" | Coded categories |

### 4.6 APS Turnaround Management

| Status | Timeframe | System Action |
|--------|----------|--------------|
| Order placed | Day 0 | Send request via preferred channel (electronic > fax > mail) |
| Follow-up #1 | Day 7 | Automated follow-up to provider; status check |
| Follow-up #2 | Day 14 | Escalated follow-up; alternative provider contact |
| Follow-up #3 | Day 21 | Phone call to provider; consider alternative evidence |
| Escalation | Day 28 | Underwriter review; applicant contact for assistance |
| Timeout | Day 45 | Consider APS waiver (if other evidence sufficient) or close case |

---

## 5. Resting ECG

### 5.1 What It Measures

A resting 12-lead electrocardiogram (ECG/EKG) records the heart's electrical activity across 12 different "views" of the heart. It screens for:

- **Rhythm disorders** — atrial fibrillation, heart block, premature beats
- **Ischemic changes** — ST depression/elevation, T-wave inversions
- **Conduction abnormalities** — bundle branch blocks, prolonged QT
- **Hypertrophy** — left/right ventricular hypertrophy
- **Prior myocardial infarction** — Q-waves indicating scar tissue

### 5.2 When Required

| Age | Face Amount | ECG Required? |
|-----|-----------|--------------|
| < 40 | Any | Only if cardiac history disclosed |
| 40–49 | < $500K | No (most carriers) |
| 40–49 | ≥ $500K | Yes (some carriers) |
| 50–59 | < $250K | Some carriers |
| 50–59 | ≥ $250K | Yes |
| 60–69 | Any face amount ≥ $100K | Yes |
| 70+ | Any face amount | Yes |

### 5.3 ECG Parameters and UW Significance

| ECG Parameter | Normal Range | UW Finding |
|--------------|-------------|-----------|
| **Heart Rate** | 60–100 bpm | < 50 or > 100: evaluate for cause |
| **PR Interval** | 120–200 ms | > 200 ms: 1st degree AV block (usually benign) |
| **QRS Duration** | < 120 ms | 120–150 ms: incomplete BBB; > 150 ms: complete BBB |
| **QT/QTc Interval** | QTc < 440 ms (M); < 460 ms (F) | > 500 ms: significant arrhythmia risk; Table rating or Decline |
| **ST Segment** | Isoelectric (no depression/elevation) | Depression > 1 mm: ischemia; Elevation: injury/pericarditis |
| **T-wave** | Upright in most leads | Inversions in anterior leads (V1–V4): possible ischemia |
| **P-wave** | Present, upright in lead II | Absent: atrial fibrillation; irregular: atrial flutter |
| **Q-waves** | Small or absent in most leads | Pathological Q-waves: prior myocardial infarction |
| **Axis** | -30° to +90° | Left axis deviation: LVH, left anterior fascicular block |

### 5.4 Minnesota Code Classification

The **Minnesota Code** is a standardized system for classifying ECG findings. Automated ECG interpretation systems (e.g., GE MUSE, Philips DXL, Mortara) output Minnesota codes that map directly to UW decisions.

| Minnesota Code | Finding | UW Category | Typical UW Action |
|---------------|---------|-------------|-------------------|
| **1-1** | Large Q/QS waves (probable MI) | Major | Table C–H; APS required; cardiac workup |
| **1-2** | Moderate Q/QS waves (possible MI) | Major | Table B–D; APS required |
| **1-3** | Small Q/QS waves | Minor | Usually no action; monitor |
| **2-1** | ST junction depression ≥ 2 mm | Major | Table C–H; stress test may be needed |
| **2-2** | ST junction depression 1–2 mm | Moderate | Table A–C; APS; evaluate for ischemia |
| **3-1** | T-wave inversion ≥ 5 mm | Major | Table B–D; cardiac evaluation |
| **3-2** | T-wave inversion 1–5 mm | Moderate | Table A–B; may be positional or non-specific |
| **4-1** | Left ventricular hypertrophy (LVH) | Moderate | Table A–C; correlate with BP |
| **4-2** | Possible LVH | Minor | Evaluate with BP, BMI |
| **5-1** | Right ventricular hypertrophy | Moderate | APS; evaluate for pulmonary disease |
| **6-1** | AV block, 1st degree | Minor | Usually benign; no action if isolated |
| **6-2** | AV block, 2nd degree (Mobitz I) | Moderate | APS; Table A–B |
| **6-3** | AV block, 2nd degree (Mobitz II) | Major | APS; Table C–D; cardiology referral |
| **6-4** | Complete heart block (3rd degree) | Major | APS; Table D–H or Decline |
| **7-1** | Left bundle branch block (LBBB) | Moderate–Major | APS; Table B–D; may mask ischemia |
| **7-2** | Right bundle branch block (RBBB) | Minor | Usually benign; no action if isolated |
| **7-4** | Intraventricular conduction delay | Minor | Evaluate with clinical context |
| **8-1** | Atrial fibrillation | Major | APS; Table B–H depending on cause/control |
| **8-3** | Atrial flutter | Major | APS; Table B–D |
| **8-1-2** | Atrial fibrillation — controlled rate | Moderate | APS; Table B–C if well-managed |
| **8-4** | Supraventricular tachycardia | Moderate | APS; Table A–C |
| **9-2** | Prolonged QTc | Moderate–Major | > 500 ms: Table D+ or Decline; 460–500: Table A–C |

### 5.5 Automated ECG Interpretation Pipeline

```
┌────────────────┐     ┌─────────────────┐     ┌──────────────────┐
│  ECG Device    │────▶│  ECG Server     │────▶│  UW System       │
│  (12-lead)     │     │  (GE MUSE,      │     │  Integration     │
│                │     │   Philips DXL)  │     │                  │
│  Raw Signal    │     │  Automated      │     │  Minnesota Code  │
│  (SCP-ECG,     │     │  Interpretation │     │  Mapping →       │
│   DICOM, HL7)  │     │  + Minnesota    │     │  UW Decision     │
│                │     │  Codes          │     │  Rules           │
└────────────────┘     └─────────────────┘     └──────────────────┘
```

**Data Flow Formats:**

| Stage | Format | Standard |
|-------|--------|---------|
| Raw signal capture | SCP-ECG, FDA XML, proprietary | IEC 11073 |
| Interpretation | HL7 ORU message | HL7 v2.5+ |
| Structured results | XML/JSON with Minnesota codes | Vendor-specific or FHIR DiagnosticReport |
| PDF report | Rendered ECG strip + interpretation | PDF/A |

---

## 6. Medical Impairment Guide — Top 30 Conditions

This section provides detailed underwriting assessment guidelines for the 30 most common medical conditions encountered in term life underwriting. Each condition includes risk classification outcomes based on severity, duration, treatment, and control status.

### 6.1 Cardiovascular Conditions

#### 6.1.1 Hypertension (Essential/Primary)

**Prevalence in UW population:** 25–35% of applicants report hypertension or take antihypertensive medication.

| Factor | Best Case | Moderate Risk | High Risk | Decline Trigger |
|--------|----------|--------------|----------|----------------|
| **Blood pressure (treated or untreated)** | < 140/90 | 140–159/90–99 | 160–179/100–109 | ≥ 180/110 |
| **Number of medications** | 0–1 | 2 | 3 | 4+ with poor control |
| **Duration of diagnosis** | > 5 years with control | 2–5 years | < 2 years (newly diagnosed) | N/A |
| **End-organ damage** | None | Mild LVH | Retinopathy, proteinuria | CKD Stage 4+, stroke |
| **Comorbidities** | None | Elevated cholesterol | Diabetes | DM + CKD + CVD |

| Scenario | Rating |
|----------|--------|
| BP < 135/85, 1 medication, no complications, ideal build | Preferred |
| BP < 140/90, 1–2 medications, no complications | Standard Plus |
| BP < 145/90, 2 medications, mild LVH on ECG | Standard |
| BP 145–159/90–99, 2–3 medications, well-controlled | Table A–B |
| BP 160+/100+, 3+ medications, LVH, proteinuria | Table C–D |
| Uncontrolled HTN with CKD or prior stroke | Table D–H or Decline |

#### 6.1.2 Coronary Artery Disease (CAD)

| Factor | Rating Driver |
|--------|-------------|
| **Type of event** | Stable angina < MI < CABG < multiple events |
| **Time since event** | < 1 year: Postpone or Table H+; 1–5 years: Table C–H; > 5 years: Table A–D |
| **Number of vessels** | Single vessel < 2-vessel < 3-vessel/left main |
| **Revascularization** | Successful PCI/CABG improves rating |
| **Ejection fraction** | > 55%: favorable; 40–55%: moderate; < 40%: severe |
| **Stress test result** | Normal post-event: favorable; abnormal: unfavorable |
| **Risk factors controlled** | Non-smoker, controlled BP, lipids on target: credits |

| Scenario | Rating |
|----------|--------|
| Single-vessel PCI, 5+ years ago, EF > 55%, normal stress test, all RF controlled | Standard to Table A |
| 2-vessel CABG, 3–5 years ago, EF 50%, controlled RF | Table B–D |
| MI < 2 years ago, 3-vessel disease, EF 40–50% | Table D–H |
| Multiple MIs, EF < 40%, ongoing symptoms | Decline |

#### 6.1.3 Heart Attack (Myocardial Infarction)

| Time Since MI | No Residual Damage (EF > 55%) | Mild Damage (EF 45–55%) | Moderate Damage (EF 35–45%) | Severe (EF < 35%) |
|--------------|------------------------------|------------------------|---------------------------|-------------------|
| < 6 months | Postpone | Postpone | Postpone | Decline |
| 6–12 months | Table D–F | Table F–H | Table H–P | Decline |
| 1–2 years | Table B–D | Table D–F | Table F–H | Decline |
| 2–5 years | Table A–B | Table B–D | Table D–F | Table H or Decline |
| 5–10 years | Standard–Table A | Table A–C | Table C–E | Table F or Decline |
| > 10 years | Standard (possible) | Table A–B | Table B–D | Table D–F |

#### 6.1.4 Atrial Fibrillation (AFib)

| Factor | Classification |
|--------|---------------|
| **Type** | Paroxysmal (intermittent, self-terminating) vs. Persistent vs. Permanent |
| **Cause** | Lone/idiopathic (best prognosis); valvular (worst); post-surgical (temporary) |
| **Rate control** | Well-controlled (< 100 bpm) vs. uncontrolled |
| **Anticoagulation** | On appropriate therapy (warfarin, DOAC): positive; not anticoagulated with CHADS-VASc ≥ 2: negative |
| **Stroke risk (CHA₂DS₂-VASc)** | 0–1: low risk; 2–3: moderate; 4+: high |

| Scenario | Rating |
|----------|--------|
| Lone AFib, paroxysmal, age < 65, rate-controlled, CHA₂DS₂-VASc 0–1 | Standard to Table A |
| Persistent AFib, controlled rate, on DOAC, no structural heart disease, CHA₂DS₂-VASc 2 | Table A–C |
| Permanent AFib, valvular, CHA₂DS₂-VASc 3+ | Table C–F |
| AFib with history of stroke | Table D–H |
| AFib with heart failure | Table F or Decline |

#### 6.1.5 Heart Murmur

| Murmur Type | Typical UW Action |
|-------------|-------------------|
| Functional/innocent murmur (confirmed by echo) | No rating impact; Preferred eligible |
| Mitral valve prolapse — no regurgitation | Standard; Preferred possible |
| Mild valvular regurgitation (any valve) | Standard to Table A |
| Moderate valvular regurgitation | Table A–C |
| Severe valvular regurgitation | Table D–H or Decline |
| Aortic stenosis — mild (gradient < 25 mmHg) | Standard to Table A |
| Aortic stenosis — moderate (gradient 25–40 mmHg) | Table B–D |
| Aortic stenosis — severe (gradient > 40 mmHg) | Table D–H or Decline |
| Prosthetic valve — mechanical (on anticoagulation) | Table B–D |
| Prosthetic valve — bioprosthetic | Table A–C |

#### 6.1.6 Cardiomyopathy

| Type | EF | Rating |
|------|-----|--------|
| Hypertrophic cardiomyopathy — no obstruction, no symptoms, EF > 55% | > 55% | Table B–D |
| Hypertrophic cardiomyopathy — with obstruction or symptoms | Any | Table D–H or Decline |
| Dilated cardiomyopathy — mild (EF 45–55%) | 45–55% | Table C–F |
| Dilated cardiomyopathy — moderate (EF 35–45%) | 35–45% | Table F–H |
| Dilated cardiomyopathy — severe (EF < 35%) | < 35% | Decline |
| Peripartum cardiomyopathy — resolved (EF normalized) | > 55% | Table A–C (if > 2 years resolved) |
| Takotsubo (stress cardiomyopathy) — resolved | > 55% | Standard to Table A (if > 1 year) |

### 6.2 Cancer

Cancer underwriting depends on four key factors: **type, stage, grade, and time since treatment completion**.

#### 6.2.1 Breast Cancer

| Stage at Diagnosis | Time Since Treatment | 5-Year Survival | UW Rating |
|-------------------|---------------------|-----------------|-----------|
| **DCIS (Stage 0)** | Completed treatment | > 99% | Standard (after 1 year) |
| **Stage I** (T1N0) | < 2 years | ~98% | Table A–B |
| **Stage I** (T1N0) | 2–5 years | ~98% | Standard |
| **Stage I** (T1N0) | > 5 years | ~98% | Preferred possible |
| **Stage IIA** (T2N0 or T1N1) | < 2 years | ~92% | Table B–D |
| **Stage IIA** | 2–5 years | ~92% | Table A–B |
| **Stage IIA** | > 5 years | ~92% | Standard |
| **Stage IIB** (T2N1 or T3N0) | < 3 years | ~85% | Table C–F |
| **Stage IIB** | 3–5 years | ~85% | Table B–D |
| **Stage IIB** | > 5 years | ~85% | Table A–B |
| **Stage III** | < 5 years | ~70% | Table D–H or Decline |
| **Stage III** | 5–10 years | ~70% | Table B–D |
| **Stage IV** (metastatic) | Any | ~28% | Decline |

**Favorable modifiers:** ER+/PR+ (hormone receptor positive), HER2-negative, low Ki-67, oncotype DX recurrence score < 18.

**Unfavorable modifiers:** Triple-negative, HER2+, high-grade (Grade 3), lymphovascular invasion, positive margins.

#### 6.2.2 Prostate Cancer

| Gleason Score | Stage | Time Since Treatment | UW Rating |
|--------------|-------|---------------------|-----------|
| **Gleason ≤ 6** (Grade Group 1) | T1–T2a | Active surveillance, > 1 year | Standard |
| **Gleason ≤ 6** | T1–T2a | Post-treatment, undetectable PSA | Standard (after 6 months) |
| **Gleason 3+4=7** (Grade Group 2) | T1–T2 | Post-treatment, undetectable PSA, > 1 year | Standard to Table A |
| **Gleason 3+4=7** | T1–T2 | Post-treatment, > 5 years | Standard |
| **Gleason 4+3=7** (Grade Group 3) | T2–T3 | Post-treatment, > 2 years, undetectable PSA | Table A–C |
| **Gleason 8** (Grade Group 4) | Any | Post-treatment, > 3 years | Table B–D |
| **Gleason 9–10** (Grade Group 5) | Any | Post-treatment, > 5 years | Table C–F |
| Any | **T3b–T4 or N1** | Any | Table D–H or Decline |
| Any | **M1 (metastatic)** | Any | Decline |

#### 6.2.3 Colon/Colorectal Cancer

| Dukes/Stage | Time Since Treatment | UW Rating |
|------------|---------------------|-----------|
| **Stage I** (Dukes A) | > 1 year, clear follow-up | Standard to Table A |
| **Stage I** | > 3 years | Standard |
| **Stage II** (Dukes B) | > 2 years, clear follow-up | Table A–B |
| **Stage II** | > 5 years | Standard |
| **Stage III** (Dukes C — node+) | > 3 years, clear follow-up | Table B–D |
| **Stage III** | > 5 years | Table A–B |
| **Stage IV** (Dukes D — metastatic) | Any | Decline |

#### 6.2.4 Melanoma

| Stage | Breslow Depth | Time Since | UW Rating |
|-------|--------------|-----------|-----------|
| **Stage 0** (in situ) | N/A | > 6 months | Standard; Preferred possible |
| **Stage I** | < 1.0 mm, no ulceration | > 1 year | Standard |
| **Stage I** | 1.0–2.0 mm, no ulceration | > 2 years | Standard to Table A |
| **Stage II** | 2.0–4.0 mm or ulcerated | > 3 years | Table A–C |
| **Stage II** | > 4.0 mm | > 5 years | Table B–D |
| **Stage III** (node+) | Any | > 5 years | Table C–F |
| **Stage IV** (metastatic) | Any | Any | Decline |

#### 6.2.5 Lung Cancer

| Stage | Type | Time Since | UW Rating |
|-------|------|-----------|-----------|
| **Stage IA** (< 3 cm, node-negative) | NSCLC | > 2 years | Table B–D |
| **Stage IA** | NSCLC | > 5 years | Table A–B |
| **Stage IB** | NSCLC | > 3 years | Table C–E |
| **Stage II** | NSCLC | > 5 years | Table D–F |
| **Stage III** | NSCLC | > 5 years | Table F–H or Decline |
| **Stage IV** | Any | Any | Decline |
| Any stage | SCLC (Small Cell) | Any (extremely poor prognosis) | Decline (unless limited stage, > 5 years NED) |

#### 6.2.6 Thyroid Cancer

| Type | Stage | Time Since | UW Rating |
|------|-------|-----------|-----------|
| **Papillary** (most common, excellent prognosis) | Stage I–II | > 1 year, no recurrence | Standard |
| **Papillary** | Stage III | > 2 years | Standard to Table A |
| **Follicular** | Stage I–II | > 1 year | Standard to Table A |
| **Follicular** | Stage III | > 3 years | Table A–C |
| **Medullary** | Any | > 3 years, normal calcitonin | Table B–D |
| **Anaplastic** | Any | Any | Decline (median survival < 6 months) |

#### 6.2.7 Leukemia / Lymphoma

| Type | Status | Time Since Treatment | UW Rating |
|------|--------|---------------------|-----------|
| **Hodgkin Lymphoma** | Complete remission, early stage | > 3 years | Table A–B |
| **Hodgkin Lymphoma** | Complete remission, early stage | > 5 years | Standard |
| **Non-Hodgkin Lymphoma — indolent** (follicular, marginal zone) | Stable/remission | > 3 years | Table A–C |
| **Non-Hodgkin Lymphoma — aggressive** (DLBCL) | Complete remission | > 3 years | Table B–D |
| **Non-Hodgkin Lymphoma — aggressive** | Complete remission | > 5 years | Table A–B |
| **CLL (Chronic Lymphocytic Leukemia)** | Rai Stage 0, observation | > 2 years | Table A–C |
| **CLL** | Rai Stage I–II, treated | > 3 years | Table C–E |
| **CML (Chronic Myeloid Leukemia)** | On TKI (imatinib), molecular remission | > 2 years | Table B–D |
| **AML / ALL (Acute)** | Complete remission | > 5 years | Table C–F |
| **AML / ALL** | Not in remission | Any | Decline |

### 6.3 Diabetes Mellitus

#### 6.3.1 Type 1 Diabetes

| Factor | Best Case | Moderate | Poor | UW Threshold |
|--------|----------|---------|------|-------------|
| **HbA1c** | < 7.0% | 7.0–8.0% | > 8.0% | > 10%: Decline |
| **Age at diagnosis** | < 30 (typical) | Any | Any | N/A |
| **Duration** | > 10 years without complications (favorable) | Any | Any | Short duration: less data |
| **Complications** | None | Background retinopathy only | Nephropathy, neuropathy, PVD | Dialysis or proliferative retinopathy: Decline |
| **Insulin regimen** | Pump or MDI with good control | Standard regimen | Erratic dosing | Compliance indicator |

| Scenario | Rating |
|----------|--------|
| T1DM, HbA1c < 7.0%, no complications, > 5 years duration, age 25–50 | Table B–D |
| T1DM, HbA1c 7.0–7.5%, background retinopathy only | Table D–F |
| T1DM, HbA1c 7.5–8.5%, mild neuropathy | Table F–H |
| T1DM, HbA1c > 8.5% or nephropathy (proteinuria, eGFR < 60) | Table H–P or Decline |

#### 6.3.2 Type 2 Diabetes

| HbA1c | No Complications | Background Retinopathy | Nephropathy (eGFR 30–60) | Multiple Complications |
|-------|-----------------|----------------------|-------------------------|----------------------|
| < 6.5% (diet-controlled) | Standard possible | Table A | Table B–C | Table C–D |
| 6.5–7.0% (oral meds only) | Standard to Table A | Table A–B | Table B–D | Table D–F |
| 7.0–7.5% (oral meds) | Table A–B | Table B–C | Table C–E | Table F–H |
| 7.5–8.0% (insulin or oral) | Table B–D | Table C–D | Table D–F | Table H or Decline |
| 8.0–9.0% | Table D–F | Table F–H | Table H | Decline |
| > 9.0% | Table H or Decline | Decline | Decline | Decline |

**Diabetic Complication Impact (Additive Debits):**

| Complication | Extra Debits |
|-------------|-------------|
| Background retinopathy | +25 to +50 |
| Proliferative retinopathy | +100 to +200 (often Decline) |
| Microalbuminuria | +25 to +50 |
| Proteinuria (macroalbuminuria) | +75 to +150 |
| Peripheral neuropathy (mild) | +25 to +50 |
| Peripheral neuropathy (moderate/severe) | +50 to +100 |
| Peripheral vascular disease | +75 to +150 |
| Autonomic neuropathy | +100 to +200 |
| Diabetic foot ulcer/amputation | +150 to +300 (often Decline) |

### 6.4 Respiratory Conditions

#### 6.4.1 Asthma

| Severity | Treatment | FEV1 | UW Rating |
|----------|----------|------|-----------|
| **Mild intermittent** | Rescue inhaler only (PRN SABA) | > 80% predicted | Preferred possible |
| **Mild persistent** | Low-dose ICS | > 80% predicted | Standard to Preferred |
| **Moderate persistent** | Medium-dose ICS + LABA | 60–80% predicted | Standard to Table A |
| **Severe persistent** | High-dose ICS + LABA ± LAMA | < 60% predicted | Table A–D |
| **Severe — requires systemic steroids** | Oral prednisone, biologics (omalizumab, dupilumab) | < 50% predicted | Table C–F |
| **Asthma with ICU admission** (past 5 years) | Any | Any | Table D–F minimum |

#### 6.4.2 COPD (Chronic Obstructive Pulmonary Disease)

| GOLD Stage | FEV1 (% predicted) | Exacerbation Frequency | UW Rating |
|-----------|-------------------|----------------------|-----------|
| **GOLD 1 — Mild** | ≥ 80% | 0–1/year | Table A–B |
| **GOLD 2 — Moderate** | 50–79% | 0–1/year | Table B–D |
| **GOLD 2 — Moderate** | 50–79% | ≥ 2/year | Table D–F |
| **GOLD 3 — Severe** | 30–49% | Any | Table F–H |
| **GOLD 4 — Very Severe** | < 30% | Any | Decline |
| COPD on home oxygen | Any | Any | Decline |

**Smoking status** is a critical modifier: current smoker with COPD = additional tobacco rating + COPD rating applied multiplicatively.

#### 6.4.3 Obstructive Sleep Apnea (OSA)

| AHI (Apnea-Hypopnea Index) | Severity | Treatment Compliance | BMI | UW Rating |
|----------------------------|---------|---------------------|-----|-----------|
| 5–15 events/hour | Mild | Compliant CPAP or no CPAP needed | < 30 | Standard; Preferred possible |
| 15–30 events/hour | Moderate | Compliant CPAP (≥ 4 hrs/night, ≥ 70% nights) | < 35 | Standard to Table A |
| 15–30 events/hour | Moderate | Non-compliant or untreated | 35+ | Table B–D |
| > 30 events/hour | Severe | Compliant CPAP | < 40 | Table A–C |
| > 30 events/hour | Severe | Non-compliant or untreated | 40+ | Table D–F |
| OSA with significant cardiac arrhythmia or pulmonary hypertension | Any | Any | Any | Table D–H or Decline |

### 6.5 Neurological Conditions

#### 6.5.1 Epilepsy / Seizure Disorder

| Scenario | UW Rating |
|----------|-----------|
| Childhood epilepsy, seizure-free > 5 years, off medication | Standard; Preferred possible |
| Single seizure (provoked — alcohol, fever, medication), no recurrence > 2 years | Standard |
| Well-controlled on single AED, seizure-free > 2 years | Standard to Table A |
| Controlled on 2+ AEDs, seizure-free > 2 years | Table A–B |
| 1–2 breakthrough seizures/year despite treatment | Table B–D |
| Frequent seizures (> 2/year) | Table D–H |
| Status epilepticus (past 5 years) | Table D–F minimum |
| Epilepsy with known structural cause (tumor, AVM) | Rate based on underlying cause |

#### 6.5.2 Multiple Sclerosis (MS)

| Type | Disability (EDSS) | Time Since Diagnosis | UW Rating |
|------|-------------------|---------------------|-----------|
| **Relapsing-Remitting (RRMS)** — mild, on DMT | EDSS 0–2 | > 5 years | Table B–D |
| **RRMS** — moderate, on DMT | EDSS 2–4 | > 3 years | Table D–F |
| **RRMS** — progressive disability | EDSS 4–6 | Any | Table F–H |
| **Secondary Progressive (SPMS)** | EDSS 4+ | Any | Table F–H or Decline |
| **Primary Progressive (PPMS)** | Any | Any | Table F–H or Decline |
| MS with significant disability (wheelchair, assistance needed) | EDSS > 6 | Any | Decline |

#### 6.5.3 Stroke / TIA

| Event Type | Time Since | Residual Deficits | Risk Factors Controlled | UW Rating |
|-----------|-----------|-------------------|------------------------|-----------|
| **TIA** (no infarct on imaging) | > 2 years | None | Yes | Standard to Table A |
| **TIA** | 1–2 years | None | Yes | Table A–B |
| **TIA** | < 1 year | Any | Any | Postpone |
| **Ischemic stroke — minor** (no/minimal residual) | > 3 years | Minimal | Yes (non-smoker, controlled BP, on antiplatelet) | Table A–C |
| **Ischemic stroke — minor** | 1–3 years | Minimal | Yes | Table C–E |
| **Ischemic stroke — moderate** (functional deficit) | > 5 years | Moderate | Yes | Table C–F |
| **Ischemic stroke — severe** (major deficit) | Any | Severe | Any | Table F–H or Decline |
| **Hemorrhagic stroke** | > 5 years | Minimal/None | Yes | Table C–F |
| **Hemorrhagic stroke** | < 5 years | Any | Any | Table F–H or Decline |
| **Multiple strokes** | Any | Any | Any | Table F–H or Decline |

#### 6.5.4 Migraines

| Type | Frequency | UW Rating |
|------|----------|-----------|
| Migraine without aura, < 4/month, OTC treatment | Infrequent | Standard; Preferred possible |
| Migraine without aura, 4–8/month, prescription treatment | Moderate | Standard |
| Migraine with aura, < 4/month | Infrequent | Standard (slight concern due to stroke risk if on OCP) |
| Migraine with aura, frequent, requiring triptans | Frequent | Standard to Table A |
| Chronic migraine (> 15 headache days/month) | Chronic | Table A–B |
| Migraine with neurological complications (hemiplegic, basilar) | Complex | Table B–D; APS required |
| Migraine requiring opioid treatment | Any | Evaluate opioid use separately |

### 6.6 Mental Health Conditions

#### 6.6.1 Depression (Major Depressive Disorder)

| Severity | Treatment | Hospitalizations | Functional Status | UW Rating |
|----------|----------|-----------------|------------------|-----------|
| **Mild** — single episode, resolved | SSRI × 6–12 months, discontinued | None | Fully functional | Standard; Preferred possible |
| **Mild–Moderate** — recurrent, well-managed | Single SSRI/SNRI, stable | None | Fully functional, employed | Standard |
| **Moderate** — ongoing, multiple medication trials | 2+ medications | None | Functional with some limitations | Standard to Table A |
| **Moderate–Severe** — with anxiety comorbidity | Multiple medications | 1 hospitalization (> 2 years ago) | Functional | Table A–C |
| **Severe** — recent hospitalization | Multiple medications, ECT | Hospitalization < 2 years | Impaired function | Table C–F or Postpone |
| **With suicidal ideation** (current) | Any | Any | Any | Decline or Postpone |

#### 6.6.2 Anxiety Disorders (GAD, Panic, Social Anxiety, PTSD)

| Scenario | UW Rating |
|----------|-----------|
| GAD, well-controlled on single medication, no hospitalization | Standard |
| Panic disorder, controlled, on SSRI, no ER visits in 2+ years | Standard |
| PTSD, stable on treatment, functional | Standard to Table A |
| Anxiety with benzodiazepine dependence | Table A–C; evaluate substance risk |
| Anxiety with multiple ER visits, work disability | Table B–D |
| Severe anxiety with agoraphobia, non-functional | Table C–F |

#### 6.6.3 Bipolar Disorder

| Type | Control | Hospitalizations | Substance Abuse | UW Rating |
|------|---------|-----------------|----------------|-----------|
| **Bipolar II** — stable on lithium/lamotrigine, > 3 years | Well-controlled | None in 5+ years | None | Table A–C |
| **Bipolar I** — stable, on mood stabilizer | Controlled | 1 in past 5 years | None | Table B–D |
| **Bipolar I** — moderately controlled | Partially controlled | 2+ in past 5 years | None | Table D–F |
| Any type — with substance abuse comorbidity | Any | Any | Yes | Table F–H or Decline |
| Any type — with recent manic episode requiring hospitalization | Uncontrolled | Within past year | Any | Postpone or Decline |

#### 6.6.4 Suicide Attempt History

| Time Since Attempt | Number of Attempts | Current Status | UW Rating |
|-------------------|-------------------|---------------|-----------|
| > 10 years | Single | Stable, no suicidal ideation, in treatment | Table B–D |
| 5–10 years | Single | Stable, no suicidal ideation | Table C–F |
| 2–5 years | Single | Stable, in active treatment | Table F–H |
| < 2 years | Any | Any | Decline |
| Any time | Multiple (2+) | Any | Decline or Table H+ (if > 10 years remote) |
| Any time | Any | Current suicidal ideation | Decline |

### 6.7 Gastrointestinal Conditions

#### 6.7.1 Hepatitis B

| Status | Viral Load | Liver Function | UW Rating |
|--------|-----------|---------------|-----------|
| **HBsAg negative, HBsAb positive** (immune — vaccinated or resolved) | N/A | Normal | Standard; no impact |
| **Chronic HBV — inactive carrier** (HBsAg+, HBeAg-, normal ALT) | < 2,000 IU/mL | Normal LFTs | Standard to Table A |
| **Chronic HBV — active** (elevated ALT, HBeAg+) | > 20,000 IU/mL | Elevated ALT 1–2× ULN | Table B–D |
| **Chronic HBV on antiviral** (tenofovir/entecavir) | Suppressed | Normal | Table A–B |
| **Chronic HBV with cirrhosis** | Any | Abnormal | Table D–H or Decline |
| **HBV with HCC (liver cancer)** | Any | Any | Decline |

#### 6.7.2 Hepatitis C

| Status | Treatment | Liver Condition | UW Rating |
|--------|----------|----------------|-----------|
| **Treated — SVR achieved** (undetectable RNA > 12 weeks post-treatment) | DAA therapy (Harvoni, Epclusa, Mavyret) | No cirrhosis, normal LFTs | Standard to Table A (> 1 year post-SVR) |
| **Treated — SVR achieved** | DAA therapy | Cirrhosis (compensated) | Table B–D |
| **Untreated — stable** | None | Normal LFTs, no fibrosis | Table A–C |
| **Untreated — active disease** | None | Elevated ALT, fibrosis | Table D–H |
| **HCV with decompensated cirrhosis** | Any | Decompensated | Decline |
| **HCV with HCC** | Any | Any | Decline |

#### 6.7.3 Non-Alcoholic Fatty Liver Disease (NAFLD) / NASH

| Stage | Fibrosis Score (FIB-4 or NAFLD Fibrosis Score) | Liver Enzymes | UW Rating |
|-------|-------------------------------------------------|--------------|-----------|
| **Simple steatosis** (fatty liver only) | FIB-4 < 1.30 (low risk) | Normal or ALT < 1.5× ULN | Standard |
| **NASH without significant fibrosis** | FIB-4 1.30–2.67 (intermediate) | ALT 1–2× ULN | Standard to Table A |
| **NASH with fibrosis (F2–F3)** | FIB-4 > 2.67 (high risk) | ALT 2–3× ULN | Table B–D |
| **Cirrhosis (F4)** — compensated | N/A | Abnormal | Table D–F |
| **Cirrhosis** — decompensated | N/A | Abnormal | Decline |

#### 6.7.4 Inflammatory Bowel Disease (Crohn's Disease & Ulcerative Colitis)

| Condition | Severity | Treatment | UW Rating |
|----------|---------|----------|-----------|
| **Ulcerative Colitis — mild** | Minimal flares, 5-ASA only | Mesalamine | Standard to Table A |
| **Ulcerative Colitis — moderate** | Periodic flares, steroid-dependent | Immunomodulators (azathioprine) | Table A–C |
| **Ulcerative Colitis — severe** | Frequent flares, biologics needed | Infliximab, vedolizumab | Table B–D |
| **UC — post-colectomy** | Curative surgery | None | Standard to Table A |
| **Crohn's Disease — mild** | Limited disease, 5-ASA | Mesalamine, budesonide | Standard to Table A |
| **Crohn's Disease — moderate** | Moderate flares | Immunomodulators | Table A–C |
| **Crohn's Disease — severe** | Fistulizing, multiple surgeries, biologics | Anti-TNF (infliximab, adalimumab) | Table C–F |
| **IBD with dysplasia or colorectal cancer** | Any | Any | Rate cancer separately; additive |

#### 6.7.5 Cirrhosis

| Etiology | Child-Pugh Class | MELD Score | UW Rating |
|----------|-----------------|-----------|-----------|
| **Alcoholic — Class A (compensated)**, abstinent > 3 years | A (5–6 points) | < 10 | Table C–F |
| **Alcoholic — Class B** | B (7–9 points) | 10–19 | Table H or Decline |
| **Alcoholic — Class C** | C (10–15 points) | ≥ 20 | Decline |
| **Non-alcoholic — Class A** | A | < 10 | Table B–D |
| **Any etiology — with varices or ascites** | B or C | Any | Decline |
| **Post-transplant (liver)** | N/A | N/A | Table D–H (minimum 1 year post-transplant; immunosuppression risk) |

### 6.8 Kidney Conditions

#### 6.8.1 Chronic Kidney Disease (CKD) Staging

| CKD Stage | eGFR (mL/min/1.73m²) | Description | UW Rating |
|-----------|----------------------|------------|-----------|
| **Stage 1** | ≥ 90 | Normal GFR with evidence of kidney damage (proteinuria) | Standard to Table A |
| **Stage 2** | 60–89 | Mildly decreased GFR | Standard to Table A (if no proteinuria) |
| **Stage 3a** | 45–59 | Mild-moderate decrease | Table A–C |
| **Stage 3b** | 30–44 | Moderate-severe decrease | Table C–F |
| **Stage 4** | 15–29 | Severely decreased | Table F–H or Decline |
| **Stage 5** | < 15 or dialysis | Kidney failure / ESRD | Decline |

**CKD Modifiers:**

| Modifier | Impact |
|---------|--------|
| Stable eGFR trend (> 2 years) | Favorable; may reduce rating by 1 table |
| Declining eGFR (> 5 mL/min/year loss) | Unfavorable; increase rating by 1–2 tables |
| Proteinuria (UACR > 300 mg/g) | Add +50 to +100 debits |
| Diabetes as underlying cause | Multiplicative risk with DM debits |
| Hypertension as cause (without DM) | Less severe than diabetic nephropathy |

#### 6.8.2 Kidney Stones (Nephrolithiasis)

| Scenario | UW Rating |
|----------|-----------|
| Single episode, no recurrence, no metabolic abnormality | Standard; Preferred possible |
| Recurrent stones (2–3 episodes) with normal kidney function | Standard |
| Recurrent stones with mild CKD or hydronephrosis | Table A–B |
| Staghorn calculus or chronic obstruction | Table B–D |
| Stones with CKD Stage 3+ | Rate per CKD staging |

#### 6.8.3 Proteinuria

| Level | Quantification | UW Action |
|-------|---------------|-----------|
| Trace on dipstick | < 150 mg/24hr | Repeat; if persistent → investigate |
| 1+ on dipstick | 150–300 mg/24hr | Order UACR or 24-hr protein; investigate cause |
| 2+ on dipstick | 300–1000 mg/24hr | APS; evaluate for kidney disease; Table A–C |
| 3–4+ on dipstick | > 1000 mg/24hr | APS; likely nephrotic syndrome; Table D–H or Decline |
| Microalbuminuria (UACR 30–300 mg/g) | Early diabetic nephropathy | Debit in context of DM rating |
| Macroalbuminuria (UACR > 300 mg/g) | Advanced diabetic nephropathy | Significant additional debit |

### 6.9 Endocrine Conditions

#### 6.9.1 Thyroid Disorders

| Condition | Treatment/Status | UW Rating |
|----------|-----------------|-----------|
| **Hypothyroidism** — on levothyroxine, TSH normal | Controlled | Standard; Preferred possible |
| **Hypothyroidism** — TSH mildly elevated (5–10 mIU/L) | Sub-optimal | Standard |
| **Hypothyroidism** — TSH significantly elevated (> 10) | Poorly controlled | Table A; investigate cause |
| **Hyperthyroidism (Graves')** — treated (RAI/surgery), stable | Resolved/controlled | Standard to Table A |
| **Hyperthyroidism** — on methimazole, not yet controlled | Active | Postpone until stable |
| **Thyroid nodule** — benign FNA | Benign | Standard |
| **Thyroid nodule** — indeterminate FNA | Uncertain | Postpone until resolved |
| **Hashimoto's thyroiditis** — on replacement, stable | Controlled | Standard |

#### 6.9.2 Adrenal Disorders

| Condition | UW Rating |
|----------|-----------|
| **Adrenal adenoma** — non-functioning, incidental finding | Standard (with imaging stability) |
| **Cushing's syndrome** — treated/cured | Table A–C (> 2 years post-cure) |
| **Cushing's syndrome** — active | Postpone or Decline |
| **Addison's disease** — stable on replacement therapy | Standard to Table A |
| **Pheochromocytoma** — resected, normetanephrines normal | Table A–B (> 2 years post-surgery) |
| **Pheochromocytoma** — active/unresected | Decline |

### 6.10 Musculoskeletal Conditions

#### 6.10.1 Back Surgery and Chronic Back Pain

| Scenario | UW Rating |
|----------|-----------|
| Single discectomy/laminectomy, full recovery, no ongoing pain meds | Standard |
| Spinal fusion (1–2 levels), good outcome, minimal pain meds | Standard to Table A |
| Spinal fusion (multiple levels), ongoing mild pain, NSAIDs | Table A–B |
| Failed back surgery syndrome, chronic opioid use | Table B–D (plus opioid assessment) |
| Chronic back pain with disability claim | Table B–D minimum |
| Back pain requiring ongoing opioid management (> 6 months) | Table C–F; evaluate opioid dependence risk |

#### 6.10.2 Chronic Pain and Disability

| Factor | UW Consideration |
|--------|-----------------|
| Pain source identified and treated | More favorable |
| Pain source unidentified (fibromyalgia, chronic pain syndrome) | Less favorable; evaluate for depression, substance risk |
| On disability (short-term) | Evaluate return-to-work prognosis |
| On disability (long-term/permanent) | Table B–D minimum; evaluate underlying cause |
| Chronic opioid use for pain | Separate opioid risk assessment; Table A–D additional |
| Pain managed with non-opioid strategies | More favorable |

### 6.11 Substance Use Disorders

#### 6.11.1 Alcohol Abuse / Alcohol Use Disorder

| Status | Time Since Last Drink / Recovery | UW Rating |
|--------|--------------------------------|-----------|
| Social drinker (< 14 drinks/week M; < 7 F) | N/A | No impact |
| Heavy drinker (no diagnosis), elevated CDT/GGT | Current | Table B–D; evaluate for alcoholism |
| AUD — in recovery, AA/treatment | > 5 years sober | Standard to Table A (some carriers) |
| AUD — in recovery | 3–5 years sober | Table A–C |
| AUD — in recovery | 1–3 years sober | Table C–F |
| AUD — in recovery | < 1 year sober | Decline or Postpone |
| AUD with liver disease (alcoholic hepatitis/cirrhosis) | Any | Rate liver disease separately; additive |
| AUD with multiple relapses | Any | Table D–H or Decline |

#### 6.11.2 Drug Use

| Substance | Status | UW Rating |
|----------|--------|-----------|
| **Marijuana** — occasional (1–2/week), no other drugs, no DUI | Current | Standard to Table A (carrier-dependent) |
| **Marijuana** — daily use | Current | Table A–C |
| **Cocaine** — past use, > 5 years ago, no other drugs | Recovery | Table A–C (carrier-dependent) |
| **Cocaine** — past use, 2–5 years ago | Recovery | Table C–F |
| **Cocaine** — current or < 2 years | Active/Recent | Decline |
| **Opioid** — prescribed, compliant, no abuse | Current | Rate based on underlying condition + opioid risk |
| **Opioid** — abuse/addiction, in MAT (methadone/buprenorphine) | Recovery, > 3 years | Table C–F |
| **Opioid** — abuse/addiction, < 2 years recovery | Recent | Decline |
| **IV drug use** (any substance) — past | > 10 years ago | Table D–H; HIV/HCV testing required |
| **IV drug use** — recent (< 5 years) | Recent | Decline |

#### 6.11.3 DUI/DWI Correlation

| DUI History | Time Since | Other Factors | UW Rating Impact |
|------------|-----------|--------------|-----------------|
| Single DUI, BAC < 0.15 | > 5 years | No alcohol diagnosis, no other violations | Minimal; Standard possible |
| Single DUI, BAC < 0.15 | 2–5 years | Clean record since | Table A–B or flat extra |
| Single DUI, BAC ≥ 0.15 | Any | Elevated CDT/GGT | Table B–D; alcohol evaluation |
| Two DUIs | Any combination | Any | Table C–F; strong alcohol abuse indicator |
| Three or more DUIs | Any | Any | Decline; presumed alcohol use disorder |
| DUI + positive CDT/GGT on lab panel | Any | Any | Table D+ or Decline |

---

## 7. Prescription Drug Interpretation

### 7.1 Prescription Database Sources

| Vendor | Data Source | Coverage | Integration |
|--------|-----------|---------|-------------|
| **Milliman IntelliScript** | Pharmacy benefit managers (PBMs), retail pharmacies | ~80% of US prescriptions | Real-time API |
| **ExamOne ScriptCheck** | PBMs, pharmacies | ~75% of US prescriptions | Real-time API |
| **MIB** | Prior insurance applications | Coded conditions (not Rx specifically) | Real-time API |

### 7.2 Medication-to-Condition Mapping

Prescription drug data reveals **undisclosed conditions**. If an applicant denies a condition but takes a medication specific to that condition, underwriting flags a discrepancy requiring investigation.

#### 7.2.1 Cardiovascular Medications

| Medication Class | Common Examples | Indicated Condition | UW Interpretation |
|-----------------|----------------|-------------------|-------------------|
| **Statins** | Atorvastatin (Lipitor), Rosuvastatin (Crestor), Simvastatin (Zocor) | Hyperlipidemia, CAD risk reduction | If disclosed: Standard–Table A. If undisclosed: order APS for lipid history |
| **ACE Inhibitors** | Lisinopril, Enalapril, Ramipril | Hypertension, heart failure, diabetic nephropathy | Common; evaluate for HTN. If used for HF: higher rating |
| **ARBs** | Losartan, Valsartan, Olmesartan | Same as ACE inhibitors | Similar UW treatment as ACE inhibitors |
| **Beta-Blockers** | Metoprolol, Atenolol, Propranolol, Carvedilol | HTN, post-MI, heart failure, arrhythmia, anxiety | Context-dependent: post-MI use → cardiology evaluation; for anxiety → mental health evaluation |
| **Calcium Channel Blockers** | Amlodipine, Diltiazem, Verapamil | HTN, angina, arrhythmia | Standard HTN treatment; evaluate for underlying condition |
| **Anticoagulants** | Warfarin (Coumadin), Apixaban (Eliquis), Rivaroxaban (Xarelto), Dabigatran (Pradaxa) | AFib, DVT/PE, mechanical valve, hypercoagulable state | Red flag: indicates significant cardiac or thrombotic condition. Always APS |
| **Antiplatelet agents** | Clopidogrel (Plavix), Ticagrelor (Brilinta), Prasugrel (Effient) | Post-stent, post-MI, CAD, stroke prevention | Indicates coronary or cerebrovascular disease; APS required |
| **Digoxin** | Digoxin (Lanoxin) | Heart failure, AFib rate control | Indicates advanced cardiac condition; APS required |
| **Nitrates** | Nitroglycerin, Isosorbide mononitrate | Angina pectoris | Indicates active angina; APS required; minimum Table B |

#### 7.2.2 Diabetes Medications

| Medication Class | Common Examples | UW Interpretation |
|-----------------|----------------|-------------------|
| **Metformin** | Metformin (Glucophage) | Type 2 DM (first-line) or pre-diabetes/PCOS. If for DM: Standard–Table D depending on HbA1c. If for PCOS/pre-DM: may be Standard |
| **Sulfonylureas** | Glipizide, Glyburide, Glimepiride | Type 2 DM (second-line); indicates need for more control than metformin alone |
| **SGLT2 Inhibitors** | Empagliflozin (Jardiance), Dapagliflozin (Farxiga), Canagliflozin (Invokana) | Type 2 DM; also used for heart failure. Cardiovascular benefit → may be favorable indicator |
| **GLP-1 Receptor Agonists** | Semaglutide (Ozempic/Wegovy), Liraglutide (Victoza/Saxenda), Dulaglutide (Trulicity) | Type 2 DM or weight management. If for weight only: differentiate from DM use |
| **DPP-4 Inhibitors** | Sitagliptin (Januvia), Linagliptin (Tradjenta) | Type 2 DM |
| **Insulin — basal** | Glargine (Lantus), Detemir (Levemir), Degludec (Tresiba) | Type 1 or advanced Type 2 DM. Insulin use = higher rating than oral meds alone |
| **Insulin — bolus/rapid** | Lispro (Humalog), Aspart (Novolog) | Active insulin management; Type 1 or poorly controlled Type 2 |
| **Insulin — mixed** | 70/30, 75/25 | Type 2 DM; simplified regimen |
| **Thiazolidinediones** | Pioglitazone (Actos) | Type 2 DM; historical concern for cardiac risk (rosiglitazone withdrawn) |

#### 7.2.3 Mental Health Medications

| Medication Class | Common Examples | UW Interpretation |
|-----------------|----------------|-------------------|
| **SSRIs** | Fluoxetine (Prozac), Sertraline (Zoloft), Escitalopram (Lexapro), Citalopram (Celexa) | Depression, anxiety, OCD, PTSD. Very common; single SSRI for mild/moderate depression = Standard possible |
| **SNRIs** | Venlafaxine (Effexor), Duloxetine (Cymbalta), Desvenlafaxine (Pristiq) | Depression, anxiety, neuropathic pain, fibromyalgia. Evaluate indication: pain vs. psych |
| **Benzodiazepines** | Alprazolam (Xanax), Lorazepam (Ativan), Clonazepam (Klonopin), Diazepam (Valium) | Anxiety, panic disorder, insomnia, seizures. Red flag for: long-term use, escalating doses, multiple concurrent benzos. Evaluate dependence risk |
| **Mood Stabilizers** | Lithium, Valproate (Depakote), Lamotrigine (Lamictal) | Bipolar disorder, mood instability. Lithium = classic bipolar indicator; triggers bipolar UW assessment |
| **Antipsychotics** (atypical) | Quetiapine (Seroquel), Aripiprazole (Abilify), Olanzapine (Zyprexa), Risperidone (Risperdal) | Schizophrenia, bipolar, treatment-resistant depression, PTSD. Low-dose quetiapine for sleep: differentiate from psychosis |
| **Stimulants** | Methylphenidate (Ritalin/Concerta), Amphetamine salts (Adderall) | ADHD. Usually Standard if no substance abuse history; evaluate for comorbid conditions |
| **Bupropion** | Bupropion (Wellbutrin, Zyban) | Depression, smoking cessation. If for smoking cessation: may indicate recent quit — verify tobacco status |

#### 7.2.4 Opioid and Pain Medications

| Medication | Schedule | Risk Level | UW Action |
|-----------|---------|-----------|-----------|
| **Hydrocodone/APAP** (Vicodin, Norco) | Schedule II | Moderate | Short-term post-surgery: no impact. Long-term (> 3 months): evaluate for chronic pain, dependence |
| **Oxycodone** (OxyContin, Percocet) | Schedule II | High | Red flag for long-term use; APS; evaluate addiction risk |
| **Morphine** | Schedule II | High | Chronic use indicates significant pain condition; APS required |
| **Fentanyl patches** | Schedule II | Very High | Severe chronic pain; APS; Table A+ for underlying condition + opioid risk |
| **Tramadol** | Schedule IV | Moderate | Less concerning than Schedule II opioids but still evaluate for chronic pain |
| **Buprenorphine** (Suboxone, Subutex) | Schedule III | Special | Medication-assisted treatment for opioid use disorder; see substance use section |
| **Methadone** (for pain) | Schedule II | High | Differentiate pain use from MAT for opioid dependence |
| **Methadone** (for opioid dependence) | Schedule II | Special | MAT program; see substance use section |
| **Gabapentin/Pregabalin** | Pregabalin: Schedule V | Low–Moderate | Neuropathic pain, seizures, anxiety; common and less concerning alone |

#### 7.2.5 Cancer/Oncology Medications

| Medication Type | Examples | UW Action |
|----------------|---------|-----------|
| **Chemotherapy agents** | Cyclophosphamide, Doxorubicin, Paclitaxel, Carboplatin | Active cancer treatment; Postpone or Decline during treatment |
| **Hormonal therapy** | Tamoxifen, Letrozole, Anastrozole (breast cancer); Leuprolide, Enzalutamide (prostate) | Indicates cancer history; rate per cancer type/stage/duration |
| **Targeted therapy** | Imatinib (Gleevec) for CML, Trastuzumab (Herceptin) for HER2+ breast cancer | Indicates specific cancer type; rate accordingly |
| **Immunotherapy** | Pembrolizumab (Keytruda), Nivolumab (Opdivo), Ipilimumab (Yervoy) | Indicates advanced cancer (often Stage III/IV); typically Decline during active treatment |

#### 7.2.6 Biologic/Immunosuppressive Medications

| Medication | Condition | UW Consideration |
|-----------|----------|-----------------|
| **Adalimumab** (Humira) | RA, Crohn's, UC, psoriasis, AS | Rate based on underlying condition; infection risk |
| **Infliximab** (Remicade) | RA, Crohn's, UC, AS | Same as adalimumab |
| **Etanercept** (Enbrel) | RA, psoriasis, AS | Slightly lower infection risk than anti-TNF antibodies |
| **Methotrexate** | RA, psoriasis, cancer | Low-dose for RA/psoriasis: Standard–Table B. Cancer dose: per cancer assessment |
| **Mycophenolate** (CellCept) | Transplant anti-rejection, lupus | Indicates transplant or severe autoimmune; significant UW impact |
| **Tacrolimus/Cyclosporine** | Transplant anti-rejection | Organ transplant = Table D–H minimum |

### 7.3 Medication Interaction Red Flags

| Pattern | Concern | UW Action |
|---------|---------|-----------|
| Multiple opioids concurrently | Polypharmacy / addiction risk | APS; substance evaluation |
| Benzodiazepine + opioid (concurrent) | High overdose/mortality risk | APS; flag for review; Table rating minimum |
| 3+ psychiatric medications | Severe/complex mental health condition | APS; detailed psychiatric evaluation |
| Warfarin + amiodarone | AFib with complex cardiac condition | APS; cardiology records |
| Insulin + ACE inhibitor + statin + antiplatelet | Metabolic syndrome / advanced DM with CVD | Comprehensive DM + CVD assessment |
| Frequent Rx changes (> 4 changes in 12 months) | Treatment instability or non-compliance | APS to evaluate |
| Prescriptions from 3+ different providers for controlled substances | Doctor shopping / substance abuse | Significant red flag; APS; potential Decline |

---

## 8. Family History Assessment

### 8.1 Why Family History Matters

Family history of premature death from certain conditions is an independent predictor of mortality. It reflects genetic predisposition and shared environmental risk factors that may not yet manifest as a diagnosed condition in the applicant.

### 8.2 Conditions That Matter

| Condition | Age-of-Onset Threshold | Relationship Considered | Impact |
|----------|----------------------|------------------------|--------|
| **Coronary artery disease / Heart attack** | Father/brother < 55; Mother/sister < 65 | Parents, siblings | Moderate debit; disqualifies Preferred Plus (most carriers) |
| **Stroke** | Any first-degree relative < 60 | Parents, siblings | Moderate debit |
| **Diabetes (Type 2)** | Any first-degree relative < 60 | Parents, siblings | Minor debit; watch applicant's glucose/HbA1c |
| **Cancer — breast** | First-degree relative < 50; or BRCA+ | Mother, sister, daughter | Moderate debit; enhanced screening recommended |
| **Cancer — colon** | First-degree relative < 50 | Parents, siblings | Moderate debit; screening compliance important |
| **Cancer — ovarian** | Any first-degree relative | Mother, sister | Moderate debit; BRCA evaluation |
| **Cancer — prostate** | First-degree relative < 60 | Father, brother | Minor debit |
| **Familial hypercholesterolemia** | Any first-degree relative with TC > 300 or known FH | Parents, siblings | Significant debit; evaluate applicant's lipids |
| **Cardiomyopathy (hypertrophic)** | Any first-degree relative | Parents, siblings | Moderate debit; may require echo |
| **Huntington's disease** | Any affected relative | Parents (autosomal dominant) | Significant concern; genetic testing implications |
| **Polycystic kidney disease** | Any affected relative | Parents (autosomal dominant) | Evaluate applicant's renal function |
| **Sudden cardiac death** | First-degree relative < 50 | Parents, siblings | Significant debit; may require cardiac workup |
| **Suicide** | First-degree relative | Parents, siblings | Considered in mental health context |
| **Substance abuse** | Multiple first-degree relatives | Parents, siblings | Context for applicant's substance history |

### 8.3 Impact by Number of Affected Relatives

| Condition | One First-Degree Relative | Two+ First-Degree Relatives |
|----------|--------------------------|---------------------------|
| **Heart disease (premature)** | Preferred Plus → Preferred (drop one class) | Preferred Plus → Standard (drop two classes); additional debit |
| **Diabetes** | Minor debit (+10–15) | Moderate debit (+25–35) |
| **Breast cancer** | Minor–Moderate debit (+15–25) | Moderate–Significant debit (+25–50); BRCA evaluation suggested |
| **Colon cancer** | Minor debit (+10–20) | Moderate debit (+20–40) |
| **Sudden cardiac death** | Moderate debit (+25–50); may require cardiac screening | Significant debit (+50–75); cardiac screening mandatory |

### 8.4 Family History UW Rules — Decision Logic

```
RULE: Family_History_CardioVascular
IF:
  - parent_or_sibling died of heart_disease OR heart_attack
  - AND age_at_death < 60
THEN:
  - IF one_relative_affected:
      max_class = "Preferred"
      add_debit(25)
  - IF two_or_more_relatives_affected:
      max_class = "Standard"
      add_debit(50)

RULE: Family_History_Cancer
IF:
  - parent_or_sibling diagnosed with cancer
  - AND type IN [breast, colon, ovarian]
  - AND age_at_diagnosis < 50
THEN:
  - add_debit(20)
  - IF two_or_more_relatives_affected:
      add_debit(40)
      recommend_genetic_screening = true
```

### 8.5 Important Caveats

- **Only first-degree relatives** count: parents and siblings. Grandparents, aunts/uncles, and cousins are generally excluded (some carriers consider grandparents for specific conditions).
- **Cause of death must be documented** — "died of heart disease at 50" vs. "died at 50, cause unknown" are different.
- **Adopted applicants** — family history is unavailable; no debit should be applied, but preferred classes may have different criteria.
- **Age-of-onset is critical** — a parent dying of heart disease at age 80 has negligible UW impact; at age 45 it is significant.

---

## 9. Build Charts — BMI, Height & Weight

### 9.1 The Role of Build in Underwriting

Body mass index (BMI) is one of the strongest predictors of mortality. The relationship follows a **J-curve**: both very low and very high BMI carry excess mortality, with the lowest risk in the 18.5–25 range.

### 9.2 BMI Calculation

```
BMI = weight (kg) / [height (m)]²
  OR
BMI = weight (lb) × 703 / [height (in)]²
```

### 9.3 Standard BMI Classification

| BMI Range | Classification | Relative Mortality | UW Class Ceiling |
|-----------|---------------|-------------------|-----------------|
| < 16.0 | Severe underweight | 200–300% | Decline or Table D+ |
| 16.0–17.0 | Moderate underweight | 130–160% | Table A–C |
| 17.0–18.5 | Mild underweight | 110–130% | Standard |
| 18.5–25.0 | Normal weight | 100% (reference) | Preferred Plus eligible |
| 25.0–27.0 | Overweight (mild) | 100–105% | Preferred Plus eligible (some carriers) |
| 27.0–30.0 | Overweight | 105–115% | Preferred eligible |
| 30.0–32.0 | Obese Class I (mild) | 115–130% | Standard Plus to Standard |
| 32.0–35.0 | Obese Class I–II | 130–150% | Standard to Table A |
| 35.0–38.0 | Obese Class II | 150–175% | Table A–C |
| 38.0–40.0 | Obese Class II–III | 175–200% | Table C–D |
| 40.0–45.0 | Obese Class III (morbid) | 200–250% | Table D–H |
| > 45.0 | Super morbid obesity | 250–400% | Table H or Decline |

### 9.4 Build Tables by Risk Class (Typical Carrier)

#### Male Build Table — Maximum Weight (lbs) by Height

| Height | Preferred Plus | Preferred | Standard Plus | Standard | Table A | Table B |
|--------|---------------|----------|--------------|---------|---------|---------|
| 5'4" | 170 | 185 | 195 | 215 | 235 | 255 |
| 5'5" | 174 | 190 | 200 | 221 | 242 | 262 |
| 5'6" | 179 | 195 | 206 | 228 | 249 | 269 |
| 5'7" | 184 | 200 | 212 | 234 | 256 | 277 |
| 5'8" | 189 | 206 | 218 | 241 | 263 | 285 |
| 5'9" | 194 | 212 | 224 | 248 | 271 | 293 |
| 5'10" | 199 | 217 | 230 | 254 | 278 | 301 |
| 5'11" | 205 | 223 | 236 | 261 | 286 | 309 |
| 6'0" | 210 | 229 | 243 | 268 | 294 | 318 |
| 6'1" | 216 | 235 | 249 | 276 | 302 | 326 |
| 6'2" | 221 | 241 | 256 | 283 | 310 | 335 |
| 6'3" | 227 | 248 | 262 | 291 | 318 | 344 |
| 6'4" | 233 | 254 | 269 | 298 | 327 | 353 |

#### Female Build Table — Maximum Weight (lbs) by Height

| Height | Preferred Plus | Preferred | Standard Plus | Standard | Table A | Table B |
|--------|---------------|----------|--------------|---------|---------|---------|
| 5'0" | 140 | 155 | 165 | 185 | 205 | 225 |
| 5'1" | 144 | 159 | 170 | 190 | 210 | 231 |
| 5'2" | 148 | 164 | 175 | 195 | 216 | 237 |
| 5'3" | 152 | 168 | 179 | 200 | 222 | 243 |
| 5'4" | 156 | 173 | 184 | 206 | 228 | 250 |
| 5'5" | 161 | 178 | 189 | 211 | 234 | 256 |
| 5'6" | 165 | 183 | 195 | 217 | 240 | 263 |
| 5'7" | 170 | 188 | 200 | 223 | 247 | 270 |
| 5'8" | 174 | 193 | 205 | 229 | 253 | 277 |
| 5'9" | 179 | 198 | 211 | 235 | 260 | 284 |
| 5'10" | 184 | 204 | 217 | 241 | 267 | 292 |
| 5'11" | 189 | 209 | 222 | 248 | 274 | 299 |
| 6'0" | 194 | 215 | 228 | 254 | 281 | 307 |

### 9.5 The J-Curve of Mortality

```
Mortality
Ratio (%)
    │
300 │●                                                    ●
    │  ●                                               ●
250 │    ●                                          ●
    │      ●                                     ●
200 │        ●                                ●
    │          ●                           ●
150 │            ●                      ●
    │              ●                 ●
120 │                ●            ●
    │                  ●       ●
100 │─ ─ ─ ─ ─ ─ ─ ─ ─ ●──●── ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
    │                      ●
 90 │                    ●    ●
    │
    └──────┬────┬────┬────┬────┬────┬────┬────┬────┬──
          16   18   20   22   25   28   30   35   40  45
                              BMI
    ◄─ Underweight ─►◄─ Normal ─►◄─ Overweight ──────►
```

### 9.6 Age-Adjusted Build Allowances

Many carriers apply **age-adjusted build charts**: slightly more lenient BMI limits for older applicants (because the mortality impact of moderate overweight diminishes with age).

| Age Band | BMI Ceiling for Preferred Plus | BMI Ceiling for Standard |
|----------|-------------------------------|-------------------------|
| 18–30 | 26.0 | 32.0 |
| 31–40 | 27.0 | 33.0 |
| 41–50 | 27.5 | 34.0 |
| 51–60 | 28.0 | 35.0 |
| 61–70 | 29.0 | 36.0 |
| 71+ | 30.0 | 37.0 |

### 9.7 Waist-to-Height Ratio (Emerging Metric)

Some carriers are supplementing BMI with waist-to-height ratio, which better captures visceral adiposity:

| Waist/Height Ratio | Risk Category | UW Impact |
|-------------------|--------------|-----------|
| < 0.40 | Underweight concern | Evaluate for eating disorder or illness |
| 0.40–0.50 | Healthy | No impact |
| 0.50–0.55 | Increased risk | Debit equivalent to BMI 28–30 |
| 0.55–0.60 | High risk | Debit equivalent to BMI 30–35 |
| > 0.60 | Very high risk | Debit equivalent to BMI 35+ |

---

## 10. Tobacco & Nicotine Assessment

### 10.1 Financial Impact of Tobacco Use

Tobacco use is the **single largest modifiable risk factor** in life insurance underwriting. Smoker rates are typically **2–3× higher** than non-smoker rates.

| Category | 20-Year Term, $500K, Male Age 35 (Approximate Annual Premium) |
|----------|-------------------------------------------------------------|
| Preferred Plus Non-Tobacco | $300–$400 |
| Preferred Non-Tobacco | $375–$475 |
| Standard Non-Tobacco | $475–$600 |
| Preferred Tobacco | $900–$1,200 |
| Standard Tobacco | $1,200–$1,600 |
| Substandard Tobacco | $2,000+ |

### 10.2 Definition of Tobacco Use

| Carrier Definition Category | Includes | Excludes |
|---------------------------|---------|---------|
| **Strict non-tobacco** | Zero use of any nicotine product in lookback period | Nothing excluded — any use = tobacco rates |
| **Cigarette-only** | Cigarette smoking | May allow occasional cigar (1–2/month), pipe, or smokeless tobacco at non-tobacco rates |
| **Nicotine-inclusive** | All nicotine products including NRT | Only those completely nicotine-free qualify |

### 10.3 Lookback Periods

| Product | Typical Lookback for Non-Tobacco Rates | Some Carriers |
|---------|---------------------------------------|--------------|
| Cigarettes | 3–5 years since last use | 12 months (aggressive) to 5 years (conservative) |
| Cigars (occasional, ≤ 12/year) | 12 months (some carriers allow cigar at non-tobacco) | Non-tobacco if ≤ 1/month and negative cotinine |
| Smokeless tobacco (chew, snus) | 2–5 years | 12 months to 5 years |
| Pipe tobacco | 2–5 years | Similar to cigarettes |
| E-cigarettes / Vaping (with nicotine) | 2–5 years (evolving) | Some carriers treat as tobacco; some as non-tobacco if no cigarettes |
| Nicotine patches/gum (NRT) | Usually same as cigarette lookback | Some carriers exclude NRT from tobacco definition if used for cessation |
| Marijuana (smoked) | 12 months to never (carrier-dependent) | Some treat as tobacco; some separately; some ignore if occasional |

### 10.4 Cotinine Testing Thresholds

| Test | Non-User | NRT / Secondhand Possible | Tobacco User |
|------|---------|--------------------------|-------------|
| Serum cotinine | < 5 ng/mL | 5–15 ng/mL | > 15 ng/mL |
| Urine cotinine (immunoassay) | < 100 ng/mL | 100–200 ng/mL | > 200 ng/mL |
| Urine cotinine (GC-MS confirmation) | < 50 ng/mL | 50–100 ng/mL | > 100 ng/mL |
| Oral fluid cotinine | < 10 ng/mL | 10–30 ng/mL | > 30 ng/mL |

### 10.5 E-Cigarettes and Vaping

The underwriting industry is still evolving on e-cigarettes. Current approaches:

| Carrier Approach | Treatment | Rationale |
|-----------------|----------|-----------|
| **Conservative** | Tobacco rates for any vaping/nicotine product | Unknown long-term health effects; nicotine = tobacco |
| **Moderate** | Non-tobacco rates if vaping only (no cigarettes in 3+ years), negative cotinine exception | Vaping likely less harmful than combustion; retain applicants |
| **Progressive** | Non-tobacco rates for vaping; separate vaping class | Harm reduction; competitive positioning |
| **Common current practice (2024–2026)** | Most carriers assign tobacco rates for active vaping with nicotine | Industry consensus pending more mortality data |

### 10.6 Marijuana Assessment

| Usage Pattern | Frequency | Carrier Treatment |
|--------------|----------|------------------|
| No use | Never or > 5 years ago | No impact |
| Occasional use (edibles/non-smoked) | ≤ 2×/month | Standard non-tobacco (progressive carriers); non-tobacco if cotinine negative |
| Regular use (edibles) | 3–4×/week | Standard (some carriers); Table A (others) |
| Occasional smoking | ≤ 2×/month | Non-tobacco (some carriers if cotinine < 10); tobacco rates (conservative carriers) |
| Regular marijuana smoking | Daily or near-daily | Tobacco rates at most carriers; Table A–B |
| Marijuana with other illicit drug use | Any | Rate per drug use guidelines; significant additional debit |
| Medical marijuana (card holder) | Any frequency | Evaluate underlying condition; often Standard if condition is mild and no smoking |

### 10.7 Prescription Nicotine Cessation Aids

| Product | Active Ingredient | Cotinine Impact | UW Treatment |
|---------|------------------|----------------|-------------|
| Nicotine patch (Nicoderm CQ) | Nicotine | Will produce positive cotinine | Most carriers: counts as tobacco use during NRT |
| Nicotine gum (Nicorette) | Nicotine | Will produce positive cotinine | Same as patch |
| Nicotine lozenge | Nicotine | Will produce positive cotinine | Same as patch |
| Nicotine inhaler (Nicotrol) | Nicotine | Will produce positive cotinine | Same as patch |
| Varenicline (Chantix) | Non-nicotine | No cotinine impact | Does not trigger tobacco rates; indicates recent smoking history |
| Bupropion (Zyban/Wellbutrin) | Non-nicotine | No cotinine impact | Does not trigger tobacco rates; also prescribed for depression |

---

## 11. Implementing Medical Rules in Code

### 11.1 Decision Table Architecture

Medical underwriting rules are best implemented as **decision tables** within a rules engine. Each rule maps a set of input conditions to an output (risk class ceiling, debit/credit, referral action).

**Core Data Model:**

```
MedicalAssessment {
  applicant_id: UUID
  age: Integer
  gender: Enum(M, F)
  conditions: List<MedicalCondition>
  medications: List<Medication>
  lab_results: Map<AnalyteCode, LabResult>
  exam_data: ExamData
  family_history: List<FamilyHistoryEntry>
  tobacco_status: TobaccoAssessment
  build: BuildData
}

MedicalCondition {
  icd10_code: String
  condition_name: String
  date_diagnosed: Date
  date_resolved: Date?
  severity: Enum(MILD, MODERATE, SEVERE)
  treatment_status: Enum(ACTIVE, RESOLVED, MANAGED)
  details: Map<String, Any>
}

LabResult {
  loinc_code: String
  value: Decimal
  unit: String
  reference_range: Range
  collection_date: Date
  fasting: Boolean?
}

RiskAssessment {
  base_class: RiskClass
  debits: List<Debit>
  credits: List<Credit>
  max_class_ceiling: RiskClass
  final_class: RiskClass
  flat_extras: List<FlatExtra>
  referral_reasons: List<String>
  decision: Enum(APPROVE, RATE, DECLINE, POSTPONE, REFER)
}
```

### 11.2 Rule Priority and Conflict Resolution

When multiple rules fire for the same applicant, the system must resolve conflicts:

| Strategy | Description | Use Case |
|----------|-----------|---------|
| **Most restrictive wins** | If Rule A says Standard and Rule B says Table C, apply Table C | Default for class ceilings — the worst impairment determines the floor |
| **Additive debits** | Sum debits from independent conditions | Unrelated conditions (e.g., hypertension + asthma) |
| **Multiplicative debits** | Multiply mortality ratios for synergistic conditions | Related conditions (e.g., diabetes + CKD) |
| **Priority override** | Higher-priority rule overrides lower-priority | Decline rules override table ratings |
| **Temporal precedence** | Most recent data takes priority | Multiple lab values for same analyte |

**Priority Ordering:**

```
Priority 1 (Highest): DECLINE rules
  - Active cancer under treatment
  - eGFR < 15 (ESRD)
  - EF < 25%
  - Current suicidal ideation
  - Positive cocaine on drug screen

Priority 2: POSTPONE rules
  - MI within 6 months
  - Cancer treatment completed < 6 months
  - Awaiting diagnostic workup

Priority 3: TABLE RATING rules
  - Rated conditions with specific table assignments
  - Applied after debits/credits calculation

Priority 4: CLASS CEILING rules
  - Maximum eligible class per condition
  - Build chart maximums
  - Tobacco status ceiling
  - Family history ceiling

Priority 5 (Lowest): CREDIT rules
  - Well-controlled conditions
  - Excellent compliance
  - Favorable lifestyle factors
```

### 11.3 Pseudocode — Blood Pressure Assessment

```
function assessBloodPressure(exam: ExamData, conditions: List<MedicalCondition>):

    readings = exam.blood_pressure_readings  // List of (systolic, diastolic)

    // Step 1: Average readings (discard first if white-coat effect)
    if len(readings) >= 3 AND readings[0].systolic - readings[1].systolic > 20:
        readings = readings[1:]  // Discard first reading

    avg_systolic = mean(r.systolic for r in readings)
    avg_diastolic = mean(r.diastolic for r in readings)

    // Step 2: Determine BP category
    bp_category = classify_bp(avg_systolic, avg_diastolic)

    // Step 3: Count antihypertensive medications
    htn_meds = conditions.filter(c => c.icd10_code starts with "I10")
    med_count = medications.count(m => m.class IN [
        "ACE_INHIBITOR", "ARB", "BETA_BLOCKER",
        "CALCIUM_CHANNEL_BLOCKER", "THIAZIDE", "LOOP_DIURETIC"
    ])

    // Step 4: Apply decision table
    result = RiskAssessment()

    match (bp_category, med_count):
        case (NORMAL, 0):
            result.max_class_ceiling = PREFERRED_PLUS
            result.debits = []

        case (ELEVATED, 0):
            result.max_class_ceiling = PREFERRED
            result.debits = [Debit("BP_ELEVATED", 10)]

        case (STAGE_1, 0..1):
            result.max_class_ceiling = STANDARD_PLUS
            result.debits = [Debit("BP_STAGE1", 25)]

        case (STAGE_1, 2):
            result.max_class_ceiling = STANDARD
            result.debits = [Debit("BP_STAGE1_2MEDS", 40)]

        case (STAGE_2, any):
            result.max_class_ceiling = TABLE_A
            result.debits = [Debit("BP_STAGE2", 75)]

        case (CRISIS, any):
            result.decision = DECLINE
            result.referral_reasons.add("Hypertensive crisis on exam")
            return result

    // Step 5: Check for end-organ damage
    if has_condition("I12", conditions):  // Hypertensive CKD
        result.debits.add(Debit("HTN_CKD", 50))
    if has_ecg_finding("LVH", exam.ecg):
        result.debits.add(Debit("HTN_LVH", 25))
    if lab_result("URINE_PROTEIN") >= "2+":
        result.debits.add(Debit("HTN_PROTEINURIA", 30))

    return result
```

### 11.4 Pseudocode — Diabetes Assessment

```
function assessDiabetes(
    conditions: List<MedicalCondition>,
    labs: Map<String, LabResult>,
    medications: List<Medication>
):
    result = RiskAssessment()

    // Step 1: Determine diabetes status
    hba1c = labs.get("LOINC:4548-4")  // HbA1c
    fasting_glucose = labs.get("LOINC:1558-6")
    diabetes_conditions = conditions.filter(c =>
        c.icd10_code starts with "E10" OR c.icd10_code starts with "E11"
    )

    dm_type = determine_dm_type(diabetes_conditions, medications)
    // Type 1: E10.x codes, on insulin since diagnosis, age at onset typically < 30
    // Type 2: E11.x codes, oral meds ± insulin, age at onset typically > 30

    // Step 2: No known diabetes — screen labs
    if dm_type == NONE:
        if hba1c != null:
            if hba1c.value < 5.7:
                return result  // No diabetes concern
            elif hba1c.value < 6.5:
                result.debits.add(Debit("PREDIABETES", 15))
                result.max_class_ceiling = STANDARD
                return result
            else:
                // New finding: HbA1c diagnostic for diabetes
                result.referral_reasons.add("New DM finding: HbA1c " + hba1c.value)
                dm_type = TYPE_2  // Assume T2DM; fall through to rating

    // Step 3: Known or newly discovered diabetes
    complications = assess_dm_complications(conditions, labs)
    // complications: {retinopathy, nephropathy, neuropathy, pvd, autonomic}

    hba1c_value = hba1c.value if hba1c else null
    complication_debits = sum(c.debit for c in complications)

    // Step 4: Apply rating matrix
    if dm_type == TYPE_1:
        base_table = t1dm_rating_table(hba1c_value)
        // T1DM base ratings are higher than T2DM
    else:
        base_table = t2dm_rating_table(hba1c_value, uses_insulin(medications))

    result.max_class_ceiling = base_table.ceiling
    result.debits.add(Debit("DM_BASE", base_table.debits))
    result.debits.addAll(complications.map(c => Debit(c.name, c.debit)))

    // Step 5: Duration and stability credits
    dm_duration = years_since(diabetes_conditions[0].date_diagnosed)
    if dm_duration > 5 AND hba1c_value < 7.0 AND complications.empty:
        result.credits.add(Credit("DM_LONG_STABLE", -15))

    // Step 6: Decline thresholds
    if hba1c_value >= 10.0:
        result.decision = DECLINE
        result.referral_reasons.add("HbA1c >= 10.0: uncontrolled DM")
    elif complications.has("PROLIFERATIVE_RETINOPATHY"):
        result.decision = DECLINE
    elif complications.has("DIALYSIS"):
        result.decision = DECLINE
    elif complications.has("AMPUTATION"):
        result.decision = DECLINE

    return result
```

### 11.5 Pseudocode — Build Assessment

```
function assessBuild(exam: ExamData, applicant: Applicant):
    result = RiskAssessment()

    height_inches = exam.height_feet * 12 + exam.height_inches
    weight_lbs = exam.weight_lbs
    bmi = (weight_lbs * 703) / (height_inches * height_inches)

    // Step 1: Look up build chart limits by gender and height
    build_limits = getBuildChart(applicant.gender, height_inches, applicant.age)

    // Step 2: Determine maximum class by weight
    if weight_lbs <= build_limits.preferred_plus_max:
        result.max_class_ceiling = PREFERRED_PLUS
    elif weight_lbs <= build_limits.preferred_max:
        result.max_class_ceiling = PREFERRED
    elif weight_lbs <= build_limits.standard_plus_max:
        result.max_class_ceiling = STANDARD_PLUS
    elif weight_lbs <= build_limits.standard_max:
        result.max_class_ceiling = STANDARD
    elif weight_lbs <= build_limits.table_a_max:
        result.max_class_ceiling = TABLE_A
        result.debits.add(Debit("BUILD_OVERWEIGHT", 25))
    elif weight_lbs <= build_limits.table_b_max:
        result.max_class_ceiling = TABLE_B
        result.debits.add(Debit("BUILD_OBESE", 50))
    else:
        // Calculate table rating based on excess weight
        excess_pct = (weight_lbs - build_limits.standard_max) / build_limits.standard_max
        table_rating = mapExcessToTable(excess_pct)
        result.max_class_ceiling = table_rating
        result.debits.add(Debit("BUILD_SEVERE_OBESITY", excess_pct * 200))

    // Step 3: Underweight check
    if bmi < 16.0:
        result.decision = DECLINE
        result.referral_reasons.add("BMI < 16.0: severe underweight")
    elif bmi < 17.0:
        result.max_class_ceiling = min(result.max_class_ceiling, TABLE_B)
        result.debits.add(Debit("UNDERWEIGHT", 50))
    elif bmi < 18.5:
        result.max_class_ceiling = min(result.max_class_ceiling, STANDARD)
        result.debits.add(Debit("MILD_UNDERWEIGHT", 15))

    // Step 4: Waist circumference (if available)
    if exam.waist_circumference != null:
        whr = exam.waist_circumference / height_inches
        if whr > 0.60:
            result.debits.add(Debit("VISCERAL_OBESITY", 25))

    return result
```

### 11.6 Pseudocode — Lab Panel Assessment

```
function assessLabPanel(labs: Map<String, LabResult>):
    results = List<RiskAssessment>()

    // Liver function assessment
    alt = labs.get("ALT")
    ast = labs.get("AST")
    ggt = labs.get("GGT")

    if alt != null AND alt.value > 2 * alt.reference_range.upper:
        liver_result = RiskAssessment()
        liver_result.referral_reasons.add("ALT > 2x ULN: " + alt.value)
        if alt.value > 5 * alt.reference_range.upper:
            liver_result.decision = POSTPONE
            liver_result.referral_reasons.add("ALT > 5x ULN — postpone pending workup")
        else:
            liver_result.debits.add(Debit("ELEVATED_ALT", 50))
        results.add(liver_result)

    // AST/ALT ratio for alcohol pattern
    if ast != null AND alt != null AND alt.value > 0:
        ratio = ast.value / alt.value
        if ratio > 2.0 AND ggt != null AND ggt.value > 2 * ggt.reference_range.upper:
            alcohol_flag = RiskAssessment()
            alcohol_flag.referral_reasons.add("AST/ALT > 2:1 with elevated GGT: alcoholic pattern")
            alcohol_flag.debits.add(Debit("ALCOHOL_LIVER_PATTERN", 75))
            results.add(alcohol_flag)

    // Kidney function
    creatinine = labs.get("CREATININE")
    if creatinine != null:
        egfr = calculate_egfr(creatinine.value, applicant.age, applicant.gender)
        kidney_result = RiskAssessment()

        if egfr >= 90:
            // Normal; no action
            pass
        elif egfr >= 60:
            kidney_result.debits.add(Debit("CKD_STAGE2", 15))
        elif egfr >= 45:
            kidney_result.max_class_ceiling = TABLE_A
            kidney_result.debits.add(Debit("CKD_STAGE3A", 50))
        elif egfr >= 30:
            kidney_result.max_class_ceiling = TABLE_C
            kidney_result.debits.add(Debit("CKD_STAGE3B", 100))
        elif egfr >= 15:
            kidney_result.max_class_ceiling = TABLE_F
            kidney_result.debits.add(Debit("CKD_STAGE4", 200))
        else:
            kidney_result.decision = DECLINE
            kidney_result.referral_reasons.add("eGFR < 15: ESRD")

        results.add(kidney_result)

    // Lipid panel
    tc = labs.get("TOTAL_CHOLESTEROL")
    hdl = labs.get("HDL")
    ldl = labs.get("LDL")
    trig = labs.get("TRIGLYCERIDES")

    if tc != null AND hdl != null AND hdl.value > 0:
        tc_hdl_ratio = tc.value / hdl.value
        lipid_result = RiskAssessment()

        if tc_hdl_ratio > 7.5:
            lipid_result.max_class_ceiling = TABLE_C
            lipid_result.debits.add(Debit("LIPID_SEVERE", 75))
        elif tc_hdl_ratio > 6.5:
            lipid_result.max_class_ceiling = STANDARD
            lipid_result.debits.add(Debit("LIPID_HIGH", 50))
        elif tc_hdl_ratio > 5.5:
            lipid_result.max_class_ceiling = PREFERRED
            lipid_result.debits.add(Debit("LIPID_BORDERLINE", 25))
        elif tc_hdl_ratio > 4.5:
            lipid_result.max_class_ceiling = PREFERRED
            // No debit; within preferred range

        results.add(lipid_result)

    // Infectious disease
    hiv = labs.get("HIV_AG_AB")
    if hiv != null AND hiv.value == POSITIVE:
        hiv_result = RiskAssessment()
        hiv_result.decision = DECLINE  // Most carriers; evolving
        hiv_result.referral_reasons.add("HIV positive")
        results.add(hiv_result)

    // Cotinine
    cotinine = labs.get("COTININE_SERUM")
    if cotinine != null AND cotinine.value >= 10:
        tobacco_result = RiskAssessment()
        tobacco_result.max_class_ceiling = STANDARD_TOBACCO
        tobacco_result.referral_reasons.add("Positive cotinine: " + cotinine.value)
        results.add(tobacco_result)

    return aggregate_results(results)
```

### 11.7 Final Aggregation Logic

```
function aggregateRiskAssessments(assessments: List<RiskAssessment>):

    final = RiskAssessment()
    final.base_class = PREFERRED_PLUS  // Start with best possible class

    // Step 1: Apply DECLINE decisions (Priority 1)
    decline_assessments = assessments.filter(a => a.decision == DECLINE)
    if decline_assessments.not_empty:
        final.decision = DECLINE
        final.referral_reasons = decline_assessments.flatMap(a => a.referral_reasons)
        return final

    // Step 2: Apply POSTPONE decisions (Priority 2)
    postpone_assessments = assessments.filter(a => a.decision == POSTPONE)
    if postpone_assessments.not_empty:
        final.decision = POSTPONE
        final.referral_reasons = postpone_assessments.flatMap(a => a.referral_reasons)
        return final

    // Step 3: Determine worst class ceiling (most restrictive)
    final.max_class_ceiling = assessments
        .map(a => a.max_class_ceiling)
        .filter(c => c != null)
        .min()  // Most restrictive class ceiling

    // Step 4: Sum all debits and credits
    total_debits = assessments.flatMap(a => a.debits).sum(d => d.value)
    total_credits = assessments.flatMap(a => a.credits).sum(c => c.value)
    net_debits = total_debits + total_credits  // Credits are negative

    // Step 5: Check for multiplicative conditions
    synergistic_pairs = [
        ("DIABETES", "CKD"),
        ("DIABETES", "SMOKING"),
        ("HYPERTENSION", "DIABETES"),
        ("OBESITY", "SLEEP_APNEA"),
    ]
    for (cond_a, cond_b) in synergistic_pairs:
        if has_debit_category(cond_a, assessments) AND has_debit_category(cond_b, assessments):
            synergy_factor = getSynergyFactor(cond_a, cond_b)  // e.g., 1.3
            net_debits = net_debits * synergy_factor

    // Step 6: Map net debits to table rating
    debit_class = mapDebitsToClass(net_debits)
    // 0-25: PP, 25-50: P, 50-75: SP, 75-100: S, 100-125: A, 125-150: B, etc.

    // Step 7: Final class = worst of (debit class, ceiling class)
    final.final_class = worst_of(debit_class, final.max_class_ceiling)

    // Step 8: Collect all referral reasons
    final.referral_reasons = assessments.flatMap(a => a.referral_reasons)

    // Step 9: Determine if auto-issue or manual referral
    if final.referral_reasons.not_empty:
        final.decision = REFER  // Send to human underwriter
    elif final.final_class.is_substandard:
        final.decision = RATE  // Approve with table rating
    else:
        final.decision = APPROVE  // STP eligible

    return final
```

---

## 12. AI/ML in Medical Underwriting

### 12.1 Overview

AI and machine learning are transforming medical underwriting in three key areas:

1. **Data extraction** — NLP/computer vision to convert unstructured medical records into structured data.
2. **Risk prediction** — ML models that predict mortality or classify risk more accurately than manual rules.
3. **Decision augmentation** — AI-assisted recommendations for human underwriters.

### 12.2 NLP for APS Extraction

#### 12.2.1 Model Architecture Options

| Approach | Technology | Accuracy | Latency | Cost |
|----------|-----------|----------|---------|------|
| **Rule-based NLP** | Regex, dictionaries, NegEx | Medium (70–80% F1) | Low | Low |
| **Classical ML** | CRF, SVM with medical features | Medium-High (80–85% F1) | Low | Medium |
| **Transformer-based** | Clinical BERT, BioBERT, PubMedBERT | High (88–93% F1) | Medium | Medium-High |
| **Large Language Models** | GPT-4, Claude, Med-PaLM | Very High (90–95% F1) | High | High |
| **Hybrid (LLM + rules)** | LLM extraction + rule-based validation | Highest (92–96% F1) | Medium-High | Medium-High |

#### 12.2.2 Training Data Requirements

| Entity Type | Minimum Labeled Samples | Recommended | Notes |
|------------|------------------------|------------|-------|
| Medical conditions | 5,000 mentions | 20,000+ | Cover specialty terminology and abbreviations |
| Medications | 3,000 mentions | 10,000+ | Include brand/generic/abbreviations |
| Lab values | 2,000 mentions | 8,000+ | Include various reporting formats |
| Dates/temporal | 3,000 mentions | 15,000+ | Relative and absolute date expressions |
| Negation | 2,000 mentions | 10,000+ | Critical for accuracy; "denies", "no evidence of" |
| Procedures | 2,000 mentions | 8,000+ | Surgical and diagnostic procedures |

#### 12.2.3 Evaluation Metrics for Medical NER

| Metric | Target | Minimum Acceptable | Measurement |
|--------|--------|-------------------|-------------|
| **Precision** (condition extraction) | > 95% | > 90% | How many extracted conditions are correct |
| **Recall** (condition extraction) | > 90% | > 85% | How many actual conditions are found |
| **F1 Score** (overall) | > 92% | > 88% | Harmonic mean of precision and recall |
| **Negation accuracy** | > 97% | > 95% | Correct identification of negated findings |
| **Temporal accuracy** | > 90% | > 85% | Correct date/duration extraction |
| **False positive rate** (conditions) | < 5% | < 10% | Incorrectly identified conditions |

### 12.3 Computer Vision for ECG Interpretation

#### 12.3.1 Deep Learning for ECG Analysis

| Application | Model Architecture | Performance | Clinical Validation |
|------------|-------------------|-------------|-------------------|
| Arrhythmia detection (AFib, VT, SVT) | 1D-CNN + LSTM, ResNet-34 | AUC > 0.97 for AFib | FDA 510(k) cleared (several products) |
| Myocardial infarction detection | 1D-CNN, attention-based | AUC > 0.93 | Research-grade; limited clinical deployment |
| LVH detection | CNN with multi-lead input | AUC > 0.90 | Supplementary to voltage criteria |
| Ejection fraction estimation | Deep neural network | MAE < 5% vs. echo | Research (Stanford, Mayo Clinic studies) |
| Biological age estimation | CNN regression | Predicts mortality beyond chronological age | Research; potential UW application |
| Hypertrophic cardiomyopathy screening | CNN, transformer-based | AUC > 0.91 | Research; screening application |

#### 12.3.2 ECG-to-UW Pipeline

```
┌──────────────┐    ┌────────────────────┐    ┌──────────────────┐
│  Raw ECG     │───▶│  AI ECG Model      │───▶│  Structured      │
│  Signal      │    │                    │    │  Findings        │
│  (12-lead)   │    │  1. Signal QA      │    │                  │
│              │    │  2. Rhythm class.   │    │  - Rhythm: AFib  │
│              │    │  3. Morphology     │    │  - Rate: 78 bpm  │
│              │    │  4. ST/T analysis  │    │  - ST changes: No│
│              │    │  5. Interval meas. │    │  - LVH: Yes      │
│              │    │  6. MI detection   │    │  - QTc: 445 ms   │
│              │    │  7. Risk score     │    │  - Minnesota: 4-1│
└──────────────┘    └────────────────────┘    └────────┬─────────┘
                                                        │
                                              ┌─────────▼─────────┐
                                              │  UW Rules Engine   │
                                              │                    │
                                              │  Minnesota Code    │
                                              │  → Table Lookup    │
                                              │  → Debit/Credit    │
                                              │  → Referral Logic  │
                                              └────────────────────┘
```

### 12.4 Predictive Models for Medical Risk

#### 12.4.1 Mortality Prediction Models

| Model Type | Inputs | Output | Use Case |
|-----------|--------|--------|---------|
| **Logistic Regression** | Demographics, conditions, labs | P(death within 15 years) | Interpretable baseline; regulatory-friendly |
| **Gradient Boosted Trees (XGBoost/LightGBM)** | All structured medical data | Mortality risk score | High accuracy; most common in production |
| **Neural Network (deep learning)** | Structured + unstructured data | Mortality risk score | Highest accuracy potential; less interpretable |
| **Survival Analysis (Cox PH)** | Demographics, conditions, time-to-event | Hazard ratio | Standard actuarial approach; interpretable |
| **Random Survival Forests** | All structured data, handles non-linear effects | Survival probability curve | Handles complex interactions |

#### 12.4.2 Feature Importance (Typical Mortality Prediction Model)

| Feature | Typical Importance Rank | Feature Type |
|---------|------------------------|-------------|
| Age | 1 | Demographic |
| Tobacco use | 2 | Behavioral |
| BMI | 3 | Physical |
| HbA1c | 4 | Lab |
| Blood pressure (systolic) | 5 | Exam |
| Total cholesterol / HDL ratio | 6 | Lab |
| eGFR | 7 | Lab (calculated) |
| Number of prescription medications | 8 | Rx |
| Cancer history | 9 | Medical history |
| Cardiac history (MI, CABG, AFib) | 10 | Medical history |
| ALT / liver enzymes | 11 | Lab |
| Family history (premature CVD) | 12 | Family |
| Mental health history | 13 | Medical history |
| CDT / alcohol markers | 14 | Lab |
| Driving record (DUI) | 15 | Behavioral |

#### 12.4.3 Model Validation and Governance

| Validation Activity | Metric | Target | Frequency |
|--------------------|--------|--------|-----------|
| **Discrimination** | AUC-ROC | > 0.80 | Quarterly |
| **Calibration** | Hosmer-Lemeshow, calibration curve | P-value > 0.05 | Quarterly |
| **Stability** | PSI (Population Stability Index) | < 0.10 | Monthly |
| **Fairness** | Disparate impact ratio across protected classes | 0.8–1.2 | Quarterly |
| **Actual-to-Expected (A/E)** | Actual deaths / expected deaths by model | 95–105% | Annually |
| **Back-testing** | Model predictions vs. outcomes on holdout data | AUC within 2% of training | Annually |
| **Champion-Challenger** | New model vs. production model on same population | Challenger must show improvement | Before deployment |

#### 12.4.4 Regulatory Considerations

| Jurisdiction | Key Regulation | Impact on AI/ML in UW |
|-------------|---------------|----------------------|
| **All US states** | Unfair discrimination statutes | Models cannot use race, national origin, or genetic information |
| **Colorado** | SB 21-169 (AI governance) | Insurers must test for unfair bias; governance framework required |
| **New York** | Circular Letter 1 (2019) | External data/algorithms must not unfairly discriminate |
| **NAIC** | Model Bulletin on AI/ML | Governance, risk management, fairness testing framework |
| **EU (Solvency II)** | EIOPA guidelines on AI | Explainability, human oversight, fair treatment |
| **Federal (US)** | FCRA, HIPAA, GINA | Credit data use restrictions; health data privacy; genetic information prohibition |

### 12.5 LLM-Assisted Underwriting

Large Language Models are emerging as tools for underwriter augmentation:

| Application | Description | Maturity |
|------------|-----------|---------|
| **APS summarization** | Generate structured UW summaries from raw medical records | Production-ready (with human review) |
| **Medical Q&A** | Answer underwriter questions about specific medical conditions | Production-ready (with guardrails) |
| **Decision rationale generation** | Explain why a risk was rated at a particular class | Early production |
| **Consistency checking** | Compare a proposed decision against historical decisions for similar cases | Pilot stage |
| **Reflexive question generation** | Generate follow-up questions based on application answers | Production-ready |
| **ICD-10 code extraction** | Extract and validate diagnosis codes from narrative text | Production-ready |
| **Drug interaction analysis** | Identify concerning drug combinations from Rx data | Pilot stage |

**Key Guardrails for LLM Use in UW:**

1. **Human-in-the-loop**: LLMs should augment, not replace, underwriting decisions for rated or complex cases.
2. **Hallucination detection**: Medical facts must be verified against structured data sources; LLMs can fabricate medical details.
3. **Explainability**: Every LLM-influenced decision must have an auditable rationale.
4. **PHI protection**: Medical records processed by LLMs must comply with HIPAA; use enterprise deployments (not public APIs) or de-identified data.
5. **Consistency**: LLM outputs should be validated against established underwriting guidelines to prevent drift.
6. **Version control**: Track model versions and prompt templates; maintain reproducibility.

---

## 13. Cross-References & Further Reading

This article is part of a comprehensive term life underwriting knowledge base. Related articles:

| Article | Coverage |
|---------|---------|
| **01 — Term Underwriting Fundamentals** | Product types, underwriting function, risk classification, mortality basics, reinsurance, glossary |
| **02 — Automated Underwriting Engine** | Architecture patterns, decision engines, rules vs. models, STP design, API design, vendor platforms |
| **03 — Financial & Non-Medical Underwriting** | Financial justification, occupation, aviation, avocation, foreign travel, criminal history, credit-based scoring |
| **04 — Medical Underwriting Deep Dive** | *(This article)* Paramedical exam, lab panels, APS, ECG, impairment guide, Rx interpretation, build charts, tobacco |
| **05 — Data Sources & Third-Party Integrations** | MIB, Rx databases, MVR, credit, identity verification, electronic health records, FCRA compliance |
| **06 — Regulatory & Compliance Framework** | State filing, unfair discrimination, genetic information, privacy (HIPAA, GLBA), NAIC guidelines, international |
| **07 — Actuarial Pricing & Mortality Tables** | Mortality tables (VBT/CSO), experience studies, pricing models, lapse assumptions, reserve requirements |
| **08 — Claims & Contestability** | Claims investigation, contestability period, material misrepresentation, rescission, fraud detection |

---

*This document is maintained as a living reference. Last updated: April 2026. All clinical thresholds, rating guidelines, and regulatory references should be validated against current carrier-specific underwriting manuals and applicable state/federal regulations before implementation in production systems.*
