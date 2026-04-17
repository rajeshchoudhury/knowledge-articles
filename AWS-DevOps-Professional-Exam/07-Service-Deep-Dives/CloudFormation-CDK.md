# AWS CloudFormation and CDK Deep Dive

Infrastructure as Code is a cornerstone of the DOP-C02 exam. CloudFormation appears in nearly every domain, and CDK knowledge is increasingly tested. This guide covers the advanced features that differentiate exam-ready candidates.

---

## AWS CloudFormation Advanced Topics

### Stack Lifecycle

Understanding the stack lifecycle is essential for troubleshooting:

1. **Creation**: Resources are created in dependency order. If any resource fails, CloudFormation rolls back all created resources (unless `--disable-rollback` is specified).
2. **Update**: CloudFormation computes a change set (explicitly or implicitly), then applies changes. Resources may be updated in-place, replaced, or left unchanged.
3. **Rollback**: On update failure, CloudFormation attempts to restore the stack to its previous state. Rollback itself can fail (stuck in `UPDATE_ROLLBACK_FAILED`), requiring `ContinueUpdateRollback` with resources to skip.
4. **Deletion**: Resources are deleted in reverse dependency order. Some resources (like non-empty S3 buckets) require `DeletionPolicy: Retain` or manual cleanup.

### Update Behaviors

Every CloudFormation resource property has an update behavior:

| Behavior | Description | Example |
|----------|-------------|---------|
| **No interruption** | Resource is updated in-place without any service disruption | Changing a Lambda function's description |
| **Some interruption** | Resource experiences brief downtime during update | Changing an EC2 instance type (requires stop/start) |
| **Replacement** | A new resource is created, traffic is switched, and the old resource is deleted | Changing an RDS instance's engine, changing an EC2 instance's AMI |

> **Key Points for the Exam:**
> - Always check the CloudFormation documentation for the update behavior of a property before answering whether an update will cause downtime.
> - **Replacement** creates a new physical resource with a new physical ID—this can break references and cause data loss if not handled carefully.

### Drift Detection

Drift detection identifies resources whose actual configuration differs from the CloudFormation template:

- **Supported resources**: Not all resource types support drift detection (check documentation)
- **Drift statuses**: `IN_SYNC`, `DRIFTED`, `NOT_CHECKED`, `DELETED`
- **Stack drift status**: `IN_SYNC` (all resources in sync), `DRIFTED` (at least one resource has drifted)

Drift detection does **not** remediate drift—it only reports it. To fix drift, either update the template to match reality or update the resource to match the template.

### Resource Import

Resource import brings existing resources under CloudFormation management:

**Requirements:**
- Each resource must have a `DeletionPolicy` attribute in the template
- Each resource must have a unique identifier (e.g., `BucketName` for S3)
- The resource must not already be managed by another stack

**Walkthrough:**
1. Add the resource to the template with a `DeletionPolicy`
2. Create a change set of type `IMPORT`
3. Provide the resource identifier values
4. Execute the change set

> **Key Points for the Exam:**
> - Resource import is commonly tested in scenarios where you need to bring manually created resources under IaC management.
> - Not all resource types support import—check the CloudFormation documentation.

### StackSets

StackSets deploy stacks across multiple accounts and regions from a single template:

**Permission models:**

| Model | Description | Use Case |
|-------|-------------|----------|
| **Self-managed** | You create the required IAM roles (`AWSCloudFormationStackSetAdministrationRole` in admin account, `AWSCloudFormationStackSetExecutionRole` in target accounts) | Non-Organizations deployments |
| **Service-managed** | Permissions handled by AWS Organizations. Enable trusted access. Roles created automatically. | Organizations-based deployments |

**Key features:**
- **Auto-deployment**: Automatically deploy to new accounts added to an OU (service-managed only)
- **Operation preferences**: `FailureToleranceCount/Percentage`, `MaxConcurrentCount/Percentage`
- **Stack instances**: Each deployment to an account-region pair is a "stack instance"
- **Region ordering**: Control the order in which regions are deployed to
- **Account gates**: Lambda-backed validation before deploying to an account

> **Key Points for the Exam:**
> - **Service-managed StackSets with auto-deployment** is the recommended pattern for Organizations-wide guardrails (e.g., deploying Config rules, CloudTrail, GuardDuty to all accounts).
> - `FailureToleranceCount` determines how many stack instances can fail before the operation stops.
> - Deleting a StackSet requires deleting all stack instances first.

### Custom Resources

Custom resources extend CloudFormation with custom provisioning logic backed by Lambda or SNS:

**Request object** (sent to Lambda/SNS):

