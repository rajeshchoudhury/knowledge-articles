# Architecture Diagrams

Each file contains one or more diagrams in **Mermaid** (renders on GitHub,
VS Code with Mermaid plugin, and any Mermaid viewer) plus an ASCII
fallback. These map to scenarios tested on CLF-C02.

Files:

- `01-global-infrastructure.md` — Region → AZ → Data Center + Edge/Local/
  Wavelength/Outposts hierarchy.
- `02-shared-responsibility.md` — Shared Responsibility Model.
- `03-iam-and-sts.md` — IAM roles, STS, federation, cross-account access.
- `04-vpc-classic.md` — Public/private subnets, IGW, NAT, endpoints, SGs.
- `05-high-availability.md` — Multi-AZ ALB + ASG + RDS Multi-AZ.
- `06-disaster-recovery.md` — 4 DR strategies side by side.
- `07-serverless-webapp.md` — CloudFront + S3 + API Gateway + Lambda +
  DynamoDB.
- `08-three-tier-webapp.md` — Classic web/app/DB on EC2.
- `09-event-driven.md` — SNS, SQS, EventBridge, Step Functions patterns.
- `10-data-lake.md` — S3 + Glue + Athena + Redshift + QuickSight.
- `11-hybrid-network.md` — DX + VPN + TGW + on-prem.
- `12-org-landing-zone.md` — Organizations + Control Tower + SCPs.
- `13-cicd.md` — CodePipeline / CodeBuild / CodeDeploy.
- `14-ml-pipeline.md` — SageMaker + S3 + data pipeline.
- `15-genai-rag.md` — Bedrock + Knowledge Base + OpenSearch.
