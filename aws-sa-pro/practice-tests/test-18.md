# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 18

**Focus Areas:** Serverless Deep Dive — Lambda, API Gateway, Step Functions, EventBridge, SQS/SNS FIFO
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

A large enterprise with 200 AWS accounts under AWS Organizations wants to deploy a standardized serverless event-processing architecture across all accounts. Each account needs an EventBridge bus, a set of Lambda functions for event processing, and SQS dead-letter queues for failed events. The configuration must be consistent and automatically deployed to new accounts.

Which approach provides the MOST operationally efficient centralized deployment?

A. Create a CloudFormation StackSet with service-managed permissions using the Organizations integration. Define the EventBridge bus, Lambda functions, SQS DLQs, and associated IAM roles in the template. Target the root OU so all current and future accounts receive the deployment automatically.

B. Use AWS CDK to define the infrastructure and manually deploy to each account using cross-account roles.

C. Create an AWS Service Catalog product containing the serverless architecture and require each account team to self-provision.

D. Write a script that uses the AWS CLI to create resources in each account by assuming roles, triggered by new account creation events.

**Correct Answer: A**

**Explanation:** CloudFormation StackSets with service-managed permissions (A) leverage the Organizations integration to automatically deploy to all accounts, including new ones added to the target OU. This is the most operationally efficient approach for consistent, organization-wide deployment. Option B requires manual per-account deployment. Option C depends on each team taking action. Option D is a custom solution with more maintenance overhead than native StackSets.

---

### Question 2

A financial services company needs to ensure that all Lambda functions across 50 accounts use VPC configurations (no functions should have internet access via public networking), have X-Ray tracing enabled, and use only approved Lambda runtimes. These must be enforced preventively and detective controls must catch any drift.

Which combination provides comprehensive enforcement? (Choose TWO.)

A. Create SCPs that deny lambda:CreateFunction and lambda:UpdateFunctionConfiguration unless the request includes VpcConfig parameters and TracingConfig.Mode is "Active". Use the lambda:Runtime condition key to restrict to approved runtimes.

B. Deploy AWS Config organizational rules: lambda-function-settings-check (for runtime, VPC, tracing), lambda-inside-vpc (for VPC compliance). Configure auto-remediation using SSM Automation documents.

C. Use AWS Lambda Powertools to enforce these settings at the application level.

D. Create a centralized Lambda layer that enforces tracing configuration when imported by functions.

E. Use EventBridge rules to monitor CreateFunction API calls and roll back non-compliant functions.

**Correct Answer: A, B**

**Explanation:** SCPs (A) provide preventive enforcement — functions cannot be created without VPC config, tracing, or approved runtimes. Config organizational rules (B) provide detective controls with auto-remediation for any drift. Together, they create a comprehensive prevention + detection strategy. Option C enforces at the application level but can be bypassed. Option D only works if the layer is included. Option E is reactive with potential gaps.

---

### Question 3

A company operates a multi-account event-driven architecture where the central security account needs to receive EventBridge events from all member accounts for security monitoring. Events include GuardDuty findings, Config rule evaluations, and custom application security events.

Which architecture centralizes events from all accounts to the security account?

A. Configure EventBridge rules in each member account to forward events to the security account's default event bus. Create a resource-based policy on the security account's event bus that allows PutEvents from the organization (aws:PrincipalOrgID condition). Deploy forwarding rules via CloudFormation StackSets.

B. Use EventBridge cross-account event buses with a dedicated custom bus in the security account.

C. Configure CloudWatch Logs subscription filters in each account to forward security events to the central account.

D. Use SNS topics with cross-account subscriptions for event distribution.

**Correct Answer: A**

**Explanation:** EventBridge cross-account event forwarding (A) is the native solution. The security account's event bus policy allows PutEvents from the organization using the aws:PrincipalOrgID condition. Member accounts create rules that target the security account's bus. StackSets automate deployment of forwarding rules across all accounts. This is the pattern AWS recommends for centralized security monitoring. Option B uses a custom bus but the approach is essentially the same — either default or custom bus works. Option C requires CloudWatch Logs, adding an intermediary. Option D doesn't support complex event filtering like EventBridge.

---

### Question 4

A company needs to implement API Gateway across multiple accounts where each account hosts specific microservices. They want a single, unified API domain (api.company.com) that routes requests to the correct account's API based on the URL path (e.g., /orders → Account A, /users → Account B).

Which architecture provides a unified API gateway across multiple accounts?

A. Create a central API Gateway in the networking account with custom domain (api.company.com). Use HTTP integrations or VPC Link integrations to route to backend APIs in other accounts. Use API Gateway resource policies to control cross-account access. Each path routes to the specific account's internal API endpoint.

B. Create separate API Gateways in each account and use Route 53 weighted routing with the same domain.

C. Use CloudFront with multiple origins, routing by path pattern to different API Gateways in different accounts.

D. Deploy all microservices in a single account behind one API Gateway to simplify routing.

**Correct Answer: A**

**Explanation:** A central API Gateway (A) with cross-account integrations provides a true unified API. HTTP integrations route to backend APIs in other accounts (via their public or private endpoints). VPC Links enable private connectivity to NLBs in other accounts via VPC peering or Transit Gateway. The custom domain presents a single endpoint. Option B creates separate domains or complex DNS routing. Option C works for simple routing but loses API Gateway features (request validation, throttling, authorization). Option D violates multi-account isolation principles.

---

### Question 5

A company uses Step Functions workflows across 30 accounts for business process automation. They need to ensure all workflows have proper error handling, timeout configurations, and CloudWatch Logs logging enabled. The operations team wants centralized visibility into workflow executions across all accounts.

Which governance and monitoring strategy provides comprehensive coverage?

A. Create AWS Config custom rules that evaluate Step Functions state machine definitions for required error handling (Catch blocks on all Task states), timeout configurations (TimeoutSeconds on Task and workflow), and logging configuration (CloudWatch Logs logging level). Deploy via organizational Config rules. For centralized monitoring, use CloudWatch cross-account observability to aggregate Step Functions metrics and logs from all accounts.

B. Review each state machine definition manually during code reviews.

C. Use SCPs to prevent Step Functions state machine creation without specific configurations.

D. Deploy a centralized monitoring Lambda that polls Step Functions APIs across all accounts.

**Correct Answer: A**

**Explanation:** Config custom rules (A) can programmatically evaluate state machine definitions (which are JSON) for required patterns — Catch blocks, TimeoutSeconds, and logging configuration. Organization-wide deployment ensures coverage. CloudWatch cross-account observability provides centralized metrics and log aggregation. Option B is manual and unscalable. Option C — SCPs don't have condition keys for Step Functions state machine definitions. Option D requires custom infrastructure and has polling latency.

---

### Question 6

An enterprise needs to implement a serverless application firewall for API Gateway APIs across their organization. They want centralized WAF rule management with per-account customization capabilities.

Which architecture provides centralized WAF management for API Gateway?

A. Use AWS Firewall Manager to deploy WAF WebACLs to all API Gateway stages across the organization. Define a security policy that includes mandatory rule groups (SQL injection, XSS, rate limiting). Allow account-level custom rules that run after the managed rules. Firewall Manager automatically associates WebACLs with API Gateway stages as they're created.

B. Create WAF WebACLs in each account manually with the same rule configuration.

C. Use API Gateway request validators and Lambda authorizers instead of WAF.

D. Deploy a third-party WAF appliance behind a Network Load Balancer in front of API Gateway.

**Correct Answer: A**

**Explanation:** Firewall Manager (A) provides centralized, organization-wide WAF management. Security policies define the mandatory rules, and automatic remediation associates WebACLs with new API Gateway stages. Per-account customization through scope-down rules or additional rule groups provides flexibility. This eliminates the need for per-account WAF management. Option B requires manual deployment in each account. Option C provides limited protection compared to WAF. Option D adds complexity and potential bottleneck.

---

### Question 7

A company uses SQS FIFO queues across 10 accounts for order processing. They need to ensure that all FIFO queues have consistent configurations: visibility timeout of 300 seconds, message retention of 14 days, DLQ configured with maxReceiveCount of 5, and KMS encryption enabled.

Which approach ensures configuration consistency across accounts?

A. Create AWS Config custom rules that evaluate SQS FIFO queue configurations against the required standards. Deploy via organizational Config with auto-remediation using SSM Automation documents that call SetQueueAttributes to correct non-compliant configurations. Additionally, use CloudFormation StackSets with Service Catalog products for consistent queue creation.

B. Create an SCP that restricts SQS CreateQueue parameters.

C. Publish a best practices document and rely on team compliance.

D. Create a centralized SQS management service that all accounts must use to create queues.

**Correct Answer: A**

**Explanation:** Config rules with auto-remediation (A) provide continuous compliance monitoring and correction. The custom rule evaluates each queue's attributes against the required configuration. SSM Automation remediation corrects drift. Service Catalog products ensure consistent initial creation. This combination provides both preventive (Service Catalog) and detective (Config) controls. Option B — SCPs don't have condition keys for SQS queue configuration parameters. Option C is unreliable. Option D centralizes queue management, adding operational bottlenecks.

---

### Question 8

A company's security team needs to audit all Lambda function permissions across the organization to identify overly permissive IAM roles (e.g., Lambda functions with AdministratorAccess or * resource permissions). They need continuous monitoring with alerts for non-compliant functions.

Which solution provides organization-wide Lambda permission auditing?

A. Use IAM Access Analyzer at the organization level to analyze Lambda function resource-based policies for external access. Additionally, deploy AWS Config rule iam-policy-no-statements-with-admin-access and custom rules that evaluate Lambda execution role policies for overly permissive actions. Aggregate findings to a central security account using Config aggregator and Security Hub.

B. Export all IAM policies to S3 and use Athena to query for permissive policies.

C. Use CloudTrail to log all Lambda invocations and identify which functions access unauthorized resources.

D. Manually review Lambda function roles during quarterly security audits.

**Correct Answer: A**

**Explanation:** IAM Access Analyzer with Config rules (A) provides comprehensive, continuous auditing. Access Analyzer identifies resource-based policies that grant external access to Lambda functions. Config rules evaluate execution role policies for admin access or wildcard permissions. Security Hub aggregates findings centrally with standard severity ratings. This is automated, continuous, and organization-wide. Option B is a point-in-time analysis requiring manual setup. Option C is reactive — waits for unauthorized access to occur. Option D is too infrequent and labor-intensive.

---

### Question 9

A company needs to implement a cross-account event routing pattern where events from a producer account are selectively distributed to multiple consumer accounts based on event attributes. Each consumer account should only receive events relevant to their department.

Which EventBridge architecture implements selective cross-account event routing?

A. Create a central event bus in a hub account. Producer accounts send events to the central bus. Create rules on the central bus that filter events by department attribute and route matching events to each consumer account's event bus. Use resource-based policies on consumer buses to allow the central bus to send events.

B. Have the producer account send events to all consumer accounts' event buses simultaneously, letting each consumer filter locally.

C. Use SNS topic with message filtering for cross-account event distribution.

D. Create a Lambda function in the hub account that receives all events and manually routes them to consumer accounts.

**Correct Answer: A**

**Explanation:** The hub-and-spoke EventBridge pattern (A) provides centralized routing with attribute-based filtering. The central bus receives all events and rules selectively route to consumer buses based on event content (e.g., department attribute). This is efficient — events are evaluated once at the hub and only delivered to relevant consumers. Consumer bus policies allow cross-account delivery. Option B sends all events to all consumers, wasting bandwidth and requiring each consumer to filter. Option C works but EventBridge provides richer filtering patterns. Option D adds Lambda invocation costs and latency.

---

### Question 10

A company wants to restrict Lambda function deployment across their organization so that functions can only use layers published by the central platform team. This prevents teams from using unauthorized third-party layers that might contain vulnerabilities.

Which control restricts Lambda layer usage to approved layers?

A. Create an SCP that denies lambda:CreateFunction and lambda:UpdateFunctionConfiguration unless the Layers parameter contains only ARNs from the central platform team's account (using StringLike condition on lambda:Layer to match the approved account's layer ARN pattern).

B. Publish approved layers via AWS RAM and restrict direct layer creation permissions.

C. Use Config rules to detect functions using unapproved layers and terminate them.

D. Create a Lambda extension that validates layer usage at runtime.

**Correct Answer: A**

**Explanation:** SCPs with lambda:Layer condition (A) provide preventive enforcement. The condition restricts function creation/updates to only include layers whose ARNs match the approved account's pattern (e.g., arn:aws:lambda:*:123456789:layer:*). This prevents any function from using layers from unauthorized accounts. Option B restricts layer creation but not layer reference — teams could still reference public or third-party layers. Option C is detective, not preventive. Option D operates at runtime but doesn't prevent deployment.

---

### Question 11

A multinational company processes events in multiple Regions using EventBridge. They need events generated in any Region to be available for processing in all other Regions within 5 seconds. The events must maintain ordering within each source.

Which architecture provides cross-Region event replication with ordering?

A. Use EventBridge global endpoints with event replication. Configure a global endpoint that replicates events to the secondary Region. Use Route 53 health checks to enable automatic failover. For ordering, ensure events from the same source use the same detailType and source fields, which EventBridge uses for routing consistency.

B. Create EventBridge rules in each Region that forward all events to every other Region's event bus. Use SQS FIFO queues in each Region for ordered processing.

C. Use EventBridge Pipes to connect cross-Region event buses with ordering guarantees.

D. Deploy a Kinesis Data Stream for cross-Region event replication with ordering by partition key.

**Correct Answer: A**

