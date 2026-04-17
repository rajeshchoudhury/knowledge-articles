# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 11

**Focus Areas:** SCPs, IAM Policies, Cross-Account Patterns, VPC Design, Lambda, S3 Security
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

A multinational corporation has 300 AWS accounts organized under AWS Organizations with a nested OU structure: Root → Business Units → Environments (prod, staging, dev). The security team discovers that developers in dev accounts are creating IAM users with AdministratorAccess policies, which violates company policy. They need to prevent this in dev OUs while still allowing it in production OUs where break-glass procedures require it.

Which approach BEST enforces this requirement with minimal operational overhead?

A. Create an SCP attached to the dev OU that denies iam:AttachUserPolicy and iam:PutUserPolicy when the policy ARN contains "AdministratorAccess." Include a condition key for aws:PrincipalOrgID to scope it to the organization.

B. Deploy AWS Config rules across all dev accounts using a conformance pack that detects IAM users with AdministratorAccess and triggers a Lambda function to detach the policy.

C. Create an SCP attached to the dev OU that denies iam:CreateUser entirely, forcing developers to use federated roles instead.

D. Use IAM permissions boundaries deployed via CloudFormation StackSets to all dev accounts that prevent escalation to AdministratorAccess.

**Correct Answer: A**

**Explanation:** An SCP attached specifically to the dev OU that denies attaching AdministratorAccess policies is the most targeted and operationally efficient approach. SCPs are preventive controls that block the action before it occurs. Option B is detective and reactive—non-compliant policies exist temporarily before remediation. Option C is too restrictive; it blocks all IAM user creation, which may be needed for service accounts. Option D (permissions boundaries) works but requires every account to have the boundary correctly applied via StackSets and doesn't prevent an admin from removing the boundary unless also protected by an SCP.

---

### Question 2

A company runs a microservices architecture across three AWS accounts: a shared-services account, a production account, and a data account. An application in the production account needs to invoke a Lambda function in the shared-services account and read objects from an S3 bucket in the data account. The solution must follow least-privilege principles and avoid long-term credentials.

Which combination of configurations enables this cross-account access pattern? (Choose TWO.)

A. Create a resource-based policy on the Lambda function in the shared-services account granting lambda:InvokeFunction to the production account's application role. The production application assumes its own role and invokes the function directly.

B. Create an IAM role in the shared-services account with a trust policy allowing the production account's application role. The application calls sts:AssumeRole to get temporary credentials and then invokes the Lambda function.

C. Add a bucket policy on the S3 bucket in the data account that grants s3:GetObject to the production account's application role ARN. The application accesses the bucket using its own role credentials.

D. Store the shared-services account credentials in AWS Secrets Manager in the production account and have the application retrieve them before invoking the Lambda function.

E. Create a VPC endpoint for S3 in the production account's VPC and use the endpoint policy to authorize access to the data account's bucket.

**Correct Answer: A, C**

**Explanation:** For Lambda cross-account invocation, a resource-based policy (A) on the Lambda function is the simplest approach—it allows the calling role to invoke directly without assuming an intermediary role. For S3 cross-account access, a bucket policy (C) granting access to the production role ARN allows direct access using the application's own credentials. Option B works but adds unnecessary complexity when resource-based policies suffice. Option D uses stored credentials, violating the no-long-term-credentials requirement. Option E (VPC endpoint policy) controls which S3 resources can be accessed through that endpoint but doesn't grant cross-account IAM permissions.

---

### Question 3

An organization uses AWS Organizations with all features enabled. They want to enforce that all EC2 instances launched in any member account must use encrypted EBS volumes, and only KMS keys managed by a central security account can be used for encryption. The policy must apply immediately to all current and future accounts.

Which solution meets these requirements?

A. Create an SCP that denies ec2:RunInstances unless the ec2:Encrypted condition is true and the kms:ViaService condition specifies the central security account's KMS key ARN.

B. Create an SCP that denies ec2:RunInstances unless the condition key ec2:Encrypted equals true, combined with a separate SCP that denies kms:CreateGrant unless the kms:CallerAccount matches the security account ID.

C. Create an SCP that denies ec2:RunInstances when the ec2:Encrypted condition is false, and a second SCP that denies ec2:RunInstances unless the kms:RequestAlias condition matches the approved key aliases from the central account.

D. Deploy AWS Config rules via delegated administrator that check for unencrypted EBS volumes and use remediation actions to terminate non-compliant instances.

**Correct Answer: C**

**Explanation:** The combination of two SCPs achieves both requirements: the first ensures all EBS volumes are encrypted by denying launches when encryption is false, and the second restricts which KMS keys can be used by requiring specific key aliases from the central account. Option A incorrectly uses kms:ViaService, which controls which AWS services can use a key, not which key is used. Option B's approach with kms:CreateGrant doesn't directly control which key is used for EBS encryption at launch time. Option D is detective, not preventive, and terminating instances causes disruption.

---

### Question 4

A healthcare company processes patient data and must comply with HIPAA. They have a VPC with application servers in private subnets that need to access DynamoDB and S3 without traffic traversing the internet. The VPC CIDR is 10.0.0.0/16 and they've exhausted available IP addresses for new subnets. The security team requires that traffic to AWS services remain within the AWS network.

Which approach provides the required connectivity with the fewest changes?

A. Create a gateway VPC endpoint for S3 and DynamoDB. Update the route tables for the private subnets to include routes to the endpoints.

B. Create interface VPC endpoints for both S3 and DynamoDB. These endpoints create ENIs in existing subnets and do not require new CIDR ranges.

C. Set up an AWS PrivateLink connection to S3 and DynamoDB through a Network Load Balancer in a new VPC peered with the existing VPC.

D. Configure a NAT gateway in a public subnet and route all S3 and DynamoDB traffic through it. Apply security group rules to restrict outbound traffic to only S3 and DynamoDB IP ranges.

**Correct Answer: A**

**Explanation:** Gateway VPC endpoints for S3 and DynamoDB are the optimal solution. They don't require ENIs or IP addresses—they add route table entries pointing to the endpoint, keeping traffic within the AWS network. Since the company has exhausted IP addresses, gateway endpoints are ideal because they consume no IPs. Option B (interface endpoints) creates ENIs that consume IP addresses from the subnet, which is problematic given the IP exhaustion. Option C introduces unnecessary complexity with a new VPC and NLB. Option D routes traffic through a NAT gateway, which technically traverses the internet path and doesn't meet the requirement of staying within the AWS network.

---

### Question 5

A company is designing an IAM strategy for a new multi-account environment. Developers need to deploy CloudFormation stacks that create IAM roles, but the security team insists that no developer-created role should be able to escalate privileges beyond a defined boundary. Developers must not be able to remove or modify the boundary once applied.

Which solution enforces this requirement?

A. Require developers to attach a specific IAM permissions boundary to every role they create by including a condition in their IAM policy that denies iam:CreateRole unless iam:PermissionsBoundary matches a specific policy ARN. Add a separate denial for iam:DeleteRolePermissionsBoundary and iam:PutRolePermissionsBoundary.

B. Use an SCP that prevents iam:CreateRole across all accounts and require developers to submit role requests through a ServiceNow integration that triggers a Step Functions workflow.

C. Create a CloudFormation hook that validates all IAM role resources include a permissions boundary property before allowing stack creation.

D. Use AWS Config to detect IAM roles without permissions boundaries and automatically delete them using a remediation Lambda function.

**Correct Answer: A**

**Explanation:** The IAM policy condition requiring iam:PermissionsBoundary ensures developers can only create roles that include the specified boundary. Denying iam:DeleteRolePermissionsBoundary and iam:PutRolePermissionsBoundary prevents developers from removing or modifying the boundary after creation. This is a well-established pattern for delegated IAM administration. Option B is overly restrictive and introduces significant operational overhead. Option C (CloudFormation hooks) adds a validation layer but doesn't prevent direct API calls that bypass CloudFormation. Option D is reactive—roles exist without boundaries before detection and remediation.

---

### Question 6

A financial services company has strict data residency requirements. All data processing and storage for European customers must occur within the eu-west-1 Region. The company uses AWS Organizations with 50 accounts. They need to prevent any resource creation outside eu-west-1 for accounts in the "EU-Production" OU, while allowing the management account to operate globally.

Which approach ensures compliance?

A. Create an SCP attached to the EU-Production OU that denies all actions when aws:RequestedRegion is not eu-west-1, with exceptions for global services like IAM, Route 53, CloudFront, and AWS Organizations.

B. Create an IAM policy in each account that denies all actions outside eu-west-1 and attach it to every user and role.

C. Use AWS Control Tower with the Region deny guardrail configured for eu-west-1 only, applied to the EU-Production OU.

D. Configure AWS Config rules in each account to detect resources created outside eu-west-1 and terminate them automatically.

**Correct Answer: A**

**Explanation:** An SCP attached to the EU-Production OU that denies actions outside eu-west-1 with exceptions for global services is the correct approach. SCPs don't apply to the management account, satisfying the requirement for global management account access. Global services (IAM, Route 53, CloudFront, Organizations, STS, Support) must be excluded since they operate from us-east-1 regardless of where you call them. Option B requires per-account management and can be bypassed by principals without the policy. Option C could work if using Control Tower, but the question doesn't mention Control Tower, and the SCP approach is more direct. Option D is detective, not preventive.

---

### Question 7

A company's VPC architecture has grown organically to include 15 VPCs across three accounts in the same Region. They need full mesh connectivity between all VPCs, centralized egress through a shared inspection VPC with third-party firewall appliances, and the ability to add new VPCs with minimal configuration changes.

Which architecture provides this capability?

A. Create VPC peering connections between all 15 VPCs (105 peering connections) and use route tables to direct internet-bound traffic through the inspection VPC.

B. Deploy an AWS Transit Gateway, attach all 15 VPCs, create a shared services route table for the inspection VPC, and configure Transit Gateway route tables to route internet-bound traffic through the inspection VPC's firewall appliances.

C. Deploy AWS PrivateLink endpoints in each VPC connecting to services in other VPCs, and configure a NAT gateway in the inspection VPC for centralized egress.

D. Create a hub-and-spoke topology using VPN connections from each VPC to a virtual private gateway in the inspection VPC.

**Correct Answer: B**

**Explanation:** AWS Transit Gateway is designed for this exact use case—it provides a hub that simplifies connectivity between multiple VPCs. With Transit Gateway, you attach VPCs and configure route tables to control traffic flow. Internet-bound traffic can be routed through the inspection VPC's firewall appliances using Transit Gateway route table entries. Adding new VPCs requires only attaching them to the Transit Gateway. Option A creates 105 peering connections (n*(n-1)/2), which is operationally unmanageable and VPC peering is non-transitive, so centralized egress routing is complex. Option C (PrivateLink) is for service-to-service communication, not general connectivity. Option D using VPN connections is operationally complex and limited in bandwidth.

---

### Question 8

A development team deploys Lambda functions that process sensitive customer data from an S3 bucket. The Lambda functions run in a VPC to access an RDS database. After deployment, the Lambda functions can reach the RDS instance but cannot access the S3 bucket. The team wants the simplest fix that keeps all traffic private.

Which solution resolves this issue?

A. Add a NAT gateway in a public subnet and update the private subnet route table to route 0.0.0.0/0 through the NAT gateway.

B. Create a gateway VPC endpoint for S3 and add a route to the private subnet's route table pointing to the endpoint.

C. Move the Lambda functions out of the VPC so they can access S3 natively, and use RDS Proxy to maintain database connectivity.

D. Create an interface VPC endpoint for S3 and update the Lambda function's security group to allow outbound HTTPS traffic to the endpoint.

**Correct Answer: B**

**Explanation:** When Lambda functions are deployed in a VPC, they lose direct access to AWS services outside the VPC. A gateway VPC endpoint for S3 is the simplest solution—it adds a route table entry that directs S3 traffic through the endpoint within the AWS network, requires no security group changes, and has no additional per-hour cost. Option A (NAT gateway) works but introduces hourly costs and routes traffic through the public internet path, not meeting the "keep all traffic private" requirement as cleanly. Option C requires significant architectural changes and RDS Proxy adds cost. Option D (interface endpoint for S3) works but costs more than a gateway endpoint and requires security group configuration.

---

### Question 9

An organization is implementing a landing zone with AWS Organizations. The security team requires that all API activity across every account be delivered to a centralized S3 bucket in a log archive account. The logs must be tamper-proof, and even administrators of individual accounts must not be able to stop logging or delete trails.

Which configuration achieves this?

A. Create an organization trail in the management account that delivers logs to the log archive account's S3 bucket. Apply an SCP to all member accounts denying cloudtrail:StopLogging, cloudtrail:DeleteTrail, and cloudtrail:UpdateTrail for the organization trail.

B. Deploy individual CloudTrail trails in each account using CloudFormation StackSets, configured to deliver logs to the centralized S3 bucket. Enable log file validation on each trail.

C. Create an organization trail and enable CloudTrail Lake to aggregate all events. Use S3 Object Lock in governance mode on the destination bucket.

D. Use AWS Config to monitor CloudTrail status across all accounts and trigger automatic remediation to re-enable any disabled trails.

**Correct Answer: A**

**Explanation:** An organization trail automatically collects API activity from all accounts in the organization and delivers it to a centralized bucket. The SCP denying modification of the organization trail prevents account administrators from tampering with logging. This is a preventive control that works across all current and future accounts. Option B requires StackSet management and individual trails can be modified by account admins without SCP protection. Option C's CloudTrail Lake is useful for querying but doesn't replace the need for SCPs to prevent tampering; governance mode Object Lock can be overridden by users with specific permissions. Option D is reactive, not preventive.

---

### Question 10

A company has a VPC with CIDR 10.1.0.0/16 and needs to connect to a partner organization's VPC (172.16.0.0/16) in a different AWS account and Region. Both companies want to share specific microservices without exposing their entire networks to each other. The partner has three services that need to be accessible.

