# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 8

**Focus Areas:** Control Tower, Config, CloudTrail, Security Hub, GuardDuty, Compliance Frameworks

**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain 1: Design Solutions for Organizational Complexity (Questions 1–20)

### Question 1
A multinational financial services company is setting up a new AWS multi-account environment using AWS Control Tower. They need to support 500+ accounts across 8 business units with the following requirements: separate OUs for regulated (PCI DSS, SOX) and non-regulated workloads, preventive and detective guardrails aligned with financial industry standards, automated account provisioning with pre-configured compliance baselines, and integration with their existing on-premises Active Directory. Which approach BEST meets these requirements?

A) Deploy Control Tower in the management account. Create a nested OU hierarchy: root > Business Unit OUs > Regulation OUs (PCI, SOX, General). Enable all strongly recommended guardrails. Use Account Factory with custom blueprints for each regulation type. Integrate AWS IAM Identity Center with the on-premises AD using AD Connector.
B) Deploy Control Tower with a flat OU structure (one OU per business unit). Apply the same set of guardrails to all OUs. Use Account Factory with a single baseline template. Connect to on-premises AD using AWS Managed Microsoft AD.
C) Skip Control Tower and use AWS Organizations directly with custom SCPs for each regulation. Build custom account provisioning automation using Step Functions and CloudFormation. Deploy AD FS for federation.
D) Deploy Control Tower with a separate landing zone per business unit. Each landing zone manages its own set of accounts and guardrails independently. Use separate AD Connectors per business unit.

**Correct Answer: A**

**Explanation:** Nested OUs in Control Tower allow granular guardrail application — PCI accounts get PCI-specific guardrails (e.g., encryption requirements, network restrictions) while general accounts get baseline guardrails only. Account Factory with custom blueprints (using Customizations for AWS Control Tower - CfCT or Account Factory for Terraform - AFT) pre-configures each account type with the correct compliance baseline at provisioning time. IAM Identity Center with AD Connector provides SSO integration with on-premises AD without deploying new directory infrastructure. Option B's flat structure prevents granular guardrail application per regulation type. Option C rebuilds what Control Tower provides natively. Option D's multiple landing zones create management fragmentation — Control Tower supports one landing zone per management account.

---

### Question 2
A company has deployed AWS Control Tower across 200 accounts. The security team discovers that several accounts have drifted from the landing zone configuration — some accounts have modified their CloudTrail settings, others have deleted the AWS Config recorder, and a few have modified the VPC configurations deployed by Control Tower. The company needs to detect and remediate drift quickly and prevent it from recurring.

A) Use the Control Tower drift detection feature in the console to identify drifted accounts. For remediation, use the Control Tower "Re-register OU" and "Update provisioned product" features to reset drifted accounts. Deploy preventive guardrails (SCPs) to prevent the API actions that caused drift (e.g., deny cloudtrail:StopLogging, deny config:DeleteConfigurationRecorder).
B) Deploy custom AWS Config rules to detect drift from Control Tower baselines. Use Systems Manager Automation for remediation. Create IAM policies to prevent users from modifying Control Tower resources.
C) Manually compare each account's configuration against the Control Tower baseline. Fix drift by re-deploying Control Tower resources using CloudFormation updates.
D) Delete and recreate drifted accounts using Account Factory. This is the fastest way to restore compliance. Implement SCPs to prevent future drift.

**Correct Answer: A**

**Explanation:** Control Tower has built-in drift detection that identifies accounts and OUs that have deviated from the landing zone configuration. The "Re-register OU" feature re-applies the guardrails and baselines to all accounts in the OU, fixing drift. "Update provisioned product" repairs individual accounts. Preventive guardrails (SCPs) are the correct mechanism to prevent future drift — for example, an SCP denying cloudtrail:StopLogging or config:StopConfigurationRecorder prevents users from disabling these critical services. This is the fastest and most reliable approach using native Control Tower capabilities. Option B requires building custom detection that Control Tower already provides. Option C is manual and time-consuming for 200 accounts. Option D's account recreation is destructive and unnecessary.

---

### Question 3
A healthcare organization uses AWS Config to monitor compliance across 50 accounts. They need to implement HIPAA compliance monitoring with the following requirements: automatically evaluate all resources against HIPAA-relevant Config rules, aggregate compliance data in a central account, generate compliance reports for auditors quarterly, and automatically remediate non-compliant resources where possible. The solution must scale as new accounts are added.

A) Deploy AWS Config conformance packs using the AWS HIPAA Operational Best Practices conformance pack template across all accounts via Organizations. Use a delegated administrator account for Config aggregation. Configure auto-remediation with SSM Automation documents for remediable rules. Use Config aggregator for centralized compliance dashboards. Export compliance data to S3 for quarterly reporting.
B) Manually create individual Config rules for each HIPAA requirement in every account. Use CloudWatch Events to detect non-compliance and trigger Lambda functions for remediation. Aggregate data in a custom DynamoDB table.
C) Use AWS Security Hub with the HIPAA standard. Security Hub aggregates findings across accounts. Use custom actions for remediation. Generate reports from Security Hub findings.
D) Deploy a third-party compliance tool (e.g., Dome9, Prisma Cloud) that provides HIPAA compliance monitoring across all accounts. These tools have pre-built HIPAA rule sets and reporting.

**Correct Answer: A**

**Explanation:** AWS Config conformance packs provide the most comprehensive HIPAA compliance monitoring. The AWS-published HIPAA conformance pack template contains dozens of pre-configured Config rules mapped to HIPAA requirements. Deploying via Organizations ensures all current and future accounts receive the conformance pack automatically. The delegated administrator feature allows a security account (not the management account) to aggregate compliance data. Auto-remediation with SSM Automation documents handles remediable violations (e.g., enabling encryption, enabling versioning). The Config aggregator provides a centralized compliance view, and S3 export enables custom quarterly reports. Option B is manually intensive and doesn't scale. Option C's Security Hub HIPAA standard is less comprehensive than Config conformance packs for resource-level compliance. Option D adds third-party dependency and cost.

---

### Question 4
A company's security team needs to implement a comprehensive CloudTrail strategy across their AWS Organization (100 accounts). Requirements include: all management events and data events for S3 and Lambda logged in all accounts, logs stored immutably for 7 years, near-real-time threat detection from CloudTrail events, the ability to perform complex SQL queries across all accounts' trail data, and encryption with a customer-managed KMS key.

A) Create an Organization Trail from the management account that captures management and data events across all accounts. Deliver logs to a centralized S3 bucket in the log archive account with KMS encryption, S3 Object Lock (compliance mode) for 7-year retention, and a bucket policy preventing deletion. Use CloudTrail Lake for SQL-based queries. Integrate with GuardDuty for threat detection.
B) Create individual trails in each account that send to a central S3 bucket. Enable CloudTrail Insights in each account for threat detection. Use Athena for cross-account log queries.
C) Create an Organization Trail with management events only (data events are too expensive at scale). Use CloudWatch Logs for real-time analysis. Query logs using CloudWatch Logs Insights.
D) Create an Organization Trail logging everything. Send logs to both S3 and CloudTrail Lake. Use S3 Lifecycle policies to move logs to Glacier after 90 days for cost optimization. Use Lake for queries and GuardDuty for detection.

**Correct Answer: A**

**Explanation:** An Organization Trail is the most efficient approach — a single trail in the management account captures events across all 100 accounts. S3 Object Lock in compliance mode ensures immutability for 7 years (no one, including root, can delete locked objects). KMS encryption with a customer-managed key satisfies security requirements. CloudTrail Lake provides native SQL querying across the organization's trail data without setting up separate Athena infrastructure. GuardDuty natively integrates with CloudTrail for threat detection using ML-based analysis. Option B's individual trails per account create management overhead and higher costs. Option C excludes data events which are specifically required. Option D is close but S3 Lifecycle to Glacier violates the immutability requirement if combined with Object Lock — the correct approach is to use Object Lock for retention and standard storage or Glacier with Object Lock for cost optimization.

---

### Question 5
A company has implemented AWS Security Hub across their Organization with 80 accounts. They've enabled the AWS Foundational Security Best Practices (FSBP), CIS Benchmarks, and PCI DSS standards. The security team is overwhelmed with 50,000+ findings, many of which are low-priority or from non-production accounts. They need to prioritize remediation and reduce alert fatigue.

A) Use Security Hub's severity and compliance status to filter findings. Create custom insights that focus on CRITICAL and HIGH severity findings in production accounts. Implement automated remediation for specific finding types using EventBridge rules with Lambda/SSM. Suppress findings for known exceptions using Security Hub suppression rules. Use Security Hub's workflow status to track remediation progress.
B) Disable all standards except FSBP to reduce finding volume. Focus on one standard at a time. Manually review all findings weekly.
C) Export all findings to a SIEM tool (Splunk/Sumo Logic) and let the SOC team triage using their existing workflow. Disable Security Hub's built-in dashboards.
D) Disable Security Hub in non-production accounts. Focus only on production account findings. Use Security Hub central configuration to manage which accounts are enabled.

**Correct Answer: A**

**Explanation:** A multi-pronged approach addresses alert fatigue while maintaining comprehensive coverage. Custom insights filter the 50,000+ findings to actionable subsets (CRITICAL/HIGH in production first). Automated remediation handles common findings automatically (e.g., auto-enable S3 encryption, auto-enable CloudTrail logging), reducing manual work. Suppression rules handle known exceptions (e.g., a security group that intentionally allows public access for a load balancer). Workflow status (NEW → NOTIFIED → RESOLVED → SUPPRESSED) tracks remediation progress. This approach systematically reduces the finding backlog. Option B loses coverage from CIS and PCI standards. Option C adds tool cost without addressing the volume issue. Option D ignores non-production, which may contain compliance requirements and represents a security risk.

---

### Question 6
A government agency needs to implement FedRAMP High compliance on AWS. Requirements include: all resources deployed only in AWS GovCloud regions, continuous compliance monitoring, encrypted communications for all data in transit and at rest, comprehensive audit logging, and automated evidence collection for FedRAMP auditors. The agency has 30 AWS accounts.

A) Deploy AWS Control Tower in GovCloud with SCPs restricting resource creation to GovCloud regions only. Enable AWS Config with FedRAMP-aligned conformance packs. Deploy AWS Security Hub with the NIST 800-53 standard. Use AWS Audit Manager with the FedRAMP High framework for automated evidence collection. Enable CloudTrail Organization Trail with KMS encryption and S3 Object Lock. Deploy GuardDuty for continuous threat monitoring.
B) Deploy resources in GovCloud standard regions. Use AWS Config rules for compliance monitoring. Manually collect evidence for FedRAMP audits using screenshots and exports. Enable CloudTrail in each account individually.
C) Use AWS Artifact to download FedRAMP compliance reports. Deploy security tools in commercial regions and assume GovCloud inheritance of compliance. Use Security Hub with basic standards.
D) Hire a third-party FedRAMP assessor to configure the AWS environment. Rely on the assessor's tools for continuous monitoring and evidence collection.

**Correct Answer: A**

**Explanation:** This comprehensive approach addresses all FedRAMP High requirements with AWS-native tools. Control Tower in GovCloud establishes the multi-account landing zone with guardrails. SCPs ensure GovCloud-only deployment. The NIST 800-53 standard in Security Hub maps directly to FedRAMP requirements. AWS Audit Manager with the FedRAMP High framework is purpose-built for automated evidence collection — it continuously collects evidence from Config, CloudTrail, Security Hub, and other sources, organizing them against FedRAMP control families for auditor review. CloudTrail with KMS encryption and Object Lock provides tamper-proof audit logging. GuardDuty provides the continuous monitoring requirement. Option B's manual evidence collection is unsustainable. Option C's commercial region deployment doesn't satisfy GovCloud requirements. Option D's third-party reliance doesn't leverage AWS-native compliance tools.

---

### Question 7
A company uses AWS CloudTrail and discovers that an IAM user's access keys were compromised. The security team needs to: determine exactly what actions the compromised keys performed, identify all resources that were created, modified, or accessed, determine if the attacker moved laterally to other accounts, and establish a timeline of the breach. The company has an Organization Trail logging to CloudTrail Lake.

A) Use CloudTrail Lake to run SQL queries filtering by the compromised access key ID. Query for all events in the time window, focusing on IAM actions (creating new users, roles, policies), resource creation/modification, and cross-account AssumeRole events. Use the eventTime field to establish timeline. Check for CreateAccessKey events that might indicate persistence mechanisms.
B) Download CloudTrail log files from S3 and search for the access key ID using grep. Manually review the JSON files to understand the attack timeline.
C) Use CloudWatch Logs Insights to search for the access key ID in CloudTrail logs delivered to CloudWatch. Create dashboards showing the attack timeline.
D) Use GuardDuty findings related to the compromised access key. GuardDuty provides a complete activity history for compromised credentials.

**Correct Answer: A**

**Explanation:** CloudTrail Lake provides the most powerful investigation capability with SQL queries against the organization's trail data. Key queries include: SELECT * WHERE userIdentity.accessKeyId = 'AKIA...' ORDER BY eventTime (full activity timeline), filtering for IAM:CreateUser, IAM:CreateAccessKey, IAM:AttachRolePolicy (privilege escalation/persistence), STS:AssumeRole across accounts (lateral movement), and resource creation events. CloudTrail Lake's SQL interface enables complex JOIN and aggregation queries that reveal attack patterns. The organization-wide trail ensures cross-account activity is captured. Option B's manual grep is slow and error-prone at scale. Option C's CloudWatch Logs Insights is useful but CloudTrail Lake provides richer querying. Option D's GuardDuty shows findings but not the complete activity history needed for forensic investigation.

---

### Question 8
A retail company needs to implement PCI DSS compliance for their cardholder data environment (CDE) on AWS. The CDE consists of 5 accounts handling payment processing. Requirements include: network segmentation between CDE and non-CDE environments, encryption of cardholder data at rest and in transit, access control with least privilege and MFA, vulnerability management and penetration testing, and logging and monitoring of all access to cardholder data.

A) Place CDE accounts in a dedicated OU with strict SCPs (deny internet access, deny unencrypted storage creation). Use Transit Gateway with Network Firewall between CDE and non-CDE VPCs. Enable AWS Config with PCI DSS conformance pack. Use KMS with CMK for all data encryption. Enforce MFA via IAM policies. Deploy GuardDuty and Security Hub with PCI DSS standard. Use AWS Inspector for vulnerability assessment. Enable CloudTrail data events for S3 buckets containing cardholder data.
B) Deploy all CDE resources in a single VPC with strict security groups. Use VPC Flow Logs for monitoring. Enable basic CloudTrail logging. Use AWS-managed encryption for all resources.
C) Use AWS Firewall Manager to enforce WAF rules on all CDE resources. Deploy Shield Advanced for DDoS protection. Use ACM for certificate management. These controls satisfy PCI DSS network security requirements.
D) Implement PCI DSS compliance using a third-party tool deployed in the CDE accounts. The tool monitors all resources and generates compliance reports. Rely on the tool for all PCI controls.

**Correct Answer: A**

**Explanation:** This solution maps to PCI DSS requirements comprehensively. Network segmentation (Requirement 1): Transit Gateway with Network Firewall between CDE and non-CDE provides inspectable network boundaries. SCPs prevent misconfigurations. Encryption (Requirements 3, 4): KMS CMK for data at rest, TLS for transit. Access control (Requirements 7, 8): Least privilege via IAM policies, MFA enforcement via IAM conditions. Vulnerability management (Requirement 6, 11): AWS Inspector scans for vulnerabilities. Logging and monitoring (Requirement 10): CloudTrail data events capture all access to cardholder data, GuardDuty detects anomalies, Security Hub with PCI standard provides continuous compliance assessment. Config PCI conformance pack monitors resource-level compliance. Option B lacks network segmentation and proper logging. Option C only addresses a subset of PCI requirements. Option D creates a single-point-of-failure for compliance.

---

### Question 9
A company with 300 AWS accounts needs to implement a centralized compliance dashboard that shows real-time compliance posture across all accounts for multiple frameworks (SOC 2, HIPAA, PCI DSS, ISO 27001). The dashboard must show: overall compliance score per framework, non-compliant resources broken down by account and framework, trend data over the past 12 months, and the ability to drill down to individual findings.

A) Use AWS Audit Manager with assessment frameworks for each compliance standard. Audit Manager continuously collects evidence and maps it to control frameworks. Build dashboards using Audit Manager's built-in assessment reports. Export data to QuickSight for custom visualizations and trend analysis.
B) Deploy AWS Security Hub with all relevant standards (FSBP, CIS, PCI DSS). Use Security Hub insights for compliance scoring. Export findings to S3 via EventBridge, process with Glue, and visualize in QuickSight.
C) Use AWS Config conformance packs for each standard deployed across the organization. Aggregate Config compliance data using the organization-level Config aggregator. Build custom dashboards in CloudWatch using Config compliance metrics.
D) Deploy Security Hub as the primary compliance tool. Use the Security Hub organizational administrator feature for cross-account aggregation. Create custom insights for each framework's compliance score. Export findings to a centralized S3 bucket for trend analysis. Build a QuickSight dashboard with historical data from the S3 exports.

**Correct Answer: D**

**Explanation:** Security Hub provides the best real-time compliance posture view across multiple frameworks. As an organizational administrator, Security Hub aggregates findings from all 300 accounts automatically. It natively supports PCI DSS and CIS frameworks, and FSBP covers many SOC 2 and ISO 27001 controls. Custom insights can calculate compliance scores per framework and per account. The EventBridge integration exports findings to S3 for historical trend data. QuickSight built on the historical S3 data provides the 12-month trend analysis and drill-down capabilities. Option A's Audit Manager is designed for audit preparation and evidence collection, not real-time compliance dashboards. Option B is close but doesn't leverage Security Hub's organizational features. Option C's Config aggregator provides resource-level compliance but lacks the framework mapping that Security Hub provides.

---