```json
{
  "RequestType": "Create|Update|Delete",
  "ResponseURL": "pre-signed S3 URL",
  "StackId": "...",
  "RequestId": "...",
  "ResourceType": "Custom::MyResource",
  "LogicalResourceId": "...",
  "ResourceProperties": { ... },
  "OldResourceProperties": { ... }
}
```

**Response object** (sent to the pre-signed S3 URL):

```json
{
  "Status": "SUCCESS|FAILED",
  "PhysicalResourceId": "unique-id",
  "StackId": "...",
  "RequestId": "...",
  "LogicalResourceId": "...",
  "Data": { "Key": "Value" }
}
```

**Critical behaviors:**
- **PhysicalResourceId**: If the physical resource ID changes on an `Update`, CloudFormation issues a `Delete` for the old physical resource ID afterward. This is a common source of bugs.
- **cfn-response module**: A helper library (for Python/Node.js) that simplifies sending responses. Available in ZipFile-based inline Lambda functions.
- **Timeout**: Custom resources have a default timeout of 1 hour. If no response is received, the stack operation fails.

**Common patterns:**
- AMI lookup (find latest AMI by name/owner)
- Empty S3 bucket before deletion
- Manage third-party resources (Datadog monitors, PagerDuty services)
- Seed a DynamoDB table or RDS database
- DNS validation for ACM certificates

> **Key Points for the Exam:**
> - If a custom resource Lambda function fails to send a response, the stack hangs for up to 1 hour, then fails.
> - The `Data` field in the response is accessible via `!GetAtt` in the template.
> - Use `cfn-response` for inline Lambda functions; for packaged functions, construct the response manually.

### Macros

CloudFormation macros process and transform templates before stack operations:

- Backed by Lambda functions
- Applied at the template level (`Transform` declaration) or snippet level (`Fn::Transform`)
- `AWS::Serverless` transform (SAM) is the most common built-in macro
- Custom macros can implement template-wide transformations (e.g., auto-add tags, enforce encryption)

### Modules

Modules are reusable building blocks registered in the CloudFormation Registry:

- Encapsulate patterns as a single logical resource type
- Versioned and published to the registry
- Use like any other resource: `Type: MyCompany::S3::Bucket::MODULE`

### Hooks

CloudFormation Hooks enforce policies before resources are created, updated, or deleted:

- **Hook types**: `preCreate`, `preUpdate`, `preDelete`
- **Failure modes**: `FAIL` (block the operation) or `WARN` (log a warning but continue)
- Registered in the CloudFormation Registry
- Written using the CloudFormation CLI and backed by Lambda

### CloudFormation Registry

The registry hosts:
- AWS resource types (first-party)
- Third-party resource types (e.g., Datadog, MongoDB Atlas, Cloudflare)
- Modules and hooks

Third-party types are invoked like AWS types: `Datadog::Monitors::Monitor`.

### Dynamic References

Dynamic references resolve values at deploy time from SSM Parameter Store and Secrets Manager:

```yaml
# SSM Parameter Store (plaintext)
!Sub '{{resolve:ssm:/${Environment}/db-host}}'

# SSM Parameter Store (SecureString)
!Sub '{{resolve:ssm-secure:/${Environment}/db-password}}'

# Secrets Manager
!Sub '{{resolve:secretsmanager:MySecret:SecretString:password}}'
```

> **Key Points for the Exam:**
> - `ssm-secure` references are **not supported** in all resource properties—only certain properties that accept secrets (e.g., RDS `MasterUserPassword`).
> - `secretsmanager` references can specify `SecretString:json-key` for JSON secrets, and optionally version stage/ID.
> - Dynamic references are resolved at **deploy time**, not template validation time.

### Outputs and Cross-Stack References

- **Outputs**: Values exported from a stack using `Export: Name`
- **Cross-stack reference**: Another stack uses `Fn::ImportValue` to consume the exported value
- **Limitations**:
  - You cannot delete a stack that has exports being referenced by other stacks
  - You cannot update an export value if it's being imported
  - Exports are region-specific
  - Use SSM Parameter Store for cross-region or frequently changing values

### Stack Policies

Stack policies protect specific resources from being updated:

```json
{
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "Update:Replace",
      "Principal": "*",
      "Resource": "LogicalResourceId/ProductionDatabase"
    },
    {
      "Effect": "Allow",
      "Action": "Update:*",
      "Principal": "*",
      "Resource": "*"
    }
  ]
}
```

- Applied to a stack (not a template)
- Can be temporarily overridden during a specific update
- Default behavior: all updates are allowed (no policy = allow all)

### Rollback Triggers

Associate CloudWatch alarms with a stack to trigger automatic rollback:

- Specify up to 5 CloudWatch alarms
- Set a monitoring time (0-180 minutes) after stack create/update
- If any alarm enters ALARM state during monitoring, CloudFormation rolls back

### Termination Protection

- Prevents accidental stack deletion
- Must be explicitly disabled before deletion
- Can be enabled/disabled via console, CLI, or API

### cfn-init Deep Dive

`AWS::CloudFormation::Init` metadata configures EC2 instances declaratively:

```yaml
Metadata:
  AWS::CloudFormation::Init:
    configSets:
      default:
        - install
        - configure
        - start
    install:
      packages:
        yum:
          httpd: []
      files:
        /etc/httpd/conf.d/myapp.conf:
          content: !Sub |
            ServerName ${DomainName}
          owner: root
          group: root
          mode: "000644"
    configure:
      commands:
        01_configure:
          command: "/usr/local/bin/configure-app.sh"
    start:
      services:
        sysvinit:
          httpd:
            enabled: true
            ensureRunning: true
            files:
              - /etc/httpd/conf.d/myapp.conf
```

**ConfigSets**: Control the order and grouping of configurations. Without configSets, the default order is `packages` → `groups` → `users` → `sources` → `files` → `commands` → `services`.

### Signal, WaitCondition, and CreationPolicy

**CreationPolicy** (preferred for ASG/EC2):

```yaml
MyASG:
  Type: AWS::AutoScaling::AutoScalingGroup
  CreationPolicy:
    ResourceSignal:
      Count: 3
      Timeout: PT15M
```

Instances call `cfn-signal` after successful initialization. CloudFormation waits for the specified count of success signals before marking the resource as complete.

**WaitCondition** (legacy, for non-EC2 or external processes):
- Creates a pre-signed URL that external processes can POST to
- Has a `Count` and `Timeout`
- WaitConditionHandle generates the URL

> **Key Points for the Exam:**
> - Use **CreationPolicy** with Auto Scaling groups and EC2 instances (modern approach).
> - Use **WaitCondition** only when you need to receive signals from resources outside CloudFormation.

### cfn-hup

`cfn-hup` is a daemon that detects changes in CloudFormation metadata and triggers updates:

- Polls metadata at a configurable interval
- Runs specified actions when metadata changes
- Useful for applying configuration changes without replacing instances
- Configured via `/etc/cfn/cfn-hup.conf` and `/etc/cfn/hooks.d/*.conf`

---

## AWS CDK

### Service Overview

