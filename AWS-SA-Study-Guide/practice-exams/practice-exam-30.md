# Practice Exam 30 - AWS Solutions Architect Associate (VERY HARD)

## Cost Optimization Mastery

### Exam Details
- **Questions:** 65
- **Time Limit:** 130 minutes
- **Difficulty:** VERY HARD (harder than real exam)
- **Passing Score:** 720/1000
- **Domain Distribution:** Cost-Optimized ~20 | Security ~12 | Resilient ~17 | High-Performing ~16

---

### Question 1
A company runs 200 m5.xlarge EC2 instances 24/7 in us-east-1 for a production workload. The workload is stable and expected to run for the next 3 years. They currently use On-Demand pricing at $0.192/hour per instance. They are evaluating: (1) Standard 3-year Reserved Instances with all upfront payment, (2) 3-year Compute Savings Plans with all upfront, and (3) 1-year Convertible Reserved Instances with no upfront. The Standard 3-year RI offers 62% savings, Compute Savings Plans offers 54% savings, and 1-year Convertible RI offers 31% savings. Which purchasing strategy provides the OPTIMAL balance of cost savings and flexibility?

A) Purchase Standard 3-year RIs for all 200 instances — maximum savings of 62% outweigh any flexibility concerns  
B) Purchase Compute Savings Plans for 70% of the compute (covering 140 instances) and keep 30% On-Demand for flexibility. Savings Plans apply across instance families, Regions, and OS  
C) Purchase 1-year Convertible RIs for all instances and convert them each year as pricing changes  
D) Purchase Standard 3-year RIs for 80% of the baseline (160 instances) and Compute Savings Plans for the remaining 20% (40 instances), maximizing savings on the predictable base while maintaining some flexibility  

---

### Question 2
A company has purchased 50 Standard Reserved Instances of m5.2xlarge in us-east-1. Their Reserved Instance Utilization report shows only 72% utilization over the past month. The RI Coverage report shows 85% coverage for the m5 family. Which TWO actions should the solutions architect take to optimize RI costs? (Choose TWO)

A) Review whether instance size flexibility within the m5 family is being leveraged — m5.2xlarge RIs can apply to equivalent capacity of smaller m5 instances (e.g., 4x m5.xlarge or 8x m5.large)  
B) List unused RIs on the Reserved Instance Marketplace to recoup some cost  
C) Convert all Standard RIs to Convertible RIs for more flexibility  
D) Increase the number of running m5.2xlarge instances to improve utilization  
E) Delete the underutilized Reserved Instances to stop being charged  

---

### Question 3
A company has Compute Savings Plans covering $10,000/hour of compute spend. Their utilization metric shows 92% but their coverage metric shows only 65%. What does this indicate, and what action should they take?

A) 92% of the Savings Plan commitment is being used (good utilization), but only 65% of total compute spend is covered by the plan — 35% is still at On-Demand rates. They should consider purchasing additional Savings Plans to increase coverage  
B) The Savings Plan is underperforming and should be cancelled  
C) 92% of instances are covered, and 65% of those are optimally sized  
D) The utilization is too high — they should reduce instances to lower the utilization to leave headroom  

---

### Question 4
A biotech company runs genomics analysis jobs that take 2-4 hours to complete. The jobs use checkpoint-and-restart patterns, saving intermediate results to S3 every 15 minutes. The jobs can tolerate interruptions. The company currently uses On-Demand c5.9xlarge instances at $1.53/hour. Spot pricing averages $0.46/hour with a 7% interruption rate in us-east-1. Which Spot strategy MOST optimizes cost while ensuring job completion?

A) Use a single Spot Fleet with `capacityOptimized` allocation strategy across multiple instance types (c5.9xlarge, c5a.9xlarge, c5n.9xlarge, m5.9xlarge) and multiple AZs. Configure the fleet to relaunch from the latest S3 checkpoint on interruption  
B) Use a single c5.9xlarge Spot request with `lowestPrice` allocation strategy  
C) Use On-Demand instances with a Savings Plan for the genomics workloads  
D) Use Spot blocks (defined duration) for 4-hour blocks to guarantee no interruption  

---

### Question 5
A company stores 200 TB of data in S3 Standard. S3 Storage Class Analysis reveals: 40% of objects are accessed fewer than once per month, 25% haven't been accessed in 90 days, and 10% haven't been accessed in 180 days. The remaining 25% is accessed frequently. Retrieval latency for infrequently accessed data must be under 100 milliseconds. What is the MOST cost-effective storage strategy?

A) Enable S3 Intelligent-Tiering for the entire bucket with no Archive tiers. Let the automatic tiering handle transitions  
B) Move the 40% infrequent objects to S3 Standard-IA, the 25% objects not accessed in 90 days to S3 Glacier Instant Retrieval, the 10% not accessed in 180 days to S3 Glacier Flexible Retrieval, and keep 25% in Standard  
C) Move the 40% infrequent objects to S3 Standard-IA, the 25% not accessed in 90 days to S3 Glacier Instant Retrieval, and keep the 10% not accessed in 180 days ALSO in Glacier Instant Retrieval (since <100ms retrieval is required). Keep 25% in Standard  
D) Move all data to S3 One Zone-IA since the company only needs millisecond access  

---

### Question 6
A company's VPC has 50 EC2 instances in private subnets that access S3 and DynamoDB frequently. Currently, traffic routes through a NAT Gateway. The NAT Gateway processes 10 TB of data per month to S3 and 2 TB to DynamoDB. NAT Gateway data processing costs $0.045/GB. What is the estimated monthly savings from implementing Gateway VPC endpoints for S3 and DynamoDB?

A) $540 savings — only S3 traffic (10 TB × $0.045/GB) is eliminated; DynamoDB still requires NAT Gateway  
B) $540 savings for S3 plus $90 for DynamoDB = $630 total savings, as both S3 and DynamoDB support Gateway VPC endpoints which are free  
C) $0 savings — VPC endpoints charge the same data processing fee as NAT Gateway  
D) $540 savings — Gateway endpoints are only available for S3; DynamoDB requires an interface endpoint which has per-hour charges  

---

### Question 7
A media company distributes video content globally using CloudFront. Their monthly data transfer is 500 TB. They currently use Price Class All (all edge locations). 70% of their viewers are in North America and Europe, 20% in Asia, and 10% in South America and Australia. CloudFront pricing varies: North America/Europe ~$0.085/GB, Asia ~$0.120/GB, South America ~$0.160/GB, Australia ~$0.140/GB. Switching to Price Class 200 (North America, Europe, Asia, Middle East, Africa) would lose South American and Australian edge locations. What is the cost trade-off analysis?

A) Use Price Class 200. Viewers in South America and Australia would be served from the nearest included edge location. The slight latency increase is offset by eliminating the $0.140-0.160/GB charges for those regions, saving approximately $7,500/month  
B) Keep Price Class All because South American and Australian users would experience unacceptable latency  
C) Switch to Price Class 100 (North America and Europe only) for maximum savings  
D) The cost difference between price classes is negligible at 500 TB scale  

---

### Question 8
A company runs a DynamoDB table for an e-commerce application. Traffic patterns show: weekday peak of 20,000 WCU / 80,000 RCU from 9am-9pm, weekday off-peak of 2,000 WCU / 8,000 RCU from 9pm-9am, and weekend steady state of 5,000 WCU / 20,000 RCU. They currently use on-demand mode and spend $45,000/month. Which capacity configuration would be MOST cost-effective?

A) Switch to provisioned capacity with auto-scaling. Set minimum to 2,000 WCU / 8,000 RCU, maximum to 25,000 WCU / 100,000 RCU, with target utilization of 70%. Purchase Reserved Capacity for the baseline 2,000 WCU / 8,000 RCU  
B) Stay on on-demand mode — the variable traffic pattern makes provisioned impractical  
C) Switch to provisioned capacity with a fixed value of 20,000 WCU / 80,000 RCU  
D) Use DAX to reduce DynamoDB costs by caching all reads  

---

### Question 9
A company runs a fleet of 100 RDS for MySQL db.r5.2xlarge instances across multiple applications. They have 60 Reserved Instances for db.r5.2xlarge. A new application requires db.r5.4xlarge instances. How does RDS Reserved Instance size flexibility apply, and what is the cost optimization opportunity?

A) RDS RI size flexibility allows a db.r5.2xlarge RI to apply as 50% of a db.r5.4xlarge instance, or 2x db.r5.xlarge instances. The 60 RIs cover 60 db.r5.2xlarge OR 30 db.r5.4xlarge equivalent. They can consolidate applications onto fewer larger instances  
B) RDS RIs are locked to the exact instance size and cannot flex to larger or smaller sizes  
C) Size flexibility only applies to EC2 RIs, not RDS RIs  
D) Each db.r5.2xlarge RI can fully cover one db.r5.4xlarge instance  

---

### Question 10
A company runs a Lambda function that processes API requests. Current configuration: 512 MB memory, average duration 800ms, 10 million invocations/month. Using Lambda Power Tuning, the architect discovers: at 1024 MB the duration drops to 400ms, at 1536 MB duration is 380ms, and at 2048 MB duration is 375ms. Lambda pricing is $0.0000166667 per GB-second plus $0.20 per 1M requests. What is the MOST cost-effective memory configuration?

A) 512 MB — lowest per-invocation compute cost despite longer duration: 0.512 GB × 0.8s = 0.4096 GB-s per invocation  
B) 1024 MB — optimal price-performance: 1.024 GB × 0.4s = 0.4096 GB-s per invocation (same GB-s cost as 512 MB but with faster response)  
C) 1536 MB — 1.536 GB × 0.38s = 0.5837 GB-s per invocation (higher cost per invocation)  
D) 2048 MB — more CPU allocation results in the best user experience  

---

### Question 11
A company runs an ElastiCache for Redis cluster with 10 r6g.xlarge nodes for a predictable workload that runs 24/7. On-demand pricing is $0.386/hour per node. Reserved nodes (1-year, all upfront) offer 33% savings. Reserved nodes (3-year, all upfront) offer 51% savings. The workload is expected to run for at least 2 years but may change after that. Which purchasing strategy is MOST cost-effective?

A) Purchase 1-year reserved nodes for all 10 nodes and renew annually — $0.259/hr per node, total savings ~$11,200/year  
B) Purchase 3-year reserved nodes for all 10 nodes — $0.189/hr per node, highest total savings  
C) Purchase 3-year reserved nodes for 7 nodes (70% baseline) and 1-year reserved for 3 nodes, providing flexibility for the uncertain third year  
D) Keep all nodes on-demand for maximum flexibility  

---

### Question 12
A company stores 50 TB of data across 10 EBS gp2 volumes, each 5 TB. The application requires only 500 IOPS and 200 MB/s throughput per volume. Each gp2 5 TB volume provides 15,000 IOPS (3 IOPS/GB cap at 16,000) and 250 MB/s throughput. What are the annual cost savings of switching to gp3?

A) gp3 at $0.08/GB/month vs gp2 at $0.10/GB/month saves $0.02/GB/month. For 50 TB: 50,000 GB × $0.02 = $1,000/month = $12,000/year. Plus gp3 includes 3,000 IOPS and 125 MB/s baseline free — since 500 IOPS < 3,000 baseline, no additional IOPS cost. Additional throughput: 200 - 125 = 75 MB/s × $0.040 = $3/volume/month × 10 = $30/month. Net savings: $970/month = $11,640/year  
B) No savings — gp2 and gp3 have the same price per GB  
C) $6,000/year — only the per-GB storage cost difference matters  
D) Cannot switch because gp3 doesn't support volumes larger than 1 TB  

