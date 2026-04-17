# Domain 4 - Cost Control Flash Cards

## AWS Certified Solutions Architect - Professional (SAP-C02)

**Topics:** EC2 pricing models, Reserved vs Savings Plans, Spot strategies, storage pricing, data transfer costs, database pricing, Lambda pricing, Cost Explorer, Budgets, CUR, Billing Conductor, cost allocation tags, right-sizing, Compute Optimizer, cost optimization patterns, FinOps

---

### Card 1
**Q:** What are the four EC2 pricing models and their discount levels?
**A:** (1) **On-Demand**: no commitment, full price, pay per second (Linux) or per hour (Windows). (2) **Reserved Instances**: 1-year (~40% discount) or 3-year (~60-72% discount). Standard RI: up to 72%. Convertible RI: up to 66%. Payment: All Upfront (most discount), Partial Upfront, No Upfront (least discount). (3) **Savings Plans**: 1 or 3-year $/hour commitment. Compute SP: up to 66%. EC2 Instance SP: up to 72%. (4) **Spot**: up to 90% discount. Interruptible with 2-minute warning.

---

### Card 2
**Q:** What is the difference between Compute Savings Plans and EC2 Instance Savings Plans?
**A:** **Compute Savings Plans**: most flexible. Applies to: EC2 (any family, size, AZ, region, OS, tenancy), Lambda, and Fargate. Up to 66% discount. Automatically applies to lowest-price usage first. **EC2 Instance Savings Plans**: applies to specific instance family in a specific region (e.g., M5 in us-east-1). Any size, OS, tenancy within that family. Up to 72% discount (higher than Compute SP). Choose Compute SP for maximum flexibility; choose EC2 Instance SP when committed to a specific family/region for higher discount.

---

### Card 3
**Q:** How do Savings Plans apply to usage?
**A:** You commit to a consistent $/hour spend (e.g., $10/hr for 1 year). Usage up to that amount is discounted. Usage beyond the commitment is On-Demand. AWS automatically applies the SP to the usage that gives you the greatest savings first. For Compute SP: applies across EC2, Lambda, and Fargate in priority order. For EC2 Instance SP: applies to the committed instance family first. Multiple SPs can be stacked. SPs appear in Cost Explorer with clear utilization metrics.

---

### Card 4
**Q:** What are the Spot Instance strategies for maximizing availability?
**A:** (1) **Instance type diversification**: request multiple instance types (same vCPU/memory) across multiple AZs. Use capacity-optimized allocation strategy. (2) **Spot Fleet/EC2 Fleet**: mix Spot + On-Demand. Set target capacity with percentage split. (3) **Auto Scaling mixed instances policy**: percentage-based On-Demand/Spot split with multiple instance types. (4) **Capacity-optimized allocation**: places instances in pools with highest available capacity (reduces interruptions). (5) **Price-capacity-optimized**: balances price and capacity. (6) **Spot placement score**: find regions/AZs with best Spot availability.

---

### Card 5
**Q:** How does Spot Instance pricing work?
**A:** Spot price fluctuates based on supply/demand per instance type per AZ. You pay the current Spot price (not your max bid). If the Spot price exceeds your max price (optional, defaults to On-Demand), your instance is interrupted. Interruption notice: 2-minute warning via instance metadata and CloudWatch Events. Interruption behaviors: terminate (default), stop, or hibernate. If AWS interrupts you, you're NOT charged for the partial hour. If YOU stop/terminate, you ARE charged for the full hour. Spot Blocks (1-6 hours) are discontinued.

---

### Card 6
**Q:** What is the S3 storage pricing model?
**A:** S3 pricing has multiple dimensions: (1) **Storage**: per GB/month, varies by class (Standard > Standard-IA > One Zone-IA > Glacier IR > Glacier Flexible > Deep Archive). (2) **Requests**: per 1,000 requests (PUT/GET/etc.), varies by class (IA has higher retrieval cost). (3) **Data transfer**: free in from internet, free to CloudFront, per GB out to internet, free within same region to EC2/Lambda. (4) **Retrieval fees**: for IA and Glacier classes. (5) **Management features**: per object for Intelligent-Tiering monitoring, per rule for lifecycle. Key: Standard has no retrieval fee; IA/Glacier have per-GB retrieval.

---

### Card 7
**Q:** What are the S3 storage class cost differences?
**A:** Approximate US East pricing per GB/month: **Standard**: $0.023. **Intelligent-Tiering**: $0.023 (frequent) to $0.004 (archive). **Standard-IA**: $0.0125 (+ $0.01/GB retrieval). **One Zone-IA**: $0.01 (+ $0.01/GB retrieval). **Glacier Instant Retrieval**: $0.004 (+ $0.03/GB retrieval). **Glacier Flexible Retrieval**: $0.0036 (+ $0.01-$0.03/GB retrieval). **Deep Archive**: $0.00099 (+ $0.02/GB retrieval). Key: cheaper storage = more expensive retrieval. IA classes have 128 KB minimum charge and 30-day minimum storage.

---

### Card 8
**Q:** What are the AWS data transfer cost rules?
**A:** Key rules: (1) **Inbound**: almost always free (from internet or any AWS service). (2) **Same AZ**: free (between EC2, RDS, etc. using private IPs). (3) **Cross-AZ**: ~$0.01/GB each way (within same region). (4) **Cross-region**: $0.02/GB (varies by region pair). (5) **To internet**: tiered pricing starting ~$0.09/GB (first 10 TB), decreasing with volume. (6) **S3 to CloudFront**: free. (7) **VPC peering cross-AZ**: same as cross-AZ pricing. (8) **Transit Gateway**: $0.02/GB processing + data transfer. (9) **NAT Gateway**: $0.045/GB processing + data transfer. (10) **PrivateLink**: $0.01/GB.

---

### Card 9
**Q:** How do you minimize data transfer costs?
**A:** Strategies: (1) **CloudFront** – use for S3 delivery (free S3→CloudFront, reduced egress). (2) **VPC endpoints** – avoid NAT Gateway charges for AWS service access. (3) **Same-AZ** – keep communicating services in same AZ where possible (free). (4) **S3 Transfer Acceleration** – faster but more expensive; use only when needed. (5) **Compress data** – smaller payloads = lower transfer costs. (6) **Direct Connect** – lower per-GB cost than internet for high-volume. (7) **Regional services** – keep processing in the same region as data. (8) **Caching** – ElastiCache/CloudFront reduces repeated transfers.

---

### Card 10
**Q:** What is the NAT Gateway pricing model and how do you optimize it?
**A:** NAT Gateway pricing: $0.045/hour + $0.045/GB processed. This is one of the most overlooked costs. Optimization: (1) **VPC endpoints** – use gateway endpoints (free) for S3/DynamoDB, interface endpoints for other services to avoid NAT. (2) **Centralized NAT** – share NAT Gateways across VPCs via Transit Gateway (fewer gateways). (3) **NAT instances** – for low-throughput use (cheaper, more management). (4) **Monitor** – use VPC Flow Logs to identify top talkers. (5) **Architecture** – put AWS-service-calling workloads in public subnets or use endpoints. NAT charges often surprise teams post-migration.

---