Which approach provides the MOST secure connectivity?

A. Create an inter-Region VPC peering connection and use security groups and NACLs to restrict access to only the specific microservice ports and IP addresses.

B. Have the partner expose each microservice behind a Network Load Balancer and create AWS PrivateLink endpoint services. The company creates interface VPC endpoints to consume these services.

C. Set up an AWS Transit Gateway in each Region with inter-Region peering and attach both VPCs. Use Transit Gateway route tables to limit routing.

D. Establish a Site-to-Site VPN between the two VPCs and use route table entries to limit accessible subnets.

**Correct Answer: B**

**Explanation:** AWS PrivateLink is the most secure option for sharing specific services between VPCs without exposing entire networks. Each service is exposed behind an NLB as an endpoint service, and the consuming company creates interface VPC endpoints. This creates a unidirectional, service-specific connection—the partner's VPC is never exposed to the consumer's network. Option A (VPC peering) exposes the entire VPC network to the peer, even with security group restrictions. Option C (Transit Gateway) provides full network connectivity, which is excessive for three specific services. Option D (VPN) also exposes network-level connectivity beyond what's needed.

---

### Question 11

A company needs to implement a cross-account deployment pipeline. The CI/CD pipeline runs in a tools account and must deploy CloudFormation stacks to development, staging, and production accounts. Each target account has different permission requirements—dev allows broad resource creation, staging restricts certain resource types, and production requires approval before deployment.

Which architecture implements this MOST securely?

A. Create an IAM user in each target account with appropriate permissions. Store the access keys in AWS Secrets Manager in the tools account. The pipeline retrieves keys before deploying to each account.

B. Create a deployment IAM role in each target account with a trust policy allowing the tools account's pipeline role. Each role has permissions tailored to the environment. Use CodePipeline with a manual approval action for the production stage.

C. Use a single IAM role in the tools account with cross-account permissions to all three target accounts. Add conditions to restrict actions based on the target account.

D. Share the CloudFormation stacks using AWS RAM and have each target account deploy from the shared resource.

**Correct Answer: B**

**Explanation:** Creating environment-specific deployment roles in each target account with trust policies back to the tools account follows the cross-account role assumption pattern, which uses temporary credentials and allows granular per-environment permissions. CodePipeline's manual approval action satisfies the production approval requirement. Option A uses long-term credentials (access keys), which is a security anti-pattern. Option C with a single role cannot enforce different permission levels per target account since IAM roles operate within a single account's scope. Option D doesn't apply—CloudFormation stacks aren't shared resources via RAM.

---

### Question 12

A company's security policy mandates that all S3 buckets must deny any requests that don't use TLS 1.2 or higher. This must be enforced across 200 accounts in their organization without relying on individual bucket policy management.

Which solution ensures consistent enforcement?

A. Create an SCP that denies s3:* when the condition aws:SecureTransport is false, attached to the root OU.

B. Use S3 Block Public Access at the organization level and enable "Require SSL" in each account's S3 settings.

C. Deploy a bucket policy to every bucket using a Lambda function triggered by S3:CreateBucket events from an organization CloudTrail trail, adding a condition denying non-TLS requests.

D. Create an SCP that denies s3:PutBucketPolicy unless the bucket policy document contains a condition for aws:SecureTransport.

**Correct Answer: A**

**Explanation:** An SCP denying all S3 actions when aws:SecureTransport is false enforces TLS at the organization level. This applies to every S3 request across all 200 accounts regardless of individual bucket policies. It's preventive, centrally managed, and automatically covers new accounts. Option B's Block Public Access doesn't enforce TLS—it controls public access. There's no "Require SSL" organization-level S3 setting. Option C is reactive and operationally complex across 200 accounts. Option D doesn't enforce TLS on requests; it only controls what bucket policies look like, and attackers could still make non-TLS requests if the bucket policy doesn't explicitly deny them.

---

### Question 13

A company is designing a multi-VPC architecture for a new application platform. The requirements include: VPC A (10.0.0.0/16) hosts shared services, VPC B (10.1.0.0/16) hosts the application tier, and VPC C (10.2.0.0/16) hosts databases. VPC B must communicate with both VPC A and VPC C, but VPC A and VPC C must NOT communicate directly. All three VPCs are in the same Region and account.

Which network design enforces this requirement?

A. Create VPC peering between A↔B and B↔C. Since VPC peering is non-transitive, A and C cannot communicate through B.

B. Deploy a Transit Gateway with all three VPCs attached. Create two route tables: one for VPC A and VPC B, another for VPC B and VPC C. Associate VPCs accordingly.

C. Create VPC peering between all three VPCs (A↔B, B↔C, A↔C) and use NACLs to block traffic between A and C.

D. Deploy a Transit Gateway with all three VPCs attached to a single route table and use security groups to block traffic between VPC A and VPC C.

**Correct Answer: A**

**Explanation:** VPC peering's non-transitive nature naturally enforces the isolation requirement. With peering between A↔B and B↔C but no peering between A↔C, there is no network path between A and C—even traffic routed through B cannot transit the peering connections. This is the simplest architecture that meets the requirement. Option B works but introduces Transit Gateway cost and complexity unnecessary for three VPCs. Option C creates connectivity between A and C and relies on NACLs, which are harder to manage and could be misconfigured. Option D with a single Transit Gateway route table would route traffic between all attached VPCs, and security groups alone are insufficient for network isolation.

---

### Question 14

A company has an AWS Lambda function that processes files uploaded to an S3 bucket. The function needs to access an Amazon ElastiCache Redis cluster in a VPC and also needs to call the Amazon Rekognition API. After placing the Lambda function in the VPC, calls to Rekognition start timing out.

Which combination of changes resolves this with the LEAST cost? (Choose TWO.)

A. Create a NAT gateway in a public subnet and add a default route in the Lambda function's private subnet route table pointing to the NAT gateway.

B. Create an interface VPC endpoint for Rekognition in the VPC.

C. Increase the Lambda function's timeout to 15 minutes to allow more time for Rekognition API calls.

D. Remove the Lambda function from the VPC and use VPC peering to access ElastiCache.

E. Create a second Lambda function outside the VPC for Rekognition calls and invoke it from the VPC-based function using the Lambda invoke API through an interface VPC endpoint.

**Correct Answer: B, E**

**Explanation:** The issue is that VPC-based Lambda functions cannot access internet-facing AWS APIs without a path to the internet or a VPC endpoint. Option B (interface VPC endpoint for Rekognition) is the most direct solution—it provides private access to Rekognition without a NAT gateway. Option E provides an alternative architecture if the endpoint approach needs supplementing. However, the best two-option combination for LEAST cost is actually B alone as the primary fix. Between A and B: Option A (NAT gateway) costs ~$32/month plus data processing charges, while an interface VPC endpoint (B) costs ~$7.30/month per AZ, making B cheaper. Option C doesn't fix the connectivity issue—it just delays the timeout. Option D is invalid because Lambda functions cannot use VPC peering to access ElastiCache from outside the VPC.

---

### Question 15

A company with 50 AWS accounts uses AWS SSO (IAM Identity Center) with an external IdP for workforce authentication. They need to implement a just-in-time access model where engineers can request elevated permissions for production accounts that automatically expire after 4 hours. All access requests must be logged and approved by a team lead.

Which solution BEST implements this requirement?

A. Create a Lambda function that temporarily adds users to a permission set with elevated privileges using the IAM Identity Center API, triggered by an approved SNS notification. Use EventBridge to schedule removal after 4 hours.

B. Use IAM Identity Center's built-in temporary elevated access feature with approval workflows configured in AWS Organizations.

C. Implement AWS SSO permission sets with session duration set to 4 hours. Create separate elevated permission sets and use an approval workflow in ServiceNow that triggers a Lambda function to assign and unassign the permission set.

D. Create IAM roles in each production account with a 4-hour max session duration. Have engineers assume these roles directly using temporary credentials obtained through an approval portal.

**Correct Answer: C**

**Explanation:** Using IAM Identity Center permission sets with a 4-hour session duration combined with an external approval workflow (ServiceNow) that triggers Lambda functions for assignment/unassignment provides a complete just-in-time access solution. The approval creates an audit trail, the permission set provides time-limited access, and the automated unassignment ensures access expires. Option A works conceptually but manipulating SSO assignments directly via API is more fragile than using permission sets. Option B doesn't exist—IAM Identity Center doesn't have a built-in elevated access approval workflow. Option D bypasses IAM Identity Center entirely, losing centralized identity management benefits.

---

### Question 16

A security audit reveals that several S3 buckets across the organization have overly permissive bucket policies granting s3:* to principal "*". The security team wants to prevent any bucket policy that grants access to the wildcard principal, while still allowing bucket policies that grant cross-account access to specific account principals.

Which approach enforces this preventively?

A. Create an SCP that denies s3:PutBucketPolicy for all accounts. Require bucket policies to be deployed only through a centralized pipeline with policy validation.

B. Enable S3 Block Public Access at the organization level for all accounts, which prevents bucket policies from granting public access.

C. Create an AWS Config rule that evaluates bucket policies and triggers a Lambda function to revert any policy containing Principal: "*".

D. Create an SCP that denies s3:PutBucketPolicy when the s3:x-amz-grant-full-control or s3:x-amz-acl condition contains "public" values.

**Correct Answer: B**

**Explanation:** S3 Block Public Access at the organization level prevents any bucket policy from granting access to the public (Principal: "*" or Principal: {"AWS": "*"}). It's a preventive control that applies across all accounts and cannot be overridden by account-level settings when applied at the organization level. It still allows bucket policies granting access to specific account principals. Option A is overly restrictive—it blocks all bucket policy changes. Option C is reactive, not preventive. Option D's condition keys control ACL-based grants, not bucket policy principal fields.

---

### Question 17

A company has a VPC with three private subnets across three Availability Zones. They need to deploy a fleet of EC2 instances that communicate with an on-premises DNS server at 10.200.1.53. The instances must also resolve AWS service endpoints using Amazon-provided DNS. Currently, the VPC's DHCP option set uses the on-premises DNS server, which causes AWS service endpoint resolution to fail.

Which solution allows both on-premises and AWS DNS resolution?

A. Create a Route 53 Resolver outbound endpoint in the VPC. Configure forwarding rules for the on-premises domains to forward queries to the on-premises DNS server. Change the DHCP option set to use AmazonProvidedDNS.

B. Create a Route 53 Resolver inbound endpoint in the VPC so the on-premises DNS server can forward queries to Route 53. Keep the DHCP option set pointing to the on-premises server.

C. Configure a custom DNS server on an EC2 instance that conditionally forwards queries: AWS domains to the VPC DNS resolver (VPC CIDR +2) and all other queries to the on-premises DNS server.

D. Use Route 53 private hosted zones associated with the VPC for on-premises domain resolution and remove the custom DHCP option set.

**Correct Answer: A**

**Explanation:** Route 53 Resolver outbound endpoints allow VPC resources to forward specific DNS queries to external DNS servers (on-premises). By changing the DHCP option set to AmazonProvidedDNS (the default), all DNS queries first go to Route 53 Resolver, which handles AWS service endpoint resolution natively. Forwarding rules for on-premises domains direct those specific queries through the outbound endpoint to the on-premises DNS server. Option B (inbound endpoint) handles queries from on-premises to AWS, not the other direction. Option C works but introduces operational overhead of managing a custom DNS instance. Option D doesn't resolve on-premises domains—private hosted zones are for AWS-side resolution.

---

### Question 18

A company runs a Lambda function that processes orders and writes to DynamoDB. The function is configured with a concurrency limit of 100. During peak sales events, the function reaches its concurrency limit, causing throttling. Some orders are lost because the triggering SQS queue returns messages to the queue, which expire before processing. The company needs zero order loss with minimal architectural changes.

Which solution addresses this?

A. Increase the Lambda function's reserved concurrency to 1000 and enable provisioned concurrency for 500 instances during peak events.

B. Configure the SQS queue with a dead-letter queue (DLQ) with maxReceiveCount of 5. Increase the SQS queue's message retention period to 14 days. Increase the Lambda concurrency limit to 500.

C. Replace SQS with Amazon Kinesis Data Streams as the event source. Kinesis retains records for 24 hours by default, preventing data loss during throttling.

D. Configure the SQS queue's visibility timeout to 6 times the Lambda function timeout. Add a dead-letter queue for failed messages. Create a separate Lambda function to process DLQ messages.

**Correct Answer: B**

**Explanation:** The solution needs to address both the capacity issue and prevent data loss. Increasing the concurrency limit to 500 handles the throughput problem during peaks. The DLQ with maxReceiveCount of 5 captures any messages that still fail after retries, preventing permanent loss. Extending retention to 14 days ensures messages remain available even during extended processing delays. Option A's provisioned concurrency reduces cold starts but doesn't prevent data loss for throttled requests. Option C changes the event source, which is not a "minimal change," and Kinesis has different scaling characteristics. Option D only addresses message handling but doesn't increase processing capacity.

---

### Question 19

An enterprise has a complex AWS Organizations structure with 15 OUs. Different teams manage different OUs. The CTO wants to implement a tagging strategy that requires all resources across the organization to have specific tags (Environment, CostCenter, Owner) but allows each OU's administrator to define additional required tags for their OU.

Which approach implements this hierarchical tagging enforcement?

A. Create a tag policy attached to the root OU that requires Environment, CostCenter, and Owner tags. Allow each OU administrator to create additional tag policies at their OU level. Tag policies are inherited and merged, so the OU-level policies add requirements.

B. Create an SCP at the root that denies resource creation without the three required tags. Each OU administrator creates additional SCPs at their OU level for extra tags.

C. Deploy AWS Config rules via a delegated administrator for the three base tags. Each OU administrator deploys additional Config rules in their accounts for extra tags.

D. Use AWS Service Catalog with tag options at the organization level for the base tags and portfolio-level tag options for OU-specific tags.

**Correct Answer: A**