---

### Question 13
A company has 200 EC2 instances spread across 15 AWS accounts in an Organization. They need to track costs by project, team, and environment. Some resources were launched without tags. Which combination of actions provides comprehensive cost visibility? (Choose THREE)

A) Activate user-defined cost allocation tags (`Project`, `Team`, `Environment`) in the management account's Billing console  
B) Use Tag Editor in AWS Resource Groups to find and tag untagged resources across accounts  
C) Enable the `aws:createdBy` system tag to track resource creators  
D) Create a tag policy in AWS Organizations to enforce consistent tag values across accounts  
E) Use AWS Cost Explorer to analyze costs by tag dimensions once tags are activated  

---

### Question 14
A company runs a NAT Gateway processing 50 TB of outbound data per month. Most traffic goes to S3 (30 TB), DynamoDB (10 TB), and external APIs (10 TB). NAT Gateway costs: $0.045/hour (approximately $32.40/month) plus $0.045/GB data processing. What is the current monthly NAT Gateway data processing cost and the optimized cost after implementing changes?

A) Current: 50 TB × $0.045/GB = $2,304/month. After S3 Gateway endpoint (saves 30 TB) and DynamoDB Gateway endpoint (saves 10 TB): 10 TB × $0.045/GB = $461/month. Monthly savings: $1,843  
B) Current: $2,304/month. Only S3 can use a Gateway endpoint, so optimized: 20 TB × $0.045/GB = $921/month. Savings: $1,383  
C) Current: $2,250/month. After optimization: $450/month  
D) NAT Gateway does not charge for data processing, only hourly charges apply  

---

### Question 15
A company is migrating from Redshift DS2 nodes to RA3 nodes. They have 10 ds2.8xlarge Reserved Nodes with 18 months remaining. Each DS2 node costs $13.04/hour on-demand. RA3.4xlarge nodes cost $3.26/hour on-demand. The current cluster stores 50 TB with only 20 TB of frequently accessed "hot" data. Which migration approach OPTIMIZES cost?

A) Exchange the DS2 reserved nodes for RA3 reserved nodes using the Reserved Node Exchange feature. RA3 nodes store hot data locally and cold data in S3-backed managed storage, potentially reducing the number of nodes needed  
B) Let the DS2 reserved nodes expire, then purchase new RA3 reserved nodes  
C) Run both DS2 and RA3 clusters in parallel, migrating data gradually  
D) DS2 reserved nodes cannot be exchanged — they must be terminated and new RA3 nodes purchased  

---

### Question 16
A company runs 500 EC2 instances but has not enabled Compute Optimizer. After enabling it, the recommendations show that 40% of instances are over-provisioned (right-sizing down would save an average of 30% per instance) and 10% are under-provisioned. However, memory metrics are not available. Which step is required to get ACCURATE right-sizing recommendations including memory?

A) Install the CloudWatch Agent on all instances to collect memory utilization metrics. Compute Optimizer will incorporate memory metrics into its recommendations once 30 hours of data is available  
B) Compute Optimizer automatically collects memory metrics — no additional configuration needed  
C) Enable detailed monitoring in CloudWatch for 1-second granularity  
D) Use AWS Trusted Advisor instead — it provides better right-sizing recommendations than Compute Optimizer  

---

### Question 17
A company receives a monthly AWS bill of $500,000. The breakdown shows: EC2 On-Demand ($200,000), RDS ($80,000), Data Transfer ($120,000), S3 ($50,000), and Other ($50,000). Data transfer costs are 24% of the bill. Which THREE strategies would have the LARGEST impact on reducing data transfer costs? (Choose THREE)

A) Use VPC endpoints for AWS service traffic to eliminate NAT Gateway data processing charges  
B) Use CloudFront for content delivery — CloudFront data transfer to the internet is cheaper than direct EC2/S3 data transfer in most regions  
C) Consolidate resources into fewer Availability Zones to reduce inter-AZ data transfer  
D) Enable S3 Transfer Acceleration for all buckets  
E) Use AWS Direct Connect instead of VPN for hybrid connectivity to reduce per-GB data transfer rates  

---

### Question 18
A company runs a batch processing workload that requires 1,000 vCPUs for 8 hours daily, 5 days a week. They are evaluating: (1) EC2 On-Demand c5.4xlarge (16 vCPU) at $0.68/hour — 63 instances × 8 hrs × 22 days = $9,540/month; (2) EC2 Spot c5.4xlarge average $0.20/hour — $2,800/month; (3) AWS Batch on Fargate at $0.04048/vCPU/hour — 1,000 vCPU × 8 hrs × 22 days = $7,124/month. Which option provides the BEST cost optimization with acceptable risk?

A) EC2 Spot with AWS Batch managing the Spot fleet, using multiple instance types and AZs for resilience. Estimated cost: $2,800/month with <5% job failure rate from interruptions  
B) Fargate with AWS Batch for serverless simplicity at $7,124/month  
C) On-Demand at $9,540/month for guaranteed availability  
D) Fargate Spot with AWS Batch — approximately 70% savings over regular Fargate ($2,137/month) with interruption handling  

---

### Question 19
A company runs an Aurora MySQL cluster with one writer (db.r5.4xlarge at $2.32/hr) and four readers (db.r5.2xlarge at $1.16/hr each). Monthly cost: writer $1,670 + readers $3,341 = $5,011. Read traffic analysis shows that readers average 30% CPU utilization with spikes to 70% during business hours. Which optimization reduces cost while maintaining performance?

A) Replace 2 of the 4 readers with Aurora Auto Scaling configured with min 2 and max 4 readers, with a target CPU utilization of 60%. This eliminates 2 always-on readers during low-traffic periods, saving approximately $1,670/month  
B) Remove all readers and use the writer for both reads and writes  
C) Switch all readers to db.r5.xlarge (half the size) to save 50% on reader costs  
D) Convert to Aurora Serverless v2 for the readers with a minimum of 2 ACU and maximum of 16 ACU per reader. At 30% average utilization, ACU consumption would be lower, potentially saving 40-50% on reader costs  

---

### Question 20
An insurance company processes claims using a Step Functions workflow. Each claim triggers 5 state transitions averaging 10,000 claims/day. Standard Workflows cost $0.025 per 1,000 state transitions. Express Workflows cost $0.00001667 per GB-second of memory and $0.000001 per request. Each claim processing takes 30 seconds with 128 MB memory. Which workflow type is MOST cost-effective?

A) Standard Workflows: 10,000 claims × 5 transitions = 50,000 transitions/day × $0.025/1,000 = $1.25/day = $37.50/month  
B) Express Workflows: 10,000 requests × $0.000001 = $0.01/day for requests + (10,000 × 30s × 0.125 GB × $0.00001667) = $0.625/day for duration = $0.635/day = $19.05/month  
C) Express Workflows are always cheaper than Standard Workflows  
D) Standard Workflows because Express Workflows cannot run for 30 seconds  

---

### Question 21
A company has AWS Organizations with consolidated billing across 20 accounts. Account A has 10 m5.xlarge On-Demand instances and Account B has 5 m5.xlarge Reserved Instances. No other accounts run m5.xlarge. How does consolidated billing apply the RIs?

A) The 5 RIs in Account B apply to 5 of Account B's instances (if any), then unused RIs apply to Account A's instances, reducing Account A's On-Demand charges for up to 5 instances. RI sharing is automatic with consolidated billing unless disabled  
B) RIs only apply to the account that purchased them — Account A gets no benefit  
C) The 5 RIs are split evenly across all 20 accounts  
D) Account A must create a linked account reference to Account B's RIs  

---

### Question 22
A company runs a web application with highly variable traffic: 100 requests/second baseline, spikes to 10,000 requests/second lasting 15 minutes occurring 3-4 times daily. The application backend is Lambda functions behind API Gateway. Each Lambda invocation uses 256 MB and runs for 200ms. Which pricing optimization reduces Lambda costs for this pattern? (Choose TWO)

A) Do NOT use provisioned concurrency — the traffic is too spiky and baseline is low. On-demand Lambda pricing is more cost-effective for this pattern  
B) Use Graviton2-based Lambda (arm64 architecture) for 20% lower price per GB-second compared to x86_64  
C) Increase Lambda memory to 512 MB to reduce duration, potentially achieving the same GB-second cost with better performance  
D) Set reserved concurrency to 10,000 to ensure capacity during spikes  
E) Use Lambda@Edge instead of regional Lambda for lower pricing  

---

### Question 23
A company migrates a 10 TB PostgreSQL database from on-premises to Amazon RDS. After migration, they need to choose between a single db.r6g.4xlarge Multi-AZ instance ($4.112/hr) and two db.r6g.2xlarge instances in an Aurora cluster ($2.056/hr each = $4.112/hr). Both have similar total hourly costs. Which factors should influence the decision for LONG-TERM cost optimization? (Choose TWO)

A) Aurora's storage auto-scaling only charges for used storage (10 KB increments) while RDS requires pre-provisioned storage — Aurora saves on storage costs for growing databases  
B) Aurora read replicas share the same storage volume and cost less than RDS read replicas which require separate storage  
C) RDS Multi-AZ standby is free and doesn't count as an additional instance  
D) Aurora Serverless v2 can replace readers during off-peak, scaling to near-zero  
E) RDS has lower data transfer costs than Aurora  

---

### Question 24
A company runs an API that serves 50 million requests/month. Average response size is 50 KB, and 80% of responses are identical for the same API path (cacheable). Current architecture: API Gateway → Lambda → DynamoDB. CloudFront CDN costs $0.085/GB for data transfer out. Without CloudFront, API Gateway charges $3.50/million requests plus Lambda and DynamoDB costs. What is the cost impact of adding CloudFront?

A) CloudFront caches 80% of requests, reducing Lambda invocations from 50M to 10M and DynamoDB reads proportionally. Data transfer: 50M × 50 KB = 2,500 GB × $0.085 = $212.50 through CloudFront. Savings from reduced Lambda (40M fewer invocations) and DynamoDB reads far exceed CloudFront cost  
B) CloudFront adds cost with no savings because API responses cannot be cached  
C) CloudFront saves on data transfer but increases Lambda invocations due to cache invalidation  
D) The savings are negligible because API Gateway already caches responses  

---

### Question 25
A company runs a data pipeline that transfers 500 GB daily between two VPCs in different AZs within the same Region. The current setup uses VPC peering. Data transfer pricing is $0.01/GB for cross-AZ traffic. They are considering Transit Gateway ($0.05/GB data processing + $0.05/hr per attachment). Which is MORE cost-effective for this traffic pattern?

A) VPC peering is more cost-effective: 500 GB × $0.01/GB × 30 days = $150/month. Transit Gateway: 500 GB × $0.05/GB × 30 days = $750/month + attachment costs. VPC peering saves $600+/month  
B) Transit Gateway is more cost-effective due to consolidated routing  
C) Both cost the same for data transfer  
D) VPC peering: $150/month vs Transit Gateway: $750/month + ~$72/month attachments. However, if connecting more than 5 VPCs, Transit Gateway becomes more cost-effective by eliminating mesh peering complexity  