### Question 10
A company uses AWS GuardDuty across their Organization. They want to customize GuardDuty's behavior: reduce false positives from known internal IP ranges and VPN endpoints, create high-priority alerts for specific threat types targeting their crown jewel accounts, automatically quarantine compromised EC2 instances, and escalate critical findings to their SOAR platform. The customization must apply across all 150 accounts.

A) Create GuardDuty trusted IP lists for internal IP ranges and VPN endpoints (reduces false positives). Create threat IP lists for known malicious IPs. Use GuardDuty finding suppression rules to filter out expected behaviors. Use EventBridge rules to route high-severity findings from crown jewel accounts to SNS for escalation. Deploy a Lambda function triggered by specific finding types to quarantine instances (remove from security groups, attach isolation SG, create forensic snapshot).
B) Modify GuardDuty's ML models to reduce sensitivity for internal IP ranges. Create custom GuardDuty rules for crown jewel account monitoring. Use GuardDuty's built-in quarantine feature for compromised instances.
C) Use Security Hub with custom actions to handle GuardDuty findings. Create automated response playbooks using Security Hub's built-in SOAR capabilities. Suppress findings at the Security Hub level.
D) Disable GuardDuty finding types that generate false positives. This directly reduces alert volume. Use CloudWatch Alarms for critical finding alerting.

**Correct Answer: A**

**Explanation:** This approach addresses each requirement with GuardDuty's native features. Trusted IP lists tell GuardDuty to not generate findings for traffic from known internal ranges — directly reducing false positives without disabling detection. Threat IP lists add monitoring for known bad actors. Suppression rules filter expected behaviors (e.g., a scanning tool that triggers Recon findings). EventBridge rules with account ID conditions route crown jewel findings to high-priority channels. The Lambda quarantine function implements automated incident response: modifying security groups to isolate the instance, creating an EBS snapshot for forensic analysis, and tagging the instance for tracking. Option B incorrectly claims you can modify GuardDuty's ML models or that it has a built-in quarantine feature. Option C's Security Hub doesn't have built-in SOAR capabilities. Option D's disabling finding types eliminates visibility.

---

### Question 11
A company is implementing a data loss prevention (DLP) strategy across their AWS environment. They need to: discover and classify sensitive data in S3 buckets across 100 accounts, continuously monitor for new sensitive data, alert when sensitive data is found in non-approved locations, and integrate with their existing DLP tools. The company stores 5 PB of data across 2,000 S3 buckets.

A) Deploy Amazon Macie across the organization using the delegated administrator model. Configure automated sensitive data discovery jobs running monthly across all accounts. Create custom data identifiers for company-specific sensitive data patterns. Use Macie findings with EventBridge to trigger alerts for sensitive data in non-approved buckets. Forward findings to Security Hub for integration with existing DLP tools.
B) Use S3 Object Lambda to scan every object on access for sensitive data. Flag objects containing PII. This provides real-time DLP for all S3 data.
C) Deploy AWS Config custom rules that check S3 object metadata for sensitive data indicators. Use Config remediation to move sensitive data to approved buckets.
D) Implement client-side DLP scanning in the application layer before writing to S3. Tag objects with sensitivity labels. Use S3 event notifications to verify tags on new objects.

**Correct Answer: A**

**Explanation:** Amazon Macie is purpose-built for sensitive data discovery in S3. Organizational deployment via delegated administrator ensures all 100 accounts are covered. Automated sensitive data discovery uses ML to classify data (PII, financial data, credentials) without manual configuration. Custom data identifiers extend Macie to detect company-specific patterns (e.g., internal account numbers, custom identifiers). EventBridge integration enables automated alerting and response when sensitive data appears in non-approved locations. Security Hub integration provides a single pane for DLP findings alongside other security findings. Option B's Object Lambda scans only on access, missing data at rest, and adds latency to every S3 read. Option C's Config rules can't inspect object content. Option D requires application changes and doesn't cover existing data.

---

### Question 12
A company has configured AWS Config rules across their Organization but finds that the rules are generating non-compliant results for resources that are intentionally configured that way (e.g., a public S3 bucket for a static website, a security group allowing SSH from a specific IP). The team wants to handle these exceptions properly while maintaining compliance visibility for genuine violations.

A) Use AWS Config conformance pack exceptions. When deploying conformance packs, specify resource exceptions (by resource ID or tag) that should be excluded from specific rules. Document the business justification for each exception. Review exceptions quarterly.
B) Modify the Config rules to exclude specific resources using rule scope (resource IDs, tags). This prevents the rule from evaluating exempted resources entirely.
C) Mark non-compliant findings as suppressed in the Config compliance dashboard. Use automation to bulk-suppress known exceptions.
D) Create an SNS notification for non-compliant findings with a Lambda function that checks an exceptions database (DynamoDB). If the resource is listed as an exception, the Lambda re-evaluates the resource as compliant using the PutEvaluations API. If not, it forwards the alert.

**Correct Answer: D**

**Explanation:** The PutEvaluations approach with an exceptions database provides the most governed exception management. The Lambda function checks each non-compliant finding against a documented exceptions list in DynamoDB (containing resource ID, rule name, business justification, approver, and expiry date). Approved exceptions are marked compliant, maintaining a clean compliance dashboard while preserving the audit trail. The DynamoDB table serves as the system of record for exceptions, enabling quarterly reviews. Option A's conformance pack exceptions are limited in granularity. Option B's excluding resources from evaluation eliminates all compliance visibility, including detecting if the resource is modified beyond the approved exception. Option C's suppression in the dashboard is manual and loses the finding data.

---

### Question 13
A financial institution needs to implement a security monitoring architecture that detects and responds to threats across 200 accounts in real-time. Requirements include: centralized threat detection, automated incident response for common threats, forensic capability for investigations, and integration with their 24/7 Security Operations Center (SOC). The SOC currently uses Splunk as their SIEM.

A) Enable GuardDuty across the organization with a delegated administrator. Enable all GuardDuty protection plans (S3, EKS, RDS, Lambda, Malware). Route findings to Security Hub as the central aggregation point. Use EventBridge rules for automated response (Lambda functions for quarantine, WAF blocking, IAM key disabling). Export Security Hub findings to Splunk via Amazon Kinesis Data Firehose with S3 as a buffer. Enable CloudTrail Lake for forensic SQL queries. Deploy Amazon Detective for visual investigation.
B) Send all CloudTrail logs and VPC Flow Logs directly to Splunk using Kinesis Data Firehose. Let the SOC team use Splunk's detection rules for threat monitoring. Respond to threats manually through Splunk workflows.
C) Deploy open-source IDS (Suricata) on EC2 instances across all accounts for threat detection. Send alerts to a central ELK stack. Use custom scripts for incident response.
D) Use Security Hub as the sole detection tool. Enable all security standards. Build custom actions for SOC notification via SNS.

**Correct Answer: A**

**Explanation:** This architecture provides layered, comprehensive security monitoring. GuardDuty with all protection plans provides ML-based threat detection across multiple data sources (CloudTrail, VPC Flow Logs, DNS logs, S3 data events, EKS audit logs, RDS login events, Lambda network activity, malware scanning). Security Hub aggregates GuardDuty findings with Config and other findings. EventBridge-triggered Lambda functions automate response to common threats (instance quarantine, key rotation, WAF rule addition). Kinesis Data Firehose delivers findings to Splunk for SOC integration. CloudTrail Lake and Amazon Detective provide complementary forensic capabilities — Lake for SQL-based investigation and Detective for visual analysis of entity relationships. Option B pushes raw logs to Splunk without AWS-native detection. Option C requires managing IDS infrastructure. Option D lacks the ML-based threat detection that GuardDuty provides.

---

### Question 14
A company needs to ensure that all EC2 instances across their 100-account Organization are patched within 48 hours of a critical security patch being released. They need to track patch compliance, automate patching for standard instances, handle special approval for production database instances, and generate compliance reports showing patch status across all accounts.

A) Deploy AWS Systems Manager Patch Manager across all accounts using Organizations. Define patch baselines for each OS type with auto-approval rules for critical patches. Create maintenance windows for automated patching: immediate for development, within 24 hours for staging, and within 48 hours for production (with SNS approval notification). Use SSM Inventory and Compliance to track patch status across the organization. Generate compliance reports using SSM Compliance data exported to S3 and visualized in QuickSight.
B) Use AWS Inspector to identify missing patches. Manually deploy patches using SSH/RDP to each instance. Track compliance in a spreadsheet.
C) Deploy a custom Lambda function that scans EC2 instances for missing patches using SSM Run Command. Trigger patching using user data scripts. Track compliance in DynamoDB.
D) Use AWS Config rules to detect unpatched instances. Config rules check the AMI age and flag instances running AMIs older than 48 hours from the latest release.

**Correct Answer: A**

**Explanation:** Systems Manager Patch Manager is the AWS-native solution for enterprise patch management. Patch baselines define which patches to apply automatically (critical/security patches for the 48-hour window). Maintenance windows schedule patching with different timelines per environment (dev/staging/production). For production databases requiring special approval, the maintenance window can be configured with an SNS notification that triggers an approval workflow before patching proceeds. SSM Inventory and Compliance provide organization-wide patch status visibility. QuickSight dashboards on the compliance data generate the required reports. Option B is manual and doesn't scale to 100 accounts. Option C builds custom what SSM provides natively. Option D's AMI age check doesn't accurately detect patch compliance (instances can be patched without AMI updates).

---

### Question 15
A company uses AWS Organizations with 150 accounts and needs to implement a tagging governance strategy. Requirements include: mandatory tags (Environment, CostCenter, Owner, Application) on all resources, consistent tag values (e.g., Environment must be "production", "staging", or "development"), automatic tag enforcement for new resources, and detection and remediation of non-compliant existing resources.

A) Implement AWS Organizations Tag Policies to define mandatory tags and allowed values. Deploy AWS Config rules (required-tags) across all accounts to detect non-compliant resources. Use Config auto-remediation with a Lambda function that adds missing tags from a lookup table based on the account's OU membership. Use SCP conditions on tagging API actions to prevent resource creation without required tags.
B) Use SCPs to deny all resource creation API calls that don't include the required tags. This preventive approach stops non-compliant resources from being created.
C) Deploy AWS Config rules only. Config detects non-compliant resources and auto-remediation adds tags. No preventive controls needed.
D) Use AWS Service Catalog to enforce tags at provisioning time. Require all resources to be created through Service Catalog products that include required tags.

**Correct Answer: A**

**Explanation:** This approach combines preventive and detective controls for comprehensive tag governance. Tag Policies in Organizations define the mandatory tags and valid values at the organization level. Config rules (required-tags managed rule) detect existing resources missing tags. Auto-remediation via Lambda applies default tags based on the account's OU (e.g., accounts in the production OU get Environment=production). While SCPs with tag conditions would be ideal for prevention, they're difficult to implement universally (not all services support tag-on-create conditions in SCPs). Instead, Config auto-remediation provides near-real-time tagging of new resources. Option B's SCP-only approach is limited because not all AWS services support condition keys for tags at creation time. Option C lacks preventive controls. Option D doesn't cover resources created outside Service Catalog.

---

### Question 16
A company is preparing for a SOC 2 Type II audit and needs to demonstrate continuous compliance monitoring over a 12-month period. They need to: map AWS controls to SOC 2 Trust Service Criteria, automatically collect evidence, demonstrate control effectiveness over time, and produce an audit-ready report package.

A) Use AWS Audit Manager with the SOC 2 framework assessment. Audit Manager automatically collects evidence from Config, CloudTrail, Security Hub, and other AWS services, mapping them to SOC 2 criteria. Run the assessment continuously for the 12-month audit period. Use Audit Manager's report generation to produce the evidence package. Assign control owners who review evidence in Audit Manager.
B) Export CloudTrail logs, Config compliance history, and Security Hub findings to S3 monthly. Hire auditors to manually review the exports and create the SOC 2 evidence package.
C) Deploy AWS Config rules mapped to SOC 2 criteria. Use Config compliance timeline for each resource to show compliance over time. Manually compile the evidence for auditors.
D) Use AWS Artifact to download SOC 2 compliance reports from AWS. These reports satisfy the SOC 2 audit requirement.

**Correct Answer: A**

**Explanation:** AWS Audit Manager is purpose-built for continuous compliance evidence collection and audit preparation. The SOC 2 framework assessment maps AWS controls directly to SOC 2 Trust Service Criteria (Security, Availability, Processing Integrity, Confidentiality, Privacy). Audit Manager automatically collects evidence from: Config (resource configuration compliance), CloudTrail (access and activity logging), Security Hub (security findings), and other services. Over the 12-month period, Audit Manager maintains a timeline of evidence, demonstrating continuous control effectiveness. Control owners can review and annotate evidence within the tool. The report generation feature produces organized evidence packages that auditors can review directly. Option B is manual and error-prone. Option C lacks the framework mapping and automated evidence organization. Option D provides AWS's SOC 2 report (shared responsibility model), not the customer's SOC 2 evidence.

---

### Question 17
A company needs to implement a centralized logging architecture for compliance. Logs from all 200 accounts must be: stored in a centralized location with tamper-proof protection, retained for different periods based on log type (CloudTrail: 7 years, VPC Flow Logs: 1 year, application logs: 90 days), queryable for security investigations, and cost-optimized for the different retention periods.

A) Deploy a centralized log archive account. CloudTrail Organization Trail to S3 with Object Lock (7-year compliance mode retention). VPC Flow Logs to CloudWatch Logs with cross-account delivery to S3 in the log archive account (1-year retention). Application logs to CloudWatch Logs with subscriptions to Kinesis Data Firehose to S3. Apply S3 Lifecycle policies: Standard for 90 days, Standard-IA for 1 year, Glacier for 7 years. Use CloudTrail Lake for CloudTrail queries, Athena for VPC and application log queries.
B) Send all logs to CloudWatch Logs in each account. Use CloudWatch Logs retention settings for different log types. Query using CloudWatch Logs Insights.
C) Send all logs to a centralized S3 bucket with a single 7-year retention policy. Use Athena for all queries.
D) Send all logs to Amazon OpenSearch Service for centralized querying. Use OpenSearch ISM policies for retention management. Enable UltraWarm for older logs.

**Correct Answer: A**

**Explanation:** This architecture optimizes each log type for its requirements. CloudTrail with S3 Object Lock in compliance mode provides tamper-proof storage that no one can delete for 7 years — meeting the highest compliance standard. VPC Flow Logs and application logs have shorter retention needs, so lifecycle policies move them through storage tiers (Standard → Standard-IA → Glacier) matching the retention requirements while minimizing cost. Separate query mechanisms optimize for each use case: CloudTrail Lake provides native SQL for CloudTrail data, Athena queries Parquet-formatted VPC and application logs in S3. The centralized log archive account with strict IAM policies prevents tampering. Option B's CloudWatch-only approach is expensive for long retention periods and doesn't provide tamper-proof protection. Option C's single 7-year policy wastes money on logs only needing 90-day retention. Option D's OpenSearch is expensive for 7-year retention at scale.

---

### Question 18
A company's security team notices that GuardDuty is generating findings about DNS queries to cryptocurrency mining domains from several EC2 instances. The team needs to immediately contain the threat, investigate the scope, identify the root cause, and implement preventive controls. This must be handled across the Organization.

A) Immediate containment: Use Lambda triggered by GuardDuty finding to quarantine affected instances (replace security groups with a restrictive one allowing only SSM access). Investigation: Use Amazon Detective to visualize the finding's context — identify related entities, timeline, and scope. Root cause: Check CloudTrail for unauthorized access, Inspector for vulnerabilities that may have been exploited. Prevention: Deploy Route 53 Resolver DNS Firewall with rules blocking known crypto mining domains across all accounts. Update GuardDuty threat lists with identified malicious IPs.
B) Terminate all affected instances immediately to stop the mining activity. Investigate using CloudTrail logs to find who launched the instances. Implement IAM restrictions on instance launches.
C) Block the mining domain IPs in security groups across all accounts. Investigate manually by reviewing each instance's configuration. Implement NACL rules to block future connections to known mining IPs.
D) Report the finding to AWS Abuse team. Wait for AWS to take action on the affected instances. Implement stronger passwords for IAM users.

**Correct Answer: A**

**Explanation:** The structured incident response addresses each phase. Containment: Lambda-based quarantine (triggered by GuardDuty finding via EventBridge) replaces security groups immediately, stopping the mining communication while preserving forensic evidence. SSM access allows remote investigation. Investigation: Amazon Detective provides visual analysis of the GuardDuty finding's context — showing what other resources are related, the timeline of suspicious activities, and the scope of the compromise. Root cause: CloudTrail reveals how the instances were accessed (stolen credentials, exposed keys, etc.) and Inspector shows if known vulnerabilities were exploited. Prevention: DNS Firewall at the Resolver level blocks mining domains organization-wide, preventing future instances from resolving these domains regardless of security group configuration. Option B's immediate termination destroys forensic evidence. Option C's IP-based blocking is easily circumvented by domain name changes. Option D's passive approach allows continued damage.

---

### Question 19
A company has been using AWS Config to monitor resource compliance but is receiving an unexpectedly high monthly bill ($15,000/month) for Config across 100 accounts. Analysis shows that Config is recording configuration changes for ALL resource types in every account, and some accounts have 50+ custom Config rules. The company needs to reduce Config costs while maintaining compliance monitoring for critical resources.

A) Limit Config recording to only the resource types required for compliance (e.g., EC2, S3, IAM, RDS, Lambda, VPC-related resources). Disable recording for resource types not relevant to compliance rules (e.g., CloudWatch dashboards, SNS topics). Consolidate overlapping custom Config rules into fewer rules. Use conformance packs to standardize and reduce duplicate rules across accounts.
B) Disable Config in non-production accounts. Keep full recording only in production accounts.
C) Switch from continuous recording to periodic recording (daily snapshots) for all resource types. This reduces configuration item recordings by 90%.
D) Replace Config rules with Security Hub controls. Disable Config rules that overlap with Security Hub's automated checks.

**Correct Answer: A**

