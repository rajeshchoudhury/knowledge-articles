# AWS Global Infrastructure

```mermaid
graph TB
  subgraph Global["AWS Global Backbone"]
    subgraph R1["Region: us-east-1 (N. Virginia)"]
      direction LR
      AZ1a["AZ: use1-az1<br/>Data Centers"]
      AZ1b["AZ: use1-az2<br/>Data Centers"]
      AZ1c["AZ: use1-az3<br/>Data Centers"]
    end
    subgraph R2["Region: eu-west-1 (Ireland)"]
      direction LR
      AZ2a["AZ: euw1-az1"]
      AZ2b["AZ: euw1-az2"]
      AZ2c["AZ: euw1-az3"]
    end
    EDGE["600+ Edge Locations<br/>(CloudFront, Route 53, Global Accelerator, WAF, Shield)"]
    RED["Regional Edge Caches (~13)"]
    LZ["Local Zones<br/>(LA, Miami, Boston, ...)"]
    WL["Wavelength Zones<br/>(in 5G telco networks)"]
    OP["AWS Outposts<br/>(customer DC)"]
  end

  R1 --- EDGE
  R2 --- EDGE
  EDGE --- RED
  R1 --- LZ
  R1 --- WL
  R1 --- OP
```

```
┌───────────────────────── AWS Global Backbone ─────────────────────────┐
│                                                                       │
│  ┌────── Region us-east-1 ──────┐   ┌────── Region eu-west-1 ──────┐  │
│  │  AZ1   AZ2   AZ3             │   │  AZ1   AZ2   AZ3             │  │
│  │  [DC1] [DC2] [DC3]           │   │  [DC1] [DC2] [DC3]           │  │
│  └──────────────────────────────┘   └──────────────────────────────┘  │
│                                                                       │
│  Edge Locations (600+) ─┬─ CloudFront                                 │
│                         ├─ Route 53                                   │
│                         ├─ Global Accelerator                         │
│                         └─ WAF / Shield                               │
│                                                                       │
│  Local Zones • Wavelength • Outposts (hybrid)                          │
└───────────────────────────────────────────────────────────────────────┘
```

**Key takeaways**
- A **Region** contains ≥ 3 **AZs**.
- An **AZ** is one or more data centers with independent power, cooling,
  and networking.
- **Edge Locations** power CloudFront/Route 53/Global Accelerator/WAF.
- **Local Zones** = metro edges; **Wavelength** = 5G edges;
  **Outposts** = AWS hardware in customer DC.