---

### Question 26
A company's S3 bucket receives 100 million PUT requests and 500 million GET requests per month. Objects average 100 KB and are stored for 90 days. Compare the TOTAL monthly cost (storage + requests + retrieval) between S3 Standard and S3 Intelligent-Tiering. S3 Standard: $0.023/GB storage, $0.005/1000 PUT, $0.0004/1000 GET. S3 Intelligent-Tiering: same storage tiers + $0.0025/1000 monitoring fee per object.

A) S3 Standard: Storage (100M × 100KB × 3months avg = ~1,000 TB-months) is impractical at this scale — S3 Standard is cheaper because Intelligent-Tiering monitoring fees ($0.0025/1000 × 100M = $250/month) add significant overhead for short-lived objects with frequent access  
B) S3 Intelligent-Tiering is always cheaper regardless of access patterns  
C) For objects accessed frequently and stored for only 90 days, S3 Standard is more cost-effective because the Intelligent-Tiering monitoring and automation fee adds cost with minimal tier-transition benefit for actively accessed objects  
D) The costs are identical  

---

### Question 27
A financial services company runs a legacy mainframe batch job migrated to AWS. The job runs for exactly 12 hours every night (6PM-6AM) processing end-of-day transactions. It requires 64 vCPUs and 256 GB RAM consistently. EC2 On-Demand r5.16xlarge ($4.032/hr) costs $48.38/night. Which purchasing approach provides the BEST cost optimization?

A) Use Scheduled Reserved Instances for the daily 12-hour recurring window  
B) On-Demand Capacity Reservations are not a savings mechanism. Use a 1-year EC2 Instance Savings Plan at $2.42/hr (40% savings). Even though the instance only runs 12 hours, the savings plan applies to any matching compute, saving on this instance when running  
C) Use Spot Instances — the job can be checkpointed and restarted  
D) For a predictable 12-hour nightly workload, calculate effective utilization: 12/24 = 50%. A 1-year All Upfront Standard RI at ~40% discount gives $2.42/hr for all hours. Since you pay for 24 hours but use 12, effective cost is $2.42 × 24 = $58.08/day — MORE than On-Demand at $48.38. Instead, use Spot Instances with checkpointing or evaluate Savings Plans compute commitment carefully against actual usage  

---

### Question 28
A company has a 10 Gbps Direct Connect connection costing $2,250/month (port fee). Monthly data transfer out averages 100 TB at $0.02/GB. They're evaluating adding a second 10 Gbps connection for redundancy. However, the second connection would only carry traffic during failover. What is the cost-optimization strategy for redundancy?

A) Add a 10 Gbps Direct Connect connection as backup at $2,250/month — pure redundancy cost of $2,250/month  
B) Add a Site-to-Site VPN as backup over the internet (approximately $0.05/hr per tunnel = $72/month for two tunnels). This provides failover capability at fraction of Direct Connect cost, acceptable for non-real-time backup traffic  
C) Use a 1 Gbps Direct Connect as backup at $220/month — sufficient for essential traffic during failover at 90% lower cost than a full 10 Gbps backup  
D) No redundancy is needed — Direct Connect has built-in redundancy  

---

### Question 29
A company runs a content management system with 500 GB of EBS storage across multiple volumes. Analysis shows: Root volumes (50 GB total) at gp2 with <100 IOPS, Application volumes (200 GB) at io1 with 5,000 provisioned IOPS but only 1,200 IOPS used on average, Log volumes (250 GB) at gp2 with sequential write patterns at 200 MB/s throughput. What are the optimized volume types and estimated savings?

A) Root: gp3 (saves ~20% over gp2). App: gp3 with 3,000 IOPS baseline is sufficient since only 1,200 used (saves ~60% over io1). Logs: st1 for sequential throughput workloads at $0.045/GB vs gp2 $0.10/GB (saves 55%)  
B) Move everything to gp3 for simplicity  
C) Keep io1 for application volumes because they are production workloads  
D) Use instance store for log volumes to eliminate EBS costs entirely  

---

### Question 30
A company processes 10 million images per month using Lambda functions triggered by S3 uploads. Each image processing takes 15 seconds with 1,536 MB memory. The Lambda function makes 3 calls to Amazon Rekognition per image at $0.001 per image. What is the total monthly cost, and which optimization has the LARGEST cost impact?

A) Lambda: 10M × 15s × 1.536 GB × $0.0000166667/GB-s = $3,840. Rekognition: 10M × 3 × $0.001 = $30,000. S3 requests: ~$5,000. Total: ~$38,840. Reducing Rekognition calls (e.g., batching or combining analyses) has the largest impact  
B) Lambda cost dominates — optimize Lambda memory and duration  
C) S3 storage costs dominate — use lifecycle policies  
D) Total cost is approximately $5,000 — Lambda is the main expense  

---

### Question 31
A company uses AWS Backup to protect 100 RDS instances, 500 EBS volumes, and 50 DynamoDB tables. The backup policy creates daily backups retained for 30 days. Warm storage costs $0.05/GB-month for EBS and RDS. Each RDS instance is 500 GB, each EBS volume is 200 GB, and each DynamoDB table is 25 GB. However, daily change rate is only 5% for RDS, 3% for EBS, and 1% for DynamoDB. How do incremental backups affect cost?

A) First backup is a full backup. Subsequent backups are incremental. For EBS: first month storage = 500 × 200 GB full + 29 days × 500 × 200 GB × 3% = 100 TB + 87 TB = 187 TB × $0.05 = $9,350/month. Incremental backups dramatically reduce storage costs compared to 30 full copies  
B) AWS Backup always creates full backups, so cost = 30 full copies per resource  
C) Incremental backups are free — you only pay for the first full backup  
D) All backup storage costs the same regardless of change rate  

---

### Question 32
A SaaS company runs multi-tenant infrastructure. Each tenant has dedicated RDS instances, Lambda functions, and S3 buckets. Monthly AWS bill is $2 million. The finance team cannot determine per-tenant costs. Which cost allocation strategy provides the MOST accurate per-tenant cost attribution? (Choose TWO)

A) Implement consistent tagging with a `TenantID` tag across all resources. Activate the tag as a cost allocation tag in the Billing console  
B) Use AWS Cost Categories to create rules that map tagged resources and shared costs to each tenant  
C) Create separate AWS accounts per tenant for complete cost isolation  
D) Use CloudWatch metrics to estimate per-tenant usage and allocate costs manually  
E) Use AWS Cost Explorer's filtering to separate costs — this only works if tags are already applied  

---

### Question 33
A company runs Amazon EKS with 50 worker nodes (m5.2xlarge On-Demand at $0.384/hr). Pod utilization analysis shows average cluster CPU at 35% and memory at 40%. Kubernetes Cluster Autoscaler is configured with min=20, max=50. What combination of optimizations provides the GREATEST cost reduction? (Choose TWO)

A) Implement Karpenter instead of Cluster Autoscaler for more efficient bin-packing and faster scaling. Karpenter selects optimal instance types based on pod requirements  
B) Use Spot instances for fault-tolerant workloads with Karpenter's Spot provisioner, maintaining On-Demand for stateful workloads  
C) Increase the minimum node count to 40 to handle traffic spikes  
D) Use Fargate for all pods to eliminate node management  
E) Upgrade to m5.4xlarge instances to reduce the number of nodes  

---

### Question 34
A company transfers data between AWS Regions for disaster recovery. Monthly transfer: 20 TB from us-east-1 to eu-west-1. Cross-Region data transfer costs $0.02/GB. Current monthly cost: 20 TB × $0.02/GB = $409.60. They also run CloudFront distributions in both Regions. How can they reduce cross-Region data transfer costs?

A) S3 Cross-Region Replication (CRR) charges $0.02/GB for cross-Region data transfer — same as standard transfer. However, using S3 Transfer Acceleration may provide faster transfer at an additional $0.04/GB. No cost savings from CRR itself  
B) Use VPC peering between Regions — peering makes cross-Region transfer free  
C) Use AWS DataSync with compression enabled to reduce the volume of data transferred, potentially saving 40-60% on transfer costs depending on data compressibility  
D) Cross-Region data transfer is free within the same AWS Organization  

---

### Question 35
A company runs a real-time analytics platform on Amazon Kinesis Data Streams. The stream has 100 shards processing 100 MB/s. Shard costs: $0.015/shard-hour + $0.014/million PUT payload units. Monthly shard cost: 100 × $0.015 × 730 = $1,095. Enhanced fan-out consumers add $0.013/shard-hour per consumer. They have 5 enhanced fan-out consumers. What is the total monthly cost, and which optimization has the MOST impact?

A) Shards: $1,095. Enhanced fan-out: 5 × 100 × $0.013 × 730 = $4,745. PUT units: ~$1,000. Total: ~$6,840. Reducing enhanced fan-out consumers (e.g., consolidating to 2-3 consumers using shared processing) saves the most — each consumer costs ~$949/month  
B) Shard costs dominate — reduce shard count by using larger records  
C) PUT payload unit costs are the largest component  
D) Enhanced fan-out is free for the first 5 consumers  

---

### Question 36
A company's AWS Config records configuration changes across 10 accounts. Each account averages 50,000 configuration item recordings per month at $0.003 per recording. Config rules evaluation: 20 rules × 50,000 evaluations = 1,000,000 evaluations at $0.001 per evaluation. What is the total monthly Config cost across all accounts, and how can it be optimized?

A) Recordings: 10 × 50,000 × $0.003 = $1,500. Evaluations: 10 × 1,000,000 × $0.001 = $10,000. Total: $11,500/month. Optimize by reducing the number of resource types recorded (only record resources you have rules for) and using periodic evaluation triggers instead of change-based triggers where appropriate  
B) AWS Config is free — there are no per-recording charges  
C) Total cost is $1,500 — rule evaluations are included in the recording fee  
D) Config costs cannot be optimized — all resources must be recorded  

---

### Question 37
A company runs a web application with the following CloudWatch configuration: 200 custom metrics published every 10 seconds (high-resolution), 50 CloudWatch Alarms, 500 GB of log data ingested monthly, and log retention set to 1 year. CloudWatch pricing: custom metrics $0.30/metric/month (first 10K), high-resolution metrics add no extra charge for publishing but $0.01 per 1000 GetMetricData API calls, alarms $0.10/alarm/month for standard resolution, log ingestion $0.50/GB, log storage $0.03/GB-month. What is the approximate monthly CloudWatch cost?

A) Metrics: 200 × $0.30 = $60. Alarms: 50 × $0.10 = $5. Log ingestion: 500 GB × $0.50 = $250. Log storage: grows by 500 GB/month, average over year ~3,000 GB × $0.03 = $90. Monthly: ~$405. Optimize by reducing log retention, using S3 for long-term log storage, and reducing custom metric count  
B) Total cost is approximately $60 — metrics are the only significant cost  
C) Log storage dominates at $1,500/month  
D) CloudWatch is included free with EC2 instances  

---

### Question 38
A company uses Amazon Redshift with 10 dc2.8xlarge nodes (On-Demand: $4.80/hr per node = $48/hr total). The cluster runs 24/7 but analytics queries only run during business hours (8am-6pm, weekdays). The cluster sits idle 70% of the time. Which approach provides the BEST cost optimization?

