# Compute Services — Deep Dive

Each service card follows the same template:

- **What it is** — one-sentence definition
- **Best for** — the one or two sentences you'd use on the exam
- **Key features** — bullet list
- **Pricing model** — how you're charged
- **Gotchas** — common exam traps
- **Compare with** — the other services often confused with this one

---

## Amazon EC2 (Elastic Compute Cloud)

- **What it is:** Virtual servers (instances) in the AWS cloud, available
  in a wide catalog of instance types, sizes, and architectures.
- **Best for:** Full control over OS and runtime; lift-and-shift
  migrations; custom kernels, drivers, and networking; workloads needing
  GPUs or specialty CPUs (Graviton, Inferentia, Trainium).
- **Key features:**
  - Hundreds of instance types across families (`t`, `m`, `c`, `r`, `x`,
    `u`, `i`, `d`, `h`, `p`, `g`, `inf`, `trn`, `dl`, `a`, `hpc`).
  - Multiple purchase options (On-Demand, Reserved, Savings Plans, Spot,
    Dedicated Hosts/Instances, Capacity Reservations).
  - Integrates with EBS for persistent storage and Instance Store for
    ephemeral.
  - Elastic IPs, ENIs, SGs for networking.
  - Auto Scaling for elasticity.
  - AMIs (Amazon Machine Images) define the boot disk.
  - User data + metadata service (IMDSv2) for bootstrap.
- **Pricing:** Per second (Linux with 60-second min) / per hour (Windows
  and most commercial OS); plus EBS, data transfer, EIPs (when unused
  or public IPv4 always).
- **Gotchas:**
  - Default tenancy is "shared"; "dedicated" costs more.
  - Stopping an instance does **not** release the instance store; use
    termination or `hibernation`.
  - Public IPv4 now charged $0.005/hr **always** (since Feb 2024).
  - M5 vs M6i vs M6g: `g` = Graviton (Arm). Silicon type affects AMI.
- **Compare with:** Fargate (no servers), Lightsail (simpler VPS), App
  Runner (fully managed web apps).

---

## EC2 Auto Scaling

- **What it is:** Automatic scaling of EC2 instances based on demand.
- **Best for:** Stateless horizontally scalable web/app tiers.
- **Key features:**
  - **Launch templates** (preferred) or launch configurations.
  - **Desired / min / max** capacity.
  - Scaling policies: target tracking (easiest), step scaling, simple
    scaling, predictive scaling (ML forecasts).
  - Scheduled scaling.
  - Health checks via EC2 or ELB; replace unhealthy.
  - **Warm pools** to pre-initialize instances.
  - **Lifecycle hooks** for customization on launch/terminate.
- **Pricing:** Free; pay only for the EC2/ELB/CW underneath.
- **Gotchas:**
  - ASG does not span Regions; only AZs within one Region.
  - If min = max, ASG only replaces failed instances (no elasticity).
- **Compare with:** ECS service autoscaling, Lambda concurrency,
  App Runner autoscaling.

---

## Elastic Load Balancing (ELB)

- **What it is:** Layer-4/7 distribution of inbound traffic across
  backend targets.
- **Types:**
  - **Application LB (ALB)** — HTTP/HTTPS/gRPC/WebSockets; advanced
    routing (host, path, header, method, query string); sticky sessions;
    WAF; user auth via Cognito / OIDC; targets EC2, ECS, Lambda, IPs.
  - **Network LB (NLB)** — TCP/UDP/TLS at L4; ultra-low latency;
    millions of requests/sec; static IP per AZ; PrivateLink provider;
    targets EC2, IPs, ALB.
  - **Gateway LB (GWLB)** — L3 transparent; inserts 3rd-party virtual
    appliances (firewalls, IDS/IPS) into traffic flow via GENEVE.
  - **Classic LB (CLB)** — legacy; avoid for new workloads.
- **Pricing:** Per hour + per LCU (Load Balancer Capacity Unit). LCU is
  the highest of connection, throughput, or rule-evaluation dimensions.
