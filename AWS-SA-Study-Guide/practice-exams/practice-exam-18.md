# Practice Exam 18 - AWS Solutions Architect Associate (SAA-C03)

## Compliance & Security Focus

**Time Limit:** 130 minutes
**Passing Score:** 720/1000
**Total Questions:** 65

- Mix of multiple choice (single correct) and multiple response (select TWO or THREE)
- Questions drawn from healthcare, finance, and government sector scenarios

---

### Question 1
A large hospital network is migrating its electronic health records (EHR) system to AWS. The system stores protected health information (PHI) that must comply with HIPAA regulations. The security team requires that all data be encrypted at rest using keys that the hospital controls and can audit. They also need the ability to immediately revoke access to encryption keys if a breach is detected. The solution must minimize operational overhead while meeting these requirements.

Which approach should the solutions architect recommend?

A) Use Amazon S3 with SSE-S3 encryption and enable S3 Object Lock to prevent unauthorized access to the data.
B) Use Amazon S3 with SSE-KMS encryption using customer managed keys (CMKs) and configure key policies that restrict usage to specific IAM roles.
C) Use Amazon S3 with SSE-C encryption and store the encryption keys in an on-premises hardware security module (HSM).
D) Use Amazon S3 with SSE-S3 encryption and configure S3 bucket policies to deny unencrypted uploads.

---

### Question 2
A financial services company processes credit card transactions and must maintain PCI DSS Level 1 compliance. The company is designing a new payment processing application on AWS. Cardholder data must be isolated from all other workloads, and network traffic must be inspectable. The company wants to use managed services wherever possible while maintaining strict network segmentation.

Which architecture meets these requirements?

A) Deploy the payment processing application in a dedicated VPC with no internet gateway. Use VPC peering to connect to other VPCs. Enable VPC Flow Logs and send them to Amazon CloudWatch Logs.
B) Deploy the payment processing application in a dedicated AWS account within AWS Organizations. Use AWS Transit Gateway with separate route tables for the cardholder data environment. Deploy AWS Network Firewall for traffic inspection.
C) Deploy the payment processing application in a public subnet with a network ACL that blocks all inbound traffic except HTTPS. Use AWS Shield Advanced for DDoS protection.
D) Deploy the payment processing application in the same VPC as other workloads but in an isolated subnet. Use security groups to restrict access to the payment processing instances only.

---

### Question 3
A European healthcare provider must store patient records in AWS while complying with GDPR. The system must support the right to erasure (the ability to permanently delete a specific patient's data upon request). Patient data is stored across Amazon S3, Amazon DynamoDB, and Amazon Aurora. The company needs to fulfill erasure requests within 30 days.

Which combination of steps should the solutions architect recommend? **(Select TWO.)**

A) Use Amazon S3 Object Lock in Governance mode for all patient data to ensure data integrity before deletion.
B) Implement a data catalog using AWS Glue that tracks which S3 objects, DynamoDB items, and Aurora records are associated with each patient, then build an automated deletion workflow using AWS Step Functions.
C) Enable Amazon S3 Versioning and create lifecycle policies that automatically delete all versions of patient objects after 30 days.
D) Assign a unique patient identifier across all storage services and build an AWS Lambda function triggered by an API Gateway endpoint that orchestrates deletion across S3, DynamoDB, and Aurora upon receiving an erasure request.
E) Use Amazon Macie to automatically identify and delete all personally identifiable information across the storage services.

---

### Question 4
A government agency is deploying a classified workload on AWS that requires FedRAMP High authorization. The workload processes sensitive but unclassified (SBU) data. The agency requires that all resources run in data centers physically located within the United States, and that only U.S. persons operate the infrastructure.

Which solution meets these requirements?

A) Deploy the workload in the us-east-1 Region and use AWS IAM Identity Center to restrict access to U.S.-based employees only.
B) Deploy the workload in AWS GovCloud (US) Regions and ensure all IAM users are U.S. persons with appropriate clearances.
C) Deploy the workload in any U.S.-based AWS Region and enable AWS CloudTrail to log all access from non-U.S. IP addresses.
D) Deploy the workload in a dedicated AWS Outposts rack physically located in the agency's data center and connect it to the nearest U.S. Region.

---

### Question 5
A multinational bank is implementing a SOC 2 Type II compliant logging architecture on AWS. The bank needs to ensure that all API calls across all AWS accounts are logged, that logs cannot be tampered with, and that logs are retained for seven years. The architecture must support centralized querying of logs for audit purposes.

Which solution meets all of these requirements?

A) Enable AWS CloudTrail in each account with log file validation enabled. Deliver logs to a centralized S3 bucket in a dedicated logging account with S3 Object Lock in Compliance mode. Use Amazon Athena for querying.
B) Enable AWS CloudTrail in each account and deliver logs to individual S3 buckets in each account. Enable S3 versioning on each bucket. Use Amazon OpenSearch Service for centralized log analysis.
C) Enable AWS CloudTrail with an organization trail and deliver logs to a centralized S3 bucket. Enable S3 MFA Delete on the bucket. Use Amazon Redshift Spectrum for querying.
D) Enable VPC Flow Logs in each account and deliver them to a centralized Amazon Kinesis Data Firehose stream. Store the logs in Amazon S3 with a 7-year lifecycle policy.

---

### Question 6
A healthcare technology startup is building a telemedicine platform on AWS. The platform processes video consultations and stores patient records. The company must comply with HIPAA and needs to sign a Business Associate Agreement (BAA) with AWS. The development team wants to use serverless services to minimize operational overhead.

Which set of AWS services can the company use under the AWS BAA for this workload? **(Select THREE.)**

A) Amazon API Gateway, AWS Lambda, and Amazon DynamoDB
B) Amazon WorkMail for patient email communications
C) Amazon Transcribe Medical for transcribing consultation recordings
D) Amazon Lightsail for hosting the web application
E) AWS Step Functions for orchestrating the consultation workflow
F) Amazon GameLift for real-time video streaming

---

### Question 7
A financial institution uses multiple AWS accounts managed through AWS Organizations. The security team needs to continuously assess the compliance posture across all accounts, automatically detect non-compliant resources, and aggregate findings in a central dashboard. The solution must check for CIS AWS Foundations Benchmark compliance.

Which solution requires the LEAST operational effort?

A) Deploy AWS Config rules in each account that align with CIS benchmarks. Use AWS Config aggregator in a centralized account to collect compliance data. Build a custom dashboard using Amazon QuickSight.
B) Enable AWS Security Hub in all accounts with the CIS AWS Foundations Benchmark standard enabled. Designate a delegated administrator account to aggregate findings from all member accounts.
C) Deploy Amazon Inspector in all accounts and configure custom assessment templates that match CIS benchmark controls. Aggregate results in a centralized S3 bucket.
D) Write custom AWS Lambda functions in each account that check CIS benchmark controls on a scheduled basis. Send results to a centralized Amazon DynamoDB table and visualize with Amazon Managed Grafana.

---

### Question 8
A hospital network runs a patient appointment scheduling system on Amazon EC2 instances behind an Application Load Balancer. The system must be highly available across multiple Availability Zones and must recover from the failure of an entire AWS Region within 15 minutes. Patient appointment data is stored in Amazon Aurora MySQL. The RPO must be less than 1 minute.

Which disaster recovery architecture meets these requirements?

A) Deploy the application in two Availability Zones in a single Region. Use Aurora Multi-AZ deployment. Configure Auto Scaling for EC2 instances with a minimum of two instances per AZ.
B) Deploy the application in two AWS Regions. Use Aurora Global Database with a secondary Region. Use Amazon Route 53 health checks with failover routing. Deploy EC2 instances in both Regions using Auto Scaling groups.
C) Deploy the application in two AWS Regions. Use Aurora read replicas in the secondary Region with cross-Region replication. Use AWS Global Accelerator for traffic routing. Deploy EC2 instances only in the primary Region.
D) Deploy the application in a single Region with Aurora Multi-AZ. Take automated Aurora snapshots every minute and copy them to a secondary Region using AWS Lambda. Use Route 53 latency-based routing.

---

### Question 9
A government contractor needs to encrypt data at rest across multiple AWS services including Amazon S3, Amazon EBS, Amazon RDS, and Amazon Redshift. The contractor must use FIPS 140-2 Level 3 validated hardware security modules to store and manage encryption keys. The keys must never exist in plaintext outside the HSMs.

Which solution meets these requirements?

A) Use AWS KMS with the default AWS managed keys, which use FIPS 140-2 Level 2 validated HSMs.
B) Use AWS CloudHSM to create a custom key store, then create AWS KMS customer managed keys (CMKs) that are backed by the CloudHSM cluster. Use these CMKs with each AWS service.
C) Use AWS KMS with customer managed keys and import key material generated from an on-premises FIPS 140-2 Level 3 HSM.
D) Use client-side encryption with keys stored in AWS Secrets Manager, which uses FIPS 140-2 Level 3 validated HSMs internally.

---

### Question 10
A pharmaceutical company is building a clinical trials data platform on AWS. The data contains sensitive patient information subject to both HIPAA and GDPR. The company needs to share de-identified datasets with research partners while ensuring the original data remains protected. The solution must automatically detect and redact personally identifiable information (PII) before data is shared.

Which architecture should the solutions architect recommend?

A) Store raw data in an Amazon S3 bucket with SSE-KMS encryption. Use Amazon Macie to scan for PII. Use Amazon Comprehend Medical to detect and redact PII. Store de-identified data in a separate S3 bucket accessible to research partners via pre-signed URLs.
B) Store raw data in an Amazon S3 bucket. Use AWS Glue DataBrew to create PII detection and redaction recipes. Output de-identified data to a separate S3 bucket. Share access via S3 Access Points with specific policies for each research partner.
C) Store raw data in Amazon Redshift. Use SQL-based masking functions to create views that redact PII columns. Grant research partners access only to the masked views.
D) Store raw data in Amazon DynamoDB. Use DynamoDB Streams with an AWS Lambda function to create de-identified copies in a separate DynamoDB table. Share access using IAM cross-account roles.

---

### Question 11
A regional bank is implementing an incident response automation pipeline. When Amazon GuardDuty detects a high-severity finding (such as unauthorized API calls from a compromised EC2 instance), the system must automatically isolate the compromised instance, capture forensic evidence, and notify the security team. The entire process must complete within 5 minutes.

Which architecture achieves this?

A) Configure GuardDuty to send findings to Amazon SNS. Create an SNS subscription that triggers an AWS Lambda function. The Lambda function modifies the instance's security group to deny all traffic, creates an EBS snapshot, and sends a notification to the security team via a separate SNS topic.
B) Configure GuardDuty to publish findings to Amazon EventBridge. Create an EventBridge rule that triggers an AWS Step Functions state machine. The state machine runs parallel Lambda functions to: replace the instance's security group with an isolation group, create EBS snapshots, capture instance metadata, and publish to an SNS topic for the security team.
C) Configure GuardDuty to write findings to an S3 bucket. Use S3 Event Notifications to trigger an AWS Lambda function that modifies the instance's network ACL, creates an AMI, and sends an email through Amazon SES to the security team.
D) Configure Amazon CloudWatch Alarms on GuardDuty metrics. When a high-severity alarm fires, trigger an AWS Systems Manager Automation runbook that isolates the instance and emails the security team using Amazon WorkMail.

---

### Question 12
A healthcare insurance company must maintain audit logs for all access to claims processing data stored in Amazon S3. The auditors require proof that log files have not been modified since creation. The logs must be stored in a way that no user, including root account users, can delete them for 3 years.

Which configuration satisfies these requirements?

A) Enable S3 server access logging. Store the logs in a separate S3 bucket with S3 Versioning and MFA Delete enabled. Apply an S3 bucket policy that denies all delete actions.
B) Enable AWS CloudTrail data events for the S3 bucket. Enable CloudTrail log file validation. Deliver logs to an S3 bucket with S3 Object Lock in Compliance mode with a 3-year retention period.
C) Enable S3 server access logging. Store logs in Amazon S3 Glacier Deep Archive with a vault lock policy that enforces a 3-year retention period.
D) Enable AWS CloudTrail data events for the S3 bucket. Deliver logs to Amazon CloudWatch Logs with a 3-year retention setting. Configure a CloudWatch Logs resource policy that denies delete actions.

---

### Question 13
A fintech company is designing a multi-account AWS architecture for a new payment processing platform. The company has separate accounts for development, staging, production, and security. The security account must be the only account allowed to manage encryption keys, and the production account must be the only account that can access production databases. Cross-account access must be tightly controlled.

Which combination of steps should the solutions architect implement? **(Select TWO.)**

A) Create AWS KMS customer managed keys in the security account. Configure key policies that grant the production account permission to use the keys for encrypt and decrypt operations. Use AWS KMS grants for temporary access.
B) Create AWS KMS customer managed keys in each account independently. Use AWS Organizations SCPs to restrict key management to the security account's IAM roles.
C) Use AWS Resource Access Manager (RAM) to share the production database subnets with the security account so security tools can scan databases directly.
D) Create cross-account IAM roles in the production account that can be assumed only by specific roles in other accounts. Use SCPs to prevent the development account from assuming any roles in the production account.
E) Deploy all encryption keys using AWS Secrets Manager in the security account and share secrets across accounts using resource-based policies.

---