**Explanation:** Tag policies in AWS Organizations support hierarchical inheritance and merging. A root-level tag policy establishes the baseline required tags, and OU-level tag policies can add additional requirements. Child policies inherit parent policies, and when both define tag requirements, they are merged. This gives the CTO base enforcement while allowing OU administrators to extend requirements. Option B (SCPs for tagging) is possible but difficult to implement comprehensively because SCP condition keys for tags don't cover all resource types. Option C provides detection but not enforcement and requires per-account deployment. Option D only enforces tags for Service Catalog-provisioned resources.

---

### Question 20

A company has enabled AWS CloudTrail across all accounts in their organization. The security team needs to receive real-time alerts when any IAM policy is created or modified that grants full administrative access (Effect: Allow, Action: "*", Resource: "*") in any account. The alert must trigger within 5 minutes.

Which solution provides the MOST reliable near-real-time detection?

A. Configure CloudTrail to deliver logs to CloudWatch Logs in each account. Create a metric filter in each account that matches IAM policy creation events and triggers an SNS notification via a CloudWatch alarm.

B. Use Amazon EventBridge in each member account with a rule matching IAM CreatePolicy and PutRolePolicy events. Forward matching events to an EventBridge event bus in the security account for centralized processing.

C. Create an organization trail delivering logs to a centralized S3 bucket. Configure S3 event notifications to trigger a Lambda function that parses each log file for IAM policy events.

D. Enable AWS Access Analyzer across the organization and configure it to alert when policies with full administrative access are detected.

**Correct Answer: B**

**Explanation:** EventBridge provides near-real-time event processing (typically within seconds) for AWS API calls. By creating rules in each member account that match IAM policy events and forwarding them to a centralized security account event bus, the security team gets rapid notification. A Lambda function on the security account bus can inspect the policy document for full admin permissions. Option A requires CloudWatch Logs setup in every account and metric filters with regex patterns, which is operationally heavy. Option C has latency because CloudTrail delivers log files every 5-15 minutes, not in real-time. Option D (Access Analyzer) analyzes external access, not the content of policies for admin permissions.

---

### Question 21

A startup is building a serverless e-commerce platform. The architecture needs to handle product catalog browsing (read-heavy, eventually consistent), order processing (transactional, strongly consistent), and real-time inventory updates. The expected load is 50,000 reads/second for the catalog and 2,000 writes/second for orders during peak.

Which combination of services BEST meets these requirements? (Choose TWO.)

A. Use Amazon DynamoDB with on-demand capacity for the product catalog and order processing. Enable DynamoDB Streams for real-time inventory updates. Use DynamoDB Accelerator (DAX) for catalog reads.

B. Use Amazon Aurora Serverless v2 for both catalog and order processing with read replicas for catalog browsing. Use Aurora's change data capture for inventory updates.

C. Use Amazon ElastiCache for Redis as the primary product catalog store with persistence enabled, and Amazon RDS for order processing.

D. Use Amazon DynamoDB with DynamoDB Streams connected to a Lambda function for inventory updates.

E. Use Amazon API Gateway with caching enabled for catalog reads, backed by Lambda functions and DynamoDB.

**Correct Answer: A, E**

**Explanation:** DynamoDB with DAX (A) handles the high-throughput catalog reads (DAX provides microsecond latency for cached reads at 50K/sec) and transactional order processing (DynamoDB transactions for strong consistency). DynamoDB Streams enables real-time inventory processing. API Gateway with caching (E) reduces load on the backend for catalog browsing by caching responses at the edge. Option B (Aurora Serverless) can handle the workload but has higher latency for the read-heavy catalog pattern at 50K reads/sec. Option C uses Redis as a primary store, which risks data loss. Option D is partially correct but incomplete as a standalone answer.

---

### Question 22

A media company needs to design an architecture for transcoding video files uploaded to S3. Files range from 100MB to 50GB. Transcoding must start within 1 minute of upload and produce multiple output formats. The system must handle 500 concurrent uploads during peak hours and scale to zero during off-peak.

Which architecture provides the BEST combination of performance and cost efficiency?

A. Configure S3 event notifications to invoke a Lambda function that submits transcoding jobs to AWS Elemental MediaConvert. MediaConvert handles scaling automatically and supports multiple output formats in a single job.

B. Configure S3 event notifications to an SQS queue. An Auto Scaling group of EC2 instances running FFmpeg polls the queue, transcodes the files, and uploads outputs to S3.

C. Configure S3 event notifications to trigger a Step Functions workflow that launches an ECS Fargate task for each file. Each task runs an FFmpeg container that transcodes and uploads results.

D. Configure S3 event notifications to invoke a Lambda function that directly performs the transcoding using FFmpeg compiled as a Lambda layer.

**Correct Answer: A**

**Explanation:** AWS Elemental MediaConvert is a fully managed transcoding service that scales automatically, supports multiple output formats per job, handles files up to 50GB, and requires no infrastructure management. S3 event → Lambda → MediaConvert job provides sub-minute initiation. It scales to zero when no jobs are submitted. Option B works but requires managing EC2 instances and Auto Scaling policies. Option C (Fargate) requires container management and has slower task startup times. Option D is impractical—Lambda has a 15-minute timeout and limited /tmp storage (10GB), insufficient for 50GB files.

---

### Question 23

A company is designing a multi-Region active-active application with the following requirements: users are routed to the nearest Region, data must be synchronized between Regions within 1 second, and if one Region fails, the other must handle 100% of traffic with no data loss.

Which data layer design supports these requirements?

A. Use Amazon DynamoDB global tables with the application configured to write to the local Region's table. DynamoDB handles cross-Region replication automatically with sub-second latency.

B. Use Amazon Aurora Global Database with write forwarding enabled. The primary Region handles writes, and the secondary Region forwards writes to the primary.

C. Use Amazon RDS Multi-AZ in each Region with cross-Region read replicas and application-level write routing to the primary Region.

D. Use Amazon ElastiCache Global Datastore with Redis in each Region for the data layer, with asynchronous replication between Regions.

**Correct Answer: A**

**Explanation:** DynamoDB global tables support active-active multi-Region writes with sub-second replication (typically under 1 second). Each Region can accept writes independently, and conflicts are resolved using last-writer-wins. During a Regional failure, the other Region has a full copy of the data with minimal lag. Option B (Aurora Global Database) uses a single write Region—it's not truly active-active, and write forwarding adds latency. Option C with RDS cross-Region replicas also has a single write Region and higher replication lag. Option D (ElastiCache Global Datastore) is for caching, not a primary data layer, and has asynchronous replication without strong consistency guarantees.

---

### Question 24

A company processes IoT data from 100,000 devices, each sending a 1KB message every 10 seconds. The data must be ingested, processed in real-time for anomaly detection, and stored for batch analytics. The architecture must handle device spikes of up to 200,000 devices.

Which ingestion and processing architecture meets these requirements?

A. Use Amazon Kinesis Data Streams with a shard count calculated for peak throughput. Process records with a Kinesis Data Analytics Apache Flink application for anomaly detection. Use Kinesis Data Firehose to deliver data to S3 for batch analytics.

B. Use Amazon SQS FIFO queues with Lambda functions for processing. Store processed data in DynamoDB for real-time queries and S3 for batch analytics.

C. Use AWS IoT Core to ingest device messages. Configure IoT Rules to send data to a Kinesis Data Stream for real-time processing and directly to S3 for batch storage.

D. Use Amazon MSK (Managed Streaming for Apache Kafka) for ingestion with Kafka Streams for real-time processing. Use Kafka Connect to sink data to S3.

**Correct Answer: C**

**Explanation:** AWS IoT Core is purpose-built for IoT device ingestion and scales to millions of devices. IoT Rules provide flexible routing—sending data simultaneously to Kinesis for real-time anomaly detection (using Kinesis Data Analytics/Flink) and directly to S3 for batch analytics. At peak: 200,000 devices × 1KB/10sec = 20,000 messages/sec (20MB/sec), well within IoT Core's capabilities. Option A works for ingestion but isn't optimized for IoT device management (authentication, device shadows, etc.). Option B (SQS FIFO) has a throughput limit of 3,000 messages/sec per queue with batching, insufficient for this workload. Option D (MSK) works but requires more operational management than IoT Core.

---

### Question 25

A SaaS company needs to provide each tenant with an isolated database while sharing the application tier. They have 500 tenants, expect to grow to 5,000, and each tenant's database is small (under 10GB). The solution must minimize operational overhead and cost.

Which database architecture is MOST appropriate?

A. Deploy a single Amazon Aurora cluster with a separate schema per tenant. Use application-level routing to direct queries to the correct schema.

B. Deploy a separate Amazon RDS instance per tenant using CloudFormation templates for consistent provisioning.

C. Use Amazon DynamoDB with tenant isolation achieved through partition key design. Each tenant's data uses a partition key prefixed with the tenant ID.

D. Deploy Amazon Aurora Serverless v2 with a separate database per tenant within a single cluster. Use IAM database authentication with tenant-specific policies.

**Correct Answer: D**

**Explanation:** Aurora Serverless v2 with separate databases per tenant in a single cluster provides true database-level isolation while sharing the underlying infrastructure. It scales capacity automatically (minimizing cost for small databases), supports up to thousands of databases per cluster, and IAM authentication provides tenant-specific access control. Option A (schema per tenant) provides less isolation—a bug or query in one schema can affect others. Option B (separate RDS instances) creates 5,000 instances, which is extremely costly and operationally heavy. Option C (DynamoDB) requires application-level isolation enforcement and doesn't provide true database-level separation.

---

### Question 26

A company needs to design an API that handles 10,000 requests per second with response times under 50ms. The API serves relatively static data that changes every 15 minutes. The backend is a Lambda function querying DynamoDB.

Which architecture achieves the performance requirement at the LOWEST cost?

A. Deploy API Gateway with edge-optimized endpoints. Enable API Gateway caching with a 15-minute TTL. Use Lambda with provisioned concurrency.

B. Deploy API Gateway with regional endpoints behind CloudFront. Configure CloudFront caching with a 15-minute TTL. Use Lambda without provisioned concurrency.

C. Deploy Application Load Balancer with Lambda target groups. Use DAX in front of DynamoDB for microsecond read latency.

D. Deploy API Gateway with regional endpoints. Use DAX for DynamoDB reads and Lambda with 128MB memory configuration.

**Correct Answer: B**

**Explanation:** CloudFront with a 15-minute TTL caches responses at edge locations globally, serving most of the 10,000 req/sec from cache with single-digit millisecond latency—well under 50ms. Since data only changes every 15 minutes, the cache hit ratio will be extremely high, dramatically reducing Lambda invocations and DynamoDB reads, minimizing cost. Lambda doesn't need provisioned concurrency because most requests are served from cache. Option A's edge-optimized API Gateway adds unnecessary latency routing through CloudFront to an edge-optimized endpoint. Option C (ALB with DAX) handles the load but costs more due to ALB hourly charges plus DAX cluster costs. Option D doesn't leverage caching for the static data pattern.

---

### Question 27

A company is designing a document processing pipeline. Users upload documents (PDF, DOCX, images) to an S3 bucket. The system must extract text, detect entities (names, dates, amounts), classify the document type, and store results in a searchable database. Processing must complete within 30 seconds of upload.

Which serverless architecture achieves this?

A. S3 event → Lambda function → Amazon Textract for text extraction → Amazon Comprehend for entity detection → DynamoDB for results. Use Step Functions to orchestrate the workflow.

B. S3 event → Lambda function → Amazon Textract for text extraction → custom Lambda for regex-based entity detection → Amazon RDS for results.

C. S3 event → SQS queue → EC2 instances running Tesseract OCR → Lambda for entity detection → Amazon OpenSearch for results.

D. S3 event → Lambda function → Amazon Rekognition for text extraction → Amazon Comprehend for entity detection → Amazon OpenSearch for results.

**Correct Answer: A**

**Explanation:** Amazon Textract extracts text from PDFs, DOCX (via image conversion), and images with high accuracy. Amazon Comprehend performs entity detection (names, dates, amounts) and document classification natively. Step Functions orchestrates the multi-step workflow with error handling and retries. DynamoDB provides fast, searchable storage with secondary indexes. This is fully serverless and can complete within 30 seconds. Option B uses regex instead of ML-based entity detection, which is less accurate. Option C introduces EC2 instances, breaking the serverless requirement. Option D uses Rekognition, which detects text in images but isn't designed for document processing like Textract.

---

### Question 28

A financial trading platform requires an architecture that processes market data with end-to-end latency under 10 milliseconds. The system receives 1 million events per second and must perform stateful aggregation (5-second windows) before writing to a time-series database.

Which architecture BEST meets the latency requirement?

A. Use Amazon Kinesis Data Streams with enhanced fan-out for ingestion. Process with Amazon Managed Service for Apache Flink for windowed aggregation. Write results to Amazon Timestream.

B. Use Amazon MSK with a dedicated Kafka cluster for ingestion. Process with Kafka Streams for aggregation. Write results to Amazon Timestream.

C. Use Amazon SQS with Lambda for processing and Amazon DynamoDB for storage with TTL for time-series behavior.

D. Use AWS IoT Core for ingestion with IoT Analytics for windowed aggregation. Store results in Amazon Timestream.

**Correct Answer: B**

**Explanation:** For sub-10ms end-to-end latency at 1M events/sec, Amazon MSK (Kafka) with Kafka Streams provides the lowest latency option. Kafka Streams processes in-memory with minimal overhead for stateful windowed aggregations. MSK handles 1M events/sec on appropriately provisioned brokers, and Kafka Streams' local state stores enable fast stateful processing. Option A (Kinesis + Flink) typically has 100ms+ latency for the Flink processing layer. Option C (SQS + Lambda) has invocation latency that exceeds 10ms. Option D (IoT Core) isn't designed for trading-speed latency requirements.

---

### Question 29

