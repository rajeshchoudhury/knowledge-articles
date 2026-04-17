# Domain 2: Configuration Management and IaC — Practice Questions

> **Instructions**: Each question is scenario-based and reflects the depth and style of the DOP-C02 exam. Select the BEST answer. Detailed explanations follow each question.

---

## Question 1

A company uses AWS CloudFormation to manage its infrastructure. A DevOps engineer is creating a template that deploys an Amazon RDS MySQL instance as part of a larger application stack. The company policy requires that if the stack is accidentally deleted, the database data must be preserved. Additionally, if the RDS instance must be replaced during a stack update (for example, due to a change in the DB instance class that requires replacement), a snapshot must be taken of the existing database before replacement occurs.

Which combination of resource attributes satisfies BOTH requirements?

A. Set `DeletionPolicy: Snapshot` on the RDS resource.
B. Set `DeletionPolicy: Retain` and `UpdateReplacePolicy: Snapshot` on the RDS resource.
C. Set `DeletionPolicy: Snapshot` and `UpdateReplacePolicy: Snapshot` on the RDS resource.
D. Set `DeletionPolicy: Snapshot` and `UpdateReplacePolicy: Retain` on the RDS resource.

<details>
<summary>Answer</summary>

**C.** `DeletionPolicy: Snapshot` ensures that when the stack is deleted, a final snapshot is taken. `UpdateReplacePolicy: Snapshot` ensures that when the resource is replaced during an update, a snapshot is also taken. These are two independent policies that operate on different lifecycle events. Option A only covers stack deletion. Option B retains the resource on deletion but doesn't take a snapshot. Option D would retain the old resource on replacement rather than snapshotting it.
</details>

---

## Question 2

A DevOps engineer manages a CloudFormation stack that provisions a VPC, subnets, and an Auto Scaling group across three Availability Zones. The engineer needs to output the VPC ID so that other independent stacks managed by different teams can reference it. The consuming stacks are in the same account and region.

What is the MOST operationally efficient approach?

A. Use nested stacks and pass the VPC ID as an output from the child stack to the parent stack.
B. Create a cross-stack reference by adding an `Export` to the VPC stack's Outputs section and use `Fn::ImportValue` in consuming stacks.
C. Store the VPC ID in SSM Parameter Store and use dynamic references in consuming stacks.
D. Use a CloudFormation custom resource in each consuming stack to look up the VPC ID via the AWS SDK.

<details>
<summary>Answer</summary>

**B.** Cross-stack references via `Export`/`Fn::ImportValue` are the native CloudFormation mechanism for sharing values between independent stacks in the same account and region. This is exactly the use case described. Option A would require coupling the stacks into a parent-child hierarchy, which contradicts the requirement for independent teams. Option C works but adds an external dependency and is less operationally efficient since Parameter Store values must be managed separately. Option D is overly complex for this scenario.
</details>

---

## Question 3

An organization wants to enforce that all newly created AWS accounts in their AWS Organization automatically have AWS Config enabled with a standard set of Config rules. The solution must work without manual intervention when new accounts are added to the Organization.

Which approach meets these requirements?

A. Create a CloudFormation StackSet with self-managed permissions targeting all accounts in the organization. Manually add new accounts to the StackSet when they are created.
B. Create a CloudFormation StackSet with service-managed permissions, target the organizational root or relevant OUs, and enable auto-deployment.
C. Use AWS Service Catalog to share a Config product portfolio with all accounts and require new account administrators to provision the product.
D. Create an EventBridge rule to detect `CreateAccount` API calls and trigger a Lambda function that deploys a CloudFormation stack to the new account.

<details>
<summary>Answer</summary>

**B.** StackSets with service-managed permissions and auto-deployment is the purpose-built solution for this scenario. When auto-deployment is enabled, any new account added to a targeted OU automatically receives the stack instance. Option A requires manual intervention. Option C requires action from the new account administrator. Option D is feasible but unnecessarily complex compared to the native StackSets auto-deployment feature.
</details>

---

## Question 4

A DevOps engineer is deploying an EC2 instance using CloudFormation. The instance must have Apache HTTP Server installed and running before CloudFormation marks the resource as `CREATE_COMPLETE`. The engineer wants to use the CloudFormation helper scripts.

Which combination of configurations achieves this? (Choose TWO)

A. Add `AWS::CloudFormation::Init` metadata to the EC2 instance resource with package installation and service configuration.
B. Add a `CreationPolicy` with `ResourceSignal` to the EC2 instance, specifying a count of 1 and a timeout.
C. Add a `WaitConditionHandle` resource and a `WaitCondition` resource with a dependency on the EC2 instance.
D. In the instance's `UserData`, call `cfn-init` to apply the configuration, followed by `cfn-signal` to report success or failure.
E. In the instance's `UserData`, call `cfn-hup` to detect metadata changes and automatically reconfigure the instance.

<details>
<summary>Answer</summary>

**A and B** (plus **D** for the signaling mechanism). The complete pattern requires: (1) `AWS::CloudFormation::Init` metadata defining the desired state (A), (2) a `CreationPolicy` telling CloudFormation to wait for signals (B), and (3) `UserData` that runs `cfn-init` and `cfn-signal` (D). Since the question asks for TWO, A and B are the CloudFormation template configurations, while D is the UserData script that ties them together. C is the older pattern using WaitCondition. E is for ongoing updates, not initial creation.

Note: If forced to choose exactly two, A and B are the resource-level configurations. D is implicitly required in UserData.
</details>

---

## Question 5

A company has a CloudFormation template that provisions an S3 bucket. The template does not set a `DeletionPolicy`. A developer accidentally deletes the stack. What happens to the S3 bucket?

A. The bucket is retained because S3 buckets have a default `DeletionPolicy` of `Retain`.
B. CloudFormation attempts to delete the bucket. If the bucket is empty, it is deleted. If it contains objects, the deletion fails and the stack enters `DELETE_FAILED` state.
C. CloudFormation takes a snapshot of the bucket contents to S3 Glacier, then deletes the bucket.
D. CloudFormation deletes the bucket and all its contents automatically.

<details>
<summary>Answer</summary>

