# Flashcards — Domain 1: Cloud Concepts

Q: Name the 6 benefits of cloud computing (per AWS).
A: 1) CapEx→variable expense; 2) Economies of scale; 3) Stop guessing capacity; 4) Speed & agility; 5) Stop running data centers; 6) Go global in minutes. #must-know

Q: Which benefit corresponds to "shut down dev env at night"?
A: Trading CapEx for variable / pay-as-you-go (and cost optimization). #must-know

Q: What are the 5 NIST cloud characteristics?
A: On-demand self-service, broad network access, resource pooling, rapid elasticity, measured service. #nist

Q: What does IaaS stand for, and give an AWS example.
A: Infrastructure-as-a-Service. EC2. #must-know

Q: PaaS example on AWS?
A: Elastic Beanstalk, App Runner, RDS. #must-know

Q: SaaS example on AWS?
A: Chime, WorkMail, Marketplace SaaS apps. #must-know

Q: Is AWS Outposts hybrid or on-prem?
A: Hybrid — AWS-managed rack in your data center. #must-know

Q: Name the 6 pillars of the Well-Architected Framework.
A: Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability. #must-know

Q: Which WAF pillar was added in 2021?
A: Sustainability. #must-know

Q: Give 2 design principles of Operational Excellence.
A: Perform operations as code; make frequent, small, reversible changes; anticipate failure; learn from failure. #pillars

Q: Give 2 design principles of Security.
A: Strong identity foundation, enable traceability, defense in depth, automate security, protect data in transit/at rest, keep people away from data. #pillars

Q: Give 2 design principles of Reliability.
A: Auto-recover from failure, test recovery procedures, scale horizontally, stop guessing capacity, manage change through automation. #pillars

Q: Give 2 design principles of Cost Optimization.
A: Consumption model, measure efficiency, stop spending on undifferentiated heavy lifting, analyze and attribute spending. #pillars

Q: What does elasticity mean?
A: Automatic scaling (up/down) to match demand. #must-know

Q: Difference between scalability and elasticity?
A: Scalability = ability to grow. Elasticity = scalability that happens automatically and quickly. #must-know

Q: HA vs Fault Tolerance?
A: HA minimizes downtime during failures. Fault Tolerance = zero loss through failure; usually full redundancy. #must-know

Q: S3's 11 nines refers to what?
A: Durability (probability of not losing data). #must-know

Q: S3 Standard's SLA (availability) is?
A: 99.99%. #must-know

Q: What is RTO?
A: Recovery Time Objective — how long until the system is back up. #must-know

Q: What is RPO?
A: Recovery Point Objective — how much data loss is acceptable (in time). #must-know

Q: 4 DR strategies from cheapest to most expensive?
A: Backup & Restore → Pilot Light → Warm Standby → Multi-site active-active. #must-know

Q: Which DR strategy provides RPO/RTO near zero?
A: Multi-site active-active. #must-know

Q: Minimum AZs per modern AWS Region?
A: 3. #must-know

Q: What is an Edge Location used for?
A: CloudFront, Route 53, Global Accelerator, WAF, Shield. #must-know

Q: What is a Local Zone?
A: Extension of a Region in a metro for single-digit-ms latency. #must-know

Q: Wavelength Zones live where?
A: Inside telco 5G networks. #must-know

Q: List the 7 R's of migration.
A: Retire, Retain, Rehost, Relocate, Repurchase, Replatform, Refactor. #must-know

Q: "Drop and shop" migration is which R?
A: Repurchase. #must-know

Q: VMware-specific migration strategy is which R?
A: Relocate. #must-know

Q: Managed MySQL → self-managed MySQL becoming RDS MySQL is which R?
A: Replatform. #must-know

Q: Which AWS service is block-level rehost migration for on-prem servers?
A: AWS Application Migration Service (MGN). #must-know

Q: Which AWS service migrates databases online with minimal downtime?
A: AWS Database Migration Service (DMS). #must-know

Q: Which tool converts schema heterogeneously (Oracle → Aurora PG)?
A: AWS Schema Conversion Tool (SCT). #must-know

Q: AWS CAF perspectives?
A: Business, People, Governance, Platform, Security, Operations. #must-know