A company wants to build a REST API that authenticates users, authorizes access based on groups, rate-limits per user, and caches responses. The authentication provider is an existing OIDC-compliant identity provider. The solution should minimize custom code.

Which architecture requires the LEAST custom code?

A. Amazon API Gateway REST API with a Cognito User Pool authorizer (federated with the OIDC provider). Configure API Gateway usage plans and API keys for rate limiting. Enable API Gateway response caching.

B. Amazon API Gateway HTTP API with a JWT authorizer configured for the OIDC provider. Use Lambda authorizer for group-based access. Configure throttling at the route level.

C. Application Load Balancer with OIDC authentication action. Route to Lambda functions. Implement rate limiting with WAF rate-based rules.

D. Amazon API Gateway REST API with a Lambda authorizer that validates OIDC tokens and checks group membership. Configure usage plans for rate limiting and enable caching.

**Correct Answer: A**

**Explanation:** API Gateway REST API with Cognito as a federated identity broker provides the most managed solution. Cognito federates with the OIDC provider for authentication and provides group-based authorization through Cognito groups mapped from the IdP. Usage plans with API keys provide per-user rate limiting, and built-in response caching is available on REST APIs. This requires minimal custom code. Option B (HTTP API) supports JWT authorizers but doesn't have built-in response caching. Option C (ALB) supports OIDC auth but lacks built-in response caching and API-level rate limiting. Option D requires a custom Lambda authorizer, adding code that Cognito handles natively.

---

### Question 30

A company is migrating a monolithic application to microservices on AWS. The application has 15 services that communicate synchronously. During peak load, cascading failures occur when one slow service causes timeouts in all dependent services. The company wants to implement resilience patterns.

Which architecture pattern BEST prevents cascading failures?

A. Deploy all services on Amazon ECS with AWS App Mesh as a service mesh. Configure circuit breakers and retry policies in App Mesh virtual nodes. Use outlier detection to remove unhealthy instances.

B. Deploy services on Lambda with SQS queues between each service to decouple synchronous calls into asynchronous communication.

C. Deploy services on EKS with Istio service mesh. Configure circuit breakers, timeouts, and retry policies in Istio virtual services.

D. Deploy services on ECS with an Application Load Balancer per service. Configure health checks with aggressive thresholds and use Auto Scaling to replace unhealthy instances quickly.

**Correct Answer: A**

**Explanation:** AWS App Mesh as a service mesh provides circuit breakers, retry policies with configurable backoff, timeouts, and outlier detection—all key patterns for preventing cascading failures. App Mesh is AWS-native and integrates seamlessly with ECS. Circuit breakers prevent calls to failing services, retry policies handle transient failures, and outlier detection removes unhealthy instances from the load balancing pool. Option B (async with SQS) fundamentally changes the communication pattern, which may not be feasible for synchronous request-response flows. Option C (Istio) works but adds operational complexity managing a non-AWS service mesh. Option D (ALB health checks) only replaces unhealthy instances but doesn't prevent cascading failures during the failure window.

---

### Question 31

A company needs to design a global content management system where editors in New York and Tokyo simultaneously edit documents. Changes must be visible to both locations within 2 seconds. Conflict resolution should favor the most recent edit.

Which architecture supports this?

A. Use Amazon DynamoDB global tables replicated between us-east-1 and ap-northeast-1. Use DynamoDB Streams to trigger Lambda functions that notify editors of changes via WebSocket connections through API Gateway.

B. Use Amazon Aurora Global Database with the primary in us-east-1 and a secondary in ap-northeast-1. Use write forwarding for Tokyo editors and polling for change detection.

C. Use Amazon ElastiCache Global Datastore with Redis in both Regions for real-time document state. Persist to S3 asynchronously.

D. Use Amazon S3 with cross-Region replication and S3 event notifications to trigger Lambda functions for conflict detection.

**Correct Answer: A**

**Explanation:** DynamoDB global tables provide active-active multi-Region writes with sub-second replication, and automatically resolve conflicts using last-writer-wins—matching the requirement. DynamoDB Streams trigger Lambda functions to push real-time notifications via API Gateway WebSocket connections, ensuring editors see changes within 2 seconds. Option B (Aurora Global Database) doesn't support active-active writes—Tokyo editors would experience write latency forwarding to us-east-1. Option C (ElastiCache) is a cache, not a durable primary store, and lacks built-in conflict resolution. Option D (S3 CRR) has replication lag that can exceed 2 seconds and doesn't provide native conflict resolution.

---

### Question 32

A healthcare application stores patient records encrypted at rest. The application uses an AWS KMS customer managed key (CMK). The requirement is that encryption keys must be rotated annually, old data must remain readable after rotation, and the rotation must happen without application downtime or code changes.

Which approach meets these requirements?

A. Enable automatic key rotation on the CMK. AWS KMS retains all previous key versions and automatically uses the appropriate version for decryption.

B. Create a new CMK annually, re-encrypt all data with the new key, and update the application to reference the new key ARN. Delete the old key after re-encryption.

C. Use an alias for the CMK in the application. Annually create a new CMK and update the alias to point to the new key. The old key remains for decrypting existing data.

D. Enable automatic key rotation and also create a Lambda function that re-encrypts all data monthly using the latest key material to ensure all data uses the current key version.

**Correct Answer: A**

**Explanation:** Enabling automatic key rotation on a customer managed CMK causes AWS KMS to generate new key material annually while retaining all previous key material within the same CMK. The key ID and ARN remain unchanged, so no application changes are needed. When encrypting, KMS uses the latest key material; when decrypting, it automatically identifies and uses the correct key version from the ciphertext metadata. Option B requires application changes and risks data loss during migration. Option C (alias rotation) works but creates operational overhead managing multiple keys. Option D adds unnecessary complexity—automatic rotation handles everything without re-encryption.

---

### Question 33

A company deploys Lambda functions that must access secrets stored in AWS Secrets Manager. The functions process 10,000 requests per second. Retrieving the secret on every invocation causes high latency and costs. The secret changes monthly.

Which approach optimizes both performance and cost?

A. Cache the secret in the Lambda function's execution environment using the Secrets Manager Lambda extension. Configure a cache TTL of 1 hour.

B. Store the secret in a Lambda environment variable encrypted with a KMS key. Update the environment variable monthly when the secret rotates.

C. Use the AWS Parameters and Secrets Lambda extension with a configurable cache TTL. The extension caches secrets in memory across invocations within the same execution environment.

D. Store the secret in an SSM Parameter Store SecureString parameter and retrieve it at function initialization. Parameter Store has no per-request charge.

**Correct Answer: C**

**Explanation:** The AWS Parameters and Secrets Lambda extension provides a local cache layer for Lambda functions. It caches secrets in memory within the execution environment, reducing API calls to Secrets Manager. With a configurable TTL, the secret is refreshed periodically. At 10,000 req/sec, caching dramatically reduces costs (Secrets Manager charges per API call). Option A describes the same approach but the extension in Option C is the official AWS solution. Option B stores secrets in plaintext environment variables (after decryption), which is visible in the Lambda console—a security concern. Option D (Parameter Store) still requires initialization-time retrieval in every new execution environment and doesn't benefit from cross-invocation caching like the extension.

---

### Question 34

A company's application uses an Amazon S3 bucket for storing user-generated content. They need to ensure that objects are only accessible through their CloudFront distribution and not directly through S3 URLs. The S3 bucket also hosts a static website feature that must continue working.

Which configuration provides this restriction?

A. Create an Origin Access Control (OAC) for the CloudFront distribution. Update the S3 bucket policy to allow access only from the OAC. Disable S3 static website hosting and use CloudFront with the S3 REST API endpoint.

B. Create an Origin Access Identity (OAI) and configure the bucket policy to allow access only from the OAI. Keep the S3 website endpoint as the CloudFront origin.

C. Configure the S3 bucket policy to allow access only from CloudFront's IP ranges using the aws:SourceIp condition. Use the S3 website endpoint as the CloudFront origin.

D. Use a Lambda@Edge function on the CloudFront distribution to add a custom header. Configure the S3 bucket policy to require that header.

**Correct Answer: A**

**Explanation:** Origin Access Control (OAC) is the recommended successor to OAI and supports all S3 features including SSE-KMS. However, the question states static website hosting must continue—OAC requires using the S3 REST API endpoint, not the website endpoint. Since the question asks to both restrict access and maintain website functionality, disabling the website hosting endpoint and using CloudFront with the REST API endpoint (which can serve the same content with index document configuration in CloudFront) is the correct approach. Option B's OAI doesn't work with S3 website endpoints. Option C using IP ranges is fragile and CloudFront IPs change. Option D adds complexity with Lambda@Edge when OAC provides native support.

---

### Question 35

A company builds a data pipeline where multiple Lambda functions process data sequentially. Each step takes 2-8 minutes. If any step fails, the entire pipeline must retry from the failed step, not from the beginning. The pipeline processes 1,000 files per day.

Which orchestration approach is MOST appropriate?

A. Use AWS Step Functions Standard Workflows with a sequential state machine. Configure retry policies on each task state with exponential backoff. Use the Map state for parallel file processing.

B. Chain Lambda functions using SQS queues between each step. Each function processes a message and sends the result to the next queue. Use DLQs for failed messages.

C. Use Amazon MWAA (Managed Airflow) to orchestrate the Lambda functions as DAG tasks with retry policies and failure handling.

D. Use EventBridge Pipes to connect the Lambda functions in sequence with automatic retry and error handling.

**Correct Answer: A**

**Explanation:** Step Functions Standard Workflows provide native retry-from-failure capability—when a state fails, the workflow can retry that specific state without re-executing completed states. Standard Workflows (not Express) are appropriate for 2-8 minute steps and persist execution state. The Map state can process the 1,000 daily files in parallel. Retry policies with exponential backoff handle transient failures. Option B (SQS chaining) works but loses the pipeline context—you can't easily track which file is at which stage or retry from a specific step. Option C (MWAA) is heavyweight for this use case and has higher operational cost. Option D (EventBridge Pipes) is designed for point-to-point event routing, not multi-step workflow orchestration.

---

### Question 36

A company needs to serve a machine learning model that receives 100 requests per second with a P99 latency requirement of 100ms. The model is 500MB and takes 200ms for cold inference but 20ms once loaded. Traffic is consistent during business hours and drops to zero overnight.

Which deployment architecture meets these requirements at the LOWEST cost?

A. Deploy the model on Amazon SageMaker Real-Time Inference endpoints with auto-scaling configured to scale down to 1 instance during low traffic and up during peaks.

B. Deploy the model on AWS Lambda with a container image. Configure provisioned concurrency for 150 instances during business hours with a scheduled scaling policy.

C. Deploy the model on Amazon ECS Fargate with auto-scaling based on CPU utilization. Use an Application Load Balancer with connection draining.

D. Deploy the model on SageMaker Serverless Inference endpoints, which automatically scale to zero when not in use and handle cold starts transparently.

**Correct Answer: B**

**Explanation:** Lambda with container images supports up to 10GB deployment packages (sufficient for the 500MB model). Provisioned concurrency eliminates cold starts (which would violate the 100ms P99 requirement since cold inference is 200ms). Scheduled scaling for business hours eliminates provisioned concurrency costs overnight when traffic is zero. At 100 req/sec with 20ms processing time, 150 provisioned instances provide headroom. Option A (SageMaker) keeps at least 1 instance running 24/7 and has higher per-instance costs. Option C (Fargate) has task startup latency and doesn't scale to zero. Option D (Serverless Inference) has cold start latency that would violate the P99 requirement.

---

### Question 37

A company collects clickstream data from a web application and needs to run near-real-time analytics dashboards showing user behavior patterns. The data volume is 5GB per hour. Analysts also need to run ad-hoc SQL queries against the data. Historical data older than 90 days should move to cheaper storage.

Which architecture provides this capability?

A. Ingest data with Kinesis Data Firehose to S3 (partitioned by date). Use Amazon Athena for ad-hoc queries. Create Amazon QuickSight dashboards connected to Athena. Configure S3 lifecycle policies to transition data older than 90 days to S3 Glacier.

B. Ingest data with Kinesis Data Streams processed by Lambda into Amazon Redshift. Use Redshift for both dashboards and ad-hoc queries. Unload data older than 90 days to S3 Glacier.

C. Ingest data with Kinesis Data Firehose directly into Amazon OpenSearch Service. Use OpenSearch Dashboards for visualization. Configure index lifecycle management for archival.

D. Ingest data with Amazon MSK into a Spark Streaming application on EMR. Store results in Amazon Redshift for querying and dashboards.

**Correct Answer: A**

**Explanation:** Kinesis Data Firehose → S3 provides a cost-effective ingestion pipeline with automatic partitioning. Athena provides serverless ad-hoc SQL queries on S3 data without infrastructure management. QuickSight connects to Athena for near-real-time dashboards with SPICE for caching. S3 lifecycle policies handle the 90-day archival requirement natively. At 5GB/hour, this is cost-effective without dedicated cluster resources. Option B (Redshift) adds cluster management overhead and costs for this volume. Option C (OpenSearch) is more expensive for SQL ad-hoc queries and long-term storage. Option D (EMR + MSK) is overly complex for 5GB/hour.

---

### Question 38

A company is designing a notification system that must deliver messages to millions of mobile devices, email addresses, and HTTP endpoints. Messages are categorized by topic (news, alerts, marketing). Users subscribe to topics and must be able to filter within a topic (e.g., only alerts for a specific Region).

Which architecture handles this at scale?

A. Use Amazon SNS with topics for each category. Configure SNS message filtering policies on subscriptions to enable per-subscriber filtering. Use SNS mobile push for device notifications and SNS email/HTTP protocols for other endpoints.

B. Create an Amazon SQS queue per subscriber with a Lambda function that routes messages based on subscriber preferences.

C. Use Amazon Pinpoint for multi-channel messaging with segments based on user preferences. Configure journey workflows for message delivery logic.