### Question 14
A large hospital system is deploying a new radiology image storage platform on AWS. The DICOM images must be stored durably with immediate retrieval capability for the first 90 days. After 90 days, images must still be accessible within 12 hours for legal or clinical review. All data must be encrypted, and the system must retain images for a minimum of 10 years to meet regulatory requirements. The hospital wants to minimize storage costs.

Which storage solution meets these requirements?

A) Store images in Amazon S3 Standard. Create a lifecycle policy that transitions objects to S3 Glacier Flexible Retrieval after 90 days. Enable SSE-KMS encryption. Configure S3 Object Lock in Compliance mode with a 10-year retention period.
B) Store images in Amazon S3 Standard-Infrequent Access. Create a lifecycle policy that transitions objects to S3 Glacier Deep Archive after 90 days. Enable SSE-S3 encryption. Use a bucket policy to deny deletion.
C) Store images in Amazon EFS with encryption enabled. After 90 days, use a scheduled Lambda function to move images to Amazon S3 Glacier Flexible Retrieval. Set a vault lock policy for 10-year retention.
D) Store images in Amazon S3 Standard. Create a lifecycle policy that transitions objects to S3 Intelligent-Tiering after 90 days. Enable SSE-KMS encryption. Use S3 Versioning with MFA Delete.

---

### Question 15
A government agency requires all communication between microservices in their VPC to be encrypted in transit using TLS 1.2 or higher. The microservices are deployed as Amazon ECS tasks running on AWS Fargate. The agency also requires mutual TLS (mTLS) authentication between services. The solution must minimize certificate management overhead.

Which approach should the solutions architect recommend?

A) Deploy an Application Load Balancer for each service with AWS Certificate Manager (ACM) certificates. Configure the ALB to terminate TLS and forward traffic to ECS tasks over HTTP.
B) Use AWS App Mesh with Envoy sidecar proxies. Enable mTLS in App Mesh using certificates managed by AWS Private Certificate Authority (AWS Private CA). Configure the Envoy proxies to handle TLS termination and mutual authentication.
C) Deploy self-signed certificates in each ECS task container. Store certificates in AWS Secrets Manager and rotate them manually every 90 days. Configure each service to validate the peer certificate.
D) Use a Network Load Balancer with TLS passthrough. Store TLS certificates in AWS Certificate Manager and attach them to the NLB target groups. Configure each ECS task to present its own certificate.

---

### Question 16
A multinational insurance company uses Amazon S3 to store customer policy documents. Due to GDPR, data for European customers must remain in the eu-west-1 Region, while data for U.S. customers must stay in us-east-1. The application must be able to write documents to the correct bucket based on customer location. The company also needs a unified view of all documents for global reporting.

Which architecture meets these requirements?

A) Create S3 buckets in both Regions. Use S3 Cross-Region Replication to copy all objects to a central reporting bucket in us-east-1. Use application logic to route writes to the correct regional bucket.
B) Create S3 buckets in both Regions. Use application logic to route writes based on customer location. Create an S3 Multi-Region Access Point for unified read access. Enable S3 Replication rules that replicate only metadata (not data) to a central catalog in Amazon DynamoDB global tables.
C) Create a single S3 bucket in us-east-1 with S3 Object Tags indicating the data residency Region. Use S3 Intelligent-Tiering to manage storage costs across Regions.
D) Create S3 buckets in both Regions. Use application logic to route writes. For global reporting, use Amazon Athena with federated queries against both regional buckets without replicating data across Regions.

---

### Question 17
A credit union is migrating its core banking application to AWS. The application uses Microsoft SQL Server and must be PCI DSS compliant. The database must support automatic failover with a recovery time of less than 60 seconds. The credit union wants to avoid managing database patching and backups.

Which database solution meets these requirements?

A) Deploy Microsoft SQL Server on Amazon EC2 instances in a Windows Server Failover Cluster (WSFC) across two Availability Zones. Use Amazon EBS Multi-Attach for shared storage.
B) Use Amazon RDS for SQL Server with a Multi-AZ deployment. Enable automated backups with encryption using AWS KMS customer managed keys.
C) Deploy Microsoft SQL Server on Amazon EC2 with SQL Server Always On Availability Groups across three Availability Zones. Use Amazon FSx for Windows File Server as a witness.
D) Use Amazon Aurora PostgreSQL with the Babelfish compatibility layer for SQL Server. Enable Multi-AZ with Aurora Replicas.

---

### Question 18
A health insurance company needs to classify and protect sensitive data across hundreds of Amazon S3 buckets containing claims data, medical records, and internal documents. The security team wants to automatically discover buckets that contain PHI or PII and generate alerts when sensitive data is found in buckets that are not properly configured with encryption or access controls.

Which solution meets these requirements with the LEAST operational effort?

A) Write AWS Lambda functions that use Amazon Textract to scan S3 objects for PII patterns. Schedule the functions with Amazon EventBridge. Store findings in Amazon DynamoDB.
B) Enable Amazon Macie and create a classification job that scans all S3 buckets. Configure Macie to publish findings to AWS Security Hub. Create EventBridge rules to alert the security team when sensitive data is found in improperly configured buckets.
C) Use AWS Config rules to check S3 bucket encryption and access configurations. Deploy Amazon Comprehend to analyze document contents for PII. Combine results in a custom dashboard.
D) Enable Amazon GuardDuty S3 protection to monitor data access patterns. Use S3 Inventory reports to track encryption status. Manually review buckets flagged by GuardDuty.

---

### Question 19
A federal agency needs to deploy a web application on AWS that meets FedRAMP Moderate requirements. The application serves internal employees only and must not be accessible from the public internet. Employees access the application from their office network, which is connected to AWS via AWS Direct Connect.

Which architecture meets these requirements?

A) Deploy the application on Amazon EC2 instances in a private subnet. Place an Application Load Balancer in a private subnet. Configure Route 53 private hosted zones for DNS resolution. Use Direct Connect with a private virtual interface to connect the office network to the VPC.
B) Deploy the application on Amazon EC2 instances in a public subnet with an internet-facing Application Load Balancer. Use security groups to restrict access to the office's public IP range. Enable AWS WAF on the ALB.
C) Deploy the application using AWS Amplify with custom domain mapping. Use Amazon CloudFront with a geographic restriction policy to allow only U.S.-based access.
D) Deploy the application on Amazon EC2 instances in a private subnet. Use AWS Client VPN for employee access. Configure an internet-facing Network Load Balancer for health checks.

---

### Question 20
A healthcare analytics firm processes large volumes of de-identified patient data from multiple hospital clients. Each hospital's data must be logically isolated from other hospitals' data, even though it resides in the same AWS account. Data scientists from each hospital should only be able to query their own hospital's data using Amazon Athena.

Which approach provides the required data isolation with the LEAST management overhead?

A) Create separate S3 buckets for each hospital. Create individual IAM policies for each hospital's data scientists that restrict access to their specific bucket. Create separate Athena workgroups for each hospital.
B) Store all data in a single S3 bucket with prefixes for each hospital. Use AWS Lake Formation to register the S3 data locations and create a data catalog. Define fine-grained access permissions in Lake Formation for each hospital, using tag-based access control.
C) Deploy separate AWS accounts for each hospital using AWS Organizations. Use AWS RAM to share common analytics resources. Create separate Athena configurations in each account.
D) Store all data in Amazon Redshift with row-level security policies. Create database users for each hospital's data scientists and restrict access at the row level.

---

### Question 21
A payment processing company discovered that several Amazon EC2 instances in its cardholder data environment (CDE) are running outdated software with known vulnerabilities. The company must implement an automated vulnerability management process that continuously scans instances, identifies vulnerabilities, and applies patches within 48 hours as required by PCI DSS.

Which combination of AWS services meets these requirements? **(Select TWO.)**

A) Use Amazon Inspector to continuously scan EC2 instances for software vulnerabilities. Configure Inspector to publish findings to AWS Security Hub.
B) Use AWS Trusted Advisor to check for security vulnerabilities on EC2 instances. Configure Trusted Advisor to send email notifications when vulnerabilities are found.
C) Use AWS Systems Manager Patch Manager to define patch baselines and maintenance windows. Configure automatic patching for critical and high vulnerabilities within the required timeframe.
D) Use AWS Config rules to verify that EC2 instances are running the latest AMI version. Automatically terminate and replace non-compliant instances.
E) Use Amazon GuardDuty to detect software vulnerabilities on EC2 instances and auto-remediate by triggering Lambda functions.

---

### Question 22
A hospital is deploying a new Electronic Medical Records (EMR) system on AWS. The system must support both HIPAA and HITRUST CSF compliance. The security team requires that the AWS environment be continuously monitored for configuration drift from the compliance baseline. When drift is detected, the system must automatically remediate the misconfiguration.

Which architecture provides automated compliance monitoring and remediation?

A) Enable AWS Config with conformance packs for HIPAA. Create AWS Config rules for each compliance control. Use AWS Config auto-remediation with AWS Systems Manager Automation documents to automatically fix non-compliant resources.
B) Deploy AWS Security Hub with the HIPAA standard enabled. Create custom Lambda functions that poll Security Hub findings every hour and remediate non-compliant resources.
C) Use AWS Audit Manager to create a HITRUST assessment. Configure Audit Manager to automatically remediate findings using AWS CloudFormation drift detection.
D) Deploy Amazon Inspector to continuously assess the environment against HIPAA benchmarks. Use Inspector findings to trigger AWS CodePipeline to redeploy compliant infrastructure.

---

### Question 23
A financial services company needs to securely transfer large datasets (up to 500 TB) from an on-premises data center to Amazon S3. The data includes financial records subject to SEC regulations and must be encrypted during transfer and at rest. The company has a 1 Gbps Direct Connect connection, but the migration must complete within 2 weeks.

Which migration approach is MOST appropriate?

A) Use AWS DataSync over the Direct Connect connection to transfer data to S3 with encryption in transit. Enable SSE-KMS on the destination S3 bucket.
B) Order multiple AWS Snowball Edge Storage Optimized devices. Enable encryption on each device using KMS keys. Ship the devices to AWS for ingestion into S3 with SSE-KMS.
C) Use the AWS CLI to perform multi-part uploads over the Direct Connect connection. Enable SSE-S3 encryption on the destination bucket.
D) Set up S3 Transfer Acceleration and transfer data over the public internet using HTTPS. Enable SSE-KMS on the destination S3 bucket.

---

### Question 24
A government health department runs a disease surveillance application that collects real-time data from hospitals and clinics. The application must be available 99.99% of the time and must process incoming data within 2 seconds. Data must be encrypted at all stages. The department wants a serverless architecture to minimize operational overhead.

Which architecture meets these requirements?

A) Use Amazon API Gateway with AWS Lambda to ingest data. Store raw data in Amazon Kinesis Data Streams. Process data with a second Lambda function that reads from Kinesis. Store results in Amazon DynamoDB with encryption enabled. Use DynamoDB global tables for multi-Region availability.
B) Use an Application Load Balancer with Amazon ECS Fargate tasks to ingest data. Store raw data in Amazon SQS. Process data with additional Fargate tasks. Store results in Amazon Aurora Serverless with encryption enabled.
C) Use Amazon CloudFront with Lambda@Edge to ingest data. Store raw data in Amazon S3. Process data with AWS Batch. Store results in Amazon Redshift Serverless with encryption enabled.
D) Use Amazon API Gateway with AWS Lambda to ingest data. Store raw data in Amazon S3. Use S3 Event Notifications to trigger a Lambda function for processing. Store results in Amazon RDS MySQL with encryption enabled.

---

### Question 25
A multinational bank must ensure that IAM users and roles across 50 AWS accounts follow the principle of least privilege. The bank's security team has noticed that many IAM entities have permissions far beyond what they actually use. The team needs to right-size permissions without disrupting business operations.

Which approach should the solutions architect recommend?

A) Use AWS IAM Access Analyzer to review IAM policies across all accounts. Generate policy recommendations based on access activity from AWS CloudTrail logs. Replace existing policies with the generated least-privilege policies after stakeholder review.
B) Delete all existing IAM policies and require teams to request specific permissions through a ticketing system. Grant permissions only as tickets are submitted and approved.
C) Use AWS Organizations SCPs to deny all actions except those explicitly allowed. Gradually add allowed actions as teams report access issues.
D) Enable AWS CloudTrail in all accounts and use Amazon Athena to query access logs. Write custom scripts to generate new IAM policies based on observed usage patterns.

---

### Question 26
A healthcare provider needs to build a patient portal that allows patients to view their medical records. The portal must authenticate patients using multi-factor authentication (MFA) and must comply with HIPAA. The development team wants to use managed services for authentication and does not want to manage user credentials or MFA infrastructure.

Which solution meets these requirements?

A) Use Amazon Cognito user pools with MFA enabled. Configure advanced security features for adaptive authentication. Use Cognito identity pools to grant temporary AWS credentials for accessing backend services.
B) Deploy a custom authentication service on Amazon EC2 with an open-source MFA library. Store user credentials in Amazon DynamoDB with encryption enabled.
C) Use AWS IAM Identity Center (SSO) to authenticate patients. Configure MFA through the Identity Center console. Use IAM roles for backend access.
D) Use Amazon API Gateway with Lambda authorizers that validate credentials against a self-managed LDAP directory running on EC2. Implement TOTP-based MFA using a custom Lambda function.