**Explanation:** EventBridge global endpoints (A) provide managed cross-Region event replication. Events sent to the global endpoint are replicated to a secondary Region. Route 53 health checks enable failover. While EventBridge doesn't guarantee strict ordering, the global endpoint pattern provides near-real-time replication within seconds. For strict ordering needs, the events can be processed through SQS FIFO queues in each Region after delivery. Option B creates N² routing rules for N Regions. Option C — EventBridge Pipes don't natively handle cross-Region replication. Option D works but requires managing Kinesis infrastructure.

---

### Question 12

A company wants to enforce that all API Gateway REST APIs across their organization use private endpoints only — no public-facing API Gateway endpoints should be possible. This is a strict security requirement for their internal-only APIs.

Which preventive control restricts API Gateway to private endpoints?

A. Create an SCP that denies apigateway:CreateRestApi unless the endpointConfiguration type is PRIVATE. Similarly deny apigateway:UpdateRestApi that would change the endpoint type from PRIVATE to REGIONAL or EDGE. This prevents any account from creating public API Gateway endpoints.

B. Use VPC endpoint policies to restrict API Gateway access to VPC endpoints only.

C. Configure security groups to block public access to API Gateway endpoints.

D. Use Config rules to detect public API Gateway endpoints and auto-remediate.

**Correct Answer: A**

**Explanation:** SCPs (A) prevent creation of non-private API Gateway endpoints at the organization level. The apigateway:CreateRestApi denial with endpoint type conditions ensures only PRIVATE APIs can be created. Similarly blocking updates to endpoint type prevents converting private APIs to public. This is preventive and organization-wide. Option B controls access through VPC endpoints but doesn't prevent public endpoint creation. Option C — API Gateway doesn't use security groups. Option D is detective, not preventive.

---

### Question 13

A company needs to implement a standardized error handling and alerting pattern for all Lambda functions across 100 accounts. When a Lambda function fails, the error must be captured, enriched with account and function metadata, and forwarded to a central alerting system.

Which architecture provides standardized, centralized error handling?

A. Use Lambda Destinations for failed async invocations. Configure all Lambda functions to send failures to an SNS topic in each account. Create EventBridge rules that forward Lambda error events (including function errors from CloudWatch Logs) to the central monitoring account. In the central account, a Lambda function enriches the error with account metadata and forwards to PagerDuty/Slack.

B. Add try/catch blocks in every Lambda function to catch and report errors.

C. Use CloudWatch Logs subscription filters on all Lambda log groups to forward error messages to a central Kinesis stream.

D. Deploy X-Ray tracing on all Lambda functions and monitor traces centrally.

**Correct Answer: A**

**Explanation:** Lambda Destinations with EventBridge (A) provide a standardized, infrastructure-level error handling pattern. Destinations automatically capture async invocation failures without modifying function code. EventBridge's cross-account forwarding centralizes all errors. The enrichment Lambda adds organizational context. This works for all async-invoked Lambda functions across all accounts. Option B requires modifying every function's code. Option C captures log-level errors but requires log parsing. Option D provides tracing but not error alerting.

---

### Question 14

A company processes 50 million API requests per day through API Gateway. They need to implement per-client rate limiting where each client (identified by API key) has a different rate limit based on their subscription tier (Free: 10 req/sec, Basic: 100 req/sec, Premium: 1000 req/sec).

Which API Gateway configuration implements tiered per-client rate limiting?

A. Create three usage plans in API Gateway, each with different throttle settings (rate and burst limits). Associate API stages with each plan. Create API keys for each client and associate each key with the appropriate usage plan based on their subscription tier. Clients must include the API key in the x-api-key header.

B. Implement throttling in a Lambda authorizer that checks the client tier and returns throttle decisions.

C. Use WAF rate-based rules with different limits per client IP.

D. Configure API Gateway stage-level throttling to match the lowest tier and handle higher tiers in the application.

**Correct Answer: A**

**Explanation:** API Gateway usage plans (A) are designed specifically for tiered rate limiting. Each usage plan defines rate (req/sec) and burst limits. API keys identify clients, and each key is associated with a usage plan. This is fully managed by API Gateway without custom code. The three plans (Free/Basic/Premium) map directly to the subscription tiers. Option B adds Lambda invocation overhead for every request. Option C uses IP-based limiting, not client-tier-based. Option D under-throttles premium clients and requires custom application logic.

---

### Question 15

A company operates a multi-account architecture where each business unit has its own AWS account. They need to share Lambda layers containing common libraries across all accounts. The layers must be version-controlled and updates must propagate consistently.

Which approach provides controlled cross-account Lambda layer sharing?

A. Publish Lambda layers in a central shared services account. Use lambda:AddLayerVersionPermission to grant access to the entire organization (aws:PrincipalOrgID condition). Use SSM Parameter Store parameters (published via AWS RAM or manually synced) in each account to store the latest approved layer version ARN. Applications reference the SSM parameter to get the layer ARN, ensuring they use the approved version.

B. Copy the layer code to S3 in each account and have functions deploy layers locally.

C. Publish layers to the AWS Serverless Application Repository for organization-wide access.

D. Use AWS CodeArtifact to distribute layer packages and build layers in each account.

**Correct Answer: A**

**Explanation:** Centralized layer publishing with org-wide permissions (A) provides the most manageable solution. The AddLayerVersionPermission grants access to all organization accounts. SSM Parameter Store parameters provide version indirection — the central team updates the parameter when a new layer version is approved, and applications reference the parameter for the ARN. This enables controlled rollout and easy rollback. Option B creates duplication and maintenance overhead. Option C's SAR is designed for application distribution, not shared libraries. Option D adds build complexity in each account.

---

### Question 16

A company has 500 Lambda functions across 20 accounts and needs to ensure that all functions have reserved concurrency limits set to prevent any single function from consuming the entire account's Lambda concurrency pool (default 1,000). Additionally, functions processing PII must have provisioned concurrency configured to avoid cold starts.

Which governance approach manages Lambda concurrency across accounts?

A. Create AWS Config custom rules that: (1) verify all Lambda functions have ReservedConcurrentExecutions configured (not unlimited), (2) verify PII-processing functions (identified by tags) have ProvisionedConcurrency configured. Deploy via organizational Config. Auto-remediate using Lambda-backed SSM Automation. Use SCPs to deny lambda:DeleteFunctionConcurrency to prevent removal of reserved concurrency.

B. Set account-level Lambda concurrency limits and let individual functions share the pool.

C. Use Lambda Power Tuning to automatically configure concurrency settings.

D. Monitor CloudWatch Lambda ConcurrentExecutions metric and alert when approaching limits.

**Correct Answer: A**

**Explanation:** Config rules with SCP enforcement (A) provide comprehensive concurrency governance. The Config rule detects functions without reserved concurrency and PII functions without provisioned concurrency. The SCP prevents removal of concurrency settings. Auto-remediation applies default reserved concurrency to non-compliant functions. Tag-based identification of PII functions enables targeted provisioned concurrency enforcement. Option B doesn't prevent a single function from monopolizing the pool. Option C optimizes memory/duration, not concurrency governance. Option D is reactive monitoring.

---

### Question 17

An organization needs to implement a cross-account Step Functions workflow where the workflow in Account A orchestrates Lambda functions in Accounts B and C. The workflow processes customer orders, calling inventory service (Account B) and payment service (Account C).

Which architecture enables cross-account Step Functions orchestration?

A. Deploy the Step Functions workflow in Account A. Use the Lambda Invoke action with the full cross-account function ARN. Create IAM roles in Accounts B and C that trust Account A's Step Functions service role. The Step Functions execution role in Account A must have permissions to invoke the cross-account Lambda functions via IAM policies and the target functions' resource-based policies must allow invocation from Account A.

B. Deploy separate Step Functions workflows in each account and chain them using EventBridge events.

C. Use SQS queues for cross-account communication instead of direct Lambda invocation.

D. Deploy all Lambda functions in a single account to avoid cross-account complexity.

**Correct Answer: A**

**Explanation:** Step Functions supports cross-account Lambda invocation (A) through IAM role configuration and Lambda resource-based policies. The workflow in Account A directly invokes functions in Accounts B and C, providing centralized orchestration with full visibility. The Lambda functions need resource-based policies granting invoke permission to Account A's Step Functions role. Option B fragments the workflow, losing centralized orchestration and error handling. Option C adds latency and complexity. Option D violates multi-account isolation.

---

### Question 18

A company uses EventBridge rules extensively across 50 accounts. They discover that some rules have been misconfigured to trigger on overly broad patterns (e.g., matching all events), causing Lambda functions to be invoked millions of times unnecessarily. They need to govern EventBridge rule patterns.

Which control prevents overly broad EventBridge rule patterns?

A. Create a custom AWS Config rule that evaluates EventBridge rule event patterns. The rule checks that patterns include at least a specific source and detail-type (not matching "all"). Auto-remediate by disabling non-compliant rules and notifying the owner. Additionally, use IAM policies that require approval for EventBridge rule creation through Service Catalog.

B. Set EventBridge account-level limits on the number of rules and matching events.

C. Use SCPs to restrict EventBridge rule creation based on event pattern specificity.

D. Monitor EventBridge invocation metrics and manually investigate high-volume rules.

**Correct Answer: A**

**Explanation:** Config custom rules (A) can parse EventBridge rule event patterns (JSON) and validate specificity — ensuring rules match at minimum a specific source and detail-type rather than catching all events. Auto-disabling non-compliant rules prevents waste. Service Catalog governance adds a preventive layer. Option B — EventBridge doesn't have account-level limits on event pattern breadth. Option C — SCPs don't have condition keys for EventBridge rule pattern content. Option D is reactive and labor-intensive.

---

### Question 19

A company needs to ensure Lambda functions in production accounts use specific VPC configurations and security groups, while development accounts have more relaxed requirements. The VPC configuration differs by account (different VPC IDs, subnet IDs, security group IDs per account).

Which approach enforces account-specific Lambda VPC requirements?

A. Use a combination of SCPs and account-specific Config rules. The SCP attached to the production OU denies lambda:CreateFunction and lambda:UpdateFunctionConfiguration without VpcConfig. Account-specific Config custom rules (deployed via StackSets with per-account parameter values) validate that functions use the correct VPC ID, subnet IDs, and security group IDs for that specific account.

B. Create a shared VPC and require all production Lambda functions to use it.

C. Use Lambda layers to enforce VPC configuration.

D. Manually review Lambda configurations during deployment pipeline approvals.

**Correct Answer: A**

**Explanation:** SCP + account-specific Config rules (A) provide two enforcement layers. The SCP preventively requires VPC configuration for all production Lambda functions. The account-specific Config rules (deployed via StackSets with account parameters) validate the exact VPC, subnets, and security groups — which differ per account. This is the only approach that handles both the mandatory VPC requirement and account-specific validation. Option B may not be feasible if accounts need their own VPCs. Option C — layers can't enforce infrastructure configuration. Option D is manual and error-prone.

---

### Question 20

A company operates a SaaS platform across 100 accounts. They need centralized management of API Gateway custom domains, ensuring all APIs use domains under the company's primary domain (*.api.company.com) with ACM certificates from a shared certificate authority.

Which centralized domain management approach ensures consistency?

A. Use a central networking account to manage Route 53 hosted zones and ACM certificates. Create wildcard ACM certificates (*.api.company.com) in the networking account. For API Gateway custom domains in member accounts, use API Gateway domain name sharing — create the custom domain in the networking account and share the domain mapping using cross-account IAM roles. Each account's API maps to a path under the shared domain.

B. Create separate ACM certificates and Route 53 records in each account for their APIs.

C. Use CloudFront distributions with custom domains in front of each account's API Gateway, managed centrally.

D. Require all accounts to request custom domain setup through a ticketing system to the networking team.

**Correct Answer: A**

**Explanation:** Centralized domain and certificate management (A) ensures all APIs use consistent, company-controlled domains. The networking account owns the DNS zones and certificates, preventing unauthorized domain creation. Cross-account domain sharing allows member accounts' APIs to be mapped under the central domain. This provides governance while enabling self-service for API deployment. Option B creates management sprawl with per-account domains. Option C adds CloudFront complexity. Option D is manual and slow.

---

### Question 21

A company is building a real-time IoT data processing pipeline. IoT devices send 10,000 messages per second. Each message must be validated, enriched with device metadata from DynamoDB, and stored in S3 in Parquet format. Messages must be processed in order per device.

Which serverless architecture handles this at scale with per-device ordering?

A. Use IoT Core to ingest messages. Route to Kinesis Data Streams with device ID as partition key (ensuring per-device ordering). Use Kinesis Data Firehose with Lambda transformation for validation and enrichment. Firehose batches and delivers to S3 in Parquet format using the Parquet format conversion feature.

B. Use IoT Core to send messages directly to Lambda for processing and writing to S3.

C. Use SQS FIFO queues with device ID as the message group ID for ordered processing.

D. Use EventBridge for IoT event processing with ordering guarantees.

**Correct Answer: A**

**Explanation:** Kinesis with device ID partitioning (A) provides per-device ordering at 10,000 messages/sec scale. Firehose's built-in Parquet conversion eliminates custom serialization. Lambda transformation enables validation and DynamoDB enrichment. This is fully managed and handles the throughput. Option B — direct Lambda invocation at 10K/sec would hit Lambda concurrency limits and doesn't guarantee ordering. Option C — SQS FIFO is limited to 3,000 messages/sec per queue with batching, insufficient for 10K/sec with per-device groups. Option D — EventBridge doesn't provide message ordering.

---

### Question 22