Q: Which CAF perspective owns FinOps / cloud financial management?
A: Governance. #caf

Q: Which CAF perspective owns training and org design?
A: People. #caf

Q: 4 factors for choosing an AWS Region?
A: Compliance/data residency, Latency, Service availability, Pricing. #must-know

Q: Is us-east-1 usually cheapest?
A: Yes — typically the cheapest and usually first to get new services. #cost

Q: Can data leave a Region without explicit action?
A: No — data stays in the Region you chose unless you replicate it. #data-residency

Q: Are GovCloud/China/Secret Regions in the normal AWS partition?
A: No — they are separate partitions with separate accounts. #partitions

Q: What's AWS Pricing Calculator?
A: Web tool to estimate costs before deploying. #domain4

Q: What does economies of scale mean from a customer POV?
A: AWS's aggregate buying power translates into lower unit prices over time. #must-know

Q: Define "measured service" (NIST).
A: Metered usage → pay-as-you-go billing. #nist

Q: Define "resource pooling" (NIST).
A: Multi-tenancy pool of infrastructure serving many customers. #nist

Q: WAF Lenses — name 3.
A: Serverless, SaaS, Financial Services, Healthcare, IoT, ML, Data Analytics, Sustainability, GenAI, Hybrid Networking, Streaming Media, Games Industry. #lenses

Q: WAF vs WAF Lens?
A: WAF is the general framework; Lenses are domain-specific add-ons to it. #lenses

Q: What does the Well-Architected Tool do?
A: Lets you document a workload and answer structured questions to assess risks. #must-know

Q: Is the Well-Architected Tool free?
A: Yes. #cost

Q: Who performs Well-Architected Reviews?
A: You (self), AWS SAs (free), or Partners. #support

Q: What is a "landing zone"?
A: A well-architected, multi-account AWS environment baseline. #caf

Q: AWS's opinionated landing zone?
A: AWS Control Tower. #caf

Q: What's IaaS's main advantage over SaaS?
A: Maximum control over OS, network, app. #service-models

Q: What's SaaS's main advantage over IaaS?
A: Minimal responsibility; AWS/vendor handles everything. #service-models

Q: Name 3 cloud deployment models.
A: Cloud (public), Hybrid, On-prem. #must-know

Q: Which is a hybrid characteristic?
A: Mix of on-prem and cloud, usually connected via VPN/Direct Connect. #must-know

Q: Define "rapid elasticity" (NIST) in AWS terms.
A: Auto Scaling Group adds/removes EC2 instances to match demand in minutes. #nist

Q: What is CapEx?
A: Capital expenditure — upfront purchase of assets. #must-know

Q: What is OpEx?
A: Operational expenditure — ongoing metered consumption. #must-know

Q: Which cloud benefit emphasizes lower per-unit cost as AWS scales?
A: Economies of scale. #must-know

Q: Describe "loose coupling" as a design principle.
A: Decouple components via queues/events/APIs so failure is contained. #must-know

Q: Describe "design for failure".
A: Assume components will fail; design for isolation, redundancy, and auto-recovery. #must-know

Q: What is the "7 R" that represents keeping the app on-prem for now?
A: Retain. #must-know

Q: Who said "Everything fails, all the time"?
A: Werner Vogels (AWS CTO). #meta

Q: Why did CLF-C02 replace CLF-C01?
A: To modernize content, consolidate domains, and emphasize cloud economics and service selection. #exam-meta

Q: Exam length (CLF-C02)?
A: 90 minutes. #exam-meta

Q: Number of questions (CLF-C02)?
A: 65 total; 50 scored, 15 unscored. #exam-meta

Q: Passing score?
A: 700 / 1000 (scaled). #exam-meta

Q: Validity of certification?
A: 3 years. #exam-meta

Q: Cost in USD?
A: $100 + taxes. #exam-meta

Q: Is there a prerequisite for CCP?
A: No formal prerequisite. #exam-meta

Q: Question formats on CCP?
A: Multiple choice (1 correct) and multiple response (2 of 5 / 3 of 6). #exam-meta

Q: Can you mark and review questions?
A: Yes — "Mark for Review" with a side panel summary. #exam-meta

Q: Online proctoring partner?
A: Pearson VUE. #exam-meta
