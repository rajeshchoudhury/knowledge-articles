# Compute & ELB Cheat Sheet

## EC2 Instance Family Quick Reference

| Family | Category          | Optimized For                        | Example Use Cases                       |
|--------|-------------------|--------------------------------------|-----------------------------------------|
| **M**  | General Purpose   | Balanced compute, memory, networking | Web servers, app servers, small DBs     |
| **T**  | General (Burstable)| Burst CPU performance               | Dev/test, small workloads, microservices|
| **C**  | Compute Optimized | High-performance processing          | Batch, ML inference, gaming, HPC        |
| **R**  | Memory Optimized  | Large in-memory datasets             | In-memory caches, real-time analytics   |
| **X**  | Memory Optimized  | Extreme memory (up to 4 TB)          | SAP HANA, in-memory DBs                |
| **I**  | Storage Optimized | High sequential read/write (NVMe)    | NoSQL DBs, data warehousing, Elasticsearch |
| **D**  | Storage Optimized | Dense HDD storage                    | MapReduce, distributed file systems     |
| **H**  | Storage Optimized | High disk throughput                 | MapReduce, distributed computing        |
| **P**  | Accelerated (GPU) | General-purpose GPU                  | ML training, HPC                        |
| **G**  | Accelerated (GPU) | Graphics-intensive                   | Video encoding, 3D rendering, gaming    |
| **Inf** | Accelerated      | ML inference (Inferentia chip)       | Low-cost ML inference                   |
| **Trn** | Accelerated      | ML training (Trainium chip)          | Deep learning training                  |
| **F**  | Accelerated (FPGA)| Hardware acceleration                | Genomics, financial analytics           |
| **z**  | High Frequency    | High single-thread performance       | EDA, gaming, single-threaded workloads  |
| **u**  | High Memory       | Up to 24 TB memory                   | SAP HANA (largest instances)            |

**Memory trick:** **M**ain, **C**ompute, **R**AM, **T**urbo(burst), **I**OPS, **G**raphics, **P**arallel(GPU)

---

## EC2 Purchasing Options Comparison

| Option                  | Discount   | Commitment   | Flexibility               | Use Case                          |
|-------------------------|------------|--------------|---------------------------|-----------------------------------|
| **On-Demand**           | 0%         | None         | Full flexibility          | Short-term, unpredictable         |
| **Reserved (Standard)** | Up to 72%  | 1 or 3 year  | Fixed instance type/region | Steady-state, predictable         |
| **Reserved (Convertible)** | Up to 66% | 1 or 3 year | Can change instance type  | Long-term with flexibility        |
| **Savings Plans (Compute)** | Up to 66% | 1 or 3 year | Any instance, region, OS, tenancy | Flexible compute commitment |
| **Savings Plans (EC2)**    | Up to 72% | 1 or 3 year | Fixed family/region       | Steady-state in specific region   |
| **Spot Instances**      | Up to 90%  | None         | Can be interrupted (2 min warning) | Fault-tolerant, batch, CI/CD |
| **Dedicated Instances** | Premium    | None         | Runs on dedicated hardware| Compliance (no shared hardware)   |
| **Dedicated Hosts**     | Premium    | None/Reserved| Physical server control   | BYOL, compliance, socket/core licensing |
| **Capacity Reservations**| 0%        | None         | Reserve capacity in an AZ | Guaranteed capacity, DR           |

**Payment options (Reserved/Savings Plans):** All Upfront > Partial Upfront > No Upfront (more upfront = more discount)

**Spot Instance behaviors on interruption:** Terminate, Stop, or Hibernate

**Exam tip:** "Reduce cost for steady workload" → Reserved/Savings Plans. "Flexible, fault-tolerant batch jobs" → Spot. "License compliance (per-socket)" → Dedicated Hosts.

---

## Placement Group Comparison

| Feature                  | Cluster                        | Spread                         | Partition                      |
|--------------------------|--------------------------------|--------------------------------|--------------------------------|
| **Strategy**             | All instances close together   | Each on different hardware     | Groups on different racks      |
| **Latency**              | Lowest (single AZ)            | Higher                         | Moderate                       |
| **Throughput**            | Highest (10 Gbps bisection)   | Standard                       | Standard                       |
| **AZ span**              | Single AZ only                | Multi-AZ (up to 3)            | Multi-AZ                       |
| **Max instances**        | No AWS limit                  | 7 per AZ per group             | Hundreds per partition          |
| **Failure isolation**    | Low (correlated failures)     | Highest (individual)           | High (partition level)         |
| **Use case**             | HPC, low-latency apps         | Critical instances (HA)        | Hadoop, Cassandra, Kafka       |