A company needs to build a document processing workflow where uploaded PDFs are split into pages, each page is processed by OCR (Textract), the extracted text is analyzed by Comprehend for PII detection, PII is redacted, and the clean document is reassembled. Documents range from 1 to 500 pages.

Which serverless architecture handles variable document sizes efficiently?

A. Use a single Lambda function that processes the entire document sequentially.

B. Use Step Functions with a Map state for parallel page processing. The workflow: (1) Lambda splits PDF into individual pages → S3. (2) Map state iterates over pages in parallel (max concurrency configured to avoid throttling): Lambda calls Textract → Lambda calls Comprehend → Lambda redacts PII. (3) Lambda reassembles the redacted pages into the final PDF → S3. Use the Distributed Map state for documents with more than 40 pages to handle up to 10,000 parallel iterations.

C. Use an SQS queue for each page and process pages independently without a workflow.

D. Use a single Step Functions Express Workflow for the entire process.

**Correct Answer: B**

**Explanation:** Step Functions with Map/Distributed Map states (B) provides dynamic parallel processing scaled to document size. The Distributed Map state supports up to 10,000 parallel iterations, handling even 500-page documents efficiently. Max concurrency settings prevent Textract/Comprehend throttling. Step Functions manages the workflow state, error handling, and page reassembly coordination. Option A can't handle 500 pages within Lambda's 15-minute timeout. Option C loses workflow coordination needed for reassembly. Option D — Express Workflows have a 5-minute timeout, insufficient for large documents.

---

### Question 23

A company needs to implement a webhook receiver that accepts events from 30 different third-party SaaS applications. Each webhook has a different authentication method (HMAC signature, API key, OAuth token), payload format, and retry behavior. The system must validate each webhook's authenticity, transform the payload into a common format, and route to appropriate internal services.

Which serverless architecture provides a flexible, maintainable webhook platform?

A. Create a single Lambda function that handles all 30 webhook types with a large switch statement.

B. Use API Gateway with a single endpoint per webhook source. Each endpoint has a Lambda authorizer specific to the source's authentication method (HMAC validator, API key checker, OAuth verifier). After authorization, a Lambda integration transforms the source-specific payload into the canonical event format. Publish the canonical event to EventBridge with the source type as the detail-type. EventBridge rules route events to appropriate internal service handlers based on event type.

C. Use SQS queues — one per webhook source — with API Gateway routing to the correct queue.

D. Use a single API Gateway endpoint with request mapping templates to handle all formats.

**Correct Answer: B**

**Explanation:** Separate endpoints with source-specific authorizers and EventBridge routing (B) provides clean separation of concerns. Each webhook source gets its own endpoint and authorizer, keeping authentication logic isolated and maintainable. Lambda transforms source-specific formats into a common schema. EventBridge provides flexible routing to internal consumers. Adding a new webhook source means creating a new endpoint, authorizer, and transformer — without modifying existing ones. Option A creates a monolithic function. Option C skips authentication. Option D can't handle 30 different authentication methods in mapping templates.

---

### Question 24

A financial trading company needs exactly-once message processing for order execution. Orders are submitted via API, must be deduplicated, processed in FIFO order per trading symbol, and each order must be processed exactly once even if the system retries.

Which architecture provides exactly-once, ordered processing?

A. Use SQS Standard queue with application-level deduplication.

B. Use API Gateway → SQS FIFO queue (content-based deduplication enabled, MessageGroupId = trading symbol). Lambda processes messages from the FIFO queue using event source mapping with a batch size of 1 and maximum concurrency of 1 per message group. Use a DynamoDB table with conditional writes for idempotent order execution — each order ID is checked before execution.

C. Use Kinesis Data Streams with exactly-once processing and partition key = trading symbol.

D. Use EventBridge with ordering guarantees per trading symbol.

**Correct Answer: B**

**Explanation:** SQS FIFO with Lambda event source mapping (B) provides the closest to exactly-once, ordered processing. FIFO guarantees ordering within message groups (per trading symbol). Content-based deduplication prevents duplicate messages within the 5-minute deduplication window. Lambda event source mapping with max concurrency per message group ensures sequential processing per symbol. DynamoDB conditional writes provide idempotent execution as a final safety net. Option A — Standard SQS doesn't guarantee ordering or deduplication. Option C — Kinesis provides ordering but at-least-once delivery, requiring application-level idempotency. Option D — EventBridge doesn't provide ordering guarantees.

---

### Question 25

A company needs to build a multi-tenant serverless API where each tenant has isolated data and custom business logic. There are 500 tenants, and each might have slightly different workflow rules for order processing.

Which architecture provides scalable tenant isolation with custom logic?

A. Deploy separate API Gateway and Lambda stacks per tenant.

B. Use a single API Gateway with a Lambda authorizer that extracts tenant context from the JWT token. Lambda functions use the tenant ID to: (1) access tenant-specific DynamoDB items (partition key = tenant ID), (2) load tenant-specific workflow rules from a configuration table, (3) execute the workflow using Step Functions with tenant context passed as input. For heavily customized tenants, use Step Functions Dynamic Parallelism to execute tenant-specific Lambda functions referenced by ARN from the configuration.

C. Use separate AWS accounts per tenant for complete isolation.

D. Use API Gateway with separate stages per tenant.

**Correct Answer: B**

**Explanation:** The pooled architecture with tenant-aware logic (B) scales to 500 tenants without per-tenant infrastructure management. JWT-based tenant identification is standard for SaaS. DynamoDB tenant isolation via partition keys is efficient. Configuration-driven workflow rules (stored in DynamoDB) allow per-tenant customization without per-tenant deployment. Step Functions dynamic references enable loading tenant-specific Lambda ARNs at runtime. Option A creates 500 stacks — unmanageable. Option C is extremely expensive for 500 tenants. Option D — 500 stages on one API Gateway is impractical.

---

### Question 26

A company processes credit card transactions and must comply with PCI DSS. They want a serverless architecture where sensitive cardholder data (CHD) is isolated in a separate processing environment from the rest of the application.

Which serverless architecture provides PCI-compliant cardholder data isolation?

A. Use a single Lambda function that processes the entire transaction including CHD.

B. Implement a two-zone architecture: (1) Standard zone: API Gateway → Lambda handles order metadata, customer info, and business logic. Publishes to EventBridge. (2) PCI zone: Separate VPC with Lambda functions (VPC-attached) that handle CHD processing. A tokenization Lambda in the PCI zone receives CHD via a VPC endpoint-connected API, tokenizes the card number, and returns a token. The standard zone only handles tokens, never raw CHD. The PCI zone has its own KMS key, IAM roles, and CloudTrail logging.

C. Encrypt all data and process everything in the same Lambda functions.

D. Use a third-party payment processor for all transaction handling.

**Correct Answer: B**

**Explanation:** Two-zone architecture (B) minimizes the PCI DSS scope. The PCI zone is a small, tightly controlled environment where CHD is processed and tokenized. The standard zone never handles raw CHD — only tokens. This dramatically reduces the number of components in PCI scope. VPC-attached Lambdas in the PCI zone provide network isolation. Separate KMS keys and IAM roles provide access isolation. Separate CloudTrail provides dedicated audit trails. Option A puts the entire application in PCI scope. Option C still processes CHD in the general environment. Option D might work but the question asks about architecture design.

---

### Question 27

A company needs to build a real-time notification system that sends personalized messages to millions of users through multiple channels (push notification, email, SMS, in-app). Each user's preferences determine which channels receive notifications. The system must handle 100,000 notifications per minute during peak events.

Which serverless architecture supports multi-channel notification at scale?

A. Use a Lambda function that sends all notifications sequentially.

B. Use EventBridge as the event ingestion layer. EventBridge rules route notification events to an SNS topic. The SNS topic fans out to channel-specific SQS queues (push, email, SMS, in-app). Channel-specific Lambda functions process each queue: push Lambda calls Amazon Pinpoint, email Lambda calls SES, SMS Lambda calls SNS SMS. A user preferences Lambda filter (triggered before fan-out) queries DynamoDB for user channel preferences and publishes to only the relevant channel queues.

C. Use Amazon Pinpoint for all notification channels.

D. Use Step Functions to orchestrate the notification flow for each message.

**Correct Answer: B**

**Explanation:** EventBridge → SNS → SQS → Lambda per channel (B) provides scalable, decoupled multi-channel notification. SQS queues buffer each channel independently, so email delays don't affect push notifications. Channel-specific Lambda functions handle the unique requirements of each delivery mechanism. The preference-based filtering prevents unnecessary processing. SQS provides retry handling and DLQ for failed deliveries. At 100K/min, this architecture handles the throughput easily. Option A is a bottleneck. Option C handles some channels but may not cover all (in-app). Option D adds per-message workflow overhead, which is expensive at 100K/min.

---

### Question 28

A company is building a serverless data pipeline that processes CSV files uploaded to S3. Files range from 1 MB to 50 GB. Each record in the CSV must be validated, transformed, and loaded into DynamoDB. Large files must be processed within 30 minutes.

Which architecture handles variable file sizes within the time constraint?

A. Use a single Lambda function triggered by S3 events to process the entire file.

B. Use S3 event notification → Lambda "splitter" function that reads the file header and splits the file into chunks using S3 Select or byte-range reads (e.g., 10,000 records per chunk). The splitter publishes chunk references to an SQS queue. A fleet of Lambda functions (with reserved concurrency of 100) processes chunks in parallel from the SQS queue, validating and writing to DynamoDB using batch writes. A Step Functions workflow monitors progress and handles completion/failure.

C. Use AWS Glue for all CSV processing regardless of file size.

D. Use Kinesis Data Firehose to stream the CSV file into DynamoDB.

**Correct Answer: B**

**Explanation:** The split-and-parallel-process pattern (B) handles variable file sizes. The splitter Lambda divides large files into manageable chunks (S3 byte-range reads enable efficient splitting without loading the entire file). SQS distributes chunks across parallel Lambda workers. 100 concurrent Lambda functions processing 10K records each can handle millions of records within 30 minutes. Batch writes to DynamoDB optimize throughput. Step Functions provides workflow orchestration. Option A — a single Lambda can't process 50 GB within the 15-minute timeout. Option C works but is slower for small files and more expensive. Option D — Firehose doesn't support CSV-to-DynamoDB.

---

### Question 29

A company needs to implement a distributed saga pattern for an e-commerce checkout process involving: (1) reserve inventory, (2) charge payment, (3) create shipment, (4) send confirmation. Each step can fail, and all previous steps must be compensated (rolled back) on failure.

Which serverless architecture correctly implements the saga pattern?

A. Use a single Lambda function that executes all steps in a try/catch block.

B. Use Step Functions with a workflow that implements the saga pattern: each step has a corresponding compensation step. Use the Catch error handler on each Task state to trigger the compensation path. The workflow: ReserveInventory → ChargePayment → CreateShipment → SendConfirmation. If ChargePayment fails: → ReleaseInventory (compensate). If CreateShipment fails: → RefundPayment → ReleaseInventory (compensate in reverse order). Each step stores its result in the workflow state for use by compensating actions.

C. Use SQS queues between each step and manually implement compensation logic in each consumer.

D. Use EventBridge to choreograph the saga with events triggering each step.

**Correct Answer: B**

**Explanation:** Step Functions (B) is the ideal service for the saga pattern. The state machine explicitly models the happy path and compensation path. Catch blocks on each Task state route to the appropriate compensation steps. The reverse-order compensation ensures consistency (undo shipment before refunding before releasing inventory). Step Functions maintains the full execution state, making debugging and auditing straightforward. Option A — a single function can't handle long-running compensations and has timeout risks. Option C loses centralized workflow visibility. Option D's choreography approach makes saga tracking and debugging very difficult.

---

### Question 30

A company needs to implement a WebSocket API for a real-time collaborative editing application. Multiple users edit the same document simultaneously, and changes must be broadcast to all connected users of that document with sub-second latency.

Which serverless architecture supports real-time collaborative editing?

A. Use API Gateway WebSocket API with $connect, $disconnect, and custom routes. Store connection IDs and their associated document IDs in a DynamoDB table (GSI on document ID for efficient lookup). When a user sends an edit via the custom route, a Lambda function: (1) saves the edit to DynamoDB (document state), (2) queries the connections table for all users of that document, (3) broadcasts the edit to all connected users using the API Gateway Management API (PostToConnection). Use DynamoDB Streams to handle conflict resolution via a Lambda function that applies operational transforms.

B. Use SNS for broadcasting messages to all connected clients.

C. Use SQS with separate queues per client for message delivery.

D. Use AppSync subscriptions for real-time data synchronization.

**Correct Answer: A**

**Explanation:** API Gateway WebSocket API (A) provides managed WebSocket connections with Lambda-based processing. The connection tracking in DynamoDB with document ID GSI enables efficient broadcast to all users of a specific document. The Management API's PostToConnection sends targeted messages to specific clients. DynamoDB Streams for conflict resolution ensures consistency. This is a common pattern for collaborative applications. Option B — SNS can't send to individual WebSocket connections. Option C adds latency and complexity. Option D (AppSync) is a valid alternative and could also work well, but the question asks about building with the listed serverless services.

---

### Question 31

A company needs to process events where some events trigger long-running workflows (up to 24 hours) and some trigger short operations (under 1 second). The system handles 50,000 events per hour.

Which architecture efficiently handles both short and long-running event processing?

A. Use Lambda for everything and chain functions for long-running processes.

B. Use EventBridge as the event router. Create rules that evaluate event type: (1) Short-lived events route directly to Lambda functions for immediate processing. (2) Long-running events route to Step Functions Standard Workflows (up to 1-year execution). The Step Functions workflow orchestrates multi-step processes with wait states, parallel branches, and callback patterns. Use Step Functions Express Workflows for sub-processes within the Standard Workflow that need high throughput (>100,000/sec) with 5-minute max duration.