---

### Question 27
A defense contractor is building a secure data analytics platform on AWS GovCloud (US). The platform must process data classified as Controlled Unclassified Information (CUI). All data access must be logged, and the contractor must demonstrate to auditors that no unauthorized data exfiltration has occurred. The platform uses Amazon S3 for data storage and Amazon EMR for analytics.

Which combination of controls should the solutions architect implement? **(Select THREE.)**

A) Enable S3 server access logging and CloudTrail data events for all S3 buckets. Configure CloudTrail log file validation.
B) Configure VPC endpoints for S3 with endpoint policies that restrict access to specific buckets. Remove all internet gateways and NAT gateways from the VPC.
C) Enable Amazon GuardDuty with S3 protection to detect anomalous data access patterns and potential exfiltration attempts.
D) Use S3 Transfer Acceleration to speed up data transfers between EMR and S3 while maintaining encryption.
E) Enable S3 Cross-Region Replication to create backup copies of all data in a commercial AWS Region for disaster recovery.
F) Deploy Amazon CloudWatch Container Insights for EMR cluster monitoring and performance optimization.

---

### Question 28
A retail bank is building a fraud detection system that analyzes transaction patterns in real time. The system must process thousands of transactions per second and flag suspicious activity within 500 milliseconds. The transaction data contains PII and must be encrypted. The bank wants to use machine learning models for fraud scoring.

Which architecture meets these requirements?

A) Use Amazon Kinesis Data Streams to ingest transactions. Process transactions with Amazon Kinesis Data Analytics using Apache Flink with a custom ML model. Store flagged transactions in Amazon DynamoDB with encryption. Alert through Amazon SNS.
B) Use Amazon SQS FIFO queues to ingest transactions. Process transactions with AWS Lambda functions that call Amazon SageMaker endpoints for fraud scoring. Store results in Amazon RDS with encryption.
C) Use Amazon MSK (Managed Streaming for Apache Kafka) to ingest transactions. Process transactions with Amazon EMR Spark Streaming. Store results in Amazon Redshift with encryption.
D) Use Amazon API Gateway to receive transactions. Process each transaction synchronously with AWS Lambda calling Amazon Comprehend for sentiment analysis on transaction descriptions. Store results in Amazon S3.

---

### Question 29
A state Medicaid agency is migrating its claims processing system to AWS. The system must comply with CMS (Centers for Medicare & Medicaid Services) security requirements. All administrative access to the AWS environment must use MFA and come from a dedicated management network. Session activity must be recorded for audit purposes.

Which solution meets these requirements?

A) Create IAM users with MFA enabled for all administrators. Require administrators to use the AWS Management Console from their office network. Enable CloudTrail for auditing.
B) Deploy AWS Systems Manager Session Manager for all administrative access. Configure Session Manager to require MFA through IAM policies. Enable session logging to an encrypted S3 bucket and CloudWatch Logs. Restrict Session Manager access to the management VPC using VPC endpoint policies.
C) Set up AWS Client VPN with certificate-based authentication for administrative access. Require MFA through the VPN connection. Log VPN connection events in CloudWatch.
D) Create a bastion host in a public subnet. Require SSH key-based authentication with MFA using a PAM module. Log all SSH sessions using script recordings stored in S3.

---

### Question 30
A pharmaceutical company maintains a data lake on Amazon S3 that stores clinical trial results, adverse event reports, and manufacturing quality data. The company must comply with FDA 21 CFR Part 11, which requires electronic records to have audit trails, access controls, and tamper-proof storage. Records must be retained for the life of the product plus an additional 2 years.

Which combination of controls meets these requirements? **(Select TWO.)**

A) Enable S3 Versioning and S3 Object Lock in Compliance mode on all buckets storing regulated data. Configure retention periods based on product lifecycle requirements.
B) Enable S3 Cross-Region Replication to maintain copies of all regulated data. Use S3 Lifecycle policies to delete replicated data after 2 years.
C) Use AWS CloudTrail data events for S3 to capture all read and write operations. Store CloudTrail logs in a separate S3 bucket with Object Lock. Enable CloudTrail log file integrity validation.
D) Use Amazon S3 Glacier Instant Retrieval for all regulated data from day one to minimize costs and prevent accidental modification.
E) Configure S3 bucket policies that allow only the root account user to delete objects, ensuring strong access controls.

---

### Question 31
A healthcare company runs a HIPAA-compliant application that uses Amazon RDS for PostgreSQL. The database contains PHI and must be encrypted at rest and in transit. The company's security policy requires that database credentials be rotated every 30 days without application downtime. The application runs on Amazon ECS Fargate.

Which approach meets these requirements?

A) Store database credentials in AWS Secrets Manager. Configure automatic rotation every 30 days using a Lambda rotation function. Configure the ECS task definition to retrieve the secret at container startup. Enable RDS encryption and enforce SSL connections.
B) Store database credentials in AWS Systems Manager Parameter Store as SecureString parameters. Create a CloudWatch Events rule that triggers a Lambda function every 30 days to rotate the password. Update the ECS task definition with the new credentials and redeploy.
C) Embed database credentials in the application code and use environment variables in the ECS task definition. Rotate credentials by updating the environment variable and performing a rolling deployment every 30 days.
D) Use IAM database authentication for RDS PostgreSQL. Assign an IAM role to the ECS task that grants rds-db:connect permission. Eliminate the need for password rotation.

---

### Question 32
A government agency is deploying a public-facing web application that must comply with the NIST 800-53 security framework. The application must be protected against common web exploits including SQL injection and cross-site scripting (XSS). The agency also needs protection against DDoS attacks and requires detailed security logging.

Which combination of services provides the required protections? **(Select TWO.)**

A) Deploy AWS WAF with managed rule groups for SQL injection and XSS protection on an Application Load Balancer. Enable WAF logging to Amazon S3 via Kinesis Data Firehose.
B) Deploy AWS Shield Standard on all public-facing resources. Configure Amazon CloudWatch Alarms on Network ACL deny counts to detect DDoS attacks.
C) Deploy AWS Shield Advanced on the Application Load Balancer and Amazon CloudFront distribution. Enable AWS Shield Advanced automatic application-layer DDoS mitigation and configure proactive engagement with the AWS Shield Response Team.
D) Use Amazon Inspector to continuously scan the web application for SQL injection and XSS vulnerabilities in the application code.
E) Deploy Amazon GuardDuty to detect SQL injection attempts and cross-site scripting attacks in real time.

---

### Question 33
A regional health system uses Amazon WorkSpaces to provide clinicians with secure access to a clinical application. The WorkSpaces must comply with HIPAA and must prevent users from copying data from the clinical application to local devices. The health system also needs to ensure that WorkSpaces are only accessible from managed corporate devices.

Which configuration meets these requirements?

A) Configure WorkSpaces to use PCoIP protocol. Enable clipboard redirection and local printing for user convenience. Use security groups to restrict access to corporate IP ranges.
B) Configure WorkSpaces to restrict clipboard, file transfer, and printing redirection through WorkSpaces access control settings. Use IP access control groups to limit access to corporate network IP ranges. Enable WorkSpaces access from trusted devices using certificate-based authentication.
C) Deploy Amazon AppStream 2.0 instead of WorkSpaces. Disable clipboard access. Use SAML-based authentication against the corporate identity provider.
D) Configure WorkSpaces with standard protocol settings. Deploy a network proxy on each WorkSpace that inspects outbound traffic and blocks data exfiltration attempts.

---

### Question 34
A financial services company needs to implement a centralized logging solution that collects logs from AWS services and on-premises servers. The logs must be searchable in near real time for security investigations. The company requires that logs older than 90 days be moved to cost-effective cold storage but remain queryable for compliance audits for up to 7 years.

Which architecture meets these requirements?

A) Send all logs to Amazon CloudWatch Logs. Use CloudWatch Logs Insights for real-time searching. After 90 days, export logs to S3 Glacier Deep Archive. Use Amazon Athena to query archived logs.
B) Send all logs to Amazon OpenSearch Service with UltraWarm nodes enabled. Configure index lifecycle policies to move indices older than 90 days to UltraWarm storage and then to cold storage. Use OpenSearch dashboards for searching across all tiers.
C) Send all logs to Amazon Kinesis Data Firehose, which delivers logs to Amazon S3. Use Amazon OpenSearch Service for real-time search on the last 90 days. Use S3 lifecycle policies to transition older logs to S3 Glacier Flexible Retrieval. Query archived logs with Athena.
D) Send all logs directly to Amazon S3. Use Amazon Athena for all querying needs. Apply S3 lifecycle policies to move logs to S3 Glacier after 90 days.

---

### Question 35
A hospital network is implementing network segmentation for HIPAA compliance. The network must separate clinical systems that handle PHI from administrative systems and guest Wi-Fi traffic. The clinical systems must have outbound internet access for software updates but must not be directly accessible from the internet. All traffic between segments must be logged.

Which network architecture meets these requirements?

A) Create a single VPC with three subnets: clinical (private), administrative (private), and guest (public). Use security groups and NACLs to control traffic between subnets. Use a NAT gateway for clinical system internet access. Enable VPC Flow Logs.
B) Create three separate VPCs: clinical, administrative, and guest. Connect them using AWS Transit Gateway with separate route tables for each VPC. Use AWS Network Firewall for inter-VPC traffic inspection and logging. Use a NAT gateway in the clinical VPC for outbound internet access.
C) Create a single VPC with all systems in private subnets. Use an Application Load Balancer with path-based routing to separate traffic. Enable AWS CloudTrail for logging.
D) Create three separate VPCs with VPC peering between the clinical and administrative VPCs. Use security groups to control traffic. Allow full peering between all three VPCs for management purposes.

---

### Question 36
A credit card processing company must ensure that its AWS infrastructure is reviewed quarterly for PCI DSS compliance. The company needs to automate evidence collection for controls related to access management, encryption, and network security. The evidence must be organized and ready for the external auditor.

Which solution provides the MOST automated approach?

A) Manually collect evidence by taking screenshots of AWS Console configurations each quarter. Store screenshots in an Amazon S3 bucket organized by PCI DSS requirement. Share the bucket with auditors.
B) Use AWS Audit Manager to create a PCI DSS assessment. Configure Audit Manager to automatically collect evidence from AWS Config, CloudTrail, and Security Hub. Share assessment reports with auditors through Audit Manager.
C) Use AWS Config to evaluate compliance rules aligned to PCI DSS. Export Config compliance reports to Amazon S3 quarterly. Use Amazon QuickSight to generate visual compliance dashboards for auditors.
D) Deploy a third-party compliance tool from the AWS Marketplace. Configure it to scan all AWS resources and generate PCI DSS reports. Store reports in Amazon S3 and share with auditors.

---

### Question 37
A state government agency handles unemployment insurance claims. During a pandemic, the volume of claims increases 50x. The application must scale to handle the surge while maintaining sub-second response times for citizens. All data must be encrypted and must not leave the designated AWS Region. The agency needs to control costs when demand returns to normal.

Which architecture handles these requirements?

A) Deploy the application on Amazon EC2 Reserved Instances sized for peak load. Use Amazon RDS Multi-AZ for the database. Store documents in Amazon S3 with SSE-KMS encryption.
B) Deploy the application on AWS Lambda behind Amazon API Gateway. Use Amazon DynamoDB with on-demand capacity mode for the database. Use Amazon S3 with SSE-KMS for document storage. Configure DynamoDB encryption at rest with a KMS key restricted to the designated Region.
C) Deploy the application on Amazon ECS with EC2 launch type using Spot Instances. Use Amazon Aurora Serverless v2 for the database. Store documents in Amazon EFS with encryption enabled.
D) Deploy the application on Amazon EC2 Auto Scaling groups with On-Demand Instances. Use Amazon ElastiCache for Redis as the primary database. Store documents in Amazon S3 with SSE-S3 encryption.

---

### Question 38
A healthcare IT vendor develops a SaaS platform used by multiple hospitals. Each hospital's data must be completely isolated. The vendor needs to deploy updates to all hospital tenants simultaneously, maintain a single codebase, and ensure HIPAA compliance. The vendor prefers a microservices architecture.

Which multi-tenant architecture should the solutions architect recommend?

A) Deploy a separate AWS account per hospital tenant using AWS Organizations. Use AWS CodePipeline to deploy updates across all accounts simultaneously. Use a pool model for shared infrastructure components with per-tenant encryption keys.
B) Deploy all tenants in a single AWS account using a single Amazon ECS cluster. Use namespace prefixes in Amazon DynamoDB table names to separate tenant data. Share encryption keys across tenants.
C) Deploy all tenants in a single VPC with separate subnets per tenant. Use a shared Amazon RDS instance with separate schemas for each tenant. Use a single KMS key for all tenants.
D) Deploy separate ECS clusters per tenant within a single AWS account. Use separate DynamoDB tables with per-tenant KMS keys. Use AWS CodeDeploy to update all clusters from a single pipeline.

---

### Question 39
An investment firm stores trade execution records in Amazon DynamoDB. SEC regulations require that these records be immutable and retained for 6 years. The firm needs to ensure that no IAM user, role, or even the root account can modify or delete trade records after they are written.

Which solution ensures immutability of the trade records?

