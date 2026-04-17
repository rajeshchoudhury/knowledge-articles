# Article 39: Cloud-Native PAS Design

## Table of Contents

1. [Introduction](#1-introduction)
2. [Cloud Strategy for Insurance](#2-cloud-strategy-for-insurance)
3. [Multi-Tenancy Architecture](#3-multi-tenancy-architecture)
4. [Containerization for PAS](#4-containerization-for-pas)
5. [Kubernetes for PAS](#5-kubernetes-for-pas)
6. [Serverless for PAS](#6-serverless-for-pas)
7. [Cloud Database Selection](#7-cloud-database-selection)
8. [Cloud-Native Integration](#8-cloud-native-integration)
9. [Security in Cloud](#9-security-in-cloud)
10. [Disaster Recovery](#10-disaster-recovery)
11. [DevOps & CI/CD](#11-devops--cicd)
12. [Cost Management & FinOps](#12-cost-management--finops)
13. [Cloud Provider Comparison](#13-cloud-provider-comparison)
14. [Reference Architecture](#14-reference-architecture)
15. [Migration Roadmap](#15-migration-roadmap)
16. [Conclusion](#16-conclusion)

---

## 1. Introduction

Cloud-native architecture represents a fundamental shift in how Policy Administration Systems are designed, deployed, and operated. Rather than simply hosting traditional applications on cloud infrastructure ("lift and shift"), cloud-native PAS platforms are purpose-built to exploit the cloud's elastic, distributed, and managed-service capabilities.

For the life insurance industry, this shift is both transformative and constrained. Transformative because cloud-native design enables:

- **Elastic scalability**: Handle month-end valuation runs, annual statement processing, and catastrophic claim surges without over-provisioning
- **Rapid product innovation**: Deploy new insurance products in weeks rather than months
- **Operational efficiency**: Reduce infrastructure management burden through managed services
- **Multi-tenant SaaS delivery**: Serve multiple carriers from a single platform instance
- **Global reach**: Deploy in regions close to policyholders and regulatory requirements

Constrained because insurance regulation imposes requirements not found in typical SaaS platforms:

- **Data residency**: Policy data may need to remain within specific jurisdictions
- **Examination readiness**: Regulators require access to data and systems during market conduct examinations
- **Vendor management**: State regulators require notifications of material outsourcing arrangements
- **Data retention**: Policy records must be retained for decades (often the life of the policy + 10 years)
- **Business continuity**: Regulatory requirements for continuity plans exceeding typical SaaS SLAs

This article provides exhaustive guidance for architects designing cloud-native PAS platforms, covering every dimension from infrastructure to operations, with insurance-specific considerations throughout.

---

## 2. Cloud Strategy for Insurance

### 2.1 Regulatory Considerations

#### 2.1.1 Data Residency Requirements

```mermaid
graph TB
    subgraph "US Regulatory Landscape"
        NAIC[NAIC Model Laws<br/>IT Governance]
        NYDFS[NYDFS 23 NYCRR 500<br/>Cybersecurity]
        STATE[State Insurance<br/>Departments<br/>50+ jurisdictions]
    end
    
    subgraph "Data Residency Rules"
        R1[Policy Data<br/>Must be accessible to<br/>state examiners]
        R2[PHI/PII Data<br/>Subject to state<br/>privacy laws]
        R3[Financial Records<br/>Statutory reporting<br/>requirements]
    end
    
    subgraph "Cloud Implications"
        I1[Region Selection<br/>US-based regions required]
        I2[Data Encryption<br/>At rest and in transit]
        I3[Access Controls<br/>Examiner access provisioning]
        I4[Vendor Management<br/>Cloud provider as vendor]
    end
    
    NAIC --> R1
    NYDFS --> R2
    STATE --> R3
    
    R1 --> I1
    R2 --> I2
    R3 --> I3
    STATE --> I4
```

**Key regulatory requirements and cloud implications**:

| Regulation | Requirement | Cloud Design Impact |
|---|---|---|
| NAIC Model Audit Rule | Auditable access to financial records | Immutable audit logs, examiner role provisioning |
| NYDFS 23 NYCRR 500 | Cybersecurity program, encryption, MFA | KMS-managed encryption, IAM with MFA |
| NAIC Insurance Data Security Model Law (#668) | Security event monitoring, incident response | SIEM integration, automated alerting |
| State examination laws | Physical/logical access to records | Data export capabilities, examiner portal |
| GLBA / Regulation S-P | Privacy of consumer financial information | Data classification, access controls, DLP |
| HIPAA (where applicable) | PHI protection | BAA with cloud provider, PHI isolation |
| SOX (if publicly traded) | Financial controls and audit trails | Change management automation, segregation of duties |

#### 2.1.2 Vendor Management for Cloud

Insurance regulators consider cloud providers as material service providers. Requirements include:

```yaml
# Cloud vendor management checklist for insurance
vendor_management:
  pre_engagement:
    - Conduct cloud provider risk assessment
    - Verify SOC 2 Type II certification
    - Review cloud provider's insurance-specific compliance certifications
    - Negotiate BAA (Business Associate Agreement) if PHI involved
    - Establish right-to-audit clauses
    - Define data ownership and portability terms
    - Review cloud provider's incident notification SLA
    
  ongoing_monitoring:
    - Annual SOC 2 review
    - Quarterly security assessment review
    - Monthly SLA performance review
    - Regulatory notification of material changes
    - Annual BCP/DR testing with cloud provider
    
  exit_strategy:
    - Data export format and timeline defined
    - Alternative provider identified
    - Migration plan documented and tested annually
    - Data destruction verification upon exit
```

### 2.2 Cloud Adoption Maturity Model

```mermaid
graph LR
    L1[Level 1<br/>Cloud Aware<br/>Lift & Shift] --> L2[Level 2<br/>Cloud Enabled<br/>Replatform]
    L2 --> L3[Level 3<br/>Cloud Native<br/>Refactor/Rearchitect]
    L3 --> L4[Level 4<br/>Cloud Optimized<br/>Serverless/Managed]
    L4 --> L5[Level 5<br/>Cloud Innovating<br/>AI/ML, Edge]
```

| Level | Characteristics | PAS Example |
|---|---|---|
| 1 - Cloud Aware | VMs in cloud, manual deployment | Mainframe rehosted on cloud mainframe (Skytap, IBM Cloud) |
| 2 - Cloud Enabled | Containers, managed DB, basic CI/CD | J2EE monolith in containers with RDS backend |
| 3 - Cloud Native | Microservices, Kubernetes, event-driven | Decomposed PAS with independent services |
| 4 - Cloud Optimized | Serverless, fully managed services, FinOps | Correspondence generation via Lambda, managed Kafka |
| 5 - Cloud Innovating | AI-driven underwriting, real-time analytics | ML-based risk assessment, real-time fraud detection |

### 2.3 Cloud Operating Model for Insurance

```mermaid
graph TB
    subgraph "Cloud Center of Excellence (CCoE)"
        GOV[Cloud Governance<br/>Standards, Policies]
        SEC[Cloud Security<br/>Guardrails, Monitoring]
        FIN[FinOps<br/>Cost Management]
        ARCH[Cloud Architecture<br/>Reference Patterns]
    end
    
    subgraph "Platform Engineering Team"
        K8S[Kubernetes Platform]
        CI[CI/CD Platform]
        OBS[Observability Platform]
        SEC_PLAT[Security Platform]
    end
    
    subgraph "Application Teams (Domain-Aligned)"
        POLICY_TEAM[Policy Domain Team]
        BILLING_TEAM[Billing Domain Team]
        CLAIMS_TEAM[Claims Domain Team]
        UW_TEAM[Underwriting Domain Team]
    end
    
    GOV --> K8S
    SEC --> SEC_PLAT
    FIN --> K8S
    ARCH --> K8S
    
    K8S --> POLICY_TEAM
    CI --> POLICY_TEAM
    OBS --> POLICY_TEAM
    K8S --> BILLING_TEAM
    K8S --> CLAIMS_TEAM
    K8S --> UW_TEAM
```

---

## 3. Multi-Tenancy Architecture

### 3.1 PAS as SaaS for Carriers

Modern PAS platforms increasingly operate as SaaS, serving multiple insurance carriers from a shared platform. This requires rigorous multi-tenancy at every layer.

### 3.2 Tenant Isolation Strategies

```mermaid
graph TB
    subgraph "Strategy 1: Database per Tenant"
        APP1[Shared Application Layer]
        DB1A[(Carrier A DB)]
        DB1B[(Carrier B DB)]
        DB1C[(Carrier C DB)]
    end
    
    subgraph "Strategy 2: Schema per Tenant"
        APP2[Shared Application Layer]
        DB2[(Shared Database)]
        S2A[Schema: carrier_a]
        S2B[Schema: carrier_b]
        S2C[Schema: carrier_c]
        DB2 --- S2A
        DB2 --- S2B
        DB2 --- S2C
    end
    
    subgraph "Strategy 3: Row-Level Security"
        APP3[Shared Application Layer]
        DB3[(Shared Database<br/>Shared Schema)]
        RLS[Row-Level Security<br/>tenant_id column]
        DB3 --- RLS
    end
```

#### 3.2.1 Comparison Matrix

| Factor | Database per Tenant | Schema per Tenant | Row-Level Security |
|---|---|---|---|
| Data isolation | Strongest | Strong | Moderate |
| Performance isolation | Strongest | Moderate | Weak |
| Cost efficiency | Low | Moderate | High |
| Operational complexity | High (many DBs) | Moderate | Low |
| Tenant onboarding speed | Slow (provision DB) | Moderate (create schema) | Fast (insert config) |
| Customization flexibility | Highest | Moderate | Limited |
| Cross-tenant reporting | Difficult | Moderate | Easy |
| Regulatory comfort | Highest | High | Moderate |
| Scale limit | ~50 tenants | ~200 tenants | Thousands |

#### 3.2.2 Recommended Hybrid Approach for PAS

```java
// Hybrid: Schema-per-tenant with tenant-specific configuration
@Component
public class TenantRoutingDataSource extends AbstractRoutingDataSource {
    
    @Override
    protected Object determineCurrentLookupKey() {
        return TenantContext.getCurrentTenant();
    }
}

@Component
public class TenantInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, 
                             HttpServletResponse response, 
                             Object handler) {
        String tenantId = resolveTenant(request);
        TenantContext.setCurrentTenant(tenantId);
        MDC.put("tenantId", tenantId);
        return true;
    }
    
    private String resolveTenant(HttpServletRequest request) {
        // Priority: 1) JWT claim, 2) X-Tenant-ID header, 3) subdomain
        String tenantFromJwt = extractTenantFromJwt(request);
        if (tenantFromJwt != null) return tenantFromJwt;
        
        String tenantFromHeader = request.getHeader("X-Tenant-ID");
        if (tenantFromHeader != null) return tenantFromHeader;
        
        return extractTenantFromSubdomain(request);
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, 
                                 HttpServletResponse response, 
                                 Object handler, Exception ex) {
        TenantContext.clear();
        MDC.remove("tenantId");
    }
}

// Tenant context propagation for Kafka events
@Component
public class TenantAwareKafkaProducer {
    
    private final KafkaTemplate<String, CloudEvent> kafkaTemplate;
    
    public void publish(String topic, String key, Object event) {
        String tenantId = TenantContext.getCurrentTenant();
        
        CloudEvent cloudEvent = CloudEventBuilder.v1()
            .withId(UUID.randomUUID().toString())
            .withSource(URI.create("/policy-service"))
            .withType(event.getClass().getName())
            .withExtension("tenantid", tenantId)
            .withData(serialize(event))
            .build();
        
        kafkaTemplate.send(topic, key, cloudEvent);
    }
}

@Component
public class TenantAwareKafkaConsumer {
    
    @KafkaListener(topics = "policy.events")
    public void handle(CloudEvent event) {
        String tenantId = (String) event.getExtension("tenantid");
        TenantContext.setCurrentTenant(tenantId);
        
        try {
            processEvent(event);
        } finally {
            TenantContext.clear();
        }
    }
}
```

### 3.3 Tenant Onboarding

```mermaid
sequenceDiagram
    participant ADMIN as Platform Admin
    participant ONBOARD as Onboarding Service
    participant DB as Database Service
    participant CONFIG as Config Service
    participant PROD as Product Service
    participant AUTH as Auth Service
    
    ADMIN->>ONBOARD: Create Tenant (carrier info)
    ONBOARD->>DB: Provision Tenant Schema
    DB-->>ONBOARD: Schema Created
    
    ONBOARD->>CONFIG: Initialize Tenant Config
    Note over CONFIG: Jurisdictions, company codes,<br/>branding, business rules
    CONFIG-->>ONBOARD: Config Applied
    
    ONBOARD->>PROD: Import Product Catalog
    Note over PROD: Plans, rates, rules,<br/>commission schedules
    PROD-->>ONBOARD: Products Loaded
    
    ONBOARD->>AUTH: Create Tenant Admin Users
    AUTH-->>ONBOARD: Users Created
    
    ONBOARD-->>ADMIN: Tenant Ready
    Note over ADMIN: Provide tenant URL,<br/>admin credentials
```

### 3.4 Tenant-Specific Configuration

```yaml
# Tenant configuration schema
tenant_config:
  tenant_id: "CARRIER_ABC"
  tenant_name: "ABC Life Insurance Company"
  
  company_info:
    naic_code: "12345"
    domicile_state: "CT"
    licensed_states: ["CT", "NY", "NJ", "MA", "PA"]
    federal_tax_id: "XX-XXXXXXX"
    
  branding:
    logo_url: "s3://tenant-assets/carrier-abc/logo.png"
    primary_color: "#003366"
    portal_domain: "abc-life.pas-platform.com"
    
  business_config:
    policy_number_prefix: "ABC"
    policy_number_format: "ABC-{PRODUCT}-{SEQ:9}"
    fiscal_year_end: "12-31"
    accounting_basis: ["STATUTORY", "GAAP"]
    default_currency: "USD"
    
  billing_config:
    grace_period_days: 31
    nsf_retry_days: 10
    nsf_max_retries: 3
    payment_methods: ["ACH", "CREDIT_CARD", "CHECK", "EFT"]
    
  underwriting_config:
    auto_issue_limit: 250000
    mib_enabled: true
    prescription_check_enabled: true
    lab_vendor: "EXAMONE"
    
  compliance_config:
    suitability_required: true
    anti_money_laundering_threshold: 100000
    replacement_review_states: ["NY", "CA", "FL"]
    
  integration_config:
    gl_system: "SAP"
    gl_interface_format: "FLAT_FILE"
    reinsurance_partners:
      - reinsurer_id: "SWISS_RE"
        treaty_ids: ["TR-001", "TR-002"]
    correspondence_vendor: "MESSAGEPOINT"
```

### 3.5 Performance Isolation

```java
// Tenant-aware rate limiting
@Component
public class TenantRateLimiter {
    
    private final Map<String, RateLimiter> tenantLimiters = new ConcurrentHashMap<>();
    private final TenantConfigService configService;
    
    public boolean tryAcquire(String tenantId) {
        RateLimiter limiter = tenantLimiters.computeIfAbsent(tenantId, id -> {
            TenantConfig config = configService.getConfig(id);
            return RateLimiter.of(id, RateLimiterConfig.custom()
                .limitForPeriod(config.getRateLimit())
                .limitRefreshPeriod(Duration.ofSeconds(1))
                .timeoutDuration(Duration.ofMillis(500))
                .build());
        });
        return limiter.acquirePermission();
    }
}

// Tenant-specific resource quotas in Kubernetes
// Applied via namespace-per-tenant or ResourceQuota per tenant
```

```yaml
# Kubernetes ResourceQuota for tenant namespace
apiVersion: v1
kind: ResourceQuota
metadata:
  name: carrier-abc-quota
  namespace: tenant-carrier-abc
spec:
  hard:
    requests.cpu: "20"
    requests.memory: "40Gi"
    limits.cpu: "40"
    limits.memory: "80Gi"
    pods: "100"
    services: "30"
    persistentvolumeclaims: "20"
```

---

## 4. Containerization for PAS

### 4.1 Docker for PAS Services

```dockerfile
# Multi-stage build for Policy Service
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /build
COPY gradle/ gradle/
COPY gradlew build.gradle settings.gradle ./
RUN ./gradlew dependencies --no-daemon

COPY src/ src/
RUN ./gradlew bootJar --no-daemon -x test

# Runtime image
FROM eclipse-temurin:21-jre-alpine AS runtime

RUN addgroup -S pas && adduser -S pas -G pas

RUN apk add --no-cache \
    curl \
    tzdata

ENV TZ=UTC

WORKDIR /app

COPY --from=builder /build/build/libs/policy-service.jar app.jar

RUN chown -R pas:pas /app
USER pas

EXPOSE 8080 8081 9090

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8081/actuator/health/liveness || exit 1

ENTRYPOINT ["java", \
    "-XX:+UseG1GC", \
    "-XX:MaxGCPauseMillis=200", \
    "-XX:+UseStringDeduplication", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/urandom", \
    "-jar", "app.jar"]
```

### 4.2 Container Image Governance

```yaml
# Container image policy (enforced by OPA/Gatekeeper)
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedRepos
metadata:
  name: pas-allowed-repos
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    namespaces: ["pas-production", "pas-staging"]
  parameters:
    repos:
      - "registry.insurer.com/pas/"
      - "registry.insurer.com/base-images/"

---
# Require non-root containers
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPAllowedUsers
metadata:
  name: pas-non-root
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    namespaces: ["pas-production"]
  parameters:
    runAsUser:
      rule: MustRunAsNonRoot
```

### 4.3 Base Image Governance

```yaml
# Base image standards for PAS
base_images:
  java_services:
    image: "registry.insurer.com/base-images/java-21-runtime:1.3.0"
    base: "eclipse-temurin:21-jre-alpine"
    includes:
      - "curl (healthcheck)"
      - "tzdata (timezone support)"
      - "non-root user 'pas'"
      - "CIS benchmark hardening"
    scan_schedule: "weekly"
    update_policy: "monthly security patches, quarterly version updates"
    
  python_services:
    image: "registry.insurer.com/base-images/python-312-runtime:1.1.0"
    base: "python:3.12-slim"
    includes:
      - "non-root user 'pas'"
      - "security updates applied"
    
  node_services:
    image: "registry.insurer.com/base-images/node-20-runtime:1.2.0"
    base: "node:20-alpine"
    includes:
      - "non-root user 'pas'"
      - "npm audit clean"
```

### 4.4 Sidecar Patterns for PAS

```mermaid
graph TB
    subgraph "Policy Service Pod"
        subgraph "Sidecars"
            ENVOY[Envoy Proxy<br/>mTLS, Traffic Mgmt]
            FLUENTBIT[Fluent Bit<br/>Log Shipping]
            VAULT_AGENT[Vault Agent<br/>Secret Injection]
        end
        
        subgraph "Main Container"
            PS[Policy Service<br/>Java 21]
        end
        
        subgraph "Init Containers"
            SCHEMA[Schema Migration<br/>Flyway]
            CONFIG[Config Loader<br/>Pull tenant configs]
        end
    end
    
    ENVOY --> PS
    PS --> FLUENTBIT
    VAULT_AGENT --> PS
    SCHEMA --> PS
    CONFIG --> PS
```

```yaml
# Pod spec with sidecars for PAS service
apiVersion: v1
kind: Pod
metadata:
  name: policy-service
spec:
  initContainers:
    - name: schema-migration
      image: registry.insurer.com/pas/policy-service-migration:3.2.1
      env:
        - name: DB_URL
          valueFrom:
            secretKeyRef:
              name: policy-db
              key: url
      command: ["flyway", "migrate"]
      
    - name: config-loader
      image: registry.insurer.com/pas/config-loader:1.0.0
      volumeMounts:
        - name: config-volume
          mountPath: /config
      env:
        - name: CONFIG_SOURCE
          value: "consul://consul.pas-infra:8500/pas/policy-service"
          
  containers:
    - name: policy-service
      image: registry.insurer.com/pas/policy-service:3.2.1
      volumeMounts:
        - name: config-volume
          mountPath: /app/config
          readOnly: true
        - name: vault-secrets
          mountPath: /vault/secrets
          readOnly: true
          
    - name: fluent-bit
      image: fluent/fluent-bit:2.2
      volumeMounts:
        - name: log-volume
          mountPath: /var/log/pas
      env:
        - name: ELASTICSEARCH_HOST
          value: "elasticsearch.pas-observability:9200"
          
    - name: vault-agent
      image: hashicorp/vault:1.15
      args: ["agent", "-config=/vault/config/agent.hcl"]
      volumeMounts:
        - name: vault-config
          mountPath: /vault/config
        - name: vault-secrets
          mountPath: /vault/secrets

  volumes:
    - name: config-volume
      emptyDir: {}
    - name: log-volume
      emptyDir: {}
    - name: vault-secrets
      emptyDir:
        medium: Memory
    - name: vault-config
      configMap:
        name: vault-agent-config
```

---

## 5. Kubernetes for PAS

### 5.1 Cluster Architecture

```mermaid
graph TB
    subgraph "Production Kubernetes Cluster"
        subgraph "Control Plane (Managed)"
            API[API Server]
            ETCD[etcd]
            SCHED[Scheduler]
            CM[Controller Manager]
        end
        
        subgraph "System Node Pool"
            SYS1[Istio Control Plane]
            SYS2[Monitoring Stack]
            SYS3[Ingress Controllers]
            SYS4[Cert Manager]
        end
        
        subgraph "Application Node Pool (General Purpose)"
            APP1[Policy Services]
            APP2[Party Services]
            APP3[Billing Services]
            APP4[Claims Services]
            APP5[Commission Services]
        end
        
        subgraph "Compute-Optimized Node Pool"
            COMP1[Valuation Engine]
            COMP2[Rating Engine]
            COMP3[Risk Assessment ML]
        end
        
        subgraph "Memory-Optimized Node Pool"
            MEM1[Fund Accounting]
            MEM2[Search/Cache Services]
            MEM3[Batch Processing]
        end
        
        subgraph "Spot/Preemptible Node Pool"
            SPOT1[Batch Valuations]
            SPOT2[Report Generation]
            SPOT3[Data Migration Jobs]
        end
    end
```

### 5.2 Namespace Design

```yaml
# Namespace design for PAS on Kubernetes
namespaces:
  # Infrastructure namespaces
  - name: pas-system
    purpose: "Service mesh control plane, cert-manager, external-dns"
    resource_quota: null  # Managed by platform team
    
  - name: pas-observability
    purpose: "Prometheus, Grafana, Jaeger, ELK"
    resource_quota: null
    
  - name: pas-ingress
    purpose: "Ingress controllers, API gateways"
    resource_quota: null
    
  # Application namespaces (by environment)
  - name: pas-production
    purpose: "Production workloads"
    network_policy: "restricted"
    pod_security: "restricted"
    
  - name: pas-staging
    purpose: "Staging environment for pre-production testing"
    network_policy: "restricted"
    pod_security: "restricted"
    
  - name: pas-development
    purpose: "Development environment"
    network_policy: "baseline"
    pod_security: "baseline"
    
  # Tenant-specific namespaces (for database-per-tenant model)
  - name: pas-tenant-{tenantId}
    purpose: "Tenant-specific resources (databases, configs)"
    resource_quota: "per-tenant-quota"
```

### 5.3 Horizontal Pod Autoscaling for Batch Processing

```yaml
# CronJob for monthly valuation with scaled-up infrastructure
apiVersion: batch/v1
kind: CronJob
metadata:
  name: monthly-valuation
  namespace: pas-production
spec:
  schedule: "0 2 1 * *"  # 2 AM on 1st of each month
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      parallelism: 10
      completions: 10
      template:
        spec:
          nodeSelector:
            workload-type: compute-optimized
          tolerations:
            - key: "workload-type"
              operator: "Equal"
              value: "compute-optimized"
              effect: "NoSchedule"
          containers:
            - name: valuation-worker
              image: registry.insurer.com/pas/valuation-engine:2.1.0
              resources:
                requests:
                  cpu: "4"
                  memory: "8Gi"
                limits:
                  cpu: "8"
                  memory: "16Gi"
              env:
                - name: PARTITION_COUNT
                  value: "10"
                - name: PARTITION_INDEX
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.annotations['batch.kubernetes.io/job-completion-index']
          restartPolicy: OnFailure

---
# KEDA ScaledObject for Kafka-driven autoscaling
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: billing-service-scaler
  namespace: pas-production
spec:
  scaleTargetRef:
    name: billing-service
  pollingInterval: 15
  cooldownPeriod: 60
  minReplicaCount: 3
  maxReplicaCount: 20
  triggers:
    - type: kafka
      metadata:
        bootstrapServers: kafka-bootstrap.pas-infra:9092
        consumerGroup: billing-service
        topic: policy.policy.issued
        lagThreshold: "50"
    - type: kafka
      metadata:
        bootstrapServers: kafka-bootstrap.pas-infra:9092
        consumerGroup: billing-service
        topic: billing.commands.process-cycle
        lagThreshold: "100"
```

### 5.4 Persistent Volume Management

```yaml
# StorageClass for PAS databases
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: pas-database-storage
provisioner: ebs.csi.aws.com
parameters:
  type: io2
  iopsPerGB: "50"
  encrypted: "true"
  kmsKeyId: "arn:aws:kms:us-east-1:123456789:key/pas-storage-key"
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true

---
# PVC for Policy Service database
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: policy-db-data
  namespace: pas-production
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: pas-database-storage
  resources:
    requests:
      storage: 500Gi
```

### 5.5 Network Policies

```yaml
# Network policy: Policy Service can only receive from API Gateway and BFF services,
# and can only connect to its database and Kafka
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-service-network
  namespace: pas-production
spec:
  podSelector:
    matchLabels:
      app: policy-service
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: api-gateway
        - podSelector:
            matchLabels:
              role: bff
      ports:
        - protocol: TCP
          port: 8080
    - from:
        - podSelector:
            matchLabels:
              app: prometheus
      ports:
        - protocol: TCP
          port: 8081
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: policy-db
      ports:
        - protocol: TCP
          port: 5432
    - to:
        - podSelector:
            matchLabels:
              app: kafka
      ports:
        - protocol: TCP
          port: 9092
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: UDP
          port: 53
```

---

## 6. Serverless for PAS

### 6.1 Serverless Use Cases in PAS

```mermaid
graph TB
    subgraph "Event-Driven Serverless Functions"
        F1[Correspondence Trigger<br/>Lambda/Cloud Function]
        F2[Notification Handler<br/>Lambda/Cloud Function]
        F3[File Processing<br/>S3 Event → Lambda]
        F4[Scheduled Reports<br/>EventBridge → Lambda]
        F5[Webhook Handler<br/>API GW → Lambda]
    end
    
    subgraph "Serverless Orchestration"
        SF1[New Business Workflow<br/>Step Functions]
        SF2[Claims Workflow<br/>Step Functions]
        SF3[Batch Processing<br/>Step Functions + Map]
    end
    
    subgraph "Serverless API"
        API1[Customer Self-Service API<br/>API GW + Lambda]
        API2[Agent Quote API<br/>API GW + Lambda]
    end
```

### 6.2 Correspondence Trigger (AWS Lambda)

```python
# Lambda function for correspondence generation trigger
import json
import boto3
from datetime import datetime

sqs = boto3.client('sqs')
dynamodb = boto3.resource('dynamodb')
correspondence_table = dynamodb.Table('CorrespondenceRequests')

def handler(event, context):
    """
    Triggered by policy events via EventBridge.
    Creates correspondence requests and queues them for processing.
    """
    for record in event['Records']:
        body = json.loads(record['body'])
        event_type = body.get('detail-type', '')
        detail = body.get('detail', {})
        
        templates = determine_templates(event_type, detail)
        
        for template in templates:
            request_id = f"{detail['policyNumber']}-{template['code']}-{datetime.utcnow().isoformat()}"
            
            correspondence_table.put_item(Item={
                'requestId': request_id,
                'templateCode': template['code'],
                'policyNumber': detail['policyNumber'],
                'tenantId': detail['tenantId'],
                'recipientPartyId': detail['ownerPartyId'],
                'dataContext': json.dumps(detail),
                'deliveryChannels': template['channels'],
                'priority': template['priority'],
                'regulatoryRequired': template.get('regulatory', False),
                'status': 'PENDING',
                'createdAt': datetime.utcnow().isoformat()
            })
            
            sqs.send_message(
                QueueUrl=os.environ['CORRESPONDENCE_QUEUE_URL'],
                MessageBody=json.dumps({
                    'requestId': request_id,
                    'templateCode': template['code'],
                    'priority': template['priority']
                }),
                MessageGroupId=detail['tenantId']
            )
    
    return {'statusCode': 200, 'processed': len(event['Records'])}


def determine_templates(event_type, detail):
    template_map = {
        'PolicyIssued': [
            {
                'code': 'POL_ISSUE_PKG',
                'channels': ['PRINT_MAIL', 'ELECTRONIC'],
                'priority': 'HIGH',
                'regulatory': True
            },
            {
                'code': 'POL_WELCOME_LETTER',
                'channels': ['EMAIL'],
                'priority': 'MEDIUM',
                'regulatory': False
            }
        ],
        'PolicyLapsed': [
            {
                'code': 'POL_LAPSE_NOTICE',
                'channels': ['PRINT_MAIL'],
                'priority': 'URGENT',
                'regulatory': True
            }
        ],
        'ClaimApproved': [
            {
                'code': 'CLM_APPROVAL',
                'channels': ['PRINT_MAIL', 'EMAIL'],
                'priority': 'HIGH',
                'regulatory': True
            }
        ]
    }
    return template_map.get(event_type, [])
```

### 6.3 Serverless Batch Processing with Step Functions

```json
{
  "Comment": "Monthly Billing Cycle Processing",
  "StartAt": "GetTenantList",
  "States": {
    "GetTenantList": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:get-active-tenants",
      "Next": "ProcessTenantsInParallel"
    },
    "ProcessTenantsInParallel": {
      "Type": "Map",
      "ItemsPath": "$.tenants",
      "MaxConcurrency": 10,
      "Iterator": {
        "StartAt": "GetBillingAccounts",
        "States": {
          "GetBillingAccounts": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789:function:get-billing-accounts",
            "Next": "GenerateStatements"
          },
          "GenerateStatements": {
            "Type": "Map",
            "ItemsPath": "$.accounts",
            "MaxConcurrency": 50,
            "Iterator": {
              "StartAt": "CalculatePremiumDue",
              "States": {
                "CalculatePremiumDue": {
                  "Type": "Task",
                  "Resource": "arn:aws:lambda:us-east-1:123456789:function:calculate-premium",
                  "Next": "CreateStatement"
                },
                "CreateStatement": {
                  "Type": "Task",
                  "Resource": "arn:aws:lambda:us-east-1:123456789:function:create-statement",
                  "Next": "QueueForDelivery"
                },
                "QueueForDelivery": {
                  "Type": "Task",
                  "Resource": "arn:aws:sqs:us-east-1:123456789:billing-statement-delivery",
                  "End": true
                }
              }
            },
            "Next": "TenantBillingComplete"
          },
          "TenantBillingComplete": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789:function:billing-cycle-summary",
            "End": true
          }
        }
      },
      "Next": "BillingCycleComplete"
    },
    "BillingCycleComplete": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:billing-cycle-report",
      "End": true
    }
  }
}
```

### 6.4 Cold Start Mitigation

```yaml
# Provisioned concurrency for latency-sensitive functions
Resources:
  QuoteApiFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: pas-quote-api
      Runtime: java21
      Handler: com.insurer.pas.QuoteHandler::handleRequest
      MemorySize: 2048
      Timeout: 30
      SnapStart:
        ApplyOn: PublishedVersions  # Java SnapStart for faster cold starts
      Environment:
        Variables:
          RATE_TABLE_CACHE: "REDIS"
          
  QuoteApiVersion:
    Type: AWS::Lambda::Version
    Properties:
      FunctionName: !Ref QuoteApiFunction
      
  QuoteApiProvisionedConcurrency:
    Type: AWS::Lambda::ProvisionedConcurrencyConfig
    Properties:
      FunctionName: !Ref QuoteApiFunction
      Qualifier: !GetAtt QuoteApiVersion.Version
      ProvisionedConcurrentExecutions: 10
```

---

## 7. Cloud Database Selection

### 7.1 Database Decision Matrix for PAS

```mermaid
graph TB
    subgraph "Transactional (OLTP)"
        RDS[Amazon Aurora / Azure SQL<br/>Policy, Billing, Claims, Commission]
    end
    
    subgraph "Document Store"
        DYNAMO[DynamoDB / CosmosDB<br/>Product Config, Templates]
    end
    
    subgraph "Analytical (OLAP)"
        REDSHIFT[Redshift / BigQuery / Synapse<br/>Actuarial Data Warehouse]
    end
    
    subgraph "Cache"
        ELASTICACHE[ElastiCache Redis<br/>Rate Tables, Product Config, Sessions]
    end
    
    subgraph "Search"
        OPENSEARCH[OpenSearch / Elastic Cloud<br/>Policy Search, Party Search]
    end
    
    subgraph "Time Series"
        TIMESTREAM[Timestream / TimescaleDB<br/>Valuations, Fund Prices]
    end
    
    subgraph "Graph"
        NEPTUNE[Neptune / CosmosDB Gremlin<br/>Party Relationships, Agent Hierarchies]
    end
    
    subgraph "Object Storage"
        S3[S3 / Blob Storage<br/>Documents, Correspondence Archive]
    end
```

### 7.2 Aurora PostgreSQL for Transactional Data

```yaml
# Aurora PostgreSQL configuration for PAS
aurora_cluster:
  engine: aurora-postgresql
  engine_version: "15.4"
  
  instances:
    writer:
      instance_class: db.r6g.2xlarge  # 8 vCPU, 64 GiB RAM
      count: 1
    reader:
      instance_class: db.r6g.xlarge   # 4 vCPU, 32 GiB RAM
      count: 2
      
  storage:
    encrypted: true
    kms_key: "arn:aws:kms:us-east-1:123456789:key/pas-db-key"
    iops: 20000
    
  high_availability:
    multi_az: true
    global_database: true  # for multi-region DR
    
  backup:
    retention_period: 35
    preferred_window: "03:00-04:00"
    copy_to_region: "us-west-2"  # DR region
    
  monitoring:
    performance_insights: true
    enhanced_monitoring_interval: 15
    
  parameters:
    shared_preload_libraries: "pg_stat_statements,auto_explain"
    log_min_duration_statement: 1000  # Log queries > 1 second
    max_connections: 500
    work_mem: "64MB"
    effective_cache_size: "48GB"
```

### 7.3 DynamoDB for Product Configuration

```python
# DynamoDB table design for product configuration
import boto3

dynamodb = boto3.resource('dynamodb')

product_table = dynamodb.create_table(
    TableName='ProductConfiguration',
    KeySchema=[
        {'AttributeName': 'PK', 'KeyType': 'HASH'},   # PRODUCT#<productCode>
        {'AttributeName': 'SK', 'KeyType': 'RANGE'}    # VERSION#<version>#<entity>
    ],
    AttributeDefinitions=[
        {'AttributeName': 'PK', 'AttributeType': 'S'},
        {'AttributeName': 'SK', 'AttributeType': 'S'},
        {'AttributeName': 'GSI1PK', 'AttributeType': 'S'},
        {'AttributeName': 'GSI1SK', 'AttributeType': 'S'}
    ],
    GlobalSecondaryIndexes=[
        {
            'IndexName': 'GSI1',
            'KeySchema': [
                {'AttributeName': 'GSI1PK', 'KeyType': 'HASH'},
                {'AttributeName': 'GSI1SK', 'KeyType': 'RANGE'}
            ],
            'Projection': {'ProjectionType': 'ALL'}
        }
    ],
    BillingMode='PAY_PER_REQUEST',
    SSESpecification={'Enabled': True, 'SSEType': 'KMS'},
    PointInTimeRecoverySpecification={'PointInTimeRecoveryEnabled': True}
)

# Access patterns:
# 1. Get product by code and version:
#    PK = PRODUCT#WL2025, SK = VERSION#003#PRODUCT
# 2. Get all plans for a product:
#    PK = PRODUCT#WL2025, SK begins_with VERSION#003#PLAN#
# 3. Get rate table:
#    PK = PRODUCT#WL2025, SK = VERSION#003#RATETABLE#MORTALITY
# 4. Get all active products:
#    GSI1PK = STATUS#ACTIVE, GSI1SK = PRODUCT#<productCode>
```

### 7.4 Redis for Caching

```java
// Redis caching strategy for PAS
@Configuration
public class RedisCacheConfig {
    
    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory factory) {
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration
            .defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(30))
            .serializeValuesWith(
                SerializationPair.fromSerializer(
                    new GenericJackson2JsonRedisSerializer()
                )
            );
        
        Map<String, RedisCacheConfiguration> cacheConfigs = Map.of(
            "rateTables", defaultConfig.entryTtl(Duration.ofHours(24)),
            "productConfig", defaultConfig.entryTtl(Duration.ofHours(12)),
            "partyData", defaultConfig.entryTtl(Duration.ofMinutes(15)),
            "policySnapshot", defaultConfig.entryTtl(Duration.ofMinutes(5)),
            "agentHierarchy", defaultConfig.entryTtl(Duration.ofHours(6)),
            "jurisdictionRules", defaultConfig.entryTtl(Duration.ofHours(24))
        );
        
        return RedisCacheManager.builder(factory)
            .cacheDefaults(defaultConfig)
            .withInitialCacheConfigurations(cacheConfigs)
            .build();
    }
}

@Service
public class ProductCachingService {
    
    @Cacheable(value = "rateTables", key = "#planCode + ':' + #effectiveDate")
    public RateTable getRateTable(String planCode, LocalDate effectiveDate) {
        return productRepository.findRateTable(planCode, effectiveDate);
    }
    
    @Cacheable(value = "productConfig", key = "#productCode + ':' + #version")
    public ProductDefinition getProductDefinition(String productCode, int version) {
        return productRepository.findProduct(productCode, version);
    }
    
    @CacheEvict(value = "productConfig", key = "#productCode + ':' + #version")
    public void evictProductCache(String productCode, int version) {
        // Called when product configuration changes
    }
}
```

### 7.5 Data Warehousing for Actuarial Analytics

```sql
-- Redshift/BigQuery schema for actuarial data warehouse
-- Star schema design for policy analytics

-- Fact table: Policy Transactions
CREATE TABLE fact_policy_transactions (
    transaction_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    policy_key BIGINT NOT NULL REFERENCES dim_policy(policy_key),
    product_key BIGINT NOT NULL REFERENCES dim_product(product_key),
    date_key INTEGER NOT NULL REFERENCES dim_date(date_key),
    agent_key BIGINT REFERENCES dim_agent(agent_key),
    geography_key INTEGER REFERENCES dim_geography(geography_key),
    transaction_type VARCHAR(30),
    face_amount DECIMAL(15,2),
    premium_amount DECIMAL(12,2),
    cash_value DECIMAL(15,2),
    death_benefit DECIMAL(15,2),
    net_amount_at_risk DECIMAL(15,2),
    policy_count INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT GETDATE()
)
DISTKEY(product_key)
SORTKEY(date_key, product_key);

-- Dimension: Policy
CREATE TABLE dim_policy (
    policy_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    policy_number VARCHAR(20),
    issue_date DATE,
    issue_age INTEGER,
    gender VARCHAR(1),
    risk_class VARCHAR(10),
    tobacco_status VARCHAR(3),
    issue_state VARCHAR(2),
    policy_status VARCHAR(30),
    effective_date DATE,
    termination_date DATE,
    scd_start_date DATE,
    scd_end_date DATE,
    is_current BOOLEAN DEFAULT TRUE
)
DISTSTYLE ALL;

-- Dimension: Product
CREATE TABLE dim_product (
    product_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_code VARCHAR(10),
    product_name VARCHAR(100),
    product_type VARCHAR(30),
    product_line VARCHAR(30),
    plan_code VARCHAR(10),
    plan_name VARCHAR(100)
)
DISTSTYLE ALL;

-- Dimension: Date
CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR(10),
    day_of_month INTEGER,
    day_of_week INTEGER,
    is_month_end BOOLEAN,
    is_quarter_end BOOLEAN,
    is_year_end BOOLEAN,
    fiscal_year INTEGER,
    fiscal_quarter INTEGER
)
DISTSTYLE ALL;
```

---

## 8. Cloud-Native Integration

### 8.1 API Gateway Architecture

```mermaid
graph TB
    subgraph "External Consumers"
        AGENT[Agent Portal]
        CUST[Customer Portal]
        PARTNER[Partners/Aggregators]
        VENDOR[Vendors (Labs, MIB)]
    end
    
    subgraph "API Gateway Layer"
        subgraph "External Gateway (Kong/AWS API GW)"
            AUTH[Authentication<br/>OAuth 2.0 / API Key]
            RATE[Rate Limiting<br/>Per Client/Plan]
            TRANS[Request Transform<br/>ACORD Mapping]
            ROUTE[Routing<br/>Version/Tenant]
            LOG[Access Logging<br/>Audit Trail]
        end
        
        subgraph "Internal Gateway (Mesh)"
            MESH_RT[Service Routing]
            MESH_CB[Circuit Breaking]
            MESH_LB[Load Balancing]
            MESH_MTLS[mTLS]
        end
    end
    
    subgraph "Backend Services"
        BFF[BFF Services]
        MICRO[Microservices]
    end
    
    AGENT --> AUTH
    CUST --> AUTH
    PARTNER --> AUTH
    VENDOR --> AUTH
    
    AUTH --> RATE --> TRANS --> ROUTE --> LOG --> BFF
    BFF --> MESH_RT --> MICRO
```

### 8.2 Kong API Gateway Configuration

```yaml
# Kong gateway configuration for PAS
_format_version: "3.0"

services:
  - name: policy-service
    url: http://policy-bff.pas-production.svc.cluster.local
    routes:
      - name: policy-api-v3
        paths:
          - /api/v3/policies
        strip_path: false
        plugins:
          - name: jwt
            config:
              claims_to_verify: ["exp"]
              key_claim_name: "iss"
          - name: rate-limiting
            config:
              minute: 300
              hour: 10000
              policy: redis
              redis_host: redis.pas-infra
          - name: request-transformer
            config:
              add:
                headers:
                  - "X-Request-Start:$(now)"
                  - "X-Gateway-Version:3.0"
          - name: correlation-id
            config:
              header_name: X-Correlation-ID
              generator: uuid
          - name: response-transformer
            config:
              remove:
                headers:
                  - "X-Internal-Trace-Id"
                  - "X-Service-Instance"
          - name: ip-restriction
            config:
              allow:
                - 10.0.0.0/8
                - 172.16.0.0/12

  - name: quote-service
    url: http://quote-bff.pas-production.svc.cluster.local
    routes:
      - name: quote-api
        paths:
          - /api/v3/quotes
        plugins:
          - name: rate-limiting
            config:
              minute: 1000
              policy: redis

consumers:
  - username: agent-portal
    plugins:
      - name: rate-limiting
        config:
          minute: 500
          hour: 20000
          
  - username: customer-portal
    plugins:
      - name: rate-limiting
        config:
          minute: 200
          hour: 5000
          
  - username: partner-aggregator
    plugins:
      - name: rate-limiting
        config:
          minute: 100
          hour: 3000
```

### 8.3 Event Bus Architecture (Kafka on Cloud)

```yaml
# Amazon MSK (Managed Streaming for Kafka) configuration
msk_cluster:
  cluster_name: pas-event-bus
  kafka_version: "3.5.1"
  
  broker_node:
    instance_type: kafka.m5.2xlarge
    number_of_broker_nodes: 6  # 3 AZs, 2 per AZ
    ebs_volume_size: 1000  # GB
    
  encryption:
    in_transit:
      client_broker: TLS
      in_cluster: true
    at_rest:
      kms_key_arn: "arn:aws:kms:us-east-1:123456789:key/pas-kafka-key"
      
  configuration:
    auto.create.topics.enable: false
    default.replication.factor: 3
    min.insync.replicas: 2
    num.partitions: 12
    log.retention.hours: 168  # 7 days
    log.retention.bytes: -1   # unlimited by size
    message.max.bytes: 1048576  # 1 MB
    
  monitoring:
    enhanced_monitoring: PER_TOPIC_PER_BROKER
    open_monitoring:
      prometheus:
        jmx_exporter: true
        node_exporter: true
    cloudwatch:
      log_group: "/msk/pas-event-bus"

# Topic definitions for PAS
topics:
  - name: policy.policy.issued
    partitions: 12
    replication_factor: 3
    config:
      retention.ms: 604800000      # 7 days
      cleanup.policy: delete
      min.insync.replicas: 2
      
  - name: policy.policy.changed
    partitions: 12
    replication_factor: 3
    config:
      retention.ms: 604800000
      
  - name: billing.payment.received
    partitions: 6
    replication_factor: 3
    config:
      retention.ms: 604800000
      
  - name: pas.audit.trail
    partitions: 24
    replication_factor: 3
    config:
      retention.ms: -1             # Infinite retention
      cleanup.policy: compact
      min.insync.replicas: 2
```

### 8.4 iPaaS Integration Patterns

```mermaid
graph TB
    subgraph "PAS Platform"
        PS[Policy Service]
        BS[Billing Service]
        CS[Claims Service]
    end
    
    subgraph "iPaaS Layer (MuleSoft / Boomi)"
        IPAAS[Integration Platform]
        
        subgraph "Integration Flows"
            F1[GL Integration<br/>PAS → SAP/Oracle]
            F2[Payment Gateway<br/>PAS → Stripe/ACH]
            F3[Vendor Integration<br/>MIB, Labs, MVR]
            F4[Reinsurance<br/>PAS → Reinsurer Portal]
            F5[ACORD Messaging<br/>Industry Standard XML]
            F6[Banking/ACH<br/>NACHA File Generation]
        end
    end
    
    subgraph "External Systems"
        SAP[SAP General Ledger]
        BANK[Banking Partner]
        MIB[MIB Check]
        LABS[Lab Vendors]
        REIN[Reinsurance Partners]
        IRS[IRS (1099-R Filing)]
    end
    
    PS --> IPAAS
    BS --> IPAAS
    CS --> IPAAS
    
    IPAAS --> F1 --> SAP
    IPAAS --> F2 --> BANK
    IPAAS --> F3 --> MIB
    IPAAS --> F3 --> LABS
    IPAAS --> F4 --> REIN
    IPAAS --> F6 --> BANK
```

---

## 9. Security in Cloud

### 9.1 Shared Responsibility Model for PAS

```mermaid
graph TB
    subgraph "Insurer/PAS Provider Responsibility"
        I1[Data Classification & Protection]
        I2[Application Security]
        I3[Identity & Access Management]
        I4[Data Encryption Key Management]
        I5[Network Security Configuration]
        I6[OS Patching (if IaaS)]
        I7[Regulatory Compliance]
        I8[Incident Response]
    end
    
    subgraph "Cloud Provider Responsibility"
        C1[Physical Security]
        C2[Network Infrastructure]
        C3[Hypervisor Security]
        C4[Managed Service Security]
        C5[Global Infrastructure]
        C6[Compliance Certifications]
    end
    
    subgraph "Shared Responsibility"
        S1[Patch Management]
        S2[Configuration Management]
        S3[Awareness & Training]
        S4[Encryption]
    end
```

### 9.2 VPC/VNET Architecture

```mermaid
graph TB
    subgraph "VPC: pas-production (10.0.0.0/16)"
        subgraph "Public Subnets (10.0.0.0/20)"
            NAT[NAT Gateway]
            ALB[Application Load Balancer]
            BASTION[Bastion Host<br/>(for emergency access)]
        end
        
        subgraph "Private App Subnets (10.0.16.0/20)"
            EKS[EKS Worker Nodes<br/>PAS Microservices]
        end
        
        subgraph "Private Data Subnets (10.0.32.0/20)"
            RDS[Aurora PostgreSQL]
            REDIS_VPC[ElastiCache Redis]
            MSK[MSK Kafka]
        end
        
        subgraph "Private Integration Subnets (10.0.48.0/20)"
            VPN[Site-to-Site VPN<br/>to On-Premises]
            DX[Direct Connect<br/>to Partner Networks]
        end
    end
    
    subgraph "VPC: pas-management (10.1.0.0/16)"
        CICD[CI/CD Agents]
        MONITOR[Monitoring Stack]
        VAULT_VPC[HashiCorp Vault]
    end
    
    INTERNET[Internet] --> ALB
    ALB --> EKS
    EKS --> RDS
    EKS --> REDIS_VPC
    EKS --> MSK
    EKS --> NAT --> INTERNET
    
    VPN --> EKS
```

### 9.3 Encryption Architecture

```yaml
# KMS key hierarchy for PAS
kms_keys:
  master_key:
    alias: "pas-master-key"
    description: "PAS master encryption key"
    key_spec: "SYMMETRIC_DEFAULT"
    key_usage: "ENCRYPT_DECRYPT"
    multi_region: true
    rotation: true
    rotation_period_days: 365
    policy: |
      Allow pas-admin-role to manage key
      Allow pas-service-roles to use key for encrypt/decrypt
      Allow auditor-role to describe key
  
  database_key:
    alias: "pas-database-key"
    description: "Encryption key for PAS databases (Aurora, DynamoDB)"
    key_spec: "SYMMETRIC_DEFAULT"
    
  storage_key:
    alias: "pas-storage-key"
    description: "Encryption key for S3 document storage"
    key_spec: "SYMMETRIC_DEFAULT"
    
  kafka_key:
    alias: "pas-kafka-key"
    description: "Encryption key for Kafka at-rest encryption"
    key_spec: "SYMMETRIC_DEFAULT"
    
  application_key:
    alias: "pas-app-encryption-key"
    description: "Application-level encryption (PII field encryption)"
    key_spec: "SYMMETRIC_DEFAULT"
    
# Application-level encryption for PII fields
application_encryption:
  strategy: "envelope_encryption"
  data_key_caching: true
  cache_ttl_seconds: 300
  max_cache_entries: 1000
  encrypted_fields:
    - "ssn"
    - "tax_id"
    - "bank_account_number"
    - "credit_card_number"
    - "date_of_birth"
    - "health_records"
```

### 9.4 Secrets Management

```yaml
# HashiCorp Vault configuration for PAS
vault:
  secrets_engines:
    - path: "pas/database"
      type: "database"
      description: "Dynamic database credentials"
      config:
        plugin: "postgresql-database-plugin"
        connection_url: "postgresql://{{username}}:{{password}}@policy-db.cluster.us-east-1.rds.amazonaws.com:5432/policy_db"
        allowed_roles: ["policy-service-role", "readonly-role"]
        
    - path: "pas/kv"
      type: "kv-v2"
      description: "Static secrets for PAS services"
      
    - path: "pas/pki"
      type: "pki"
      description: "Internal CA for service-to-service TLS"
      
  policies:
    - name: "policy-service"
      rules: |
        path "pas/database/creds/policy-service-role" {
          capabilities = ["read"]
        }
        path "pas/kv/data/policy-service/*" {
          capabilities = ["read"]
        }
        path "pas/pki/issue/policy-service" {
          capabilities = ["create", "update"]
        }
        
    - name: "billing-service"
      rules: |
        path "pas/database/creds/billing-service-role" {
          capabilities = ["read"]
        }
        path "pas/kv/data/billing-service/*" {
          capabilities = ["read"]
        }
        path "pas/kv/data/payment-gateway/*" {
          capabilities = ["read"]
        }
  
  auth_methods:
    - type: "kubernetes"
      config:
        kubernetes_host: "https://kubernetes.default.svc"
      roles:
        - name: "policy-service"
          bound_service_account_names: ["policy-service"]
          bound_service_account_namespaces: ["pas-production"]
          policies: ["policy-service"]
          ttl: "1h"
```

### 9.5 WAF and DDoS Protection

```yaml
# AWS WAF rules for PAS web applications
waf_web_acl:
  name: "pas-web-acl"
  rules:
    - name: "AWSManagedRulesCommonRuleSet"
      priority: 1
      managed_rule_group: "AWS"
      
    - name: "AWSManagedRulesKnownBadInputsRuleSet"
      priority: 2
      managed_rule_group: "AWS"
      
    - name: "AWSManagedRulesSQLiRuleSet"
      priority: 3
      managed_rule_group: "AWS"
      
    - name: "RateLimitPerIP"
      priority: 4
      type: "rate-based"
      rate_limit: 2000  # requests per 5 minutes
      
    - name: "GeoRestriction"
      priority: 5
      type: "geo-match"
      allowed_countries: ["US", "CA"]  # Restrict to licensed jurisdictions
      
    - name: "BlockBadBots"
      priority: 6
      type: "regex"
      patterns:
        - "(?i)(scrapy|curl|wget|python-requests)"
      field: "user-agent"
      action: "block"
      
    - name: "RequireValidContentType"
      priority: 7
      type: "byte-match"
      field: "content-type"
      positive_match: "application/json"
      condition: "POST,PUT,PATCH requests"
```

---

## 10. Disaster Recovery

### 10.1 Multi-Region Architecture

```mermaid
graph TB
    subgraph "Primary Region (us-east-1)"
        subgraph "Active"
            EKS1[EKS Cluster<br/>All PAS Services]
            RDS1[(Aurora Primary<br/>Writer)]
            MSK1[MSK Kafka<br/>Primary]
            S3_1[S3 Documents]
            REDIS1[ElastiCache]
        end
    end
    
    subgraph "DR Region (us-west-2)"
        subgraph "Standby (Warm)"
            EKS2[EKS Cluster<br/>Scaled Down]
            RDS2[(Aurora Replica<br/>Reader)]
            MSK2[MSK Kafka<br/>Mirror]
            S3_2[S3 Documents<br/>Replicated]
            REDIS2[ElastiCache<br/>Standby]
        end
    end
    
    subgraph "Global"
        R53[Route 53<br/>DNS Failover]
        GDB[Aurora Global<br/>Database]
        S3REP[S3 Cross-Region<br/>Replication]
        MSKMIR[MSK Mirror<br/>Maker]
    end
    
    R53 --> EKS1
    R53 -.->|failover| EKS2
    
    RDS1 --> GDB --> RDS2
    S3_1 --> S3REP --> S3_2
    MSK1 --> MSKMIR --> MSK2
```

### 10.2 RTO/RPO Requirements

| Component | RPO | RTO | DR Strategy |
|---|---|---|---|
| Policy Database | < 1 second | < 15 minutes | Aurora Global Database (async replication) |
| Billing Database | < 1 second | < 15 minutes | Aurora Global Database |
| Claims Database | < 1 second | < 30 minutes | Aurora Global Database |
| Financial Database | < 1 second | < 15 minutes | Aurora Global Database |
| Document Store (S3) | < 15 minutes | < 1 hour | S3 Cross-Region Replication |
| Kafka Events | < 5 minutes | < 30 minutes | MirrorMaker 2 cross-region |
| Search Index | Rebuild from source | < 2 hours | Rebuild from event log |
| Cache (Redis) | N/A (rebuildable) | < 5 minutes | Warm standby, populate on demand |
| Product Config | < 1 hour | < 30 minutes | DynamoDB Global Tables |

### 10.3 Failover Procedure

```yaml
# DR failover runbook (automated via Step Functions)
failover_procedure:
  detection:
    - Route 53 health check failure (3 consecutive, 30s interval)
    - CloudWatch alarm: Primary region API error rate > 50% for 5 minutes
    - Manual trigger by operations team
    
  automated_steps:
    1_dns_failover:
      action: "Route 53 failover to DR region"
      timeout: 60s
      automated: true
      
    2_database_promotion:
      action: "Promote Aurora DR replica to primary"
      timeout: 120s
      automated: true
      validation: "Verify write capability on promoted cluster"
      
    3_kafka_activation:
      action: "Activate DR Kafka cluster, redirect producers"
      timeout: 60s
      automated: true
      
    4_service_scaling:
      action: "Scale up EKS nodes and pods in DR region"
      timeout: 300s
      automated: true
      target_replicas: "Match primary region"
      
    5_cache_warm:
      action: "Warm cache from database (critical paths only)"
      timeout: 180s
      automated: true
      priority_caches: ["rateTables", "productConfig"]
      
    6_verification:
      action: "Run smoke tests against DR environment"
      timeout: 300s
      automated: true
      tests:
        - "Policy lookup by number"
        - "New business quote"
        - "Payment processing"
        - "Claims inquiry"
      
  manual_steps:
    7_communication:
      action: "Notify stakeholders of DR activation"
      audience: ["IT leadership", "Business ops", "Regulatory"]
      
    8_monitoring:
      action: "Enhanced monitoring for 24 hours"
      focus: ["Error rates", "Latency", "Data consistency"]

  failback_procedure:
    prerequisite: "Primary region fully restored and validated"
    steps:
      - "Sync data changes from DR back to primary (incremental)"
      - "Verify data consistency between regions"
      - "Gradual traffic shift: 10% → 25% → 50% → 100%"
      - "Monitor for 48 hours before decommissioning DR active mode"
```

### 10.4 DR Testing

```yaml
# Annual DR testing plan
dr_testing:
  frequency: "Quarterly (minimum annually per regulation)"
  
  test_types:
    tabletop_exercise:
      frequency: "Quarterly"
      participants: ["IT", "Business", "Compliance"]
      scenarios:
        - "Complete primary region outage"
        - "Database corruption requiring point-in-time recovery"
        - "Ransomware attack requiring clean restore"
        - "Cloud provider region failure"
      
    technical_failover_test:
      frequency: "Semi-annually"
      scope: "Full automated failover to DR region"
      duration: "4 hours minimum running on DR"
      success_criteria:
        - "All services operational within RTO"
        - "Data loss within RPO"
        - "All smoke tests pass"
        - "No manual intervention required for automated steps"
      
    chaos_engineering:
      frequency: "Monthly in staging"
      tools: ["Chaos Mesh", "Litmus"]
      scenarios:
        - "Kill random pod in production"
        - "Network partition between services"
        - "Database failover"
        - "Kafka broker failure"
```

---

## 11. DevOps & CI/CD

### 11.1 CI/CD Pipeline Architecture

```mermaid
graph LR
    subgraph "Source"
        GIT[Git Repository<br/>GitHub/GitLab]
    end
    
    subgraph "CI Pipeline"
        BUILD[Build & Unit Test]
        SAST[SAST Scan<br/>SonarQube/Checkmarx]
        DEP_SCAN[Dependency Scan<br/>Snyk/Dependabot]
        CONTAINER[Container Build<br/>& Scan (Trivy)]
        CONTRACT[Contract Tests<br/>Pact Broker]
        PUBLISH[Publish to<br/>Container Registry]
    end
    
    subgraph "CD Pipeline"
        DEV[Deploy to Dev<br/>Auto]
        INT_TEST[Integration Tests]
        STAGE[Deploy to Staging<br/>Auto]
        PERF[Performance Tests]
        SEC_TEST[DAST Scan<br/>OWASP ZAP]
        APPROVAL[Manual Approval<br/>for Production]
        CANARY[Canary Deploy<br/>5% traffic]
        MONITOR[Monitor Canary<br/>Error rates, latency]
        PROMOTE[Promote to<br/>100% traffic]
    end
    
    GIT --> BUILD --> SAST --> DEP_SCAN --> CONTAINER --> CONTRACT --> PUBLISH
    PUBLISH --> DEV --> INT_TEST --> STAGE --> PERF --> SEC_TEST --> APPROVAL
    APPROVAL --> CANARY --> MONITOR --> PROMOTE
```

### 11.2 GitHub Actions CI Pipeline

```yaml
# .github/workflows/ci.yml
name: PAS Service CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  REGISTRY: registry.insurer.com/pas
  SERVICE_NAME: policy-service

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21
          cache: gradle
      
      - name: Build and Unit Test
        run: ./gradlew build test jacocoTestReport
        
      - name: Check Code Coverage
        run: |
          COVERAGE=$(./gradlew jacocoTestCoverageVerification 2>&1)
          echo "$COVERAGE"
          # Minimum 80% line coverage required
          
      - name: Upload Test Results
        uses: actions/upload-artifact@v4
        with:
          name: test-results
          path: build/reports/

  security-scan:
    runs-on: ubuntu-latest
    needs: build-and-test
    steps:
      - uses: actions/checkout@v4
      
      - name: SAST Scan (SonarQube)
        uses: sonarsource/sonarqube-scan-action@v2
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          
      - name: Dependency Scan (Snyk)
        uses: snyk/actions/gradle@master
        with:
          args: --severity-threshold=high
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

  container-build:
    runs-on: ubuntu-latest
    needs: [build-and-test, security-scan]
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Container Image
        run: |
          docker build -t $REGISTRY/$SERVICE_NAME:${{ github.sha }} .
          
      - name: Scan Container (Trivy)
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: '${{ env.REGISTRY }}/${{ env.SERVICE_NAME }}:${{ github.sha }}'
          format: 'sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
          
      - name: Push to Registry
        run: |
          docker push $REGISTRY/$SERVICE_NAME:${{ github.sha }}
          docker tag $REGISTRY/$SERVICE_NAME:${{ github.sha }} \
            $REGISTRY/$SERVICE_NAME:latest
          docker push $REGISTRY/$SERVICE_NAME:latest

  contract-test:
    runs-on: ubuntu-latest
    needs: build-and-test
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Consumer Contract Tests
        run: ./gradlew pactTest
        
      - name: Publish Pacts to Broker
        run: ./gradlew pactPublish
        env:
          PACT_BROKER_URL: ${{ secrets.PACT_BROKER_URL }}
          PACT_BROKER_TOKEN: ${{ secrets.PACT_BROKER_TOKEN }}

  deploy-dev:
    runs-on: ubuntu-latest
    needs: [container-build, contract-test]
    if: github.ref == 'refs/heads/develop'
    environment: development
    steps:
      - name: Deploy to Dev via ArgoCD
        run: |
          argocd app set $SERVICE_NAME-dev \
            --helm-set image.tag=${{ github.sha }}
          argocd app sync $SERVICE_NAME-dev --wait
```

### 11.3 Infrastructure as Code (Terraform)

```hcl
# terraform/environments/production/main.tf

module "vpc" {
  source = "../../modules/vpc"
  
  vpc_name    = "pas-production"
  vpc_cidr    = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  private_subnets = ["10.0.16.0/22", "10.0.20.0/22", "10.0.24.0/22"]
  public_subnets  = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  data_subnets    = ["10.0.32.0/22", "10.0.36.0/22", "10.0.40.0/22"]
  
  enable_nat_gateway = true
  single_nat_gateway = false  # One per AZ for HA
  
  tags = {
    Environment = "production"
    Project     = "PAS"
    ManagedBy   = "terraform"
  }
}

module "eks" {
  source = "../../modules/eks"
  
  cluster_name    = "pas-production"
  cluster_version = "1.28"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      instance_types = ["m6i.2xlarge"]
      min_size       = 3
      max_size       = 20
      desired_size   = 6
      labels = {
        workload-type = "general"
      }
    }
    compute = {
      instance_types = ["c6i.4xlarge"]
      min_size       = 2
      max_size       = 10
      desired_size   = 3
      labels = {
        workload-type = "compute-optimized"
      }
      taints = [{
        key    = "workload-type"
        value  = "compute-optimized"
        effect = "NO_SCHEDULE"
      }]
    }
    memory = {
      instance_types = ["r6i.2xlarge"]
      min_size       = 2
      max_size       = 8
      desired_size   = 3
      labels = {
        workload-type = "memory-optimized"
      }
    }
  }
}

module "aurora" {
  source = "../../modules/aurora"
  
  for_each = {
    policy    = { instance_class = "db.r6g.2xlarge", reader_count = 2 }
    billing   = { instance_class = "db.r6g.xlarge", reader_count = 1 }
    claims    = { instance_class = "db.r6g.xlarge", reader_count = 1 }
    financial = { instance_class = "db.r6g.xlarge", reader_count = 1 }
    commission = { instance_class = "db.r6g.large", reader_count = 1 }
  }
  
  cluster_identifier = "pas-${each.key}-db"
  engine             = "aurora-postgresql"
  engine_version     = "15.4"
  instance_class     = each.value.instance_class
  reader_count       = each.value.reader_count
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.data_subnet_ids
  
  storage_encrypted = true
  kms_key_id        = module.kms.database_key_arn
  
  backup_retention_period = 35
  
  global_cluster = true  # Enable for DR
}

module "msk" {
  source = "../../modules/msk"
  
  cluster_name = "pas-event-bus"
  kafka_version = "3.5.1"
  
  broker_node_count = 6
  instance_type     = "kafka.m5.2xlarge"
  ebs_volume_size   = 1000
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.data_subnet_ids
  
  encryption_at_rest_kms_key_arn = module.kms.kafka_key_arn
  encryption_in_transit          = "TLS"
}
```

---

## 12. Cost Management & FinOps

### 12.1 Cost Optimization Strategies

```mermaid
graph TB
    subgraph "Cost Optimization Pillars"
        RI[Reserved Instances<br/>Steady-state workloads]
        SPOT[Spot/Preemptible<br/>Batch processing]
        SL[Serverless<br/>Variable workloads]
        TIER[Storage Tiering<br/>Hot/Warm/Cold]
        RIGHT[Right-Sizing<br/>Resource optimization]
        AUTO[Auto-Scaling<br/>Match demand]
    end
    
    subgraph "PAS Workload Classification"
        STEADY[Steady State<br/>Policy API, Billing<br/>RI / Savings Plans]
        BURST[Burst Processing<br/>Month-end valuation<br/>On-demand + Spot]
        EVENT[Event-Driven<br/>Notifications, Correspondence<br/>Serverless]
        BATCH[Batch Jobs<br/>Reports, Data Migration<br/>Spot Instances]
        STORE[Storage<br/>Documents, Archives<br/>Tiered Storage]
    end
```

### 12.2 Reserved Instances Strategy

```yaml
# RI/Savings Plan allocation for PAS
reserved_capacity:
  compute_savings_plan:
    commitment: "$150,000/month"
    term: "1 year"
    payment: "Partial Upfront"
    coverage:
      - eks_node_groups: "general, memory-optimized"
      - rds_instances: "all Aurora instances"
      
  on_demand_allocation:
    - compute_optimized_nodes: "Auto-scale group for batch processing"
    - development_environments: "Shut down nights/weekends"
    
  spot_allocation:
    - batch_processing: "Monthly valuation, annual statement, data migration"
    - testing: "Load testing, integration testing"
    
  serverless_allocation:
    - correspondence_triggers: "Lambda"
    - notification_handlers: "Lambda"
    - file_processing: "Lambda"
    - scheduled_reports: "Lambda + Step Functions"
```

### 12.3 Storage Tiering

```yaml
# S3 lifecycle policies for PAS documents
s3_lifecycle:
  policy_documents:
    bucket: "pas-policy-documents"
    rules:
      - name: "active-policy-documents"
        transitions:
          - days: 0
            storage_class: "STANDARD"           # Active policies
          - days: 365
            storage_class: "STANDARD_IA"         # After 1 year
          - days: 2555                           # ~7 years
            storage_class: "GLACIER_IR"          # Infrequent access
          - days: 3650                           # 10 years
            storage_class: "GLACIER_DEEP_ARCHIVE" # Long-term retention
            
  correspondence_archive:
    bucket: "pas-correspondence-archive"
    rules:
      - name: "correspondence-lifecycle"
        transitions:
          - days: 90
            storage_class: "STANDARD_IA"
          - days: 365
            storage_class: "GLACIER_IR"
          - days: 2555
            storage_class: "GLACIER_DEEP_ARCHIVE"
            
  claims_documents:
    bucket: "pas-claims-documents"
    rules:
      - name: "claims-lifecycle"
        transitions:
          - days: 0
            storage_class: "STANDARD"           # Active claims
          - days: 730                            # 2 years after closure
            storage_class: "STANDARD_IA"
          - days: 3650
            storage_class: "GLACIER_DEEP_ARCHIVE"
```

### 12.4 Cost Allocation by Tenant

```yaml
# AWS tagging strategy for PAS cost allocation
tagging_strategy:
  required_tags:
    - key: "Environment"
      values: ["production", "staging", "development"]
    - key: "Project"
      value: "PAS"
    - key: "Domain"
      values: ["policy", "billing", "claims", "underwriting", "commission", "financial", "correspondence", "infrastructure"]
    - key: "TenantId"
      description: "Carrier/tenant identifier for cost allocation"
    - key: "CostCenter"
      description: "Internal cost center code"
      
  cost_allocation:
    shared_infrastructure:
      allocation_method: "proportional_to_policy_count"
      components: ["EKS control plane", "MSK cluster", "VPC", "monitoring"]
      
    dedicated_resources:
      allocation_method: "direct_assignment"
      components: ["tenant-specific databases", "tenant-specific storage"]
      
    usage_based:
      allocation_method: "metered_usage"
      components: ["API calls", "compute time", "storage consumed", "data transfer"]

# Monthly cost report structure
cost_report:
  dimensions:
    - tenant
    - domain
    - environment
    - resource_type
  metrics:
    - total_cost
    - cost_per_policy
    - cost_per_transaction
    - cost_trend_30d
```

### 12.5 FinOps Practices

| Practice | Frequency | Owner | Actions |
|---|---|---|---|
| Cost anomaly detection | Real-time | Automated | Alert on >20% day-over-day increase |
| Resource right-sizing | Monthly | Platform team | Review CPU/memory utilization, adjust requests/limits |
| Reserved instance optimization | Quarterly | FinOps team | Review utilization, modify reservations |
| Unused resource cleanup | Weekly | Automated | Identify and report unattached volumes, idle instances |
| Development environment scheduling | Daily | Automated | Scale down dev environments nights/weekends |
| Tenant cost reporting | Monthly | FinOps team | Allocate costs, generate tenant invoices |
| Architecture cost review | Quarterly | Architecture team | Review expensive patterns, identify optimization opportunities |

---

## 13. Cloud Provider Comparison

### 13.1 Service Mapping for PAS

| PAS Capability | AWS | Azure | GCP |
|---|---|---|---|
| **Container Orchestration** | EKS | AKS | GKE |
| **Relational Database** | Aurora PostgreSQL | Azure SQL / Cosmos PostgreSQL | Cloud SQL / AlloyDB |
| **Document Database** | DynamoDB | Cosmos DB | Firestore |
| **Message Broker** | MSK (Kafka), SQS | Event Hubs, Service Bus | Pub/Sub |
| **Event Bus** | EventBridge | Event Grid | Eventarc |
| **Object Storage** | S3 | Blob Storage | Cloud Storage |
| **Cache** | ElastiCache (Redis) | Azure Cache for Redis | Memorystore |
| **Search** | OpenSearch | Azure Cognitive Search | Vertex AI Search |
| **API Gateway** | API Gateway | APIM | Apigee |
| **Serverless Compute** | Lambda | Functions | Cloud Functions |
| **Serverless Orchestration** | Step Functions | Durable Functions / Logic Apps | Workflows |
| **Secrets Management** | Secrets Manager | Key Vault | Secret Manager |
| **Key Management** | KMS | Key Vault | Cloud KMS |
| **CI/CD** | CodePipeline/CodeBuild | Azure DevOps | Cloud Build |
| **IaC** | CloudFormation / CDK | ARM / Bicep | Deployment Manager |
| **Monitoring** | CloudWatch | Monitor | Cloud Monitoring |
| **Tracing** | X-Ray | Application Insights | Cloud Trace |
| **Data Warehouse** | Redshift | Synapse Analytics | BigQuery |
| **Identity** | IAM / Cognito | Entra ID / AD B2C | IAM / Identity Platform |
| **WAF** | AWS WAF | Azure WAF | Cloud Armor |
| **DNS** | Route 53 | Traffic Manager + DNS | Cloud DNS |
| **VPN/DirectConnect** | Direct Connect | ExpressRoute | Cloud Interconnect |

### 13.2 Insurance-Specific Compliance Certifications

| Certification | AWS | Azure | GCP |
|---|---|---|---|
| SOC 2 Type II | Yes | Yes | Yes |
| SOC 1 Type II | Yes | Yes | Yes |
| ISO 27001 | Yes | Yes | Yes |
| ISO 27017 | Yes | Yes | Yes |
| ISO 27018 | Yes | Yes | Yes |
| HIPAA BAA | Yes | Yes | Yes |
| PCI DSS Level 1 | Yes | Yes | Yes |
| FedRAMP | Yes (High) | Yes (High) | Yes (High) |
| HITRUST CSF | Yes | Yes | Partial |
| NYDFS 23 NYCRR 500 Support | Shared Responsibility | Shared Responsibility | Shared Responsibility |
| State Insurance Regulatory Compliance | Customer Responsibility | Customer Responsibility | Customer Responsibility |

### 13.3 Provider Selection Decision Framework

```mermaid
graph TB
    START[Provider Selection] --> Q1{Existing Cloud<br/>Relationship?}
    
    Q1 -->|AWS Shop| AWS_LEAN[Lean AWS<br/>Strongest managed services ecosystem]
    Q1 -->|Azure/Microsoft Shop| AZURE_LEAN[Lean Azure<br/>Best Microsoft integration]
    Q1 -->|Neither| EVALUATE[Evaluate on Merit]
    
    EVALUATE --> Q2{Primary Workload?}
    
    Q2 -->|Data/Analytics Heavy| GCP_REC[Consider GCP<br/>BigQuery, Vertex AI]
    Q2 -->|Enterprise Integration| AZURE_REC[Consider Azure<br/>Power Platform, Dynamics]
    Q2 -->|Cloud-Native Microservices| AWS_REC[Consider AWS<br/>Broadest service catalog]
    
    AWS_LEAN --> FINAL[Final Decision:<br/>Multi-cloud readiness<br/>with primary provider]
    AZURE_LEAN --> FINAL
    GCP_REC --> FINAL
    AZURE_REC --> FINAL
    AWS_REC --> FINAL
```

---

## 14. Reference Architecture

### 14.1 Complete Cloud-Native PAS Architecture

```mermaid
graph TB
    subgraph "Global Edge"
        CF[CloudFront CDN]
        WAF[AWS WAF]
        R53[Route 53<br/>Geo DNS]
    end
    
    subgraph "Primary Region (us-east-1)"
        subgraph "Ingress"
            ALB[Application LB]
            APIGW[API Gateway]
        end
        
        subgraph "Compute (EKS)"
            subgraph "Application Services"
                PS[Policy Svc]
                BS[Billing Svc]
                CS[Claims Svc]
                UWS[UW Svc]
                COMS[Commission Svc]
                FS[Financial Svc]
                PTS[Party Svc]
                PRODS[Product Svc]
            end
            
            subgraph "Supporting Services"
                CORRS[Correspondence]
                DOCS[Document Svc]
                FUNDS[Fund Svc]
                TAXS[Tax Svc]
                SEARCHS[Search Svc]
            end
        end
        
        subgraph "Serverless"
            LAMBDA[Lambda Functions<br/>Event Handlers]
            SF[Step Functions<br/>Workflows]
        end
        
        subgraph "Messaging"
            MSK[MSK Kafka]
            SQS[SQS Queues]
            EB[EventBridge]
        end
        
        subgraph "Data"
            AURORA[(Aurora PostgreSQL<br/>Policy, Billing, Claims)]
            DYNAMO[(DynamoDB<br/>Product Config)]
            ELASTIC[(OpenSearch<br/>Search Index)]
            REDIS_ARCH[(ElastiCache Redis<br/>Cache)]
            S3_ARCH[(S3<br/>Documents)]
        end
        
        subgraph "Security"
            COGNITO[Cognito<br/>User Auth]
            VAULT_ARCH[Vault<br/>Secrets]
            KMS_ARCH[KMS<br/>Encryption]
        end
        
        subgraph "Observability"
            CW[CloudWatch]
            XRAY[X-Ray]
            PROM_ARCH[Prometheus]
            GRAF[Grafana]
        end
    end
    
    subgraph "DR Region (us-west-2)"
        EKS_DR[EKS (Standby)]
        AURORA_DR[(Aurora Replica)]
        S3_DR[(S3 Replica)]
    end
    
    R53 --> CF --> WAF --> ALB
    ALB --> PS
    ALB --> BS
    APIGW --> LAMBDA
    
    PS --> MSK
    MSK --> BS
    MSK --> COMS
    MSK --> FS
    
    PS --> AURORA
    BS --> AURORA
    CS --> AURORA
    PRODS --> DYNAMO
    SEARCHS --> ELASTIC
    DOCS --> S3_ARCH
    
    AURORA --> AURORA_DR
    S3_ARCH --> S3_DR
```

### 14.2 Multi-Region, Multi-Tenant Deployment

```mermaid
graph TB
    subgraph "Tenant Routing"
        DNS[DNS: carrier-abc.pas.com<br/>carrier-xyz.pas.com]
        GLB[Global Load Balancer]
    end
    
    subgraph "Region: US East"
        subgraph "Shared Infrastructure"
            EKS_E[EKS Cluster]
            MSK_E[MSK Kafka]
        end
        
        subgraph "Tenant: Carrier ABC"
            NS_ABC[Namespace: tenant-abc]
            DB_ABC[(Aurora: carrier_abc schema)]
            S3_ABC[S3: pas-docs-abc/]
        end
        
        subgraph "Tenant: Carrier XYZ"
            NS_XYZ[Namespace: tenant-xyz]
            DB_XYZ[(Aurora: carrier_xyz schema)]
            S3_XYZ[S3: pas-docs-xyz/]
        end
    end
    
    subgraph "Region: US West (DR)"
        EKS_W[EKS Cluster (Standby)]
        DB_DR[(Aurora Replicas)]
    end
    
    DNS --> GLB
    GLB --> EKS_E
    
    EKS_E --> NS_ABC --> DB_ABC
    EKS_E --> NS_XYZ --> DB_XYZ
    
    DB_ABC --> DB_DR
    DB_XYZ --> DB_DR
```

---

## 15. Migration Roadmap

### 15.1 Phased Cloud Adoption

```mermaid
gantt
    title PAS Cloud-Native Migration Roadmap
    dateFormat  YYYY-MM
    
    section Phase 1: Foundation
    Cloud account setup & governance     :2025-01, 3M
    VPC/Network architecture             :2025-02, 2M
    EKS cluster provisioning             :2025-03, 2M
    CI/CD pipeline setup                 :2025-03, 2M
    Security baseline (Vault, KMS, IAM)  :2025-03, 3M
    Observability stack                  :2025-04, 2M
    
    section Phase 2: Pilot Services
    Product Config service (cloud-native) :2025-06, 3M
    Party Service (cloud-native)          :2025-06, 3M
    Document Service (S3-backed)          :2025-07, 2M
    Kafka event bus                       :2025-07, 2M
    
    section Phase 3: Core Services
    Policy Service migration              :2025-09, 4M
    Billing Service migration             :2025-10, 4M
    Claims Service migration              :2025-11, 4M
    Underwriting Service migration        :2026-01, 3M
    
    section Phase 4: Financial Services
    Commission Service                    :2026-02, 3M
    Financial/Accounting Service          :2026-03, 4M
    Reinsurance Service                   :2026-04, 3M
    
    section Phase 5: Optimization
    Multi-tenant enablement               :2026-06, 3M
    DR implementation                     :2026-07, 2M
    Performance optimization              :2026-08, 2M
    FinOps implementation                 :2026-08, 2M
    Legacy decommission                   :2026-09, 3M
```

---

## 16. Conclusion

Cloud-native PAS design represents the future of policy administration technology. The architecture described in this article enables:

- **Elastic scalability** that matches the inherently variable workloads of insurance operations
- **Multi-tenant SaaS delivery** that creates economies of scale while maintaining strict tenant isolation
- **Operational resilience** through multi-region deployment and automated failover
- **Accelerated innovation** through managed services, serverless functions, and modern CI/CD practices
- **Cost optimization** through right-sizing, reserved capacity, and serverless execution

Success requires balancing the benefits of cloud-native patterns with the stringent regulatory and data governance requirements of the insurance industry. Every architectural decision must be evaluated through the lens of:

1. **Regulatory compliance**: Does this pattern meet examination, data residency, and business continuity requirements?
2. **Data protection**: Is sensitive policyholder data protected at every layer?
3. **Operational readiness**: Can the operations team manage this architecture effectively?
4. **Cost sustainability**: Does the total cost of ownership justify the architectural complexity?
5. **Vendor independence**: Can we exit the cloud provider if needed (contractually and technically)?

The reference architecture presented here is a proven pattern used by leading InsurTech firms and progressive carriers. Adapt it to your organization's specific regulatory environment, existing technology landscape, and transformation readiness.

---

*This article is part of the Life Insurance PAS Architect's Encyclopedia. See also: Article 38 (Microservices Architecture), Article 40 (Legacy Modernization Strategies), Article 41 (Security Architecture for PAS).*