**B.** The default `DeletionPolicy` for all resources (except `AWS::RDS::DBCluster` which defaults to `Snapshot`) is `Delete`. CloudFormation will attempt to delete the S3 bucket. However, S3 does not allow deletion of non-empty buckets via the API. If the bucket contains objects, the delete operation fails, the stack enters `DELETE_FAILED`, and the bucket remains. This is a common exam scenario testing knowledge of deletion behavior and the need for custom resources to empty buckets before deletion.
</details>

---

## Question 6

A DevOps team uses AWS CodePipeline to deploy CloudFormation templates to production. The team wants to implement a safe deployment process where changes are reviewed before being applied. A change set should be created first, reviewed by the team lead, and then executed.

Which sequence of CodePipeline actions implements this workflow?

A. CloudFormation action with mode `CREATE_UPDATE` → Manual Approval → CloudFormation action with mode `CHANGE_SET_EXECUTE`
B. CloudFormation action with mode `CHANGE_SET_REPLACE` → Manual Approval → CloudFormation action with mode `CHANGE_SET_EXECUTE`
C. CloudFormation action with mode `CHANGE_SET_EXECUTE` → Manual Approval → CloudFormation action with mode `CREATE_UPDATE`
D. CloudFormation action with mode `CREATE_UPDATE` → Manual Approval → CloudFormation action with mode `CHANGE_SET_REPLACE`

<details>
<summary>Answer</summary>

**B.** The safe deployment pattern is: `CHANGE_SET_REPLACE` (creates the change set without executing it) → Manual Approval (team lead reviews the change set) → `CHANGE_SET_EXECUTE` (applies the approved changes). Option A performs a direct update first, which defeats the purpose. Options C and D have the steps in the wrong order.
</details>

---

## Question 7

A DevOps engineer needs to reference a database password stored in AWS Secrets Manager within a CloudFormation template. The password should not appear in the CloudFormation console, CLI output, or template body.

Which approach meets this requirement?

A. Use a `NoEcho` parameter and have users manually input the password during stack creation.
B. Use a CloudFormation dynamic reference: `{{resolve:secretsmanager:MySecret:SecretString:password}}`
C. Use `Fn::ImportValue` to import the password from another stack that provisions the secret.
D. Store the password in SSM Parameter Store as a `String` type and use `{{resolve:ssm:/app/db-password}}`

<details>
<summary>Answer</summary>

**B.** Dynamic references with the `secretsmanager` pattern resolve the value at stack operation time without exposing it in the template, console, or API responses. Option A requires manual input and the password would still need to be known by the operator. Option C would expose the password in the exporting stack's outputs. Option D stores the password unencrypted (String type, not SecureString).
</details>

---

## Question 8

An organization requires that all CloudFormation templates pass compliance checks before deployment. Specifically, all S3 buckets must have server-side encryption enabled, and all EC2 instances must use approved AMI IDs. The compliance checks must run automatically in the CI/CD pipeline before any deployment occurs.

Which tool is BEST suited for this requirement?

A. AWS Config rules evaluated after deployment
B. CloudFormation stack policies
C. CloudFormation Guard (cfn-guard)
D. AWS CloudFormation drift detection

<details>
<summary>Answer</summary>

**C.** CloudFormation Guard (cfn-guard) is a policy-as-code tool specifically designed to validate CloudFormation templates against custom rules before deployment. It runs as a CLI tool in the CI/CD pipeline. Option A evaluates after deployment, which is too late. Option B only controls which resources can be updated, not compliance of configurations. Option D detects configuration changes after they occur.
</details>

---

## Question 9

A company uses AWS CDK (TypeScript) to define infrastructure. The team needs to ensure that all S3 buckets across the entire CDK application have versioning enabled, regardless of which developer created them. The check should fail the synthesis step if a non-versioned bucket is found.

What CDK feature should the team use?

A. Create a custom L3 construct that wraps the S3 Bucket construct with versioning enabled.
B. Use CDK Aspects to visit all S3 Bucket constructs and validate or enforce versioning.
C. Write a cfn-guard rule and run it after `cdk synth`.
D. Add unit tests using the CDK assertions library to check each stack individually.

<details>
<summary>Answer</summary>

**B.** CDK Aspects implement the Visitor pattern and can traverse the entire construct tree. An Aspect can visit every S3 Bucket node and either enforce versioning (modify the property) or report an error (add a validation message that fails synthesis). Option A only works if all developers use the custom construct. Option C works but is outside the CDK framework. Option D requires explicit tests per stack rather than an automatic cross-cutting check.
</details>

---

## Question 10

A DevOps engineer has a CDK application that must deploy to three environments: dev, staging, and production. Each environment is in a different AWS account. The pipeline should update itself automatically when the pipeline definition changes.

Which CDK feature provides this capability?

A. CDK Pipelines with self-mutation enabled
B. A custom CodePipeline construct with CodeBuild stages
C. CDK context variables with environment-specific settings
D. CDK bootstrap with cross-account trust

<details>
<summary>Answer</summary>

**A.** CDK Pipelines is a high-level construct library purpose-built for continuous delivery of CDK apps. Its self-mutation feature means the pipeline detects changes to its own definition and updates itself before deploying application changes. Option B is feasible but requires manual implementation. Option C is for configuration, not pipeline management. Option D is a prerequisite for cross-account deployment but isn't the pipeline mechanism itself.
</details>

---

## Question 11

A company stores application configuration parameters in AWS Systems Manager Parameter Store. The security team requires that database connection strings be encrypted at rest using a customer-managed KMS key and that the parameters be automatically deleted after 90 days if not renewed.

Which combination of Parameter Store features satisfies these requirements?

A. Standard tier parameters with `SecureString` type using the default `aws/ssm` KMS key.
B. Advanced tier parameters with `SecureString` type using a customer-managed KMS key, with an expiration policy set to 90 days.
C. Standard tier parameters with `SecureString` type using a customer-managed KMS key. Use a Lambda function on a schedule to delete expired parameters.
D. Advanced tier parameters with `String` type and a notification policy. Encrypt the values at the application level.

<details>
<summary>Answer</summary>

**B.** Advanced tier parameters support parameter policies including expiration (automatic deletion after a specified date/duration). SecureString with a customer-managed CMK provides encryption at rest as required. Option A uses the default key (not customer-managed) and standard tier (no expiration policies). Option C requires a custom Lambda — the exam prefers native features. Option D doesn't use SSM encryption.
</details>