**Explanation:** The primary Config cost drivers are: configuration item (CI) recording charges per resource type per region, and rule evaluation charges per rule per resource. By recording only compliance-relevant resource types (typically 15-20 types vs. all 200+ types), CI recording costs drop significantly. In accounts with 50+ rules, many likely overlap (e.g., multiple rules checking S3 encryption with slightly different scopes). Consolidating into conformance packs eliminates redundancy. AWS publishes conformance pack templates that combine multiple related rules efficiently. Option B eliminates non-production compliance monitoring, which may be required by auditors. Option C's periodic recording misses configuration changes between snapshots, creating compliance gaps. Option D removes Config rules but Security Hub still needs Config for its automated checks — they're complementary, not replaceable.

---

### Question 20
A company needs to implement identity-based access controls across their AWS Organization that align with their enterprise identity governance. Requirements include: single sign-on using their existing Okta identity provider, role-based access with permission sets mapped to job functions, temporary elevated access for break-glass scenarios with automatic revocation, and access certification reviews every 90 days showing who has access to what.

A) Configure AWS IAM Identity Center with Okta as the external identity provider using SAML 2.0. Create permission sets mapped to job functions (Developer, DBA, SecurityAuditor, etc.) and assign to groups synced from Okta. For break-glass access, implement a Step Functions workflow triggered via API Gateway: the workflow creates a temporary IAM Identity Center assignment, waits for a configurable duration (with SNS approval), then automatically removes the assignment. Use IAM Access Analyzer to generate access reports for 90-day certification reviews.
B) Configure individual IAM identity providers in each account for Okta federation. Create IAM roles per job function in each account. Use Okta's MFA for break-glass access. Manually review IAM roles quarterly.
C) Use AWS Managed Microsoft AD as the identity source for IAM Identity Center. Sync users from Okta to Managed AD, then to Identity Center. Use Group-based permission assignments.
D) Configure IAM Identity Center with Okta using SCIM for automatic user provisioning. Use permission sets with session duration policies. For break-glass, use the IAM Identity Center temporary elevated access management feature. Use IAM Access Analyzer for access reviews.

**Correct Answer: D**

**Explanation:** IAM Identity Center with Okta using SCIM (System for Cross-domain Identity Management) provides automatic user/group provisioning — when users or groups change in Okta, Identity Center automatically reflects those changes. Permission sets map to job functions and are assigned to Okta-synced groups. Session duration policies control how long elevated access persists. IAM Identity Center now supports temporary elevated access management, allowing users to request elevated permissions that automatically expire after a defined period. IAM Access Analyzer's access reviews show the effective permissions for each principal, supporting 90-day certification reviews. Option A's Step Functions workflow is custom-built when the managed feature exists. Option B's per-account IAM providers don't scale. Option C adds an unnecessary Managed AD layer.

---

## Domain 2: Design for New Solutions (Questions 21–42)

### Question 21
A pharmaceutical company needs to design a compliant data analytics platform for clinical trial data. The platform must: enforce row-level and column-level access control based on user roles, encrypt all data with customer-managed KMS keys, maintain an immutable audit trail of all data access, comply with FDA 21 CFR Part 11 (electronic records, electronic signatures), and prevent data exfiltration through unauthorized exports.

A) Use AWS Lake Formation for fine-grained access control. Register S3 data locations with Lake Formation. Define databases and tables in the Glue Data Catalog. Grant column-level and row-level permissions to IAM principals using Lake Formation permissions. Enable Lake Formation audit logging to CloudTrail. Configure S3 bucket policies denying direct S3 access, forcing all access through Lake Formation. Use KMS CMKs for encryption. Deploy VPC endpoints for Athena/Redshift to prevent internet access.
B) Deploy an Amazon Redshift cluster with row-level security (RLS) policies and column-level access control using views. Use Redshift audit logging for access tracking. Encrypt with KMS. Use VPC security groups to restrict access.
C) Use DynamoDB with fine-grained access control using IAM conditions on partition key values. Enable DynamoDB Streams for audit logging. Encrypt with KMS.
D) Store data in S3 with separate prefixes per access level. Use S3 bucket policies with IAM conditions for access control. Enable S3 access logging. Use Macie for DLP.

**Correct Answer: A**

**Explanation:** Lake Formation provides the most comprehensive data governance for analytics platforms. Column-level permissions restrict which columns users can see (e.g., hiding patient identifiers from analysts). Row-level security filters data based on user attributes (e.g., researchers see only their assigned trial data). Lake Formation permissions override IAM policies for the registered data, creating a unified permission model. By blocking direct S3 access (via bucket policy), all data access goes through Lake Formation's governance layer. CloudTrail integration provides the immutable audit trail required by FDA 21 CFR Part 11. KMS CMKs satisfy encryption requirements. VPC endpoints prevent data exfiltration through internet access. Option B's Redshift is suitable but Lake Formation provides broader governance across multiple analytics services (Athena, Redshift, EMR). Option C's DynamoDB isn't designed for analytics workloads. Option D's prefix-based access is coarse-grained.

---

### Question 22
A government agency needs to design a secure document management system that supports classification levels (Unclassified, Confidential, Secret). Documents must only be accessible by users with the appropriate clearance level. The system must prevent users from downloading Secret documents to unclassified endpoints, enforce watermarking on all document views, and maintain chain-of-custody logging.

A) Store documents in S3 with object-level tagging for classification. Use S3 Access Points per classification level with IAM conditions matching user clearance attributes. Deploy Amazon WorkSpaces for secure document access (prevent downloads to personal devices). Use Lambda@Edge with CloudFront to inject dynamic watermarks on document views. Enable CloudTrail data events with S3 Object-level logging for chain-of-custody.
B) Store documents in separate S3 buckets per classification level. Use bucket policies with IAM role conditions. Deploy VDI (EC2 instances) for document access. Implement custom watermarking in the application layer.
C) Use AWS WorkDocs for document management. Configure sharing policies based on classification. Enable WorkDocs activity feed for audit logging.
D) Store documents in an encrypted EFS file system. Use POSIX permissions for classification-based access control. Mount EFS on Amazon WorkSpaces. Implement OS-level DLP agents.

**Correct Answer: A**

**Explanation:** This architecture implements defense in depth for classified document management. S3 object tagging with classification labels enables policy-based access control. S3 Access Points per classification level enforce separation with IAM conditions that match the user's clearance attribute (stored as IAM session tags or STS tag assertion). WorkSpaces provides managed secure desktops that can be configured to prevent file downloads, clipboard transfer, and printing, ensuring Secret documents cannot be exfiltrated to unclassified endpoints. Lambda@Edge dynamically injects watermarks (username, timestamp, classification) into document views served through CloudFront. CloudTrail S3 data events log every access with user identity, providing the chain-of-custody trail. Option B's VDI requires managing EC2 instances. Option C's WorkDocs lacks the granular classification controls. Option D's EFS POSIX permissions are less granular than IAM-based policies.

---

### Question 23
A multinational company needs to design a GDPR-compliant data processing architecture on AWS. Requirements include: data subject access requests (DSAR) must be fulfilled within 30 days, right to erasure must be supported for all personal data, data processing activities must be logged, personal data transfers outside the EU must be documented and authorized, and privacy impact assessments must be conducted for new data processing activities.

A) Store all EU personal data in EU regions using SCPs to enforce data residency. Implement a DSAR automation workflow using Step Functions that: queries Amazon Macie for data discovery across S3 buckets, searches DynamoDB/RDS for personal data using Lambda functions, aggregates results, and delivers them to the requestor via encrypted S3 presigned URL. For erasure, use the same discovery to locate and delete personal data with verification. Log all processing activities in CloudTrail and DynamoDB. Use AWS Transfer Family with SFTP for authorized cross-border transfers.
B) Implement a manual process where the privacy team searches for personal data on request. Use S3 lifecycle policies to delete data. Log processing in spreadsheets.
C) Use Amazon Macie for continuous personal data discovery. Deploy AWS Config rules to ensure all data stores are in EU regions. Use Lambda for DSAR automation.
D) Deploy a third-party privacy management platform for DSAR handling. Use the platform's data discovery, erasure, and logging capabilities. Connect to AWS via API.

**Correct Answer: A**

**Explanation:** This comprehensive architecture automates GDPR compliance. SCPs enforce EU data residency by denying resource creation in non-EU regions for accounts processing personal data. The Step Functions DSAR workflow automates the discovery-aggregation-delivery process within the 30-day requirement: Macie discovers personal data in S3, Lambda queries structured databases, and the aggregated results are delivered securely. The same discovery pipeline supports right-to-erasure by locating all instances of personal data across services. CloudTrail provides immutable logging of all data processing activities. DynamoDB stores DSAR request tracking and processing records (data processing register). Authorized cross-border transfers use AWS Transfer Family for controlled, logged data movement. Option B's manual process won't scale and risks missing the 30-day deadline. Option C is incomplete — lacks the full DSAR workflow. Option D adds external dependency for what AWS services can handle natively.

---

### Question 24
A company needs to design a secure secrets management solution that supports: 100 microservices across 20 accounts, automatic secret rotation for database credentials and API keys, cross-account secret sharing for shared infrastructure credentials, emergency access to secrets during service outages, and audit logging of all secret access.

A) Use AWS Secrets Manager with automatic rotation enabled for all database credentials. Share secrets cross-account using resource-based policies with specific IAM role ARNs. For API keys, implement custom rotation Lambda functions. Deploy a break-glass IAM role with direct Secrets Manager access, protected by MFA and monitored by CloudTrail alarms. Use cross-account IAM roles for microservice access patterns.
B) Store secrets in AWS Systems Manager Parameter Store SecureString parameters. Use cross-account IAM roles for access. Implement custom rotation using Lambda and CloudWatch Events.
C) Use HashiCorp Vault deployed on ECS for centralized secrets management. Vault handles rotation, access control, and audit logging. Deploy in each region for low latency.
D) Store secrets in KMS-encrypted S3 objects. Use S3 bucket policies for cross-account sharing. Implement rotation by uploading new secret values. Use S3 access logging for audit.

**Correct Answer: A**

**Explanation:** Secrets Manager is the AWS-native secrets management service with built-in rotation capabilities. For RDS, Redshift, and DocumentDB, Secrets Manager provides managed rotation using pre-built Lambda functions. For custom secrets (API keys), custom rotation Lambda functions implement the four-step rotation process (createSecret, setSecret, testSecret, finishSecret). Resource-based policies on secrets enable cross-account sharing with specific IAM principal restrictions. The break-glass pattern provides emergency access: a dedicated IAM role with MFA requirement that can directly access secrets, with CloudTrail monitoring and CloudWatch alarms on any usage of the break-glass role. CloudTrail logs all GetSecretValue and RotateSecret API calls. Option B's Parameter Store lacks native rotation and has lower API request rate limits. Option C adds operational overhead of managing Vault infrastructure. Option D is not designed for secrets management.

---

### Question 25
A financial institution needs to implement network segmentation that satisfies both PCI DSS and SOX requirements. The network architecture must: isolate cardholder data environment (CDE) from corporate networks, restrict access to financial reporting systems, implement layered security with IDS/IPS, log and inspect all cross-zone traffic, and support compliance evidence generation.

A) Deploy a multi-VPC architecture with Transit Gateway: CDE VPC (PCI scope), financial reporting VPC (SOX scope), corporate VPC, and shared services VPC. Deploy Network Firewall between each zone with IDS/IPS rules (Suricata-compatible). Use Transit Gateway route tables to enforce segmentation. Enable VPC Flow Logs for all VPCs with centralized delivery to S3. Deploy AWS Config with PCI DSS and custom SOX conformance packs. Use Audit Manager with custom frameworks covering both PCI and SOX controls for evidence collection.
B) Use a single VPC with separate subnets for CDE, financial, and corporate workloads. Security groups provide isolation between zones. NACLs add an additional layer of control.
C) Deploy separate AWS accounts for each compliance domain. Use no network connectivity between accounts. Access shared services through the internet with VPN encryption.
D) Use AWS Firewall Manager to deploy common security policies across all VPCs. Implement WAF rules for application-level security. Use Shield Advanced for DDoS protection.

**Correct Answer: A**

**Explanation:** This architecture addresses both compliance frameworks with network-level isolation. Separate VPCs provide the strongest segmentation — CDE, financial reporting, corporate, and shared services are physically separate networks. Transit Gateway with route tables controls which zones can communicate (CDE only talks to shared services, not corporate). Network Firewall with Suricata IDS/IPS rules between zones satisfies both PCI DSS Requirement 1 (firewall/network segmentation) and SOX network monitoring requirements. VPC Flow Logs provide the traffic logging evidence. Config conformance packs continuously monitor resource compliance against both frameworks. Audit Manager automates evidence collection mapped to both PCI and SOX control families. Option B's single VPC with subnets doesn't provide sufficient segmentation for PCI DSS. Option C's no connectivity approach is impractical. Option D's Firewall Manager alone doesn't provide the network segmentation architecture.

---

### Question 26
A company is designing a zero-trust security architecture on AWS. The principles include: verify every access request regardless of network location, enforce least privilege with just-in-time access, continuously validate security posture, encrypt all data in transit (even within the VPC), and maintain comprehensive access logs. The environment has 50 microservices across 10 accounts.

A) Implement AWS Verified Access for application-level zero trust (replaces VPN for user access). Use IAM Roles for Service Accounts (IRSA) on EKS with short-lived credentials for service-to-service auth. Deploy service mesh (App Mesh) with mTLS for all inter-service communication. Use IAM Identity Center with temporary elevated access for just-in-time privileged access. Enable VPC endpoint policies for AWS service access control. Implement Security Hub with continuous security posture assessment. Enable CloudTrail for comprehensive logging.
B) Deploy VPN with MFA for all access to AWS resources. Use long-lived IAM access keys with MFA enforcement. Enable encryption in transit using ALB with HTTPS. Use security groups for network-level zero trust.
C) Use AWS PrivateLink for all internal service communication. Implement mutual TLS at the application level using custom certificates. Use STS for temporary credentials. Deploy GuardDuty for continuous monitoring.
D) Deploy AWS Network Firewall in every VPC for traffic inspection. Use VPC peering with strict route tables. Implement IAM policies with IP-based conditions to verify network location.

**Correct Answer: A**

**Explanation:** True zero-trust architecture verifies identity and security posture at every access point. AWS Verified Access provides identity-aware application access without VPN, evaluating user identity and device posture for each request. IRSA provides pods with short-lived AWS credentials tied to specific Kubernetes service accounts (least privilege). App Mesh with mTLS encrypts and authenticates all inter-service traffic (even within the VPC) — no implicit trust based on network location. IAM Identity Center's temporary elevated access implements just-in-time privileged access with automatic expiration. VPC endpoint policies add another verification layer for AWS service access. Security Hub continuously assesses security posture. Option B's VPN and long-lived keys contradict zero-trust principles. Option C addresses some aspects but misses user access and continuous posture assessment. Option D's network-centric approach (firewall, IP conditions) contradicts the zero-trust principle of not relying on network location.

---

### Question 27
A healthcare organization needs to design a system that enables secure sharing of de-identified patient data with external research partners. Requirements include: automated de-identification of PHI fields, ability to re-identify data only by authorized personnel with proper approval, maintain data utility for research purposes, audit all access and re-identification events, and comply with HIPAA Safe Harbor de-identification method.

A) Use AWS Glue with custom PySpark transformations for de-identification. Implement tokenization for direct identifiers (names, SSN, MRN) using a separate tokenization service backed by DynamoDB with KMS encryption. Apply generalization for quasi-identifiers (dates to year, ZIP codes to first 3 digits) per HIPAA Safe Harbor. Store de-identified data in S3 accessible via Lake Formation. Store the tokenization mapping in a separate account with strict access controls. Re-identification requires Step Functions approval workflow with MFA and is logged in CloudTrail.
B) Use Amazon Comprehend Medical to identify PHI entities, then redact them from the dataset. Store redacted data in S3. Share with partners via S3 presigned URLs.
C) Manually review and de-identify datasets using spreadsheet tools. Upload de-identified data to S3 for partner access. Maintain a separate file mapping de-identified to original data.
D) Use Amazon Macie to discover PHI in S3 buckets. Use S3 Object Lambda to dynamically de-identify data on access. Each partner receives a different de-identification view.

**Correct Answer: A**

**Explanation:** This architecture implements HIPAA Safe Harbor de-identification with reversible tokenization. Direct identifiers (18 HIPAA identifiers) are tokenized — replaced with random tokens using a deterministic tokenization service. The tokenization mapping (stored separately in DynamoDB with KMS encryption) enables authorized re-identification when needed. Quasi-identifiers are generalized (date → year, ZIP → first 3 digits) per HIPAA Safe Harbor methodology while maintaining data utility for research. Lake Formation provides fine-grained access control for research partners. The re-identification approval workflow (Step Functions + MFA) ensures only authorized personnel can de-tokenize data, with full CloudTrail logging. Option B's redaction is irreversible — re-identification is impossible. Option C is manual and doesn't scale. Option D's dynamic de-identification doesn't provide permanent de-identification for partner datasets.

---

### Question 28
A company needs to implement a comprehensive vulnerability management program across 200 AWS accounts. Requirements include: continuous vulnerability scanning for EC2 instances, container images in ECR, and Lambda functions, prioritization based on business criticality and exploitability, integration with their ticketing system (Jira), automated remediation for known fixes, and compliance reporting showing vulnerability posture.

A) Deploy Amazon Inspector across the organization using the delegated administrator model. Inspector automatically discovers and scans EC2 instances (using SSM agent), ECR container images, and Lambda functions. Use Inspector's risk-based scoring (CVSS + exploit availability + network reachability) for prioritization. Tag resources with BusinessCriticality to weight findings. Route findings to Security Hub, then to EventBridge for Jira ticket creation via Lambda. Implement automated patching via SSM Patch Manager for EC2 and automated ECR image rebuilds via CodePipeline for container vulnerabilities.
B) Use AWS Config rules to check for known vulnerable software versions. Implement custom scanning using open-source tools (Trivy, Clair) deployed on EC2 for container scanning.
C) Use Security Hub as the primary vulnerability management tool. Enable the FSBP standard which checks for some vulnerability-related configurations. Export findings for Jira integration.
D) Deploy GuardDuty for vulnerability detection. GuardDuty identifies exploited vulnerabilities through runtime behavior analysis. Use GuardDuty findings for remediation prioritization.