The AWS Cloud Development Kit (CDK) lets you define cloud infrastructure using familiar programming languages (TypeScript, Python, Java, C#, Go). CDK synthesizes your code into CloudFormation templates.

### Construct Levels

| Level | Name | Description | Example |
|-------|------|-------------|---------|
| **L1** | CFN Resources | Direct 1:1 mapping to CloudFormation resources. Prefixed with `Cfn*`. | `CfnBucket` |
| **L2** | Curated Constructs | Higher-level abstractions with sensible defaults, helper methods, and security best practices. | `Bucket` (auto-encryption, lifecycle rules) |
| **L3** | Patterns | Multi-resource architectures composed from L2 constructs. | `ApplicationLoadBalancedFargateService` |

> **Key Points for the Exam:**
> - **L1 constructs** require you to specify every property—they mirror the CloudFormation resource specification exactly.
> - **L2 constructs** encode best practices (e.g., an S3 Bucket L2 construct enables encryption by default).
> - **L3 constructs** (patterns) create multiple resources and are opinionated about architecture.

### App Lifecycle

CDK apps go through these phases:

1. **Construct**: Your code instantiates constructs and wires them together
2. **Prepare**: Framework-level mutations (generally not user-visible)
3. **Validate**: Constructs validate their own configuration
4. **Synthesize**: The construct tree is synthesized into a CloudFormation template (`cdk.out/`)
5. **Deploy**: The CLI deploys the synthesized template via CloudFormation

### Assets

CDK assets are local files or Docker images that CDK uploads and references:

- **File assets**: Bundled into a zip, uploaded to the CDK bootstrap S3 bucket, and referenced in the template
- **Docker image assets**: Built locally, pushed to the CDK bootstrap ECR repository, and referenced in the template

### Context and Feature Flags

- **Context** (`cdk.context.json`): Cached values from context lookups (VPC IDs, AMI IDs). Committed to version control for reproducibility.
- **Feature flags** (`cdk.json`): Control CDK behavior changes between versions. Older apps can opt out of breaking changes.

### Bootstrapping

`cdk bootstrap` creates a `CDKToolkit` CloudFormation stack in the target account/region containing:

- S3 bucket for file assets and templates
- ECR repository for Docker image assets
- IAM roles for deployment (publish, deploy, lookup, file publishing)

**Cross-account bootstrapping**: Establish **trust relationships** by specifying `--trust <pipeline-account-id>` during bootstrap. This allows a CI/CD account to deploy into target accounts.

> **Key Points for the Exam:**
> - **Every account/region must be bootstrapped** before CDK can deploy to it.
> - Cross-account CDK deployments require the target account to be bootstrapped with `--trust` pointing to the deploying account.
> - The bootstrap stack creates IAM roles with specific trust policies—this is analogous to cross-account CodePipeline role setup.

### cdk.json and cdk.context.json

- `cdk.json`: Project configuration (app command, feature flags, context values)
- `cdk.context.json`: Cached context lookups. Should be committed to source control. `cdk context --clear` resets cached lookups.

### CDK Pipelines

CDK Pipelines is a high-level construct for building **self-mutating** CI/CD pipelines:

```typescript
const pipeline = new pipelines.CodePipeline(this, 'Pipeline', {
  synth: new pipelines.ShellStep('Synth', {
    input: pipelines.CodePipelineSource.codeCommit(repo, 'main'),
    commands: ['npm ci', 'npx cdk synth'],
  }),
});

pipeline.addStage(new MyApplicationStage(this, 'Staging'));
pipeline.addStage(new MyApplicationStage(this, 'Production'), {
  pre: [new pipelines.ManualApprovalStep('Approve')],
});
```

**Self-mutating**: The pipeline updates itself when you change the pipeline definition. The `UpdatePipeline` stage runs first, then the application stages.

**Stages**: Represent deployment environments. Each stage can contain multiple stacks.

### Testing

CDK supports two testing strategies:

- **Fine-grained assertions**: Assert that specific resources exist with specific properties (`Template.fromStack(stack).hasResourceProperties(...)`)
- **Snapshot testing**: Compare the synthesized template against a previously saved snapshot. Detects unintended changes.

### Aspects

Aspects apply operations across all constructs in a scope:

```typescript
class EncryptionChecker implements cdk.IAspect {
  visit(node: IConstruct) {
    if (node instanceof s3.Bucket && !node.encryptionKey) {
      Annotations.of(node).addError('Bucket must be encrypted');
    }
  }
}
Aspects.of(app).add(new EncryptionChecker());
```

Common use cases:
- Enforce tagging policies across all resources
- Validate that all S3 buckets are encrypted
- Add CloudWatch alarms to all Lambda functions

> **Key Points for the Exam:**
> - **Aspects** are the CDK equivalent of CloudFormation Hooks/Guard—they enforce policies during synthesis.
> - Aspects run during the **prepare** phase, before synthesis.

### Escape Hatches

When L2 constructs don't expose a needed CloudFormation property, use escape hatches to access the underlying L1 construct:

```typescript
const bucket = new s3.Bucket(this, 'MyBucket');
const cfnBucket = bucket.node.defaultChild as s3.CfnBucket;
cfnBucket.analyticsConfigurations = [{ id: 'Config', ... }];
```

You can also use `addOverride`, `addDeletionOverride`, and `addPropertyOverride` for targeted modifications.

---

## CloudFormation vs CDK: When to Use What

| Scenario | Recommendation |
|----------|---------------|
| Simple, declarative infrastructure | CloudFormation YAML/JSON |
| Complex logic, conditionals, loops | CDK (programming language power) |
| Compliance templates shared as-is | CloudFormation (no compilation needed) |
| Multi-stack applications with shared constructs | CDK (construct reuse, L3 patterns) |
| Cross-account CI/CD pipeline for infrastructure | CDK Pipelines |

---

## Summary: Top Exam Scenarios

1. **Stack stuck in `UPDATE_ROLLBACK_FAILED`**: Use `ContinueUpdateRollback` and skip problematic resources
2. **Deploy guardrails to all accounts in an OU**: Service-managed StackSets with auto-deployment
3. **Custom resource Lambda not responding**: Stack hangs for up to 1 hour—ensure `cfn-response` or manual response is sent
4. **Protect production database from replacement**: Use a stack policy denying `Update:Replace` on that resource
5. **Cross-account CDK deployment**: Bootstrap target accounts with `--trust`, use CDK Pipelines
6. **Detect manual changes to resources**: Use CloudFormation drift detection
7. **Dynamic secrets in templates**: Use `{{resolve:secretsmanager:...}}` dynamic references
8. **EC2 instances not signaling success**: Check `cfn-signal` is called, `CreationPolicy` timeout is sufficient, and the instance has internet access (for the signal endpoint)
9. **Enforce encryption on all CDK resources**: Use CDK Aspects
10. **Import existing resources into CloudFormation**: Create a change set of type IMPORT with resource identifiers
