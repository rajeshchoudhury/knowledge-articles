# Regulatory, Compliance & Fair Underwriting

> A comprehensive reference covering every regulatory, compliance, and fair-underwriting requirement that shapes term life insurance underwriting. Written for solution architects building automated underwriting platforms that must operate lawfully across all US jurisdictions.

---

## Table of Contents

1. [State Insurance Regulation](#1-state-insurance-regulation)
2. [Unfair Discrimination vs Fair Classification](#2-unfair-discrimination-vs-fair-classification)
3. [FCRA (Fair Credit Reporting Act)](#3-fcra-fair-credit-reporting-act)
4. [HIPAA in Underwriting](#4-hipaa-in-underwriting)
5. [Genetic Information](#5-genetic-information)
6. [State-Specific Underwriting Restrictions](#6-state-specific-underwriting-restrictions)
7. [AML (Anti-Money Laundering)](#7-aml-anti-money-laundering)
8. [Insurance Fraud & Contestability](#8-insurance-fraud--contestability)
9. [Privacy Regulations](#9-privacy-regulations)
10. [Algorithmic Fairness & AI Regulation](#10-algorithmic-fairness--ai-regulation)
11. [MIB Compliance](#11-mib-compliance)
12. [Replacement & Suitability Regulations](#12-replacement--suitability-regulations)
13. [E-Signature & E-Delivery](#13-e-signature--e-delivery)
14. [Building Compliance into Automated Systems](#14-building-compliance-into-automated-systems)
15. [Compliance Checklists](#15-compliance-checklists)
16. [Glossary](#16-glossary)

---

## 1. State Insurance Regulation

### 1.1 The McCarran-Ferguson Act (15 U.S.C. §§ 1011–1015)

The McCarran-Ferguson Act of 1945 is the foundational statute that governs the relationship between federal and state regulation of insurance in the United States.

**Key provisions:**

- **Section 1011**: Congress declares that continued regulation by the states is in the public interest.
- **Section 1012(a)**: The business of insurance is subject to the laws of the several states.
- **Section 1012(b)**: No federal statute shall be construed to invalidate, impair, or supersede any state law regulating insurance — unless the federal statute specifically relates to insurance.
- **Section 1013(a)**: The Sherman Act, Clayton Act, and FTC Act apply to insurance only to the extent that the business is not regulated by state law.

**Architectural implications:**

- There is no single federal insurance regulator. Each state DOI has primary jurisdiction.
- Underwriting rules, rate filings, form approvals, and market conduct standards vary by state.
- Automated underwriting systems must be configurable per-state — a single national rule set is legally insufficient.
- Federal laws that DO apply (FCRA, AML, HIPAA, GINA) do so because they contain specific insurance provisions or because McCarran-Ferguson's reverse-preemption does not extend to them.

```
┌──────────────────────────────────────────────────────────────┐
│                    Federal Oversight                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────┐ │
│  │   FCRA   │  │  HIPAA   │  │ AML/BSA  │  │  E-SIGN Act │ │
│  │  (FTC /  │  │  (HHS)   │  │(FinCEN/  │  │  (Federal)  │ │
│  │  CFPB)   │  │          │  │Treasury) │  │             │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────────┘ │
├──────────────────────────────────────────────────────────────┤
│              McCarran-Ferguson Reverse Preemption            │
├──────────────────────────────────────────────────────────────┤
│                  State Insurance Regulation                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────┐ │
│  │ Rate &   │  │  Market  │  │  Unfair  │  │  Privacy &  │ │
│  │ Form     │  │ Conduct  │  │  Trade   │  │  Data Use   │ │
│  │ Approval │  │ Exams    │  │ Practices│  │  Laws       │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────────┘ │
│                                                              │
│  50 States + DC + 5 Territories = 56 Jurisdictions          │
└──────────────────────────────────────────────────────────────┘
```

### 1.2 State Department of Insurance (DOI) Role

Each state has a Department of Insurance (or equivalent — Division of Insurance, Office of Insurance Regulation, etc.) headed by a Commissioner or Superintendent.

**DOI responsibilities relevant to underwriting:**

| Function | Description | UW System Impact |
|----------|-------------|------------------|
| **Licensing** | Insurers must be licensed (admitted) in each state where they sell | System must validate state licensure before quoting |
| **Rate & Form Approval** | Policy forms and rates must be filed and approved | Rate tables, form versions must be state-specific |
| **Market Conduct Examination** | Periodic audits of insurer practices including UW | Full audit trail required; every decision must be explainable |
| **Consumer Complaints** | DOI investigates complaints about UW decisions | Need complaint tracking, correspondence management |
| **Unfair Trade Practices** | Enforcement of anti-discrimination, fair dealing | Rules engine must encode state-specific prohibited practices |
| **Data Calls** | DOI requests aggregate underwriting data | Reporting infrastructure must produce state-mandated reports |

### 1.3 NAIC Model Laws

The National Association of Insurance Commissioners (NAIC) is a standard-setting organization of state insurance regulators. It drafts **model laws** and **model regulations** that states may adopt (with modifications).

**NAIC model laws most relevant to underwriting:**

| Model Law/Regulation | NAIC # | Key UW Provisions |
|----------------------|--------|-------------------|
| Unfair Trade Practices Act | 880 | Prohibits unfair discrimination in underwriting |
| Life Insurance Disclosure Model Reg | 580 | Disclosure requirements at point of sale |
| Insurance Information and Privacy Protection Model Act | 670 | How personal info is collected, used, disclosed |
| Replacement of Life Insurance Model Reg | 613 | Requirements when replacing existing coverage |
| Suitability in Life Insurance Model Reg | 582 | Suitability standards for recommendations |
| Life Insurance Illustrations Model Reg | 582 | Standards for policy illustrations |
| Individual Life Insurance Solicitation Model Reg | 581 | Buyer's guide and policy summary requirements |
| NAIC Model Bulletin on AI | N/A | Guidance on use of AI/ML in insurance (2023) |
| Insurance Data Security Model Law | 668 | Cybersecurity and data protection requirements |

**Adoption tracking is critical.** Not every state adopts every model law, and states frequently modify adopted models. Your compliance system must track:

1. Which model law version each state has adopted
2. State-specific modifications and additions
3. Effective dates and transition periods
4. Regulatory bulletins and guidance letters that interpret the law

### 1.4 How Underwriting Is Regulated State-by-State

```
┌─────────────────────────────────────────────────────────────┐
│           State-Specific Underwriting Regulation             │
│                                                             │
│  Pre-Issue Regulation                                       │
│  ├── Approved application forms & questions                 │
│  ├── Permissible underwriting factors                       │
│  ├── Required notices (FCRA, MIB, HIV, genetic, privacy)   │
│  ├── Consent & authorization requirements                   │
│  ├── Evidence-ordering restrictions (HIV, genetic testing)  │
│  └── Rate classification rules                              │
│                                                             │
│  Decision Regulation                                        │
│  ├── Adverse action notice requirements                     │
│  ├── Prohibited bases for decline/rating                    │
│  ├── Free-look period requirements                          │
│  ├── Right to appeal / reconsideration                      │
│  └── Mandatory offer requirements (e.g., conversion)        │
│                                                             │
│  Post-Issue Regulation                                      │
│  ├── Contestability period rules                            │
│  ├── Incontestability clause requirements                   │
│  ├── Grace period requirements                              │
│  ├── Reinstatement provisions                               │
│  └── Claims handling standards                              │
└─────────────────────────────────────────────────────────────┘
```

**Data model for state regulatory configuration:**

```json
{
  "stateCode": "CA",
  "stateName": "California",
  "doiName": "California Department of Insurance",
  "regulatoryProfile": {
    "unfairTradeActVersion": "CA Ins. Code §§ 790-790.15",
    "privacyActAdopted": true,
    "privacyActVersion": "CA Ins. Code §§ 791-791.27",
    "replacementRegAdopted": true,
    "creditUseRestriction": "PROHIBITED",
    "hivTestingRestriction": "CONSENT_REQUIRED_SPECIFIC",
    "geneticTestingRestriction": "PROHIBITED",
    "marijuanaGuidance": "NO_ADVERSE_ACTION_LEGAL_USE",
    "eSignatureAccepted": true,
    "eDeliveryAccepted": true,
    "eDeliveryConsentRequired": true,
    "adverseActionNoticeDays": 10,
    "freeLookPeriodDays": 30,
    "contestabilityPeriodMonths": 24,
    "suicideExclusionMonths": 24,
    "dataSecurityModelAdopted": true
  }
}
```

### 1.5 Federal Insurance Office (FIO)

The Dodd-Frank Act (2010) created the Federal Insurance Office within the Treasury Department. While FIO does **not** have direct regulatory authority over insurance underwriting, it:

- Monitors the insurance industry for systemic risk
- Advises the Secretary of the Treasury on insurance matters
- Negotiates international insurance agreements (covered agreements)
- Can preempt state laws that conflict with covered agreements
- Issues reports and recommendations that influence state regulation

FIO's reports on race and insurance, algorithmic bias, and climate risk increasingly influence NAIC model development and state regulatory action.

---

## 2. Unfair Discrimination vs Fair Classification

### 2.1 The Fundamental Tension

Insurance underwriting is inherently about **classification** — grouping people by risk characteristics and charging accordingly. The law permits this when classification is based on **actuarially justified** factors, but prohibits classification based on **protected characteristics** that lack actuarial justification or violate public policy.

### 2.2 The Legal Framework

**NAIC Unfair Trade Practices Act (Model #880), Section 4(G):**

> Making or permitting any unfair discrimination between individuals of the same class and equal expectation of life in the rates charged for any contract of life insurance or of life annuity or in the dividends or other benefits payable thereon, or in any other of the terms and conditions of such contract.

**Key legal standard: unfair discrimination ≠ all discrimination.**

Actuarially justified risk classification is **permitted** and even **required** for insurance solvency. What is prohibited is:

1. **Treating similarly-situated applicants differently** without actuarial basis
2. **Using protected characteristics** as underwriting factors (varies by state and characteristic)
3. **Using facially-neutral factors that serve as proxies** for protected characteristics without actuarial justification

### 2.3 Protected Classes in Insurance Underwriting

| Protected Class | Federal Protection | State Protection | Permissible in Life UW? |
|----------------|-------------------|-----------------|------------------------|
| **Race** | Civil Rights Act, FHA | All states | **Never permissible** |
| **Color** | Civil Rights Act, FHA | All states | **Never permissible** |
| **National Origin** | Civil Rights Act | All states | **Never permissible** |
| **Religion** | Civil Rights Act | All states | **Never permissible** |
| **Sex/Gender** | Varies | Most states allow gender-based mortality tables | **Permitted in most states** (actuarially justified) — but see Montana (unisex) |
| **Age** | ADEA (does not apply to insurance pricing) | Some states | **Permitted** (actuarially justified) |
| **Disability/ADA** | ADA §501(c) safe harbor | Varies | Permitted if actuarially justified; not solely on basis of disability |
| **Genetic Info** | GINA (does NOT apply to life) | ~20 states restrict | **State-specific** (see Section 5) |
| **Sexual Orientation** | No federal protection | ~25 states | **Cannot decline solely on basis** in many states |
| **Gender Identity** | No federal protection | ~25 states | State-specific guidance emerging |
| **Marital Status** | None | ~20 states | Generally permitted if actuarially justified |
| **Domestic Violence** | None | All states (NAIC model) | **Cannot use as UW factor** |
| **Credit History** | None | ~12 states restrict | **State-specific** (see Section 6) |
| **HIV/AIDS Status** | None | Many states restrict testing | **State-specific** restrictions on testing and use |
| **Lawful Activities** | None | ~30 states | **Cannot decline for lawful off-duty conduct** in some states |

### 2.4 Actuarial Justification Standard

For a factor to be used in underwriting, the insurer must generally demonstrate:

1. **Statistical correlation** with mortality/morbidity
2. **Causation or reasonable proxy** — the factor reflects actual differences in risk
3. **Actuarial soundness** — the factor is recognized by actuarial standards of practice (ASOPs)
4. **Not a prohibited proxy** — the factor does not serve primarily as a proxy for a protected class
5. **Credible data** — sufficient data volume and quality to support the distinction

**ASOP No. 12 (Risk Classification)** from the Actuarial Standards Board provides the professional framework:

> Risk characteristics should be related to expected outcomes... The actuary should consider whether a risk classification system complies with applicable law... The actuary should consider the interdependence among risk characteristics and the potential for unfair discrimination.

### 2.5 The ADA Safe Harbor

The Americans with Disabilities Act includes a specific insurance safe harbor at **42 U.S.C. § 12201(c)**:

> [The ADA does not prohibit] an insurer... from establishing, sponsoring, observing or administering the terms of a bona fide benefit plan that is not subject to state laws that regulate insurance... [and are] based on underwriting risks, classifying risks, or administering such risks that are based on or not inconsistent with state law.

**Requirements for invoking the safe harbor:**

- The underwriting distinction must be based on **sound actuarial principles** or **actual or reasonably anticipated experience**
- The insurer cannot use disability status as a **subterfuge** to evade the ADA
- The distinction must be applied consistently to all applicants

### 2.6 Domestic Violence Protections

The **NAIC Model Act Regarding Insurance Discrimination Against Victims of Domestic Violence (#897)** prohibits:

- Denying or limiting coverage based on domestic violence status
- Using abuse status as an underwriting criterion
- Rating based on domestic violence history
- Requiring disclosure of domestic violence as a condition of coverage

All 50 states have adopted some version of this protection. Your rules engine must ensure that no underwriting pathway uses domestic violence history as a factor.

### 2.7 Proxy Discrimination in Automated Systems

Automated underwriting systems create particular risk for **proxy discrimination** — using facially neutral variables that correlate with protected classes.

**High-risk proxy variables:**

| Variable | Potential Proxy For | Mitigation |
|----------|-------------------|-----------|
| ZIP code / geography | Race, national origin | Validate actuarial basis; test for disparate impact |
| Credit-based score | Race, income | Prohibited in many states for life insurance; test for disparate impact where permitted |
| Occupation | Gender, race | Validate actuarial justification; review for disparate impact |
| Education level | Race, national origin | Generally not used in life UW; high proxy risk |
| Social media activity | Religion, political affiliation, race | Extremely high risk; avoid |
| Purchasing patterns | Income, race | Requires strong actuarial justification |
| Digital behavioral data | Age, disability, socioeconomic status | Emerging regulatory scrutiny; proceed with caution |

### 2.8 Testing for Unfair Discrimination

```
┌──────────────────────────────────────────────────────────────┐
│              Discrimination Testing Framework                │
│                                                              │
│  1. PROHIBITED FACTOR AUDIT                                  │
│     └── Verify no protected class used directly              │
│                                                              │
│  2. PROXY ANALYSIS                                           │
│     └── Correlation analysis between UW variables and        │
│         protected classes (race, gender, etc.)               │
│                                                              │
│  3. DISPARATE IMPACT TESTING                                 │
│     └── Compare approval/decline rates across demographic    │
│         groups using the 80% (4/5ths) rule                   │
│                                                              │
│  4. COUNTERFACTUAL ANALYSIS                                  │
│     └── Change only the protected attribute; does the        │
│         decision change?                                     │
│                                                              │
│  5. ACTUARIAL JUSTIFICATION REVIEW                           │
│     └── Confirm every distinguishing factor has actuarial    │
│         support and is not merely correlated                 │
│                                                              │
│  6. DOCUMENTATION                                            │
│     └── Record all testing methodology, results, and         │
│         remediation in model governance repository           │
└──────────────────────────────────────────────────────────────┘
```

---

## 3. FCRA (Fair Credit Reporting Act)

### 3.1 Overview

The Fair Credit Reporting Act (15 U.S.C. § 1681 et seq.) is one of the most operationally impactful federal statutes for life insurance underwriting. It governs how **consumer reports** are obtained and used in insurance underwriting, and mandates specific **adverse action** procedures.

### 3.2 What Is a "Consumer Report" in Underwriting?

Under FCRA § 1681a(d), a "consumer report" is:

> Any written, oral, or other communication of any information by a consumer reporting agency bearing on a consumer's credit worthiness, credit standing, credit capacity, character, general reputation, personal characteristics, or mode of living which is used or expected to be used or collected in whole or in part for the purpose of serving as a factor in establishing the consumer's eligibility for... insurance to be used primarily for personal, family, or household purposes.

**In life insurance underwriting, the following are consumer reports under FCRA:**

| Report Type | Consumer Reporting Agency | FCRA Coverage |
|------------|--------------------------|---------------|
| **MIB Report** | MIB Group, Inc. | Yes — consumer report |
| **Motor Vehicle Report (MVR)** | State DMV (via vendors like LexisNexis) | Yes — consumer report |
| **Credit Report / Credit-Based Insurance Score** | Equifax, Experian, TransUnion | Yes — consumer report |
| **Prescription Drug History (Rx)** | Milliman IntelliScript, ExamOne | Yes — consumer report |
| **Criminal Background** | Various CRA vendors | Yes — consumer report |
| **Identity Verification** | LexisNexis, various | Yes — if from a CRA |
| **Inspection Report** | Investigative CRAs | Yes — "investigative consumer report" (additional requirements) |
| **Public Records** | LexisNexis, various | Yes — consumer report |

**Not consumer reports under FCRA:**

- Medical records obtained directly from the applicant's physician (first-party data)
- Paramedical exam results ordered by the insurer (first-party data)
- Lab results from insurer-ordered tests (first-party data)
- Information provided directly by the applicant on the application

### 3.3 Permissible Purpose

FCRA § 1681b(a)(3)(C) provides that a consumer report may be obtained:

> In connection with the underwriting of insurance involving the consumer.

**This permissible purpose extends to:**
- Initial underwriting at application
- Policy renewal underwriting (if applicable)
- Reinstatement underwriting

**It does NOT extend to:**
- Marketing or lead generation (without firm offer of insurance)
- Post-issue monitoring (unless specifically for renewal/reinstatement)
- Claims investigation (separate permissible purpose under § 1681b(a)(3)(D))

### 3.4 Pre-Collection Notices

Before obtaining consumer reports, insurers must provide specific notices:

**Standard consumer report notice (FCRA § 1681b(b)(1)):**

The notice must:
- Be clear and conspicuous
- Be in writing (or electronic with E-SIGN consent)
- Be provided before the report is obtained
- Inform the consumer that a consumer report may be obtained
- Be standalone or prominently placed in the application

**Investigative consumer report notice (FCRA § 1681d(a)(1)):**

If an investigative consumer report (involving personal interviews) will be obtained, additional disclosure is required within 3 days of ordering:
- Written notice that an investigative consumer report may be obtained
- Statement of the consumer's right to request information about the nature and scope of the investigation
- Summary of consumer rights under FCRA

### 3.5 Adverse Action — The Critical Compliance Obligation

**Definition:** Under FCRA § 1681a(k)(1)(B)(ii), "adverse action" for insurance means:

> A denial or cancellation of, an increase in any charge for, or a reduction or other adverse or unfavorable change in the terms of coverage or amount of, any insurance, existing or applied for, in connection with the underwriting of insurance.

**In underwriting terms, adverse action includes:**

- Outright decline of the application
- Approval at a higher rate class than the best available (e.g., Standard instead of Preferred)
- Approval with exclusion riders
- Approval at a reduced face amount
- Approval with a flat extra or table rating
- Any modification less favorable than the applicant's requested terms

### 3.6 Adverse Action Notice Requirements

When adverse action is taken based in whole or in part on information in a consumer report, the insurer **must** provide written notice to the applicant. This requirement applies even if the consumer report was only **one factor** among many.

**Required elements (FCRA § 1681m(a)):**

1. Name, address, and telephone number of the consumer reporting agency (CRA) that furnished the report
2. Statement that the CRA did not make the adverse decision and is unable to explain why the decision was made
3. Statement of the consumer's right to obtain a free copy of the report from the CRA within 60 days
4. Statement of the consumer's right to dispute the accuracy or completeness of information with the CRA

### 3.7 Adverse Action Notice — Full Template

```
────────────────────────────────────────────────────────────────────────
                    NOTICE OF ADVERSE UNDERWRITING DECISION

                    [INSURER NAME]
                    [INSURER ADDRESS]
                    [INSURER PHONE]

Date: [DATE]

Applicant: [APPLICANT FULL NAME]
Application Number: [APP NUMBER]
Policy Applied For: [PRODUCT NAME, FACE AMOUNT, TERM]

Dear [APPLICANT NAME]:

We have completed our review of your application for life insurance. Based
on our underwriting evaluation, we are unable to offer coverage on the terms
you requested.

ACTION TAKEN: [SELECT ONE]
  □ Your application for life insurance has been declined.
  □ Your application has been approved at a rate classification other than
    the most favorable class available. You applied for [REQUESTED CLASS]
    and have been offered [OFFERED CLASS].
  □ Your application has been approved with a modified face amount of
    [AMOUNT] instead of the requested [AMOUNT].
  □ Your application has been approved with the following rating
    modification: [TABLE RATING / FLAT EXTRA DESCRIPTION].
  □ Your application has been approved with an exclusion rider for
    [CONDITION/EXCLUSION].

REASONS FOR THIS DECISION:
[List principal reason(s) — e.g., "medical history," "driving record,"
"prescription drug history." Do NOT disclose specific medical diagnoses
obtained from consumer reports.]

CONSUMER REPORT INFORMATION:

Our decision was based, in whole or in part, on information contained in
a consumer report(s) obtained from the following consumer reporting
agency(ies):

  [CRA NAME]
  [CRA ADDRESS]
  [CRA PHONE]
  [CRA WEBSITE]

  [REPEAT FOR EACH CRA USED]

The consumer reporting agency(ies) listed above did not make the decision
to take adverse action and is (are) unable to provide you the specific
reasons why the adverse action was taken.

YOUR RIGHTS UNDER THE FAIR CREDIT REPORTING ACT:

You have the right to obtain a free copy of your consumer report from the
consumer reporting agency(ies) named above. To obtain your free copy, you
must request it within 60 days of receiving this notice.

You have the right to dispute the accuracy or completeness of any
information in your consumer report directly with the consumer reporting
agency. The consumer reporting agency must investigate your dispute within
30 days.

You have additional rights under the Fair Credit Reporting Act. For more
information, including information about your right to obtain your credit
score, your right to place a fraud alert or security freeze on your
consumer report, and your right to obtain information from a consumer
reporting agency if you are the victim of identity theft, please visit
www.consumerfinance.gov/learnmore or write to:

  Consumer Financial Protection Bureau
  1700 G Street NW
  Washington, DC 20552

[IF MIB WAS USED:]

MEDICAL INFORMATION BUREAU (MIB) NOTICE:

Information from MIB, Inc. was used in connection with this underwriting
decision. You have the right to obtain a copy of your MIB record by
contacting:

  MIB, Inc.
  50 Braintree Hill Park, Suite 400
  Braintree, MA 02184-8734
  Phone: (866) 692-6901
  Website: www.mib.com

[IF CREDIT INFORMATION WAS USED:]

CREDIT SCORE INFORMATION:

A credit-based insurance score was used in making this underwriting
decision. Your credit-based insurance score was [SCORE]. Credit-based
insurance scores are derived from information in your credit report.
The key factors that adversely affected your score are:

  1. [FACTOR 1]
  2. [FACTOR 2]
  3. [FACTOR 3]
  4. [FACTOR 4]

[IF MEDICAL INFORMATION FROM NON-CRA SOURCES:]

NOTICE REGARDING MEDICAL INFORMATION:

We also obtained and used medical information in making our underwriting
decision. You may have the right to obtain this information. To request
the specific medical information upon which this decision was based, please
contact us at:

  [INSURER MEDICAL RECORDS CONTACT]
  [ADDRESS]
  [PHONE]

If you have questions about this decision, please contact us at the number
above.

Sincerely,

[INSURER NAME]
Underwriting Department
[PHONE]
[EMAIL]
────────────────────────────────────────────────────────────────────────
```

### 3.8 Adverse Action Process Flow

```
┌──────────────────┐
│ UW Decision Made │
│ (not best class)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────┐     ┌──────────────────────────┐
│ Was a consumer report    │ YES │ Generate Adverse Action   │
│ used in whole or in part?├────▶│ Notice with CRA details   │
└────────┬─────────────────┘     └────────┬─────────────────┘
         │ NO                              │
         ▼                                 ▼
┌──────────────────────────┐     ┌──────────────────────────┐
│ No FCRA adverse action   │     │ Was MIB report used?     │
│ notice required. But     │     │ Was credit score used?   │
│ check state-specific     │     │ Was Rx check used?       │
│ adverse UW decision      │     │ Was MVR used?            │
│ notice requirements.     │     └────────┬─────────────────┘
└──────────────────────────┘              │
                                          ▼
                              ┌──────────────────────────┐
                              │ Include specific CRA info │
                              │ for EACH report used:     │
                              │ • Name, address, phone    │
                              │ • CRA did not make        │
                              │   the decision            │
                              │ • 60-day free copy right  │
                              │ • Dispute right           │
                              └────────┬─────────────────┘
                                       │
                                       ▼
                              ┌──────────────────────────┐
                              │ If credit score used:     │
                              │ • Disclose score          │
                              │ • Disclose key factors    │
                              │ • Range of possible scores│
                              └────────┬─────────────────┘
                                       │
                                       ▼
                              ┌──────────────────────────┐
                              │ Mail / deliver notice     │
                              │ within [state-specific]   │
                              │ days of decision          │
                              │ (typically 10-30 days)    │
                              └────────┬─────────────────┘
                                       │
                                       ▼
                              ┌──────────────────────────┐
                              │ Log notice in audit trail │
                              │ • Date generated          │
                              │ • Date sent               │
                              │ • Delivery method         │
                              │ • CRAs identified         │
                              │ • Retain for 7+ years     │
                              └──────────────────────────┘
```

### 3.9 Consumer Dispute Process

When a consumer disputes information in a consumer report:

1. **CRA obligation (§ 1681i)**: Investigate within 30 days; forward dispute to furnisher; delete or modify inaccurate information
2. **Furnisher obligation (§ 1681s-2(b))**: Investigate dispute referred by CRA; report results to CRA; if inaccurate, correct with all CRAs to which it was reported
3. **Insurer obligation**: If the insurer receives notice that previously-used information was inaccurate, the insurer should reconsider the underwriting decision

**System implications:**

- Maintain linkage between underwriting decisions and the specific consumer report data used
- Implement workflow to receive and act on dispute notifications from CRAs
- Support reconsideration workflow when disputed information changes
- Track dispute resolution outcomes for regulatory reporting

### 3.10 FCRA Compliance Data Model

```json
{
  "adverseActionRecord": {
    "applicationId": "APP-2024-001234",
    "applicantId": "APPLICANT-5678",
    "decisionDate": "2024-03-15",
    "decisionType": "RATED_UP",
    "requestedClass": "PREFERRED_PLUS",
    "offeredClass": "STANDARD_PLUS",
    "adverseActionRequired": true,
    "consumerReportsUsed": [
      {
        "reportType": "MIB",
        "craName": "MIB, Inc.",
        "craAddress": "50 Braintree Hill Park, Suite 400, Braintree, MA 02184",
        "craPhone": "866-692-6901",
        "craWebsite": "www.mib.com",
        "reportDate": "2024-03-10",
        "reportReferenceId": "MIB-REF-9876"
      },
      {
        "reportType": "PRESCRIPTION_HISTORY",
        "craName": "Milliman IntelliScript",
        "craAddress": "15800 W Bluemound Rd, Brookfield, WI 53005",
        "craPhone": "877-211-4816",
        "reportDate": "2024-03-10",
        "reportReferenceId": "RX-REF-5432"
      },
      {
        "reportType": "MVR",
        "craName": "LexisNexis Risk Solutions",
        "craAddress": "1000 Alderman Dr, Alpharetta, GA 30005",
        "craPhone": "800-456-6004",
        "reportDate": "2024-03-09",
        "reportReferenceId": "MVR-REF-1122"
      }
    ],
    "creditScoreUsed": false,
    "noticeGenerated": {
      "generatedDate": "2024-03-15",
      "templateVersion": "AA-NOTICE-v3.2",
      "deliveryMethod": "USPS_FIRST_CLASS",
      "deliveryDate": "2024-03-17",
      "trackingNumber": "9400111899223100001234"
    },
    "principalReasons": [
      "Prescription drug history",
      "Motor vehicle record"
    ]
  }
}
```

### 3.11 FCRA Penalties

| Violation Type | Penalty |
|---------------|---------|
| Negligent noncompliance (§ 1681o) | Actual damages + attorney's fees |
| Willful noncompliance (§ 1681n) | Actual OR statutory damages ($100–$1,000 per violation) + punitive damages + attorney's fees |
| Class action | Statutory damages up to the lesser of $500,000 or 1% of net worth |
| FTC/CFPB enforcement | Civil penalties up to $50,120 per violation (adjusted for inflation) |
| State attorney general action | Varies by state; additional damages and penalties |

---

## 4. HIPAA in Underwriting

### 4.1 HIPAA's Limited but Critical Role

The Health Insurance Portability and Accountability Act (HIPAA) does **not** directly regulate life insurance underwriting. HIPAA's Privacy Rule (45 CFR Part 164) applies to **covered entities** — health plans, health care clearinghouses, and health care providers who transmit health information electronically.

**However**, HIPAA significantly impacts life insurance underwriting in these ways:

1. **Healthcare providers** that share medical records with life insurers must comply with HIPAA when doing so
2. **Authorization requirements** shape how insurers obtain medical records
3. **Business associate** relationships may exist with certain underwriting vendors
4. **State mini-HIPAA laws** extend HIPAA-like protections to life insurers directly

### 4.2 HIPAA Authorization for Underwriting

When a life insurer requests medical records from a healthcare provider (covered entity), the provider must obtain a **HIPAA-compliant authorization** from the patient before releasing records.

**Required elements of a valid HIPAA authorization (45 CFR § 164.508(c)):**

1. Description of information to be used or disclosed
2. Name or specific identification of person(s) authorized to make the disclosure
3. Name or specific identification of person(s) to whom the disclosure may be made
4. Description of the purpose of the disclosure
5. Expiration date or expiration event
6. Signature of the individual and date
7. If signed by a personal representative, description of representative's authority

**Required statements:**

- Right to revoke the authorization in writing
- Ability or inability to condition treatment, payment, enrollment, or eligibility on the authorization
- Potential for re-disclosure by the recipient and loss of HIPAA protection

### 4.3 Minimum Necessary Standard

HIPAA's **minimum necessary** standard (45 CFR § 164.502(b)) requires covered entities to limit disclosures to the minimum necessary to accomplish the intended purpose.

**Impact on underwriting:**

- Healthcare providers may redact portions of records not relevant to the underwriting request
- Insurers should request specific record types (e.g., "office visit notes for the last 5 years related to cardiovascular history") rather than "complete medical records"
- Automated systems should be designed to request only the minimum necessary medical information

### 4.4 Business Associate Agreements (BAAs)

If a life insurer contracts with vendors who handle **protected health information (PHI)** on behalf of a covered entity, the vendor may need a BAA.

**Common underwriting vendors that may require BAAs:**

| Vendor Type | BAA Needed? | Rationale |
|-------------|-------------|-----------|
| Paramedical exam companies | Possibly | If they receive PHI from healthcare providers |
| Lab companies | Possibly | If they receive referral PHI from providers |
| Electronic Health Record (EHR) data aggregators | Yes | They access PHI from covered entities |
| Prescription drug history vendors | Depends | IntelliScript obtains from pharmacies (covered entities) |
| Underwriting outsourcers (TPAs) | Yes, if they handle PHI | They process PHI on behalf of the insurer |

### 4.5 PHI in Automated Underwriting Systems

**Data handling requirements when PHI enters the underwriting pipeline:**

```
┌──────────────────────────────────────────────────────────────────┐
│                PHI Data Handling in Automated UW                  │
│                                                                  │
│  INGESTION                                                       │
│  ├── Validate HIPAA authorization on file before requesting      │
│  ├── Request minimum necessary information                       │
│  ├── Receive via encrypted channel (TLS 1.2+)                   │
│  ├── Verify sender identity                                      │
│  └── Log receipt with timestamp and authorization reference      │
│                                                                  │
│  PROCESSING                                                      │
│  ├── Store PHI in encrypted-at-rest database                    │
│  ├── Apply role-based access controls (RBAC)                    │
│  ├── Use PHI only for the authorized purpose (underwriting)     │
│  ├── Do not commingle PHI with marketing data                   │
│  ├── Apply data masking in non-production environments          │
│  └── Log all access to PHI (who, when, what, why)              │
│                                                                  │
│  RETENTION                                                       │
│  ├── Retain per state retention requirements (typically 7-10yr) │
│  ├── For declined applications: retain per state requirement    │
│  ├── Apply automated retention policies                          │
│  ├── Secure disposal when retention period expires              │
│  └── Document retention schedule and disposal certifications    │
│                                                                  │
│  DISCLOSURE                                                      │
│  ├── Never disclose PHI without valid authorization             │
│  ├── Adverse action notices must not reveal specific diagnoses  │
│  │   obtained from consumer reports                              │
│  ├── Respond to applicant requests for their own PHI            │
│  └── Report breaches per state and federal requirements         │
└──────────────────────────────────────────────────────────────────┘
```

### 4.6 Data Retention Requirements

| Record Type | Minimum Retention | Governing Rule |
|-------------|------------------|----------------|
| Application and UW file | 7 years from decision (varies by state) | State insurance regulations |
| Medical records obtained | Same as UW file | State insurance regulations |
| HIPAA authorizations | 6 years from creation or last effective date | 45 CFR § 164.530(j) |
| Consumer report data | Per FCRA — as long as needed for dispute | FCRA |
| Adverse action notices | 7 years minimum | State insurance regulations, FCRA |
| Correspondence | 7 years | State insurance regulations |
| Declined application records | Varies: 3-7 years by state | State insurance regulations |

---

## 5. Genetic Information

### 5.1 GINA Does NOT Apply to Life Insurance

The Genetic Information Nondiscrimination Act of 2008 (GINA, Pub. L. 110-233) is widely misunderstood in the context of life insurance. **GINA does NOT apply to life insurance, disability insurance, or long-term care insurance.**

**What GINA covers:**

- **Title I**: Prohibits genetic discrimination in health insurance (amends ERISA, PHSA, IRC)
- **Title II**: Prohibits genetic discrimination in employment (amends Title VII of CRA)

**What GINA explicitly excludes:**

GINA § 209(a)(1):

> Nothing in this title shall be construed to apply to life insurance, disability insurance, or long-term care insurance.

**Legislative history:** Congress deliberately excluded life insurance from GINA, recognizing that life insurance underwriting relies on mortality risk assessment and that genetic information can be directly relevant to mortality. There were concerns about adverse selection if applicants with knowledge of genetic predispositions could obtain coverage at standard rates.

### 5.2 Why This Matters Architecturally

Despite GINA's exclusion of life insurance, **state laws increasingly restrict genetic information use in life insurance underwriting.** The regulatory landscape is fragmented and evolving rapidly.

### 5.3 State Genetic Privacy Laws Affecting Life Insurance

The following states have enacted laws that restrict the use of genetic information in life insurance underwriting:

| State | Citation | Restriction | Effective |
|-------|----------|-------------|-----------|
| **California** | Cal. Ins. Code § 10149.1 | Cannot require or use results of genetic testing; cannot consider genetic characteristics | 2012 |
| **Florida** | Fla. Stat. § 760.40 | Cannot deny/condition/rate based solely on genetic test results; cannot require testing | 1992 (amended) |
| **Arizona** | Ariz. Rev. Stat. § 20-448 | Cannot require genetic testing; cannot consider results of genetic testing | 2001 |
| **Colorado** | C.R.S. § 10-3-1104.7 | Cannot use genetic testing information to deny, cancel, limit, or rate | 2016 |
| **Connecticut** | C.G.S. § 38a-816(19) | Unfair trade practice to use genetic information in underwriting | 2011 |
| **Delaware** | 18 Del. C. § 2317 | Cannot require genetic testing; cannot use results for underwriting | 1998 |
| **Georgia** | O.C.G.A. § 33-54-1 et seq. | Cannot use genetic testing to determine insurability | 1995 |
| **Illinois** | 410 ILCS 513/30 | Cannot request or require genetic testing; cannot use results | 1998 |
| **Kansas** | K.S.A. § 40-2259 | Cannot require genetic screening test; cannot consider results | 2001 |
| **Louisiana** | La. R.S. § 22:1023 | Cannot require genetic testing; limited use restrictions | 2014 |
| **Maine** | 24-A M.R.S. § 2159-C | Cannot require genetic testing; cannot use results | 1998 |
| **Maryland** | Md. Code, Ins. § 27-909 | Cannot use genetic information in determining premiums or eligibility | 1997 |
| **Massachusetts** | M.G.L. c. 175 § 120E | Cannot require genetic testing; cannot use results for underwriting | 2000 |
| **Minnesota** | Minn. Stat. § 72A.139 | Cannot require genetic testing; cannot use results | 2013 |
| **Montana** | Mont. Code Ann. § 33-18-206 | Cannot require or request genetic testing | 2001 |
| **Nebraska** | Neb. Rev. Stat. § 44-7604 | Cannot require genetic testing; cannot use results | 2001 |
| **New Hampshire** | N.H. Rev. Stat. Ann. § 141-H:3 | Cannot require genetic testing | 1995 |
| **New Jersey** | N.J.S.A. § 17B:30-12 | Cannot require or use genetic information for underwriting | 1996 |
| **New Mexico** | N.M. Stat. Ann. § 24-21-3 | Cannot require genetic testing; cannot use results | 1998 |
| **New York** | N.Y. Ins. Law § 2615 | Cannot require or request genetic testing; cannot use results | 1996 |
| **North Carolina** | N.C.G.S. § 58-3-215 | Limited restriction on use of genetic information | 1997 |
| **Ohio** | O.R.C. § 3901.49 | Cannot require genetic testing as condition of coverage | 2001 |
| **Oklahoma** | 36 Okla. Stat. § 3614.2 | Cannot require genetic testing | 2000 |
| **Oregon** | O.R.S. § 746.135 | Cannot require or use genetic testing information | 1995 |
| **Rhode Island** | R.I. Gen. Laws § 27-18-52 | Restrictions on use of genetic information | 2015 |
| **South Carolina** | S.C. Code Ann. § 38-93-10 et seq. | Restrictions on genetic testing requirements | 2008 |
| **South Dakota** | S.D. Codified Laws § 58-1-25 | Cannot require genetic testing | 2000 |
| **Texas** | Tex. Ins. Code § 546.002 | Cannot use genetic information to reject, limit, or rate | 2013 |
| **Vermont** | 18 V.S.A. § 9334 | Cannot require genetic testing; cannot use results | 1998 |
| **Virginia** | Va. Code § 38.2-508.4 | Cannot require genetic testing; limited use restrictions | 2005 |
| **Washington** | Wash. Rev. Code § 48.43.062 | Cannot require genetic testing | 2004 |
| **Wisconsin** | Wis. Stat. § 631.89 | Cannot require genetic testing; limited restrictions on use | 1992 |

### 5.4 Key Distinctions in State Genetic Laws

State laws vary on several critical dimensions:

**What counts as "genetic information":**

- **Narrow**: Only results of a genetic test (laboratory analysis of DNA, RNA, chromosomes, proteins, or metabolites)
- **Broad**: Includes family history, genetic test results, genetic counseling records, and manifestation of a genetic condition

**What is prohibited:**

- **Requiring** genetic testing as a condition of coverage
- **Requesting** genetic test results
- **Using** genetic information in underwriting decisions
- **Considering** genetic information as a factor

**Whether voluntarily provided information can be used:**

- Some states prohibit use even of voluntarily provided genetic information
- Other states only prohibit requiring or requesting testing but allow use of voluntarily disclosed results
- Some states distinguish between presymptomatic genetic predispositions and manifested genetic conditions

### 5.5 Genetic Information Configuration Schema

```json
{
  "stateGeneticRestriction": {
    "stateCode": "CA",
    "geneticTestingRequired": "PROHIBITED",
    "geneticTestingRequested": "PROHIBITED",
    "geneticResultsUse": "PROHIBITED",
    "familyHistoryRestricted": false,
    "voluntaryDisclosureUsable": false,
    "manifestedConditionUsable": true,
    "geneticInfoDefinition": "BROAD",
    "citation": "Cal. Ins. Code § 10149.1",
    "effectiveDate": "2012-01-01",
    "enforcementAgency": "CA DOI",
    "penaltyType": "ADMINISTRATIVE_FINE",
    "notes": "California has one of the broadest genetic privacy protections for life insurance"
  }
}
```

### 5.6 System Implementation Guidance

```
┌──────────────────────────────────────────────────────────────┐
│            Genetic Information Compliance Engine              │
│                                                              │
│  APPLICATION PHASE                                           │
│  ├── State lookup → Determine genetic info restrictions      │
│  ├── Suppress genetic-related application questions if       │
│  │   prohibited in applicant's state                         │
│  ├── If family history is restricted, suppress those fields  │
│  └── Log state-specific form version served                  │
│                                                              │
│  EVIDENCE GATHERING                                          │
│  ├── NEVER order genetic testing regardless of state         │
│  │   (no state permits requiring; industry standard)         │
│  ├── When processing APS / medical records:                  │
│  │   ├── Flag genetic test results in documents              │
│  │   ├── If state prohibits USE of results:                  │
│  │   │   ├── Redact from underwriter view                    │
│  │   │   ├── Exclude from automated rules engine input       │
│  │   │   └── Log redaction in audit trail                    │
│  │   └── If state allows use of manifested conditions:       │
│  │       └── Allow only manifested condition data through    │
│  │                                                           │
│  DECISION PHASE                                              │
│  ├── Rules engine must NOT reference genetic variables       │
│  │   for restricted states                                   │
│  ├── Validate that no genetic data leaked into decision      │
│  │   inputs for restricted states                            │
│  └── Audit log must confirm genetic data exclusion           │
│                                                              │
│  DATA RETENTION                                              │
│  ├── If genetic data was received but not used:              │
│  │   ├── Segregate from UW file                              │
│  │   ├── Apply minimum retention only                        │
│  │   └── Destroy per state genetic data destruction rules    │
│  └── Never share genetic data with reinsurers in             │
│      states that prohibit use                                │
└──────────────────────────────────────────────────────────────┘
```

---

## 6. State-Specific Underwriting Restrictions

### 6.1 Credit-Based Information Restrictions

Several states restrict or prohibit the use of credit information (credit reports, credit scores, credit-based insurance scores) in life insurance underwriting:

| State | Restriction | Citation |
|-------|-------------|----------|
| **California** | Prohibited — cannot use credit information in life insurance underwriting | Cal. Ins. Code § 10506.3 |
| **Colorado** | Cannot use credit score as sole basis for adverse action | C.R.S. § 10-3-1104.6 |
| **Connecticut** | Restrictions on use; cannot be sole factor | C.G.S. § 38a-358 |
| **Hawaii** | Prohibited for personal lines; restrictions on life | H.R.S. § 431:10C-207 |
| **Illinois** | Cannot use absence of credit history as negative factor | 215 ILCS 5/1401.1 |
| **Maryland** | Prohibited for life insurance underwriting | Md. Code, Ins. § 27-501 |
| **Massachusetts** | Prohibited for all insurance lines | M.G.L. c. 175 § 4C |
| **Michigan** | Restrictions on use; filing requirements | M.C.L. § 500.2153 |
| **Minnesota** | Cannot use credit score as sole factor; filing required | Minn. Stat. § 72A.20 |
| **Nevada** | Restrictions; adverse action notice requirements | N.R.S. § 686A.680 |
| **New York** | Prohibited for life insurance | N.Y. Ins. Law § 2802 |
| **North Carolina** | Restrictions on use; cannot be sole factor | N.C.G.S. § 58-36-90 |
| **Ohio** | Cannot use credit score as sole basis | O.R.C. § 3901.21 |
| **Oregon** | Prohibited for life and health insurance | O.R.S. § 746.015 |
| **South Carolina** | Restrictions; must demonstrate actuarial justification | S.C. Code Ann. § 38-73-457 |
| **Vermont** | Restrictions on credit use for all insurance | 8 V.S.A. § 4724 |
| **Washington** | Restricted; cannot be sole basis | R.C.W. § 48.18.480 |

### 6.2 HIV/AIDS Testing Restrictions

States have varying restrictions on HIV/AIDS testing in life insurance underwriting:

| State | Restriction | Key Provisions |
|-------|-------------|----------------|
| **California** | Written informed consent; specific notice requirements; results only to physician unless consent | Cannot decline solely on positive test; must consider T-cell count and stage |
| **Connecticut** | Written informed consent; pre-test counseling | Cannot use as sole basis for adverse action |
| **District of Columbia** | Written informed consent | Cannot require testing for policies under $100,000 (threshold varies) |
| **Florida** | Written informed consent; DOH-approved test only | Strict confidentiality; named reporting |
| **Illinois** | Written informed consent; pre-test counseling | Strict result handling; limited disclosure |
| **Massachusetts** | Written informed consent | Cannot be sole basis for adverse action |
| **Michigan** | Written informed consent; pre- and post-test counseling | Specific form requirements |
| **New Jersey** | Written informed consent | Cannot use HIV status as sole basis for adverse action |
| **New York** | Written informed consent (Article 27-F); specific consent form | Most restrictive — separate specific consent form; results only to authorized persons; strict criminal penalties for unauthorized disclosure |
| **Oregon** | Written informed consent | Specific informed consent requirements |
| **Rhode Island** | Written informed consent | Cannot use positive result as sole basis |
| **Wisconsin** | Written informed consent | Specific notice and consent requirements |

**Common HIV testing compliance requirements across states:**

1. **Separate, specific consent** — cannot be buried in general application authorization
2. **Pre-test notification** — applicant must be informed that an HIV test will be conducted
3. **Post-test notification** — applicant must be informed of results, typically through their physician
4. **Result confidentiality** — HIV test results subject to heightened confidentiality requirements
5. **Not sole basis** — most states do not allow HIV status as the sole reason for adverse action; must consider full clinical picture
6. **Result handling** — specific chain-of-custody and disclosure limitations

### 6.3 Marijuana Legalization Impact

As marijuana legalization spreads across states, insurers face complex questions about how to treat marijuana use in underwriting.

**Current landscape (as of 2025):**

- **Recreational legal**: 24 states + DC
- **Medical only**: 14 states
- **Illegal**: 12 states
- **Federal**: Remains Schedule I under the Controlled Substances Act

**Underwriting considerations:**

| Factor | Traditional Approach | Evolving Approach |
|--------|---------------------|-------------------|
| Marijuana use disclosure | Classified as drug use; tobacco rates | Separate marijuana class; not equated with tobacco |
| Frequency of use | Any use = decline or high rating | Occasional recreational use may be Standard; heavy use = rated |
| Medical marijuana | Often treated same as recreational | Many carriers now treat medical marijuana users more favorably |
| CBD use | Not well-addressed | Most carriers disregard CBD-only use |
| Drug testing positive | Often decline or postpone | More nuanced evaluation; THC positive may not trigger automatic decline |

**State-specific guidance on marijuana in underwriting:**

- **California**: DOI guidance discourages penalizing legal marijuana use to the same extent as illegal drug use
- **Colorado**: CDI has indicated that insurers should not treat legal marijuana use identically to illegal drug use
- **New York**: DFS has not issued specific guidance but monitors for unfair discrimination based on lawful activities
- **Oregon**: Lawful-activity protections may limit insurer's ability to rate for legal marijuana use

**System implementation:**

```json
{
  "marijuanaUnderwritingConfig": {
    "stateCode": "CO",
    "recreationalLegal": true,
    "medicalLegal": true,
    "underwritingApproach": "SEPARATE_MARIJUANA_CLASS",
    "tobaccoEquivalent": false,
    "frequencyThresholds": {
      "occasional": { "maxPerWeek": 2, "riskClass": "STANDARD_NONSMOKER" },
      "moderate": { "maxPerWeek": 5, "riskClass": "STANDARD_NONSMOKER" },
      "heavy": { "minPerWeek": 6, "riskClass": "STANDARD_SMOKER" }
    },
    "cbdOnlyExcluded": true,
    "medicalMarijuanaWithPrescription": "EVALUATE_UNDERLYING_CONDITION"
  }
}
```

### 6.4 Transgender Underwriting Guidance

Several states have issued guidance on underwriting of transgender individuals:

| State | Guidance | Key Requirements |
|-------|----------|-----------------|
| **California** | CDI Bulletin 2013-5; Insurance Code § 10140.1 | Cannot deny, cancel, or alter coverage based on gender identity; use gender identity (not sex assigned at birth) for rating unless actuarial basis |
| **Colorado** | Bulletin B-4.49 | Cannot discriminate based on gender identity or expression |
| **Connecticut** | Bulletin IC-34 | Gender identity is a protected class; cannot use sex assigned at birth if inconsistent with gender identity |
| **DC** | Human Rights Act | Gender identity and expression are protected classes |
| **Massachusetts** | DOI Bulletin 2013-03 | Cannot discriminate based on gender identity |
| **Minnesota** | Commerce Department guidance | Cannot discriminate based on gender identity |
| **New York** | Circular Letter No. 15 (2019) | Cannot discriminate based on gender identity, gender expression, or transgender status |
| **Oregon** | Division of Financial Regulation guidance | Gender identity is a protected class in insurance |
| **Vermont** | DFR guidance | Gender identity is a protected class |
| **Washington** | OIC R 2022-03 | Cannot discriminate based on gender identity or gender expression |

**Mortality table implications:**

When an insurer uses gender-based mortality tables (which most do, as sex is an actuarially justified rating factor in most states), the question arises: which gender applies for a transgender individual?

**Approaches:**

1. **Gender identity approach**: Use the individual's current gender identity for rating (California, Connecticut, Oregon)
2. **Legal gender approach**: Use the gender on the individual's legal identification documents
3. **Sex at birth approach**: Use sex assigned at birth for mortality table purposes (increasingly disfavored)
4. **Unisex approach**: Apply unisex mortality tables (Montana requires for all applicants)

### 6.5 Domestic Partner / Civil Union Requirements

| State | Requirement |
|-------|-------------|
| **California** | Domestic partners must be treated the same as married spouses for all insurance purposes including beneficiary and insurable interest |
| **Colorado** | Civil unions create the same rights as marriage for insurance purposes |
| **Connecticut** | Same-sex marriage legal since 2008; full equality requirements |
| **DC** | Domestic partnerships recognized; full equality in insurance |
| **Hawaii** | Civil unions and reciprocal beneficiary relationships recognized |
| **Illinois** | Civil unions recognized; full equality |
| **Nevada** | Domestic partnerships recognized |
| **New Jersey** | Domestic partnerships and civil unions recognized |
| **Oregon** | Domestic partnerships recognized |
| **Vermont** | Civil unions (now marriage) — full equality |
| **Washington** | Domestic partnerships recognized for insurance purposes |

**Post-Obergefell (2015)**: While marriage equality is now the law of the land, domestic partner and civil union designations continue to exist in many states and insurers must continue to recognize them for underwriting, beneficiary, and insurable interest purposes.

---

## 7. AML (Anti-Money Laundering)

### 7.1 Why Life Insurance Requires AML Compliance

Life insurance is recognized as a potential vehicle for money laundering because:

- **Large single premiums** can be used to place illicit funds into the financial system
- **Policy loans and surrenders** can convert placed funds back to apparently legitimate form
- **Death benefits** paid to beneficiaries can layer and integrate illicit funds
- **Cash value products** can store value (primarily applies to whole/universal life, but AML applies to all)

While **term life insurance** has lower inherent money-laundering risk (no cash value), it is **not exempt** from AML requirements.

### 7.2 Legal Framework

**Bank Secrecy Act (BSA) / USA PATRIOT Act:**

- **31 U.S.C. §§ 5311-5332**: BSA requires financial institutions (including insurance companies) to establish AML programs
- **31 CFR § 1025**: FinCEN rules specific to insurance companies
- **USA PATRIOT Act § 352**: Requires insurance companies to establish anti-money laundering programs
- **USA PATRIOT Act § 326**: Customer Identification Program (CIP) requirements

### 7.3 AML Program Requirements

Every insurance company must establish and maintain an AML program that includes:

1. **Internal policies, procedures, and controls** reasonably designed to detect and report suspicious transactions
2. **Compliance officer** designation (must be an officer of the company)
3. **Ongoing employee training** program
4. **Independent audit function** to test the AML program

### 7.4 Customer Due Diligence (CDD)

**Standard CDD for all applicants:**

| Element | Requirement | System Implementation |
|---------|-------------|----------------------|
| **Identity verification** | Verify identity using government-issued ID, SSN, date of birth, address | Real-time identity verification via LexisNexis, Equifax, etc. |
| **Beneficial ownership** | Identify beneficial owners of legal entities | Entity applicants require ownership structure disclosure |
| **Nature of relationship** | Understand the purpose of the insurance transaction | Application questions about purpose, insurable interest |
| **Ongoing monitoring** | Monitor for suspicious activity | Post-issue monitoring for unusual policy activity |

### 7.5 Enhanced Due Diligence (EDD)

Enhanced due diligence is required for higher-risk situations:

**High-face-amount triggers:**

| Face Amount | EDD Requirements |
|-------------|-----------------|
| > $1,000,000 | Source of funds documentation; enhanced identity verification; senior management approval |
| > $5,000,000 | All of above plus: financial justification analysis; third-party verification of assets/income; enhanced beneficial ownership review |
| > $10,000,000 | All of above plus: in-person verification consideration; comprehensive background investigation; reinsurer AML review |

**Other EDD triggers:**

- Applicant is a Politically Exposed Person (PEP)
- Applicant is from or resides in a high-risk jurisdiction (FATF grey/black list)
- Applicant has adverse media or negative news
- Unusual transaction patterns (e.g., multiple applications, multiple policies, rapid policy changes)
- Third-party payer arrangements
- Policy funded from foreign sources

### 7.6 OFAC Screening

The Office of Foreign Assets Control (OFAC) maintains several lists of sanctioned individuals, entities, and countries. Life insurers must screen against OFAC lists.

**Required screening points:**

1. **Application**: Screen applicant, owner, beneficiary, payor at application
2. **Policy issue**: Re-screen at issue
3. **Policy changes**: Screen new beneficiaries, owners, assignees at change
4. **Claims**: Screen claimant and payee at claim
5. **Ongoing**: Periodic re-screening of in-force policies against updated lists

**OFAC lists to screen:**

- Specially Designated Nationals (SDN) list
- Sectoral Sanctions Identifications (SSI) list
- Foreign Sanctions Evaders (FSE) list
- Non-SDN Menu-Based Sanctions (NS-MBS) list
- Consolidated Sanctions List (non-SDN)

**Screening must include:**

- Full legal name and known aliases
- Date of birth
- Address (current and prior)
- Country of citizenship/residency
- Fuzzy matching (name variations, transliterations, phonetic matches)

### 7.7 Suspicious Activity Reporting (SAR)

**When to file a SAR:**

An insurer must file a SAR with FinCEN when it knows, suspects, or has reason to suspect that a transaction:

1. Involves funds derived from illegal activity
2. Is designed to evade BSA reporting requirements
3. Has no business or apparent lawful purpose
4. Involves the use of the insurer to facilitate criminal activity

**SAR filing requirements:**

| Element | Requirement |
|---------|-------------|
| Filing deadline | Within 30 days of detection (60 days if no suspect identified) |
| Filing method | Electronic filing via FinCEN BSA E-Filing System |
| Threshold | No minimum dollar threshold for insurance SARs |
| Confidentiality | SAR existence and contents are confidential; cannot notify the subject |
| Retention | Retain SAR and supporting documentation for 5 years from filing |

### 7.8 AML Red Flags in Life Insurance Underwriting

```
┌──────────────────────────────────────────────────────────────┐
│              AML Red Flags in Underwriting                    │
│                                                              │
│  APPLICANT RED FLAGS                                         │
│  ├── Applicant reluctant to provide identification           │
│  ├── Identification documents appear forged or altered       │
│  ├── Applicant's address is in a high-risk jurisdiction      │
│  ├── Applicant is a PEP or close associate of a PEP         │
│  ├── Applicant's stated income inconsistent with face amount │
│  ├── Applicant has adverse media / negative news             │
│  ├── Applicant matches or closely matches OFAC list          │
│  └── Applicant recently immigrated from high-risk country    │
│                                                              │
│  TRANSACTION RED FLAGS                                       │
│  ├── Face amount disproportionate to income or need          │
│  ├── Multiple applications in short period                   │
│  ├── Applicant insisting on large single premium payment     │
│  ├── Third-party paying premiums (non-family)                │
│  ├── Applicant inquiring about early surrender or loan       │
│  │   provisions before policy issued                         │
│  ├── Requests to name unusual beneficiaries                  │
│  ├── Payment via wire transfer from foreign bank             │
│  ├── Payment via multiple money orders or cashier's checks   │
│  └── Structured payments to avoid reporting thresholds       │
│                                                              │
│  AGENT/PRODUCER RED FLAGS                                    │
│  ├── Agent completing application without applicant present  │
│  ├── Agent paying premiums on behalf of insured              │
│  ├── Agent pressing for rapid issue without normal UW        │
│  ├── Agent handling unusually high volume of high-face cases │
│  └── Agent associated with known fraud cases                 │
└──────────────────────────────────────────────────────────────┘
```

### 7.9 AML Compliance Data Model

```json
{
  "amlScreeningResult": {
    "applicationId": "APP-2024-001234",
    "screeningDate": "2024-03-15T10:30:00Z",
    "screeningType": "APPLICATION",
    "personsScreened": [
      {
        "role": "APPLICANT_INSURED",
        "fullName": "John Michael Smith",
        "dob": "1985-06-15",
        "ssn": "***-**-1234",
        "ofacResult": "NO_MATCH",
        "pepResult": "NO_MATCH",
        "adverseMediaResult": "NO_MATCH",
        "sanctionsResult": "NO_MATCH"
      },
      {
        "role": "BENEFICIARY",
        "fullName": "Jane Marie Smith",
        "dob": "1987-09-22",
        "ofacResult": "NO_MATCH",
        "pepResult": "NO_MATCH"
      }
    ],
    "eddRequired": false,
    "eddTrigger": null,
    "overallResult": "CLEAR",
    "analystReview": null,
    "vendorUsed": "BRIDGER_INSIGHT",
    "vendorReferenceId": "BR-2024-56789"
  }
}
```

---

## 8. Insurance Fraud & Contestability

### 8.1 Material Misrepresentation

**Legal framework:**

Insurance contracts are contracts of **utmost good faith** (uberrimae fidei). The applicant has a duty to disclose all material information truthfully. A **material misrepresentation** is a false statement in the application that, if known to the insurer, would have influenced the underwriting decision.

**Elements of material misrepresentation:**

1. **A statement was made** in the application (or during the underwriting process)
2. **The statement was false** (inaccurate, incomplete, or misleading)
3. **The misrepresentation was material** — it would have influenced the insurer's decision to issue, rate, or set terms
4. **The insurer relied** on the misrepresentation in making its underwriting decision

**Materiality test (varies by state):**

| Standard | Description | States |
|----------|-------------|--------|
| **Increase-in-risk** | Misrepresentation is material if it increases the risk assumed by the insurer | Majority of states |
| **Reliance** | Material if insurer actually relied on the misrepresentation | Some states |
| **Contribute-to-loss** | Material only if the misrepresented condition contributed to the loss (death) | NY, CT, and several others |
| **Intent-to-deceive** | Requires showing that applicant intended to deceive (not just made an honest mistake) | MO, and a few others |

### 8.2 Contestability Period

The **contestability period** is one of the most important concepts in life insurance law. It establishes a time window during which the insurer can investigate and potentially rescind a policy based on material misrepresentation.

**Standard contestability clause:**

> This policy shall be incontestable after it has been in force during the lifetime of the insured for a period of two (2) years from the date of issue, except for non-payment of premiums and except as to provisions relating to benefits in the event of disability and provisions which grant additional insurance specifically against death by accident.

**Key rules:**

| Rule | Description |
|------|-------------|
| **Duration** | 2 years from policy issue (in all states; some states allow shorter) |
| **During lifetime** | The insured must be alive during the contestability period; if insured dies during the period, the policy can be contested |
| **Runs from issue date** | Not from application date; backdating can affect the period |
| **Suicide exclusion** | Separate from contestability; typically also 2 years |
| **Reinstatement** | Reinstatement restarts the contestability period (new 2-year period) |
| **Fraud exception** | Some states allow contest even after 2 years for fraud (not just misrepresentation) |
| **State variations** | A few states have 1-year contestability for certain types |

### 8.3 Rescission Process

When an insurer discovers a material misrepresentation during the contestability period:

```
┌──────────────────────────────────────────────────────────────┐
│                     Rescission Process                        │
│                                                              │
│  1. DISCOVERY                                                │
│     ├── Claim investigation reveals potential misrep         │
│     ├── Post-issue audit identifies discrepancy              │
│     └── Third-party information contradicts application      │
│                                                              │
│  2. INVESTIGATION                                            │
│     ├── Obtain and review original application               │
│     ├── Gather evidence of actual facts                      │
│     ├── Document the misrepresentation                       │
│     ├── Determine materiality (would UW decision change?)    │
│     └── Legal review of state-specific contestability rules  │
│                                                              │
│  3. MATERIALITY DETERMINATION                                │
│     ├── Re-underwrite with correct information               │
│     ├── Document what the decision WOULD have been           │
│     │   (decline? different rating? exclusion?)              │
│     └── Apply state-specific materiality standard            │
│                                                              │
│  4. DECISION                                                 │
│     ├── If material: proceed with rescission                 │
│     ├── If not material: no rescission; pay claim            │
│     └── If close call: legal and compliance review           │
│                                                              │
│  5. NOTICE                                                   │
│     ├── Written notice to policyholder/beneficiary           │
│     ├── Explain the misrepresentation                        │
│     ├── Explain materiality determination                    │
│     ├── Return all premiums paid (mandatory in most states)  │
│     └── Advise of right to contest/appeal                    │
│                                                              │
│  6. DOCUMENTATION                                            │
│     ├── Complete rescission file for regulatory examination  │
│     ├── Report to state DOI if required                      │
│     └── Report to MIB if applicable                          │
└──────────────────────────────────────────────────────────────┘
```

### 8.4 Fraud Indicators in Underwriting

**Application-stage fraud indicators:**

| Indicator | Risk Level | System Detection Method |
|-----------|-----------|------------------------|
| Inconsistent answers across application sections | Medium | Cross-reference validation rules |
| Income stated significantly above industry/occupation norms | Medium | Income reasonability check against occupation/age tables |
| Multiple recent applications at other carriers | High | MIB activity check |
| Application submitted very shortly after a terminal diagnosis (STOLI indicator) | Critical | Medical record review; velocity check |
| Applicant has no insurable interest relationship with owner/beneficiary | Critical | Insurable interest verification |
| Answers conflict with MIB codes | High | Automated MIB comparison |
| Answers conflict with Rx history | High | Automated Rx-to-application comparison |
| Answers conflict with MVR | Medium | Automated MVR comparison |
| Face amount grossly disproportionate to income/net worth | High | Financial justification rules |
| Recent lifestyle change (e.g., sudden fitness, diet) inconsistent with history | Low-Medium | Difficult to detect automatically |

**STOLI (Stranger-Originated Life Insurance) indicators:**

STOLI involves a third party (with no insurable interest) initiating and funding a life insurance policy on someone's life, typically an elderly individual, with the intent to profit from the death benefit.

- Premium financing arrangements with no reasonable ability to repay
- Policy procured at instigation of a third party with no insurable interest
- Applicant has multiple recently-issued large policies
- Applicant was solicited by a "life settlement" broker
- Trust or entity named as owner/beneficiary with no clear connection to insured
- Free-look period inquiry before policy delivery
- Applicant is elderly with face amount disproportionate to estate

### 8.5 Post-Claim Underwriting Prohibition

Many states prohibit or restrict **post-claim underwriting** — the practice of conducting minimal underwriting at application and then rigorously investigating only when a claim is filed.

**States with explicit prohibitions or restrictions:**

- California (Cal. Ins. Code § 10113.5)
- New York (Circular Letter No. 2001-11)
- Illinois (215 ILCS 5/224)
- Several others via Unfair Claims Practices Act provisions

**Impact on system design:**

- Underwriting completeness must be documented at time of issue
- The system must ensure that all material questions were asked and answered before policy issue
- Simplified issue and accelerated underwriting programs must be defensible as adequate underwriting — not deferred underwriting

---

## 9. Privacy Regulations

### 9.1 NAIC Insurance Information and Privacy Protection Model Act (#670)

This model act governs how personal information is collected, used, and disclosed by insurers. Most states have adopted some version.

**Key provisions:**

1. **Notice of information practices**: Insurers must provide notice to applicants about information collection and sharing practices
2. **Access to recorded personal information**: Applicants and policyholders have the right to access their recorded personal information
3. **Correction or amendment**: Right to request correction of inaccurate information
4. **Reasons for adverse underwriting decisions**: Insurer must provide specific reasons for adverse decisions
5. **Information collected through pretext interviews**: Prohibits obtaining information through false pretenses
6. **Disclosure limitations**: Limits on sharing personal information without consent

### 9.2 CCPA/CPRA (California)

The California Consumer Privacy Act (CCPA, as amended by CPRA) applies to insurers operating in California and creates significant obligations.

**Applicability to insurance:**

- CCPA broadly applies to businesses that collect California consumers' personal information
- The insurance exemption in CCPA § 1798.145(e) exempts activity regulated by the California Insurance Information and Privacy Protection Act (IIPPA) — but the exemption is narrow and does not cover all insurer data practices
- CPRA (effective January 1, 2023) further narrowed the insurance exemption

**Key CCPA/CPRA obligations for insurers:**

| Right | Description | UW System Impact |
|-------|-------------|------------------|
| **Right to Know** | Consumers can request what personal info is collected, used, and disclosed | Must catalog all UW data elements and their sources |
| **Right to Delete** | Consumers can request deletion of personal info (with exceptions) | Must implement deletion workflow; insurance exception applies to active policies |
| **Right to Opt-Out** | Consumers can opt out of "sale" or "sharing" of personal info | Must implement opt-out mechanism; evaluate if any UW data sharing constitutes "sale" |
| **Right to Correct** | Consumers can request correction of inaccurate info | Must implement correction workflow |
| **Right to Limit Use of Sensitive Personal Information** | Consumers can limit use of sensitive info (SSN, health data, etc.) | Must evaluate which UW data elements are "sensitive" |
| **Privacy Notice** | Must provide detailed notice at or before collection | Application must include CCPA-compliant notice |

### 9.3 NY DFS Cybersecurity Regulation (23 NYCRR 500)

The New York Department of Financial Services Cybersecurity Regulation is one of the most stringent cybersecurity requirements for financial institutions, including insurers.

**Key requirements relevant to underwriting systems:**

| Section | Requirement | Implementation |
|---------|-------------|----------------|
| 500.02 | Cybersecurity program | Documented program covering UW systems |
| 500.03 | Cybersecurity policy | Board-approved policy covering data protection |
| 500.04 | CISO designation | Responsible for UW system security |
| 500.05 | Penetration testing and vulnerability assessments | Annual penetration testing; bi-annual vulnerability assessment of UW systems |
| 500.06 | Audit trail | UW systems must maintain audit trail of all transactions and access for 5+ years |
| 500.07 | Access privileges | Limit access to UW data and systems based on job function |
| 500.08 | Application security | Secure development practices for UW applications |
| 500.09 | Risk assessment | Periodic risk assessment of UW systems and data |
| 500.10 | Third-party service provider security policy | Security requirements for UW vendors (labs, CRAs, TPAs) |
| 500.11 | Multi-factor authentication | MFA for access to UW systems and data |
| 500.12 | Limitations on data retention | Cannot retain nonpublic information longer than necessary; must securely dispose |
| 500.13 | Encryption | Encryption of nonpublic info in transit and at rest in UW systems |
| 500.14 | Monitoring | Implement systems to monitor UW system activity and detect unauthorized access |
| 500.15 | Encryption of nonpublic information | All nonpublic info must be encrypted (in transit and at rest) |
| 500.16 | Incident response plan | Plan must cover UW system breaches |
| 500.17 | Notices to superintendent | Report material cybersecurity events within 72 hours |

### 9.4 NAIC Insurance Data Security Model Law (#668)

This model law, adopted by over 20 states, establishes data security requirements for insurers similar to NY DFS 500 but less prescriptive.

**Key requirements:**

1. **Information Security Program**: Written program appropriate to insurer's size and complexity
2. **Risk Assessment**: Identify reasonably foreseeable threats to nonpublic information
3. **Security Measures**: Implement safeguards (access controls, encryption, etc.)
4. **Third-Party Oversight**: Due diligence and contractual security requirements for vendors
5. **Incident Response Plan**: Written plan for responding to cybersecurity events
6. **Notification**: Notify state DOI within 72 hours of a cybersecurity event; notify consumers as required
7. **Annual Certification**: Certify compliance to state DOI annually

**States that have adopted the NAIC Data Security Model Law (as of 2025):**

Alabama, Connecticut, Delaware, Georgia, Hawaii, Illinois, Indiana, Iowa, Kentucky, Louisiana, Maine, Maryland, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, New Hampshire, New York (has its own regulation), North Carolina, North Dakota, Ohio, Oklahoma, Oregon, Rhode Island, South Carolina, Tennessee, Texas, Vermont, Virginia, West Virginia, Wisconsin

### 9.5 Breach Notification Requirements

All 50 states, DC, and US territories have breach notification laws. When a breach of personal information occurs in underwriting systems:

**Common requirements:**

| Element | Typical Requirement |
|---------|-------------------|
| **Definition of breach** | Unauthorized access to or acquisition of unencrypted personal information |
| **Personal information** | Typically: name + SSN, driver's license, financial account number, health information |
| **Notification timing** | Varies: "without unreasonable delay" (most states), 30 days (some), 60 days (some), 72 hours (for DOI notification in Data Security Model Law states) |
| **Notification content** | Description of breach, types of info compromised, steps taken, contact info, credit monitoring offer (if SSN exposed) |
| **Notification recipients** | Affected individuals, state AG (most states), state DOI (if insurer), credit bureaus (if >500 or >1,000 affected, varies) |
| **Record retention** | Retain breach investigation files for state examination |

### 9.6 Privacy Impact Assessment (PIA)

For automated underwriting systems, a privacy impact assessment should be conducted:

```
┌──────────────────────────────────────────────────────────────────┐
│              Privacy Impact Assessment Framework                  │
│                                                                  │
│  1. DATA INVENTORY                                               │
│     ├── What personal data is collected?                         │
│     ├── What are the sources (applicant, CRA, medical, etc.)?   │
│     ├── What is the legal basis for collection?                  │
│     ├── What sensitive data elements are present?                │
│     │   (SSN, health data, financial data, genetic info)         │
│     └── What is the data flow (collection → processing →        │
│         storage → sharing → disposal)?                           │
│                                                                  │
│  2. PURPOSE LIMITATION                                           │
│     ├── Is data used only for the stated purpose (underwriting)? │
│     ├── Is any secondary use occurring (analytics, marketing)?  │
│     └── Is purpose documented and communicated to consumer?     │
│                                                                  │
│  3. DATA MINIMIZATION                                            │
│     ├── Is only the minimum necessary data collected?           │
│     ├── Could the same UW decision be made with less data?      │
│     └── Are data fields that are no longer needed being purged? │
│                                                                  │
│  4. STORAGE & SECURITY                                           │
│     ├── Where is data stored (on-prem, cloud, vendor)?          │
│     ├── Is data encrypted at rest and in transit?               │
│     ├── Who has access? (Role-based access controls)            │
│     ├── How is access audited?                                   │
│     └── What is the retention period and disposal method?       │
│                                                                  │
│  5. SHARING & DISCLOSURE                                         │
│     ├── With whom is UW data shared?                            │
│     │   (reinsurers, vendors, MIB, regulators)                  │
│     ├── Is there a legal basis and/or consent for each sharing? │
│     ├── Are data processing agreements in place?                │
│     └── Is cross-border data transfer occurring?                │
│                                                                  │
│  6. INDIVIDUAL RIGHTS                                            │
│     ├── Can consumers access their UW data?                     │
│     ├── Can they request correction?                             │
│     ├── Can they request deletion (with exceptions)?            │
│     ├── Can they opt out of sharing/sale?                       │
│     └── How are these requests fulfilled?                       │
│                                                                  │
│  7. RISK ASSESSMENT                                              │
│     ├── What are the privacy risks?                             │
│     ├── What is the likelihood and impact of each risk?         │
│     ├── What mitigations are in place?                          │
│     └── What residual risk remains?                             │
│                                                                  │
│  8. SIGN-OFF                                                     │
│     ├── Privacy officer review and approval                     │
│     ├── Legal review and approval                                │
│     ├── CISO review and approval                                │
│     └── Periodic re-assessment schedule (annual minimum)        │
└──────────────────────────────────────────────────────────────────┘
```

---

## 10. Algorithmic Fairness & AI Regulation

### 10.1 The Regulatory Landscape for AI in Insurance

The use of artificial intelligence and machine learning in insurance underwriting is subject to rapidly evolving regulation. As of 2025, the regulatory framework includes:

**Federal level:**

- No comprehensive federal AI regulation for insurance (as of 2025)
- FIO reports and recommendations on AI use in insurance
- EEOC guidance on AI (relevant for employment, not directly insurance)
- NIST AI Risk Management Framework (voluntary, but influential)

**NAIC level:**

- NAIC Model Bulletin on the Use of Artificial Intelligence Systems by Insurers (December 2023)
- NAIC Innovation, Cybersecurity, and Technology (H) Committee guidance
- Big Data and Artificial Intelligence (H) Working Group studies

**State level:**

- Colorado SB 21-169 (Protecting Consumers from Unfair Discrimination in Insurance Practices)
- Connecticut Public Act 22-104 (Insurance Data Privacy)
- Various state DOI bulletins and guidance on algorithmic underwriting

### 10.2 NAIC Model Bulletin on AI (2023)

The NAIC Model Bulletin provides the most comprehensive regulatory guidance on AI use in insurance. Key requirements:

**Governance:**

1. Insurers must have an **AI governance framework** that is proportionate to the risk and impact of AI use
2. Board or senior management must be responsible for AI governance
3. Must designate an individual(s) responsible for AI risk management
4. Must have policies and procedures for the development, acquisition, and use of AI systems

**Principles:**

| Principle | Description | UW System Implementation |
|-----------|-------------|--------------------------|
| **Fair and ethical** | AI must not result in unfair discrimination | Disparate impact testing before deployment and ongoing |
| **Accountable** | Insurer is responsible for AI decisions, even if developed by third party | Full audit trail; cannot disclaim responsibility for vendor AI |
| **Compliant** | AI must comply with all applicable insurance laws | Compliance testing against state-specific rules |
| **Transparent** | Insurer must be able to explain AI decisions to regulators and consumers | Explainability requirements; no pure "black box" |
| **Secure and safe** | AI systems must be secure; data used must be protected | Cybersecurity requirements; data governance |

**Third-party AI:**

- Using a third-party AI system (e.g., vendor scoring model, cloud ML service) does **not** relieve the insurer of compliance obligations
- Insurer must conduct due diligence on third-party AI systems
- Must validate that third-party AI does not produce unfairly discriminatory outcomes
- Contractual provisions must ensure access to model information for regulatory compliance

### 10.3 Colorado SB 21-169

Colorado SB 21-169 is the most significant state legislation specifically addressing algorithmic fairness in insurance.

**Key provisions (effective November 14, 2023):**

1. **Governance and Risk Management**: Insurers must develop, implement, and maintain a governance and risk management framework for the use of external consumer data and information sources (ECDIS), algorithms, and predictive models
2. **Unfair Discrimination Testing**: Insurers must test algorithms and predictive models for unfair discrimination based on race, color, national or ethnic origin, religion, sex, sexual orientation, disability, gender identity, or gender expression
3. **Correlation and Proxy Analysis**: Must assess whether ECDIS or models are using proxies for protected classes
4. **Documentation**: Must maintain documentation of testing methodology and results
5. **Regulatory Reporting**: Commissioner can require submission of testing data and methodology

**Colorado Division of Insurance regulations (3 CCR 702-12):**

| Requirement | Detail |
|-------------|--------|
| Testing frequency | Before deployment and at least annually |
| Testing methodology | Must use quantitative methods; qualitative alone is insufficient |
| Protected classes | Race, color, national/ethnic origin, religion, sex, sexual orientation, disability, gender identity, gender expression |
| Proxy assessment | Must evaluate whether variables serve as proxies for protected classes |
| Documentation retention | 6 years minimum |
| Regulatory authority | Commissioner may examine testing methodology, data, and results |

### 10.4 Disparate Impact Testing for Underwriting Models

**What is disparate impact?**

Disparate impact occurs when a facially neutral practice or criterion disproportionately affects a protected group, even without discriminatory intent. In underwriting, this means an algorithm that does not explicitly use race but produces outcomes that disproportionately disadvantage applicants of a particular race.

**Testing methodologies:**

### 10.4.1 Demographic Parity (Statistical Parity)

**Definition:** The probability of a favorable outcome (approval, best rate class) should be the same across all demographic groups.

```
P(favorable_outcome | Group_A) ≈ P(favorable_outcome | Group_B)

Metric: Demographic Parity Ratio (DPR) = 
  min_group(approval_rate) / max_group(approval_rate)

Threshold: DPR ≥ 0.80 (the "4/5ths rule" adapted from employment law)
```

**Example:**

| Group | Total Applicants | Approved (Preferred+) | Approval Rate | DPR |
|-------|------------------|-----------------------|---------------|-----|
| Group A | 10,000 | 7,500 | 75.0% | — |
| Group B | 5,000 | 3,000 | 60.0% | 60/75 = 0.80 |
| Group C | 3,000 | 2,400 | 80.0% | — |

DPR = 60.0% / 80.0% = 0.75 → Below 0.80 threshold → Potential disparate impact

**Limitation:** Demographic parity does not account for legitimate differences in risk between groups. If Group B genuinely has higher mortality risk, equal approval rates would mean the insurer is not risk-classifying accurately.

### 10.4.2 Equalized Odds

**Definition:** The model's true positive rate (TPR) and false positive rate (FPR) should be the same across demographic groups.

```
P(predicted_high_risk | actually_high_risk, Group_A) ≈ 
P(predicted_high_risk | actually_high_risk, Group_B)

AND

P(predicted_high_risk | actually_low_risk, Group_A) ≈ 
P(predicted_high_risk | actually_low_risk, Group_B)
```

**Interpretation for underwriting:**

- Among applicants who are genuinely high-risk, the model should flag them at the same rate regardless of demographic group
- Among applicants who are genuinely low-risk, the model should clear them at the same rate regardless of demographic group

### 10.4.3 Predictive Parity (Calibration)

**Definition:** The model's positive predictive value (PPV) should be the same across groups. Among those flagged as high-risk, the actual risk level should be similar across groups.

```
P(actually_high_risk | predicted_high_risk, Group_A) ≈
P(actually_high_risk | predicted_high_risk, Group_B)
```

### 10.4.4 Individual Fairness

**Definition:** Similar individuals should receive similar outcomes, regardless of group membership. This is operationalized as:

```
For applicants x, y with similar risk profiles:
|score(x) - score(y)| should be small

even if x ∈ Group_A and y ∈ Group_B
```

### 10.5 Practical Bias Testing Pipeline

```
┌──────────────────────────────────────────────────────────────────┐
│              ML Model Fairness Testing Pipeline                   │
│                                                                  │
│  STEP 1: DATA PREPARATION                                       │
│  ├── Obtain demographic data for test population                 │
│  │   (Note: may need to use BISG or similar imputation           │
│  │    if protected class data not directly collected)            │
│  ├── Define protected groups                                     │
│  ├── Define outcome variable (approval, rate class, etc.)       │
│  └── Split into test/validation sets                             │
│                                                                  │
│  STEP 2: BASELINE METRICS                                        │
│  ├── Calculate approval/decline rates by group                   │
│  ├── Calculate rate class distribution by group                  │
│  ├── Calculate average score/risk assessment by group            │
│  └── Calculate Demographic Parity Ratio                          │
│                                                                  │
│  STEP 3: FAIRNESS METRICS                                        │
│  ├── Demographic Parity: approval rate ratio across groups       │
│  ├── Equalized Odds: TPR and FPR parity across groups           │
│  ├── Predictive Parity: PPV parity across groups                │
│  ├── Calibration: predicted vs. actual risk by group             │
│  └── Individual fairness: matched-pair analysis                  │
│                                                                  │
│  STEP 4: PROXY ANALYSIS                                          │
│  ├── Correlation analysis: each feature vs. protected class     │
│  ├── Feature importance decomposition by group                   │
│  ├── Partial dependence plots for top features by group         │
│  └── SHAP value analysis by group                                │
│                                                                  │
│  STEP 5: REMEDIATION (if bias detected)                          │
│  ├── Feature exclusion (remove high-proxy variables)             │
│  ├── Re-weighting (adjust sample weights)                        │
│  ├── Threshold adjustment (group-specific thresholds)            │
│  ├── Adversarial de-biasing                                      │
│  ├── Post-processing calibration                                 │
│  └── Re-test after remediation                                   │
│                                                                  │
│  STEP 6: DOCUMENTATION & GOVERNANCE                              │
│  ├── Document all testing methodology and results                │
│  ├── Record remediation actions taken                            │
│  ├── Executive summary for governance committee                  │
│  ├── Regulatory-ready report                                     │
│  └── Schedule ongoing monitoring (quarterly minimum)             │
└──────────────────────────────────────────────────────────────────┘
```

### 10.6 BISG (Bayesian Improved Surname Geocoding)

Since insurers typically do not collect race/ethnicity data from applicants, testing for racial disparate impact requires **imputation** of race/ethnicity. BISG is the industry-standard method.

**How BISG works:**

1. Use Census Bureau surname frequency data to estimate P(race | surname)
2. Use Census Bureau geocoded population data to estimate P(race | geography)
3. Apply Bayes' theorem to combine: P(race | surname, geography)

**BISG accuracy:**

- Generally reliable for large populations (thousands of applications)
- Less reliable for individual predictions
- Works best for Black, White, Hispanic, and Asian populations
- Less reliable for smaller populations (Native American, Pacific Islander, etc.)
- Should be used for aggregate analysis, not individual decisions

### 10.7 Model Risk Management (SR 11-7 Adapted for Insurance)

While SR 11-7 (Federal Reserve guidance on model risk management) applies to banks, insurers increasingly adopt its framework for underwriting models:

**Three lines of defense:**

| Line | Responsibility | Activities |
|------|---------------|-----------|
| **First Line** | Model developers, business users | Build, validate, use models; initial testing |
| **Second Line** | Model risk management, compliance | Independent validation; policy and standards; ongoing monitoring |
| **Third Line** | Internal audit | Assess effectiveness of model risk governance; independent testing |

**Model lifecycle governance:**

```
┌────────┐    ┌──────────┐    ┌────────────┐    ┌──────────┐
│ Model  │───▶│ Model    │───▶│ Model      │───▶│ Model    │
│ Design │    │ Develop  │    │ Validation │    │ Approval │
└────────┘    └──────────┘    └────────────┘    └────┬─────┘
                                                     │
     ┌───────────────────────────────────────────────┘
     │
     ▼
┌──────────┐    ┌──────────┐    ┌──────────────┐
│ Model    │───▶│ Model    │───▶│ Model        │
│ Deploy   │    │ Monitor  │    │ Retire/      │
│          │    │ (ongoing)│    │ Replace      │
└──────────┘    └──────────┘    └──────────────┘
```

**Validation requirements for underwriting models:**

1. **Conceptual soundness**: Does the model make actuarial/medical sense?
2. **Data quality**: Is training data representative, accurate, and sufficient?
3. **Discrimination testing**: Does the model produce unfairly discriminatory outcomes?
4. **Performance testing**: Accuracy, stability, sensitivity analysis
5. **Benchmarking**: Comparison against alternative models or manual underwriting
6. **Limitations documentation**: What can't the model do? Where does it break down?
7. **Ongoing monitoring**: Performance drift, data drift, fairness drift

---

## 11. MIB Compliance

### 11.1 What Is MIB?

MIB, Inc. (formerly the Medical Information Bureau) is a not-for-profit corporation owned by approximately 400 member life insurance companies. It operates an information exchange that helps insurers detect misrepresentation and fraud on life, health, disability, and long-term care insurance applications.

### 11.2 MIB Code System

MIB uses a coded system to flag medical conditions, lifestyle risks, and other underwriting-relevant findings. Codes are **not** diagnoses — they are signals that a prior insurer identified a condition during underwriting.

**Code categories:**

| Category | Code Range | Examples |
|----------|-----------|---------|
| Cardiovascular | 001-099 | Hypertension, coronary artery disease, arrhythmia |
| Respiratory | 100-199 | Asthma, COPD, sleep apnea |
| Gastrointestinal | 200-299 | Liver disease, Crohn's, ulcerative colitis |
| Neurological | 300-399 | Epilepsy, multiple sclerosis, stroke |
| Mental/Behavioral | 400-499 | Depression, anxiety, substance abuse |
| Musculoskeletal | 500-599 | Back disorders, arthritis |
| Endocrine | 600-699 | Diabetes, thyroid disorders |
| Genitourinary | 700-799 | Kidney disease, prostate conditions |
| Neoplastic | 800-899 | Cancer (various types) |
| Blood/Immune | 900-949 | Anemia, HIV/AIDS, autoimmune |
| Non-medical | 950-999 | Aviation, hazardous activities, financial, driving |

### 11.3 Fair Information Practices (MIB Member Obligations)

All MIB member companies must comply with MIB's **Fair Information Practices**, which align with FCRA requirements and add additional protections:

**Pre-notification requirement:**

Before submitting an application for MIB checking, the insurer must provide the applicant with a **Pre-Notification** disclosure. This can be included in the application or provided separately.

**Required MIB pre-notification language:**

```
────────────────────────────────────────────────────────────────────────
INFORMATION PRACTICES — MIB, INC. DISCLOSURE

Information regarding your insurability will be treated as
confidential. [COMPANY NAME] or its reinsurers may, however, make a
brief report thereon to MIB, Inc., formerly known as the Medical
Information Bureau, a not-for-profit membership organization of life
insurance companies, which operates an information exchange on behalf
of its Members. If you apply to another MIB Member company for life
or health insurance coverage, or a claim for benefits is submitted to
such a company, MIB, upon request, will supply such company with the
MIB information in its file.

Upon receipt of a request from you, MIB will arrange disclosure of
any information in your file. Please contact MIB at 50 Braintree
Hill Park, Suite 400, Braintree, Massachusetts 02184-8734, telephone
(866) 692-6901. If you question the accuracy of information in
MIB's file, you may contact MIB and seek a correction in accordance
with the procedures set forth in the federal Fair Credit Reporting
Act. The address for MIB is 50 Braintree Hill Park, Suite 400,
Braintree, Massachusetts 02184-8734, telephone (866) 692-6901.

[COMPANY NAME] or its reinsurers may also release information in its
file to other insurance companies to whom you may apply for life or
health insurance, or to whom a claim for benefits may be submitted.

Information for consumers about MIB may be obtained on its website
at www.mib.com.
────────────────────────────────────────────────────────────────────────
```

### 11.4 Applicant Rights to MIB Record

Under FCRA and MIB's own policies, applicants have the following rights:

1. **Right to disclosure**: Request a copy of their MIB record
2. **Right to dispute**: Challenge the accuracy of any MIB code
3. **Right to correction**: Have inaccurate information corrected or deleted
4. **Free annual disclosure**: One free MIB record disclosure per year (via www.mib.com)
5. **Right to know who received**: Know which insurers have accessed their MIB record in the past 12 months

### 11.5 MIB Coding Obligations

**When to code:**

Insurers must report MIB codes when underwriting reveals a condition or finding that is significant to the applicant's insurability. Coding must occur:

- After the underwriting decision is made (not before)
- Only for conditions detected through the underwriting process
- Only using approved MIB codes
- Within the timeframe required by MIB rules (typically 15 business days)

**What NOT to code:**

- Information obtained solely from the MIB check itself (no "chain coding")
- Information from genetic testing (in states where genetic information restrictions apply)
- Information that does not correspond to an approved MIB code
- HIV/AIDS status (subject to specific MIB HIV reporting rules and state restrictions)

### 11.6 MIB Dispute Process

```
┌──────────────────────────────────────────────────────────────┐
│                  MIB Dispute Process                          │
│                                                              │
│  1. Consumer contacts MIB to dispute a code                  │
│     ├── Online at www.mib.com                                │
│     ├── Phone: (866) 692-6901                                │
│     └── Mail: 50 Braintree Hill Park, Suite 400,             │
│              Braintree, MA 02184                              │
│                                                              │
│  2. MIB notifies the reporting insurer of the dispute        │
│     └── Insurer has 30 days to investigate and respond       │
│                                                              │
│  3. Reporting insurer investigates                           │
│     ├── Reviews original underwriting file                   │
│     ├── Verifies the basis for the code                      │
│     └── Responds to MIB with findings                        │
│                                                              │
│  4. MIB resolves the dispute                                 │
│     ├── If insurer agrees code is inaccurate: delete/modify  │
│     ├── If insurer maintains code is accurate: retain        │
│     └── If insurer cannot substantiate: delete               │
│                                                              │
│  5. MIB notifies consumer of outcome                         │
│     ├── If resolved in consumer's favor: updated record      │
│     └── If not: consumer may add statement of dispute        │
│                                                              │
│  6. If consumer remains dissatisfied                         │
│     ├── Escalate within MIB                                  │
│     ├── File complaint with state DOI                        │
│     └── File complaint with CFPB/FTC                         │
└──────────────────────────────────────────────────────────────┘
```

### 11.7 MIB Integration Architecture

```json
{
  "mibIntegration": {
    "checkRequest": {
      "endpoint": "https://services.mib.com/checking/v2",
      "authentication": "MUTUAL_TLS",
      "requestFields": [
        "fullLegalName",
        "dateOfBirth",
        "stateOfResidence",
        "ssn_last4",
        "gender",
        "applicationDate",
        "productType",
        "faceAmount"
      ],
      "responseFields": [
        "matchIndicator",
        "mibCodes",
        "activityIndicator",
        "followUpRecommendation"
      ]
    },
    "codeReporting": {
      "endpoint": "https://services.mib.com/coding/v2",
      "timing": "POST_DECISION",
      "maxReportingDelay": "15_BUSINESS_DAYS"
    },
    "disputeHandling": {
      "inboundChannel": "SECURE_API",
      "responseDeadline": "30_CALENDAR_DAYS",
      "workflowIntegration": "UW_CASE_MANAGEMENT"
    }
  }
}
```

---

## 12. Replacement & Suitability Regulations

### 12.1 NAIC Life Insurance and Annuities Replacement Model Regulation (#613)

The Replacement Model Regulation governs the process when a new life insurance policy is intended to replace an existing policy. This regulation exists to protect consumers from inappropriate replacement (called "churning" or "twisting").

**Definition of replacement:**

A transaction where a new policy is purchased and an existing policy is:
- Lapsed, forfeited, surrendered, or otherwise terminated
- Converted to reduced paid-up or extended term insurance
- Amended to reduce benefits or lengthen the benefit period
- Subjected to borrowing (policy loan exceeding existing indebtedness)
- Assigned to the replacing insurer or its agent

### 12.2 Replacement Process Requirements

**When replacement is identified:**

| Step | Responsibility | Requirement |
|------|---------------|-------------|
| 1 | Agent/Producer | Complete replacement questionnaire in application |
| 2 | Agent/Producer | Present Important Notice Regarding Replacement to applicant |
| 3 | Agent/Producer | Leave copies of all sales materials with applicant |
| 4 | Replacing insurer | Send notice to existing insurer within specified timeframe (typically 3-10 business days) |
| 5 | Existing insurer | May contact policyholder to provide comparative information |
| 6 | Replacing insurer | Maintain replacement file for regulatory examination |

**Important Notice Regarding Replacement (template):**

```
────────────────────────────────────────────────────────────────────────
            IMPORTANT NOTICE REGARDING REPLACEMENT
            
        OF LIFE INSURANCE OR ANNUITIES

You are contemplating the purchase of a life insurance policy or
annuity contract. In some cases this purchase may involve
discontinuing or changing an existing policy or contract. If so,
a replacement is occurring.

Financed purchases are also considered replacements.

A replacement occurs when a new policy or contract is purchased
and, in connection with the sale, you discontinue making premium
payments on the existing policy or contract, or an existing policy
or contract is surrendered, forfeited, assigned to the replacing
insurer, or otherwise terminated or used in a financed purchase.

A financed purchase occurs when the purchase of a new life
insurance policy involves the use of funds obtained by the
withdrawal or surrender of or by borrowing some or all of the
policy values, including accumulated dividends, of an existing
policy, to pay all or part of any premium or policy values of a
new policy.

You should carefully consider whether a replacement is in your
best interest. You will want to consider the following:

(1) Premiums for the new policy may be higher because you are
    now older.
(2) Your present health condition may affect your ability to
    obtain a new policy.
(3) Your existing policy may have provisions not available in
    the new policy.
(4) There may be tax consequences to the replacement.
(5) A new contestability and suicide period will begin for the
    new policy.

I certify that the following is being replaced:

Company: _____________________  Policy Number: ________________

Sincerely,
[APPLICANT SIGNATURE]            [DATE]
[AGENT SIGNATURE]                [DATE]
────────────────────────────────────────────────────────────────────────
```

### 12.3 State Variations in Replacement Requirements

| State | Notable Variation |
|-------|------------------|
| **California** | Enhanced consumer protection; longer comparison period; specific disclosure requirements |
| **Florida** | Agents must complete specific replacement training; detailed comparison required |
| **New York** | Regulation 60 (11 NYCRR 51) — among the most detailed replacement regulations; requires specific comparison forms |
| **Texas** | Specific replacement form requirements; agent training requirements |
| **Illinois** | Enhanced disclosure for senior consumers (age 65+) |
| **Pennsylvania** | Specific replacement notice language requirements |

### 12.4 Suitability / Best Interest Standards

**NAIC Suitability in Life Insurance Model Regulation (#582):**

Originally adopted in 2010 and substantially revised in 2020 to add a **best interest** standard, this regulation requires:

1. **Producer obligation**: Must act in the consumer's best interest at the time of recommendation
2. **Care obligation**: Must exercise reasonable diligence, care, and skill in making a recommendation
3. **Disclosure obligation**: Must disclose relevant information including conflicts of interest
4. **Conflict of interest obligation**: Must identify and mitigate conflicts of interest

**Suitability factors to consider:**

- Consumer's age
- Annual income and financial situation
- Financial experience and objectives
- Intended use of the policy
- Financial time horizon
- Existing assets and financial products
- Liquidity needs
- Risk tolerance
- Tax status

**System implications:**

The underwriting system should integrate suitability assessment — not just risk assessment — as part of the application process. This includes:

- Needs analysis questionnaire
- Financial justification validation
- Replacement detection and processing
- Suitability documentation in the case file

---

## 13. E-Signature & E-Delivery

### 13.1 Federal Framework: E-SIGN Act

The Electronic Signatures in Global and National Commerce Act (E-SIGN, 15 U.S.C. §§ 7001–7031, 2000) provides the federal foundation for electronic signatures and records in insurance transactions.

**Key provisions:**

- A signature, contract, or record may not be denied legal effect solely because it is in electronic form
- An electronic signature satisfies any law that requires a signature
- An electronic record satisfies any law that requires a record to be in writing

**Requirements for valid e-signature:**

1. **Intent to sign**: The signer must intend to sign the document
2. **Consent to do business electronically**: Must be affirmative consent
3. **Association of signature with record**: The e-signature must be logically associated with the record
4. **Record retention**: Electronic records must be retained in a form that accurately reflects the information

### 13.2 UETA (Uniform Electronic Transactions Act)

UETA is a model state law (adopted by 47 states + DC) that provides the state-level framework for electronic transactions. UETA is largely consistent with E-SIGN but may have state-specific variations.

**States that have NOT adopted UETA:**
- Illinois (has its own Electronic Commerce Security Act)
- New York (has its own Electronic Signatures and Records Act — ESRA)
- Washington (has its own electronic authentication laws)

### 13.3 Consent Requirements for E-Signature and E-Delivery

**E-SIGN consent requirements (15 U.S.C. § 7001(c)):**

Before using electronic records to satisfy a legal requirement to provide a document in writing, the consumer must:

1. **Receive clear and conspicuous statement** informing them of:
   - Right to receive paper records
   - Right to withdraw consent (and any conditions, consequences, and fees for withdrawal)
   - Whether consent applies only to the current transaction or to ongoing relationship
   - Procedures for withdrawing consent and updating contact information
   - Hardware and software requirements to access and retain electronic records

2. **Affirmatively consent** to electronic delivery

3. **Demonstrate ability** to access the electronic format (e.g., by opening a test document or responding to a verification email)

**Template consent language:**

```
────────────────────────────────────────────────────────────────────────
            CONSENT TO ELECTRONIC SIGNATURES AND DELIVERY

By checking the box below, you consent to:

1. Sign documents electronically using [E-SIGNATURE TECHNOLOGY]
2. Receive documents and notices electronically, including but
   not limited to:
   - Insurance applications and amendments
   - Policy documents and endorsements
   - Underwriting correspondence and notices
   - Privacy notices and disclosures
   - Adverse action notices
   - Annual statements and confirmations

YOUR RIGHTS:

- You have the right to receive paper copies of any documents.
  To request paper copies, contact us at [PHONE/EMAIL].
  [Paper copy fees, if any: $X per document]

- You may withdraw this consent at any time by contacting us
  at [PHONE/EMAIL/ADDRESS]. Withdrawal of consent will not
  affect the legal validity of any electronic signatures or
  documents provided before withdrawal.

- This consent applies to all transactions and communications
  related to your insurance application and policy with
  [COMPANY NAME].

HARDWARE AND SOFTWARE REQUIREMENTS:

To access and retain electronic documents, you will need:
- A computer or mobile device with internet access
- A current web browser (Chrome, Firefox, Safari, or Edge)
- Adobe Acrobat Reader or compatible PDF reader
- An active email address
- Sufficient storage to save documents or a printer to print them

CONTACT INFORMATION:

Please keep your email address current. To update your email
address, contact us at [PHONE/EMAIL/ADDRESS].

□ I have read this disclosure. I consent to use electronic
  signatures and receive documents electronically. I confirm
  that I can access documents in the electronic format described
  above.

[SIGNATURE]                         [DATE]
[EMAIL ADDRESS FOR DELIVERY]
────────────────────────────────────────────────────────────────────────
```

### 13.4 E-Signature in Insurance — Specific Considerations

| Document | E-Signature Permitted? | Notes |
|----------|----------------------|-------|
| Application for insurance | Yes (all states) | Consent required |
| HIPAA authorization | Yes (with specific requirements) | Must meet HIPAA electronic authorization standards |
| HIV test consent | State-specific | Some states require wet signature for HIV test consent |
| Beneficiary designation | Yes (most states) | May need witness/notarization in some states |
| Policy delivery acknowledgment | Yes (most states) | Starts free-look period |
| Replacement notice | Yes (most states) | Some states require specific format |
| Adverse action notice | Yes (if e-delivery consent obtained) | FCRA permits electronic delivery |
| Premium payment authorization | Yes | Standard e-commerce |
| Ownership/assignment change | State-specific | Some states require specific formalities |

### 13.5 Record Retention for Electronic Documents

**E-SIGN retention requirements:**

- Electronic records must be retained in a form that accurately reflects the information
- Records must remain accessible for later reference
- Retention period must comply with state insurance record retention laws (typically 7-10 years for underwriting records)

**Best practices:**

| Practice | Description |
|----------|-------------|
| Tamper-evident storage | Use digital signatures or hash-based verification to ensure records are not altered after signing |
| Audit trail | Record signer identity, timestamp, IP address, device information, authentication method |
| Long-term format | Use PDF/A or similar archival format; avoid proprietary formats |
| Redundant storage | Maintain copies in multiple locations; disaster recovery |
| Accessibility | Ensure records can be produced for regulatory examination, litigation, or consumer request |

---

## 14. Building Compliance into Automated Systems

### 14.1 Compliance-as-Code Philosophy

Compliance requirements should not be an afterthought or a manual overlay on automated systems. Instead, compliance should be **encoded directly into the system architecture** — "compliance-as-code."

**Principles:**

1. **Codify regulations**: Transform regulatory text into executable rules
2. **Automate enforcement**: The system should make it impossible (not just difficult) to violate compliance rules
3. **Version control**: Regulatory rules should be versioned, with effective dates and audit history
4. **Testable**: Compliance rules should be unit-tested and integration-tested like any code
5. **Transparent**: The system should explain which compliance rules were applied to any given decision
6. **Auditable**: Every compliance-relevant action should be logged immutably

### 14.2 Regulatory Rule Engine Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                 Regulatory Rule Engine Architecture                │
│                                                                  │
│  ┌──────────────────────────────────────────────────────┐       │
│  │              Regulatory Rule Repository               │       │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────────┐   │       │
│  │  │ FCRA Rules │ │ State UW   │ │ AML Rules      │   │       │
│  │  │ (Federal)  │ │ Rules (x56)│ │ (Federal)      │   │       │
│  │  └────────────┘ └────────────┘ └────────────────┘   │       │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────────┐   │       │
│  │  │ HIPAA Rules│ │ Privacy    │ │ Genetic Info   │   │       │
│  │  │ (Federal)  │ │ Rules (x56)│ │ Rules (x56)    │   │       │
│  │  └────────────┘ └────────────┘ └────────────────┘   │       │
│  │  ┌────────────┐ ┌────────────┐ ┌────────────────┐   │       │
│  │  │ E-Sign     │ │ Replacement│ │ AI/Fairness    │   │       │
│  │  │ Rules      │ │ Rules (x56)│ │ Rules          │   │       │
│  │  └────────────┘ └────────────┘ └────────────────┘   │       │
│  └──────────────────────────────────────────────────────┘       │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────┐       │
│  │              Rule Execution Engine                    │       │
│  │                                                      │       │
│  │  Input: Application data, state, product, UW data    │       │
│  │                                                      │       │
│  │  Processing:                                         │       │
│  │  1. Identify applicable jurisdiction(s)              │       │
│  │  2. Load jurisdiction-specific rule sets              │       │
│  │  3. Evaluate rules against case data                 │       │
│  │  4. Generate compliance determinations               │       │
│  │  5. Produce required notices and documents           │       │
│  │                                                      │       │
│  │  Output: Compliance results, required actions,       │       │
│  │          notices to generate, blocks/warnings        │       │
│  └──────────────────────────────────────────────────────┘       │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────┐       │
│  │              Compliance Action Handler                │       │
│  │                                                      │       │
│  │  ├── BLOCK: Prevent action (e.g., cannot order       │       │
│  │  │   genetic test in CA)                             │       │
│  │  ├── REQUIRE: Must complete action before proceeding │       │
│  │  │   (e.g., must have FCRA consent before CRA pull)  │       │
│  │  ├── GENERATE: Produce document or notice            │       │
│  │  │   (e.g., adverse action notice)                   │       │
│  │  ├── LOG: Record compliance event in audit trail     │       │
│  │  └── ALERT: Notify compliance team                   │       │
│  └──────────────────────────────────────────────────────┘       │
└──────────────────────────────────────────────────────────────────┘
```

### 14.3 Regulatory Rule Data Model

```json
{
  "regulatoryRule": {
    "ruleId": "FCRA-ADV-001",
    "ruleName": "FCRA Adverse Action Notice Required",
    "ruleCategory": "FCRA",
    "jurisdiction": "FEDERAL",
    "stateOverrides": [
      {
        "stateCode": "CA",
        "overrideType": "ADDITIONAL_REQUIREMENT",
        "description": "California requires additional state-specific adverse action language",
        "citation": "Cal. Ins. Code § 791.10"
      },
      {
        "stateCode": "NY",
        "overrideType": "ADDITIONAL_REQUIREMENT",
        "description": "NY requires notice within 10 business days",
        "citation": "N.Y. Ins. Law § 2611"
      }
    ],
    "triggerCondition": {
      "type": "COMPOUND",
      "operator": "AND",
      "conditions": [
        {
          "field": "uwDecision.isAdverseAction",
          "operator": "EQUALS",
          "value": true
        },
        {
          "field": "consumerReports.used",
          "operator": "EQUALS",
          "value": true
        }
      ]
    },
    "requiredActions": [
      {
        "actionType": "GENERATE_NOTICE",
        "templateId": "ADVERSE_ACTION_NOTICE_V3",
        "deliveryMethod": "APPLICANT_PREFERRED",
        "deliveryDeadline": {
          "type": "BUSINESS_DAYS",
          "count": 10,
          "fromEvent": "UW_DECISION_DATE"
        }
      },
      {
        "actionType": "LOG_AUDIT",
        "auditEventType": "ADVERSE_ACTION_GENERATED",
        "retentionYears": 7
      }
    ],
    "citation": "15 U.S.C. § 1681m(a)",
    "effectiveDate": "1970-04-25",
    "lastAmendedDate": "2018-05-21",
    "version": "3.2",
    "lastReviewDate": "2024-01-15"
  }
}
```

### 14.4 Automated Adverse Action Generation

The adverse action notice generation system must handle the full complexity of multi-jurisdiction, multi-CRA notifications:

```
┌──────────────────────────────────────────────────────────────────┐
│            Automated Adverse Action Generation                    │
│                                                                  │
│  INPUT                                                           │
│  ├── UW decision details                                        │
│  │   ├── Decision type (decline, rate-up, exclusion, etc.)      │
│  │   ├── Requested vs. offered terms                            │
│  │   ├── Principal reasons for adverse action                   │
│  │   └── Decision date                                          │
│  ├── Consumer reports used                                      │
│  │   ├── CRA details for each report                            │
│  │   ├── Report dates                                           │
│  │   └── Credit score details (if applicable)                   │
│  ├── Applicant information                                      │
│  │   ├── Name, address                                          │
│  │   ├── State of residence                                     │
│  │   └── E-delivery consent status                              │
│  └── Application details                                        │
│      ├── Product, face amount, term                              │
│      └── Application date                                        │
│                                                                  │
│  PROCESSING                                                      │
│  ├── Determine applicable FCRA requirements                     │
│  ├── Determine state-specific overlay requirements              │
│  │   ├── Additional state notice language                       │
│  │   ├── State-specific delivery deadlines                      │
│  │   ├── State-specific consumer rights language                │
│  │   └── State-specific appeal/reconsideration requirements     │
│  ├── Select appropriate template                                │
│  ├── Populate template with case-specific data                  │
│  ├── Generate credit score disclosure (if applicable)           │
│  ├── Include MIB notice (if MIB was used)                       │
│  ├── Include medical information notice (if applicable)         │
│  └── Quality check (all required elements present)              │
│                                                                  │
│  OUTPUT                                                          │
│  ├── Completed adverse action notice (PDF)                      │
│  ├── Delivery instruction (mail vs. electronic)                 │
│  ├── Delivery tracking record                                   │
│  └── Audit trail entry                                          │
│                                                                  │
│  POST-GENERATION                                                 │
│  ├── Queue for delivery (USPS or e-delivery)                   │
│  ├── Track delivery confirmation                                │
│  ├── Handle returned mail (re-delivery process)                 │
│  └── Respond to consumer inquiries about notice                 │
└──────────────────────────────────────────────────────────────────┘
```

### 14.5 Consent Management System

Consent management is a critical compliance function. The system must track all consents obtained from the applicant and ensure that required consents are in place before proceeding.

**Consent types to track:**

| Consent Type | Required Before | Revocable? | State Variations |
|-------------|----------------|-----------|-----------------|
| General application authorization | Submitting application | Yes | Minor variations |
| FCRA consumer report authorization | Ordering any CRA report | Yes (prospectively) | Some states require specific language |
| MIB pre-notification | Ordering MIB check | N/A (notice, not consent) | Required in all states |
| HIPAA authorization | Requesting medical records from providers | Yes | Must meet HIPAA standards |
| HIV test consent | Ordering HIV test | Yes | State-specific form requirements |
| Genetic testing consent | Ordering genetic test (if ever permitted) | Yes | State-specific |
| E-signature consent | Electronic signature | Yes | E-SIGN/UETA requirements |
| E-delivery consent | Electronic document delivery | Yes | E-SIGN/UETA requirements |
| CCPA/CPRA notice acknowledgment | Data collection (CA applicants) | N/A (notice) | CA only |
| Phone recording consent | Recording calls | N/A (varies) | All-party vs. one-party states |
| Text/SMS consent | Sending texts | Yes | TCPA requirements |
| Privacy notice acknowledgment | Data collection | N/A (notice) | State variations |
| Replacement acknowledgment | Processing replacement | N/A | NAIC Model #613 |

**Consent data model:**

```json
{
  "consentRecord": {
    "applicationId": "APP-2024-001234",
    "applicantId": "APPLICANT-5678",
    "consents": [
      {
        "consentType": "FCRA_CONSUMER_REPORT",
        "consentStatus": "GRANTED",
        "grantedDate": "2024-03-09T14:30:00Z",
        "grantedMethod": "E_SIGNATURE",
        "signatureId": "ESIG-2024-9876",
        "consentText": "I authorize [Company] to obtain consumer reports...",
        "consentVersion": "FCRA-AUTH-v4.1",
        "expirationDate": "2025-03-09",
        "revoked": false,
        "revokedDate": null
      },
      {
        "consentType": "HIPAA_AUTHORIZATION",
        "consentStatus": "GRANTED",
        "grantedDate": "2024-03-09T14:31:00Z",
        "grantedMethod": "E_SIGNATURE",
        "signatureId": "ESIG-2024-9877",
        "consentText": "I authorize any physician, medical practitioner...",
        "consentVersion": "HIPAA-AUTH-v2.3",
        "expirationDate": "2026-03-09",
        "revoked": false,
        "revokedDate": null
      },
      {
        "consentType": "E_DELIVERY",
        "consentStatus": "GRANTED",
        "grantedDate": "2024-03-09T14:29:00Z",
        "grantedMethod": "CHECKBOX_CLICK",
        "verificationMethod": "EMAIL_CONFIRMATION",
        "consentText": "I consent to receive documents electronically...",
        "consentVersion": "EDELIVER-v3.0",
        "expirationDate": null,
        "revoked": false,
        "revokedDate": null
      }
    ]
  }
}
```

### 14.6 Audit Trail Requirements

Every compliance-relevant action in the automated underwriting system must be logged in an immutable audit trail.

**Audit trail data elements:**

| Element | Description | Example |
|---------|-------------|---------|
| Event ID | Unique identifier | AUDIT-2024-00123456 |
| Timestamp | Date/time of event (UTC) | 2024-03-15T10:30:15.123Z |
| Event type | Category of event | UW_DECISION, NOTICE_GENERATED, CONSENT_OBTAINED |
| Actor | Who performed the action | SYSTEM (automated), USER-1234 (underwriter), APPLICANT |
| Application ID | Associated application | APP-2024-001234 |
| Action | Specific action taken | APPROVED_STANDARD_PLUS |
| Details | Additional context | {"requestedClass": "PREFERRED_PLUS", "offeredClass": "STANDARD_PLUS", "reasons": ["BMI > 30", "Rx history"]} |
| Compliance rules applied | Which rules were evaluated | ["FCRA-ADV-001", "STATE-CA-PRIV-003"] |
| Data accessed | What data was viewed/used | ["MIB_REPORT", "RX_HISTORY", "MVR"] |
| IP address | Source IP (for human actors) | 10.0.1.123 |
| Session ID | User session identifier | SESSION-2024-789 |

**Immutability requirements:**

- Audit records must be write-once (append-only)
- No modification or deletion of audit records
- Tamper-evident storage (hash chains, write-once media, or blockchain-like structures)
- Retained for minimum 7 years (longer if state requires)
- Accessible for regulatory examination, litigation hold, and internal audit

### 14.7 Data Retention Automation

```
┌──────────────────────────────────────────────────────────────────┐
│              Automated Data Retention Management                  │
│                                                                  │
│  RETENTION POLICY ENGINE                                         │
│  ├── Define retention periods per data type and jurisdiction     │
│  ├── Apply longest applicable retention period when multiple     │
│  │   jurisdictions or requirements apply                        │
│  ├── Extend retention for litigation holds and regulatory        │
│  │   examinations                                               │
│  └── Allow manual retention extension for specific cases         │
│                                                                  │
│  RETENTION SCHEDULE                                              │
│  ┌──────────────────────┬──────────────┬──────────────────────┐ │
│  │ Data Type            │ Min Retention│ Governing Rule       │ │
│  ├──────────────────────┼──────────────┼──────────────────────┤ │
│  │ Application + UW file│ 7 years      │ State insurance reg  │ │
│  │ Issued policy file   │ Life of      │ State insurance reg  │ │
│  │                      │ policy + 7yr │                      │ │
│  │ Declined app file    │ 5-7 years    │ State insurance reg  │ │
│  │ Consumer report data │ 7 years      │ FCRA + state         │ │
│  │ Adverse action notice│ 7 years      │ FCRA + state         │ │
│  │ HIPAA authorizations │ 6 years      │ 45 CFR § 164.530(j) │ │
│  │ Consent records      │ 7 years      │ E-SIGN + state       │ │
│  │ AML/SAR records      │ 5 years      │ BSA/FinCEN           │ │
│  │ Audit trail          │ 7 years      │ State + company      │ │
│  │ MIB codes reported   │ 7 years      │ MIB rules            │ │
│  │ Model validation docs│ Life of model│ Model governance     │ │
│  │                      │ + 3 years    │                      │ │
│  │ Genetic information  │ Min required │ State genetic laws   │ │
│  │ (if collected)       │ then destroy │                      │ │
│  └──────────────────────┴──────────────┴──────────────────────┘ │
│                                                                  │
│  DISPOSITION AUTOMATION                                          │
│  ├── Identify records reaching end of retention period           │
│  ├── Check for litigation holds, regulatory holds                │
│  ├── Check for related open matters                              │
│  ├── Generate disposition report for compliance review           │
│  ├── Execute secure destruction (cryptographic erasure,          │
│  │   secure overwrite, or physical destruction)                 │
│  └── Log disposition in audit trail (date, method, certifier)   │
└──────────────────────────────────────────────────────────────────┘
```

### 14.8 Compliance Monitoring Dashboard

```
┌──────────────────────────────────────────────────────────────────┐
│              Compliance Monitoring Dashboard                      │
│                                                                  │
│  REAL-TIME METRICS                                               │
│  ├── Adverse action notices pending delivery                    │
│  ├── Average adverse action notice delivery time (days)         │
│  ├── Consumer disputes pending investigation                    │
│  ├── Consent expiration alerts (30/60/90 day windows)           │
│  ├── AML screening alerts pending review                        │
│  ├── OFAC matches requiring manual review                       │
│  └── Regulatory filing deadlines approaching                    │
│                                                                  │
│  PERIODIC METRICS                                                │
│  ├── Approval/decline rates by state (monthly)                  │
│  ├── Approval/decline rates by demographic (quarterly)          │
│  ├── Rate class distribution by demographic (quarterly)         │
│  ├── Model fairness metrics (quarterly)                         │
│  │   ├── Demographic parity ratio                               │
│  │   ├── Equalized odds                                         │
│  │   └── Calibration by group                                   │
│  ├── Consumer complaint volume and trends (monthly)             │
│  ├── Replacement activity volume (monthly)                      │
│  ├── MIB dispute volume and outcomes (monthly)                  │
│  └── Data breach incidents (ongoing)                            │
│                                                                  │
│  REGULATORY EXAMINATION READINESS                                │
│  ├── Audit trail completeness score                             │
│  ├── Document retention compliance rate                         │
│  ├── Training completion rates                                  │
│  ├── Policy and procedure currency                              │
│  └── Prior examination finding remediation status               │
└──────────────────────────────────────────────────────────────────┘
```

---

## 15. Compliance Checklists

### 15.1 New State Market Entry Compliance Checklist

```
□ 1. Verify state licensure (admitted carrier in state)
□ 2. File and obtain approval for policy forms
□ 3. File and obtain approval for rates
□ 4. Review state Unfair Trade Practices Act provisions
□ 5. Review state privacy/information practices act
□ 6. Review state replacement regulation
□ 7. Review state suitability/best interest requirements
□ 8. Review state genetic information restrictions
□ 9. Review state HIV testing restrictions
□ 10. Review state credit use restrictions
□ 11. Review state domestic violence protections
□ 12. Review state transgender/gender identity guidance
□ 13. Review state domestic partnership recognition
□ 14. Review state marijuana/lawful activity protections
□ 15. Review state e-signature/e-delivery rules
□ 16. Review state adverse action notice requirements
□ 17. Review state data breach notification law
□ 18. Review state data security requirements
□ 19. Review state CCPA/state privacy law applicability
□ 20. Configure state-specific rules in underwriting engine
□ 21. Configure state-specific application forms
□ 22. Configure state-specific notices and disclosures
□ 23. Test state-specific rule execution
□ 24. Train agents/producers on state-specific requirements
□ 25. Document state regulatory profile in compliance system
```

### 15.2 Automated Underwriting System Compliance Checklist

```
□ 1.  FCRA compliance
      □ Pre-collection notices provided
      □ Permissible purpose validated before CRA pulls
      □ Adverse action notice generation automated
      □ All CRA details captured for notice generation
      □ Credit score disclosure automated (where applicable)
      □ Consumer dispute workflow implemented

□ 2.  State-specific underwriting rules
      □ Prohibited factors blocked per state
      □ Credit restrictions enforced per state
      □ Genetic information restrictions enforced per state
      □ HIV testing restrictions enforced per state
      □ State-specific notice requirements automated

□ 3.  Privacy compliance
      □ CCPA/CPRA consumer rights workflow (CA applicants)
      □ Privacy notice served at application
      □ Data inventory and mapping documented
      □ Privacy impact assessment completed
      □ Encryption at rest and in transit
      □ Access controls and authentication

□ 4.  AML compliance
      □ Identity verification integrated
      □ OFAC screening at all required points
      □ PEP screening integrated
      □ EDD triggers configured
      □ SAR filing workflow implemented
      □ AML red flag detection rules active

□ 5.  Consent management
      □ All required consents tracked
      □ Consent validation before gated actions
      □ Consent revocation workflow implemented
      □ Consent expiration monitoring active

□ 6.  Audit trail
      □ All UW decisions logged
      □ All data access logged
      □ All notices generated/sent logged
      □ Audit records immutable
      □ Retention policies automated

□ 7.  AI/ML fairness
      □ Disparate impact testing completed
      □ Proxy analysis completed
      □ Model validation documented
      □ Ongoing monitoring scheduled
      □ Model governance framework in place

□ 8.  Data security
      □ NY DFS 500 requirements (if applicable)
      □ NAIC Data Security Model Law requirements
      □ Penetration testing completed
      □ Vulnerability assessments completed
      □ Vendor security assessments completed
      □ Incident response plan in place

□ 9.  E-Signature/E-Delivery
      □ E-SIGN/UETA consent obtained
      □ Hardware/software requirements disclosed
      □ Withdrawal of consent process implemented
      □ Record retention for e-signed documents
      □ Tamper-evident storage implemented

□ 10. Documentation and training
      □ Compliance policies and procedures documented
      □ Staff training completed and recorded
      □ Regulatory change monitoring process in place
      □ Compliance testing/audit schedule established
```

### 15.3 Adverse Action Compliance Checklist

```
□ 1. Determine if adverse action was taken
     □ Decline
     □ Rate class less favorable than best available
     □ Reduced face amount
     □ Table rating or flat extra applied
     □ Exclusion rider applied
     □ Any terms less favorable than requested

□ 2. Identify all consumer reports used in the decision
     □ MIB report
     □ Prescription drug history (Rx)
     □ Motor vehicle report (MVR)
     □ Credit report / credit-based insurance score
     □ Criminal background check
     □ Public records search
     □ Inspection/investigative report

□ 3. Generate adverse action notice
     □ Insurer name and contact information
     □ Application/policy identification
     □ Action taken description
     □ Principal reasons for action
     □ For EACH CRA used:
         □ CRA name, address, phone number
         □ Statement: CRA did not make the decision
         □ Consumer's right to free copy within 60 days
         □ Consumer's right to dispute accuracy
     □ If credit score used:
         □ Score disclosure
         □ Key factors affecting score
         □ Score range information
     □ If MIB used:
         □ MIB contact information
         □ Consumer's rights regarding MIB record
     □ FCRA consumer rights summary
     □ CFPB contact information

□ 4. Apply state-specific overlay requirements
     □ State-specific notice language
     □ State-specific delivery deadline
     □ State-specific consumer rights language
     □ State-specific appeal/reconsideration requirements

□ 5. Deliver notice
     □ Within applicable deadline
     □ Via consented delivery method
     □ Track delivery confirmation

□ 6. Document and retain
     □ Copy of notice in case file
     □ Delivery confirmation in case file
     □ Audit trail entry created
     □ Retained for required period (7+ years)
```

### 15.4 AML Compliance Checklist

```
□ 1. Customer Identification
     □ Government-issued photo ID verified
     □ SSN verified (or Tax ID for entities)
     □ Date of birth verified
     □ Address verified
     □ Identity verification service used

□ 2. OFAC Screening
     □ Applicant screened against SDN list
     □ Owner screened (if different from applicant)
     □ Beneficiaries screened
     □ Payor screened (if different)
     □ Fuzzy matching applied
     □ Potential matches escalated to compliance

□ 3. PEP Screening
     □ Applicant screened for PEP status
     □ Close associates and family screened
     □ PEP matches escalated to compliance

□ 4. Risk Assessment
     □ Face amount vs. income evaluated
     □ Source of funds for premium verified
     □ Red flags checklist reviewed
     □ Risk level assigned (low/medium/high)

□ 5. Enhanced Due Diligence (if required)
     □ Source of funds documentation obtained
     □ Source of wealth documentation obtained
     □ Senior management approval obtained
     □ Enhanced verification completed
     □ EDD documentation in case file

□ 6. Ongoing Monitoring
     □ Transaction monitoring active
     □ Periodic re-screening scheduled
     □ Suspicious activity escalation process in place
```

---

## 16. Glossary

| Term | Definition |
|------|-----------|
| **ADA** | Americans with Disabilities Act — federal law prohibiting discrimination based on disability; includes insurance safe harbor at § 12201(c) |
| **Adverse Action** | Under FCRA, a denial, increase in charge, or unfavorable change in terms of insurance based on consumer report information |
| **AML** | Anti-Money Laundering — regulatory framework requiring financial institutions (including insurers) to detect and report money laundering |
| **ASOP** | Actuarial Standard of Practice — professional standards governing actuarial work, including risk classification (ASOP No. 12) |
| **BAA** | Business Associate Agreement — HIPAA-required contract between covered entity and business associate |
| **BISG** | Bayesian Improved Surname Geocoding — statistical method for imputing race/ethnicity from surname and geography |
| **BSA** | Bank Secrecy Act — federal law requiring financial institutions to maintain AML programs |
| **CCPA** | California Consumer Privacy Act — comprehensive consumer privacy law applicable to insurers operating in California |
| **CDD** | Customer Due Diligence — AML requirement to verify customer identity and understand the nature of the business relationship |
| **CFPB** | Consumer Financial Protection Bureau — federal agency with enforcement authority for FCRA |
| **Contestability Period** | Period (typically 2 years) during which insurer can investigate and potentially rescind a policy for material misrepresentation |
| **CPRA** | California Privacy Rights Act — amendment to CCPA adding additional consumer rights |
| **CRA** | Consumer Reporting Agency — entity that assembles and provides consumer reports (MIB, credit bureaus, LexisNexis, etc.) |
| **Demographic Parity** | Fairness metric requiring equal favorable outcome rates across demographic groups |
| **Disparate Impact** | When a facially neutral practice disproportionately affects a protected group |
| **DOI** | Department of Insurance — state regulatory agency |
| **E-SIGN Act** | Electronic Signatures in Global and National Commerce Act — federal law providing legal foundation for e-signatures |
| **EDD** | Enhanced Due Diligence — heightened AML scrutiny for higher-risk customers |
| **Equalized Odds** | Fairness metric requiring equal true positive and false positive rates across groups |
| **FCRA** | Fair Credit Reporting Act — federal law governing consumer reports and adverse action notices |
| **FinCEN** | Financial Crimes Enforcement Network — Treasury Department bureau administering BSA/AML |
| **FIO** | Federal Insurance Office — Treasury Department office monitoring insurance industry |
| **GINA** | Genetic Information Nondiscrimination Act — federal law prohibiting genetic discrimination in health insurance and employment (does NOT apply to life insurance) |
| **HIPAA** | Health Insurance Portability and Accountability Act — federal law governing health information privacy and security |
| **Material Misrepresentation** | A false statement in an insurance application that would have influenced the underwriting decision |
| **McCarran-Ferguson Act** | Federal law establishing that insurance regulation is primarily a state function |
| **MIB** | MIB, Inc. (formerly Medical Information Bureau) — not-for-profit information exchange for life insurance |
| **Model Bulletin** | NAIC guidance document (not law) providing recommendations to state regulators |
| **NAIC** | National Association of Insurance Commissioners — standard-setting organization of state insurance regulators |
| **OFAC** | Office of Foreign Assets Control — Treasury Department office administering sanctions |
| **PEP** | Politically Exposed Person — individual holding prominent public position (elevated AML risk) |
| **PHI** | Protected Health Information — individually identifiable health information subject to HIPAA |
| **PIA** | Privacy Impact Assessment — analysis of how personal information is collected, used, shared, and protected |
| **Proxy Discrimination** | Using facially neutral variables that correlate with protected classes as a substitute for direct discrimination |
| **Rescission** | Voiding a policy retroactively based on material misrepresentation |
| **SAR** | Suspicious Activity Report — report filed with FinCEN when suspicious transactions are identified |
| **SDN** | Specially Designated Nationals — OFAC list of sanctioned individuals and entities |
| **STOLI** | Stranger-Originated Life Insurance — life insurance procured by a third party with no insurable interest |
| **UETA** | Uniform Electronic Transactions Act — model state law providing framework for electronic transactions |
| **Unfair Discrimination** | Using protected characteristics or inadequately justified factors to differentiate between similarly-situated insurance applicants |

---

## References

### Federal Statutes
- Fair Credit Reporting Act (FCRA): 15 U.S.C. § 1681 et seq.
- Health Insurance Portability and Accountability Act (HIPAA): Pub. L. 104-191; 45 CFR Parts 160, 164
- Genetic Information Nondiscrimination Act (GINA): Pub. L. 110-233
- McCarran-Ferguson Act: 15 U.S.C. §§ 1011-1015
- Americans with Disabilities Act (ADA): 42 U.S.C. § 12101 et seq.
- Bank Secrecy Act (BSA): 31 U.S.C. §§ 5311-5332
- USA PATRIOT Act: Pub. L. 107-56
- E-SIGN Act: 15 U.S.C. §§ 7001-7031

### NAIC Model Laws and Regulations
- Unfair Trade Practices Act (Model #880)
- Insurance Information and Privacy Protection Model Act (Model #670)
- Life Insurance and Annuities Replacement Model Regulation (Model #613)
- Suitability in Life Insurance Model Regulation (Model #582)
- Insurance Data Security Model Law (Model #668)
- Model Act Regarding Insurance Discrimination Against Victims of Domestic Violence (Model #897)
- NAIC Model Bulletin on the Use of Artificial Intelligence Systems by Insurers (2023)

### Federal Regulations
- FinCEN Anti-Money Laundering Program Requirements: 31 CFR § 1025
- HIPAA Privacy Rule: 45 CFR Part 164
- HIPAA Security Rule: 45 CFR Part 164, Subpart C
- FCRA Implementing Regulations: 12 CFR Part 1022 (Regulation V)

### State Regulations (Selected)
- New York DFS Cybersecurity Regulation: 23 NYCRR 500
- Colorado SB 21-169 and implementing regulations: 3 CCR 702-12
- California Insurance Code §§ 10140-10149.1 (genetic information)
- California Consumer Privacy Act (CCPA/CPRA): Cal. Civ. Code § 1798.100 et seq.

### Professional Standards
- Actuarial Standard of Practice No. 12: Risk Classification
- Actuarial Standard of Practice No. 25: Credibility Procedures
- NIST AI Risk Management Framework (AI RMF 1.0)

---

*This document is part of the Term Life Insurance Underwriting domain knowledge series. It provides regulatory and compliance reference material for solution architects building automated underwriting platforms. While comprehensive, it is not legal advice — always consult qualified legal counsel for specific compliance questions.*