A) Use Redshift Serverless, which charges per RPU-hour only when queries are running. For a workload using ~256 RPU for 10 hours × 22 weekdays = 220 hours at $0.375/RPU-hour = $21,120/month vs current $35,040/month  
B) Pause the Redshift cluster outside business hours using a scheduled action. Running 10 hours × 22 days = 220 hours at $48/hr = $10,560/month + storage for paused cluster. Savings: ~$24,480/month (70%)  
C) Resize to fewer nodes since the cluster is underutilized  
D) Move data to Athena and eliminate Redshift entirely  

---

### Question 39
A company has a workload running on 10 c5.2xlarge instances in an Auto Scaling group. AWS Compute Optimizer recommends c6g.2xlarge (Graviton2) instances which offer 40% better price-performance. Current cost: $0.34/hr × 10 = $3.40/hr. c6g.2xlarge: $0.272/hr. Assuming the workload can run on ARM architecture with no code changes, what are the savings?

A) New cost: $0.272 × 10 = $2.72/hr. With 40% better price-performance, potentially need only 7 instances: $0.272 × 7 = $1.904/hr. Savings: 44% ($1.496/hr = $1,092/month)  
B) Savings of exactly 20% ($0.068/hr per instance) — only the per-instance price difference  
C) No savings — Graviton2 instances require more instances to achieve the same throughput  
D) Savings require purchasing new Reserved Instances for Graviton, which takes 1-3 years to realize  

---

### Question 40
A company has 50 TB in S3 Standard. They receive 1 million GET requests/day and 100,000 PUT requests/day. The workload is unpredictable — some objects are accessed heavily for a week then rarely touched for months. Others have consistent access. Which storage strategy MINIMIZES cost without impacting access latency for active objects?

A) S3 Intelligent-Tiering with no archive tiers enabled. Objects automatically move between Frequent and Infrequent Access tiers (30-day threshold). No retrieval fees. Monitoring cost: $0.0025/1000 objects/month  
B) S3 lifecycle policy: move to Standard-IA after 30 days  
C) Keep everything in S3 Standard  
D) S3 lifecycle policy: move to Glacier Instant Retrieval after 30 days  

---

### Question 41
A company runs a multi-Region active-active architecture with Aurora Global Database. Primary Region (us-east-1) has a writer and 2 readers. Secondary Region (eu-west-1) has 2 readers. Monthly costs: us-east-1 writer db.r6g.2xlarge ($2.056/hr × 730 = $1,501), us-east-1 readers ($1,501 × 2 = $3,002), eu-west-1 readers ($1,501 × 2 = $3,002), cross-Region replication data transfer (~2 TB at $0.02/GB = $40.96). Total: $7,546/month. Which optimization saves the MOST while maintaining multi-Region capability? (Choose TWO)

A) Use Aurora Auto Scaling in both Regions to scale readers from 1 to 3 based on CPU utilization — eliminating one always-on reader per Region saves ~$3,002/month  
B) Switch eu-west-1 readers to Aurora Serverless v2 (min 0.5 ACU, max 32 ACU) — during low-traffic European hours, ACU consumption drops significantly  
C) Eliminate cross-Region replication to save on data transfer costs  
D) Use smaller instance types for all readers (db.r6g.xlarge at half the cost)  
E) Replace the secondary Region with a CloudFront distribution  

---

### Question 42
A company runs an IoT platform ingesting sensor data from 100,000 devices. Each device sends a 1 KB message every 5 seconds. Data flows: IoT Core → Kinesis Data Streams → Lambda → DynamoDB. Current DynamoDB WCU provisioned: 20,000 at $0.00065/WCU/hr. Monthly DynamoDB write cost: 20,000 × $0.00065 × 730 = $9,490. How can the architect REDUCE DynamoDB costs while handling the 20,000 writes/second?

A) Batch writes in Lambda — accumulate 25 items per `BatchWriteItem` call, reducing the number of WCUs consumed per batch by using efficient item sizes  
B) Switch DynamoDB to on-demand mode — on-demand WRU cost is $1.25 per million. 20,000 WRU/s × 86,400 s × 30 = 51.84 billion WRU × $1.25/M = $64,800/month. On-demand is MORE expensive for predictable high-throughput workloads  
C) Use DynamoDB Streams to write asynchronously, reducing WCU needs  
D) Aggregate sensor readings in Lambda (e.g., average readings per minute instead of per 5 seconds) before writing to DynamoDB. This reduces writes by 12x (from 20,000/s to ~1,667/s), cutting DynamoDB costs by ~92%  

---

### Question 43
A company runs a serverless API using API Gateway REST API. Monthly usage: 300 million API calls. API Gateway pricing: $3.50 per million for REST API, $1.00 per million for HTTP API. The API uses Lambda proxy integration, request/response transformation, and API keys for throttling. Which migration saves costs? (Choose TWO)

A) Migrate from REST API to HTTP API if the features used (Lambda proxy, throttling) are supported by HTTP API. Savings: (300M × $3.50/M) - (300M × $1.00/M) = $750/month  
B) HTTP API supports Lambda proxy integration and basic throttling but NOT request/response transformation — evaluate if this feature is critical before migrating  
C) Enable API Gateway caching ($0.020/hr for 0.5 GB cache) to reduce backend invocations. If 50% cache hit rate, Lambda invocations drop from 300M to 150M  
D) HTTP API and REST API have the same pricing  
E) Switch to ALB with Lambda targets at $0.008/LCU-hour — not directly comparable as ALB lacks API management features  

---

### Question 44
A company stores database backups in S3. Backup profile: daily 500 GB full backups retained for 30 days, stored in S3 Standard currently. Backups older than 7 days are only accessed during disaster recovery (estimated once per year). Compare costs between S3 Standard and a tiered approach. S3 Standard: $0.023/GB/month. S3 Glacier Instant Retrieval: $0.004/GB/month, $0.01/GB retrieval.

A) Current: 30 × 500 GB = 15 TB in Standard = $345/month. Optimized: 7 × 500 GB in Standard ($80.50) + 23 × 500 GB in Glacier Instant Retrieval (11.5 TB × $0.004 = $46). Total: $126.50/month. Annual savings: $2,622. DR retrieval cost (once/year): 500 GB × $0.01 = $5  
B) Keep all in Standard — the retrieval cost from Glacier makes it more expensive  
C) Move all backups to Glacier Deep Archive immediately for maximum savings  
D) Use S3 One Zone-IA for all backups  

---

### Question 45
A company runs 100 t3.micro instances for a development environment (On-Demand: $0.0104/hr per instance). Developers work 8 hours/day, 5 days/week. Instances run 24/7. Monthly cost: 100 × $0.0104 × 730 = $759.20. What is the savings from implementing start/stop automation?

A) Running only during work hours: 100 × $0.0104 × 8 × 22 = $183.04/month. Savings: $576.16/month (76%). Implement using Instance Scheduler on AWS or EventBridge Scheduler with Lambda to start/stop instances  
B) $0 savings — t3.micro instances are too cheap to optimize  
C) 50% savings from running 12 hours instead of 24  
D) Start/stop automation doesn't save money because EBS volumes still incur charges  

---

### Question 46
A company uses AWS WAF on CloudFront and ALB. WAF pricing: $5/web ACL/month, $1/rule/month, $0.60/million requests. They have 5 web ACLs with 20 rules each across 3 CloudFront distributions and 10 ALBs. Monthly requests: 500 million. What is the WAF cost and optimization strategy?

A) Web ACLs: 5 × $5 = $25. Rules: 5 × 20 × $1 = $100. Requests: 500M × $0.60/M = $300. Total: $425/month. Optimize by consolidating web ACLs (use fewer ACLs with more targeted rules), removing unused rules, and using rule groups for shared rule sets  
B) WAF costs are negligible — no optimization needed  
C) $300/month — only request costs matter  
D) Use Shield Advanced to eliminate WAF costs  

---

### Question 47
A company is evaluating the cost of running a PostgreSQL database. Options: RDS db.r6g.xlarge Multi-AZ ($0.958/hr = $699/month), Aurora db.r6g.xlarge with 1 reader ($0.479/hr × 2 = $699/month), self-managed on EC2 r6g.xlarge ($0.336/hr = $245/month + EBS + management overhead). The database stores 2 TB with 5,000 IOPS needed. Which is MOST cost-effective when factoring in operational costs?

A) RDS Multi-AZ and Aurora have similar compute costs. Aurora saves on storage (pay-per-use vs provisioned) and provides automatic failover with read scaling. At 2 TB with 5,000 IOPS, Aurora storage: 2 TB × $0.10/GB = $200/month + I/O: ~$50/month. RDS: 2 TB gp3 = $160/month + provisioned IOPS cost. Aurora total: ~$949. RDS total: ~$859. EC2: ~$245 compute + $160 storage = $405 but with significant operational overhead  
B) EC2 is always cheapest — managed services are a waste of money  
C) Aurora is cheapest due to storage I/O pricing  
D) All three options cost approximately the same  

---

### Question 48
A company processes video transcoding using EC2 Spot Instances. The fleet uses c5.4xlarge instances. Current Spot price: $0.20/hr (vs On-Demand $0.68/hr). The fleet processes 1,000 hours of video daily. Each hour of video requires 1 hour of c5.4xlarge processing. Monthly fleet hours: 30,000 instance-hours. What is the monthly cost, and how does a Spot interruption rate of 10% affect total cost?

A) Base Spot cost: 30,000 × $0.20 = $6,000/month. With 10% interruption, 3,000 hours of work is lost and must be reprocessed: additional 3,000 × $0.20 = $600. Total: $6,600/month vs On-Demand $20,400/month. Net savings: 68% even with interruptions  
B) 10% interruption makes Spot more expensive than On-Demand  
C) $6,000/month with zero interruption cost — Spot instances are not charged for interrupted hours  
D) $6,000/month — interruption has no cost impact because work is never lost  

---

### Question 49
A company uses Amazon S3 for a data lake. Monthly operations: 500 million S3 API calls (60% GET, 30% PUT, 10% LIST). S3 Standard pricing: GET $0.0004/1000, PUT $0.005/1000, LIST $0.005/1000. What is the monthly S3 request cost, and which optimization has the BIGGEST impact?

A) GET: 300M × $0.0004/1000 = $120. PUT: 150M × $0.005/1000 = $750. LIST: 50M × $0.005/1000 = $250. Total: $1,120/month. PUT operations are the most expensive — optimizing PUT patterns (larger batches, fewer small objects) has the biggest cost impact  
B) GET operations dominate costs  
C) Total request cost is under $100 — request costs are negligible  
D) LIST operations are the most expensive  

---

### Question 50
A company operates in 5 AWS Regions with ~100 resources per Region requiring monitoring. CloudWatch cross-Region dashboards and metrics are needed. Cross-account CloudWatch data sharing involves GetMetricData API calls. At high-resolution (10-second periods), monitoring 500 metrics across 5 Regions generates approximately 2.6 billion API datapoints/month. GetMetricData pricing: $0.01 per 1,000 metrics requested. How can they reduce monitoring costs? (Choose TWO)

