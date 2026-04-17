# Document Management & Correspondence in Claims

## Table of Contents

1. [Document Management in Claims Context](#1-document-management-in-claims-context)
2. [Document Types in Claims](#2-document-types-in-claims)
3. [Document Lifecycle](#3-document-lifecycle)
4. [Document Capture Channels](#4-document-capture-channels)
5. [Intelligent Document Processing (IDP) Pipeline](#5-intelligent-document-processing-idp-pipeline)
6. [OCR Technology](#6-ocr-technology)
7. [Document Classification Models](#7-document-classification-models)
8. [Data Extraction](#8-data-extraction)
9. [Document Metadata Model](#9-document-metadata-model)
10. [Content Management System Requirements](#10-content-management-system-requirements)
11. [Content Management Platforms](#11-content-management-platforms)
12. [ECM Integration Patterns](#12-ecm-integration-patterns)
13. [Document Indexing & Search](#13-document-indexing--search)
14. [Image Management](#14-image-management)
15. [Correspondence Management](#15-correspondence-management)
16. [Correspondence Types](#16-correspondence-types)
17. [Template Management](#17-template-management)
18. [Correspondence Generation](#18-correspondence-generation)
19. [Correspondence Delivery Channels](#19-correspondence-delivery-channels)
20. [Correspondence Template Engine Architecture](#20-correspondence-template-engine-architecture)
21. [Print Vendor Integration](#21-print-vendor-integration)
22. [Email & Digital Delivery Integration](#22-email--digital-delivery-integration)
23. [Regulatory Correspondence Requirements](#23-regulatory-correspondence-requirements)
24. [Correspondence Tracking](#24-correspondence-tracking)
25. [Document Retention Policies](#25-document-retention-policies)
26. [Litigation Hold & E-Discovery](#26-litigation-hold--e-discovery)
27. [Document Security & Access Control](#27-document-security--access-control)
28. [Digital Signature & E-Consent](#28-digital-signature--e-consent)
29. [Document Data Model Complete Schema](#29-document-data-model-complete-schema)
30. [Sample Correspondence Templates](#30-sample-correspondence-templates)
31. [Document Management Architecture](#31-document-management-architecture)

---

## 1. Document Management in Claims Context

Document management in PnC claims is a mission-critical capability that underpins every stage of the claims lifecycle. A single property claim can generate 50–200+ documents; a litigated bodily injury claim can produce 500–2,000+ documents. Across a mid-size carrier processing 200,000 claims per year, the document repository must manage millions of documents with strict regulatory retention, security, and accessibility requirements.

### Why Document Management Matters in Claims

| Dimension | Impact |
|-----------|--------|
| Regulatory compliance | State laws mandate specific correspondence, retention of claim files |
| Litigation readiness | Complete, indexed claim files required for legal defense |
| Operational efficiency | Adjusters spend 30%–40% of time on document-related activities |
| Customer experience | Fast document processing = faster claim resolution |
| Fraud detection | Document analysis reveals forgery, manipulation, inconsistencies |
| Financial controls | Documentation supports every payment, reserve, and recovery |
| Audit readiness | Internal/external auditors require full documentation trail |

### Document Volume Benchmarks

| Claim Type | Avg Documents per Claim | Range | Peak |
|-----------|------------------------|-------|------|
| Auto physical damage (simple) | 15–25 | 10–50 | 100+ (total loss) |
| Auto BI (non-litigated) | 30–60 | 20–150 | 300+ |
| Auto BI (litigated) | 100–300 | 50–2,000+ | 5,000+ |
| Homeowners property | 20–40 | 10–100 | 200+ (large loss) |
| Homeowners liability | 30–80 | 20–200 | 500+ |
| Commercial property | 50–200 | 20–500+ | 1,000+ |
| Workers compensation | 50–150 | 20–500+ | 2,000+ (complex) |

---

## 2. Document Types in Claims

### Comprehensive Document Type Taxonomy

```
CLAIMS DOCUMENT TAXONOMY
├── FNOL & INTAKE DOCUMENTS
│   ├── FNOL Form (web, phone transcript, mobile)
│   ├── Loss Report (agent/broker)
│   ├── Police Report / Accident Report
│   ├── Fire Department Report
│   ├── Incident Report (commercial)
│   └── Weather Report / CAT Bulletin
│
├── POLICY & COVERAGE DOCUMENTS
│   ├── Policy Declaration Page
│   ├── Policy Forms & Endorsements
│   ├── Coverage Verification Letter
│   ├── Reservation of Rights Letter
│   └── Coverage Denial Letter
│
├── INVESTIGATION DOCUMENTS
│   ├── Adjuster Report / Field Notes
│   ├── Recorded Statement Transcript
│   ├── Sworn Statement in Proof of Loss
│   ├── Examination Under Oath (EUO) Transcript
│   ├── Scene Investigation Report
│   ├── Witness Statements
│   ├── Expert Reports (engineering, cause & origin)
│   └── SIU Investigation Report
│
├── DAMAGE DOCUMENTATION
│   ├── Photographs (exterior, interior, vehicle, injury)
│   ├── Video (inspection, surveillance)
│   ├── Drone / Aerial Imagery
│   ├── Repair Estimate (Xactimate, CCC, Mitchell)
│   ├── Supplement Estimate
│   ├── Contractor Proposal / Quote
│   ├── Scope of Work
│   ├── Building Diagrams / Sketches
│   └── Vehicle Inspection Report
│
├── MEDICAL DOCUMENTS (BI / WC)
│   ├── Medical Records (initial treatment)
│   ├── Medical Records (ongoing treatment)
│   ├── Medical Bills / Invoices
│   ├── Explanation of Benefits (EOB)
│   ├── Independent Medical Examination (IME) Report
│   ├── Peer Review Report
│   ├── Nurse Case Manager Report
│   ├── Pharmacy Records
│   ├── Disability Rating / Impairment Report
│   └── Medical Authorization / HIPAA Release
│
├── FINANCIAL DOCUMENTS
│   ├── Reserve Worksheet
│   ├── Payment Authorization
│   ├── Check / ACH Record
│   ├── Payment Ledger
│   ├── Proof of Loss (sworn)
│   ├── Contractor Invoice
│   ├── Rental Car Invoice
│   ├── Salvage Settlement
│   ├── Subrogation Demand
│   ├── Subrogation Recovery Receipt
│   └── Tax Forms (1099, W-9)
│
├── LEGAL DOCUMENTS
│   ├── Complaint / Petition
│   ├── Answer / Response
│   ├── Discovery Requests (Interrogatories, RFP, RFA)
│   ├── Discovery Responses
│   ├── Deposition Transcripts
│   ├── Expert Witness Reports
│   ├── Motion Filings
│   ├── Court Orders
│   ├── Mediation / Arbitration Documents
│   ├── Settlement Agreement
│   ├── Judgment
│   ├── Release / Discharge
│   └── Attorney Correspondence
│
├── CORRESPONDENCE
│   ├── Acknowledgment Letter
│   ├── Status Update Letter
│   ├── Information Request Letter
│   ├── Coverage Decision Letter
│   ├── Settlement Offer Letter
│   ├── Denial Letter
│   ├── Closing Letter
│   ├── Regulatory Response
│   ├── Subrogation Demand Letter
│   ├── Salvage Notification
│   └── General Correspondence
│
├── REGULATORY DOCUMENTS
│   ├── Department of Insurance Complaint
│   ├── DOI Response
│   ├── Market Conduct Exam Documents
│   ├── Regulatory Filing
│   └── State-Mandated Forms
│
└── ADMINISTRATIVE DOCUMENTS
    ├── Assignment Records
    ├── Activity / Task Logs
    ├── Internal Memos / Notes
    ├── Quality Audit Reports
    └── Vendor Correspondence
```

### Document Type Classification Table

| Document Type | Format | Avg Size | Sensitivity | Retention |
|--------------|--------|----------|-------------|-----------|
| Police report | PDF, Image | 50KB–2MB | Standard | Claim retention + 7 years |
| Medical records | PDF | 100KB–50MB | PHI (HIPAA) | Claim retention + statute |
| Photographs | JPEG, PNG | 1MB–10MB | Standard | Claim retention + 5 years |
| Repair estimate | PDF, XML | 200KB–5MB | Standard | Claim retention + 5 years |
| Settlement release | PDF (signed) | 100KB–500KB | PII | Claim retention + 10 years |
| Correspondence | PDF | 50KB–500KB | PII/Standard | Claim retention + 7 years |
| Legal documents | PDF | 100KB–100MB | Attorney-client privilege | Permanent |
| Video | MP4, MOV | 50MB–2GB | Standard | Claim retention + 5 years |
| Drone imagery | JPEG, TIFF | 5MB–500MB | Standard | Claim retention + 5 years |

---

## 3. Document Lifecycle

### Complete Document Lifecycle

```
+===================================================================+
|                   DOCUMENT LIFECYCLE                                |
+===================================================================+
|                                                                     |
|  1. CAPTURE                                                        |
|  +-------------------------------------------------------------+  |
|  | Physical:  Scan → Digital Image → OCR                        |  |
|  | Email:     Attachment extraction → Classification             |  |
|  | Web:       Upload form → Virus scan → Staging                |  |
|  | Mobile:    Photo/PDF capture → Upload → Staging              |  |
|  | Fax:       Fax server → Digital Image → OCR                  |  |
|  | API:       System-to-system → Validation → Staging           |  |
|  | EDI:       Structured data → Parsing → Staging               |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  2. CLASSIFY                                                       |
|  +-------------------------------------------------------------+  |
|  | Auto-classification (ML model)                               |  |
|  | - Document type prediction (confidence score)                |  |
|  | - Sub-type classification                                    |  |
|  | - Language detection                                         |  |
|  | Manual classification (fallback < 80% confidence)            |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  3. INDEX                                                          |
|  +-------------------------------------------------------------+  |
|  | Extract metadata:                                            |  |
|  | - Claim number (from content or association)                 |  |
|  | - Document type / sub-type                                   |  |
|  | - Date received                                              |  |
|  | - Source (sender, channel)                                   |  |
|  | - Key data fields (from extraction)                          |  |
|  | - Confidentiality level                                      |  |
|  | Full-text index (for search)                                 |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  4. STORE                                                          |
|  +-------------------------------------------------------------+  |
|  | Primary storage: Content management system                   |  |
|  | - Versioning (if document is updated)                        |  |
|  | - Access control (role-based)                                |  |
|  | - Encryption (at rest and in transit)                        |  |
|  | - Geo-redundant storage                                      |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  5. RETRIEVE                                                       |
|  +-------------------------------------------------------------+  |
|  | Access methods:                                              |  |
|  | - Claim document list (all docs for a claim)                |  |
|  | - Search (metadata, full-text, semantic)                     |  |
|  | - Direct link (document ID)                                  |  |
|  | - API access (system-to-system)                              |  |
|  | - Viewer (in-browser rendering)                              |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  6. ARCHIVE                                                        |
|  +-------------------------------------------------------------+  |
|  | Migrate to lower-cost storage tier:                          |  |
|  | - After claim closure + defined period                       |  |
|  | - Move from hot storage to cold/archive storage             |  |
|  | - Maintain metadata index for retrieval                      |  |
|  | - Glacier, S3 IA, Azure Archive tiers                       |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  7. PURGE                                                          |
|  +-------------------------------------------------------------+  |
|  | After retention period expires:                              |  |
|  | - Verify no litigation hold                                  |  |
|  | - Verify no regulatory hold                                  |  |
|  | - Verify retention period complete                           |  |
|  | - Secure deletion (with audit log)                           |  |
|  | - Certificate of destruction                                 |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 4. Document Capture Channels

### Channel-Specific Processing

| Channel | Intake Process | Processing Time | Quality |
|---------|---------------|----------------|---------|
| Scan/mail room | Physical mail → barcode → high-speed scanner → image | 4–24 hours | High (controlled scan) |
| Email | Email received → attachment extracted → virus scan | Minutes | Variable |
| Web upload | Browser upload → virus scan → staging | Seconds | Variable (user controlled) |
| Mobile app | Camera capture → upload → staging | Seconds | Variable (photo quality) |
| Fax | Fax server → TIFF image → staging | Minutes | Low (fax quality) |
| API ingestion | System-to-system → validation → staging | Seconds | High (structured) |
| EDI | Structured data → parsing → staging | Seconds–minutes | High (machine generated) |

### Mail Room / Scan Operations

```
+-------------------------------------------------------------------+
|                   PHYSICAL MAIL PROCESSING                          |
+-------------------------------------------------------------------+
|                                                                     |
|  1. MAIL RECEIPT                                                   |
|     - USPS, FedEx, UPS delivery                                   |
|     - Log receipt (timestamp, sender, tracking)                    |
|     - Sort by department / claim number                            |
|                                                                     |
|  2. PREPARATION                                                    |
|     - Open envelopes                                               |
|     - Remove staples, unfold                                       |
|     - Separate documents                                           |
|     - Add barcode separator sheets (if batch scanning)            |
|     - Identify claim number (from cover sheet or content)         |
|                                                                     |
|  3. SCANNING                                                       |
|     - High-speed production scanner (Kodak, Fujitsu, Canon)       |
|     - Duplex scanning (front/back)                                |
|     - 300 DPI minimum (600 DPI for OCR-critical)                  |
|     - Automatic document feeder (ADF)                             |
|     - Image enhancement (auto-rotate, deskew, despeckle)          |
|                                                                     |
|  4. QUALITY CHECK                                                  |
|     - Page count verification                                      |
|     - Image quality check                                          |
|     - Rescan if quality insufficient                               |
|                                                                     |
|  5. INDEXING                                                       |
|     - Associate with claim number                                  |
|     - Classify document type                                       |
|     - Add metadata                                                 |
|     - Release to content management system                        |
|                                                                     |
|  6. PHYSICAL DOCUMENT HANDLING                                     |
|     - Temporary storage (30-90 days)                              |
|     - Secure destruction after confirmed digital capture          |
|                                                                     |
+-------------------------------------------------------------------+
```

### Email Ingestion Architecture

```
+-------------------------------------------------------------------+
|                   EMAIL DOCUMENT INGESTION                          |
+-------------------------------------------------------------------+
|                                                                     |
|  Incoming Email                                                    |
|  (claims@company.com, newloss@company.com, etc.)                  |
|       |                                                             |
|       v                                                             |
|  +---------------------+                                           |
|  | Email Gateway        |                                           |
|  | (Exchange, Gmail,    |                                           |
|  |  dedicated mailbox)  |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Email Processing     |                                           |
|  | Service              |                                           |
|  | - Parse email header |                                           |
|  | - Extract body text  |                                           |
|  | - Identify claim #   |                                           |
|  |   (regex: CLM-\d+)  |                                           |
|  | - Extract attachments|                                           |
|  | - Virus scan all     |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+                                            |
|    |                  |                                             |
|    v                  v                                             |
|  Email Body        Attachments                                     |
|  (saved as         (each processed                                 |
|   correspondence)   separately)                                    |
|    |                  |                                             |
|    v                  v                                             |
|  +---------------------------------------------+                  |
|  | Document Classification & Indexing Pipeline  |                  |
|  +---------------------------------------------+                  |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 5. Intelligent Document Processing (IDP) Pipeline

### End-to-End IDP Architecture

```
+===================================================================+
|               INTELLIGENT DOCUMENT PROCESSING PIPELINE              |
+===================================================================+
|                                                                     |
|  STAGE 1: INGESTION                                                |
|  +-------------------------------------------------------------+  |
|  | Input: Raw document (PDF, Image, TIFF, Word, etc.)          |  |
|  | Actions:                                                     |  |
|  |   - Virus/malware scan                                      |  |
|  |   - Format detection and validation                         |  |
|  |   - Page splitting (multi-doc PDF separation)               |  |
|  |   - Duplicate detection (hash comparison)                   |  |
|  | Output: Clean document(s) in staging                        |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 2: PRE-PROCESSING                                          |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - Image enhancement (contrast, brightness)                |  |
|  |   - Deskew (straighten rotated images)                      |  |
|  |   - Despeckle (remove noise)                                |  |
|  |   - Binarization (convert to black/white for OCR)           |  |
|  |   - Resolution normalization (upscale to 300+ DPI)          |  |
|  |   - Page orientation detection and correction               |  |
|  |   - Border removal                                          |  |
|  | Output: Enhanced images ready for OCR                       |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 3: OCR (Optical Character Recognition)                      |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - Text extraction from images                             |  |
|  |   - Layout analysis (tables, columns, sections)             |  |
|  |   - Handwriting recognition (ICR)                           |  |
|  |   - Checkbox/mark detection (OMR)                           |  |
|  |   - Barcode/QR code reading                                 |  |
|  |   - Confidence scoring per character/word                   |  |
|  | Output: Extracted text with coordinates and confidence       |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 4: CLASSIFICATION                                           |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - ML model predicts document type                         |  |
|  |   - Sub-type classification (e.g., medical bill vs record)  |  |
|  |   - Confidence scoring                                      |  |
|  |   - Human review queue for low-confidence (<80%)            |  |
|  | Output: Document type label with confidence                 |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 5: EXTRACTION                                               |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - Key-value pair extraction                               |  |
|  |   - Table extraction                                        |  |
|  |   - Entity recognition (names, dates, amounts, codes)       |  |
|  |   - Relationship extraction (which amount for which service) |  |
|  |   - Confidence scoring per field                            |  |
|  | Output: Structured data from unstructured document          |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 6: VALIDATION                                               |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - Business rule validation                                |  |
|  |   - Cross-reference with claim data                         |  |
|  |   - Consistency checks                                      |  |
|  |   - Human review for exceptions                             |  |
|  | Output: Validated, structured data                          |  |
|  +-------------------------------------------------------------+  |
|                           |                                         |
|                           v                                         |
|  STAGE 7: INDEXING & STORAGE                                       |
|  +-------------------------------------------------------------+  |
|  | Actions:                                                     |  |
|  |   - Metadata assignment                                     |  |
|  |   - Full-text indexing                                      |  |
|  |   - Content management system storage                       |  |
|  |   - Claim file association                                  |  |
|  |   - Workflow triggers (notify adjuster, create activity)    |  |
|  | Output: Indexed, searchable, retrievable document           |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

---

## 6. OCR Technology

### OCR Technology Comparison

| Technology | Type | Accuracy | Handwriting | Tables | Cost | Deployment |
|-----------|------|----------|-------------|--------|------|------------|
| Tesseract (open source) | Traditional + LSTM | 85%–95% | Limited | Limited | Free | Self-hosted |
| AWS Textract | Cloud ML | 95%–99% | Good | Excellent | Pay per page | Cloud API |
| Azure Form Recognizer | Cloud ML | 95%–99% | Good | Excellent | Pay per page | Cloud API |
| Google Document AI | Cloud ML | 95%–99% | Good | Excellent | Pay per page | Cloud API |
| ABBYY FineReader | Commercial | 97%–99% | Good | Good | License | On-prem/cloud |
| Kofax | Commercial | 96%–99% | Good | Good | License | On-prem/cloud |

### OCR Integration Architecture

```
+-------------------------------------------------------------------+
|                   OCR PROCESSING ARCHITECTURE                       |
+-------------------------------------------------------------------+
|                                                                     |
|  Document Input                                                    |
|       |                                                             |
|       v                                                             |
|  +---------------------+                                           |
|  | Pre-Processor        |                                           |
|  | (Image enhancement)  |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Document Analyzer    |                                           |
|  | (Determine best OCR  |                                           |
|  |  engine for doc type)|                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+---------+                                  |
|    |        |         |         |                                  |
|    v        v         v         v                                  |
| AWS      Azure    Google    ABBYY                                  |
| Textract  Form     Doc AI                                          |
|           Recog.                                                   |
|    |        |         |         |                                  |
|    v        v         v         v                                  |
|  +----------+---------+---------+----------+                       |
|  | Result Aggregation & Confidence Scoring  |                       |
|  | - Best result selection                  |                       |
|  | - Ensemble (multiple engine results)     |                       |
|  | - Confidence threshold check             |                       |
|  +------------------------------------------+                       |
|             |                                                       |
|             v                                                       |
|  High Confidence (>95%): Auto-process                              |
|  Medium Confidence (80-95%): Spot check                            |
|  Low Confidence (<80%): Human review                               |
|                                                                     |
+-------------------------------------------------------------------+
```

### AWS Textract Integration Example

```json
{
  "textractRequest": {
    "documentLocation": {
      "s3Object": {
        "bucket": "claims-documents-raw",
        "name": "CLM-2024-0045231/police-report.pdf"
      }
    },
    "featureTypes": ["TABLES", "FORMS"],
    "outputConfig": {
      "s3Bucket": "claims-documents-processed",
      "s3Prefix": "textract-output/"
    }
  }
}
```

**Textract Response (Simplified):**

```json
{
  "textractResponse": {
    "documentMetadata": {
      "pages": 3,
      "ocrConfidence": 97.2
    },
    "blocks": [
      {
        "blockType": "KEY_VALUE_SET",
        "key": "Report Number",
        "value": "TPD-2024-001234",
        "confidence": 99.1
      },
      {
        "blockType": "KEY_VALUE_SET",
        "key": "Date of Incident",
        "value": "10/15/2024",
        "confidence": 98.7
      },
      {
        "blockType": "KEY_VALUE_SET",
        "key": "Officer Name",
        "value": "Officer J. Rodriguez",
        "confidence": 96.3
      },
      {
        "blockType": "TABLE",
        "tableCells": [
          {"row": 0, "col": 0, "text": "Vehicle 1", "confidence": 99.0},
          {"row": 0, "col": 1, "text": "2022 Honda Accord", "confidence": 97.5},
          {"row": 1, "col": 0, "text": "Vehicle 2", "confidence": 99.0},
          {"row": 1, "col": 1, "text": "2021 Toyota Camry", "confidence": 96.8}
        ]
      }
    ]
  }
}
```

---

## 7. Document Classification Models

### ML Classification Pipeline

```
+-------------------------------------------------------------------+
|              DOCUMENT CLASSIFICATION MODEL                          |
+-------------------------------------------------------------------+
|                                                                     |
|  Training Phase:                                                   |
|  +-------------------------------------------------------------+  |
|  | 1. Training Data Collection                                  |  |
|  |    - 10,000+ labeled documents per class                    |  |
|  |    - Balanced across all document types                     |  |
|  |    - Include edge cases and poor quality samples            |  |
|  |                                                              |  |
|  | 2. Feature Engineering                                      |  |
|  |    - Text features (TF-IDF, word embeddings)                |  |
|  |    - Layout features (page structure, formatting)           |  |
|  |    - Visual features (logos, headers, formatting)           |  |
|  |    - Metadata features (page count, file size)              |  |
|  |                                                              |  |
|  | 3. Model Training                                           |  |
|  |    - Multi-class classifier (15-25 document types)          |  |
|  |    - Algorithms: BERT, Document AI, Custom CNN              |  |
|  |    - Cross-validation, hyperparameter tuning                |  |
|  |                                                              |  |
|  | 4. Model Evaluation                                         |  |
|  |    - Accuracy: > 95% overall                                |  |
|  |    - Per-class precision/recall: > 90%                      |  |
|  |    - Confusion matrix analysis                              |  |
|  |    - Edge case testing                                      |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  Inference Phase:                                                  |
|  +-------------------------------------------------------------+  |
|  | Input: OCR text + layout features + visual features         |  |
|  |        |                                                     |  |
|  |        v                                                     |  |
|  | Model Prediction                                            |  |
|  |   - Class: POLICE_REPORT                                   |  |
|  |   - Confidence: 94.7%                                      |  |
|  |   - Runner-up: INCIDENT_REPORT (3.2%)                      |  |
|  |        |                                                     |  |
|  |        v                                                     |  |
|  | Confidence Routing:                                         |  |
|  |   - >= 90%: Auto-classify                                  |  |
|  |   - 70-90%: Auto-classify with review flag                 |  |
|  |   - < 70%: Human classification queue                      |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

### Classification Taxonomy for Claims

| Primary Type | Sub-Types | Classification Signals |
|-------------|-----------|----------------------|
| POLICE_REPORT | Traffic accident, incident, fire | "Case Number", "Officer", "Department" |
| MEDICAL_RECORD | ER, office visit, surgery, imaging | "Patient", "ICD", "CPT", "Diagnosis" |
| MEDICAL_BILL | Hospital, physician, pharmacy, PT | "Total Charges", "Balance Due", "CPT Code" |
| REPAIR_ESTIMATE | Xactimate, CCC, Mitchell | "Line Items", "RCV", "Depreciation", "Deductible" |
| PHOTOGRAPH | Damage, vehicle, property, injury | Image classification (CNN) |
| CORRESPONDENCE | Inbound letter, outbound letter, email | Letterhead, salutation, signature |
| LEGAL_DOCUMENT | Complaint, motion, order, deposition | "Court", "Plaintiff", "Defendant", "Case No" |
| POLICY_DOCUMENT | Dec page, forms, endorsements | "Policy Number", "Effective Date", "Premium" |
| FINANCIAL | Invoice, receipt, check, statement | "Amount Due", "Invoice Number" |
| PROOF_OF_LOSS | Sworn statement | "Proof of Loss", "Notary", "Sworn" |
| RELEASE | Settlement release, waiver | "Release", "Settlement", "Hereby release" |
| IDENTITY | Driver's license, ID, passport | Image + OCR patterns |
| VEHICLE | Title, registration, VIN verification | "VIN", "Title Number", "Registration" |

---

## 8. Data Extraction

### Extraction Methods Comparison

| Method | Description | Accuracy | Flexibility | Maintenance |
|--------|-------------|----------|-------------|-------------|
| Template-based | Fixed positions on known forms | 98%+ for exact templates | Low (new template per form) | High |
| Rule-based | Regex, keyword proximity, layout rules | 90%–95% | Medium | Medium |
| ML-based | Trained models for entity/field extraction | 92%–97% | High | Low (with retraining) |
| LLM-based | Large language model extraction (GPT, Claude) | 90%–98% | Very High | Very Low |
| Hybrid | Combination of above methods | 95%–99% | High | Medium |

### Extraction by Document Type

**Police Report Extraction:**

```json
{
  "extractedData": {
    "documentType": "POLICE_REPORT",
    "confidence": 0.96,
    "fields": {
      "reportNumber": {"value": "TPD-2024-001234", "confidence": 0.99},
      "incidentDate": {"value": "2024-10-15", "confidence": 0.98},
      "incidentTime": {"value": "14:32", "confidence": 0.97},
      "location": {"value": "Dale Mabry Hwy & Kennedy Blvd, Tampa FL", "confidence": 0.95},
      "reportingOfficer": {"value": "Officer J. Rodriguez #4521", "confidence": 0.96},
      "department": {"value": "Tampa Police Department", "confidence": 0.99},
      "vehicles": [
        {
          "vehicleNumber": 1,
          "year": {"value": "2022", "confidence": 0.99},
          "make": {"value": "Honda", "confidence": 0.99},
          "model": {"value": "Accord", "confidence": 0.99},
          "vin": {"value": "1HGCM82633A004352", "confidence": 0.97},
          "plate": {"value": "ABC 1234", "confidence": 0.95},
          "driver": {"value": "John Smith", "confidence": 0.96},
          "driverDOB": {"value": "1985-03-15", "confidence": 0.94},
          "driverLicense": {"value": "S123-456-78-901-0", "confidence": 0.93},
          "insuranceCarrier": {"value": "XYZ Insurance", "confidence": 0.91},
          "policyNumber": {"value": "PA-987654321", "confidence": 0.90}
        },
        {
          "vehicleNumber": 2,
          "year": {"value": "2021", "confidence": 0.99},
          "make": {"value": "Toyota", "confidence": 0.99},
          "model": {"value": "Camry", "confidence": 0.98},
          "vin": {"value": "4T1BF1FK5MU123456", "confidence": 0.96},
          "driver": {"value": "Jane Doe", "confidence": 0.95}
        }
      ],
      "narrative": {"value": "Vehicle 1 was traveling northbound...", "confidence": 0.92},
      "citations": [
        {"vehicle": 1, "violation": "Following too closely", "statute": "316.0895", "confidence": 0.91}
      ],
      "injuries": {"reported": true, "details": "Driver of V2 complained of neck pain", "confidence": 0.89}
    }
  }
}
```

**Medical Bill Extraction:**

```json
{
  "extractedData": {
    "documentType": "MEDICAL_BILL",
    "confidence": 0.94,
    "fields": {
      "provider": {"value": "Tampa General Hospital", "confidence": 0.99},
      "providerNPI": {"value": "1234567890", "confidence": 0.97},
      "providerTaxId": {"value": "XX-XXXXXXX", "confidence": 0.96},
      "patientName": {"value": "Jane Doe", "confidence": 0.98},
      "patientDOB": {"value": "1990-07-22", "confidence": 0.97},
      "dateOfService": {"value": "2024-10-15", "confidence": 0.99},
      "lineItems": [
        {
          "cptCode": "99283",
          "description": "Emergency department visit, moderate severity",
          "quantity": 1,
          "charge": 1850.00,
          "confidence": 0.95
        },
        {
          "cptCode": "72141",
          "description": "MRI cervical spine without contrast",
          "quantity": 1,
          "charge": 2400.00,
          "confidence": 0.94
        },
        {
          "cptCode": "72100",
          "description": "X-ray lumbar spine, 2-3 views",
          "quantity": 1,
          "charge": 450.00,
          "confidence": 0.96
        }
      ],
      "totalCharges": {"value": 4700.00, "confidence": 0.98},
      "insurancePayment": {"value": 0.00, "confidence": 0.90},
      "patientBalance": {"value": 4700.00, "confidence": 0.93},
      "diagnosisCodes": [
        {"icd10": "S13.4XXA", "description": "Sprain of cervical spine", "confidence": 0.92},
        {"icd10": "M54.2", "description": "Cervicalgia", "confidence": 0.91}
      ]
    }
  }
}
```

---

## 9. Document Metadata Model

### Core Metadata Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| documentId | VARCHAR(30) | Yes | Unique document identifier |
| claimId | VARCHAR(20) | Yes | Associated claim |
| documentType | VARCHAR(30) | Yes | Primary classification |
| documentSubType | VARCHAR(30) | No | Secondary classification |
| documentTitle | VARCHAR(200) | No | Human-readable title |
| dateReceived | TIMESTAMP | Yes | When document was received/created |
| dateIndexed | TIMESTAMP | Yes | When document was indexed |
| source | VARCHAR(30) | Yes | Capture channel (SCAN, EMAIL, WEB, MOBILE, FAX, API) |
| senderName | VARCHAR(200) | No | Who sent the document |
| senderType | VARCHAR(30) | No | INSURED, CLAIMANT, VENDOR, ATTORNEY, PROVIDER, INTERNAL |
| pageCount | INTEGER | Yes | Number of pages |
| fileFormat | VARCHAR(10) | Yes | PDF, TIFF, JPEG, PNG, DOCX, etc. |
| fileSizeBytes | BIGINT | Yes | File size |
| storageLocation | VARCHAR(500) | Yes | CMS storage path/reference |
| ocrProcessed | BOOLEAN | Yes | Whether OCR has been run |
| ocrConfidence | DECIMAL(5,2) | No | Overall OCR confidence score |
| classificationConfidence | DECIMAL(5,2) | No | ML classification confidence |
| confidentialityLevel | VARCHAR(20) | Yes | PUBLIC, INTERNAL, CONFIDENTIAL, PRIVILEGED, PHI |
| litigationHold | BOOLEAN | No | Under litigation hold |
| retentionDate | DATE | No | Calculated retention expiration |
| versionNumber | INTEGER | Yes | Version (for updated documents) |
| parentDocumentId | VARCHAR(30) | No | For versioned documents, original |
| checksum | VARCHAR(64) | Yes | SHA-256 hash for integrity |
| createdBy | VARCHAR(50) | Yes | User/system that created |
| updatedBy | VARCHAR(50) | No | Last user/system that updated |
| createdDate | TIMESTAMP | Yes | Record creation timestamp |
| updatedDate | TIMESTAMP | Yes | Record update timestamp |

---

## 10. Content Management System Requirements

### CMS Requirements for Claims

| Requirement | Description | Priority |
|-------------|-------------|----------|
| Document storage | Store millions of documents with geo-redundancy | Critical |
| Version control | Track document versions, maintain history | Critical |
| Access control | Role-based, claim-based, confidentiality-based | Critical |
| Full-text search | Search document content, not just metadata | High |
| Audit trail | Track all access, view, download, modify actions | Critical |
| API access | REST APIs for all CRUD operations | Critical |
| Viewer | In-browser document rendering (PDF, image, video) | High |
| Annotation | Mark up, highlight, redact documents | High |
| Workflow integration | Trigger workflows on document events | High |
| Retention management | Automated retention policy enforcement | High |
| Litigation hold | Prevent purge of held documents | Critical |
| Bulk operations | Import/export large document sets | Medium |
| Metadata search | Search by any metadata field | Critical |
| Performance | < 2 second retrieval for any document | High |
| Scalability | Support 100M+ documents | High |
| Encryption | At-rest and in-transit encryption | Critical |

---

## 11. Content Management Platforms

### Platform Comparison

| Platform | Vendor | Architecture | Strengths | Claims Fit |
|----------|--------|-------------|-----------|-----------|
| OnBase | Hyland | .NET, SQL Server | Insurance vertical, workflow | Excellent |
| FileNet P8 | IBM | Java, DB2/Oracle | Enterprise scale, compliance | Excellent |
| Alfresco | Hyland | Java, open source | Modern API, flexible | Good |
| SharePoint | Microsoft | .NET, SQL Server | Microsoft ecosystem, collaboration | Moderate |
| Box | Box | Cloud-native | Cloud simplicity, collaboration | Good |
| Nuxeo | Hyland | Java, cloud-native | Modern, headless CMS | Good |

### OnBase (Hyland) for Claims

```
+-------------------------------------------------------------------+
|                   ONBASE CLAIMS ARCHITECTURE                        |
+-------------------------------------------------------------------+
|                                                                     |
|  +---------------------+     +---------------------+               |
|  | Claims System       |<--->| OnBase Integration  |               |
|  | (Guidewire, etc.)   |     | Server              |               |
|  +---------------------+     +----------+----------+               |
|                                         |                           |
|                              +----------v----------+               |
|                              | OnBase Application   |               |
|                              | Server               |               |
|                              +----------+----------+               |
|                                         |                           |
|  +--------------------+  +--------------+--+  +------------------+ |
|  | Document Storage   |  | Workflow Engine |  | Keyword Index    | |
|  | (Disk Groups,      |  | (Document      |  | (Metadata        | |
|  |  Optical, Cloud)   |  |  lifecycle)    |  |  search)         | |
|  +--------------------+  +-----------------+  +------------------+ |
|                                                                     |
|  OnBase Integrations for Claims:                                   |
|  - Unity Forms: electronic document capture                        |
|  - WorkView: custom business objects                               |
|  - Workflow: document routing and approval                         |
|  - Integration for Guidewire: certified connector                  |
|  - OCR/ICR: built-in or third-party                               |
|  - Full-text search: built-in indexing                             |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 12. ECM Integration Patterns

### Integration with Claims Management System

```
+-------------------------------------------------------------------+
|           ECM ↔ CLAIMS SYSTEM INTEGRATION PATTERNS                  |
+-------------------------------------------------------------------+
|                                                                     |
|  PATTERN 1: EMBEDDED VIEWER                                        |
|  +-------------------------------------------------------------+  |
|  | Claims UI embeds ECM document viewer (iframe/component)      |  |
|  | - User sees documents within claims application              |  |
|  | - Single sign-on (SSO) for seamless access                  |  |
|  | - Context-aware (shows documents for current claim)          |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 2: API INTEGRATION                                       |
|  +-------------------------------------------------------------+  |
|  | Claims system calls ECM REST APIs for CRUD operations       |  |
|  | - Upload: POST /documents (multipart/form-data)             |  |
|  | - Download: GET /documents/{id}/content                     |  |
|  | - Search: GET /documents?claimId=xxx&type=xxx               |  |
|  | - Metadata: GET /documents/{id}/metadata                    |  |
|  | - Delete: DELETE /documents/{id}                            |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 3: EVENT-DRIVEN                                           |
|  +-------------------------------------------------------------+  |
|  | ECM publishes events when documents are received/classified  |  |
|  | - "New document received for CLM-2024-001"                  |  |
|  | - Claims system creates activity/notification               |  |
|  | - Workflow triggers based on document type                   |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PATTERN 4: CMIS (Content Management Interoperability Services)    |
|  +-------------------------------------------------------------+  |
|  | Standard protocol for ECM integration (OASIS standard)      |  |
|  | - Supported by: Alfresco, FileNet, Nuxeo, SharePoint        |  |
|  | - Operations: getObject, query, createDocument, etc.         |  |
|  | - Binding types: AtomPub, Web Services, Browser              |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 13. Document Indexing & Search

### Search Architecture

```
+-------------------------------------------------------------------+
|                   DOCUMENT SEARCH ARCHITECTURE                      |
+-------------------------------------------------------------------+
|                                                                     |
|  Search Input: "police report for CLM-2024-0045231"               |
|       |                                                             |
|       v                                                             |
|  +---------------------+                                           |
|  | Search Gateway       |                                           |
|  | - Parse query        |                                           |
|  | - Identify search    |                                           |
|  |   type (metadata,    |                                           |
|  |   full-text, both)   |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|    +--------+---------+--------+                                   |
|    |                  |        |                                    |
|    v                  v        v                                    |
| Metadata           Full-Text  Semantic                             |
| Search             Search     Search                               |
| (SQL/API)          (Elastic-  (Vector DB /                         |
|                    search)    Embeddings)                           |
|    |                  |        |                                    |
|    v                  v        v                                    |
|  +----------+---------+--------+----------+                        |
|  | Result Aggregation & Ranking            |                        |
|  | - Merge results from all sources        |                        |
|  | - Score by relevance                    |                        |
|  | - Apply access control filters          |                        |
|  | - Return ranked results                 |                        |
|  +-----------------------------------------+                        |
|                                                                     |
+-------------------------------------------------------------------+
```

### Search Types

| Type | Technology | Use Case | Example Query |
|------|-----------|----------|---------------|
| Metadata | SQL / NoSQL query | Find by known attributes | `claimId = "CLM-2024-0045231" AND documentType = "POLICE_REPORT"` |
| Full-text | Elasticsearch / Solr | Search document content | `"cervical sprain" AND "Dr. Johnson"` |
| Semantic | Vector embeddings (OpenAI, Cohere) | Natural language search | "Find the doctor's report about the neck injury" |
| Faceted | Elasticsearch facets | Browse/filter by category | Filter by type, date range, source |

---

## 14. Image Management

### Photo/Video Management Architecture

```
+-------------------------------------------------------------------+
|                   IMAGE MANAGEMENT SYSTEM                           |
+-------------------------------------------------------------------+
|                                                                     |
|  CAPTURE                                                           |
|  +-------------------------------------------------------------+  |
|  | Mobile App:                                                  |  |
|  |   - Guided photo capture (prompts for each required angle)  |  |
|  |   - GPS tagging (latitude, longitude)                       |  |
|  |   - Timestamp embedding                                     |  |
|  |   - Compass direction                                       |  |
|  |   - EXIF data preservation                                  |  |
|  |                                                              |  |
|  | Field Adjuster:                                              |  |
|  |   - Structured photo set (exterior 4 sides, interior rooms) |  |
|  |   - Label/tag at capture                                    |  |
|  |   - Damage annotation                                       |  |
|  |   - Measurement overlay                                     |  |
|  |                                                              |  |
|  | Drone:                                                       |  |
|  |   - Automated flight pattern                                |  |
|  |   - Geotagged imagery                                       |  |
|  |   - Orthomosaic generation                                  |  |
|  |   - 3D model creation                                       |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  PROCESSING                                                        |
|  +-------------------------------------------------------------+  |
|  | - Thumbnail generation (multiple sizes)                     |  |
|  | - Image compression (optimize for web)                      |  |
|  | - EXIF data extraction                                      |  |
|  | - AI damage detection and tagging                           |  |
|  | - Face detection/blur (privacy)                              |  |
|  | - PII detection/redaction                                   |  |
|  | - Before/after comparison linkage                           |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  ANNOTATION                                                        |
|  +-------------------------------------------------------------+  |
|  | Tools:                                                       |  |
|  |   - Draw boxes/circles around damage                        |  |
|  |   - Add text labels                                         |  |
|  |   - Measurement lines                                       |  |
|  |   - Color coding by damage type                             |  |
|  |   - Severity markers                                        |  |
|  |   - Link to estimate line items                             |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 15. Correspondence Management

### Correspondence in Claims Context

Correspondence is the carrier's primary communication channel with all claim stakeholders. Every outbound communication is a regulatory touchpoint that must comply with state-specific requirements for timing, content, and delivery method.

### Correspondence Lifecycle

```
+-------------------------------------------------------------------+
|              CORRESPONDENCE LIFECYCLE                                |
+-------------------------------------------------------------------+
|                                                                     |
|  1. TRIGGER                                                        |
|     - Event (FNOL received, payment issued, claim closed)          |
|     - Rule (14-day status update required, proof of loss due)      |
|     - Manual (adjuster composes letter)                            |
|     - Scheduled (weekly status update batch)                       |
|                                                                     |
|  2. TEMPLATE SELECTION                                             |
|     - Based on: letter type, state, LOB, language                  |
|     - Regulatory-approved template                                 |
|     - Version-controlled                                           |
|                                                                     |
|  3. DATA MERGE                                                     |
|     - Claim data (numbers, dates, names, amounts)                  |
|     - Policy data (coverages, limits, deductibles)                 |
|     - Recipient data (name, address, language preference)          |
|     - Conditional sections (based on claim characteristics)        |
|                                                                     |
|  4. REVIEW & APPROVAL                                              |
|     - Auto-approval (standard correspondence)                     |
|     - Manual review (denials, large settlements, regulatory)       |
|     - Supervisor approval (coverage denials, bad faith risk)       |
|                                                                     |
|  5. DELIVERY                                                       |
|     - Print & mail (physical letter)                               |
|     - Email                                                        |
|     - Portal message                                               |
|     - SMS (short notifications)                                    |
|     - Push notification                                            |
|     - Fax (for some legal/medical providers)                       |
|                                                                     |
|  6. TRACKING                                                       |
|     - Delivery confirmation (mail tracking, email delivery)        |
|     - Read receipt (email open, portal view)                       |
|     - Response tracking (did recipient respond?)                   |
|     - Follow-up scheduling (if no response within X days)          |
|                                                                     |
|  7. STORAGE                                                        |
|     - Store in claim file (ECM)                                    |
|     - Full audit trail (who, when, what, how)                      |
|     - Retention per document retention policy                      |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 16. Correspondence Types

### Complete Correspondence Catalog

| Type | Trigger | Regulatory? | Delivery | Template Required? |
|------|---------|-------------|----------|--------------------|
| FNOL Acknowledgment | FNOL received | Yes (most states) | Mail + email | Yes |
| Adjuster Assignment | Adjuster assigned | Some states | Email + portal | Yes |
| Status Update | Periodic or milestone | Yes (many states) | Mail or email | Yes |
| Information Request | Additional info needed | Yes (documented request) | Mail | Yes |
| Reservation of Rights | Coverage question identified | Yes (critical) | Certified mail | Yes |
| Coverage Decision (grant) | Coverage determined | Yes | Mail | Yes |
| Coverage Denial | Coverage denied | Yes (strict requirements) | Certified mail | Yes |
| Settlement Offer | Offer made | Yes (documented) | Mail + email | Yes |
| Settlement Agreement | Terms agreed | Yes | Mail (with release) | Yes |
| Payment Notification | Payment issued | Yes (some states) | Email + portal | Yes |
| Proof of Loss Request | Claim investigation | Yes (NFIP required) | Certified mail | Yes |
| Proof of Loss Acknowledgment | Proof of Loss received | Yes (NFIP) | Mail | Yes |
| Claim Closing | Claim closed | Yes (most states) | Mail + email | Yes |
| Subrogation Demand | Recovery pursuit | No (but standard) | Mail | Yes |
| Salvage Notification | Total loss, salvage process | Yes (some states) | Mail | Yes |
| DOI Complaint Response | DOI inquiry | Yes (regulatory requirement) | Per DOI instructions | Yes |
| Litigation Hold Notice | Claim enters litigation | Internal legal | Internal | Yes |
| Fraud Referral | SIU referral | Internal | Internal | No |

---

## 17. Template Management

### Template Architecture

```
+-------------------------------------------------------------------+
|                   TEMPLATE MANAGEMENT SYSTEM                        |
+-------------------------------------------------------------------+
|                                                                     |
|  TEMPLATE STRUCTURE:                                               |
|  +-------------------------------------------------------------+  |
|  | Template ID: TMPL-ACK-HO-FL-EN-001                          |  |
|  |                                                              |  |
|  | Components:                                                  |  |
|  | ├── Header (company logo, return address, date)              |  |
|  | ├── Recipient block (merge: name, address)                   |  |
|  | ├── Reference line (merge: claim #, policy #, loss date)     |  |
|  | ├── Body paragraphs                                         |  |
|  | │   ├── Opening paragraph (standard)                        |  |
|  | │   ├── Conditional: Coverage summary                       |  |
|  | │   ├── Conditional: Deductible information                 |  |
|  | │   ├── Conditional: Named storm deductible                 |  |
|  | │   ├── Conditional: Flood notice (if flood zone)           |  |
|  | │   ├── Next steps paragraph (standard)                     |  |
|  | │   └── Contact information                                 |  |
|  | ├── Closing (signature, adjuster name, phone, email)        |  |
|  | └── Footer (regulatory disclosures, website)                |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  TEMPLATE VERSIONING:                                              |
|  +-------------------------------------------------------------+  |
|  | Version | Effective Date | Approved By | Status              |  |
|  | 1.0     | 2023-01-01     | Legal Dept  | Superseded         |  |
|  | 1.1     | 2023-07-01     | Legal Dept  | Superseded         |  |
|  | 2.0     | 2024-01-01     | Legal Dept  | Active             |  |
|  | 2.1     | 2024-07-01     | Legal Dept  | Draft (in review)  |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

### Merge Fields

| Category | Merge Field | Source | Example |
|----------|------------|-------|---------|
| Claim | `{{claim.number}}` | Claims system | CLM-2024-0045231 |
| Claim | `{{claim.lossDate}}` | Claims system | October 10, 2024 |
| Claim | `{{claim.lossDescription}}` | Claims system | Wind damage to roof |
| Claim | `{{claim.adjusterName}}` | Claims system | Sarah Johnson |
| Claim | `{{claim.adjusterPhone}}` | Claims system | (813) 555-0456 |
| Claim | `{{claim.adjusterEmail}}` | Claims system | sarah.johnson@company.com |
| Policy | `{{policy.number}}` | Policy system | HO-123456789 |
| Policy | `{{policy.effectiveDate}}` | Policy system | January 1, 2024 |
| Policy | `{{policy.expirationDate}}` | Policy system | January 1, 2025 |
| Policy | `{{policy.deductible}}` | Policy system | $2,500 |
| Insured | `{{insured.name}}` | Policy/claims | John Smith |
| Insured | `{{insured.address}}` | Policy/claims | 123 Ocean Drive, Tampa, FL 33701 |
| Payment | `{{payment.amount}}` | Claims system | $40,231.89 |
| Payment | `{{payment.method}}` | Claims system | ACH Direct Deposit |
| Payment | `{{payment.date}}` | Claims system | October 26, 2024 |
| Date | `{{today}}` | System | April 16, 2026 |
| Regulatory | `{{state.doiPhone}}` | Reference data | (850) 413-3140 |
| Regulatory | `{{state.doiAddress}}` | Reference data | 200 East Gaines Street, Tallahassee, FL 32399 |

---

## 18. Correspondence Generation

### Generation Modes

| Mode | Trigger | Volume | Review | Use Case |
|------|---------|--------|--------|----------|
| Manual | Adjuster clicks "Generate Letter" | One at a time | Adjuster reviews before send | Custom correspondence, complex situations |
| Rule-triggered | Business rule fires on claim event | One per event | Automated (no review for standard) | FNOL acknowledgment, payment notification |
| Event-triggered | System event (status change, payment) | One per event | Automated or spot-check | Status updates, milestone notifications |
| Batch | Scheduled job (daily, weekly) | Hundreds to thousands | Spot-check sampling | Weekly status updates, periodic compliance |
| Template-driven | Template selection + data merge | One at a time | Optional review | Standard letters with custom data |

### Correspondence Generation Engine

```
+-------------------------------------------------------------------+
|              CORRESPONDENCE GENERATION ENGINE                       |
+-------------------------------------------------------------------+
|                                                                     |
|  Input:                                                            |
|  - Letter type (e.g., ACKNOWLEDGMENT)                             |
|  - Claim ID                                                       |
|  - Recipient                                                       |
|  - Delivery channel preference                                    |
|  - Language preference                                             |
|       |                                                             |
|       v                                                             |
|  +---------------------+                                           |
|  | Template Resolver    |                                           |
|  | - Match by: type +   |                                           |
|  |   state + LOB +      |                                           |
|  |   language + channel |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Data Collector       |                                           |
|  | - Claim data         |                                           |
|  | - Policy data        |                                           |
|  | - Contact data       |                                           |
|  | - Regulatory data    |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Template Engine       |                                           |
|  | (e.g., Apache FreeMarker,                                       |
|  |  Thymeleaf, Handlebars,                                         |
|  |  custom engine)       |                                           |
|  | - Merge data into     |                                          |
|  |   template            |                                          |
|  | - Evaluate conditions  |                                         |
|  | - Format dates/currency|                                         |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Output Formatter      |                                          |
|  | - PDF generation      |                                          |
|  | - HTML (for email)    |                                          |
|  | - Plain text (for SMS)|                                          |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Delivery Router       |                                          |
|  | - Route to print vendor|                                         |
|  | - Send via email       |                                         |
|  | - Post to portal       |                                         |
|  | - Send SMS             |                                         |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Audit & Store         |                                          |
|  | - Log generation       |                                         |
|  | - Store copy in ECM    |                                         |
|  | - Update claim activity|                                         |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 19. Correspondence Delivery Channels

### Channel Selection Logic

```
Priority Order (configurable per carrier):
1. Customer preference (if set)
2. Regulatory requirement (some letters MUST be mailed)
3. Delivery urgency
4. Cost optimization
5. Default channel

Rules:
  IF letterType IN ('DENIAL', 'RESERVATION_OF_RIGHTS')
    THEN channel = CERTIFIED_MAIL + EMAIL_COPY
  
  IF letterType = 'ACKNOWLEDGMENT' AND customer.emailOptIn = TRUE
    THEN channel = EMAIL + PORTAL_MESSAGE
  
  IF letterType = 'PAYMENT_NOTIFICATION'
    THEN channel = EMAIL + SMS + PUSH_NOTIFICATION
  
  IF customer.preferredChannel = 'DIGITAL' AND letterType NOT IN regulatoryMailRequired
    THEN channel = EMAIL + PORTAL_MESSAGE
  
  DEFAULT: PHYSICAL_MAIL + EMAIL_COPY
```

### Channel Comparison

| Channel | Delivery Time | Cost | Tracking | Legal Proof | Best For |
|---------|-------------|------|----------|-------------|----------|
| Physical mail (1st class) | 3–7 days | $0.75–$1.50 | USPS tracking (limited) | Mailing certificate | Formal correspondence |
| Certified mail | 3–7 days | $4.00–$8.00 | Full tracking + signature | Strong legal proof | Denials, ROR, POL requests |
| Email | Instant | $0.01–$0.05 | Open/click tracking | Moderate (with metadata) | Status updates, notifications |
| Portal message | Instant | $0.00 | View tracking | Good (with audit log) | All non-regulatory |
| SMS | Instant | $0.02–$0.10 | Delivery receipt | Weak | Short notifications |
| Push notification | Instant | $0.01 | Delivery/open tracking | Weak | Alerts, status updates |
| Fax | Minutes | $0.10–$0.50 | Transmission confirmation | Good | Medical providers, legal |

---

## 20. Correspondence Template Engine Architecture

### Technology Options

| Engine | Language | Features | Claims Fit |
|--------|---------|----------|-----------|
| Apache FreeMarker | Java | Templates, macros, conditions | Excellent (Guidewire compatible) |
| Thymeleaf | Java | Natural templates, HTML-native | Good (Spring ecosystem) |
| Handlebars | JavaScript | Simple, logic-less templates | Good (Node.js apps) |
| Mustache | Multi-language | Minimal logic, cross-platform | Moderate |
| XSLT | XML | XML transformation, PDF generation | Good (legacy systems) |
| Custom engines | Various | Full control, complex logic | Complex but flexible |

### FreeMarker Template Example

```
<#-- Template: FNOL Acknowledgment Letter -->
<#-- Template ID: TMPL-ACK-HO-${state}-EN -->

${companyName}
${companyAddress}

${today?string("MMMM d, yyyy")}

${insured.fullName}
${insured.address.street}
${insured.address.city}, ${insured.address.state} ${insured.address.zip}

Re: Claim Number: ${claim.number}
    Policy Number: ${policy.number}
    Date of Loss: ${claim.lossDate?string("MMMM d, yyyy")}
    Loss Location: ${claim.lossLocation}

Dear ${insured.salutation} ${insured.lastName}:

Thank you for reporting your claim to ${companyName}. We understand this is a
difficult time and we are committed to handling your claim promptly and fairly.

Your claim has been assigned to ${claim.adjuster.fullName}, who can be reached
at ${claim.adjuster.phone} or ${claim.adjuster.email}. Your adjuster will
contact you within ${state.contactTimelineDays} business days to discuss your claim.

<#if claim.coverages?size gt 0>
Based on our initial review of your policy, the following coverages may apply:

<#list claim.coverages as coverage>
  - ${coverage.name}: ${coverage.limit?string.currency}
    (Deductible: ${coverage.deductible?string.currency})
</#list>

</#if>
<#if claim.isCAT>
This claim is associated with ${claim.catEvent.name}. Due to the large volume
of claims from this event, processing times may be longer than usual. We
appreciate your patience and will keep you informed of progress.

</#if>
WHAT TO DO NEXT:

1. Document the damage with photographs and video if possible
2. Make temporary repairs to prevent further damage (keep all receipts)
3. Do NOT dispose of damaged property until your adjuster has inspected it
4. Gather any receipts or documentation related to your loss
5. Contact your adjuster with any questions

<#if state.code == "FL">
IMPORTANT FLORIDA NOTICE:
Pursuant to Section 627.70131, Florida Statutes, ${companyName} will
investigate this claim and provide you with a coverage determination
within 90 days of receiving your claim.

If you have any complaints about the handling of this claim, you may
contact the Florida Office of Insurance Regulation at ${state.doiPhone}
or ${state.doiWebsite}.

</#if>
Sincerely,

${claim.adjuster.fullName}
Claims Adjuster
${claim.adjuster.phone}
${claim.adjuster.email}

${companyName}
${companyWebsite}
```

---

## 21. Print Vendor Integration

### Print Vendor Landscape

| Vendor | Specialty | Volume Capability | Turnaround |
|--------|-----------|------------------|------------|
| Broadridge | Financial communications, regulatory | Millions/month | 24–48 hours |
| Ricoh (DocuStar) | Transactional print | Millions/month | 24–48 hours |
| Pitney Bowes | Mailing solutions, print + mail | Millions/month | 24–72 hours |
| OSG Billing | Insurance-specific print | Millions/month | 24–48 hours |
| In-house print | Local letters, urgent correspondence | Thousands/month | Same day |

### Print Vendor Integration Flow

```
+-------------------------------------------------------------------+
|                   PRINT VENDOR INTEGRATION                          |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System → Correspondence Engine                             |
|       |                                                             |
|       | Generated PDF / Data file                                   |
|       v                                                             |
|  +---------------------+                                           |
|  | Print Job Manager    |                                           |
|  | - Batch collection   |                                           |
|  | - Priority sorting   |                                           |
|  | - SLA assignment     |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | File Preparation     |                                           |
|  | - PDF composition    |                                           |
|  | - Postal optimization|                                           |
|  | - Barcode insertion  |                                           |
|  | - Return envelope    |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|             | SFTP / API transfer                                   |
|             v                                                       |
|  +---------------------+                                           |
|  | Print Vendor         |                                           |
|  | (Broadridge, etc.)   |                                           |
|  | - Print              |                                           |
|  | - Fold/insert        |                                           |
|  | - Address/postage    |                                           |
|  | - USPS hand-off      |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|             | Status updates (API / file)                           |
|             v                                                       |
|  +---------------------+                                           |
|  | Tracking Service     |                                           |
|  | - Print confirmed    |                                           |
|  | - Mailed date        |                                           |
|  | - USPS tracking #    |                                           |
|  | - Delivery status    |                                           |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 22. Email & Digital Delivery Integration

### Email Delivery Architecture

```
+-------------------------------------------------------------------+
|                   EMAIL DELIVERY SYSTEM                              |
+-------------------------------------------------------------------+
|                                                                     |
|  Correspondence Engine                                             |
|       |                                                             |
|       | HTML email + PDF attachment                                 |
|       v                                                             |
|  +---------------------+                                           |
|  | Email Service        |                                           |
|  | (SendGrid, AWS SES,  |                                           |
|  |  Mailgun, or custom) |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Email Composition     |                                          |
|  | - HTML body           |                                          |
|  | - PDF attachment      |                                          |
|  | - Reply-to address    |                                          |
|  | - Tracking pixel      |                                          |
|  | - Unsubscribe link    |                                          |
|  | - DKIM signing        |                                          |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Delivery Engine       |                                          |
|  | - Queue management    |                                          |
|  | - Retry on failure    |                                          |
|  | - Bounce handling     |                                          |
|  | - Complaint handling  |                                          |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Tracking & Analytics  |                                          |
|  | - Delivered / Bounced |                                          |
|  | - Opened / Not opened |                                          |
|  | - Link clicks         |                                          |
|  | - Unsubscribes        |                                          |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 23. Regulatory Correspondence Requirements

### State-Specific Timelines

| State | FNOL Acknowledgment | Status Updates | Payment After Agreement | Denial Notification |
|-------|-------------------|----------------|------------------------|-------------------|
| Florida | 14 calendar days | Every 30 days | 90 days from FNOL | Written, specific reasons |
| Texas | 15 business days (acknowledge + begin investigation) | Every 30 days | Within 5 business days of agreement | Written, specific reasons |
| California | 15 calendar days | Every 30 days | Within 30 calendar days | Written, specific reasons, 1 year to sue |
| New York | 15 business days | Every 90 days | Within 35 business days | Written with specific reasons |
| Louisiana | 30 calendar days | No specific requirement | 30 days from agreement | Written, specific reasons |
| Georgia | 15 business days | Every 30 days (if requested) | Within 10 business days | Written, specific reasons |
| North Carolina | Per UCSPA | Reasonable updates | Promptly | Written, specific reasons |
| Illinois | Per Fair Claims Practices | Every 45 days | Promptly | Written, specific reasons |
| Pennsylvania | 10 business days (acknowledge) | Every 30 days | Within 15 business days | Written, specific reasons |
| New Jersey | Per UCSPA | Every 30 days | Within 10 calendar days | Written, within 30 days of determination |

### Required Content for Denial Letters

```
A proper denial letter MUST contain (varies by state):

1. HEADER INFORMATION
   - Company name and address
   - Date of letter
   - Claim number
   - Policy number
   - Date of loss

2. DENIAL SPECIFICS
   - Specific policy provisions that apply
   - Exact language of exclusion/condition/limitation
   - Clear statement of why coverage does not apply
   - Factual basis for the denial decision

3. CLAIMANT RIGHTS
   - Right to appeal (and how to appeal)
   - Right to request reconsideration with additional information
   - Right to file complaint with state DOI
   - DOI contact information (address, phone, website)
   - Statute of limitations for legal action (state-specific)
   - Right to consult an attorney

4. CONTACT INFORMATION
   - Adjuster name and direct contact
   - Supervisor name and contact
   - Company complaint/grievance process

5. STATE-SPECIFIC ADDITIONS (examples):
   - FL: "You may contact the Florida Office of Insurance Regulation..."
   - CA: "Under California law, you have one year to bring legal action..."
   - TX: "If you are dissatisfied with this determination..."
   - NY: "You may contact the NY Department of Financial Services..."
```

---

## 24. Correspondence Tracking

### Tracking Data Model

```json
{
  "correspondenceTracking": {
    "correspondenceId": "CORR-2024-0045231-001",
    "claimId": "CLM-2024-0045231",
    "templateId": "TMPL-ACK-HO-FL-EN-001",
    "letterType": "FNOL_ACKNOWLEDGMENT",
    "generatedDate": "2024-10-11T10:30:00Z",
    "generatedBy": "SYSTEM",
    "approvedDate": "2024-10-11T10:30:00Z",
    "approvedBy": "AUTO",
    "delivery": [
      {
        "channel": "PHYSICAL_MAIL",
        "status": "DELIVERED",
        "sentDate": "2024-10-12T08:00:00Z",
        "printVendor": "BROADRIDGE",
        "printJobId": "BR-2024-789012",
        "uspsTrackingNumber": "9400111899223100001234",
        "deliveredDate": "2024-10-16T14:23:00Z",
        "deliveredTo": "MAILBOX"
      },
      {
        "channel": "EMAIL",
        "status": "OPENED",
        "sentDate": "2024-10-11T10:35:00Z",
        "emailProvider": "SENDGRID",
        "messageId": "sg-msg-2024-456789",
        "deliveredDate": "2024-10-11T10:35:12Z",
        "openedDate": "2024-10-11T11:02:34Z",
        "openCount": 3,
        "linkClicks": 1
      },
      {
        "channel": "PORTAL",
        "status": "VIEWED",
        "postedDate": "2024-10-11T10:35:00Z",
        "viewedDate": "2024-10-11T14:15:22Z"
      }
    ],
    "response": {
      "responseRequired": false,
      "responseReceived": false,
      "responseDeadline": null
    },
    "regulatoryCompliance": {
      "timelineRequirement": "14_CALENDAR_DAYS",
      "requiredByDate": "2024-10-25",
      "sentDate": "2024-10-11",
      "compliant": true,
      "daysBeforeDeadline": 14
    }
  }
}
```

---

## 25. Document Retention Policies

### Retention by Document Type

| Document Type | Minimum Retention | Trigger | Notes |
|--------------|------------------|---------|-------|
| Claim file (all documents) | Claim closure + 7 years | Claim close date | Minimum; some states require longer |
| Correspondence | Claim closure + 7 years | Claim close date | Regulatory touchpoints |
| Payment records | Claim closure + 7 years | Last payment date | Financial audit requirement |
| Medical records (BI) | Claim closure + 10 years | Claim close date | Longer due to statute of limitations |
| Medical records (WC) | Claim closure + 30 years | Claim close date | Long tail exposures |
| Legal documents | Permanent or closure + 15 years | Case resolution | Varies by significance |
| Photos/video | Claim closure + 7 years | Claim close date | May archive to cold storage |
| Subrogation records | Recovery completion + 7 years | Final recovery | Financial records |
| Fraud investigation | Investigation close + 10 years | Investigation close | SIU requirement |
| DOI complaints | Resolution + 10 years | Resolution date | Regulatory requirement |
| Policy documents | Policy expiration + 7 years | Expiration date | Backing documentation |

### Retention Architecture

```
+-------------------------------------------------------------------+
|                   DOCUMENT RETENTION MANAGEMENT                     |
+-------------------------------------------------------------------+
|                                                                     |
|  HOT STORAGE (Primary ECM)                                         |
|  Duration: Active claim + 2 years post-closure                     |
|  Storage: SSD/fast storage, full indexing                          |
|  Access: Instant retrieval (< 2 seconds)                           |
|  Cost: $$$                                                         |
|                                                                     |
|  WARM STORAGE (Archive Tier 1)                                     |
|  Duration: 2–7 years post-closure                                  |
|  Storage: HDD/standard storage, index preserved                    |
|  Access: Fast retrieval (< 30 seconds)                             |
|  Cost: $$                                                          |
|                                                                     |
|  COLD STORAGE (Archive Tier 2)                                     |
|  Duration: 7+ years post-closure                                   |
|  Storage: Object storage (S3 Glacier, Azure Archive)               |
|  Access: Delayed retrieval (1–12 hours)                            |
|  Cost: $                                                           |
|                                                                     |
|  PURGE                                                             |
|  Trigger: Retention period expired AND no holds                    |
|  Process: Automated with approval workflow                         |
|  Verification: No litigation hold, no regulatory hold              |
|  Execution: Secure deletion with certificate                       |
|  Audit: Purge log maintained permanently                           |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 26. Litigation Hold & E-Discovery

### Litigation Hold Process

```
+-------------------------------------------------------------------+
|                   LITIGATION HOLD PROCESS                           |
+-------------------------------------------------------------------+
|                                                                     |
|  1. HOLD TRIGGER                                                   |
|     - Lawsuit filed (complaint received)                           |
|     - Pre-litigation demand letter (reasonably anticipated)        |
|     - Regulatory investigation                                     |
|     - Internal investigation                                       |
|                                                                     |
|  2. HOLD SCOPE DEFINITION                                          |
|     - Claim(s) affected                                            |
|     - Document types in scope                                      |
|     - Custodians (people with relevant documents)                  |
|     - Date range                                                   |
|     - Systems containing responsive documents                      |
|                                                                     |
|  3. HOLD IMPLEMENTATION                                            |
|     - Suspend retention/purge for in-scope documents               |
|     - Tag documents with litigation hold flag                      |
|     - Notify custodians (preservation notice)                      |
|     - Block automated deletion                                     |
|     - Preserve electronic metadata                                 |
|                                                                     |
|  4. HOLD MONITORING                                                |
|     - Periodic reminder notices to custodians                      |
|     - New document capture monitoring                              |
|     - Hold compliance verification                                 |
|                                                                     |
|  5. HOLD RELEASE                                                   |
|     - Litigation resolved                                          |
|     - Legal department authorizes release                          |
|     - Remove hold tags                                             |
|     - Resume normal retention processing                           |
|                                                                     |
+-------------------------------------------------------------------+
```

### E-Discovery Workflow

```
EDRM (Electronic Discovery Reference Model):

  +------------+     +----------+     +----------+
  |Information |---->|Identifi- |---->|Preser-   |
  |Governance  |     |cation    |     |vation    |
  +------------+     +----------+     +----------+
                                           |
  +------------+     +----------+     +----v-----+
  |Presentation|<----|Production|<----|Collection|
  +------------+     +----------+     +----------+
                          ^                |
                     +----+-----+     +----v-----+
                     |Review    |<----|Processing|
                     +----------+     +----------+
                                           |
                                      +----v-----+
                                      |Analysis  |
                                      +----------+
```

---

## 27. Document Security & Access Control

### Access Control Model

```
+-------------------------------------------------------------------+
|              DOCUMENT ACCESS CONTROL MODEL                          |
+-------------------------------------------------------------------+
|                                                                     |
|  LAYER 1: ROLE-BASED ACCESS CONTROL (RBAC)                        |
|  +-------------------------------------------------------------+  |
|  | Role               | View | Upload | Download | Delete | Admin|  |
|  |--------------------+------+--------+----------+--------+------|  |
|  | Claims Adjuster    | Own  | Yes    | Yes      | No     | No   |  |
|  | Claims Supervisor  | Team | Yes    | Yes      | No     | No   |  |
|  | Claims Manager     | Dept | Yes    | Yes      | Yes    | No   |  |
|  | SIU Investigator   | SIU  | Yes    | Yes      | No     | No   |  |
|  | Legal Counsel      | Lit  | Yes    | Yes      | No     | No   |  |
|  | Vendor (IA)        | Asgn | Yes    | Yes      | No     | No   |  |
|  | Customer (Portal)  | Own  | Yes    | Own      | No     | No   |  |
|  | System Admin       | All  | Yes    | Yes      | Yes    | Yes  |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  LAYER 2: CLAIM-BASED ACCESS                                      |
|  +-------------------------------------------------------------+  |
|  | - User can only access documents for claims assigned to them |  |
|  | - Supervisor can access team's claims                        |  |
|  | - Manager can access department's claims                     |  |
|  | - Cross-claim access requires explicit grant                 |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  LAYER 3: CONFIDENTIALITY-BASED ACCESS                             |
|  +-------------------------------------------------------------+  |
|  | Level          | Who Can Access                               |  |
|  |----------------+---------------------------------------------|  |
|  | PUBLIC         | All authorized users                         |  |
|  | INTERNAL       | Internal employees only (no vendors)         |  |
|  | CONFIDENTIAL   | Specific roles only (adjuster + supervisor)  |  |
|  | PRIVILEGED     | Legal department only (attorney-client)      |  |
|  | PHI            | Authorized medical reviewers + adjuster      |  |
|  | SIU_ONLY       | SIU investigators only                       |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+-------------------------------------------------------------------+
```

---

## 28. Digital Signature & E-Consent

### Digital Signature Integration

```
+-------------------------------------------------------------------+
|              DIGITAL SIGNATURE INTEGRATION                          |
+-------------------------------------------------------------------+
|                                                                     |
|  Claims System                                                     |
|       |                                                             |
|       | Signature request (document + signer info)                  |
|       v                                                             |
|  +---------------------+                                           |
|  | E-Sign Platform      |                                           |
|  | (DocuSign, Adobe     |                                           |
|  |  Sign, HelloSign)    |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Envelope Creation    |                                           |
|  | - Upload document    |                                           |
|  | - Define sign fields |                                           |
|  | - Define signer order|                                           |
|  | - Set expiration     |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Signer Notification  |                                           |
|  | - Email with link    |                                           |
|  | - SMS notification   |                                           |
|  | - In-app notification|                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Signing Ceremony     |                                           |
|  | - Identity verif.    |                                           |
|  | - Document review    |                                           |
|  | - Signature capture  |                                           |
|  | - Audit trail        |                                           |
|  +----------+----------+                                           |
|             |                                                       |
|  +----------v----------+                                           |
|  | Completion           |                                           |
|  | - Signed PDF returned|                                           |
|  | - Certificate of     |                                           |
|  |   completion         |                                           |
|  | - Webhook callback   |                                           |
|  | - Store in ECM       |                                           |
|  +---------------------+                                           |
|                                                                     |
+-------------------------------------------------------------------+
```

### Documents Requiring Signature in Claims

| Document | Signer(s) | E-Sign Eligible | Authentication |
|----------|----------|----------------|----------------|
| Proof of Loss | Insured | State-dependent | KBA or SMS |
| Settlement Release | Insured + Claimant | Yes (most states) | KBA or SMS |
| Medical Authorization (HIPAA) | Claimant | Yes | KBA |
| Sworn Statement | Insured | State-dependent (notary may be required) | KBA + video notary |
| Contractor Authorization | Insured | Yes | Email + SMS |
| Rental Agreement | Insured | Yes | Email |
| Salvage Title Transfer | Insured | State-dependent | KBA |
| Subrogation Release | Third party | Yes | Email |

---

## 29. Document Data Model Complete Schema

```sql
CREATE TABLE document (
    document_id         VARCHAR(30)     PRIMARY KEY,
    claim_id            VARCHAR(20)     NOT NULL,
    policy_number       VARCHAR(20),
    document_type       VARCHAR(30)     NOT NULL,
    document_sub_type   VARCHAR(30),
    document_title      VARCHAR(200),
    date_received       TIMESTAMP       NOT NULL,
    date_indexed        TIMESTAMP,
    date_created_original DATE,
    source_channel      VARCHAR(20)     NOT NULL
        CHECK (source_channel IN ('SCAN','EMAIL','WEB_UPLOAD','MOBILE',
               'FAX','API','EDI','SYSTEM_GENERATED','MANUAL')),
    sender_name         VARCHAR(200),
    sender_type         VARCHAR(20)
        CHECK (sender_type IN ('INSURED','CLAIMANT','VENDOR','ATTORNEY',
               'MEDICAL_PROVIDER','AGENT','REGULATOR','INTERNAL','OTHER')),
    page_count          INTEGER         NOT NULL DEFAULT 1,
    file_format         VARCHAR(10)     NOT NULL,
    file_size_bytes     BIGINT          NOT NULL,
    storage_location    VARCHAR(500)    NOT NULL,
    storage_tier        VARCHAR(20)     DEFAULT 'HOT'
        CHECK (storage_tier IN ('HOT','WARM','COLD','ARCHIVE')),
    ocr_processed       BOOLEAN         DEFAULT FALSE,
    ocr_confidence      DECIMAL(5,2),
    ocr_text_location   VARCHAR(500),
    classification_method VARCHAR(20)
        CHECK (classification_method IN ('ML_AUTO','RULE_BASED','MANUAL','HYBRID')),
    classification_confidence DECIMAL(5,2),
    confidentiality_level VARCHAR(20)   NOT NULL DEFAULT 'INTERNAL'
        CHECK (confidentiality_level IN ('PUBLIC','INTERNAL','CONFIDENTIAL',
               'PRIVILEGED','PHI','SIU_ONLY')),
    litigation_hold     BOOLEAN         DEFAULT FALSE,
    litigation_hold_id  VARCHAR(20),
    retention_policy_id VARCHAR(20),
    retention_expiry_date DATE,
    is_current_version  BOOLEAN         DEFAULT TRUE,
    version_number      INTEGER         DEFAULT 1,
    parent_document_id  VARCHAR(30),
    checksum_sha256     VARCHAR(64)     NOT NULL,
    tags                TEXT[],
    created_by          VARCHAR(50)     NOT NULL,
    updated_by          VARCHAR(50),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE document_extraction (
    extraction_id       VARCHAR(30)     PRIMARY KEY,
    document_id         VARCHAR(30)     NOT NULL REFERENCES document(document_id),
    extraction_engine   VARCHAR(30)     NOT NULL,
    extraction_date     TIMESTAMP       NOT NULL,
    overall_confidence  DECIMAL(5,2),
    extracted_fields    JSONB           NOT NULL,
    validation_status   VARCHAR(20)     DEFAULT 'PENDING'
        CHECK (validation_status IN ('PENDING','VALIDATED','REJECTED','MANUAL_REVIEW')),
    validated_by        VARCHAR(50),
    validated_date      TIMESTAMP,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE correspondence (
    correspondence_id   VARCHAR(30)     PRIMARY KEY,
    claim_id            VARCHAR(20)     NOT NULL,
    template_id         VARCHAR(30)     NOT NULL,
    letter_type         VARCHAR(30)     NOT NULL,
    generation_trigger  VARCHAR(20)     NOT NULL
        CHECK (generation_trigger IN ('MANUAL','RULE','EVENT','BATCH','SCHEDULED')),
    generated_date      TIMESTAMP       NOT NULL,
    generated_by        VARCHAR(50)     NOT NULL,
    approved_date       TIMESTAMP,
    approved_by         VARCHAR(50),
    document_id         VARCHAR(30)     REFERENCES document(document_id),
    recipient_name      VARCHAR(200)    NOT NULL,
    recipient_type      VARCHAR(20)     NOT NULL,
    recipient_address   TEXT,
    recipient_email     VARCHAR(200),
    language            VARCHAR(5)      DEFAULT 'en-US',
    status              VARCHAR(20)     DEFAULT 'GENERATED'
        CHECK (status IN ('DRAFT','GENERATED','APPROVED','SENT','DELIVERED',
               'FAILED','CANCELLED')),
    regulatory_required BOOLEAN         DEFAULT FALSE,
    regulatory_deadline DATE,
    regulatory_compliant BOOLEAN,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE correspondence_delivery (
    delivery_id         VARCHAR(30)     PRIMARY KEY,
    correspondence_id   VARCHAR(30)     NOT NULL REFERENCES correspondence(correspondence_id),
    channel             VARCHAR(20)     NOT NULL
        CHECK (channel IN ('PHYSICAL_MAIL','CERTIFIED_MAIL','EMAIL','PORTAL',
               'SMS','PUSH_NOTIFICATION','FAX')),
    vendor              VARCHAR(50),
    vendor_job_id       VARCHAR(50),
    sent_date           TIMESTAMP,
    delivered_date      TIMESTAMP,
    delivery_status     VARCHAR(20)     DEFAULT 'PENDING'
        CHECK (delivery_status IN ('PENDING','SENT','IN_TRANSIT','DELIVERED',
               'BOUNCED','FAILED','RETURNED','OPENED','CLICKED')),
    tracking_number     VARCHAR(50),
    delivery_proof      TEXT,
    opened_date         TIMESTAMP,
    open_count          INTEGER         DEFAULT 0,
    cost                DECIMAL(8,2),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE correspondence_template (
    template_id         VARCHAR(30)     PRIMARY KEY,
    template_name       VARCHAR(200)    NOT NULL,
    letter_type         VARCHAR(30)     NOT NULL,
    state               VARCHAR(2),
    line_of_business    VARCHAR(20),
    language            VARCHAR(5)      DEFAULT 'en-US',
    channel             VARCHAR(20),
    version             INTEGER         NOT NULL DEFAULT 1,
    status              VARCHAR(20)     DEFAULT 'DRAFT'
        CHECK (status IN ('DRAFT','IN_REVIEW','APPROVED','ACTIVE','RETIRED')),
    effective_date      DATE,
    retirement_date     DATE,
    template_content    TEXT            NOT NULL,
    merge_fields        JSONB,
    conditional_sections JSONB,
    approved_by         VARCHAR(50),
    approved_date       DATE,
    regulatory_approved BOOLEAN         DEFAULT FALSE,
    created_by          VARCHAR(50),
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE litigation_hold (
    hold_id             VARCHAR(20)     PRIMARY KEY,
    hold_name           VARCHAR(200)    NOT NULL,
    hold_type           VARCHAR(20)     NOT NULL
        CHECK (hold_type IN ('LITIGATION','REGULATORY','INVESTIGATION','INTERNAL')),
    claim_ids           TEXT[]          NOT NULL,
    document_scope      TEXT,
    custodians          TEXT[],
    date_range_start    DATE,
    date_range_end      DATE,
    hold_start_date     DATE            NOT NULL,
    hold_end_date       DATE,
    status              VARCHAR(20)     DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE','RELEASED','EXPIRED')),
    legal_case_number   VARCHAR(50),
    authorized_by       VARCHAR(50)     NOT NULL,
    release_authorized_by VARCHAR(50),
    notes               TEXT,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_document_claim ON document(claim_id);
CREATE INDEX idx_document_type ON document(document_type);
CREATE INDEX idx_document_received ON document(date_received);
CREATE INDEX idx_document_retention ON document(retention_expiry_date) WHERE retention_expiry_date IS NOT NULL;
CREATE INDEX idx_document_hold ON document(litigation_hold) WHERE litigation_hold = TRUE;
CREATE INDEX idx_correspondence_claim ON correspondence(claim_id);
CREATE INDEX idx_correspondence_type ON correspondence(letter_type);
CREATE INDEX idx_correspondence_deadline ON correspondence(regulatory_deadline) WHERE regulatory_required = TRUE;
```

---

## 30. Sample Correspondence Templates

### Settlement Offer Letter

```
[Company Letterhead]

[Date]

[Insured Name]
[Insured Address]
[City, State ZIP]

Re: Claim Number: [Claim Number]
    Policy Number: [Policy Number]
    Date of Loss: [Loss Date]
    Loss Location: [Loss Location]

Dear [Insured Name]:

We have completed our investigation and evaluation of your claim for
damages resulting from [loss description] on [loss date].

SETTLEMENT SUMMARY:

  Coverage A - Dwelling:
    Replacement Cost Value (RCV):     $[RCV Amount]
    Less Depreciation:                ($[Depreciation])
    Actual Cash Value (ACV):          $[ACV Amount]
    Less Deductible:                  ($[Deductible])
    Net ACV Payment:                  $[Net ACV]

  Coverage B - Other Structures:
    Net ACV Payment:                  $[Cov B Amount]

  Coverage D - Additional Living Expense:
    ALE Payment:                      $[ALE Amount]

  TOTAL SETTLEMENT:                   $[Total Amount]

DEPRECIATION HOLDBACK:
The difference between the RCV and ACV ($[Holdback]) will be paid upon
completion of repairs, provided repairs are completed within [X] months
of this offer and you submit documentation of the completed repairs.

PAYMENT METHOD:
[If ACH] Payment will be deposited to your bank account on file within
3-5 business days of your acceptance.
[If Check] A check will be mailed to the address above within 7-10
business days of your acceptance.

[If Mortgagee] As required by your policy, the payment for dwelling
damage will be made payable to both you and your mortgage company,
[Mortgagee Name].

TO ACCEPT THIS OFFER:
Please sign and return the enclosed settlement acceptance form, or
accept digitally using the secure link sent to your email at
[insured email].

If you disagree with this settlement, you may:
1. Contact your adjuster to discuss specific items
2. Provide additional documentation supporting a different amount
3. Request an appraisal under your policy's appraisal provision

[State-specific rights notice]

If you have any questions, please contact me directly.

Sincerely,

[Adjuster Name]
[Title]
[Phone]
[Email]

Enclosures: Settlement Acceptance Form, Estimate Summary
```

### Denial Letter

```
[Company Letterhead]

[Date]

VIA CERTIFIED MAIL AND FIRST CLASS MAIL

[Insured/Claimant Name]
[Address]
[City, State ZIP]

Re: Claim Number: [Claim Number]
    Policy Number: [Policy Number]
    Date of Loss: [Loss Date]

Dear [Insured/Claimant Name]:

We have completed our investigation of the above-referenced claim.
Based on our thorough review of the facts and applicable policy
provisions, we must respectfully deny coverage for this claim.

POLICY PROVISIONS:

Your policy, [Policy Number], effective [Effective Date] to
[Expiration Date], contains the following relevant provision:

  SECTION I - EXCLUSIONS
  "[Exact policy exclusion language quoted verbatim]"

FACTUAL BASIS:

Based on our investigation, which included [investigation activities -
inspection, expert report, recorded statement, etc.], we determined
that [factual findings that trigger the exclusion].

[Detailed explanation of why the facts meet the exclusion]

CONCLUSION:

Based on the above policy provisions and factual findings, the claimed
loss is not covered under your policy because [clear statement of why].

YOUR RIGHTS:

1. ADDITIONAL INFORMATION: If you have additional information that
   you believe is relevant to this determination, please provide it
   to your adjuster within 60 days.

2. RECONSIDERATION: You may request reconsideration of this decision
   by submitting a written request to [address/email].

3. APPRAISAL: [If applicable] Your policy contains an appraisal
   provision that may be applicable.

4. DEPARTMENT OF INSURANCE: You may contact the [State] Department
   of Insurance at:
   [DOI Name]
   [DOI Address]
   [DOI Phone]
   [DOI Website]

5. LEGAL ACTION: [State-specific statute of limitations notice]
   [e.g., "Under [State] law, you have [X years] from the date of
   loss to bring legal action under this policy."]

We understand this is not the outcome you were hoping for. If you
have any questions about this determination, please do not hesitate
to contact me.

Sincerely,

[Adjuster Name]
[Title]
[Phone]
[Email]

cc: [Agent/Broker if applicable]
    [Attorney if represented]
```

---

## 31. Document Management Architecture

### Complete Architecture Diagram

```
+===================================================================+
|              DOCUMENT MANAGEMENT ARCHITECTURE                       |
+===================================================================+
|                                                                     |
|  CAPTURE LAYER                                                     |
|  +-------------------------------------------------------------+  |
|  | Scanner | Email | Web | Mobile | Fax | API | EDI             |  |
|  +----+----+---+---+--+--+---+----+--+--+-+---+--+--+          |  |
|       |        |      |      |       |    |       |              |  |
|       v        v      v      v       v    v       v              |  |
|  +-------------------------------------------------------------+  |
|  |           INGESTION SERVICE                                  |  |
|  |  - Virus scan                                                |  |
|  |  - Format validation                                        |  |
|  |  - Duplicate detection                                      |  |
|  |  - Initial routing                                          |  |
|  +------------------------------+------------------------------+  |
|                                  |                                  |
|  PROCESSING LAYER                |                                  |
|  +------------------------------v------------------------------+  |
|  |           IDP PIPELINE                                      |  |
|  |  +------------------+  +------------------+                 |  |
|  |  | Pre-Processing   |->| OCR Engine       |                 |  |
|  |  | (enhance,deskew) |  | (Textract/Azure) |                 |  |
|  |  +------------------+  +--------+---------+                 |  |
|  |                                 |                            |  |
|  |  +------------------+  +--------v---------+                 |  |
|  |  | Data Extraction  |<-| Classification   |                 |  |
|  |  | (fields, tables) |  | (ML model)       |                 |  |
|  |  +--------+---------+  +------------------+                 |  |
|  |           |                                                  |  |
|  |  +--------v---------+                                       |  |
|  |  | Validation        |                                       |  |
|  |  | (rules, cross-ref)|                                       |  |
|  |  +--------+---------+                                       |  |
|  +-----------|-------------------------------------------------+  |
|              |                                                      |
|  STORAGE LAYER                                                     |
|  +-----------|-----+-------------------------------------------+  |
|  |           v     |                                            |  |
|  |  +--------+-----+-----+  +-----------------------------+    |  |
|  |  | ECM (OnBase/FileNet)| | Search Engine               |    |  |
|  |  | - Document store    | | (Elasticsearch)             |    |  |
|  |  | - Metadata index    | | - Full-text index           |    |  |
|  |  | - Version control   | | - Metadata index            |    |  |
|  |  | - Access control    | | - Semantic search (optional)|    |  |
|  |  | - Audit trail       | +-----------------------------+    |  |
|  |  +---------------------+                                     |  |
|  |                                                              |  |
|  |  +-------------------+  +-------------------+                |  |
|  |  | Object Storage    |  | Archive Storage   |                |  |
|  |  | (S3/Azure Blob)   |  | (Glacier/Archive) |                |  |
|  |  | - Primary binary  |  | - Cold/archive    |                |  |
|  |  | - CDN for images  |  | - Retention mgmt  |                |  |
|  |  +-------------------+  +-------------------+                |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  ACCESS LAYER                                                      |
|  +-------------------------------------------------------------+  |
|  |  +-------------------+  +-------------------+                |  |
|  |  | Claims System     |  | Customer Portal   |                |  |
|  |  | (embedded viewer) |  | (document upload   |                |  |
|  |  |                   |  |  and download)     |                |  |
|  |  +-------------------+  +-------------------+                |  |
|  |                                                              |  |
|  |  +-------------------+  +-------------------+                |  |
|  |  | Vendor Portal     |  | Mobile App        |                |  |
|  |  | (IA, attorney,    |  | (photo capture,   |                |  |
|  |  |  medical)         |  |  document view)   |                |  |
|  |  +-------------------+  +-------------------+                |  |
|  |                                                              |  |
|  |  +-------------------+                                       |  |
|  |  | REST APIs         |                                       |  |
|  |  | (system-to-system)|                                       |  |
|  |  +-------------------+                                       |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
|  CORRESPONDENCE LAYER                                              |
|  +-------------------------------------------------------------+  |
|  |  +-------------------+  +-------------------+                |  |
|  |  | Template Engine   |  | Delivery Router   |                |  |
|  |  | (FreeMarker)      |  | (Mail, Email,     |                |  |
|  |  |                   |  |  Portal, SMS)     |                |  |
|  |  +-------------------+  +-------------------+                |  |
|  |                                                              |  |
|  |  +-------------------+  +-------------------+                |  |
|  |  | Print Vendor      |  | E-Sign Platform   |                |  |
|  |  | (Broadridge)      |  | (DocuSign)        |                |  |
|  |  +-------------------+  +-------------------+                |  |
|  +-------------------------------------------------------------+  |
|                                                                     |
+===================================================================+
```

### API Endpoints for Document Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/documents` | Upload new document (multipart) |
| GET | `/api/v1/documents/{id}` | Get document metadata |
| GET | `/api/v1/documents/{id}/content` | Download document content |
| GET | `/api/v1/documents/{id}/thumbnail` | Get document thumbnail |
| PUT | `/api/v1/documents/{id}/metadata` | Update document metadata |
| DELETE | `/api/v1/documents/{id}` | Soft-delete document |
| GET | `/api/v1/claims/{claimId}/documents` | List all documents for a claim |
| POST | `/api/v1/documents/search` | Search documents (metadata + full-text) |
| POST | `/api/v1/documents/{id}/classify` | Reclassify a document |
| POST | `/api/v1/documents/{id}/extract` | Trigger data extraction |
| GET | `/api/v1/documents/{id}/extractions` | Get extraction results |
| POST | `/api/v1/correspondence` | Generate correspondence |
| GET | `/api/v1/correspondence/{id}` | Get correspondence details |
| GET | `/api/v1/correspondence/{id}/tracking` | Get delivery tracking |
| GET | `/api/v1/templates` | List available templates |
| GET | `/api/v1/templates/{id}` | Get template details |
| POST | `/api/v1/templates/{id}/preview` | Preview merged template |

---

*This article is part of the PnC Claims Encyclopedia. For related topics, see Article 17 (Vendor Ecosystem), Article 19 (Customer Experience), and Article 11 (Payment Processing).*