### Card 11
**Q:** What are the EBS pricing considerations?
**A:** EBS pricing: (1) **Storage**: per GB/month. gp3: $0.08/GB. gp2: $0.10/GB. io2: $0.125/GB. st1: $0.045/GB. sc1: $0.015/GB. (2) **IOPS**: gp3 includes 3,000 free, additional $0.005/IOPS. io2: $0.065/IOPS/month. (3) **Throughput**: gp3 includes 125 MiB/s free, additional $0.040/MiB/s. (4) **Snapshots**: $0.05/GB/month (incremental). (5) **Fast Snapshot Restore**: $0.75/AZ/hour per snapshot. Optimization: use gp3 over gp2 (cheaper baseline), right-size volumes, delete unused volumes/snapshots, use lifecycle policies for snapshots.

---

### Card 12
**Q:** What is AWS Cost Explorer and its key features?
**A:** Cost Explorer visualizes and analyzes AWS spending. Features: (1) **Historical analysis** – up to 12 months of past costs. (2) **Forecasting** – up to 12 months ahead using ML. (3) **Filtering/grouping** – by service, account, region, tag, instance type, usage type, etc. (4) **RI/SP recommendations** – suggests purchases based on usage patterns. (5) **RI/SP utilization and coverage reports** – track how well you're using commitments. (6) **Rightsizing recommendations** – identify over-provisioned EC2 instances. (7) **Hourly granularity** (with hourly billing enabled). (8) **API access** for programmatic cost queries.

---

### Card 13
**Q:** What are AWS Budgets and their types?
**A:** AWS Budgets help monitor spending and usage against thresholds. Budget types: (1) **Cost budget** – track total spend against a dollar amount. (2) **Usage budget** – track service usage (e.g., EC2 hours, S3 GB). (3) **RI utilization budget** – alert when RI utilization drops below threshold. (4) **RI coverage budget** – alert when RI coverage drops below threshold. (5) **Savings Plans utilization/coverage budgets** – same for SPs. Alerts via email or SNS. **Budget Actions** can automatically: apply SCPs, apply IAM policies, or stop EC2/RDS instances when thresholds are breached.

---

### Card 14
**Q:** What is the AWS Cost and Usage Report (CUR)?
**A:** CUR is the most granular cost data available. Features: line-item billing data for every resource/hour/day/month. Includes: account, service, usage type, pricing, tags, RI/SP amortization, resource IDs. Delivered to S3 in CSV or Parquet format. Can be queried with: Athena (recommended), Redshift, QuickSight. Supports: hourly/daily/monthly granularity, resource-level detail, split cost allocation for shared resources. CUR 2.0 uses standard SQL column names. Essential for: custom cost analysis, chargeback/showback, cost anomaly investigation.

---

### Card 15
**Q:** What is AWS Billing Conductor?
**A:** Billing Conductor creates custom billing views for different groups within an organization. Features: (1) **Billing groups** – group accounts and assign custom pricing. (2) **Custom pricing rules** – markup/markdown rates, tiered pricing. (3) **Custom line items** – add credits, fees, or adjustments. (4) **Pro forma CUR** – generate custom billing reports per billing group. Use for: MSPs (managed service providers) creating custom invoices for clients, enterprises doing showback/chargeback to business units with custom rates, applying negotiated pricing differently across teams.

---

### Card 16
**Q:** What are cost allocation tags and how do you use them?
**A:** Cost allocation tags enable tracking costs by project, team, environment, or any custom dimension. Two types: (1) **AWS-generated tags** – automatically applied (aws:createdBy, aws:cloudformation:stack-name). Must be activated. (2) **User-defined tags** – custom tags you apply to resources. Must be activated in Billing console. After activation: tags appear in CUR and Cost Explorer for filtering/grouping. Best practice: define a tagging strategy early. Common tags: Environment, Project, Owner, CostCenter, Application. Enforce with tag policies and SCPs.

---

### Card 17
**Q:** What is AWS Compute Optimizer for cost optimization?
**A:** Compute Optimizer uses ML to analyze resource utilization (CloudWatch metrics) and recommend optimal configurations. Resources covered: (1) **EC2** – instance type/size recommendations (downsize or change family). (2) **EBS** – volume type/size (e.g., gp2 to gp3, reduce size). (3) **Lambda** – memory size optimization. (4) **Auto Scaling groups** – instance type recommendations. (5) **ECS on Fargate** – task size (vCPU/memory). Reports savings estimates in dollars. Requires opt-in. Enhanced metrics (paid) provides 3 months of history (vs. 14 days for free).

---

### Card 18
**Q:** What are the key RDS pricing components?
**A:** RDS pricing: (1) **Instance hours** – per hour based on instance class. On-Demand, Reserved (1-3 year). (2) **Storage** – per GB/month. gp3, gp2, io1/io2, magnetic. (3) **Provisioned IOPS** – for io1/io2 volumes. (4) **Backup storage** – free up to DB size. Additional at $0.095/GB/month. (5) **Data transfer** – same as EC2 rules (cross-AZ, cross-region, internet). (6) **Multi-AZ** – doubles instance cost (standby in another AZ). (7) **Read replicas** – charged as separate instances + cross-AZ/region data transfer. Optimization: use RIs for steady databases, right-size instances.

---

### Card 19
**Q:** How does Aurora pricing differ from RDS?
**A:** Aurora differences: (1) **Storage** – pay per GB/month ($0.10), auto-scales, no pre-provisioning. Storage charged based on high-water mark (Aurora Standard) or actual usage (Aurora I/O-Optimized). (2) **I/O** – charged per million I/O requests ($0.20/million for Aurora Standard). Aurora I/O-Optimized: no I/O charges but ~30% higher storage cost. (3) **Backtrack** – charged per change record. (4) **Global Database** – cross-region replication charges. (5) **Serverless v2** – per ACU-hour ($0.12/ACU-hour). Choose I/O-Optimized if I/O costs exceed 25% of total Aurora cost.

---

### Card 20
**Q:** What is the Lambda pricing model?
**A:** Lambda pricing: (1) **Requests**: $0.20 per million requests. First 1 million/month free. (2) **Duration**: $0.0000166667 per GB-second (billed per 1ms). Memory allocated × execution time. First 400,000 GB-seconds/month free. (3) **Provisioned concurrency**: per GB-second provisioned + per request (even when idle). (4) **Ephemeral storage**: free up to 512 MB, $0.0000000309/GB-second beyond. Example: 128 MB, 200ms, 10M requests/month = $2.00 (requests) + $3.33 (duration) ≈ $5.33/month. Optimization: right-size memory (often faster AND cheaper), minimize execution time.

---

### Card 21
**Q:** How do you optimize Lambda costs?
**A:** Strategies: (1) **Right-size memory** – use Lambda Power Tuning tool (Step Functions-based) to find optimal memory setting (more memory = faster execution, sometimes cheaper). (2) **Minimize cold starts** – avoid provisioned concurrency unless needed ($$$). (3) **Optimize code** – faster execution = lower duration cost. Use connection reuse, minimize package size. (4) **Use Graviton (ARM)** – 20% cheaper per GB-second, often 34% better price-performance. (5) **Avoid unnecessary invocations** – filter events at source (EventBridge, SNS filter policies). (6) **Use SnapStart** for Java (eliminate cold start overhead).

---