A) Reduce metric resolution from 10 seconds to 60 seconds for non-critical metrics — this reduces API calls by ~6x  
B) Use CloudWatch Metric Streams to export metrics to S3 via Kinesis Data Firehose at $0.003 per 1000 metric updates — cheaper than repeated GetMetricData calls for dashboards  
C) Increase the number of dashboards for better visibility  
D) Disable all CloudWatch monitoring to eliminate costs  
E) Use CloudWatch composite alarms to reduce the number of individual alarm evaluations  

---

### Question 51
A company runs AWS Glue ETL jobs processing 5 TB of data daily. Current configuration: 50 DPUs (Data Processing Units) for 4 hours at $0.44/DPU-hour. Monthly cost: 50 × 4 × $0.44 × 30 = $2,640. The data engineering team discovers that the job spends 40% of processing time on data shuffling due to skewed partitions. Which optimization reduces Glue costs the MOST?

A) Fix data skew by repartitioning or salting the join keys. Reducing shuffle time by 40% could cut job duration to ~2.4 hours. New cost: 50 × 2.4 × $0.44 × 30 = $1,584/month. Savings: $1,056/month (40%)  
B) Increase DPUs to 100 to process faster  
C) Switch to Glue 4.0 with auto-scaling, which automatically optimizes DPU allocation and reduces cost by right-sizing resources to the workload. Combined with fixing data skew, potential savings of 50-60%  
D) Move to EMR for lower per-hour compute costs  

---

### Question 52
A company has 1,000 AWS Lambda functions across 20 microservices. Average monthly Lambda bill is $15,000. Analysis shows: 30% of functions are invoked fewer than 100 times/month, 20% of functions use provisioned concurrency but are over-provisioned by 60%, and 10% of functions have timeout set to 15 minutes but complete in under 30 seconds. Which THREE optimizations provide the MOST savings? (Choose THREE)

A) Right-size provisioned concurrency based on actual concurrent execution metrics — reducing over-provisioning by 60% on 20% of the $15,000 bill saves approximately $1,800/month  
B) For functions completing in 30 seconds with 15-minute timeouts, reducing timeout doesn't directly save money (billing is per-100ms of actual duration), but it prevents runaway executions that could increase costs  
C) Remove or consolidate the 30% of rarely-invoked functions — Lambda charges per invocation, so 300 functions at <100 invocations/month contribute minimal cost; savings are operational, not financial  
D) Use Lambda arm64 (Graviton2) architecture for all functions — 20% price reduction applies to the entire $15,000 bill, saving $3,000/month  
E) Enable Lambda Insights for all functions to get better observability  

---

### Question 53
A company runs an Amazon MQ (ActiveMQ) broker in a Multi-AZ deployment using mq.m5.xlarge ($0.672/hr). Monthly cost: $490/month. Message throughput is only 100 messages/second. The application uses simple queue and topic patterns. Which MOST cost-effective alternative should the architect recommend?

A) Migrate to Amazon SQS and SNS. SQS pricing: $0.40/million messages. At 100 msg/s = 259.2M msgs/month × $0.40/M = $103.68/month. SNS: similar pricing for pub/sub. Total: ~$150-200/month — saving ~60%  
B) Keep Amazon MQ but downsize to mq.m5.large ($0.336/hr = $245/month)  
C) Migrate to Amazon MSK (Kafka) for better throughput  
D) SQS is more expensive than Amazon MQ at this message rate  

---

### Question 54
A company has a 500-instance fleet with mixed purchasing: 200 On-Demand, 150 Standard RIs, 100 Convertible RIs, and 50 Spot. Monthly EC2 cost is $180,000. They want to reduce costs by 30% ($54,000/month) without reducing capacity. Which strategy is MOST likely to achieve this target? (Choose TWO)

A) Convert the 200 On-Demand instances to Standard 1-year RIs — at ~40% savings on On-Demand portion: 200 instances × current On-Demand cost × 40% savings  
B) Use Compute Savings Plans to cover the On-Demand instances — provides flexibility to change instance types while achieving ~37% savings  
C) Replace 50% of On-Demand instances with Spot where workloads are fault-tolerant. Spot typically saves 60-70% over On-Demand  
D) Negotiate an Enterprise Discount Program (EDP) with AWS for overall account-level discounts  
E) Upgrade all instances to the latest generation for price-performance improvements  

---

### Question 55
A company has an S3 bucket with 100 million objects totaling 50 TB. They enable S3 Inventory to track storage classes and encryption status. Inventory pricing: $0.0025 per million objects listed. They run inventory weekly. Additionally, they use S3 Analytics Storage Class Analysis at $0.10/million objects monitored per month. What is the monthly cost of these management features?

A) Inventory: 100M objects × $0.0025/M × 4 weeks = $1.00/month. Analytics: 100M × $0.10/M = $10.00/month. Total: $11.00/month — negligible compared to storage costs  
B) Inventory and Analytics are free features  
C) $250/month for Inventory alone  
D) $1,000/month for Analytics at scale  

---

### Question 56
A company's network architecture uses Transit Gateway to connect 20 VPCs and 2 Direct Connect gateways. Transit Gateway pricing: $0.05/hr per attachment + $0.02/GB data processed. Monthly: 22 attachments × $0.05 × 730 = $803 attachment cost. Data processed: 50 TB × $0.02/GB = $1,024. Total: $1,827/month. The company discovers that 80% of traffic flows between only 4 VPC pairs. How can they optimize?

A) Replace the 4 high-traffic VPC pairs with direct VPC peering ($0.01/GB cross-AZ, free same-AZ). This removes 8 attachments (4 pairs = 8 VPCs off TGW) saving $292/month in attachment costs and reduces TGW data processing by 80% (40 TB × $0.02 = $800 saved). Keep TGW for the remaining 12 VPCs. New total: ~$735/month  
B) VPC peering doesn't reduce costs — all AWS data transfer costs the same  
C) Remove Transit Gateway entirely and use VPC peering mesh  
D) Add more Transit Gateway attachments for better load distribution  

---

### Question 57
A company runs a CI/CD pipeline using CodeBuild. Build configuration: general1.large (8 vCPU, 15 GB) at $0.005/build-minute. They run 500 builds/day, each averaging 15 minutes. Monthly cost: 500 × 15 × $0.005 × 30 = $1,125/month. Analysis shows that 60% of build time is downloading dependencies (npm packages, Docker layers). Which optimizations reduce CodeBuild costs? (Choose TWO)

A) Enable CodeBuild local caching (Docker layer cache and source cache) to reduce dependency download time. If caching reduces build time by 50%: new cost = $562.50/month  
B) Use a custom Docker image with pre-installed dependencies as the build environment, reducing download time  
C) Upgrade to general1.2xlarge for faster builds  
D) Run builds on EC2 Spot Instances with Jenkins instead of CodeBuild  
E) Reduce the number of builds by implementing branch-only builds instead of per-commit builds  

---

### Question 58
A company has AWS accounts across 3 Regions. They use CloudFormation StackSets to deploy infrastructure. Each deployment includes a NAT Gateway per AZ (3 AZs per Region). NAT Gateway: $0.045/hr each. They have 9 NAT Gateways (3 per Region). Monthly NAT Gateway fixed cost: 9 × $0.045 × 730 = $295.65. For development and staging environments where high availability isn't critical, what cost optimization is possible?

A) Use a single NAT Gateway per VPC in non-production environments instead of one per AZ. This reduces from 3 to 1 per Region for dev/staging, saving $0.045 × 2 × 730 = $65.70/month per non-production environment  
B) Replace NAT Gateways with NAT instances (t3.nano at $0.0052/hr). For dev/staging: 6 NAT instances at $0.0052/hr vs 6 NAT Gateways at $0.045/hr = savings of $0.0398/hr × 6 × 730 = $174.32/month  
C) Remove NAT Gateways from development environments entirely and use VPC endpoints for AWS services  
D) All three are valid strategies with increasing cost savings: A saves ~$131, B saves ~$174, C saves the most (~$197) but limits external access. Choose based on requirements  

---

### Question 59
A company runs a hybrid environment with 100 TB of data on-premises. They need to analyze this data using AWS analytics services (Athena, EMR, Redshift Spectrum). Uploading 100 TB to S3 would cost approximately $2,300/month in storage. Data changes at 5% per month. Using Direct Connect (10 Gbps), the initial transfer would take ~24 hours. What is the MOST cost-effective data strategy? (Choose TWO)

A) Use AWS Storage Gateway File Gateway to cache frequently accessed data locally while storing the full dataset in S3. Cost: S3 storage ($2,300/month) + gateway instance + data transfer  
B) Use Amazon S3 File Gateway for initial migration, then use DataSync for ongoing 5% incremental transfers (5 TB/month through Direct Connect at $0.02/GB = $102.40/month outbound transfer)  
C) Keep data on-premises and use AWS Outposts for local analytics processing  
D) Use Redshift Spectrum or Athena with S3 — accept the $2,300/month storage cost as it enables serverless analytics without provisioning dedicated compute clusters  
E) Replicate the entire 100 TB weekly to keep S3 in sync  

---

### Question 60
A company runs Amazon OpenSearch Service (Elasticsearch) with 6 r5.2xlarge.search data nodes ($0.494/hr each) and 3 r5.xlarge.search master nodes ($0.247/hr each). Monthly cost: data nodes $2,163 + master nodes $541 = $2,704/month. Storage: 10 TB on gp2 EBS. The cluster averages 25% CPU utilization and 40% memory utilization. Which optimization provides the MOST savings?

A) Right-size data nodes from r5.2xlarge to r5.xlarge (half the resources). New data node cost: 6 × $0.247 × 730 = $1,082/month. Savings: $1,081/month (40%). Memory at 40% utilization on 2xlarge (64 GB) means ~26 GB used — xlarge (32 GB) provides sufficient headroom  
B) Switch master nodes to t3.medium.search for master-eligible nodes at $0.073/hr. New master cost: 3 × $0.073 × 730 = $160/month. Savings: $381/month  
C) Combine A and B: right-size data nodes AND use smaller master nodes. Total new cost: $1,082 + $160 = $1,242/month. Total savings: $1,462/month (54%)  
D) Reduce to 3 data nodes since utilization is low  

---

### Question 61
A company migrates from self-managed Kafka on EC2 (12 × m5.2xlarge = $4,598/month) to Amazon MSK. MSK pricing for kafka.m5.large: $0.21/hr per broker. The workload needs 6 brokers minimum. MSK monthly: 6 × $0.21 × 730 = $919.80. However, MSK also charges for storage ($0.10/GB/month). The cluster stores 5 TB of data with 3x replication. What is the TOTAL MSK monthly cost?

A) Brokers: $919.80. Storage: 5 TB × 3 replicas = 15 TB = 15,000 GB × $0.10 = $1,500. Total: $2,419.80/month. Compared to self-managed $4,598/month, MSK saves $2,178/month (47%) while eliminating operational overhead  
B) $919.80 — storage is included in broker pricing  
C) $5,000/month — MSK is more expensive than self-managed  
D) $1,500/month — only storage costs apply  

---

### Question 62
A company is evaluating the total cost of a VPN-based hybrid architecture vs Direct Connect. Current: 2 Site-to-Site VPN connections ($0.05/hr each = $73/month total) with 5 TB monthly data transfer ($0.09/GB = $460.80). Direct Connect 1 Gbps: port fee $220/month + data transfer out $0.02/GB = $102.40 for 5 TB. Total VPN: $533.80/month vs Direct Connect: $322.40/month. At what data transfer volume does Direct Connect become more cost-effective than VPN?

