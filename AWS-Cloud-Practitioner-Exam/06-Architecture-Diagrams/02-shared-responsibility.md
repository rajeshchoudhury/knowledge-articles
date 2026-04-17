# Shared Responsibility Model

```mermaid
graph TB
  subgraph Customer["Customer — Security IN the cloud"]
    C1["Customer Data"]
    C2["Platform, applications, IAM"]
    C3["Operating System, Network & Firewall config"]
    C4["Client-side data encryption + data integrity auth"]
    C5["Server-side encryption (filesystem / data)"]
    C6["Networking traffic protection (encrypt, integrity, identity)"]
  end
  subgraph AWS["AWS — Security OF the cloud"]
    A1["Software"]
    A2["Compute • Storage • Database • Networking"]
    A3["Hardware / Global Infrastructure<br/>Regions • AZs • Edge"]
  end
  Customer --> AWS
```

```
┌───────────────────────────────────────────────────────────────────┐
│                 CUSTOMER — "security IN the cloud"               │
│  • Customer data                                                 │
│  • Platform, applications, IAM                                   │
│  • Operating system, network and firewall configuration          │
│  • Client-side data encryption & integrity                       │
│  • Server-side encryption (filesystem and/or data)                │
│  • Networking traffic protection                                 │
├───────────────────────────────────────────────────────────────────┤
│                    AWS — "security OF the cloud"                 │
│  • Software                                                      │
│  • Compute • Storage • DB • Networking                            │
│  • Hardware / Global Infrastructure                              │
│    Regions • AZs • Edge Locations                                │
└───────────────────────────────────────────────────────────────────┘
```

**Rule of thumb**
- The higher up the abstraction (IaaS → PaaS → SaaS), the more AWS takes on.
- On **EC2**, customer patches the OS. On **RDS**, AWS patches the DB
  engine during your maintenance window.
- Shared controls: patch management, configuration management, awareness
  and training.
