# Classic 3-Tier Web Application on AWS

```mermaid
graph TB
  Users((Users)) --> R53["Route 53"]
  R53 --> CF["CloudFront<br/>+ WAF + Shield"]
  CF --> ALB["Application Load Balancer"]
  subgraph WebTier["Web Tier (public-ish via ALB)"]
    Web1["EC2 / container (nginx)"]
    Web2["EC2 / container"]
  end
  subgraph AppTier["App Tier (private subnets)"]
    App1["EC2 / container (Java/Node)"]
    App2["EC2 / container"]
  end
  subgraph DataTier["Data Tier"]
    RDS[(RDS Multi-AZ primary)]
    Replica[(Read Replica)]
    Cache[(ElastiCache)]
  end
  ALB --> WebTier --> AppTier --> RDS
  AppTier --> Cache
  AppTier --> Replica
  Assets[(S3 static assets)] --> CF
```

**Notes**
- Static content on S3 behind CloudFront; dynamic through ALB/ASG.
- App tier connects to DB via the private subnet route.
- Cache reduces DB load for hot reads.
- Replace EC2 tiers with Fargate/ECS or Lambda to move toward
  serverless.