D. Build a custom message router using Lambda functions that read subscriber preferences from DynamoDB and deliver to each endpoint individually.

**Correct Answer: A**

**Explanation:** Amazon SNS natively supports the pub/sub pattern with topics, multiple protocol subscriptions (mobile push, email, HTTP), and message filtering policies. Message filtering allows subscribers to receive only messages matching their criteria (e.g., Region-specific alerts) without additional infrastructure. SNS scales to millions of subscribers per topic. Option B (SQS per subscriber) creates millions of queues—impractical at scale. Option C (Pinpoint) is designed for marketing campaigns and user engagement, not general-purpose notification routing. Option D is custom-built with significant development and operational overhead.

---

### Question 39

A company is deploying a web application that must meet these requirements: TLS termination with custom domain, WebSocket support, path-based routing to different backend services, and automatic certificate management. The backends include ECS containers, Lambda functions, and EC2 instances.

Which load balancing solution meets ALL requirements?

A. Application Load Balancer with ACM certificate, WebSocket support enabled by default, path-based routing rules, and target groups for ECS, Lambda, and EC2.

B. Network Load Balancer with TLS listener using an ACM certificate, and target groups for different backends. Use a Lambda function for path-based routing logic.

C. CloudFront distribution with ACM certificate, Lambda@Edge for routing logic, and multiple origins for different backends.

D. API Gateway HTTP API with a custom domain and ACM certificate, routes configured for path-based routing, and integrations with ECS (via VPC Link), Lambda, and EC2 (via VPC Link).

**Correct Answer: A**

**Explanation:** Application Load Balancer meets every requirement: TLS termination with ACM certificates, native WebSocket support (enabled by default on ALB), path-based routing rules, and support for heterogeneous target groups including ECS, Lambda, and EC2 instances. Option B (NLB) operates at Layer 4 and doesn't support path-based routing natively. Option C (CloudFront) supports WebSocket but path-based routing to mixed backend types requires complex Lambda@Edge logic. Option D (API Gateway) supports all features listed but has a 29-second integration timeout for HTTP backends, which may be limiting, and WebSocket requires a separate API.

---

### Question 40

A company needs to implement an event-driven architecture where a single business event (e.g., "order placed") triggers multiple downstream processes: send confirmation email, update inventory, start fulfillment, and update analytics. Each process is independent and must not block others. Failed processes should retry without affecting other processes.

Which architecture provides the BEST decoupling?

A. Publish the event to an Amazon EventBridge custom event bus. Create separate rules for each downstream process, each targeting a different Lambda function (or SQS queue for longer processes). Configure DLQs on each target for failure handling.

B. Publish the event to an SNS topic with four SQS queue subscriptions (one per process). Each queue has a Lambda consumer and a DLQ for failures.

C. Publish the event to a Kinesis Data Stream with four Lambda consumers using enhanced fan-out for independent processing.

D. Use Step Functions with a Parallel state that executes all four processes simultaneously. Configure error handling on each branch.

**Correct Answer: A**

**Explanation:** Amazon EventBridge provides the best decoupling for event-driven architectures. Each rule independently routes events to its target, targets have their own retry policies and DLQs, and adding new consumers requires only a new rule—no changes to the publisher or existing consumers. EventBridge also supports content-based filtering, schema discovery, and archive/replay. Option B (SNS + SQS) works and is a valid pattern, but EventBridge provides richer routing capabilities and better operational visibility. Option C (Kinesis) is designed for streaming data, not discrete business events, and enhanced fan-out adds cost. Option D (Step Functions) couples the processes in a single workflow—adding a new process requires modifying the state machine.

---

### Question 41

A company wants to run a batch processing workload that analyzes 10TB of data stored in S3. The processing involves CPU-intensive transformations using a proprietary algorithm compiled for x86. The job runs weekly and takes approximately 6 hours on a cluster of 20 c5.4xlarge instances. Cost optimization is the primary concern.

Which compute strategy provides the LOWEST cost?

A. Use a managed EMR cluster with Spot Instances for core and task nodes, with On-Demand instances for the master node. Configure instance fleets with multiple instance types.

B. Use AWS Batch with a managed compute environment configured to use Spot Instances. Define a job definition with the proprietary algorithm as a container.

C. Use an ECS cluster with Fargate Spot tasks running the algorithm in containers. Configure ECS service auto-scaling.

D. Use 20 Spot Instances in an Auto Scaling group with a launch template specifying c5.4xlarge and diversified allocation strategy across multiple AZs.

**Correct Answer: B**

**Explanation:** AWS Batch with Spot Instances is optimal for batch processing workloads. Batch automatically manages the compute environment, handles Spot interruptions with job retries, and scales to zero between weekly runs. Using containers allows packaging the proprietary algorithm without EMR overhead. Spot pricing provides up to 90% savings. Option A (EMR) adds Hadoop ecosystem overhead unnecessary for a proprietary algorithm. Option C (Fargate Spot) has a higher per-vCPU cost than EC2 Spot and limits CPU/memory configurations. Option D (ASG) requires custom job scheduling and interruption handling logic that Batch provides natively.

---

### Question 42

A company is designing a data lake that ingests data from 50 different sources including databases, SaaS applications, and streaming sources. The data must be cataloged, transformed, and made available for SQL queries by analysts. Data governance requires column-level access control based on analyst team membership.

Which architecture provides comprehensive data governance?

A. Use AWS Glue crawlers to catalog data in S3. Transform with Glue ETL jobs. Use AWS Lake Formation for the data catalog, column-level permissions, and governed tables. Analysts query through Amazon Athena with Lake Formation enforcing access control.

B. Ingest data into Amazon Redshift using Redshift Spectrum for S3 data. Use Redshift column-level GRANT statements for access control. Analysts query through Redshift.

C. Use AWS Glue for cataloging and ETL. Store data in S3 with IAM policies that restrict access to specific S3 prefixes corresponding to data columns (stored in separate files).

D. Use Amazon EMR with Apache Ranger for column-level security. Catalog data with the Hive metastore. Analysts query through HiveQL or Spark SQL.

**Correct Answer: A**

**Explanation:** AWS Lake Formation provides centralized data governance for data lakes with column-level permissions. It integrates with the Glue Data Catalog for metadata management, supports column-level and row-level access control, and works with IAM/SSO for identity management. Athena respects Lake Formation permissions natively. Glue handles the diverse source ingestion. Option B (Redshift) works for querying but doesn't provide a complete data lake governance framework for 50 diverse sources. Option C (IAM on S3 prefixes) doesn't provide true column-level security. Option D (EMR with Ranger) requires managing EMR clusters and Ranger infrastructure.

---

### Question 43

A company has been running a three-tier application on EC2 instances for two years. Performance monitoring reveals that the application tier instances average 15% CPU utilization with spikes to 40% during peak hours. The database tier uses RDS MySQL with Multi-AZ. Monthly costs are $45,000 for EC2 and $8,000 for RDS.

Which optimization provides the MOST significant cost and operational improvement?

A. Migrate the application tier to AWS Lambda with API Gateway. Convert the application to serverless functions. Migrate the database to Aurora Serverless v2.

B. Right-size the application tier EC2 instances based on the 40% peak utilization. Purchase 1-year Compute Savings Plans for the right-sized instances. Switch RDS to Reserved Instances.

C. Migrate the application tier to ECS Fargate with auto-scaling. Move the database to Aurora Serverless v2 for automatic capacity management.

D. Move all application tier instances to Spot Instances with an On-Demand fallback using a mixed instances Auto Scaling group.

**Correct Answer: C**

**Explanation:** The 15% average utilization with 40% peaks indicates significant over-provisioning. ECS Fargate with auto-scaling right-sizes capacity dynamically—scaling down during low utilization and up during peaks. Aurora Serverless v2 automatically adjusts database capacity, eliminating RDS over-provisioning. This combination reduces both compute waste and operational overhead (no instance management). Option A (full serverless) requires significant application refactoring, which the question doesn't indicate is feasible. Option B (right-sizing + Savings Plans) helps but still runs at fixed capacity between peaks. Option D (Spot) risks interruptions for a production application tier.

---

### Question 44

A company's Lambda functions process S3 events and write to DynamoDB. CloudWatch metrics show that 5% of invocations result in throttling errors from DynamoDB. The DynamoDB table uses provisioned capacity with auto-scaling configured. The auto-scaling has a target utilization of 70% and takes 5-10 minutes to scale up.

Which change MOST effectively reduces throttling?

A. Switch the DynamoDB table to on-demand capacity mode, which handles traffic spikes without capacity planning.

B. Reduce the auto-scaling target utilization to 50% so more headroom is available before throttling occurs.

C. Add an SQS queue between S3 events and the Lambda function to buffer requests. Configure the Lambda event source mapping with a batch window and concurrency limit.

D. Enable DynamoDB Accelerator (DAX) to reduce read load on the base table, freeing capacity for writes.

**Correct Answer: C**

**Explanation:** The root cause is bursty traffic from S3 events overwhelming DynamoDB before auto-scaling can react. An SQS queue buffers the burst, and configuring the Lambda event source mapping with a batch window and concurrency limit controls the rate at which items are written to DynamoDB. This smooths the write pattern to match available capacity. Option A (on-demand) handles spikes but costs significantly more at sustained high throughput. Option B (lower target utilization) wastes more provisioned capacity. Option D (DAX) helps with reads but the question describes write-path throttling from Lambda processing events.

---

### Question 45

A company runs a monolithic application on a single large EC2 instance (r5.4xlarge). The application handles web serving, background job processing, and scheduled tasks. The instance runs at 85% memory utilization and 20% CPU. The team wants to improve reliability without re-architecting the application.

Which improvement provides the BEST reliability enhancement with minimal changes?

A. Create an AMI of the current instance. Deploy behind an Application Load Balancer with an Auto Scaling group (min=1, max=3, desired=1). Configure health checks to automatically replace unhealthy instances.

B. Migrate the application to a container on ECS Fargate with a task definition matching the current instance's resources.

C. Deploy the application on two r5.4xlarge instances behind an ALB with session affinity enabled. Use a shared EFS volume for application state.

D. Switch to a memory-optimized x2idn.xlarge instance for better memory-to-CPU ratio and enable EC2 Auto Recovery.

**Correct Answer: A**

**Explanation:** An Auto Scaling group with min=1 ensures automatic instance replacement on failure, providing self-healing. The AMI captures the current configuration without changes. ALB health checks detect application-level failures. This adds reliability (automatic replacement, health monitoring) without any application changes. Option B (Fargate) requires containerizing the application—a significant change for a monolith. Option C (two instances with session affinity) doesn't handle session state properly for a monolith and doubles costs. Option D (Auto Recovery) only handles host-level failures, not application crashes, and changing instance types may introduce compatibility issues.

---

### Question 46

A company has an Amazon Aurora PostgreSQL cluster that handles both OLTP transactions and complex analytical queries. The analytical queries are causing performance degradation for the OLTP workload during business hours. The analytics team runs queries twice daily.

Which solution isolates the workloads with the LEAST operational effort?

A. Create an Aurora Replica and direct analytical queries to the reader endpoint. The replica handles read traffic without impacting the writer instance.

B. Enable Aurora parallel query, which offloads analytical processing to the storage layer, reducing impact on the writer instance.

C. Export Aurora data to Amazon Redshift using the zero-ETL integration. Direct analytical queries to Redshift.

D. Create an Aurora clone twice daily for analytics. Run queries against the clone and delete it after use.

**Correct Answer: C**

**Explanation:** Aurora zero-ETL integration with Redshift continuously replicates data without requiring ETL pipelines. Analytical queries run on Redshift, which is optimized for complex analytics, completely isolating the OLTP workload. This requires the least operational effort once configured. Option A (Aurora Replica) shares the same storage layer—heavy analytical queries on the replica can still impact the writer through storage contention. Option B (parallel query) reduces but doesn't eliminate the impact on the writer instance. Option D (cloning twice daily) requires scheduling, management, and doesn't provide real-time data for analytics.

---

### Question 47

A company uses AWS Lambda functions that connect to an RDS PostgreSQL database. During traffic spikes, the database reaches its maximum connection limit (200 connections), causing new Lambda invocations to fail with "too many connections" errors. The Lambda function currently opens a new database connection per invocation.

Which solution resolves this with the LEAST code changes?

A. Deploy Amazon RDS Proxy in front of the database. Update the Lambda function's connection string to point to the RDS Proxy endpoint. RDS Proxy manages connection pooling automatically.

B. Implement connection pooling in the Lambda function code using a library like pgBouncer embedded in the Lambda layer.

C. Increase the RDS instance size to support more concurrent connections. Configure Lambda reserved concurrency to match the new connection limit.

D. Refactor the Lambda function to use DynamoDB instead of RDS to avoid connection-based scaling issues.

**Correct Answer: A**

**Explanation:** Amazon RDS Proxy is purpose-built for this problem. It maintains a pool of database connections and multiplexes Lambda invocations across them, dramatically reducing the number of connections to the database. The only code change is updating the connection string endpoint. Option B (embedded pgBouncer) adds significant complexity and doesn't work well in Lambda's stateless execution model. Option C (larger instance) is expensive and doesn't address the fundamental mismatch between Lambda's scaling and connection-based databases. Option D requires a complete data layer rewrite.

---

### Question 48

A company's CloudWatch monitoring reveals that their API Gateway backed by Lambda has P99 latency of 3 seconds, while P50 is 200ms. Investigation shows that cold starts are the primary cause of the high P99 latency. The Lambda functions use a 256MB memory allocation, a 50MB deployment package, and connect to a VPC.

Which combination of changes MOST effectively reduces P99 latency? (Choose TWO.)

A. Enable Lambda provisioned concurrency with auto-scaling based on utilization.

B. Increase Lambda memory to 1024MB, which also increases CPU allocation and reduces initialization time.

C. Move the Lambda functions out of the VPC to eliminate ENI attachment time during cold starts.

