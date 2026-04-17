# Security Architecture in TOGAF

## Table of Contents

- [Introduction](#introduction)
- [Security as a Cross-Cutting Concern](#security-as-a-cross-cutting-concern)
- [Security Across the Four Architecture Domains](#security-across-the-four-architecture-domains)
- [Security Considerations in Each ADM Phase](#security-considerations-in-each-adm-phase)
- [Threat Modeling in Enterprise Architecture](#threat-modeling-in-enterprise-architecture)
- [Security Services Taxonomy](#security-services-taxonomy)
- [Security Patterns and Building Blocks](#security-patterns-and-building-blocks)
- [Risk-Based Approach to Security Architecture](#risk-based-approach-to-security-architecture)
- [Integration with Security Frameworks](#integration-with-security-frameworks)
- [TOGAF TRM and Security Services](#togaf-trm-and-security-services)
- [Security Governance](#security-governance)
- [Privacy by Design](#privacy-by-design)
- [Compliance and Regulatory Requirements](#compliance-and-regulatory-requirements)
- [Security Architecture Artifacts](#security-architecture-artifacts)
- [Real-World Security Architecture Scenarios](#real-world-security-architecture-scenarios)
- [Review Questions](#review-questions)

---

## Introduction

Security architecture is one of the most critical aspects of enterprise architecture. In the TOGAF framework, security is not treated as an isolated domain but as a **cross-cutting concern** that permeates every layer of the enterprise architecture. A well-designed security architecture ensures that an organization's information assets, business processes, and technology infrastructure are protected against threats while enabling the business to operate effectively.

TOGAF 10 emphasizes that security must be considered from the earliest stages of architecture development and woven throughout every phase of the Architecture Development Method (ADM). The security architect works alongside domain architects (Business, Data, Application, Technology) to ensure that security requirements are identified, addressed, and validated at every level.

```
┌─────────────────────────────────────────────────────────────┐
│                    ENTERPRISE ARCHITECTURE                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────────┐  │
│  │Business │  │  Data   │  │  App    │  │ Technology   │  │
│  │ Arch    │  │  Arch   │  │  Arch   │  │    Arch      │  │
│  └────┬────┘  └────┬────┘  └────┬────┘  └──────┬───────┘  │
│       │            │            │               │           │
│  ┌────┴────────────┴────────────┴───────────────┴────────┐  │
│  │          SECURITY ARCHITECTURE (Cross-Cutting)        │  │
│  │  Authentication | Authorization | Audit | Integrity   │  │
│  │  Confidentiality | Availability | Non-repudiation     │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Security as a Cross-Cutting Concern

In TOGAF, a **cross-cutting concern** is an aspect of the architecture that affects multiple domains and cannot be cleanly decomposed into a single domain. Security is the quintessential cross-cutting concern because:

1. **Business Architecture** must define security policies, roles, and responsibilities
2. **Data Architecture** must classify data sensitivity and define data protection requirements
3. **Application Architecture** must implement security controls within and between applications
4. **Technology Architecture** must provide the infrastructure-level security mechanisms

### Why Security Cannot Be an Afterthought

Organizations that treat security as an afterthought face several critical problems:

| Problem | Impact |
|---------|--------|
| Bolt-on security | Higher cost, weaker protection, architectural debt |
| Missing requirements | Security gaps discovered late in development |
| Compliance failures | Regulatory penalties, legal exposure |
| Inconsistent controls | Uneven protection creates exploitable weak points |
| Poor user experience | Poorly integrated security frustrates users |

### The Security Architect's Role

The security architect in a TOGAF context acts as a **specialist advisor** who:

- Participates in all ADM phases to provide security guidance
- Maintains the organization's security architecture patterns and building blocks
- Ensures alignment between business risk appetite and security controls
- Bridges the gap between security frameworks (SABSA, NIST, ISO 27001) and the enterprise architecture
- Reviews architecture deliverables for security completeness

---

## Security Across the Four Architecture Domains

### Business Architecture Security

Security in the Business Architecture domain addresses:

- **Business roles and responsibilities** for security (RACI matrices)
- **Security policies** derived from business strategy and risk appetite
- **Business process security** — identifying where sensitive data is created, processed, stored, or transmitted
- **Organizational security structure** — Chief Information Security Officer (CISO) positioning, security teams
- **Security awareness and training** requirements
- **Business continuity and disaster recovery** planning

**Key artifacts:**
- Business roles catalog with security responsibilities
- Security policy catalog
- Business process security assessment

### Data Architecture Security

Security in the Data Architecture domain addresses:

- **Data classification** — categorizing data by sensitivity (Public, Internal, Confidential, Restricted)
- **Data ownership and stewardship** — who is responsible for protecting specific data assets
- **Data lifecycle security** — protection from creation through archival and destruction
- **Data privacy** — personally identifiable information (PII), protected health information (PHI)
- **Data residency and sovereignty** — where data can be stored and processed
- **Encryption** requirements for data at rest and data in transit

**Key artifacts:**
- Data classification schema
- Data security matrix (data entity vs. security control)
- Data flow diagrams with trust boundaries

### Application Architecture Security

Security in the Application Architecture domain addresses:

- **Application authentication and authorization** mechanisms
- **Secure coding practices** and standards
- **Application-level encryption** and key management
- **Session management** and token handling
- **Input validation** and output encoding
- **API security** — authentication, rate limiting, input validation
- **Inter-application trust** — how applications authenticate to each other
- **Security testing** requirements (SAST, DAST, penetration testing)

**Key artifacts:**
- Application security requirements catalog
- Application communication matrix with security protocols
- Application/security control matrix

### Technology Architecture Security

Security in the Technology Architecture domain addresses:

- **Network security** — firewalls, IDS/IPS, network segmentation, DMZ design
- **Infrastructure hardening** — OS, database, middleware security configurations
- **Identity and Access Management (IAM)** infrastructure
- **PKI (Public Key Infrastructure)** and certificate management
- **Security monitoring** — SIEM, log management, threat detection
- **Endpoint security** — anti-malware, device management
- **Physical security** — data center access controls, environmental protections
- **Cloud security** — shared responsibility model, cloud security posture management

**Key artifacts:**
- Network security diagram
- Technology security standards catalog
- Infrastructure security configuration baseline

---

## Security Considerations in Each ADM Phase

```
┌───────────────────────────────────────────────────────┐
│                    ADM Phases                          │
│                                                       │
│     Preliminary ──► Security principles defined       │
│          │                                            │
│     Phase A ──────► Security vision & requirements    │
│          │                                            │
│     Phase B ──────► Business security policies        │
│          │                                            │
│     Phase C ──────► App & data security controls      │
│          │                                            │
│     Phase D ──────► Infrastructure security design    │
│          │                                            │
│     Phase E ──────► Security implementation planning  │
│          │                                            │
│     Phase F ──────► Security migration planning       │
│          │                                            │
│     Phase G ──────► Security implementation govern.   │
│          │                                            │
│     Phase H ──────► Security monitoring & review      │
│          │                                            │
│  Requirements ────► Continuous security requirements  │
│  Management         management                        │
└───────────────────────────────────────────────────────┘
```

### Preliminary Phase

- Establish **security principles** as part of the architecture principles
- Define the **security architecture governance** structure
- Identify **security-related stakeholders** (CISO, DPO, compliance officers)
- Assess existing **security frameworks and standards** in use
- Define the **scope of security architecture** within the EA capability

### Phase A: Architecture Vision

- Include security in the **Architecture Vision** document
- Identify **high-level security requirements** from business drivers
- Perform initial **security risk assessment**
- Identify **security-related concerns** of key stakeholders
- Include security in **value propositions** and business case
- Define **security constraints** (regulatory, contractual, organizational)

### Phase B: Business Architecture

- Map **business roles** to security responsibilities
- Identify **sensitive business processes** and their protection needs
- Define **security policies** aligned with business objectives
- Analyze **business risk tolerance** for different process areas
- Document **compliance requirements** that drive security

### Phase C: Information Systems Architecture (Data & Application)

- Perform **data classification** and define protection requirements
- Design **application security architecture** (authentication, authorization, encryption)
- Define **data flow security** — encryption in transit, trust boundaries
- Specify **API security** standards and patterns
- Design **identity and access management** at the application level
- Define **audit logging** requirements

### Phase D: Technology Architecture

- Design the **network security architecture** (segmentation, firewalls, DMZ)
- Select **security technology platforms** (SIEM, IAM, PKI, DLP)
- Define **infrastructure hardening** standards
- Design **security monitoring and incident detection** capabilities
- Plan **disaster recovery and business continuity** technology

### Phase E: Opportunities and Solutions

- Evaluate **security solution options** (build vs. buy vs. cloud service)
- Assess **security vendor products** against requirements
- Define **security work packages** and project boundaries
- Identify **security dependencies** between projects

### Phase F: Migration Planning

- Prioritize security implementations based on **risk**
- Ensure **security controls are not weakened** during transition states
- Plan **security testing** for each migration increment
- Define **security acceptance criteria** for each transition architecture

### Phase G: Implementation Governance

- Review implementations for **security compliance**
- Conduct **security architecture reviews** of solution designs
- Verify **security testing results** (penetration tests, vulnerability scans)
- Ensure **security configurations** match architecture specifications

### Phase H: Architecture Change Management

- Monitor **threat landscape changes** that affect the architecture
- Review **security incidents** for architecture implications
- Assess new **compliance requirements** and their impact
- Trigger new ADM cycles when security gaps are identified

### Requirements Management

- Maintain a **security requirements repository**
- Track security requirements through all phases
- Manage **changes to security requirements** with impact analysis
- Ensure **traceability** from business risk to security control

---

## Threat Modeling in Enterprise Architecture

Threat modeling is the process of identifying, analyzing, and mitigating potential security threats to an enterprise. In a TOGAF context, threat modeling should be integrated into the ADM.

### STRIDE Threat Model

| Threat | Description | Security Property |
|--------|-------------|-------------------|
| **S**poofing | Impersonating a user or system | Authentication |
| **T**ampering | Unauthorized modification of data | Integrity |
| **R**epudiation | Denying an action occurred | Non-repudiation |
| **I**nformation Disclosure | Exposing data to unauthorized parties | Confidentiality |
| **D**enial of Service | Making a system unavailable | Availability |
| **E**levation of Privilege | Gaining unauthorized access | Authorization |

### Threat Modeling in the ADM

```
Phase B (Business)           Phase C (Data/App)          Phase D (Technology)
┌──────────────────┐    ┌──────────────────────┐    ┌──────────────────────┐
│ Identify business│    │ Model data flows and │    │ Identify infra       │
│ process threats  │───►│ app interaction      │───►│ attack surfaces      │
│                  │    │ threats              │    │                      │
│ • Fraud          │    │ • SQL injection      │    │ • Network intrusion  │
│ • Social eng.    │    │ • XSS               │    │ • Malware            │
│ • Insider threat │    │ • API abuse          │    │ • Physical access    │
└──────────────────┘    └──────────────────────┘    └──────────────────────┘
```

### Applying Threat Modeling

1. **Decompose the architecture** — identify entry points, assets, trust boundaries
2. **Identify threats** — use STRIDE or other frameworks against each component
3. **Assess risk** — likelihood x impact for each threat
4. **Define mitigations** — security controls to reduce risk
5. **Validate** — verify mitigations are effective through testing

---

## Security Services Taxonomy

TOGAF defines a taxonomy of security services that must be addressed in any enterprise architecture. These seven core services form the foundation of security architecture.

### 1. Authentication

**Definition:** Verifying the identity of a user, system, or entity.

| Method | Strength | Use Case |
|--------|----------|----------|
| Password | Low | Basic access |
| Multi-Factor (MFA) | Medium-High | Sensitive applications |
| Certificate-based | High | System-to-system |
| Biometric | High | Physical access, high-security apps |
| Token-based (OAuth/OIDC) | Medium-High | Web/API access |
| SSO (Single Sign-On) | Varies | Enterprise-wide identity |

### 2. Authorization

**Definition:** Determining what an authenticated entity is permitted to do.

- **RBAC (Role-Based Access Control)** — permissions assigned to roles, users assigned to roles
- **ABAC (Attribute-Based Access Control)** — permissions based on attributes (user, resource, environment)
- **PBAC (Policy-Based Access Control)** — centralized policy engine makes access decisions
- **MAC (Mandatory Access Control)** — system-enforced, label-based (used in government/military)

### 3. Audit

**Definition:** Recording and monitoring security-relevant events.

- **Audit logging** — recording who did what, when, and from where
- **Log management** — centralized collection, storage, and retention of logs
- **Security monitoring** — real-time analysis of security events (SIEM)
- **Forensic capability** — ability to investigate security incidents after the fact
- **Compliance reporting** — generating evidence for regulatory requirements

### 4. Confidentiality

**Definition:** Ensuring information is only accessible to authorized entities.

- **Encryption at rest** — AES-256, database-level encryption, disk encryption
- **Encryption in transit** — TLS 1.3, IPSec VPN, HTTPS
- **Data masking** — hiding sensitive data in non-production environments
- **Data Loss Prevention (DLP)** — preventing unauthorized data exfiltration
- **Classification-based controls** — applying protection based on data classification

### 5. Integrity

**Definition:** Ensuring data and systems have not been tampered with.

- **Hash functions** — SHA-256, SHA-3 for data integrity verification
- **Digital signatures** — ensuring authenticity and integrity of messages
- **Checksums** — verifying file and data transfer integrity
- **Change detection** — file integrity monitoring (FIM)
- **Version control** — maintaining authoritative versions of configurations and code

### 6. Availability

**Definition:** Ensuring systems and data are accessible when needed.

- **Redundancy** — eliminating single points of failure
- **Load balancing** — distributing workload across multiple systems
- **Disaster recovery** — capability to restore operations after a catastrophic event
- **Business continuity** — maintaining critical business functions during disruption
- **DDoS protection** — defending against distributed denial-of-service attacks
- **Backup and restore** — regular backup with tested recovery procedures

### 7. Non-repudiation

**Definition:** Ensuring an entity cannot deny having performed an action.

- **Digital signatures** — cryptographic proof of origin
- **Timestamps** — authoritative time-stamping of transactions
- **Audit trails** — immutable records of actions
- **Transaction logging** — recording complete transaction details
- **Receipt mechanisms** — acknowledgment of message delivery

---

## Security Patterns and Building Blocks

### Security Architecture Building Blocks (ABBs and SBBs)

In TOGAF, security capabilities are expressed as building blocks:

| Architecture Building Block (ABB) | Solution Building Block (SBB) Example |
|-----------------------------------|--------------------------------------|
| Identity Management Service | Microsoft Entra ID, Okta, Ping Identity |
| Access Control Service | Policy Decision Point (OPA, XACML engine) |
| Encryption Service | AWS KMS, HashiCorp Vault, HSM |
| Audit and Logging Service | Splunk, ELK Stack, Azure Sentinel |
| Network Security Service | Palo Alto NGFW, AWS Security Groups |
| Certificate Management Service | Let's Encrypt, Venafi, AWS Certificate Manager |
| Threat Detection Service | CrowdStrike, Microsoft Defender, Darktrace |

### Common Security Patterns

**1. Defense in Depth**
```
┌─────────────────────────────────────────┐
│ Physical Security                       │
│  ┌───────────────────────────────────┐  │
│  │ Network Security (Firewalls, IDS) │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │ Host Security (Hardening)   │  │  │
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │ Application Security  │  │  │  │
│  │  │  │  ┌─────────────────┐  │  │  │  │
│  │  │  │  │ Data Security   │  │  │  │  │
│  │  │  │  └─────────────────┘  │  │  │  │
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**2. Zero Trust Architecture**
- Never trust, always verify
- Least privilege access
- Micro-segmentation
- Continuous verification
- Assume breach mentality

**3. Secure Service Gateway (API Gateway Pattern)**
- Centralized authentication and authorization for APIs
- Rate limiting and throttling
- Input validation and threat protection
- Logging and monitoring

**4. Identity Federation**
- Trust relationships between identity providers
- Federated SSO across organizational boundaries
- Standards: SAML 2.0, OpenID Connect, OAuth 2.0

**5. Demilitarized Zone (DMZ)**
- Network segmentation between trusted and untrusted zones
- Multi-tier architecture with security controls at each boundary

---

## Risk-Based Approach to Security Architecture

TOGAF advocates a **risk-based approach** to security, where security investment is proportional to the risk being mitigated. This avoids both under-protection and over-engineering.

### Risk Assessment Process

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Identify   │───►│    Assess    │───►│   Mitigate   │───►│   Monitor    │
│    Assets    │    │    Risks     │    │    Risks     │    │    Risks     │
│              │    │              │    │              │    │              │
│ • Data       │    │ • Likelihood │    │ • Accept     │    │ • KRIs       │
│ • Systems    │    │ • Impact     │    │ • Mitigate   │    │ • Incidents  │
│ • Processes  │    │ • Priority   │    │ • Transfer   │    │ • Reviews    │
│ • People     │    │              │    │ • Avoid      │    │              │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
```

### Risk Matrix

| | Low Impact | Medium Impact | High Impact | Critical Impact |
|---|-----------|---------------|-------------|-----------------|
| **Very Likely** | Medium | High | Critical | Critical |
| **Likely** | Low | Medium | High | Critical |
| **Possible** | Low | Medium | Medium | High |
| **Unlikely** | Low | Low | Medium | Medium |

### Risk Treatment Strategies

| Strategy | Description | Example |
|----------|-------------|---------|
| **Accept** | Acknowledge risk without further action | Low-impact, low-likelihood risks within appetite |
| **Mitigate** | Implement controls to reduce likelihood or impact | Deploying encryption, access controls, monitoring |
| **Transfer** | Shift risk to a third party | Cyber insurance, outsourcing to managed security provider |
| **Avoid** | Eliminate the activity that creates the risk | Not collecting certain sensitive data |

---

## Integration with Security Frameworks

### SABSA (Sherwood Applied Business Security Architecture)

SABSA is a layered security architecture framework that maps well to TOGAF's four architecture domains.

| SABSA Layer | Focus | TOGAF Equivalent |
|-------------|-------|------------------|
| Contextual (Business View) | Why? Business requirements | Architecture Vision / Business Architecture |
| Conceptual (Architect's View) | What? Security concepts | Business Architecture / Data Architecture |
| Logical (Designer's View) | How? Security services | Application Architecture |
| Physical (Builder's View) | With what? Security mechanisms | Technology Architecture |
| Component (Tradesman's View) | Products and tools | Solution Building Blocks |
| Operational (Facilities Manager) | Operations and management | Implementation Governance |

**Integration approach:**
- Use SABSA's business-driven risk analysis to feed TOGAF's security requirements
- Map SABSA security services to TOGAF building blocks
- Use SABSA's attribute profiling to define security requirements in each ADM phase
- Leverage SABSA's operational security management for Phase H activities

### NIST Cybersecurity Framework (CSF)

The NIST CSF provides five core functions that can be mapped into TOGAF:

| NIST CSF Function | Description | ADM Phase Integration |
|-------------------|-------------|----------------------|
| **Identify** | Asset management, risk assessment, governance | Preliminary, Phase A, Phase B |
| **Protect** | Access control, data security, training | Phase C, Phase D |
| **Detect** | Anomaly detection, continuous monitoring | Phase D, Phase G |
| **Respond** | Response planning, communications, mitigation | Phase G, Phase H |
| **Recover** | Recovery planning, improvements | Phase H |

**Integration approach:**
- Map NIST CSF categories and subcategories to TOGAF architecture requirements
- Use NIST CSF profiles as input to the Architecture Vision
- Align NIST CSF implementation tiers with architecture maturity levels
- Incorporate NIST CSF outcomes as architecture requirements

### ISO 27001/27002

ISO 27001 provides a management system for information security, and ISO 27002 provides specific security controls.

**Integration approach:**
- Use ISO 27001 risk assessment methodology within ADM Phase A
- Map ISO 27002 controls to TOGAF security building blocks
- Use ISO 27001's Statement of Applicability as input to security requirements
- Align TOGAF architecture governance with ISO 27001 ISMS governance
- Use ISO 27002 control domains to structure the security architecture:
  - Organizational controls (policies, roles, responsibilities)
  - People controls (screening, awareness, training)
  - Physical controls (physical security perimeters, equipment)
  - Technological controls (access control, cryptography, network security)

---

## TOGAF TRM and Security Services

The TOGAF Technical Reference Model (TRM) includes security services as a key component of the infrastructure services layer.

```
┌────────────────────────────────────────────────────────────┐
│                    Business Applications                    │
├────────────────────────────────────────────────────────────┤
│              Application Platform Services                  │
│  ┌─────────────┐ ┌──────────────┐ ┌────────────────────┐  │
│  │ Data Mgmt   │ │ Transaction  │ │ User Interface     │  │
│  │ Services    │ │ Processing   │ │ Services           │  │
│  └─────────────┘ └──────────────┘ └────────────────────┘  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SECURITY SERVICES                      │   │
│  │  • Identification & Authentication                  │   │
│  │  • System Entry Control (Authorization)             │   │
│  │  • Audit                                            │   │
│  │  • Access Control                                   │   │
│  │  • Non-repudiation                                  │   │
│  │  • Security Management                              │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────┐ ┌──────────────┐ ┌────────────────────┐  │
│  │ Network     │ │ Operating    │ │ Software Eng.      │  │
│  │ Services    │ │ System Svcs  │ │ Services           │  │
│  └─────────────┘ └──────────────┘ └────────────────────┘  │
├────────────────────────────────────────────────────────────┤
│              Communications Infrastructure                  │
└────────────────────────────────────────────────────────────┘
```

The TRM security services include:

1. **Identification and Authentication** — verifying the identity of users and systems
2. **System Entry Control** — controlling access to the system based on authenticated identity
3. **Audit** — recording security-relevant events for later analysis
4. **Access Control** — controlling access to specific resources and operations
5. **Non-repudiation** — ensuring actions cannot be denied
6. **Security Management** — administering security policies, keys, and configurations

These TRM security services should be mapped to specific Solution Building Blocks during Phase D and Phase E of the ADM.

---

## Security Governance

Security governance within TOGAF is an extension of architecture governance and ensures that security decisions are made, implemented, and monitored effectively.

### Security Governance Structure

```
┌─────────────────────────────────────────────┐
│           Board / Executive Committee        │
│         (Security risk oversight)            │
├─────────────────────────────────────────────┤
│        Architecture Review Board (ARB)       │
│   (Security architecture decisions/reviews)  │
├──────────────────┬──────────────────────────┤
│ Security         │ Architecture             │
│ Steering         │ Governance Board         │
│ Committee        │                          │
├──────────────────┴──────────────────────────┤
│        Security Architecture Team            │
│  (Day-to-day security architecture work)     │
├─────────────────────────────────────────────┤
│        Project Security Reviews              │
│   (Implementation-level security checks)     │
└─────────────────────────────────────────────┘
```

### Key Security Governance Activities

| Activity | Description | Frequency |
|----------|-------------|-----------|
| Security architecture review | Reviewing solution designs for security compliance | Per project/release |
| Security risk assessment | Evaluating residual risk of architecture decisions | Per ADM cycle |
| Security standards update | Updating security standards and patterns | Quarterly/annually |
| Security compliance audit | Verifying adherence to security architecture | Annually |
| Security exception management | Approving deviations from security standards | As needed |
| Threat landscape review | Updating threat model based on new threats | Quarterly |

### Architecture Compliance and Security

TOGAF's compliance review process should include security-specific checkpoints:

- Does the solution comply with the security architecture?
- Have all security requirements been addressed?
- Are security controls appropriate for the data classification?
- Has threat modeling been performed?
- Have security tests been planned and executed?
- Are security monitoring and incident response capabilities in place?

---

## Privacy by Design

Privacy by Design (PbD) is an approach where privacy is embedded into the design of systems and business processes from the outset. This is especially important given regulations like GDPR, CCPA, and other privacy laws.

### Seven Principles of Privacy by Design

| Principle | Application in TOGAF |
|-----------|---------------------|
| 1. Proactive not reactive | Address privacy in ADM Phase A and B, not as an afterthought |
| 2. Privacy as the default | Default configurations should maximize privacy protection |
| 3. Privacy embedded into design | Privacy requirements in Phase C and D architecture designs |
| 4. Full functionality (positive-sum) | Privacy should not compromise functionality |
| 5. End-to-end security | Security across the full data lifecycle |
| 6. Visibility and transparency | Architecture documentation includes privacy controls |
| 7. Respect for user privacy | User-centric design principles |

### Privacy Architecture Considerations

- **Data minimization** — collect only necessary personal data
- **Purpose limitation** — use personal data only for stated purposes
- **Consent management** — architecture for collecting and managing user consent
- **Data subject rights** — capabilities for access, rectification, erasure, portability
- **Privacy impact assessment** — evaluate privacy risks for new architecture components
- **Data protection by default** — strongest privacy settings as default
- **Cross-border data transfer** — architectural controls for data sovereignty

---

## Compliance and Regulatory Requirements

Security architecture must address various compliance and regulatory requirements. These requirements should be captured as architecture constraints and requirements early in the ADM.

### Common Regulatory Frameworks

| Regulation | Domain | Key Security Requirements |
|------------|--------|--------------------------|
| GDPR | Data privacy (EU) | Data protection, consent, breach notification, DPO |
| HIPAA | Healthcare (US) | PHI protection, access controls, audit trails |
| PCI DSS | Payment card data | Network segmentation, encryption, access control, monitoring |
| SOX | Financial reporting | Internal controls, audit trails, change management |
| SOC 2 | Service organizations | Security, availability, processing integrity, confidentiality, privacy |
| NIST 800-53 | US Federal systems | Comprehensive security control catalog |
| DORA | Financial services (EU) | ICT risk management, incident reporting, resilience testing |

### Mapping Compliance to Architecture

```
Regulatory Requirement ──► Architecture Constraint ──► Building Block
                                                        Requirement

Example:
GDPR Art. 32         ──► "Encrypt PII at rest   ──► AES-256 database
(Security of              and in transit"            encryption +
 processing)                                         TLS 1.3
```

---

## Security Architecture Artifacts

TOGAF defines various artifacts for documenting architecture. Security-specific artifacts include:

### Catalogs

| Catalog | Description |
|---------|-------------|
| Security Policy Catalog | Inventory of all security policies and their scope |
| Security Control Catalog | List of security controls mapped to requirements |
| Security Risk Catalog | Documented security risks with assessment and treatment |
| Security Standards Catalog | Approved security standards and technologies |
| Compliance Requirements Catalog | Regulatory and contractual security requirements |

### Matrices

| Matrix | Description |
|--------|-------------|
| Threat/Control Matrix | Maps threats to the controls that mitigate them |
| Data Classification/Control Matrix | Maps data classifications to required security controls |
| Application/Security Service Matrix | Maps applications to security services they consume |
| Compliance/Control Matrix | Maps compliance requirements to implementing controls |
| Role/Permission Matrix | Maps business roles to system permissions |

### Diagrams

| Diagram | Description |
|---------|-------------|
| Security Architecture Overview | High-level view of security architecture and its components |
| Network Security Diagram | Network zones, firewalls, and security boundaries |
| Trust Boundary Diagram | Shows trust boundaries between systems and zones |
| Identity and Access Flow Diagram | Authentication and authorization data flows |
| Data Flow Diagram (with security) | Data flows annotated with security controls |
| Security Incident Response Flow | Process flow for handling security incidents |

---

## Real-World Security Architecture Scenarios

### Scenario 1: Cloud Migration Security

An organization is migrating its on-premises applications to the cloud. The security architect must:

1. **Assess** the shared responsibility model (what the cloud provider secures vs. what the organization secures)
2. **Redesign** network security for a cloud environment (virtual networks, security groups, WAF)
3. **Migrate** identity management to a cloud-compatible solution (federation, cloud IAM)
4. **Implement** cloud-native security services (cloud SIEM, cloud key management)
5. **Ensure** data residency and sovereignty requirements are met
6. **Update** security monitoring for cloud workloads

### Scenario 2: Zero Trust Implementation

An organization is adopting Zero Trust architecture:

1. **Map** all applications, users, and data flows (Phase B, C)
2. **Define** micro-segmentation strategy (Phase D)
3. **Implement** continuous authentication and authorization (Phase C, D)
4. **Deploy** identity-aware proxies and policy enforcement points
5. **Establish** device trust and posture assessment
6. **Monitor** all access with detailed audit logging

### Scenario 3: Merger/Acquisition Security Integration

Two organizations are merging and need to integrate their security architectures:

1. **Assess** both organizations' security postures and architectures
2. **Identify** gaps and conflicts between security policies
3. **Define** a target security architecture that satisfies both organizations' requirements
4. **Plan** migration from two separate security domains to a unified one
5. **Integrate** identity management systems
6. **Harmonize** data classification schemes and access controls

---

## Review Questions

### Question 1
**In TOGAF, security is best described as:**
- A) A separate architecture domain alongside Business, Data, Application, and Technology
- B) A cross-cutting concern that spans all four architecture domains
- C) A sub-domain of the Technology Architecture
- D) A governance function outside the scope of enterprise architecture

**Answer: B** — Security is a cross-cutting concern that must be addressed across all four architecture domains (Business, Data, Application, Technology). It is not a separate fifth domain, nor is it limited to technology.

---

### Question 2
**During which ADM phase should security requirements first be identified?**
- A) Phase D: Technology Architecture
- B) Phase C: Information Systems Architecture
- C) Phase A: Architecture Vision
- D) Phase G: Implementation Governance

**Answer: C** — High-level security requirements should be identified during Phase A (Architecture Vision) as part of understanding business drivers, stakeholder concerns, and constraints. They are then elaborated in subsequent phases.

---

### Question 3
**Which of the following is NOT one of the seven core security services in TOGAF's security taxonomy?**
- A) Authentication
- B) Encryption
- C) Non-repudiation
- D) Audit

**Answer: B** — Encryption is a mechanism used to provide **Confidentiality** and **Integrity**, but it is not listed as a standalone security service. The seven services are: Authentication, Authorization, Audit, Confidentiality, Integrity, Availability, and Non-repudiation.

---

### Question 4
**The STRIDE threat model maps threats to security properties. Which threat maps to the Confidentiality property?**
- A) Spoofing
- B) Tampering
- C) Information Disclosure
- D) Elevation of Privilege

**Answer: C** — Information Disclosure is the threat that maps to the Confidentiality security property. Spoofing maps to Authentication, Tampering to Integrity, and Elevation of Privilege to Authorization.

---

### Question 5
**How does the TOGAF TRM address security?**
- A) It defines a complete security architecture
- B) It includes security services as part of the Application Platform services
- C) It delegates security entirely to external frameworks
- D) It only addresses network security

**Answer: B** — The TOGAF TRM includes security services (Identification & Authentication, System Entry Control, Audit, Access Control, Non-repudiation, Security Management) as part of the Application Platform services layer.

---

### Question 6
**When integrating SABSA with TOGAF, which SABSA layer most closely corresponds to TOGAF's Technology Architecture?**
- A) Contextual layer
- B) Conceptual layer
- C) Logical layer
- D) Physical layer

**Answer: D** — The SABSA Physical layer (Builder's View) focuses on security mechanisms and technologies, which corresponds to TOGAF's Technology Architecture where specific technology decisions are made.

---

### Question 7
**A risk-based approach to security architecture means:**
- A) Spending equally on all security controls
- B) Investing in security proportional to the risk being mitigated
- C) Only addressing high-severity risks
- D) Delegating risk assessment to the business

**Answer: B** — A risk-based approach means security investment is proportional to the risk. This ensures that high-value assets and high-likelihood threats receive appropriate protection without over-engineering for low-risk areas.

---

### Question 8
**In the context of Privacy by Design, which TOGAF ADM phase is most critical for embedding privacy?**
- A) Phase G: Implementation Governance
- B) Phase H: Architecture Change Management
- C) Phase A: Architecture Vision and Phase B: Business Architecture
- D) Phase F: Migration Planning

**Answer: C** — Privacy by Design requires embedding privacy from the earliest design stages. Phase A (Architecture Vision) and Phase B (Business Architecture) are where privacy requirements and policies are first established.

---

### Question 9
**Which of the following best describes the relationship between TOGAF security governance and the Architecture Review Board (ARB)?**
- A) The ARB has no role in security governance
- B) The ARB reviews and approves security architecture decisions and exceptions
- C) The ARB is replaced by a security steering committee
- D) The ARB only reviews technology security

**Answer: B** — The ARB reviews and approves architecture decisions including security architecture. It handles security exception requests and ensures security architecture compliance across projects.

---

### Question 10
**Which security pattern is characterized by the principle "never trust, always verify"?**
- A) Defense in Depth
- B) DMZ Architecture
- C) Zero Trust Architecture
- D) Identity Federation

**Answer: C** — Zero Trust Architecture is based on the principle of "never trust, always verify," requiring continuous authentication and authorization regardless of network location.

---

### Question 11
**When mapping NIST Cybersecurity Framework to TOGAF, the "Protect" function primarily aligns with which ADM phases?**
- A) Preliminary and Phase A
- B) Phase C and Phase D
- C) Phase G and Phase H
- D) Phase E and Phase F

**Answer: B** — The NIST CSF "Protect" function focuses on implementing safeguards (access control, data security, training), which primarily aligns with Phase C (Information Systems Architecture) and Phase D (Technology Architecture) where security controls are designed.

---

### Question 12
**In a cloud migration scenario, the shared responsibility model requires the security architect to:**
- A) Transfer all security responsibility to the cloud provider
- B) Maintain all security controls as they were on-premises
- C) Clearly delineate security responsibilities between the organization and cloud provider
- D) Only focus on physical security

**Answer: C** — The shared responsibility model requires a clear delineation of security responsibilities. The cloud provider is responsible for security OF the cloud (physical, hypervisor), while the customer is responsible for security IN the cloud (data, identity, application).

---

### Question 13
**Data classification in the Data Architecture domain is important for security because:**
- A) It reduces the total amount of data stored
- B) It determines the level of security controls applied to different data assets
- C) It is only required for compliance with GDPR
- D) It replaces the need for encryption

**Answer: B** — Data classification determines the sensitivity level of data, which in turn drives the level of security controls (encryption, access control, monitoring) applied. More sensitive data requires stronger protection.

---

### Question 14
**Which security architecture artifact maps threats to the controls that mitigate them?**
- A) Security Policy Catalog
- B) Threat/Control Matrix
- C) Network Security Diagram
- D) Compliance Requirements Catalog

**Answer: B** — The Threat/Control Matrix maps identified threats to the security controls that mitigate each threat, providing traceability from threats to protective measures.

---

### Question 15
**During Phase F (Migration Planning), security architecture is critical because:**
- A) Security requirements are first identified in this phase
- B) Transition architectures may temporarily weaken security controls
- C) Security is not relevant during migration
- D) Only network security is considered during migration

**Answer: B** — During migration, transition states may temporarily weaken security controls. The security architect must ensure that migration plans do not create security gaps and that acceptable security levels are maintained throughout all transition architectures.

---

### Question 16
**An organization needs to comply with both PCI DSS and GDPR. In TOGAF, these compliance requirements should be captured as:**
- A) Architecture principles only
- B) Architecture constraints and requirements in the Requirements Management phase
- C) Implementation details in Phase G
- D) Business goals in the Preliminary phase only

**Answer: B** — Compliance requirements (PCI DSS, GDPR) should be captured as architecture constraints and requirements, managed through Requirements Management, and traced through all ADM phases to ensure they are addressed in the architecture.

---

### Question 17
**The Defense in Depth security pattern is characterized by:**
- A) A single, strong perimeter defense
- B) Multiple layers of security controls at different levels
- C) Relying entirely on encryption
- D) Trusting all internal network traffic

**Answer: B** — Defense in Depth employs multiple layers of security controls (physical, network, host, application, data) so that if one layer is breached, other layers continue to provide protection.

---

*End of Security Architecture Study Guide*
