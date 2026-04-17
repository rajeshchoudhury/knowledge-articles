# Artificial Intelligence & Machine Learning in Claims Processing

## A Comprehensive Architecture & Implementation Guide for P&C Insurance

---

## Table of Contents

1. [AI/ML Landscape in Insurance Claims](#1-aiml-landscape-in-insurance-claims)
2. [Computer Vision Applications](#2-computer-vision-applications)
3. [Natural Language Processing](#3-natural-language-processing)
4. [Predictive Analytics](#4-predictive-analytics)
5. [Machine Learning Model Types](#5-machine-learning-model-types)
6. [Deep Learning Applications](#6-deep-learning-applications)
7. [Feature Engineering for Claims ML](#7-feature-engineering-for-claims-ml)
8. [Training Data & Data Pipeline Design](#8-training-data--data-pipeline-design)
9. [Model Deployment Architecture (MLOps)](#9-model-deployment-architecture-mlops)
10. [A/B Testing & Champion-Challenger](#10-ab-testing--champion-challenger)
11. [Explainable AI (XAI)](#11-explainable-ai-xai)
12. [Bias Detection & Fairness](#12-bias-detection--fairness)
13. [Real-Time vs Batch Inference](#13-real-time-vs-batch-inference)
14. [Computer Vision Pipeline for Auto Damage](#14-computer-vision-pipeline-for-auto-damage)
15. [NLP Pipeline for Claims](#15-nlp-pipeline-for-claims)
16. [Conversational AI for FNOL](#16-conversational-ai-for-fnol)
17. [Claims Triage Scoring Model](#17-claims-triage-scoring-model)
18. [Litigation Prediction Model](#18-litigation-prediction-model)
19. [Medical Bill Review with NLP](#19-medical-bill-review-with-nlp)
20. [Subrogation Identification with ML](#20-subrogation-identification-with-ml)
21. [Vendor & Model Marketplace](#21-vendor--model-marketplace)
22. [Ethical Considerations & Regulatory Constraints](#22-ethical-considerations--regulatory-constraints)
23. [Model Monitoring & Drift Detection](#23-model-monitoring--drift-detection)
24. [Complete ML Pipeline Architecture](#24-complete-ml-pipeline-architecture)
25. [Sample Feature Store Schema](#25-sample-feature-store-schema)

---

## 1. AI/ML Landscape in Insurance Claims

### 1.1 Current State of AI Adoption

The insurance industry has progressed from experimental AI pilots to production-grade deployments across the claims lifecycle. AI/ML capabilities now touch every phase—from FNOL through settlement—and are becoming table-stakes for competitive carriers.

```
AI/ML ADOPTION MATURITY BY CLAIMS FUNCTION

  Fraud Detection       ████████████████████░  90%  (Mature)
  Document Processing   ██████████████████░░░  85%  (Mature)
  Claims Triage         ███████████████░░░░░░  70%  (Growing)
  Damage Estimation     ██████████████░░░░░░░  65%  (Growing)
  Reserve Prediction    ████████████░░░░░░░░░  55%  (Emerging)
  Litigation Prediction ██████████░░░░░░░░░░░  45%  (Emerging)
  Subrogation ID        ████████░░░░░░░░░░░░░  35%  (Emerging)
  Settlement Negotiation████░░░░░░░░░░░░░░░░░  15%  (Early)
  Autonomous Claims     ███░░░░░░░░░░░░░░░░░░  10%  (Experimental)
```

### 1.2 AI/ML Value Map Across Claims Lifecycle

```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│   FNOL   │  │  TRIAGE  │  │ INVESTIG │  │ EVALUATE │  │ SETTLE   │
│          │  │          │  │          │  │          │  │          │
│ Chatbot/ │  │ Severity │  │ Computer │  │ Reserve  │  │ Settle-  │
│ Virtual  │  │ Scoring  │  │ Vision   │  │ Predict  │  │ ment     │
│ Assist   │  │          │  │          │  │          │  │ Predict  │
│          │  │ Fraud    │  │ NLP Doc  │  │ Medical  │  │          │
│ Voice    │  │ Scoring  │  │ Analysis │  │ Bill     │  │ Litig.   │
│ Analytic │  │          │  │          │  │ Review   │  │ Predict  │
│          │  │ Routing  │  │ Satellite│  │          │  │          │
│ Photo    │  │ Optimiz. │  │ Imagery  │  │ Subrog   │  │ Negoti-  │
│ AI       │  │          │  │          │  │ Ident.   │  │ ation AI │
└──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘
     │              │              │              │              │
     ▼              ▼              ▼              ▼              ▼
  ┌────────────────────────────────────────────────────────────────┐
  │              CROSS-CUTTING AI CAPABILITIES                      │
  │                                                                  │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
  │  │ Fraud    │  │ Document │  │ Analytics│  │ Customer │      │
  │  │ Detection│  │ Intellig.│  │ Platform │  │ Intellig.│      │
  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘      │
  └────────────────────────────────────────────────────────────────┘
```

### 1.3 Business Impact Metrics

| AI Application | Metric | Typical Improvement |
|---------------|--------|-------------------|
| CV Damage Estimation | Cycle time | 50–70% reduction |
| NLP Document Processing | Manual review time | 60–80% reduction |
| Fraud Detection ML | Detection rate | 2–3x improvement |
| Claims Triage Scoring | Assignment accuracy | 30–40% improvement |
| Reserve Prediction | Accuracy (vs actual) | 15–25% improvement |
| Chatbot FNOL | FNOL completion time | 40–60% reduction |
| Litigation Prediction | Early identification | 60–70% accuracy |
| Subrogation ID | Recovery rate | 15–25% increase |
| Medical Bill NLP | Processing cost | 50–60% reduction |

---

## 2. Computer Vision Applications

### 2.1 Photo-Based Damage Estimation

Computer vision for auto damage estimation uses convolutional neural networks to analyze photographs of damaged vehicles and estimate repair costs.

```
DAMAGE ESTIMATION PIPELINE:

  ┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐
  │ Image      │    │ Quality    │    │ Vehicle    │    │ Damage     │
  │ Ingestion  │───▶│ Assessment │───▶│ Identifi-  │───▶│ Detection  │
  │            │    │            │    │ cation     │    │ & Localize │
  └────────────┘    └────────────┘    └────────────┘    └────────────┘
                                                              │
  ┌────────────┐    ┌────────────┐    ┌────────────┐         │
  │ Cost       │    │ Repair vs  │    │ Damage     │◀────────┘
  │ Estimation │◀───│ Replace    │◀───│ Severity   │
  │            │    │ Decision   │    │ Classify   │
  └────────────┘    └────────────┘    └────────────┘
```

#### Image Quality Assessment Model

| Check | Method | Threshold | Action on Fail |
|-------|--------|-----------|---------------|
| Resolution | Pixel count | ≥ 1280×960 | Request retake |
| Blur Detection | Laplacian variance | > 100 | Request retake |
| Brightness | Histogram analysis | 40–220 mean | Request retake |
| Vehicle Presence | Object detection | Confidence > 90% | Request retake |
| Damage Visible | Damage detector | Confidence > 70% | Request additional angle |
| Angle Coverage | Pose estimation | 4+ angles | Request missing angles |
| Obstruction | Segmentation | < 10% occluded | Request retake |

#### Damage Detection Architecture

```
INPUT: Vehicle damage photographs (4-8 images per claim)

MODEL ARCHITECTURE:
  Backbone: ResNet-101 or EfficientNet-B4 (pre-trained on ImageNet)
  Detection Head: Faster R-CNN or YOLO v5 for damage region detection
  Segmentation: Mask R-CNN for pixel-level damage masks
  Classification: Multi-label classifier for damage types

DAMAGE CLASSES:
  - Dent (minor, moderate, severe)
  - Scratch (surface, deep, through-paint)
  - Crack (hairline, spider, shattered)
  - Broken (partial, complete)
  - Misalignment (minor, major)
  - Missing part
  - Deployed airbag
  - Fluid leak
  - Structural deformation
  - Fire/burn damage

VEHICLE PANELS:
  - Front bumper          - Hood
  - Front left fender     - Front right fender
  - Left front door       - Right front door
  - Left rear door        - Right rear door
  - Left rear quarter     - Right rear quarter
  - Rear bumper           - Trunk/liftgate
  - Roof                  - Windshield
  - Left mirror           - Right mirror
  - Left headlight        - Right headlight
  - Left taillight        - Right taillight
  - Undercarriage (visible)

OUTPUT:
  {
    "vehicle_identified": true,
    "vehicle_info": {"year": 2021, "make": "Toyota", "model": "Camry"},
    "damages": [
      {
        "panel": "REAR_BUMPER",
        "damage_type": "DENT",
        "severity": "MODERATE",
        "confidence": 0.92,
        "bounding_box": [120, 340, 450, 520],
        "area_percentage": 35.2,
        "repair_action": "REPLACE",
        "estimated_cost": {"parts": 485, "labor": 320, "paint": 275}
      },
      {
        "panel": "TRUNK",
        "damage_type": "DENT",
        "severity": "MINOR",
        "confidence": 0.87,
        "bounding_box": [200, 180, 380, 340],
        "area_percentage": 12.8,
        "repair_action": "PDR",
        "estimated_cost": {"parts": 0, "labor": 250, "paint": 0}
      }
    ],
    "total_estimate": {
      "parts": 485,
      "labor": 570,
      "paint": 275,
      "total": 1330,
      "confidence": 0.89
    },
    "total_loss_probability": 0.05,
    "airbag_deployed": false,
    "structural_damage": false
  }
```

### 2.2 Satellite & Aerial Imagery Analysis

Used primarily for property claims, especially catastrophe events.

| Application | Technology | Data Source | Use Case |
|------------|-----------|------------|----------|
| Roof damage assessment | Semantic segmentation | Aerial/drone imagery | Hail, wind, hurricane claims |
| Pre/post loss comparison | Change detection CNN | Satellite imagery | CAT event validation |
| Flood extent mapping | Water segmentation | Satellite/aerial | Flood claim validation |
| Wildfire perimeter | Fire boundary detection | Satellite (IR + visible) | Wildfire claim triage |
| Building damage level | Classification CNN | Drone/aerial imagery | Earthquake, tornado claims |
| Vegetation encroachment | Object detection | Aerial imagery | Liability prevention |

```
SATELLITE IMAGERY PIPELINE (PROPERTY CAT):

  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
  │ Acquire      │    │ Pre-Event    │    │ Post-Event   │
  │ Imagery      │    │ Baseline     │    │ Imagery      │
  │ (Maxar/      │    │ Image        │    │ Acquisition  │
  │  Planet)     │    │ Retrieval    │    │              │
  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘
         │                   │                    │
         └───────────────────┼────────────────────┘
                             │
                    ┌────────▼────────┐
                    │ Image           │
                    │ Registration    │
                    │ & Alignment     │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Change          │
                    │ Detection       │
                    │ Model           │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Damage          │
                    │ Classification  │
                    │ (None/Minor/    │
                    │  Major/Destroy) │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Policy          │
                    │ Geocode Match   │
                    │ & Report Gen    │
                    └─────────────────┘
```

### 2.3 Document OCR & Classification

```
DOCUMENT CV PIPELINE:

  Input: Scanned document or photo of document

  Step 1: Image Pre-processing
    - Deskew (Hough transform)
    - Denoise (bilateral filter)
    - Binarize (Otsu's threshold)
    - Crop margins
    
  Step 2: Layout Analysis
    - Detect text regions, tables, images, signatures
    - Model: Detectron2 / LayoutLMv3
    
  Step 3: Document Classification
    - CNN classifier or LayoutLM fine-tuned
    - Classes: Police Report, Medical Record, Estimate,
               Invoice, Legal Filing, Correspondence, Photo,
               ID Document, Proof of Loss
    - Confidence threshold: 90% for auto-classify
    
  Step 4: OCR
    - Printed text: Tesseract 5 / AWS Textract / Google Vision
    - Handwritten: Google Vision / Azure Cognitive Services
    - Table extraction: AWS Textract Tables / Camelot
    
  Step 5: Entity Extraction
    - Named Entity Recognition (BERT-based)
    - Domain-specific entities: claim number, policy number,
      dollar amounts, dates, diagnosis codes, CPT codes
    
  Step 6: Validation & Output
    - Cross-reference extracted data with claim system
    - Flag low-confidence extractions for human review
    - Output: structured JSON mapped to claim fields
```

---

## 3. Natural Language Processing

### 3.1 Claims Narrative Analysis

Claims adjusters and claimants write narrative descriptions of losses. NLP extracts structured information from these unstructured narratives.

```
EXAMPLE INPUT (Loss Description):
"On March 14th around 3:30 PM, I was driving eastbound on Highway 101 
near the Oak Street exit when the vehicle in front of me suddenly stopped. 
I applied my brakes but was unable to stop in time and rear-ended the 
other vehicle, a blue 2019 Ford F-150. The other driver complained of 
neck pain. There were no passengers in either vehicle. Officer Johnson, 
badge #4521, responded and issued a report #2024-03-14-1234. Weather 
was clear and roads were dry."

NLP EXTRACTION OUTPUT:
{
  "date_of_loss": "2024-03-14",
  "time_of_loss": "15:30",
  "location": {
    "road": "Highway 101",
    "near": "Oak Street exit",
    "direction": "eastbound"
  },
  "accident_type": "REAR_END",
  "fault_indicator": "INSURED_AT_FAULT",
  "vehicles": [
    {"role": "INSURED", "direction": "eastbound"},
    {"role": "CLAIMANT", "color": "blue", "year": 2019, 
     "make": "Ford", "model": "F-150"}
  ],
  "injuries": [
    {"person": "OTHER_DRIVER", "type": "NECK_PAIN", 
     "severity": "MINOR"}
  ],
  "passengers": {"insured_vehicle": 0, "other_vehicle": 0},
  "police_report": {
    "officer": "Johnson", "badge": "4521",
    "report_number": "2024-03-14-1234"
  },
  "weather": "CLEAR",
  "road_conditions": "DRY",
  "entities_extracted": 14,
  "confidence": 0.91
}
```

### 3.2 Sentiment Analysis for Claims

```
SENTIMENT ANALYSIS APPLICATIONS:

  1. Claimant Communication Tone
     - Detect frustration, anger, satisfaction in correspondence
     - Trigger proactive outreach for negative sentiment
     - Escalate potential complaint situations
     
  2. Adjuster Note Quality
     - Detect completeness of investigation notes
     - Flag subjective language that may indicate bias
     - Ensure regulatory compliance in documentation
     
  3. Attorney Demand Analysis
     - Assess aggressiveness of demand letters
     - Predict negotiation posture
     - Identify key leverage points

MODEL: Fine-tuned BERT/RoBERTa for insurance domain

SENTIMENT CLASSES:
  - Very Negative (angry, threatening, demanding)
  - Negative (frustrated, dissatisfied, concerned)
  - Neutral (factual, informational)
  - Positive (satisfied, appreciative)
  - Very Positive (highly satisfied, complimentary)

APPLICATIONS BY SCORE:
  Score < -0.5: Auto-escalate to supervisor, priority callback
  Score -0.5 to -0.2: Flag for adjuster attention
  Score -0.2 to 0.2: Standard processing
  Score > 0.2: Candidate for satisfaction survey
  Score > 0.5: Candidate for testimonial/referral program
```

### 3.3 Medical Record Summarization

```
MEDICAL RECORD NLP PIPELINE:

  Input: Medical records (PDF, images, HL7/FHIR)
  
  ┌─────────────────┐
  │ Document Intake  │
  │ - PDF parsing    │
  │ - OCR if needed  │
  │ - Section detect │
  └────────┬────────┘
           │
  ┌────────▼────────┐
  │ Section         │
  │ Classification  │
  │ - History       │
  │ - Examination   │
  │ - Diagnosis     │
  │ - Treatment     │
  │ - Prognosis     │
  │ - Billing       │
  └────────┬────────┘
           │
  ┌────────▼────────┐
  │ Entity          │
  │ Extraction      │
  │ - Diagnosis (ICD│
  │ - Procedures    │
  │ - Medications   │
  │ - Body parts    │
  │ - Dates         │
  │ - Providers     │
  └────────┬────────┘
           │
  ┌────────▼────────┐
  │ Causal Link     │
  │ Analysis        │
  │ - Injury related│
  │   to accident?  │
  │ - Pre-existing? │
  │ - Treatment     │
  │   reasonable?   │
  └────────┬────────┘
           │
  ┌────────▼────────┐
  │ Summary         │
  │ Generation      │
  │ - Key findings  │
  │ - Timeline      │
  │ - Claim-relevant│
  │   highlights    │
  └─────────────────┘

OUTPUT EXAMPLE:
{
  "patient": "Jane Doe",
  "dates_of_service": ["2024-03-14", "2024-03-21", "2024-04-15"],
  "providers": [
    {"name": "Dr. Smith", "specialty": "Emergency Medicine"},
    {"name": "Dr. Chen", "specialty": "Orthopedics"}
  ],
  "diagnoses": [
    {"code": "S13.4", "description": "Cervical sprain", "related_to_accident": true},
    {"code": "M54.2", "description": "Cervicalgia", "related_to_accident": true},
    {"code": "E11.9", "description": "Type 2 diabetes", "related_to_accident": false}
  ],
  "treatments": [
    {"type": "ER Visit", "date": "2024-03-14", "cpt": "99283"},
    {"type": "X-Ray Cervical", "date": "2024-03-14", "cpt": "72050"},
    {"type": "Physical Therapy", "date": "2024-03-21", "cpt": "97110", "units": 3},
    {"type": "Follow-up Ortho", "date": "2024-04-15", "cpt": "99213"}
  ],
  "pre_existing_conditions": ["Type 2 diabetes", "Prior lumbar strain (2019)"],
  "accident_causation_score": 0.88,
  "treatment_reasonableness_score": 0.92,
  "estimated_future_treatment": "4-6 weeks PT, possible MRI if no improvement",
  "max_medical_improvement_estimate": "2024-07-15",
  "summary": "Patient sustained cervical sprain in MVA on 3/14. ER evaluation showed no fracture. Referred to orthopedics. Undergoing PT. Pre-existing diabetes noted but unrelated. Treatment appears reasonable and related to accident."
}
```

---

## 4. Predictive Analytics

### 4.1 Claim Severity Prediction

```
MODEL: Claim Severity Predictor

OBJECTIVE: Predict total incurred cost at FNOL (before investigation)

ALGORITHM: Gradient Boosted Trees (XGBoost / LightGBM)

TARGET VARIABLE: total_incurred (continuous, log-transformed)

KEY FEATURES:
  Claim Features:
    - LOB, coverage type, loss cause
    - Claimed amount (if provided)
    - Number of claimants, vehicles
    - Injury indicators, injury types
    - Date/time of loss
    - Days to report
    
  Policy Features:
    - Policy age, tenure
    - Coverage limits, deductibles
    - Premium amount
    - Prior claims count
    
  External Features:
    - Loss location demographics
    - Weather at loss time
    - Venue litigation risk score
    - Medical cost index for area
    
PERFORMANCE METRICS:
  - RMSE: $2,800 (on log-scale: 0.42)
  - MAE: $1,950
  - R²: 0.72
  - Within 25% of actual: 68% of claims
  - Within 50% of actual: 89% of claims
```

### 4.2 Litigation Propensity Prediction

| Feature Category | Features | Importance |
|-----------------|----------|-----------|
| Injury Severity | Injury type, hospitalization, surgery | Very High |
| Attorney Involvement | Attorney at FNOL, prior attorney history | Very High |
| Claim Value | Estimated severity, coverage limits | High |
| Claimant Demographics | Age, occupation, prior litigation | Medium |
| Venue | County litigation rate, judicial environment | High |
| Communication | Sentiment score, response times | Medium |
| Claims Handling | Adjuster experience, cycle time | Medium |
| Loss Characteristics | Accident type, fault determination | Medium |

```
MODEL OUTPUT:
{
  "claim_id": "CLM-2024-001234",
  "litigation_probability": 0.73,
  "litigation_risk_tier": "HIGH",
  "key_risk_factors": [
    {"factor": "Attorney retained at FNOL", "contribution": 0.25},
    {"factor": "Cervical injury with surgery indication", "contribution": 0.20},
    {"factor": "High litigation venue (Cook County, IL)", "contribution": 0.15},
    {"factor": "Policy limits demand likely", "contribution": 0.13}
  ],
  "recommended_actions": [
    "Assign to senior adjuster with litigation experience",
    "Set initial reserve at 75th percentile for venue",
    "Early mediation consideration",
    "Engage defense counsel proactively"
  ],
  "estimated_litigation_cost": {
    "defense_costs": {"p25": 12000, "p50": 25000, "p75": 55000},
    "indemnity": {"p25": 35000, "p50": 75000, "p75": 175000}
  }
}
```

### 4.3 Settlement Amount Prediction

```
ALGORITHM: Quantile Regression (predict P25, P50, P75 settlement ranges)

FEATURES:
  - All severity prediction features
  - Liability determination result
  - Injury diagnosis codes (ICD-10)
  - Treatment duration and cost
  - Attorney demand amount
  - Venue/jurisdiction history
  - Adjuster negotiation history
  - Similar claim settlements (k-NN)

OUTPUT:
  Settlement Range Prediction:
    P10: $15,000   (10% chance settlement below this)
    P25: $25,000   (25% chance)
    P50: $42,000   (median prediction)
    P75: $68,000   (75% chance)
    P90: $95,000   (90% chance settlement below this)
    
  Recommended Initial Offer: $28,000 (based on P25-P50 range)
  Recommended Settlement Authority: $68,000 (P75)
```

### 4.4 Claim Duration Prediction

```
MODEL: Time-to-Close Predictor

ALGORITHM: Survival Analysis (Cox Proportional Hazards + Random Survival Forest)

TARGET: Days from FNOL to closure

FEATURES:
  - LOB, claim type, severity score
  - Attorney involvement
  - Injury type and severity
  - State/jurisdiction
  - Number of parties
  - Subrogation potential
  - Coverage complexity
  
OUTPUTS:
  Expected Duration: 127 days
  Probability of closure within:
    30 days:  12%
    60 days:  28%
    90 days:  45%
    180 days: 72%
    365 days: 91%
    
  Risk of becoming long-tail (>2 years): 4%
```

---

## 5. Machine Learning Model Types

### 5.1 Classification Models

| Use Case | Algorithm | Classes | Key Metrics |
|----------|-----------|---------|-------------|
| Fraud Detection | XGBoost, Random Forest | Fraud / Non-Fraud | AUC-ROC: 0.92, Precision: 0.75 |
| Claim Triage | LightGBM | Low/Med/High/Severe | Weighted F1: 0.81 |
| Document Type | Fine-tuned BERT | 15+ doc types | Accuracy: 94% |
| Coverage Decision | Decision Tree Ensemble | Covered/Not/Review | Accuracy: 96% |
| Injury Classification | Multi-label NN | 20+ injury types | Micro-F1: 0.85 |
| Total Loss Prediction | Logistic Regression | Total Loss / Repair | AUC-ROC: 0.95 |
| STP Eligibility | Rules + ML Hybrid | Eligible / Not | Precision: 0.98 |
| Subrogation Potential | XGBoost | Subro / No-Subro | AUC-ROC: 0.88 |

### 5.2 Regression Models

| Use Case | Algorithm | Target | Key Metrics |
|----------|-----------|--------|-------------|
| Reserve Prediction | XGBoost Regressor | Total incurred ($) | RMSE: $2,800, R²: 0.72 |
| Settlement Amount | Quantile Regression | Settlement ($) | MAE: $3,200 |
| Repair Cost | CNN + Regression | Repair cost ($) | MAE: $450 |
| Medical Cost | Gradient Boosting | Total medical ($) | RMSE: $1,500 |
| Duration | Survival Forest | Days to close | C-Index: 0.78 |
| Salvage Value | Random Forest | Salvage ($) | MAE: $800 |
| Subrogation Recovery | Linear Regression | Recovery amount ($) | R²: 0.65 |

### 5.3 Clustering Models

| Use Case | Algorithm | Clusters | Application |
|----------|-----------|----------|-------------|
| Claim Segmentation | K-Means | 8–12 segments | Workload balancing |
| Claimant Profiling | DBSCAN | Dynamic | Behavioral analysis |
| Provider Grouping | Hierarchical | 5–10 groups | Network analysis |
| Fraud Ring Detection | Community Detection | Dynamic | Organized fraud |
| Loss Pattern Clustering | Gaussian Mixture | 6–8 patterns | Trend detection |
| Venue Clustering | K-Means | 10–15 venues | Settlement benchmarking |

### 5.4 NER (Named Entity Recognition)

```
CUSTOM NER ENTITIES FOR CLAIMS:

  ENTITY TYPE           EXAMPLES
  ─────────────────     ─────────────────────────────────
  PERSON                "John Smith", "Dr. Johnson"
  ORGANIZATION          "State Farm", "City Hospital"
  VEHICLE               "2021 Toyota Camry", "blue Ford F-150"
  VIN                   "1HGBH41JXMN109186"
  POLICY_NUMBER         "PA-2024-12345678"
  CLAIM_NUMBER          "CLM-2024-001234"
  DATE                  "March 14, 2024", "3/14/24"
  TIME                  "3:30 PM", "15:30"
  MONEY                 "$5,000", "five thousand dollars"
  LOCATION              "Highway 101 near Oak Street exit"
  BODY_PART             "neck", "lower back", "left knee"
  INJURY_TYPE           "sprain", "fracture", "contusion"
  DIAGNOSIS_CODE        "S13.4", "M54.2"
  CPT_CODE              "99283", "97110"
  MEDICATION            "ibuprofen 800mg", "Flexeril"
  CAUSE_OF_LOSS         "rear-end collision", "hail storm"
  WEATHER               "clear", "rainy", "icy"
  ROAD_CONDITION        "dry", "wet", "construction zone"
  POLICE_REPORT_NUM     "2024-03-14-1234"
  OFFICER               "Officer Johnson, badge #4521"
  WITNESS               "Mary Jones", "bystander"
```

---

## 6. Deep Learning Applications

### 6.1 CNN for Image Damage Assessment

```
ARCHITECTURE: Multi-Task CNN for Damage Assessment

Base Network: EfficientNet-B4 (pre-trained ImageNet)

Task Heads:
  1. Damage Detection (Object Detection)
     - Faster R-CNN head
     - Output: Bounding boxes + damage type labels
     
  2. Severity Classification (Multi-class)
     - Global Average Pooling + Dense layers
     - Output: None / Minor / Moderate / Severe
     
  3. Panel Identification (Multi-label)
     - Dense + Sigmoid activations
     - Output: Probability per vehicle panel
     
  4. Repair Action Prediction (Multi-class per region)
     - ROI Pooling + Dense layers
     - Output: Repair / PDR / Replace / Blend per region

TRAINING DATA:
  - 500,000+ annotated vehicle damage images
  - Annotations: bounding boxes, damage type, severity, panel, repair action
  - Sources: historical claims photos, vendor estimates, CCC/Mitchell data
  
TRAINING PROCESS:
  - Pre-train backbone on ImageNet
  - Fine-tune on vehicle damage dataset
  - Multi-task loss: L = w1*L_detect + w2*L_severity + w3*L_panel + w4*L_repair
  - Data augmentation: rotation, flip, brightness, contrast, crop
  - Batch size: 16, Learning rate: 1e-4 with cosine annealing
  
INFERENCE:
  - Input: 4-8 photos (640x480 minimum)
  - Processing time: ~2 seconds per image (GPU)
  - Output: Structured damage report with confidence scores
```

### 6.2 Transformer Models for Text Analysis

```
MODEL: Claims-BERT (Domain-Adapted BERT for Insurance Claims)

ADAPTATION PROCESS:
  Step 1: Start with BERT-base or RoBERTa-base
  Step 2: Continue pre-training on insurance corpus
          - 10M+ claims narratives
          - 5M+ adjuster notes
          - 2M+ policy documents
          - Insurance regulatory texts
          - Medical records related to claims
  Step 3: Fine-tune for specific tasks

FINE-TUNED TASK MODELS:
  
  Claims-BERT-NER:
    Task: Named Entity Recognition
    Training: 50,000 annotated claims narratives
    Entities: 20+ custom entity types (see NER section)
    F1-Score: 0.89
    
  Claims-BERT-Classification:
    Task: Claim type / severity / routing classification
    Training: 200,000 labeled claims
    Accuracy: 93%
    
  Claims-BERT-Sentiment:
    Task: Sentiment analysis of correspondence
    Training: 30,000 annotated communications
    Accuracy: 87%
    
  Claims-BERT-Summarization:
    Task: Abstractive summarization of claims files
    Architecture: BART or T5 fine-tuned
    ROUGE-L: 0.45
    
  Claims-BERT-Similarity:
    Task: Similar claim retrieval
    Architecture: Sentence-BERT (bi-encoder)
    Recall@10: 0.82
```

### 6.3 GANs for Synthetic Data

```
APPLICATION: Generating Synthetic Claims Data for Model Training

CHALLENGE: Insufficient labeled fraud cases for supervised learning

SOLUTION: Use GANs to augment minority class (fraud) data

ARCHITECTURE:
  Generator: 
    Input: Random noise vector (z ~ N(0,1), dim=100)
    Architecture: 4-layer MLP (100 → 256 → 512 → 256 → n_features)
    Output: Synthetic fraud claim feature vector
    
  Discriminator:
    Input: Real or synthetic claim feature vector
    Architecture: 4-layer MLP (n_features → 256 → 128 → 64 → 1)
    Output: Probability of being a real fraud case

TRAINING:
  - Train on real fraud cases (minority class)
  - Generate synthetic fraud cases to balance dataset
  - Validate synthetic data quality: statistical similarity tests
  - Use combined (real + synthetic) dataset for fraud model training
  
RESULTS:
  - Fraud detection F1 improved from 0.62 to 0.74
  - Particularly effective for rare fraud types (staged accidents, arson)
  
CAUTIONS:
  - Monitor for mode collapse
  - Validate synthetic data does not introduce unrealistic patterns
  - Regulatory review of synthetic data use in decision-making
```

---

## 7. Feature Engineering for Claims ML

### 7.1 Comprehensive Feature Catalog (200+ Features)

#### Claim-Level Features (1–50)

| # | Feature Name | Type | Description |
|---|-------------|------|-------------|
| 1 | `claim_type` | Categorical | Type of claim (collision, comp, property, etc.) |
| 2 | `lob` | Categorical | Line of business |
| 3 | `loss_cause_code` | Categorical | Cause of loss code |
| 4 | `loss_state` | Categorical | State where loss occurred |
| 5 | `loss_county` | Categorical | County of loss |
| 6 | `loss_zip` | Categorical | ZIP code of loss |
| 7 | `date_of_loss` | Date | Date loss occurred |
| 8 | `time_of_loss` | Time | Time loss occurred |
| 9 | `day_of_week_loss` | Categorical | Day of week of loss |
| 10 | `month_of_loss` | Numeric | Month of loss |
| 11 | `is_weekend_loss` | Binary | Loss on weekend |
| 12 | `is_holiday_loss` | Binary | Loss on/near holiday |
| 13 | `date_reported` | Date | Date claim reported |
| 14 | `days_to_report` | Numeric | Days between loss and report |
| 15 | `reporting_channel` | Categorical | How claim was reported (phone, web, app) |
| 16 | `reporter_type` | Categorical | Who reported (insured, agent, third party) |
| 17 | `claimed_amount` | Numeric | Initial claimed amount |
| 18 | `claimed_amount_log` | Numeric | Log-transformed claimed amount |
| 19 | `number_of_claimants` | Numeric | Count of claimants |
| 20 | `number_of_vehicles` | Numeric | Number of vehicles involved |
| 21 | `has_bodily_injury` | Binary | Any bodily injury reported |
| 22 | `injury_count` | Numeric | Number of injured parties |
| 23 | `max_injury_severity` | Ordinal | Highest injury severity |
| 24 | `has_fatality` | Binary | Any fatality involved |
| 25 | `has_pedestrian` | Binary | Pedestrian involved |
| 26 | `has_police_report` | Binary | Police report filed |
| 27 | `has_witnesses` | Binary | Witnesses identified |
| 28 | `witness_count` | Numeric | Number of witnesses |
| 29 | `fault_indicator` | Categorical | Initial fault assessment |
| 30 | `attorney_at_fnol` | Binary | Attorney involved at FNOL |
| 31 | `loss_description_length` | Numeric | Character count of narrative |
| 32 | `loss_description_word_count` | Numeric | Word count of narrative |
| 33 | `narrative_sentiment_score` | Numeric | Sentiment analysis score |
| 34 | `narrative_consistency_score` | Numeric | Internal consistency score |
| 35 | `photo_count_at_fnol` | Numeric | Photos submitted at FNOL |
| 36 | `document_count` | Numeric | Documents at FNOL |
| 37 | `is_catastrophe_event` | Binary | Part of declared CAT |
| 38 | `cat_event_id` | Categorical | CAT event identifier |
| 39 | `weather_at_loss` | Categorical | Weather conditions |
| 40 | `road_conditions` | Categorical | Road conditions |
| 41 | `lighting_conditions` | Categorical | Lighting at time of loss |
| 42 | `speed_at_impact` | Numeric | Estimated speed (if available) |
| 43 | `intersection_indicator` | Binary | Occurred at intersection |
| 44 | `parking_lot_indicator` | Binary | Occurred in parking lot |
| 45 | `highway_indicator` | Binary | Occurred on highway |
| 46 | `multi_vehicle_indicator` | Binary | More than 2 vehicles |
| 47 | `damage_area_primary` | Categorical | Primary damage area code |
| 48 | `damage_severity_initial` | Ordinal | Initial damage assessment |
| 49 | `airbag_deployed` | Binary | Airbag deployment indicated |
| 50 | `vehicle_towed` | Binary | Vehicle towed from scene |

#### Policy & Insured Features (51–100)

| # | Feature Name | Type | Description |
|---|-------------|------|-------------|
| 51 | `policy_tenure_days` | Numeric | Days since first policy with carrier |
| 52 | `policy_age_days` | Numeric | Days since current policy inception |
| 53 | `policy_term` | Categorical | Policy term (6-mo, 12-mo) |
| 54 | `days_since_inception` | Numeric | Days from inception to loss |
| 55 | `days_to_expiration` | Numeric | Days from loss to expiration |
| 56 | `premium_amount` | Numeric | Current premium |
| 57 | `premium_tier` | Ordinal | Premium tier/segment |
| 58 | `payment_history_score` | Numeric | Premium payment history score |
| 59 | `coverage_limit_bi` | Numeric | BI coverage limit |
| 60 | `coverage_limit_pd` | Numeric | PD coverage limit |
| 61 | `coverage_limit_comp` | Numeric | Comprehensive limit |
| 62 | `coverage_limit_coll` | Numeric | Collision limit |
| 63 | `deductible_amount` | Numeric | Applicable deductible |
| 64 | `has_um_uim_coverage` | Binary | UM/UIM coverage exists |
| 65 | `has_med_pay_pip` | Binary | Med pay/PIP coverage |
| 66 | `has_rental_coverage` | Binary | Rental coverage |
| 67 | `has_towing_coverage` | Binary | Towing coverage |
| 68 | `coverage_change_recent` | Binary | Coverage changed in 90 days |
| 69 | `coverage_increase_recent` | Binary | Coverage increased in 90 days |
| 70 | `named_driver_count` | Numeric | Named drivers on policy |
| 71 | `youthful_driver_indicator` | Binary | Driver under 25 |
| 72 | `insured_age` | Numeric | Age of named insured |
| 73 | `insured_gender` | Categorical | Gender of insured |
| 74 | `insured_marital_status` | Categorical | Marital status |
| 75 | `insured_credit_score_band` | Ordinal | Credit-based insurance score band |
| 76 | `insured_education` | Categorical | Education level |
| 77 | `insured_occupation` | Categorical | Occupation category |
| 78 | `insured_years_licensed` | Numeric | Years since first licensed |
| 79 | `insured_violations_3yr` | Numeric | Violations in 3 years |
| 80 | `insured_at_fault_accidents_5yr` | Numeric | At-fault accidents in 5 years |
| 81 | `prior_claims_count_3yr` | Numeric | Prior claims in 3 years |
| 82 | `prior_claims_count_5yr` | Numeric | Prior claims in 5 years |
| 83 | `prior_claims_total_paid` | Numeric | Total paid on prior claims |
| 84 | `prior_fraud_referral` | Binary | Prior SIU referral |
| 85 | `vehicle_year` | Numeric | Vehicle model year |
| 86 | `vehicle_age` | Numeric | Age of vehicle at loss |
| 87 | `vehicle_make` | Categorical | Vehicle make |
| 88 | `vehicle_model` | Categorical | Vehicle model |
| 89 | `vehicle_body_type` | Categorical | Body type (sedan, SUV, truck) |
| 90 | `vehicle_value_acv` | Numeric | Actual cash value |
| 91 | `vehicle_mileage` | Numeric | Odometer reading |
| 92 | `vehicle_use` | Categorical | Vehicle use (pleasure, commute, business) |
| 93 | `vehicle_safety_rating` | Ordinal | NHTSA safety rating |
| 94 | `vehicle_theft_rank` | Ordinal | NICB theft ranking |
| 95 | `has_lienholder` | Binary | Lienholder on vehicle |
| 96 | `multi_policy_indicator` | Binary | Multiple policies with carrier |
| 97 | `agent_type` | Categorical | Captive vs independent agent |
| 98 | `distribution_channel` | Categorical | Direct, agent, digital |
| 99 | `garaging_state` | Categorical | Vehicle garaging state |
| 100 | `garaging_zip` | Categorical | Vehicle garaging ZIP |

#### External & Derived Features (101–150)

| # | Feature Name | Type | Description |
|---|-------------|------|-------------|
| 101 | `zip_median_income` | Numeric | Median household income of loss ZIP |
| 102 | `zip_population_density` | Numeric | Population density of loss ZIP |
| 103 | `zip_crime_index` | Numeric | Crime index of loss ZIP |
| 104 | `county_litigation_rate` | Numeric | Historical litigation rate |
| 105 | `county_avg_settlement` | Numeric | Average settlement in county |
| 106 | `state_no_fault_flag` | Binary | No-fault state indicator |
| 107 | `state_comparative_neg` | Binary | Comparative negligence state |
| 108 | `state_contributory_neg` | Binary | Contributory negligence state |
| 109 | `weather_severity_score` | Numeric | Weather severity at loss time |
| 110 | `temperature_at_loss` | Numeric | Temperature at loss time |
| 111 | `precipitation_at_loss` | Numeric | Precipitation at loss time |
| 112 | `visibility_at_loss` | Numeric | Visibility at loss time |
| 113 | `traffic_density_score` | Numeric | Traffic density at loss location |
| 114 | `road_type_score` | Numeric | Road type risk score |
| 115 | `distance_from_home` | Numeric | Distance from home to loss location |
| 116 | `iso_claimsearch_matches` | Numeric | ISO ClaimSearch match count |
| 117 | `iso_claimsearch_same_type` | Numeric | Same-type matches |
| 118 | `nicb_alert_flag` | Binary | NICB alert on vehicle/person |
| 119 | `medical_cost_index_area` | Numeric | Medical cost index for area |
| 120 | `repair_cost_index_area` | Numeric | Auto repair cost index for area |
| 121 | `claimed_to_vehicle_value_ratio` | Numeric | claimed_amount / vehicle_ACV |
| 122 | `claimed_to_limit_ratio` | Numeric | claimed_amount / coverage_limit |
| 123 | `deductible_to_claimed_ratio` | Numeric | deductible / claimed_amount |
| 124 | `claim_frequency_policy` | Numeric | Claims per policy year |
| 125 | `days_since_last_claim` | Numeric | Days since prior claim |
| 126 | `same_claimant_prior_12mo` | Numeric | Same claimant claims in 12 months |
| 127 | `same_loss_type_prior_24mo` | Binary | Same loss type in 24 months |
| 128 | `inception_to_loss_ratio` | Numeric | policy_age / policy_term |
| 129 | `premium_to_claim_ratio` | Numeric | annual_premium / claimed_amount |
| 130 | `vehicle_age_to_value_ratio` | Numeric | vehicle_age / vehicle_ACV |
| 131 | `narrative_fraud_score` | Numeric | NLP-derived fraud indicators |
| 132 | `photo_damage_score` | Numeric | CV-derived damage assessment |
| 133 | `photo_consistency_score` | Numeric | Photo consistency with narrative |
| 134 | `address_verification_score` | Numeric | Address verification result |
| 135 | `phone_verification_score` | Numeric | Phone number verification |
| 136 | `email_risk_score` | Numeric | Email address risk scoring |
| 137 | `device_risk_score` | Numeric | Device fingerprint risk |
| 138 | `ip_risk_score` | Numeric | IP address risk scoring |
| 139 | `velocity_fnol_24hr` | Numeric | FNOL submissions from same device/IP in 24hr |
| 140 | `social_network_connections` | Numeric | SNA connections to flagged entities |
| 141 | `provider_fraud_score` | Numeric | Service provider fraud risk |
| 142 | `provider_claim_volume` | Numeric | Provider claim volume vs peers |
| 143 | `provider_avg_charge` | Numeric | Provider avg charge vs peers |
| 144 | `telematics_available` | Binary | Telematics data available |
| 145 | `telematics_speed_at_impact` | Numeric | Speed from telematics |
| 146 | `telematics_harsh_braking` | Binary | Hard braking event detected |
| 147 | `telematics_impact_severity` | Numeric | Impact G-force |
| 148 | `telematics_confirms_accident` | Binary | Telematics confirms event |
| 149 | `days_to_first_treatment` | Numeric | Days from loss to first medical |
| 150 | `treatment_gap_days` | Numeric | Max gap in treatment days |

#### Model-Specific Features (151–200+)

| # | Feature Name | Type | Description |
|---|-------------|------|-------------|
| 151 | `fraud_rule_hit_count` | Numeric | Number of fraud rules triggered |
| 152 | `fraud_composite_score` | Numeric | Weighted fraud score |
| 153 | `severity_model_score` | Numeric | ML severity prediction |
| 154 | `litigation_model_score` | Numeric | ML litigation probability |
| 155 | `subrogation_model_score` | Numeric | ML subrogation probability |
| 156 | `total_loss_model_score` | Numeric | ML total loss probability |
| 157 | `reserve_model_prediction` | Numeric | ML reserve prediction |
| 158 | `triage_model_score` | Numeric | ML triage/complexity score |
| 159 | `claim_to_similar_avg_ratio` | Numeric | Claim vs similar claims avg |
| 160 | `adjuster_experience_years` | Numeric | Assigned adjuster experience |
| 161 | `adjuster_avg_cycle_time` | Numeric | Adjuster avg cycle time |
| 162 | `adjuster_avg_severity` | Numeric | Adjuster avg claim cost |
| 163 | `adjuster_closure_rate` | Numeric | Adjuster claims/month |
| 164 | `adjuster_caseload_current` | Numeric | Current open caseload |
| 165 | `is_rush_hour` | Binary | Loss during rush hour |
| 166 | `is_school_zone` | Binary | Loss in school zone |
| 167 | `intersection_traffic_control` | Categorical | Signal, stop sign, none |
| 168 | `seatbelt_use` | Binary | Seatbelt use at loss |
| 169 | `child_involved` | Binary | Minor child involved |
| 170 | `commercial_vehicle_involved` | Binary | Commercial vehicle involved |
| 171 | `government_vehicle_involved` | Binary | Government vehicle involved |
| 172 | `emergency_vehicle_involved` | Binary | Emergency vehicle involved |
| 173 | `dui_indicator` | Binary | DUI/DWI involved |
| 174 | `hit_and_run_indicator` | Binary | Hit and run reported |
| 175 | `rental_vehicle_involved` | Binary | Rental vehicle involved |
| 176 | `rideshare_indicator` | Binary | Rideshare vehicle involved |
| 177 | `construction_zone` | Binary | Loss in construction zone |
| 178 | `animal_involved` | Binary | Animal involved |
| 179 | `property_type` | Categorical | SFR, condo, townhome, apartment |
| 180 | `property_age_years` | Numeric | Age of property |
| 181 | `property_value` | Numeric | Property assessed value |
| 182 | `roof_age_years` | Numeric | Age of roof |
| 183 | `roof_type` | Categorical | Shingle, tile, metal, flat |
| 184 | `property_protection_class` | Ordinal | Fire protection class |
| 185 | `distance_to_fire_station` | Numeric | Miles to nearest fire station |
| 186 | `flood_zone` | Categorical | FEMA flood zone |
| 187 | `coastal_indicator` | Binary | Coastal property |
| 188 | `hoa_indicator` | Binary | HOA property |
| 189 | `prior_property_claims` | Numeric | Prior property claims on address |
| 190 | `wc_employer_size` | Categorical | Small/medium/large employer |
| 191 | `wc_industry_class` | Categorical | Industry classification |
| 192 | `wc_class_code` | Categorical | Workers comp class code |
| 193 | `wc_experience_mod` | Numeric | Experience modification factor |
| 194 | `wc_injury_body_part` | Categorical | Injured body part |
| 195 | `wc_nature_of_injury` | Categorical | Nature of injury code |
| 196 | `wc_cause_of_injury` | Categorical | Cause of injury code |
| 197 | `employee_tenure_years` | Numeric | Employee tenure at employer |
| 198 | `employee_age` | Numeric | Employee age |
| 199 | `employee_wage` | Numeric | Employee weekly wage |
| 200 | `monday_claim_indicator` | Binary | Claim reported on Monday (WC) |
| 201 | `embedding_loss_narrative` | Vector | BERT embedding of loss narrative |
| 202 | `embedding_medical_summary` | Vector | BERT embedding of medical summary |
| 203 | `photo_embedding` | Vector | CNN embedding of damage photos |

---

## 8. Training Data & Data Pipeline Design

### 8.1 Training Data Requirements

| Model | Min Records | Ideal Records | Label Source | Update Freq |
|-------|-----------|---------------|-------------|-------------|
| Fraud Detection | 50,000 (5,000 fraud) | 500,000+ | SIU confirmed cases | Quarterly |
| Severity Prediction | 100,000 | 1,000,000+ | Closed claim incurred | Quarterly |
| Litigation Prediction | 50,000 (10,000 litigated) | 200,000+ | Litigation outcome | Semi-annual |
| Damage Estimation (CV) | 100,000 images | 500,000+ images | Estimate matched | Monthly |
| Document Classification | 10,000 per class | 50,000+ per class | Manual labels | Quarterly |
| NER | 20,000 annotated docs | 100,000+ | Manual annotation | Semi-annual |
| Reserve Prediction | 100,000 | 500,000+ | Final incurred | Quarterly |
| Triage Scoring | 50,000 | 200,000+ | Outcome-based labels | Quarterly |

### 8.2 Data Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                      ML DATA PIPELINE                                │
│                                                                      │
│  ┌──────────────┐                                                   │
│  │ SOURCE       │                                                   │
│  │ SYSTEMS      │                                                   │
│  │              │                                                   │
│  │ - Claims DB  │    ┌──────────────┐    ┌──────────────────┐      │
│  │ - Policy DB  │───▶│ Ingestion    │───▶│ Raw Data Lake    │      │
│  │ - Billing DB │    │ Layer        │    │ (S3/ADLS)        │      │
│  │ - Documents  │    │ (Kafka/      │    │                  │      │
│  │ - Photos     │    │  Spark)      │    │ Partitioned by:  │      │
│  │ - External   │    └──────────────┘    │ - Source         │      │
│  │   APIs       │                        │ - Date           │      │
│  └──────────────┘                        │ - LOB            │      │
│                                          └────────┬─────────┘      │
│                                                   │                 │
│                                          ┌────────▼─────────┐      │
│                                          │ Feature          │      │
│                                          │ Engineering      │      │
│                                          │ Pipeline         │      │
│                                          │ (Spark/dbt)      │      │
│                                          │                  │      │
│                                          │ - Cleaning       │      │
│                                          │ - Transformation │      │
│                                          │ - Aggregation    │      │
│                                          │ - Encoding       │      │
│                                          │ - Imputation     │      │
│                                          └────────┬─────────┘      │
│                                                   │                 │
│                                          ┌────────▼─────────┐      │
│                                          │ Feature Store    │      │
│                                          │ (Feast/Tecton)   │      │
│                                          │                  │      │
│                                          │ - Online (Redis) │      │
│                                          │ - Offline (S3)   │      │
│                                          │ - Versioned      │      │
│                                          │ - Discoverable   │      │
│                                          └────────┬─────────┘      │
│                                                   │                 │
│                         ┌─────────────────────────┼────────┐       │
│                         │                         │        │       │
│                         ▼                         ▼        ▼       │
│                  ┌──────────────┐  ┌──────────┐  ┌──────────┐     │
│                  │ Training     │  │ Batch    │  │ Online   │     │
│                  │ Pipeline     │  │ Scoring  │  │ Scoring  │     │
│                  │ (SageMaker/  │  │ (Spark)  │  │ (API)    │     │
│                  │  MLflow)     │  │          │  │          │     │
│                  └──────────────┘  └──────────┘  └──────────┘     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.3 Data Quality Framework

```
DATA QUALITY CHECKS:

  Completeness:
    - Feature null rate < 5% for critical features
    - Feature null rate < 20% for optional features
    - Record completeness score per claim
    
  Accuracy:
    - Cross-validation against source systems
    - Range checks for numeric features
    - Referential integrity checks
    - Date logic validation (DOL < report date < close date)
    
  Consistency:
    - Cross-feature consistency (e.g., total_loss=true → reserve > threshold)
    - Temporal consistency (features don't change unexpectedly)
    - Cross-system consistency (policy vs claim data)
    
  Timeliness:
    - Data freshness < 24 hours for training
    - Data freshness < 1 hour for online features
    - Stale feature detection and alerting
    
  Distribution Monitoring:
    - Feature distribution drift detection (KL divergence, PSI)
    - Label distribution monitoring
    - Outlier detection (IQR method, Z-score)
```

---

## 9. Model Deployment Architecture (MLOps)

### 9.1 MLOps Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│                         MLOps LIFECYCLE                               │
│                                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │ Feature  │  │ Model    │  │ Model    │  │ Model    │           │
│  │ Engineer │─▶│ Training │─▶│ Evaluat. │─▶│ Registry │           │
│  │          │  │          │  │ & Valid. │  │          │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                                                   │                  │
│                                          ┌────────▼─────────┐      │
│                                          │ Model Approval   │      │
│                                          │ (Human Review)   │      │
│                                          └────────┬─────────┘      │
│                                                   │                  │
│                                          ┌────────▼─────────┐      │
│                                          │ Deployment       │      │
│                                          │ (Canary/Blue-    │      │
│                                          │  Green)          │      │
│                                          └────────┬─────────┘      │
│                                                   │                  │
│                                          ┌────────▼─────────┐      │
│                                          │ Monitoring &     │      │
│                                          │ Drift Detection  │      │
│                                          └────────┬─────────┘      │
│                                                   │                  │
│                                          [Drift Detected?]          │
│                                          ┌────────┴─────────┐      │
│                                         YES               NO       │
│                                          │                 │        │
│                                          ▼                 │        │
│                                    ┌──────────┐   Continue │        │
│                                    │ Retrain  │   Monitoring│       │
│                                    │ Trigger  │            │        │
│                                    └──────────┘            │        │
│                                                             │        │
└─────────────────────────────────────────────────────────────────────┘
```

### 9.2 Model Registry Schema

```sql
CREATE TABLE model_registry (
    model_id          UUID PRIMARY KEY,
    model_name        VARCHAR(100) NOT NULL,
    model_version     VARCHAR(20) NOT NULL,
    model_type        VARCHAR(50) NOT NULL,
    algorithm         VARCHAR(100) NOT NULL,
    framework         VARCHAR(50) NOT NULL,
    artifact_path     VARCHAR(500) NOT NULL,
    training_dataset  VARCHAR(200) NOT NULL,
    training_date     TIMESTAMP NOT NULL,
    training_metrics  JSONB NOT NULL,
    validation_metrics JSONB NOT NULL,
    feature_set       VARCHAR(100) NOT NULL,
    feature_count     INTEGER NOT NULL,
    hyperparameters   JSONB,
    status            VARCHAR(20) NOT NULL DEFAULT 'STAGING',
    deployed_at       TIMESTAMP,
    retired_at        TIMESTAMP,
    approved_by       VARCHAR(50),
    approval_date     TIMESTAMP,
    created_by        VARCHAR(50) NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(model_name, model_version)
);

CREATE TABLE model_deployment (
    deployment_id     UUID PRIMARY KEY,
    model_id          UUID REFERENCES model_registry(model_id),
    environment       VARCHAR(20) NOT NULL,
    endpoint_name     VARCHAR(100) NOT NULL,
    endpoint_url      VARCHAR(500),
    traffic_percentage DECIMAL(5,2) DEFAULT 100.00,
    deployment_type   VARCHAR(20) NOT NULL,
    status            VARCHAR(20) NOT NULL,
    deployed_at       TIMESTAMP NOT NULL,
    retired_at        TIMESTAMP,
    instance_type     VARCHAR(50),
    instance_count    INTEGER
);

CREATE TABLE model_prediction_log (
    prediction_id     UUID PRIMARY KEY,
    model_id          UUID NOT NULL,
    model_version     VARCHAR(20) NOT NULL,
    claim_id          VARCHAR(20) NOT NULL,
    prediction_timestamp TIMESTAMP NOT NULL,
    input_features    JSONB NOT NULL,
    prediction_output JSONB NOT NULL,
    confidence_score  DECIMAL(5,4),
    latency_ms        INTEGER NOT NULL,
    actual_outcome    JSONB,
    outcome_date      TIMESTAMP,
    feedback_received BOOLEAN DEFAULT FALSE
);
```

---

## 10. A/B Testing & Champion-Challenger

### 10.1 Champion-Challenger Framework

```
┌─────────────────────────────────────────────────────────────────┐
│              CHAMPION-CHALLENGER FRAMEWORK                       │
│                                                                  │
│  Incoming Claims                                                │
│       │                                                         │
│       ▼                                                         │
│  ┌──────────────────┐                                          │
│  │   Traffic Router  │                                          │
│  │   (Feature Flag)  │                                          │
│  └────────┬─────────┘                                          │
│           │                                                     │
│     ┌─────┴──────────────────────┐                             │
│     │                            │                              │
│     ▼ (90% traffic)              ▼ (10% traffic)               │
│  ┌──────────────┐         ┌──────────────┐                     │
│  │  CHAMPION    │         │  CHALLENGER  │                     │
│  │  Model v2.3  │         │  Model v2.4  │                     │
│  │              │         │              │                     │
│  │  XGBoost     │         │  LightGBM    │                     │
│  │  AUC: 0.91   │         │  AUC: 0.93   │                     │
│  └──────┬───────┘         └──────┬───────┘                     │
│         │                        │                              │
│         └────────┬───────────────┘                              │
│                  │                                               │
│         ┌────────▼────────┐                                     │
│         │  Both scores    │                                     │
│         │  logged for     │                                     │
│         │  comparison     │                                     │
│         └────────┬────────┘                                     │
│                  │                                               │
│         ┌────────▼────────┐                                     │
│         │  Only routed    │                                     │
│         │  model score    │                                     │
│         │  used for       │                                     │
│         │  decision       │                                     │
│         └─────────────────┘                                     │
│                                                                  │
│  PROMOTION CRITERIA:                                            │
│  1. Challenger AUC > Champion AUC by >= 2% (stat significant)  │
│  2. Challenger false positive rate <= Champion                  │
│  3. Minimum 30-day evaluation period                           │
│  4. Minimum 5,000 scored claims                                │
│  5. No adverse impact on protected classes                     │
│  6. Regulatory review completed                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 11. Explainable AI (XAI)

### 11.1 XAI Methods for Claims Models

| Method | Type | Use Case | Output |
|--------|------|----------|--------|
| **SHAP** | Model-agnostic | Feature importance per prediction | Shapley values per feature |
| **LIME** | Model-agnostic | Local explanation for single prediction | Simplified local model |
| **Partial Dependence** | Model-agnostic | Feature effect on outcome | PD plots |
| **Feature Importance** | Model-specific | Global feature ranking | Importance scores |
| **Attention Weights** | Model-specific | Transformer model focus | Attention heatmaps |
| **Grad-CAM** | Model-specific | CNN visual explanation | Heatmap on image |
| **Counterfactual** | Model-agnostic | "What if" scenarios | Minimal changes needed |
| **Decision Rules** | Model-agnostic | Human-readable rules | IF-THEN rules |

### 11.2 SHAP Implementation for Fraud Model

```python
# SHAP explanation for fraud prediction
import shap

# Trained XGBoost fraud model
model = xgb_fraud_model

# Create SHAP explainer
explainer = shap.TreeExplainer(model)

# Generate explanations for a single claim
claim_features = get_features(claim_id="CLM-2024-001234")
shap_values = explainer.shap_values(claim_features)

# Output explanation
"""
FRAUD PREDICTION EXPLANATION
Claim: CLM-2024-001234
Fraud Score: 0.78 (HIGH RISK)

Top Contributing Factors:
  +0.25  Policy inception < 30 days (Policy Age: 12 days)
  +0.18  Coverage increased recently (Limit doubled 3 weeks ago)
  +0.12  3 prior claims in 12 months
  +0.08  Friday evening loss (typical fraud pattern)
  +0.06  Claimed amount near vehicle value (ratio: 0.85)
  +0.05  Geographic anomaly (120 miles from home)
  -0.03  Long tenure with carrier (8 years)
  -0.02  No prior SIU referrals
  
Base fraud rate: 0.05
Final score: 0.78
"""
```

### 11.3 Grad-CAM for Damage Assessment

```
GRAD-CAM EXPLANATION FOR DAMAGE CV MODEL:

Input Image: Rear-end vehicle damage photo

Output:
  - Damage Detected: DENT (Moderate) on REAR_BUMPER
  - Confidence: 0.92
  - Estimated Cost: $1,850
  
  Grad-CAM Heatmap:
  ┌────────────────────────────────────────┐
  │                                        │
  │          Vehicle rear view             │
  │                                        │
  │    ┌──────────────────────┐            │
  │    │ ░░░░░░░░░░░░░░░░░░░ │  ← Low    │
  │    │ ░░░░████████░░░░░░░ │    attention│
  │    │ ░░████████████░░░░░ │            │
  │    │ ░░████████████████░ │  ← HIGH   │
  │    │ ░░░░████████████░░░ │    ATTENTION│
  │    │ ░░░░░░░░████░░░░░░░ │    (damage │
  │    └──────────────────────┘    region) │
  │                                        │
  └────────────────────────────────────────┘
  
  The model focused on the dented area of the rear bumper,
  with highest activation around the impact point and 
  deformation pattern.
```

---

## 12. Bias Detection & Fairness

### 12.1 Protected Attributes in Claims AI

| Attribute | Protected By | Claims Application Risk |
|-----------|-------------|----------------------|
| Race/Ethnicity | Federal/State law | ZIP code as proxy, name-based inference |
| Gender | Federal/State law | Vehicle type correlation, injury patterns |
| Age | State law (varies) | Driving patterns, injury severity correlation |
| Religion | Federal law | Holiday/day-of-week patterns |
| National Origin | Federal law | Name-based inference, language |
| Disability | ADA | WC claims patterns |
| Marital Status | State law (varies) | Household composition |
| Income/SES | Regulatory guidance | ZIP code, vehicle value as proxy |

### 12.2 Fairness Metrics

```
FAIRNESS EVALUATION FRAMEWORK:

For each protected group (g) vs reference group:

1. Demographic Parity:
   P(positive_outcome | group=g) ≈ P(positive_outcome | group=reference)
   Threshold: Ratio between 0.80 and 1.25 (4/5ths rule)

2. Equal Opportunity:
   P(positive_outcome | actual=positive, group=g) ≈ 
   P(positive_outcome | actual=positive, group=reference)
   Threshold: Difference < 0.05

3. Equalized Odds:
   Equal TPR and FPR across groups
   Threshold: Difference < 0.05

4. Predictive Parity:
   P(actual=positive | predicted=positive, group=g) ≈
   P(actual=positive | predicted=positive, group=reference)
   Threshold: Difference < 0.05

MONITORING REPORT:
┌──────────────────────────────────────────────────────────┐
│ FAIRNESS AUDIT: Fraud Detection Model v2.3               │
│ Date: 2024-03-15                                         │
│                                                           │
│ Protected Attribute: ZIP-Inferred Income Quartile         │
│                                                           │
│ Metric           │ Q1(Low) │ Q2     │ Q3     │ Q4(High)│
│ ─────────────────┼─────────┼────────┼────────┼─────────│
│ Referral Rate    │ 8.2%    │ 5.1%   │ 4.8%   │ 4.5%   │
│ False Pos Rate   │ 6.1%    │ 3.2%   │ 2.9%   │ 2.7%   │
│ True Pos Rate    │ 72%     │ 75%    │ 76%    │ 78%    │
│ Parity Ratio     │ 1.82    │ 1.13   │ 1.07   │ 1.00   │
│                                                           │
│ ⚠ ALERT: Q1 referral rate 1.82x Q4 (exceeds 1.25 limit)│
│ ACTION: Investigate ZIP-correlated features for bias      │
└──────────────────────────────────────────────────────────┘
```

---

## 13. Real-Time vs Batch Inference

### 13.1 Architecture Comparison

```
REAL-TIME INFERENCE                    BATCH INFERENCE
┌──────────────────────┐               ┌──────────────────────┐
│                      │               │                      │
│  Claim Event         │               │  Scheduled Job       │
│       │              │               │  (Daily/Weekly)      │
│       ▼              │               │       │              │
│  API Gateway         │               │       ▼              │
│       │              │               │  Spark Job           │
│       ▼              │               │       │              │
│  Feature Store       │               │       ▼              │
│  (Online - Redis)    │               │  Feature Store       │
│       │              │               │  (Offline - S3)      │
│       ▼              │               │       │              │
│  Model Endpoint      │               │       ▼              │
│  (SageMaker RT)      │               │  Model (Local)       │
│       │              │               │       │              │
│       ▼              │               │       ▼              │
│  Response (< 100ms)  │               │  Score Table         │
│                      │               │  (Written to DB)     │
│ USE FOR:             │               │                      │
│ - FNOL fraud score   │               │ USE FOR:             │
│ - STP eligibility    │               │ - Reserve re-scoring │
│ - Triage scoring     │               │ - Portfolio analysis │
│ - Damage estimation  │               │ - Model retraining   │
│                      │               │ - Reporting          │
│ LATENCY: < 100ms     │               │ LATENCY: Hours       │
│ THROUGHPUT: 1000/sec  │               │ THROUGHPUT: Millions │
│ COST: Higher         │               │ COST: Lower          │
│                      │               │                      │
└──────────────────────┘               └──────────────────────┘
```

### 13.2 Model Serving Patterns

| Pattern | Use Case | Technology | SLA |
|---------|----------|-----------|-----|
| Synchronous REST | FNOL fraud scoring | SageMaker Endpoint | < 100ms |
| Async Event-Driven | Document classification | Lambda + SQS | < 5 seconds |
| Batch ETL | Reserve re-scoring | Spark + S3 | < 4 hours |
| Streaming | Real-time anomaly detection | Kafka Streams + ONNX | < 500ms |
| Edge Inference | Mobile damage estimation | TFLite on device | < 2 seconds |

---

## 14. Computer Vision Pipeline for Auto Damage

### 14.1 End-to-End Pipeline

```
STEP 1: IMAGE INGESTION
  ├─ Source: Mobile app, web upload, vendor portal, email
  ├─ Supported formats: JPEG, PNG, HEIC, RAW
  ├─ Min resolution: 1280x960 (1.2MP)
  ├─ Store raw images in S3 with claim_id prefix
  └─ Generate thumbnail for UI display

STEP 2: QUALITY CHECK (< 1 second)
  ├─ Blur detection (Laplacian variance > 100)
  ├─ Brightness check (40 < mean < 220)
  ├─ Resolution check (>= 1280x960)
  ├─ Vehicle presence detection (YOLO confidence > 0.90)
  ├─ Damage visibility check (damage detector confidence > 0.70)
  ├─ Duplicate image detection (perceptual hash comparison)
  └─ IF quality_fail: return feedback to user with guidance

STEP 3: VEHICLE IDENTIFICATION (< 2 seconds)
  ├─ Make/Model classification (CNN → 200+ classes, top-3 accuracy: 96%)
  ├─ Color detection (HSV analysis → 15 standard colors)
  ├─ Year estimation (regression model, ±2 years accuracy: 85%)
  ├─ VIN extraction from photos if visible (OCR)
  ├─ Cross-reference with policy vehicle data
  └─ IF mismatch: flag for manual review

STEP 4: DAMAGE DETECTION & LOCALIZATION (< 3 seconds)
  ├─ Object detection: Faster R-CNN / YOLO v5
  ├─ Detect damage regions with bounding boxes
  ├─ Multi-label classification per region:
  │   ├─ Damage type: dent, scratch, crack, break, misalign
  │   ├─ Severity: minor, moderate, severe
  │   └─ Confidence score per label
  ├─ Panel mapping: Map damage regions to vehicle panels
  └─ Semantic segmentation: Mask R-CNN for pixel-level damage area

STEP 5: SEVERITY CLASSIFICATION (< 1 second)
  ├─ Per-panel severity scoring (0-100)
  ├─ Overall vehicle damage severity
  ├─ Structural damage indicator
  ├─ Airbag deployment detection
  ├─ Total loss probability
  └─ Drivability assessment

STEP 6: COST ESTIMATION (< 2 seconds)
  ├─ Map damage to repair operations (CCC/Mitchell labor times)
  ├─ Parts lookup: OEM vs aftermarket pricing
  ├─ Labor rate: market rate for loss location ZIP
  ├─ Paint/materials estimate
  ├─ Supplement probability
  ├─ Total estimate with confidence interval
  └─ Compare to historical similar claims

TOTAL PIPELINE TIME: < 10 seconds per image set
```

---

## 15. NLP Pipeline for Claims

### 15.1 End-to-End NLP Pipeline

```
STEP 1: TEXT INGESTION
  ├─ Sources: FNOL narrative, adjuster notes, correspondence,
  │           medical records, police reports, depositions
  ├─ Format handling: Plain text, PDF, DOCX, email
  ├─ OCR if scanned document
  └─ Language detection (support multi-language)

STEP 2: TEXT PRE-PROCESSING
  ├─ Sentence segmentation
  ├─ Tokenization (WordPiece for BERT models)
  ├─ Named Entity Recognition (custom Claims-BERT-NER)
  ├─ Part-of-Speech tagging
  ├─ Dependency parsing
  └─ Coreference resolution

STEP 3: ENTITY EXTRACTION
  ├─ Persons: claimants, witnesses, officers, providers
  ├─ Vehicles: make, model, year, color, VIN, plate
  ├─ Locations: addresses, intersections, landmarks
  ├─ Dates/Times: loss date, treatment dates, report dates
  ├─ Money: amounts, limits, deductibles
  ├─ Medical: diagnosis codes, procedures, body parts, medications
  ├─ Legal: case numbers, attorney names, court venues
  └─ Insurance: policy numbers, claim numbers, coverage types

STEP 4: CLASSIFICATION
  ├─ Loss cause classification (30+ categories)
  ├─ Severity classification (Low/Medium/High/Severe)
  ├─ Liability indicator (At-fault/Not-at-fault/Shared/Unknown)
  ├─ Coverage type mapping
  ├─ Fraud narrative indicators
  └─ Sentiment / urgency scoring

STEP 5: SUMMARIZATION
  ├─ Extractive: Key sentences from claims file
  ├─ Abstractive: Generated summary using BART/T5
  ├─ Domain-specific template filling
  └─ Timeline generation from extracted events

STEP 6: ROUTING & TRIGGERS
  ├─ Auto-assign based on extracted claim attributes
  ├─ Trigger fraud scoring if suspicious indicators
  ├─ Trigger subrogation if third-party indicators
  ├─ Flag if attorney involvement detected
  └─ Generate follow-up tasks from extracted action items
```

---

## 16. Conversational AI for FNOL

### 16.1 Dialog Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  CONVERSATIONAL AI FNOL SYSTEM                   │
│                                                                  │
│  ┌──────────────┐                                               │
│  │ Channel      │  Voice (IVR/Phone)                            │
│  │ Adapter      │  Chat (Web/App/SMS)                           │
│  │              │  Messaging (WhatsApp/FB)                       │
│  └──────┬───────┘                                               │
│         │                                                        │
│  ┌──────▼───────┐                                               │
│  │ ASR / STT    │  (Voice only: Speech-to-Text)                │
│  │ (Whisper/    │                                               │
│  │  Google STT) │                                               │
│  └──────┬───────┘                                               │
│         │                                                        │
│  ┌──────▼───────┐                                               │
│  │ NLU Engine   │                                               │
│  │              │                                               │
│  │ Intent       │  Intents: REPORT_CLAIM, CHECK_STATUS,        │
│  │ Recognition  │          ADD_INFO, ASK_QUESTION,              │
│  │              │          ESCALATE, CANCEL                      │
│  │ Slot Filling │  Slots: policy_number, date_of_loss,         │
│  │              │         loss_type, vehicle_info,              │
│  │              │         injury_info, location, etc.           │
│  └──────┬───────┘                                               │
│         │                                                        │
│  ┌──────▼───────┐                                               │
│  │ Dialog       │                                               │
│  │ Manager      │  State machine + ML-based policy              │
│  │              │                                               │
│  │ ┌──────────┐ │                                               │
│  │ │ Dialog   │ │  Tracks conversation state,                   │
│  │ │ State    │ │  manages slot filling,                        │
│  │ │ Tracker  │ │  handles clarification                        │
│  │ └──────────┘ │                                               │
│  │ ┌──────────┐ │                                               │
│  │ │ Policy   │ │  Determines next action:                      │
│  │ │ Network  │ │  ask, confirm, clarify, escalate              │
│  │ └──────────┘ │                                               │
│  └──────┬───────┘                                               │
│         │                                                        │
│  ┌──────▼───────┐                                               │
│  │ Response     │                                               │
│  │ Generator    │  Template-based + LLM-assisted                │
│  │ (NLG)        │                                               │
│  └──────┬───────┘                                               │
│         │                                                        │
│  ┌──────▼───────┐                                               │
│  │ TTS          │  (Voice only: Text-to-Speech)                │
│  │ (Neural TTS) │                                               │
│  └──────────────┘                                               │
│                                                                  │
│  BACKEND INTEGRATIONS:                                          │
│  ├─ Policy System (verification)                                │
│  ├─ Claims System (claim creation)                              │
│  ├─ Photo Upload (damage photos via link)                       │
│  ├─ Vendor Assignment (tow/glass dispatch)                      │
│  └─ Agent Handoff (escalation with context)                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 16.2 Intent & Slot Schema

```
INTENT: REPORT_AUTO_CLAIM
  Required Slots:
    - policy_number (or name + DOB for lookup)
    - date_of_loss
    - loss_type (collision, comp, theft, etc.)
    - loss_location
    - loss_description
    - vehicle_involved (if multiple on policy)
    - any_injuries (yes/no)
    - drivable (yes/no)
    - police_report_filed (yes/no)
    
  Optional Slots:
    - time_of_loss
    - other_vehicle_info
    - other_driver_info
    - witness_info
    - injury_description
    - police_report_number
    - tow_needed (yes/no)
    - rental_needed (yes/no)
    - photos_available (yes/no)

ESCALATION TRIGGERS:
  - User requests human agent
  - Severe injury reported (hospitalization, fatality)
  - Attorney involvement mentioned
  - 3 consecutive NLU low-confidence turns
  - Coverage issue detected
  - Fraud indicators in narrative
  - Emotional distress detected (sentiment < -0.7)
  - Session timeout (> 15 minutes)
```

---

## 17. Claims Triage Scoring Model

### 17.1 Model Design

```
MODEL: Claims Triage Scoring

OBJECTIVE: Score claims at FNOL for complexity and optimal handling path

ALGORITHM: Gradient Boosted Trees (LightGBM)

TARGET: Composite triage score (0-100) with tier mapping

FEATURE GROUPS:
  1. Claim Characteristics (20 features)
  2. Policy/Insured History (15 features)
  3. Injury/Damage Indicators (15 features)
  4. External Risk Factors (10 features)
  5. NLP-Derived Features (5 features)
  6. Fraud Score (1 feature)

TRIAGE TIERS:
  Score 0-20:   TIER 1 - Simple (STP candidate)
  Score 21-40:  TIER 2 - Standard (desk adjuster)
  Score 41-60:  TIER 3 - Moderate (experienced adjuster)
  Score 61-80:  TIER 4 - Complex (senior adjuster)
  Score 81-100: TIER 5 - Severe (complex claims unit)

TRAINING:
  - Labels: Expert adjuster retrospective scoring
  - 200,000 closed claims with outcome-based complexity
  - Cross-validation: 5-fold temporal CV
  - Optimization: Weighted MAE (higher weight on severe under-prediction)
```

### 17.2 Triage Output & Assignment

```json
{
  "claim_id": "CLM-2024-001234",
  "triage_score": 72,
  "triage_tier": "TIER_4",
  "tier_description": "Complex - Senior Adjuster Required",
  "score_components": {
    "claim_complexity": 25,
    "injury_severity": 20,
    "litigation_risk": 15,
    "fraud_risk": 7,
    "coverage_complexity": 5
  },
  "recommended_assignment": {
    "handler_type": "SENIOR_ADJUSTER",
    "specialization": "AUTO_BI",
    "experience_min_years": 5,
    "authority_level": "LEVEL_3"
  },
  "key_flags": [
    "Attorney involvement at FNOL",
    "Cervical injury with ER visit",
    "High litigation venue (Cook County)",
    "Multiple claimants (3)"
  ],
  "predicted_outcomes": {
    "estimated_incurred": {"p50": 45000, "p75": 85000},
    "litigation_probability": 0.65,
    "estimated_duration_days": 180,
    "total_loss_probability": 0.12
  }
}
```

---

## 18. Litigation Prediction Model

### 18.1 Detailed Model Architecture

```
MODEL: Litigation Propensity Predictor

OBJECTIVE: Predict probability of litigation at various claim stages

ALGORITHMS (Ensemble):
  1. XGBoost (primary)
  2. Logistic Regression (interpretable baseline)
  3. Neural Network (capture non-linear interactions)
  
  Final: Weighted average (0.5 XGB + 0.2 LR + 0.3 NN)

FEATURES (Top 30 by SHAP importance):
  1. attorney_at_fnol (binary)
  2. injury_severity_score (numeric)
  3. county_litigation_rate (numeric)
  4. claimed_amount_to_limit_ratio (numeric)
  5. hospitalization_indicator (binary)
  6. surgery_indicator (binary)
  7. claimant_age (numeric)
  8. days_to_first_treatment (numeric)
  9. treatment_duration_projected (numeric)
  10. prior_litigation_history (binary)
  11. state_no_fault_flag (binary)
  12. liability_dispute_indicator (binary)
  13. adjuster_response_time_hours (numeric)
  14. number_of_claimants (numeric)
  15. commercial_vehicle_indicator (binary)
  16. government_entity_indicator (binary)
  17. loss_description_sentiment (numeric)
  18. medical_provider_type (categorical)
  19. insured_vs_third_party (categorical)
  20. coverage_limit_amount (numeric)
  21. policy_type (categorical)
  22. lob (categorical)
  23. zip_median_income (numeric)
  24. zip_attorney_density (numeric)
  25. accident_type (categorical)
  26. dui_indicator (binary)
  27. hit_and_run_indicator (binary)
  28. multi_vehicle_indicator (binary)
  29. pedestrian_indicator (binary)
  30. child_involved (binary)

PERFORMANCE:
  AUC-ROC: 0.87
  Precision @50% recall: 0.72
  Recall @50% precision: 0.68
  Lift @top decile: 4.2x
  
  At threshold 0.60:
    Precision: 0.65
    Recall: 0.58
    F1: 0.61
```

---

## 19. Medical Bill Review with NLP

### 19.1 Automated Medical Bill Review Pipeline

```
PIPELINE: AI-Assisted Medical Bill Review

  STEP 1: Bill Ingestion & OCR
    ├─ Receive bill (CMS-1500, UB-04, itemized)
    ├─ Document type classification
    ├─ OCR / structured data extraction
    └─ Map to standard bill format

  STEP 2: Provider Verification
    ├─ Lookup provider NPI in NPPES
    ├─ Verify provider credentials
    ├─ Check provider against fraud watch list
    ├─ Check if in-network for WC/PIP
    └─ Flag unusual provider types for injury

  STEP 3: Procedure Code Validation
    ├─ Validate CPT/HCPCS codes exist
    ├─ Check for unbundling (modifier analysis)
    ├─ Check for upcoding (complexity match)
    ├─ Verify units reasonable for procedure
    ├─ Check frequency against guidelines
    └─ Validate ICD-10 to CPT mapping (medical necessity)

  STEP 4: Fee Schedule Application
    ├─ Apply state workers comp fee schedule (if WC)
    ├─ Apply PIP fee schedule (if applicable)
    ├─ Apply UCR (Usual, Customary, Reasonable)
    ├─ Compare to Medicare rates
    └─ Flag charges > 200% of benchmark

  STEP 5: Relatedness Assessment (NLP)
    ├─ Extract diagnosis from bill
    ├─ Compare diagnosis to accident injury description
    ├─ NLP model: relatedness score (0-1)
    ├─ Check for pre-existing condition overlap
    ├─ Flag treatments inconsistent with injury type
    └─ Assess temporal reasonableness

  STEP 6: Guideline Compliance
    ├─ ODG (Official Disability Guidelines) check
    ├─ Treatment frequency within guidelines
    ├─ Duration of treatment reasonable
    ├─ Diagnostic testing appropriate
    └─ Referral patterns within norms

  STEP 7: Output Decision
    ├─ AUTO_APPROVE: All checks pass, < threshold
    ├─ FLAG_FOR_REVIEW: Some checks fail, needs nurse review
    ├─ DENY: Clear guideline violation or unrelatedness
    └─ Generate explanation for each line item
```

---

## 20. Subrogation Identification with ML

### 20.1 Subrogation Potential Model

```
MODEL: Subrogation Potential Identifier

OBJECTIVE: Predict probability of recoverable subrogation at FNOL

ALGORITHM: XGBoost Classifier

FEATURES:
  - Loss type / cause of loss
  - Liability determination
  - Number of parties involved
  - Police report available
  - Other vehicle/party identified
  - Other insurance identified
  - Fault percentage (if determined)
  - Narrative indicators (NLP-extracted)
  - Product defect indicators
  - Premises liability indicators
  - Employer negligence (WC third-party)
  - Historical recovery rate by similar claims

OUTPUT:
  {
    "claim_id": "CLM-2024-001234",
    "subrogation_probability": 0.82,
    "subrogation_type": "THIRD_PARTY_AUTO",
    "estimated_recovery": {
      "gross": 4500,
      "net_of_costs": 3800,
      "probability_weighted": 3116
    },
    "key_indicators": [
      "Clear rear-end collision (other driver at fault)",
      "Other driver's insurance identified (State Farm)",
      "Police report assigns fault to other driver",
      "No comparative negligence factors identified"
    ],
    "recommended_action": "INITIATE_DEMAND",
    "demand_priority": "HIGH"
  }
```

---

## 21. Vendor & Model Marketplace

### 21.1 Claims AI Vendor Landscape

| Vendor | Primary Capability | Technology | Claims Fit |
|--------|-------------------|-----------|-----------|
| **CCC Intelligent Solutions** | Auto damage estimation, total loss | CV, ML, data network | Excellent (auto) |
| **Tractable** | AI photo estimation (auto & property) | Deep learning CV | Excellent |
| **Snapsheet** | Virtual appraisal, photo estimation | CV, workflow | Very Good |
| **Claim Genius** | AI damage estimation | Computer vision | Good |
| **Shift Technology** | Fraud detection, claims automation | ML, network analysis | Excellent |
| **FRISS** | Fraud, risk, compliance | Rules + ML | Very Good |
| **Cape Analytics** | Property intelligence (aerial) | Satellite CV | Excellent (property) |
| **Nearmap** | Aerial imagery, property analytics | Aerial CV | Very Good (property) |
| **Verisk/ISO** | Analytics, ClaimSearch, estimating | Data + ML | Excellent |
| **LexisNexis** | Data enrichment, fraud indicators | Data + rules | Very Good |
| **Hi Marley** | Conversational AI (SMS-based) | NLP, chatbot | Good |
| **Sprout.ai** | Claims automation, document processing | NLP, IDP | Good |
| **Groundspeed Analytics** | Document data extraction | NLP, OCR | Good |
| **Gradient AI** | Loss run analysis, reserves | ML, predictive | Good |

---

## 22. Ethical Considerations & Regulatory Constraints

### 22.1 Regulatory Framework

| Regulation | Jurisdiction | AI Impact | Requirements |
|-----------|-------------|-----------|-------------|
| NAIC AI Principles | US (Model) | All AI models | Fairness, accountability, transparency |
| Colorado SB 21-169 | Colorado | Life + claims | Bias testing, governance program |
| EU AI Act | European Union | All AI systems | Risk classification, human oversight |
| CCPA/CPRA | California | Data-based models | Data rights, opt-out, disclosure |
| FCRA | US Federal | Credit-based scoring | Adverse action notices, disputes |
| State Unfair Claims Acts | US (State) | Claims decisions | Prompt, fair, equitable handling |
| State Insurance Data | Various states | Rating/UW models | Filed and approved requirements |

### 22.2 AI Governance Framework

```
┌─────────────────────────────────────────────────────────────────┐
│                   AI GOVERNANCE FRAMEWORK                        │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  AI ETHICS BOARD                                          │   │
│  │  - Chief Actuary           - Chief Claims Officer         │   │
│  │  - Chief Data Officer      - Chief Compliance Officer     │   │
│  │  - Head of AI/ML           - External Ethics Advisor      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  MODEL GOVERNANCE PROCESS                                 │   │
│  │                                                           │   │
│  │  1. Use Case Approval                                     │   │
│  │     - Business justification                              │   │
│  │     - Risk assessment (high/medium/low)                   │   │
│  │     - Data privacy impact assessment                      │   │
│  │                                                           │   │
│  │  2. Development Standards                                 │   │
│  │     - Approved algorithms and frameworks                  │   │
│  │     - Feature approval (no prohibited attributes)         │   │
│  │     - Documentation requirements                          │   │
│  │     - Bias testing requirements                           │   │
│  │                                                           │   │
│  │  3. Validation & Testing                                  │   │
│  │     - Independent model validation                        │   │
│  │     - Fairness audit (disparate impact analysis)          │   │
│  │     - Robustness testing (adversarial, edge cases)        │   │
│  │     - Regulatory compliance check                         │   │
│  │                                                           │   │
│  │  4. Deployment Approval                                   │   │
│  │     - Ethics board review for high-risk models            │   │
│  │     - Actuarial sign-off for pricing/reserve models       │   │
│  │     - Compliance sign-off                                 │   │
│  │                                                           │   │
│  │  5. Ongoing Monitoring                                    │   │
│  │     - Performance monitoring (drift, accuracy)            │   │
│  │     - Fairness monitoring (quarterly)                     │   │
│  │     - Annual model review/revalidation                    │   │
│  │     - Regulatory examination readiness                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 23. Model Monitoring & Drift Detection

### 23.1 Monitoring Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                  MODEL MONITORING PLATFORM                       │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Performance  │  │ Data Drift   │  │ Concept Drift        │  │
│  │ Monitor      │  │ Monitor      │  │ Monitor              │  │
│  │              │  │              │  │                      │  │
│  │ - Accuracy   │  │ - PSI per    │  │ - Prediction shift   │  │
│  │ - Precision  │  │   feature    │  │ - Actual vs predicted│  │
│  │ - Recall     │  │ - KL diver-  │  │   divergence over    │  │
│  │ - F1         │  │   gence      │  │   time               │  │
│  │ - AUC-ROC    │  │ - Chi-square │  │ - Residual trends    │  │
│  │ - Calibration│  │   test       │  │                      │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
│         │                  │                      │              │
│         └──────────────────┼──────────────────────┘              │
│                            │                                     │
│                   ┌────────▼────────┐                            │
│                   │ Alert Engine    │                            │
│                   │                 │                            │
│                   │ WARNING:        │                            │
│                   │  PSI > 0.10     │                            │
│                   │  Accuracy < -3% │                            │
│                   │                 │                            │
│                   │ CRITICAL:       │                            │
│                   │  PSI > 0.25     │                            │
│                   │  Accuracy < -5% │                            │
│                   │  AUC < 0.80     │                            │
│                   └────────┬────────┘                            │
│                            │                                     │
│                   ┌────────▼────────┐                            │
│                   │ Action          │                            │
│                   │ - Notify team   │                            │
│                   │ - Trigger       │                            │
│                   │   retraining    │                            │
│                   │ - Fallback to   │                            │
│                   │   previous ver. │                            │
│                   └─────────────────┘                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 23.2 Drift Detection Metrics

```
POPULATION STABILITY INDEX (PSI):

  PSI = Σ (Actual% - Expected%) × ln(Actual% / Expected%)
  
  Interpretation:
    PSI < 0.10: No significant drift (GREEN)
    PSI 0.10-0.25: Moderate drift, investigate (YELLOW)
    PSI > 0.25: Significant drift, action required (RED)

  Example: Fraud Score Distribution Drift
  
  Score Bucket  Expected%  Actual%    Component
  0-10          35.0%      32.5%      0.0019
  11-20         25.0%      23.0%      0.0017
  21-30         15.0%      16.5%      0.0015
  31-40         10.0%      11.0%      0.0009
  41-50         7.0%       8.0%       0.0013
  51-60         4.0%       4.5%       0.0006
  61-70         2.5%       3.0%       0.0010
  71-80         1.0%       1.0%       0.0000
  81-90         0.4%       0.4%       0.0000
  91-100        0.1%       0.1%       0.0000
  ────────────────────────────────────────────
  TOTAL PSI:                          0.0089  → GREEN (no drift)
```

---

## 24. Complete ML Pipeline Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CLAIMS AI/ML PLATFORM ARCHITECTURE                     │
│                                                                           │
│  ┌───────────────────────────────────────────────────────────────────┐   │
│  │                      DATA SOURCES                                  │   │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │   │
│  │  │ Claims  │ │ Policy  │ │ External│ │ Photos  │ │ Docs    │   │   │
│  │  │ System  │ │ Admin   │ │ APIs    │ │ Storage │ │ Storage │   │   │
│  │  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘   │   │
│  └───────┼──────────┼──────────┼──────────┼──────────┼─────────────┘   │
│          └──────────┴──────────┴──────────┴──────────┘                   │
│                                │                                          │
│  ┌─────────────────────────────▼────────────────────────────────────┐   │
│  │                    DATA ENGINEERING LAYER                          │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │   │
│  │  │ Kafka        │  │ Spark        │  │ Data Lake (S3)     │     │   │
│  │  │ (Streaming)  │  │ (Batch ETL)  │  │ - Raw / Curated    │     │   │
│  │  └──────────────┘  └──────────────┘  └────────────────────┘     │   │
│  └─────────────────────────────┬────────────────────────────────────┘   │
│                                │                                          │
│  ┌─────────────────────────────▼────────────────────────────────────┐   │
│  │                    FEATURE PLATFORM                                │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │   │
│  │  │ Feature      │  │ Online Store │  │ Offline Store      │     │   │
│  │  │ Registry     │  │ (Redis)      │  │ (S3 / Parquet)     │     │   │
│  │  └──────────────┘  └──────────────┘  └────────────────────┘     │   │
│  └─────────────────────────────┬────────────────────────────────────┘   │
│                                │                                          │
│  ┌─────────────────────────────▼────────────────────────────────────┐   │
│  │                    ML TRAINING PLATFORM                            │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │   │
│  │  │ Experiment   │  │ Training     │  │ Model Registry     │     │   │
│  │  │ Tracking     │  │ Jobs         │  │ (MLflow)           │     │   │
│  │  │ (MLflow)     │  │ (SageMaker)  │  │                    │     │   │
│  │  └──────────────┘  └──────────────┘  └────────────────────┘     │   │
│  └─────────────────────────────┬────────────────────────────────────┘   │
│                                │                                          │
│  ┌─────────────────────────────▼────────────────────────────────────┐   │
│  │                    MODEL SERVING LAYER                             │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │   │
│  │  │ Real-Time    │  │ Batch        │  │ Edge               │     │   │
│  │  │ Endpoints    │  │ Scoring      │  │ Inference          │     │   │
│  │  │ (SageMaker)  │  │ (Spark)      │  │ (Mobile TFLite)   │     │   │
│  │  └──────────────┘  └──────────────┘  └────────────────────┘     │   │
│  └─────────────────────────────┬────────────────────────────────────┘   │
│                                │                                          │
│  ┌─────────────────────────────▼────────────────────────────────────┐   │
│  │                    MONITORING & GOVERNANCE                         │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐     │   │
│  │  │ Performance  │  │ Drift        │  │ Fairness &         │     │   │
│  │  │ Monitoring   │  │ Detection    │  │ Explainability     │     │   │
│  │  └──────────────┘  └──────────────┘  └────────────────────┘     │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 25. Sample Feature Store Schema

### 25.1 Feature Store Entity Definitions

```sql
-- Feature Store: Claims Feature Group
CREATE TABLE feature_store.claim_features (
    claim_id            VARCHAR(20) PRIMARY KEY,
    feature_timestamp   TIMESTAMP NOT NULL,
    
    -- Claim attributes
    lob                 VARCHAR(20),
    claim_type          VARCHAR(30),
    loss_cause_code     VARCHAR(10),
    loss_state          VARCHAR(2),
    loss_county         VARCHAR(50),
    date_of_loss        DATE,
    day_of_week_loss    INTEGER,
    month_of_loss       INTEGER,
    is_weekend_loss     BOOLEAN,
    days_to_report      INTEGER,
    reporting_channel   VARCHAR(20),
    claimed_amount      DECIMAL(12,2),
    claimed_amount_log  DECIMAL(8,4),
    number_of_claimants INTEGER,
    number_of_vehicles  INTEGER,
    has_bodily_injury   BOOLEAN,
    injury_count        INTEGER,
    max_injury_severity VARCHAR(20),
    has_police_report   BOOLEAN,
    attorney_at_fnol    BOOLEAN,
    
    -- Derived features
    claimed_to_limit_ratio      DECIMAL(8,4),
    claimed_to_vehicle_ratio    DECIMAL(8,4),
    narrative_length            INTEGER,
    narrative_sentiment         DECIMAL(5,3),
    photo_count                 INTEGER,
    
    -- Model scores (populated by scoring pipelines)
    fraud_score                 DECIMAL(5,3),
    severity_score              DECIMAL(5,3),
    litigation_score            DECIMAL(5,3),
    subrogation_score           DECIMAL(5,3),
    triage_score                DECIMAL(5,3),
    
    -- Metadata
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feature Store: Policy Feature Group
CREATE TABLE feature_store.policy_features (
    policy_id           VARCHAR(20) PRIMARY KEY,
    feature_timestamp   TIMESTAMP NOT NULL,
    
    policy_tenure_days      INTEGER,
    policy_age_days         INTEGER,
    premium_amount          DECIMAL(10,2),
    coverage_limit_bi       DECIMAL(12,2),
    coverage_limit_pd       DECIMAL(12,2),
    deductible_comp         DECIMAL(10,2),
    deductible_coll         DECIMAL(10,2),
    named_driver_count      INTEGER,
    prior_claims_3yr        INTEGER,
    prior_claims_total_paid DECIMAL(12,2),
    insured_age             INTEGER,
    insured_credit_band     VARCHAR(10),
    vehicle_year            INTEGER,
    vehicle_value_acv       DECIMAL(10,2),
    vehicle_age             INTEGER,
    multi_policy_flag       BOOLEAN,
    
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feature Store: External Feature Group
CREATE TABLE feature_store.external_features (
    zip_code            VARCHAR(10) PRIMARY KEY,
    feature_timestamp   TIMESTAMP NOT NULL,
    
    median_income           DECIMAL(10,2),
    population_density      DECIMAL(10,2),
    crime_index             DECIMAL(8,4),
    litigation_rate         DECIMAL(8,4),
    avg_settlement          DECIMAL(12,2),
    medical_cost_index      DECIMAL(8,4),
    repair_cost_index       DECIMAL(8,4),
    attorney_density        DECIMAL(8,4),
    
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feature Store: NLP Feature Group
CREATE TABLE feature_store.nlp_features (
    claim_id            VARCHAR(20) PRIMARY KEY,
    feature_timestamp   TIMESTAMP NOT NULL,
    
    narrative_embedding     VECTOR(768),
    narrative_entities      JSONB,
    narrative_sentiment     DECIMAL(5,3),
    narrative_consistency   DECIMAL(5,3),
    fraud_language_score    DECIMAL(5,3),
    extracted_loss_cause    VARCHAR(50),
    extracted_fault_ind     VARCHAR(20),
    extracted_injury_types  JSONB,
    extracted_vehicle_info  JSONB,
    extracted_location      JSONB,
    
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feature Store: Image Feature Group
CREATE TABLE feature_store.image_features (
    claim_id            VARCHAR(20) PRIMARY KEY,
    feature_timestamp   TIMESTAMP NOT NULL,
    
    image_count             INTEGER,
    image_quality_avg       DECIMAL(5,3),
    damage_region_count     INTEGER,
    damage_panels           JSONB,
    max_damage_severity     VARCHAR(20),
    structural_damage_flag  BOOLEAN,
    airbag_deployed_flag    BOOLEAN,
    total_loss_probability  DECIMAL(5,3),
    estimated_repair_cost   DECIMAL(10,2),
    image_embedding         VECTOR(512),
    
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 25.2 Feature Freshness Requirements

| Feature Group | Online Store TTL | Update Frequency | Latency SLA |
|--------------|-----------------|-----------------|-------------|
| Claim Features | 7 days | Real-time (event-driven) | < 100ms |
| Policy Features | 24 hours | Daily batch + change events | < 50ms |
| External Features | 30 days | Monthly batch | < 50ms |
| NLP Features | 7 days | On document receipt | < 200ms |
| Image Features | 7 days | On photo upload | < 500ms |
| Model Scores | 7 days | Real-time (on scoring) | < 100ms |

---

## Appendix A: Model Performance Benchmarks

| Model | Algorithm | AUC-ROC | Precision | Recall | F1 | Latency |
|-------|-----------|---------|-----------|--------|-----|---------|
| Fraud Detection | XGBoost | 0.92 | 0.75 | 0.60 | 0.67 | 15ms |
| Triage Scoring | LightGBM | 0.88 | 0.79 | 0.76 | 0.77 | 12ms |
| Litigation Pred. | Ensemble | 0.87 | 0.72 | 0.58 | 0.64 | 25ms |
| Severity Pred. | XGBoost | N/A (regression) | MAE: $2,800 | R²: 0.72 | N/A | 12ms |
| Subrogation ID | XGBoost | 0.88 | 0.80 | 0.65 | 0.72 | 10ms |
| Total Loss Pred. | Log. Reg. | 0.95 | 0.88 | 0.82 | 0.85 | 5ms |
| Doc Classification | BERT | 0.96 | 0.94 | 0.93 | 0.94 | 150ms |
| Damage Estimation | CNN+Reg | N/A (regression) | MAE: $450 | R²: 0.81 | N/A | 2000ms |
| NER | Claims-BERT | N/A (seq) | 0.89 | 0.87 | 0.88 | 200ms |

---

*This document is part of the PnC Claims Encyclopedia. For related topics, see:*
- *Article 6: Claims Automation & Straight-Through Processing*
- *Article 8: Fraud Detection & SIU Operations*
- *Article 9: Subrogation & Recovery*
- *Article 10: Reserves & Financial Management*