D. Reduce the deployment package size by removing unnecessary dependencies and using Lambda layers for shared libraries.

E. Enable Lambda SnapStart (if using Java) or use the Lambda execution environment reuse pattern.

**Correct Answer: A, B**

**Explanation:** Provisioned concurrency (A) eliminates cold starts entirely by keeping execution environments pre-initialized—this directly addresses the P99 latency problem. Increasing memory to 1024MB (B) provides proportionally more CPU, which accelerates initialization (cold start) time for any invocations not covered by provisioned concurrency. Together, they dramatically reduce P99 latency. Option C is outdated—since 2019, VPC-enabled Lambda functions no longer have additional cold start latency from ENI creation due to Hyperplane ENI improvements. Option D helps marginally but doesn't eliminate cold starts. Option E (SnapStart) is Java-only and the question doesn't specify Java.

---

### Question 49

A company runs a production workload on an Auto Scaling group of EC2 instances behind an ALB. They want to implement canary deployments for application updates—routing 5% of traffic to the new version initially, then gradually increasing to 100% if health checks pass. Rollback must be automatic if error rates exceed 1%.

Which approach implements this with the LEAST operational effort?

A. Use AWS CodeDeploy with an in-place deployment configured for a canary deployment strategy (Canary10Percent5Minutes). CodeDeploy uses ALB target group shifting and automatic rollback based on CloudWatch alarms.

B. Create a second Auto Scaling group with the new version. Configure the ALB listener rules with weighted target groups (5% to new, 95% to old). Use a Lambda function that monitors CloudWatch metrics and adjusts weights.

C. Use AWS App Mesh with a virtual router that splits traffic between two virtual nodes (old and new versions) using weighted routing. Configure health checks for automatic rollback.

D. Deploy the new version using a CodeDeploy blue/green deployment with traffic shifting configured for LinearCanary10Percent5Minutes. Configure automatic rollback triggers based on CloudWatch alarms.

**Correct Answer: D**

**Explanation:** CodeDeploy blue/green deployments with EC2/Auto Scaling support traffic shifting strategies including canary patterns. The deployment creates a new Auto Scaling group, shifts traffic gradually using the ALB, and automatically rolls back if CloudWatch alarms trigger. This is the lowest operational effort because CodeDeploy manages the entire process. Option A describes in-place deployment, which updates instances sequentially (not canary). Option B requires custom Lambda logic for traffic shifting and rollback. Option C (App Mesh) adds a service mesh layer, which is significant infrastructure overhead for simple traffic shifting.

---

### Question 50

A company stores application logs in CloudWatch Logs across 20 accounts. The security team needs a centralized search capability across all accounts' logs with a retention of 90 days. They also need to create dashboards showing cross-account error trends.

Which architecture provides centralized log analytics with the LEAST operational overhead?

A. Configure CloudWatch cross-account observability by designating a monitoring account. Source accounts share their CloudWatch data with the monitoring account. Use CloudWatch Logs Insights in the monitoring account to query across all accounts.

B. Set up Kinesis Data Firehose in each account to stream CloudWatch Logs to a centralized S3 bucket. Use Amazon Athena for querying and QuickSight for dashboards.

C. Deploy an Amazon OpenSearch Service domain in a central account. Configure CloudWatch Logs subscription filters in each account to stream logs to OpenSearch via Lambda.

D. Create an organization CloudTrail and direct all logs to a centralized S3 bucket. Use Athena for querying.

**Correct Answer: A**

**Explanation:** CloudWatch cross-account observability allows a monitoring account to view and query CloudWatch data (logs, metrics, traces) from source accounts without moving the data. CloudWatch Logs Insights provides a powerful query engine that works across accounts. Dashboards can be created in the monitoring account showing cross-account data. This is fully managed with minimal setup. Option B requires Firehose configuration in each account plus separate analytics infrastructure. Option C requires OpenSearch cluster management and Lambda functions in each account. Option D—CloudTrail collects API activity, not application logs.

---

### Question 51

A company has an application that writes data to an S3 bucket with versioning enabled. Over 18 months, the bucket has grown to 50TB, with 30TB being non-current versions. The compliance team requires keeping all versions for 7 years, but the current storage cost is unsustainable.

Which S3 lifecycle configuration BEST optimizes costs while maintaining compliance?

A. Create a lifecycle rule that transitions non-current versions to S3 Glacier Instant Retrieval after 30 days and to S3 Glacier Deep Archive after 90 days. Transition current versions to S3 Intelligent-Tiering after 60 days.

B. Create a lifecycle rule that deletes non-current versions after 90 days and enable S3 Cross-Region Replication to a Glacier vault for compliance.

C. Create a lifecycle rule that transitions all objects (current and non-current) to S3 Glacier Deep Archive after 1 day.

D. Enable S3 Intelligent-Tiering for the entire bucket. It automatically moves objects between access tiers based on usage patterns, including archive tiers.

**Correct Answer: A**

**Explanation:** This configuration optimizes costs across different access patterns: non-current versions (which are rarely accessed) move to Glacier Instant Retrieval at 30 days, then to Deep Archive at 90 days—achieving ~95% cost reduction for the 30TB of non-current versions. Current versions move to Intelligent-Tiering, which optimizes based on actual access patterns. All versions are retained for compliance. Option B deletes non-current versions, violating the 7-year retention requirement. Option C moves current versions to Deep Archive, making them inaccessible without retrieval delays. Option D doesn't leverage the deepest archive tiers for non-current versions as aggressively.

---

### Question 52

A company's VPC has grown to include 200 security groups with 3,000 rules total. Engineers frequently report that new security group rules take hours to be reviewed and applied. The team wants to simplify security group management while maintaining fine-grained access control.

Which approach simplifies management without reducing security?

A. Replace individual IP-based rules with security group references where possible. Create security groups based on application roles (web-tier, app-tier, db-tier) and reference these groups in rules instead of IP ranges.

B. Replace all security groups with a single network ACL per subnet that consolidates all rules. NACLs provide stateless filtering at the subnet level.

C. Implement AWS Firewall Manager to centrally manage security groups across the VPC. Create Firewall Manager security group policies that automatically apply to resources.

D. Migrate from security groups to AWS Network Firewall for centralized traffic inspection and rule management.

**Correct Answer: C**

**Explanation:** AWS Firewall Manager centrally manages security group policies across accounts and VPCs. It can define baseline security group rules that are automatically applied to resources matching specified criteria, enforce audit policies to detect non-compliant security groups, and manage security groups at scale. This reduces the review bottleneck by providing centralized policy management. Option A is a good practice but doesn't address the management and review process. Option B (single NACL) loses the fine-grained per-resource control that security groups provide. Option D (Network Firewall) is for advanced traffic inspection and doesn't replace security groups for instance-level access control.

---

### Question 53

A company has an existing application using Amazon SQS for message processing. Occasionally, messages are processed twice due to SQS's at-least-once delivery, causing duplicate order entries in the database. The team wants to prevent duplicate processing without changing to FIFO queues (to maintain higher throughput).

Which approach prevents duplicate processing with the LEAST application changes?

A. Implement idempotency in the processing Lambda function by storing processed message IDs in a DynamoDB table with a conditional write. Before processing, check if the message ID already exists.

B. Switch to Amazon Kinesis Data Streams, which provides exactly-once processing semantics.

C. Enable SQS message deduplication by setting the content-based deduplication attribute on the standard queue.

D. Increase the SQS visibility timeout to 24 hours to prevent messages from being redelivered while processing.

**Correct Answer: A**

**Explanation:** Implementing idempotency using DynamoDB conditional writes is the standard pattern for handling at-least-once delivery. The Lambda function checks DynamoDB for the message ID before processing—if it exists, the message is skipped. DynamoDB's conditional PutItem (attribute_not_exists) provides atomic check-and-write. This is a minimal change—only the processing function is modified. Option B (Kinesis) doesn't provide exactly-once semantics inherently and requires significant architecture changes. Option C is incorrect—content-based deduplication is only available on FIFO queues, not standard queues. Option D doesn't prevent duplicate delivery—it only delays redelivery.

---

### Question 54

A company is migrating a 200TB Oracle database to AWS. The database supports an OLTP application with 50,000 transactions per second. The migration must have less than 2 hours of downtime. The company wants to move to Amazon Aurora PostgreSQL to reduce licensing costs.

Which migration strategy meets the downtime requirement?

A. Use AWS Database Migration Service (DMS) with a full load plus change data capture (CDC) task. Set up an Oracle-to-PostgreSQL migration with SCT for schema conversion. Perform the full load during a maintenance window, then enable CDC for ongoing replication. Cut over when the CDC lag is minimal.

B. Use AWS Snowball Edge devices to transfer the 200TB database export to S3, then import into Aurora PostgreSQL using pg_restore.

C. Set up an Oracle Data Guard replica, then use DMS to replicate from the replica to Aurora PostgreSQL to minimize impact on the production database.

D. Use the AWS Schema Conversion Tool to convert the schema, export the data using Oracle Data Pump, upload to S3, and import into Aurora using the aws_s3 extension.

**Correct Answer: A**

**Explanation:** DMS with full load + CDC enables continuous replication from Oracle to Aurora PostgreSQL while the source database remains operational. The full load migrates the initial 200TB, and CDC captures ongoing changes. When the replication lag drops to near-zero, the cutover requires only redirecting the application—achieving less than 2 hours downtime. AWS SCT handles the schema conversion from Oracle to PostgreSQL. Option B (Snowball) doesn't provide ongoing replication during migration, resulting in extended downtime. Option C adds complexity with Data Guard but doesn't change the fundamental approach—DMS can replicate directly from the primary. Option D (export/import) requires full downtime during the data transfer, far exceeding 2 hours for 200TB.

---

### Question 55

A company wants to migrate 500 virtual machines from VMware vSphere to AWS. They need to discover application dependencies, group VMs by application, and create migration wave plans. The migration should minimize downtime for each application group.

Which combination of services provides the MOST automated migration path? (Choose TWO.)

A. Use AWS Application Discovery Service with the Agentless Collector deployed in the vSphere environment to discover VMs, their configurations, and performance metrics.

B. Use AWS Migration Hub to organize discovered servers into applications, create wave groups, and track migration progress across all servers.

C. Use AWS Server Migration Service (SMS) to replicate each VM incrementally, then perform a final cutover with minimal downtime.

D. Use the AWS Cloud Adoption Readiness Tool (CART) to assess each VM for cloud readiness and generate migration recommendations.

E. Use CloudEndure Migration to perform continuous block-level replication of each VM to AWS, then cut over with minimal downtime.

**Correct Answer: A, B**

**Explanation:** Application Discovery Service with the Agentless Collector (A) discovers VMs in the vSphere environment, collects configuration data, and maps network dependencies between servers—critical for identifying application groups. Migration Hub (B) provides a centralized dashboard to organize discovered servers into application groups, create migration waves, and track progress. For the actual migration execution, either AWS MGN (the successor to CloudEndure) or SMS would be used, but the question asks about discovery and planning. Option C (SMS) is being deprecated in favor of AWS MGN. Option D (CART) is a questionnaire-based assessment tool, not a discovery tool. Option E (CloudEndure) is now AWS Application Migration Service (MGN).

---

### Question 56

A company is migrating a stateful Windows application from on-premises to AWS. The application stores session data in the local file system, uses Windows Authentication via Active Directory, and communicates with other applications via NetBIOS. The company wants minimal application changes.

Which migration approach maintains compatibility?

A. Launch EC2 Windows instances in a VPC. Deploy AWS Managed Microsoft AD and establish a one-way trust with the on-premises AD. Attach Amazon FSx for Windows File Server for shared file storage. Configure security groups to allow NetBIOS traffic.

B. Containerize the application on Amazon ECS with Windows containers. Use AWS Directory Service Simple AD for authentication and EFS for file storage.

C. Migrate the application to AWS Elastic Beanstalk with a Windows platform. Use Amazon Cognito for authentication and S3 for session storage.

D. Launch the application on EC2 with a VPN connection to on-premises. Keep using the on-premises AD with no changes. Store session data on EBS volumes.

**Correct Answer: A**

**Explanation:** EC2 Windows instances provide full Windows compatibility. AWS Managed Microsoft AD supports Windows Authentication with trust relationships to on-premises AD. FSx for Windows File Server provides SMB-compatible shared storage for session data. Security groups can allow NetBIOS ports (137-139, 445). This requires minimal application changes. Option B—ECS Windows containers may not support all Windows features, Simple AD has limitations, and EFS doesn't support Windows. Option C—Elastic Beanstalk and Cognito don't support Windows Authentication natively. Option D works but keeping AD on-premises without AWS Directory Service means latency-sensitive authentication depends on VPN reliability.

---

### Question 57

A company is migrating a legacy application that uses an Oracle database with extensive PL/SQL stored procedures. The application team estimates 18 months to rewrite the stored procedures for PostgreSQL. They want to migrate to AWS immediately to reduce datacenter costs but plan to refactor the database later.

Which migration strategy accomplishes this?

A. Migrate the Oracle database to Amazon RDS for Oracle using DMS for the initial migration phase. Later, use SCT to convert PL/SQL and DMS to migrate to Aurora PostgreSQL.

B. Use SCT to automatically convert all PL/SQL to PostgreSQL. Deploy on Aurora PostgreSQL immediately.

C. Migrate to Amazon Redshift, which supports PL/pgSQL similar to Oracle PL/SQL.

D. Use Oracle on EC2 instances with Bring Your Own License (BYOL) to avoid cloud database costs, then refactor to Aurora.

**Correct Answer: A**

**Explanation:** Amazon RDS for Oracle provides a managed Oracle database that runs the existing PL/SQL procedures without modification, enabling an immediate "lift and shift" to reduce datacenter costs. DMS handles the migration with minimal downtime. The team can then spend 18 months refactoring PL/SQL using SCT (which converts a significant percentage automatically) and migrate to Aurora PostgreSQL when ready. This is a two-phase migration: rehost first, then refactor. Option B is unrealistic—SCT can't automatically convert complex PL/SQL with 100% accuracy, especially extensive stored procedures. Option C—Redshift is a data warehouse, not an OLTP database. Option D—Oracle on EC2 is unmanaged and doesn't reduce operational costs as effectively as RDS.