---

## Question 12

A DevOps team needs to apply security patches to 500 Amazon EC2 instances across multiple accounts. The patching must occur during a 4-hour maintenance window on Sunday nights. Critical patches should be auto-approved after 3 days, while non-critical patches should be auto-approved after 14 days. The team needs compliance reports showing which instances are patched.

Which combination of AWS services and features should be used? (Choose THREE)

A. SSM Patch Manager with a custom patch baseline defining auto-approval rules
B. SSM Maintenance Windows with a patching task
C. SSM Run Command with a custom script to install patches
D. AWS Config rules to check patch compliance
E. SSM Patch Manager compliance reporting with Resource Data Sync to S3
F. CloudWatch Events to trigger patching on a schedule

<details>
<summary>Answer</summary>

**A, B, E.** Patch Manager with a custom patch baseline (A) defines the auto-approval rules for critical vs non-critical patches. Maintenance Windows (B) provides the scheduled 4-hour Sunday night window for executing the patching task. Patch Manager compliance reporting with Resource Data Sync (E) provides the compliance visibility. Option C is lower-level and doesn't provide compliance tracking. Option D checks compliance but doesn't perform patching. Option F is unnecessary when using Maintenance Windows.
</details>

---

## Question 13

An application running on EC2 instances requires configuration files to be updated whenever a CloudFormation metadata change is pushed. The instances should detect the change and re-apply the configuration without being replaced.

Which CloudFormation helper script enables this behavior?

A. `cfn-init`
B. `cfn-signal`
C. `cfn-hup`
D. `cfn-get-metadata`

<details>
<summary>Answer</summary>

**C.** `cfn-hup` is a daemon that runs on the instance and detects changes to the resource metadata. When a change is detected, it re-runs specified hooks (typically calling `cfn-init` to re-apply the configuration). This enables in-place updates without instance replacement. `cfn-init` applies configuration but doesn't detect changes by itself. `cfn-signal` sends signals to CloudFormation. `cfn-get-metadata` retrieves metadata but doesn't watch for changes.
</details>

---

## Question 14

A DevOps engineer is designing a CloudFormation template for a multi-region deployment. The template must use different AMI IDs depending on the region where the stack is deployed. The engineer does not want to use parameters for this — the AMI selection should be automatic.

Which template feature should be used?

A. `Conditions` section with region-based conditions and `Fn::If` in the resource properties.
B. `Mappings` section with region-to-AMI mappings and `Fn::FindInMap` with `AWS::Region`.
C. A custom resource that queries the EC2 API for the latest AMI in the current region.
D. Dynamic references to SSM Parameter Store public parameters for AMI IDs.

<details>
<summary>Answer</summary>

**B.** The `Mappings` section is specifically designed for static lookup tables. Combined with `Fn::FindInMap` and the `AWS::Region` pseudo parameter, it provides automatic region-based AMI selection without parameters. Option A would work but is verbose and cumbersome for many regions. Option C is viable for dynamic latest-AMI lookups but is overly complex for static known AMIs. Option D is a valid approach for getting the latest AMI (AWS publishes AMI IDs to public SSM parameters), but the question specifies static AMI mapping.
</details>

---

## Question 15

A company has 200 existing EC2 instances that were created manually through the AWS Console. The company now wants to manage these instances through CloudFormation without disrupting the running instances.

What is the correct approach?

A. Create a CloudFormation template declaring all 200 instances and run `create-stack`. CloudFormation will adopt existing instances.
B. Create a CloudFormation template for the instances with `DeletionPolicy: Retain`, then use resource import to bring them under CloudFormation management.
C. Use AWS Config to generate a CloudFormation template from the existing instances and deploy it.
D. Manually terminate the instances and recreate them using a CloudFormation template.

<details>
<summary>Answer</summary>

**B.** Resource import is the CloudFormation feature for bringing existing resources under management. The process requires: (1) add the resource to the template with `DeletionPolicy: Retain`, (2) create a change set of type `IMPORT` with the resource identifiers, (3) execute the change set. This does not disrupt running instances. Option A would try to create new instances. Option C is not a real AWS Config feature. Option D disrupts running instances.
</details>

---

## Question 16

A DevOps engineer is building a Lambda-backed CloudFormation custom resource that empties an S3 bucket before the bucket resource is deleted. During testing, the engineer notices that when the stack deletion fails partway through, the Lambda function is invoked again with a `Delete` request, but the bucket is already empty. The function crashes on this second invocation, causing the stack to hang for over an hour.

What is the root cause of the stack hanging, and how should it be fixed?

A. The Lambda function timeout is too short. Increase the function timeout to 15 minutes.
B. The Lambda function is crashing before sending a response to the CloudFormation pre-signed S3 URL. Wrap the function logic in a try/catch block and always send a response (SUCCESS or FAILED).
C. The custom resource should use SNS-backed instead of Lambda-backed configuration to ensure reliable delivery.
D. Add a `DependsOn` attribute to ensure the custom resource is deleted before the S3 bucket.

<details>
<summary>Answer</summary>

**B.** When a custom resource's Lambda function crashes without sending a response to the pre-signed S3 URL, CloudFormation waits for the response until the custom resource timeout (default 1 hour). The fix is to always wrap the logic in a try/catch block and ensure `cfn-response.send()` is called in all code paths (including error paths). Option A doesn't address the core issue of no response being sent. Option C doesn't solve the response problem. Option D doesn't address the function crash.
</details>

---

## Question 17

An enterprise uses AWS Service Catalog to provide self-service provisioning. The security team wants to ensure that end users can launch products without having direct IAM permissions to create the underlying resources (EC2 instances, RDS databases, security groups, etc.).

Which Service Catalog feature enables this?

A. Template Constraint
B. Launch Constraint
C. Tag Update Constraint
D. Notification Constraint

<details>
<summary>Answer</summary>

**B.** A Launch Constraint specifies an IAM role that Service Catalog assumes when provisioning the product. This role has the permissions to create the underlying resources. End users only need permissions to use Service Catalog — they don't need direct permissions to create EC2, RDS, etc. Template Constraints restrict parameter values. Tag Update Constraints control tag editing. Notification Constraints configure SNS notifications.
</details>

