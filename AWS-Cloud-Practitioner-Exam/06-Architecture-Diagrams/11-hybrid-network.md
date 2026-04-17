# Hybrid Network Connectivity

```mermaid
graph LR
  subgraph OnPrem["On-premises Data Center"]
    Core["Core Router"]
    Fw["Firewall"]
    OnUsers["Users / Servers"]
  end

  subgraph AWS["AWS Cloud"]
    DX["Direct Connect<br/>Location"]
    DXGW["DX Gateway"]
    TGW["Transit Gateway"]
    subgraph Accts["Multiple AWS Accounts"]
      VPC1["Dev VPC"]
      VPC2["Stage VPC"]
      VPC3["Prod VPC"]
    end
    S3svc["S3 (Public VIF / Gateway Endpoint)"]
  end

  OnUsers --- Fw --- Core
  Core --"Private / Transit VIF"--> DX
  Core -."Backup IPsec VPN".-> TGW
  DX --> DXGW --> TGW
  TGW --- VPC1 & VPC2 & VPC3
  Core --"Public VIF"--> S3svc
```

**Highlights**
- **Direct Connect** for dedicated bandwidth; use a **VPN backup** over
  the internet for HA.
- **Transit Gateway** hub; attach DX Gateway + VPCs + VPN connections.
- Route 53 **Resolver endpoints** for DNS between on-prem and AWS (not
  shown).
- MACsec at 10/100 Gbps for L2 encryption.