A) Enable DynamoDB point-in-time recovery (PITR). Configure an SCP in AWS Organizations that denies the dynamodb:DeleteItem and dynamodb:UpdateItem actions for the trade records table.
B) Write trade records to DynamoDB and simultaneously export them to Amazon S3 using DynamoDB Streams and AWS Lambda. Configure S3 Object Lock in Compliance mode with a 6-year retention period on the S3 bucket for the authoritative immutable copy.
C) Create a DynamoDB table with a condition expression on all write operations that prevents updates to existing items. Configure IAM policies that deny delete operations for all users.
D) Enable DynamoDB encryption with a customer managed KMS key. Disable the KMS key after writing records to prevent any modifications.

---

### Question 40
A national health information exchange (HIE) needs to enable secure data sharing between hospitals that each have their own AWS accounts. The HIE acts as a central coordinator. Patient records must be shared only with the patient's consent, and all sharing activities must be auditable. Each hospital must maintain ownership of its own data.

Which architecture supports these requirements? **(Select TWO.)**

A) Create a central Amazon S3 bucket in the HIE's account. Require all hospitals to upload patient data to this central bucket. Use S3 bucket policies to control which hospitals can access which records.
B) Use AWS Resource Access Manager (RAM) to share specific resources between hospital accounts. Implement a consent management service in the HIE's account that uses Amazon DynamoDB to track patient consent. Share data only when consent is verified.
C) Have each hospital expose patient data through Amazon API Gateway endpoints. The HIE's central account calls these APIs when consent-verified requests are made. Enable API Gateway access logging and CloudTrail for audit purposes.
D) Use AWS PrivateLink to create VPC endpoint services in each hospital's account. The HIE's account connects to these endpoints to request patient data. Log all data access requests in a centralized CloudTrail organization trail.
E) Replicate all hospital data to the HIE's account using DynamoDB global tables. Use fine-grained access control with IAM policies to restrict access based on consent records.

---

### Question 41
A fintech startup processes loan applications and stores applicant financial data in Amazon Aurora MySQL. The company needs to provide read-only access to a third-party credit scoring service without exposing the full database. Only specific columns (name, credit score, and loan amount) should be accessible. The applicant's Social Security number and bank account details must remain hidden.

Which approach meets these requirements with the LEAST operational overhead?

A) Create an Aurora clone for the third-party service. Delete sensitive columns from the clone's tables. Refresh the clone weekly with a Lambda function.
B) Create a database view in Aurora MySQL that exposes only the approved columns. Create a database user with SELECT-only permissions on the view. Provide the third-party service with an RDS Proxy endpoint that connects to this user. Restrict access via security groups.
C) Export the required columns to Amazon S3 using an AWS Glue ETL job. Share the S3 bucket with the third-party service using a cross-account IAM role.
D) Use Amazon DynamoDB to create a synchronized copy of only the required columns. Use DynamoDB Streams and Lambda to keep the copy updated. Share access via a cross-account IAM role.

---

### Question 42
A hospital data center experiences frequent power outages. The hospital's critical patient monitoring system must continue operating even if the primary AWS Region becomes unavailable. The system uses Amazon ECS, Amazon Aurora, and Amazon S3. The RTO is 5 minutes and the RPO is 0 (zero data loss).

Which disaster recovery strategy meets these requirements?

A) Deploy an active-active architecture across two AWS Regions. Use Aurora Global Database with write forwarding enabled. Use S3 Cross-Region Replication with S3 Replication Time Control. Use Route 53 health checks with active-active failover routing.
B) Deploy the application in a single Region with Multi-AZ for all services. Use Aurora Multi-AZ and S3 Cross-Region Replication. Configure Route 53 failover routing to a static S3 website in the secondary Region.
C) Deploy a warm standby in a secondary Region. Use Aurora cross-Region read replicas. Use S3 Cross-Region Replication. Configure Route 53 failover routing. Scale up the standby during failover.
D) Deploy a pilot light in a secondary Region with the minimum infrastructure. Use Aurora Global Database. Use S3 Cross-Region Replication. Launch full ECS capacity in the secondary Region only during failover events.

---

### Question 43
A financial institution needs to implement network-level isolation for its trading platform on AWS. The trading platform must communicate with market data providers over the internet, but all internal communication between application tiers must be over private connections. The institution also needs to inspect all outbound traffic for data loss prevention.

Which network architecture meets these requirements?

A) Deploy all application tiers in private subnets. Use a NAT gateway for outbound internet access. Deploy AWS Network Firewall in the VPC with inspection rules for outbound traffic. Use VPC endpoints for AWS service communication.
B) Deploy application tiers in both public and private subnets. Use an internet gateway for market data provider access. Use security groups to restrict internal communication.
C) Deploy all application tiers in private subnets. Use a proxy server on an EC2 instance in a public subnet for outbound internet access. Configure the proxy to inspect outbound traffic using open-source DLP tools.
D) Deploy all application tiers in a single public subnet. Use NACLs to restrict communication between application tiers. Use AWS WAF for outbound traffic inspection.

---

### Question 44
A healthcare data analytics company needs to process patient records from multiple hospitals. Each hospital sends data in different formats (HL7, FHIR, CSV). The company needs to transform all incoming data into a standardized format, encrypt it, and store it in a data lake for analytics. The processing pipeline must handle variable volumes and be cost-efficient.

Which architecture should the solutions architect recommend?

A) Use Amazon API Gateway to receive data from hospitals. Invoke AWS Lambda functions to detect the data format and apply the appropriate transformation. Store transformed data in Amazon S3 with SSE-KMS encryption. Use AWS Glue crawlers to catalog the data for Athena queries.
B) Deploy Amazon MQ to receive messages from hospitals in different formats. Use Amazon EC2 instances to run custom transformation scripts. Store transformed data in Amazon Redshift with encryption enabled.
C) Use AWS Transfer Family SFTP endpoints to receive files from hospitals. Process files using Amazon EMR clusters that run transformation jobs. Store transformed data in Amazon S3 with SSE-S3 encryption.
D) Use Amazon Kinesis Data Firehose to receive streaming data from hospitals. Use Firehose transformation with Lambda to standardize formats. Store transformed data directly in Amazon S3 with SSE-KMS encryption.

---

### Question 45
An insurance company is migrating to a multi-account AWS architecture using AWS Control Tower. The company needs to enforce security guardrails across all accounts, including mandatory encryption for all EBS volumes, prevention of public S3 buckets, and restriction of AWS Regions to only us-east-1 and us-west-2.

Which approach provides these guardrails with the LEAST effort?

A) Create custom AWS Config rules in each account for EBS encryption and S3 public access. Write Lambda functions for auto-remediation. Manually restrict Regions by not provisioning resources in other Regions.
B) Enable AWS Control Tower mandatory guardrails. Create additional custom SCPs in AWS Organizations to enforce EBS encryption by default, deny S3 public access, and restrict API calls to the approved Regions. Apply SCPs to all organizational units except the management account.
C) Deploy AWS CloudFormation StackSets across all accounts to configure AWS Config rules and remediation. Use IAM policies in each account to deny Region-specific API calls.
D) Use AWS Security Hub to detect non-compliant resources. Create EventBridge rules to trigger remediation Lambda functions. Use IAM policies to restrict Region access.

---

### Question 46
A bank has a critical application running on Amazon EC2 instances that access an Amazon RDS Oracle database. The bank needs to establish private connectivity between the EC2 instances and a third-party payment processor without traversing the public internet. The payment processor has deployed its service in its own AWS account.

Which solution provides the required private connectivity?

A) Create a VPC peering connection between the bank's VPC and the payment processor's VPC. Configure route tables and security groups to allow communication.
B) Have the payment processor create a VPC endpoint service using AWS PrivateLink backed by a Network Load Balancer. Create an interface VPC endpoint in the bank's VPC to connect to the payment processor's endpoint service.
C) Set up an AWS Site-to-Site VPN connection between the bank's VPC and the payment processor's VPC. Use the VPN for all communication.
D) Deploy AWS Transit Gateway and share it with the payment processor's account using AWS RAM. Attach both VPCs to the Transit Gateway.

---

### Question 47
A government agency processes citizen tax returns using an application that runs on AWS. The application must store tax return data for 10 years. Access to tax return data must be restricted based on the sensitivity classification (Public, Sensitive, Highly Sensitive). Users should only be able to access data at or below their clearance level.

Which approach implements the required access control model?

A) Create separate S3 buckets for each classification level. Create IAM policies that grant access to buckets based on user clearance. Assign policies to IAM groups corresponding to each clearance level.
B) Store all data in a single S3 bucket. Use S3 object tags to classify data by sensitivity level. Use AWS Lake Formation tag-based access control (TBAC) to enforce that users can only access data tagged at or below their clearance level.
C) Store all data in Amazon DynamoDB. Use fine-grained access control with IAM condition keys to restrict access based on item attributes matching the user's clearance level.
D) Create separate AWS accounts for each classification level. Use AWS Organizations SCPs to prevent users from switching between accounts above their clearance level.

---

### Question 48
A European bank needs to implement a customer data platform on AWS that processes personal data under GDPR. The platform ingests customer interactions from multiple channels (web, mobile, call center). The bank must obtain and track customer consent for data processing, support data portability requests, and enable data pseudonymization for analytics.

Which architecture addresses these GDPR requirements? **(Select TWO.)**

A) Build a consent management service using Amazon DynamoDB to store consent records with TTL for automatic expiration. Integrate the consent check into the data processing pipeline using AWS Step Functions so that no data is processed without verified consent.
B) Use Amazon Kinesis Data Streams to ingest customer interaction data. Apply pseudonymization by replacing customer identifiers with tokenized values using a Lambda function before data reaches the analytics layer. Store the token-to-identity mapping in a separate, encrypted DynamoDB table with strict access controls.
C) Store all customer data in Amazon Redshift with column-level encryption. Use Redshift data sharing to provide analytics access. Implement data portability by generating Redshift UNLOAD commands that export customer data to CSV.
D) Use Amazon Personalize to process customer interaction data for analytics. Rely on the service's built-in GDPR compliance features to handle consent and data portability.
E) Store all customer data in a single Amazon S3 bucket and use S3 Intelligent-Tiering for cost optimization. Handle data portability requests by manually locating and downloading relevant files.

---

### Question 49
A large healthcare provider is implementing a backup strategy for its AWS environment that complies with HIPAA requirements. The backup policy requires daily backups of all databases, weekly backups of file systems, 35-day retention for daily backups, and 1-year retention for weekly backups. Backups must be encrypted and must be stored in a different Region from the primary workloads.

Which solution meets all of these requirements with the LEAST operational overhead?

A) Use AWS Backup to create a backup plan with two rules: daily database backups with 35-day retention and weekly file system backups with 365-day retention. Configure a cross-Region backup copy rule for both. Ensure the backup vault is encrypted with a KMS customer managed key.
B) Create custom Lambda functions for each backup type. Schedule them using Amazon EventBridge. Copy backups to a secondary Region using additional Lambda functions. Store backup metadata in DynamoDB for tracking retention.
C) Use Amazon Data Lifecycle Manager (DLM) for EBS snapshots and RDS automated backups for databases. Manually configure cross-Region snapshot copy. Set retention policies individually for each service.
D) Use AWS CloudFormation to deploy backup scripts on EC2 instances in each account. Schedule scripts using cron jobs. Use S3 Cross-Region Replication for backup storage.

---

### Question 50
A regional bank needs to deploy a customer-facing mobile banking application on AWS. The application must authenticate users with username/password plus biometric verification. After authentication, the application must provide temporary AWS credentials to access backend APIs and DynamoDB tables. Each user must only be able to read and write their own records in DynamoDB.

Which architecture meets these requirements?

A) Use Amazon Cognito user pools for authentication with custom Lambda triggers for biometric verification. Use Cognito identity pools to issue temporary AWS credentials. Configure DynamoDB fine-grained access control using IAM policy conditions with ${cognito-identity.amazonaws.com:sub} to restrict access to user-specific records.
B) Use AWS IAM Identity Center for user authentication. Create individual IAM users for each mobile app user. Attach inline IAM policies to each user that restrict DynamoDB access to their records.
C) Use Amazon API Gateway with a custom Lambda authorizer for authentication. Generate long-lived AWS access keys for each user. Store the keys in the mobile app's local storage. Use API Gateway resource policies to restrict DynamoDB access.
D) Use Auth0 as an external identity provider. Federate with AWS IAM using SAML 2.0. Create IAM roles with trust policies for each user group. Use DynamoDB table-level permissions to restrict access.

---

### Question 51
A pharmaceutical company runs batch processing jobs for drug interaction analysis on AWS. The jobs process sensitive patient data and FDA-regulated manufacturing data. The company needs to ensure that the EC2 instances used for batch processing are hardened according to CIS benchmarks. Instances must be patched within 72 hours of critical vulnerability disclosure.

Which approach ensures continuous compliance of the EC2 fleet?

A) Create a golden AMI using EC2 Image Builder with a CIS benchmark hardening component. Use AWS Systems Manager Patch Manager with a custom patch baseline that auto-approves critical patches within 72 hours. Use Systems Manager State Manager to ensure instances conform to the CIS configuration on an ongoing basis.
B) Deploy EC2 instances from the latest Amazon Linux AMI. Use AWS Config rules to check CIS compliance. Terminate and replace non-compliant instances with new instances from updated AMIs.
C) Use AWS Marketplace CIS-hardened AMIs. Schedule weekly AMI updates using a Lambda function. Replace all running instances with instances launched from the updated AMI weekly.
D) Deploy a configuration management tool (Ansible) on a bastion host. Run CIS hardening playbooks against all EC2 instances on a nightly schedule. Use Amazon Inspector to verify compliance.

