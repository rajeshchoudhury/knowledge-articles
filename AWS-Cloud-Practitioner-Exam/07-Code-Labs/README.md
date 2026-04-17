# Code Labs

Hands-on labs with AWS CLI, SDK, CloudFormation, and Terraform. The CCP
exam does **not** test commands or IaC syntax, but doing these exercises
will cement concepts faster than any amount of reading.

> Required: an AWS account with Free Tier eligibility, an IAM user with
> programmatic access (or IAM Identity Center), AWS CLI v2 installed,
> and (for Terraform labs) Terraform ≥ 1.5.

Labs:

- `01-first-account-and-cli.md` — bootstrap your environment
- `02-iam-lab.md` — users, groups, roles, policies, MFA
- `03-ec2-and-s3-lab.md` — launch EC2, upload objects
- `04-rds-and-dynamodb-lab.md` — managed DBs
- `05-vpc-from-scratch.md` — build a VPC
- `06-serverless-hello-world.md` — Lambda + API Gateway + DynamoDB
- `07-cloudformation-and-terraform.md` — same stack, two IaC flavors
- `08-billing-and-guardrails.md` — Budgets, Cost Explorer, SCPs