---

## Question 18

A DevOps engineer manages a CloudFormation stack with a stack policy that denies all update actions on the production RDS instance. An emergency patch requires updating the RDS engine version immediately.

How can the engineer update the RDS instance without permanently removing the stack policy protection?

A. Delete the stack policy, perform the update, then recreate the stack policy.
B. Supply a temporary stack policy override during the update that allows the RDS update.
C. Modify the stack policy to allow the update, perform the update, then modify the stack policy back.
D. Use a CloudFormation change set to bypass the stack policy.

<details>
<summary>Answer</summary>

**B.** CloudFormation supports temporary stack policy overrides during stack updates. You supply the override policy with the `--stack-policy-during-update-body` or `--stack-policy-during-update-url` parameter. The override policy is in effect only for the duration of that update; the original stack policy remains unchanged. Option A is incorrect because stack policies cannot be deleted once set. Option C works but is less efficient and creates a window of reduced protection. Option D is incorrect — change sets do not bypass stack policies.
</details>

---

## Question 19

A company's CloudFormation template creates an EC2 Auto Scaling group. During stack updates, the team wants CloudFormation to perform rolling updates: replacing instances in batches of 2, pausing for 5 minutes between batches for health checks, and requiring at least 1 instance to remain in service at all times.

Which resource attribute and settings accomplish this?

A. `UpdatePolicy` with `AutoScalingReplacingUpdate` set to `true`.
B. `UpdatePolicy` with `AutoScalingRollingUpdate` specifying `MaxBatchSize: 2`, `PauseTime: PT5M`, `MinInstancesInService: 1`, and `WaitOnResourceSignals: true`.
C. `CreationPolicy` with `ResourceSignal` count equal to the number of instances.
D. `DependsOn` the launch template resource to ensure sequential updates.

<details>
<summary>Answer</summary>

**B.** `AutoScalingRollingUpdate` within the `UpdatePolicy` controls rolling update behavior. `MaxBatchSize` sets the batch size, `PauseTime` sets the wait between batches (ISO 8601 format), `MinInstancesInService` ensures availability, and `WaitOnResourceSignals` with `PauseTime` waits for cfn-signal from new instances. Option A replaces the entire ASG at once. Option C is for creation, not updates. Option D doesn't control rolling updates.
</details>

---

## Question 20

A DevOps engineer needs to deploy the same CloudFormation template across 10 AWS accounts in 3 regions. The deployment should process a maximum of 5 accounts simultaneously, and the operation should stop if deployments fail in more than 2 accounts.

Which StackSet operation preferences should be configured?

A. `MaxConcurrentCount: 5`, `FailureToleranceCount: 2`, `RegionConcurrencyType: PARALLEL`
B. `MaxConcurrentCount: 5`, `FailureToleranceCount: 2`, `RegionConcurrencyType: SEQUENTIAL`
C. `MaxConcurrentPercentage: 50`, `FailureTolerancePercentage: 20`, `RegionConcurrencyType: PARALLEL`
D. `MaxConcurrentCount: 3`, `FailureToleranceCount: 10`, `RegionConcurrencyType: SEQUENTIAL`

<details>
<summary>Answer</summary>

**A.** `MaxConcurrentCount: 5` limits simultaneous deployments to 5 accounts. `FailureToleranceCount: 2` stops the operation if more than 2 accounts fail. `RegionConcurrencyType: PARALLEL` processes all 3 regions simultaneously for efficiency. Option B uses SEQUENTIAL region processing, which is slower. Option C uses percentages, and 50% of 10 is 5, but 20% of 10 is only 2 — this technically also works, but A is the most direct match. Option D has incorrect values.
</details>

---

## Question 21

A DevOps team uses CloudFormation to deploy a VPC stack that exports the VPC ID and subnet IDs. An application stack imports these values. The networking team wants to update the VPC stack to modify a subnet's CIDR block, but the update fails with an error saying the exported value cannot be updated or deleted because it is being imported.

What must the team do to modify the exported value?

A. Use a CloudFormation change set to force the update through.
B. First remove the `Fn::ImportValue` references from all importing stacks, then update the VPC stack, then re-add the import references.
C. Enable termination protection on the VPC stack and then force the update.
D. Delete the VPC stack and recreate it with the new CIDR values.

<details>
<summary>Answer</summary>

**B.** CloudFormation prevents modification or deletion of exports that are actively imported by other stacks. To change the exported value, you must first remove the import dependencies from all consuming stacks, then update the VPC stack (which modifies the export), and then update the consuming stacks to re-import the new value. This is a key operational constraint of cross-stack references. Option A won't bypass this restriction. Option C is unrelated. Option D is extreme and unnecessary.
</details>

---

## Question 22

A company is migrating from a Chef-managed infrastructure to AWS-native tools. They currently use OpsWorks Stacks with lifecycle events for instance setup, configuration, and deployment. The team needs to maintain the following capabilities: (1) Bootstrapping new instances with required software, (2) Automatic configuration updates when infrastructure changes, (3) Application deployment orchestration.

Which combination of AWS services replaces OpsWorks Stacks for these use cases?

A. CloudFormation `cfn-init` for bootstrapping, `cfn-hup` for configuration updates, and CodeDeploy for application deployment.
B. EC2 User Data for bootstrapping, AWS Config for configuration updates, and CodePipeline for application deployment.
C. SSM State Manager for bootstrapping and configuration, and SSM Automation for deployment orchestration.
D. Elastic Beanstalk for all three capabilities.

<details>
<summary>Answer</summary>

**A.** This combination maps directly to the OpsWorks lifecycle events: `cfn-init` handles the Setup lifecycle (bootstrapping), `cfn-hup` handles the Configure lifecycle (reacting to infrastructure changes), and CodeDeploy handles the Deploy lifecycle (application deployments). Option B's Config doesn't handle configuration management in this sense. Option C is viable but less precise than A for the specific use cases listed. Option D works for web applications but is opinionated and doesn't provide the same level of control.
</details>

---

## Question 23

A DevOps engineer is using Terraform to manage AWS infrastructure. Multiple team members need to run `terraform apply` concurrently. The engineer wants to prevent state file corruption from simultaneous writes.