---

### Question 52
A healthcare technology company is building a FHIR-compliant API for exchanging patient data between healthcare providers. The API must handle hundreds of thousands of requests per second during peak hours and must respond within 100 milliseconds. The data must be encrypted in transit and at rest. The company needs fine-grained access control based on the requesting provider's identity and the patient's consent status.

Which architecture meets these requirements?

A) Deploy the API on Amazon API Gateway with AWS Lambda backend. Use Amazon DynamoDB as the data store with DAX (DynamoDB Accelerator) for caching. Implement a custom Lambda authorizer that checks provider identity and patient consent from a Cognito user pool and a consent DynamoDB table.
B) Deploy the API on Amazon ECS Fargate behind an Application Load Balancer. Use Amazon Aurora with read replicas as the data store. Implement OAuth 2.0 authorization using a third-party identity provider.
C) Deploy the API on Amazon EC2 instances behind a Network Load Balancer. Use Amazon ElastiCache for Redis as the primary data store. Use IAM authentication for each API request.
D) Deploy the API using AWS AppSync with a GraphQL interface. Use Amazon Neptune as the backend data store. Use AppSync's built-in authorization with API keys.

---

### Question 53
A federal law enforcement agency needs to establish a secure, forensically sound evidence storage system on AWS. Digital evidence must be write-once-read-many (WORM), must maintain a chain of custody log, and must be retained for the duration of each case plus 25 years. Evidence files range from kilobytes (text files) to terabytes (video recordings).

Which solution meets these requirements?

A) Store evidence in Amazon S3 with S3 Object Lock in Compliance mode. Set retention periods dynamically per case using object-level retention settings. Enable S3 Versioning. Log all access using CloudTrail data events and S3 server access logging to a separate locked S3 bucket for chain of custody.
B) Store evidence in Amazon EFS with file system encryption. Use Linux file permissions to make files read-only after upload. Enable EFS Backup for long-term retention.
C) Store evidence in Amazon S3 Glacier Deep Archive for cost savings. Use S3 Vault Lock for WORM compliance. Log access using CloudWatch Logs.
D) Store evidence in Amazon FSx for Lustre with write-once mount options. Log file access using VPC Flow Logs. Archive data to S3 after the case closes.

---

### Question 54
A multinational financial services company needs to deploy a risk assessment application across three AWS Regions (us-east-1, eu-west-1, ap-southeast-1) to serve users globally with low latency. The application requires consistent data across all Regions. Data sovereignty laws require that European customer data be processed only in eu-west-1.

Which architecture meets these requirements?

A) Deploy the application in all three Regions. Use Amazon DynamoDB global tables for shared data. Use application-level logic to route European customer data exclusively to eu-west-1. Use Amazon Route 53 geolocation routing to direct users to the nearest Region.
B) Deploy the application in a single Region (us-east-1) behind Amazon CloudFront. Use CloudFront edge caching to reduce latency for global users. Store European data in a separate DynamoDB table with a condition that restricts writes to eu-west-1.
C) Deploy the application in all three Regions. Use Amazon Aurora Global Database with the primary in us-east-1. Route all European requests to eu-west-1 using Route 53 latency-based routing.
D) Deploy the application in all three Regions. Use Amazon ElastiCache Global Datastore for shared session data. Use Amazon S3 with Cross-Region Replication for data storage. Use Route 53 weighted routing.

---

### Question 55
A medical device manufacturer stores IoT telemetry from devices implanted in patients. The data is subject to both HIPAA and FDA regulations. The manufacturer needs to detect anomalies in device performance in real time and alert healthcare providers when a device malfunction is detected. The system must scale to millions of devices.

Which architecture meets these requirements?

A) Use AWS IoT Core to ingest device telemetry. Use AWS IoT Rules Engine to route data to Amazon Kinesis Data Streams. Process data with Amazon Kinesis Data Analytics for anomaly detection using the RANDOM_CUT_FOREST function. Send alerts through Amazon SNS to healthcare providers. Store all telemetry in Amazon S3 with SSE-KMS encryption for long-term regulatory retention.
B) Use Amazon API Gateway to receive device telemetry via HTTPS. Store data directly in Amazon DynamoDB. Use DynamoDB Streams with Lambda to detect anomalies based on threshold rules. Send alerts via Amazon SES.
C) Use AWS IoT Core to ingest device telemetry. Store all data directly in Amazon Timestream. Query Timestream periodically with scheduled Lambda functions to detect anomalies. Send alerts through Amazon SNS.
D) Use AWS IoT Greengrass on a gateway device at the hospital. Process all telemetry locally and send only alerts to the cloud. Store all data on the local gateway.

---

### Question 56
A state child welfare agency needs to share case information securely with county-level offices. Each county office has its own AWS account. The state agency manages the central case management database on Amazon Aurora PostgreSQL. County offices should have read-only access to cases in their jurisdiction only. All access must be logged for compliance.

Which architecture provides secure, auditable, jurisdiction-based access?

A) Create Aurora read replicas in each county's account using cross-account Aurora cloning. Filter data by county at the application level. Enable Aurora audit logging.
B) Create a single Aurora read replica in the state agency's account. Expose data through Amazon API Gateway with Lambda functions that enforce jurisdiction-based filtering using the caller's identity. Enable API Gateway access logging and CloudTrail for audit.
C) Share the Aurora database directly with county accounts using AWS RAM. Create database users for each county with row-level security (RLS) policies that filter by jurisdiction.
D) Export county-specific data to separate S3 buckets nightly using AWS Glue ETL jobs. Share each bucket with the respective county account using cross-account S3 bucket policies.

---

### Question 57
A healthcare organization uses AWS to run clinical research workloads. The organization needs to ensure that all Amazon EBS volumes attached to EC2 instances are encrypted. If an unencrypted EBS volume is detected, it must be automatically encrypted without disrupting the running workload.

Which solution provides automated detection and remediation?

A) Enable the EBS encryption by default setting in each AWS account. For existing unencrypted volumes, create an AWS Config rule (encrypted-volumes) to detect non-compliant volumes. Trigger an AWS Systems Manager Automation document that creates an encrypted snapshot of the unencrypted volume, creates a new encrypted volume from the snapshot, stops the instance, detaches the old volume, attaches the new encrypted volume, and starts the instance.
B) Enable the EBS encryption by default setting. For existing unencrypted volumes, manually create encrypted copies during the next maintenance window.
C) Create an SCP that denies the ec2:CreateVolume action when the encryption parameter is not set to true. Terminate and relaunch all existing instances to pick up the encryption setting.
D) Use Amazon Inspector to detect unencrypted EBS volumes. Configure Inspector to trigger a Lambda function that modifies the EBS volume encryption setting in place without creating a snapshot.

---

### Question 58
A global investment bank needs to implement a solution for managing secrets (API keys, database credentials, certificates) across 200+ AWS accounts. The secrets must be centrally managed, automatically rotated, and accessible only to authorized applications. The solution must support cross-account access and audit all secret access.

Which solution meets these requirements with the LEAST operational complexity?

A) Deploy AWS Secrets Manager in a centralized security account. Store all secrets in the central account. Create resource-based policies on each secret to allow cross-account access from specific IAM roles. Enable automatic rotation. Use CloudTrail to audit all access.
B) Deploy HashiCorp Vault on Amazon ECS in a dedicated account. Federate authentication with AWS IAM. Store all secrets in Vault. Configure automatic rotation using Vault's dynamic secrets feature.
C) Deploy AWS Systems Manager Parameter Store (SecureString) in each account. Synchronize secrets across accounts using a custom Lambda function. Rotate secrets manually on a quarterly basis.
D) Store all secrets in a centralized Amazon DynamoDB table with client-side encryption using the AWS Encryption SDK. Create cross-account IAM roles for access. Build custom rotation logic using Lambda and EventBridge.

---

### Question 59
A healthcare organization is building a data pipeline that ingests electronic health records (EHR) from multiple hospitals. The pipeline must de-identify data for research purposes while maintaining referential integrity across datasets. The de-identified data must satisfy the HIPAA Safe Harbor method requirements. The organization needs to process 10 million records daily.

Which approach meets these requirements?

A) Use AWS Glue ETL jobs with custom PySpark scripts to detect and remove the 18 HIPAA Safe Harbor identifiers. Use deterministic tokenization (format-preserving encryption) to replace identifiers with consistent pseudonyms that maintain referential integrity across datasets. Store de-identified data in Amazon S3 with SSE-KMS encryption.
B) Use Amazon Comprehend Medical to detect PHI in EHR data. Use Amazon Comprehend's PII redaction feature to replace all detected PHI with placeholder text. Store de-identified data in Amazon S3.
C) Use AWS Lambda functions to process records one at a time. Apply regex patterns to detect and remove PHI. Store de-identified data in Amazon DynamoDB.
D) Use Amazon Macie to scan S3 buckets containing EHR data and automatically redact all PII. Store the redacted data in a separate S3 bucket.

---

### Question 60
A county government runs a property records management system on AWS. The system must be protected against ransomware attacks. Critical data includes land titles, tax assessments, and property transfer records. The government needs to ensure that even if all IAM credentials are compromised, the data can be recovered to a known good state.

Which combination of measures provides the MOST comprehensive ransomware protection? **(Select TWO.)**

A) Enable S3 Versioning on all buckets. Configure S3 Object Lock in Compliance mode with a retention period. Store critical backups in a separate AWS account with no cross-account trust relationship to the production account. Use AWS Backup with vault lock.
B) Enable Amazon GuardDuty with malware protection for EC2 instances and S3 buckets. Configure automated responses via EventBridge to quarantine compromised resources.
C) Deploy AWS Shield Advanced on all public-facing resources to prevent ransomware delivery via DDoS attacks.
D) Increase the EBS volume size for all EC2 instances to provide more storage buffer in case of ransomware encryption.
E) Deploy third-party antivirus software on all EC2 instances and configure daily full-system scans.

---

### Question 61
A bank's compliance team requires that all Amazon RDS database instances must use encryption at rest. They also need a mechanism to prevent any team from launching an unencrypted RDS instance and to receive a notification if a non-compliant instance is somehow created.

Which combination provides both preventive and detective controls? **(Select TWO.)**

A) Create an SCP that denies the rds:CreateDBInstance action unless the condition key rds:StorageEncrypted is true. Apply the SCP to all OUs in AWS Organizations.
B) Create an AWS Config rule that checks whether all RDS instances have storage encryption enabled. Configure an EventBridge rule to send SNS notifications when non-compliant instances are detected.
C) Create an IAM policy in each account that denies the rds:CreateDBInstance action for all users. Require users to submit a request to a central team to create encrypted RDS instances.
D) Enable AWS Security Hub and configure the AWS Foundational Security Best Practices standard, which includes checks for unencrypted RDS instances.
E) Deploy Amazon Inspector to scan RDS instances for encryption compliance.

---

### Question 62
A clinical genomics laboratory processes DNA sequencing data on AWS. The raw sequencing data (FASTQ files) are typically 200-500 GB per sample. The laboratory needs to run computationally intensive variant calling pipelines that require up to 96 vCPUs and 768 GB of memory per sample. The workload is highly variable, ranging from 5 to 200 samples per day. Data must be encrypted and access must be restricted to authorized researchers.

Which compute solution is MOST cost-effective while meeting performance requirements?

A) Deploy Amazon EC2 instances with 96 vCPUs and 768 GB memory (memory-optimized instance family). Use Spot Instances with On-Demand fallback through EC2 Auto Scaling. Store data in Amazon S3 with SSE-KMS encryption. Use S3 bucket policies and IAM roles to restrict access.
B) Use AWS Batch with a managed compute environment configured to use Spot Instances with a fallback to On-Demand. Define job definitions that request 96 vCPUs and 768 GB memory. Configure AWS Batch to pull FASTQ files from encrypted S3 buckets and write results back. Use IAM roles for job-level access control.
C) Deploy Amazon ECS on AWS Fargate with 96 vCPU tasks. Store data in Amazon EFS with encryption enabled. Use IAM task roles for access control.
D) Deploy an Amazon EMR cluster with memory-optimized instances. Process sequencing data using Apache Spark. Store data in HDFS on the cluster with LUKS encryption.

---

### Question 63
A government agency manages a classified document management system. All documents must be labeled with a security classification (Unclassified, Confidential, Secret). The system must enforce that users can only access documents at or below their security clearance level. The solution must use attribute-based access control (ABAC) and must work across multiple AWS accounts.

Which implementation meets these requirements?

A) Use AWS IAM with tag-based conditions. Tag all S3 objects with a SecurityClassification tag. Tag IAM roles with a ClearanceLevel tag. Create IAM policies with conditions that compare the user's ClearanceLevel tag against the resource's SecurityClassification tag. Use AWS Organizations to propagate tags across accounts.
B) Create three separate S3 buckets for each classification level. Use S3 bucket policies to restrict access based on IAM role ARNs. Maintain a mapping of user clearances to IAM roles in Amazon DynamoDB.
C) Use Amazon Cognito user pools with custom attributes for clearance level. Create separate Cognito groups for each clearance level. Use Cognito identity pool role mappings to assign IAM roles based on clearance.
D) Deploy AWS Verified Access with trust providers that evaluate user clearance attributes. Create access policies that compare user clearance levels against document classifications.

