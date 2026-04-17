# AWS Organizations & Control Tower Landing Zone

```mermaid
graph TB
  Root["Management (Payer) Account"]
  Root --> OUSec["Security OU"]
  Root --> OUInf["Infrastructure OU"]
  Root --> OUSand["Sandbox OU"]
  Root --> OUWrk["Workloads OU"]

  OUSec --> LogAcct["Log Archive Account<br/>(aggregates CloudTrail, Config)"]
  OUSec --> SecAcct["Audit / Security Tooling Account<br/>(GuardDuty, Security Hub, Inspector admin)"]
  OUInf --> NetAcct["Network Account<br/>(TGW, VPNs, DX)"]
  OUInf --> SharedAcct["Shared Services<br/>(AD, Monitoring, CI/CD)"]
  OUWrk --> ProdA["Prod Account A"]
  OUWrk --> ProdB["Prod Account B"]
  OUSand --> DevAcct["Developer sandbox accounts"]

  SCPs[["SCPs (guardrails)"]] -. enforce .-> OUSec
  SCPs -. enforce .-> OUWrk
  SCPs -. enforce .-> OUSand
  IdentityCenter["IAM Identity Center"] -. provisions roles into all accounts .-> Root
```

**Landing Zone patterns**
- Separate **Log Archive** and **Audit** accounts never used for
  workloads. They receive org-wide CloudTrail and Config.
- Dedicated **Network** account for Transit Gateway, VPC sharing (RAM),
  central egress.
- **Identity Center** centralizes SSO across the org.
- **SCPs** enforce preventive guardrails (e.g., "no leaving an approved
  Region list", "no deleting CloudTrail").
- **Control Tower** sets most of this up in a day with a console wizard.