---

### Question 58

A company has 100TB of data in an on-premises Hadoop cluster that needs to be migrated to Amazon S3 for a new data lake. The data is actively being read and written. The internet connection is 1 Gbps. The migration must complete within 2 weeks.

Which approach meets the timeline?

A. Order two AWS Snowball Edge Storage Optimized devices (80TB each). Copy the data to the devices and ship them to AWS. Use S3 sync for any changes that occurred during shipping.

B. Use AWS DataSync with an agent deployed on-premises to transfer data over the internet connection. DataSync optimizes bandwidth usage and handles retries.

C. Set up a Direct Connect 10Gbps dedicated connection and use DataSync to transfer the data.

D. Use the S3 CLI with multipart upload to transfer the data over the internet connection.

**Correct Answer: A**

**Explanation:** At 1 Gbps, transferring 100TB over the internet takes approximately 10 days (100TB × 8 / 1Gbps = 800,000 seconds ≈ 9.3 days) at full utilization—leaving almost no margin within 2 weeks, and sustained full utilization is unrealistic. Two Snowball Edge devices (160TB total capacity) can be loaded in parallel, shipped (typically 4-6 days including loading and transit), and the data is imported to S3. Changes during the shipping period can be captured using DataSync or S3 sync over the 1Gbps connection (delta changes are small). Option B (DataSync over 1Gbps) is risky given the tight timeline and bandwidth constraints. Option C (Direct Connect) takes weeks to provision, exceeding the deadline. Option D (S3 CLI) is slower than DataSync and lacks optimization.

---

### Question 59

A company has a legacy three-tier application where the web tier, application tier, and database tier are all on the same physical server. They want to migrate to AWS and implement proper tier separation for scalability and security. The application uses a shared file system between the web and application tiers.

Which migration approach provides proper separation?

A. Use the Strangler Fig pattern to gradually extract each tier: deploy the web tier on CloudFront + S3 for static content and ALB + EC2 for dynamic content, the application tier on EC2 in private subnets, and migrate the database to RDS. Use Amazon EFS for the shared file system.

B. Lift and shift the entire server to a single large EC2 instance first. Then gradually refactor each tier into separate services.

C. Deploy all three tiers in separate containers on a single ECS task definition sharing the same task volume.

D. Migrate directly to a serverless architecture: S3 + CloudFront for the web tier, Lambda for the application tier, and DynamoDB for the database.

**Correct Answer: A**

**Explanation:** The Strangler Fig pattern allows gradual decomposition while maintaining functionality. CloudFront + S3 handles static content, ALB routes dynamic requests to EC2-based web servers, the application tier runs in private subnets for security, and RDS provides managed database services. Amazon EFS provides a POSIX-compatible shared file system that replaces the local shared filesystem. This achieves proper tier separation with independent scaling. Option B delays the benefit of separation and runs a monolith on AWS. Option C keeps everything coupled in one task—not true separation. Option D requires complete application rewrite, which isn't feasible for a legacy application.

---

### Question 60

A company is migrating microservices from an on-premises Kubernetes cluster to Amazon EKS. The services use Consul for service discovery, Vault for secrets management, and Prometheus for monitoring. The team wants to minimize the number of tools to manage post-migration.

Which combination of AWS-native replacements reduces operational overhead? (Choose TWO.)

A. Replace Consul with AWS Cloud Map for service discovery. EKS integrates with Cloud Map through the AWS Cloud Map MCS controller.

B. Replace Vault with AWS Secrets Manager for secrets management. Use the Secrets Store CSI driver to mount secrets directly into pods.

C. Keep Prometheus but deploy it as Amazon Managed Service for Prometheus (AMP). Use Amazon Managed Grafana for visualization.

D. Replace all three tools with AWS App Mesh, which provides service discovery, secrets management, and monitoring in a single service.

E. Replace Consul with CoreDNS (built into EKS) for service discovery within the cluster.

**Correct Answer: B, C**

**Explanation:** Replacing Vault with Secrets Manager (B) eliminates Vault cluster management. The Secrets Store CSI driver provides native Kubernetes integration, mounting secrets as volumes. Amazon Managed Prometheus (C) keeps the Prometheus query language and ecosystem that the team knows while eliminating the operational overhead of running Prometheus infrastructure. AMP handles scaling, availability, and retention. Option A (Cloud Map) works but CoreDNS is already built into EKS for in-cluster service discovery, making Cloud Map unnecessary unless cross-service-mesh discovery is needed. Option D is incorrect—App Mesh doesn't manage secrets. Option E (CoreDNS) is valid for basic in-cluster discovery but doesn't provide health checking or cross-cluster discovery that Consul offers.

---

### Question 61

A retail company is migrating its e-commerce platform from on-premises to AWS during a Black Friday preparation period. They need a migration approach that allows them to test the AWS deployment under production-like load before fully cutting over, and enables instant rollback to on-premises if issues arise.

Which migration strategy supports this?

A. Implement a blue/green migration using Route 53 weighted routing. Direct 10% of production traffic to the AWS deployment while 90% continues to on-premises. Gradually increase the AWS weight as confidence grows. Use health checks for automatic DNS failover.

B. Perform a cutover migration during a maintenance window. If issues arise, restore from a backup to on-premises.

C. Use AWS Application Migration Service (MGN) to maintain continuous replication. Perform test launches on AWS while production runs on-premises. When ready, perform the cutover and keep on-premises as a standby.

D. Set up a pilot light environment on AWS with only the database replicated. During cutover, launch the full application stack and redirect traffic.

**Correct Answer: A**

**Explanation:** Route 53 weighted routing enables gradual traffic shifting from on-premises to AWS, allowing real production load testing on the AWS deployment. Starting at 10% provides a safe initial test, and weights can be adjusted in real-time. If issues arise, setting the AWS weight to 0 provides instant rollback. Health checks add automatic failover. This is ideal for validating a high-stakes migration before a peak event. Option B (cutover migration) is all-or-nothing with no gradual validation. Option C (MGN) provides test launches but not with real production traffic. Option D (pilot light) requires spinning up the full stack during cutover, which is risky for a Black Friday timeline.

---

### Question 62

A company is migrating a legacy application that depends on multicast networking for cluster communication between application nodes. AWS VPCs do not natively support multicast. The application cannot be modified.

Which solution enables multicast communication on AWS?

A. Deploy the application on EC2 instances and use AWS Transit Gateway multicast domains. Associate the instances' subnets with the multicast domain and configure multicast group membership.

B. Deploy the application on EC2 instances with an overlay network (e.g., VXLAN) to encapsulate multicast traffic in unicast UDP packets.

C. Deploy the application in a placement group with cluster strategy, which enables multicast within the placement group.

D. Use Elastic Fabric Adapter (EFA) on the EC2 instances, which supports multicast for high-performance computing.

**Correct Answer: A**

**Explanation:** AWS Transit Gateway supports multicast domains, enabling multicast communication between EC2 instances in associated subnets. You create a multicast domain, associate subnets, and register instances as multicast group members or sources. This is an AWS-native solution requiring no application changes. Option B (overlay network) works but requires additional network configuration and management overhead. Option C is incorrect—placement groups don't enable multicast; they optimize placement for low latency. Option D—EFA supports MPI and custom protocols but doesn't provide standard IP multicast support.

---

### Question 63

A company runs a data analytics workload on a fleet of 50 r5.2xlarge On-Demand instances that run 24/7. The workload is steady-state with minimal variation. The company has committed to running this workload for at least 3 years. They want to minimize compute costs.

Which purchasing option provides the GREATEST savings?

A. Purchase a 3-year All Upfront Compute Savings Plan covering the full workload.

B. Purchase 3-year All Upfront EC2 Instance Savings Plans for r5.2xlarge in the current Region.

C. Purchase 3-year All Upfront Reserved Instances for 50 r5.2xlarge instances in the current Availability Zone.

D. Convert all instances to Spot Instances with a fallback On-Demand Auto Scaling group.

**Correct Answer: C**

**Explanation:** For a steady-state, committed workload with no variation, 3-year All Upfront Reserved Instances provide the deepest discount—up to 72% off On-Demand pricing. Zonal RIs also provide capacity reservation, ensuring instances are always available. Since the workload is fixed (same instance type, same Region, 3-year commitment), the inflexibility of Standard RIs is not a concern. Option A (Compute Savings Plans) provides up to 66% savings—less than RIs because of their flexibility premium. Option B (EC2 Instance Savings Plans) provides similar savings to RIs but without capacity reservation. Option D (Spot) is unsuitable for a 24/7 steady-state workload due to interruption risk.

---

### Question 64

A company has multiple S3 buckets totaling 500TB across 10 accounts. Monthly storage costs are $11,500. Analysis shows that 60% of the data hasn't been accessed in 6 months and 20% hasn't been accessed in 2 years. The remaining 20% is actively accessed.

Which S3 storage optimization strategy provides the GREATEST cost reduction?

A. Enable S3 Intelligent-Tiering on all buckets. Configure the archive access tier (90 days) and deep archive access tier (180 days).

B. Create lifecycle rules to transition objects not accessed in 6 months to S3 Glacier Instant Retrieval and objects not accessed in 2 years to S3 Glacier Deep Archive.

C. Move all data to a single S3 bucket with S3 Intelligent-Tiering to consolidate management and leverage automatic tiering.

D. Use S3 Storage Lens to analyze access patterns and manually move data between storage classes based on recommendations.

**Correct Answer: A**

**Explanation:** S3 Intelligent-Tiering with archive tiers provides automatic cost optimization without lifecycle management complexity. Objects not accessed for 90 days move to the archive access tier (same cost as Glacier Instant Retrieval), and objects not accessed for 180 days move to the deep archive tier (same cost as Glacier Deep Archive). Actively accessed data stays in the frequent access tier. No retrieval fees for Intelligent-Tiering means no cost penalty for occasionally accessed archived data. Option B (lifecycle rules) works but requires knowing exact access patterns upfront and charges retrieval fees if archived data is accessed. Option C—consolidating into one bucket doesn't improve costs and creates management challenges. Option D is manual and ongoing.

---

### Question 65

A company runs a web application behind an ALB with an Auto Scaling group. The application uses RDS MySQL with Multi-AZ. Current monthly costs: EC2 ($15,000), RDS ($5,000), Data Transfer ($3,000), ALB ($500). The company wants to reduce costs by 30% without affecting availability.

Which combination of changes achieves this goal? (Choose TWO.)

A. Purchase a 1-year No Upfront Compute Savings Plan covering 80% of the steady-state EC2 usage. Use On-Demand for the remaining variable capacity.

B. Enable CloudFront in front of the ALB to cache static content and reduce both data transfer costs and ALB processing.

C. Replace RDS MySQL Multi-AZ with a single-AZ Aurora Serverless instance.

D. Switch from ALB to a Network Load Balancer to reduce load balancer costs.

E. Migrate the application to Lambda with API Gateway to eliminate EC2 costs entirely.

**Correct Answer: A, B**

**Explanation:** A Compute Savings Plan (A) covering 80% of steady-state usage provides approximately 36% savings on that portion—saving roughly $4,300/month on EC2 costs. CloudFront (B) caches static content at edge locations, reducing ALB request processing and data transfer. Data transfer from CloudFront is cheaper than from ALB, and caching reduces origin requests, lowering EC2 load. Together, these achieve >30% overall savings. Option C (single-AZ) sacrifices the availability requirement. Option D—NLB costs are similar to ALB and NLB doesn't support Layer 7 routing. Option E requires complete application rewrite.

---

### Question 66

A company runs 200 development EC2 instances that are only used during business hours (8 AM - 6 PM, Monday to Friday). Currently, all instances are On-Demand and run 24/7. Monthly cost is $30,000.

Which approach provides the GREATEST cost savings?

A. Create an AWS Instance Scheduler solution using Lambda and CloudWatch Events to start instances at 8 AM and stop them at 6 PM on weekdays. Use On-Demand pricing for the running hours.

B. Purchase Reserved Instances for all 200 instances since they are used consistently during business hours.

C. Convert all instances to Spot Instances with persistent Spot requests that activate during business hours.

D. Create an Instance Scheduler to run instances only during business hours AND purchase a Compute Savings Plan covering the business-hours compute.

**Correct Answer: D**

**Explanation:** The combination maximizes savings from two angles. First, scheduling reduces running hours from 168/week to 50/week (a 70% reduction). Then, applying a Compute Savings Plan to the remaining 50 hours provides an additional ~30% savings on those hours. Total savings: approximately 79% ($30,000 → ~$6,300). Option A (scheduling only) saves 70% but pays full On-Demand for running hours. Option B (Reserved Instances 24/7) wastes reservation during non-business hours—you pay for 168 hours but use 50. Option C (Spot) risks interruptions during active development, causing developer productivity loss.

---

### Question 67

A company uses Amazon DynamoDB with provisioned capacity for a production table. The table has predictable traffic patterns: 1,000 WCU during the day and 100 WCU at night. Auto-scaling is configured but frequently undershoots during the morning traffic ramp-up, causing throttling.

Which approach optimizes cost while eliminating throttling?

A. Switch to DynamoDB on-demand capacity mode, which instantly accommodates any traffic level without throttling.

B. Configure DynamoDB auto-scaling with a lower target utilization (40% instead of 70%) and use scheduled scaling to pre-provision capacity 30 minutes before the morning ramp-up.

C. Increase the provisioned write capacity to 1,000 WCU constantly and disable auto-scaling to ensure capacity is always available.

D. Enable DynamoDB global tables, which provide unlimited burst capacity across Regions.

**Correct Answer: B**