---

### Question 64
A health insurance company processes millions of claims daily. Each claim contains member information, diagnosis codes, procedure codes, and billing amounts. The company needs to detect fraudulent claims in near real time. The solution must be able to identify patterns such as unusual billing amounts, impossible diagnosis-procedure combinations, and providers submitting abnormally high volumes of certain procedures.

Which architecture provides the MOST effective fraud detection?

A) Store claims in Amazon S3. Use Amazon Athena to run SQL queries that identify claims outside of normal statistical ranges. Schedule queries with Amazon EventBridge to run hourly.
B) Ingest claims using Amazon Kinesis Data Streams. Use Amazon SageMaker to train a fraud detection ML model on historical claims data. Deploy the model as a SageMaker real-time endpoint. Process each incoming claim through the endpoint via a Lambda function that reads from Kinesis. Flag suspicious claims in Amazon DynamoDB and alert investigators through SNS.
C) Store all claims in Amazon Redshift. Create materialized views that aggregate provider billing patterns. Run nightly batch analysis using Redshift stored procedures to flag anomalies.
D) Use Amazon Fraud Detector to ingest claims. Train a model using the historical claims dataset. Generate fraud predictions for each incoming claim through the Fraud Detector API.

---

### Question 65
A multinational corporation is implementing a comprehensive security monitoring solution across 50 AWS accounts spanning five AWS Regions. The corporation needs to detect threats, identify vulnerabilities, monitor compliance, and respond to security incidents from a single pane of glass. The security team has six analysts who need to be able to investigate and respond to findings efficiently.

Which architecture provides the MOST comprehensive and operationally efficient security monitoring? **(Select THREE.)**

A) Enable Amazon GuardDuty in all accounts and Regions with a delegated administrator account. Enable all protection plans including S3, EKS, RDS, Lambda, and Malware Protection.
B) Enable AWS Security Hub in all accounts and Regions with a delegated administrator. Enable the AWS Foundational Security Best Practices, CIS Benchmarks, and PCI DSS standards. Create custom insights for the security team's common investigation queries.
C) Deploy Amazon Detective in the delegated administrator account. Integrate it with GuardDuty findings. Use Detective's investigation tools for root cause analysis during incident response.
D) Deploy a third-party SIEM solution on Amazon EC2 in every Region. Aggregate logs from all accounts using S3 Cross-Region Replication.
E) Enable AWS CloudTrail in all accounts and Regions. Deploy CloudTrail Lake in the management account for centralized SQL-based querying of events across the organization.
F) Deploy Amazon Macie in all accounts to perform threat detection on EC2 instances and network traffic.

---

## Answer Key

### Question 1
**Correct Answer:** B

**Explanation:** SSE-KMS with customer managed keys (CMKs) provides the hospital with full control over encryption key policies, including the ability to audit key usage via CloudTrail and revoke access instantly by disabling or deleting the key. This approach meets HIPAA encryption requirements with minimal operational overhead since AWS manages the underlying HSM infrastructure. SSE-S3 does not provide customer-controlled key policies, and SSE-C requires the customer to manage key storage and transmission, adding operational complexity.

---

### Question 2
**Correct Answer:** B

**Explanation:** PCI DSS requires strict network segmentation of the cardholder data environment (CDE). A dedicated AWS account provides the strongest isolation boundary. AWS Transit Gateway with separate route tables enables controlled communication between the CDE and other environments. AWS Network Firewall is a managed service that provides stateful traffic inspection needed for PCI DSS requirement 1 (install and maintain a firewall configuration). VPC peering alone lacks traffic inspection capability, and deploying in a public subnet violates PCI DSS network isolation requirements.

---

### Question 3
**Correct Answer:** B, D

**Explanation:** GDPR Article 17 requires organizations to erase personal data upon request. Answer B provides the foundational capability of knowing where all patient data resides across multiple services through a comprehensive data catalog, which is essential before any deletion can occur. Answer D implements the actual deletion mechanism with a unique patient identifier enabling systematic erasure across S3, DynamoDB, and Aurora. S3 Object Lock would prevent deletion, not enable it. Lifecycle policies delete based on age, not on-demand. Macie identifies sensitive data but does not perform targeted deletion of specific records.

---

### Question 4
**Correct Answer:** B

**Explanation:** AWS GovCloud (US) Regions are specifically designed for FedRAMP High workloads. They are physically located in the United States and are operated exclusively by U.S. persons who are screened U.S. citizens. Standard commercial AWS Regions (like us-east-1) are operated by AWS employees globally and do not satisfy the FedRAMP High requirement that infrastructure operators be U.S. persons. Outposts extends AWS infrastructure on-premises but still relies on connectivity to a parent Region and doesn't address the FedRAMP authorization requirement.

---

### Question 5
**Correct Answer:** A

**Explanation:** An organization trail with log file validation enabled ensures that all API calls across all accounts are captured and that any tampering with log files is detectable (meeting SOC 2 integrity requirements). Delivering logs to a centralized S3 bucket with Object Lock in Compliance mode ensures that logs cannot be deleted or modified by anyone, including root users, for the specified retention period. Amazon Athena provides a serverless, cost-effective querying mechanism for audit purposes. VPC Flow Logs only capture network-level metadata, not API calls, so option D fails to meet the requirement.

---

### Question 6
**Correct Answer:** A, C, E

**Explanation:** AWS maintains a list of HIPAA-eligible services that can be used under a BAA. Amazon API Gateway, AWS Lambda, DynamoDB, Amazon Transcribe Medical, and AWS Step Functions are all HIPAA-eligible services. Amazon Lightsail became HIPAA-eligible but has limited features compared to the serverless options. Amazon GameLift is not a HIPAA-eligible service and is designed for game server hosting, not video streaming. Amazon WorkMail is HIPAA-eligible but was not presented with other essential services for this specific use case. The question asks for the best set of services for a serverless telemedicine platform.

---

### Question 7
**Correct Answer:** B

**Explanation:** AWS Security Hub provides a built-in CIS AWS Foundations Benchmark compliance standard that can be enabled with a single click. The delegated administrator feature allows centralized aggregation of findings from all member accounts with minimal configuration. This requires far less operational effort than deploying and managing Config rules individually, building custom Lambda functions, or deploying Inspector with custom assessment templates. Security Hub also provides an integrated dashboard for viewing compliance status across all accounts.

---

### Question 8
**Correct Answer:** B

**Explanation:** The requirement for Regional failure recovery within 15 minutes and RPO less than 1 minute necessitates a multi-Region architecture. Aurora Global Database provides cross-Region replication with replication lag typically under 1 second, meeting the RPO requirement. Route 53 health checks with failover routing can detect Regional failures and redirect traffic within minutes. EC2 Auto Scaling groups in both Regions ensure compute capacity is available for failover. A single-Region deployment (Option A) cannot survive a Regional failure. Option C only has EC2 in the primary Region, missing the RTO requirement. Option D with snapshot-based replication cannot achieve sub-minute RPO.

---

### Question 9
**Correct Answer:** B

**Explanation:** AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs. By creating a custom key store in AWS KMS backed by CloudHSM, the encryption keys are generated and stored in the Level 3 HSMs while still being usable with AWS services that integrate with KMS (S3, EBS, RDS, Redshift). Standard AWS KMS uses FIPS 140-2 Level 2 (not Level 3) validated HSMs. Importing key material into KMS means the key material is still used within KMS's Level 2 HSMs. Secrets Manager doesn't provide direct FIPS 140-2 Level 3 HSM key storage for encryption operations.

---

### Question 10
**Correct Answer:** B

**Explanation:** AWS Glue DataBrew provides built-in PII detection and redaction recipe steps that can automatically identify and transform sensitive data fields. Storing de-identified output in a separate S3 bucket with S3 Access Points allows fine-grained, per-partner access policies. This approach keeps raw and de-identified data strictly separated and provides scalable, partner-specific access control. While Amazon Macie can detect PII, it doesn't perform redaction. Redshift SQL masking (Option C) doesn't provide the same level of automated PII detection across unstructured data formats common in clinical trials.

---

### Question 11
**Correct Answer:** B

**Explanation:** GuardDuty natively integrates with Amazon EventBridge, which is the recommended pattern for automated response workflows. AWS Step Functions orchestrates multiple parallel actions (security group replacement, EBS snapshot creation, metadata capture, notification) reliably and with built-in error handling, retry logic, and execution tracking. Option A uses SNS as an intermediary, which adds unnecessary complexity and lacks orchestration capabilities for parallel actions. Option C uses S3 as an intermediary, which introduces latency. Option D relies on CloudWatch Alarms, but GuardDuty findings are events, not metrics, making EventBridge the proper integration point.

---

### Question 12
**Correct Answer:** B

**Explanation:** CloudTrail data events for S3 provide a complete audit trail of all API-level access to the claims data bucket. CloudTrail log file validation creates a digitally signed hash chain that proves logs have not been tampered with, satisfying the auditor's integrity requirement. S3 Object Lock in Compliance mode with a 3-year retention period ensures that no one, including the root account user, can delete or modify the log files during the retention period. S3 server access logging (Options A and C) does not provide the same level of detail or integrity validation as CloudTrail data events. CloudWatch Logs retention (Option D) does not provide the same tamper-proof guarantees as S3 Object Lock.

---

### Question 13
**Correct Answer:** A, D

**Explanation:** Creating KMS CMKs in a centralized security account with key policies granting usage permissions to the production account follows the principle of centralized key management while enabling cross-account encryption operations. KMS grants provide additional flexibility for temporary access. Cross-account IAM roles in the production account with SCPs blocking the development account ensure tight access control between environments. Option B is incorrect because SCPs cannot restrict key management actions within a specific account to only certain accounts' roles. Option E is incorrect because Secrets Manager is for storing secrets, not managing encryption keys used by AWS services.

---

### Question 14
**Correct Answer:** A

**Explanation:** S3 Standard provides immediate access for the first 90 days. The lifecycle policy to S3 Glacier Flexible Retrieval provides retrieval within 3-12 hours, meeting the 12-hour requirement. SSE-KMS encryption satisfies the encryption requirement with customer key control. S3 Object Lock in Compliance mode ensures that images cannot be deleted for the 10-year regulatory retention period, even by the root account. S3 Glacier Deep Archive (Option B) has retrieval times up to 48 hours, which exceeds the 12-hour requirement. S3 Intelligent-Tiering (Option D) does not guarantee archival retrieval within 12 hours, and MFA Delete does not provide the same protection as Object Lock in Compliance mode.

---

### Question 15
**Correct Answer:** B

**Explanation:** AWS App Mesh with Envoy sidecar proxies provides a service mesh that handles mTLS between services transparently. AWS Private CA automates certificate issuance, renewal, and revocation, minimizing certificate management overhead. The Envoy sidecar handles TLS termination and mutual authentication without requiring application code changes. Option A terminates TLS at the ALB, meaning traffic between the ALB and ECS tasks would be unencrypted. Option C requires manual certificate management, which is operationally burdensome. Option D's TLS passthrough does not provide mTLS between services.

---

### Question 16
**Correct Answer:** D

**Explanation:** Creating regional S3 buckets with application-level routing ensures data residency compliance (GDPR requires EU data to stay in the EU). Using Amazon Athena with federated queries allows global reporting across both regional buckets without replicating data, which would violate data residency requirements. Option A's Cross-Region Replication would copy EU data to us-east-1, violating GDPR. Option B's Multi-Region Access Point could potentially route reads across Regions. Option C's single bucket in us-east-1 violates the EU data residency requirement entirely.

---

### Question 17
**Correct Answer:** B

**Explanation:** Amazon RDS for SQL Server with Multi-AZ provides automatic failover typically within 60 seconds using synchronous standby replication. As a managed service, RDS handles patching, backups, and maintenance automatically. SSE-KMS encryption meets PCI DSS encryption requirements. Option A requires managing EC2 instances, OS patching, and database administration. Option C also requires managing EC2 instances. Option D uses Aurora PostgreSQL with Babelfish, which may not have full SQL Server compatibility for all legacy banking application features and introduces migration risk.

---

### Question 18
**Correct Answer:** B

**Explanation:** Amazon Macie is purpose-built for discovering and protecting sensitive data in S3. It uses machine learning and pattern matching to automatically identify PII and PHI. Integration with AWS Security Hub provides centralized visibility, and EventBridge rules enable automated alerting when sensitive data is found in misconfigured buckets. This requires minimal operational effort compared to building custom Lambda functions with Textract (Option A) or combining Config and Comprehend (Option C). GuardDuty (Option D) monitors for threats, not data classification.

---

### Question 19
**Correct Answer:** A

**Explanation:** Deploying the application in private subnets with a private ALB ensures the application is not accessible from the public internet. A Route 53 private hosted zone enables DNS resolution only within the VPC. Direct Connect with a private virtual interface provides dedicated, private connectivity from the office network to the VPC without traversing the internet. Option B places resources in a public subnet with an internet-facing ALB, which violates the requirement. Option C uses Amplify and CloudFront, which are public-facing services. Option D uses Client VPN, which is unnecessary when Direct Connect is already available.

---