C. Use ECS Fargate tasks for all processing to handle both short and long-running workloads.

D. Use SQS with visibility timeout set to 24 hours for long-running processes.

**Correct Answer: B**

**Explanation:** EventBridge routing to Lambda (short) or Step Functions Standard Workflows (long) (B) provides the optimal architecture. Lambda handles sub-second operations efficiently without orchestration overhead. Standard Workflows handle multi-hour processes with state persistence, wait states, and exactly-once execution. Nesting Express Workflows inside Standard Workflows gives high throughput for sub-steps while maintaining the long-running orchestration. Option A — Lambda chaining is fragile and loses state between invocations. Option C is over-provisioned for short operations. Option D — 24-hour visibility timeout means failed messages aren't retried for 24 hours.

---

### Question 32

A company needs to implement a serverless ETL pipeline that processes data from multiple sources (S3, DynamoDB Streams, Kinesis) and loads into a data lake on S3 in Iceberg table format. The pipeline must handle schema evolution and data deduplication.

Which serverless architecture handles multi-source ETL with schema management?

A. Use individual Lambda functions for each source, writing directly to S3.

B. Use EventBridge Pipes to connect each source to a processing pipeline: (1) DynamoDB Streams → EventBridge Pipe → Lambda enrichment → Kinesis Data Firehose → S3. (2) Kinesis Data Streams → EventBridge Pipe → Lambda transformation → Firehose → S3. (3) S3 events → Lambda processing → Firehose → S3. Configure Firehose to use the Apache Iceberg table format with AWS Glue Data Catalog for schema management. Use Glue Crawlers for automatic schema evolution. Implement deduplication using Iceberg's merge-on-read with Athena queries.

C. Use AWS Glue ETL jobs for all processing.

D. Use Step Functions to orchestrate Lambda-based ETL for each source.

**Correct Answer: B**

**Explanation:** EventBridge Pipes with Firehose and Iceberg (B) provides a serverless, managed ETL pipeline. EventBridge Pipes natively connect to DynamoDB Streams and Kinesis, providing filtering and enrichment. Firehose handles batching and delivery to S3 in Iceberg format. Glue Data Catalog manages schema evolution. Iceberg tables support merge-on-read for deduplication and ACID transactions. This is fully serverless without managing ETL infrastructure. Option A requires custom Iceberg write logic. Option C works but isn't fully serverless (Glue runs on managed Spark). Option D adds orchestration complexity.

---

### Question 33

A company needs to implement a serverless CQRS (Command Query Responsibility Segregation) pattern where writes go to a transactional store and reads come from optimized read models. Commands are processed through a Lambda function that writes to DynamoDB, and the read model must support complex queries.

Which architecture implements serverless CQRS effectively?

A. Use a single DynamoDB table for both writes and reads with GSIs for query patterns.

B. Use DynamoDB as the write store. Enable DynamoDB Streams to capture all changes. A Lambda function triggered by the stream transforms and projects the data into read-optimized stores: (1) OpenSearch Service for full-text search queries, (2) ElastiCache Redis for low-latency key-value lookups, (3) S3 + Athena for analytical queries. Each read model is optimized for its specific query pattern. API Gateway routes read requests to the appropriate Lambda function based on the query type.

C. Use RDS for writes and DynamoDB for reads.

D. Use a single EventBridge bus for all commands and queries.

**Correct Answer: B**

**Explanation:** DynamoDB Streams-based CQRS (B) cleanly separates write and read concerns. The write path is optimized for transactional operations via DynamoDB. The stream captures all changes and projects to purpose-built read stores: OpenSearch for search, Redis for fast lookups, S3+Athena for analytics. Each read model is optimized for its query pattern without impacting write performance. The stream provides eventual consistency between write and read models. Option A doesn't provide CQRS separation. Option C mixes paradigms unnecessarily. Option D conflates event routing with data storage.

---

### Question 34

A company needs to implement serverless batch processing that runs every hour, processing data from 1,000 S3 objects. Each object requires independent processing that takes 2-5 minutes. Total processing must complete within 30 minutes.

Which architecture processes 1,000 objects in parallel within the time constraint?

A. Use a single Lambda function iterating over all objects sequentially.

B. Use Step Functions Distributed Map state. The workflow: (1) Lambda generates the list of 1,000 S3 object keys. (2) Distributed Map state processes all objects in parallel with max concurrency of 200, each iteration running a Lambda function that processes one S3 object. (3) A results-collection Lambda aggregates outcomes. Configure the Distributed Map with tolerated failure count for resilience. EventBridge Scheduler triggers the workflow hourly.

C. Use 1,000 individual EventBridge scheduled rules, each triggering a Lambda for one object.

D. Use SQS with 1,000 messages and Lambda polling.

**Correct Answer: B**

**Explanation:** Step Functions Distributed Map (B) is designed for exactly this pattern — large-scale parallel processing. It supports up to 10,000 concurrent iterations, easily handling 1,000 objects. Max concurrency of 200 means ~5 batches of 200, each taking 5 minutes = 25 minutes (within the 30-minute requirement). Tolerated failure count provides resilience without failing the entire batch. EventBridge Scheduler provides cron-like triggering. Option A — sequential processing of 1,000 objects (2-5 min each) would take 33-83 hours. Option C is unmanageable. Option D works but doesn't provide the orchestration, visibility, and error handling of Step Functions.

---

### Question 35

A company needs to implement API Gateway caching for a REST API that serves product catalog data. Different products change at different rates — some change hourly, others are static for months. They want to optimize cache hit ratio while ensuring data freshness.

Which caching strategy optimizes both hit ratio and freshness?

A. Enable API Gateway caching with a single TTL of 300 seconds for all responses.

B. Enable API Gateway caching at the stage level. Configure per-method cache TTLs: static product categories → 3600 seconds (1 hour), frequently updated products → 60 seconds, real-time pricing → 0 seconds (no cache). Use cache key parameters to include query string parameters and headers that affect the response. Implement cache invalidation using the Cache-Control: max-age=0 header for administrative updates. Set cache capacity to 6.1 GB for optimal performance.

C. Implement client-side caching and skip API Gateway caching.

D. Use CloudFront caching in front of API Gateway instead of API Gateway's native cache.

**Correct Answer: B**

**Explanation:** Per-method cache TTLs (B) optimize for different update frequencies. Static data gets long TTLs (high hit ratio), frequently updated data gets short TTLs (balance of freshness and hits), and real-time data skips caching. Cache key parameters ensure unique responses are cached separately. Cache invalidation via headers enables administrative overrides. The 6.1 GB cache size provides sufficient space for varied product data. Option A applies a single TTL that's either too short (wasting cache for static data) or too stale (serving old dynamic data). Option C loses server-side cache benefits. Option D adds another caching layer but doesn't enable per-method TTL control.

---

### Question 36

A company runs a Lambda function that processes images uploaded to S3. The function resizes images using the Sharp library (native Node.js addon). When deployed, the function fails with "Cannot find module 'sharp'" because the node_modules were built on macOS but Lambda runs on Amazon Linux.

Which solution resolves the native dependency issue?

A. Install sharp on Amazon Linux by building the Lambda deployment package in a Docker container that matches the Lambda runtime. Use the AWS SAM CLI with sam build --use-container to automatically build in a Lambda-compatible container. Alternatively, create a Lambda Layer with sharp pre-compiled for the Amazon Linux 2 x86_64 (or arm64 for Graviton) platform.

B. Bundle a pre-compiled sharp binary for all platforms in the deployment package.

C. Use ImageMagick via the /opt/bin path that Lambda provides.

D. Replace sharp with a pure JavaScript image processing library.

**Correct Answer: A**

**Explanation:** Building in a Lambda-compatible container (A) ensures native dependencies are compiled for Amazon Linux. SAM CLI's --use-container flag handles this automatically. Alternatively, a Lambda Layer with pre-compiled binaries provides a reusable solution. The sharp library's npm package actually includes pre-built binaries for Linux x64 when installed with the correct platform flag (npm install --platform=linux --arch=x64 sharp). Option B bloats the package with unnecessary platform binaries. Option C — ImageMagick is not pre-installed in current Lambda runtimes. Option D loses the performance benefits of sharp.

---

### Question 37

A company uses API Gateway with Lambda proxy integration. They observe that the first request after a deployment takes 8-10 seconds (cold start) because their Lambda function loads a large ML model (500 MB) during initialization. Subsequent requests complete in 200ms.

Which solution eliminates the cold start latency?

A. Reduce the Lambda memory allocation to reduce initialization time.

B. Configure provisioned concurrency on the Lambda function. Set provisioned concurrency to match the expected minimum concurrent requests (e.g., 10). Use Application Auto Scaling to adjust provisioned concurrency based on the API Gateway utilization schedule (higher during business hours, lower overnight). Move the ML model loading to the initialization phase (outside the handler) so it completes during provisioned concurrency initialization.

C. Use a Lambda@Edge function instead, which has no cold start.

D. Deploy the ML model as a Lambda Layer to speed up loading.

**Correct Answer: B**

**Explanation:** Provisioned concurrency (B) keeps Lambda execution environments pre-initialized, eliminating cold starts. The ML model loads during initialization (outside the handler), and provisioned concurrency ensures these environments are ready before requests arrive. Application Auto Scaling adjusts the provisioned concurrency count based on demand patterns, optimizing cost. Option A — less memory actually increases cold start time (Lambda allocates CPU proportional to memory). Option C — Lambda@Edge also has cold starts and has 5-second timeout limits. Option D — Layers still need to be loaded during initialization.

---

### Question 38

A company processes financial transactions using SQS FIFO queues. They need to ensure that if a message fails processing 3 times, it moves to a dead-letter queue (DLQ) AND the remaining messages in that message group are blocked until the failed message is handled — preventing out-of-order processing after a failure.

Which configuration ensures per-group message blocking on failure?

A. Configure the FIFO queue with a DLQ (maxReceiveCount = 3). After a message moves to the DLQ, subsequent messages in the same message group remain blocked because SQS FIFO maintains per-message-group ordering — the next message in the group won't be delivered until the failed one is successfully processed or moved to the DLQ.

B. Actually, SQS FIFO behavior is: once a message is moved to the DLQ (after maxReceiveCount), the next message in the group IS delivered. To block the group, implement a Lambda consumer that: (1) On failure, records the failed message group ID in a DynamoDB table. (2) Before processing any message, checks if the message group ID is in the "blocked" table. (3) If blocked, immediately makes the message visible again (by not deleting it) and skips processing. (4) An operational team reviews the DLQ, resolves the issue, and removes the block from DynamoDB.

C. Use separate FIFO queues per message group for complete isolation.

D. Set visibility timeout to a very high value to prevent re-delivery of subsequent messages.

**Correct Answer: B**

**Explanation:** Understanding SQS FIFO DLQ behavior (B) is critical. Once a message reaches maxReceiveCount and is moved to the DLQ, SQS considers it processed and delivers the NEXT message in the group. This can cause out-of-order processing. To prevent this, you need application-level blocking — the consumer must track failed groups and refuse to process subsequent messages until the failure is resolved. This is a common pattern for financial transaction processing where strict ordering must be maintained even across failures. Option A incorrectly assumes the group remains blocked after DLQ redirect. Options C and D are impractical.

---

### Question 39

A company needs to implement a serverless application that needs to call an external API that has a rate limit of 10 requests per second. The internal system generates 1,000 requests per minute that need to make this external call.

Which architecture smooths the request rate to comply with the external API's rate limit?

A. Use SQS as a buffer between the internal system and the external API. Configure a Lambda function to poll the SQS queue with a reserved concurrency of 1 and batch size of 1. Use a Lambda Destination to handle failures. Add a wait mechanism: the Lambda function processes one message, calls the external API, and uses the SQS visibility timeout and batch window settings to control the processing rate. Alternatively, use Step Functions with a Wait state of 100ms between API calls.

B. Use API Gateway throttling to limit internal requests to 10 per second.

C. Implement backoff and retry in each calling Lambda function.

D. Use a token bucket algorithm implemented in DynamoDB to control the call rate.

**Correct Answer: A**

**Explanation:** SQS with controlled Lambda concurrency (A) provides a natural rate-limiting buffer. With reserved concurrency of 1, only one Lambda instance processes messages. At 1,000 messages/minute ≈ 17/second, the single Lambda processes them sequentially. Each external API call takes time, naturally throttling the rate. For precise control, Step Functions with a Wait state between calls provides exact timing. The SQS queue absorbs the burst (1,000/min) and drains at the controlled rate (10/sec = 600/min). Option B throttles internal requests but doesn't smooth them to the external rate. Option C leads to inconsistent retry storms. Option D works but is more complex.

---

### Question 40

A company needs a serverless API that supports GraphQL with real-time subscriptions, offline data synchronization for mobile clients, and automatic conflict resolution when multiple clients modify the same data.

Which AWS serverless solution provides all these capabilities natively?

A. API Gateway REST API with Lambda resolvers and WebSocket API for real-time updates.

B. AWS AppSync. Configure a GraphQL API with: (1) DynamoDB resolvers for CRUD operations. (2) Real-time subscriptions using AppSync's built-in WebSocket support — clients subscribe to mutations and receive updates automatically. (3) Enable AppSync's built-in offline support and conflict detection/resolution with DynamoDB versioning (optimistic concurrency with version field). Mobile clients use the Amplify DataStore library for seamless offline sync.

C. API Gateway HTTP API with EventBridge for real-time events.

D. Custom WebSocket server on Fargate with DynamoDB for data storage.