**Explanation:** Scheduled scaling pre-provisions capacity before the predictable morning ramp-up, preventing the throttling that occurs when auto-scaling reacts too slowly. The lower target utilization (40%) provides more headroom for unexpected spikes. Night-time scaling reduces capacity to save costs. This optimizes both cost and performance. Option A (on-demand) eliminates throttling but costs approximately 6.5x more per WCU than provisioned capacity—expensive for a predictable workload. Option C (constant 1,000 WCU) wastes capacity during the 100 WCU night period. Option D—global tables don't provide "unlimited burst capacity."

---

### Question 68

A company processes 10 million images daily using a fleet of GPU instances (p3.2xlarge). Processing takes 30 seconds per image and can tolerate interruptions. Current monthly cost is $200,000 using On-Demand instances.

Which approach provides the LOWEST processing cost?

A. Use Spot Instances with a diversified allocation strategy across p3.2xlarge, p3.8xlarge, and g4dn.xlarge. Implement checkpointing so interrupted jobs can resume on new instances. Use SQS for job queuing.

B. Purchase 1-year Reserved Instances for p3.2xlarge to get a 40% discount.

C. Use AWS Batch with Spot Instances and retry policies for interrupted jobs. Allow Batch to select optimal instance types from GPU instance families.

D. Migrate to Amazon SageMaker Processing jobs with managed Spot training for the image processing.

**Correct Answer: C**

**Explanation:** AWS Batch with Spot Instances provides the lowest cost for batch image processing. Batch manages the Spot Instance lifecycle, automatically retries interrupted jobs, and can select from multiple GPU instance types to find the best Spot pricing. SQS queuing is handled natively by Batch's job queue. Spot pricing for GPU instances can be 60-90% off On-Demand. Option A is essentially a manual version of what Batch provides—more operational overhead. Option B (Reserved Instances at 40% savings) saves $80,000, while Spot can save $120,000-$180,000. Option D (SageMaker Processing) is designed for ML workflows and adds overhead for simple image processing.

---

### Question 69

A company runs a SaaS application that charges customers based on usage. Each customer's resources are tagged with their customer ID. The company needs to accurately allocate AWS costs to each customer, including shared infrastructure costs like NAT gateways and Transit Gateway.

Which approach provides the MOST accurate cost allocation?

A. Enable user-defined cost allocation tags in the Billing console. Use AWS Cost Explorer to filter costs by the customer ID tag. Distribute untagged shared costs proportionally based on each customer's tagged resource usage.

B. Create a separate AWS account per customer using AWS Organizations. All costs in each account are automatically attributed to that customer.

C. Use AWS Cost and Usage Report (CUR) delivered to S3. Process with Athena to aggregate costs by customer tag and allocate shared costs using a Lambda function that applies custom allocation rules.

D. Use AWS Budgets with per-customer budgets filtered by tags. Export budget reports for customer billing.

**Correct Answer: C**

**Explanation:** The CUR provides the most granular cost data including resource-level costs with tags. Processing with Athena allows complex queries that aggregate tagged costs per customer and apply custom allocation rules for shared infrastructure (e.g., allocate NAT gateway costs based on data transfer per customer, Transit Gateway costs based on attachment usage). Lambda automation enables custom business logic for allocation. Option A (Cost Explorer) provides visual analysis but lacks the granularity and custom allocation logic needed for shared costs. Option B (account-per-customer) is impractical for SaaS with many customers and doesn't solve shared infrastructure allocation. Option D (Budgets) is for monitoring, not cost allocation.

---

### Question 70

A company has a multi-Region active-passive disaster recovery setup. The primary Region runs the full application stack, and the DR Region maintains a pilot light (only database replicas). During a DR test, spinning up the full application stack in the DR Region took 45 minutes, exceeding the 15-minute RTO.

Which changes reduce the DR activation time to meet the 15-minute RTO?

A. Pre-deploy the application infrastructure in the DR Region using CloudFormation but keep EC2 instances stopped and Auto Scaling groups at zero capacity. During DR, update the ASG desired capacity and start instances. Use pre-built AMIs.

B. Upgrade from pilot light to warm standby—run a scaled-down but fully functional application stack in the DR Region. During DR, scale up the resources.

C. Use Lambda functions to replace the application tier in the DR Region, eliminating instance startup time.

D. Deploy identical full-scale infrastructure in both Regions (active-active) to eliminate any activation time.

**Correct Answer: B**

**Explanation:** Warm standby maintains a running (but scaled-down) application stack in the DR Region. During a DR event, Auto Scaling groups increase desired capacity to full production levels. Since instances are already running and application code is deployed, scaling up takes minutes rather than the 45 minutes needed to launch from scratch. This meets the 15-minute RTO. Option A (stopped instances) still requires instance boot time, application startup, and health check passing—likely exceeding 15 minutes. Option C requires significant re-architecture to serverless. Option D (active-active) eliminates activation time but doubles costs for a passive DR Region.

---

### Question 71

A company stores 1PB of log data in S3. Analysts run Athena queries against this data but queries take 10-20 minutes due to the data volume. The most common queries filter by date range and service name. The data is stored as uncompressed JSON files.

Which combination of optimizations provides the GREATEST query performance improvement? (Choose TWO.)

A. Convert the data from JSON to Apache Parquet format using AWS Glue ETL jobs. Parquet provides columnar storage with compression.

B. Partition the data in S3 by date and service name, matching the most common query filter patterns. Update the Glue Data Catalog with partition information.

C. Increase the Athena workgroup's DPU allocation to process more data in parallel.

D. Create an Athena materialized view for the most common queries.

E. Enable S3 Transfer Acceleration on the bucket to speed up data reads.

**Correct Answer: A, B**

**Explanation:** Converting to Parquet (A) provides columnar storage (only reading required columns), compression (typically 75% reduction), and predicate pushdown—dramatically reducing the data scanned. Partitioning by date and service name (B) allows Athena to skip entire partitions that don't match the WHERE clause, reducing the data scanned from 1PB to only relevant partitions. Together, these can reduce query times from minutes to seconds. Option C—Athena doesn't have configurable DPU allocation (that's Athena provisioned capacity, which helps with concurrency, not single-query speed). Option D—Athena doesn't support traditional materialized views. Option E—Transfer Acceleration is for uploads, not for Athena query reads.

---

### Question 72

A company has 30 EC2 instances running various workloads with different utilization patterns. Some instances run at 10% CPU, others at 80%. The company uses a mix of instance types chosen when the workloads were first deployed two years ago. Monthly EC2 costs are $25,000.

Which approach provides RIGHT-SIZING recommendations with the LEAST effort?

A. Enable AWS Compute Optimizer for the account. Review the recommendations for each instance, which analyze 14 days of CloudWatch metrics to suggest optimal instance types.

B. Use AWS Trusted Advisor cost optimization checks to identify underutilized instances and follow the recommendations.

C. Write a custom script that queries CloudWatch metrics for all instances and generates a report of instances with average CPU below 40%.

D. Use AWS Cost Explorer right-sizing recommendations filtered by the account to identify cost optimization opportunities.

**Correct Answer: A**

**Explanation:** AWS Compute Optimizer analyzes CPU utilization, memory (with CloudWatch agent), network, and disk I/O over 14 days using machine learning to recommend optimal instance types. It considers instance family changes (e.g., moving from m5 to c5 for CPU-bound workloads) and provides projected cost savings. This is the most comprehensive automatic analysis. Option B (Trusted Advisor) provides basic utilization checks but doesn't recommend specific replacement instance types. Option C (custom script) only considers CPU and requires development effort. Option D (Cost Explorer right-sizing) provides recommendations but is less comprehensive than Compute Optimizer's ML-based analysis.

---

### Question 73

A company runs an Amazon RDS PostgreSQL Multi-AZ instance (db.r5.4xlarge) costing $4,000/month. Analysis shows the database is 70% idle during off-peak hours (6 PM - 8 AM) and weekends. The workload cannot tolerate downtime for instance modifications.

Which approach reduces database costs while maintaining availability?

A. Migrate to Amazon Aurora Serverless v2 with a minimum ACU of 2 and maximum ACU of 32. Aurora Serverless scales capacity based on demand without downtime.

B. Schedule a Lambda function to modify the RDS instance to a smaller instance class during off-peak hours and scale it back up during peak hours.

C. Purchase a 1-year Partial Upfront Reserved Instance for the db.r5.4xlarge.

D. Create a read replica for peak traffic and direct read traffic to it. Stop the replica during off-peak hours.

**Correct Answer: A**

**Explanation:** Aurora Serverless v2 automatically scales capacity (ACUs) based on actual demand—scaling down during the 70% idle periods and up during peak times. Migration from RDS PostgreSQL to Aurora PostgreSQL is straightforward (snapshot restore), and Aurora Serverless v2 scales without any downtime. The minimum ACU ensures availability even at lowest demand. Option B (RDS modify) causes downtime during instance class changes, violating the no-downtime requirement. Option C (Reserved Instance) saves ~38% but still pays for full capacity during idle periods. Option D (read replica) doesn't reduce primary instance costs during off-peak.

---

### Question 74

A company uses Amazon CloudFront to distribute content from an S3 origin. Monthly CloudFront costs are $8,000 with 50TB of data transfer. The content is delivered primarily to users in North America and Europe.

Which optimization reduces CloudFront costs?

A. Configure CloudFront price class to "Price Class 200" (North America, Europe, Asia, Middle East, and Africa) instead of "Price Class All" since users are primarily in North America and Europe.

B. Enable CloudFront Origin Shield to reduce origin fetches and consolidate cache hits.

C. Increase the default TTL from 24 hours to 7 days for static content that rarely changes, reducing origin fetches and improving cache hit ratio.

D. Switch from CloudFront to S3 Transfer Acceleration for content delivery.

**Correct Answer: A**

**Explanation:** If users are primarily in North America and Europe, switching to Price Class 100 (North America and Europe only) removes expensive edge locations in other regions, reducing per-GB data transfer costs. With 50TB of transfer, even small per-GB savings are significant. Option B (Origin Shield) reduces origin fetches but adds a per-request charge—it saves origin costs, not CloudFront delivery costs. Option C (longer TTL) improves performance but CloudFront charges are primarily based on data transfer to viewers, not origin fetches. Option D—Transfer Acceleration is for uploads to S3, not content delivery.

---

### Question 75

A company has 500 Lambda functions across 15 accounts. Each function is configured with memory ranging from 128MB to 3008MB, set at deployment time and never adjusted. Monthly Lambda costs are $20,000. The team suspects many functions are over-provisioned.

Which approach identifies and implements optimal memory configurations?

A. Enable AWS Lambda Power Tuning (open-source tool) deployed as a Step Functions state machine. Run it against each function to determine the optimal memory/cost configuration. Implement findings through CI/CD pipeline updates.

B. Enable AWS Compute Optimizer for Lambda functions. Review the memory recommendations based on invocation metrics. Implement recommendations through infrastructure-as-code updates.

C. Analyze CloudWatch metrics for each function's max memory used. Set each function's memory to 1.5x the max observed memory usage.

D. Set all functions to 128MB memory and increase only when functions timeout or produce errors.

**Correct Answer: B**

**Explanation:** AWS Compute Optimizer supports Lambda functions and analyzes invocation patterns, memory utilization, and execution duration to recommend optimal memory configurations. It processes data across all 15 accounts (when enabled at the organization level) and provides actionable recommendations. Implementation through infrastructure-as-code ensures consistency. Option A (Lambda Power Tuning) is effective but requires deploying and running it per function across 500 functions—significant operational effort. Option C (1.5x max memory) is a reasonable heuristic but doesn't account for the cost/performance tradeoff—some functions benefit from more CPU (which comes with more memory). Option D (minimum memory) would degrade performance for many functions.

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | D1 |
| 2 | A, C | D1 |
| 3 | C | D1 |
| 4 | A | D1 |
| 5 | A | D1 |
| 6 | A | D1 |
| 7 | B | D1 |
| 8 | B | D1 |
| 9 | A | D1 |
| 10 | B | D1 |
| 11 | B | D1 |
| 12 | A | D1 |
| 13 | A | D1 |
| 14 | B, E | D1 |
| 15 | C | D1 |
| 16 | B | D1 |
| 17 | A | D1 |
| 18 | B | D1 |
| 19 | A | D1 |
| 20 | B | D1 |
| 21 | A, E | D2 |
| 22 | A | D2 |
| 23 | A | D2 |
| 24 | C | D2 |
| 25 | D | D2 |
| 26 | B | D2 |
| 27 | A | D2 |
| 28 | B | D2 |
| 29 | A | D2 |
| 30 | A | D2 |
| 31 | A | D2 |
| 32 | A | D2 |
| 33 | C | D2 |
| 34 | A | D2 |
| 35 | A | D2 |
| 36 | B | D2 |
| 37 | A | D2 |
| 38 | A | D2 |
| 39 | A | D2 |
| 40 | A | D2 |
| 41 | B | D2 |
| 42 | A | D2 |
| 43 | C | D3 |
| 44 | C | D3 |
| 45 | A | D3 |
| 46 | C | D3 |
| 47 | A | D3 |
| 48 | A, B | D3 |
| 49 | D | D3 |
| 50 | A | D3 |
| 51 | A | D3 |
| 52 | C | D3 |
| 53 | A | D3 |
| 54 | A | D4 |
| 55 | A, B | D4 |
| 56 | A | D4 |
| 57 | A | D4 |
| 58 | A | D4 |
| 59 | A | D4 |
| 60 | B, C | D4 |
| 61 | A | D4 |
| 62 | A | D4 |
| 63 | C | D5 |
| 64 | A | D5 |
| 65 | A, B | D5 |
| 66 | D | D5 |
| 67 | B | D5 |
| 68 | C | D5 |
| 69 | C | D5 |
| 70 | B | D5 |
| 71 | A, B | D5 |
| 72 | A | D5 |
| 73 | A | D5 |
| 74 | A | D5 |
| 75 | B | D5 |