A) Direct Connect fixed cost is higher ($220 vs $73), but per-GB is lower ($0.02 vs $0.09). Break-even: $220 + $0.02x = $73 + $0.09x → $147 = $0.07x → x = 2,100 GB ≈ 2.1 TB/month. Above 2.1 TB, Direct Connect is cheaper  
B) Direct Connect is always more expensive due to the port fee  
C) They break even at 10 TB/month  
D) VPN is always cheaper because there are no port fees  

---

### Question 63
A company runs a serverless data processing pipeline: S3 → Lambda → SQS → Lambda → DynamoDB. Processing 100 million records/month. Each record: S3 GET ($0.0004/1000), Lambda invocation 1 ($0.20/M + compute), SQS send+receive ($0.40/M for standard), Lambda invocation 2, DynamoDB write ($1.25/M WRU on-demand). What is the approximate monthly cost breakdown, and which component should be optimized FIRST for cost reduction?

A) S3: $40. Lambda 1: $20 + compute ~$500. SQS: $80. Lambda 2: $20 + compute ~$500. DynamoDB: $125. Total: ~$1,285/month. Lambda compute costs dominate — optimize memory/duration  
B) DynamoDB costs dominate at $12,500/month  
C) S3 GET costs are the largest at $40,000/month  
D) SQS costs dominate at $4,000/month  

---

### Question 64
A company uses AWS Fargate for ECS tasks. Current configuration: 100 tasks running 24/7, each with 2 vCPU and 8 GB memory. Fargate pricing: $0.04048/vCPU/hr + $0.004445/GB/hr. Monthly per-task: (2 × $0.04048 + 8 × $0.004445) × 730 = $84.89. Fleet monthly: $8,489. Traffic analysis shows only 30 tasks are needed during off-peak hours (8PM-8AM, 12 hours). Which TWO optimizations provide the MOST savings? (Choose TWO)

A) Implement ECS Service Auto Scaling to scale between 30 and 100 tasks based on request count or CPU utilization. Average task count drops to ~65, saving approximately $2,972/month (35%)  
B) Switch to Fargate Spot for fault-tolerant tasks. Fargate Spot offers up to 70% discount. Running 50% of tasks on Spot: 50 tasks × $84.89 × 0.3 = $1,273/month for those tasks vs $4,245 on regular Fargate. Savings: $2,972/month  
C) Increase task size to 4 vCPU / 16 GB and reduce task count to 50 — same total compute at same cost  
D) Migrate to EC2 launch type for lower per-unit compute costs with Reserved Instances  
E) Use ARM64/Graviton-based Fargate tasks for 20% lower pricing: 100 × $84.89 × 0.2 = $1,698/month savings  

---

### Question 65
A company's total AWS bill is $1.2 million/month. The CFO wants a 25% reduction ($300,000 savings) within 6 months. Current breakdown: EC2 (40% = $480,000), RDS (15% = $180,000), Data Transfer (12% = $144,000), S3 (10% = $120,000), Lambda (8% = $96,000), Other (15% = $180,000). Which comprehensive strategy is MOST likely to achieve the 25% target? (Choose THREE)

A) Implement a commitment-based purchasing strategy: Savings Plans/RIs for EC2 (~40% savings on $480K = $192,000) and RDS (~30% savings on $180K = $54,000). Combined: $246,000/month savings  
B) Right-size all EC2 and RDS instances using Compute Optimizer recommendations. Typically achieves 10-20% additional savings: ~$66,000-$132,000  
C) Optimize data transfer: implement VPC endpoints, CloudFront, and Direct Connect improvements for ~20% data transfer reduction: $28,800  
D) Migrate all Lambda functions to EC2 to reduce Lambda costs  
E) Delete all CloudWatch logs to reduce monitoring costs  

---

## Answer Key

### Question 1
**Correct Answer: D**

This strategy maximizes savings on the predictable base workload (80% at 62% discount with Standard RIs) while maintaining flexibility with Compute Savings Plans for the remaining 20%. Compute Savings Plans allow changing instance families, Regions, and OS without losing the commitment. Option A sacrifices all flexibility. Option B applies a lower discount rate (54%) to a larger portion. Option C has the lowest savings (31%) and requires annual conversion management.

### Question 2
**Correct Answer: A, B**

Instance size flexibility (A) means an m5.2xlarge RI (normalization factor 16) can cover the equivalent compute of smaller instances: 4× m5.xlarge (factor 8 each = 32 ÷ 16 = 2 RIs) or 8× m5.large (factor 4 each). If the company runs smaller m5 instances, unused 2xlarge RIs should automatically apply. Listing on the Marketplace (B) recovers value from genuinely unused RIs. Standard RIs cannot be converted to Convertible (C). Increasing instances (D) wastes compute. RIs cannot be deleted (E) — they're a commitment.

### Question 3
**Correct Answer: A**

Utilization measures what percentage of your commitment is being used — 92% is healthy (8% waste). Coverage measures what percentage of your total eligible compute spend is covered by the plan — 65% means 35% is at On-Demand rates. The correct action is to purchase additional Savings Plans to increase coverage, targeting ~90% coverage based on predictable baseline workload. Plans cannot be cancelled (B). The metrics measure different things than C suggests.

### Question 4
**Correct Answer: A**

The `capacityOptimized` strategy across multiple instance types and AZs minimizes interruption by placing instances in the optimal Spot pools. Multiple instance types increase available capacity pools. S3 checkpointing every 15 minutes means at most 15 minutes of work is lost on interruption. A single instance type (B) is vulnerable to capacity exhaustion. On-Demand (C) is 3x more expensive. Spot Blocks (D) are no longer available for new customers.

### Question 5
**Correct Answer: C**

The requirement for <100ms retrieval eliminates Glacier Flexible Retrieval (minimum 1-5 minute retrieval for expedited). Standard-IA handles the 40% infrequent access at lower cost. Glacier Instant Retrieval provides millisecond retrieval at the lowest storage cost for the 25% and 10% tiers. Option B incorrectly puts the 10% in Glacier Flexible Retrieval, violating the latency requirement. Intelligent-Tiering (A) adds monitoring fees for known access patterns. One Zone-IA (D) sacrifices durability.

### Question 6
**Correct Answer: B**

Both S3 and DynamoDB support Gateway VPC endpoints, which are free (no hourly charge, no data processing charge). S3 savings: 10 TB × 1,024 GB × $0.045 = $460.80. DynamoDB savings: 2 TB × 1,024 GB × $0.045 = $92.16. Total savings: ~$553/month (approximately $630 when using exact TB to GB conversion). Gateway endpoints eliminate the NAT Gateway data processing charge for traffic to these services.

### Question 7
**Correct Answer: A**

With Price Class 200, South American and Australian viewers (~10% of traffic = 50 TB) are served from the nearest included edge location (US or Asia), with slightly higher latency but still acceptable for video. The savings come from not paying the premium pricing tiers ($0.140-0.160/GB) for that 10% of traffic. Instead, it's served at North American/European rates. The exact savings depend on CDN routing, but eliminating the highest-cost edge locations for a small percentage of traffic is a good trade-off.

### Question 8
**Correct Answer: A**

Provisioned capacity with auto-scaling matches the predictable daily pattern: low at night, high during day, moderate on weekends. Reserved capacity for the baseline (minimum sustained load) locks in the lowest rate. Auto-scaling handles the daily fluctuations. On-demand (B) is the most expensive mode for predictable high-throughput workloads. Fixed provisioning (C) wastes capacity during off-peak. DAX (D) helps with reads but doesn't address write costs.

### Question 9
**Correct Answer: A**

RDS Reserved Instance size flexibility (for the same engine and family) uses normalization factors. db.r5.2xlarge has a normalization factor of 16, and db.r5.4xlarge has a factor of 32. So 2× db.r5.2xlarge RIs = 1× db.r5.4xlarge equivalent. The 60 RIs can be flexed to cover a mix of sizes within the r5 family. This is not locked to exact size (B), does apply to RDS (C), and 2xlarge doesn't equal one 4xlarge (D).

### Question 10
**Correct Answer: B**

At 512 MB: 0.512 × 0.8 = 0.4096 GB-s. At 1024 MB: 1.024 × 0.4 = 0.4096 GB-s. Same GB-second cost but 1024 MB gives 2x faster execution (better user experience) at the same price. At 1536 MB: 0.5837 GB-s (43% more expensive). At 2048 MB: 0.768 GB-s (88% more expensive). The 1024 MB configuration hits the optimal price-performance point where doubling memory exactly halves duration.

### Question 11
**Correct Answer: C**

The hybrid approach hedges against the uncertain third year. 3-year RIs for 70% of the baseline captures maximum savings on the guaranteed portion. 1-year RIs for 30% provide flexibility — if requirements change after year 2, those 1-year RIs can be adjusted. All 3-year (B) risks paying for unused capacity if requirements change. All 1-year (A) sacrifices 18% additional savings on the baseline. All On-Demand (D) wastes money on a predictable workload.

### Question 12
**Correct Answer: A**

gp3 base price ($0.08/GB) is 20% less than gp2 ($0.10/GB) for the same storage. For 50 TB: $1,000/month savings on storage alone. gp3's baseline of 3,000 IOPS (vs requirement of 500) and 125 MB/s throughput means only the additional 75 MB/s throughput needs to be provisioned. The per-GB savings is the dominant factor at this scale. gp2 and gp3 have different pricing (B is wrong). gp3 has no minimum size (D is wrong).

### Question 13
**Correct Answer: A, D, E**

Activating cost allocation tags (A) enables cost tracking by tag in Cost Explorer and CUR. Tag policies (D) enforce consistent tagging across the Organization. Cost Explorer (E) provides analysis by tag dimensions. Tag Editor (B) helps find and tag resources but doesn't enforce or allocate costs. The `aws:createdBy` tag (C) tracks who created resources but doesn't provide project/team/environment attribution.

### Question 14
**Correct Answer: A**

Current NAT Gateway data processing: 50,000 GB × $0.045 = $2,250/month (close to $2,304 with exact conversion). After implementing S3 and DynamoDB Gateway endpoints (both free): remaining 10 TB external API traffic = 10,240 GB × $0.045 = $460.80/month. Savings: ~$1,789/month. Both S3 and DynamoDB support Gateway endpoints, making B incorrect. NAT Gateway does charge per GB (D is wrong).

### Question 15
**Correct Answer: A**

The Redshift Reserved Node Exchange feature allows exchanging DS2 reserved nodes for RA3 reserved nodes, applying the remaining term value. RA3 nodes use managed storage (S3-backed), so the 50 TB cluster with only 20 TB hot data benefits from RA3's architecture — hot data cached locally, cold data in S3. This may allow using fewer RA3 nodes than DS2 nodes. The exchange preserves the reserved pricing benefit.

### Question 16
**Correct Answer: A**

Compute Optimizer uses CloudWatch metrics for recommendations. By default, EC2 instances report CPU, network, and disk metrics, but NOT memory. Installing the CloudWatch Agent enables memory metrics. Compute Optimizer incorporates these for more accurate recommendations — without memory metrics, it might recommend undersized instances that would OOM. Compute Optimizer doesn't auto-collect memory (B). Detailed monitoring (C) adds frequency, not new metrics.