**Correct Answer: B**

**Explanation:** AWS AppSync (B) is purpose-built for this use case, providing all three capabilities natively: GraphQL API with flexible resolvers, built-in real-time subscriptions via WebSockets (no custom infrastructure), and offline data synchronization with automatic conflict resolution (configurable strategies: auto-merge, optimistic concurrency, custom Lambda resolver). Amplify DataStore provides the client-side SDK. Option A requires building all three capabilities manually. Option C doesn't support GraphQL or subscriptions natively. Option D requires significant custom development.

---

### Question 41

A company needs to implement a serverless event sourcing pattern where all state changes in their order management system are captured as immutable events. The system must support replaying events to rebuild state, querying the event stream, and projecting events into read models.

Which serverless architecture implements event sourcing?

A. Use DynamoDB as a mutable state store with change tracking via versioning.

B. Use DynamoDB as the event store with the following design: partition key = aggregate ID (order ID), sort key = event timestamp + sequence number. Each item is an immutable event (OrderCreated, ItemAdded, PaymentProcessed). Enable DynamoDB Streams to project events to read models. A Lambda function triggered by the stream projects events to: (1) a current-state DynamoDB table for fast lookups, (2) OpenSearch for event stream queries, (3) S3 for long-term event archival. For event replay, use a Lambda function that reads events by aggregate ID in sort key order and rebuilds the aggregate state.

C. Use Kinesis Data Streams as the event store with infinite retention.

D. Use S3 with event objects stored as JSON files.

**Correct Answer: B**

**Explanation:** DynamoDB as an event store (B) provides the right characteristics for event sourcing: partition key for aggregate grouping, sort key for event ordering, immutable items (append-only writes), and DynamoDB Streams for real-time projections. The read models are materialized via stream-triggered Lambda functions. Event replay reads all events for an aggregate in order and rebuilds state. This is a proven serverless event sourcing pattern. Option A is CRUD, not event sourcing. Option C — Kinesis doesn't efficiently support querying events by aggregate ID. Option D — S3 lacks efficient sorted querying by aggregate.

---

### Question 42

A company needs to build a serverless machine learning inference pipeline that accepts images, runs them through three ML models in sequence (object detection → classification → sentiment analysis), and returns aggregated results. Each model inference takes 5-15 seconds, and the pipeline must handle 500 concurrent requests.

Which architecture supports high-concurrency, multi-model inference?

A. Use a single Lambda function that loads all three models and runs them sequentially.

B. Use API Gateway → Step Functions Express Workflow. The workflow calls three Lambda functions in sequence: (1) Object detection Lambda (with provisioned concurrency, model loaded at init). (2) Classification Lambda (with provisioned concurrency). (3) Sentiment analysis Lambda (with provisioned concurrency). Each Lambda uses 10 GB memory configuration for ML model loading. The Step Functions Express Workflow handles the orchestration with 5-minute max duration (sufficient for 15s × 3 = 45s total). Use API Gateway synchronous integration with Step Functions for request-response pattern.

C. Use SQS between each model for decoupling.

D. Deploy models on SageMaker endpoints and orchestrate with Step Functions.

**Correct Answer: B**

**Explanation:** Step Functions Express Workflow with provisioned concurrency Lambda (B) provides managed orchestration with consistent latency. Express Workflows support synchronous request-response patterns via API Gateway. Each Lambda function specializes in one model, keeping memory efficient and enabling independent scaling. Provisioned concurrency eliminates cold starts for latency-sensitive inference. 10 GB Lambda memory provides sufficient resources for ML models. The Express Workflow handles 500 concurrent executions within its limits. Option A risks timeout (15s × 3 models) and requires massive memory for all models. Option C adds latency from queue polling. Option D is valid for production ML but uses non-serverless SageMaker instances.

---

### Question 43

A company has a Lambda function that processes SQS messages. The function currently processes one message at a time (batch size 1), resulting in high Lambda invocation costs. They process 10 million messages per day.

Which optimization reduces Lambda costs while maintaining processing reliability?

A. Increase the Lambda memory to process messages faster.

B. Increase the event source mapping batch size to 100 and batch window to 60 seconds. Modify the Lambda function to process messages in a batch loop. Enable report batch item failures so that only failed messages return to the queue (not the entire batch). This reduces Lambda invocations from 10 million to approximately 100,000 per day (100x reduction in invocation cost).

C. Use SNS instead of SQS to reduce costs.

D. Switch to Kinesis for message processing with larger batches.

**Correct Answer: B**

**Explanation:** Batch processing with report batch item failures (B) dramatically reduces invocations. A batch size of 100 means each Lambda processes 100 messages per invocation. The report batch item failures feature is critical — when a message in a batch fails, only that message returns to the queue (not all 100), preventing reprocessing of successful messages. The 60-second batch window ensures Lambda waits to accumulate messages before invoking, further reducing invocations during low-traffic periods. Option A doesn't address invocation count. Option C changes the messaging model. Option D requires infrastructure changes for marginal benefit.

---

### Question 44

A company operates an API Gateway REST API with Lambda integration. They discover that 60% of API responses are identical for the same query parameters within any 5-minute window. The API handles 1 million requests per day.

Which optimization reduces both cost and latency for repeated requests?

A. Implement application-level caching in Lambda using global variables.

B. Enable API Gateway caching with a 300-second (5-minute) TTL. Configure cache key parameters to include the relevant query string parameters. Set the cache capacity to 1.6 GB (appropriate for the data size). This eliminates Lambda invocations for cached responses, reducing Lambda costs by ~60% (600K fewer invocations/day) and improving response latency from ~100ms to ~1ms for cached hits.

C. Use CloudFront caching in front of API Gateway.

D. Implement DynamoDB response caching within the Lambda function.

**Correct Answer: B**

**Explanation:** API Gateway caching (B) is the most cost-effective optimization for this pattern. With 60% cache hit ratio, 600K of 1M daily requests are served directly from the cache without invoking Lambda. This eliminates Lambda invocation cost, compute cost, and reduces latency to single-digit milliseconds for cached responses. Cache key parameters ensure different query combinations get their own cache entries. Option A — Lambda's execution environment reuse is not guaranteed and doesn't help across different invocations. Option C adds another caching layer with less control. Option D still requires Lambda invocation for every request.

---

### Question 45

A company uses Step Functions Standard Workflows for order processing. Each workflow execution costs $0.025 per 1,000 state transitions. They process 100,000 orders per day with an average of 20 state transitions per order, totaling 2 million transitions/day ($50/day).

Which optimization reduces Step Functions costs?

A. Reduce the number of steps in the workflow by combining multiple actions into single Lambda functions.

B. Analyze the workflow for steps that don't require exactly-once execution semantics or the Standard Workflow's audit trail. Convert high-throughput, low-duration sub-workflows to Express Workflows (priced by duration, not transitions). Keep the outer orchestration as Standard for audit trail. For example, if 15 of 20 transitions are in a data-processing sub-workflow, move those to an Express Workflow called from the Standard Workflow. Cost comparison: 100K × 15 transitions × $0.025/1000 = $37.50/day in Standard vs. ~$5/day for equivalent Express Workflow duration.

C. Use EventBridge for orchestration instead of Step Functions.

D. Process orders in batches to reduce the number of workflow executions.

**Correct Answer: B**