**Exam tip:** "Low latency between instances" → Cluster. "Individual instance isolation" → Spread. "Large distributed workloads (HDFS, HBase)" → Partition.

---

## Auto Scaling Policy Types

| Policy Type               | How It Works                               | Use Case                        |
|---------------------------|--------------------------------------------|---------------------------------|
| **Target Tracking**       | Maintain a specific metric value (e.g., CPU at 50%) | Simplest, most common       |
| **Step Scaling**          | Scale by different amounts based on alarm thresholds | Varying scale amounts       |
| **Simple Scaling**        | Scale when alarm breaches, then cooldown   | Legacy, basic                   |
| **Scheduled Scaling**     | Scale at specific times                    | Known traffic patterns          |
| **Predictive Scaling**    | ML-based, forecasts traffic and pre-scales | Recurring patterns              |

**Scaling metrics:**
- **CPUUtilization** — average CPU across group
- **RequestCountPerTarget** — ALB requests per instance
- **ASGAverageNetworkIn/Out** — network traffic
- **Custom CloudWatch metric** — application-level

**Cooldown period:** Default 300 seconds. Prevents rapid scale in/out oscillation.

**Warm pool:** Pre-initialized instances in stopped state for faster scale-out.

---

## ALB vs NLB vs GLB vs CLB

| Feature                  | ALB                     | NLB                     | GLB                     | CLB                     |
|--------------------------|-------------------------|-------------------------|-------------------------|-------------------------|
| **Layer**                | 7 (HTTP/HTTPS)          | 4 (TCP/UDP/TLS)         | 3 (IP packets)          | 4 & 7 (legacy)          |
| **Protocol**             | HTTP, HTTPS, gRPC       | TCP, UDP, TLS           | GENEVE (port 6081)      | HTTP, HTTPS, TCP, SSL   |
| **Performance**          | Moderate                | Ultra-low latency, millions/sec | High               | Low                     |
| **Static IP**            | No (use Global Accel)   | Yes (1 per AZ)          | No                      | No                      |
| **Elastic IP**           | No                      | Yes                     | No                      | No                      |
| **SSL termination**      | Yes                     | Yes (TLS listener)      | No                      | Yes                     |
| **Path/Host routing**    | Yes                     | No                      | No                      | No                      |
| **WebSocket**            | Yes                     | Yes                     | N/A                     | No                      |
| **Fixed response**       | Yes                     | No                      | No                      | No                      |
| **Redirects**            | Yes                     | No                      | No                      | No                      |
| **Target types**         | Instance, IP, Lambda    | Instance, IP, ALB       | Instance, IP            | Instance                |
| **Health checks**        | HTTP, HTTPS             | TCP, HTTP, HTTPS        | HTTP, HTTPS             | TCP, HTTP               |
| **Stickiness**           | Yes (cookie-based)      | Yes (flow hash)         | Yes (flow hash)         | Yes (cookie-based)      |
| **Cross-zone LB**        | On by default (free)    | Off by default (paid)   | Off by default          | Off by default          |
| **WAF**                  | Yes                     | No                      | No                      | No                      |
| **Use case**             | Web apps, microservices | Gaming, IoT, real-time  | 3rd party firewalls, IDS/IPS | Legacy only          |

**Exam tip:** "Path-based routing / host-based routing / microservices" → ALB. "Static IP / ultra-low latency / TCP/UDP" → NLB. "3rd party network appliance / firewall" → GLB. "Deprecated" → CLB.

---

## Lambda Limits Quick Reference

| Limit                        | Value                                    |
|------------------------------|------------------------------------------|
| **Memory**                   | 128 MB – 10,240 MB (10 GB)              |
| **Timeout**                  | Max 15 minutes (900 seconds)             |
| **Deployment package (zip)** | 50 MB (compressed), 250 MB (uncompressed)|
| **Container image**          | Up to 10 GB                              |
| **Environment variables**    | 4 KB total                               |
| **/tmp storage**             | 512 MB – 10,240 MB (10 GB)              |
| **Concurrent executions**    | 1,000 per region (default, can increase) |
| **Burst concurrency**        | 500 – 3,000 (varies by region)           |
| **Layers**                   | 5 per function                           |
| **Invocation payload (sync)**| 6 MB                                    |
| **Invocation payload (async)**| 256 KB                                  |
| **vCPU**                     | 6 vCPU (at 10 GB memory)                |

**Exam tip:** "15-minute timeout" is the critical Lambda limit. If processing takes longer → use Step Functions, ECS/Fargate, or EC2.

---

## ECS vs EKS vs Lambda vs Fargate