### Question 17
**Correct Answer: A, B, E**

VPC endpoints (A) eliminate NAT Gateway data processing charges for AWS service traffic — often 30-50% of data transfer costs. CloudFront (B) offers lower data transfer rates ($0.085/GB vs $0.09/GB from EC2) and reduces origin data transfer through caching. Direct Connect (E) reduces per-GB data transfer rates from $0.09 to $0.02 for outbound traffic. Consolidating AZs (C) would sacrifice high availability. Transfer Acceleration (D) increases S3 upload costs.

### Question 18
**Correct Answer: D**

Fargate Spot offers up to 70% discount over regular Fargate pricing and handles interruptions gracefully by draining tasks. For batch processing that can tolerate interruptions, Fargate Spot at ~$2,137/month combines low cost with serverless simplicity (no instance management). EC2 Spot (A) is cheaper but requires managing instances. Regular Fargate (B) and On-Demand (C) are significantly more expensive.

### Question 19
**Correct Answer: D**

Aurora Serverless v2 for readers provides the most dynamic cost optimization. During low-traffic periods, readers scale down to minimum ACU (2 ACU × $0.12/ACU-hr = $0.24/hr vs $1.16/hr for db.r5.2xlarge). During peak, they scale up. The 30% average utilization with spikes to 70% is a perfect fit for Serverless v2's scaling model. Auto Scaling (A) only adjusts the number of readers (integer scaling). Removing readers (B) eliminates read scaling. Halving size (C) risks peak capacity issues.

### Question 20
**Correct Answer: B**

Express Workflows at $19.05/month are significantly cheaper than Standard Workflows at $37.50/month for this workload. Express Workflows support up to 5-minute executions (D is wrong — 30 seconds is well within limits). The per-request plus duration-based pricing of Express is more cost-effective for high-volume, short-duration workflows. Standard Workflows' per-transition pricing becomes expensive with many state transitions.

### Question 21
**Correct Answer: A**

With consolidated billing in AWS Organizations, RI benefits are shared across all accounts by default. Account B's 5 RIs apply to Account B's matching instances first, then unused RIs apply to matching instances in other accounts. Since Account B may not run m5.xlarge instances, all 5 RIs could apply to Account A. RI sharing can be disabled if needed. RIs are not account-locked (B), not split evenly (C), and don't require manual linking (D).

### Question 22
**Correct Answer: A, B**

With a low baseline (100 req/s) and dramatic spikes (10,000 req/s), provisioned concurrency would over-provision 99% of the time. On-demand pricing only charges for actual invocations (A). Graviton2 Lambda (B) provides a flat 20% price reduction on all invocations regardless of traffic pattern. Memory optimization (C) might help but doesn't guarantee savings if GB-s stays constant. Reserved concurrency (D) limits max concurrency but doesn't save money.

### Question 23
**Correct Answer: A, B**

Aurora's storage auto-scaling (A) means you only pay for used storage (starts at 10 GB, grows in 10 GB increments). RDS requires pre-provisioning storage. For a 2 TB database that might grow to 5 TB, RDS requires provisioning ahead while Aurora grows automatically. Aurora read replicas share storage (B) — adding a replica costs only compute, not additional storage. RDS read replicas need separate EBS volumes. RDS Multi-AZ standby does incur cost (C is wrong).

### Question 24
**Correct Answer: A**

CloudFront caching 80% of requests dramatically reduces backend costs. 40 million cached requests never hit Lambda or DynamoDB. At $0.20/million Lambda invocations + compute costs + DynamoDB RCU costs, the savings from 40M fewer backend calls far exceed CloudFront's data transfer cost of ~$212. API responses with appropriate Cache-Control headers are very cacheable. API Gateway doesn't cache by default (D).

### Question 25
**Correct Answer: D**

VPC peering is cheaper for point-to-point connections due to lower per-GB rates ($0.01 vs $0.05). However, Transit Gateway provides centralized routing for many-to-many connectivity. For 2 VPCs, peering saves $600+/month. But once you need to connect 5+ VPCs, the mesh of peering connections becomes unmanageable, and Transit Gateway's centralized model provides operational benefits that justify the cost premium.

### Question 26
**Correct Answer: C**

For frequently accessed objects with a 90-day lifecycle, the Intelligent-Tiering monitoring fee ($0.0025/1000 objects/month) adds cost with minimal benefit. If objects are accessed within 30 days, they stay in the Frequent Access tier (same price as Standard) while paying the monitoring fee. S3 Standard avoids the per-object monitoring overhead. Intelligent-Tiering is best for unknown or changing access patterns, not for consistently accessed data.

### Question 27
**Correct Answer: D**

A 1-year Standard RI at 40% discount costs $2.42/hr, but you're billed for all 24 hours. Daily RI cost: $2.42 × 24 = $58.08, which EXCEEDS the On-Demand cost of $48.38 (12 hours × $4.032). For workloads running less than ~60% of the time, full-period RIs can be more expensive than On-Demand. Spot Instances with checkpointing provide the best savings for interruptible batch processing. Scheduled Reserved Instances (A) have been discontinued for new purchases.

### Question 28
**Correct Answer: C**

A 1 Gbps Direct Connect at $220/month provides sufficient bandwidth for essential traffic during failover at a fraction of 10 Gbps cost. A VPN (B) at $72/month is cheapest but has variable latency and limited bandwidth. A full 10 Gbps backup (A) is expensive redundancy. No redundancy (D) is a risk — Direct Connect doesn't have built-in redundancy (AWS recommends redundant connections). The 1 Gbps option balances cost and capability.

### Question 29
**Correct Answer: A**

Root volumes: gp3 ($0.08/GB vs gp2 $0.10/GB), 3,000 baseline IOPS >> 100 needed. Application volumes: switching from io1 ($0.125/GB + $0.065/IOPS) to gp3 ($0.08/GB, 3,000 IOPS included) saves ~60% since only 1,200 IOPS are used (well within gp3 baseline). Log volumes: st1 ($0.045/GB) designed for sequential throughput at 500 MB/s per TB, perfect for log workloads at 55% savings over gp2. Option B ignores the optimal st1 choice for logs. Option C wastes money on io1 for low IOPS usage.

### Question 30
**Correct Answer: A**

At $30,000/month, Rekognition is by far the largest cost component (77% of total). Lambda compute is significant at ~$3,840 but secondary. The most impactful optimization is reducing Rekognition API calls — combining multiple analyses into fewer calls (e.g., using DetectLabels with all feature types instead of separate calls for labels, faces, and text) could reduce Rekognition costs by 66%.

### Question 31
**Correct Answer: A**

AWS Backup creates incremental backups after the initial full backup. Only changed blocks are stored in subsequent backups. With a 3% daily change rate for EBS, the 29 incremental backups each store only 3% of the volume size, dramatically reducing storage compared to 30 full backups. This makes backup storage roughly: 1 full + 29 × 3% ≈ 1.87x the volume size instead of 30x. Incremental backup pricing is per-GB of backup data stored.

### Question 32
**Correct Answer: A, B**

Consistent tagging with cost allocation tags (A) enables cost tracking in Cost Explorer and Cost and Usage Reports. AWS Cost Categories (B) provide rules-based cost grouping that can handle shared resources (like data transfer, support charges) by distributing them across tenants proportionally. Separate accounts (C) is the most accurate but operationally complex. CloudWatch estimation (D) is manual and inaccurate. Cost Explorer (E) depends on tags being applied first.

### Question 33
**Correct Answer: A, B**

Karpenter (A) improves bin-packing by selecting optimal instance types for pending pods, reducing wasted capacity. With 35% CPU utilization, better bin-packing could reduce nodes by 30-40%. Spot instances (B) for stateless workloads save 60-70% on those nodes. Combined, these could reduce costs by 50-60%. Increasing minimum (C) increases cost. Fargate (D) costs more per vCPU. Larger instances (E) don't improve utilization.

### Question 34
**Correct Answer: C**

AWS DataSync with compression can significantly reduce the volume of data transferred over the wire, directly reducing data transfer costs. For compressible data (logs, text, JSON), compression ratios of 40-60% are common, reducing the 20 TB to 8-12 TB effectively. CRR itself charges the same per-GB rate (A). VPC peering is not free cross-Region (B). Cross-Region transfer is never free (D).

### Question 35
**Correct Answer: A**

Enhanced fan-out consumers at $0.013/shard-hour per consumer represent the largest cost component ($4,745/month for 5 consumers vs $1,095 for shards). Consolidating from 5 consumers to 2-3 saves $949-$1,898/month. Alternatively, switch some consumers to standard (non-enhanced) fan-out which has no per-shard-hour cost. Enhanced fan-out is not free (D). PUT costs (C) and shard costs (B) are smaller.

### Question 36
**Correct Answer: A**

Total Config cost: $1,500 (recordings) + $10,000 (evaluations) = $11,500/month. Rule evaluations dominate costs. Optimization: only record resource types that have corresponding rules (eliminating unnecessary recordings), use periodic evaluations for rules that don't need real-time change detection, and consolidate rules where possible. Config does charge per recording and per evaluation (B, C are wrong). Recording scope can be customized (D is wrong).

### Question 37
**Correct Answer: A**

The main costs are: metrics ($60), alarms ($5), log ingestion ($250), and log storage (growing monthly). After 12 months, 6 TB of logs at $0.03/GB = $180/month in storage alone. The biggest optimization is reducing log retention and archiving to S3 ($0.023/GB) instead of CloudWatch ($0.03/GB), or reducing log verbosity. High-resolution metrics don't add per-metric cost but increase API call costs for dashboards. CloudWatch is not free (D).

### Question 38
**Correct Answer: B**

Pausing the Redshift cluster outside business hours saves 70% on compute costs. Paused clusters only pay for underlying storage (snapshot storage). Running 220 hours vs 730 hours: $10,560 vs $35,040, saving ~$24,480/month. Redshift Serverless (A) is also viable but may cost more depending on RPU consumption patterns. Resizing (C) addresses sizing, not idle time. Athena migration (D) is a different architecture decision.

### Question 39
**Correct Answer: A**

Graviton2 instances offer 40% better price-performance, meaning you can handle the same workload with fewer instances. If 10 c5.2xlarge instances are needed, approximately 7 c6g.2xlarge instances can handle the same throughput. At $0.272/hr × 7 = $1.904/hr vs current $3.40/hr, savings are 44% ($1,092/month). The savings come from both the lower per-instance price AND the reduced instance count.

### Question 40
**Correct Answer: A**

S3 Intelligent-Tiering is ideal for unpredictable access patterns. It automatically moves objects between Frequent and Infrequent Access tiers based on access patterns with no retrieval fees. The monitoring cost ($0.0025/1000 objects) is minimal. Lifecycle policies (B, D) require predicting access patterns, which is impossible here. S3 Standard (C) is the most expensive option for objects that become infrequently accessed.

### Question 41
**Correct Answer: A, B**

Aurora Auto Scaling (A) eliminates always-on readers during low-traffic periods. At 30% average CPU, scaling from 2 to 1 reader during off-peak saves ~$1,501/month per Region. Serverless v2 for EU readers (B) provides even more granular scaling — during European night hours (US business hours), EU readers scale to minimum ACU, saving more than fixed instances. Eliminating replication (C) destroys DR capability. Smaller instances (D) save less than dynamic scaling.

