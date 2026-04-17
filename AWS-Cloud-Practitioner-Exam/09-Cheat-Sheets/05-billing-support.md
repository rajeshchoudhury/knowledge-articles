# Billing, Pricing & Support Cheat Sheet

## Pricing fundamentals
- Pay-as-you-go • Pay-less-by-using-more • Pay-less-with-commitment
- Compute per-second (Linux) or hour (Windows)
- Data **IN** is free • Between AZs **charged** • Out to internet **charged**
- Prices vary by Region

## Free Tier — 3 types
- Always-free (e.g., Lambda 1M req/mo, DDB 25 GB)
- 12-month free (EC2 t2.micro 750h/mo, S3 Std 5 GB)
- Trials (SageMaker Studio 2 mo, Lightsail 3 mo)

## Purchase option cheat
- **On-Demand** — 0% discount, no commit, per-second
- **RI Standard 1/3y** — ≤72%, locked
- **RI Convertible** — ≤54%, changeable
- **Compute SP** — ≤66%, flexible (incl. Lambda/Fargate/SM)
- **EC2 Instance SP** — ≤72%, locked family/Region
- **SageMaker SP** — ≤64%
- **Spot** — ≤90%, interruptible
- **Dedicated Host** — BYOL, physical host
- **Dedicated Instance** — HW isolation, less visibility than Host
- **Capacity Reservation** — capacity but not price

## Cost management tools
| Goal | Tool |
|---|---|
| Pre-deploy estimate | Pricing Calculator |
| Post-hoc analysis + forecast | Cost Explorer |
| Alert on budget | AWS Budgets (+ Budget Actions) |
| Hourly granular data for BI | Cost and Usage Report (CUR) |
| ML anomaly detection | Cost Anomaly Detection |
| Right-size EC2/EBS/Lambda/ECS | Compute Optimizer |
| Chargeback / reseller pro-forma | Billing Conductor |
| Best-practice + cost checks | Trusted Advisor |

## Organizations
- Free
- Consolidated billing
- Volume aggregation
- RI/SP sharing across accounts (toggle per account)
- SCPs (not for root)
- Tag / AI opt-out / backup policies

## Support plans
| Plan | 24×7 phone | Full TA | 3rd-party SW | TAM | WAR | Concierge | IEM | Crit SLA |
|---|---|---|---|---|---|---|---|---|
| Basic | — | — | — | — | — | — | — | — |
| Developer | — | — | — | — | — | — | — | — |
| Business | ✓ | ✓ | ✓ | — | — | — | add-on | 1 h urgent |
| Enterprise On-Ramp | ✓ | ✓ | ✓ | pool | ✓ | ✓ | ✓ | 30 min |
| Enterprise | ✓ | ✓ | ✓ | dedicated | ✓ | ✓ | ✓ | 15 min |

## Partner programs
- **APN Services Partners** (ex-Consulting) — SIs, MSPs, VARs
- **APN Technology Partners** — ISVs
- **Competencies** — industry/workload specializations
- **MSP Program** — validated managed service providers
- **AWS IQ** — freelance marketplace
- **AWS Managed Services (AMS)** — AWS ops your cloud
- **AWS Professional Services** — AWS consultants
- **AWS Marketplace** — 3rd-party SW billed on your AWS invoice
