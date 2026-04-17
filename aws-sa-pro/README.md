# AWS Certified Solutions Architect - Professional (SAP-C02) Complete Study Guide

## Exam Overview

| Detail | Information |
|--------|-------------|
| **Exam Code** | SAP-C02 |
| **Duration** | 180 minutes |
| **Questions** | 75 (multiple choice & multiple response) |
| **Passing Score** | 750/1000 |
| **Cost** | $300 USD |
| **Validity** | 3 years |
| **Prerequisite** | Recommended: Associate-level certification + 2+ years hands-on |

## Exam Domains & Weightings

| Domain | Weight | Description |
|--------|--------|-------------|
| **Domain 1** | 26% | Design Solutions for Organizational Complexity |
| **Domain 2** | 29% | Design for New Solutions |
| **Domain 3** | 15% | Continuous Improvement for Existing Solutions |
| **Domain 4** | 12% | Accelerate Workload Migration and Modernization |
| **Domain 5** | 18% | Cost-Optimized Architectures |

## Repository Structure

```
aws-sa-pro/
├── README.md                           ← You are here
├── study-plan/
│   └── 30-day-study-plan.md           ← Day-by-day study schedule
│
├── domain-1-organizational-complexity/
│   ├── 01-multi-account-strategies.md
│   ├── 02-aws-organizations-deep-dive.md
│   ├── 03-cross-account-access-patterns.md
│   ├── 04-networking-connectivity.md
│   ├── 05-hybrid-dns-and-directory.md
│   ├── 06-identity-federation.md
│   └── 07-governance-and-compliance.md
│
├── domain-2-design-new-solutions/
│   ├── 01-compute-solutions.md
│   ├── 02-storage-architecture.md
│   ├── 03-database-strategies.md
│   ├── 04-networking-deep-dive.md
│   ├── 05-serverless-architecture.md
│   ├── 06-containers-and-orchestration.md
│   ├── 07-application-integration.md
│   ├── 08-analytics-and-big-data.md
│   ├── 09-machine-learning-services.md
│   └── 10-security-architecture.md
│
├── domain-3-migration-planning/
│   ├── 01-migration-strategies.md
│   ├── 02-aws-migration-tools.md
│   ├── 03-database-migration.md
│   ├── 04-application-modernization.md
│   └── 05-hybrid-architectures.md
│
├── domain-4-cost-control/
│   ├── 01-pricing-models-deep-dive.md
│   ├── 02-cost-optimization-strategies.md
│   ├── 03-cost-governance.md
│   └── 04-right-sizing-and-reserved.md
│
├── domain-5-continuous-improvement/
│   ├── 01-operational-excellence.md
│   ├── 02-monitoring-and-observability.md
│   ├── 03-disaster-recovery.md
│   ├── 04-automation-and-cicd.md
│   └── 05-performance-optimization.md
│
├── flash-cards/
│   ├── domain-1-flash-cards.md
│   ├── domain-2-flash-cards.md
│   ├── domain-3-flash-cards.md
│   ├── domain-4-flash-cards.md
│   └── domain-5-flash-cards.md
│
├── architecture-diagrams/
│   ├── multi-account-topology.md
│   ├── hybrid-connectivity.md
│   ├── disaster-recovery-patterns.md
│   ├── serverless-patterns.md
│   ├── data-lake-architecture.md
│   └── microservices-patterns.md
│
├── code-examples/
│   ├── cloudformation/
│   ├── terraform/
│   ├── python-boto3/
│   └── cli-scripts/
│
├── cheat-sheets/
│   ├── services-comparison.md
│   ├── networking-cheat-sheet.md
│   ├── security-cheat-sheet.md
│   ├── database-cheat-sheet.md
│   ├── storage-cheat-sheet.md
│   └── limits-and-quotas.md
│
└── practice-tests/
    ├── test-01.md through test-50.md  ← 50 full practice tests (75 questions each)
    └── answer-explanations/
```

## How to Use This Guide

### For 30-Day Preparation
1. Follow the `study-plan/30-day-study-plan.md` exactly
2. Read domain articles in order
3. Review flash cards daily
4. Take practice tests starting Week 2
5. Focus on weak areas identified by practice tests

### For Quick Review (1 Week)
1. Read all cheat sheets
2. Review flash cards
3. Take practice tests 1-10
4. Deep-dive into weak domains

### Key Exam Tips
- **Time management**: ~2.4 minutes per question. Flag difficult ones and return.
- **Elimination**: Remove obviously wrong answers first.
- **Key phrases**: "MOST cost-effective", "LEAST operational overhead", "BEST" — these indicate trade-offs.
- **Multi-account**: Many questions involve cross-account scenarios.
- **Always consider**: Security, scalability, cost, and operational complexity.
- **Read ALL options**: The best answer might not be the first one that seems right.
- **Scenario length**: Expect long, detailed scenarios. Extract key requirements first.

## Services You MUST Know Cold

### Tier 1 (Appears in 80%+ of questions)
- VPC, Subnets, Route Tables, NACLs, Security Groups
- IAM, STS, Organizations, Control Tower, SSO/Identity Center
- EC2, Auto Scaling, ELB (ALB/NLB/GWLB)
- S3, EBS, EFS, FSx
- RDS, Aurora, DynamoDB, ElastiCache
- Lambda, API Gateway, Step Functions
- CloudFormation, CloudWatch, CloudTrail
- Route 53, CloudFront
- Direct Connect, VPN, Transit Gateway

### Tier 2 (Appears in 40-80% of questions)
- ECS, EKS, Fargate
- Kinesis, SQS, SNS, EventBridge
- Redshift, Athena, Glue, EMR
- Secrets Manager, KMS, ACM
- Config, Systems Manager, Service Catalog
- Migration Hub, DMS, SCT, MGN
- Storage Gateway, DataSync, Transfer Family

### Tier 3 (Appears in 10-40% of questions)
- AppSync, Cognito, Amplify
- SageMaker, Comprehend, Rekognition
- GuardDuty, Inspector, Macie, Security Hub
- Backup, Elastic Disaster Recovery
- Global Accelerator, PrivateLink
- Lake Formation, Data Pipeline
- CodePipeline, CodeBuild, CodeDeploy