- **Gotchas:**
  - ALB supports WAF; NLB does not directly (attach WAF to a fronting
    ALB or CloudFront).
  - NLB preserves source IP; ALB uses `X-Forwarded-For`.
  - GWLB requires GENEVE; appliances must support it.
- **Compare with:** CloudFront (global caching), API Gateway (API
  management), Global Accelerator (static anycast IPs, TCP/UDP).

---

## AWS Lambda

- **What it is:** Serverless compute for event-driven functions.
- **Best for:** API back-ends, event handlers, data processing, cron jobs,
  webhooks; anything < 15 min.
- **Key features:**
  - Supported runtimes: Node.js, Python, Java, Go, Ruby, .NET, custom
    runtimes via Runtime API, or **container images** (up to 10 GB).
  - Up to **15 minutes** timeout; **10 GB** memory; 6 vCPU; 10 GB `/tmp`.
  - EFS mount; VPC attach.
  - **Event sources**: API Gateway, ALB, SQS, SNS, EventBridge,
    DynamoDB Streams, Kinesis, S3 notifications, MSK, IoT, Cognito,
    MQ, scheduled events, Lambda URL (HTTPS), + 100+ others.
  - **Concurrency controls** — reserved and provisioned concurrency.
  - **SnapStart** — faster cold starts for Java.
  - **Lambda Layers** — share code / deps across functions.
  - **Lambda@Edge** + **CloudFront Functions** for edge logic.
- **Pricing:** Per request ($0.20 / M) + per GB-second + optional
  provisioned concurrency. First 1 M requests and 400 K GB-s **always
  free**.
- **Gotchas:**
  - Max runtime is 15 min. For longer, use Fargate, ECS, or Step
    Functions with state machines.
  - Cold starts for VPC-attached, Java, or large packages.
  - Payload limits: 6 MB sync, 256 KB async event.
  - Don't use Lambda for heavy persistent connections; use Fargate.
- **Compare with:** Fargate (long-running containers), Step Functions
  (orchestration), App Runner (web apps).

---

## AWS Fargate

- **What it is:** Serverless compute engine for containers (ECS and EKS).
- **Best for:** Containers without managing EC2 nodes.
- **Key features:**
  - Works under **ECS** (simpler) and **EKS** (Kubernetes).
  - Pay per vCPU-second and GB-second.
  - Integrates with ALB/NLB, Cloud Map, App Mesh, IAM, Secrets Manager,
    CloudWatch.
  - Graviton (Arm) Fargate up to 20% cheaper.
- **Pricing:** vCPU-second + memory-second + storage-second.
- **Gotchas:**
  - No daemonset support in EKS Fargate.
  - Fargate tasks can't attach EBS volumes (ephemeral 20 GB included;
    new Fargate ephemeral expansion up to 200 GB).
- **Compare with:** Lambda (event functions), ECS on EC2 (DIY nodes),
  EKS on EC2, App Runner.

---

## Amazon ECS (Elastic Container Service)

- **What it is:** AWS-native container orchestration.
- **Best for:** Teams that want AWS-integrated orchestration without
  Kubernetes complexity.
- **Key features:**
  - **Task Definition** (container spec), **Task** (running instance),
    **Service** (desired count + ALB/NLB target).
  - Launch types: **EC2** or **Fargate**.
  - IAM task roles, Secrets Manager / Parameter Store integration.
  - Capacity Providers for capacity management.
  - Service Connect / Cloud Map for service discovery.
  - ECS Anywhere for on-prem.
- **Pricing:** EC2 launch type — pay for EC2; Fargate — pay per task
  resources.
- **Compare with:** EKS, Fargate, App Runner.

---

## Amazon EKS (Elastic Kubernetes Service)

- **What it is:** Managed Kubernetes control plane.
- **Best for:** Portable Kubernetes workloads; mature ecosystems;
  multi-cloud teams.