Which Terraform backend configuration should be used?

A. Local backend with file-level locking on a shared NFS mount.
B. S3 backend for state storage with a DynamoDB table for state locking.
C. S3 backend for state storage with S3 Object Lock for concurrency control.
D. Consul backend for both state storage and locking.

<details>
<summary>Answer</summary>

**B.** The S3 backend with DynamoDB locking is the standard AWS-native Terraform backend configuration. The S3 bucket stores the state file (with versioning for history). The DynamoDB table (with a `LockID` partition key) provides state locking to prevent concurrent modifications. Option A is fragile and not cloud-native. Option C doesn't provide the mutual exclusion needed. Option D is valid but not AWS-native and adds unnecessary complexity.
</details>

---

## Question 24

A DevOps engineer needs to create a CloudFormation template that conditionally creates an Elastic IP and associates it with an EC2 instance only if the environment is `Production`. In non-production environments, the Elastic IP should not be created at all, and the EC2 instance should not have the `ElasticIp` property set.

Which combination of CloudFormation features achieves this?

A. Use the `Conditions` section with `Fn::Equals` to check the environment parameter. Apply the condition to the Elastic IP resource. Use `Fn::If` with `AWS::NoValue` for the EC2 property.
B. Use `Mappings` to map environment names to Elastic IP settings. Use `Fn::FindInMap` in the EC2 resource properties.
C. Use a custom resource to conditionally create the Elastic IP.
D. Create two separate templates, one for production and one for non-production.

<details>
<summary>Answer</summary>

**A.** The correct approach uses: (1) A `Condition` that evaluates `Fn::Equals` on the environment parameter, (2) the `Condition` attribute on the EIP resource to conditionally create it, and (3) `Fn::If` with `AWS::NoValue` on the EC2 instance's `ElasticIp` property to conditionally remove the property entirely. `AWS::NoValue` is specifically designed for this — when returned by `Fn::If`, the corresponding property is removed as if it were never specified. Option B can't conditionally create/skip resources. Option C is unnecessarily complex. Option D violates the DRY principle.
</details>

---

## Question 25

An organization uses SSM Session Manager to provide shell access to EC2 instances. The security team requires that all session activity be logged to both CloudWatch Logs and S3. They also need to ensure that sessions are encrypted with a customer-managed KMS key and automatically terminate after 20 minutes of inactivity.

Where should these Session Manager preferences be configured?

A. On each EC2 instance's SSM Agent configuration file.
B. In the SSM Session Manager preferences (document `SSM-SessionManagerRunShell`) at the account level.
C. In the IAM policy attached to users who start sessions.
D. In the EC2 instance's security group settings.

<details>
<summary>Answer</summary>

**B.** Session Manager preferences are configured in the `SSM-SessionManagerRunShell` document (Session document). This is an account-level configuration that defines S3 bucket for logging, CloudWatch Logs group, KMS key for encryption, idle timeout, and Run As settings. These settings apply to all sessions in the account. Option A would require per-instance configuration and doesn't support all preferences. Option C controls who can start sessions, not session behavior. Option D is unrelated.
</details>

---

## Question 26

A DevOps engineer is deploying a CloudFormation stack that creates an EC2 instance. The instance's `UserData` script takes 20 minutes to complete. The engineer has configured a `CreationPolicy` with a `Timeout` of `PT15M`. The `UserData` successfully installs all software and calls `cfn-signal` with exit code 0, but this happens at the 18-minute mark.

What is the result?

A. The stack creation succeeds because `cfn-signal` was sent with exit code 0.
B. The stack creation fails because the `CreationPolicy` timeout of 15 minutes was exceeded, causing a rollback.
C. The stack creation succeeds but with a warning about the timeout being exceeded.
D. The `CreationPolicy` timeout is automatically extended because the signal was successful.

<details>
<summary>Answer</summary>

**B.** The `CreationPolicy` timeout is strict. If CloudFormation does not receive the required signals within the specified timeout period, the resource creation is marked as `CREATE_FAILED` regardless of whether the signal eventually arrives. The 18-minute signal arrives 3 minutes after the 15-minute timeout, so CloudFormation has already failed the resource. The stack rolls back. The fix is to increase the timeout to at least `PT20M` with buffer.
</details>

---

## Question 27

A company has a CloudFormation template that defines an AWS Lambda function using the `AWS::Serverless::Function` resource type. When the DevOps engineer tries to deploy the template, the deployment fails with an error about an unsupported resource type.

What is the most likely cause and fix?

A. The Lambda function definition has invalid properties. Fix the function configuration.
B. The template is missing the `Transform: AWS::Serverless-2016-10-31` declaration. Add the SAM transform to the template.
C. The AWS account doesn't have Lambda service access. Request a service limit increase.
D. The template should use `AWS::Lambda::Function` instead of `AWS::Serverless::Function`.

<details>
<summary>Answer</summary>

**B.** `AWS::Serverless::Function` is a SAM resource type that requires the `AWS::Serverless-2016-10-31` transform to be specified in the template's `Transform` section. Without this transform, CloudFormation doesn't recognize SAM resource types. While Option D is technically a workaround (using the standard CloudFormation resource type), the question asks for the most likely cause and fix, which is the missing transform.
</details>

---

## Question 28

A DevOps team manages infrastructure for a multi-tier application. The VPC and networking components are managed by the network team's CloudFormation stack. The application team's stack needs the VPC ID, and both stacks share a lifecycle — they are always deployed together and updated together.

Should the team use nested stacks or cross-stack references?

A. Cross-stack references, because they allow independent teams to manage their stacks.
B. Nested stacks, because the stacks share a lifecycle and are always deployed together.
C. Neither — combine everything into a single template.
D. Cross-stack references with a Service Catalog product for the VPC stack.

<details>
<summary>Answer</summary>

**B.** Since the stacks share a lifecycle (deployed together, updated together), nested stacks are the appropriate choice. The parent stack manages both the networking (child stack) and application (child stack), ensuring coordinated deployments. Cross-stack references are better for independently managed stacks with different lifecycles. Option C may work for small templates but doesn't scale (500 resource limit). Option D adds unnecessary complexity.
</details>

---