**Explanation:** Hybrid Standard + Express Workflows (B) optimize cost by matching pricing model to requirements. Standard Workflows charge per transition ($0.025/1000) and provide audit trails, execution history, and exactly-once semantics. Express Workflows charge by duration and number of requests — much cheaper for high-throughput processing. Moving data-processing steps (which don't need long-term audit) to Express while keeping the orchestration shell in Standard saves ~85% on those transitions. Option A reduces functionality. Option C loses Step Functions' state management. Option D complicates error handling.

---

### Question 46

A company runs 200 Lambda functions triggered by various events. They notice that 50 functions have been allocated 1024 MB memory but only use 128 MB during execution. The over-provisioning adds $3,000/month in unnecessary costs.

Which approach right-sizes Lambda function memory allocations?

A. Manually reduce all over-provisioned functions to 128 MB memory.

B. Use AWS Lambda Power Tuning (open-source tool) to automatically test each function at various memory configurations (128 MB to 3008 MB) and identify the optimal memory size that balances cost and performance. Lambda allocates CPU proportional to memory, so reducing memory also reduces CPU — verify that function execution time doesn't increase disproportionately. For the 50 over-provisioned functions, run Power Tuning and apply the recommended configurations. Use AWS Compute Optimizer's Lambda function recommendations for ongoing monitoring.

C. Set all functions to the minimum 128 MB memory.

D. Use provisioned concurrency instead of adjusting memory.

**Correct Answer: B**

**Explanation:** Lambda Power Tuning (B) scientifically determines the optimal memory-cost balance. Simply reducing memory to match usage (128 MB) would reduce CPU proportionally, potentially increasing duration and total cost (Lambda charges per ms × memory). Power Tuning tests various configurations and finds the sweet spot where cost (memory × duration) is minimized. Some functions might actually cost less at 256 MB because they finish 3x faster despite using 2x memory. Compute Optimizer provides ongoing recommendations. Option A might increase execution time. Option C risks performance degradation. Option D addresses cold starts, not memory optimization.

---

### Question 47

A company uses EventBridge rules to trigger Lambda functions. They have 500 rules across 20 accounts, and rule maintenance has become a significant operational burden. Many rules have similar patterns with slight variations.

Which optimization reduces rule management overhead?

A. Consolidate rules by using EventBridge event patterns with content filtering — OR conditions, prefix matching, numeric matching, and exists patterns. Instead of 10 rules matching similar events with slight variations, create one rule with a compound pattern using $or operators. Transform events using EventBridge Input Transformers before passing to targets, reducing the need for per-target processing logic. Use EventBridge Pipes for source-to-target integrations that don't need complex routing.

B. Delete unused rules and keep only active ones.

C. Use SNS topics instead of EventBridge rules for simpler management.

D. Create a management Lambda that dynamically creates and deletes rules based on configuration.

**Correct Answer: A**

**Explanation:** Rule consolidation with advanced patterns (A) dramatically reduces the number of rules. EventBridge supports sophisticated pattern matching — $or, prefix, numeric ranges, and exists — allowing a single rule to cover multiple event variations. Input Transformers reduce downstream processing by reshaping events before delivery. EventBridge Pipes simplify point-to-point integrations without needing rules at all. This could reduce 500 rules to under 100. Option B is a one-time cleanup without structural improvement. Option C loses EventBridge's advanced filtering. Option D adds custom infrastructure.

---

### Question 48

A company has a Lambda function that queries an RDS PostgreSQL database. During traffic spikes, the Lambda function creates too many database connections, overwhelming the RDS instance (max_connections = 100). The function handles 500 concurrent requests during peaks.

Which solution resolves the database connection issue?

A. Increase the RDS instance size to allow more connections.

B. Use Amazon RDS Proxy between the Lambda function and the RDS instance. RDS Proxy maintains a connection pool and multiplexes Lambda invocations across a smaller number of database connections. Configure the proxy with max connections percentage of 80% (80 connections from the 100 available). Lambda functions connect to the proxy endpoint instead of directly to RDS. The proxy handles connection pooling, reuse, and multiplexing transparently.

C. Implement connection pooling in the Lambda function code using a global variable.

D. Use DynamoDB instead of RDS to avoid connection limits.

**Correct Answer: B**

**Explanation:** RDS Proxy (B) is the AWS-recommended solution for Lambda-to-RDS connections. It manages a connection pool that's shared across all Lambda invocations. 500 concurrent Lambda functions connect to the proxy, which multiplexes them across 80 actual database connections. Connections are efficiently reused, and the proxy handles connection cleanup when Lambda environments are recycled. Option A increases connections but doesn't solve the fundamental mismatch between Lambda's scaling model and RDS connection limits. Option C — Lambda's global variable connection reuse works within a single execution environment but doesn't solve cross-environment connection explosion. Option D changes the database.

---

### Question 49

A company's Step Functions workflow takes 30 minutes to complete because it includes a state that waits for a human approval via email. The approval step adds 25 minutes (waiting for human response) to an otherwise 5-minute automated workflow.

Which optimization allows the workflow to wait for human approval without keeping the execution running?

A. Use Step Functions .waitForTaskToken integration pattern. The workflow: (1) A Task state sends an approval email containing the task token (via SES or SNS). (2) The Task state pauses (no compute consumed) until the token is returned. (3) The approver clicks a link that triggers an API Gateway → Lambda function, which calls SendTaskSuccess or SendTaskFailure with the task token. This pauses the workflow execution without consuming resources during the wait period.

B. Use a Step Functions Wait state with a fixed duration of 25 minutes.

C. Use a Lambda function that polls an approval queue every 30 seconds.

D. Split the workflow into two separate workflows — before and after approval.

**Correct Answer: A**

**Explanation:** The .waitForTaskToken callback pattern (A) is designed for human-in-the-loop workflows. The execution pauses at the Task state and consumes no resources until the task token is returned. The email contains a unique token embedded in approve/reject URLs. Clicking the URL triggers an API that calls back to Step Functions with the token. This is efficient — no polling, no idle compute. Standard Workflows support wait times up to 1 year. Option B wastes time if approval comes early. Option C wastes Lambda invocations on polling. Option D loses single-workflow orchestration and error handling.

---

### Question 50

A company uses Lambda functions extensively and notices that VPC-attached Lambda functions have 10-15 second cold starts compared to 1-2 seconds for non-VPC functions. They need VPC access for RDS connectivity but want to minimize cold start impact.

Which combination of approaches minimizes VPC Lambda cold starts? (Choose TWO.)

A. Use Hyperplane ENI (which is now the default for VPC Lambda). Since 2019, Lambda VPC networking uses Hyperplane ENIs that are shared across invocations, significantly reducing VPC cold start times to comparable levels with non-VPC functions. Verify the Lambda functions are using the current VPC implementation.

B. Use provisioned concurrency for latency-sensitive functions to eliminate cold starts entirely.

C. Remove VPC configuration and use a NAT Gateway to access RDS from non-VPC Lambda.

D. Use smaller Lambda deployment packages to reduce cold start time.

E. Implement a keep-warm mechanism by pinging the Lambda function every 5 minutes.

**Correct Answer: A, B**

**Explanation:** Hyperplane ENI (A) (current default) has dramatically reduced VPC Lambda cold starts from the historical 10-15 seconds to under 1 second in most cases. If the company sees 10-15 second cold starts, they may be using the older VPC implementation or have a different issue. Verifying the current implementation is the first step. Provisioned concurrency (B) eliminates cold starts entirely by keeping environments pre-initialized. Option C is incorrect — non-VPC Lambda cannot directly connect to RDS in a VPC. Option D has minimal impact on VPC-specific cold start. Option E is a hack that doesn't reliably prevent all cold starts.

---

### Question 51

A company sends 500,000 emails per day using SES, triggered by Lambda functions. Each Lambda invocation sends one email, resulting in 500,000 Lambda invocations. The Lambda function constructs the email from a template and calls the SES API.

Which optimization reduces the overhead of email sending?

A. Use SES bulk email sending templates. Instead of individual Lambda invocations per email, batch recipients: (1) Group emails by template and send up to 50 destinations per SES SendBulkTemplatedEmail API call. (2) Process batches using SQS with a batch size of 50, where each Lambda invocation handles 50 emails. This reduces Lambda invocations from 500,000 to 10,000 (50x reduction). Use SES templates for personalization instead of constructing emails in Lambda.

B. Use SNS to send emails instead of SES for better integration.

C. Use a dedicated EC2 instance for email sending to avoid Lambda overhead.

D. Increase Lambda memory to send emails faster.

**Correct Answer: A**

**Explanation:** SES bulk sending with batched Lambda (A) provides the most significant optimization. The SendBulkTemplatedEmail API handles up to 50 personalized emails per call, reducing both Lambda invocations and SES API calls by 50x. SES templates handle personalization (variable substitution) server-side, eliminating email construction in Lambda. SQS batching ensures efficient grouping. Option B — SNS email is limited and not suitable for transactional emails. Option C loses serverless benefits. Option D doesn't address the invocation count problem.

---

### Question 52

A company's EventBridge rules occasionally fail to invoke Lambda functions, and events are lost without any notification. They need to ensure no events are lost and all failures are detected.

Which approach prevents event loss and ensures failure visibility?

A. Configure DLQs (SQS queues) on EventBridge rules as failure destinations. When a rule fails to deliver an event to the target (Lambda throttling, permission error, etc.), the event is sent to the DLQ. Create CloudWatch alarms on the DLQ ApproximateNumberOfMessagesVisible metric to alert on failed deliveries. Also configure Lambda async invocation DLQs for events that are delivered to Lambda but fail processing. Enable EventBridge retry policy with maximum of 185 retries over 24 hours for transient failures.

B. Enable CloudTrail to log all EventBridge events and manually check for failures.

C. Use EventBridge Archives to capture all events and replay any that weren't processed.

D. Increase Lambda concurrency to prevent throttling-related event loss.

**Correct Answer: A**

**Explanation:** Multi-layer failure handling (A) addresses all event loss scenarios. EventBridge rule DLQs catch delivery failures (target unavailable, permission issues). EventBridge's built-in retry policy (up to 185 retries over 24 hours) handles transient failures. Lambda async DLQs catch processing failures. CloudWatch alarms on DLQ depth provide visibility. This creates a comprehensive safety net. Option B doesn't prevent loss or provide real-time alerting. Option C provides replay capability but doesn't prevent initial loss. Option D addresses one failure mode but not others.

---

### Question 53

A company uses API Gateway REST APIs with custom Lambda authorizers for authentication. The authorizer Lambda is invoked for every API request, adding 50ms latency and significant Lambda cost. The authorization decision rarely changes for the same token.

Which optimization reduces authorizer invocations and latency?

A. Replace Lambda authorizers with IAM authorization.

B. Enable authorizer caching in API Gateway. Set the TTL to 300 seconds (5 minutes), matching the token's claims refresh cycle. Configure the identity source (Authorization header) as the cache key so that identical tokens return the cached authorization result without invoking the Lambda authorizer. For a TOKEN-type authorizer, the token value is the cache key. For a REQUEST-type authorizer, configure the identity sources to include relevant headers and query parameters.

C. Move authorization logic into each backend Lambda function.

D. Use Cognito User Pools instead of custom Lambda authorizers.

**Correct Answer: B**

**Explanation:** Authorizer caching (B) eliminates redundant Lambda invocations for repeated tokens. With a 300-second TTL, the first request with a given token invokes the authorizer; subsequent requests within 5 minutes use the cached result (no Lambda invocation, no 50ms latency). For APIs with high traffic from authenticated users, this can eliminate 90%+ of authorizer invocations. The identity source configuration ensures different tokens get separate cache entries. Option A changes the auth model. Option C moves cost to backend. Option D changes the auth provider.

---

### Question 54

A company is migrating a traditional Java Spring Boot monolithic application to a serverless architecture on AWS. The application has 50 REST endpoints, connects to a PostgreSQL database, uses Redis for caching, and has background job processing.

Which migration approach provides a smooth transition to serverless?

A. Rewrite the entire application from scratch in Node.js Lambda functions.

B. Phase 1 (Lift and Shift): Deploy the Spring Boot application as a single Lambda function using AWS Lambda Web Adapter or Spring Cloud Function. API Gateway proxies all requests to the single Lambda. This provides immediate serverless benefits (no server management, pay-per-use) with minimal code changes. Phase 2 (Strangler Fig): Gradually extract individual endpoints to dedicated Lambda functions. Phase 3: Move background jobs to Step Functions with SQS. Phase 4: Replace the monolithic Lambda with individual Lambda functions per endpoint.

C. Deploy the Spring Boot application on Fargate and call it "serverless."

D. Use Elastic Beanstalk with auto-scaling as a serverless alternative.

**Correct Answer: B**

**Explanation:** The phased approach (B) minimizes risk. Lambda Web Adapter or Spring Cloud Function wraps the existing Java application as a Lambda function, providing an immediate serverless deployment without code rewrites. API Gateway handles routing. Over time, the Strangler Fig pattern extracts endpoints to optimized, individual Lambda functions. Background jobs migrate to Step Functions. This approach delivers value immediately while enabling incremental improvement. Option A is high-risk and time-consuming. Option C (Fargate) isn't truly serverless (you manage container configurations). Option D isn't serverless.

---

### Question 55

A company is migrating from RabbitMQ to SQS/SNS for their message-based integration. The RabbitMQ setup uses exchanges, routing keys, and topic patterns for message routing. They need equivalent functionality on AWS.

Which AWS messaging architecture replicates RabbitMQ routing patterns?

A. Use SQS Standard queues for all messaging.

B. Map RabbitMQ concepts to AWS services: (1) RabbitMQ topic exchange → SNS topics with message filtering policies. (2) Routing keys → SNS message attributes with filter policies. (3) Queue bindings → SQS queue subscriptions to SNS topics with filter policies. (4) Fan-out exchange → SNS topic with multiple SQS subscribers. (5) Direct exchange → SNS with exact match filter policies. (6) Dead-letter exchange → SQS DLQ configuration. Implement message filtering at the SNS subscription level to replicate topic pattern matching (e.g., order.* matches order.created, order.updated).

C. Use Amazon MQ (managed RabbitMQ) instead of migrating to SQS/SNS.

D. Use EventBridge as a replacement for all RabbitMQ functionality.

**Correct Answer: B**

**Explanation:** The SNS/SQS pattern (B) maps directly to RabbitMQ concepts. SNS topics replace exchanges, filter policies replace routing keys, and SQS subscriptions replace queue bindings. SNS filter policies support exact match, prefix, numeric range, and exists patterns — covering most RabbitMQ routing patterns. Fan-out is native to SNS. This is the recommended AWS-native migration path. Option A loses routing capabilities. Option C is a valid alternative but the question asks about migrating TO SQS/SNS. Option D (EventBridge) can also work but is more commonly used for event-driven architectures rather than message queuing patterns.

---

### Question 56

A company is migrating from a cron-based batch job system (running on EC2) to serverless. They have 200 cron jobs of varying complexity: some run simple scripts (5 seconds), some run complex data processing (45 minutes), and some require orchestrating multiple steps with conditional logic.

Which serverless migration strategy handles all job types?

A. Use Lambda functions for all jobs with CloudWatch Events scheduling.

B. Categorize and migrate based on complexity: (1) Simple jobs (< 15 min, single task): Lambda functions triggered by EventBridge Scheduler. EventBridge Scheduler supports cron expressions and rate-based schedules. (2) Long-running jobs (> 15 min): Step Functions Standard Workflows triggered by EventBridge Scheduler. Use Activity tasks or ECS/Fargate tasks within the workflow for processing exceeding Lambda's limits. (3) Multi-step orchestrations: Step Functions workflows with parallel, conditional, and error-handling states. (4) Jobs requiring specific runtime environments: ECS Fargate tasks triggered by EventBridge Scheduler. Map each existing cron schedule to an EventBridge Scheduler schedule.

C. Use AWS Batch for all job types.

D. Run all cron jobs as Lambda functions with 15-minute timeouts.

**Correct Answer: B**

**Explanation:** Categorization by job type (B) ensures the right service handles each workload. Lambda is ideal for short jobs (pay-per-invocation, zero management). Step Functions handles long-running orchestrations (up to 1 year). ECS Fargate handles jobs requiring specific environments or exceeding Lambda's constraints. EventBridge Scheduler provides flexible scheduling for all types, replacing cron. Option A can't handle jobs exceeding 15 minutes. Option C is good for batch but adds complexity for simple jobs. Option D fails for jobs longer than 15 minutes.

---

### Question 57

A company is migrating a Windows-based application that uses MSMQ (Microsoft Message Queuing) for inter-process communication to a serverless architecture. The application relies on MSMQ's transactional message delivery and poison message handling.

Which AWS services replicate MSMQ's transactional capabilities?

A. Use SQS Standard queues as a direct replacement.

B. Use SQS FIFO queues for transactional message delivery: (1) Exactly-once delivery maps to FIFO deduplication. (2) Ordered delivery maps to FIFO message groups. (3) Poison message handling maps to SQS DLQ with maxReceiveCount. (4) Transaction semantics: while SQS doesn't support XA transactions, implement application-level transaction patterns — process message and write to database, then delete message. On failure, message returns after visibility timeout (similar to MSMQ abort). Use DLQ for messages that exceed retry count (poison messages).

C. Use Amazon MQ with ActiveMQ, which supports JMS transactions similar to MSMQ.

D. Use Kinesis Data Streams for message ordering and exactly-once delivery.

**Correct Answer: B**

**Explanation:** SQS FIFO (B) provides the closest serverless equivalent to MSMQ transactional queues. FIFO delivery guarantees ordering, deduplication provides exactly-once semantics (within the 5-minute window), and DLQ handles poison messages. The visibility timeout mechanism provides effective retry behavior similar to MSMQ transaction abort. For most workloads, this mapping is sufficient. Option A — Standard SQS lacks ordering and deduplication. Option C is valid but not serverless (managed broker). Option D — Kinesis provides ordering but different consumption semantics.

---

### Question 58

A company is migrating a REST API from an on-premises Nginx-based API gateway to AWS API Gateway. The Nginx setup uses complex URL rewriting rules, rate limiting per route, custom error pages, and request/response header manipulation.

Which API Gateway configuration replicates the Nginx API gateway functionality?

A. Use API Gateway HTTP API for its simplicity and lower cost.

B. Use API Gateway REST API with the following mapping: (1) URL rewriting → API Gateway resource mapping and integration request URI parameter mapping. (2) Rate limiting per route → Usage plans with per-method throttling. (3) Custom error pages → Gateway response customization for 4xx and 5xx errors. (4) Header manipulation → Integration request and response mapping templates that add, remove, or modify headers. (5) Complex routing → API Gateway resource hierarchy with path parameters and ANY methods. Use Velocity Template Language (VTL) in mapping templates for complex transformations.

C. Use CloudFront in front of ALB to replicate Nginx functionality.

D. Deploy Nginx on Fargate and use it alongside API Gateway.

**Correct Answer: B**

**Explanation:** API Gateway REST API (B) provides feature parity with Nginx API gateway capabilities. REST API's mapping templates (VTL) enable complex URL rewriting and header manipulation. Usage plans provide per-route rate limiting. Gateway responses customize error pages. The resource hierarchy handles complex routing patterns. REST API (not HTTP API) is needed because HTTP API lacks mapping templates and gateway responses. Option A (HTTP API) is simpler but lacks the advanced customization features. Option C doesn't provide API-level features. Option D defeats the purpose of serverless migration.

---

### Question 59

A company is migrating a stateful WebSocket application from an on-premises Node.js server to serverless. The current application maintains WebSocket connections with in-memory session state for a real-time chat application serving 50,000 concurrent users.

Which serverless migration approach handles stateful WebSocket connections at scale?

A. Use a single Fargate task to maintain all WebSocket connections.

B. Use API Gateway WebSocket API for connection management. Migrate the in-memory session state to DynamoDB: (1) Store connection metadata (connectionId, userId, chatRoom) in DynamoDB on $connect. (2) On message received, Lambda retrieves session state from DynamoDB, processes the message, and broadcasts to room participants using the API Gateway Management API (PostToConnection). (3) On $disconnect, clean up DynamoDB records. Use DynamoDB DAX for sub-millisecond session state lookups. Implement a fan-out pattern for broadcasts: when a message arrives, query DynamoDB for all connections in the room and call PostToConnection for each.

C. Use IoT Core's MQTT WebSocket support for the chat application.

D. Use AppSync subscriptions for the real-time chat functionality.

**Correct Answer: B**

**Explanation:** API Gateway WebSocket API with DynamoDB (B) provides a fully serverless migration path. Moving session state from in-memory to DynamoDB eliminates the stateful server requirement. API Gateway manages WebSocket connections at scale (50K+ concurrent). The Lambda functions are stateless, with all session data in DynamoDB. DAX provides fast lookups. The PostToConnection API handles message delivery to specific clients. Option A is not serverless. Option C (IoT Core) works for messaging but is designed for IoT devices. Option D (AppSync) is viable for simpler real-time patterns but the question asks about migrating an existing WebSocket application.

---

### Question 60

A company is migrating from Apache Kafka to Amazon EventBridge for event-driven integration. Their Kafka setup uses topics, consumer groups, and stream processing. They need to maintain similar capabilities.

Which migration mapping provides equivalent EventBridge functionality?

A. Map Kafka topics directly to EventBridge event buses with 1:1 correspondence.

B. Map Kafka concepts to EventBridge: (1) Kafka topic → EventBridge event bus + rules with source/detail-type patterns (an event bus is more flexible than a topic). (2) Kafka consumer groups → Multiple rules on the same bus, each with different targets (EventBridge rules replace consumer group semantics — each rule independently processes events). (3) Stream processing → EventBridge Pipes for source-to-target with enrichment and filtering. (4) Schema management → EventBridge Schema Registry (auto-discovers schemas from events). (5) Ordering → For ordered processing, route to SQS FIFO via EventBridge rule. Note: EventBridge doesn't retain events like Kafka. For replay, enable EventBridge Archive with retention for event replay capability.

C. Use Amazon MSK (Managed Streaming for Apache Kafka) instead of migrating to EventBridge.

D. Use Kinesis Data Streams as a direct Kafka replacement and EventBridge for routing only.

**Correct Answer: B**

**Explanation:** The concept mapping (B) provides a clear migration path from Kafka to EventBridge. EventBridge's event buses are more flexible than Kafka topics — content-based filtering replaces topic-based routing. Rules replace consumer group semantics with more powerful filtering. EventBridge Pipes replace simple stream processing pipelines. Schema Registry provides schema management. Archives provide event replay. The key architectural difference is that EventBridge is push-based (rules push to targets) vs. Kafka's pull-based (consumers pull from topics). Option A oversimplifies the mapping. Option C avoids migration. Option D adds unnecessary complexity.

---

### Question 61

A company is migrating from AWS Lambda@Edge to CloudFront Functions for simple request/response manipulations (header additions, URL rewrites, redirects). They want to reduce execution cost and latency.

Which migration considerations are critical for moving from Lambda@Edge to CloudFront Functions?

A. CloudFront Functions and Lambda@Edge are interchangeable — migrate all functions directly.

B. Evaluate each Lambda@Edge function against CloudFront Functions limitations: (1) CloudFront Functions support only viewer request and viewer response events (not origin request/response). (2) Maximum execution time is 1ms (vs. 5-30 seconds for Lambda@Edge). (3) Maximum memory is 2 MB (vs. 128-10,240 MB for Lambda@Edge). (4) No network access (can't call external APIs or AWS services). (5) Only JavaScript runtime. Functions that only manipulate headers, rewrite URLs, or perform redirects are good candidates. Functions that need origin events, external API calls, or complex processing must remain on Lambda@Edge.

C. Always use Lambda@Edge because CloudFront Functions are too limited.

D. Migrate all functions to CloudFront Functions and handle limitations in the origin.

**Correct Answer: B**

**Explanation:** Careful evaluation of limitations (B) is critical for a successful migration. CloudFront Functions execute in sub-millisecond at edge locations and cost 1/6th of Lambda@Edge. However, they have strict limitations — no network access, minimal memory, and only viewer events. Simple transformations (headers, redirects, URL rewrites, A/B testing based on cookies) are ideal candidates. Functions requiring API calls, database lookups, or origin-level processing must stay on Lambda@Edge. Option A ignores critical limitations. Option C ignores the cost and latency benefits. Option D may break functionality.

---

### Question 62

A company is migrating from an on-premises ESB (Enterprise Service Bus) to a serverless integration architecture on AWS. The ESB currently handles message routing, protocol transformation (SOAP to REST), message enrichment, and dead letter handling.

Which serverless architecture replicates ESB functionality?

A. Deploy MuleSoft on EC2 as a cloud-based ESB.

B. Map ESB capabilities to serverless services: (1) Message routing → EventBridge rules with content-based filtering and SNS with message filtering for pub/sub patterns. (2) Protocol transformation → API Gateway with mapping templates for SOAP-to-REST conversion (VTL templates parse XML SOAP requests and convert to JSON). (3) Message enrichment → EventBridge Pipes enrichment step or Lambda functions that add data from external sources. (4) Dead letter handling → SQS DLQs on all integration points. (5) Orchestration → Step Functions for complex integration workflows. (6) Monitoring → CloudWatch for all components with centralized logging.

C. Use Amazon MQ as a managed ESB replacement.

D. Use a single large Lambda function as the integration hub.

**Correct Answer: B**

**Explanation:** The serverless service mapping (B) distributes ESB functionality across purpose-built services. EventBridge handles routing (replacing ESB routing engine). API Gateway with VTL handles protocol transformation (SOAP XML to REST JSON). EventBridge Pipes or Lambda provides enrichment. SQS DLQs handle dead letters. Step Functions provides orchestration. This decomposed approach is more scalable, resilient, and cost-effective than a monolithic ESB. Option A isn't serverless. Option C is a message broker, not an ESB. Option D creates a monolithic bottleneck.

---

### Question 63

A company processes 50 million SQS messages per day using Lambda. Each message triggers a Lambda invocation with 512 MB memory, and processing takes an average of 500ms. Their monthly Lambda bill is $12,500.

Which optimization provides the greatest cost reduction?

A. Reduce the Lambda timeout setting.

B. Use AWS Lambda Power Tuning to find the optimal memory configuration. Test shows that at 256 MB memory, the function takes 600ms (20% longer but 50% less memory cost). Cost comparison: Current (512 MB × 500ms) = 256,000 GB-ms per invocation. Optimized (256 MB × 600ms) = 153,600 GB-ms per invocation — 40% cost reduction. At 50M invocations/month: $12,500 → $7,500 (saves $5,000/month). Also implement batch processing (batch size 10) to reduce invocations by 10x, saving additional invocation cost.

C. Switch from SQS to Kinesis to reduce the number of Lambda invocations.

D. Use Graviton-based Lambda functions for a flat 20% cost reduction.

**Correct Answer: B**

**Explanation:** Power Tuning optimization (B) scientifically balances memory allocation and duration cost. The key insight is that Lambda billing is memory × duration — sometimes less memory is cheaper even if execution takes longer, because the memory reduction outweighs the duration increase. The 40% reduction from right-sizing plus further savings from batching provides the greatest combined impact. Option A reduces timeout but not actual cost (billing is based on actual duration). Option C changes architecture without necessarily reducing cost. Option D provides 20% savings vs. the combined 40%+ from optimization + batching.

---

### Question 64

A company uses API Gateway REST APIs across 15 accounts. They pay $3.50 per million API calls. Analysis shows that 40% of their 500 million monthly requests are simple proxy passes to Lambda without requiring REST API features (mapping templates, request validation, WAF, API keys).

Which migration reduces API Gateway costs for simple proxy APIs?

A. Replace all REST APIs with HTTP APIs for lower pricing ($1.00 per million requests vs $3.50). But only migrate the 40% that don't need REST API features, saving $500M × 40% × ($3.50 - $1.00) / 1M = $500/month. Keep the 60% requiring REST features on REST API. HTTP APIs support Lambda proxy integration, JWT authorizers, and CORS — sufficient for simple proxy use cases.

B. Replace API Gateway with CloudFront + Lambda@Edge for all APIs.

C. Use Application Load Balancer instead of API Gateway for Lambda invocation.

D. Build a custom API proxy on EC2 for lower cost.

**Correct Answer: A**

**Explanation:** Migrating eligible APIs from REST to HTTP API (A) provides a 71% cost reduction per request for those APIs. HTTP APIs support Lambda proxy integration, OIDC/JWT authorization, automatic CORS handling, and automatic deployments — sufficient for simple proxy use cases. APIs requiring REST-specific features (mapping templates, request validation, WAF integration, usage plans/API keys, caching) stay on REST API. Option B loses API Gateway features. Option C works for simple cases but loses API management features. Option D adds operational overhead.

---

### Question 65

A company uses Step Functions for order processing workflows. They run 5 million workflow executions per month using Standard Workflows, each averaging 10 state transitions. Monthly cost: $1,250 for state transitions.

Some workflows complete in under 30 seconds and don't require the Standard Workflow audit trail. Which optimization reduces Step Functions costs?

A. Reduce the number of states in each workflow.

B. Identify workflows completing in under 5 minutes that don't need long-term execution history. Migrate these to Express Workflows. Express Workflow pricing: $1.00 per million requests + $0.00001667 per GB-second of duration. For 3 million short workflows (60% of total): Current Standard cost: 3M × 10 transitions × $0.025/1000 = $750. Express cost: 3M × $1/1M + duration cost ≈ $3 + ~$50 = $53. Savings: ~$700/month on migrated workflows. Keep 2 million complex workflows on Standard ($500/month).

C. Use Lambda functions instead of Step Functions for simple workflows.

D. Use EventBridge for workflow orchestration instead of Step Functions.

**Correct Answer: B**

**Explanation:** Migrating eligible short-duration workflows to Express (B) provides dramatically lower per-execution costs. Express Workflows charge by duration and requests rather than per-transition, which is much cheaper for high-volume, short-duration workflows. The key requirements for Express: execution under 5 minutes, at-least-once execution acceptable (vs. Standard's exactly-once), and no need for long-term execution history (Express logs to CloudWatch). Option A reduces functionality. Option C loses orchestration benefits. Option D — EventBridge doesn't provide workflow orchestration.

---

### Question 66

A company runs a serverless data processing pipeline that uses Lambda functions with 3 GB memory to process JSON files from S3. Each file is 50 MB. The Lambda function reads the entire file into memory, processes it, and writes results to DynamoDB. Processing 10,000 files per day costs $800/month in Lambda compute.

Which optimization reduces processing costs?

A. Use Fargate tasks for cheaper compute at this memory level.

B. Optimize the Lambda function to use streaming JSON parsing instead of loading the entire file. This allows reducing memory from 3 GB to 512 MB. Use S3 Select to retrieve only the needed fields from the JSON file, reducing data transfer and processing time. Process files in batches using S3 Batch Operations triggering Lambda for each file. These optimizations: (1) Reduce memory 6x (3GB → 512MB). (2) Reduce duration 3x (less data to process with S3 Select). (3) Combined cost reduction: ~85% ($800 → ~$120/month).

C. Switch to Graviton Lambda for 20% savings.

D. Use AWS Glue instead of Lambda for JSON processing.

**Correct Answer: B**

**Explanation:** Combined optimization of memory, processing approach, and data selection (B) provides the greatest savings. Streaming parsing eliminates the need to load 50 MB into memory, allowing a 6x memory reduction. S3 Select retrieves only needed fields, reducing both data transfer and processing time. The multiplicative effect (6x memory reduction × 3x duration reduction) yields ~85% cost savings. Option C provides only 20% savings. Option D (Glue) costs more for this scale of processing. Option A might be cheaper but adds container management complexity.

---

### Question 67

A company uses EventBridge with 500 rules across their organization. Each rule invokes a Lambda function. Many Lambda functions are idle most of the time, only processing a few events per day. The minimum billable duration for each invocation is 1ms, but the company pays for the full initialization even for trivial events.

Which optimization reduces cost for low-frequency Lambda invocations?

A. Consolidate Lambda functions. Instead of 500 Lambda functions (one per rule), create fewer, multi-purpose Lambda functions that handle multiple event types via a switch/dispatch pattern. Route related events to the same Lambda function using EventBridge rule target input transformations to include the event type. Reducing from 500 to 50 Lambda functions reduces the overall number of cold starts and makes better use of Lambda's execution environment reuse.

B. Use EC2 instances instead of Lambda for low-frequency processing.

C. Set Lambda memory to the minimum (128 MB) for all functions.

D. Use EventBridge Pipes instead of rules and Lambda for simple processing.

**Correct Answer: A**

**Explanation:** Function consolidation (A) addresses the core issue — 500 separate functions that each receive a few events per day will experience cold starts on almost every invocation. By consolidating related event processing into fewer functions, each function receives more invocations, increasing execution environment reuse (fewer cold starts). Input transformations add the event type to the payload, allowing the function to dispatch to the correct handler. Option B adds management overhead. Option C doesn't address the cold start issue. Option D works for simple event filtering/transformation but not for Lambda processing logic.

---

### Question 68

A company sends 10 million SNS messages per day across 100 topics. They pay $0.50 per million messages for the first billion. Their monthly cost is $150. They want to reduce messaging costs.

Which optimization reduces SNS costs?

A. Use SQS instead of SNS.

B. Implement message batching where possible. Use SNS message filtering to ensure subscribers only receive relevant messages (reducing downstream processing costs, not SNS message cost). For high-volume, internal service-to-service communication, evaluate replacing SNS with EventBridge for applicable patterns ($1 per million events, but with richer filtering). For scenarios where fan-out to SQS is the primary pattern, consider using SQS directly with Lambda fan-out instead of SNS → SQS. Consolidate topics where possible — 100 topics might be reducible with content-based message filtering.

C. Use SES for all notifications to reduce per-message costs.

D. Switch to Amazon MQ for message distribution.

**Correct Answer: B**

**Explanation:** Multi-faceted optimization (B) addresses different cost drivers. SNS message filtering reduces downstream processing costs by preventing unnecessary Lambda invocations or SQS messages (subscribers only receive what they need). Topic consolidation with filtering reduces management overhead. For some patterns, direct SQS with Lambda fan-out may be cheaper. Note that at $0.50/million, SNS is already very cost-effective — the bigger savings come from reducing downstream processing triggered by unnecessary message deliveries. Option A loses pub/sub. Option C is for email, not messaging. Option D adds infrastructure.

---

### Question 69

A company's serverless application uses DynamoDB on-demand mode for several tables. During consistent workload patterns (not bursty), they notice that provisioned mode with auto-scaling would be significantly cheaper. Their current DynamoDB bill is $15,000/month.

Which approach optimizes DynamoDB costs?

A. Switch all tables to provisioned mode immediately.

B. Analyze each table's access patterns using CloudWatch DynamoDB metrics (ConsumedReadCapacityUnits and ConsumedWriteCapacityUnits over 30 days): (1) Tables with consistent, predictable traffic → Switch to provisioned capacity with auto-scaling (target utilization 70%). Projected savings: 40-60% vs. on-demand for consistent workloads. (2) Tables with highly variable or spiky traffic → Keep on-demand mode to avoid throttling during spikes. (3) Tables with predictable peak schedules → Use scheduled auto-scaling to increase provisioned capacity before known peak times. (4) Consider DynamoDB Reserved Capacity for high-usage tables (1 or 3-year commitment for additional 53-76% savings). Expected total optimization: $15,000 → ~$6,000/month.

C. Reduce DynamoDB usage by caching more aggressively with DAX.

D. Move to Aurora Serverless v2 for relational queries.

**Correct Answer: B**

**Explanation:** Data-driven mode selection (B) optimizes each table based on its access pattern. On-demand mode is optimal for unpredictable workloads but costs ~6x more per unit than provisioned at steady state. Switching consistent workloads to provisioned with auto-scaling provides 40-60% savings. Reserved capacity provides additional savings for committed base usage. The key is analyzing each table individually — some may benefit from on-demand while others from provisioned. Option A risks throttling bursty tables. Option C reduces reads but not the capacity cost model. Option D changes the database.

---

### Question 70

A company runs a serverless application where Lambda functions write logs to CloudWatch Logs. With 200 Lambda functions producing logs, their CloudWatch Logs bill is $8,000/month (ingestion + storage).

Which optimization reduces CloudWatch Logs costs for Lambda?

A. Disable all Lambda logging to eliminate costs.

B. Implement multi-level optimization: (1) Use Lambda Powertools or structured logging to reduce log verbosity — switch from DEBUG to INFO in production (reduces log volume 60-70%). (2) Set CloudWatch Logs retention periods appropriate to each function (7 days for dev, 30 days for prod, 90 days for compliance-sensitive). (3) For long-term retention, use CloudWatch Logs subscription filters to stream logs to S3 via Kinesis Data Firehose (S3 storage is 90% cheaper). (4) Use Lambda Advanced Logging Controls to set the logging level at the Lambda service level without code changes. Expected savings: 70-80% ($8,000 → ~$2,000/month).

C. Use X-Ray tracing instead of logging.

D. Switch to a third-party logging solution.

**Correct Answer: B**

**Explanation:** Multi-level log optimization (B) addresses both ingestion and storage costs. Reducing log verbosity (INFO vs. DEBUG) cuts ingestion volume by 60-70%. Retention policies prevent indefinite log storage. Streaming to S3 for long-term retention reduces storage costs by 90%. Lambda Advanced Logging Controls enable service-level log level management without code deployments. Option A loses observability. Option C is for tracing, not replacing logging. Option D may not be cheaper and adds management complexity.

---

### Question 71

A company uses API Gateway WebSocket APIs with Lambda for a real-time dashboard serving 10,000 concurrent connections. Each connection receives updates every 5 seconds via PostToConnection. The Lambda function making PostToConnection calls costs $2,000/month due to the volume of API calls.

Which optimization reduces the cost of broadcasting to many WebSocket connections?

A. Reduce the update frequency from 5 seconds to 30 seconds.

B. Implement a fan-out optimization: Instead of a single Lambda calling PostToConnection sequentially for 10,000 connections, use a Step Functions Express Workflow with a Map state that calls PostToConnection in parallel batches. Alternatively, use an SNS topic with a Lambda subscriber that processes PostToConnection in batches. More fundamentally, consider AppSync subscriptions which handle the fan-out natively without per-connection API calls.

C. Use SQS to buffer WebSocket messages.

D. Implement long-polling instead of WebSocket for updates.

**Correct Answer: B**

**Explanation:** Optimizing the broadcast pattern (B) addresses the core cost driver — individual PostToConnection calls for 10,000 connections every 5 seconds (2M calls/minute). Parallelizing via Step Functions Map state reduces Lambda duration. AppSync subscriptions provide a native fan-out mechanism where the service handles message delivery to all subscribers without per-connection API calls, potentially eliminating the PostToConnection overhead entirely. Option A reduces update frequency, impacting real-time experience. Option C adds latency. Option D loses real-time capability.

---

### Question 72

A company uses SQS with Lambda event source mapping for order processing. They process 30 million messages per month. The Lambda function occasionally takes longer than expected, and the SQS visibility timeout is set too low (30 seconds), causing messages to become visible and be processed twice.

Which optimization prevents duplicate processing and reduces reprocessing costs?

A. Increase the visibility timeout to 6x the Lambda function's average processing time.

B. Set the SQS visibility timeout to at least 6x the Lambda function's configured timeout (e.g., if Lambda timeout is 60 seconds, set visibility timeout to 360 seconds). This is the AWS recommendation. Additionally, implement idempotent processing using DynamoDB conditional writes — before processing, check if the message ID has been processed. Use Lambda's report batch item failures to handle partial batch failures gracefully. These changes prevent duplicate processing (saving reprocessing costs) and reduce DLQ messages.

C. Use SQS FIFO queues for exactly-once processing.

D. Set the Lambda concurrency to 1 to prevent concurrent duplicate processing.

**Correct Answer: B**

**Explanation:** Proper visibility timeout (6x Lambda timeout) with idempotent processing (B) addresses both the cause and effect of duplicate processing. The visibility timeout prevents premature message re-delivery. Idempotency (via DynamoDB conditional writes) handles the case where duplicate processing still occurs (e.g., Lambda timeout, retry after error). Report batch item failures prevents reprocessing the entire batch for single failures. Option A sets a specific timeout but doesn't address the 6x rule. Option C changes to FIFO, which has different throughput characteristics. Option D destroys scalability.

---

### Question 73

A company runs 50 Step Functions Standard Workflows per day for data pipeline orchestration. Each workflow has 100+ state transitions and runs for 2 hours. The monthly cost is $3,750 (50/day × 30 days × 100 transitions × $0.025/1000).

Which cost optimization is most effective?

A. Reduce the number of states by combining operations.

B. Analyze the workflow structure: many of the 100 states are sequential Lambda calls that could be combined. Refactor the workflow: (1) Combine sequential Lambda calls that don't need independent error handling into single Lambda functions (reduce 100 states to 30). (2) Use Express Workflows for sub-processes that don't need exactly-once semantics (e.g., data transformation sub-workflows). (3) Use Step Functions SDK service integrations instead of Lambda for direct AWS service calls (e.g., directly calling DynamoDB PutItem, SQS SendMessage, or starting Glue jobs from Step Functions without a Lambda intermediary — saves both transition and Lambda costs).

C. Use Lambda orchestration instead of Step Functions.

D. Run workflows less frequently by batching data.

**Correct Answer: B**

**Explanation:** Multi-pronged workflow optimization (B) reduces both transitions and Lambda invocations. Combining sequential Lambda calls reduces state count from 100 to 30 (70% transition cost reduction). SDK service integrations eliminate Lambda intermediaries for direct AWS service calls — calling DynamoDB from Step Functions directly is one transition instead of two (invoke Lambda + Lambda calls DynamoDB). Express Workflows for sub-processes convert per-transition to per-duration pricing for eligible portions. Option A is part of B. Option C loses Step Functions' state management and error handling. Option D may not be feasible for pipeline schedules.

---

### Question 74

A company's serverless application uses provisioned concurrency on 20 Lambda functions to eliminate cold starts. Each function has provisioned concurrency of 50, costing a total of $4,000/month. Analysis shows that only 5 functions need provisioned concurrency during peak hours (9 AM - 5 PM), and the rest don't need it at all.

Which optimization reduces provisioned concurrency costs?

A. Remove provisioned concurrency from all functions and accept cold starts.

B. Remove provisioned concurrency from the 15 functions that don't need it (saving $3,000/month). For the 5 remaining functions, implement Application Auto Scaling for provisioned concurrency with scheduled scaling: provisioned concurrency of 50 during peak hours (9 AM - 5 PM, 8 hours) and 5 during off-peak (16 hours). Cost calculation: 15 functions × $0 = $0. 5 functions: 8 hours × 50 concurrency + 16 hours × 5 concurrency = 480 concurrency-hours/day vs. 24 hours × 50 = 1,200 concurrency-hours/day (60% reduction per function). New total: ~$400/month vs $4,000/month (90% reduction).

C. Use Lambda SnapStart instead of provisioned concurrency for Java functions.

D. Reduce provisioned concurrency to 10 for all functions.

**Correct Answer: B**

**Explanation:** Eliminating unnecessary provisioned concurrency and right-sizing the remainder (B) provides 90% cost reduction. Most functions don't benefit from provisioned concurrency (their cold start latency is acceptable). For the 5 that need it, scheduled scaling matches concurrency to demand patterns — full capacity during business hours, minimal overnight. Option A eliminates cold start protection for functions that need it. Option C is only applicable to Java runtimes. Option D still wastes money on 15 functions that don't need provisioned concurrency.

---

### Question 75

A company operates a serverless architecture with total monthly costs of: Lambda ($25,000), API Gateway ($5,000), DynamoDB ($15,000), Step Functions ($3,000), SQS/SNS ($2,000), EventBridge ($1,000), CloudWatch ($8,000). Total: $59,000/month.

Which comprehensive optimization strategy provides the greatest total savings?

A. Focus on Lambda optimization since it's the largest cost.

B. Prioritize optimizations by ROI across all services: (1) Lambda ($25K): Right-size memory with Power Tuning (30% savings = $7,500). Use Graviton (20% additional = $3,500). Batch processing where applicable. (2) DynamoDB ($15K): Switch consistent workloads from on-demand to provisioned with auto-scaling (40% = $6,000). (3) CloudWatch ($8K): Reduce log verbosity, set retention policies, stream to S3 (70% = $5,600). (4) API Gateway ($5K): Migrate simple proxies to HTTP API (50% savings on eligible APIs = $1,250). (5) Step Functions ($3K): Migrate eligible workflows to Express (60% savings on eligible = $900). (6) SQS/SNS and EventBridge: Optimize message filtering and reduce unnecessary fan-out ($500). Total projected savings: ~$25,250/month (43% overall reduction to ~$33,750/month).

C. Negotiate an Enterprise Discount Program with AWS.

D. Migrate to containers on ECS Fargate to reduce serverless service costs.

**Correct Answer: B**

**Explanation:** A service-by-service optimization prioritized by absolute savings (B) provides the greatest total reduction. Lambda and DynamoDB (the two largest cost items at 68% of total) get the most attention. CloudWatch (often overlooked) provides surprisingly large savings through log optimization. Each service gets its specific optimization technique. The cumulative effect of addressing all services provides 43% total savings. Option A only addresses 42% of the bill. Option C provides a smaller discount than architectural optimization. Option D requires significant re-architecture and may not reduce costs.

---

## Answer Key

| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|-----|---|-----|---|-----|---|-----|---|-----|
| 1 | A | 16 | A | 31 | B | 46 | B | 61 | B |
| 2 | A,B | 17 | A | 32 | B | 47 | A | 62 | B |
| 3 | A | 18 | A | 33 | B | 48 | B | 63 | B |
| 4 | A | 19 | A | 34 | B | 49 | A | 64 | A |
| 5 | A | 20 | A | 35 | B | 50 | A,B | 65 | B |
| 6 | A | 21 | A | 36 | A | 51 | A | 66 | B |
| 7 | A | 22 | B | 37 | B | 52 | A | 67 | A |
| 8 | A | 23 | B | 38 | B | 53 | B | 68 | B |
| 9 | A | 24 | B | 39 | A | 54 | B | 69 | B |
| 10 | A | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | B | 41 | B | 56 | B | 71 | B |
| 12 | A | 27 | B | 42 | B | 57 | B | 72 | B |
| 13 | A | 28 | B | 43 | B | 58 | B | 73 | B |
| 14 | A | 29 | B | 44 | B | 59 | B | 74 | B |
| 15 | A | 30 | A | 45 | B | 60 | B | 75 | B |
