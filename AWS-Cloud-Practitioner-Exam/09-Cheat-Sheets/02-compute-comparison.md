# Compute Comparison

| Need | Service | Why |
|---|---|---|
| OS control, custom kernel | **EC2** | Full VM; many purchase options |
| Containers without nodes | **Fargate** | Serverless containers |
| K8s workloads | **EKS** | Managed Kubernetes |
| AWS-native container orchestration | **ECS** | Simpler than EKS |
| Event functions ≤ 15 min | **Lambda** | Auto-scale, pay per invocation |
| Web app / API from source or image | **App Runner** | Zero-config hosting |
| Quick PaaS with access to servers | **Elastic Beanstalk** | Code push, AWS builds ELB+ASG+EC2 |
| Flat-rate hobby/SMB workloads | **Lightsail** | $3.50+/mo VPS + DB + CDN |
| Batch / HPC jobs | **AWS Batch** | Managed job queues on EC2/Fargate |
| On-prem with AWS APIs | **Outposts** | AWS rack in your DC |
| Metro <10 ms latency | **Local Zones** | |
| 5G carrier edge | **Wavelength Zones** | |

## EC2 purchasing options

| Option | Commit | Discount | When |
|---|---|---|---|
| On-Demand | — | 0% | Short / unpredictable |
| RI Standard 1/3y | 1/3y | ≤72% | Stable, same instance |
| RI Convertible | 1/3y | ≤54% | Stable, may change family |
| Compute Savings Plan | 1/3y | ≤66% | Flex EC2/Lambda/Fargate/SageMaker |
| EC2 Instance SP | 1/3y | ≤72% | Locked family/Region |
| Spot | — | ≤90% | Interrupt-tolerant |
| Dedicated Host | OD/RI/SP | $/host | BYOL, compliance |
| Dedicated Instances | OD/RI | +$ | Tenancy isolation |
| Capacity Reservation | — | 0% | Reserve capacity, not price |

## ELB comparison

| Type | Layer | Protocols | Use |
|---|---|---|---|
| ALB | 7 | HTTP/HTTPS/gRPC/WS | Microservices, path/host routing, WAF integration |
| NLB | 4 | TCP/UDP/TLS | Extreme perf, static IPs, PrivateLink |
| GWLB | 3 (GENEVE) | — | Insert 3rd-party appliances |
| CLB | 4/7 | HTTP/TCP | Legacy; avoid |