## Question 29

An organization needs to securely provide EC2 instances with frequently rotated database credentials. The credentials should be rotated every 30 days, and the instances should always retrieve the current credentials at runtime.

Which AWS service and approach should be used?

A. SSM Parameter Store with a SecureString parameter and a Lambda function to rotate the value every 30 days.
B. AWS Secrets Manager with automatic rotation enabled using a Lambda rotation function, with applications retrieving the secret at runtime via the Secrets Manager API.
C. IAM roles with temporary credentials generated by STS.
D. CloudFormation dynamic references with `{{resolve:secretsmanager:...}}` to inject credentials at deployment time.

<details>
<summary>Answer</summary>

**B.** Secrets Manager is designed for this use case. It natively supports automatic rotation with Lambda rotation functions, including pre-built rotation templates for RDS, Redshift, and DocumentDB. Applications retrieve the current secret value at runtime via the Secrets Manager API/SDK. Option A requires building rotation from scratch. Option C doesn't apply to database credentials. Option D only resolves at CloudFormation deployment time, not at runtime — if the secret rotates, the deployed value becomes stale.
</details>

---

## Question 30

A DevOps engineer is building a CloudFormation custom resource backed by Lambda. The custom resource needs to return data (a calculated VPC CIDR block) that other resources in the template can reference via `Fn::GetAtt`.

How should the Lambda function return this data?

A. Write the data to SSM Parameter Store and use a dynamic reference in other resources.
B. Include the data in the `Data` field of the response sent to the CloudFormation pre-signed S3 URL. Reference the data using `Fn::GetAtt` on the custom resource with the key name.
C. Write the data to the Lambda function's CloudWatch Logs and use a `Fn::ImportValue` to retrieve it.
D. Return the data in the Lambda function's return value. CloudFormation automatically captures it.

<details>
<summary>Answer</summary>

**B.** Custom resources return data by including key-value pairs in the `Data` field of the JSON response sent to the pre-signed S3 URL. Other resources in the template can then access these values using `!GetAtt MyCustomResource.KeyName`. The response must include `Status`, `PhysicalResourceId`, and `Data`. Option A works but adds unnecessary complexity. Option C is not valid. Option D is incorrect — CloudFormation reads the response from the pre-signed S3 URL, not the Lambda return value.
</details>

---

## Question 31

A DevOps engineer is using the CDK to create infrastructure. The engineer needs to use a specific VPC that already exists in the account (VPC ID: `vpc-12345678`). The engineer does not want CDK to manage or modify this VPC.

How should the engineer reference the existing VPC in CDK code?

A. Create a new `Vpc` construct with the same configuration as the existing VPC.
B. Use `Vpc.fromLookup(this, 'ExistingVpc', { vpcId: 'vpc-12345678' })` to import the existing VPC.
C. Use `Vpc.fromVpcAttributes(this, 'ExistingVpc', { vpcId: 'vpc-12345678', availabilityZones: [...] })`.
D. Both B and C are valid approaches.

<details>
<summary>Answer</summary>

**D.** Both approaches work. `Vpc.fromLookup` performs an actual AWS API call during synthesis (using context) to discover VPC attributes like AZs and subnet IDs. `Vpc.fromVpcAttributes` uses hard-coded attributes that you provide directly. `fromLookup` is more convenient but requires credentials at synth time. `fromVpcAttributes` works without API calls. Both return an `IVpc` interface, and neither allows CDK to manage the VPC. Option A would create a new VPC.
</details>

---

## Question 32

A company uses AWS Systems Manager Automation to remediate AWS Config rule violations. When an EC2 instance is found to be non-compliant (missing required tags), an Automation runbook should be executed to add the missing tags. However, the runbook should not execute until a manager approves the remediation action.

Which Automation step type provides this capability?

A. `aws:executeScript` with a Lambda function that sends an email and waits for a reply.
B. `aws:approve` step type with designated approvers.
C. `aws:waitForAwsResourceProperty` step type that polls for an approval flag in a DynamoDB table.
D. `aws:branch` step type that checks if approval was granted.

<details>
<summary>Answer</summary>

**B.** The `aws:approve` step type is built into SSM Automation for exactly this purpose. It pauses the automation and sends an approval request to specified IAM principals (via the console or SNS notification). The automation only proceeds to the next step when an approver approves the request. Option A is overly complex. Options C and D could work but are not the purpose-built solution.
</details>

---

## Question 33

A DevOps team is using CloudFormation to manage an application stack. After a stack update, they discover that an unauthorized team member manually modified a security group rule through the AWS Console, creating a configuration drift. The team wants to detect and alert on such drift.

Which approach provides continuous detection and alerting?

A. Run `aws cloudformation detect-stack-drift` on a schedule using a CloudWatch Events rule and Lambda function.
B. Enable AWS Config with the `cloudformation-stack-drift-detection-check` managed rule, and configure an SNS notification for non-compliant resources.
C. Use CloudTrail to detect API calls that modify resources managed by CloudFormation and trigger an EventBridge rule.
D. All of the above are valid approaches, but B is the most operationally efficient for continuous monitoring.

<details>
<summary>Answer</summary>

**D.** All three approaches can detect drift-related issues. However, Option B (AWS Config rule) is the most operationally efficient because AWS Config continuously evaluates resources and can trigger notifications and auto-remediation. Option A requires custom scheduling. Option C detects API calls but doesn't compare against the expected CloudFormation state. For the exam, Option B is the recommended approach for continuous compliance monitoring.
</details>

---

## Question 34

A company uses OpsWorks Stacks to manage its application infrastructure. The operations team notices that whenever a new instance comes online in the application layer, the configuration for load balancer backends on ALL instances in the stack is updated to include the new instance.

Which OpsWorks lifecycle event is responsible for this behavior?

A. Setup
B. Configure
C. Deploy
D. Shutdown

<details>
<summary>Answer</summary>

**B.** The **Configure** lifecycle event fires on ALL instances in the stack whenever instances come online or go offline, an Elastic IP is associated or disassociated, or an ELB is attached or detached from a layer. This event enables instances to react to infrastructure changes — for example, updating load balancer or service discovery configurations. Setup only runs on the newly booted instance. Deploy runs application deployments. Shutdown runs before termination.
</details>

