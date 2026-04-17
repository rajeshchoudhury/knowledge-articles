# Secrets Manager, SSM & Certificate Manager

## Table of Contents

1. [AWS Secrets Manager](#aws-secrets-manager)
2. [AWS Systems Manager (SSM) Overview](#aws-systems-manager-ssm-overview)
3. [SSM Parameter Store](#ssm-parameter-store)
4. [SSM Session Manager](#ssm-session-manager)
5. [SSM Run Command](#ssm-run-command)
6. [SSM Patch Manager](#ssm-patch-manager)
7. [SSM State Manager](#ssm-state-manager)
8. [SSM Automation](#ssm-automation)
9. [SSM OpsCenter](#ssm-opscenter)
10. [SSM Inventory](#ssm-inventory)
11. [SSM Distributor](#ssm-distributor)
12. [AWS Certificate Manager (ACM)](#aws-certificate-manager-acm)
13. [ACM Private Certificate Authority](#acm-private-certificate-authority)
14. [Comparison: Secrets Manager vs Parameter Store vs Environment Variables](#comparison-secrets-manager-vs-parameter-store-vs-environment-variables)
15. [Common Exam Scenarios](#common-exam-scenarios)

---

## AWS Secrets Manager

### Overview

AWS Secrets Manager helps you manage, retrieve, and rotate database credentials, API keys, and other secrets throughout their lifecycle. Unlike SSM Parameter Store (which can also store secrets), Secrets Manager is purpose-built for secret management with **native rotation capabilities**.

### Secret Creation and Storage

**What Can Be Stored:**
- Database credentials (username/password)
- API keys and tokens
- SSH keys
- Arbitrary text or binary data (up to **65,536 bytes** per secret)
- JSON key-value pairs (most common format for structured secrets)

**Secret Structure:**
```json
{
  "username": "admin",
  "password": "MyS3cur3P@ssw0rd!",
  "engine": "mysql",
  "host": "mydb.cluster-xyz.us-east-1.rds.amazonaws.com",
  "port": 3306,
  "dbname": "myapp"
}
```

**Encryption:**
- All secrets are encrypted at rest using **AWS KMS**
- Default: AWS managed key (`aws/secretsmanager`)
- Option: Customer managed KMS key (CMK) — required for cross-account access
- Encryption in transit via HTTPS (TLS)

**Versioning:**
- Every secret has version stages: `AWSCURRENT` (current value), `AWSPREVIOUS` (previous value), `AWSPENDING` (during rotation)
- Automatic versioning during rotation
- Can retrieve by version stage or version ID

### Secret Rotation

Rotation is the most important feature that differentiates Secrets Manager from Parameter Store.

**How Rotation Works:**
1. **createSecret**: Lambda creates a new version of the secret (`AWSPENDING`)
2. **setSecret**: Lambda sets the new credential in the database
3. **testSecret**: Lambda tests the new credential works
4. **finishSecret**: Lambda moves `AWSCURRENT` label to the new version, old version becomes `AWSPREVIOUS`

**Rotation Lambda Function:**
- Secrets Manager provides **pre-built rotation Lambda functions** for supported databases
- Functions are deployed in your account via AWS SAR (Serverless Application Repository) or CloudFormation
- Lambda must have network access to the database (same VPC, security groups, NAT Gateway for Secrets Manager API calls)
- Lambda needs IAM permissions to access the secret and the KMS key

#### Automatic Rotation for Supported Services

| Service | Rotation Strategy | Notes |
|---------|-------------------|-------|
| **Amazon RDS** (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server) | Single-user or Multi-user | Native integration, pre-built Lambda functions |
| **Amazon Aurora** | Single-user or Multi-user | Same as RDS |
| **Amazon Redshift** | Single-user or Multi-user | Pre-built Lambda functions |
| **Amazon DocumentDB** | Single-user or Multi-user | Pre-built Lambda functions |

**Rotation Strategies:**

**Single-User Rotation:**
- Updates the password for a single database user
- Brief period of unavailability during password change (between setSecret and finishSecret)
- Simpler to set up
- Risk: Applications using old credentials fail until they fetch the new secret

**Multi-User Rotation (Alternating Users):**
- Uses TWO database users (e.g., `app_user` and `app_user_clone`)
- While one is being rotated, the other serves active requests
- **Zero downtime** — no period where credentials are invalid
- Requires a **master secret** (superuser) to update the alternate user's password
- More complex but recommended for production

**Rotation Schedule:**
- Configure rotation interval (minimum 4 hours, maximum 365 days)
- Schedule expression: `rate(30 days)` or cron expression
- Automatic rotation invokes the Lambda function on schedule
- Can also trigger immediate rotation manually

### Multi-Region Replication

Secrets Manager supports replicating secrets to multiple AWS regions:

- **Replica secrets** are read-only copies kept in sync with the primary
- Replicas have the same secret value but different ARNs
- If the primary region fails, you can **promote a replica to standalone** in another region
- Use case: Multi-region applications that need local access to secrets
- Use case: Disaster recovery — promote replica in DR region
- Replicas use the same KMS key type but can use different KMS keys per region

### Resource Policy

Secrets can have **resource-based policies** (similar to S3 bucket policies):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:role/AppRole"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
```

**Use Cases for Resource Policies:**
- Cross-account access: Allow another AWS account to access the secret
- Restrict access to specific VPC endpoints
- Enforce encryption with specific KMS keys
- Deny access from specific principals

**Cross-Account Access Requirements:**
1. Resource policy on the secret allowing the other account
2. IAM policy in the other account allowing the user/role to access the secret
3. If using a CMK, the KMS key policy must also allow the other account

### Pricing

| Component | Cost |
|-----------|------|
| **Secret storage** | $0.40 per secret per month |
| **API calls** | $0.05 per 10,000 API calls |
| **Rotation Lambda** | Standard Lambda pricing (invocations, duration) |
| **Replication** | $0.40 per replica per month (same as primary) |

**Key Pricing Notes:**
- Secrets marked for deletion (7–30 day waiting period) are NOT charged
- No charge for secrets created by other AWS services (e.g., RDS master password managed by RDS)
- Lambda rotation costs are separate standard Lambda charges

---

## AWS Systems Manager (SSM) Overview

### What is Systems Manager?

AWS Systems Manager is a comprehensive **operations management** service that provides a unified interface for viewing and managing AWS resources. It's a collection of capabilities (features) organized into categories:

**Operations Management:**
- Explorer, OpsCenter, Incident Manager, CloudWatch Dashboard

**Application Management:**
- Application Manager, AppConfig, Parameter Store

**Change Management:**
- Change Manager, Automation, Change Calendar, Maintenance Windows

**Node Management:**
- Fleet Manager, Compliance, Inventory, Session Manager, Run Command, State Manager, Patch Manager, Distributor

### SSM Agent

The **SSM Agent** is the software component that runs on EC2 instances and on-premises servers, enabling Systems Manager to manage them:

- **Pre-installed** on many AMIs (Amazon Linux 2, Ubuntu 16.04+, Windows Server 2016+)
- Must be installed manually on older/custom AMIs and on-premises servers
- Requires an **IAM instance profile** with the managed policy `AmazonSSMManagedInstanceCore`
- Communicates with SSM service endpoints over HTTPS (port 443)
- For instances in private subnets: requires NAT Gateway, VPC endpoint for SSM, or Systems Manager interface endpoints

**Managed Instances:**
- EC2 instances with SSM Agent running and proper IAM role
- On-premises servers registered with SSM (Hybrid Activations)
- Edge devices (IoT Greengrass core devices)

---

## SSM Parameter Store

### Overview

SSM Parameter Store provides secure, hierarchical storage for configuration data and secrets management. It can store data such as passwords, database strings, AMI IDs, and license codes as parameter values.

### Parameter Types

| Type | Description | Example |
|------|-------------|---------|
| **String** | Any string value | `"us-east-1"`, `"ami-12345678"` |
| **StringList** | Comma-separated list of strings | `"us-east-1,us-west-2,eu-west-1"` |
| **SecureString** | String encrypted with KMS | Database passwords, API keys |

**SecureString Details:**
- Encrypted using AWS KMS (default key `aws/ssm` or customer managed CMK)
- Decrypted when retrieved with `GetParameter` API using `WithDecryption=true`
- Supports cross-account decryption if using a customer managed CMK with proper key policy

### Parameter Tiers

| Feature | Standard | Advanced |
|---------|----------|----------|
| **Max parameters per account/region** | 10,000 | 100,000 |
| **Max parameter value size** | 4 KB | 8 KB |
| **Parameter policies** | No | Yes |
| **Cost** | Free | $0.05 per advanced parameter per month |
| **Higher throughput** | No (default 40 TPS, adjustable to 1,000) | Yes (default 1,000 TPS, adjustable to 10,000) |

### Parameter Hierarchies

Parameters are organized in a hierarchical path structure using forward slashes:

```
/myapp/prod/db/host          → "prod-db.example.com"
/myapp/prod/db/port          → "3306"
/myapp/prod/db/password      → (SecureString) "encrypted-password"
/myapp/staging/db/host       → "staging-db.example.com"
/myapp/staging/db/port       → "3306"
/myapp/staging/db/password   → (SecureString) "encrypted-password"
```

**Benefits of Hierarchies:**
- `GetParametersByPath` API retrieves all parameters under a path (e.g., `/myapp/prod/`)
- IAM policies can restrict access by path (e.g., allow access to `/myapp/prod/*` but not `/myapp/staging/*`)
- Organize by application, environment, service
- Maximum hierarchy depth: 15 levels

**Public Parameters:**
- AWS publishes public parameters for official AMI IDs, service endpoints, and region information
- Example: `/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2` returns the latest Amazon Linux 2 AMI ID

### Parameter Policies (Advanced Tier Only)

Parameter policies allow you to assign lifecycle management to parameters:

**Expiration Policy:**
```json
{
  "Type": "Expiration",
  "Version": "1.0",
  "Attributes": {
    "Timestamp": "2025-12-31T23:59:59.000Z"
  }
}
```
- Parameter is automatically deleted after the specified date
- EventBridge notification before expiration (15 days, 5 days, 1 day by default)

**ExpirationNotification Policy:**
```json
{
  "Type": "ExpirationNotification",
  "Version": "1.0",
  "Attributes": {
    "Before": "15",
    "Unit": "Days"
  }
}
```
- Sends notification via EventBridge before expiration

**NoChangeNotification Policy:**
```json
{
  "Type": "NoChangeNotification",
  "Version": "1.0",
  "Attributes": {
    "After": "30",
    "Unit": "Days"
  }
}
```
- Alerts if a parameter hasn't been updated for a specified period
- Use case: Ensure credentials are rotated regularly

### Integration Points

- **CloudFormation**: Reference parameters in templates using `{{resolve:ssm:/path/to/param}}`
- **ECS**: Task definition can reference SSM parameters
- **Lambda**: Environment variables can reference SSM parameters
- **CodeDeploy/CodePipeline**: Retrieve configuration during deployments
- **EC2 Run Command**: Use parameters in commands
- **EventBridge**: React to parameter changes

---

## SSM Session Manager

### Overview

Session Manager provides **secure, auditable shell access** to EC2 instances and on-premises servers **without opening inbound ports**, managing SSH keys, or using bastion hosts.

### How It Works

1. User initiates a session through the AWS Console, CLI (`aws ssm start-session`), or SDK
2. SSM Agent on the target instance establishes an outbound HTTPS connection to the SSM service
3. A secure WebSocket connection is established between the user's browser/CLI and the instance
4. All session data is encrypted using **TLS 1.2**

### Key Features

**No Inbound Ports Required:**
- SSM Agent initiates outbound connections on port 443
- No need for SSH (port 22) or RDP (port 3389) in security groups
- No bastion hosts needed
- No SSH key management

**IAM-Based Access Control:**
- Control who can start sessions using IAM policies
- Restrict access to specific instances using tags or instance IDs
- Example: Allow developers to connect only to dev instances

**Session Logging and Auditing:**

| Destination | What's Logged |
|-------------|---------------|
| **Amazon S3** | Full session output (commands and responses) |
| **Amazon CloudWatch Logs** | Full session output, searchable |
| **AWS CloudTrail** | API calls (StartSession, TerminateSession, ResumeSession) |

**Additional Features:**
- **Port forwarding**: Forward ports from local machine to remote instance (e.g., RDP, database ports)
- **SSH over Session Manager**: Use Session Manager as a tunnel for SSH connections (useful for SCP file transfers)
- **Interactive commands**: Restrict which commands users can run (using SSM documents)
- **Idle timeout**: Automatically terminate sessions after inactivity
- **Max session duration**: Limit how long sessions can last
- **Run As**: Specify which OS user to start the session as (Linux)
- **Encryption**: Optional additional encryption with a customer managed KMS key (encrypts session data beyond TLS)

### Prerequisites

1. **SSM Agent** installed and running on the target instance
2. **IAM Instance Profile** with `AmazonSSMManagedInstanceCore` policy
3. **Network connectivity** to SSM endpoints (NAT Gateway, VPC endpoints, or public IP)
4. **IAM permissions** for the user to call `ssm:StartSession`

### VPC Endpoints for Session Manager

For instances in private subnets without internet access, create these VPC interface endpoints:
- `com.amazonaws.region.ssm`
- `com.amazonaws.region.ssmmessages` (required for Session Manager)
- `com.amazonaws.region.ec2messages` (required for Run Command)
- `com.amazonaws.region.s3` (Gateway endpoint, for S3 logging)
- `com.amazonaws.region.logs` (for CloudWatch Logs)
- `com.amazonaws.region.kms` (if using KMS encryption)

---

## SSM Run Command

### Overview

SSM Run Command lets you remotely execute commands on managed instances **without SSH or RDP**. It's designed for operational tasks at scale.

### How It Works

1. Define a **command document** (SSM Document) specifying what to run
2. Select **targets**: specific instances, tags, resource groups, or all instances
3. SSM service sends the command to SSM Agents on target instances
4. Agents execute the command and report results back

### Key Features

**Targeting:**
- By instance IDs (manual selection)
- By tags (e.g., `Environment=Production`)
- By resource group
- All managed instances

**Rate Control:**
- **Concurrency**: How many instances execute simultaneously (number or percentage)
  - Example: `10` or `25%` — run on 10 instances at a time or 25% at a time
- **Error threshold**: Stop execution if too many instances fail (number or percentage)
  - Example: Stop if 5 instances fail or if 10% of instances fail

**Pre-built Documents:**
- `AWS-RunShellScript` — Run shell commands on Linux
- `AWS-RunPowerShellScript` — Run PowerShell commands on Windows
- `AWS-RunPatchBaseline` — Apply patches
- `AWS-ConfigureAWSPackage` — Install/uninstall AWS packages
- `AWS-ApplyAnsiblePlaybooks` — Run Ansible playbooks
- `AWS-RunDocument` — Run another SSM document

**Output:**
- Console output viewable in the AWS Console
- Full output stored in **Amazon S3** (recommended for large outputs)
- Output sent to **CloudWatch Logs**
- **CloudTrail** logs the SendCommand API call

**Notifications:**
- SNS notifications for command status changes
- EventBridge events for command completion/failure

**Command Status Flow:**
```
Pending → In Progress → Success / Failed / Cancelled / Timed Out
```

### Key Exam Points

- No SSH/RDP required — uses SSM Agent
- Great for running operational commands at scale (install software, run scripts, collect diagnostics)
- Rate control prevents overwhelming all instances simultaneously
- Output can be large — always use S3 for production
- Integration with EventBridge for automation

---

## SSM Patch Manager

### Overview

SSM Patch Manager automates the process of **patching managed instances** with security-related updates and other types of updates for operating systems and applications.

### Key Concepts

#### Patch Baselines

A patch baseline defines which patches should be applied to instances:

**AWS Predefined Baselines (per OS):**
- `AWS-DefaultPatchBaseline` — Updates only critical and security patches for the OS
- `AWS-AmazonLinux2DefaultPatchBaseline` — Amazon Linux 2 specific
- `AWS-WindowsPredefinedPatchBaseline-OS` — Windows OS only
- `AWS-WindowsPredefinedPatchBaseline-OS-Applications` — Windows OS + Microsoft applications

**Custom Patch Baselines:**
- **Approval rules**: Auto-approve patches based on classification (Security, Bugfix, Enhancement), severity (Critical, Important, Medium, Low), and auto-approval delay (days after release)
- **Approved patches**: Explicitly approved patches (override approval rules)
- **Rejected patches**: Explicitly rejected patches (never install)
- **Patch sources**: Custom repositories for Linux instances
- **Compliance level**: Tag patches with compliance severity (Critical, High, Medium, Low, Informational, Unspecified)

#### Patch Groups

- Group instances for patching by assigning the tag key `Patch Group` (exact key name required)
- Each patch group is associated with one patch baseline
- An instance can belong to only one patch group
- Example: `Patch Group = Production`, `Patch Group = Development`

#### Maintenance Windows

Define recurring time windows when patching (and other operations) should occur:

- **Schedule**: Cron or rate expression (e.g., every Sunday at 2 AM)
- **Duration**: How long the window stays open (1–24 hours)
- **Cutoff**: Stop starting new tasks N hours before the window ends
- **Targets**: Instances or tags
- **Tasks**: Run Command, Automation, Lambda, Step Functions

### Patch Manager Workflow

1. Define **patch baselines** (which patches to apply)
2. Create **patch groups** (which instances to patch)
3. Set up **maintenance windows** (when to patch)
4. Patch Manager uses `AWS-RunPatchBaseline` document to scan and/or install patches
5. **Compliance results** reported back to SSM Compliance dashboard

**Scan vs Install:**
- **Scan**: Check compliance without installing patches
- **Install**: Scan and install missing patches (may require reboot)

### Key Exam Points

- Use **maintenance windows** to control when patching occurs
- **Patch groups** associate instances with baselines using tags
- `AWS-RunPatchBaseline` is the key document for both scanning and installing
- Compliance results visible in SSM Compliance and can trigger EventBridge rules
- Can patch both EC2 instances and on-premises managed instances

---

## SSM State Manager

### Overview

SSM State Manager is a configuration management service that automates the process of keeping your managed instances in a **defined and consistent state**.

### Key Concepts

**Associations:**
- An association defines the desired state for managed instances
- Specifies an SSM Document, targets, schedule, and parameters
- State Manager applies the configuration on a schedule or on-demand

**Common Use Cases:**
- Ensure antivirus software is installed and running
- Join instances to a domain
- Configure CloudWatch Agent
- Enforce security policies
- Bootstrap instances at launch

**Example Associations:**
- Run `AWS-ConfigureAWSPackage` to ensure the CloudWatch Agent is installed on all instances tagged `Monitoring=true`
- Run `AWS-ApplyDSCMof` to enforce desired state configuration on Windows instances
- Run a custom document to configure application settings every 30 minutes

**Schedule:**
- Cron expression or rate expression
- Apply immediately when association is created
- Reapply if configuration drifts

### Difference from Run Command

| Feature | Run Command | State Manager |
|---------|-------------|---------------|
| **Execution** | One-time (ad-hoc) | Recurring (scheduled) |
| **Purpose** | Execute task once | Maintain desired state |
| **Drift** | No drift detection | Reapplies configuration |
| **Compliance** | No tracking | Compliance status tracked |

---

## SSM Automation

### Overview

SSM Automation simplifies common maintenance and deployment tasks for AWS resources. It uses **runbooks** (Automation documents) that define a series of steps.

### Key Concepts

**Runbooks:**
- YAML or JSON documents defining automation steps
- **AWS pre-built runbooks**: 100+ for common tasks
- **Custom runbooks**: Create your own multi-step workflows
- Shareable across accounts and regions

**Common Pre-Built Runbooks:**
- `AWS-RestartEC2Instance` — Stop and start an EC2 instance
- `AWS-StopEC2Instance` — Stop an EC2 instance
- `AWS-CreateSnapshot` — Create an EBS snapshot
- `AWS-CreateImage` — Create an AMI from an instance
- `AWS-UpdateCloudFormationStack` — Update a CloudFormation stack
- `AWS-PatchInstanceWithRollback` — Patch instance with automatic rollback on failure
- `AWS-ConfigureS3BucketLogging` — Enable S3 bucket logging

**Step Types:**
- `aws:executeScript` — Run a Python or PowerShell script
- `aws:executeAwsApi` — Call any AWS API
- `aws:runCommand` — Execute an SSM Run Command
- `aws:createImage` — Create an AMI
- `aws:createStack` — Create a CloudFormation stack
- `aws:approve` — Pause and wait for manual approval
- `aws:branch` — Conditional branching
- `aws:sleep` — Pause for a specified time
- `aws:invokeLambdaFunction` — Invoke a Lambda function
- `aws:waitForAwsResourceProperty` — Wait until a resource reaches a desired state
- `aws:changeInstanceState` — Stop, start, or terminate instances

**Approval Workflows:**
- `aws:approve` step type pauses automation and waits for approval
- Specify approvers (IAM users, roles, or ARNs)
- Approval or rejection can be done via Console, CLI, or API
- Timeout for approval (default 7 days)

**Execution Modes:**
- **Simple execution**: Run against a single resource
- **Rate control**: Execute against multiple resources with concurrency and error thresholds
- **Multi-account and multi-region**: Execute runbooks across AWS Organizations
- **Manual execution**: Run from Console, CLI, or SDK
- **EventBridge triggered**: Automatically triggered by events (e.g., Config rule non-compliance)

### Key Exam Points

- Automation is for **multi-step workflows** with approval gates
- Use for remediation actions triggered by Config rules, Security Hub findings, or EventBridge events
- Example: Config detects non-compliant security group → EventBridge → SSM Automation runbook removes offending rule

---

## SSM OpsCenter

### Overview

SSM OpsCenter provides a central location to manage **operational issues** (OpsItems) related to AWS resources.

### Key Features

- **Aggregated view**: Single dashboard for operational issues from multiple sources
- **OpsItems**: Work items representing issues (created automatically or manually)
- **Sources**: CloudWatch Alarms, Config rule non-compliance, EventBridge events, Security Hub findings
- **Runbook integration**: Associate and run Automation runbooks directly from OpsItems
- **Cross-account**: View OpsItems across AWS Organizations
- **Deduplication**: Similar issues are grouped to reduce noise

### Use Case

When a CloudWatch Alarm fires for high CPU, OpsCenter can automatically create an OpsItem that includes:
- Related CloudWatch metrics and alarms
- Related AWS Config changes
- Suggested runbooks to remediate
- Timeline of events

---

## SSM Inventory

### Overview

SSM Inventory collects **metadata** about your managed instances and the software installed on them.

### Data Collected

| Type | Examples |
|------|----------|
| **Applications** | Installed applications, versions |
| **AWS Components** | SSM Agent version, AWS CLI version |
| **Files** | Specific files and their properties |
| **Network Configuration** | IP addresses, MAC addresses, DNS settings |
| **Windows Updates** | Installed Windows updates and patches |
| **Instance Details** | OS name, version, architecture |
| **Services** | Running services (Windows) |
| **Windows Roles** | Installed Windows roles and features |
| **Custom Inventory** | User-defined metadata |

### Key Features

- **Resource Data Sync**: Aggregate inventory data from multiple accounts and regions into a single **S3 bucket**
- **Query with Athena**: Use Athena to query inventory data in S3 using SQL
- **Built-in dashboards**: View inventory data in the SSM Console
- **Configuration compliance**: Compare collected inventory against expected configurations

---

## SSM Distributor

### Overview

SSM Distributor helps you **package and distribute software** to managed instances.

### Key Features

- **Package types**: AWS published packages (CloudWatch Agent, Inspector Agent, etc.) and custom packages
- **Install/Uninstall**: Deploy or remove software packages
- **Versioning**: Multiple versions of packages with install/uninstall scripts
- **Cross-platform**: Supports Linux, Windows, and macOS
- **Integration**: Works with State Manager for scheduled distribution

### Common Use Cases

- Deploy the CloudWatch Agent to all instances
- Distribute custom application packages
- Install security agents across the fleet

---

## AWS Certificate Manager (ACM)

### Overview

AWS Certificate Manager (ACM) handles the complexity of creating, storing, and renewing **public and private SSL/TLS certificates** for use with AWS services and connected resources.

### Public Certificates

**Requesting a Public Certificate:**

1. **Add domain names**: Fully qualified domain name (FQDN), e.g., `example.com`, `*.example.com` (wildcard)
2. **Choose validation method**: DNS or Email
3. **Validate ownership**: Prove you own/control the domain
4. **Certificate issued**: ACM issues the certificate after validation

**Validation Methods:**

| Method | How It Works | Recommended? |
|--------|-------------|--------------|
| **DNS Validation** | Add a CNAME record to your DNS. ACM checks the record exists. Works automatically with Route 53. | **Yes** — supports automatic renewal |
| **Email Validation** | ACM sends email to domain contacts (admin@, webmaster@, postmaster@, etc.). Click approval link. | No — manual process for each renewal |

**DNS Validation with Route 53:**
- ACM can automatically create the required CNAME record in Route 53
- One-time setup — renewal happens automatically
- Wildcard certificates: Only need ONE CNAME record for `*.example.com`

**Certificate Renewal:**
- AWS-issued certificates are valid for **13 months** (395 days)
- **Automatic renewal**: ACM attempts to renew DNS-validated certificates automatically (starting 60 days before expiration)
- Email-validated certificates require manual approval for renewal
- Renewal status visible in ACM console

### Importing Certificates

You can import third-party certificates into ACM:
- Must provide: Certificate body, private key, certificate chain
- **No automatic renewal** — you must reimport before expiration
- ACM sends expiration notifications via EventBridge (45 days, 30 days, 15 days, 7 days, 3 days, 1 day before)
- Cannot export imported certificates
- Useful for certificates from other CAs (DigiCert, Let's Encrypt, etc.)

### ACM Integration Points

ACM certificates can ONLY be used with specific AWS services:

| Service | Notes |
|---------|-------|
| **Elastic Load Balancer (ALB, NLB)** | Most common use case. TLS termination at the load balancer |
| **Amazon CloudFront** | Certificate MUST be in **us-east-1** for CloudFront. SNI or dedicated IP |
| **Amazon API Gateway** | Custom domain names for REST and HTTP APIs |
| **AWS Elastic Beanstalk** | Via the associated ALB |
| **AWS App Runner** | Custom domain HTTPS |
| **AWS CloudFormation** | Reference ACM certificates in templates |
| **AWS Nitro Enclaves** | For EC2 instances (special case — ACM for Nitro Enclaves) |

**Critical Exam Point:** ACM certificates **CANNOT** be installed directly on EC2 instances. For EC2, you must manage certificates yourself or use ACM for Nitro Enclaves (advanced use case). Use ALB in front of EC2 for ACM integration.

**Regional vs Global:**
- ACM certificates are **regional** — a certificate in us-east-1 cannot be used with an ALB in eu-west-1
- Exception: CloudFront is global but requires certificates in **us-east-1**
- To use the same domain across multiple regions, request a certificate in each region

### ALB with ACM — HTTPS Setup

```
Client --HTTPS--> ALB (TLS termination with ACM cert) --HTTP--> EC2 instances
```

- ALB terminates TLS using the ACM certificate
- Traffic between ALB and EC2 can be HTTP (within VPC) or HTTPS (end-to-end encryption)
- ALB can serve multiple domains using **SNI (Server Name Indication)**
- SNI allows multiple certificates on a single ALB listener

### NLB with ACM

- NLB supports TLS listeners for TLS termination
- Can also use TCP passthrough (no TLS termination) for end-to-end encryption
- For TLS termination: ACM certificate on NLB listener

---

## ACM Private Certificate Authority

### Overview

ACM Private CA enables you to create a **private certificate authority (CA)** hierarchy for issuing private TLS certificates within your organization.

### Use Cases

- **Internal services**: TLS encryption between microservices within a VPC
- **IoT devices**: Authenticate and encrypt IoT device communication
- **Code signing**: Sign code and documents
- **User authentication**: Client certificate authentication
- **Enterprise PKI**: Replace self-managed internal CA infrastructure

### Key Concepts

**Certificate Chain:**
```
Root CA (offline, most secure)
  └── Subordinate CA (issues end-entity certificates)
       └── End-entity certificates (server/client certificates)
```

- Root CA should be kept secure and used only to sign subordinate CAs
- Subordinate CAs issue the actual certificates used by applications
- Supports up to 5 levels of CA hierarchy

**Certificate Types:**
- End-entity certificates (servers, clients)
- Subordinate CA certificates
- Self-signed root CA certificates

### Features

- **Automatic renewal** for private certificates (via ACM)
- **CRL (Certificate Revocation List)**: Stored in S3, accessible via CloudFront
- **OCSP (Online Certificate Status Protocol)**: Real-time certificate status
- **CloudTrail auditing**: All certificate operations logged
- **Cross-account sharing**: Share CA across AWS accounts using RAM
- **Custom extensions**: Add custom extensions to certificates

### Pricing

- $400/month per CA (prorated)
- Certificate pricing tiers:
  - $0.75 per certificate (first 1,000/month)
  - Decreasing price at higher volumes

### Certificate Pinning Considerations

**What is Certificate Pinning?**
- Application stores the expected certificate (or public key) and compares it during TLS handshake
- If the certificate doesn't match, the connection is rejected
- Prevents man-in-the-middle attacks with forged certificates

**Considerations with ACM:**
- **Do NOT pin ACM-managed certificates** — ACM may renew with a different key pair
- If pinning is required, use imported certificates or ACM Private CA
- Pin the CA certificate (more stable) rather than the leaf certificate
- Mobile apps and IoT devices often use pinning — plan certificate management carefully

---

## Comparison: Secrets Manager vs Parameter Store vs Environment Variables

| Feature | Secrets Manager | Parameter Store (SecureString) | Environment Variables |
|---------|----------------|-------------------------------|----------------------|
| **Purpose** | Purpose-built for secrets | Configuration + secrets | Runtime configuration |
| **Rotation** | Built-in automatic rotation | No built-in rotation (use Lambda + EventBridge) | No rotation |
| **Max Size** | 65 KB | 4 KB (standard) / 8 KB (advanced) | OS-dependent (typically 32 KB total) |
| **Encryption** | Always encrypted (KMS) | Optional (SecureString uses KMS) | Not encrypted at rest |
| **Versioning** | Automatic (AWSCURRENT, AWSPREVIOUS) | Version numbers (1, 2, 3...) | No versioning |
| **Cross-Region** | Native replication | No native replication | No |
| **Pricing** | $0.40/secret/month + API calls | Free (standard) / $0.05/param/month (advanced) | Free |
| **Hierarchies** | No | Yes (/app/prod/db/password) | No |
| **Policies** | Resource policies | Parameter policies (advanced only) | No |
| **CloudFormation** | `{{resolve:secretsmanager:...}}` | `{{resolve:ssm:...}}` or `{{resolve:ssm-secure:...}}` | Direct reference |
| **Best For** | Database creds with rotation, cross-account secrets | App configuration, feature flags, non-rotating secrets | Simple, non-sensitive config |

### When to Use What

**Use Secrets Manager when:**
- You need **automatic rotation** of database credentials
- You need **multi-region replication** of secrets
- You're managing RDS, Aurora, Redshift, or DocumentDB passwords
- You need **cross-account secret sharing** with resource policies
- Budget allows $0.40/secret/month

**Use Parameter Store when:**
- You need **hierarchical configuration** management
- You want to store both secrets AND plain-text configuration
- You need **free** secret storage (standard tier)
- You don't need built-in rotation
- You want **AWS public parameters** (AMI IDs, etc.)
- You need **parameter policies** for lifecycle management

**Use Environment Variables when:**
- Configuration is simple, non-sensitive, and instance-specific
- Quick testing or development
- Configuration doesn't need to be shared across instances

---

## Common Exam Scenarios

### Scenario 1: Database Credential Rotation

**Question**: An application uses RDS MySQL and the security team requires database credentials to be rotated every 30 days automatically.

**Answer**: Use **AWS Secrets Manager** with automatic rotation enabled. Configure a rotation schedule of 30 days. Secrets Manager provides pre-built Lambda rotation functions for RDS MySQL. Use **multi-user rotation** strategy for zero-downtime. The application should call `GetSecretValue` API to always get the current credentials.

### Scenario 2: Store Configuration Across Environments

**Question**: An application needs to store different configuration values (database endpoints, feature flags, API URLs) for dev, staging, and production environments.

**Answer**: Use **SSM Parameter Store** with hierarchical organization:
- `/myapp/dev/db/endpoint`, `/myapp/prod/db/endpoint`
- Use IAM policies to restrict access by environment path
- Use `GetParametersByPath` API to retrieve all config for an environment
- Standard tier is free for up to 10,000 parameters

### Scenario 3: Secure Shell Access Without SSH

**Question**: A company wants to provide developers shell access to EC2 instances in private subnets without managing SSH keys or bastion hosts.

**Answer**: Use **SSM Session Manager**. Install SSM Agent (pre-installed on Amazon Linux 2), attach `AmazonSSMManagedInstanceCore` IAM role. Create VPC endpoints for SSM in the private subnet. Use IAM policies to control which developers can access which instances. Enable session logging to S3 and CloudWatch Logs for audit.

### Scenario 4: HTTPS for Application Behind ALB

**Question**: A web application needs HTTPS support. The domain is managed in Route 53.

**Answer**: Request a **public certificate in ACM** for the domain name. Use **DNS validation** — ACM automatically creates the CNAME record in Route 53. Attach the certificate to the **ALB HTTPS listener**. Set up HTTP to HTTPS redirect rule on ALB. ACM automatically renews the certificate.

### Scenario 5: CloudFront with Custom Domain HTTPS

**Question**: A CloudFront distribution needs to serve content over HTTPS with a custom domain.

**Answer**: Request an ACM certificate in **us-east-1** (required for CloudFront). Use DNS validation. Associate the certificate with the CloudFront distribution. Configure Route 53 alias record pointing to the CloudFront distribution. The certificate must be in us-east-1 regardless of where the origin is located.

### Scenario 6: Patch Management at Scale

**Question**: A company has 500 EC2 instances across production and development that need OS patches applied on different schedules.

**Answer**: Use **SSM Patch Manager**. Create custom **patch baselines** for each environment. Create **patch groups** using tags (e.g., `Patch Group = Production`, `Patch Group = Development`). Set up **maintenance windows**: production on Sunday 2 AM, development on Wednesday 10 PM. Use `AWS-RunPatchBaseline` document with Install operation. Monitor compliance in SSM Compliance dashboard.

### Scenario 7: Automated Remediation Workflow

**Question**: When AWS Config detects a security group with port 22 open to 0.0.0.0/0, it should automatically remove the rule.

**Answer**: Create an AWS Config rule to detect open port 22. Configure **SSM Automation** remediation with a runbook that calls `RevokeSecurityGroupIngress`. Set remediation to **automatic**. The workflow: Config detects non-compliance → triggers SSM Automation → runbook removes the offending security group rule.

### Scenario 8: Multi-Region Secret Access

**Question**: An application running in us-east-1 and eu-west-1 needs access to the same database credentials with low latency.

**Answer**: Create the secret in **Secrets Manager** in the primary region (us-east-1). Enable **multi-region replication** to eu-west-1. Each region's application reads from the local replica. If the primary region fails, promote the eu-west-1 replica to standalone.

### Scenario 9: Private TLS Between Microservices

**Question**: Microservices in a VPC need mutual TLS authentication for inter-service communication.

**Answer**: Create an **ACM Private CA** hierarchy (root CA + subordinate CA). Issue private certificates for each microservice. Use mutual TLS (mTLS) — each service presents its certificate and validates the peer's certificate. ACM Private CA handles automatic renewal. Cost: $400/month per CA.

### Scenario 10: Cross-Account Secret Access

**Question**: Account A has a database secret in Secrets Manager. An application in Account B needs to read this secret.

**Answer**: In Account A: Add a **resource policy** on the secret allowing Account B's role. Use a **customer managed KMS key** (not the default `aws/secretsmanager` key) and update the KMS key policy to allow Account B. In Account B: Add IAM policy allowing the role to call `secretsmanager:GetSecretValue` and `kms:Decrypt` on the key in Account A.

### Scenario 11: Ensuring Software is Always Installed

**Question**: The CloudWatch Agent must always be installed and running on all EC2 instances tagged `Monitoring=enabled`.

**Answer**: Use **SSM State Manager** with an association. Use the `AWS-ConfigureAWSPackage` document targeting instances with tag `Monitoring=enabled`. Set a schedule (e.g., every 30 minutes). State Manager ensures the agent is installed and reinstalls it if removed. Use SSM Distributor to manage the CloudWatch Agent package.

---

## Key Takeaways for the Exam

1. **Secrets Manager** = Database credential rotation (automatic, built-in), multi-region replication, $0.40/secret/month
2. **Parameter Store** = Free hierarchical configuration storage, SecureString for encrypted values, parameter policies (advanced tier)
3. **Secrets Manager rotation** uses Lambda functions; multi-user rotation provides zero downtime
4. **Session Manager** = Secure shell access without SSH, logging to S3/CloudWatch, IAM-based access control
5. **Run Command** = One-time ad-hoc commands at scale with rate control
6. **Patch Manager** = Patch baselines + patch groups + maintenance windows
7. **State Manager** = Maintain desired state on schedule (recurring Run Command)
8. **Automation** = Multi-step workflows with approval gates, runbooks for remediation
9. **ACM public certificates** = Free, auto-renewal with DNS validation, cannot be used directly on EC2
10. **ACM for CloudFront** must be in **us-east-1**
11. **ACM Private CA** = Internal PKI, $400/month per CA, mutual TLS
12. **Do NOT pin ACM certificates** — they may change on renewal
13. **SSM Agent** requires IAM instance profile and outbound HTTPS connectivity