### Card 22
**Q:** What is the DynamoDB pricing model?
**A:** Two modes: (1) **On-demand**: $1.25 per million WCU, $0.25 per million RCU (standard). No capacity planning. (2) **Provisioned**: $0.00065 per WCU/hour, $0.00013 per RCU/hour. Auto-scaling included. Reserved capacity: 1-3 year for additional savings. Other charges: **Storage** $0.25/GB/month. **Global Tables** replicated WCU: $1.875/million. **DAX**: per node-hour. **Streams**: $0.02/100K reads. **On-demand backup**: $0.10/GB. **PITR**: $0.20/GB/month. **Data export**: $0.11/GB. Optimization: use provisioned + auto-scaling for predictable workloads; on-demand for unpredictable.

---

### Card 23
**Q:** What are the common cost optimization patterns for EC2?
**A:** Patterns: (1) **Right-sizing** – Compute Optimizer recommendations. Downsize or change instance family. (2) **Reserved/Savings Plans** – for steady-state workloads (>66% utilization is break-even). (3) **Spot** – for fault-tolerant workloads (batch, stateless workers, CI/CD). (4) **Graviton** – ARM instances, 20-40% better price-performance. (5) **Auto Scaling** – scale down during low demand. (6) **Scheduling** – stop dev/test instances nights/weekends (Instance Scheduler). (7) **Newer generations** – M6i cheaper and faster than M5. (8) **Consolidation** – fewer larger instances can be cheaper than many small ones.

---

### Card 24
**Q:** What is the AWS Instance Scheduler?
**A:** Instance Scheduler is an AWS Solution that automatically starts/stops EC2 and RDS instances on a schedule. Uses tags to identify resources (e.g., `Schedule: office-hours`). Schedules defined in DynamoDB. Runs via Lambda triggered by EventBridge rules. Supports: custom schedules (work hours, weekdays only), time zones, multiple regions, cross-account via Organizations. Savings example: stopping dev instances nights + weekends = ~65% reduction in EC2 costs. Can save 50-70% on non-production environments.

---

### Card 25
**Q:** What is the total cost of ownership (TCO) for different storage options?
**A:** Storage cost comparison (per GB/month, approximate): **EBS gp3**: $0.08 + IOPS/throughput. **EBS io2**: $0.125 + $0.065/IOPS. **EFS Standard**: $0.30 (but auto-scales, no pre-provisioning). **EFS IA**: $0.025 (+ $0.01/GB access). **S3 Standard**: $0.023. **S3 IA**: $0.0125. **S3 Glacier**: $0.004. **FSx Windows**: $0.13 (SSD). **FSx Lustre**: $0.14 (persistent SSD). Key: factor in data transfer, IOPS, retrieval fees, and management overhead. S3 is cheapest for object storage; EFS adds convenience at higher cost; EBS for block needs.

---

### Card 26
**Q:** How do Reserved Instances work and what are the payment options?
**A:** RIs are a billing discount applied to matching On-Demand usage. Not physical instances—you can launch/terminate normally. **Scope**: regional (applies to any AZ in the region, flexible sizing) or zonal (specific AZ, capacity reservation). **Payment**: All Upfront (max discount), Partial Upfront (mid discount), No Upfront (least discount). **Term**: 1-year or 3-year. Applied automatically to matching usage. Unused RIs still cost money. Can sell Standard RIs on the RI Marketplace. Convertible RIs can be exchanged for different attributes.

---

### Card 27
**Q:** What is RI size flexibility and how does it work?
**A:** Regional RIs (Linux/Unix) support size flexibility within an instance family. A single RI can cover multiple smaller instances or partial coverage of a larger instance. Uses a normalization factor: nano=0.25, micro=0.5, small=1, medium=2, large=4, xlarge=8, 2xlarge=16, 4xlarge=32, 8xlarge=64, 16xlarge=128. Example: one m5.xlarge RI (factor 8) covers: two m5.large (2×4=8) or one m5.large + two m5.medium (4+2+2=8). Only for Linux, default tenancy, regional scope.

---

### Card 28
**Q:** When should you choose Reserved Instances vs. Savings Plans?
**A:** **Choose RIs** when: need capacity reservation (zonal RIs), specific instance attributes (dedicated tenancy, Windows with SQL Server), want to sell unused commitments (Standard RI Marketplace). **Choose Savings Plans** when: want flexibility across instance families/regions (Compute SP), want to cover Lambda/Fargate too, prefer simpler management (one commitment applies broadly). **General guidance**: Savings Plans are simpler and more flexible; RIs provide capacity reservations and more specific targeting. Most organizations are moving to Savings Plans.

---

### Card 29
**Q:** What is the AWS Pricing Calculator?
**A:** AWS Pricing Calculator (calculator.aws) estimates monthly costs for AWS services. Features: select services, configure parameters (instance type, storage, data transfer, etc.), generate estimates, save/share estimates via URL, compare configurations, export to CSV. Replaces the legacy Simple Monthly Calculator and TCO Calculator. Use for: pre-migration cost estimation, architecture cost comparison, budget planning. Tip: always include data transfer, managed service overhead, and support plan costs in estimates.

---

### Card 30
**Q:** What is AWS Cost Anomaly Detection?
**A:** Cost Anomaly Detection uses ML to automatically detect unusual spending patterns. Monitors: specific AWS services, member accounts, cost allocation tags, or cost categories. When an anomaly is detected: alerts via SNS or email with: root cause analysis, impacted service/account/region, spending change amount. You set threshold (dollar or percentage) for alerts. No additional cost for the service. Use for: catching unexpected spend increases early (e.g., crypto mining on compromised instances, misconfigured auto-scaling, forgotten resources). Complements Budgets.

---

### Card 31
**Q:** What are AWS Cost Categories?
**A:** Cost Categories group costs into custom categories for organization-specific views. Define rules based on: account, service, tag, charge type, or other dimensions. Examples: group by team (Engineering, Marketing), by environment (Prod, Dev, Test), by product line. Rules evaluated in order; first match wins. Cost categories appear in: Cost Explorer, Budgets, CUR. Can be nested (inherited values). Use for: organizational showback/chargeback, cost allocation beyond basic tags, executive-level cost reporting by business unit.

---

### Card 32
**Q:** How does CloudFront pricing work?
**A:** CloudFront pricing: (1) **Data transfer out**: per GB, varies by geography (US/Europe cheapest, India more expensive). Tiered pricing (cheaper at higher volumes). (2) **Requests**: per 10,000 requests (HTTP cheaper than HTTPS). (3) **Origin Shield**: per 10,000 requests (reduces origin load). (4) **Functions**: $0.10/million invocations (CloudFront Functions), Lambda@Edge is per GB-second. (5) **Field-level encryption**: per 10,000 requests. Free: S3→CloudFront data transfer. Savings vs. direct S3 egress: CloudFront is often cheaper than direct S3 internet egress for high-volume distribution.

---

### Card 33
**Q:** What is the AWS Free Tier and what's included?
**A:** Three types: (1) **Always free**: Lambda 1M requests/month, DynamoDB 25 WCU/25 RCU, S3 (via 12-month trial then standard pricing), SQS 1M requests, SNS 1M publishes, CloudWatch 10 metrics/5 minute, etc. (2) **12 months free** (from account creation): EC2 750 hours/month (t2.micro or t3.micro), S3 5 GB, RDS 750 hours (db.t2.micro/db.t3.micro), ELB 750 hours. (3) **Trials**: short-term trials for specific services (Inspector 15 days, GuardDuty 30 days, etc.). Important: Free Tier applies per account, not per Organization.