---

## Question 35

A DevOps engineer needs to create a CloudFormation template that works in both the `aws` (commercial) and `aws-us-gov` (GovCloud) partitions. The template creates an IAM role and needs to construct the correct ARN format for a policy.

Which pseudo parameters should the engineer use to construct the ARN?

A. `AWS::AccountId` and `AWS::Region`
B. `AWS::Partition` and `AWS::AccountId`
C. `AWS::URLSuffix` and `AWS::Region`
D. `AWS::StackId` and `AWS::Partition`

<details>
<summary>Answer</summary>

**B.** IAM ARN format is `arn:{partition}:iam::{account-id}:policy/policy-name`. The `AWS::Partition` pseudo parameter returns `aws`, `aws-cn`, or `aws-us-gov` depending on the environment. `AWS::AccountId` provides the account number. Using these ensures the ARN is correct in any partition. A typical construction would be: `!Sub 'arn:${AWS::Partition}:iam::${AWS::AccountId}:policy/MyPolicy'`. Option A doesn't include the partition. Option C's `URLSuffix` is for endpoint URLs, not ARNs. Option D's `StackId` is the stack's ARN, not relevant here.
</details>

---

## Question 36

A DevOps engineer has a CloudFormation template that creates an Auto Scaling group with a desired capacity of 4 instances. The engineer wants CloudFormation to wait until all 4 instances are healthy before marking the ASG as `CREATE_COMPLETE`.

Which configuration achieves this?

A. Add a `CreationPolicy` to the ASG with `ResourceSignal: Count: 4` and `Timeout: PT30M`. In the launch configuration's UserData, call `cfn-signal` after instance bootstrapping.
B. Add a `WaitCondition` with `Count: 4` and a `WaitConditionHandle`. Reference the handle URL in the launch configuration.
C. Add an `UpdatePolicy` with `AutoScalingRollingUpdate: MinInstancesInService: 4`.
D. Set the ASG `MinSize: 4` and `HealthCheckType: ELB`.

<details>
<summary>Answer</summary>

**A.** `CreationPolicy` with `ResourceSignal` on the ASG is the recommended pattern. The `Count` specifies how many signals to wait for (4, matching the desired capacity). Each instance's UserData runs `cfn-signal` after successful bootstrapping. CloudFormation waits until 4 signals are received or the timeout is reached. Option B uses the older WaitCondition pattern. Option C is for updates, not creation. Option D doesn't signal CloudFormation.
</details>

---

## Question 37

A team is building a CDK pipeline that deploys a Lambda function. The team wants to ensure that the synthesized CloudFormation template always creates the Lambda function with a `Runtime` of `nodejs18.x` and a `Timeout` of at least 30 seconds. This check should be enforced at synthesis time.

How should this be implemented?

A. Write a unit test using the CDK assertions library that checks these properties.
B. Create a CDK Aspect that visits Lambda Function constructs and validates the Runtime and Timeout properties.
C. Use cfn-guard rules run as a post-synthesis step.
D. Both A and B are valid approaches, but B provides automatic enforcement without requiring developers to run tests.

<details>
<summary>Answer</summary>

**D.** Both unit tests (A) and Aspects (B) can validate these properties. However, Aspects are applied automatically during synthesis, while unit tests must be explicitly run. An Aspect would visit every Lambda function construct in the app and add an error annotation if the Runtime or Timeout doesn't meet requirements, causing `cdk synth` to fail. This provides automatic enforcement. Unit tests are complementary and provide explicit documentation of requirements.
</details>

---

## Question 38

A DevOps engineer needs to deploy a CloudFormation stack that includes an RDS instance with a master password. The password is stored in AWS Secrets Manager. The engineer wants to ensure the password never appears in the CloudFormation template, console, events, or API responses.

Which approach is most secure?

A. Pass the password as a `NoEcho` parameter and input it during stack creation.
B. Use a dynamic reference: `{{resolve:secretsmanager:MyDBSecret:SecretString:password}}` in the RDS resource's `MasterUserPassword` property.
C. Use an SSM SecureString dynamic reference: `{{resolve:ssm-secure:/db/password:1}}` in the `MasterUserPassword` property.
D. Both B and C are equally secure and valid.

<details>
<summary>Answer</summary>

**D.** Both `secretsmanager` and `ssm-secure` dynamic references resolve at stack operation time and prevent the actual value from appearing in the template, console, events, or API responses. Both are considered secure approaches. Option A's `NoEcho` only masks the value in the console display; the value is still accessible in the template if hard-coded, and someone must know the password to input it. The choice between B and C depends on where the secret is stored.
</details>

---

## Question 39

A company uses CloudFormation to deploy an application stack that includes an S3 bucket, a Lambda function, an API Gateway, and a DynamoDB table. A rollback trigger is configured with a CloudWatch alarm that monitors the API Gateway's 5XX error rate. After an update, the 5XX error rate spikes 5 minutes after the update completes. The monitoring period is set to 10 minutes.

What happens?

A. Nothing — rollback triggers only monitor during the stack update, not after completion.
B. CloudFormation automatically rolls back the stack to the previous state because the alarm entered ALARM state within the monitoring period.
C. CloudFormation sends an SNS notification but does not automatically roll back.
D. CloudFormation pauses the stack and waits for manual approval to roll back.

<details>
<summary>Answer</summary>

**B.** Rollback triggers continue monitoring for the specified monitoring period **after** the stack operation completes. If any of the specified CloudWatch alarms enter the `ALARM` state during this period, CloudFormation rolls back the entire stack to the previous state. The 5XX spike at 5 minutes is within the 10-minute monitoring window, so automatic rollback occurs. This is a powerful safety net for catching post-deployment issues.
</details>

---

## Question 40

A DevOps engineer is creating a CloudFormation template that deploys resources conditionally. The template has a parameter `EnvType` with allowed values `prod` and `dev`. For production, an Elastic IP should be created and associated with an EC2 instance. For dev, no EIP should be created.

The engineer writes a condition:
```yaml
Conditions:
  IsProd: !Equals [!Ref EnvType, prod]
```

And defines the EIP resource:
```yaml
MyEIP:
  Type: AWS::EC2::EIP
  Condition: IsProd
  Properties:
    InstanceId: !Ref MyInstance
```