**Correct Answer: A**

**Explanation:** Amazon Inspector provides comprehensive, continuous vulnerability scanning across EC2 instances, ECR images, and Lambda functions — the three primary compute platforms. Inspector's risk scoring combines CVSS severity, exploit availability (is a working exploit in the wild?), and network reachability (is the vulnerable resource internet-facing?) to prioritize effectively. Business criticality tagging adds organizational context to prioritization. The Security Hub → EventBridge → Lambda → Jira pipeline automates ticket creation for findings that require human attention. Automated remediation handles known fixes: SSM Patch Manager applies OS and application patches to EC2, and CodePipeline triggers container image rebuilds when base images have vulnerability fixes. Option B requires managing open-source scanning tools. Option C's Security Hub doesn't perform vulnerability scanning. Option D's GuardDuty detects threats, not vulnerabilities.

---

### Question 29
A company is deploying an application that processes credit card data and needs to design the KMS key hierarchy. Requirements include: separate encryption keys for different data classifications (cardholder data, PII, general data), key rotation every 365 days, some keys must be importable (BYOK) from their on-premises HSM, auditability of all key usage, and key deletion must require multi-party approval.

A) Create separate KMS CMKs for each data classification: one with AWS-managed key material and automatic annual rotation for general data, one with customer-managed key material (BYOK imported from the on-premises HSM) for cardholder data, and one AWS-managed CMK for PII. Enable CloudTrail logging for all KMS API calls. Implement key policies that require multi-party approval for ScheduleKeyDeletion by requiring two IAM principals from different teams.
B) Create a single KMS CMK for all data encryption. Use encryption context to differentiate data classifications. Enable automatic key rotation.
C) Use AWS CloudHSM for all encryption operations. CloudHSM provides the highest level of key control. Manage key hierarchy within CloudHSM using PKCS#11 APIs.
D) Create KMS keys with customer-managed key material for all classifications. Implement manual rotation by creating new keys annually and re-encrypting data. Use key aliases to manage rotation.

**Correct Answer: A**

**Explanation:** Separate CMKs per data classification provides the strongest access control — key policies restrict which IAM principals can use each key, ensuring cardholder data keys are only usable by payment processing services. BYOK (imported key material) for cardholder data satisfies PCI DSS requirements for key management control — the key material originates from the company's on-premises HSM. Automatic rotation (annual) is supported for AWS-generated key material and eliminates operational burden. For BYOK keys, manual rotation is required (create new key, import new material, re-encrypt). CloudTrail captures all KMS API calls (Encrypt, Decrypt, GenerateDataKey, etc.) for audit. Multi-party key deletion requires key policies with conditions that mandate approval from multiple IAM principals, preventing accidental or unauthorized key deletion. Option B's single key doesn't provide classification-based access control. Option C's CloudHSM adds operational complexity beyond what's needed. Option D's manual rotation for all keys is unnecessary for non-BYOK keys.

---

### Question 30
A company needs to implement automated compliance remediation across their AWS Organization. They have identified 50 common compliance violations that they want to automatically fix. Remediation must be safe (not disrupt production), auditable, and follow change management processes for production accounts while being fully automated for development accounts.

A) Deploy AWS Config rules for each violation with SSM Automation documents as remediation actions. For development accounts: enable Config auto-remediation with automatic execution. For production accounts: configure Config remediation to execute SSM Automation with a manual approval step via SNS notification to the change management team. All remediation actions are logged in CloudTrail and SSM Automation execution history. Use conformance packs to deploy rules and remediation consistently across the organization.
B) Use EventBridge rules to detect Config compliance changes. Trigger Step Functions workflows that implement remediation logic in Lambda. Include approval gates for production. Log all actions.
C) Deploy Security Hub with automated response and remediation playbooks. Security Hub's integration with Systems Manager provides pre-built remediation runbooks for common violations.
D) Use AWS Firewall Manager for network-related remediations and Config for resource-level remediations. Separate the remediation responsibilities between the networking and security teams.

**Correct Answer: A**

**Explanation:** Config auto-remediation with SSM Automation provides the native, integrated solution. SSM Automation documents define the remediation steps (e.g., enable S3 encryption, enable versioning, restrict security group rules). For development accounts, Config triggers remediation automatically on compliance violations — fully automated. For production accounts, the SSM Automation document includes an approval step (aws:approve action type) that sends an SNS notification to the change management team; the automation pauses until approved. This satisfies change management requirements while still automating the remediation execution. All actions are audited through Config compliance history, SSM Automation execution history, and CloudTrail. Conformance packs ensure consistent deployment across accounts. Option B builds custom what Config remediation provides natively. Option C's Security Hub doesn't provide the remediation depth of Config + SSM. Option D splits responsibilities unnecessarily.

---

### Question 31
A company needs to design an AWS environment for running workloads that must comply with both ITAR (International Traffic in Arms Regulations) and ISO 27001. ITAR requires that only US persons have access to controlled data, and the data must reside in US-based facilities. The company has 50 employees with US person status and 30 international employees who cannot access ITAR data.

A) Deploy ITAR workloads in AWS GovCloud (US) regions (US person-operated by AWS). Use IAM Identity Center with attribute-based access control (ABAC) — US person status as a session tag. Enforce access policies that require the USPerson=true tag for ITAR-classified resources. Deploy non-ITAR workloads in standard commercial regions. Use SCPs in GovCloud to restrict resource creation to US regions only. Implement AWS Config with ISO 27001 conformance pack. Enable CloudTrail for audit logging.
B) Deploy in standard US commercial regions (us-east-1, us-west-2). Use IAM policies to restrict access to US persons based on IP address ranges (corporate VPN).
C) Deploy all workloads in GovCloud regardless of ITAR classification. This simplifies management by applying the highest security standard to everything.
D) Use AWS Outposts in the company's US-based facility. ITAR data stays on the company's premises, ensuring US-person-only physical access. Standard AWS connectivity for non-ITAR workloads.

**Correct Answer: A**

**Explanation:** AWS GovCloud (US) is specifically designed for ITAR compliance — it's operated by US persons and located in the US. ABAC with US person status as a session tag enables fine-grained access control: IAM policies with Condition blocks checking the aws:PrincipalTag/USPerson attribute ensure only tagged US persons can access ITAR resources. Non-ITAR workloads in commercial regions avoid unnecessary GovCloud costs for the 30 international employees who only need commercial access. SCPs enforce data residency. Config with ISO 27001 conformance pack provides continuous compliance monitoring for both environments. Option B's commercial regions don't satisfy ITAR's US-person-operated facility requirement. Option C deploys everything in GovCloud unnecessarily, increasing costs and limiting international employee access. Option D's Outposts approach is expensive and doesn't leverage GovCloud's compliance features.

---

### Question 32
A company is building a secure API platform that must meet SOC 2 Type II requirements for availability, security, and confidentiality. The API serves financial data to regulated clients. Requirements include: 99.99% availability SLA, DDoS protection, rate limiting per client, mutual TLS for client authentication, request/response encryption, and comprehensive logging.

A) Deploy API Gateway REST API with Regional endpoint behind AWS Shield Advanced. Configure WAF with rate-limiting rules per client (using API key or source IP). Implement mutual TLS using API Gateway's mTLS support with a custom domain and client certificate truststore in S3. Enable API Gateway access logging and execution logging to CloudWatch. Deploy the API in two regions with Route 53 failover routing for 99.99% availability. Use KMS for data encryption.
B) Deploy an ALB with mutual TLS termination. Use WAF for DDoS and rate limiting. Backend on ECS Fargate. CloudWatch for logging.
C) Use CloudFront with Lambda@Edge for the API. Shield Standard for DDoS. Custom rate limiting in Lambda@Edge. Client certificates validated in Lambda.
D) Deploy API Gateway with a VPC endpoint (private API). Only allow access through Direct Connect from clients. This eliminates DDoS concerns and provides inherent mTLS through private connectivity.

**Correct Answer: A**

**Explanation:** This architecture addresses every SOC 2 requirement. Shield Advanced provides enterprise-grade DDoS protection with 24/7 DDoS Response Team access and cost protection. WAF rate-limiting per client prevents abuse. API Gateway's native mTLS support validates client certificates against a truststore — clients must present a valid certificate for every request, providing strong authentication. Multi-region deployment with Route 53 failover achieves 99.99% availability. Comprehensive logging (access logs, execution logs, CloudTrail API logs) satisfies SOC 2 monitoring and audit requirements. KMS encryption for data at rest completes the security controls. Option B's ALB mTLS is valid but API Gateway provides more comprehensive API management features (throttling, usage plans, documentation). Option C's CloudFront is not ideal for API workloads. Option D's private API limits accessibility and doesn't satisfy the requirement for internet-facing client access.

---

### Question 33
A company has deployed Amazon GuardDuty across 100 accounts and wants to create custom threat detection rules for scenarios specific to their business. Specifically, they want to detect: API calls from countries where they have no operations, access to sensitive S3 buckets outside business hours, unusual patterns of cross-account role assumption, and API calls using console sign-in from unusual locations.

A) GuardDuty already detects unusual API call patterns and geolocation anomalies through its ML models. Enhance detection by creating custom CloudWatch Event rules on CloudTrail events: Lambda functions evaluate API caller's source IP against a geolocation database, check the time-of-day for sensitive bucket access, analyze cross-account AssumeRole patterns against a baseline in DynamoDB, and check console sign-in locations. Route detections to Security Hub as custom findings.
B) Create custom GuardDuty threat lists with IP ranges from countries where the company has no operations. GuardDuty will alert on any traffic to/from these IPs. For other detections, rely on GuardDuty's built-in ML capabilities.
C) Deploy Amazon Macie for S3 access monitoring. Use CloudWatch Logs Insights for CloudTrail analysis. Create custom dashboards for the monitoring scenarios.
D) Use Amazon Detective to create custom detection rules. Detective analyzes CloudTrail and VPC Flow Logs to identify the specified suspicious patterns.

**Correct Answer: A**

**Explanation:** GuardDuty's ML-based detections already cover many of these scenarios (unusual API caller locations, unusual console sign-ins), but custom business rules require additional detection logic. CloudTrail event-driven rules (via EventBridge) with Lambda evaluation provide real-time custom detection. For geolocation: Lambda checks the sourceIPAddress from CloudTrail events against a MaxMind or similar database, alerting on unexpected countries. For time-based: Lambda evaluates the eventTime against business hour windows for sensitive bucket access patterns. For cross-account: Lambda maintains baseline AssumeRole patterns in DynamoDB and alerts on deviations. Publishing detections as Security Hub custom findings integrates them with existing security workflows. Option B's threat IP lists only cover IP-based detection, not time or pattern analysis. Option C's Macie is for data classification, not access pattern monitoring. Option D's Detective is for investigation, not detection.

---

### Question 34
A company operates in a highly regulated industry and needs to implement continuous compliance monitoring that provides real-time compliance scores against multiple frameworks. The compliance dashboard must show: current compliance percentage per framework, trend over time, specific non-compliant resources with remediation guidance, estimated time to remediation for each finding, and executive-level and technical-level views.

A) Use AWS Security Hub as the primary compliance aggregation point. Enable FSBP, CIS, PCI DSS standards. Create custom standards mapping to additional frameworks (SOX, ISO 27001) using Security Hub custom controls. Deploy a QuickSight dashboard consuming Security Hub findings exported to S3 via EventBridge and Kinesis Firehose: executive view shows compliance percentages and trends, technical view shows specific resources with Security Hub remediation guidance. Use Config compliance history in the Data Catalog for trend analysis.
B) Deploy AWS Audit Manager with multiple framework assessments. Use Audit Manager dashboards for compliance scoring. Export assessment reports for executive review.
C) Build a custom compliance dashboard using Lambda that queries Config, Security Hub, GuardDuty, and Inspector APIs, calculates compliance scores, and stores results in DynamoDB. Visualize with a custom web application on ECS.
D) Use AWS Trusted Advisor with Business/Enterprise Support for compliance checks. Trusted Advisor provides recommendations that map to compliance requirements. Use the Trusted Advisor dashboard for compliance visibility.

**Correct Answer: A**

**Explanation:** Security Hub provides the most comprehensive real-time compliance view. It natively supports multiple frameworks (FSBP, CIS, PCI DSS) and allows custom controls for additional frameworks. The compliance percentage per standard is calculated automatically and updated in real-time. EventBridge exports findings to S3 for historical analysis, enabling QuickSight to show compliance trends over months. Each finding includes remediation guidance. The dual-dashboard approach serves both audiences: executives see high-level scores and trends, while technical teams see specific resources needing remediation. Config compliance timeline adds resource-level historical data. Option B's Audit Manager is optimized for audit evidence collection, not real-time operational dashboards. Option C is a large custom build. Option D's Trusted Advisor doesn't provide compliance framework mapping.

---

### Question 35
A company needs to implement data encryption governance across their AWS Organization. Requirements include: all EBS volumes, S3 buckets, RDS instances, and DynamoDB tables must be encrypted, encryption must use customer-managed KMS keys (not AWS-managed or service-default keys), each business unit must use its own KMS key, and non-compliant resources must be detected within 1 hour and reported.

A) Deploy SCPs denying resource creation without encryption (ec2:CreateVolume without Encrypted=true, s3:CreateBucket without server-side encryption). Deploy AWS Config rules: encrypted-volumes (checking for CMK encryption), s3-bucket-server-side-encryption-enabled (checking for aws:kms with specific key ARNs), rds-storage-encrypted, dynamodb-table-encrypted-kms. Use Config remediation to re-encrypt non-compliant resources with the correct business unit CMK. Config evaluations run within the 1-hour detection window.
B) Use AWS CloudTrail to detect resource creation events. Lambda functions evaluate whether encryption was specified and tag the resource. A second Lambda remediates non-compliant resources.
C) Create KMS key policies that deny encryption with AWS-managed keys. This forces all services to use customer-managed keys.
D) Enable AWS default encryption for EBS, S3, and RDS at the account level using the correct CMK. This ensures all new resources are encrypted without additional controls.

**Correct Answer: A**

**Explanation:** The layered approach uses both preventive (SCPs) and detective (Config) controls. SCPs prevent creation of unencrypted resources — for example, denying ec2:CreateVolume when the encrypted condition is not true. Config rules detect resources that might bypass SCPs (existing resources, resources created before SCPs were applied) and check that encryption uses the correct business unit CMK, not just any key. The Config rules can be customized to verify the KMS key ARN matches the expected business unit key. Auto-remediation changes encryption to the correct CMK. This runs within the 1-hour detection requirement since Config evaluates resource changes in near-real-time. Option B's CloudTrail-based approach is more complex than Config for resource compliance checks. Option C's KMS key policies can't prevent use of AWS-managed keys by services that default to them. Option D's default encryption helps but doesn't enforce per-business-unit key usage.

---

### Question 36
A company needs to implement a security incident response plan for their AWS environment. The plan must include: automated detection and alerting, predefined response playbooks for common incident types, evidence preservation for forensic analysis, containment and eradication procedures, and post-incident review and improvement processes.

A) Use GuardDuty for detection with EventBridge rules routing findings to SNS (alerting) and Step Functions (automated response). Create Step Functions state machines for each incident type: compromised credentials (disable access keys, revoke sessions, notify), compromised EC2 (quarantine SG, create EBS snapshots, create forensic AMI, isolate), data exfiltration (block VPC egress, revoke S3 access, preserve CloudTrail logs). Use S3 with Object Lock for evidence storage. Deploy Systems Manager Incident Manager for incident coordination, runbooks, and post-incident analysis.
B) Train the security team to manually respond to incidents using AWS console access. Create wiki documentation for response procedures. Use email notifications for alerting.
C) Use AWS Security Hub for detection. Create custom actions that trigger Lambda functions for response. Store evidence in EBS snapshots.
D) Deploy a third-party SOAR platform (Palo Alto XSOAR) for automated incident response. Connect to AWS via API for detection and response actions.

**Correct Answer: A**

**Explanation:** This architecture implements a comprehensive incident response capability. GuardDuty provides ML-based detection across multiple threat vectors. Step Functions state machines implement deterministic response playbooks — each incident type has predefined, tested steps that execute automatically. Evidence preservation includes: EBS snapshots (disk forensics), forensic AMIs (full machine state), CloudTrail logs preserved with Object Lock (tamper-proof activity records), and VPC Flow Logs (network evidence). Quarantine security groups isolate compromised resources while preserving them for analysis. Systems Manager Incident Manager coordinates the human aspects: incident tracking, escalation, runbook execution, and post-incident review with timeline analysis. Option B's manual approach is too slow for critical incidents. Option C doesn't provide comprehensive playbook orchestration. Option D adds external dependency and cost.

---

### Question 37
A company needs to implement a cloud security posture management (CSPM) solution using AWS-native services. The solution must: continuously assess security configuration across 200 accounts, detect cloud misconfigurations (open security groups, public S3 buckets, unencrypted resources), prioritize findings based on risk, provide actionable remediation steps, and benchmark against industry standards.

A) Deploy Security Hub as the central CSPM with delegated administrator. Enable FSBP (AWS Foundational Security Best Practices) as the primary standard — it covers common misconfigurations. Enable CIS Benchmarks for industry standards. Use Security Hub's severity ratings and compliance status for prioritization. Implement automatic remediation for critical findings using EventBridge rules with SSM Automation. Build QuickSight dashboards for CSPM visibility.
B) Use AWS Config with managed rules for misconfiguration detection. Deploy Config across the organization with an aggregator for centralized visibility. Use Config conformance packs for standard benchmarks.
C) Deploy Amazon Inspector for vulnerability assessment. Inspector scans EC2 instances, containers, and Lambda functions for security issues. Use Inspector's risk-based scoring for prioritization.
D) Use AWS Trusted Advisor for configuration assessment. Trusted Advisor checks security, cost, performance, and fault tolerance. Enable all security checks with Business/Enterprise Support.