---

### Card 34
**Q:** What are the costs of a Multi-AZ deployment?
**A:** Multi-AZ cost implications: (1) **RDS Multi-AZ**: ~2x single-AZ cost (standby instance billed). No cross-AZ data transfer charges for replication. (2) **EC2 across AZs**: cross-AZ data transfer ~$0.01/GB each way. (3) **ALB/NLB**: charged per AZ used ($0.0225/hour per AZ + LCU). (4) **NAT Gateway**: one per AZ recommended (each $0.045/hour + $0.045/GB). (5) **EFS**: Standard is multi-AZ by default; One Zone saves ~47% but loses AZ resilience. Trade-off: Multi-AZ is critical for production HA but increases costs 20-100% depending on service.

---

### Card 35
**Q:** How do you implement chargeback and showback for a multi-account organization?
**A:** Implementation: (1) **Cost allocation tags** – enforce consistent tagging (CostCenter, Project, Team). Use tag policies. (2) **AWS Organizations** – separate accounts per team/business unit for clear billing boundaries. (3) **CUR** – detailed billing data with tags, account IDs. (4) **Cost Categories** – group costs by business dimensions. (5) **QuickSight dashboards** – visualize costs per team/project. (6) **Billing Conductor** – for MSPs or custom chargeback with markup/markdown. (7) **Split cost allocation** – for shared resources (new CUR feature for ECS/EKS shared clusters). Showback = visibility; Chargeback = actual billing.

---

### Card 36
**Q:** What is the difference between blended and unblended costs?
**A:** **Unblended cost**: actual cost per resource/usage. Each account sees the specific rate it would pay. **Blended cost**: average rate across an Organization. Takes total cost for a usage type and divides by total usage. Accounts benefit from consolidated billing volume discounts equally. **Amortized cost**: spreads upfront RI/SP payments over the commitment period (monthly). Use unblended for: per-account cost analysis. Use blended for: fair cost distribution. Use amortized for: true monthly cost including RI/SP commitment. CUR includes all three perspectives.

---

### Card 37
**Q:** What is the cost impact of Graviton (ARM) instances?
**A:** Graviton instances (e.g., M6g, C6g, R6g, M7g) provide 20-40% better price-performance vs. x86 (Intel/AMD). Price is ~20% lower per hour for equivalent specs. Performance is equal or better for most workloads. Supported by: EC2, RDS, ElastiCache, EMR, Lambda (arm64), ECS/EKS. Considerations: application must run on ARM (most Linux workloads do, check Windows/.NET Framework compatibility). Lambda: arm64 is 20% cheaper per GB-second. Best cost optimization: migrate to Graviton where possible—immediate savings with minimal effort.

---

### Card 38
**Q:** What is AWS Trusted Advisor's cost optimization guidance?
**A:** Trusted Advisor cost checks (Business/Enterprise support): (1) **Low utilization EC2** – instances with < 10% avg CPU for 14 days. (2) **Idle ELBs** – no active instances or < 100 requests/day. (3) **Unassociated Elastic IPs** – charged $0.005/hour when not attached. (4) **Idle RDS instances** – no connections for 7+ days. (5) **Underutilized EBS** – volumes with low IOPS usage. (6) **Unassociated EBS** – detached volumes. (7) **Old snapshots** – snapshots > 30 days. (8) **Reserved Instance optimization** – recommendations for RI purchases. (9) **S3 incomplete multipart uploads**. Estimated savings shown per check.

---

### Card 39
**Q:** How do you optimize S3 costs?
**A:** Strategies: (1) **Lifecycle policies** – transition to cheaper classes (IA → Glacier → Deep Archive). (2) **Intelligent-Tiering** – for unpredictable access (auto-tiers, no retrieval fee). (3) **S3 analytics** – identifies objects for lifecycle transitions. (4) **Compression** – store compressed objects. (5) **Clean up** – delete incomplete multipart uploads (lifecycle rule), remove old versions, set expiration. (6) **Right storage class** – don't use Standard for archival. (7) **S3 Lens** – analyze storage patterns (StorageLens free tier: 28 metrics). (8) **Requester Pays** – for shared datasets. (9) **Same-region endpoints** – avoid cross-region transfer.

---

### Card 40
**Q:** What is Amazon S3 Storage Lens?
**A:** S3 Storage Lens provides organization-wide visibility into S3 usage and activity. Two tiers: (1) **Free metrics** – 28 usage metrics, 14-day data retention. (2) **Advanced metrics** – 35+ additional metrics (activity metrics, cost optimization, data protection), 15-month retention, prefix-level metrics, CloudWatch publishing. Covers: all accounts in an Organization. Metrics include: total storage, object count, average object size, % encrypted, % versioned, incomplete multipart uploads, IA transition recommendations. Dashboard and CSV export available.

---

### Card 41
**Q:** What is the pricing for Transit Gateway vs. VPC Peering?
**A:** **Transit Gateway**: (1) Per attachment: $0.05/hour/attachment (~$36/month). (2) Per GB processed: $0.02/GB. Cost for 10 VPCs: ~$360/month attachments + data processing. **VPC Peering**: no hourly charge. Data transfer: standard cross-AZ ($0.01/GB) or cross-region rates. No per-GB processing fee. For a few VPCs with high data volume, peering is cheaper. For many VPCs or complex routing, TGW's management benefits outweigh cost. Break-even depends on number of VPCs and data volume.

---

### Card 42
**Q:** What is the Elastic IP pricing model?
**A:** Elastic IP pricing: (1) **Free** when: associated with a running EC2 instance (one EIP per instance is free). (2) **Charged $0.005/hour** when: not associated with any resource, associated with a stopped instance, or additional EIPs on a running instance. (3) **Remap fee**: $0.10 per remap after the first 100/month. Total cost of an unused EIP: ~$3.60/month. Best practice: release EIPs not in use. Trusted Advisor checks for unassociated EIPs.

---

### Card 43
**Q:** How does ELB pricing work?
**A:** **ALB**: $0.0225/hour + per LCU (Load Balancer Capacity Unit). LCU measures: new connections, active connections, bandwidth, rule evaluations. Charged for the highest dimension. **NLB**: $0.0225/hour + per NLCU (similar dimensions: new connections/flows, active connections/flows, bandwidth). **GWLB**: $0.0125/hour + per GLCU. **Cross-zone**: free on ALB, charged on NLB/GWLB (inter-AZ data transfer). Optimization: minimize idle LBs, consolidate applications onto fewer ALBs using host/path routing, use NLB only when Layer 4 features are needed.

---

### Card 44
**Q:** What is the AWS Support plan pricing and what does each tier include?
**A:** (1) **Basic**: free. Documentation, forums, limited Trusted Advisor (7 checks), Personal Health Dashboard. (2) **Developer**: $29/month or 3% of spend. Business hours email support, 1 contact, 12-24hr response. (3) **Business**: $100/month or 5-10% of spend. 24/7 phone/chat, unlimited contacts, full Trusted Advisor, 1hr response for production down. (4) **Enterprise On-Ramp**: $5,500/month. TAM pool, 30min response for business-critical. (5) **Enterprise**: $15,000/month or 3-10% of spend. Dedicated TAM, 15min response for business-critical, Concierge, Architecture reviews.

