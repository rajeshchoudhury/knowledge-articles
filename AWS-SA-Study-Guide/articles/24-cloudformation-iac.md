# CloudFormation & Infrastructure as Code

## Table of Contents

1. [CloudFormation Overview](#cloudformation-overview)
2. [Template Anatomy](#template-anatomy)
3. [Resources](#resources)
4. [Parameters](#parameters)
5. [Intrinsic Functions](#intrinsic-functions)
6. [Pseudo Parameters](#pseudo-parameters)
7. [Mappings and Conditions](#mappings-and-conditions)
8. [Change Sets](#change-sets)
9. [Nested Stacks vs Cross-Stack References](#nested-stacks-vs-cross-stack-references)
10. [StackSets](#stacksets)
11. [Drift Detection](#drift-detection)
12. [Custom Resources](#custom-resources)
13. [Helper Scripts](#helper-scripts)
14. [CreationPolicy and WaitCondition](#creationpolicy-and-waitcondition)
15. [Rollback and Stack Policies](#rollback-and-stack-policies)
16. [Service Role](#service-role)
17. [CloudFormation Registry and Modules](#cloudformation-registry-and-modules)
18. [AWS CDK](#aws-cdk)
19. [Terraform on AWS](#terraform-on-aws)
20. [AWS SAM](#aws-sam)
21. [CloudFormation vs Terraform vs CDK vs SAM Comparison](#cloudformation-vs-terraform-vs-cdk-vs-sam-comparison)
22. [Common Exam Scenarios](#common-exam-scenarios)

---

## CloudFormation Overview

### What is CloudFormation?

AWS CloudFormation is an **Infrastructure as Code (IaC)** service that allows you to model, provision, and manage AWS resources by defining them in template files. CloudFormation automates and standardizes resource provisioning.

### Key Benefits

- **Declarative**: Define WHAT you want, not HOW to create it
- **Reproducible**: Same template produces the same infrastructure every time
- **Version controlled**: Templates are text files that can be stored in Git
- **Dependency management**: CloudFormation determines the correct order to create resources
- **Rollback**: Automatic rollback on failure
- **Cost estimation**: Preview the cost of resources before creating them
- **Diagram**: CloudFormation Designer provides a visual representation

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Template** | JSON or YAML file defining resources |
| **Stack** | A collection of AWS resources created from a template |
| **Stack Events** | Log of actions during stack creation, update, or deletion |
| **Change Set** | Preview of proposed changes before applying |
| **StackSet** | Deploy stacks across multiple accounts and regions |

---

## Template Anatomy

A CloudFormation template has the following sections (only `Resources` is required):

```yaml
AWSTemplateFormatVersion: "2010-09-09"

Description: "A description of the template"

Metadata:
  # Additional information about the template

Parameters:
  # Input values provided at stack creation/update

Mappings:
  # Static key-value lookup tables

Conditions:
  # Conditional logic for resource creation

Transform:
  # Macros to process the template (e.g., AWS::Serverless, AWS::Include)

Resources:
  # AWS resources to create (REQUIRED - only mandatory section)

Outputs:
  # Values to return after stack creation
```

### Section Details

**AWSTemplateFormatVersion:**
- Always `"2010-09-09"` (only version available)
- Optional but recommended

**Description:**
- Text description of the template
- Must follow `AWSTemplateFormatVersion` if both are present
- Up to 1024 bytes

**Metadata:**
- Additional information about the template
- `AWS::CloudFormation::Designer` — Visual designer layout
- `AWS::CloudFormation::Interface` — Parameter grouping and ordering in the console
- `AWS::CloudFormation::Init` — Configuration for cfn-init (software installation, file creation)

**Transform:**
- `AWS::Serverless-2016-10-31` — Enables SAM (Serverless Application Model) syntax
- `AWS::Include` — Include template snippets from S3
- Custom macros — Lambda-backed template transformations

---

## Resources

### Overview

The Resources section is the **only required section** and defines the AWS resources to create.

### Resource Syntax

```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    DependsOn: MySecurityGroup
    DeletionPolicy: Retain
    UpdatePolicy:
      AutoScalingRollingUpdate:
        MaxBatchSize: 2
    UpdateReplacePolicy: Snapshot
    Properties:
      InstanceType: t3.micro
      ImageId: ami-0abcdef1234567890
      SecurityGroupIds:
        - !Ref MySecurityGroup
```

### Resource Attributes

**Type (Required):**
- Format: `AWS::<Service>::<Resource>`
- Examples: `AWS::EC2::Instance`, `AWS::S3::Bucket`, `AWS::Lambda::Function`
- Third-party resources: `<Organization>::<Service>::<Resource>` (from CloudFormation Registry)

**Properties:**
- Configuration specific to the resource type
- Some properties are required, others optional
- Reference other resources using `!Ref` or `!GetAtt`

### DependsOn

Explicitly specifies that one resource depends on another:

```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    DependsOn: MyRDSInstance
    Properties:
      # ...

  MyRDSInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      # ...
```

- CloudFormation creates the RDS instance first, then the EC2 instance
- CloudFormation automatically determines most dependencies through `!Ref` and `!GetAtt`
- Use `DependsOn` when there's an implicit dependency CloudFormation can't detect
- Can specify a single resource or a list of resources

### DeletionPolicy

Controls what happens to the resource when the stack is deleted:

| Policy | Description |
|--------|-------------|
| **Delete** | Default. Resource is deleted when the stack is deleted |
| **Retain** | Resource is kept (not deleted) when the stack is deleted. CloudFormation removes it from the stack but doesn't delete the actual resource |
| **Snapshot** | Creates a final snapshot before deletion. Supported for: EBS volumes, RDS instances, RDS clusters, Redshift clusters, Neptune, DocumentDB |

**Important:** `DeletionPolicy` only applies when the **stack** is deleted. It does NOT apply when a resource is removed from the template during a stack update (use `UpdateReplacePolicy` for that).

### UpdatePolicy

Controls how CloudFormation handles updates to specific resource types:

**AutoScalingRollingUpdate** (for Auto Scaling Groups):
```yaml
UpdatePolicy:
  AutoScalingRollingUpdate:
    MaxBatchSize: 2
    MinInstancesInService: 2
    PauseTime: PT10M
    WaitOnResourceSignals: true
    SuspendProcesses:
      - HealthCheck
      - ReplaceUnhealthy
```

**AutoScalingReplacingUpdate** (for Auto Scaling Groups):
```yaml
UpdatePolicy:
  AutoScalingReplacingUpdate:
    WillReplace: true
```
Creates a new ASG, waits for instances to be healthy, then deletes the old ASG (immutable update).

**AutoScalingScheduledAction** (for scheduled scaling actions during update):
```yaml
UpdatePolicy:
  AutoScalingScheduledAction:
    IgnoreUnmodifiedGroupSizeProperties: true
```

### UpdateReplacePolicy

Controls what happens to the original resource when it needs to be **replaced** during a stack update:

| Policy | Description |
|--------|-------------|
| **Delete** | Default. Old resource is deleted after replacement |
| **Retain** | Old resource is kept after replacement (orphaned) |
| **Snapshot** | Takes a snapshot of the old resource before deletion |

**Difference from DeletionPolicy:**
- `DeletionPolicy`: Applies when the **stack** is deleted
- `UpdateReplacePolicy`: Applies when a **resource is replaced** during stack update

---

## Parameters

### Overview

Parameters enable you to input custom values to your template at stack creation or update time, making templates reusable.

### Parameter Properties

```yaml
Parameters:
  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues:
      - t3.micro
      - t3.small
      - t3.medium
    Description: "EC2 instance type"
    ConstraintDescription: "Must be a valid T3 instance type"

  DatabasePassword:
    Type: String
    NoEcho: true
    MinLength: 8
    MaxLength: 64
    AllowedPattern: "[a-zA-Z0-9!@#$%^&*()_+=-]*"
    Description: "Database master password"

  VPCCidr:
    Type: String
    Default: "10.0.0.0/16"
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    ConstraintDescription: "Must be a valid CIDR block"

  SubnetId:
    Type: AWS::EC2::Subnet::Id
    Description: "Select a subnet"

  KeyPairName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: "Select an EC2 Key Pair"
```

### Parameter Types

**Standard Types:**
- `String` — Any string value
- `Number` — Integer or float
- `List<Number>` — Comma-separated list of numbers
- `CommaDelimitedList` — Comma-separated list of strings

**AWS-Specific Types:**
- `AWS::EC2::Instance::Id` — EC2 instance ID
- `AWS::EC2::Image::Id` — AMI ID
- `AWS::EC2::KeyPair::KeyName` — Key pair name
- `AWS::EC2::SecurityGroup::Id` — Security group ID
- `AWS::EC2::Subnet::Id` — Subnet ID
- `AWS::EC2::VPC::Id` — VPC ID
- `AWS::EC2::AvailabilityZone::Name` — AZ name
- `AWS::Route53::HostedZone::Id` — Hosted zone ID
- `List<AWS::EC2::Subnet::Id>` — List of subnet IDs
- `AWS::SSM::Parameter::Value<String>` — Resolve SSM parameter at deploy time

### Parameter Constraints

| Constraint | Description |
|-----------|-------------|
| `AllowedValues` | List of permitted values (dropdown in console) |
| `AllowedPattern` | Regex pattern the value must match |
| `MinLength` / `MaxLength` | String length constraints |
| `MinValue` / `MaxValue` | Numeric range constraints |
| `Default` | Default value if none provided |
| `NoEcho` | Mask the value in console/CLI output (for passwords) |
| `ConstraintDescription` | Custom error message when constraint is violated |

### SSM Parameter Type

Reference SSM Parameter Store values dynamically:

```yaml
Parameters:
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
```

This resolves the SSM parameter value at stack creation/update time.

---

## Intrinsic Functions

CloudFormation provides built-in functions for dynamic template logic.

### Ref

Returns the value of a parameter or the physical ID of a resource:

```yaml
!Ref MyParameter           # Returns parameter value
!Ref MyEC2Instance         # Returns instance ID (e.g., i-1234567890abcdef0)
!Ref MyS3Bucket            # Returns bucket name
!Ref MySecurityGroup       # Returns security group ID
```

### Fn::GetAtt

Returns the value of an attribute from a resource:

```yaml
!GetAtt MyEC2Instance.PrivateIp         # Returns private IP address
!GetAtt MyEC2Instance.PublicIp          # Returns public IP address
!GetAtt MyALB.DNSName                   # Returns ALB DNS name
!GetAtt MyRDSInstance.Endpoint.Address  # Returns RDS endpoint
!GetAtt MyLambda.Arn                    # Returns Lambda function ARN
!GetAtt MyS3Bucket.Arn                  # Returns S3 bucket ARN
!GetAtt MyS3Bucket.DomainName           # Returns bucket domain name
```

### Fn::Join

Joins values with a delimiter:

```yaml
!Join [ ":", [ "a", "b", "c" ] ]    # Returns "a:b:c"

!Join
  - "-"
  - - !Ref AWS::StackName
    - "web"
    - "server"
# Returns "my-stack-web-server"
```

### Fn::Sub

Substitutes variables in a string (preferred over Fn::Join for readability):

```yaml
!Sub "arn:aws:s3:::${MyBucket}/*"

!Sub
  - "https://${Domain}/api"
  - Domain: !GetAtt MyALB.DNSName

!Sub "arn:aws:ec2:${AWS::Region}:${AWS::AccountId}:instance/${MyEC2Instance}"
```

### Fn::Select

Selects a value from a list by index:

```yaml
!Select [ 0, [ "a", "b", "c" ] ]    # Returns "a"
!Select [ 1, !GetAZs "" ]            # Returns second AZ in the region
```

### Fn::Split

Splits a string into a list:

```yaml
!Split [ ",", "a,b,c" ]    # Returns ["a", "b", "c"]

# Combined with Select:
!Select [ 0, !Split [ ",", "a,b,c" ] ]    # Returns "a"
```

### Fn::FindInMap

Returns a value from a mapping:

```yaml
Mappings:
  RegionMap:
    us-east-1:
      AMI: ami-12345678
      InstanceType: t3.micro
    eu-west-1:
      AMI: ami-87654321
      InstanceType: t3.small

Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !FindInMap [ RegionMap, !Ref "AWS::Region", AMI ]
      InstanceType: !FindInMap [ RegionMap, !Ref "AWS::Region", InstanceType ]
```

### Fn::If

Returns one value if a condition is true, another if false:

```yaml
Conditions:
  IsProduction: !Equals [ !Ref Environment, "prod" ]

Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !If [ IsProduction, "m5.large", "t3.micro" ]
```

### Fn::ImportValue

Imports a value exported by another stack:

```yaml
# Stack A (exports):
Outputs:
  VPCId:
    Value: !Ref MyVPC
    Export:
      Name: SharedVPCId

# Stack B (imports):
Resources:
  MySubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !ImportValue SharedVPCId
```

### Fn::GetAZs

Returns a list of Availability Zones for a region:

```yaml
!GetAZs ""                     # Current region's AZs
!GetAZs "us-east-1"            # us-east-1 AZs

# Common pattern: first AZ
!Select [ 0, !GetAZs "" ]     # Returns first AZ (e.g., us-east-1a)
```

### Fn::Cidr

Returns an array of CIDR address blocks:

```yaml
!Cidr [ "10.0.0.0/16", 6, 8 ]
# Returns 6 CIDR blocks of /24 (32-8=24) from the 10.0.0.0/16 range
# ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
```

### Fn::Base64

Encodes a string to Base64 (commonly used for EC2 UserData):

```yaml
UserData:
  Fn::Base64: !Sub |
    #!/bin/bash
    yum update -y
    yum install -y httpd
    echo "Hello from ${AWS::StackName}" > /var/www/html/index.html
    systemctl start httpd
```

### Fn::Transform

Specifies a macro to process the template:

```yaml
Transform:
  Name: AWS::Include
  Parameters:
    Location: s3://my-bucket/my-snippet.yaml
```

---

## Pseudo Parameters

Pseudo parameters are predefined by CloudFormation and available in any template:

| Pseudo Parameter | Value |
|-----------------|-------|
| `AWS::AccountId` | The AWS account ID (e.g., `123456789012`) |
| `AWS::Region` | The region where the stack is created (e.g., `us-east-1`) |
| `AWS::StackName` | The name of the stack |
| `AWS::StackId` | The ARN of the stack |
| `AWS::NoValue` | Used with `Fn::If` to remove a property conditionally |
| `AWS::URLSuffix` | The domain suffix (e.g., `amazonaws.com`, or `amazonaws.com.cn` for China) |
| `AWS::Partition` | The partition (e.g., `aws`, `aws-cn`, `aws-us-gov`) |
| `AWS::NotificationARNs` | List of notification ARNs for the stack |

**AWS::NoValue Usage:**
```yaml
Properties:
  DBSnapshotIdentifier: !If
    - UseSnapshot
    - !Ref SnapshotId
    - !Ref AWS::NoValue    # Removes the property entirely if condition is false
```

---

## Mappings and Conditions

### Mappings

Mappings are fixed key-value lookup tables defined at template design time:

```yaml
Mappings:
  EnvironmentConfig:
    prod:
      InstanceType: m5.large
      MinSize: "2"
      MaxSize: "10"
    staging:
      InstanceType: t3.medium
      MinSize: "1"
      MaxSize: "4"
    dev:
      InstanceType: t3.micro
      MinSize: "1"
      MaxSize: "2"

  RegionAMI:
    us-east-1:
      HVM64: ami-0abcdef1234567890
      HVM32: ami-0987654321abcdef0
    us-west-2:
      HVM64: ami-0fedcba0987654321
      HVM32: ami-0123456789abcdef0
```

**Accessing Mappings:**
```yaml
!FindInMap [ EnvironmentConfig, !Ref Environment, InstanceType ]
!FindInMap [ RegionAMI, !Ref "AWS::Region", HVM64 ]
```

**When to Use Mappings vs Parameters:**
- **Mappings**: Known values that don't change per deployment (AMI IDs per region, environment configs)
- **Parameters**: User-provided values that vary per deployment

### Conditions

Conditions control whether resources are created or properties are set:

```yaml
Conditions:
  IsProduction: !Equals [ !Ref Environment, "prod" ]
  IsUSEast1: !Equals [ !Ref "AWS::Region", "us-east-1" ]
  CreateProdResources: !And
    - !Condition IsProduction
    - !Condition IsUSEast1

Resources:
  ProdOnlyBucket:
    Type: AWS::S3::Bucket
    Condition: IsProduction    # Only created if IsProduction is true

  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !If [ IsProduction, "m5.large", "t3.micro" ]
      Monitoring: !If [ IsProduction, true, false ]
```

**Condition Functions:**

| Function | Description |
|----------|-------------|
| `Fn::Equals` | Returns true if two values are equal |
| `Fn::And` | Returns true if ALL conditions are true (2–10 conditions) |
| `Fn::Or` | Returns true if ANY condition is true (2–10 conditions) |
| `Fn::Not` | Returns the inverse of a condition |
| `Fn::If` | Returns one value if true, another if false |

---

## Change Sets

### Overview

Change Sets let you **preview how proposed changes** to a stack might impact running resources before applying them.

### Workflow

1. **Create Change Set**: Submit the updated template or parameter changes
2. **Review Change Set**: CloudFormation shows what will be added, modified, or removed
3. **Execute Change Set**: Apply the changes (or delete the change set to discard)

### Change Types

| Action | Description |
|--------|-------------|
| **Add** | New resource will be created |
| **Modify** | Existing resource will be updated (in-place or replacement) |
| **Remove** | Existing resource will be deleted |

**Replacement Indicator:**
- **True**: Resource will be replaced (new physical resource ID)
- **False**: Resource will be updated in-place
- **Conditional**: May or may not require replacement depending on the property

### Key Points

- Change sets do NOT tell you if the update will succeed
- Creating a change set doesn't make any changes
- Multiple change sets can exist for a stack simultaneously
- Use for production updates to understand impact before applying
- Can be created via Console, CLI, or SDK

---

## Nested Stacks vs Cross-Stack References

### Nested Stacks

A nested stack is a stack created as part of another stack (parent stack):

```yaml
Resources:
  VPCStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://s3.amazonaws.com/mybucket/vpc-template.yaml
      Parameters:
        VPCCidr: "10.0.0.0/16"

  AppStack:
    Type: AWS::CloudFormation::Stack
    DependsOn: VPCStack
    Properties:
      TemplateURL: https://s3.amazonaws.com/mybucket/app-template.yaml
      Parameters:
        VPCId: !GetAtt VPCStack.Outputs.VPCId
        SubnetId: !GetAtt VPCStack.Outputs.SubnetId
```

**Characteristics:**
- Template stored in S3 and referenced via URL
- Parent stack passes parameters to child stacks
- Child stacks return values via Outputs
- Lifecycle tied to parent stack (delete parent → delete all children)
- Updates to nested stacks must be done through the parent
- Good for **component reuse** (VPC template, security template, etc.)

### Cross-Stack References (Export/ImportValue)

Share values between independent stacks using Exports and ImportValue:

```yaml
# Stack A: Network Stack
Outputs:
  VPCId:
    Value: !Ref MyVPC
    Export:
      Name: !Sub "${AWS::StackName}-VPCId"

  PublicSubnetId:
    Value: !Ref PublicSubnet
    Export:
      Name: !Sub "${AWS::StackName}-PublicSubnetId"
```

```yaml
# Stack B: Application Stack
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      SubnetId: !ImportValue "NetworkStack-PublicSubnetId"
```

**Characteristics:**
- Stacks are independent with separate lifecycles
- Export names must be **unique within a region** in the same account
- Cannot delete a stack that has exports being imported by other stacks
- Good for **shared infrastructure** (VPC, subnets, security groups)

### Nested Stacks vs Cross-Stack References

| Feature | Nested Stacks | Cross-Stack References |
|---------|--------------|----------------------|
| **Relationship** | Parent-child (hierarchical) | Independent (peer-to-peer) |
| **Lifecycle** | Tied to parent stack | Independent lifecycles |
| **Reusability** | Template reuse (same VPC template in multiple parent stacks) | Value sharing across stacks |
| **Updates** | Update through parent | Update independently |
| **Deletion** | Delete parent deletes all children | Cannot delete exporting stack while imported |
| **Use Case** | Component reuse | Shared infrastructure values |

---

## StackSets

### Overview

CloudFormation StackSets extend the functionality of stacks by enabling you to create, update, or delete stacks across **multiple accounts and regions** with a single operation.

### Key Concepts

**Administrator Account:** The account from which you create and manage StackSets.

**Target Accounts:** The accounts where stacks are created from the StackSet.

**Stack Instances:** A reference to a stack in a target account and region. A stack instance can exist without a stack (if creation failed).

### Permission Models

**Self-Managed Permissions:**
- You create IAM roles manually in the administrator and target accounts
- Administrator account: `AWSCloudFormationStackSetAdministrationRole` (trusts CloudFormation)
- Target accounts: `AWSCloudFormationStackSetExecutionRole` (trusts the administrator account)
- More control but more setup

**Service-Managed Permissions:**
- Integrates with **AWS Organizations**
- CloudFormation automatically creates the necessary roles
- Can deploy to organizational units (OUs) — automatically includes new accounts added to the OU
- **Automatic deployment**: New accounts in the OU get the stack automatically
- Recommended approach for Organizations

### Deployment Options

**Deployment Order:**
- Deploy to regions sequentially or in parallel
- Specify failure tolerance (number or percentage of accounts/regions that can fail)
- Specify maximum concurrent accounts/regions

**Deployment Targets:**
- Specific account IDs (self-managed)
- Organizational Units (service-managed)
- Entire organization (service-managed)

### Key Exam Points

- StackSets for **multi-account, multi-region** deployments
- Service-managed with Organizations is the recommended approach
- Auto-deployment: New accounts in an OU automatically get the stack
- Use cases: Deploy Config rules, CloudTrail, GuardDuty, security baselines across all accounts
- Cannot use nested stacks within StackSets

---

## Drift Detection

### Overview

CloudFormation Drift Detection identifies resources that have been changed **outside of CloudFormation** (manual changes, CLI commands, SDK calls, other tools).

### How It Works

1. Initiate drift detection on a stack or specific resource
2. CloudFormation compares the current configuration with the expected configuration from the template
3. Results show:
   - **IN_SYNC**: Resource matches the template
   - **MODIFIED**: Resource has been changed (shows expected vs actual values)
   - **DELETED**: Resource has been deleted
   - **NOT_CHECKED**: Drift detection not supported for this resource type

### Key Points

- Not all resource types support drift detection
- Drift detection is **read-only** — it doesn't fix drift
- To fix drift: Update the template to match current state, or update the resource to match the template
- Can be run on individual resources or entire stacks
- StackSets support drift detection across all stack instances
- **Import**: Can import existing resources into a stack to manage them with CloudFormation

---

## Custom Resources

### Overview

Custom resources enable you to write custom provisioning logic that CloudFormation runs during stack operations (create, update, delete). Use custom resources for anything CloudFormation doesn't natively support.

### Lambda-Backed Custom Resources

```yaml
Resources:
  MyCustomResource:
    Type: Custom::MyFunction
    Properties:
      ServiceToken: !GetAtt MyLambdaFunction.Arn
      Param1: "value1"
      Param2: "value2"

  MyLambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.12
      Handler: index.handler
      Code:
        ZipFile: |
          import cfnresponse
          import boto3
          def handler(event, context):
              if event['RequestType'] == 'Create':
                  # Do something on create
                  cfnresponse.send(event, context, cfnresponse.SUCCESS, {"Result": "Created"})
              elif event['RequestType'] == 'Update':
                  # Do something on update
                  cfnresponse.send(event, context, cfnresponse.SUCCESS, {"Result": "Updated"})
              elif event['RequestType'] == 'Delete':
                  # Do something on delete
                  cfnresponse.send(event, context, cfnresponse.SUCCESS, {"Result": "Deleted"})
```

**How It Works:**
1. CloudFormation sends a request (Create/Update/Delete) to the Lambda function
2. Lambda processes the request and performs custom actions
3. Lambda sends a response back to CloudFormation (SUCCESS or FAILED) via a pre-signed S3 URL
4. CloudFormation proceeds based on the response

### SNS-Backed Custom Resources

- CloudFormation sends the request to an SNS topic instead of Lambda
- An external process subscribes to the topic and handles the request
- Use case: When the custom logic runs outside of AWS (on-premises system)

### Common Use Cases

- Empty an S3 bucket before stack deletion (CloudFormation can't delete non-empty buckets)
- Fetch the latest AMI ID from a custom source
- Create resources in a third-party system
- Run database migrations during deployment
- Register DNS records in an external DNS provider

---

## Helper Scripts

CloudFormation provides helper scripts for EC2 instances to bootstrap configuration:

### cfn-init

Reads metadata from `AWS::CloudFormation::Init` and configures the instance:

```yaml
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Metadata:
      AWS::CloudFormation::Init:
        config:
          packages:
            yum:
              httpd: []
              php: []
          files:
            /var/www/html/index.html:
              content: "<h1>Hello World</h1>"
              mode: "000644"
              owner: "apache"
              group: "apache"
          services:
            sysvinit:
              httpd:
                enabled: true
                ensureRunning: true
          commands:
            01_configure:
              command: "echo 'configured' > /tmp/configured"
    Properties:
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash -xe
          yum update -y aws-cfn-bootstrap
          /opt/aws/bin/cfn-init -s ${AWS::StackName} -r MyInstance --region ${AWS::Region}
          /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource MyInstance --region ${AWS::Region}
```

**AWS::CloudFormation::Init Sections:**

| Section | Description |
|---------|-------------|
| `packages` | Install packages (yum, apt, rpm, msi, pip) |
| `groups` | Create Linux groups |
| `users` | Create Linux users |
| `sources` | Download and extract archives |
| `files` | Create files with specified content, permissions |
| `commands` | Execute commands (run in alphabetical order) |
| `services` | Configure and manage services |

### cfn-signal

Signals CloudFormation that the instance has been successfully configured:

- Used with **CreationPolicy** or **WaitCondition**
- Sends SUCCESS or FAILURE signal
- Includes exit code from cfn-init

### cfn-hup

A daemon that checks for updates to metadata and runs specified hooks:

- Runs continuously on the instance
- Periodically checks for changes to `AWS::CloudFormation::Init` metadata
- When changes are detected, runs the specified actions (e.g., re-run cfn-init)
- Enables **live updates** to instance configuration without replacing the instance

**Configuration files:**
- `/etc/cfn/cfn-hup.conf` — Main configuration (stack name, region, polling interval)
- `/etc/cfn/hooks.d/cfn-auto-reloader.conf` — Hook that triggers cfn-init on metadata change

### cfn-get-metadata

Retrieves metadata from a resource in the template:

- Standalone tool to fetch metadata
- Less commonly used than cfn-init

---

## CreationPolicy and WaitCondition

### CreationPolicy

Prevents CloudFormation from marking a resource as CREATE_COMPLETE until it receives a specified number of success signals:

```yaml
Resources:
  MyAutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    CreationPolicy:
      ResourceSignal:
        Count: 3          # Wait for 3 success signals
        Timeout: PT15M    # Wait up to 15 minutes
    Properties:
      MinSize: 3
      MaxSize: 6
      # ...
```

- **Count**: Number of signals to wait for
- **Timeout**: Maximum wait time (ISO 8601 duration format: PT15M = 15 minutes)
- Signals sent via `cfn-signal`
- If timeout expires before receiving all signals, stack creation fails and rolls back

### WaitCondition

Similar to CreationPolicy but more flexible — can be used with resources that don't directly support CreationPolicy:

```yaml
Resources:
  WaitHandle:
    Type: AWS::CloudFormation::WaitConditionHandle

  WaitCondition:
    Type: AWS::CloudFormation::WaitCondition
    DependsOn: MyEC2Instance
    Properties:
      Handle: !Ref WaitHandle
      Timeout: 600        # 10 minutes
      Count: 1            # Number of signals

  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          # ... configuration ...
          /opt/aws/bin/cfn-signal -e 0 '${WaitHandle}'
```

**CreationPolicy vs WaitCondition:**
- **CreationPolicy**: Simpler, directly on the resource, preferred for EC2 and ASG
- **WaitCondition**: More flexible, can receive data from signals, can be used with any resource

---

## Rollback and Stack Policies

### Rollback Behavior

**Stack Creation Failure:**
- Default: Everything rolls back (all resources deleted)
- Option: **Disable rollback** (`--disable-rollback` / `DisableRollback: true`) — failed resources remain for debugging
- Option: **Preserve successfully created resources** (`--on-failure DO_NOTHING`)

**Stack Update Failure:**
- Default: Stack rolls back to the previous known good state
- If rollback itself fails: Stack enters `UPDATE_ROLLBACK_FAILED` state
- Recovery: Fix the issue, then **continue rollback** (`ContinueUpdateRollback` API)

### Rollback Triggers

Monitor CloudWatch Alarms during stack operations and roll back if alarms fire:

```yaml
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --rollback-configuration \
    RollbackTriggers=[{Arn=arn:aws:cloudwatch:us-east-1:123456789012:alarm:my-alarm,Type=AWS::CloudWatch::Alarm}] \
    MonitoringTimeInMinutes=10
```

- Specify up to 5 CloudWatch Alarms
- Monitoring period: 0–180 minutes after stack operation completes
- If any alarm triggers during monitoring, the stack rolls back

### Stack Policies

Stack policies protect specific resources from being **updated** or **deleted** during stack updates:

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

**Actions:**
- `Update:Modify` — In-place updates
- `Update:Replace` — Resource replacement
- `Update:Delete` — Resource deletion
- `Update:*` — All update actions

**Key Points:**
- Stack policy protects ALL resources by default after it's set (implicit deny)
- Must explicitly allow updates in the policy
- Can be temporarily overridden during a stack update
- Once set, a stack policy cannot be removed (only updated)

---

## Service Role

A **Service Role** is an IAM role that CloudFormation assumes to create, update, and delete resources on your behalf:

- Without a service role: CloudFormation uses the **caller's permissions**
- With a service role: CloudFormation uses the **role's permissions**
- Use case: Allow users to create stacks without giving them direct resource permissions
- The user only needs `iam:PassRole` and `cloudformation:*` permissions
- The service role needs permissions to create/update/delete the resources in the template

```yaml
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --role-arn arn:aws:iam::123456789012:role/CloudFormationServiceRole
```

---

## CloudFormation Registry and Modules

### CloudFormation Registry

The Registry is a catalog of **resource types** (AWS, third-party, and custom) available for use in templates:

- **Public extensions**: AWS resource types, third-party types from publishers
- **Private extensions**: Custom types you develop and register
- **Activated extensions**: Extensions you've enabled in your account/region
- Third-party types: Datadog monitors, MongoDB Atlas clusters, Cloudflare DNS records, etc.

### CloudFormation Modules

Modules are reusable, encapsulated template fragments:

- Package common infrastructure patterns as modules
- Register modules in the CloudFormation Registry
- Use modules like any other resource type
- Modules support parameters and can output values
- Versioned and shareable across accounts

---

## AWS CDK

### Overview

The AWS Cloud Development Kit (CDK) is an **open-source framework** that lets you define cloud infrastructure using familiar programming languages.

### Supported Languages

Python, TypeScript, JavaScript, Java, C#/.NET, Go

### Key Concepts

**Constructs:**
Constructs are the building blocks of CDK applications, organized in three levels:

| Level | Description | Example |
|-------|-------------|---------|
| **L1 (CloudFormation Resources)** | Direct 1:1 mapping to CloudFormation resources. Prefixed with `Cfn` | `CfnBucket`, `CfnInstance` |
| **L2 (Curated Constructs)** | AWS-written constructs with sensible defaults and convenience methods | `Bucket`, `Function`, `Table` |
| **L3 (Patterns)** | Multi-resource patterns that implement common architectures | `LambdaRestApi`, `ApplicationLoadBalancedFargateService` |

**CDK App Structure:**
```
App
 └── Stack(s)
      └── Construct(s)
           └── Resource(s)
```

### CDK Workflow

1. **Write**: Define infrastructure in your programming language
2. **cdk synth**: Synthesize to CloudFormation template (YAML/JSON)
3. **cdk diff**: Compare deployed stack with current code
4. **cdk deploy**: Deploy the stack (uses CloudFormation under the hood)
5. **cdk destroy**: Delete the stack

### CDK Bootstrap

Before first deployment, you must **bootstrap** the environment:
- `cdk bootstrap aws://ACCOUNT_ID/REGION`
- Creates an S3 bucket for CDK assets (templates, Lambda code)
- Creates IAM roles for CDK deployments
- One-time operation per account per region

### Key Exam Points

- CDK **synthesizes to CloudFormation** — it's an abstraction layer on top of CloudFormation
- L2 constructs provide sensible defaults (e.g., encryption enabled by default)
- CDK is great for developers who prefer code over YAML/JSON
- CDK has its own testing framework for unit testing infrastructure

---

## Terraform on AWS

### Overview

Terraform (by HashiCorp) is a **multi-cloud** IaC tool that can manage AWS resources alongside resources in other cloud providers.

### Key Concepts

**Providers:**
- AWS provider configures Terraform to interact with AWS
- Supports all AWS services
- Provider version management

**State Management on AWS:**

| Component | Purpose |
|-----------|---------|
| **S3 Backend** | Store Terraform state file remotely in S3 |
| **DynamoDB Lock Table** | State locking to prevent concurrent modifications |
| **Encryption** | S3 encryption (SSE-S3 or SSE-KMS) for state file |
| **Versioning** | S3 versioning for state file history |

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

**Terraform Workflow:**
1. `terraform init` — Initialize providers and backend
2. `terraform plan` — Preview changes (like CloudFormation change sets)
3. `terraform apply` — Apply changes
4. `terraform destroy` — Destroy all managed resources

### Key Exam Points

- Terraform is **NOT an AWS-native** service
- Multi-cloud advantage: Manage AWS, Azure, GCP, and other providers
- State file management is critical — use S3 + DynamoDB
- Not deeply tested on SAA-C03, but understanding the comparison is important

---

## AWS SAM

### Overview

AWS Serverless Application Model (SAM) is an **extension of CloudFormation** specifically designed for serverless applications.

### Key Features

**SAM Template:**
- Simplified syntax for serverless resources
- `Transform: AWS::Serverless-2016-10-31` enables SAM syntax
- Translates to standard CloudFormation at deployment

**SAM Resource Types:**

| SAM Type | CloudFormation Equivalent |
|----------|--------------------------|
| `AWS::Serverless::Function` | Lambda + IAM Role + API Gateway + EventSource Mapping |
| `AWS::Serverless::Api` | API Gateway REST API |
| `AWS::Serverless::HttpApi` | API Gateway HTTP API |
| `AWS::Serverless::SimpleTable` | DynamoDB table |
| `AWS::Serverless::LayerVersion` | Lambda layer |
| `AWS::Serverless::Application` | Nested application (SAR) |
| `AWS::Serverless::StateMachine` | Step Functions state machine |

**SAM CLI:**

| Command | Description |
|---------|-------------|
| `sam init` | Initialize a new SAM project |
| `sam build` | Build the application |
| `sam local invoke` | Invoke Lambda locally |
| `sam local start-api` | Start local API Gateway |
| `sam local start-lambda` | Start local Lambda endpoint |
| `sam deploy` | Deploy to AWS (wraps CloudFormation deploy) |
| `sam logs` | Fetch and tail Lambda function logs |
| `sam validate` | Validate SAM template |

### Key Exam Points

- SAM is an **extension of CloudFormation** (not a replacement)
- SAM templates are transformed into CloudFormation templates
- SAM CLI enables **local testing** of serverless applications
- SAM is for **serverless only** — use CloudFormation or CDK for broader infrastructure

---

## CloudFormation vs Terraform vs CDK vs SAM Comparison

| Feature | CloudFormation | Terraform | CDK | SAM |
|---------|---------------|-----------|-----|-----|
| **Language** | YAML/JSON | HCL | Python, TypeScript, Java, C#, Go | YAML (extended CloudFormation) |
| **Cloud Support** | AWS only | Multi-cloud | AWS only (synthesizes to CFN) | AWS only (serverless focused) |
| **State Management** | Managed by AWS | User-managed (S3 + DynamoDB) | Managed by AWS (uses CFN) | Managed by AWS (uses CFN) |
| **Learning Curve** | Medium (YAML) | Medium (HCL) | Low (familiar languages) | Low (simplified YAML) |
| **Resource Coverage** | All AWS resources | Most AWS resources | All AWS resources (via CFN) | Serverless resources only |
| **Local Testing** | No | No | Limited | Yes (sam local) |
| **Rollback** | Automatic | Manual (terraform state) | Automatic (uses CFN) | Automatic (uses CFN) |
| **Drift Detection** | Yes | `terraform plan` | Yes (uses CFN) | Yes (uses CFN) |
| **Multi-Account** | StackSets | Workspaces, multiple providers | Multiple stacks | Limited |
| **Cost** | Free | Free (open source) / Paid (Cloud) | Free | Free |
| **Best For** | AWS-native IaC | Multi-cloud, existing Terraform teams | Developers preferring code | Serverless applications |

---

## Common Exam Scenarios

### Scenario 1: Protect Critical Resources During Updates

**Question**: A production RDS database must not be replaced or deleted during CloudFormation stack updates.

**Answer**: Use a **Stack Policy** that denies `Update:Replace` and `Update:Delete` on the RDS resource. Additionally, set `DeletionPolicy: Snapshot` on the RDS resource to create a final snapshot if the stack is ever deleted. Set `UpdateReplacePolicy: Snapshot` for protection during updates that require replacement.

### Scenario 2: Deploy Infrastructure Across 50 Accounts

**Question**: A company needs to deploy the same Config rules, CloudTrail trail, and GuardDuty configuration across all 50 accounts in their organization.

**Answer**: Use **CloudFormation StackSets** with **service-managed permissions** (AWS Organizations integration). Enable **auto-deployment** so new accounts added to the OU automatically receive the stack. Service-managed permissions automatically create the required roles.

### Scenario 3: Wait for EC2 Instance Configuration

**Question**: After launching an EC2 instance, CloudFormation should wait until the application is fully configured before marking the resource as complete.

**Answer**: Use **CreationPolicy** with **cfn-signal**. In the UserData script, run cfn-init for configuration, then cfn-signal to send a success/failure signal. Set a timeout in the CreationPolicy. If the signal isn't received within the timeout, the stack creation fails and rolls back.

### Scenario 4: Reusable Infrastructure Components

**Question**: A team has a standard VPC template used across multiple applications. How to reuse it efficiently?

**Answer**: Use **Nested Stacks**. Store the VPC template in S3 and reference it from parent templates using `AWS::CloudFormation::Stack`. Pass parameters for customization (CIDR blocks, AZ count). Parent stacks get VPC outputs via `!GetAtt VPCStack.Outputs.VPCId`.

### Scenario 5: Share VPC ID Across Independent Stacks

**Question**: Multiple independent application stacks need access to the VPC ID and subnet IDs from a network stack.

**Answer**: Use **Cross-Stack References** with Export/ImportValue. The network stack exports VPC ID and subnet IDs using the `Export` property in Outputs. Application stacks import these values using `!ImportValue`. This allows independent lifecycle management of each stack.

### Scenario 6: Custom Logic During Stack Operations

**Question**: CloudFormation needs to empty an S3 bucket before deleting it (CloudFormation can't delete non-empty buckets).

**Answer**: Create a **Custom Resource** backed by a Lambda function. On Delete event, the Lambda function lists and deletes all objects in the bucket. After the custom resource succeeds, CloudFormation deletes the bucket. The Lambda function sends a cfnresponse SUCCESS/FAILED signal back.

### Scenario 7: Detect Manual Configuration Changes

**Question**: Resources managed by CloudFormation are being modified manually, causing issues. How to detect this?

**Answer**: Use **CloudFormation Drift Detection** to identify resources that have been modified outside of CloudFormation. Run drift detection periodically. Results show expected vs actual configuration for each drifted resource. To prevent drift, use **Stack Policies** and IAM policies that restrict direct resource modification.

### Scenario 8: Serverless Application Deployment

**Question**: A team is building a serverless application with Lambda, API Gateway, and DynamoDB and wants simplified template syntax with local testing.

**Answer**: Use **AWS SAM**. SAM provides simplified resource types (`AWS::Serverless::Function`, `AWS::Serverless::Api`, `AWS::Serverless::SimpleTable`). SAM CLI enables local testing with `sam local invoke` and `sam local start-api`. SAM templates are transformed into CloudFormation templates at deployment.

### Scenario 9: Multi-Cloud Infrastructure Management

**Question**: A company uses AWS and Azure and wants a single IaC tool to manage both.

**Answer**: Use **Terraform**. Terraform supports multiple providers (AWS, Azure, GCP, etc.) with a unified workflow. Store state in S3 with DynamoDB locking for the AWS portion. This is NOT a CloudFormation use case — CloudFormation is AWS-only.

### Scenario 10: Rolling Update for Auto Scaling Group

**Question**: An ASG needs to update instances gradually without downtime when the launch template changes.

**Answer**: Use **UpdatePolicy** with `AutoScalingRollingUpdate`. Set `MinInstancesInService` to maintain capacity during the update. Set `MaxBatchSize` to control how many instances update at once. Enable `WaitOnResourceSignals` with `PauseTime` to wait for instances to signal success before continuing.

---

## Key Takeaways for the Exam

1. **Resources** is the ONLY required section in a CloudFormation template
2. **DeletionPolicy**: Delete (default), Retain, Snapshot — applies when STACK is deleted
3. **UpdateReplacePolicy**: Applies when RESOURCE is replaced during update
4. **Parameters**: Use constraints (AllowedValues, AllowedPattern) for input validation; NoEcho for secrets
5. **!Ref** returns resource ID; **!GetAtt** returns resource attributes
6. **Fn::Sub** is preferred over Fn::Join for string construction
7. **FindInMap** for static lookups; **Conditions** for conditional resource creation
8. **Change Sets**: Preview changes before executing (doesn't guarantee success)
9. **Nested Stacks**: Component reuse (parent-child lifecycle)
10. **Cross-Stack References**: Value sharing (Export/ImportValue, independent lifecycles)
11. **StackSets**: Multi-account, multi-region deployment; service-managed with Organizations
12. **Drift Detection**: Identifies out-of-band changes; doesn't fix them
13. **Custom Resources**: Lambda-backed for unsupported resources or custom logic
14. **cfn-init + cfn-signal + CreationPolicy**: Bootstrap EC2 and wait for completion
15. **Stack Policies**: Protect resources from accidental update/replacement
16. **Service Role**: Allows users to create stacks without direct resource permissions
17. **CDK** synthesizes to CloudFormation; **SAM** extends CloudFormation for serverless
