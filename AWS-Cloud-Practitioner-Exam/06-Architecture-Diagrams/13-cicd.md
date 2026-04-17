# CI/CD on AWS

```mermaid
graph LR
  Dev["Developer"] --> Git[("Git repo<br/>(GitHub, GitLab, CodeCommit)")]
  Git --> Pipeline["CodePipeline"]
  Pipeline --> Build["CodeBuild<br/>(tests, build, push image)"]
  Build --> ECR[("ECR / S3 artifact")]
  Pipeline --> Deploy["CodeDeploy<br/>(EC2, ECS, Lambda)"]
  Deploy --> Prod["Target<br/>(EC2 fleet / ECS service / Lambda)"]
  Quality["CodeGuru / Q Developer / X-Ray"] -. insights .-> Build
  CFN["CloudFormation / CDK stacks"] -. apply .-> Prod
```

**Principles**
- Trigger pipeline on Git push.
- **CodeBuild** creates immutable artifacts.
- **CodeDeploy** supports canary, linear, all-at-once deployment.
- **CloudFormation / CDK / Terraform** applied through an IaC stage.
- Pipelines can have **manual approval** gates.
- Use **multi-account pipelines** (e.g., deploy from Tools → Stage →
  Prod accounts).
