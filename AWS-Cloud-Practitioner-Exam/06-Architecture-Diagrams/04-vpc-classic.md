# VPC — Classic Public/Private Layout

```mermaid
graph TB
  Internet((Internet))
  IGW["Internet Gateway"]
  Internet --- IGW
  subgraph VPC["VPC 10.0.0.0/16"]
    subgraph AZa["AZ a"]
      PubA["Public Subnet<br/>10.0.1.0/24<br/>ALB, NAT GW"]
      PrivA["Private Subnet<br/>10.0.11.0/24<br/>EC2 / EKS / ECS"]
      DBA["DB Subnet<br/>10.0.21.0/24<br/>RDS (Multi-AZ primary)"]
    end
    subgraph AZb["AZ b"]
      PubB["Public Subnet<br/>10.0.2.0/24<br/>ALB, NAT GW"]
      PrivB["Private Subnet<br/>10.0.12.0/24<br/>EC2 / EKS / ECS"]
      DBB["DB Subnet<br/>10.0.22.0/24<br/>RDS (Multi-AZ standby)"]
    end
    VpcEndpoint["VPC Endpoints<br/>(S3 Gateway, DDB Gateway,<br/>KMS, Secrets Mgr, ECR, STS)"]
  end
  IGW --- PubA & PubB
  PubA -. NAT .-> PrivA
  PubB -. NAT .-> PrivB
  PrivA --- DBA
  PrivB --- DBB
  PrivA --- VpcEndpoint
  PrivB --- VpcEndpoint
```

**Design rules**
- Put **ALB** and **NAT Gateways** in **public subnets** (one per AZ for
  HA).
- Put **compute** (EC2, ECS, EKS, Lambda ENIs) in **private subnets**.
- Put **RDS/Aurora** in a **DB subnet group** spanning ≥ 2 AZs.
- Add **VPC Endpoints** for S3/DDB (Gateway) and KMS/Secrets/ECR/STS
  (Interface) to keep traffic off the public internet.
- Use **Security Groups** between tiers (e.g., DB SG allows only from
  App SG).