### Question 20
**Correct Answer:** B

**Explanation:** AWS Lake Formation provides centralized data governance with fine-grained access control through tag-based access control (TBAC). By tagging data with hospital identifiers, Lake Formation can enforce that each hospital's data scientists only access their own data. This is simpler to manage than maintaining individual IAM policies per hospital (Option A), separate accounts per hospital (Option C), or running a separate Redshift cluster (Option D). Lake Formation integrates natively with Athena, providing seamless query access with enforced permissions.

---

### Question 21
**Correct Answer:** A, C

**Explanation:** Amazon Inspector provides continuous, automated vulnerability scanning of EC2 instances and publishes findings to Security Hub for centralized visibility. AWS Systems Manager Patch Manager automates the patching process with configurable patch baselines and maintenance windows, enabling the company to meet the 48-hour patching requirement for critical vulnerabilities. Trusted Advisor (Option B) performs limited security checks, not comprehensive vulnerability scanning. Config rules checking AMI versions (Option D) would cause unnecessary disruption by terminating instances. GuardDuty (Option E) detects threats, not software vulnerabilities.

---

### Question 22
**Correct Answer:** A

**Explanation:** AWS Config with conformance packs provides pre-built compliance templates, including HIPAA-aligned rules. Config auto-remediation using Systems Manager Automation documents enables automatic correction of non-compliant resources without human intervention. This provides continuous monitoring and automated remediation in a single integrated solution. Option B requires custom Lambda development and hourly polling, which delays remediation. Audit Manager (Option C) is designed for audit evidence collection, not auto-remediation. Inspector (Option D) focuses on vulnerability assessment, not configuration compliance.

---

### Question 23
**Correct Answer:** B

**Explanation:** At 1 Gbps, transferring 500 TB would take approximately 46 days (500 TB / 1 Gbps), far exceeding the 2-week deadline. Multiple Snowball Edge Storage Optimized devices (each holding up to 80 TB usable) can transfer 500 TB in parallel by shipping devices. Snowball Edge provides hardware encryption using KMS keys, and data is ingested into S3 with SSE-KMS at the destination. This is the most practical solution for large-scale data migration within the time constraint. DataSync over Direct Connect (Option A) would exceed the 2-week window. Transfer Acceleration (Option D) over the internet would be even slower and less secure.

---

### Question 24
**Correct Answer:** A

**Explanation:** This architecture is fully serverless (API Gateway, Lambda, Kinesis, DynamoDB), minimizing operational overhead. Kinesis Data Streams handles real-time ingestion and enables sub-second processing latency. DynamoDB global tables provide multi-Region replication for 99.99% availability with built-in encryption. The two-Lambda pattern (ingest + process) separates concerns and enables independent scaling. Option B uses Fargate, which is not fully serverless in terms of cluster management. Option C's AWS Batch is designed for batch processing, not real-time data. Option D's S3-triggered processing introduces latency that may exceed 2 seconds.

---

### Question 25
**Correct Answer:** A

**Explanation:** IAM Access Analyzer can analyze CloudTrail logs to determine which permissions are actually used by IAM entities, then generate least-privilege policy recommendations. This data-driven approach ensures that permissions are right-sized based on actual usage, minimizing the risk of disrupting business operations. Option B would cause immediate and severe business disruption. Option C would also cause widespread disruption and is impractical for 50 accounts. Option D would require significant custom development to achieve what Access Analyzer provides as a managed service.

---

### Question 26
**Correct Answer:** A

**Explanation:** Amazon Cognito is a HIPAA-eligible managed service that provides user pools for authentication with built-in MFA support. Advanced security features provide adaptive authentication based on risk factors. Cognito identity pools issue temporary, scoped AWS credentials for accessing backend services. This eliminates the need to manage user credentials or MFA infrastructure. Option B requires managing EC2 instances and custom MFA implementation. Option C (IAM Identity Center) is designed for workforce identity, not customer identity. Option D requires managing LDAP infrastructure on EC2.

---

### Question 27
**Correct Answer:** A, B, C

**Explanation:** S3 server access logging and CloudTrail data events with log file validation (Option A) provide comprehensive auditing and integrity verification for all data access. VPC endpoints with restrictive policies and removal of internet gateways (Option B) prevent any data from leaving the VPC via the internet, addressing exfiltration concerns. GuardDuty with S3 protection (Option C) uses machine learning to detect anomalous access patterns that could indicate unauthorized exfiltration. Transfer Acceleration (Option D) is a performance feature, not a security control. Cross-Region Replication to a commercial Region (Option E) would move CUI data outside GovCloud, violating security requirements.

---

### Question 28
**Correct Answer:** A

**Explanation:** Amazon Kinesis Data Streams provides low-latency ingestion of high-volume transaction data. Kinesis Data Analytics with Apache Flink supports custom ML model execution in real time with sub-second processing latency, meeting the 500ms requirement. DynamoDB provides single-digit millisecond response times for storing flagged transactions. The entire pipeline supports encryption in transit and at rest. SQS FIFO (Option B) has lower throughput limits and Lambda cold starts could impact latency. EMR Spark Streaming (Option C) has higher processing latency. Amazon Comprehend (Option D) performs NLP, not fraud detection.

---

### Question 29
**Correct Answer:** B

**Explanation:** AWS Systems Manager Session Manager provides secure administrative access without requiring bastion hosts, SSH keys, or inbound ports. It natively supports MFA enforcement through IAM policies and provides comprehensive session logging to S3 and CloudWatch Logs. VPC endpoint policies restrict Session Manager access to the management VPC. This meets CMS security requirements for MFA, network restriction, and session recording. Option A doesn't provide session recording or restrict the management network. Option D (bastion host) requires additional management and has a public-facing attack surface.

---

### Question 30
**Correct Answer:** A, C

**Explanation:** S3 Object Lock in Compliance mode ensures that regulated records cannot be deleted or modified during the retention period, even by the root account, meeting FDA 21 CFR Part 11 requirements for tamper-proof storage. CloudTrail data events for S3 provide a comprehensive audit trail of all read/write operations with log file integrity validation, satisfying the audit trail requirement. Cross-Region Replication (Option B) with lifecycle delete is not an appropriate retention mechanism. Glacier Instant Retrieval (Option D) from day one would impair access to frequently used records. Root-only delete policies (Option E) don't prevent the root account from deleting objects.

---

### Question 31
**Correct Answer:** A

**Explanation:** AWS Secrets Manager is specifically designed for credential lifecycle management. It supports automatic rotation via Lambda rotation functions without requiring application downtime, as the application retrieves the latest secret at each container startup. RDS encryption at rest and enforced SSL connections protect PHI in transit and at rest. Option B requires manual ECS redeployment after rotation. Option C embeds credentials in code, which is a security anti-pattern. Option D (IAM database authentication) is a valid approach but has connection-per-second limits and requires specific PostgreSQL configuration that may not work for all application patterns.

---

### Question 32
**Correct Answer:** A, C

**Explanation:** AWS WAF with managed rule groups provides protection against OWASP Top 10 threats including SQL injection and XSS, with detailed logging for compliance. AWS Shield Advanced provides comprehensive DDoS protection with automatic application-layer mitigation, cost protection, and access to the Shield Response Team for proactive engagement during attacks. Shield Standard (Option B) provides basic DDoS protection but lacks the advanced features and proactive engagement. Inspector (Option D) scans for vulnerabilities in code, not real-time attack protection. GuardDuty (Option E) detects threats at the infrastructure level, not application-layer web attacks.

---

### Question 33
**Correct Answer:** B

**Explanation:** WorkSpaces provides granular access control settings to disable clipboard, file transfer, and printing redirection, preventing data exfiltration to local devices. IP access control groups restrict WorkSpaces access to specific IP ranges (corporate network). Certificate-based authentication ensures that only managed corporate devices with the appropriate certificate can connect. This comprehensive approach addresses HIPAA data loss prevention requirements. Option A enables clipboard and printing, which allows data exfiltration. Option C proposes a different service entirely. Option D's proxy approach is complex and may not catch all exfiltration vectors.

---

### Question 34
**Correct Answer:** C

**Explanation:** This architecture provides near real-time search capability through OpenSearch Service for the most recent 90 days of data. Kinesis Data Firehose provides a reliable pipeline for both real-time indexing and S3 archival. S3 lifecycle policies handle the transition to Glacier for cost-effective cold storage. Amazon Athena enables querying of archived logs for compliance audits. This combination balances real-time search needs with cost-effective long-term storage. Option A's CloudWatch Logs export to Glacier is not automated. Option B's OpenSearch-only approach is expensive for 7 years of data. Option D lacks real-time search capability.

---

### Question 35
**Correct Answer:** B

**Explanation:** Three separate VPCs provide the strongest network isolation between clinical, administrative, and guest environments. AWS Transit Gateway with separate route tables enables controlled, segmented routing between VPCs. AWS Network Firewall provides stateful inspection and logging of inter-VPC traffic, meeting HIPAA requirements for traffic monitoring. A NAT gateway in the clinical VPC provides outbound internet access for updates without inbound exposure. A single VPC with subnets (Option A) provides weaker isolation. VPC peering with full connectivity (Option D) violates segmentation principles.

---

### Question 36
**Correct Answer:** B

**Explanation:** AWS Audit Manager is purpose-built for compliance audit evidence collection and management. It provides pre-built frameworks for PCI DSS that automatically collect evidence from AWS Config, CloudTrail, and Security Hub. Evidence is organized by control and ready for auditor review, significantly reducing manual effort. Option A is entirely manual. Option C requires building custom dashboards. Option D involves managing a third-party tool.

---

### Question 37
**Correct Answer:** B

**Explanation:** Lambda and API Gateway automatically scale to handle 50x traffic surges without provisioning or capacity planning. DynamoDB on-demand capacity mode scales automatically and charges only for actual usage, controlling costs when demand returns to normal. S3 with SSE-KMS using a Region-restricted key ensures data stays in the designated Region. This serverless architecture scales seamlessly and costs scale down proportionally when demand decreases. Reserved Instances (Option A) would be wasteful at normal volumes. Spot Instances (Option C) may be interrupted during peak demand. ElastiCache (Option D) is not suitable as a primary database.

---

### Question 38
**Correct Answer:** A

**Explanation:** Separate AWS accounts per tenant provide the strongest isolation boundary, which is critical for HIPAA compliance across different hospital clients. AWS Organizations enables centralized management and governance. CodePipeline can deploy updates across all accounts simultaneously from a single codebase. Per-tenant encryption keys ensure cryptographic isolation. Options B and C share encryption keys or instances across tenants, which is insufficient for HIPAA data isolation between competing healthcare organizations. Option D is a reasonable approach but lacks the strong account-level isolation boundary.

---

### Question 39
**Correct Answer:** B

**Explanation:** DynamoDB does not natively support WORM (write-once-read-many) semantics. The solution writes records to DynamoDB for operational use while simultaneously exporting them to S3 via DynamoDB Streams and Lambda. S3 Object Lock in Compliance mode creates a truly immutable copy that cannot be modified or deleted by anyone, including the root account, for the 6-year retention period. SCP-based approaches (Option A) can be modified by the management account administrator. Condition expressions (Option C) can be bypassed by changing IAM policies. Disabling a KMS key (Option D) would make all data inaccessible, not just unmodifiable.

---

### Question 40
**Correct Answer:** C, D

**Explanation:** API Gateway endpoints in each hospital's account allow hospitals to maintain ownership of their data while enabling controlled access. The HIE's consent management service validates consent before making API calls. API Gateway access logging and CloudTrail provide comprehensive audit trails. AWS PrivateLink (Option D) provides private connectivity between the HIE and hospital accounts without traversing the internet, enhancing security. Combined, these solutions enable consent-verified, auditable data sharing while hospitals maintain data ownership. Option A centralizes data in the HIE's account, violating the ownership requirement. Option E replicates all data, which is unnecessary and violates ownership principles.

---

### Question 41
**Correct Answer:** B

**Explanation:** Creating a database view that exposes only approved columns is the simplest and most secure approach. The view acts as a logical access control layer at the database level. RDS Proxy provides connection management and an endpoint that can be restricted via security groups. This approach requires no data movement, no ETL processes, and no synchronization logic. Option A requires periodic refresh and risks stale data. Options C and D require ETL jobs and data synchronization, adding operational overhead and potential data consistency issues.

---

### Question 42
**Correct Answer:** A

**Explanation:** An RPO of 0 (zero data loss) requires synchronous replication, which is achieved through an active-active architecture with Aurora Global Database's write forwarding. S3 Replication Time Control ensures objects are replicated within 15 minutes. Route 53 active-active routing with health checks provides immediate failover. This architecture meets both the 5-minute RTO and zero RPO requirements. Warm standby (Option C) and pilot light (Option D) cannot achieve 5-minute RTO with zero RPO because Aurora read replicas use asynchronous replication. Option B's static S3 website cannot serve a dynamic patient monitoring application.

---

### Question 43
**Correct Answer:** A

**Explanation:** Deploying all tiers in private subnets ensures internal traffic stays private. NAT gateway provides outbound internet access for market data providers without inbound exposure. AWS Network Firewall provides deep packet inspection for outbound traffic, enabling data loss prevention (DLP) rules. VPC endpoints eliminate the need for internet access to reach AWS services. Option B puts some tiers in public subnets, exposing them. Option C's open-source proxy on EC2 requires manual management and may not provide enterprise-grade DLP. Option D's single public subnet and NACLs provide insufficient isolation and WAF doesn't inspect outbound traffic.