**Correct Answer: A**

**Explanation:** Security Hub functions as a CSPM by aggregating and normalizing security findings from multiple AWS services (Config, GuardDuty, Inspector, Macie). FSBP contains 200+ controls that detect common cloud misconfigurations — it's the most comprehensive security configuration standard. CIS Benchmarks add industry-recognized best practices. Security Hub's severity (CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL) combined with compliance status provides risk-based prioritization. Each finding includes remediation steps. The organizational deployment ensures all 200 accounts are assessed continuously. Automated remediation via EventBridge+SSM handles critical misconfigurations without manual intervention. Option B's Config is a component of the CSPM (Security Hub consumes Config findings), not the complete solution. Option C's Inspector focuses on vulnerabilities, not configuration misconfigurations. Option D's Trusted Advisor has limited depth compared to Security Hub.

---

### Question 38
A company has AWS CloudTrail logging enabled but needs to detect specific insider threat patterns: an administrator creating IAM users for unauthorized access, someone modifying CloudTrail configurations to cover tracks, unusual data downloads from S3 (more than 10 GB in an hour per user), and privilege escalation through IAM policy modifications.

A) Create EventBridge rules matching specific CloudTrail event patterns. Rule 1: Match iam:CreateUser, iam:CreateAccessKey from non-automation IAM principals. Rule 2: Match cloudtrail:StopLogging, cloudtrail:DeleteTrail, cloudtrail:UpdateTrail. Rule 3: Use CloudTrail S3 data events with Lambda that aggregates download volume per user per hour and alerts above 10 GB threshold. Rule 4: Match iam:AttachUserPolicy, iam:PutUserPolicy, iam:AttachRolePolicy with specific policy ARNs (AdministratorAccess, PowerUserAccess). Route all alerts to SNS for SOC notification and Security Hub as custom findings.
B) Use GuardDuty to detect all insider threats. GuardDuty's ML models identify anomalous IAM activity automatically.
C) Enable CloudTrail Insights to detect unusual API call volumes. Insights detects when API call patterns deviate from baseline, which may indicate insider threats.
D) Deploy a UEBA (User and Entity Behavior Analytics) solution from AWS Marketplace. These solutions specialize in insider threat detection using ML.

**Correct Answer: A**

**Explanation:** Specific insider threat patterns require targeted detection rules. EventBridge rules matching exact CloudTrail event patterns provide deterministic, reliable detection for known threat scenarios. IAM user creation by non-automation principals catches unauthorized access provisioning. CloudTrail modification detection is critical — an insider may try to disable logging before malicious actions. S3 download volume aggregation catches data exfiltration patterns. IAM privilege escalation detection catches attempts to gain administrator access. Publishing to both SNS (immediate SOC alert) and Security Hub (tracking and remediation workflow) ensures comprehensive response. Option B's GuardDuty detects some anomalies but doesn't provide the specific, rule-based detection needed for these exact patterns. Option C's CloudTrail Insights detects volume anomalies but not the specific event patterns described. Option D adds third-party cost and dependency.

---

### Question 39
A company is deploying a new application that processes healthcare data and must pass a HITRUST assessment. They need to map their AWS controls to HITRUST CSF (Common Security Framework) requirements. The mapping must be maintained as AWS services evolve and as HITRUST updates its framework.

A) Use AWS Audit Manager with the HITRUST CSF framework. Audit Manager provides a pre-built mapping of AWS controls to HITRUST requirements. Configure automated evidence collection from Config, CloudTrail, Security Hub, and other services. Assign control owners in Audit Manager for accountability. Generate assessment reports for the HITRUST assessor. As AWS or HITRUST updates, AWS updates the Audit Manager framework mapping.
B) Hire a HITRUST assessor to manually map AWS controls to HITRUST requirements. Maintain the mapping in a spreadsheet. Update annually.
C) Use AWS Artifact to download compliance reports that demonstrate HITRUST compliance. AWS's HITRUST certification covers customer workloads.
D) Deploy AWS Config with a custom conformance pack that implements HITRUST CSF controls. Build the mapping manually in the conformance pack template.

**Correct Answer: A**

**Explanation:** AWS Audit Manager with the HITRUST CSF framework provides automated, maintained mapping between AWS controls and HITRUST requirements. The framework assessment continuously collects evidence from AWS services (Config compliance results, CloudTrail logs, Security Hub findings) and organizes them by HITRUST control domain. Control owners can review evidence, add manual evidence where needed, and track assessment progress. The assessment report is designed for HITRUST assessors. AWS maintains and updates the framework mapping as both AWS services and HITRUST CSF evolve, eliminating the manual mapping maintenance burden. Option B's manual approach is expensive and quickly outdated. Option C's AWS certification under the shared responsibility model doesn't cover customer-specific controls. Option D requires building and maintaining the mapping manually.

---

### Question 40
A company uses AWS Config across their Organization and wants to implement custom Config rules for company-specific policies that standard managed rules don't cover. The custom policies include: EC2 instances must use approved AMIs from the company's AMI catalog, Lambda functions must not have environment variables containing patterns that look like secrets, RDS instances must use specific parameter groups based on the environment tag, and S3 buckets must have a specific lifecycle policy configuration.

A) Create AWS Config custom rules using AWS CloudFormation Guard policy-as-code. Guard rules evaluate resource configurations declaratively without Lambda: check EC2 imageId against an approved AMI list, check Lambda environment variables for secret patterns using regex, check RDS parameterGroupName matches the expected value based on tags, check S3 lifecycle configuration for required policies. Deploy via conformance packs across the organization.
B) Create custom Config rules backed by Lambda functions for each policy. Each Lambda evaluates the specific compliance condition and returns COMPLIANT or NON_COMPLIANT. Deploy using CloudFormation StackSets.
C) Use AWS Config managed rules with custom parameters. Many managed rules accept parameters that can customize their behavior for company-specific requirements.
D) Deploy OPA (Open Policy Agent) as a central policy engine. Custom Config rules call OPA for evaluation. OPA provides a richer policy language (Rego) than Guard.

**Correct Answer: A**

**Explanation:** CloudFormation Guard rules (supported by Config custom policy rules) provide a declarative, serverless approach to custom Config rules without Lambda functions. Guard's policy language supports the described checks: AMI allowlists, regex matching for secret patterns in Lambda environment variables, conditional parameter group checks based on tags, and lifecycle configuration validation. Deploying via conformance packs ensures organizational-wide, consistent deployment. Guard rules are evaluated by Config directly — no Lambda invocation needed, reducing cost and complexity. Option B's Lambda-based rules work but add Lambda management overhead and costs for something Guard handles declaratively. Option C's managed rules don't cover these company-specific requirements. Option D introduces an external dependency (OPA) that adds operational complexity.

---

### Question 41
A company needs to implement a secure CI/CD pipeline for deploying to their compliance-regulated AWS environment. Requirements include: code changes must be reviewed and approved before deployment, container images must be scanned for vulnerabilities before deployment, infrastructure changes must be validated against compliance rules, deployment artifacts must be signed and verified, and all pipeline activities must be auditable.

A) CodeCommit with branch protection (require PR approval). CodeBuild for build and test. Amazon ECR with image scanning enabled (Inspector integration) — block deployment if CRITICAL vulnerabilities found. CodePipeline with a manual approval stage for production. Use AWS Signer for code signing and artifact verification. CloudFormation Guard in CodeBuild to validate templates against compliance rules before deployment. CloudTrail logs all pipeline API calls.
B) GitHub with branch protection. Jenkins on EC2 for build. Docker Hub for image storage. Manual deployment to production via SSH.
C) CodeCommit → CodeBuild → CodeDeploy pipeline. Enable all automated stages without manual approval for speed. Use Security Hub for post-deployment compliance checking.
D) GitHub Actions for CI/CD. Use Terraform Cloud for infrastructure deployment. Snyk for container scanning. Manual approval via GitHub PR review.

**Correct Answer: A**

**Explanation:** This pipeline implements security at every stage. CodeCommit branch protection ensures code review (PR approval) before merge. CodeBuild runs unit tests and CloudFormation Guard validates infrastructure templates against compliance rules (preventing non-compliant resources from being deployed). ECR image scanning with Inspector integration detects container vulnerabilities before deployment — the pipeline can be configured to fail if CRITICAL findings exist. AWS Signer provides cryptographic signing of deployment artifacts, and the deployment stage verifies signatures before applying changes. Manual approval for production provides a final human gate for regulated environments. CloudTrail captures all CodePipeline, CodeBuild, and CodeDeploy API calls for audit. Option B uses unmanaged tools with security gaps. Option C lacks vulnerability scanning and manual approval for production. Option D uses non-AWS tools that may not integrate as seamlessly for audit logging.

---

### Question 42
A company wants to implement AWS CloudTrail Lake for cross-account security analysis. They need to: query CloudTrail events across all 100 accounts in their Organization, correlate IAM activity with network events, create reusable saved queries for their security team, retain queryable data for 2 years, and integrate query results with their incident response workflow.

A) Enable CloudTrail Lake with an organization-level event data store in the security account. Configure the data store to retain events for 2 years. Include management events and data events. Create saved queries for common security analysis patterns (compromised credential investigation, lateral movement detection, data exfiltration timelines). Use CloudTrail Lake's integration with Athena for complex queries joining CloudTrail and VPC Flow Log data. Export query results to S3 for incident response documentation.
B) Send CloudTrail logs from all accounts to a centralized S3 bucket. Use Athena to query the logs. Create Athena saved queries and workgroups for the security team.
C) Enable CloudTrail Insights across all accounts. Use Insights events for security analysis. Insights provides anomaly detection that reduces the need for manual querying.
D) Send CloudTrail logs to CloudWatch Logs. Use CloudWatch Logs Insights for cross-account querying. Create CloudWatch dashboards for security monitoring.

**Correct Answer: A**

**Explanation:** CloudTrail Lake provides native SQL querying of CloudTrail events with organization-wide scope. An organization-level event data store automatically collects events from all member accounts without individual trail configuration. Lake supports 7-year retention (2 years is within this limit), saved queries for reusable analysis, and direct integration with Athena for complex joins with other data sources (VPC Flow Logs, Config data). Key advantages over S3+Athena (Option B): no partition management, automatic schema, optimized storage and query performance for CloudTrail data, and built-in organization support. Lake retains the queryable data for the configured retention period without managing S3 lifecycle policies. Option B requires significant infrastructure setup (Glue catalog, partitioning, Athena workgroups). Option C's Insights is for anomaly detection, not investigative queries. Option D's CloudWatch Logs Insights has query complexity limitations and higher cost for 2-year retention.

---

## Domain 3: Continuous Improvement for Existing Solutions (Questions 43–53)

### Question 43
A company has implemented Security Hub across their Organization, but the security team reports that they're spending most of their time on low-impact findings while critical security issues are being missed. The company has 80,000 total findings, with 500 CRITICAL, 5,000 HIGH, 15,000 MEDIUM, and 59,500 LOW/INFORMATIONAL findings. How should they optimize their Security Hub workflow?

A) Create Security Hub automation rules to: (1) auto-resolve INFORMATIONAL findings older than 30 days, (2) auto-suppress LOW findings in non-production accounts, (3) auto-set workflow status to NOTIFIED for new CRITICAL findings and trigger PagerDuty via EventBridge, (4) create custom insights showing "Critical findings in production by resource type" as the default dashboard view. Implement automated remediation for the top 20 most frequent HIGH/CRITICAL finding types.
B) Disable LOW and INFORMATIONAL severity controls in the enabled standards. This prevents these findings from being generated. Focus only on CRITICAL and HIGH.
C) Export all findings to Splunk and use Splunk's triage capabilities. The SOC team manages Security Hub findings through Splunk dashboards.
D) Create a daily email digest of CRITICAL findings only. Ignore all other severity levels until CRITICAL findings are resolved.

**Correct Answer: A**

**Explanation:** Security Hub automation rules (recently added feature) enable automated workflow management at scale. Auto-resolving stale INFORMATIONAL findings and suppressing LOW findings in non-production accounts reduces the visible finding count from 80,000 to approximately 20,500 (CRITICAL + HIGH + production MEDIUM). Auto-notification for CRITICAL findings ensures they get immediate attention via PagerDuty. Custom insights with the default dashboard focused on CRITICAL+HIGH in production ensures the security team sees the most impactful issues first. Automated remediation for the most common finding types (like unencrypted S3 buckets, public security groups) reduces the HIGH finding count over time. Option B disables detection for those severity levels, reducing security visibility. Option C adds tool cost without addressing the triage problem. Option D ignores potentially important HIGH findings.

---

### Question 44
A company has been using AWS Config for 2 years and their Config costs have grown to $20,000/month across 100 accounts. The primary cost drivers are: configuration item (CI) recording for all resource types ($12,000), rule evaluations ($5,000), and conformance pack evaluations ($3,000). The company wants to reduce costs by 50% while maintaining compliance monitoring for critical resources.

A) Switch from continuous recording to daily periodic recording for non-critical resource types (CloudWatch, SNS, SQS resources rarely change). Maintain continuous recording only for security-critical types (IAM, S3, EC2, RDS, Lambda, VPC). Consolidate overlapping rules — many managed rules check similar things. Remove conformance packs from non-production accounts where individual rules suffice.
B) Disable Config in all non-production accounts. Maintain full recording and all rules only in production accounts.
C) Replace Config with Security Hub for compliance monitoring. Security Hub includes many of the same checks as Config rules at a lower per-finding cost.
D) Reduce the number of Config rules to 10 essential rules. Remove all conformance packs. Accept the reduced compliance coverage.

**Correct Answer: A**

**Explanation:** Periodic recording for non-critical resource types is the highest-impact optimization. Resources like CloudWatch dashboards, SNS topics, and SQS queues change infrequently — daily periodic recording captures their state without the cost of recording every API-driven change. Security-critical resources (IAM, S3, EC2, RDS, Lambda, VPC) keep continuous recording for near-real-time compliance monitoring. Rule consolidation eliminates duplicate evaluations — for example, if both a managed rule and a conformance pack rule check S3 encryption, remove the standalone rule. Removing conformance packs from non-production accounts (where individual critical rules suffice) further reduces costs. These optimizations can achieve 50% reduction while maintaining compliance for critical resources. Option B eliminates visibility in non-production. Option C's Security Hub requires Config for many of its checks. Option D accepts reduced compliance coverage.

---

### Question 45
A company's GuardDuty findings show that 70% of their MEDIUM and HIGH findings are related to EC2 instances making DNS requests to known cryptocurrency mining domains. Investigation reveals that these are development instances launched from community AMIs that contain pre-installed mining software. The company needs to address the root cause while maintaining the ability to use community AMIs for testing.

A) Implement an AMI governance process: create an EC2 Image Builder pipeline that takes community AMIs, runs security scanning (Inspector), removes unwanted software (using component documents), and outputs approved AMIs. Deploy an SCP or IAM policy that restricts ec2:RunInstances to only approved AMIs (condition key: ec2:ImageId). Allow exceptions for sandbox accounts. Deploy Route 53 Resolver DNS Firewall to block known mining domains as a network-level control.
B) Block all community AMIs with an SCP denying ec2:RunInstances for non-Amazon AMIs. Only allow AWS-published and company-owned AMIs.
C) Deploy GuardDuty suppression rules for cryptocurrency-related findings from development accounts. This reduces noise without addressing the root cause.
D) Implement NACL rules blocking outbound connections to known mining pool IP ranges. Update the IP list weekly.

**Correct Answer: A**

**Explanation:** This addresses the root cause (contaminated AMIs) with a governance pipeline while maintaining flexibility. EC2 Image Builder creates a "golden AMI" pipeline: community AMIs are scanned for vulnerabilities and malware, unwanted software is removed by component documents, and the resulting clean AMI is published as an approved image. SCPs/IAM policies restrict instance launches to approved AMIs only, preventing untested community AMIs in non-sandbox accounts. Sandbox accounts maintain the exception for testing. DNS Firewall provides a network-level safety net, blocking mining domain resolution even if a contaminated AMI slips through. Option B is too restrictive — it blocks all community AMIs which may be needed for legitimate testing. Option C suppresses symptoms without fixing the cause. Option D's IP-based blocking is easily circumvented by mining pools changing IPs.

---

### Question 46
A company's existing CloudTrail configuration logs management events only. After a security incident, investigators discover they need S3 data events to understand what data was accessed by the compromised credentials. The company wants to enable S3 data events but is concerned about the cost (estimated $50,000/month for all S3 buckets across the organization).

A) Enable S3 data events selectively: identify S3 buckets containing sensitive data using Macie, then enable CloudTrail data events only for those buckets. Use advanced event selectors to filter to specific API calls (GetObject, PutObject, DeleteObject) and exclude read-heavy buckets that serve static content. This targets logging to where it matters most, reducing costs significantly.
B) Enable S3 data events for all buckets across the organization. The security benefit justifies the $50,000/month cost. Use CloudTrail Lake for efficient querying.
C) Don't enable S3 data events. Instead, use S3 server access logging for all buckets. Server access logs are free and provide similar information to CloudTrail data events.
D) Enable S3 data events only in production accounts. Development and staging accounts rarely contain data worth logging at this level.

**Correct Answer: A**

**Explanation:** Selective data event logging optimizes the cost-to-security ratio. Using Macie to identify buckets with sensitive data targets logging where it matters. Advanced event selectors provide fine-grained control — you can specify which S3 API actions to log (GetObject for access monitoring, DeleteObject for deletion monitoring) and which S3 buckets to include/exclude. Excluding read-heavy static content buckets (which would generate massive log volumes with minimal security value) dramatically reduces costs. The result is comprehensive logging for sensitive data at a fraction of the full-deployment cost. Option B's blanket approach is unnecessarily expensive. Option C's S3 access logs don't integrate with CloudTrail Lake/Athena and lack the IAM identity detail that CloudTrail provides. Option D misses sensitive data in non-production accounts.

---

