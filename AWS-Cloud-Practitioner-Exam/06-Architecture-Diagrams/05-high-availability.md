# High Availability — Multi-AZ Web Tier

```mermaid
graph TB
  Users((Users))
  R53["Route 53"]
  CF["CloudFront<br/>+ WAF + Shield"]
  Users --> R53 --> CF
  CF --> ALB["Application Load Balancer<br/>(multi-AZ)"]
  subgraph ASG["Auto Scaling Group"]
    direction LR
    EC2a["EC2 AZ a"]
    EC2b["EC2 AZ b"]
    EC2c["EC2 AZ c"]
  end
  ALB --> ASG
  ASG --> RDS[("RDS Multi-AZ Primary<br/>(sync standby in 2nd AZ)")]
  ASG --> Cache[("ElastiCache (Redis/Valkey) cluster")]
  ASG --> S3[("S3 assets + logs")]
  CW["CloudWatch Metrics / Alarms / Logs"] -. observability .-> ASG
```

**Why this is HA**
- DNS → CDN → ALB → ASG → RDS Multi-AZ. Any single AZ failure is
  tolerated.
- ASG replaces failed EC2 and scales based on CloudWatch alarms.
- RDS Multi-AZ provides synchronous standby for automated failover.
- ElastiCache replicates across AZs for cache HA.
- S3 is Regional (multi-AZ) by default.

**How to upgrade to DR (multi-Region)**
- Replicate S3 (CRR), Aurora (Global DB), DynamoDB (Global Tables).
- Use Route 53 Failover or Latency routing.
- Use AWS Backup cross-Region copy.
- Consider Global Accelerator for fast failover (TCP/UDP).
