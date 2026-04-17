# Global Infrastructure Cheat Sheet

| Term | Definition |
|---|---|
| **Region** | Geographic area with ≥ 3 AZs; isolated for fault containment; data residency boundary |
| **Availability Zone** | One or more physical data centers with independent power, cooling, network |
| **Edge Location** | 600+ CloudFront/Route 53/Global Accelerator PoPs |
| **Regional Edge Cache** | Larger CloudFront tier between Origin and Edge |
| **Local Zone** | AWS extension near metros for single-digit-ms latency |
| **Wavelength Zone** | AWS inside 5G telco networks |
| **Outposts** | AWS racks in customer DC (hybrid) |
| **GovCloud / China / Secret / Top Secret** | Isolated partitions; separate credentials |
| **Dedicated Local Zone / AWS Region** | Customer-specific isolated zones/Regions |

## Choosing a Region — 4 factors
Compliance/data residency • Latency to users • Service availability •
Pricing

## Service scope
- **Global:** IAM, Route 53, CloudFront, WAF, Shield, Organizations,
  Artifact
- **Regional:** S3 (bucket), EC2, RDS, Lambda, VPC, KMS, DynamoDB
- **AZ-scoped:** EC2 instance, EBS volume, RDS single-AZ
