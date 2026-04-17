# Serverless Web Application

```mermaid
graph LR
  Users((Users)) --> CF["CloudFront<br/>+ WAF"]
  CF --> S3["S3 bucket<br/>(static site)"]
  CF --> APIG["API Gateway<br/>(HTTP or REST)"]
  APIG --> Lambda["AWS Lambda functions"]
  Lambda --> DDB[(DynamoDB<br/>PITR + Streams)]
  Lambda --> SQS[(SQS Queue)]
  Lambda --> SNS[(SNS Topic)]
  Lambda --> Secrets[(Secrets Manager / KMS)]
  Lambda --> CW[(CloudWatch Logs / X-Ray)]
  Cog["Cognito User Pool"] -. authenticates .-> APIG
  EB["EventBridge rules"] -. schedule .-> Lambda
```

**Serverless characteristics**
- No servers to patch. Scale to zero. Pay per request.
- **Cognito** adds authn; JWT flows to API Gateway authorizers.
- **DynamoDB** for KV/document state. Lambda triggers via Streams.
- **SQS / SNS / EventBridge** for async decoupling.
- **CloudWatch + X-Ray** for observability.
- Add **Step Functions** if workflow spans many Lambdas with retries.