### Question 47
A company has an AWS Organization with 150 accounts and uses multiple security services (GuardDuty, Security Hub, Config, Inspector, Macie). The CISO reports that the organization is struggling with "security tool sprawl" — each service generates alerts independently, the security team switches between 5 different consoles, and there's no unified view of the organization's security posture.

A) Use Security Hub as the single pane of glass. Configure all security services to send findings to Security Hub via native integrations. Create custom Security Hub dashboards (using custom insights) that show the unified security posture: findings by service, by severity, by account, and by resource. Implement EventBridge rules from Security Hub for unified alerting to PagerDuty. Use Security Hub's batch-update capabilities for bulk finding management.
B) Replace all individual security services with Security Hub. Security Hub's standards and controls cover the functionality of GuardDuty, Config, Inspector, and Macie.
C) Export all findings from all services to a central S3 data lake. Build a custom dashboard using QuickSight that queries the data lake for a unified view.
D) Use Amazon Detective as the central console. Detective ingests findings from GuardDuty, Config, and other services and provides a unified investigation interface.

**Correct Answer: A**

**Explanation:** Security Hub is designed to be the central aggregation point for security findings across AWS services. It natively integrates with GuardDuty (threat detection), Config (compliance), Inspector (vulnerabilities), Macie (data security), and 60+ third-party tools. Findings are normalized to the AWS Security Finding Format (ASFF), enabling unified querying and management. Custom insights create dashboards showing the organization's security posture from multiple angles. EventBridge integration provides a single alerting pipeline instead of separate alerts from each service. The batch-update API enables bulk workflow status changes (e.g., marking hundreds of resolved findings at once). Option B incorrectly suggests Security Hub replaces other services — it aggregates their findings but doesn't perform their functions. Option C requires building custom infrastructure. Option D is designed for investigation, not unified security posture management.

---

### Question 48
A company has implemented AWS Control Tower but is experiencing challenges with Account Factory. Provisioning new accounts takes 2-3 days because of manual post-provisioning configuration steps (VPC setup, baseline security tools, SSM configuration, monitoring agents). The company provisions 5-10 new accounts per month and needs to reduce provisioning time to under 4 hours.

A) Implement Account Factory for Terraform (AFT) to customize account provisioning. Define Terraform modules for: VPC networking (Transit Gateway attachment, DNS, flow logs), security baseline (GuardDuty, Security Hub, Config rules), operations baseline (SSM, CloudWatch agents, patching), and IAM baseline (roles, permission sets). AFT executes these customizations automatically after Control Tower provisions the account. Store Terraform state in a centralized backend.
B) Use Customizations for AWS Control Tower (CfCT) with CloudFormation StackSets. Define CloudFormation templates for each post-provisioning configuration. CfCT automatically deploys the StackSets when new accounts are created. Use lifecycle events for triggering.
C) Create a manual runbook documenting all post-provisioning steps. Train the infrastructure team to follow the runbook for each new account. Track completion in a project management tool.
D) Pre-create accounts in bulk (50 at a time) and let them sit until needed. When a team requests an account, assign a pre-configured one. This eliminates wait time at request time.

**Correct Answer: B**

**Explanation:** Customizations for AWS Control Tower (CfCT) is the native solution for automated post-provisioning customization. CfCT uses AWS CodePipeline and CloudFormation StackSets to deploy custom configurations to accounts when they're provisioned (or when configuration changes are pushed). CloudFormation templates define the VPC networking, security baseline, operational tools, and IAM configuration. CfCT responds to Control Tower lifecycle events, automatically deploying customizations to new accounts without manual intervention. The entire provisioning process (Control Tower account creation + CfCT customization) completes in 1-2 hours. Option A's AFT works well for Terraform shops but adds Terraform pipeline complexity. Option B's CfCT is more tightly integrated with Control Tower. Option C is manual and doesn't scale. Option D wastes resources on pre-created accounts.

---

### Question 49
A company's AWS Config aggregate dashboard shows 15,000 non-compliant resources across 100 accounts. The security team needs to systematically reduce this number. Analysis shows: 5,000 are S3 buckets without default encryption, 3,000 are EBS volumes without encryption, 2,000 are security groups with overly permissive rules, 2,000 are IAM users without MFA, and 3,000 are miscellaneous other violations. The team wants to remediate at scale with minimal risk.

A) Prioritize by impact and remediability. Phase 1 (Week 1-2): Auto-remediate S3 encryption — Config remediation with SSM Automation enables default encryption (low risk, high volume). Phase 2 (Week 3-4): Auto-remediate EBS encryption for unattached volumes; report attached volumes for manual remediation during maintenance windows. Phase 3 (Week 5-6): Auto-remediate overly permissive security groups by removing 0.0.0.0/0 rules (with exceptions for ALBs and NLBs). Phase 4 (Week 7-8): Send MFA enforcement notifications to users with 30-day compliance deadline. Phase 5: Address miscellaneous violations individually.
B) Enable auto-remediation for all 50 Config rules simultaneously. Fix everything as quickly as possible.
C) Create a Jira ticket for each of the 15,000 non-compliant resources. Assign tickets to individual teams for manual remediation.
D) Focus only on CRITICAL findings. Ignore MEDIUM and LOW severity non-compliant resources.

**Correct Answer: A**

**Explanation:** Phased, risk-based remediation is the professional approach. S3 default encryption is the safest auto-remediation — enabling it doesn't affect existing objects or access patterns, only encrypts new objects. EBS encryption for unattached volumes is also safe (no running workload impact), while attached volumes need maintenance windows. Security group remediation removes the most dangerous misconfigurations (0.0.0.0/0) with exceptions for resources that legitimately need public access. MFA enforcement requires user action, so notifications with a deadline are more appropriate than auto-remediation (which would lock out users). This phased approach reduces the 15,000 count systematically while managing risk. Option B's simultaneous auto-remediation could cause widespread outages. Option C's manual approach doesn't scale. Option D ignores high-volume, easily fixable issues.

---

### Question 50
A company has deployed Amazon Inspector across their Organization but finds that Inspector is generating findings for EC2 instances that are immutable and replaced regularly (new instances launched from AMI every deployment). The same vulnerability appears on every new instance, creating duplicate findings. The team wants Inspector to focus on the AMI build process rather than individual instances.

A) Integrate Inspector scanning into the EC2 Image Builder pipeline. Add an Inspector scan step that evaluates the AMI for vulnerabilities before it's published. If CRITICAL or HIGH vulnerabilities are found, the pipeline fails and the AMI is not published. For runtime instances, use Inspector suppression rules to suppress findings for instance types that match the immutable deployment pattern (short-lived instances launched from approved AMIs).
B) Disable Inspector scanning for EC2 instances. Enable only ECR container image scanning. Address EC2 vulnerabilities through regular AMI rebuilds.
C) Create Inspector exceptions for all known vulnerability findings. This reduces the finding count but requires maintaining the exception list.
D) Deploy a patching schedule using SSM Patch Manager that runs on every new instance at launch. This resolves vulnerabilities before Inspector scans.

**Correct Answer: A**

**Explanation:** Shifting vulnerability scanning to the AMI build process ("shift left") is the correct approach for immutable infrastructure. EC2 Image Builder with Inspector integration scans AMIs during the build pipeline — vulnerabilities are caught and fixed before any instance uses the AMI. This eliminates the redundant per-instance findings. Suppression rules for runtime instances using the approved AMI pattern reduce noise while maintaining detection for instances that don't follow the immutable pattern. If a new vulnerability is discovered after AMI publication, the build pipeline can be re-triggered to produce a patched AMI. Option B disables runtime scanning entirely, missing vulnerabilities discovered after AMI build. Option C requires manual maintenance of exception lists. Option D adds patching time to every instance launch, delaying deployments and contradicting the immutable infrastructure pattern.

---

### Question 51
A company's security team runs monthly penetration tests against their AWS environment. They need to: test their GuardDuty detection capabilities, verify that automated response playbooks trigger correctly, validate that Network Firewall rules block expected traffic, and test incident response team readiness. They want to do this safely without impacting production.

A) Use a dedicated security testing account in a separate OU with relaxed guardrails. Deploy representative infrastructure (same architecture as production but smaller scale). Use Amazon GuardDuty Findings Simulator (or third-party tools like Atomic Red Team) to generate realistic findings. Use a test event bus in EventBridge to verify automation responses. Use Network Firewall rule testing mode. Conduct tabletop exercises for incident response team readiness.
B) Run penetration tests directly against production. AWS allows customers to perform security assessments without prior approval for most services. This tests the actual production configuration.
C) Use AWS's free tier of penetration testing services. AWS provides automated security assessment through Inspector and Security Hub.
D) Deploy a full copy of the production environment in a separate region. Run penetration tests against the copy. This ensures production is never at risk.

**Correct Answer: A**

**Explanation:** A dedicated security testing account provides a safe environment for security validation. GuardDuty's test findings feature generates sample findings that look realistic and trigger the same EventBridge rules as real findings, validating the automated response pipeline end-to-end. A separate test EventBridge event bus allows verifying automation without actually quarantining production resources. Network Firewall rule testing validates that rules block expected traffic patterns. Using a representative (but smaller) infrastructure reduces costs while still testing the same security controls. Tabletop exercises (simulated incident walkthroughs) test human response procedures without technical risk. Option B risks production impact and doesn't test response automation safely. Option C conflates vulnerability scanning with penetration testing. Option D's full production copy is expensive and still risky if automation connects to production systems.

---

### Question 52
A company recently passed their SOC 2 Type II audit but the auditors noted several observations. One key observation was that the company lacks continuous monitoring of their control effectiveness — they rely on point-in-time checks. The company needs to implement continuous control monitoring that satisfies SOC 2 requirements.

A) Use AWS Security Hub as the continuous control monitoring platform. Map Security Hub controls to SOC 2 Trust Service Criteria. Create Security Hub custom insights showing control compliance percentages over time. Implement automated remediation for controls that drift out of compliance. Generate weekly control effectiveness reports from Security Hub data exported to S3 and visualized in QuickSight. Use AWS Audit Manager to continuously collect evidence linking Security Hub compliance data to SOC 2 controls.
B) Schedule monthly Config compliance snapshots. Compare month-over-month changes. Generate reports from the snapshots for SOC 2 evidence.
C) Hire an external auditor to perform quarterly compliance assessments. Use their reports as evidence of continuous monitoring.
D) Deploy a custom monitoring Lambda function that runs daily, checking all SOC 2-relevant configurations across accounts. Store results in DynamoDB. Generate reports from DynamoDB data.

**Correct Answer: A**

**Explanation:** Continuous control monitoring requires real-time assessment, not periodic checks. Security Hub continuously evaluates resources against security controls (FSBP contains controls mapping to SOC 2 criteria like access management, encryption, logging). The compliance percentage is updated in real-time as resources are created, modified, or deleted. Custom insights track compliance trends over time. Automated remediation ensures controls stay effective — if compliance drifts (e.g., an unencrypted S3 bucket is created), it's automatically corrected. Weekly reports from Security Hub data demonstrate continuous monitoring to auditors. Audit Manager ties it all together by collecting this evidence and mapping it to SOC 2 control families. Option B's monthly snapshots are periodic, not continuous. Option C's quarterly assessments don't satisfy continuous monitoring. Option D is a custom build that duplicates Security Hub's capabilities.

---

### Question 53
A company has discovered that their AWS CloudTrail logs contain sensitive information — API calls include database connection strings, S3 presigned URL signatures, and other sensitive parameters in the request/response fields. The company needs to continue logging all API calls for compliance but must protect the sensitive data in logs.

A) There is no native CloudTrail data masking feature. Implement a post-processing pipeline: CloudTrail → S3 → Lambda (triggered by S3 event) → Lambda redacts sensitive fields using regex patterns → stores redacted copy in a separate S3 bucket for general access. Maintain the original unredacted logs in a restricted S3 bucket accessible only to security administrators for forensic investigations. Apply S3 Object Lock to both buckets.
B) Configure CloudTrail to exclude specific API calls that contain sensitive parameters. This reduces the risk of sensitive data in logs.
C) Encrypt CloudTrail logs with KMS. The encryption protects the sensitive data from unauthorized access. Only users with the KMS decrypt permission can read the logs.
D) Enable CloudTrail log file validation but no other changes. The validation ensures logs haven't been tampered with, which addresses the compliance requirement.

**Correct Answer: A**

**Explanation:** CloudTrail doesn't natively support field-level masking or redaction. The dual-storage approach preserves the original logs for forensic/compliance purposes while providing redacted versions for general security analysis. Lambda-based redaction can use regex patterns to identify and mask connection strings (jdbc:*), presigned URL signatures (X-Amz-Signature=*), and other sensitive patterns. The unredacted bucket with restricted IAM access and Object Lock maintains compliance (complete, immutable logging). The redacted bucket allows broader team access for routine log analysis without exposure to sensitive data. Option B's excluding API calls creates gaps in the audit trail, violating compliance requirements. Option C's encryption restricts access but doesn't redact — authorized users still see sensitive data. Option D's validation only ensures integrity, not data protection.

---

## Domain 4: Accelerate Workload Migration and Modernization (Questions 54–62)

### Question 54
A company is migrating from an on-premises identity management system to AWS. Their current system handles: user authentication via LDAP, authorization using role-based access control, MFA using RSA SecurID tokens, privileged access management with CyberArk, and user lifecycle management (onboarding/offboarding). They want to implement equivalent capabilities using AWS-native services.

A) Deploy AWS IAM Identity Center as the central identity hub, federated with the existing LDAP via AD Connector during migration. Use permission sets for role-based access. Enable MFA using IAM Identity Center's built-in MFA (replacing RSA tokens over time). Implement IAM Identity Center temporary elevated access for privileged access management. Use SCIM with HR system integration for automated user lifecycle management. Phase out LDAP and CyberArk as AWS-native capabilities mature.
B) Keep LDAP and CyberArk on-premises. Federate with AWS using SAML 2.0 from an ADFS proxy. No changes to the identity infrastructure.
C) Deploy AWS Managed Microsoft AD. Extend the on-premises AD to AWS using AD trust. Use Group Policy for authorization. Keep RSA SecurID for MFA.
D) Implement Amazon Cognito as the central identity provider. Use Cognito User Pools for authentication and Cognito Identity Pools for authorization. Enable Cognito MFA.

**Correct Answer: A**

**Explanation:** IAM Identity Center provides a comprehensive AWS-native identity solution. Federation with existing LDAP via AD Connector enables a smooth migration — users continue using existing credentials initially. Permission sets mapped to job functions provide RBAC. Built-in MFA (supporting FIDO2, authenticator apps, and hardware tokens) replaces RSA SecurID. Temporary elevated access management replaces CyberArk for AWS privileged access — users request elevated permissions for a time window with approval. SCIM integration with HR systems automates user provisioning/deprovisioning. The phased approach reduces risk by maintaining existing identity infrastructure during transition. Option B doesn't modernize, maintaining on-premises dependencies. Option C adds AD infrastructure complexity. Option D is designed for customer identity, not workforce identity and access management.

---

### Question 55
A company is modernizing their security operations from a legacy on-premises SIEM to a cloud-native security operations architecture on AWS. The legacy SIEM collects Windows event logs, firewall logs, and application logs. The company wants to maintain these log sources while adding cloud-native detection capabilities.

A) Use Amazon Security Lake as the centralized security data lake. Security Lake collects and normalizes logs from AWS sources (CloudTrail, VPC Flow Logs, Route 53 DNS logs, Security Hub findings, GuardDuty findings) and supports ingestion of on-premises logs (Windows events, firewall logs) via custom sources. Use the OCSF (Open Cybersecurity Schema Framework) schema for normalization. Query with Athena or connect third-party SIEM/analytics tools via the subscriber mechanism.
B) Deploy Amazon OpenSearch Service as the SIEM replacement. Ingest all logs into OpenSearch. Use OpenSearch Security Analytics for detection rules. Build dashboards in OpenSearch Dashboards.
C) Continue using the on-premises SIEM but extend it to collect AWS logs via S3 export. The SIEM handles all correlation and detection.
D) Deploy a commercial cloud SIEM (Splunk Cloud, Sumo Logic) on AWS. Ingest all logs into the cloud SIEM. Use the SIEM's detection and response capabilities.

**Correct Answer: A**

**Explanation:** Amazon Security Lake is purpose-built for centralizing security data from multiple sources. It automatically collects logs from AWS services and normalizes them to the OCSF schema, enabling consistent cross-source analysis. Custom sources allow ingestion of on-premises logs (Windows events via Kinesis, firewall logs via Fluentd/Logstash). The OCSF normalization means analysts don't need to understand different log formats. Security Lake's subscriber mechanism allows multiple analytics tools to access the data, including third-party SIEMs for organizations that want to maintain SIEM capabilities alongside the data lake. This provides flexibility to use AWS-native analytics (Athena, QuickSight) or commercial tools. Option B's OpenSearch works but requires managing the cluster and building the normalization. Option C keeps the on-premises SIEM as a bottleneck. Option D adds significant licensing costs.

---

### Question 56
A company is migrating their compliance-related workloads from an on-premises environment to AWS. The workloads include: a GRC (Governance, Risk, and Compliance) platform, a vulnerability management system, a log management system, and a policy management system. The company wants to replace these with AWS-native equivalents.

A) Map tools to AWS equivalents: GRC platform → AWS Audit Manager (compliance assessment, evidence collection), Vulnerability management → Amazon Inspector (scanning) + Security Hub (aggregation), Log management → CloudTrail + CloudWatch Logs + Security Lake (centralization), Policy management → AWS Config (resource policies) + SCPs (preventive policies). Implement a phased migration: start with log management (CloudTrail/Config are prerequisites), then vulnerability management, then GRC, then policy management.
B) Deploy all four tools on EC2 instances. Lift-and-shift the existing software to AWS without changing the tools.
C) Replace everything with Security Hub. Security Hub provides GRC, vulnerability management, log management, and policy management in a single service.
D) Use AWS Marketplace to find cloud-native replacements for each tool. Deploy third-party tools that match the current capabilities.

**Correct Answer: A**