---

### Card 45
**Q:** What is the FinOps approach and how does it apply to AWS?
**A:** FinOps is a practice combining systems, best practices, and culture to increase business value from cloud spending. Three phases: (1) **Inform** – understand costs, allocate to teams, create visibility (CUR, Cost Explorer, dashboards). (2) **Optimize** – identify savings (right-sizing, RIs/SPs, Spot, architectural changes). (3) **Operate** – continuous governance, automation, organizational alignment. AWS tools: Cost Explorer (inform), Compute Optimizer (optimize), Budgets (operate). Key principle: engineering teams take ownership of their cloud spend. Finance, engineering, and business collaborate.

---

### Card 46
**Q:** What are the cost implications of serverless vs. server-based architectures?
**A:** **Serverless** (Lambda, Fargate, DynamoDB on-demand, S3): pay per use, zero cost at zero usage, auto-scales, no idle cost. Better for: variable/unpredictable workloads, low/medium traffic, event-driven. **Server-based** (EC2, ECS on EC2, RDS): pay for running instances, idle cost when underutilized. Better for: high/consistent traffic (lower per-request cost at scale), specific hardware needs (GPU), long-running processes. Break-even: serverless is cheaper until a certain traffic threshold; beyond that, provisioned compute with RIs is cheaper.

---

### Card 47
**Q:** How do you calculate the cost of running a Lambda function vs. an EC2 instance?
**A:** Example: function runs 10M times/month, 200ms, 256 MB. **Lambda**: Requests: 10M × $0.20/M = $2.00. Duration: 10M × 0.2s × 0.25 GB × $0.0000166667 = $8.33. Total: ~$10.33/month. **EC2 t3.micro** (2 vCPU, 1 GB): $0.0104/hr × 730 = $7.59/month. EC2 is cheaper IF the instance handles the load. But Lambda requires zero management, auto-scales, and costs $0 when idle. The crossover point where EC2 becomes cheaper depends on consistent high utilization. For variable workloads, Lambda usually wins.

---

### Card 48
**Q:** What are the costs associated with VPC endpoints?
**A:** **Gateway endpoints** (S3, DynamoDB): FREE. No hourly charge, no per-GB charge. Always use for S3/DynamoDB access from VPC. **Interface endpoints** (PrivateLink): (1) $0.01/hour per AZ (~$7.30/month per AZ). (2) $0.01/GB data processed. For 2 AZs = ~$14.60/month + data costs. But saves: NAT Gateway costs ($0.045/hour + $0.045/GB). For high-volume AWS service access: interface endpoint is cheaper than NAT Gateway. Break-even: ~325 GB/month of data through NAT to a single service.

---

### Card 49
**Q:** What is the pricing for AWS Direct Connect?
**A:** DX pricing: (1) **Port hours**: varies by speed and location. 1 Gbps: ~$0.30/hour (~$219/month). 10 Gbps: ~$2.25/hour (~$1,643/month). (2) **Data transfer OUT**: ~$0.02/GB (cheaper than internet egress at $0.09/GB). Data transfer IN: free. (3) **Partner charges**: additional fees from the DX partner/colocation provider. (4) **Cross-connect**: colocation facility charges. Break-even for DX vs. internet: when data transfer savings exceed port + partner costs. Typically beneficial at > 2-5 TB/month outbound, plus latency/consistency benefits.

---

### Card 50
**Q:** What are the most common sources of unexpected AWS costs?
**A:** Common cost surprises: (1) **NAT Gateway data processing** – high-volume apps can cost hundreds/month. (2) **Unattached EBS volumes** – orphaned after instance termination. (3) **Unused Elastic IPs** – charged when not associated. (4) **Idle load balancers** – still charged per hour even with no traffic. (5) **Cross-region data transfer** – replication, backups. (6) **CloudWatch Logs** – ingestion at $0.50/GB, storage at $0.03/GB. (7) **Snapshot accumulation** – old snapshots never deleted. (8) **Over-provisioned RDS** – Multi-AZ on dev environments. (9) **S3 request costs** – high-request workloads in IA classes.

---

### Card 51
**Q:** What is the cost difference between RDS Multi-AZ and Aurora?
**A:** **RDS Multi-AZ**: ~2x single instance cost (pay for standby). Standby not readable. **Aurora**: storage cost includes 6-way replication across 3 AZs (built-in). Up to 15 read replicas (each billed as separate instance). For HA comparison: Aurora's base storage already provides Multi-AZ durability. Adding one Aurora read replica gives both read scaling AND HA at the cost of one additional instance. Aurora failover is faster (< 30s vs. 60-120s for RDS). For workloads needing HA + read scaling, Aurora is often more cost-effective.

---

### Card 52
**Q:** How do you optimize ElastiCache costs?
**A:** Strategies: (1) **Reserved nodes** – 1/3-year commitments for 30-55% discount. (2) **Right-size** – monitor cache hit rate and memory usage. Downsize if underutilized. (3) **Data tiering** – Redis 7.0+ supports data tiering to SSD (cheaper for large datasets). (4) **Use r6g (Graviton)** – better price-performance than r5/r6i. (5) **Cluster mode** – shard data across nodes instead of scaling vertically. (6) **Evaluate necessity** – if hit rate is low, caching may not provide sufficient benefit to justify cost. (7) **Auto-scaling** – for Redis cluster mode, add/remove shards based on demand.

---

### Card 53
**Q:** What is the pricing model for Amazon Redshift?
**A:** Redshift pricing: (1) **On-Demand**: per node-hour. RA3 (xlplus: $1.086/hr, 4xlarge: $3.26/hr, 16xlarge: $13.04/hr). DC2 (large: $0.25/hr, 8xlarge: $4.80/hr). (2) **Reserved Nodes**: 1-3 year, up to 75% discount. (3) **Managed storage** (RA3): $0.024/GB/month. (4) **Redshift Spectrum**: $5/TB scanned. (5) **Concurrency Scaling**: first 1 hour/day free per cluster, then per-second billing. (6) **Redshift Serverless**: pay per RPU-hour. Optimization: use RA3 for flexibility, reserved for steady workloads, pause cluster when not in use.

---

### Card 54
**Q:** What is the cost of running containers on ECS vs. EKS?
**A:** **ECS**: no control plane charge. Pay only for underlying compute (EC2 instances or Fargate). **EKS**: $0.10/hour control plane (~$73/month per cluster) + compute costs. For both on EC2: instance costs. For both on Fargate: per vCPU/GB-second. So ECS is always $73/month cheaper than EKS (no control plane fee). Choose ECS for: cost savings, simpler setup, tight AWS integration. Choose EKS for: Kubernetes compatibility, portability, ecosystem. Cost optimization for both: Spot instances/Fargate Spot, right-size tasks, bin-packing.

---

