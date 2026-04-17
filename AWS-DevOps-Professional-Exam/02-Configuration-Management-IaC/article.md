# Domain 2: Configuration Management and Infrastructure as Code (17% of Exam)

## Overview

Domain 2 of the AWS Certified DevOps Engineer – Professional (DOP-C02) exam focuses on your ability to define, deploy, and manage AWS infrastructure using code-driven, repeatable, and automated processes. This domain carries **17% of the total exam weight**, making it a significant scoring area. Mastery of AWS CloudFormation is non-negotiable; it is the single most heavily tested IaC service on this exam. You must also demonstrate working knowledge of the AWS CDK, AWS Service Catalog, AWS Systems Manager, AWS OpsWorks, and complementary configuration-management tooling.

The exam tests your ability to make **architectural decisions**—choosing the right tool, the right deployment strategy, and the right integration pattern for a given scenario. Expect questions that combine IaC with CI/CD pipelines, multi-account governance, compliance automation, and secret management.

---

## 1. AWS CloudFormation (CRITICAL — Most Tested IaC Service)

AWS CloudFormation is Amazon's native Infrastructure as Code service. It lets you model your entire cloud environment in JSON or YAML templates, which CloudFormation interprets to provision and manage resources in the correct order, handling dependencies automatically.

### 1.1 Template Anatomy

Every CloudFormation template is a declarative document with up to nine top-level sections. Only the `Resources` section is mandatory.

| Section | Required | Purpose |
|---|---|---|
| `AWSTemplateFormatVersion` | No | Identifies the template format version (currently `"2010-09-09"`). Does **not** map to an API version. |
| `Description` | No | A text string that describes the template. Must follow `AWSTemplateFormatVersion` if both are present. |
| `Metadata` | No | Arbitrary JSON/YAML objects that provide additional information. Used by `AWS::CloudFormation::Interface` to customise the console parameter input UI. |
| `Parameters` | No | Values passed at stack creation/update. Supports types (`String`, `Number`, `List<Number>`, `CommaDelimitedList`, AWS-specific types like `AWS::EC2::VPC::Id`). Constraints: `AllowedValues`, `AllowedPattern`, `MinLength/MaxLength`, `MinValue/MaxValue`, `Default`, `NoEcho` (masks sensitive input). Maximum **200 parameters** per template. |
| `Mappings` | No | Static key-value lookup tables. Accessed via `Fn::FindInMap`. Useful for region-specific AMI IDs, environment-specific sizing, etc. |
| `Conditions` | No | Boolean expressions evaluated at stack creation/update time. Control whether resources are created or properties are applied. Reference parameters, other conditions, or pseudo parameters. |
| `Transform` | No | Specifies macros that CloudFormation uses to process the template. `AWS::Include` fetches template snippets from S3. `AWS::Serverless-2016-10-31` enables SAM syntax. |
| `Resources` | **Yes** | The only required section. Declares AWS resources and their properties. Each resource has a logical ID, a `Type`, and `Properties`. Maximum **500 resources** per template (can be extended via nested stacks). |
| `Outputs` | No | Declares values returned after stack creation. Can be imported by other stacks (`Export`). Maximum **200 outputs** per template. Commonly used for cross-stack references. |

> **Key Points for the Exam**
> - Only `Resources` is mandatory.
> - `Parameters` max = 200; `Resources` max = 500; `Outputs` max = 200.
> - `Mappings` are static; they **cannot** reference parameters or pseudo parameters at the mapping definition level—they're resolved through `Fn::FindInMap` which takes runtime references as keys.
> - `Conditions` can be applied to resources, outputs, and individual resource properties (via `Fn::If`).
> - `NoEcho` on parameters prevents the value from being displayed in the console, CLI, or API responses, but the value **is still stored in plaintext in the template** if hard-coded—use Dynamic References instead for secrets.

### 1.2 Intrinsic Functions

Intrinsic functions are built-in functions that you use within CloudFormation templates to assign values to properties that are not available until runtime.

| Function | Short Form | Purpose |
|---|---|---|
| `Fn::Ref` | `!Ref` | Returns the value of a parameter or the physical ID of a resource. |
| `Fn::GetAtt` | `!GetAtt` | Returns an attribute of a resource (e.g., `!GetAtt MyELB.DNSName`). |
| `Fn::Sub` | `!Sub` | Substitutes variables in a string. Supports `${AWS::StackName}` style references and a mapping for custom variables. |
| `Fn::Join` | `!Join` | Joins a list of values with a delimiter. |
| `Fn::Select` | `!Select` | Returns a single object from a list by index (zero-based). |
| `Fn::Split` | `!Split` | Splits a string into a list using a delimiter. |
| `Fn::If` | `!If` | Returns one of two values based on a condition. Used inside resource properties. |
| `Fn::ImportValue` | `!ImportValue` | Imports an exported output from another stack. Creates a cross-stack dependency. |
| `Fn::FindInMap` | `!FindInMap` | Retrieves a value from the `Mappings` section. Takes three keys: MapName, FirstLevelKey, SecondLevelKey. |
| `Fn::GetAZs` | `!GetAZs` | Returns a list of AZs for the specified region. |
| `Fn::Cidr` | `!Cidr` | Returns an array of CIDR address blocks from an IP block. |
| `Fn::Transform` | N/A | Specifies a macro to perform custom processing on part of a template. |
| `Fn::Length` | `!Length` | Returns the number of elements in an array. Added in 2022. |
| `Fn::ToJsonString` | `!ToJsonString` | Converts an object or array to its JSON string representation. Useful for passing structured data to Lambda environment variables. |

> **Key Points for the Exam**
> - `Fn::Sub` is the most flexible string-building function. Prefer it over `Fn::Join` when constructing ARNs or URLs.
> - `Fn::ImportValue` cannot reference values that are being updated or deleted in the exporting stack. The exporting stack **cannot** be deleted while any import exists.
> - You **cannot** use `Fn::Ref` or `Fn::GetAtt` across stacks—use exports/imports or nested stacks.
> - `Fn::If` is the mechanism for conditional property values; `Conditions` by themselves only control resource creation.

