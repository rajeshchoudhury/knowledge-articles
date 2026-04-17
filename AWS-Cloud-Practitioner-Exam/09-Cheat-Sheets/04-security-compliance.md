# Security & Compliance Cheat Sheet

## Shared Responsibility
- AWS: security *OF* the cloud (HW, hypervisor, facilities, managed
  service plane)
- Customer: security *IN* the cloud (IAM config, OS on EC2, app, data,
  client encryption, network config)
- Shared controls: patch mgmt, config mgmt, awareness/training

## IAM decision tree
- Humans doing AWS work → **IAM users** (legacy) or **IAM Identity Center**
- Workloads on AWS → **IAM roles** (no keys on disk)
- Cross-account → **role trust** + `sts:AssumeRole`
- Federated workforce → Identity Center with SAML/OIDC
- App's end-users → **Cognito User Pool**
- Temporary creds always preferred → **STS**

## Policy types
| Type | Attaches to | Purpose |
|---|---|---|
| Identity policy | user/group/role | What principal can do |
| Resource policy | resource | Who can access the resource |
| SCP | OU/account | Caps max permissions (Org) |
| Permissions boundary | user/role | Caps individual principal |
| Session policy | STS session | Further restrict |
| ACL | resource (S3) | Legacy cross-account |

## Data protection
- **KMS** = multi-tenant HSM (FIPS 140-2 L3); symmetric + asymmetric
- **CloudHSM** = single-tenant HSM cluster
- **Secrets Manager** (rotation) vs **SSM Parameter Store** (config + secrets)
- **ACM** = free TLS certs; **ACM PCA** private CA ($400/mo)
- At rest: KMS-backed (S3, EBS, RDS, DDB); in transit: TLS 1.2+

## Network security
| Tool | Where |
|---|---|
| SG (stateful, ENI) | VPC |
| NACL (stateless, subnet) | VPC |
| WAF | CF / ALB / APIGW / AppSync / App Runner / VA / Cognito |
| Shield Standard / Advanced | Global (CF/R53/GA) |
| Network Firewall | VPC egress/east-west |
| DNS Firewall | Route 53 Resolver |
| Firewall Manager | Org-wide orchestration |
| PrivateLink / Interface Endpoints | Private service access |
| Verified Access | Zero-trust app access |

## Detective controls
| Who/what | Service |
|---|---|
| API activity | CloudTrail |
| Resource history | AWS Config |
| Threats (ML) | GuardDuty |
| CVEs (EC2/ECR/Lambda) | Inspector |
| PII in S3 | Macie |
| Unified findings | Security Hub |
| Investigation graph | Detective |

## Governance
| Need | Service |
|---|---|
| Multi-account mgmt | Organizations |
| Opinionated landing zone | Control Tower |
| Approved IaC catalog | Service Catalog |
| AWS compliance reports | Artifact |
| Automated evidence collection | Audit Manager |
| License tracking | License Manager |
| Resource sharing | RAM |

## Compliance acronyms
SOC 1/2/3 • ISO 27001/27017/27018/27701/22301 • PCI-DSS • HIPAA/HITECH •
FedRAMP Mod/High • IL4/5/6 • GDPR • FISMA/NIST 800-53/171 • FIPS 140-2 •
IRAP • C5 • StateRAMP • K-ISMS • MTCS • CSA STAR