---

### Question 44
**Correct Answer:** A

**Explanation:** API Gateway provides a managed entry point for hospitals to submit data. Lambda functions can detect data formats (HL7, FHIR, CSV) and apply appropriate transformation logic, scaling automatically with variable volumes. S3 with SSE-KMS provides encrypted storage, and Glue crawlers automatically catalog the transformed data for Athena queries. This serverless architecture is cost-efficient for variable workloads. Amazon MQ with EC2 (Option B) requires managing infrastructure. EMR (Option C) is expensive for variable workloads. Kinesis Data Firehose (Option D) is optimized for streaming data, whereas hospital data submission is typically batch/API-based.

---

### Question 45
**Correct Answer:** B

**Explanation:** AWS Control Tower provides mandatory guardrails out of the box. Custom SCPs provide preventive controls that block non-compliant actions before they occur (e.g., deny creating unencrypted EBS volumes, deny public S3 bucket configurations, deny API calls outside approved Regions). SCPs applied at the OU level propagate automatically to all accounts in the OU, requiring minimal per-account configuration. Option A requires deploying Config rules and Lambda in each account individually. Options C and D provide detective controls but not preventive controls.

---

### Question 46
**Correct Answer:** B

**Explanation:** AWS PrivateLink enables private connectivity between VPCs without requiring VPC peering, VPN, or internet access. The payment processor creates a VPC endpoint service backed by a Network Load Balancer, and the bank creates an interface VPC endpoint to connect. Traffic stays on the AWS network and never traverses the public internet. VPC peering (Option A) requires coordinating CIDR ranges and opens broader network connectivity. Site-to-Site VPN (Option C) adds encryption overhead and complexity. Transit Gateway (Option D) provides broader connectivity than needed for a single service.

---

### Question 47
**Correct Answer:** B

**Explanation:** AWS Lake Formation's tag-based access control (TBAC) provides attribute-based access control at the data level. By tagging S3 objects with sensitivity classifications and assigning matching tags to users, Lake Formation automatically enforces that users can only access data at or below their clearance level. This is more scalable and manageable than separate buckets with individual IAM policies (Option A). Separate accounts (Option D) add excessive management overhead. DynamoDB fine-grained access (Option C) doesn't apply to S3-based data storage.

---

### Question 48
**Correct Answer:** A, B

**Explanation:** A consent management service using DynamoDB with TTL (Option A) provides a scalable, automated solution for tracking and expiring consent. Integration with Step Functions ensures no data is processed without consent, meeting GDPR's lawful basis requirement. Pseudonymization via tokenization with Lambda on Kinesis Data Streams (Option B) separates identifying information from analytics data while maintaining referential integrity through consistent tokenization. The secure token-to-identity mapping supports re-identification when legally required. Redshift data sharing (Option C) doesn't address consent tracking. Amazon Personalize (Option D) is not a general-purpose GDPR compliance tool.

---

### Question 49
**Correct Answer:** A

**Explanation:** AWS Backup provides a centralized, fully managed backup service that supports multiple AWS services. A single backup plan with two rules (daily and weekly) with different retention periods satisfies the backup frequency and retention requirements. Cross-Region backup copy rules automate the storage of backups in a different Region. KMS encryption on the backup vault ensures HIPAA compliance. This requires minimal operational effort compared to custom Lambda functions (Option B), manual per-service configuration (Option C), or EC2-based backup scripts (Option D).

---

### Question 50
**Correct Answer:** A

**Explanation:** Amazon Cognito user pools handle authentication with built-in MFA and support custom Lambda triggers for biometric verification. Cognito identity pools provide temporary, scoped AWS credentials. DynamoDB fine-grained access control using the Cognito identity sub as a condition variable ensures each user can only access their own records. This is a fully managed, scalable solution. IAM Identity Center (Option B) is for workforce identity, not customer-facing apps. Long-lived access keys (Option C) are a security anti-pattern. SAML 2.0 federation (Option D) is complex and doesn't provide per-user DynamoDB record isolation.

---

### Question 51
**Correct Answer:** A

**Explanation:** EC2 Image Builder with CIS benchmark hardening components creates a standardized, compliant base AMI. Patch Manager with custom baselines and auto-approval rules ensures critical patches are applied within the required 72-hour window. State Manager provides continuous drift detection and remediation against the CIS configuration baseline. This creates a comprehensive lifecycle from AMI creation through ongoing compliance maintenance. Options B and C would cause disruption by terminating or replacing instances. Option D relies on external tooling and doesn't provide the same level of AWS integration.

---

### Question 52
**Correct Answer:** A

**Explanation:** API Gateway with Lambda provides automatic scaling to hundreds of thousands of requests per second. DynamoDB with DAX provides single-digit millisecond read latency, meeting the 100ms response time requirement. A custom Lambda authorizer enables fine-grained access control that checks both provider identity and patient consent status before granting access to data. DynamoDB encryption at rest and API Gateway TLS provide encryption requirements. Option B's Aurora may struggle with the latency requirement under peak load. Option C's Redis as a primary store lacks durability. Option D's AppSync with API keys doesn't support the required fine-grained authorization model.

---

### Question 53
**Correct Answer:** A

**Explanation:** S3 Object Lock in Compliance mode provides true WORM storage that cannot be overridden by any user. Dynamic per-object retention settings allow different retention periods per case. S3 Versioning ensures no data is lost. CloudTrail data events and S3 server access logging in a separate locked bucket provide a tamper-proof chain of custody record. S3 scales to handle files from kilobytes to terabytes seamlessly. EFS with Linux permissions (Option B) can be overridden by root users. Glacier Vault Lock (Option C) doesn't support object-level retention. FSx for Lustre (Option D) is designed for high-performance computing, not long-term archival.

---

### Question 54
**Correct Answer:** A

**Explanation:** DynamoDB global tables provide multi-Region replication with eventual consistency, supporting global data availability. Application-level routing ensures European customer data is written exclusively to eu-west-1, satisfying data sovereignty requirements. Route 53 geolocation routing directs users to the nearest Region for low latency. This approach balances global availability with data sovereignty. A single Region with CloudFront (Option B) doesn't provide the required multi-Region deployment. Aurora Global Database (Option C) has a single write Region, which doesn't address data sovereignty for EU writes. ElastiCache Global Datastore (Option D) is for session data only and S3 CRR would replicate EU data to other Regions.

---

### Question 55
**Correct Answer:** A

**Explanation:** AWS IoT Core is purpose-built for managing millions of IoT devices with secure, bidirectional communication. The IoT Rules Engine routes telemetry to Kinesis Data Streams for real-time processing. Kinesis Data Analytics' RANDOM_CUT_FOREST function provides built-in anomaly detection without training a custom ML model. SNS enables immediate alerts to healthcare providers. S3 with SSE-KMS provides long-term encrypted storage for regulatory retention. API Gateway (Option B) isn't designed for device-scale IoT. Scheduled Lambda (Option C) isn't real-time. Local-only processing (Option D) doesn't provide centralized monitoring or cloud-scale analytics.

---

### Question 56
**Correct Answer:** B

**Explanation:** An API Gateway with Lambda functions in the state agency's account provides a controlled access layer where jurisdiction-based filtering can be enforced programmatically. The Lambda function verifies the caller's identity and returns only cases for their jurisdiction. API Gateway access logging and CloudTrail provide comprehensive audit trails. This approach is centralized, secure, and auditable. Cross-account Aurora cloning (Option A) creates full database copies, which is wasteful and harder to secure. Direct database sharing via RAM (Option C) with RLS is possible but exposing Aurora directly to external accounts increases the attack surface. Nightly S3 exports (Option D) introduce data staleness.

---

### Question 57
**Correct Answer:** A

**Explanation:** Enabling EBS encryption by default prevents future unencrypted volumes. The AWS Config rule provides continuous detection of existing unencrypted volumes. The Systems Manager Automation document provides automated remediation by creating an encrypted snapshot, creating a new encrypted volume, and performing a volume swap. While this requires a brief instance stop, it's automated and systematic. Option B is manual. Option C's SCP and instance termination is disruptive. Option D is incorrect because EBS encryption cannot be changed in-place without creating a new volume from an encrypted snapshot.

---

### Question 58
**Correct Answer:** A

**Explanation:** AWS Secrets Manager in a centralized account provides a single management plane for all secrets. Resource-based policies enable cross-account access without deploying Secrets Manager in every account. Built-in automatic rotation supports common database engines and custom Lambda functions for other secret types. CloudTrail automatically logs all API calls for auditing. This approach minimizes operational complexity compared to managing HashiCorp Vault (Option B), synchronizing Parameter Store across accounts (Option C), or building custom solutions (Option D).

---

### Question 59
**Correct Answer:** A

**Explanation:** AWS Glue ETL with custom PySpark scripts provides the flexibility to implement HIPAA Safe Harbor's specific 18-identifier removal rules at scale. Deterministic tokenization (format-preserving encryption) replaces identifiers with consistent pseudonyms, ensuring that the same patient identifier produces the same token across different datasets, maintaining referential integrity for research. S3 with SSE-KMS provides encrypted storage. Comprehend Medical (Option B) detects PHI but simple redaction with placeholder text breaks referential integrity. Lambda per-record processing (Option C) doesn't scale to 10 million records efficiently. Macie (Option D) detects PII but doesn't perform de-identification.

---

### Question 60
**Correct Answer:** A, B

**Explanation:** S3 Object Lock in Compliance mode with versioning ensures that even with compromised credentials, data cannot be deleted or encrypted by ransomware during the retention period. Storing backups in a completely separate AWS account with no cross-account trust eliminates the risk of compromised credentials reaching backup data. AWS Backup Vault Lock makes backup copies immutable. GuardDuty with malware protection (Option B) provides real-time detection of ransomware activity and automated quarantine of compromised resources. Shield Advanced (Option C) protects against DDoS, not ransomware. Increased EBS size (Option D) does not protect against ransomware.

---

### Question 61
**Correct Answer:** A, B

**Explanation:** An SCP that denies rds:CreateDBInstance without encryption provides a preventive control that blocks non-compliant instance creation at the organization level. The AWS Config rule provides a detective control that identifies any existing or somehow-created unencrypted instances and triggers SNS notifications. Together, these provide defense in depth with both preventive and detective controls. Option C is overly restrictive and creates a bottleneck. Option D (Security Hub) provides detective controls but doesn't prevent non-compliant creation. Option E (Inspector) scans for vulnerabilities, not encryption compliance of RDS instances.

---

### Question 62
**Correct Answer:** B

**Explanation:** AWS Batch is purpose-built for batch processing workloads with variable volumes. It automatically manages compute resources, launches Spot Instances for cost savings (up to 90% discount) with On-Demand fallback for availability. Job definitions specify exact CPU and memory requirements. AWS Batch handles job scheduling, queuing, and retry logic. S3 with SSE-KMS and IAM roles provide security and access control. Option A requires managing Auto Scaling configuration manually. Option C (Fargate) supports a maximum of 16 vCPUs per task, far below the 96 vCPU requirement. Option D (EMR/Spark) adds unnecessary complexity for a straightforward batch processing workload.

---

### Question 63
**Correct Answer:** A

**Explanation:** IAM tag-based conditions provide native ABAC in AWS. Tagging S3 objects with SecurityClassification and IAM roles with ClearanceLevel enables policies that dynamically compare these attributes. This approach scales across accounts via AWS Organizations and doesn't require maintaining explicit role-to-bucket mappings. The aws:PrincipalTag and s3:ExistingObjectTag condition keys enable comparison-based access decisions. Separate buckets (Option B) require managing access lists per bucket. Cognito (Option C) is designed for customer identity, not government classification systems. Verified Access (Option D) is designed for application access, not S3 object-level access control.

---

### Question 64
**Correct Answer:** B

**Explanation:** Kinesis Data Streams provides real-time ingestion of claim data. SageMaker enables training custom ML models on historical claims data that can learn complex fraud patterns including unusual billing amounts, impossible diagnosis-procedure combinations, and provider anomalies. Real-time endpoints provide low-latency predictions for each incoming claim. This approach detects sophisticated patterns that rule-based systems would miss. Athena hourly queries (Option A) are not near real-time. Redshift nightly batches (Option C) introduce unacceptable delays. Amazon Fraud Detector (Option D) is a viable option but SageMaker provides more flexibility for the complex domain-specific patterns described in the requirements.

---

### Question 65
**Correct Answer:** A, B, C

**Explanation:** GuardDuty (Option A) provides comprehensive threat detection across all accounts and Regions with ML-based anomaly detection covering multiple attack surfaces. Security Hub (Option B) aggregates findings from GuardDuty, Inspector, Macie, and Config, providing a single pane of glass for compliance monitoring and security findings with built-in standards. Amazon Detective (Option C) provides investigation and root cause analysis capabilities that help the security team efficiently investigate findings from GuardDuty and Security Hub. These three services form AWS's recommended security monitoring stack. A third-party SIEM per Region (Option D) adds enormous operational overhead. CloudTrail Lake (Option E) provides event querying but doesn't detect threats or provide investigation tools. Macie (Option F) discovers sensitive data in S3, not EC2 threats.