The EC2 instance also has a property `NetworkInterfaces` that should only include the EIP association in production. How should the engineer handle this in the instance resource?

A. Use `!If [IsProd, !Ref MyEIP, !Ref 'AWS::NoValue']` for the property that references the EIP.
B. Use `DependsOn: MyEIP` with a condition on the DependsOn.
C. Create two separate EC2 instance resources with conditions.
D. Use `Fn::ImportValue` to get the EIP only if it exists.

<details>
<summary>Answer</summary>

**A.** `Fn::If` with `AWS::NoValue` is the correct pattern for conditionally setting a property. When the condition `IsProd` is true, the EIP reference is used. When false, `AWS::NoValue` effectively removes the property from the resource definition, as if it were never specified. Option B's `DependsOn` cannot be conditional. Option C duplicates the instance definition unnecessarily. Option D is for cross-stack references.
</details>

---

## Question 41

A DevOps team manages over 50 AWS accounts using AWS Organizations. They need to deploy a standard set of IAM roles and security configurations to every account, including any new accounts created in the future. The deployment should happen automatically without manual intervention.

What is the recommended approach?

A. Create an AWS Lambda function triggered by the `CreateAccount` CloudTrail event to deploy CloudFormation stacks to new accounts.
B. Use CloudFormation StackSets with service-managed permissions, targeting the organization root, with auto-deployment enabled.
C. Use AWS Service Catalog with a mandatory product that each new account must provision.
D. Use Terraform Cloud with workspaces for each account.

<details>
<summary>Answer</summary>

**B.** StackSets with service-managed permissions and auto-deployment is the AWS-recommended solution for organization-wide, automatic deployments. When auto-deployment is enabled and the StackSet targets the organization root (or specific OUs), CloudFormation automatically deploys the stack to new accounts as they are added. This requires no custom code or manual steps. Option A works but requires custom development and maintenance. Option C requires manual provisioning. Option D is not AWS-native.
</details>

---

## Question 42

A DevOps engineer is troubleshooting a CloudFormation stack creation failure. The stack uses `cfn-init` to bootstrap an EC2 instance, but the instance fails to signal back within the `CreationPolicy` timeout. The stack rolls back, terminating the instance before the engineer can investigate.

How can the engineer preserve the failed instance for debugging?

A. Set `DeletionPolicy: Retain` on the EC2 instance resource.
B. Disable rollback on the stack creation by using the `--disable-rollback` flag.
C. Increase the `CreationPolicy` timeout to a very large value.
D. Use `UpdateReplacePolicy: Retain` on the EC2 instance resource.

<details>
<summary>Answer</summary>

**B.** The `--disable-rollback` (or `DisableRollback: true`) flag prevents CloudFormation from rolling back on creation failure, leaving all created resources (including the failed instance) intact for investigation. The stack will be in `CREATE_FAILED` state. The engineer can then SSH/Session Manager into the instance to check `/var/log/cfn-init.log` and `/var/log/cloud-init-output.log`. Option A preserves the instance on stack *deletion*, not on rollback. Option C only delays the failure. Option D is for update replacements.
</details>

---

## Question 43

A company's CloudFormation template includes a Lambda function that uses a deployment package stored in S3. The engineer updates the code in S3 but notices that redeploying the CloudFormation stack does not trigger a Lambda code update because the S3 key hasn't changed.

What is the recommended solution?

A. Use a CloudFormation custom resource to force the Lambda function update.
B. Change the S3 key to include a version hash (e.g., `lambda-code-v2.zip`) and update the template's `S3Key` property.
C. Use the `AWS::Lambda::Version` resource to create a new version on each deployment.
D. Delete the Lambda function and recreate it.

<details>
<summary>Answer</summary>

**B.** CloudFormation detects changes by comparing template property values. If the `S3Key` doesn't change, CloudFormation sees no difference and skips the update. By including a version hash or timestamp in the S3 key (e.g., `lambda-code-abc123.zip`), each code update results in a new key value, triggering a CloudFormation update. This is the standard pattern used by build systems. Option A is unnecessarily complex. Option C creates a version but doesn't update the code. Option D is destructive.
</details>

---

## Question 44

A DevOps engineer needs to reference the same parameter value in multiple CloudFormation stacks across different regions. The value should be centrally managed and version-controlled.

Which approach is MOST operationally efficient?

A. Use CloudFormation cross-stack references with `Export` and `Fn::ImportValue`.
B. Pass the value as a parameter to each stack using CI/CD pipeline parameter files.
C. Store the value in SSM Parameter Store in each region and use `{{resolve:ssm:...}}` dynamic references.
D. Hard-code the value in a CloudFormation Mapping and select based on region.

<details>
<summary>Answer</summary>

**C.** SSM Parameter Store with dynamic references allows centralized management of the value, with each region having its own parameter store entry. Dynamic references resolve at stack operation time. This is operationally efficient because: (1) no template changes needed when the value changes, (2) values can be version-controlled and audited in SSM, (3) works across regions and accounts. Option A doesn't work cross-region. Option B works but requires pipeline changes for value updates. Option D requires template updates for value changes.
</details>

---

## Question 45

A large enterprise wants to allow development teams to self-provision approved infrastructure patterns (VPCs, ECS clusters, databases) through a portal interface. The teams should not need AWS Console access or deep AWS knowledge. All provisioned resources must be tagged with cost allocation tags and comply with security baselines.

Which AWS service is purpose-built for this requirement?

A. AWS CloudFormation with a custom web application frontend
B. AWS Service Catalog with portfolios, products, launch constraints, template constraints, and TagOptions
C. AWS CDK with a shared construct library
D. AWS Control Tower with Account Factory

<details>
<summary>Answer</summary>

**B.** AWS Service Catalog is purpose-built for self-service provisioning of approved IT resources. Portfolios organize products by team or use case. Products are CloudFormation templates for approved patterns. Launch constraints allow provisioning without direct AWS permissions. Template constraints restrict parameter choices (e.g., limit instance sizes). TagOptions enforce consistent tagging. The Service Catalog console provides the portal experience. Option A requires custom development. Option C requires developer expertise. Option D is for account provisioning, not infrastructure patterns.
</details>