**Explanation:** Each on-premises tool maps to an AWS-native service designed for that function. Audit Manager replaces the GRC platform with automated evidence collection mapped to compliance frameworks. Inspector + Security Hub replaces vulnerability management with continuous scanning and centralized finding aggregation. CloudTrail + CloudWatch Logs + Security Lake replace log management with organization-wide, normalized log collection. Config + SCPs replace policy management with both detective (Config rules) and preventive (SCPs) controls. The phased migration order is logical: logs and Config are foundations needed by other tools. Option B doesn't modernize. Option C overestimates Security Hub's scope — it's an aggregator and compliance checker, not a full GRC or log management solution. Option D adds third-party costs and complexity.

---

### Question 57
A company is migrating their on-premises PKI (Public Key Infrastructure) to AWS. They currently manage their own root CA, intermediate CAs, and issue certificates for internal services, mutual TLS, and code signing. The migration must maintain the existing trust hierarchy and support both AWS and on-premises workloads during the transition.

A) Deploy AWS Private CA (formerly ACM Private CA). Import the existing root CA certificate to establish trust. Create subordinate CAs under the imported root for different certificate types (TLS, mTLS, code signing). Issue certificates from the AWS Private CA for AWS workloads. Maintain the on-premises CA for on-premises workloads during transition. Configure short-lived certificates with automatic renewal via ACM integration. Use cross-account RAM sharing for the Private CA to issue certificates across AWS accounts.
B) Use ACM (public) certificates for all internal services. ACM provides free, automatically renewed certificates. Replace mutual TLS with IAM-based authentication.
C) Deploy Microsoft AD CS (Certificate Services) on EC2. Mirror the on-premises PKI hierarchy. This is the most compatible migration path for Windows-based PKI.
D) Use Let's Encrypt for all certificate issuance. Deploy Certbot on EC2 instances for automatic renewal. Use Let's Encrypt certificates for mutual TLS.

**Correct Answer: A**

**Explanation:** AWS Private CA provides a managed PKI service that integrates with the existing trust hierarchy. By importing the existing root CA certificate (or creating a subordinate CA under it), the new AWS-issued certificates are trusted by all systems that trust the existing root — enabling seamless coexistence during migration. Separate subordinate CAs for different purposes (TLS, mTLS, code signing) maintain proper certificate lifecycle management. ACM integration provides automatic certificate renewal for AWS resources (ALB, CloudFront, API Gateway). RAM sharing enables cross-account certificate issuance from a centralized CA. Short-lived certificates reduce the risk of compromise. Option B's ACM public certificates can't be used for internal mTLS or code signing. Option C adds EC2 management overhead. Option D's Let's Encrypt doesn't support private PKI use cases.

---

### Question 58
A company has been using AWS Security Hub for 1 year and wants to improve their security maturity. Their current state is: reactive (responding to findings after they appear), manual (security team manually triages findings), and siloed (each team handles their own account's findings). They want to evolve to: proactive (preventing issues before they occur), automated (automated triage and remediation), and centralized (unified security operations).

A) Phase 1 (Proactive): Deploy SCPs and IAM permission boundaries to prevent common misconfigurations. Implement Service Catalog for approved architectures. Use CloudFormation Guard in CI/CD pipelines to validate templates. Phase 2 (Automated): Implement Security Hub automation rules for finding triage. Deploy EventBridge-triggered remediation for the top 20 finding types. Create escalation workflows via Step Functions. Phase 3 (Centralized): Designate a security operations team with a delegated administrator account. Build unified dashboards in QuickSight. Implement cross-account automated response.
B) Purchase a commercial CSPM tool that provides all three capabilities out of the box.
C) Hire more security engineers to handle the increased workload manually. Scale the team to match the finding volume.
D) Reduce the number of enabled Security Hub controls to only CRITICAL severity. This reduces finding volume, making manual management feasible.

**Correct Answer: A**

**Explanation:** Progressing security maturity requires a phased approach addressing each dimension. Proactive controls (SCPs, permission boundaries, Service Catalog, Guard rules) prevent misconfigurations from occurring — this is more effective than detecting and remediating after creation. Automated triage and remediation (Security Hub automation rules, EventBridge-triggered Lambda/SSM) handle the volume that manual processes can't. Centralized operations (delegated administrator, unified dashboards) provide organizational visibility and coordinated response. Each phase builds on the previous: proactive controls reduce finding volume, automation handles what remains efficiently, and centralization provides strategic visibility. Option B doesn't address the organizational and process changes needed. Option C doesn't scale cost-effectively. Option D reduces security visibility.

---

### Question 59
A company is migrating from a legacy RADIUS-based VPN authentication system to AWS. Their current VPN concentrators authenticate users against a RADIUS server backed by Active Directory. The company wants to maintain VPN access during migration while transitioning to AWS-native solutions.

A) Phase 1: Deploy AWS Client VPN with Active Directory authentication (using AWS Managed Microsoft AD or AD Connector). This maintains the AD-based authentication users are familiar with. Phase 2: Add certificate-based mutual authentication using AWS Private CA for enhanced security. Phase 3: Migrate to AWS Verified Access for application-level zero trust, eliminating VPN for most use cases. Maintain Client VPN only for network-level access needs (infrastructure management).
B) Deploy AWS Site-to-Site VPN to replace the VPN concentrators. Configure the VPN with pre-shared keys. Users connect through the on-premises VPN client.
C) Replace VPN with AWS Direct Connect for all remote access. Direct Connect provides private connectivity without VPN overhead.
D) Deploy Client VPN immediately with certificate-only authentication. Decommission the RADIUS server. Users install new certificates on their devices.

**Correct Answer: A**

**Explanation:** The phased approach minimizes user disruption. Phase 1 deploys AWS Client VPN with AD authentication — users authenticate with the same credentials they're familiar with, and AD Connector provides the bridge to on-premises AD. Phase 2 adds mTLS using Private CA certificates for stronger authentication (certificate + AD credentials). Phase 3 represents the modern approach: AWS Verified Access provides identity-aware, per-application access without VPN, supporting zero-trust principles. Most user access shifts to Verified Access, while Client VPN remains for infrastructure management that requires network-level access. Option B's Site-to-Site VPN is for site connectivity, not user authentication. Option C's Direct Connect is for site connectivity, not remote user access. Option D's abrupt certificate-only switch disrupts users with no transition period.

---

### Question 60
A company runs a compliance-sensitive workload that requires hardware-based MFA for all administrative access. Currently, they use physical YubiKeys for on-premises systems. They need to extend this requirement to AWS console and CLI access. The solution must work for 100 administrators across 50 accounts.

A) Configure IAM Identity Center as the authentication portal. Enable MFA in Identity Center with FIDO2 security keys (YubiKeys support FIDO2). Create an SCP that denies all actions unless aws:MultiFactorAuthPresent is true for administrative permission sets. For CLI access, use Identity Center's CLI integration (aws sso login) which inherits the MFA session. Administrators authenticate once with YubiKey via Identity Center and access all 50 accounts.
B) Assign hardware MFA devices to individual IAM users in each account. Each administrator manages their own MFA device per account. Enforce MFA via IAM policies.
C) Use virtual MFA (authenticator apps) instead of hardware MFA. Virtual MFA is easier to manage at scale and provides equivalent security for most use cases.
D) Implement a custom MFA gateway using API Gateway + Lambda that validates YubiKey OTP tokens before issuing temporary AWS credentials.

**Correct Answer: A**

**Explanation:** IAM Identity Center with FIDO2 security keys provides centralized hardware MFA management across all 50 accounts. YubiKeys support FIDO2/WebAuthn, which Identity Center natively supports as an MFA mechanism. Users authenticate once at the Identity Center portal with their YubiKey, then can access any assigned account without re-authenticating. The SCP requiring aws:MultiFactorAuthPresent ensures MFA is enforced at the organizational level — even if someone bypasses Identity Center. For CLI access, the aws sso login command opens a browser for FIDO2 authentication, then provides temporary credentials for CLI usage. This centralized approach is dramatically simpler than managing per-account MFA devices. Option B requires 100 administrators × 50 accounts = 5,000 MFA device assignments. Option C violates the hardware MFA requirement. Option D is unnecessarily complex.

---

### Question 61
A company has completed their cloud migration and needs to decommission their on-premises security tools. They need to ensure that every capability of their on-premises security stack is covered by AWS services before decommissioning. Current on-premises stack: Qualys (vulnerability scanning), Splunk (SIEM/log management), CrowdStrike (endpoint protection), Palo Alto (network firewall/IDS), and ServiceNow (security incident management).

A) Map each tool: Qualys → Amazon Inspector + AWS Config (vulnerability scanning + compliance), Splunk → Amazon Security Lake + Amazon OpenSearch (or keep Splunk Cloud as a subscriber to Security Lake), CrowdStrike → GuardDuty + Inspector (threat detection + vulnerability scanning; keep CrowdStrike on EC2 as endpoint agent), Palo Alto → AWS Network Firewall + WAF (network security), ServiceNow → Systems Manager Incident Manager (incident management). Validate each mapping with a parallel-run period before decommissioning on-premises tools.
B) Replace all on-premises tools with Security Hub alone. Security Hub provides vulnerability scanning, SIEM, endpoint protection, network security, and incident management in one service.
C) Keep all security tools but migrate them to run on EC2 in AWS. This is the simplest migration with no capability gaps.
D) Replace all tools with a single cloud-native CSPM platform (like Wiz or Orca). These platforms provide comprehensive cloud security without needing multiple tools.

**Correct Answer: A**

**Explanation:** Each on-premises tool maps to specific AWS services, but the mapping isn't always 1:1. Inspector replaces Qualys for vulnerability scanning on AWS resources. Security Lake provides centralized security data that Splunk Cloud (or OpenSearch) can consume as a subscriber — maintaining SIEM analytics capabilities. CrowdStrike's endpoint protection is complementary to GuardDuty; keeping CrowdStrike as an agent on EC2 instances maintains runtime protection that GuardDuty doesn't fully replace. Network Firewall + WAF replace Palo Alto for network security and IDS/IPS. Incident Manager replaces ServiceNow's security incident management with native AWS integration. The parallel-run period validates that no capabilities are lost before decommissioning. Option B vastly overestimates Security Hub's scope. Option C doesn't modernize. Option D's single-platform approach may have gaps in specific areas.

---

### Question 62
A company needs to migrate their on-premises data classification system to AWS. The current system manually classifies documents as Public, Internal, Confidential, and Restricted. The company wants to automate classification and enforce access controls based on classification levels across their AWS data stores (S3, RDS, DynamoDB, Redshift).

A) Deploy Amazon Macie for automated discovery and classification of sensitive data in S3. For structured data (RDS, DynamoDB, Redshift), use AWS Glue with sensitive data detection transforms. Implement a tagging strategy: all resources tagged with DataClassification=(Public|Internal|Confidential|Restricted). Use Lake Formation for fine-grained access control based on classification tags. Deploy SCPs and IAM policies with tag-based conditions restricting access to Confidential and Restricted data. Use Config rules to verify classification tags exist on all data resources.
B) Manually tag all S3 objects and database records with classification levels. Build custom Lambda functions to enforce access based on tags.
C) Use Amazon Comprehend to classify document content. Store classification results in a DynamoDB table. Build a custom access control layer using API Gateway.
D) Use AWS Glue Data Catalog as the metadata layer for classification. Add classification as a table property. Use Lake Formation permissions based on table properties.

**Correct Answer: A**

**Explanation:** Macie provides automated, ML-based data classification for S3, identifying PII, financial data, credentials, and other sensitive patterns that map to classification levels. For structured data in databases, Glue's sensitive data detection identifies sensitive columns (credit card numbers, SSNs, etc.) for classification. The tagging strategy creates a unified classification mechanism across all services — DataClassification tags enable IAM/SCP conditions for access control. Lake Formation enforces fine-grained access at the analytics layer. Config rules ensure classification tags are present, flagging unclassified resources for remediation. Option B's manual classification doesn't scale and is error-prone. Option C's Comprehend is for NLP text classification, not data sensitivity classification. Option D covers analytics databases only, missing S3 and direct database access.

---

## Domain 5: Design for Cost Optimization (Questions 63–75)

### Question 63
A company spends $50,000/month on AWS Config across 200 accounts. The cost breakdown is: configuration item recording $30,000, rule evaluations $15,000, and conformance packs $5,000. The company needs to reduce Config costs by 40% while maintaining compliance monitoring for critical resources and frameworks.

A) Switch to periodic recording mode for stable resource types (IAM policies, S3 bucket configurations, VPC configurations) that change infrequently — daily recording captures their state adequately. Maintain continuous recording only for frequently changing types (EC2 instances, security groups, Lambda functions). Remove individual Config rules that are duplicated in conformance packs. Remove conformance packs from sandbox/development accounts where only critical rules are needed. Use organization-level Config rules instead of account-level rules where possible to reduce rule count.
B) Disable Config in all accounts except production. Maintain conformance packs only in production.
C) Switch to AWS Security Hub only (disable Config). Security Hub provides compliance monitoring without the CI recording costs.
D) Reduce the number of resource types recorded to only the 10 most critical. Disable recording for all other types.

**Correct Answer: A**

**Explanation:** This optimizes each cost component without sacrificing critical compliance monitoring. Periodic recording for stable resources reduces CI recording costs by 40-60% for those types (recording once daily vs. on every change). Continuous recording for dynamic resources maintains real-time compliance monitoring. Rule deduplication (removing standalone rules covered by conformance packs) reduces evaluation costs. Removing conformance packs from non-compliance-sensitive accounts (sandbox, development) saves $5,000+ while maintaining critical rules individually. Organization-level rules evaluate from a central account, reducing per-account rule deployment. Option B eliminates non-production compliance monitoring. Option C's Security Hub requires Config for its underlying checks. Option D is too aggressive and may miss compliance-relevant resource types.

---

### Question 64
A company deploys GuardDuty across 200 accounts. Their monthly GuardDuty cost is $25,000 with the breakdown: CloudTrail analysis $5,000, VPC Flow Log analysis $8,000, DNS Log analysis $2,000, S3 protection $4,000, EKS protection $3,000, and malware protection $3,000. The company wants to reduce costs without significantly reducing threat detection capability.

A) Analyze GuardDuty finding history to determine which protection plans generate actionable findings. If EKS protection has generated zero findings (no EKS usage), disable it. If malware protection triggers only on development workloads, disable it for development accounts. Keep CloudTrail, VPC Flow, DNS, and S3 protection enabled across all accounts as they provide the broadest threat detection. Use GuardDuty usage statistics to identify accounts generating disproportionate costs (high VPC Flow Log volume) and optimize their network configurations to reduce traffic volume.
B) Disable GuardDuty in all non-production accounts. Threats in development don't matter.
C) Disable VPC Flow Log analysis (largest cost). The other analysis types provide sufficient detection. Monitor CloudTrail and DNS for threat indicators.
D) Disable all optional protection plans (S3, EKS, malware) and keep only the core CloudTrail, VPC Flow, and DNS analysis.

**Correct Answer: A**

**Explanation:** Data-driven optimization ensures cost reduction doesn't create security blind spots. Analyzing finding history reveals which protection plans are generating value. Disabling EKS protection in accounts without EKS workloads saves $3,000 with zero security impact. Limiting malware protection to production accounts focuses the spend where it matters. VPC Flow Log analysis costs often correlate with network chatty applications — optimizing these (reducing unnecessary cross-AZ traffic, consolidating connections) reduces both GuardDuty costs and data transfer costs. Maintaining core protections (CloudTrail, VPC Flow, DNS, S3) across all accounts preserves the broad detection baseline. Option B ignores threats in non-production that could spread to production. Option C disables the most valuable detection source. Option D removes valuable protection plans indiscriminately.

---

### Question 65
A company's Security Hub generates 100,000 findings per month. They pay for both Security Hub finding ingestion and the downstream processing (EventBridge rules, Lambda invocations, S3 storage for findings). The total monthly cost for the security monitoring pipeline is $8,000. The company wants to reduce this cost while maintaining effective security monitoring.

A) Implement Security Hub automation rules to automatically resolve findings that are duplicates, informational, or from known-acceptable configurations. This reduces the finding count that flows through EventBridge and downstream processing. Configure Security Hub to use organization-level management (delegated administrator) instead of per-account finding aggregation to reduce cross-account EventBridge traffic. Optimize Lambda functions for batch processing instead of per-finding invocation.
B) Disable less critical Security Hub standards (keep only FSBP). Fewer enabled controls means fewer findings generated.
C) Reduce Security Hub's evaluation frequency by disabling automatic control evaluations. Run evaluations manually on a weekly schedule.
D) Export Security Hub findings to S3 directly instead of using EventBridge. Batch process findings from S3 daily instead of real-time.

**Correct Answer: A**

**Explanation:** Automation rules at the Security Hub level reduce findings before they enter the processing pipeline. Auto-resolving duplicates, informational findings, and known-acceptable configurations can reduce the effective finding count by 50-70%. The delegated administrator model centralizes finding management, reducing cross-account EventBridge event volume. Batch processing in Lambda (processing multiple findings per invocation instead of one) reduces Lambda invocation costs. These optimizations maintain the same detection capability (all findings are still generated and evaluated) while reducing downstream processing costs. Option B reduces detection capability. Option C loses real-time monitoring. Option D's daily batch processing delays incident response.

---

### Question 66
A company runs AWS Audit Manager with 5 framework assessments (SOC 2, PCI DSS, HIPAA, ISO 27001, FedRAMP). The monthly Audit Manager cost is $5,000 primarily from evidence collection. The company wants to reduce costs while maintaining audit readiness.

A) Review which assessments are needed continuously vs. periodically. Run SOC 2 and PCI DSS continuously (these have ongoing audit requirements). Switch HIPAA, ISO 27001, and FedRAMP to periodic assessments — activate them 3 months before scheduled audits and deactivate after. This reduces evidence collection costs by 60% for those three frameworks.
B) Disable Audit Manager entirely. Manually collect evidence for audits using Config, CloudTrail, and Security Hub exports.
C) Consolidate all frameworks into a single custom framework that covers the common controls. Run only the unified assessment.
D) Reduce evidence collection frequency from continuous to weekly for all assessments.