### 1.3 Pseudo Parameters

Pseudo parameters are predefined by AWS CloudFormation. You do not declare them; you reference them with `!Ref`.

| Pseudo Parameter | Returns |
|---|---|
| `AWS::AccountId` | The AWS account ID of the account in which the stack is being created. |
| `AWS::Region` | The region where the stack is created (e.g., `us-east-1`). |
| `AWS::StackName` | The name of the stack. |
| `AWS::StackId` | The ID (ARN) of the stack. |
| `AWS::NotificationARNs` | List of SNS topic ARNs configured for the stack. |
| `AWS::NoValue` | Removes the corresponding property when used with `Fn::If`. Equivalent to not specifying the property at all. |
| `AWS::URLSuffix` | The suffix for a domain (e.g., `amazonaws.com` or `amazonaws.com.cn` for China). |
| `AWS::Partition` | The partition (`aws`, `aws-cn`, `aws-us-gov`). Essential for constructing correct ARNs in non-standard partitions. |

> **Key Points for the Exam**
> - `AWS::NoValue` is used with `Fn::If` to conditionally remove a property entirely (not just set it to empty).
> - `AWS::Partition` and `AWS::URLSuffix` are critical for templates that must work across partitions (GovCloud, China).
> - Always use pseudo parameters instead of hard-coding account IDs or regions.

### 1.4 Resource Attributes

Resource attributes control how CloudFormation manages the lifecycle of individual resources.