| Feature                  | ECS                     | EKS                     | Lambda                  | Fargate                 |
|--------------------------|-------------------------|-------------------------|-------------------------|-------------------------|
| **Orchestration**        | AWS proprietary         | Kubernetes              | Event-driven            | Serverless compute engine |
| **Compute**              | EC2 or Fargate          | EC2 or Fargate          | Managed (no servers)    | Managed (no servers)    |
| **Server management**    | EC2: you manage. Fargate: no | EC2: you manage. Fargate: no | No               | No                      |
| **Scaling**              | Service Auto Scaling    | HPA, VPA, Cluster Autoscaler | Auto (concurrent)  | Auto (with ECS/EKS)    |
| **Max runtime**          | Unlimited               | Unlimited               | 15 minutes              | Unlimited               |
| **Container support**    | Docker                  | Docker (OCI)            | Container images or zip | Docker (ECS/EKS)       |
| **Pricing**              | EC2 or Fargate pricing  | $0.10/hr cluster + compute | Per request + duration | Per vCPU + memory/sec  |
| **Use case**             | Docker on AWS, simple   | K8s workloads, portability | Short tasks, event-driven | Serverless containers |
| **Portable**             | AWS-only                | Multi-cloud             | AWS-only                | AWS-only                |
| **GPU support**          | Yes (EC2)               | Yes (EC2)               | No                      | No                      |

**Exam tip:** "Kubernetes" → EKS. "Simplest container service" → ECS. "No server management for containers" → Fargate. "Event-driven, short-lived" → Lambda.

---

## Elastic Beanstalk Deployment Policies

| Policy                    | Downtime? | Deploy Speed | Rollback           | Capacity During Deploy | Cost        |
|---------------------------|-----------|--------------|--------------------|-----------------------|-------------|
| **All at once**           | Yes       | Fastest      | Manual redeploy    | Reduced (all down)    | No extra    |
| **Rolling**               | No        | Slow         | Manual redeploy    | Reduced (batch-sized) | No extra    |
| **Rolling with batch**    | No        | Slower       | Manual redeploy    | Full (extra batch)    | Extra cost  |
| **Immutable**             | No        | Slowest      | Terminate new ASG  | Full + extra          | Extra cost  |
| **Traffic splitting**     | No        | Slow         | Reroute traffic    | Full + extra          | Extra cost  |
| **Blue/Green**            | No        | Moderate     | Swap URLs          | Full (2 environments) | Double cost |

**Exam tip:** "Zero downtime, easy rollback" → Immutable or Blue/Green. "Cheapest" → All at once or Rolling. "Canary-style" → Traffic splitting.

---

## ENI vs ENA vs EFA

| Feature                  | ENI                            | ENA                            | EFA                            |
|--------------------------|--------------------------------|--------------------------------|--------------------------------|
| **Full name**            | Elastic Network Interface      | Elastic Network Adapter        | Elastic Fabric Adapter         |
| **Purpose**              | Basic networking               | Enhanced networking (high perf)| HPC / ML inter-node            |
| **Speed**                | Standard                       | Up to 100 Gbps                 | Up to 100 Gbps                 |
| **Latency**              | Standard                       | Lower                          | Lowest (OS-bypass)             |
| **Protocol**             | Standard TCP/IP                | Standard TCP/IP                | Libfabric (OS-bypass)          |
| **Cost**                 | Included                       | No extra charge                | No extra charge                |
| **Use case**             | Dual-homing, management NIC    | High PPS workloads             | MPI, NCCL, HPC, ML training   |
| **Multiple per instance**| Yes                            | One per instance               | One per instance               |

**ENI features:** Can have multiple private IPs, one or more security groups, one MAC address. Can be moved between instances (same AZ) for failover.

---

## Burstable Instance Credit Types (T-Series)

| Mode                      | Behavior                                   | When Credits Run Out            |
|---------------------------|--------------------------------------------|---------------------------------|
| **Standard**              | Earn credits below baseline, spend above   | Throttled to baseline CPU       |
| **Unlimited**             | Can burst past credit balance              | Charged for surplus credits     |

**Credit earning:** Each T instance earns CPU credits per hour based on instance size.  
**Baseline performance:** Varies by size (e.g., t3.micro = 10% of a vCPU baseline).

| Instance   | Baseline | Credits/hr | Max Credits |
|------------|----------|------------|-------------|
| t3.nano    | 5%       | 6          | 144         |
| t3.micro   | 10%      | 12         | 288         |
| t3.small   | 20%      | 24         | 576         |
| t3.medium  | 20%      | 24         | 576         |
| t3.large   | 30%      | 36         | 864         |
| t3.xlarge  | 40%      | 96         | 2,304       |

**Exam tip:** "Unpredictable burst CPU" → T-series. If consistently >baseline → switch to M or C instance family.
