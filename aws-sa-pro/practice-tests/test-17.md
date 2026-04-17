# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 17

**Focus Areas:** Auto Scaling Advanced, Spot Instances, Placement Groups, EBS Optimization, Performance Engineering
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A global e-commerce company operates across 12 AWS accounts under AWS Organizations, each running Auto Scaling groups for their regional storefront. The central platform team needs to enforce that all Auto Scaling groups across the organization use only approved AMI IDs, specific instance families, and mandatory tags. Deviations must be prevented, not just detected.

Which approach provides preventive enforcement across all accounts?

A. Deploy AWS Config rules in each account to detect non-compliant Auto Scaling groups and auto-remediate by terminating non-compliant instances.

B. Create SCPs that deny autoscaling:CreateLaunchConfiguration and autoscaling:CreateAutoScalingGroup unless the request includes approved instance types via condition keys, and use tag policies for mandatory tags. Distribute approved AMI IDs via a shared AWS Systems Manager Parameter Store parameter.

C. Use CloudFormation StackSets to deploy IAM policies in all accounts that restrict Auto Scaling operations to approved configurations.

D. Implement a centralized Lambda function that monitors CloudTrail events for Auto Scaling API calls and rolls back non-compliant changes.

**Correct Answer: B**

**Explanation:** SCPs (B) provide preventive, organization-wide enforcement. The ec2:InstanceType condition key in SCPs restricts which instance types can be launched. Tag policies enforce mandatory tag keys and values. Sharing approved AMIs via SSM Parameter Store provides a central source of truth. SCPs apply automatically to all accounts, including new ones. Option A is detective, not preventive — non-compliant resources exist briefly before remediation. Option C's IAM policies can be modified by account administrators. Option D is reactive with potential delay.

---

### Question 2

A financial services company manages 30 AWS accounts, each with production Auto Scaling groups. The risk team requires that no account can modify the minimum capacity of production ASGs below a specified threshold during market hours (9:30 AM - 4:00 PM ET). Outside market hours, standard capacity management should apply.

Which solution enforces time-based Auto Scaling restrictions?

A. Create an SCP that denies autoscaling:UpdateAutoScalingGroup when the requested MinSize is below the threshold. Use a Lambda function triggered by EventBridge scheduled rules to attach/detach the SCP at market open/close times.

B. Use scheduled scaling actions in each ASG to set minimum capacity during market hours.

C. Deploy a CloudWatch alarm that triggers an SNS notification when ASG capacity drops below the threshold during market hours.

D. Configure AWS Config rules with time-based evaluation to detect capacity changes during restricted hours.

**Correct Answer: A**

**Explanation:** Combining SCPs with automated attachment/detachment (A) provides time-based preventive enforcement. The SCP denies UpdateAutoScalingGroup requests that would reduce MinSize below the threshold. EventBridge triggers a Lambda function at 9:30 AM ET to attach the SCP and at 4:00 PM ET to detach it, enforcing the restriction only during market hours. This works across all 30 accounts. Option B relies on each account configuring scheduled actions correctly (not centrally enforceable). Option C is detective, not preventive. Option D detects but doesn't prevent changes.

---

### Question 3

A media streaming company uses EC2 Spot Instances for video transcoding across 5 accounts. They need a centralized view of Spot Instance interruptions, capacity availability, and cost savings across all accounts. The data must be queryable for capacity planning decisions.

Which architecture provides a centralized Spot analytics solution?

A. Configure EventBridge in each account to forward EC2 Spot Instance interruption warnings and Spot placement score events to a central analytics account's EventBridge bus. Use a Lambda function to store events in a DynamoDB table. Create QuickSight dashboards against DynamoDB for visualization.

B. Use AWS Cost Explorer Spot Instance advisor across all linked accounts in the consolidated billing family.

C. Deploy a Lambda function in each account that queries the EC2 Describe API every 5 minutes for Spot Instance status and sends data to a central S3 bucket.

D. Use CloudTrail Lake across the organization to query Spot-related API events.

**Correct Answer: A**

**Explanation:** Cross-account EventBridge event forwarding (A) provides real-time, centralized Spot Instance telemetry. Spot interruption warnings (2-minute notices) and other Spot events are forwarded to a central bus for aggregation. DynamoDB provides low-latency querying, and QuickSight enables visual analytics for capacity planning. Option B — Cost Explorer doesn't provide real-time interruption data or capacity analytics. Option C introduces polling lag and misses events between intervals. Option D captures API calls but not Spot interruption events or capacity metrics.

---

### Question 4

An organization requires that all EC2 instances across 50 accounts use only EBS volumes with specific configurations: gp3 type, minimum 3000 IOPS, encrypted with a CMK, and no more than 500 GB per volume. The policy must be enforced preventively.

Which enforcement mechanism BEST meets these requirements?

A. Create SCPs with conditions on ec2:VolumeType (gp3), ec2:VolumeSize (max 500), and encryption requirements. Use a custom Lambda-backed Config rule for IOPS validation since SCPs cannot directly condition on IOPS values.

B. Use AWS Service Catalog to provide pre-configured EBS volume products and restrict direct EBS API access.

C. Deploy IAM permission boundaries in all accounts that restrict EBS volume creation parameters.

D. Create an SCP that denies all ec2:CreateVolume actions and require users to submit requests through a centralized provisioning service.

**Correct Answer: A**

**Explanation:** SCPs with EC2 condition keys (A) provide preventive enforcement for volume type and size. The ec2:VolumeType condition restricts to gp3, and ec2:Encrypted ensures encryption. However, SCPs don't have a direct condition key for IOPS, so a Config rule supplements by detecting non-compliant IOPS configurations with auto-remediation. This layered approach (preventive + detective) provides comprehensive enforcement. Option B restricts users to Service Catalog but doesn't prevent API-level access unless combined with SCPs. Option C uses permission boundaries that need per-account management. Option D blocks all volume creation, disrupting normal operations.

---

### Question 5

A company runs a high-frequency trading platform where EC2 instances require the lowest possible network latency for inter-instance communication. They use cluster placement groups. The compliance team requires that the placement group configurations are consistent across all trading accounts and that instances failing to launch in the placement group are never placed outside it.

Which governance approach ensures placement group consistency and strict placement enforcement?

A. Use launch templates with placement group requirements (GroupName and Tenancy). Configure the Auto Scaling group with the launch template and set the OnDemandAllocationStrategy to prioritized. Deploy configurations via CloudFormation StackSets.

B. Create launch templates with Placement group configuration set to required (not best-effort). Deploy via CloudFormation StackSets from a delegated administrator account. Include ASG configurations that reference these launch templates. Configure the ASG to fail instance launches rather than placing outside the group by not setting spread or partition strategies.

C. Document placement group requirements in a wiki and rely on each trading team to configure them correctly.

D. Use an SCP that denies ec2:RunInstances unless a placement group is specified in the request.

**Correct Answer: B**

**Explanation:** Launch templates with required placement group settings (B) ensure instances only launch within the designated placement group or fail. StackSets from a delegated administrator provide consistent deployment across accounts. The "required" placement constraint means if the cluster placement group cannot accommodate the instance, the launch fails rather than placing it elsewhere — critical for latency-sensitive trading. Option A's "prioritized" allocation strategy relates to instance type preference, not placement enforcement. Option C relies on manual compliance. Option D enforces placement group specification but not the correct type or strict placement.

---

### Question 6

A company has multiple teams running Auto Scaling groups across 20 accounts. Some teams have set overly aggressive scale-in policies that cause frequent instance termination during normal traffic fluctuations, impacting application stability. The platform team needs to enforce minimum cooldown periods and scaling policy constraints across all accounts.

Which approach provides centralized scaling policy governance?

A. Use AWS Config organizational rules to evaluate Auto Scaling group configurations. Create custom rules that check for minimum cooldown periods (e.g., ≥300 seconds), verify that scale-in protection is enabled on critical instances, and ensure target tracking policies use appropriate thresholds. Auto-remediate non-compliant configurations using SSM Automation.

B. Create SCPs that deny autoscaling:PutScalingPolicy if cooldown parameters are below a threshold.

C. Deploy CloudWatch alarms in all accounts that alert when scaling activities occur too frequently.

D. Override team Auto Scaling configurations by deploying standardized ASG settings via StackSets, removing team autonomy.

**Correct Answer: A**

**Explanation:** Config organizational rules with custom evaluations (A) can inspect Auto Scaling group configurations for cooldown periods, scaling policy thresholds, and protection settings. SSM Automation remediation can adjust non-compliant configurations automatically. This allows teams to manage their ASGs while enforcing minimum standards. Option B — SCPs don't have condition keys for cooldown values in scaling policy API calls. Option C is detective-only without remediation. Option D removes team flexibility, which is operationally counterproductive in a multi-team environment.

---

### Question 7

A gaming company uses Spot Instances for game server fleets across multiple Regions. They need to implement a strategy that maximizes instance availability while minimizing interruptions. The game servers require c5.2xlarge equivalent compute capacity and must maintain at least 1,000 instances globally at all times.

Which Spot Instance strategy maximizes availability across Regions?

A. Create a single Auto Scaling group with a capacity of 1,000 using c5.2xlarge Spot Instances in the primary Region.

B. Deploy EC2 Fleet with Spot allocation strategy set to capacity-optimized across multiple Regions. Define a diversified instance type list including c5.2xlarge, c5a.2xlarge, c5n.2xlarge, c5d.2xlarge, m5.2xlarge, and r5.2xlarge. Use separate fleets per Region with a global orchestration Lambda that rebalances capacity when interruptions occur. Implement Spot Instance rebalancing recommendations to proactively migrate before interruptions.

C. Use On-Demand instances to guarantee availability, as Spot Instances cannot reliably maintain 1,000 instances.

D. Request Spot Instance dedicated capacity reservations from AWS for guaranteed availability.

**Correct Answer: B**

**Explanation:** Diversification across instance types and Regions (B) is the key to Spot availability. The capacity-optimized strategy launches instances from pools with the most available capacity, reducing interruption probability. Including multiple similar instance types (c5, c5a, c5n, c5d, m5, r5 in 2xlarge) increases the number of capacity pools. Multi-Region deployment isolates from regional capacity constraints. Rebalance recommendations enable proactive migration before interruptions. Option A uses a single instance type in one Region — maximum interruption risk. Option C is reliable but expensive. Option D doesn't exist — Spot doesn't offer dedicated reservations.

---

### Question 8

A large enterprise needs to ensure that all Auto Scaling groups across 100 accounts have proper health check configurations. They've experienced outages where unhealthy instances continued serving traffic because ASGs used only EC2 status checks without ELB health checks.

Which solution enforces proper health check configuration at scale?

A. Create a custom AWS Config organizational rule that evaluates each ASG's HealthCheckType. If the ASG is associated with a target group, the rule verifies HealthCheckType is "ELB" (not just "EC2") and HealthCheckGracePeriod is appropriately set. Auto-remediate using SSM Automation that calls UpdateAutoScalingGroup.

B. Use SCPs to deny creation of Auto Scaling groups that don't include ELB health checks.

C. Deploy CloudWatch alarms that trigger when ASG instances fail ELB health checks but aren't terminated.

D. Modify the default ASG behavior in each account using account-level settings to always use ELB health checks.

**Correct Answer: A**

**Explanation:** A Config rule that evaluates ASG-to-target-group associations (A) and verifies the correct health check type provides intelligent enforcement. Not all ASGs use ELBs, so the rule only flags ASGs that should have ELB health checks (those attached to target groups). SSM Automation corrects misconfigurations. This approach handles the nuance that not every ASG needs ELB health checks. Option B can't enforce this — SCPs lack condition keys for ASG health check types. Option C is detective and doesn't fix the configuration. Option D doesn't exist — there's no account-level default for ASG health check type.

---

### Question 9

An organization needs to implement a tagging strategy for all EC2 instances launched by Auto Scaling groups across the organization. Tags must include CostCenter, Environment, Application, and Owner. The tags must propagate from the ASG to all launched instances and associated EBS volumes.

Which comprehensive approach ensures consistent tagging?

A. Configure tag propagation in all Auto Scaling group configurations (PropagateAtLaunch: true for each tag). Enforce mandatory tags using tag policies via AWS Organizations. Use SCPs with aws:RequestTag conditions on autoscaling:CreateAutoScalingGroup and autoscaling:CreateOrUpdateTags to deny ASG creation without required tags. Deploy Config rules to detect ASGs with missing tag propagation.

B. Use EC2 tag-on-creation enforcement via SCPs and rely on ASGs to inherit these requirements.

C. Create a Lambda function that periodically scans all instances and applies missing tags.

D. Use CloudFormation StackSets to deploy ASG configurations with correct tags in all accounts.

**Correct Answer: A**

**Explanation:** A multi-layered approach (A) ensures end-to-end tag enforcement. SCPs prevent ASG creation without required tags. Tag propagation settings ensure instances inherit ASG tags. Tag policies enforce consistent tag key casing and allowed values. Config rules detect ASGs where PropagateAtLaunch is incorrectly set. This covers creation-time enforcement and ongoing compliance. Option B's SCP on ec2:RunInstances may conflict with ASG-initiated launches. Option C is reactive with lag. Option D provides templates but doesn't prevent manual changes.

---

### Question 10

A company's security team discovers that several accounts have Auto Scaling groups configured to launch instances into public subnets with public IP addresses assigned. They need to prevent ASGs from launching instances with public IPs across the organization.

Which preventive control addresses this requirement?

A. Create an SCP that denies ec2:RunInstances when the condition ec2:AssociatePublicIpAddress is true. This prevents any instance launch (including those from ASGs) that would assign a public IP.

B. Modify all VPC subnet settings to disable auto-assign public IP addresses and use Config rules to maintain this setting.

C. Use Security Hub to detect instances with public IPs and auto-remediate by removing the public IP.

