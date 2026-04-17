# Flashcards — Domain 3 (Compute)

Q: What is EC2?
A: Virtual servers (instances) in AWS. #must-know

Q: What's an AMI?
A: Amazon Machine Image — the template for an EC2 instance's boot disk. #must-know

Q: Instance store vs EBS?
A: Instance store is ephemeral local disk; EBS is persistent network block storage. #must-know

Q: 3 classic EC2 families?
A: t (burstable GP), m (general), c (compute), r (memory), plus x/u, i/d/h, p/g/dl/trn/inf, a. #must-know

Q: What are Graviton instance types?
A: AWS Arm-based CPUs (t4g, m7g, c7g, etc.); ~20-40% better price/performance for many workloads. #must-know

Q: What's user data?
A: Script run on EC2's first boot (cloud-init). #must-know

Q: IMDSv2?
A: Secure version of EC2 metadata service using session tokens (protects against SSRF). #must-know

Q: What's an Auto Scaling Group?
A: Maintains desired count of EC2 across AZs; supports scaling policies. #must-know

Q: Target-tracking scaling is?
A: Keep a metric at a target value (e.g., CPU at 50%). #must-know

Q: What is a launch template?
A: Preferred config object for ASG launches (versions, complex config). #must-know

Q: ASG spans Regions?
A: No — only AZs within a Region. #must-know

Q: 4 types of ELB?
A: ALB (L7), NLB (L4), GWLB (L3 GENEVE), Classic (legacy). #must-know

Q: Which ELB supports WAF directly?
A: ALB (also CloudFront, APIGW, etc.). NLB does not. #must-know

Q: Which ELB preserves client source IP by default?
A: NLB. ALB uses X-Forwarded-For. #must-know

Q: What is AWS Lambda?
A: Serverless function-as-a-service; event-driven. #must-know

Q: Lambda max timeout?
A: 15 minutes. #must-know

Q: Lambda max memory?
A: 10 GB. #must-know

Q: Lambda ephemeral /tmp size?
A: 512 MB default, configurable up to 10 GB. #must-know

Q: Lambda pricing model?
A: Requests + GB-second of compute time. #must-know

Q: What is Lambda Provisioned Concurrency?
A: Pre-initialized execution environments to avoid cold starts. #must-know

Q: What is SnapStart?
A: Faster Java Lambda cold starts using pre-initialized snapshots. #must-know

Q: Fargate?
A: Serverless compute engine for containers (ECS, EKS). #must-know

Q: ECS vs EKS?
A: ECS = AWS-native container orchestration; EKS = managed Kubernetes. #must-know

Q: Which is typically simpler/cheaper to operate?
A: ECS. #must-know

Q: EKS control-plane cost?
A: $0.10/hour per cluster + data plane. #must-know

Q: What's an ECR?
A: Elastic Container Registry — private/public container images. #must-know

Q: What's Elastic Beanstalk?
A: Managed PaaS that deploys your app to ELB/ASG/EC2 automatically. #must-know

Q: Can you SSH into EC2 running Beanstalk workload?
A: Yes. #must-know

Q: What is App Runner?
A: Fully managed service to deploy a web app or API from source repo or container image with zero config. #must-know

Q: What is Lightsail?
A: Simple VPS + managed DB + CDN + containers with flat monthly pricing. #must-know

Q: What is AWS Batch?
A: Managed batch job orchestration across EC2/Fargate/Spot. #must-know

Q: Best EC2 purchase option for spiky, interruption-tolerant workloads?
A: Spot. #must-know

Q: Max Spot discount?
A: Up to 90%. #must-know

Q: Max RI Standard 3-year discount?
A: Up to 72%. #must-know

Q: Best option for baseline 24/7 compute across EC2/Lambda/Fargate?
A: Compute Savings Plan. #must-know

Q: Best option for baseline 24/7 compute locked to one instance family?
A: EC2 Instance Savings Plan (best discount within a family). #must-know

Q: Dedicated Host vs Dedicated Instance?
A: Host gives you physical-host visibility for BYOL; Instance isolates tenancy without host control. #must-know

Q: What does Capacity Reservation do?
A: Reserves physical capacity in an AZ; no discount by itself. #must-know

Q: What's a typical use for Dedicated Hosts?
A: BYOL licensing (Windows, SQL Server, Oracle), compliance requiring dedicated hardware. #must-know

Q: Which service automatically orchestrates spot + on-demand mix?
A: EC2 Auto Scaling / Spot Fleet / ASG mixed-instance policies. #must-know

Q: Which compute option is best for 10,000 inbound HTTPS req/s with bursty traffic (web)?
A: EC2 behind ALB with ASG; or Lambda + APIGW; or Fargate + ALB depending on pattern. #scenario

Q: Which compute option to run a Dockerfile without managing infra?
A: App Runner. #must-know

Q: Which managed service auto-builds ELB+ASG+EC2 from my .war or .zip?
A: Elastic Beanstalk. #must-know

Q: Outposts allow you to run what AWS services on-prem?
A: EC2, EBS, S3 on Outposts, ECS, EKS, RDS, EMR, ALB, Direct Connect termination. #must-know

Q: What runs AWS natively inside telco 5G networks?
A: AWS Wavelength. #must-know

Q: What gives sub-10-ms latency in large metros?
A: AWS Local Zones. #must-know

Q: VMware workloads can be moved to AWS via?
A: VMware Cloud on AWS (Relocate strategy). #must-know

Q: Typical workload for HPC/ML on AWS?
A: EC2 hpc/p/g families + FSx for Lustre + Placement Groups (cluster). #must-know

Q: Placement Group types?
A: Cluster, Partition, Spread. #must-know