### Question 42
**Correct Answer: D**

Aggregating sensor readings before writing to DynamoDB has the largest impact. Instead of writing every 5-second reading individually (20,000 writes/s), aggregating to per-minute averages reduces writes by 12x (~1,667/s). This reduces DynamoDB WCU from 20,000 to ~1,667, saving ~92% on DynamoDB costs ($8,730/month saved). On-demand mode (B) would be more expensive. Streams (C) don't reduce write costs. Batching (A) reduces API calls but not WCU consumption.

### Question 43
**Correct Answer: A, B**

HTTP API is 70% cheaper than REST API ($1.00 vs $3.50 per million). Migration saves $750/month for 300M calls (A). However, HTTP API doesn't support request/response transformation templates (B) — the company must evaluate if this feature is needed. If transformation is critical, they could implement it in Lambda instead. API caching (C) reduces backend costs but adds cache hourly cost. REST and HTTP have different pricing (D is wrong).

### Question 44
**Correct Answer: A**

The tiered approach saves $218.50/month ($2,622/year). Backups accessed within 7 days stay in Standard for immediate access. Backups 7-30 days old move to Glacier Instant Retrieval at $0.004/GB (83% cheaper than Standard) with millisecond retrieval for DR needs. The annual DR retrieval cost ($5) is negligible. Full Standard (current) wastes money on rarely-accessed backups. Deep Archive (C) has 12-hour retrieval — unacceptable for DR. One Zone-IA (D) risks data loss.

### Question 45
**Correct Answer: A**

Running instances only during work hours (8 hrs × 22 days = 176 hrs/month vs 730 hrs/month) saves 76%. For 100 t3.micro instances: $183.04 vs $759.20. Annual savings: $6,914. Implementation using EventBridge Scheduler or Instance Scheduler is straightforward. EBS volumes do still incur charges (D mentions this) but at $0.10/GB/month, even 500 GB of EBS = $50/month — negligible compared to instance savings.

### Question 46
**Correct Answer: A**

Total WAF cost: $425/month broken down as web ACLs ($25), rules ($100), and request charges ($300). Request charges are the largest component (71%). Optimizations: consolidate web ACLs to reduce base costs, remove unused rules, and use scope-down statements to reduce evaluated requests. Shield Advanced (D) doesn't eliminate WAF costs — it provides DDoS protection.

### Question 47
**Correct Answer: A**

When factoring in total cost including storage, all three options have different trade-offs. Aurora's pay-per-use storage is cost-effective for growing databases. RDS's provisioned storage is predictable. EC2 is cheapest in raw compute but requires managing HA, backups, patching, and monitoring — the DBA salary likely exceeds the savings. For most organizations, Aurora provides the best long-term value through operational savings and flexible scaling.

### Question 48
**Correct Answer: A**

Even with 10% interruption requiring reprocessing, total Spot cost ($6,600) is 68% less than On-Demand ($20,400). Spot instances are not charged for the partial hour when interrupted (C is partially correct). The reprocessing cost accounts for re-running failed work. The 70% savings far outweigh the 10% interruption penalty. Spot is never more expensive than On-Demand even with interruptions (B is wrong).

### Question 49
**Correct Answer: A**

PUT operations at $750/month are the most expensive component (67% of request costs), followed by LIST at $250 and GET at $120. Optimizing PUT patterns — combining small objects, using multipart uploads for large objects, reducing unnecessary PUTs — provides the largest cost reduction. GET costs are lower despite higher volume because GET pricing is 12.5x cheaper per request than PUT/LIST.

### Question 50
**Correct Answer: A, B**

Reducing metric resolution (A) from 10 seconds to 60 seconds for non-critical metrics reduces API calls by ~6x, directly cutting GetMetricData costs. Metric Streams (B) provide a push-based model that's more cost-effective for dashboards than repeated pull-based API calls, especially at scale. Composite alarms (E) help but are less impactful. More dashboards (C) increase costs. Disabling monitoring (D) is reckless.

### Question 51
**Correct Answer: C**

Combining Glue 4.0 auto-scaling with data skew fixes provides the best optimization. Auto-scaling right-sizes DPU allocation dynamically (instead of fixed 50 DPUs), and fixing data skew reduces job duration. Together, savings of 50-60% are achievable. Simply fixing skew (A) saves 40% but still over-provisions DPUs. Increasing DPUs (B) adds cost. EMR migration (D) adds operational complexity.

### Question 52
**Correct Answer: A, B, D**

Right-sizing provisioned concurrency (A) eliminates 60% waste on the provisioned concurrency spend. Reducing timeouts (B) prevents runaway executions that could cause unexpected cost spikes. Graviton2 (D) provides a flat 20% reduction across all Lambda compute costs — the single largest percentage savings applicable to the entire bill. Rarely-invoked functions (C) contribute minimal cost. Lambda Insights (E) adds cost.

### Question 53
**Correct Answer: A**

At 100 messages/second, Amazon MQ is over-provisioned. SQS at $0.40/million messages handles this workload for ~$104/month vs $490/month for MQ. SQS and SNS provide queue and pub/sub patterns natively. For simple messaging patterns without JMS/AMQP protocol requirements, SQS/SNS is the most cost-effective choice. Downsizing MQ (B) saves less. MSK (C) is overkill for this volume.

### Question 54
**Correct Answer: B, C**

Compute Savings Plans (B) for On-Demand instances provide ~37% savings with flexibility to change instance types. Converting 50% of On-Demand to Spot (C) where workloads allow saves 60-70% on those instances. Combined: Savings Plans for 100 On-Demand + Spot for 100 instances could save $90,000-$120,000 on the On-Demand portion alone. Standard RIs (A) have less flexibility than Savings Plans. EDP (D) requires significant minimum spend commitments.

### Question 55
**Correct Answer: A**

S3 Inventory at $0.0025 per million objects × 100M × 4 weeks = $1.00/month. Storage Class Analysis at $0.10 per million objects × 100M = $10.00/month. Total: $11.00/month. These management features are extremely cost-effective compared to the ~$1,150/month storage cost for 50 TB. Inventory and Analytics are not free (B) but are inexpensive at any scale.

### Question 56
**Correct Answer: A**

Replacing the 4 high-traffic VPC pairs (80% of data) with direct VPC peering eliminates $800/month in TGW data processing and reduces attachment costs. VPC peering charges $0.01/GB for cross-AZ traffic (vs $0.02/GB for TGW), saving an additional amount on per-GB pricing. The remaining 12 VPCs continue using TGW for simplified routing. This hybrid approach optimizes cost for high-traffic flows while maintaining TGW convenience for the rest.

### Question 57
**Correct Answer: A, B**

Local caching (A) stores Docker layers and dependencies between builds, eliminating repeated downloads. This can reduce build time by 40-60%, directly reducing per-minute CodeBuild charges. Custom Docker images (B) with pre-installed dependencies reduce build-time dependency resolution. Combined, these could reduce build time from 15 to 5-7 minutes, saving $500-700/month. Upgrading instances (C) costs more per minute.

### Question 58
**Correct Answer: D**

All three strategies are valid with escalating savings. Single NAT Gateway per VPC (A) saves ~$131/month for dev/staging. NAT instances (B) save ~$174/month. Eliminating NAT Gateways and using VPC endpoints + proxy (C) saves the most but limits external access. The optimal choice depends on non-production requirements: if instances only need AWS service access, VPC endpoints eliminate NAT entirely.

### Question 59
**Correct Answer: B, D**

DataSync for incremental transfers (B) efficiently handles the 5% monthly changes (5 TB) with compression and scheduling. Accepting S3 storage costs (D) enables serverless analytics with Athena and Redshift Spectrum — no dedicated compute clusters needed, paying only for queries. Storage Gateway (A) adds gateway costs and complexity. Outposts (C) requires significant capital investment. Full weekly replication (E) wastes bandwidth and cost.

### Question 60
**Correct Answer: C**

Combining data node right-sizing and master node downsizing saves 54% ($1,462/month). Data nodes at 25% CPU and 40% memory on r5.2xlarge (64 GB RAM) can safely downsize to r5.xlarge (32 GB RAM) — 40% of 64 GB = 26 GB used, fitting within 32 GB. Master nodes handle cluster management and don't need r5.xlarge resources. Combined savings exceed either optimization alone. Reducing to 3 data nodes (D) risks cluster stability.

### Question 61
**Correct Answer: A**

MSK total cost includes both broker and storage charges. Brokers: $919.80 + Storage: $1,500 = $2,419.80/month. Compared to self-managed Kafka on EC2 at $4,598/month, MSK saves 47% while providing managed patching, monitoring, and scaling. Storage is NOT included in broker pricing (B). The combined cost is still less than self-managed (C). Both components contribute to total cost (D).

### Question 62
**Correct Answer: A**

The break-even calculation: Direct Connect fixed + variable = VPN fixed + variable. $220 + $0.02x = $73 + $0.09x. $147 = $0.07x. x = 2,100 GB ≈ 2.1 TB. Above 2.1 TB/month, Direct Connect is cheaper. At 5 TB: DX = $322.40, VPN = $533.80. At 1 TB: DX = $240.48, VPN = $165.16. The lower per-GB rate of Direct Connect dominates at higher transfer volumes, while VPN's lower fixed cost wins at low volumes.

### Question 63
**Correct Answer: A**

Lambda compute costs (~$1,000 combined for both functions) dominate the pipeline cost. S3 requests ($40), SQS ($80), Lambda request fees ($40), and DynamoDB ($125) are relatively minor. Optimizing Lambda memory/duration through right-sizing, code optimization, or switching to a compiled language can significantly reduce the compute portion. DynamoDB on-demand at $1.25/M WRU for 100M = $125, not $12,500 (B).

### Question 64
**Correct Answer: A, B**

ECS Auto Scaling (A) reduces average task count from 100 to ~65 by scaling down during off-peak (30 tasks for 12 hours vs 100 for 12 hours). Savings: ~$2,972/month. Fargate Spot (B) for stateless tasks provides up to 70% discount. Running half the fleet on Spot saves ~$2,972/month. Combined potential savings: ~$5,944/month (70%). Graviton2 (E) saves 20% but less than A or B. Larger tasks (C) don't save money.

### Question 65
**Correct Answer: A, B, C**

Savings Plans/RIs (A) targeting EC2 ($192K) and RDS ($54K) savings = $246K — the single largest lever. Right-sizing (B) provides additional 10-20% savings on an already-committed base: $66K-$132K. Data transfer optimization (C) saves ~$29K. Combined worst case: $246K + $66K + $29K = $341K (28.4% savings), meeting the 25% target. Migrating Lambda to EC2 (D) likely increases cost and reduces agility. Deleting logs (E) is reckless and provides minimal savings.

---

**End of Practice Exam 30**

### Scoring Guide
- **Cost-Optimized Architecture:** Questions 1-15, 19-20, 22, 24-31, 38-45, 48-49, 51-58, 60-65
- **Security:** Questions 13, 32, 36, 46
- **Resilient Architecture:** Questions 4, 16, 18, 23, 27, 33-34, 41, 47, 53, 59
- **High-Performing Technology:** Questions 8, 10, 17, 21, 35, 37, 42, 50
