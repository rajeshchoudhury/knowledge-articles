# IAM, STS, Federation, Cross-Account

```mermaid
graph LR
  Human["Human user<br/>(IAM user / Identity Center)"] --> Console["AWS Console / CLI"]
  App["Application<br/>(on EC2 / Lambda / ECS)"] --> STS["AWS STS"]
  STS --> Role1["IAM Role"]
  Role1 --> Resources["AWS Resources<br/>(S3, DynamoDB, SQS, ...)"]
  SAML["External IdP<br/>(Okta / Azure AD)"] -. SAML 2.0 .-> IC["IAM Identity Center"]
  IC --> PermSet["Permission Set"] --> Role1
  OIDC["OIDC IdP<br/>(GitHub Actions, Cognito)"] -. OIDC .-> STS
  ExternalAccount["Another AWS Account"] -. AssumeRole .-> STS
```

**Key patterns**
- **Application on EC2** never uses access keys; it uses an **instance
  profile / IAM role** and calls STS under the hood.
- **Human workforce users** should use **IAM Identity Center** with SAML
  or SCIM from the corporate IdP.
- **App end-users** use **Cognito** (not shown here).
- **Cross-account access** uses `sts:AssumeRole` on a role trusted by
  the other account.
- **GitHub Actions / CI** use **OIDC federation** to a role (no
  long-lived keys).