- **Key features:**
  - Managed upstream Kubernetes.
  - Node groups on EC2, managed node groups, Fargate, or Karpenter.
  - **EKS Anywhere** for on-prem; **EKS Distro** for self-managed.
  - IAM Roles for Service Accounts (**IRSA**).
  - Pod Identity (newer, simpler than IRSA).
- **Pricing:** $0.10 per hour per cluster (+ Fargate/EC2).
- **Compare with:** ECS (simpler), Fargate (serverless nodes).

---

## Amazon ECR (Elastic Container Registry)

- **What it is:** Private/public container registry.
- **Best for:** Storing OCI/Docker images; integration with ECS/EKS/Lambda.
- **Key features:** Image scanning (basic or Inspector-enhanced),
  lifecycle policies, cross-Region replication, pull-through cache
  (mirror public registries).
- **Pricing:** $0.10 / GB-month + data transfer.

---

## AWS Elastic Beanstalk

- **What it is:** Managed PaaS on top of EC2, ASG, ELB, RDS.
- **Best for:** Devs who want to upload code and let AWS manage capacity
  and deploy.
- **Supported platforms:** Java, .NET, PHP, Node.js, Python, Ruby, Go,
  Docker single/multi-container, tomcat, Corretto.
- **Deployment policies:** All-at-once, Rolling, Rolling with additional
  batch, Immutable, Blue/Green (via swap URLs), Traffic Splitting.
- **Pricing:** Free, pay only for the underlying AWS resources.
- **Compare with:** App Runner (simpler), ECS/EKS (more control),
  CloudFormation (IaC).

---

## AWS App Runner

- **What it is:** Fully managed service to deploy a container or source
  repo as a web app/API.
- **Best for:** Running a Dockerfile with *zero* infra config; frequent
  deploy cycles.
- **Key features:** Auto-deploys on source/image change; autoscale to
  zero; VPC connector; private endpoints via PrivateLink.
- **Pricing:** per vCPU-second + GB-second + requests (+ deploy).
- **Compare with:** Beanstalk (more control), ECS/Fargate, Lambda.

---

## Amazon Lightsail

- **What it is:** Lightweight VPS-style AWS offering with flat monthly
  pricing.
- **Best for:** Dev/test, small websites, WordPress, dev sandboxes, MSBs.
- **Includes:** VPS instances, managed DBs, load balancer, CDN,
  containers, object storage.
- **Pricing:** Predictable flat monthly ($3.50–$160/instance/month).
- **Compare with:** EC2 (advanced).

---

## AWS Batch

- **What it is:** Fully managed batch-job orchestration.
- **Best for:** HPC, genomics, rendering, ML training, ETL batches, any
  job-based compute.
- **Key features:** Managed compute environments (EC2 On-Demand / Spot,
  Fargate, EKS), job queues, multi-node parallel, job dependencies,
  retry strategies, array jobs, fair-share scheduling.
- **Pricing:** Free (service); pay for EC2/Fargate/EBS used.

---

## AWS Outposts

- **What it is:** AWS-branded racks shipped to your data center or
  colo; fully managed by AWS.
- **Best for:** Low-latency local processing, data residency, gradual
  cloud migration.
- **Runs:** EC2, EBS, S3 on Outposts, ECS/EKS, RDS, EMR, Direct Connect
  termination.
- **Pricing:** Per-rack 3-year commitment (plus standard AWS usage).

---

## AWS Local Zones

- **What it is:** Smaller AWS edge deployments in large metros.
- **Best for:** Single-digit-ms latency to users in a metro; media &
  gaming workloads.

---

## AWS Wavelength

- **What it is:** AWS infrastructure inside telecom 5G networks.
- **Best for:** Ultra-low-latency to mobile users via 5G.

---

## VMware Cloud on AWS

- **What it is:** Run your existing vSphere environment on AWS bare-metal.
- **Best for:** "Relocate" migration strategy for VMware workloads.
- **Note:** VMware's product positioning has shifted post-Broadcom; check
  current status before design.