### Card 55
**Q:** What is the pricing for AWS Step Functions?
**A:** **Standard Workflows**: $0.025 per 1,000 state transitions. First 4,000 transitions/month free. Each step (Task, Choice, Wait, etc.) counts as a transition. **Express Workflows**: priced per execution + duration. $1.00 per million executions + $0.00001667 per GB-second of duration. Standard: better for low-volume, long-running workflows. Express: better for high-volume, short-duration workflows. Optimization: reduce state transitions (combine steps), use Express for high-volume short workflows, avoid unnecessary Wait states.

---

### Card 56
**Q:** What are the CloudWatch pricing components?
**A:** CloudWatch pricing: (1) **Metrics**: first 10 free, then $0.30/metric/month (high-res $0.10 additional). (2) **Dashboards**: $3/dashboard/month. First 3 free. (3) **Alarms**: $0.10/standard alarm, $0.30/high-res alarm. First 10 free. (4) **Logs ingestion**: $0.50/GB. (5) **Logs storage**: $0.03/GB/month. (6) **Logs Insights queries**: $0.005/GB scanned. (7) **Custom metrics**: $0.30/metric/month. (8) **Contributor Insights**: $0.02 per metric matched per month. Optimization: reduce log verbosity, archive old logs to S3, use metric filters instead of full log queries, set log retention periods.

---

### Card 57
**Q:** How do you estimate and control costs for a new AWS project?
**A:** Process: (1) **Estimate** – use AWS Pricing Calculator with expected architecture. Include: compute, storage, data transfer, managed services, support plan. (2) **Set budgets** – AWS Budgets with dollar thresholds and alerts. (3) **Tag strategy** – implement from day one for cost visibility. (4) **Use Free Tier** – for dev/test environments where applicable. (5) **Start small** – begin with minimal resources, scale up based on actual needs. (6) **Monitor** – Cost Explorer weekly reviews, Cost Anomaly Detection. (7) **Optimize continuously** – right-size after gathering utilization data (2-4 weeks). (8) **Automate** – instance scheduling, auto-scaling.

---

### Card 58
**Q:** What is the cost of cross-region replication for different services?
**A:** Cross-region replication costs: (1) **S3 CRR**: storage in destination + data transfer between regions ($0.02/GB) + request costs. (2) **RDS cross-region read replica**: instance + storage in destination + cross-region data transfer. (3) **Aurora Global Database**: storage + replication I/O + cross-region data transfer. (4) **DynamoDB Global Tables**: storage + replicated write capacity + cross-region data transfer. (5) **EBS snapshot copy**: snapshot storage + data transfer. All incur destination storage + inter-region data transfer. Plan for: 2x storage cost + data transfer for full cross-region HA.

---

### Card 59
**Q:** What is the AWS Graviton cost-saving calculation?
**A:** Example: m5.xlarge (Intel) = $0.192/hr. m6g.xlarge (Graviton2) = $0.154/hr. m7g.xlarge (Graviton3) = $0.163/hr. Savings: ~20% per hour (m5→m6g), with equal or better performance. Annual savings for one instance: ~$333 (m5→m6g). For 100 instances: ~$33,300/year. With 3-year RI: savings compound. Graviton is available across: EC2, RDS, ElastiCache, EMR, Lambda (20% cheaper), EKS/ECS. Migration effort is low for Linux workloads. Most languages/frameworks support ARM. Verify application compatibility before switching.

---

### Card 60
**Q:** What is the cost difference between provisioned and on-demand DynamoDB for different workload patterns?
**A:** Example: 1,000 WCU, 5,000 RCU steady. **Provisioned**: WCU: 1,000 × $0.00065/hr × 730 = $474.50. RCU: 5,000 × $0.00013/hr × 730 = $474.50. Total: ~$949/month. **On-Demand** (equivalent traffic): WCU: 1,000/sec × 2.6M/month × $1.25/M = $3,250. RCU: 5,000/sec × 13M/month × $0.25/M = $3,250. Total: ~$6,500/month. Provisioned is ~7x cheaper for steady workloads. On-demand is better when: traffic is spiky/unpredictable, usage is very low, or you can't predict capacity. With reserved capacity, provisioned is even cheaper.

---

### Card 61
**Q:** How does the AWS Support plan cost factor into total spend?
**A:** Support cost is percentage of AWS spend: **Business**: greater of $100/month or: 10% of first $10K + 7% of $10K-$80K + 5% of $80K-$250K + 3% above $250K. Example: $50K/month spend → $2,500/month Business support. **Enterprise**: greater of $15,000/month or 3-10% (tiered). Example: $500K/month → ~$15,000/month. For exam: support plans are a significant cost. Include in TCO calculations. Business plan is typically recommended minimum for production workloads (24/7 support, full Trusted Advisor, 1-hour response for production issues).

---

### Card 62
**Q:** What are the cost optimization strategies for AWS Lambda at scale?
**A:** At scale strategies: (1) **Provisioned concurrency** management – use Application Auto Scaling to match demand (avoid paying for idle provisioned capacity). (2) **Power tuning** – optimize memory to find cost-performance sweet spot. (3) **ARM/Graviton** – 20% cheaper. (4) **Batch processing** – process SQS messages in batches (fewer invocations). (5) **Response streaming** – for large payloads, avoid buffering. (6) **Evaluate vs. Fargate/EC2** – at very high concurrency, a long-running Fargate/EC2 service may be cheaper. (7) **Code optimization** – reduce execution time. (8) **Ephemeral storage** – minimize /tmp allocation.

---

### Card 63
**Q:** What are the costs of running a VPN vs. Direct Connect?
**A:** **Site-to-Site VPN**: (1) $0.05/hour per VPN connection (~$36.50/month). (2) Data transfer: standard internet rates ($0.09/GB out). (3) Accelerated VPN: additional $0.035/hour + $0.015/GB for Global Accelerator. Total for 1 TB/month out: ~$126.50. **Direct Connect 1 Gbps**: (1) ~$219/month port fee. (2) Data transfer: ~$0.02/GB out. (3) Partner cross-connect: varies ($200-$1,000+/month). Total for 1 TB/month out: ~$439-$1,239+. DX becomes cheaper than VPN at ~3-5 TB/month outbound (data transfer savings offset port costs).

---