**Correct Answer: A**

**Explanation:** Not all compliance frameworks require continuous evidence collection. SOC 2 Type II requires demonstrating control effectiveness over the audit period (typically 12 months), so continuous assessment is necessary. PCI DSS requires ongoing compliance monitoring. However, ISO 27001 and FedRAMP audits are typically scheduled events — evidence from the period leading up to the audit is sufficient. HIPAA compliance can be demonstrated with periodic assessment. Running assessments only when needed (3 months before audit provides sufficient evidence) reduces costs significantly. The 3-month window provides enough evidence history for auditors while saving 75% on those framework costs. Option B loses automated evidence collection. Option C's unified framework may not satisfy auditor requirements for framework-specific evidence. Option D's weekly collection may miss short-lived non-compliance events.

---

### Question 67
A company deploys Amazon Inspector across 200 accounts, scanning 10,000 EC2 instances, 5,000 ECR images, and 2,000 Lambda functions. Monthly Inspector cost is $15,000. The company wants to reduce costs without reducing vulnerability visibility.

A) Analyze Inspector scan patterns: if 80% of EC2 instances are built from 50 AMIs, focus scanning on the AMI build process (EC2 Image Builder with Inspector) and reduce runtime scanning frequency for instances running approved AMIs. For ECR, enable scanning only for images pushed in the last 30 days (older images should be rebuilt, not rescanned). For Lambda, scan only functions with recent code updates. Use Inspector suppression rules for known-acceptable vulnerabilities.
B) Disable Inspector for development and staging accounts. Scan only production instances.
C) Switch from continuous scanning to on-demand scanning. Run scans monthly instead of continuously.
D) Replace Inspector with open-source vulnerability scanners (Trivy, Grype) deployed on EC2. These tools are free for unlimited scanning.

**Correct Answer: A**

**Explanation:** Inspector costs are driven by the number of assessed resources. The key insight is that many EC2 instances share the same AMI — scanning each instance individually is redundant when vulnerabilities are AMI-level. Shifting to AMI-level scanning during the build process catches vulnerabilities before deployment, and runtime scanning at reduced frequency confirms no new vulnerabilities have emerged. ECR image scanning focus on recent images avoids paying to rescan stale images that should be rebuilt. Lambda function scanning on code update triggers avoids rescanning unchanged functions. Suppression rules for known-acceptable vulnerabilities reduce noise and unnecessary re-scanning. Option B creates blind spots in non-production. Option C misses vulnerabilities discovered between monthly scans. Option D requires managing open-source tool infrastructure.

---

### Question 68
A company's CloudTrail costs have grown to $20,000/month primarily due to S3 data events ($15,000) and Lambda data events ($3,000). The remaining $2,000 is management events. The company needs to reduce CloudTrail costs while maintaining security visibility.

A) Use CloudTrail advanced event selectors to filter data events. For S3: log only specific buckets containing sensitive data (not static website or CDN origin buckets). For Lambda: log only specific functions handling sensitive data. Exclude read-only events (GetObject) for high-volume buckets where only write/delete events matter. Use CloudTrail Lake with targeted event data stores instead of logging everything to S3.
B) Disable data events entirely. Management events provide sufficient security visibility.
C) Reduce CloudTrail retention in S3 from 7 years to 90 days. This reduces S3 storage costs.
D) Switch from CloudTrail to S3 server access logging for S3 data events. S3 access logs are free.

**Correct Answer: A**

**Explanation:** Advanced event selectors provide surgical control over data event logging. For S3, excluding high-volume, non-sensitive buckets (static websites, CDN origins, application asset buckets) dramatically reduces event volume. Excluding GetObject events for buckets where read access isn't security-relevant (log aggregation buckets, backup buckets) further reduces volume. For Lambda, targeting only sensitive functions (authentication, payment processing) versus utility functions (scheduled cleanups, health checks) focuses logging on security-relevant invocations. CloudTrail Lake with targeted event data stores can be more cost-effective than logging everything to S3 when you need queryability. Option B eliminates data event visibility entirely. Option C reduces storage but not the logging cost (which is the primary cost driver). Option D's S3 access logs lack IAM identity information and don't integrate with security tools.

---

### Question 69
A company operates a Security Operations Center that uses multiple AWS security services. Their monthly security tooling cost is: GuardDuty $15,000, Security Hub $5,000, Config $20,000, Inspector $8,000, Macie $10,000, and Detective $5,000. Total: $63,000/month. The CISO wants to reduce security costs by 30% without reducing the organization's security posture.

A) Optimize each service independently: GuardDuty — disable protection plans for non-existent workloads. Security Hub — reduce finding processing overhead with automation rules. Config — switch stable resources to periodic recording and deduplicate rules. Inspector — shift to AMI-level scanning. Macie — run discovery jobs monthly instead of weekly for non-critical buckets. Detective — evaluate if Detective's value justifies the cost; if the security team rarely uses it for investigations, disable it and use CloudTrail Lake for ad-hoc investigation.
B) Keep only GuardDuty and Config. Disable Security Hub, Inspector, Macie, and Detective. These services overlap significantly.
C) Negotiate volume discounts through AWS Enterprise Support for security services.
D) Replace all AWS security services with a third-party cloud security platform that provides unified capabilities at a lower total cost.

**Correct Answer: A**

**Explanation:** Systematic optimization of each service yields significant savings. Each optimization preserves the core detection/monitoring capability while eliminating waste. GuardDuty optimization: disabling unused protection plans saves $3-5K. Config optimization: periodic recording + rule deduplication saves $8-10K. Inspector shift to AMI scanning saves $4-5K. Macie frequency reduction saves $5-7K. Detective evaluation — if the security team relies on CloudTrail Lake for investigations (which they already pay for), Detective may be redundant, saving $5K. Total potential savings: $25-32K (40-50%), exceeding the 30% target. Each optimization has a clear rationale and maintains security functionality. Option B eliminates important capabilities (Inspector's vulnerability scanning, Macie's data classification). Option C may provide modest discounts but doesn't address waste. Option D introduces risk and migration effort.

---

### Question 70
A company uses AWS CloudTrail Lake for security investigations. Their Lake storage costs $3,000/month for 2 years of data. Most queries access data from the last 30 days, with occasional 7-year lookback for compliance investigations. The company wants to reduce Lake costs.

A) Create two CloudTrail Lake event data stores: one with 30-day retention for active investigation data (low cost) and one with 7-year retention for compliance data (using the one-year extendable pricing option). Configure the 30-day store as the default for queries. Use the 7-year store only for compliance investigations. This reduces costs because the shorter retention store has lower per-event storage costs.
B) Disable CloudTrail Lake. Use S3 with Athena for all CloudTrail queries. S3+Athena is cheaper for infrequent queries.
C) Reduce Lake retention to 90 days. Archive older data to S3 for compliance. Use Athena for historical queries.
D) Keep a single data store but reduce it to 1 year. Accept that 7-year lookback won't be queryable in Lake.

**Correct Answer: C**

**Explanation:** CloudTrail Lake's pricing is based on data ingestion and retention period. For data that's queried rarely (older than 90 days), storing in S3 with Glacier transition is dramatically cheaper. Athena queries on S3 data provide the same SQL capability for the occasional compliance investigation. The 90-day Lake retention covers 95% of investigation needs. For the 5% of queries needing older data, Athena on S3 (with partitioned Parquet files from the original CloudTrail logs) provides adequate performance. This approach reduces Lake costs by ~87% while maintaining all data accessibility. Option A's dual data store reduces costs but not as dramatically as moving historical data to S3. Option B loses the native CloudTrail Lake query optimization for recent data. Option D limits compliance capability.

---

### Question 71
A company has enabled Amazon Macie across 200 accounts to discover sensitive data. Macie's monthly cost is $12,000, primarily from automated sensitive data discovery running against 500 TB of S3 data. The discovery runs daily across all buckets. The company wants to reduce Macie costs while maintaining sensitive data visibility.

A) Configure Macie's automated discovery to run weekly instead of daily for most buckets. For buckets with high data ingestion rates, keep daily discovery. Exclude buckets that are known to never contain sensitive data (CloudTrail logs, VPC Flow Logs, application logs). Use Macie's bucket-level classification results to identify which buckets need frequent scanning vs. which can be scanned monthly.
B) Disable automated discovery. Run one-time classification jobs quarterly. This reduces continuous costs while still providing periodic visibility.
C) Reduce Macie to only 10 critical accounts. Disable in the remaining 190 accounts.
D) Use S3 Object Lock instead of Macie. If data can't be modified, there's no risk of sensitive data being added.

**Correct Answer: A**

**Explanation:** Macie's automated sensitive data discovery costs are proportional to the data sampled and frequency. Adjusting frequency based on data change rates optimizes costs: buckets receiving new data hourly benefit from daily discovery, while archival buckets can be scanned weekly or monthly. Excluding known non-sensitive buckets (logs, metrics data) eliminates unnecessary scanning of data that will never contain PII or sensitive information. Macie's bucket-level insights help identify which buckets warrant more frequent scanning based on the types of sensitive data discovered. This reduces scanning volume by 60-80% while maintaining discovery for buckets that actually contain or receive sensitive data. Option B loses continuous monitoring. Option C creates large blind spots. Option D misunderstands the problem — Macie discovers existing sensitive data, not just changes.

---

### Question 72
A company needs to comply with multiple security frameworks, each requiring dedicated AWS security services. They're concerned about the total cost of running Security Hub, Config, GuardDuty, Inspector, Macie, Audit Manager, and Detective across 200 accounts. The estimated total is $100,000/month. They want to determine the minimum set of services needed for their compliance requirements (SOC 2 and HIPAA).

A) Core required services: Config (resource compliance - required by both SOC 2 and HIPAA), CloudTrail (audit logging - required by both), GuardDuty (threat detection - required by both for continuous monitoring), and Security Hub (compliance dashboards and finding aggregation). Recommended but optional: Inspector (vulnerability management - strengthens compliance posture), Macie (data classification - particularly important for HIPAA PHI discovery). Situational: Audit Manager (required only during audit preparation periods, not continuously), Detective (only if the security team conducts investigations, otherwise CloudTrail Lake suffices). Deploy core services across all accounts, recommended services in production only, and situational services as needed.
B) All services are required for both SOC 2 and HIPAA. No optimization is possible without risking compliance.
C) Only Config and CloudTrail are required. All other services are nice-to-have.
D) Use Audit Manager as the single compliance tool. It collects evidence from other services, but you don't need to enable them all — Audit Manager has built-in checks.

**Correct Answer: A**

**Explanation:** Understanding which services are actually required vs. recommended is key to cost optimization. Config provides the resource-level compliance checks required by both frameworks. CloudTrail provides the audit logging that every compliance framework requires. GuardDuty provides the continuous threat monitoring required for SOC 2 (Monitoring CC7.1) and HIPAA (§164.312(b)). Security Hub aggregates findings and provides compliance dashboards. Inspector strengthens the posture but isn't strictly required if OS patching is handled through SSM. Macie is particularly valuable for HIPAA (discovering PHI locations) but can be scoped to critical accounts. Audit Manager can run periodically during audit preparation rather than continuously. Detective is optional if CloudTrail Lake provides sufficient investigation capability. This tiered approach can reduce costs by 40-50%. Option B accepts unnecessary costs. Option C misses required monitoring capabilities. Option D's Audit Manager doesn't perform security monitoring.

---

### Question 73
A company has Config rules that check EBS encryption across 200 accounts. Each account has an average of 500 EBS volumes. The Config rule evaluates each volume whenever its configuration changes. Monthly Config costs for this single rule: 200 accounts × 500 volumes × ~10 changes/month = 1,000,000 evaluations × $0.001 = $1,000/month just for this one rule. The company has 100 such rules, costing $100,000/month in rule evaluations alone.

A) Convert high-frequency evaluation rules from change-triggered to periodic (every 24 hours). For EBS encryption, a daily check is sufficient since encryption status rarely changes. This reduces evaluations from ~1,000,000 to 200 accounts × 500 volumes = 100,000 per evaluation cycle, run once daily = 100,000 evaluations/month vs. 1,000,000. Apply this to all rules where daily evaluation suffices.
B) Use organization-level Config rules instead of account-level rules. Organization rules evaluate centrally, reducing the per-account evaluation count.
C) Disable Config rules and rely on SCPs to prevent non-compliant resource creation. No evaluation costs with preventive-only controls.
D) Move to custom Config rules with Lambda that batch-evaluate multiple resources per invocation. This reduces the per-resource evaluation charge.

**Correct Answer: A**

**Explanation:** Switching from change-triggered to periodic evaluation dramatically reduces evaluation count for stable configurations. EBS encryption status doesn't change frequently — once a volume is encrypted (or not), it stays that way until deleted. Daily periodic evaluation captures any changes within 24 hours (acceptable for compliance monitoring) at 1/10th the evaluation cost. Applied across 100 rules, this reduces monthly evaluation costs from $100,000 to approximately $10,000-$20,000. The key insight is that not every configuration change needs immediate compliance evaluation — for stable attributes like encryption status, daily checks are adequate. Option B's organization rules still evaluate each resource. Option C's SCPs don't cover existing resources. Option D's Lambda batching doesn't change the per-evaluation pricing.

---

### Question 74
A company runs Amazon Detective for security investigations across 100 accounts. The monthly cost is $8,000, primarily from VPC Flow Log data ingestion (the largest data source). The security team uses Detective approximately twice per month for incident investigations. The company questions whether this cost is justified.

A) Evaluate Detective's usage vs. alternative investigation tools. If the team uses Detective only twice/month, consider disabling it and using CloudTrail Lake for CloudTrail-based investigations and Athena for VPC Flow Log analysis (data already stored in S3). The investigation capability is maintained through Athena queries, saving $8,000/month. Re-enable Detective only if a major incident requires its visual analysis capabilities.
B) Keep Detective enabled. The cost is justified for the two investigations per month — proactive security investment.
C) Reduce Detective to 50 accounts (production only). This halves the cost while maintaining coverage for the most critical accounts.
D) Use Amazon Managed Grafana to build custom security dashboards as a Detective replacement. Grafana can visualize CloudTrail and VPC Flow Log data.

**Correct Answer: A**

**Explanation:** At $8,000/month for twice-monthly usage, the cost-per-investigation is $4,000. The key question is whether Detective provides unique value that Athena+CloudTrail Lake can't. Detective's main advantage is visual entity relationship graphs (showing connections between users, IP addresses, and resources during an investigation). If the security team can conduct equivalent investigations using SQL queries in CloudTrail Lake and Athena on VPC Flow Logs (which they already have access to), Detective provides marginal benefit at significant cost. The data sources (CloudTrail, VPC Flow Logs) are already collected by other services. Detective can be re-enabled quickly if a complex investigation requires its visual capabilities. Option B doesn't challenge the cost-benefit. Option C still pays $4,000 for twice-monthly usage. Option D adds Grafana setup complexity.

---

### Question 75
A company has established a comprehensive security monitoring infrastructure on AWS but wants to benchmark their security spending against industry standards. Their security tooling costs represent 8% of their total AWS bill ($100,000/month security on $1.25M/month total). The CISO wants to know if this ratio is appropriate and how to optimize it.

A) The 8% ratio is reasonable for a regulated industry (typical range is 5-12%). Optimize by: reviewing each security service's ROI (findings generated vs. cost), right-sizing services based on the optimizations discussed (periodic recording in Config, targeted data events in CloudTrail, AMI-level scanning in Inspector), consolidating tools where capabilities overlap, and implementing a security cost dashboard in QuickSight that tracks security spending by service, per finding detected, and per account. This enables continuous optimization based on security-cost metrics.
B) 8% is too high. Industry standard is 2-3%. Reduce security tooling to essential services only (Config, CloudTrail, GuardDuty).
C) 8% is too low. Increase security spending to 15% by enabling all protection plans, maximum scanning frequency, and adding third-party security tools.
D) The percentage doesn't matter. Security spending should be based on risk assessment, not percentage of cloud spend.

**Correct Answer: A**

**Explanation:** For regulated industries (financial services, healthcare, government), security spending of 5-12% of cloud costs is typical. The 8% ratio falls within this range. However, the absolute cost can still be optimized through the techniques discussed throughout this test: targeted Config recording, selective CloudTrail data events, AMI-level Inspector scanning, frequency-optimized Macie discovery, and usage-based Detective evaluation. The security cost dashboard enables data-driven optimization: tracking cost-per-finding by service reveals which services provide the best security value. Services with high cost and low findings may need reconfiguration or replacement. Services with low cost and high actionable findings deserve continued investment. Option B's 2-3% is too low for regulated industries. Option C's 15% may be excessive without evidence. Option D is partially correct — risk assessment drives security strategy, but cost efficiency still matters within that strategy.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | A | 16 | A | 31 | A | 46 | A | 61 | A |
| 2 | A | 17 | A | 32 | A | 47 | A | 62 | A |
| 3 | A | 18 | A | 33 | A | 48 | B | 63 | A |
| 4 | A | 19 | A | 34 | D | 49 | A | 64 | A |
| 5 | A | 20 | D | 35 | A | 50 | A | 65 | A |
| 6 | A | 21 | A | 36 | A | 51 | A | 66 | A |
| 7 | A | 22 | A | 37 | A | 52 | A | 67 | A |
| 8 | A | 23 | A | 38 | A | 53 | A | 68 | A |
| 9 | D | 24 | A | 39 | A | 54 | A | 69 | A |
| 10 | A | 25 | A | 40 | A | 55 | A | 70 | C |
| 11 | A | 26 | A | 41 | A | 56 | A | 71 | A |
| 12 | D | 27 | A | 42 | A | 57 | A | 72 | A |
| 13 | A | 28 | A | 43 | A | 58 | A | 73 | A |
| 14 | A | 29 | A | 44 | A | 59 | A | 74 | A |
| 15 | A | 30 | A | 45 | A | 60 | A | 75 | A |