D. Create network ACLs that block all inbound traffic to instances with public IPs.

**Correct Answer: A**

**Explanation:** The SCP with ec2:AssociatePublicIpAddress condition (A) preventively blocks any instance launch that assigns a public IP, including launches by Auto Scaling groups. This is the most direct preventive control. When an ASG tries to launch an instance with a public IP (due to launch template or subnet configuration), the SCP blocks the launch. Option B addresses subnet-level auto-assignment but doesn't prevent explicit public IP assignment in launch templates. Option C is detective, not preventive. Option D doesn't remove the public IP, just blocks traffic.

---

### Question 11

A company uses mixed-instances Auto Scaling groups with On-Demand and Spot Instances across 15 accounts. They need to ensure that the On-Demand base capacity is never reduced below the minimum required for each application's SLA, even by account administrators.

Which governance mechanism protects On-Demand base capacity?

A. Use AWS Config rules to monitor the OnDemandBaseCapacity parameter in ASG mixed instance policies and alert on deviations from approved values.

B. Implement a Service Catalog product for ASG creation that enforces minimum OnDemandBaseCapacity values. Remove direct autoscaling:UpdateAutoScalingGroup permissions from all non-admin roles using permission boundaries. The Service Catalog product uses a constrained launch role with the correct base capacity.

C. Use SCPs to deny autoscaling:UpdateAutoScalingGroup unless the request maintains the OnDemandBaseCapacity above the threshold.

D. Create CloudWatch alarms that trigger when On-Demand instance count in an ASG drops below the threshold.

**Correct Answer: B**

**Explanation:** Service Catalog with permission boundaries (B) provides a governance-controlled approach. By removing direct ASG update permissions (via permission boundaries) and funneling changes through Service Catalog products with constrained launch roles, you ensure that ASG modifications maintain the required On-Demand base capacity. The Service Catalog product enforces business logic. Option A detects but doesn't prevent changes. Option C — SCPs don't have condition keys for OnDemandBaseCapacity in the UpdateAutoScalingGroup action. Option D is detective-only.

---

### Question 12

A company manages EBS volumes across 50 accounts. They need to enforce that all io2 Block Express volumes have consistent performance configurations based on the application tier: production requires minimum 64,000 IOPS and 1,000 MB/s throughput, while development requires maximum 16,000 IOPS to control costs.

Which approach enforces tier-based EBS performance policies?

A. Use AWS Config custom rules that evaluate EBS volume configurations based on the Environment tag (production/development) against the required IOPS and throughput ranges. Auto-remediate non-compliant volumes using SSM Automation documents that call ModifyVolume to adjust IOPS and throughput. Deploy via organizational Config rules.

B. Create SCPs with conditions on ec2:VolumeIops to restrict IOPS values per account OU (production OU vs. development OU).

C. Use Service Catalog to provide pre-configured volume products for each tier and restrict direct EBS API access.

D. Deploy CloudWatch alarms on VolumeReadOps and VolumeWriteOps to detect volumes that don't meet performance requirements.

**Correct Answer: A**

**Explanation:** Config rules evaluating tag-based criteria (A) provide flexible, tier-aware enforcement. The rule checks the Environment tag and validates IOPS/throughput against tier requirements. SSM Automation can adjust volumes to meet the policy. This works across all accounts via organizational rules. Option B's SCP approach could work for OU-level restrictions but doesn't handle mixed-tier accounts. Option C restricts developer flexibility. Option D monitors actual performance, not configuration compliance.

---

### Question 13

A healthcare company requires that all EBS snapshots across the organization are encrypted and shared only within the organization. Public snapshot sharing must be completely blocked. They need to enforce this for all current and future accounts.

Which controls prevent public EBS snapshot sharing?

A. Enable the EC2 Block Public Sharing of AMIs and Snapshots feature at the organization level using the EC2 Image Block Public Access and EBS Snapshot Block Public Access settings. This prevents any account from making snapshots or AMIs public. Additionally, deploy Config rules for detective monitoring.

B. Create SCPs that deny ec2:ModifySnapshotAttribute when the attribute is createVolumePermission and the value includes "all".

C. Use AWS RAM to share snapshots only within the organization and disable direct snapshot sharing APIs.

D. Create a Lambda function that monitors CloudTrail for ModifySnapshotAttribute events and reverts public sharing.

**Correct Answer: A**

**Explanation:** EBS Snapshot Block Public Access (A) is an account-level and organization-level setting that prevents public sharing of snapshots. When enabled at the organization level, it applies to all member accounts and cannot be overridden. Combined with the EC2 Image Block Public Access setting, this provides comprehensive protection. Config rules provide additional monitoring. Option B works as an SCP but the Block Public Access feature is more direct and purpose-built. Option C — RAM is for controlled sharing but doesn't prevent direct API calls. Option D is reactive.

---

### Question 14

A company operates a real-time bidding platform that requires predictable, low-latency storage I/O. They use io2 Block Express volumes for their database tier. The operations team needs to monitor EBS performance across 200 instances and proactively identify volumes that are approaching their provisioned IOPS or throughput limits.

Which monitoring strategy provides proactive performance management?

A. Create CloudWatch dashboards showing VolumeReadOps, VolumeWriteOps, VolumeThroughputPercentage, and VolumeConsumedReadWriteOps metrics. Configure composite CloudWatch alarms that trigger when VolumeConsumedReadWriteOps exceeds 80% of provisioned IOPS for more than 5 minutes. Use CloudWatch anomaly detection on these metrics to identify unusual patterns.

B. Use EBS-optimized instance metrics to monitor I/O performance at the instance level only.

C. Deploy a custom monitoring agent on each instance that reads /proc/diskstats and publishes to CloudWatch.

D. Use AWS Compute Optimizer to identify EBS volumes that need performance adjustments.

**Correct Answer: A**

**Explanation:** CloudWatch EBS metrics (A) provide built-in, granular monitoring without agents. VolumeConsumedReadWriteOps shows actual IOPS against provisioned capacity. VolumeThroughputPercentage shows throughput utilization. Composite alarms combining these metrics with 80% thresholds enable proactive scaling before performance degradation. Anomaly detection identifies unusual patterns like gradual performance decline. Option B monitors instance-level I/O but not per-volume provisioned capacity utilization. Option C duplicates built-in metrics. Option D provides recommendations but not real-time monitoring.

---

### Question 15

A multinational company has Auto Scaling groups in 10 Regions. They need a centralized dashboard that shows scaling activities, instance health, and capacity metrics across all Regions and accounts. The dashboard must update in near real-time.

Which architecture provides a centralized, cross-Region, cross-account ASG dashboard?

A. Use CloudWatch cross-account, cross-Region dashboards. Configure each account and Region as a monitoring source in the central monitoring account. Create dashboard widgets for ASG metrics (GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupTerminatingInstances) across all accounts and Regions.

B. Deploy a custom data collection agent in each account that polls ASG APIs and sends data to a central Elasticsearch cluster.

C. Use AWS Systems Manager Inventory to collect ASG configuration data and display it in a central dashboard.

D. Create individual CloudWatch dashboards in each account and Region, then use a screen aggregator tool to display them on a single monitor.

**Correct Answer: A**

**Explanation:** CloudWatch cross-account, cross-Region observability (A) is the native solution for this. The central monitoring account can create dashboards pulling metrics from all source accounts and Regions. ASG metrics like GroupDesiredCapacity and GroupInServiceInstances are automatically available in CloudWatch. Near real-time updates are provided by CloudWatch's standard metric resolution (1-minute for ASG metrics). Option B requires custom infrastructure. Option C collects inventory, not real-time metrics. Option D is a fragmented, unscalable approach.

---

### Question 16

A company needs to ensure that Spot Instance interruptions across their organization are properly handled. They want to enforce that all Auto Scaling groups using Spot Instances have capacity rebalancing enabled and that applications implement graceful shutdown procedures.

Which combination of controls ensures proper Spot interruption handling? (Choose TWO.)

A. Use AWS Config rules to verify that ASGs with Spot Instances have CapacityRebalance enabled. Auto-remediate non-compliant ASGs using SSM Automation.

B. Create SCPs that deny autoscaling:CreateAutoScalingGroup for mixed-instances policies unless CapacityRebalance is set to true.

C. Configure EventBridge rules in each account to capture EC2 Instance Rebalance Recommendation and EC2 Spot Instance Interruption Warning events. Forward to a central monitoring account for tracking compliance with graceful shutdown procedures.

D. Require all instances to use EC2 instance metadata service to check for interruption notices and implement shutdown procedures.

E. Disable Spot Instance usage entirely to avoid interruption handling complexity.

**Correct Answer: A, C**

**Explanation:** Config rules with auto-remediation (A) ensure all Spot-using ASGs have capacity rebalancing enabled. EventBridge event forwarding (C) provides centralized visibility into interruption events and rebalance recommendations, enabling the team to verify that applications handle interruptions gracefully. Together, they provide both configuration compliance and operational monitoring. Option B — SCPs don't have condition keys for CapacityRebalance. Option D is a best practice but can't be enforced at the infrastructure level. Option E is unnecessarily restrictive.

---

### Question 17

A company uses placement groups for various workloads. They need to implement governance that ensures HPC workloads use cluster placement groups, distributed databases use partition placement groups, and web servers use spread placement groups. The incorrect use of placement group types has caused performance issues.

Which governance approach enforces correct placement group usage?

A. Use AWS Config custom rules that evaluate the relationship between instance tags (WorkloadType: HPC/Database/WebServer) and their placement group strategy (cluster/partition/spread). Flag mismatches and auto-remediate by migrating instances to correctly typed placement groups.

B. Create SCPs that restrict placement group creation based on OU membership — HPC OU can only create cluster placement groups, database OU can only create partition groups.

C. Use Service Catalog products for each workload type that include the correct placement group configuration. Remove direct ec2:CreatePlacementGroup permissions from development teams and route all requests through Service Catalog.

D. Document placement group guidelines in a runbook and train all teams on correct usage.

**Correct Answer: C**