### Card 64
**Q:** What is the cost of CloudWatch Logs and how do you optimize it?
**A:** CloudWatch Logs costs: ingestion $0.50/GB, storage $0.03/GB/month, Insights queries $0.005/GB scanned. For a fleet of 100 servers generating 1 GB/day each: ingestion = 100 GB/day × $0.50 = $50/day = $1,500/month. Storage accumulates: after 6 months = 18 TB × $0.03 = $540/month. Optimization: (1) Set retention periods (don't store indefinitely). (2) Filter logs before ingestion (only error/warning). (3) Export to S3 for cheaper long-term storage ($0.023/GB). (4) Use subscription filters to stream to S3 via Firehose. (5) Reduce log verbosity.

---

### Card 65
**Q:** What is the cost structure of Amazon Kinesis Data Streams?
**A:** Kinesis pricing: (1) **On-demand**: $0.04/hour per stream + $0.08/GB data ingested + $0.04/GB data read. (2) **Provisioned**: $0.015/shard/hour + optional Enhanced Fan-Out: $0.013/consumer/shard/hour + $0.013/GB. Each shard: 1 MB/s in, 2 MB/s out. 24-hour retention (free), up to 7 days ($0.02/shard/hour additional) or 365 days ($0.023/shard/hour). Optimization: use on-demand for variable workloads, right-size shard count for provisioned, use enhanced fan-out only when needed (multiple consumers), aggregate records to reduce per-record overhead.

---

### Card 66
**Q:** How do you perform a cost comparison between on-premises and AWS?
**A:** On-premises TCO includes: (1) **Capital**: servers, storage, networking, data center build/lease. (2) **Operational**: power, cooling, physical security, staff salaries, licensing, hardware refresh (3-5 year cycle), space. (3) **Opportunity cost**: over-provisioning for peak (often 15-20% utilization). AWS TCO: compute + storage + data transfer + managed services + support. Use **Migration Evaluator** for automated analysis. Typically AWS saves 30-50% for variable workloads due to: right-sizing, pay-as-you-go, no capital expense, reduced ops staff, volume discounts.

---

### Card 67
**Q:** What are the cost considerations for multi-region architectures?
**A:** Multi-region costs: (1) **Duplicate infrastructure** – 2x (or more) compute, databases, managed services. (2) **Cross-region data transfer** – $0.02/GB for replication (RDS, S3, DynamoDB Global Tables). (3) **Route 53** – health checks ($0.50/check + $0.75 for HTTPS with string matching). (4) **Global Accelerator** – $0.025/hour + $0.01-$0.035/GB. Optimization: use pilot light or warm standby (not full active-active) unless required. Choose regions with lower pricing. Minimize replication frequency for non-critical data. Consider: is the business impact of downtime worth 2x+ cost?

---

### Card 68
**Q:** What are the Reserved Instance recommendations in Cost Explorer?
**A:** Cost Explorer RI recommendations analyze: historical usage (7, 30, or 60 days), service, instance type, region, and platform. It recommends: (1) Which RIs to purchase. (2) How many (normalized units or instance count). (3) Payment option (All/Partial/No Upfront). (4) Term (1 or 3 year). (5) Estimated monthly savings. (6) ROI percentage. (7) Break-even point. Recommendations are based on steady-state usage patterns. Best practice: review 30-60 day lookback for stable recommendations. Also check Savings Plans recommendations for potentially better flexibility.

---

### Card 69
**Q:** What is the cost impact of enabling encryption on AWS services?
**A:** Encryption costs: (1) **SSE-S3**: free. (2) **SSE-KMS**: $1/month per key + $0.03/10,000 API calls. High-volume S3 access can generate significant KMS costs. (3) **CloudHSM**: $1.60/hour per HSM (~$1,168/month). Minimum 2 for HA. (4) **EBS encryption**: free (uses KMS, API charges minimal). (5) **RDS encryption**: free (uses KMS). (6) **TLS termination**: no direct cost on ALB/NLB. Overall: encryption adds minimal cost for most services. KMS costs can be significant for high-request S3 (millions of PUTs/GETs). Use SSE-S3 instead of SSE-KMS when audit trail isn't required.

---

### Card 70
**Q:** How do you implement automated cost governance?
**A:** Automation tools: (1) **Budget Actions** – automatically apply SCPs/IAM policies or stop instances when budget exceeded. (2) **Lambda + EventBridge** – custom automation (delete old snapshots, stop idle resources). (3) **Instance Scheduler** – stop/start on schedule. (4) **AWS Config rules** – detect non-compliant (expensive) resource types and auto-remediate. (5) **SCPs** – prevent launching expensive instance types in dev accounts. (6) **Service Quotas** – limit max instances per account. (7) **Tag enforcement** – SCP deny untagged resources. (8) **Cost Anomaly Detection** – alert on unexpected spend. Build a cost governance pipeline.

---

### Card 71
**Q:** What is the pricing for Amazon API Gateway?
**A:** **REST API**: $3.50 per million requests (first 333M), $2.80-$2.37 for higher volumes. + caching: $0.020-$1.168/hour (by size). **HTTP API**: $1.00 per million requests (first 300M), $0.90 for higher volumes. ~71% cheaper than REST. **WebSocket API**: $1.00 per million connection minutes + $1.00 per million messages. + data transfer out. Optimization: use HTTP API when REST features aren't needed, implement caching (REST), use request throttling to prevent runaway costs, choose regional (cheaper) vs. edge-optimized endpoints wisely.

---

### Card 72
**Q:** What is the cost impact of different S3 request patterns?
**A:** S3 request pricing: Standard: PUT/POST $0.005/1K, GET $0.0004/1K. Standard-IA: PUT $0.01/1K, GET $0.001/1K + $0.01/GB retrieval. Glacier Instant: PUT $0.02/1K, GET $0.01/1K + $0.03/GB retrieval. Example: 10M small objects accessed daily from Standard-IA = 10M GETs × $0.001/1K = $10/day = $300/month + retrieval fees. The same from Standard = $4/day. For frequently accessed small objects, Standard can be cheaper than IA despite higher storage cost. Always model total cost (storage + requests + retrieval) not just storage.

---

### Card 73
**Q:** What is the cost optimization for CloudFront vs. direct S3?
**A:** Scenario: serving 10 TB/month from S3 (us-east-1) to internet. **Direct S3**: $0.09/GB × 10,000 GB = $900/month data transfer. **Via CloudFront**: S3→CF free + CF→internet $0.085/GB × 10,000 = $850/month (+ requests). CloudFront is cheaper AND provides: caching (reduces origin requests), global edge delivery, DDoS protection (Shield Standard). Additional savings: CloudFront Security Savings Bundle (up to 30% with commitment). For popular objects: CloudFront cache hits dramatically reduce S3 request costs. Almost always use CloudFront for public content.

---

### Card 74
**Q:** What are the cost optimization strategies for RDS?
**A:** Strategies: (1) **Reserved Instances** – for production databases (30-60% savings). (2) **Right-size** – monitor CPU/memory with Performance Insights and CloudWatch; downsize if underutilized. (3) **Multi-AZ only for production** – disable for dev/test. (4) **Aurora Serverless v2** – for variable workloads (scales to 0.5 ACU). (5) **Read replicas** – offload reads instead of upsizing primary. (6) **Aurora I/O-Optimized** – if I/O costs > 25% of total. (7) **Storage auto-scaling** – avoid over-provisioning storage. (8) **Snapshot management** – delete old manual snapshots. (9) **Graviton** – use db.r6g/r7g for 15-35% cost savings.

---

### Card 75
**Q:** What is the pricing model for Amazon EFS and how do you optimize it?
**A:** EFS pricing: **Standard**: $0.30/GB/month. **IA**: $0.025/GB/month (+ $0.01/GB access). **One Zone Standard**: $0.16/GB/month. **One Zone IA**: $0.013/GB/month. Throughput charges for Provisioned/Elastic modes: per MiB/s provisioned or per GiB transferred. Optimization: (1) **Lifecycle policies** – move to IA after 7-90 days of no access. (2) **One Zone** – for non-critical data (47% cheaper). (3) **Elastic throughput** – pay per use instead of provisioned. (4) **Right-size** – clean up unused files. (5) **Consider S3** – for data that doesn't need POSIX file system semantics.

---

### Card 76
**Q:** What is the AWS Cost Optimization Hub?
**A:** Cost Optimization Hub (in AWS Billing console) consolidates cost optimization recommendations from: Compute Optimizer, Cost Explorer right-sizing, Trusted Advisor, and custom recommendations. Provides: aggregate savings potential across the Organization, prioritized recommendations by savings amount, implementation tracking, estimated vs. actual savings after implementation. Single dashboard view vs. checking multiple tools. Supports filtering by account, region, service. Helps build the business case for optimization investments.

---

### Card 77
**Q:** How do you calculate the ROI for migrating to AWS?
**A:** ROI calculation: (1) **Current costs** (annual): hardware amortization + data center + staff + licensing + power + network + maintenance. (2) **AWS costs** (annual): compute + storage + data transfer + managed services + support + migration one-time cost (amortized). (3) **Savings** = Current - AWS. (4) **ROI** = (Savings - Migration Cost) / Migration Cost × 100%. Also consider: (5) **Agility benefit** – faster time to market (hard to quantify but significant). (6) **Risk reduction** – HA/DR without capital investment. (7) **Innovation** – access to ML/AI services. Typical ROI: 20-50% cost savings + qualitative benefits.

---

### Card 78
**Q:** What are the cost implications of different caching strategies?
**A:** Caching costs and savings: (1) **CloudFront** – reduces S3/origin costs; CDN costs often lower than direct egress. (2) **ElastiCache** – node costs ($0.017-$3.50/hr depending on type/size). Saves: reduced database load (potentially smaller DB instance), lower latency. (3) **DAX** – $0.269/hr (r5.large). Saves: reduced DynamoDB RCU consumption. (4) **API Gateway caching** – $0.02-$1.17/hr (by cache size). Saves: reduced Lambda/backend invocations. ROI: compare cache cost vs. savings on downstream services. A $50/month ElastiCache node saving $200/month in RDS load = good ROI.

---

### Card 79
**Q:** What is the cost structure of AWS Glue?
**A:** Glue pricing: (1) **ETL jobs**: $0.44/DPU/hour (Apache Spark), minimum 2 DPUs, billed per second (10-minute minimum). (2) **Crawlers**: same DPU pricing. (3) **Data Catalog**: first million objects/month free, then $1/100K objects. (4) **Development endpoints**: $0.44/DPU/hour. (5) **Glue DataBrew**: interactive sessions $1/session-hour, jobs $0.48/node/hour. (6) **Glue Elastic Views**: preview. Optimization: right-size DPUs (use auto-scaling), use Glue bookmarks for incremental processing (avoid reprocessing), optimize data formats (Parquet/ORC for less scanning), use push-down predicates.

---

### Card 80
**Q:** What are the costs of running EKS with different compute options?
**A:** **EKS on EC2 (self-managed nodes)**: $0.10/hr control plane + EC2 instances (On-Demand/RI/Spot/SP). Most flexible, lowest per-pod cost at scale. **EKS on EC2 (managed node groups)**: same pricing, easier management. **EKS on Fargate**: $0.10/hr control plane + Fargate per pod (vCPU + GB-second). Simpler but often more expensive than EC2. **EKS on Fargate Spot**: up to 70% discount on Fargate. Optimization: use Karpenter for efficient node provisioning, Spot for fault-tolerant pods, right-size pods, use Graviton nodes.

---

### Card 81
**Q:** What is the Spot Instance Advisor and Spot Placement Score?
**A:** **Spot Instance Advisor**: shows interruption frequency (< 5% to > 20%) and savings (vs. On-Demand) for each instance type per region. Helps select instance types with lowest interruption risk. **Spot Placement Score**: before launching, query for a Spot placement score (1-10) for your target capacity across regions/AZs. Score 10 = very likely to succeed. Score 1 = unlikely. Use to: identify best regions for Spot workloads, diversify across high-scoring regions. Both tools help optimize Spot usage for maximum savings with acceptable interruption rates.

---

### Card 82
**Q:** How do you create a cost-effective disaster recovery strategy?
**A:** Cost-optimized DR: (1) **Backup & Restore** (cheapest): S3 for backups ($0.023/GB), cross-region replication ($0.02/GB transfer). Total: storage cost only. RTO: hours. (2) **Pilot Light** (moderate): replicated database ($50-200/month for small RDS), AMIs in DR region (snapshot cost). Launch EC2 only during DR. Total: DB cost + snapshot storage. (3) **Warm Standby** (higher): scaled-down infrastructure running (~20-30% of production cost). (4) **Active-Active** (highest): ~100% duplication. Choose based on: business RPO/RTO requirements balanced against budget. Most workloads don't need active-active.

---

### Card 83
**Q:** What is the cost of Amazon SQS and how do you optimize it?
**A:** SQS pricing: **Standard**: first 1M requests/month free, then $0.40/million requests (64 KB chunk). **FIFO**: $0.50/million requests. Each 64 KB of payload counts as one request. Messages larger than 256 KB: use SQS Extended Client Library (payload in S3 + pointer in SQS). Optimization: (1) Batch messages (SendMessageBatch/ReceiveMessageBatch: up to 10 messages per API call = 10x cost reduction). (2) Long polling (WaitTimeSeconds > 0) reduces empty receives. (3) Use Standard unless ordering/exactly-once is required (20% cheaper).

---

### Card 84
**Q:** What is the AWS pricing model for outbound data transfer at scale?
**A:** Outbound data transfer tiers (to internet, per GB): First 10 TB/month: $0.09. Next 40 TB: $0.085. Next 100 TB: $0.07. Next 350 TB: $0.05. Over 500 TB: contact AWS. These tiers aggregate across all services in a region. Additionally: **CloudFront committed pricing** (CloudFront Security Savings Bundle): 30% discount with 1-year commitment on a monthly spend. **Direct Connect**: ~$0.02/GB (much cheaper). **Private pricing agreements**: available for very large customers. Always negotiate pricing for high-volume data transfer scenarios.

---

### Card 85
**Q:** What is the cost difference between Amazon Aurora Standard and Aurora I/O-Optimized?
**A:** **Aurora Standard**: storage $0.10/GB/month + I/O $0.20/million requests. I/O costs are variable and can be significant for write-heavy or read-heavy workloads. **Aurora I/O-Optimized**: storage $0.225/GB/month (2.25x higher) + I/O: FREE. No per-I/O charges. Break-even: when I/O costs exceed ~56% of total Aurora cost (or ~125% of storage cost). AWS guidance: switch to I/O-Optimized if I/O costs are > 25% of total bill (conservative threshold). Monitor via Cost Explorer (filter by usage type containing "IOUsage").

---

### Card 86
**Q:** How do you estimate and budget for a serverless application?
**A:** Estimate components: (1) **API Gateway**: requests/month × price/million. (2) **Lambda**: (requests × $/million) + (memory × duration × $/GB-sec). (3) **DynamoDB**: read/write request units + storage. (4) **S3**: storage + requests. (5) **CloudFront**: data transfer + requests. (6) **CloudWatch**: logs + metrics + alarms. (7) **Step Functions**: state transitions. (8) **SQS/SNS**: messages. Key: serverless costs scale linearly with usage. At zero traffic, cost ≈ $0 (except minimum charges). Budget using AWS Budgets with cost and usage budgets per service. Set alerts at 50%, 80%, 100% thresholds.