**DependsOn**: Explicitly declares a dependency between resources. CloudFormation normally determines order automatically from references, but `DependsOn` is needed when there is no intrinsic reference (e.g., a VPC gateway attachment must exist before launching instances, even if the instance resource doesn't reference the attachment directly).

**DeletionPolicy**: Controls what happens when a resource is removed from the template or the stack is deleted.
- `Delete` (default for most resources): Resource is deleted.
- `Retain`: Resource is preserved; CloudFormation removes it from the stack but does **not** delete the actual AWS resource.
- `Snapshot`: Takes a final snapshot before deletion. Supported for EBS volumes, RDS instances, RDS clusters, Redshift clusters, Neptune, and DocumentDB.

**UpdatePolicy**: Governs how CloudFormation handles updates to specific resource types. Most importantly used with:
- `AWS::AutoScaling::AutoScalingGroup`: Controls rolling updates (`AutoScalingRollingUpdate`), replacing updates (`AutoScalingReplacingUpdate`), and scheduled action handling (`AutoScalingScheduledAction`).
- `AWS::ElastiCache::ReplicationGroup` and `AWS::OpenSearchService::Domain`: `UseOnlineResharding` etc.
- `AWS::Lambda::Alias`: `CodeDeployLambdaAliasUpdate` for canary/linear deployments using CodeDeploy.

**UpdateReplacePolicy**: Same options as `DeletionPolicy` but applied when a resource is **replaced** during a stack update (not deleted). Use `Snapshot` or `Retain` to preserve data when a replacement occurs.

**CreationPolicy**: Tells CloudFormation to wait for a success signal before marking the resource as `CREATE_COMPLETE`. Used with `AWS::AutoScaling::AutoScalingGroup`, `AWS::EC2::Instance`, and `AWS::CloudFormation::WaitCondition`. Specifies a `Count` (number of signals to receive) and a `Timeout` (ISO 8601 duration, e.g., `PT15M`).

**Metadata**: Arbitrary key-value data attached to a resource. Most commonly used with `AWS::CloudFormation::Init` (see section 1.9).

> **Key Points for the Exam**
> - If you need to preserve an RDS database during stack deletion, set `DeletionPolicy: Snapshot` (takes a final snapshot) or `DeletionPolicy: Retain`.
> - `UpdateReplacePolicy` is separate from `DeletionPolicy`. A replacement can happen during an update while a deletion happens during stack delete—the policies for each are independent.
> - `CreationPolicy` with `cfn-signal` is the recommended pattern (replaces the older `WaitCondition` + `WaitConditionHandle` pattern for EC2 instances and ASGs).
> - Failing to send the required number of signals within the timeout results in a `CREATE_FAILED` status and triggers rollback.

### 1.5 Stack Operations

**Create**: CloudFormation provisions resources in dependency order. If any resource fails, the default behavior is to **rollback** (delete all created resources). You can disable rollback (`--disable-rollback`) for debugging, which preserves failed resources but leaves the stack in `CREATE_FAILED` state.

**Update**: Two types:
- **Direct update**: Changes are applied immediately. CloudFormation determines the update behavior per property: *No interruption*, *Some interruption*, or *Replacement*. Check the documentation's "Update requires" column for each property.
- **Change Set**: Creates a preview of proposed changes without executing them. Recommended for production stacks to review impact before applying.

**Delete**: Resources are deleted in reverse dependency order. If deletion of a resource fails (e.g., non-empty S3 bucket), the stack enters `DELETE_FAILED` state. You can retry deletion and skip the failing resources.

**Drift Detection**: Compares the actual state of provisioned resources against the expected template configuration. Drift can be detected at the stack level or for individual resources. Not all resources support drift detection. Drift does not automatically remediate; you must update the template or the resource manually.

**Import**: Brings existing resources into a CloudFormation stack. Requires a resource identifier (e.g., a VPC ID) and a template that declares the resource. Imported resources adopt the stack's lifecycle. Useful for brownfield environments.

### 1.6 Change Sets

Change Sets are a critical exam topic. They let you preview exactly what CloudFormation will modify, replace, or delete before committing an update.

**Workflow:**
1. Create a change set by submitting the updated template (or parameter overrides).
2. Review the change set — see which resources will be Added, Modified, Removed, or Replaced.
3. Execute the change set to apply changes, or delete the change set to discard.

Change sets do **not** indicate whether the update will succeed—they only show what CloudFormation *intends* to do. A change set for resource import is also supported.

> **Key Points for the Exam**
> - Change sets are non-destructive previews. They let you answer "what will happen?" without committing.
> - You can have multiple change sets per stack; executing one invalidates the others.
> - In CodePipeline, the `CHANGE_SET_REPLACE` action mode creates a change set, and a separate `CHANGE_SET_EXECUTE` action executes it.

### 1.7 Nested Stacks vs Cross-Stack References

**Nested Stacks** are stacks created as part of a parent stack using the `AWS::CloudFormation::Stack` resource. The child template is stored in S3.
- **Use case**: Breaking large templates into reusable components (e.g., a VPC stack, a security group stack, a compute stack).
- **Lifecycle**: Nested stacks are updated/deleted with the parent. They share a lifecycle.
- Data flows from parent to child via `Parameters` and from child to parent via `Outputs` referenced by `!GetAtt NestedStack.Outputs.OutputKey`.

**Cross-Stack References** use `Export` in the Outputs section of one stack and `Fn::ImportValue` in another.
- **Use case**: Sharing infrastructure between **independent** stacks managed by different teams or pipelines.
- **Lifecycle**: Stacks are independent. The exporting stack cannot be deleted or have its exported value updated while imports exist.
- Maximum **200 exports** per account per region.

| Aspect | Nested Stacks | Cross-Stack References |
|---|---|---|
| Lifecycle coupling | Tightly coupled (parent manages children) | Loosely coupled (independent lifecycles) |
| Reuse pattern | Component composition | Shared infrastructure |
| Update model | Parent update cascades to children | Stacks updated independently |
| Limit | 500 resources total (across nested stacks) | 200 exports per account/region |
| Dependency | Implicit (parent-child) | Explicit (export/import) |

> **Key Points for the Exam**
> - Use nested stacks when components share a lifecycle (e.g., an application's VPC + subnets + EC2).
> - Use cross-stack references when sharing foundational infrastructure across independent applications.
> - You **cannot** delete an export while any stack imports it.

### 1.8 StackSets

StackSets let you deploy CloudFormation stacks across **multiple accounts and regions** in a single operation.

**Deployment Targets:**
- Individual AWS accounts
- Organizational Units (OUs) in AWS Organizations (service-managed model)
- Entire Organization

**Permission Models:**
- **Self-managed**: You create the necessary IAM roles (`AWSCloudFormationStackSetAdministrationRole` in the admin account, `AWSCloudFormationStackSetExecutionRole` in each target account). Full control, more setup.
- **Service-managed**: Enabled through AWS Organizations integration. CloudFormation creates service-linked roles automatically. Supports **auto-deployment** — new accounts added to an OU automatically receive the stack.

**Auto-Deployment**: When enabled (service-managed only), StackSets automatically deploys stacks to new accounts added to targeted OUs and removes stacks from accounts removed from those OUs. This is fundamental for **landing zone governance**.

**Drift Detection**: StackSets can detect drift across all stack instances. Drift status is reported per stack instance.

**Operation Preferences:**
- `FailureToleranceCount/Percentage`: Number/percentage of stack instances that can fail before the operation stops.
- `MaxConcurrentCount/Percentage`: Number/percentage of accounts in which operations are performed simultaneously.
- `RegionConcurrencyType`: `SEQUENTIAL` or `PARALLEL`.

> **Key Points for the Exam**
> - StackSets with service-managed permissions + auto-deployment is the recommended approach for multi-account governance (e.g., ensuring GuardDuty, Config, or CloudTrail is enabled in every account).
> - The admin account creates the StackSet; target accounts receive stack instances.
> - Operation preferences control blast radius and speed. For conservative rollouts, use low `MaxConcurrentCount` and low `FailureToleranceCount`.

### 1.9 Custom Resources

Custom Resources let you run custom provisioning logic during CloudFormation stack operations. When CloudFormation creates, updates, or deletes a custom resource, it sends a request to a specified endpoint.

**Types:**
- `AWS::CloudFormation::CustomResource` (or `Custom::MyCustomName`)
- Backed by Lambda (`ServiceToken` = Lambda ARN) or SNS (`ServiceToken` = SNS Topic ARN).

**Lifecycle:**
1. CloudFormation sends a **request** to the `ServiceToken` with `RequestType` (`Create`, `Update`, `Delete`), `ResourceProperties`, `OldResourceProperties` (on Update), `StackId`, `RequestId`, `LogicalResourceId`, and a `ResponseURL` (pre-signed S3 URL).
2. Your code performs custom logic (e.g., look up an AMI ID, empty an S3 bucket before deletion, configure a third-party resource).
3. Your code sends a **response** (JSON PUT to the `ResponseURL`) indicating `SUCCESS` or `FAILED`, with optional `Data` (key-value pairs accessible via `Fn::GetAtt`), `PhysicalResourceId`, and `Reason`.

**cfn-response module**: A helper library (bundled in the `ZipFile` inline code option for Lambda) that simplifies sending the response. Call `cfn_response.send(event, context, status, data)`.

**Critical behavior:**
- If your Lambda function fails to respond (crashes, times out, network issue), CloudFormation waits for 1 hour (or the custom timeout) and then marks the resource as `FAILED`.
- The `PhysicalResourceId` determines whether an Update triggers a replacement. If the new `PhysicalResourceId` differs from the old one, CloudFormation treats it as a replacement and later sends a `Delete` for the old physical resource.

> **Key Points for the Exam**
> - Lambda-backed custom resources are by far the most common pattern.
> - The function **must** send a response to the pre-signed S3 URL, or the stack will hang.
> - Common use cases on the exam: cleaning up S3 buckets before stack deletion, looking up the latest AMI ID, creating resources not supported by CloudFormation.
> - Pay attention to `PhysicalResourceId` handling — changing it on Update triggers a replacement lifecycle.

### 1.10 CloudFormation Init (cfn-init)

`AWS::CloudFormation::Init` is metadata attached to an EC2 instance resource that declares the desired configuration state. The `cfn-init` helper script reads this metadata and configures the instance.

**Metadata Structure:**
```yaml
Metadata:
  AWS::CloudFormation::Init:
    configSets:
      default:
        - install
        - configure
    install:
      packages:
        yum:
          httpd: []
      files:
        /var/www/html/index.html:
          content: "Hello World"
          mode: "000644"
          owner: root
          group: root
      services:
        sysvinit:
          httpd:
            enabled: true
            ensureRunning: true
    configure:
      commands:
        01_setup:
          command: "/opt/setup.sh"
```

**Configuration keys (within each config block):**
- `packages`: Install packages (yum, apt, python, rubygems, msi).
- `groups`: Create Linux groups.
- `users`: Create Linux users.
- `sources`: Download and extract archives to specified directories.
- `files`: Create files with content (inline, URL, or S3), set permissions.
- `commands`: Execute shell commands in alphabetical order of their keys. Support `test` (conditional execution), `cwd`, `env`, `ignoreErrors`.
- `services`: Ensure services are started/stopped/enabled. Can be linked to files or packages for automatic restart on change.

**configSets** define the order in which config blocks are applied. You can create complex ordered sequences and even reference other configSets.

### 1.11 Helper Scripts

| Script | Purpose |
|---|---|
| `cfn-init` | Reads `AWS::CloudFormation::Init` metadata and applies the configuration. Called once during instance launch (typically from `UserData`). |
| `cfn-signal` | Sends a success or failure signal to CloudFormation. Used with `CreationPolicy` or `WaitCondition`. Exit code 0 = success. |
| `cfn-hup` | A daemon that detects changes to metadata and re-runs specified actions. Enables **in-place updates** without replacing the instance. Configured via `cfn-hup.conf` and `hooks.d/` directory. |
| `cfn-get-metadata` | Retrieves metadata for a resource. Rarely used directly (cfn-init handles this). |

**cfn-signal and CreationPolicy/WaitCondition:**

`CreationPolicy` is the modern approach. You declare it on an EC2 instance or Auto Scaling group:

```yaml
CreationPolicy:
  ResourceSignal:
    Count: 1
    Timeout: PT15M
```

The instance's `UserData` runs `cfn-init` followed by `cfn-signal`:

```bash
/opt/aws/bin/cfn-init -s ${AWS::StackId} -r MyInstance --region ${AWS::Region}
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackId} --resource MyInstance --region ${AWS::Region}
```

`WaitCondition` + `WaitConditionHandle` is the older pattern. `WaitCondition` is a resource that pauses the stack until it receives a signal at the pre-signed URL provided by the `WaitConditionHandle`. It is still relevant for scenarios where the signal must come from **outside the stack** or from a non-EC2 resource.

> **Key Points for the Exam**
> - `cfn-init` + `cfn-signal` + `CreationPolicy` is the recommended bootstrapping pattern.
> - `cfn-hup` is essential for updating instance configuration **without replacement** when the metadata changes.
> - `WaitCondition` is used when signals must come from outside the stack.

### 1.12 Stack Policies

Stack policies are JSON documents that control which resources can be updated. By default, all resources can be updated. Once a stack policy is set, **all resources are protected by default** (deny all updates), and you must explicitly allow updates.

```json
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "Update:*",
      "Principal": "*",
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": "Update:Replace",
      "Principal": "*",
      "Resource": "LogicalResourceId/ProductionDatabase"
    }
  ]
}
```

You can temporarily override a stack policy during an update by supplying a temporary policy. Stack policies **cannot be deleted once set** — only replaced.

### 1.13 Rollback Triggers

Rollback triggers monitor CloudWatch alarms during stack creation or update. If any specified alarm enters `ALARM` state within the monitoring period (0–180 minutes after stack operation completes), CloudFormation automatically rolls back the operation.

```yaml
RollbackConfiguration:
  MonitoringTimeInMinutes: 10
  RollbackTriggers:
    - Arn: !Ref MyAlarm
      Type: AWS::CloudWatch::Alarm
```

### 1.14 Macros and Transforms

**Macros** are custom template processors. You register a macro (backed by a Lambda function) that receives template content, processes it, and returns modified content. CloudFormation applies the macro during template processing.

**Built-in Transforms:**
- `AWS::Include`: Fetches a template snippet from S3 and inserts it. Useful for reusing common template fragments.
- `AWS::Serverless-2016-10-31` (SAM Transform): Converts SAM syntax (`AWS::Serverless::Function`, etc.) into standard CloudFormation resources.

### 1.15 CloudFormation Registry and Modules

**Registry**: A catalog of resource types, modules, and hooks. Includes:
- **Public types** published by AWS and third parties.
- **Private types** registered in your account (custom resource types written with the CloudFormation CLI, in Java, Python, Go, or TypeScript).
- **Hooks**: Run validation logic before or after resource provisioning (e.g., enforce tagging policies).

**Modules**: Packages of template fragments that are versioned and published to the registry. Used as `AWS::MyOrg::MyModule::MODULE` in templates. Modules encapsulate best-practice configurations.

### 1.16 CloudFormation Guard (cfn-guard)

`cfn-guard` is a policy-as-code tool that validates CloudFormation templates (and other JSON/YAML documents) against rules.

```
let s3_buckets = Resources.*[ Type == 'AWS::S3::Bucket' ]
rule s3_bucket_encryption when %s3_buckets !empty {
    %s3_buckets.Properties.BucketEncryption exists
}
```

`cfn-guard validate` checks templates; `cfn-guard test` tests guard rules. It is an open-source CLI and can be integrated into CI/CD pipelines.

### 1.17 Continuous Delivery with CodePipeline

CloudFormation integrates natively with AWS CodePipeline as a deploy action provider.

**Action Modes:**
| Mode | Behavior |
|---|---|
| `CREATE_UPDATE` | Creates the stack if it doesn't exist; updates it if it does. Direct update, no preview. |
| `CHANGE_SET_REPLACE` | Creates (or replaces) a change set. Does **not** execute it. |
| `CHANGE_SET_EXECUTE` | Executes a previously created change set. |
| `DELETE_ONLY` | Deletes the stack. |
| `REPLACE_ON_FAILURE` | If the stack is in a failed state, deletes it and creates a new one. Otherwise, updates. |

**Common Pipeline Pattern:**
1. Source stage: Pulls template from CodeCommit/S3/GitHub.
2. Build stage (optional): Runs `cfn-lint`, `cfn-guard`, or generates templates.
3. Deploy stage (Test): `CREATE_UPDATE` to a test environment.
4. Manual approval.
5. Deploy stage (Prod): `CHANGE_SET_REPLACE` → Manual approval → `CHANGE_SET_EXECUTE`.

> **Key Points for the Exam**
> - `CHANGE_SET_REPLACE` + `CHANGE_SET_EXECUTE` is the safe production deployment pattern.
> - `CREATE_UPDATE` is simpler but provides no preview.
> - The pipeline must have an IAM role with permissions to create/update stacks and the resources within them.

### 1.18 Dynamic References

Dynamic References allow CloudFormation to retrieve values from SSM Parameter Store and Secrets Manager at stack operation time.

| Pattern | Service | Example |
|---|---|---|
| `{{resolve:ssm:param-name:version}}` | SSM Parameter Store (String, StringList) | `{{resolve:ssm:/app/db-host:1}}` |
| `{{resolve:ssm-secure:param-name:version}}` | SSM Parameter Store (SecureString) | `{{resolve:ssm-secure:/app/db-password:1}}` |
| `{{resolve:secretsmanager:secret-id:SecretString:json-key:version-stage:version-id}}` | Secrets Manager | `{{resolve:secretsmanager:MySecret:SecretString:password}}` |

**Restrictions:**
- `ssm-secure` can only be used in supported resource properties (e.g., password fields). It **cannot** be used in `Outputs`, `Metadata`, `Conditions`, or `Rules`.
- Dynamic references are resolved at **create/update time**, not at template processing time.

> **Key Points for the Exam**
> - Dynamic references are the recommended way to reference secrets in CloudFormation templates — they prevent secrets from appearing in the template or CloudFormation console.
> - Know the difference between `ssm`, `ssm-secure`, and `secretsmanager` resolve patterns.
> - `ssm-secure` has usage restrictions.

### 1.19 Template Validation and Linting

- `aws cloudformation validate-template`: Basic syntax check. Does **not** validate resource property values or logic errors.
- `cfn-lint`: Open-source linter that performs deep validation against the CloudFormation resource specification. Catches incorrect property types, missing required properties, unsupported intrinsic function usage, and more.
- `taskcat`: Tests CloudFormation templates by deploying them across multiple regions and accounts.

### 1.20 Resource Import and Removal

**Resource Import**: Bring existing resources under CloudFormation management. Steps:
1. Add the resource to the template with a `DeletionPolicy` of `Retain`.
2. Run `create-change-set` with `--change-set-type IMPORT` and provide `--resources-to-import` (resource identifier).
3. Execute the change set.

**Resource Removal (without deletion)**: Set `DeletionPolicy: Retain` on the resource, then remove it from the template. CloudFormation removes it from the stack but leaves the actual resource intact.

### 1.21 Termination Protection

When enabled on a stack, prevents accidental deletion. The stack cannot be deleted until termination protection is explicitly disabled. This is a simple but commonly tested concept.

---

## 2. AWS CDK (Cloud Development Kit)

The AWS CDK lets you define cloud infrastructure using familiar programming languages (TypeScript, Python, Java, C#, Go). The CDK synthesizes your code into a CloudFormation template.

### 2.1 Core Concepts

**Constructs** are the basic building blocks:
- **L1 (CFN Resources)**: Direct CloudFormation resource mappings (`CfnBucket`). One-to-one with CloudFormation resources. Prefixed with `Cfn`.
- **L2 (Curated Constructs)**: Higher-level abstractions with sensible defaults, convenience methods, and security best practices (`Bucket`, `Function`). These are the most commonly used.
- **L3 (Patterns)**: Complete multi-resource architectures (e.g., `ApplicationLoadBalancedFargateService`). Opinionated, high-level patterns.

**Stacks**: The unit of deployment. Each stack maps to a CloudFormation stack. A CDK app can contain multiple stacks.

**Apps**: The root construct. An app is the entry point that contains one or more stacks.

### 2.2 CDK CLI Commands

| Command | Purpose |
|---|---|
| `cdk synth` | Synthesizes the CDK app into a CloudFormation template (output to `cdk.out/`). |
| `cdk deploy` | Deploys the stack(s) to AWS. Synthesizes first, then deploys. |
| `cdk diff` | Compares the deployed stack with the current CDK code (like a change set preview). |
| `cdk destroy` | Deletes the stack(s). |
| `cdk bootstrap` | Provisions the CDK toolkit stack (S3 bucket, ECR repo, IAM roles) in the target account/region. Must be done once per account/region before deploying. |
| `cdk ls` | Lists all stacks in the app. |

### 2.3 Context, Environment, and Bootstrapping

**Context**: Key-value pairs used to pass configuration to the CDK app. Can come from `cdk.json`, `cdk.context.json`, command line (`-c key=value`), or programmatically. Cached values (like VPC lookups) are stored in `cdk.context.json`.

**Environment**: The target AWS account and region for a stack. Can be specified explicitly (`env: { account: '123456789012', region: 'us-east-1' }`) or resolved from the CLI profile.

**Bootstrapping**: `cdk bootstrap` sets up a CloudFormation stack (`CDKToolkit`) containing:
- An S3 bucket for assets (Lambda code, Docker images).
- An ECR repository.
- IAM roles for deployment.
Must be done for each target account/region combination. For cross-account deployments, bootstrap the target account with a trust policy to the deploying account.

### 2.4 Aspects for Compliance

Aspects are a CDK mechanism for applying operations across all constructs in a scope. Implement the `IAspect` interface with a `visit(node)` method. Use cases:
- Adding tags to all resources.
- Validating that all S3 buckets have encryption enabled.
- Checking that all security groups don't allow `0.0.0.0/0` ingress.

Aspects are applied using `Aspects.of(scope).add(new MyAspect())`.

### 2.5 Testing with Assertions Library

The CDK provides `aws-cdk-lib/assertions` for testing synthesized templates:
- `Template.fromStack(stack)`: Creates a template assertion object.
- `template.hasResourceProperties(type, props)`: Assert that a resource with specific properties exists.
- `template.resourceCountIs(type, count)`: Assert the count of resources of a given type.
- `Match.objectLike()`, `Match.arrayWith()`, `Match.stringLikeRegexp()`: Flexible matchers.

### 2.6 CDK Pipelines (Self-Mutating Pipelines)

CDK Pipelines is a high-level construct library for building continuous delivery pipelines for CDK applications.

**Self-mutating**: The pipeline updates itself when you push changes to the CDK app code. If the pipeline definition changes, the pipeline detects this and updates itself before deploying application changes.

**Structure:**
1. **Source**: Code repository (CodeCommit, GitHub, etc.).
2. **Build (Synth)**: Runs `cdk synth` to produce the Cloud Assembly.
3. **UpdatePipeline**: The self-mutation step — updates the pipeline itself.
4. **Stages**: Deployment stages (e.g., Dev, Staging, Prod) with optional pre/post steps (manual approvals, integration tests).

> **Key Points for the Exam**
> - CDK synthesizes to CloudFormation — understanding CloudFormation is still essential.
> - L2 constructs are recommended for most use cases (secure defaults).
> - CDK Pipelines' self-mutation is a differentiating feature.
> - Aspects enable org-wide compliance enforcement in CDK apps.
> - Bootstrapping must happen before any deployment and must be done per-account/per-region.

---

## 3. AWS Service Catalog

AWS Service Catalog allows organizations to create and manage curated catalogs of approved IT resources (products).

### 3.1 Core Components

**Portfolios**: Collections of products with access control. You assign IAM principals (users, groups, roles) or share portfolios with other AWS accounts/Organizations.

**Products**: CloudFormation templates (or Terraform configurations) packaged with metadata (name, description, version). Each product can have multiple versions.

**Constraints** (applied at the portfolio level):
| Constraint | Purpose |
|---|---|
| **Launch Constraint** | Specifies an IAM role that Service Catalog assumes to provision the product. Allows end users to launch products without needing direct permissions to create the underlying resources. |
| **Notification Constraint** | Specifies an SNS topic to receive notifications about product provisioning events. |
| **Template Constraint** | Restricts parameter values that end users can enter when launching a product (e.g., limit instance types to `t3.micro` and `t3.small`). |
| **Tag Update Constraint** | Allows or disallows end users from updating tags on provisioned products. |
| **Stack Set Constraint** | Specifies which accounts and regions the product can be deployed to using StackSets. |

### 3.2 Provisioned Products

When a user launches a product, Service Catalog creates a **provisioned product**. Users can update, terminate, or view the status of their provisioned products. Administrators can see all provisioned products across users.

### 3.3 TagOptions

TagOptions are key-value pairs managed centrally. When associated with a portfolio or product, they are automatically applied to provisioned resources. TagOptions enforce consistent tagging across the organization.

### 3.4 Service Actions

Service Actions allow end users to perform operational tasks on provisioned products (e.g., restart an EC2 instance, create a snapshot) through SSM Automation documents, without requiring AWS Console access.

### 3.5 Integration with AWS Organizations

Portfolios can be shared across accounts in an AWS Organization. This enables centralized product catalog management with decentralized consumption.

> **Key Points for the Exam**
> - Launch constraints are essential: they let end users launch products with a role that has the needed permissions, so end users don't need direct IAM permissions for the underlying resources.
> - Template constraints restrict parameter choices (e.g., limit instance sizes).
> - Service Catalog + Organizations enables centralized governance of approved architectures.
> - Products are versioned — users can be on different versions.

---

## 4. AWS Systems Manager (Configuration Management)

AWS Systems Manager provides a unified interface for managing AWS resources at scale.

### 4.1 State Manager

State Manager ensures that your instances maintain a defined configuration state.

**Associations**: Define the desired state by linking an SSM document with target instances and a schedule. For example, ensure the CloudWatch agent is installed and running on all instances tagged `Environment=Production`.

**Documents**: SSM documents define the actions State Manager performs. Types: `Command`, `Automation`, `Policy`, `Session`.

**Targets**: Instances can be targeted by instance IDs, tags, resource groups, or `InstanceIds` parameter.

**Compliance**: State Manager tracks compliance status. Resources are either `COMPLIANT` or `NON_COMPLIANT` based on whether the association was successfully applied.

### 4.2 Parameter Store

A secure, hierarchical storage service for configuration data and secrets.

| Feature | Standard | Advanced |
|---|---|---|
| Max parameter size | 4 KB | 8 KB |
| Max parameters | 10,000 | 100,000+ |
| Parameter policies | No | Yes (expiration, notification) |
| Cost | Free | Charged per parameter |
| Throughput | 40 TPS (adjustable to 1,000) | 1,000 TPS default |

**Hierarchies**: Parameters can be organized in paths (e.g., `/app/prod/db/host`). `GetParametersByPath` retrieves all parameters under a path.

**Types**: `String`, `StringList`, `SecureString`. `SecureString` is encrypted with KMS (default `aws/ssm` key or a custom CMK).

**Parameter Policies** (advanced tier only):
- **Expiration**: Automatically deletes or notifies when a parameter expires.
- **ExpirationNotification**: Sends an EventBridge event before expiration.
- **NoChangeNotification**: Sends an event if the parameter hasn't been changed within a specified period.

> **Key Points for the Exam**
> - Parameter Store is **free** for standard tier. Advanced tier adds policies, higher limits, and higher throughput at a cost.
> - `SecureString` uses KMS encryption. The default key is `aws/ssm` but custom CMKs enable cross-account access.
> - Parameter Store supports versioning and labeling (e.g., `prod`, `staging`) for aliasing.
> - Know the comparison: Parameter Store vs. Secrets Manager. Secrets Manager supports automatic rotation (Lambda), cross-account access via resource policies, and replication. Parameter Store is simpler and free for basic use.

### 4.3 Automation

SSM Automation executes runbooks (Automation documents) to perform common maintenance and deployment tasks.

**Key capabilities:**
- **Approval actions**: `aws:approve` step type requires one or more IAM principals to approve before the automation proceeds. Essential for change management.
- **Branching**: `aws:branch` evaluates conditions and routes execution to different steps (if/else logic within a runbook).
- **Rate control**: Limit concurrent executions and define error thresholds when targeting multiple resources.
- **Multi-account/multi-region**: Execute automations across accounts and regions via a central management account.
- **EventBridge integration**: Trigger automations from EventBridge events (e.g., auto-remediate a Config rule violation).

**Common AWS-managed runbooks:**
- `AWS-StopEC2Instance`, `AWS-StartEC2Instance`
- `AWS-CreateSnapshot`
- `AWS-PatchInstanceWithRollback`
- `AWS-UpdateCloudFormationStack`

### 4.4 Patch Manager

Automates the process of patching managed instances.

**Patch Baselines**: Define which patches are approved for installation. Specify:
- OS, product, classification, severity
- Auto-approval delay (e.g., approve critical patches after 7 days)
- Approved and rejected patches lists
- Default baselines exist for each OS

**Patch Groups**: Logical groupings of instances (via the `Patch Group` tag). Each patch group is associated with one patch baseline. Instances in the same patch group receive the same patching configuration.

**Maintenance Windows**: Scheduled windows during which patching (or other tasks) can run. Define:
- Schedule (cron or rate)
- Duration and cutoff time
- Targets and tasks (Run Command, Automation, Lambda, Step Functions)

**Compliance Reporting**: Patch Manager reports compliance status for each instance — which patches are installed, missing, or failed. Data flows to SSM Compliance and can be aggregated in S3 via Resource Data Sync.

### 4.5 Session Manager

Provides secure, auditable shell access to instances without needing SSH keys, open inbound ports, or bastion hosts.

**Key features:**
- All sessions can be logged to **S3** and **CloudWatch Logs** for audit.
- Supports **port forwarding** (e.g., forward RDS port through an EC2 instance).
- Session preferences allow configuring default shell, idle timeout, encryption (KMS), and Run As (Linux user).
- Integrates with IAM policies and supports tag-based access control.

### 4.6 OpsCenter and OpsItems

**OpsCenter** aggregates and resolves operational issues (OpsItems). OpsItems can be created manually or automatically from CloudWatch Alarms, Config rule violations, EventBridge events, etc.

Each OpsItem includes:
- Title, description, severity, status
- Related resources
- Runbooks (Automation documents) for resolution
- Deduplication based on source and type

### 4.7 Distributor

Packages and distributes software packages to managed instances. Supports installing, updating, and uninstalling packages. AWS provides packages for common agents (CloudWatch, Inspector, etc.), and you can create custom packages.

### 4.8 Run Command

Remotely execute SSM documents on managed instances without SSH/RDP.

**Targeting**: By instance IDs, tags, resource groups, or all instances.

**Rate Control**:
- `MaxConcurrency`: Limit the number of instances running the command simultaneously.
- `MaxErrors`: Stop execution after a threshold of failures (absolute number or percentage).

**Output**: Command output can be sent to **S3** or **CloudWatch Logs**. Output displayed in the console is truncated at 48,000 characters; use S3 for full output.

**Notifications**: SNS can notify on command status changes.

> **Key Points for the Exam**
> - Run Command + rate control is used for safe, controlled mass operations.
> - Session Manager eliminates the need for bastion hosts and SSH key management.
> - Patch Manager's compliance reporting integrates with SSM Compliance for centralized compliance views.
> - Automation runbooks with approval steps enable change-management workflows.

---

## 5. AWS OpsWorks

AWS OpsWorks provides managed Chef and Puppet servers for configuration management.

### 5.1 Variants

- **OpsWorks for Chef Automate**: Fully managed Chef server. Chef recipes define configuration.
- **OpsWorks for Puppet Enterprise**: Fully managed Puppet server. Puppet manifests define configuration.
- **OpsWorks Stacks** (legacy): Custom Chef-based configuration management. Most commonly tested on the exam.

### 5.2 OpsWorks Stacks Concepts

**Stacks**: The top-level container representing an application environment (e.g., production stack, staging stack). Contains layers, instances, and apps.

**Layers**: Represent components of the application (e.g., web layer, application layer, database layer). Each layer has associated Chef recipes that run during lifecycle events.

**Instances**: EC2 instances belonging to a layer. Types:
- **24/7**: Always running.
- **Time-based**: Start/stop on a schedule.
- **Load-based**: Start/stop based on metrics (CPU, memory, load).

### 5.3 Lifecycle Events

| Event | When It Runs |
|---|---|
| **Setup** | After an instance boots. Install packages, configure the system. |
| **Configure** | When instances come online/go offline, EIP or ELB association changes. Runs on **all** instances in the stack. |
| **Deploy** | When you deploy an application. |
| **Undeploy** | When you remove an application. |
| **Shutdown** | Before an instance is terminated. Cleanup tasks. |

Each layer has custom recipes assigned to each lifecycle event.

### 5.4 Berkshelf and Data Bags

**Berkshelf**: A Chef dependency manager for managing cookbooks and their dependencies. OpsWorks Stacks supports Berkshelf for resolving cookbook dependencies from external sources.

**Data Bags**: JSON data structures that store configuration data accessible by Chef recipes. OpsWorks automatically creates stack-level data bags with instance, layer, and app information. Custom data bags can also be created.

> **Key Points for the Exam**
> - OpsWorks is less commonly tested than CloudFormation/CDK, but know the lifecycle events.
> - The **Configure** event runs on **all** instances — this is a common exam question.
> - Know the instance types: 24/7, time-based, load-based.
> - OpsWorks is being deprecated in favor of SSM and CloudFormation. Exam questions may test when OpsWorks is appropriate for migrating Chef/Puppet workloads.

---

## 6. Terraform on AWS (Brief Coverage)

While Terraform is not an AWS-native service, the exam may include questions about using Terraform with AWS.

### 6.1 State Management

Terraform maintains a state file that maps resources to real-world infrastructure. Best practices on AWS:
- **S3 backend**: Store state in an S3 bucket with versioning enabled.
- **DynamoDB locking**: Use a DynamoDB table for state locking to prevent concurrent modifications. The table requires a `LockID` partition key.
- **Encryption**: Enable S3 server-side encryption for state files.

### 6.2 Modules and Workspaces

**Modules**: Reusable Terraform configurations. Published to the Terraform Registry or stored in private repositories. Similar to nested stacks in CloudFormation.

**Workspaces**: Named state-file environments within the same configuration. Each workspace has its own state file. Useful for managing multiple environments (dev, staging, prod) from one codebase. Not to be confused with Terraform Cloud workspaces.

> **Key Points for the Exam**
> - The exam won't deeply test Terraform syntax, but know the S3 + DynamoDB state management pattern.
> - Understand how Terraform fits as an alternative/complement to CloudFormation.

---

## 7. Configuration Management Best Practices

### 7.1 Infrastructure as Code Patterns

- **Declarative vs. Imperative**: CloudFormation and Terraform are declarative (desired state). CDK is imperative code that generates declarative templates. SSM Automation is more procedural.
- **Immutable Infrastructure**: Replace instances rather than updating them in place. Use AMI baking (Packer + CodePipeline) and Auto Scaling Group rolling updates.
- **Mutable Infrastructure**: Update existing instances (cfn-init + cfn-hup, Ansible, Chef). Appropriate when instance replacement is costly or stateful.

### 7.2 GitOps Workflows

- Templates and code stored in version control (CodeCommit, GitHub).
- Pull requests trigger validation (cfn-lint, cfn-guard, CDK tests).
- Merge to main triggers pipeline deployment.
- **No manual changes** to infrastructure — all changes through code.

### 7.3 Environment Promotion

- Use the same template across environments; parameterize differences.
- Promote artifacts (not code rebuilds) through stages.
- Use parameter files (`dev.json`, `prod.json`) or CDK context for environment-specific values.

### 7.4 Secret Management

| Method | When to Use |
|---|---|
| SSM Parameter Store (SecureString) | Simple secrets, no rotation needed, free tier |
| Secrets Manager | Rotation required, cross-account access, database credentials |
| CloudFormation Dynamic References | Referencing secrets in IaC templates without exposing them |
| `NoEcho` parameters | Masking input in console; **not** secure storage |

### 7.5 Drift Detection and Remediation

- **CloudFormation Drift Detection**: Identifies resources whose actual state differs from the template. Does not auto-remediate.
- **AWS Config Rules**: Continuously evaluate resource configurations. Paired with SSM Automation for auto-remediation.
- **CDK `cdk diff`**: Preview differences between deployed and local code.
- **Terraform `terraform plan`**: Shows proposed changes.

**Remediation Strategy:**
1. Detect drift (Config, CloudFormation, Terraform).
2. Alert (EventBridge → SNS/Lambda).
3. Remediate automatically (Config remediation → SSM Automation) or manually (update template and redeploy).

> **Key Points for the Exam**
> - Immutable infrastructure (replace, not update) is the preferred pattern for stateless workloads.
> - All secrets should use SSM SecureString or Secrets Manager, never plaintext parameters.
> - Drift detection is a detection mechanism — remediation requires additional tooling (Config + SSM Automation).
> - GitOps: Code → PR → Review → Merge → Pipeline → Deploy. No manual changes.

---

## Summary Comparison Table

| Feature | CloudFormation | CDK | Terraform | OpsWorks | Service Catalog |
|---|---|---|---|---|---|
| Type | Declarative IaC | Imperative → Declarative | Declarative IaC | Config Mgmt | Governance |
| Language | JSON/YAML | TypeScript, Python, etc. | HCL | Chef/Puppet | CFn templates |
| State | Managed by AWS | Managed by AWS (CFn) | S3 + DynamoDB | OpsWorks service | CFn stacks |
| Multi-account | StackSets | CDK Pipelines | Terraform Cloud/workspaces | Per-stack | Portfolio sharing |
| Drift detection | Yes | Via CFn | Yes (`plan`) | No | Via CFn |
| Rollback | Automatic | Via CFn | Manual (`apply` reversal) | Per-recipe | Via CFn |
| Best for | AWS-native IaC | Developers preferring code | Multi-cloud IaC | Chef/Puppet shops | End-user self-service |

---

## Final Exam Preparation Checklist

- [ ] Can you write a CloudFormation template from scratch with parameters, conditions, mappings, and outputs?
- [ ] Do you understand the difference between nested stacks and cross-stack references?
- [ ] Can you explain StackSets permission models and auto-deployment?
- [ ] Do you know when to use `CreationPolicy` vs `WaitCondition`?
- [ ] Can you describe custom resource lifecycle events and the cfn-response pattern?
- [ ] Do you understand CDK constructs levels (L1/L2/L3) and CDK Pipelines self-mutation?
- [ ] Can you differentiate Service Catalog constraints?
- [ ] Do you understand SSM Parameter Store tiers, Patch Manager workflows, and Automation approval steps?
- [ ] Can you design a GitOps workflow for CloudFormation with CodePipeline?
- [ ] Do you know when to use `DeletionPolicy: Retain` vs `Snapshot` vs `Delete`?