**Explanation:** Service Catalog products (C) provide governed, self-service provisioning. Each product template includes the correct placement group type for the workload. Removing direct API access ensures teams use the governed path. This is more practical than Config rules (which would need to migrate instances — a disruptive operation) or SCPs (which don't have workload-awareness). Option A's auto-remediation of moving instances between placement groups is disruptive. Option B limits entire OUs to one placement group type, which is inflexible. Option D relies on manual compliance.

---

### Question 18

A company's data engineering team needs to ensure that all EBS volumes attached to EMR cluster instances are automatically encrypted with a specific KMS key. The team uses Auto Scaling within EMR managed scaling. They need to enforce this without modifying EMR cluster configurations manually.

Which approach ensures EBS encryption for EMR managed scaling?

A. Create a default EBS encryption setting at the account level (enable EBS encryption by default with the specified KMS key). This ensures ALL EBS volumes created in the account — including those created by EMR managed scaling — are automatically encrypted with the default KMS key.

B. Configure the EMR security configuration with an encryption policy that specifies EBS encryption with the KMS key.

C. Use an SCP to deny ec2:CreateVolume without encryption specified.

D. Deploy a Lambda function that monitors EMR cluster creation and modifies EBS volumes post-creation.

**Correct Answer: B**

**Explanation:** EMR security configurations (B) provide the proper mechanism to enforce EBS encryption for EMR workloads. The security configuration specifies the KMS key for EBS encryption and applies to all instances in the cluster, including those added by managed scaling. This is the EMR-native approach. Option A (account-level default encryption) works as a catch-all but doesn't provide EMR-specific key management. Option C may interfere with EMR's internal volume creation. Option D is reactive and may miss volumes during rapid scaling.

---

### Question 19

An organization operates a multi-account structure where different business units run performance-sensitive workloads. The central infrastructure team needs to ensure that business units don't accidentally use burstable instance types (t3, t3a, t4g) for production workloads, as credit exhaustion has caused production incidents.

Which preventive control blocks burstable instances in production?

A. Create an SCP attached to the Production OU that denies ec2:RunInstances when the ec2:InstanceType condition matches t3.*, t3a.*, and t4g.* patterns. This prevents any instance launch of burstable types in production accounts, including those launched by Auto Scaling groups.

B. Remove burstable instance types from the AWS Service Catalog products available to production accounts.

C. Configure CloudWatch alarms for CPUCreditBalance and alert when credits are low on production instances.

D. Use AWS Compute Optimizer to identify burstable instances in production and recommend replacements.

**Correct Answer: A**

**Explanation:** SCPs with ec2:InstanceType conditions (A) provide preventive enforcement at the organization level. Using pattern matching on t3.*, t3a.*, and t4g.* blocks all burstable instance families. This applies to all launch methods — direct RunInstances, Auto Scaling groups, EMR, and other services. Option B only controls Service Catalog launches, not direct API calls. Option C detects credit exhaustion but doesn't prevent burstable usage. Option D is advisory, not preventive.

---

### Question 20

A regulated industry company needs to ensure that all Auto Scaling group launch templates across the organization include specific configurations: IMDSv2 required (no IMDSv1), encrypted root volumes, and specific security group patterns. These are compliance requirements that cannot be waived.

Which enforcement strategy covers all requirements?

A. Use SCPs with conditions to enforce IMDSv2 (deny ec2:RunInstances unless ec2:MetadataHttpTokens is "required"). For encrypted root volumes, use the account-level EBS encryption default. For security groups, use Config rules that evaluate launch template security group associations against approved patterns with auto-remediation.

B. Create a golden launch template in a shared services account and require all accounts to use it via cross-account sharing.

C. Implement a custom approval workflow for all launch template changes.

D. Use AWS Firewall Manager to enforce security group rules across all accounts.

**Correct Answer: A**

**Explanation:** A layered approach (A) addresses each requirement with the most appropriate tool. SCPs enforce IMDSv2 at launch time — the ec2:MetadataHttpTokens condition key prevents launches without IMDSv2. Account-level EBS encryption default ensures all volumes are encrypted. Config rules evaluate security group patterns in launch templates because SCPs can't evaluate security group membership against patterns. Option B's shared template can't account for per-account subnet and security group differences. Option C adds manual overhead. Option D manages security group rules but not launch template configurations.

---

### Question 21

A video streaming company needs to design a transcoding pipeline that processes uploaded videos. Processing is CPU-intensive, each job takes 5-30 minutes, and the workload is highly variable — 100 jobs during off-peak and 50,000 during content launches. Transcoding can tolerate a job being restarted if an instance is interrupted.

Which architecture optimizes for cost and throughput?

A. Deploy a fixed fleet of c5.4xlarge On-Demand instances behind an SQS queue.

B. Use an SQS queue to buffer transcoding jobs. Create an Auto Scaling group with a mixed instances policy: On-Demand base capacity of 10 c5.4xlarge instances, with Spot Instances for the remainder using capacity-optimized allocation across c5.4xlarge, c5a.4xlarge, c5n.4xlarge, c6i.4xlarge, and m5.4xlarge. Scale based on the SQS ApproximateNumberOfMessagesVisible metric with target tracking. Implement checkpointing in the transcoding application to resume from the last completed segment after interruption.

C. Use AWS Batch with Spot Instances for all transcoding jobs.

D. Use Lambda functions for transcoding to eliminate instance management.

**Correct Answer: B**

**Explanation:** SQS-driven Auto Scaling with mixed instances (B) provides the ideal balance. The SQS queue buffers variable workloads. A small On-Demand base ensures minimum capacity. Spot Instances with diversified types and capacity-optimized allocation reduce cost while maximizing availability. Checkpointing handles interruptions without losing progress. Scaling on queue depth matches capacity to actual demand. Option A wastes money during off-peak. Option C (Batch) is valid but less flexible than direct ASG management for custom transcoding applications. Option D — Lambda has a 15-minute timeout, insufficient for 30-minute jobs, and limited CPU/memory for transcoding.

---

### Question 22

A machine learning company needs to train models using GPU instances. Training jobs last 2-12 hours and can use checkpointing. They want to minimize costs while ensuring jobs complete within a reasonable timeframe. GPU Spot Instance interruption rates vary significantly by instance type.

Which architecture balances cost and reliability for GPU training?

A. Use p3.2xlarge On-Demand instances exclusively for training reliability.

B. Create an EC2 Fleet request with the capacity-optimized-prioritized allocation strategy. List multiple GPU instance types in priority order: p3.2xlarge, p3.8xlarge, p4d.24xlarge, g4dn.xlarge, g5.xlarge. Implement checkpointing to S3 every 10 minutes. Configure the fleet with Spot capacity rebalancing. Use a Spot-to-On-Demand fallback: if Spot capacity is unavailable for 30 minutes, launch an On-Demand instance to ensure job completion.

C. Request a Spot Instance persistent request for p3.2xlarge instances only.

D. Use SageMaker managed Spot training, which handles checkpointing and interruption recovery automatically.

**Correct Answer: D**

**Explanation:** SageMaker managed Spot training (D) is purpose-built for ML training with Spot Instances. It automatically handles checkpointing to S3, recovers from interruptions, and resumes training from the last checkpoint. It manages instance selection and fallback without custom infrastructure. This provides up to 90% cost savings over On-Demand while abstracting the complexity. Option B is a valid custom solution but requires significant engineering effort that SageMaker provides natively. Option A is expensive. Option C uses a single instance type, limiting availability.

---

### Question 23

A financial analytics company runs Monte Carlo simulations requiring 10,000 vCPUs for burst workloads lasting 2-4 hours. The simulations are embarrassingly parallel and fault-tolerant. They need the maximum compute capacity at the lowest cost.

Which compute strategy provides the most cost-effective large-scale burst capacity?

A. Use EC2 Spot Fleet with the lowestPrice allocation strategy across 20+ instance types and all available AZs. Request capacity using the request type "request" (not maintain) since the workload is finite. Implement a custom orchestration layer that tracks simulation progress and only processes on healthy instances.

B. Purchase Reserved Instances for the maximum required capacity.

C. Use a single large instance type (e.g., c5.metal) to consolidate compute onto fewer instances.

D. Use AWS Batch with a Spot compute environment, specifying 20+ instance types. Configure array jobs for the simulation tasks. Set a retry strategy for interrupted tasks. This provides managed instance selection, scaling, and job scheduling without custom orchestration.

**Correct Answer: D**

**Explanation:** AWS Batch with Spot (D) is purpose-built for large-scale burst compute. It manages instance selection from the diversified type list, handles Spot interruptions via job retries, and scales capacity automatically. Array jobs efficiently distribute embarrassingly parallel work. The managed service eliminates the need for custom orchestration in Option A. Option A works but requires building orchestration infrastructure. Option B wastes money on capacity used only during bursts. Option C limits to one instance type, risking capacity constraints.

---

### Question 24

A company is designing a real-time recommendation engine that requires ultra-low latency (<1ms) for cache reads. They plan to use ElastiCache Redis on r6g.xlarge instances. The cluster must handle 500,000 reads per second with automatic failover.

Which architecture provides the required latency and throughput?

A. Deploy a single ElastiCache Redis cluster with 3 shards and 2 replicas per shard in a cluster placement group. Enable cluster mode for data partitioning across shards. Configure read replicas with Auto Discovery for read scaling. Place the application EC2 instances in the same placement group as the ElastiCache nodes for minimal network latency.

B. Deploy a single Redis node with maxmemory-policy allkeys-lru and scale vertically to handle all traffic.

C. Use DynamoDB Accelerator (DAX) instead of Redis for sub-millisecond latency.

D. Deploy multiple standalone Redis instances behind an application-level load balancer.

**Correct Answer: A**

**Explanation:** Cluster mode Redis with sharding and read replicas (A) distributes the 500K reads/sec across multiple nodes. Placement groups provide the lowest network latency between application and cache nodes. Redis cluster mode partitions data across shards for horizontal scaling, and read replicas further distribute read load. Auto Discovery simplifies client configuration. Option B's single node creates a SPOF and can't handle 500K reads/sec. Option C — DAX is DynamoDB-specific, not a general-purpose cache. Option D lacks Redis cluster mode's data partitioning and requires custom routing.

---

### Question 25

A company needs to design a high-performance computing (HPC) cluster for computational fluid dynamics (CFD) simulations. The workload requires tight coupling between nodes with MPI communication. Each simulation uses 256 cores and 512 GB of memory across multiple nodes and runs for 6-12 hours.

Which instance and networking configuration provides optimal HPC performance?

A. Use c5n.18xlarge instances in a cluster placement group with Elastic Fabric Adapter (EFA) enabled. Configure the placement group in a single AZ. Use the EFA for MPI communication, which provides OS-bypass capabilities for lower latency and higher throughput than standard TCP. Mount a Lustre (FSx for Lustre) file system for shared scratch storage.

B. Use c5.18xlarge instances in a spread placement group with enhanced networking enabled.

C. Use m5.24xlarge instances in a partition placement group with standard networking.

D. Use hpc6a.48xlarge instances without a placement group but with EFA enabled.

**Correct Answer: A**

**Explanation:** The combination of c5n.18xlarge (network-optimized compute), cluster placement group (lowest latency), and EFA (A) provides the optimal HPC configuration. EFA's OS-bypass (SRD protocol) dramatically reduces MPI communication latency compared to standard TCP, critical for tightly-coupled CFD simulations. Single-AZ cluster placement ensures instances are physically co-located. FSx for Lustre provides high-throughput, low-latency shared storage. Option B's spread placement group maximizes physical separation — opposite of what HPC needs. Option C's partition groups are for distributed databases, not tightly-coupled HPC. Option D — hpc6a instances are good but should also use a cluster placement group.

---

### Question 26

A company runs a large-scale web application with predictable traffic patterns: 10,000 requests/second baseline, scaling to 100,000 requests/second during daily peaks (12 PM - 2 PM) and 500,000 requests/second during weekly flash sales. The application runs on Auto Scaling groups behind ALBs.

Which Auto Scaling configuration handles all traffic patterns efficiently?

A. Use target tracking scaling with a target of 70% CPU utilization and let the ASG react to traffic changes.

B. Implement a three-tier scaling strategy: (1) Scheduled scaling to pre-warm capacity before the daily 12 PM peak — increase minimum capacity to handle 100,000 rps at 11:45 AM. (2) Target tracking scaling on ALBRequestCountPerTarget at 1,000 requests/target for dynamic adjustment. (3) For flash sales, use predictive scaling trained on historical flash sale patterns combined with a manual scheduled action to pre-warm 30 minutes before the event. Set a warm pool with pre-initialized instances in the Stopped state to reduce launch time.

C. Over-provision to handle the flash sale peak at all times.

D. Use a single step scaling policy based on CPU utilization.

**Correct Answer: B**

**Explanation:** A multi-strategy approach (B) addresses each traffic pattern optimally. Scheduled scaling pre-warms for known daily peaks, avoiding the lag of reactive scaling. Target tracking provides dynamic adjustment for unexpected variations. Flash sale preparation combines predictive scaling (learned patterns) with manual pre-warming. Warm pools ensure pre-initialized instances launch quickly when needed. Option A reacts too slowly for 10x-50x traffic spikes. Option C wastes resources 95% of the time. Option D using CPU alone doesn't account for network or memory-bound scaling needs.

---

### Question 27

A gaming company needs to run thousands of game simulation servers, each requiring exactly 4 vCPUs, 16 GB RAM, and 100 GB of fast local storage. The instances must launch within 60 seconds of a request. Game sessions last 30-60 minutes.

Which compute configuration optimizes for rapid launch and local storage performance?

A. Use c5d.xlarge instances (4 vCPU, 8 GB RAM) with NVMe instance store for local storage. Pre-configure a warm pool in an Auto Scaling group with instances in the Running state, pre-loaded with game data on the instance store volume. Scale the warm pool based on predicted demand from the matchmaking system.

B. Use c5.xlarge instances with gp3 EBS volumes for local storage.

C. Use m5d.xlarge instances (4 vCPU, 16 GB RAM, 150 GB NVMe SSD) with a warm pool in the Running state. Pre-load game data to the instance store during warm pool initialization via a lifecycle hook script. The Auto Scaling group pulls pre-warmed instances from the pool, meeting the 60-second launch requirement.

D. Use Lambda for game simulation to eliminate instance management.

**Correct Answer: C**

**Explanation:** m5d.xlarge (C) matches the memory requirement (16 GB vs. c5d's 8 GB) while providing NVMe instance store for fast local storage. Warm pool instances in the Running state with pre-loaded game data via lifecycle hooks ensure sub-60-second availability. When demand increases, pre-warmed instances move from the pool to the ASG instantly. Option A's c5d.xlarge only has 8 GB RAM, insufficient. Option B uses EBS, which is slower for local storage and incurs additional cost. Option D — Lambda has resource and timeout limitations incompatible with 30-60 minute game sessions.

---

### Question 28

A data analytics company processes large datasets using Apache Spark on EMR. The processing is memory-intensive and runs on r5.4xlarge instances. They want to reduce costs using Spot Instances but need to ensure the driver node (which holds the DAG and application state) never gets interrupted.

Which EMR configuration protects the driver while using Spot for executors?

A. Use On-Demand instances for the entire cluster to ensure stability.

B. Configure the EMR cluster with the following fleet allocation: Master instance fleet — On-Demand r5.4xlarge (always stable). Core instance fleet — On-Demand r5.4xlarge for HDFS data nodes (data durability). Task instance fleet — Spot with capacity-optimized allocation across r5.4xlarge, r5.2xlarge, r5a.4xlarge, r5d.4xlarge, m5.4xlarge. Enable managed scaling for the task fleet. The Spark driver runs on the master node, protected from Spot interruptions.

C. Use Spot Instances for all node types and rely on HDFS replication for data protection.

D. Use a single large On-Demand instance for the master and Spot for everything else, including core nodes.

**Correct Answer: B**

**Explanation:** Tiered instance strategy (B) protects critical components while maximizing Spot savings. The master node (running the Spark driver) uses On-Demand for stability. Core nodes (HDFS data) use On-Demand for data durability. Task nodes (Spark executors) use diversified Spot instances — if interrupted, Spark recomputes lost partitions without losing overall job state. Managed scaling adjusts task fleet capacity automatically. Option A is expensive. Option C risks master node interruption, losing the entire job. Option D risks core node interruption, losing HDFS data that requires expensive recomputation.

---

### Question 29

A company wants to optimize their EBS storage for a PostgreSQL database running on EC2. The database has a 2 TB dataset with a read-heavy workload (80% reads, 20% writes). Current performance shows read latency averaging 5ms on gp3 volumes, but they need sub-1ms read latency for critical queries.

Which EBS optimization achieves sub-1ms read latency?

A. Upgrade from gp3 to io2 Block Express volumes with 64,000 IOPS provisioned.

B. Migrate to io2 Block Express volumes. Additionally, ensure the EC2 instance type is EBS-optimized with sufficient EBS bandwidth. For the read-heavy workload, implement PostgreSQL read replicas with separate io2 volumes to distribute read load. Configure huge pages and direct I/O in PostgreSQL to minimize OS-level caching overhead. Use NVMe-based instance types (e.g., r5b) for maximum EBS throughput.

C. Add an ElastiCache Redis layer in front of PostgreSQL for frequently accessed data.

D. Use instance store volumes for the database instead of EBS.

**Correct Answer: B**

**Explanation:** Achieving sub-1ms EBS read latency (B) requires multiple optimizations. io2 Block Express provides single-digit microsecond latency for the storage layer. An r5b instance type provides up to 60 Gbps EBS bandwidth, eliminating instance-level bottlenecks. PostgreSQL tuning (huge pages, direct I/O) reduces OS overhead. Read replicas distribute the 80% read workload. Together, these deliver consistent sub-1ms latency. Option A upgrades the volume but doesn't address instance bandwidth or database optimization. Option C caches data outside PostgreSQL, changing the application architecture. Option D uses ephemeral storage, risking data loss — unacceptable for a database.

---

### Question 30

A company runs a batch processing system that creates hundreds of EBS snapshots daily across multiple accounts. They need to optimize snapshot creation and manage the growing number of snapshots (currently 500,000 across the organization).

Which approach optimizes snapshot management at scale?

A. Use Amazon Data Lifecycle Manager (DLM) with organizational policies deployed via StackSets. Configure DLM to create snapshots on a schedule, tag them with creation date and source, and automatically delete snapshots older than the retention period. Enable fast snapshot restore (FSR) in target AZs for critical snapshots that need rapid restoration. Use EBS Snapshot Archive for snapshots that must be retained for compliance but are rarely accessed (75% cost reduction).

B. Create a Lambda function that calls CreateSnapshot for each volume daily and DeleteSnapshot for old snapshots.

C. Use AWS Backup for all snapshot management with a single backup plan across the organization.

D. Store snapshots indefinitely and use S3 lifecycle policies to manage costs (snapshots are stored in S3).

**Correct Answer: A**

**Explanation:** DLM with organizational policies (A) provides comprehensive lifecycle management. Automated creation, tagging, and retention policies reduce operational burden. FSR eliminates the I/O performance penalty when restoring from snapshots (critical for rapid recovery). EBS Snapshot Archive dramatically reduces storage costs for compliance-driven retention. Option B is a custom solution requiring maintenance. Option C (AWS Backup) is a valid alternative but DLM provides EBS-specific features like FSR and archive. Option D — snapshots don't use customer-managed S3 storage; lifecycle policies can't be applied to them directly.

---

### Question 31

A company is deploying a real-time fraud detection system. The application requires instances with high network throughput (100 Gbps) for receiving transaction streams, fast local storage for temporary data processing, and GPU acceleration for ML inference.

Which instance configuration meets all requirements?

A. Use p4d.24xlarge instances, which provide 8 NVIDIA A100 GPUs, 400 Gbps network bandwidth with EFA support, and 8 x 1 TB NVMe SSD instance store volumes. Deploy in a cluster placement group for optimal network performance between instances.

B. Use p3.16xlarge instances with additional EBS volumes for storage.

C. Use g4dn.12xlarge instances for a balance of GPU and networking.

D. Use c5n.18xlarge for networking and attach an Elastic GPU for inference.

**Correct Answer: A**

**Explanation:** p4d.24xlarge (A) uniquely provides all three requirements: 8 A100 GPUs for ML inference, 400 Gbps networking (highest in EC2), and 8 TB NVMe local storage. The cluster placement group maximizes inter-instance bandwidth for distributed inference workloads. Option B's p3.16xlarge has only 25 Gbps networking and no instance store. Option C's g4dn.12xlarge has 50 Gbps — insufficient. Option D — Elastic GPUs are deprecated and were limited to OpenGL workloads, not ML inference.

---

### Question 32

A company runs a microservices architecture on ECS with Auto Scaling. During deployments, they observe that new task instances take 90 seconds to become healthy (pulling Docker images, initializing connections, warming caches). During this warm-up period, the ALB routes traffic to unhealthy instances, causing errors.

Which configuration ensures traffic is only routed to fully warmed instances?

A. Configure the ALB target group health check with an appropriate health check interval, healthy threshold, and a custom health check endpoint that returns 200 only when the application has completed warm-up (cache loaded, connections established). Set the ECS service's health check grace period to 120 seconds (exceeding the 90-second warm-up). Configure the ALB's slow start mode on the target group with a 120-second duration to gradually increase traffic to new targets.

B. Increase the ECS task CPU and memory to speed up warm-up time.

C. Use a deployment circuit breaker to automatically roll back unhealthy deployments.

D. Configure the ALB to use round-robin instead of least outstanding requests to distribute traffic evenly.

**Correct Answer: A**

**Explanation:** The combination of custom health checks, health check grace period, and slow start (A) addresses the warm-up issue comprehensively. The custom health endpoint reports readiness only after full initialization. The grace period prevents ECS from marking tasks as unhealthy during warm-up. ALB slow start gradually increases traffic to new targets over 120 seconds, preventing a burst of traffic to a cold instance. Option B doesn't address the warm-up requirements (cache warming, connection setup). Option C handles deployment failures but not warm-up routing. Option D doesn't prevent traffic to unready instances.

---

### Question 33

A company operates a high-throughput message processing system using SQS and EC2 Auto Scaling. Each message takes 30 seconds to process. The current target tracking policy scales on CPU utilization, but they observe that the queue grows rapidly during traffic spikes before scaling catches up, leading to message processing delays.

Which scaling optimization reduces queue processing latency during spikes?

A. Implement a custom CloudWatch metric: backlog-per-instance = ApproximateNumberOfMessagesVisible / NumberOfActiveInstances. Use target tracking scaling on this custom metric with a target value equal to the acceptable backlog per instance (e.g., 10 messages × 30 sec processing = 5 minutes of work per instance). This directly ties scaling to queue depth relative to capacity, providing faster, more proportional scaling response.

B. Decrease the target tracking CPU threshold from 70% to 40% to trigger scaling earlier.

C. Add a step scaling policy based on the SQS queue depth in addition to the CPU-based target tracking.

D. Increase the maximum capacity of the Auto Scaling group to allow more instances.

**Correct Answer: A**

**Explanation:** The backlog-per-instance metric (A) is the AWS-recommended approach for SQS-driven scaling. It calculates the per-instance workload based on queue depth, providing proportional scaling — if the queue doubles, the ASG doubles. This responds faster than CPU-based scaling because it reacts to demand (queue depth) rather than resource consumption (CPU). The target value represents the acceptable work per instance. Option B triggers scaling earlier but still reacts to CPU, which lags behind queue growth. Option C creates conflicting scaling policies. Option D increases the ceiling but doesn't improve scaling speed.

---

### Question 34

A company needs to optimize EBS I/O performance for a high-transaction OLTP database. They're using io2 volumes with 30,000 IOPS provisioned, but monitoring shows that actual IOPS are capped at 18,750 even during peak load. The database runs on an r5.4xlarge instance.

What is the root cause and solution?

A. The io2 volume has a throughput bottleneck. Increase the volume throughput.

B. The r5.4xlarge instance has a maximum EBS IOPS limit of 18,750. The instance is the bottleneck, not the volume. Upgrade to r5.8xlarge (30,000 max IOPS) or r5.12xlarge (40,000 max IOPS) to fully utilize the provisioned volume IOPS. Alternatively, use an r5b.4xlarge which supports up to 30,000 IOPS.

C. The io2 volume needs to be warmed up by reading all blocks before it can deliver full IOPS.

D. EBS is throttling due to credit exhaustion. Wait for credits to replenish.

**Correct Answer: B**

**Explanation:** EC2 instances have per-instance EBS IOPS limits (B) that are separate from volume-level limits. The r5.4xlarge supports a maximum of 18,750 EBS IOPS. Even though the volume is provisioned for 30,000 IOPS, the instance caps actual I/O. Upgrading the instance type to one with higher EBS IOPS limits (r5.8xlarge at 30,000 or r5b.4xlarge at 30,000) removes the bottleneck. Option A — throughput and IOPS are separate limits; the issue is IOPS. Option C — io2 volumes don't require pre-warming; that was a historical issue with volumes restored from snapshots. Option D — io2 volumes don't use a credit system.

---

### Question 35

A company is designing a system for high-frequency order matching that requires the lowest possible network latency between application servers. They need single-digit microsecond latency for inter-node communication.

Which networking configuration achieves the lowest possible latency?

A. Use c5n.18xlarge instances in a cluster placement group with enhanced networking (ENA) enabled.

B. Use c6in.32xlarge instances in a cluster placement group with Elastic Fabric Adapter (EFA) enabled. Use the SRD (Scalable Reliable Datagram) protocol via the EFA for direct node-to-node communication, bypassing the kernel TCP/IP stack. Implement shared memory communication patterns using the Libfabric API.

C. Use dedicated hosts in the same rack for guaranteed physical proximity.

D. Use AWS Nitro-based instances with DPDK (Data Plane Development Kit) for kernel bypass networking.

**Correct Answer: B**

**Explanation:** EFA with SRD protocol (B) provides the absolute lowest latency on AWS. EFA enables OS-bypass, allowing applications to communicate directly with the network adapter, eliminating kernel overhead. The SRD protocol is optimized for low-latency, reliable communication. Cluster placement groups ensure physical co-location. Libfabric provides standardized APIs for this communication pattern. Option A's ENA provides good networking but goes through the kernel. Option C — dedicated hosts don't guarantee same-rack placement. Option D's DPDK provides kernel bypass for standard networking but EFA's SRD protocol is specifically designed for lower latency.

---

### Question 36

A company runs a CI/CD pipeline that triggers hundreds of parallel build jobs. Each build job requires a fresh EC2 instance with 8 vCPUs, 16 GB RAM, and takes 5-15 minutes. They currently use On-Demand c5.2xlarge instances, costing $25,000/month.

Which optimization reduces build costs while maintaining throughput?

A. Use Spot Instances for all build jobs with automatic retry on interruption.

B. Create an Auto Scaling group with a mixed instances policy: 0 On-Demand base, 100% Spot with capacity-optimized allocation across c5.2xlarge, c5a.2xlarge, c5d.2xlarge, c6i.2xlarge, m5.2xlarge, and m5a.2xlarge. Enable Spot Instance rebalancing. Configure the build system (Jenkins/CodeBuild) to retry failed builds. Use a warm pool with pre-built AMIs that have build dependencies pre-installed to reduce initialization time.

C. Use larger instance types and run multiple builds per instance.

D. Switch to AWS CodeBuild, which uses per-minute billing and manages compute automatically.

**Correct Answer: B**

**Explanation:** A diversified Spot fleet with build-specific optimizations (B) provides maximum cost savings (60-90% vs. On-Demand). Capacity-optimized allocation across 6+ instance types maximizes availability. Warm pools with pre-built AMIs reduce startup time. Build retries handle the rare Spot interruption. At 5-15 minute build times, the interruption risk is low. Option A uses a single instance type — risky for availability. Option C complicates build isolation. Option D is a valid alternative but may cost more than Spot for heavy usage and offers less instance type flexibility.

---

### Question 37

A company runs a stateful application server cluster where each instance maintains in-memory session data. When Auto Scaling terminates an instance during scale-in, active user sessions are lost. They need graceful scale-in that preserves sessions.

Which approach prevents session loss during scale-in?

A. Configure the Auto Scaling group with a lifecycle hook for the autoscaling:EC2_INSTANCE_TERMINATING event. The lifecycle hook triggers a Lambda function that: (1) puts the instance in draining state in the load balancer, (2) waits for active sessions to complete or timeout (with a configurable maximum wait), (3) migrates remaining session data to ElastiCache Redis, (4) signals the ASG to proceed with termination after draining completes.

B. Use sticky sessions on the ALB to keep users on the same instance and disable scale-in entirely.

C. Store all session data in DynamoDB from the start, making instances stateless.

D. Configure scale-in protection on all instances to prevent termination.

**Correct Answer: A**

**Explanation:** Termination lifecycle hooks (A) provide a grace period for session draining before termination. The Lambda-driven workflow puts the instance in ALB draining mode (stopping new connections while existing ones complete), then migrates any remaining sessions to Redis. This preserves sessions without blocking scale-in indefinitely. Option B disables scale-in, wasting resources. Option C is the ideal long-term architecture but requires application redesign — the question asks about preventing loss with the current stateful design. Option D prevents all termination, defeating Auto Scaling's purpose.

---

### Question 38

A company needs to run a distributed database (Apache Cassandra) on EC2 that requires exactly 7 nodes spread across 3 AZs. Each node must be on separate physical hardware to avoid correlated failures. If one node fails, a replacement must launch on different hardware than the remaining 6 nodes.

Which placement configuration meets these requirements?

A. Use a spread placement group across 3 AZs. This limits placement to 7 instances per AZ per group (21 total) but guarantees each instance runs on distinct hardware. Configure the Auto Scaling group with the spread placement group and set desired capacity to 7 with 1 per AZ minimum.

B. Use a partition placement group with 3 partitions (one per AZ), 2-3 nodes per partition. This isolates partitions to different racks.

C. Use a cluster placement group to ensure all nodes are close together for low-latency replication.

D. Use dedicated hosts to control physical placement.

**Correct Answer: A**

**Explanation:** Spread placement groups (A) guarantee that each instance is placed on distinct underlying hardware. For 7 nodes across 3 AZs, this ensures no two Cassandra nodes share the same physical server, eliminating correlated hardware failures. When a node is replaced, the spread placement group ensures the new instance uses different hardware than all existing instances. The 7-per-AZ limit is well within bounds. Option B's partition placement groups isolate at the rack level, but instances within the same partition might share hardware. Option C optimizes for proximity, not separation — wrong for a distributed database needing fault isolation. Option D is expensive overkill.

---

### Question 39

A company uses Graviton-based instances (c6g, m6g, r6g) for cost optimization. They want to create Auto Scaling groups that mix both x86 and Graviton instance types for maximum Spot availability. The application runs in Docker containers on ECS.

Which configuration enables cross-architecture Auto Scaling?

A. Create a single ASG with both x86 and ARM instance types in the mixed instances policy.

B. Create separate Auto Scaling groups for x86 and ARM instances, each with its own launch template specifying the appropriate architecture-specific AMI. Use ECS capacity providers to manage both ASGs, with capacity provider strategies distributing tasks across providers. Build multi-architecture Docker images (manifest lists) so the same container image works on both x86 and ARM.

C. Use a single launch template with a multi-architecture AMI that works on both x86 and ARM.

D. Configure the ECS task definition with runtime platform detection that auto-selects the correct binary.

**Correct Answer: B**

**Explanation:** Separate ASGs per architecture with ECS capacity providers (B) is the correct approach. Each ASG uses an architecture-specific AMI (Amazon Linux 2 ARM vs. x86). ECS capacity providers abstract the underlying instance architecture, distributing tasks across both pools. Multi-architecture Docker images (built with docker buildx) contain both ARM and x86 binaries, allowing the same image to run on either architecture. Option A won't work because a single launch template can't specify different AMIs for different architectures. Option C — multi-architecture AMIs don't exist as a single entity. Option D — ECS uses the image manifest for architecture selection, not runtime detection.

---

### Question 40

A company operates a microservices platform on ECS with 50 services. Each service has its own Auto Scaling configuration. During a recent incident, multiple services scaled simultaneously, causing the account to hit its EC2 instance limit. Services competed for limited capacity, and critical services were starved.

Which architecture prevents capacity starvation of critical services during simultaneous scaling?

A. Increase the EC2 instance limit and hope it's sufficient.

B. Implement ECS capacity providers with managed scaling. Create two Auto Scaling groups: a "critical" ASG with On-Demand instances and Capacity Reservations for guaranteed capacity, and a "standard" ASG with mixed instances (On-Demand base + Spot). Configure critical services to use the critical capacity provider with weight 1 and standard services to use the standard provider. Set the critical ASG's minimum capacity to handle the critical services' peak requirements.

C. Use Fargate for all services to eliminate instance capacity management.

D. Implement priority-based scaling that scales critical services before non-critical ones.

**Correct Answer: B**

**Explanation:** Separate capacity providers with dedicated ASGs (B) create isolated capacity pools. Critical services get guaranteed capacity through On-Demand instances with Capacity Reservations (guaranteeing instance availability even during capacity crunches). Standard services use a separate pool with mixed instances. This prevents competition between critical and non-critical services. Option A doesn't solve the priority problem. Option C (Fargate) eliminates instance management but is more expensive and has its own service limits. Option D — ECS doesn't have built-in priority-based scaling between services.

---

### Question 41

A company needs to optimize EBS performance for a distributed time-series database (InfluxDB) that has a very specific I/O pattern: sequential writes (high throughput, moderate IOPS) and random reads (high IOPS, moderate throughput). The dataset is 10 TB.

Which EBS configuration optimizes for this mixed I/O pattern?

A. Use a single large io2 Block Express volume with 100,000 IOPS and 4,000 MB/s throughput.

B. Separate the write and read workloads onto different EBS volumes. Use a throughput-optimized st1 volume for the write-ahead log (WAL) / recent writes (sequential, throughput-heavy). Use an io2 volume with high IOPS provisioned for the read-optimized data store (random reads). Configure InfluxDB to use separate storage paths for WAL and data.

C. Use instance store NVMe volumes for maximum performance.

D. Use a RAID 0 array of multiple gp3 volumes for combined IOPS and throughput.

**Correct Answer: B**

**Explanation:** Separating I/O patterns onto purpose-optimized volumes (B) is the most efficient approach. st1 provides cost-effective sequential write throughput (up to 500 MB/s) for the WAL. io2 provides high random read IOPS for data queries. InfluxDB supports configuring separate storage paths for WAL and data files. This avoids over-provisioning a single volume for both patterns. Option A works but is expensive — provisioning for both patterns on one volume over-allocates one dimension. Option C — instance store is ephemeral, risky for a database. Option D provides combined performance but doesn't optimize for the different I/O patterns.

---

### Question 42

A company is building a distributed training system for large language models. Training requires 128 GPUs across 16 nodes communicating via all-reduce operations. Each training run takes 72 hours. They need to minimize training time while controlling costs.

Which infrastructure configuration optimizes for large-scale distributed training?

A. Use 16 p4d.24xlarge instances in a cluster placement group with EFA enabled. Configure EFA for NCCL (NVIDIA Collective Communications Library) backend communication. Use FSx for Lustre (PERSISTENT_2 with 1000 MB/s/TiB throughput) for the training data and checkpoints. Enable NCCL environment variables for EFA optimization (FI_PROVIDER=efa, NCCL_ALGO=Ring). Use Spot Instances with 72-hour checkpointing to S3 for cost optimization.

B. Use 16 p3.16xlarge instances with standard networking.

C. Use 128 g4dn.xlarge instances (1 GPU each) for maximum GPU count.

D. Use SageMaker distributed training with fully managed infrastructure.

**Correct Answer: A**

**Explanation:** p4d.24xlarge with EFA and NCCL optimization (A) provides the highest-performance distributed training. Each p4d has 8 A100 GPUs and 400 Gbps networking. EFA with NCCL provides the lowest-latency GPU-to-GPU communication across nodes. Cluster placement group ensures physical proximity. FSx for Lustre provides the throughput needed for training data loading. NCCL ring algorithm optimizes all-reduce patterns for 16-node topologies. Option B's p3 instances have slower networking (25 Gbps) and older V100 GPUs. Option C using many single-GPU instances creates massive communication overhead. Option D is valid but provides less infrastructure control for advanced NCCL tuning.

---

### Question 43

A company has been running their application on m5.4xlarge instances for two years. AWS Compute Optimizer recommends moving to m6i.2xlarge instances, showing that the current instances average 25% CPU utilization and 30% memory utilization. The application is memory-sensitive and occasionally spikes to 70% memory usage.

Which right-sizing approach minimizes risk while optimizing costs?

A. Immediately switch all instances to m6i.2xlarge based on Compute Optimizer recommendations.

B. Phase 1: Validate Compute Optimizer's recommendation by analyzing 30 days of detailed CloudWatch metrics (CPU, memory via CloudWatch Agent, network, disk I/O) at 1-minute granularity. Phase 2: Test with m6i.2xlarge in a staging environment under load, monitoring memory pressure. Phase 3: Deploy to a canary production group (10% of fleet). Phase 4: If canary succeeds for 7 days, roll out to remaining instances using rolling ASG updates with health checks.

C. Switch to m6i.xlarge (even smaller) since average utilization is low.

D. Keep current instances but enable T3 unlimited mode for cost savings.

**Correct Answer: B**

**Explanation:** A phased right-sizing approach (B) minimizes risk. Compute Optimizer provides good recommendations but is based on averages — the 70% memory spike needs validation. Detailed metric analysis confirms workload patterns. Staging tests verify the application works on smaller instances under load. Canary deployment catches production-specific issues. Rolling updates provide gradual, reversible migration. Option A risks memory pressure issues from the 70% spike on a smaller instance (m6i.2xlarge has 32 GB vs. m5.4xlarge's 64 GB). Option C ignores the memory spike. Option D changes the billing model without addressing over-provisioning.

---

### Question 44

A company's Auto Scaling group frequently launches and terminates instances during workload fluctuations, causing a "thrashing" pattern. Instances launch, run for 5 minutes, then scale in, only to scale out again minutes later. This wastes money on instance launch overhead and causes application instability.

Which combination of adjustments eliminates scaling thrashing? (Choose TWO.)

A. Increase the scale-in cooldown period to 300 seconds (5 minutes) and add a scale-in metric evaluation period of 15 minutes to ensure the low-utilization condition is sustained before removing capacity.

B. Enable Auto Scaling group metrics collection at 1-minute granularity for more accurate scaling decisions.

C. Implement a scaling policy that uses a composite metric combining CPU utilization and request count, with the scale-in threshold set 20% lower than the scale-out threshold (hysteresis). For example: scale out at 70% CPU, scale in at 50% CPU.

D. Set the minimum and maximum capacity to the same value to prevent any scaling.

E. Use predictive scaling with a 10-minute scheduling buffer to anticipate demand changes.

**Correct Answer: A, C**

**Explanation:** Extended cooldown periods and evaluation periods (A) prevent premature scale-in by requiring sustained low utilization before removing capacity. Hysteresis in scaling thresholds (C) creates a buffer zone — the system doesn't scale in until utilization is well below the scale-out threshold, preventing oscillation around a single threshold value. Together, these eliminate the thrash cycle. Option B provides better data but doesn't change scaling behavior. Option D eliminates Auto Scaling entirely. Option E helps with predictable patterns but doesn't address reactive scaling thrashing.

---

### Question 45

A company uses io2 EBS volumes for their database tier. After a recent performance review, they notice that some volumes are provisioned with 64,000 IOPS but consistently use only 10,000 IOPS. However, during month-end batch processing (3 days/month), IOPS spike to 60,000.

Which optimization reduces costs while handling the monthly spike?

A. Reduce the provisioned IOPS to 10,000 permanently and accept degraded month-end performance.

B. Implement EBS Elastic Volumes to modify IOPS dynamically. Create an automated workflow: (1) Use EventBridge scheduled rules to trigger a Lambda function that increases volume IOPS to 64,000 one day before month-end processing. (2) After processing completes, another scheduled trigger reduces IOPS back to 15,000 (10K baseline + buffer). (3) Monitor with CloudWatch to detect if the baseline IOPS need adjustment.

C. Use gp3 volumes with 16,000 IOPS (max) and accept the month-end performance limitation.

D. Create separate volumes for month-end processing and swap them in.

**Correct Answer: B**

**Explanation:** Dynamic IOPS adjustment via Elastic Volumes (B) matches provisioned capacity to actual demand. During 27 days/month, 15,000 IOPS costs less than 64,000 IOPS. For 3 days, scaling up to 64,000 IOPS handles the spike. Note: io2 IOPS changes take effect immediately (no waiting period for downsizing as with some modifications). This can save approximately 75% on IOPS costs. Option A degrades month-end performance unacceptably. Option C caps at 16,000 IOPS, far below the 60,000 requirement. Option D adds operational complexity with volume management.

---

### Question 46

A company runs a web application where response time increases significantly during Auto Scaling scale-out events. New instances take 4 minutes to become healthy, during which the existing instances become overloaded.

Which solution reduces the performance impact during scale-out?

A. Configure an Auto Scaling warm pool with instances in the Warmed:Running state. Set the warm pool to pre-initialize instances with the application code and cache. Use a lifecycle hook to trigger a Lambda function that pre-warms application caches (e.g., loading frequently accessed data from the database into local memory). This reduces the time from scale-out trigger to serving traffic from 4 minutes to under 30 seconds.

B. Use larger instance types that can handle more traffic per instance.

C. Over-provision the ASG minimum capacity to handle all traffic without scaling.

D. Increase the health check grace period to 5 minutes to give instances more time to warm up.

**Correct Answer: A**

**Explanation:** Warm pools (A) maintain pre-initialized instances that are ready to serve traffic almost immediately when scaling out. Instances in the Running state have the OS booted, application deployed, and base initialization complete. The lifecycle hook handles application-specific warm-up (cache loading). This reduces the critical "cold start" gap from 4 minutes to seconds. Option B doesn't solve the warm-up problem — larger instances still need initialization time. Option C wastes money during off-peak. Option D gives more time but doesn't actually speed up the process — users still experience degradation during warm-up.

---

### Question 47

A company runs a big data processing cluster with 100 instances, each with 2 TB of gp3 EBS storage. The processing involves large sequential reads and writes. They notice that throughput is limited to 250 MB/s per volume (gp3 default) but need 1,000 MB/s per instance.

Which approach provides 1,000 MB/s throughput per instance most cost-effectively?

A. Upgrade all volumes to io2 with high throughput provisioned.

B. Increase the gp3 volume throughput from 250 MB/s to 1,000 MB/s per volume. gp3 supports up to 1,000 MB/s throughput with provisioned throughput (independent of IOPS). Ensure the instance type supports the required EBS throughput. This is the most cost-effective option as gp3 throughput pricing is significantly lower than io2.

C. Create a RAID 0 array of four gp3 volumes (each at 250 MB/s) per instance to achieve 1,000 MB/s aggregate.

D. Use instance store volumes for the processing workload.

**Correct Answer: B**

**Explanation:** gp3 volumes support independently provisioned throughput up to 1,000 MB/s (B), making this the simplest and most cost-effective solution. The default is 125 MB/s (not 250 MB/s — clarification: gp3 baseline is 125 MB/s, provisioned up to 1,000 MB/s). Provisioning 1,000 MB/s on gp3 is significantly cheaper than io2 throughput. No RAID management overhead required. Option A (io2) is more expensive for throughput-focused workloads. Option C works but adds RAID complexity and management overhead. Option D uses ephemeral storage, risking data loss.

---

### Question 48

A company's Auto Scaling group uses target tracking on CPU utilization at 60%. They notice that during traffic spikes, scaling doesn't happen fast enough — by the time new instances launch and pass health checks, the existing instances are at 95% CPU and dropping requests.

Which improvement accelerates scaling response to traffic spikes?

A. Lower the target tracking threshold from 60% to 40%.

B. Add a step scaling policy alongside the target tracking policy, with an aggressive step: if CPU exceeds 80%, immediately add 50% more capacity. This handles sudden spikes that exceed the target tracking's proportional response. Enable instance scale-in protection during the step scaling event. Also reduce the default cooldown and configure detailed monitoring (1-minute metrics instead of 5-minute) for faster metric detection.

C. Replace target tracking with simple scaling to have more control over scaling actions.

D. Pre-scale the ASG to maximum capacity at all times.

**Correct Answer: B**

**Explanation:** Combining target tracking with step scaling (B) provides both proportional and emergency scaling. Target tracking handles normal fluctuations around the 60% target. The step scaling policy acts as a circuit breaker — if CPU jumps past 80%, it aggressively adds capacity. 1-minute detailed monitoring reduces detection lag from 5 minutes to 1 minute. Reduced cooldowns allow faster consecutive scaling actions. Option A makes the system overly sensitive, leading to over-provisioning during normal operation. Option C loses target tracking's proportional scaling advantages. Option D wastes resources.

---

### Question 49

A company runs a genomics analysis pipeline on EC2. Each job processes a single genome file (50-200 GB) and is I/O intensive during the first phase (reading the genome file) and CPU-intensive during the second phase (analysis). Jobs take 2-6 hours.

Which storage and compute architecture optimizes for this two-phase workload?

A. Use r5d.4xlarge instances with NVMe instance store for local storage. Stage the genome file from S3 to the instance store before processing begins. The NVMe provides high random I/O throughput for the read-intensive phase, and the instance store data is automatically available for the CPU-intensive phase without network latency. Use S3 Transfer Acceleration for faster initial file staging.

B. Use EBS io2 volumes for genome file storage with maximum IOPS.

C. Process genome files directly from S3 using S3 Select for the I/O phase.

D. Use EFS to store genome files with all instances accessing the same file system.

**Correct Answer: A**

**Explanation:** Instance store NVMe (A) provides the highest I/O performance for the read-intensive phase (up to 7.5 GB/s sequential reads on r5d). Staging from S3 to local NVMe before processing begins eliminates network I/O during analysis. The r5d provides ample memory for the CPU-intensive analysis phase. Since genomics jobs are batch workloads on individual files, instance store volatility is acceptable — the source data is preserved in S3. Option B (io2) is slower and more expensive than NVMe instance store. Option C — S3 Select doesn't work for binary genomics files. Option D (EFS) adds network latency and shared I/O contention.

---

### Question 50

A company runs a Kubernetes cluster on EKS with the Cluster Autoscaler managing node groups. They have separate node groups for different workload types: compute-optimized, memory-optimized, and GPU. Pod scheduling is slow because the Cluster Autoscaler takes 3-5 minutes to provision new nodes when pods are pending.

Which solution reduces node provisioning time in EKS?

A. Replace Cluster Autoscaler with Karpenter. Karpenter directly provisions EC2 instances matching pod requirements (instance type, architecture, capacity type) without pre-defined node groups. It makes real-time decisions about instance selection using AWS pricing and availability data. Configure Karpenter provisioners with appropriate constraints for each workload type. Use launch template overrides for consistent node configuration.

B. Pre-scale all node groups to their maximum capacity to eliminate provisioning delays.

C. Increase the Cluster Autoscaler's scale-up threshold to trigger earlier.

D. Use Fargate profiles for all workloads to eliminate node management.

**Correct Answer: A**

**Explanation:** Karpenter (A) is purpose-built for EKS and significantly faster than Cluster Autoscaler. It bypasses the ASG layer, directly calling the EC2 Fleet API to provision instances. It selects optimal instance types in real-time based on pending pod requirements, eliminating the pre-defined node group constraint. Provisioning time drops from 3-5 minutes to under 1 minute. Option B wastes resources. Option C helps slightly but doesn't address the fundamental Cluster Autoscaler → ASG → EC2 latency chain. Option D eliminates flexibility and increases cost for compute-intensive workloads.

---

### Question 51

A company uses EBS-backed AMIs for their Auto Scaling group. Instance launches take 5 minutes because the AMI is 50 GB and EBS volumes created from snapshots require I/O initialization (lazy loading from S3). During scaling events, this causes performance degradation on new instances.

Which optimization eliminates the I/O initialization penalty?

A. Enable Fast Snapshot Restore (FSR) on the AMI's snapshot in all AZs where the Auto Scaling group operates. FSR pre-initializes the snapshot data on EBS volumes, eliminating the lazy loading penalty. New volumes from the snapshot deliver full provisioned performance from the first I/O operation.

B. Use instance store-backed AMIs instead of EBS-backed AMIs.

C. Decrease the AMI size by removing unnecessary packages.

D. Use EBS volume initialization (dd if=/dev/zero) in the user data script during launch.

**Correct Answer: A**

**Explanation:** Fast Snapshot Restore (A) eliminates the EBS snapshot lazy loading penalty by pre-initializing data blocks. Without FSR, the first read of any block triggers a background fetch from S3, causing high latency. With FSR, all blocks are pre-warmed, providing full provisioned performance immediately. This is critical for Auto Scaling where new instances need to serve traffic quickly. Option B removes EBS features and is deprecated for most use cases. Option C reduces size but doesn't eliminate lazy loading. Option D warms the volume post-launch but adds minutes to startup time.

---

### Question 52

A company runs a stateless web application with variable traffic patterns. Their Auto Scaling group uses On-Demand instances and frequently scales between 10 and 200 instances. They've noticed that during rapid scale-out events, some instance launches fail because their preferred instance type (c5.2xlarge) has insufficient capacity in the target AZ.

Which improvement ensures reliable scaling during capacity constraints?

A. Configure the Auto Scaling group with a mixed instances policy including multiple instance types: c5.2xlarge, c5a.2xlarge, c5n.2xlarge, c6i.2xlarge, m5.2xlarge. Set the allocation strategy to lowest-price for On-Demand (which actually uses priority-based ordering). Use the Availability Zone rebalancing feature to distribute across AZs evenly.

B. Use capacity-optimized allocation strategy with Spot Instances for better capacity availability.

C. Pre-purchase On-Demand Capacity Reservations for 200 c5.2xlarge instances.

D. Set the ASG to use only one AZ where capacity is consistently available.

**Correct Answer: A**

**Explanation:** Diversifying instance types in the mixed instances policy (A) is the primary solution for On-Demand capacity constraints. When c5.2xlarge isn't available, the ASG falls back to alternative types. For On-Demand in mixed instances policies, the allocation strategy uses a priority order based on the instance type list. AZ rebalancing ensures even distribution. Option B uses Spot, which was not requested — the company uses On-Demand. Option C is expensive — reserving 200 instances when the baseline is 10 wastes money. Option D reduces availability (single AZ is a SPOF).

---

### Question 53

A company operates a streaming data platform that ingests events into Amazon Kinesis Data Streams. The consumer application runs on EC2 instances in an Auto Scaling group. The team wants to scale the ASG based on the stream's processing backlog to prevent data lag.

Which scaling metric BEST drives consumer scaling for Kinesis?

A. Scale based on the GetRecords.IteratorAgeMilliseconds metric. Configure a target tracking policy with a target value representing the maximum acceptable consumer lag (e.g., 60,000 ms = 1 minute). When the iterator age increases (consumer falling behind), the ASG scales out. When it decreases (consumer catching up), it scales in. Also consider the number of shards — each KCL worker processes a shard, so the ASG maximum should be at least equal to the shard count.

B. Scale based on IncomingRecords metric to match producer rate.

C. Scale based on CPU utilization of the consumer instances.

D. Scale based on the number of Kinesis shards and maintain one instance per shard.

**Correct Answer: A**

**Explanation:** IteratorAgeMilliseconds (A) directly measures consumer lag — the time difference between the latest record in the stream and what the consumer has processed. It's the most accurate indicator of whether consumers are keeping up. Target tracking on this metric automatically adjusts capacity to maintain acceptable lag. Setting maximum capacity ≥ shard count ensures each shard can have a dedicated worker for maximum parallelism. Option B measures input rate, not processing backlog. Option C doesn't reflect actual stream processing performance. Option D maintains a fixed ratio without considering actual processing load.

---

### Question 54

A company is migrating a VMware-based on-premises infrastructure to AWS. Their VMware cluster uses DRS (Distributed Resource Scheduler) for automated load balancing across ESXi hosts. They want equivalent automated resource management on AWS.

Which AWS services and features replicate DRS-like behavior on AWS?

A. Use EC2 Auto Scaling groups with target tracking policies that scale based on aggregate resource utilization. Configure mixed instances policies with multiple instance types for flexibility. For existing VM workloads during migration, use AWS Application Migration Service (MGN) with right-sizing recommendations. Post-migration, implement AWS Compute Optimizer for ongoing right-sizing recommendations and Auto Scaling for dynamic capacity adjustment.

B. Use VMware Cloud on AWS to maintain the same DRS functionality.

C. Deploy EC2 Dedicated Hosts and manually distribute workloads across hosts.

D. Use ECS with automated task placement strategies.

**Correct Answer: A**

**Explanation:** AWS Auto Scaling with Compute Optimizer (A) provides the closest equivalent to DRS functionality. Target tracking auto-scales based on utilization (similar to DRS distributing VMs based on host load). Mixed instances policies provide flexibility in instance selection. MGN provides the migration path, and Compute Optimizer provides ongoing right-sizing (analogous to DRS recommendations). Option B preserves VMware but doesn't leverage cloud-native benefits. Option C requires manual management. Option D is container-specific.

---

### Question 55

A company is migrating a legacy application from on-premises that requires specific CPU features (AVX-512 instructions) for scientific computation. They need to ensure the target EC2 instance type supports these instructions and that performance is equivalent to their current hardware.

Which approach validates instance compatibility and performance during migration?

A. Select any compute-optimized instance family and assume CPU compatibility.

B. Identify EC2 instance types that use Intel Ice Lake or later processors (c6i, m6i, r6i) which support AVX-512. Run benchmarks comparing on-premises performance against the candidate instance types using the actual application workload. Use EC2 instance type specifications to verify CPU architecture, clock speed, and instruction set support. Document the mapping: on-premises server type → EC2 instance type → benchmark results.

C. Use Graviton instances for the best price/performance ratio.

D. Use dedicated hosts to guarantee specific CPU models.

**Correct Answer: B**

**Explanation:** Validating CPU instruction set compatibility (B) is critical for applications that depend on specific CPU features like AVX-512. Intel Ice Lake processors (used in *6i instance families) support AVX-512. Benchmarking with the actual workload validates that performance meets or exceeds on-premises hardware. Documentation provides the migration team a clear mapping. Option A risks selecting instances without AVX-512 support. Option C — Graviton (ARM) doesn't support AVX-512 (x86 instruction set). Option D provides hardware isolation but not necessarily specific CPU models.

---

### Question 56

A company is migrating a Windows-based HPC cluster from on-premises to AWS. The cluster uses Microsoft MPI for inter-node communication and requires low-latency networking. The on-premises cluster uses InfiniBand for interconnect.

Which AWS configuration provides the closest equivalent to InfiniBand for MPI workloads?

A. Use standard enhanced networking (ENA) on c5n instances.

B. Deploy hpc6a.48xlarge instances in a cluster placement group with Elastic Fabric Adapter (EFA) enabled. EFA provides InfiniBand-like OS-bypass capabilities for MPI communication. For Windows, verify EFA driver availability and use Microsoft MPI with the EFA Libfabric provider. Configure the placement group for single-AZ deployment to minimize latency.

C. Use AWS Direct Connect for low-latency networking between instances.

D. Deploy EC2 instances on dedicated hosts with SR-IOV for enhanced networking.

**Correct Answer: B**

**Explanation:** EFA (B) is AWS's equivalent to InfiniBand for HPC workloads. It provides OS-bypass (similar to InfiniBand verbs) and uses the SRD protocol for reliable, low-latency communication. hpc6a instances are specifically designed for HPC workloads. Cluster placement groups ensure physical proximity. For Windows HPC, EFA supports Microsoft MPI through the Libfabric provider. Option A's ENA provides good networking but not the OS-bypass capability that MPI workloads need. Option C connects AWS to on-premises, not between instances. Option D's SR-IOV is part of ENA but doesn't provide MPI-optimized communication.

---

### Question 57

A company is migrating a database from on-premises to EC2. The database requires exactly 500,000 IOPS of random 4KB reads. On-premises, this is served by a SAN with SSD arrays. The migration team needs to determine the correct EBS configuration.

Which EBS configuration delivers 500,000 IOPS?

A. Use a single io2 Block Express volume with 500,000 IOPS provisioned (io2 Block Express supports up to 256,000 IOPS per volume).

B. A single io2 Block Express volume supports up to 256,000 IOPS. To achieve 500,000 IOPS, use RAID 0 with two io2 Block Express volumes, each provisioned with 250,000 IOPS. Use an r5b.24xlarge instance (supporting up to 260,000 EBS IOPS per instance) — however, this still caps below 500,000. Instead, use an i3en.24xlarge or similar instance with 8x NVMe instance store SSDs in RAID 0 for up to 2 million random read IOPS, exceeding the requirement.

C. Use gp3 volumes in RAID 0 to achieve the required IOPS.

D. Use a single io2 volume with 500,000 IOPS provisioned.

**Correct Answer: B**

**Explanation:** Achieving 500,000 IOPS (B) requires understanding both volume and instance limits. A single io2 Block Express volume tops at 256,000 IOPS. Even RAID 0 with EBS is limited by per-instance EBS IOPS caps. For 500,000 random read IOPS, NVMe instance store (i3en.24xlarge: 8 x 7,500 GB NVMe SSD) provides millions of IOPS, far exceeding the requirement. The trade-off is ephemeral storage — requiring a replication strategy. Option A exceeds single-volume limits. Option C — gp3 max is 16,000 IOPS per volume. Option D — standard io2 caps at 64,000 IOPS.

---

### Question 58

A company is migrating a scale-out application that currently runs on 50 on-premises servers with auto-scaling handled by VMware vRealize Automation. They need to replicate the auto-scaling behavior on AWS while the migration is in progress (hybrid state where some instances are on-premises and some on AWS).

Which approach provides hybrid auto-scaling during migration?

A. Use AWS Auto Scaling for the AWS portion and manually scale on-premises servers.

B. Implement a unified orchestration layer using a custom application (or tools like Terraform/Ansible) that manages capacity across both environments. Use CloudWatch custom metrics to monitor aggregate load across on-premises and AWS instances. The orchestrator scales AWS ASGs up when demand increases and scales down on-premises servers as migration progresses. Use Route 53 weighted routing to distribute traffic between environments.

C. Migrate all 50 servers to AWS at once and configure Auto Scaling after migration.

D. Use VMware Cloud on AWS to maintain the same vRealize Automation scaling.

**Correct Answer: B**

**Explanation:** A unified orchestration layer (B) manages capacity across both environments during the hybrid migration phase. Custom metrics provide a single view of total capacity and demand. The orchestrator makes scaling decisions considering both environments — scaling AWS up while gradually decommissioning on-premises. Route 53 weighted routing directs traffic proportionally. Option A creates two disconnected scaling domains without coordination. Option C is a big-bang migration with risk. Option D maintains VMware but doesn't optimize for cloud-native capabilities.

---

### Question 59

A company is migrating a high-performance Oracle RAC cluster to AWS. The on-premises RAC uses shared storage (ASM) across nodes. They need to replicate the shared storage requirement on AWS.

Which AWS storage solution supports Oracle RAC's shared storage requirement?

A. Use EBS Multi-Attach with io2 volumes. io2 Multi-Attach allows a single EBS volume to be attached to up to 16 Nitro-based instances in the same AZ, supporting the shared storage model required by Oracle RAC ASM. Use a cluster placement group for the RAC nodes and io2 Block Express volumes for the required performance.

B. Use Amazon EFS for shared storage across RAC nodes.

C. Use S3 as shared storage with a POSIX file system layer.

D. Use separate EBS volumes for each RAC node and configure Oracle Data Guard for replication.

**Correct Answer: A**

**Explanation:** EBS Multi-Attach with io2 (A) provides the shared block storage that Oracle RAC ASM requires. Multiple EC2 instances can access the same io2 volume simultaneously, replicating the SAN-like shared storage model. The 16-instance limit is sufficient for typical RAC configurations. Block Express provides the IOPS required for high-performance RAC workloads. Cluster placement groups minimize latency between RAC nodes. Option B — EFS is NFS, not block storage; RAC requires shared block storage for ASM. Option C — S3 is object storage, unsuitable for database shared storage. Option D — Data Guard is for replication, not shared storage; it's an alternative to RAC, not a component.

---

### Question 60

A company is migrating 500 servers from on-premises to AWS using AWS Application Migration Service (MGN). During migration testing, they find that some instances experience degraded EBS performance after cutover because of snapshot lazy loading.

Which approach ensures full EBS performance immediately after cutover?

A. Enable Fast Snapshot Restore (FSR) on all EBS snapshots created during the MGN replication process, in all AZs where target instances will launch. This ensures that volumes created from these snapshots deliver full provisioned performance without the lazy loading penalty.

B. Run fio read benchmarks on each migrated instance immediately after launch to force all blocks to load.

C. Wait 24 hours after cutover for EBS to fully initialize the volumes.

D. Use instance store volumes instead of EBS for migrated servers.

**Correct Answer: A**

**Explanation:** FSR (A) eliminates the lazy loading issue that causes degraded performance on volumes created from snapshots. During MGN replication, data is stored as EBS snapshots. When target instances launch, their volumes are created from these snapshots. Without FSR, first-read latency is high as blocks are fetched from S3 on demand. FSR pre-initializes all blocks. Option B forces initialization but takes time and consumes I/O resources. Option C's 24-hour wait is disrupting and not guaranteed. Option D — instance store is ephemeral and not suitable for all workloads.

---

### Question 61

A company is migrating a workload that requires consistent, dedicated network bandwidth between instances. On-premises, they use dedicated 10 Gbps links between servers. They're concerned about the shared nature of EC2 networking.

Which AWS networking feature provides bandwidth guarantees between instances?

A. Use placement groups to guarantee network bandwidth between instances.

B. Select an appropriate EC2 instance type that provides guaranteed bandwidth. EC2 Nitro instances provide consistent, baseline bandwidth guarantees. For example, c5n.18xlarge provides 100 Gbps network bandwidth. Place instances in a cluster placement group for optimal throughput. Use enhanced networking (ENA) which provides up to 100 Gbps and is included with Nitro instances. For guaranteed bandwidth to other AWS services (S3, EFS), use the instance's baseline bandwidth specification.

C. Purchase AWS Direct Connect for inter-instance communication.

D. Use Dedicated Hosts to eliminate bandwidth sharing with other customers.

**Correct Answer: B**

**Explanation:** EC2 Nitro instances provide specified, guaranteed network bandwidth (B). The bandwidth listed in the instance type specification is guaranteed, not best-effort. For example, c5n.18xlarge guarantees 100 Gbps. Cluster placement groups maximize throughput between instances. Enhanced networking via ENA provides the high-bandwidth, low-latency networking. Unlike older instance types where bandwidth was "up to X Gbps," Nitro instances provide consistent, guaranteed bandwidth. Option A — placement groups optimize latency and may improve throughput but don't define a bandwidth guarantee independent of instance type. Option C — Direct Connect is for AWS-to-on-premises, not inter-instance. Option D — dedicated hosts provide hardware isolation but network bandwidth is still determined by instance type.

---

### Question 62

A company is migrating a latency-sensitive trading application from a colocation facility to AWS. The application currently benefits from kernel bypass networking (DPDK) on custom hardware. They need equivalent performance on AWS.

Which migration approach preserves kernel bypass networking capabilities?

A. Use standard EC2 instances and rely on enhanced networking (ENA) for good performance.

B. Migrate to EC2 instances that support ENA with DPDK. AWS provides ENA PMD (Poll Mode Driver) for DPDK, enabling user-space packet processing that bypasses the kernel. Use c5n or c6in instances for high-bandwidth, low-latency networking. Place instances in a cluster placement group. Configure the DPDK application to use ENA PMD for the data plane while keeping the kernel network stack for control plane traffic.

C. Use AWS Outposts to run the application on dedicated hardware in a nearby AWS edge location.

D. Use bare metal instances (*.metal) to have direct hardware access for custom networking drivers.

**Correct Answer: B**

**Explanation:** AWS ENA supports DPDK via the ENA PMD driver (B), providing kernel bypass packet processing on standard EC2 instances. This allows migrating DPDK-based applications with minimal code changes — just switch to the ENA PMD instead of the colocation's NIC driver. c5n/c6in instances provide up to 100/200 Gbps networking. Cluster placement groups minimize latency. Option A loses the kernel bypass capability that the application relies on. Option C is expensive and may not be close enough for latency requirements. Option D provides metal access but ENA PMD works on regular Nitro instances without needing bare metal.

---

### Question 63

A company runs 500 EC2 instances across 10 accounts. Their monthly EC2 bill is $800,000. Analysis shows: 200 instances run 24/7 with steady utilization (production), 150 instances run 12 hours/day (business hours), and 150 instances have variable usage patterns. All instances are On-Demand.

Which purchasing strategy provides the maximum cost savings?

A. Purchase Reserved Instances for all 500 instances.

B. Implement a tiered purchasing strategy: (1) Compute Savings Plans for the 200 steady-state production instances — 1-year partial upfront provides ~36% savings. (2) EC2 Instance Savings Plans for the 150 business-hours instances (Savings Plans apply per-hour, so 12-hour usage still benefits). (3) Spot Instances with diversified fleets for the 150 variable instances where workloads are fault-tolerant. (4) Use AWS Cost Explorer recommendations to right-size commitment levels. Expected savings: ~$360,000/month (45% overall).

C. Use all Spot Instances for maximum savings.

D. Negotiate an Enterprise Discount Program (EDP) with AWS for a flat discount.

**Correct Answer: B**

**Explanation:** A tiered purchasing strategy (B) matches the commitment type to the usage pattern. Compute Savings Plans provide the deepest discount for steady 24/7 workloads with flexibility across instance families and Regions. EC2 Instance Savings Plans provide good savings for the business-hours instances. Spot Instances deliver 60-90% savings for variable, fault-tolerant workloads. This layered approach maximizes savings for each pattern. Option A over-commits for variable workloads. Option C requires all workloads to be fault-tolerant. Option D provides a discount but typically less than optimized purchasing.

---

### Question 64

A company discovers they're paying for EBS volumes that are not attached to any EC2 instance. An audit reveals 2,000 unattached EBS volumes totaling 200 TB across the organization, costing $16,000/month in gp3 storage charges.

Which approach identifies and remediates orphaned EBS volumes cost-effectively?

A. Delete all unattached volumes immediately to stop costs.

B. Deploy an organizational AWS Config rule (ec2-volume-inuse-check) to detect unattached volumes. Implement a tiered remediation process: (1) Tag unattached volumes with discovery date and owner (from CloudTrail creation events). (2) Notify owners via SNS and give 14 days to claim. (3) After 14 days, create a snapshot (for recovery) and delete the volume. (4) Retain snapshots for 30 days, then move to EBS Snapshot Archive (75% cheaper). Automate with Step Functions.

C. Convert all unattached volumes to sc1 (cold HDD) to reduce costs while keeping them available.

D. Use Trusted Advisor to identify unattached volumes and manually review each one.

**Correct Answer: B**

**Explanation:** A structured, automated remediation pipeline (B) addresses the problem safely. Config rules detect unattached volumes organization-wide. Owner notification prevents accidentally deleting volumes someone needs. Snapshots before deletion provide a safety net. The 14-day claim window balances cost savings with operational safety. Snapshot archiving reduces long-term retention costs. Option A risks deleting volumes that may be needed (detached for maintenance, etc.). Option C reduces but doesn't eliminate waste. Option D identifies volumes but requires manual action for 2,000 volumes.

---

### Question 65

A company uses a mix of io2, gp3, and gp2 EBS volumes. Their EBS bill is $120,000/month. An analysis shows that 40% of gp2 volumes could be migrated to gp3 for identical or better performance at lower cost, and 30% of io2 volumes are over-provisioned on IOPS.

Which optimization plan provides the maximum EBS cost reduction?

A. Migrate all volumes to gp3 regardless of workload requirements.

B. Phase 1: Migrate gp2 volumes to gp3. gp3 provides the same 3,000 IOPS and 125 MB/s baseline at 20% lower cost, with the ability to provision IOPS and throughput independently. Use Elastic Volumes to modify in place with zero downtime. Phase 2: Right-size io2 volumes by analyzing CloudWatch VolumeReadOps and VolumeWriteOps metrics over 30 days. Reduce provisioned IOPS to match the 95th percentile of actual usage plus a 20% buffer. Phase 3: Identify volumes eligible for gp3 upgrade from io2 — volumes using ≤16,000 IOPS and ≤1,000 MB/s throughput can switch to gp3, which is significantly cheaper.

C. Switch all volumes to st1 (throughput-optimized HDD) for the lowest per-GB cost.

D. Enable EBS Snapshot Archive for all snapshots to reduce snapshot storage costs.

**Correct Answer: B**

**Explanation:** The phased optimization (B) targets the largest savings opportunities first. gp2→gp3 migration is risk-free — same or better performance at 20% lower cost, done via Elastic Volumes without downtime. io2 right-sizing based on actual metrics eliminates over-provisioning while maintaining a safety buffer. Qualifying io2→gp3 migrations provide further savings where gp3's performance range is sufficient. Option A risks migrating workloads that genuinely need io2 performance. Option C is unsuitable for most workloads (no random I/O support). Option D addresses snapshot costs, not volume costs.

---

### Question 66

A company runs a large Spark cluster on EMR with 100 r5.4xlarge On-Demand instances for a data processing pipeline that runs 8 hours daily, 5 days per week. Their monthly EMR compute cost is $110,000.

Which optimization strategy provides the greatest cost reduction?

A. Use Reserved Instances for all 100 instances.

B. Restructure the EMR cluster: (1) Use 10 On-Demand r5.4xlarge instances for the core fleet (HDFS data nodes, driver). (2) Use 90 Spot Instances for the task fleet with capacity-optimized allocation across r5.4xlarge, r5a.4xlarge, r5d.4xlarge, m5.4xlarge, r6i.4xlarge. (3) Enable EMR managed scaling to dynamically adjust the task fleet. (4) Configure node labels to run only map/shuffle tasks on task nodes. (5) Use EMRFS (S3) instead of HDFS for input/output data to reduce core node dependency. Expected savings: 70-80% on the task fleet (~$66,000-$77,000/month reduction).

C. Switch to Graviton instances (m6g) for better price/performance.

D. Run the pipeline on AWS Glue instead of EMR to eliminate instance management.

**Correct Answer: B**

**Explanation:** Converting 90% of the fleet to Spot with diversified instance types (B) provides the biggest savings. The 10 On-Demand core nodes protect HDFS and the driver. Task nodes on Spot handle data processing — if interrupted, Spark automatically re-runs lost tasks. EMRFS (S3) for data storage means task node loss doesn't lose data. Managed scaling adjusts capacity dynamically. The 8-hour, 5-day-week schedule makes Reserved Instances wasteful (only 40 hours/168 hours utilization). Option A wastes money on capacity unused 76% of the time. Option C provides ~20% savings vs. 70-80% from Spot. Option D may have different performance characteristics for the workload.

---

### Question 67

A company uses Auto Scaling across 20 applications. They notice that several applications have the same desired capacity as their minimum capacity at all times — they never scale. These ASGs cost $50,000/month in idle capacity.

Which analysis and optimization reduces idle ASG costs?

A. Remove the Auto Scaling groups and use static EC2 instances.

B. Analyze each never-scaling ASG: (1) Check if the minimum capacity is set too high relative to actual load — use CloudWatch metrics (CPU, memory, network) to identify right-sizing opportunities. (2) For ASGs that serve as HA configurations (min=2, desired=2, max=2), evaluate if the redundancy level is appropriate. (3) Implement scheduled scaling for development/staging ASGs to reduce capacity outside business hours. (4) Right-size instances within ASGs using Compute Optimizer. Expected outcome: reduce minimum capacities and right-size instances for ~40% savings.

C. Set all minimum capacities to 0 and let target tracking scaling provision instances on demand.

D. Consolidate all 20 ASGs into a single large ASG to pool resources.

**Correct Answer: B**

**Explanation:** Analyzing never-scaling ASGs (B) often reveals over-provisioned minimum capacities from initial conservative sizing that was never revised. CloudWatch data shows actual utilization patterns. Scheduled scaling for non-production ASGs (reducing to 0 or 1 instance overnight) addresses the 16 hours/day when nobody uses dev/staging. Instance right-sizing via Compute Optimizer further reduces per-instance costs. Option A eliminates auto-healing and scaling capabilities. Option C creates cold start delays when traffic arrives. Option D mixes applications inappropriately.

---

### Question 68

A company runs a batch processing system using Spot Instances with a single instance type (c5.4xlarge) in a single AZ. They experience frequent Spot interruptions that delay job completion.

Which changes improve Spot Instance availability and reduce interruptions?

A. Switch to On-Demand instances to avoid interruptions.

B. Diversify across multiple dimensions: (1) Add multiple instance types: c5.4xlarge, c5a.4xlarge, c5d.4xlarge, c5n.4xlarge, c6i.4xlarge, m5.4xlarge, m5a.4xlarge (at least 6+ types). (2) Spread across all available AZs in the Region. (3) Use the capacity-optimized allocation strategy to launch from the pool with the most capacity. (4) Enable Spot Instance rebalancing recommendations to proactively migrate before interruptions. (5) Implement checkpointing for long-running jobs.

C. Use a Spot block (fixed duration) for guaranteed Spot Instance availability.

D. Set a higher maximum Spot price to reduce interruptions.

**Correct Answer: B**

**Explanation:** Diversification (B) is the fundamental strategy for Spot availability. Using 7+ instance types across multiple AZs dramatically increases the number of capacity pools. Capacity-optimized allocation selects pools with the most available capacity, reducing interruption probability. Rebalancing recommendations enable proactive migration before interruptions. Checkpointing preserves progress. Option A eliminates cost savings. Option C — Spot blocks are no longer available for new requests. Option D — Spot prices are rarely the reason for interruptions in the current Spot model; capacity availability is the primary factor.

---

### Question 69

A company has 300 Savings Plans and Reserved Instances across their organization. Managing these commitments has become complex, with some underutilized and others expired. They're losing an estimated $200,000/year to suboptimal commitment management.

Which approach optimizes commitment utilization?

A. Cancel all commitments and use only On-Demand instances.

B. Implement a centralized FinOps approach: (1) Use AWS Cost Explorer's RI/Savings Plan utilization and coverage reports to identify underutilized commitments. (2) Sell unused Reserved Instances on the AWS Reserved Instance Marketplace. (3) Consolidate into Compute Savings Plans for maximum flexibility (any instance family, any Region, any OS). (4) Implement quarterly reviews of commitment utilization with right-sizing analysis. (5) Use AWS Cost Anomaly Detection to alert on sudden utilization changes.

C. Convert all Reserved Instances to Convertible Reserved Instances for flexibility.

D. Set all commitments to 1-year no-upfront terms to minimize risk.

**Correct Answer: B**

**Explanation:** A centralized FinOps approach (B) optimizes across the entire commitment portfolio. Identifying underutilized RIs and selling them on the Marketplace recovers value. Migrating to Compute Savings Plans provides flexibility across instance families and Regions. Quarterly reviews catch utilization changes before they accumulate. Cost Anomaly Detection provides early warning. Option A loses all committed discount savings. Option C — you can't directly convert Standard to Convertible RIs. Option D — shorter terms reduce discounts without addressing utilization issues.

---

### Question 70

A company runs a development environment with 100 instances across 10 teams. The instances run 24/7 but developers only work 10 hours/day, 5 days/week. This means instances are idle 71% of the time, costing $60,000/month.

Which solution provides the greatest savings for the development environment?

A. Implement instance scheduling using AWS Instance Scheduler. Configure start/stop schedules matching team work hours (8 AM - 6 PM, Monday-Friday, adjusted per timezone). Configure the scheduler via DynamoDB schedule tables. Allow developers to override schedules temporarily via a self-service portal (simple web app calling the Instance Scheduler API). Expected savings: ~70% ($42,000/month).

B. Use smaller instance types for development.

C. Use Spot Instances for all development workloads.

D. Move all development to AWS Cloud9 browser-based IDEs.

**Correct Answer: A**

**Explanation:** Instance scheduling (A) directly addresses the 71% idle time by stopping instances when developers aren't working. AWS Instance Scheduler uses Lambda and DynamoDB to manage start/stop schedules. The self-service override allows developers to work late or weekends without IT intervention. 70% savings is achievable by running 10 hours × 5 days = 50 hours/168 hours per week. Option B provides smaller savings (~30%) without addressing idle time. Option C saves money but instances still run 24/7 idle. Option D changes the development workflow significantly.

---

### Question 71

A company pays $15,000/month for EBS snapshots (500 TB across 10,000 snapshots). Many snapshots are old backups kept for compliance but rarely accessed. Analysis shows 80% of snapshots haven't been accessed in over a year.

Which optimization reduces snapshot storage costs?

A. Delete all snapshots older than one year.

B. Move the 80% of rarely accessed snapshots to EBS Snapshot Archive tier. Archive tier costs $0.0125/GB/month vs. $0.05/GB/month for standard tier (75% savings on archived snapshots). Implement DLM policies to automatically archive snapshots older than 90 days that don't have a "keep-standard" tag. Maintain standard tier for recent snapshots and those tagged for rapid restore needs. Expected savings: ~$9,000/month (60% overall reduction).

C. Convert snapshots to AMIs, which have lower storage costs.

D. Copy snapshots to S3 and delete the EBS snapshots.

**Correct Answer: B**

**Explanation:** EBS Snapshot Archive (B) provides 75% cost reduction for snapshots that must be retained but are rarely accessed. Archiving 400 TB (80% of 500 TB) saves $15,000/month × 80% × 75% = $9,000/month. DLM automates the archival process. The trade-off is restoration time (24-72 hours for archived snapshots), which is acceptable for compliance-driven retention. Option A may violate compliance retention requirements. Option C — AMIs reference snapshots; they don't provide cheaper storage. Option D — you can't easily convert EBS snapshots to S3 objects.

---

### Question 72

A company uses gp3 EBS volumes for their web application tier. Each instance has a 100 GB root volume with default gp3 settings (3,000 IOPS, 125 MB/s). Monitoring shows the application uses an average of 200 IOPS and 20 MB/s. They have 200 instances.

What is the optimization opportunity?

A. Switch to gp2 volumes for potentially lower costs.

B. The gp3 baseline of 3,000 IOPS and 125 MB/s is the minimum — it cannot be reduced further. However, if the volume size could be reduced (100 GB may be over-provisioned), reducing to 50 GB would halve storage costs. Also evaluate if some instances could use st1 or sc1 for non-boot volumes with sequential access patterns. For the root volume, gp3 at 100 GB × $0.08/GB = $8/month per instance × 200 instances = $1,600/month — primary savings come from volume size right-sizing.

C. Reduce the provisioned IOPS on gp3 volumes below 3,000.

D. Replace gp3 with magnetic (standard) volumes for the lowest cost.

**Correct Answer: B**

**Explanation:** gp3 volumes (B) have a minimum baseline of 3,000 IOPS and 125 MB/s that cannot be reduced. The optimization opportunity is primarily volume size right-sizing — if the application only uses 30 GB of the 100 GB volume, reducing to a smaller size saves on per-GB storage costs. At 200 instances, even small per-volume savings add up. Option A — gp2 costs more per GB and doesn't allow independent IOPS provisioning. Option C is impossible — 3,000 IOPS is the immutable gp3 baseline. Option D — magnetic (standard) volumes are previous generation and not recommended.

---

### Question 73

A company runs a fleet of GPU instances (p3.8xlarge) for machine learning inference. The instances run 24/7 but inference requests vary significantly — peak hours see 90% GPU utilization, but overnight utilization drops to 5%. The monthly cost is $240,000.

Which optimization strategy reduces inference costs while maintaining response latency?

A. Use Elastic Inference (EI) attachments instead of full GPU instances.

B. Implement a tiered approach: (1) Right-size to g4dn.xlarge instances for inference (sufficient for most models at 1/10th the cost of p3.8xlarge). (2) Use Auto Scaling based on the custom GPU utilization metric (published via CloudWatch Agent) to scale between 5 and 50 instances. (3) Use Savings Plans for the baseline capacity (5 instances). (4) Use Spot Instances for the variable portion above baseline. (5) Consider SageMaker Inference with auto-scaling for managed infrastructure. Expected savings: 80-90%.

C. Schedule GPU instances to stop overnight and use CPU-only instances for overnight inference.

D. Move all inference to AWS Inferentia instances (inf1) for specialized inference hardware.

**Correct Answer: B**

**Explanation:** The tiered approach (B) addresses multiple inefficiencies: p3.8xlarge is training-oriented hardware (expensive for inference), and the fleet doesn't scale with demand. g4dn.xlarge provides T4 GPUs sufficient for most inference workloads at ~$0.53/hour vs. $12.24/hour for p3.8xlarge. Auto Scaling matches capacity to demand, eliminating overnight waste. Savings Plans + Spot further reduce costs. Option A — Elastic Inference is being phased out. Option C maintains expensive instances during the day. Option D (Inferentia) is valid for supported models but may require model compilation changes.

---

### Question 74

A company runs an Auto Scaling group with 50 m5.2xlarge instances for a web application. They use Savings Plans covering 40 instances worth of compute. The remaining 10 instances are On-Demand. Occasionally, the ASG scales to 80 instances during peaks.

Which optimization maximizes savings for the variable portion above 40 instances?

A. Purchase additional Savings Plans to cover the full 80 instances.

B. Convert the ASG to a mixed instances policy: maintain the Savings Plans coverage for the first 40 instances worth of compute (On-Demand base). Configure the instances above 40 as Spot with capacity-optimized allocation across m5.2xlarge, m5a.2xlarge, m5n.2xlarge, m6i.2xlarge, c5.2xlarge. This gives 60-90% savings on the variable portion. Set On-Demand percentage above base to 0% (all Spot for the overflow).

C. Use more aggressive scaling to reduce the number of instances needed during peaks.

D. Enable EC2 Auto Scaling predictive scaling to better anticipate peaks.

**Correct Answer: B**

**Explanation:** Using Spot Instances for the variable capacity above the Savings Plan commitment (B) maximizes savings. The first 40 instances are covered by Savings Plans (~36% discount). Instances 41-80 (the variable portion) use Spot for 60-90% savings. Mixed instances with diversified types ensure Spot availability. This creates an optimal cost ladder: Savings Plans base → Spot overflow. Option A over-commits — the 40 extra instances are only needed during peaks. Option C may compromise application performance. Option D improves scaling timing but doesn't address pricing optimization.

---

### Question 75

A company's total compute bill is $2 million/month across their organization. They've identified the following optimization opportunities: 30% of instances are over-provisioned (right-sizing potential), 25% of non-production instances run 24/7 unnecessarily (scheduling potential), 40% of compute uses On-Demand without commitments, and Spot is used for only 5% of eligible workloads.

Which comprehensive optimization plan provides the greatest total savings?

A. Focus solely on purchasing Savings Plans for the maximum discount.

B. Implement optimizations in priority order for maximum impact: (1) Instance scheduling for non-production: stop dev/staging instances outside business hours — saves ~$150,000/month (25% of $2M × 30% avg schedule savings). (2) Right-sizing: resize 30% of over-provisioned instances based on Compute Optimizer recommendations — saves ~$180,000/month (30% of fleet × ~30% avg right-size savings). (3) Spot adoption: migrate eligible workloads (batch processing, dev environments, CI/CD) from On-Demand to Spot — saves ~$200,000/month (increasing Spot from 5% to 25% of eligible compute, ~70% discount). (4) Commitment optimization: purchase Compute Savings Plans for the remaining steady-state On-Demand usage after steps 1-3 — saves ~$150,000/month (36% on committed usage). Total estimated savings: ~$680,000/month (34% reduction).

C. Migrate everything to Graviton instances for a flat 20% savings.

D. Negotiate an Enterprise Discount Program (EDP) for an organization-wide discount.

**Correct Answer: B**

**Explanation:** The sequenced, comprehensive approach (B) maximizes savings by addressing each inefficiency with the right lever. Importantly, the order matters — right-size and schedule BEFORE purchasing commitments, otherwise you commit to over-provisioned or unnecessary capacity. Spot adoption provides the highest per-instance savings. The cumulative effect of all four levers exceeds any single optimization. Option A commits to current (wasteful) capacity levels. Option C provides modest savings without addressing waste. Option D provides a discount but typically 5-10%, far less than the 34% achievable through operational optimization.

---

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | B | 16 | A,C | 31 | A | 46 | A | 61 | B |
| 2 | A | 17 | C | 32 | A | 47 | B | 62 | B |
| 3 | A | 18 | B | 33 | A | 48 | B | 63 | B |
| 4 | A | 19 | A | 34 | B | 49 | A | 64 | B |
| 5 | B | 20 | A | 35 | B | 50 | A | 65 | B |
| 6 | A | 21 | B | 36 | B | 51 | A | 66 | B |
| 7 | B | 22 | A | 37 | A | 52 | A | 67 | B |
| 8 | A | 23 | A | 38 | A | 53 | A | 68 | B |
| 9 | A | 24 | A | 39 | B | 54 | A | 69 | B |
| 10 | A | 25 | A | 40 | B | 55 | B | 70 | A |
| 11 | B | 26 | B | 41 | B | 56 | B | 71 | B |
| 12 | A | 27 | C | 42 | A | 57 | B | 72 | B |
| 13 | A | 28 | B | 43 | B | 58 | B | 73 | B |
| 14 | A | 29 | B | 44 | A,C | 59 | A | 74 | B |
| 15 | A | 30 | A | 45 | B | 60 | A | 75 | B |
