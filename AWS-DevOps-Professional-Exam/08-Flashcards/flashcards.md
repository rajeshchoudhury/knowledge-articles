# AWS DevOps Engineer Professional (DOP-C02) Flashcards

> **250+ flashcards** organized by exam domain. Use these for active recall and spaced repetition.

---

## Domain 1: SDLC Automation (Cards 1–50)

---
**Card #1** | Domain: 1
**Q:** What are the four stage types in AWS CodePipeline?
**A:** Source, Build, Test, and Deploy. A pipeline must have at least two stages and the first must be a Source stage.
---

---
**Card #2** | Domain: 1
**Q:** What is the difference between CodePipeline V1 and V2 pipeline types?
**A:** V2 supports triggers (push-based via EventBridge), pipeline-level variables, Git tags as triggers, and improved execution modes (QUEUED, PARALLEL). V1 uses polling or CloudWatch Events and only supports SUPERSEDED mode.
---

---
**Card #3** | Domain: 1
**Q:** What are the three execution modes in CodePipeline V2?
**A:** **SUPERSEDED** (default V1 — newer execution replaces in-progress), **QUEUED** (executions run in order), **PARALLEL** (executions run concurrently without waiting).
---

---
**Card #4** | Domain: 1
**Q:** How do you implement cross-account deployments in CodePipeline?
**A:** Use a cross-account IAM role in the target account that the pipeline account assumes. The artifact bucket must have a bucket policy allowing the target account, and the KMS key policy must grant access to the target account's role.
---

---
**Card #5** | Domain: 1
**Q:** What are the four phases in a CodeBuild buildspec.yml?
**A:** **install** (install dependencies), **pre_build** (pre-build commands like login to ECR), **build** (actual build commands), **post_build** (post-build commands like push Docker images). Each phase has `commands` and optional `finally` blocks.
---

---
**Card #6** | Domain: 1
**Q:** How does CodeBuild caching work and what types are available?
**A:** Two cache types: **S3 caching** (stores cache in S3 bucket, good for dependencies) and **Local caching** (caches on the build host — supports source, Docker layer, and custom caching). Local caching requires the build project to use the same host for subsequent builds.
---

---
**Card #7** | Domain: 1
**Q:** What is the purpose of the `artifacts` section in a buildspec.yml?
**A:** It defines which files from the build are uploaded to the output artifact location (S3). You specify `files` (with glob patterns), `base-directory`, `discard-paths`, and `name`.
---

---
**Card #8** | Domain: 1
**Q:** Name the three compute platforms supported by AWS CodeDeploy.
**A:** **EC2/On-Premises**, **AWS Lambda**, and **Amazon ECS**.
---

---
**Card #9** | Domain: 1
**Q:** What is the correct order of CodeDeploy lifecycle hooks for EC2/On-Premises (in-place deployment)?
**A:** ApplicationStop → DownloadBundle → BeforeInstall → Install → AfterInstall → ApplicationStart → ValidateService. Optional hooks: BeforeBlockTraffic, BlockTraffic, AfterBlockTraffic (if using a load balancer).
---

---
**Card #10** | Domain: 1
**Q:** What deployment types does CodeDeploy support for ECS?
**A:** **Blue/Green only.** CodeDeploy shifts traffic from the original (blue) task set to the replacement (green) task set. Traffic can be shifted using Canary, Linear, or All-at-once configurations.
---

---
**Card #11** | Domain: 1
**Q:** What are the lifecycle hooks for a CodeDeploy Lambda deployment?
**A:** **BeforeAllowTraffic** → AllowTraffic → **AfterAllowTraffic**. Only BeforeAllowTraffic and AfterAllowTraffic are hooks you can run custom functions in.
---

---
**Card #12** | Domain: 1
**Q:** What are the lifecycle hooks for a CodeDeploy ECS deployment?
**A:** BeforeInstall → Install → AfterInstall → AllowTestTraffic → **AfterAllowTestTraffic** → BeforeAllowTraffic → AllowTraffic → **AfterAllowTraffic**.
---

---
**Card #13** | Domain: 1
**Q:** What file does CodeDeploy use and what sections does it contain for EC2?
**A:** **appspec.yml** — contains `version`, `os` (linux/windows), `files` (source/destination mappings), `permissions`, and `hooks` (lifecycle event scripts with location, timeout, and runas).
---

---
**Card #14** | Domain: 1
**Q:** How does CodeDeploy automatic rollback work?
**A:** You can configure rollback when a deployment fails or when a CloudWatch alarm threshold is met. Rollback creates a new deployment with the last known good revision — it does NOT roll back to a previous state in-place.
---

---
**Card #15** | Domain: 1
**Q:** What are the five Elastic Beanstalk deployment policies?
**A:** **All at once** (fastest, downtime), **Rolling** (batches, reduced capacity), **Rolling with additional batch** (batches, maintains full capacity), **Immutable** (new instances in new ASG, safest), **Traffic splitting** (canary-style using ALB weighted target groups).
---

---
**Card #16** | Domain: 1
**Q:** How does Elastic Beanstalk blue/green deployment work?
**A:** Create a clone environment, deploy new version to clone, then perform a **CNAME swap** to redirect traffic. The two environments swap URLs. This is NOT a built-in deployment policy — you manage it manually or via CLI.
---

---
**Card #17** | Domain: 1
**Q:** What is the purpose of `.ebextensions` in Elastic Beanstalk?
**A:** YAML/JSON configuration files in `.ebextensions/` directory customize the environment. They can configure packages, sources, files, users, groups, commands, container_commands, services, and option_settings. Files must have a `.config` extension.
---

---
**Card #18** | Domain: 1
**Q:** What is the difference between `commands` and `container_commands` in `.ebextensions`?
**A:** `commands` run before the application and web server are set up. `container_commands` run after the app is extracted but before it is deployed — they have access to environment variables and can use `leader_only` to run on just one instance.
---

---
**Card #19** | Domain: 1
**Q:** Describe the canary deployment strategy.
**A:** Route a small percentage of traffic (e.g., 10%) to the new version first. After a defined evaluation period, if healthy, shift the remaining traffic all at once. Example: `Canary10Percent5Minutes` — 10% for 5 minutes, then 100%.
---

---
**Card #20** | Domain: 1
**Q:** Describe the linear deployment strategy.
**A:** Traffic shifts in equal increments with equal time between each increment. Example: `Linear10PercentEvery1Minute` — shift 10% every minute until 100%. This is more gradual than canary.
---

---
**Card #21** | Domain: 1
**Q:** How does blue/green deployment differ from canary deployment?
**A:** Blue/green runs two full environments and switches traffic all at once (via DNS, LB, or deployment group). Canary gradually shifts a small percentage of traffic first, then the rest — both versions share the same infrastructure during transition.
---

---
**Card #22** | Domain: 1
**Q:** What is immutable deployment and when would you use it?
**A:** Launches a completely new set of instances in a new ASG with the new version. Once they pass health checks, they replace old instances. Safest rollback (terminate new ASG). Use in production where zero-downtime and quick rollback are critical.
---

---
**Card #23** | Domain: 1
**Q:** What is AWS CodeArtifact?
**A:** A fully managed artifact repository service for software packages. Supports npm, PyPI, Maven, NuGet, Swift, and generic formats. Can be configured as an upstream proxy to public registries. Supports cross-account access and integrates with CodeBuild.
---

---
**Card #24** | Domain: 1
**Q:** How does CodeArtifact upstream repository resolution work?
**A:** When a package is requested, CodeArtifact checks the repository first, then its configured upstream repositories in order, and finally the external connection (e.g., npmjs.com). Found packages are cached in the requesting repository.
---

---
**Card #25** | Domain: 1
**Q:** What is an ECR lifecycle policy?
**A:** Rules to automatically clean up images in an ECR repository. Rules can expire images by count or age, and filter by tag status (tagged/untagged) or tag prefix. Rules have priorities — lower number = higher priority.
---

---
**Card #26** | Domain: 1
**Q:** What are ECR image scanning options?
**A:** **Basic scanning** (on push or manual, uses Clair CVE database) and **Enhanced scanning** (continuous, uses Amazon Inspector, supports OS and programming language vulnerabilities, integrates with EventBridge for findings).
---

---
**Card #27** | Domain: 1
**Q:** How do you store Docker images for use in ECS or EKS?
**A:** Use Amazon ECR (Elastic Container Registry). Push images using `docker push` after authenticating with `aws ecr get-login-password`. ECR supports cross-region and cross-account replication, immutable image tags, and encryption.
---

---
**Card #28** | Domain: 1
**Q:** What is trunk-based development?
**A:** A branching strategy where developers integrate small, frequent changes directly to a single trunk/main branch. Feature flags are used instead of long-lived feature branches. Promotes CI/CD best practices and reduces merge conflicts.
---

---
**Card #29** | Domain: 1
**Q:** What is Gitflow and when is it appropriate?
**A:** A branching strategy with main, develop, feature, release, and hotfix branches. Suited for projects with scheduled releases. More complex than trunk-based — generally NOT recommended for continuous deployment pipelines.
---

---
**Card #30** | Domain: 1
**Q:** How do you implement automated testing in CodePipeline?
**A:** Add a Test stage using CodeBuild (unit/integration tests), third-party tools (Jenkins), or AWS Device Farm (mobile/web testing). Use manual approval actions for gates. CodeBuild reports test results in JUnit XML format.
---

---
**Card #31** | Domain: 1
**Q:** What is the purpose of a manual approval action in CodePipeline?
**A:** Pauses the pipeline execution and sends an SNS notification. A designated IAM user must approve or reject. Can include a URL to review (e.g., staging environment). Has a configurable timeout (default 7 days).
---

---
**Card #32** | Domain: 1
**Q:** How does CodePipeline handle source changes from CodeCommit?
**A:** In V2, uses EventBridge triggers. In V1, an EventBridge rule (formerly CloudWatch Events rule) is automatically created to detect branch changes and start the pipeline. Polling is also available but not recommended.
---

---
**Card #33** | Domain: 1
**Q:** What CodeDeploy deployment configurations exist for EC2?
**A:** **OneAtATime** (safest, slowest), **HalfAtATime** (50% at a time), **AllAtOnce** (fastest, downtime risk), and **Custom** (specify minimum healthy percentage or host count).
---

---
**Card #34** | Domain: 1
**Q:** What happens during a CodeDeploy blue/green deployment on EC2?
**A:** New replacement instances are provisioned, application is installed, traffic is rerouted from original (blue) instances via the load balancer, and after a wait period, original instances are terminated (or kept for rollback).
---

---
**Card #35** | Domain: 1
**Q:** What is the CodeDeploy agent and where is it required?
**A:** A software package installed on EC2/on-premises instances that enables CodeDeploy to deploy applications. Required for EC2/On-Premises compute platform only. NOT needed for Lambda or ECS deployments.
---

---
**Card #36** | Domain: 1
**Q:** How can you ensure CodeBuild has access to VPC resources?
**A:** Configure CodeBuild with VPC configuration — specify VPC ID, subnets, and security groups. The build runs inside the VPC and can access private resources like RDS, ElastiCache, or internal services.
---

---
**Card #37** | Domain: 1
**Q:** What are CodeBuild environment types?
**A:** **Linux** (standard, ARM, GPU, Lambda), **Windows** (standard). Each has curated images. You can also use custom Docker images from ECR or Docker Hub. Compute types range from small (3GB/2vCPU) to 2xlarge (145GB/72vCPU).
---

---
**Card #38** | Domain: 1
**Q:** How do you pass secrets to CodeBuild?
**A:** Use environment variables that reference **SSM Parameter Store** parameters or **Secrets Manager** secrets. In the buildspec, use `parameter-store` or `secrets-manager` in the `env` section. Never hardcode secrets.
---

---
**Card #39** | Domain: 1
**Q:** What are CodePipeline action categories?
**A:** Source (CodeCommit, S3, GitHub, ECR), Build (CodeBuild, Jenkins), Test (CodeBuild, Device Farm, third-party), Deploy (CodeDeploy, CloudFormation, ECS, S3, Elastic Beanstalk, Service Catalog), Approval, Invoke (Lambda, Step Functions).
---

---
**Card #40** | Domain: 1
**Q:** How do you implement cross-Region deployments in CodePipeline?
**A:** Add actions in stages that reference resources in other regions. CodePipeline automatically creates an artifact bucket in each region. The pipeline's artifact is replicated to the target region's bucket for deployment actions.
---

---
**Card #41** | Domain: 1
**Q:** What is the CodeBuild `reports` section in buildspec?
**A:** Defines test report groups that CodeBuild displays. Supports JUnit XML, Cucumber JSON, TestNG XML, Visual Studio TRX, and NUnit XML for test reports, plus Clover XML, Cobertura XML, JaCoCo XML, and SimpleCov JSON for code coverage.
---

---
**Card #42** | Domain: 1
**Q:** How does CodeDeploy integrate with Auto Scaling groups?
**A:** CodeDeploy automatically deploys to new EC2 instances launched by Auto Scaling. If a scale-out event occurs during deployment, the new instances get the latest successful revision, not the in-progress one.
---

---
**Card #43** | Domain: 1
**Q:** What is the difference between in-place and blue/green deployment in CodeDeploy for EC2?
**A:** **In-place**: application is stopped, new version installed on existing instances. **Blue/Green**: new instances are created, application deployed to them, traffic shifted via load balancer, old instances optionally terminated.
---

---
**Card #44** | Domain: 1
**Q:** What is Elastic Beanstalk's saved configuration vs `.ebextensions`?
**A:** Saved configurations store the complete environment configuration and are stored in S3. `.ebextensions` are bundled with the application source and apply customizations during deployment. Saved configs are applied first, then `.ebextensions` override them.
---

---
**Card #45** | Domain: 1
**Q:** What is a CodePipeline webhook vs trigger?
**A:** **Webhook** (V1): HTTP endpoint that external sources (GitHub) call to start the pipeline. **Trigger** (V2): EventBridge-based configuration supporting filters on branches, tags, and file paths — more flexible and the recommended approach.
---

---
**Card #46** | Domain: 1
**Q:** How do you implement feature flags in AWS?
**A:** Use **AWS AppConfig** (part of Systems Manager). Define feature flags as configuration profiles, deploy using deployment strategies with rollback safeguards. Integrates with Lambda extensions for caching.
---

---
**Card #47** | Domain: 1
**Q:** What is the maximum number of stages in a CodePipeline? Maximum actions per stage?
**A:** Maximum 50 stages per pipeline. Maximum 50 actions per stage. Maximum 50 pipelines per region per account (soft limit).
---

---
**Card #48** | Domain: 1
**Q:** How do you implement a multi-environment pipeline (dev/staging/prod)?
**A:** Create a single pipeline with stages for each environment. Use manual approval actions between staging and production. Alternatively, use separate pipelines triggered sequentially or use CodePipeline V2 with pipeline variables.
---

---
**Card #49** | Domain: 1
**Q:** What is the CodeDeploy deployment group?
**A:** A set of target instances or Lambda functions/ECS services identified by tags, Auto Scaling group names, or ECS cluster/service. Also specifies deployment configuration, rollback settings, alarm-based monitoring, and trigger notifications.
---

---
**Card #50** | Domain: 1
**Q:** How does Elastic Beanstalk worker environment differ from web server environment?
**A:** Worker environments pull messages from an SQS queue (managed by EB) and process them via HTTP POST to localhost. No ELB is configured. Used for background processing. A cron.yaml file can schedule periodic tasks.
---

## Domain 2: Configuration Management and IaC (Cards 51–95)

---
**Card #51** | Domain: 2
**Q:** Name all CloudFormation intrinsic functions.
**A:** `Ref`, `Fn::GetAtt`, `Fn::Join`, `Fn::Sub`, `Fn::Select`, `Fn::Split`, `Fn::FindInMap`, `Fn::If`, `Fn::Equals`, `Fn::And`, `Fn::Or`, `Fn::Not`, `Fn::Base64`, `Fn::Cidr`, `Fn::GetAZs`, `Fn::ImportValue`, `Fn::Length`, `Fn::ToJsonString`, `Fn::Transform`.
---

---
**Card #52** | Domain: 2
**Q:** What are the CloudFormation pseudo parameters?
**A:** `AWS::AccountId`, `AWS::NotificationARNs`, `AWS::NoValue`, `AWS::Partition`, `AWS::Region`, `AWS::StackId`, `AWS::StackName`, `AWS::URLSuffix`.
---

---
**Card #53** | Domain: 2
**Q:** What are the CloudFormation resource attributes?
**A:** `CreationPolicy`, `DeletionPolicy`, `DependsOn`, `Metadata`, `UpdatePolicy`, `UpdateReplacePolicy`, `Condition`.
---

---
**Card #54** | Domain: 2
**Q:** What values can `DeletionPolicy` take?
**A:** **Delete** (default for most resources — resource is deleted), **Retain** (resource is kept when stack is deleted), **Snapshot** (creates a snapshot before deletion — supported by EBS, RDS, Redshift, Neptune, DocumentDB).
---

---
**Card #55** | Domain: 2
**Q:** What does `UpdatePolicy` control and which resources support it?
**A:** Controls how CloudFormation handles updates. Supported on: **AutoScaling::AutoScalingGroup** (AutoScalingRollingUpdate, AutoScalingReplacingUpdate, AutoScalingScheduledAction), **ElastiCache::ReplicationGroup**, **Lambda::Alias** (CodeDeployLambdaAliasUpdate), **OpenSearch::Domain**.
---

---
**Card #56** | Domain: 2
**Q:** How does `CreationPolicy` work with `cfn-signal`?
**A:** `CreationPolicy` tells CloudFormation to wait for a specified number of success signals within a timeout period before marking the resource as CREATE_COMPLETE. `cfn-signal` sends the signals from EC2 instances. If signals aren't received in time, the creation fails and rolls back.
---

---
**Card #57** | Domain: 2
**Q:** What are the four CloudFormation helper scripts?
**A:** **cfn-init** (reads metadata to configure instance — packages, files, services), **cfn-signal** (signals success/failure back to CloudFormation), **cfn-get-metadata** (retrieves metadata), **cfn-hup** (daemon that detects metadata changes and reruns cfn-init).
---

---
**Card #58** | Domain: 2
**Q:** Describe the `AWS::CloudFormation::Init` metadata structure.
**A:** Organized into **configSets** (ordered list of configs) containing **configs**, each with: `packages` (yum, apt, rpm, msi), `groups`, `users`, `sources`, `files`, `commands`, `services`. They execute in this fixed order within a config.
---

---
**Card #59** | Domain: 2
**Q:** What is a CloudFormation WaitCondition and how does it differ from CreationPolicy?
**A:** Both wait for signals. **CreationPolicy** is attached to a resource (typically ASG/EC2). **WaitCondition** is a standalone resource that can wait for signals from external sources (not just the stack). WaitCondition requires a WaitConditionHandle to generate a pre-signed URL.
---

---
**Card #60** | Domain: 2
**Q:** How do CloudFormation nested stacks work?
**A:** A parent stack includes child stacks using `AWS::CloudFormation::Stack` resource. The child template URL is specified in `TemplateURL`. Outputs from child stacks are accessed via `Fn::GetAtt`. Updates to the parent propagate to children.
---

---
**Card #61** | Domain: 2
**Q:** How do CloudFormation cross-stack references work?
**A:** Stack A exports a value using `Outputs` with `Export: Name`. Stack B imports it using `Fn::ImportValue`. The export name must be unique within the region. You cannot delete Stack A while Stack B references its exports.
---

---
**Card #62** | Domain: 2
**Q:** What are CloudFormation StackSets?
**A:** Deploy stacks across multiple AWS accounts and regions with a single operation. Requires an administrator account and target accounts. Supports self-managed permissions (IAM roles) or service-managed permissions (AWS Organizations). Supports automatic deployment to new accounts.
---

---
**Card #63** | Domain: 2
**Q:** What are CloudFormation custom resources?
**A:** Resources backed by Lambda functions or SNS topics that execute custom provisioning logic. Defined as `AWS::CloudFormation::CustomResource` or `Custom::MyResource`. CloudFormation sends Create/Update/Delete requests and the Lambda must return a response to the pre-signed S3 URL.
---

---
**Card #64** | Domain: 2
**Q:** What is a CloudFormation change set?
**A:** A preview of changes that CloudFormation will make when you update a stack. You create a change set, review it (which resources will be added, modified, or replaced), and then execute or delete it. Does not indicate if the update will succeed.
---

---
**Card #65** | Domain: 2
**Q:** How does CloudFormation drift detection work?
**A:** Compares the actual resource configuration with the expected template configuration. Reports drifted resources and their property differences. Only detects drift for supported resources. Does not fix drift — just detects it.
---

---
**Card #66** | Domain: 2
**Q:** What are CloudFormation dynamic references?
**A:** Reference values stored in SSM Parameter Store or Secrets Manager directly in templates. Syntax: `{{resolve:ssm:name:version}}` for SSM, `{{resolve:ssm-secure:name:version}}` for SecureString, `{{resolve:secretsmanager:secret-id:SecretString:json-key:version-stage}}`.
---

---
**Card #67** | Domain: 2
**Q:** What is a CloudFormation stack policy?
**A:** A JSON document that defines which update actions are allowed on specified resources. By default, all updates are allowed. Once set, all resources are protected (deny all), and you explicitly allow updates on specific resources. Can be overridden temporarily during an update.
---

---
**Card #68** | Domain: 2
**Q:** What are CloudFormation macros and transforms?
**A:** Macros are custom processing functions (Lambda-backed) invoked in templates using `Fn::Transform`. Built-in transforms include `AWS::Include` (include template snippets from S3) and `AWS::Serverless` (SAM transform). Custom macros can modify the entire template.
---

---
**Card #69** | Domain: 2
**Q:** What are the three levels of CDK constructs?
**A:** **L1 (CFN Resources)**: Direct CloudFormation mapping, prefixed with `Cfn`. **L2 (Curated)**: AWS-authored with sensible defaults, helper methods, security-group wiring. **L3 (Patterns)**: Multi-resource architectures (e.g., `ApplicationLoadBalancedFargateService`).
---

---
**Card #70** | Domain: 2
**Q:** What is CDK Pipelines?
**A:** A high-level construct for creating self-mutating CI/CD pipelines. The pipeline updates itself when you push changes. Uses CodePipeline under the hood. Supports multiple deployment stages, waves (parallel stages), and pre/post deployment steps.
---

---
**Card #71** | Domain: 2
**Q:** What are CDK Aspects?
**A:** A way to apply an operation to all constructs in a scope. Implements the Visitor pattern. Commonly used for compliance (e.g., ensure all S3 buckets have versioning), tagging, or validation. Applied using `Aspects.of(scope).add(aspect)`.
---

---
**Card #72** | Domain: 2
**Q:** How do you test CDK applications?
**A:** Use **assertions** module: `Template.fromStack()` to get the synthesized template, then `hasResourceProperties()`, `hasResource()`, `resourceCountIs()`. **Snapshot testing**: compare synthesized template against saved snapshot. **Fine-grained assertions** for specific properties.
---

---
**Card #73** | Domain: 2
**Q:** What is `cdk synth` vs `cdk deploy`?
**A:** `cdk synth` synthesizes the CDK app into a CloudFormation template (output in `cdk.out/`). `cdk deploy` synthesizes AND deploys the stack. Always synth first to review the template before deploying.
---

---
**Card #74** | Domain: 2
**Q:** What is AWS Service Catalog?
**A:** Enables organizations to create and manage catalogs of approved IT products (CloudFormation templates). Organized into **Portfolios** (collections of products) shared with specific IAM users/roles/groups or OUs. End users launch products as **Provisioned Products**.
---

---
**Card #75** | Domain: 2
**Q:** What types of constraints exist in Service Catalog?
**A:** **Launch constraints** (specify an IAM role for launching — end users don't need CloudFormation permissions), **Notification constraints** (SNS topic for events), **Template constraints** (restrict parameter values users can select), **Tag update constraints**.
---

---
**Card #76** | Domain: 2
**Q:** What are the SSM Parameter Store tiers?
**A:** **Standard**: free, up to 10,000 parameters, max 4KB value, no parameter policies. **Advanced**: paid, up to 100,000 parameters, max 8KB value, supports parameter policies (expiration, notification). Both support String, StringList, and SecureString types.
---

---
**Card #77** | Domain: 2
**Q:** What is SSM State Manager?
**A:** Maintains a defined configuration state for managed instances. Uses **Associations** that define the desired state (e.g., install software, join domain). Associations target instances via tags, instance IDs, or resource groups and run on a schedule.
---

---
**Card #78** | Domain: 2
**Q:** How does SSM Patch Manager work?
**A:** Uses **Patch Baselines** (rules for auto-approving patches), **Patch Groups** (instances tagged for the same baseline), and **Maintenance Windows** (scheduled patching). The `AWS-RunPatchBaseline` document handles scanning and installing patches.
---

---
**Card #79** | Domain: 2
**Q:** What is SSM Run Command?
**A:** Remotely execute commands on managed instances without SSH/RDP. Uses SSM Documents (command documents). Supports rate control (concurrency and error thresholds), targets by tags or instance IDs, output to S3/CloudWatch, and integration with EventBridge.
---

---
**Card #80** | Domain: 2
**Q:** What is SSM Automation?
**A:** Automate common IT tasks using Automation runbooks (documents). Supports multi-step workflows with approvals, branching, and error handling. Can be triggered by EventBridge, used as Config remediation, or run via Maintenance Windows. Supports cross-account/region execution.
---

---
**Card #81** | Domain: 2
**Q:** What are the five OpsWorks lifecycle events?
**A:** **Setup** (after instance boots), **Configure** (when instances enter/leave online state), **Deploy** (when app is deployed), **Undeploy** (when app is removed), **Shutdown** (before instance is terminated). Each event runs associated Chef recipes.
---

---
**Card #82** | Domain: 2
**Q:** What are the three OpsWorks offerings?
**A:** **OpsWorks for Chef Automate** (managed Chef server), **OpsWorks for Puppet Enterprise** (managed Puppet server), **OpsWorks Stacks** (AWS-native, uses layers, instances, and apps with Chef Solo).
---

---
**Card #83** | Domain: 2
**Q:** What is the `UpdateReplacePolicy` resource attribute?
**A:** Controls what happens to a resource when it is replaced during a stack update (not deletion). Values are `Delete`, `Retain`, `Snapshot`. Different from `DeletionPolicy` which applies when the stack is deleted.
---

---
**Card #84** | Domain: 2
**Q:** How do you import existing resources into CloudFormation?
**A:** Use `resource import`. Each resource must have a `DeletionPolicy` in the template. Provide the resource identifier. CloudFormation creates a change set of type IMPORT. The resource must not already belong to another stack.
---

---
**Card #85** | Domain: 2
**Q:** What is CloudFormation Registry?
**A:** A catalog of extensions (resource types, modules, hooks) that can be used in templates. Includes AWS public types, third-party types from the registry, and private types you register. Enables managing non-AWS resources (e.g., Datadog, MongoDB Atlas).
---

---
**Card #86** | Domain: 2
**Q:** What are CloudFormation Hooks?
**A:** Proactive compliance checks that run before resource provisioning. Hooks can inspect resource configurations and either warn or fail the operation if non-compliant. Example: block creation of S3 buckets without encryption.
---

---
**Card #87** | Domain: 2
**Q:** How does `Fn::Sub` work?
**A:** String substitution. Replaces `${Variable}` with values. Short form: `!Sub "arn:aws:s3:::${BucketName}"`. Can reference parameters, resources, resource attributes, and pseudo parameters. Also supports a mapping list for custom variables as the second argument.
---

---
**Card #88** | Domain: 2
**Q:** What is the difference between `Ref` and `Fn::GetAtt`?
**A:** `Ref` returns the resource's default identifier (e.g., physical ID, parameter value). `Fn::GetAtt` returns a specific attribute of a resource (e.g., `!GetAtt MyBucket.Arn`, `!GetAtt MyBucket.DomainName`).
---

---
**Card #89** | Domain: 2
**Q:** How do CloudFormation Mappings work?
**A:** A fixed lookup table in the template. Define key-value pairs organized by top-level key and second-level key. Access values using `Fn::FindInMap`. Common use: map AMI IDs per region. Cannot include parameters or references in mappings.
---

---
**Card #90** | Domain: 2
**Q:** What is `cdk bootstrap` and when is it required?
**A:** Provisions resources needed by CDK in a target account/region (S3 bucket for assets, IAM roles, ECR repo). Required before first `cdk deploy` in any account/region. Creates a CDKToolkit CloudFormation stack. Must be run in every target account/region for cross-account deployments.
---

---
**Card #91** | Domain: 2
**Q:** What is the difference between SSM Parameter Store and Secrets Manager?
**A:** Both store secrets. **Secrets Manager**: automatic rotation (Lambda), cross-region replication, higher cost, designed for secrets. **Parameter Store**: free tier, hierarchy/path support, no native rotation (use Lambda manually), stores both plain and encrypted values.
---

---
**Card #92** | Domain: 2
**Q:** What is a CloudFormation StackSet operation?
**A:** An action performed on stack instances: Create, Update, Delete. Configurable with `MaxConcurrentCount`/`MaxConcurrentPercentage` (parallelism) and `FailureToleranceCount`/`FailureTolerancePercentage` (how many failures before stopping).
---

---
**Card #93** | Domain: 2
**Q:** How do you prevent accidental updates to critical CloudFormation resources?
**A:** Use **Stack Policies** (prevent updates to specific resources), **DeletionPolicy: Retain**, **Termination Protection** (prevent stack deletion), **IAM policies** (restrict who can update stacks), and **Change Sets** (review before applying).
---

---
**Card #94** | Domain: 2
**Q:** What is CDK `context` and how is it used?
**A:** Runtime information passed to CDK apps. Can be set via `cdk.json`, `cdk.context.json`, CLI (`-c key=value`), or code. Used for feature flags, environment-specific values, and caching VPC lookups. `cdk.context.json` should be committed to source control.
---

---
**Card #95** | Domain: 2
**Q:** How does CloudFormation handle circular dependencies?
**A:** CloudFormation reports an error. Resolve by: using `DependsOn` carefully, breaking the cycle with a separate resource (e.g., `AWS::EC2::SecurityGroupIngress` instead of inline ingress rules), or restructuring the template.
---

## Domain 3: Monitoring and Logging (Cards 96–130)

---
**Card #96** | Domain: 3
**Q:** What are the CloudWatch metric resolution types?
**A:** **Standard resolution**: 1-minute granularity (default for most AWS services). **High resolution**: 1-second granularity (custom metrics only, specified with `StorageResolution=1`). High-resolution metrics can still be aggregated at any period ≥1 second.
---

---
**Card #97** | Domain: 3
**Q:** What are the three CloudWatch alarm states?
**A:** **OK** (metric is within the threshold), **ALARM** (metric has breached the threshold), **INSUFFICIENT_DATA** (not enough data to determine state, or alarm just started).
---

---
**Card #98** | Domain: 3
**Q:** What are the four options for `treat missing data` in CloudWatch alarms?
**A:** **missing** (maintain current state), **notBreaching** (treat as within threshold — good), **breaching** (treat as exceeding threshold), **ignore** (current state is maintained). Default is `missing`.
---

---
**Card #99** | Domain: 3
**Q:** What are CloudWatch composite alarms?
**A:** Alarms that combine multiple child alarms using AND/OR/NOT logic. Reduces alarm noise — only trigger when a combination of conditions is met. Can help prevent action fatigue by aggregating related alarms.
---

---
**Card #100** | Domain: 3
**Q:** What are CloudWatch metric filters?
**A:** Define patterns to search for in log groups and create custom metrics from matches. Each filter has a filter pattern, metric name, metric namespace, metric value, and optional default value. Can extract values from JSON log events.
---

---
**Card #101** | Domain: 3
**Q:** What are CloudWatch subscription filters?
**A:** Real-time streaming of log events from a log group to a destination: **Kinesis Data Streams**, **Kinesis Data Firehose**, **Lambda**, or **OpenSearch** (via Lambda). Maximum 2 subscription filters per log group.
---

---
**Card #102** | Domain: 3
**Q:** How does CloudWatch Logs Insights work?
**A:** An interactive query language for searching and analyzing log data. Supports `fields`, `filter`, `stats`, `sort`, `limit`, `parse`, `display` commands. Auto-discovers fields from JSON logs. Results can be visualized as bar, line, or stacked area charts.
---

---
**Card #103** | Domain: 3
**Q:** What is the difference between CloudWatch Agent, CloudWatch Logs Agent, and Unified Agent?
**A:** **Logs Agent** (legacy): only sends logs. **Unified Agent** = **CloudWatch Agent** (current): sends both logs AND metrics (RAM, disk, CPU per core, netstat, processes). Configured via SSM Parameter Store or local config file. Recommended over the old Logs Agent.
---

---
**Card #104** | Domain: 3
**Q:** What is CloudWatch Synthetics?
**A:** Canaries — configurable scripts that run on a schedule to monitor endpoints and APIs. Written in Node.js or Python. Can check availability, latency, UI screenshots, broken links, and API responses. Integrates with CloudWatch alarms.
---

---
**Card #105** | Domain: 3
**Q:** What is CloudWatch Container Insights?
**A:** Collects and aggregates metrics and logs from containerized applications on ECS, EKS, and Kubernetes. Provides CPU, memory, disk, and network metrics at cluster, service, task, and pod levels. Uses a CloudWatch agent as a DaemonSet on EKS.
---

---
**Card #106** | Domain: 3
**Q:** What is CloudWatch Embedded Metric Format (EMF)?
**A:** Embed custom metrics within structured log events (JSON). Metrics are automatically extracted by CloudWatch without a separate PutMetricData API call. Great for high-cardinality, high-dimensionality metrics from Lambda or containers.
---

---
**Card #107** | Domain: 3
**Q:** What are the components of an X-Ray trace?
**A:** A **trace** represents an end-to-end request. It contains **segments** (one per service) and **subsegments** (detailed breakdown within a segment — remote calls, SQL queries). Each segment/subsegment has timing, status, and error information.
---

---
**Card #108** | Domain: 3
**Q:** What is the difference between X-Ray annotations and metadata?
**A:** **Annotations**: key-value pairs that are **indexed** and can be used for filtering traces (search/filter). **Metadata**: key-value pairs that are **NOT indexed** — used for storing additional data without filter capability. Both are attached to segments/subsegments.
---

---
**Card #109** | Domain: 3
**Q:** How does X-Ray sampling work?
**A:** Default rule: first request each second is sampled, then 5% of additional requests. Custom sampling rules override this. Rules have a priority, rate (fixed rate), and reservoir (minimum per second). Configured in the X-Ray console — no application restart needed.
---

---
**Card #110** | Domain: 3
**Q:** What is the X-Ray daemon?
**A:** A process that listens on UDP port 2000, collects raw segment data from the X-Ray SDK, buffers it, and sends it to the X-Ray API in batches. Runs alongside the application on EC2, ECS (sidecar), or Elastic Beanstalk. On Lambda, the runtime sends traces directly.
---

---
**Card #111** | Domain: 3
**Q:** What does the X-Ray Service Map show?
**A:** A visual representation of your application's components and their connections. Shows response times, request counts, and error rates for each node. Highlights latency bottlenecks and error sources. Generated automatically from trace data.
---

---
**Card #112** | Domain: 3
**Q:** What are the three types of CloudTrail events?
**A:** **Management events** (control plane — CreateBucket, RunInstances), **Data events** (data plane — S3 object operations, Lambda invocations, DynamoDB operations), **Insights events** (unusual API activity detection). Management events are logged by default; data events are opt-in.
---

---
**Card #113** | Domain: 3
**Q:** How does CloudTrail log file integrity validation work?
**A:** CloudTrail creates a digest file every hour containing hashes of the log files delivered. You can use the `aws cloudtrail validate-logs` CLI command to verify that logs haven't been modified, deleted, or forged since delivery.
---

---
**Card #114** | Domain: 3
**Q:** What is CloudTrail Lake?
**A:** A managed data lake for CloudTrail events. Query events using SQL. Supports retention up to 7 years (2555 days). Replaces the need to export logs to S3 and query with Athena for many use cases. Supports organization-level event data stores.
---

---
**Card #115** | Domain: 3
**Q:** What is a CloudTrail organization trail?
**A:** A trail created in the management account that logs events for all accounts in the AWS Organization. Logs are delivered to a single S3 bucket. Member accounts can see the trail but cannot modify or delete it.
---

---
**Card #116** | Domain: 3
**Q:** What information do VPC Flow Logs capture?
**A:** Source/destination IP, source/destination port, protocol, packets, bytes, start/end time, action (ACCEPT/REJECT), log-status. Can be published to CloudWatch Logs, S3, or Kinesis Data Firehose. Can be set at VPC, subnet, or ENI level.
---

---
**Card #117** | Domain: 3
**Q:** What is AWS Config and what does it track?
**A:** Records configuration changes to AWS resources over time as **configuration items** (CIs). Each CI contains metadata, attributes, relationships, and current configuration. Provides a configuration timeline and compliance dashboard.
---

---
**Card #118** | Domain: 3
**Q:** What are AWS Config rules?
**A:** Evaluate whether resource configurations comply with desired settings. **Managed rules** (AWS-provided, 300+) and **Custom rules** (Lambda-backed or CloudFormation Guard). Triggered by configuration changes or periodically. Report resources as COMPLIANT or NON_COMPLIANT.
---

---
**Card #119** | Domain: 3
**Q:** What is AWS Config remediation?
**A:** Automatically fix non-compliant resources. Uses **SSM Automation documents** as remediation actions. Can be auto-remediation (automatic) or manual. Configurable retry attempts and concurrency. Example: auto-enable S3 bucket versioning.
---

---
**Card #120** | Domain: 3
**Q:** What are AWS Config conformance packs?
**A:** A collection of Config rules and remediation actions packaged as a single entity. Written in YAML. Can be deployed across an organization using Organizations. Provides an aggregated compliance score.
---

---
**Card #121** | Domain: 3
**Q:** What is a Config aggregator?
**A:** Collects Config data from multiple accounts and regions into a single aggregator account. Supports organization-wide or individual account authorization. Provides a multi-account, multi-region compliance view. Does NOT enforce rules — only aggregates data.
---

---
**Card #122** | Domain: 3
**Q:** How does CloudWatch Logs export to S3 work?
**A:** Use `CreateExportTask` API to export log data to S3. NOT real-time — can take up to 12 hours. For real-time streaming, use subscription filters to Kinesis Data Firehose → S3. Only one export task per log group at a time.
---

---
**Card #123** | Domain: 3
**Q:** What CloudWatch metric retention periods apply?
**A:** Data points with period < 60s: retained 3 hours. Period 60s (1 min): retained 15 days. Period 300s (5 min): retained 63 days. Period 3600s (1 hour): retained 455 days (15 months). Metrics roll up to coarser granularity over time.
---

---
**Card #124** | Domain: 3
**Q:** What is CloudWatch Anomaly Detection?
**A:** Uses machine learning to establish a baseline for a metric (expected values band). Creates an anomaly detection model. Alarms can trigger when the metric goes outside the expected band rather than a static threshold.
---

---
**Card #125** | Domain: 3
**Q:** How do you query VPC Flow Logs efficiently?
**A:** Store in S3 in Parquet format (for Athena), then query with **Athena**. Or send to CloudWatch Logs and use **CloudWatch Logs Insights**. For real-time analysis, stream to **Kinesis Data Firehose** → OpenSearch.
---

---
**Card #126** | Domain: 3
**Q:** What is the CloudWatch agent's `collectd` integration?
**A:** The CloudWatch agent can receive metrics from `collectd` (system statistics daemon). Enables collecting custom system-level metrics not available by default (e.g., detailed CPU states, disk I/O per device) and publishing them to CloudWatch.
---

---
**Card #127** | Domain: 3
**Q:** What is Amazon OpenSearch Service in a DevOps monitoring context?
**A:** Managed Elasticsearch/OpenSearch for log analytics and visualization. Common pattern: CloudWatch Logs → Subscription Filter → Lambda → OpenSearch with Kibana/Dashboards for visualization. Supports fine-grained access control and multi-AZ.
---

---
**Card #128** | Domain: 3
**Q:** What is the CloudWatch Logs filter pattern syntax for space-delimited log events?
**A:** Use bracket notation: `[ip, id, user, timestamp, request, status_code=5*, bytes]`. For exact match use `=`, for exclusion use `!=`. For numeric: `>`, `<`, `>=`, `<=`. For JSON logs, use `{ $.statusCode = 500 }`.
---

---
**Card #129** | Domain: 3
**Q:** What are CloudWatch cross-account observability features?
**A:** **Cross-account dashboards** (view metrics from multiple accounts), **Cross-account alarms** (one account monitors another's metrics), **CloudWatch Observability Access Manager (OAM)** — link monitoring and source accounts to share metrics, logs, and traces.
---

---
**Card #130** | Domain: 3
**Q:** How does X-Ray integrate with API Gateway, Lambda, and ECS?
**A:** **API Gateway**: enable tracing in stage settings. **Lambda**: enable Active Tracing in function config — X-Ray SDK auto-included. **ECS**: run X-Ray daemon as a sidecar container in the task definition, instrument app with X-Ray SDK.
---

## Domain 4: Policies and Standards Automation (Cards 131–165)

---
**Card #131** | Domain: 4
**Q:** How are Service Control Policies (SCPs) evaluated?
**A:** SCPs are permission guardrails. Effective permissions = intersection of SCP AND IAM policies. SCPs don't grant permissions — they set the maximum permissions boundary. Evaluated at OU and account level. The management account is NOT affected by SCPs.
---

---
**Card #132** | Domain: 4
**Q:** How does SCP inheritance work?
**A:** SCPs are inherited down the OU hierarchy. An account's effective SCP is the intersection of all SCPs applied from root → parent OUs → the account's OU → the account directly. All must allow the action for it to be permitted.
---

---
**Card #133** | Domain: 4
**Q:** What is the difference between SCP deny-list and allow-list strategies?
**A:** **Deny-list** (default): AWS attaches `FullAWSAccess` SCP, you add deny statements for restricted services. **Allow-list**: Remove `FullAWSAccess`, explicitly allow only permitted services. Allow-list is more restrictive but harder to manage.
---

---
**Card #134** | Domain: 4
**Q:** Describe the IAM policy evaluation logic (single account).
**A:** 1) Start with implicit deny. 2) Evaluate all applicable policies. 3) Any explicit deny → DENY. 4) If SCP exists → must allow. 5) If resource policy allows (for some services) → ALLOW. 6) If permission boundary exists → must allow. 7) If session policy exists → must allow. 8) Identity-based policy must allow → ALLOW. Otherwise DENY.
---

---
**Card #135** | Domain: 4
**Q:** What are IAM permission boundaries?
**A:** An advanced IAM feature that sets the maximum permissions an IAM entity (user/role) can have. Effective permissions = intersection of identity-based policies AND permission boundary. Used to delegate admin tasks safely — admins can create roles only within the boundary.
---

---
**Card #136** | Domain: 4
**Q:** What IAM condition keys are important for the DevOps exam?
**A:** `aws:SourceIp`, `aws:RequestedRegion`, `aws:PrincipalOrgID`, `aws:PrincipalTag`, `aws:ResourceTag`, `aws:CalledVia`, `aws:ViaAWSService`, `aws:MultiFactorAuthPresent`, `aws:SecureTransport`, `aws:SourceVpce`, `aws:SourceVpc`, `ec2:ResourceTag`, `s3:prefix`.
---

---
**Card #137** | Domain: 4
**Q:** What is IAM Access Analyzer?
**A:** Identifies resources shared with external entities (cross-account/public). Uses automated reasoning (provable security). Generates findings for resources like S3, IAM roles, KMS, Lambda, SQS. Also validates policies and generates least-privilege policies from CloudTrail activity.
---

---
**Card #138** | Domain: 4
**Q:** What is AWS IAM Identity Center (formerly SSO)?
**A:** Centralized access management for multiple AWS accounts and business applications. Integrates with identity providers (SAML 2.0, Active Directory, built-in directory). Uses **Permission Sets** mapped to AWS accounts. Provides a single sign-on portal for users.
---

---
**Card #139** | Domain: 4
**Q:** What types of Control Tower guardrails exist?
**A:** **Preventive** (SCPs — block actions), **Detective** (Config rules — detect noncompliance), **Proactive** (CloudFormation Hooks — check before provisioning). Behavior levels: **Mandatory** (always on), **Strongly recommended**, **Elective**.
---

---
**Card #140** | Domain: 4
**Q:** What is Control Tower Account Factory?
**A:** Automates provisioning of new accounts with pre-configured settings. Configures VPC, subnets, regions. Can be customized with **Account Factory Customization (AFC)** using Service Catalog and CloudFormation. Supports Account Factory for Terraform (AFT).
---

---
**Card #141** | Domain: 4
**Q:** What is the Control Tower landing zone?
**A:** A well-architected multi-account AWS environment. Includes: management account, log archive account (centralized logging), audit account (security tooling), and organization structure (OUs). Provides baseline guardrails and centralized governance.
---

---
**Card #142** | Domain: 4
**Q:** What is CloudFormation Guard?
**A:** A policy-as-code language that validates CloudFormation templates (and JSON/YAML) against custom rules. Write rules like `AWS::S3::Bucket { Properties.BucketEncryption exists }`. Can run locally, in CI/CD pipelines, or as a CloudFormation Hook.
---

---
**Card #143** | Domain: 4
**Q:** How does Service Catalog enforce governance?
**A:** Admins create approved CloudFormation templates as Products in Portfolios. End users can only launch approved products. **Launch constraints** use a service role (users don't need direct CloudFormation/resource permissions). **Template constraints** restrict parameter values.
---

---
**Card #144** | Domain: 4
**Q:** What is Amazon Inspector?
**A:** Automated vulnerability management. Continuously scans EC2 instances, Lambda functions, and container images (ECR) for software vulnerabilities and unintended network exposure. Generates findings with severity ratings. Uses SSM Agent on EC2.
---

---
**Card #145** | Domain: 4
**Q:** What are Trusted Advisor's five categories?
**A:** **Cost Optimization**, **Performance**, **Security**, **Fault Tolerance**, **Service Limits**. Free tier has 7 core checks (security focused). Business/Enterprise Support plans unlock all checks plus API access and CloudWatch integration.
---

---
**Card #146** | Domain: 4
**Q:** How do you automate security remediation for Config rule violations?
**A:** Config Rule detects non-compliance → auto-remediation using SSM Automation document. Example: non-compliant S3 bucket → SSM Automation runs `AWS-EnableS3BucketEncryption`. Alternatively: Config → EventBridge → Lambda for custom remediation.
---

---
**Card #147** | Domain: 4
**Q:** How do you enforce tagging compliance across an organization?
**A:** Use **Tag Policies** (Organizations), **Config Rules** (required-tags), **SCP** (deny ec2:RunInstances without tags using condition keys `aws:RequestTag`), **Service Catalog** (template constraints), **CloudFormation Guard** (pre-deployment).
---

---
**Card #148** | Domain: 4
**Q:** What is cross-account IAM policy evaluation?
**A:** For cross-account access, BOTH accounts must allow: the identity policy in the source account AND the resource policy in the target account. Exception: if the target uses an IAM role (AssumeRole), only the role's trust policy and the role's permissions apply.
---

---
**Card #149** | Domain: 4
**Q:** How do AWS Organizations Tag Policies work?
**A:** Define standardized tags for resources — specify allowed tag keys, values, and which resource types they apply to. Can report non-compliant tags. Can optionally enforce compliance (prevent creation of non-compliant tags). Applied at OU or account level.
---

---
**Card #150** | Domain: 4
**Q:** What is the AWS Well-Architected Tool?
**A:** Review workloads against the Well-Architected Framework's six pillars. Identify high-risk issues and get improvement recommendations. Supports custom lenses. Can generate milestones to track improvements.
---

---
**Card #151** | Domain: 4
**Q:** How do you ensure only approved AMIs are used?
**A:** Use Config Rule `approved-amis-by-id` or `approved-amis-by-tag`. Enforce with SCP denying `ec2:RunInstances` unless `ec2:ImageId` condition matches. Use Service Catalog products with pre-configured AMIs. Automate with EC2 Image Builder.
---

---
**Card #152** | Domain: 4
**Q:** What is AWS Audit Manager?
**A:** Continuously collects evidence relevant to AWS usage and maps it to compliance frameworks (SOC 2, PCI DSS, HIPAA, GDPR). Automates evidence collection from Config, CloudTrail, Security Hub. Generates audit-ready reports.
---

---
**Card #153** | Domain: 4
**Q:** What is AWS Security Hub?
**A:** Centralized security findings from GuardDuty, Inspector, Macie, Firewall Manager, Config, and partner tools. Runs automated security checks against standards (CIS Benchmarks, PCI DSS, AWS Foundational Best Practices). Supports cross-account aggregation.
---

---
**Card #154** | Domain: 4
**Q:** How do you enforce encryption at rest across services?
**A:** Use SCP to deny actions without encryption (e.g., `s3:PutObject` without `s3:x-amz-server-side-encryption`). Config rules to detect unencrypted resources. CloudFormation Guard to prevent deployment. AWS Config auto-remediation to enable encryption.
---

---
**Card #155** | Domain: 4
**Q:** What is the difference between AWS-managed, customer-managed, and AWS-owned KMS keys?
**A:** **AWS-managed**: created automatically by services (aws/s3, aws/ebs), auto-rotated yearly, you can view but not manage. **Customer-managed**: you create and control (key policy, rotation, deletion). **AWS-owned**: used by AWS internally, not visible in your account.
---

---
**Card #156** | Domain: 4
**Q:** How do you restrict resource creation to specific regions?
**A:** Use SCP with condition key `aws:RequestedRegion`. Example: deny all actions where `aws:RequestedRegion` is NOT in `[us-east-1, eu-west-1]`. Apply to the root OU for organization-wide enforcement.
---

---
**Card #157** | Domain: 4
**Q:** What are Config Organization Rules?
**A:** Config rules deployed across all member accounts in an AWS Organization from the management/delegated admin account. Provides centralized governance. Rules are created in each member account automatically. Managed via the Config Aggregator.
---

---
**Card #158** | Domain: 4
**Q:** How does IAM Access Analyzer policy generation work?
**A:** Analyzes CloudTrail logs (up to 90 days) to generate a least-privilege IAM policy based on actual API usage. Creates a policy that grants only the permissions that were actually used. Helps implement the principle of least privilege.
---

---
**Card #159** | Domain: 4
**Q:** What is an IAM session policy?
**A:** A policy passed inline when assuming a role or federating. Further restricts the role's permissions for that session (intersection of role policy and session policy). Cannot grant more permissions than the role has. Used for temporary, scoped-down access.
---

---
**Card #160** | Domain: 4
**Q:** How do you prevent member accounts from leaving the organization?
**A:** Apply an SCP that denies `organizations:LeaveOrganization`. Since SCPs affect member accounts, they cannot call this API even if their IAM policies allow it. The management account is exempt from SCPs.
---

---
**Card #161** | Domain: 4
**Q:** What is the difference between proactive and detective controls?
**A:** **Proactive**: prevent non-compliant resources before creation (CloudFormation Guard, Hooks, SCPs). **Detective**: identify non-compliant resources after creation (Config Rules, Security Hub, Inspector). Both are needed for comprehensive governance.
---

---
**Card #162** | Domain: 4
**Q:** How do you enforce MFA for sensitive operations?
**A:** IAM policy condition: `"Bool": {"aws:MultiFactorAuthPresent": "true"}` or `"NumericLessThan": {"aws:MultiFactorAuthAge": "3600"}`. SCP can deny specific actions without MFA across the organization.
---

---
**Card #163** | Domain: 4
**Q:** What is AWS Systems Manager Compliance?
**A:** Shows compliance status of managed instances against patch baselines (Patch Manager) and associations (State Manager). Provides a dashboard of compliant/non-compliant instances. Data can be synced to S3 and queried with Athena.
---

---
**Card #164** | Domain: 4
**Q:** How do you detect and remediate public S3 buckets?
**A:** Detect: Config rule `s3-bucket-public-read-prohibited` / `s3-bucket-public-write-prohibited`, Access Analyzer, S3 Access Points. Remediate: Config auto-remediation with SSM Automation, S3 Block Public Access (account or bucket level), EventBridge + Lambda.
---

---
**Card #165** | Domain: 4
**Q:** What are AWS Organizations delegated administrators?
**A:** Member accounts designated to manage specific AWS services on behalf of the organization (e.g., Config aggregator, Security Hub, GuardDuty). Reduces the need to use the management account for daily operations. Configured per service.
---

## Domain 5: Incident and Event Response (Cards 166–210)

---
**Card #166** | Domain: 5
**Q:** What are the main components of Amazon EventBridge?
**A:** **Event buses** (default, custom, partner), **Rules** (match events using patterns), **Targets** (services that process events — Lambda, SQS, SNS, Step Functions, etc.), **Schema Registry** (discover and store event schemas), **Pipes** (point-to-point integrations).
---

---
**Card #167** | Domain: 5
**Q:** What content filtering options are available in EventBridge event patterns?
**A:** **Prefix** (`"prefix": "prod-"`), **Suffix** (`"suffix": ".png"`), **Anything-but** (`"anything-but": ["value"]`), **Numeric** (`"numeric": [">", 100]`), **Exists** (`"exists": true/false`), **Equals-ignore-case** (`"equals-ignore-case": "value"`), **Wildcard** (`"wildcard": "*.log"`).
---

---
**Card #168** | Domain: 5
**Q:** What is an EventBridge event bus and what types exist?
**A:** A bus receives events. **Default bus**: receives AWS service events automatically. **Custom bus**: receives events from your applications via `PutEvents` API. **Partner bus**: receives events from SaaS partners (Datadog, Zendesk, Auth0).
---

---
**Card #169** | Domain: 5
**Q:** How does EventBridge archive and replay work?
**A:** **Archive**: store events that match a pattern (or all events) from a bus with configurable retention. **Replay**: replay archived events to the bus for a specified time range. Used for debugging, testing, and disaster recovery.
---

---
**Card #170** | Domain: 5
**Q:** What is EventBridge Pipes?
**A:** Point-to-point integrations connecting a source to a target with optional filtering, enrichment, and transformation. Sources: SQS, Kinesis, DynamoDB Streams, Managed Streaming for Kafka. Targets: 14+ AWS services. Simpler than building with rules.
---

---
**Card #171** | Domain: 5
**Q:** What are the types of Auto Scaling scaling policies?
**A:** **Target Tracking** (maintain a metric at target value, e.g., CPU at 50%), **Step Scaling** (scale by different amounts based on alarm thresholds), **Simple Scaling** (scale by a fixed amount on alarm — legacy, has cooldown), **Scheduled Scaling** (scale at specific times), **Predictive Scaling** (ML-based forecast).
---

---
**Card #172** | Domain: 5
**Q:** What is an Auto Scaling cooldown period?
**A:** Time after a scaling activity during which further scaling actions are suppressed (default 300 seconds). Applies to **Simple Scaling** only. **Target Tracking** and **Step Scaling** handle this automatically. Prevents thrashing due to rapid scale in/out.
---

---
**Card #173** | Domain: 5
**Q:** What are Auto Scaling warm pools?
**A:** Pre-initialized EC2 instances kept in a stopped (or running/hibernated) state. When a scale-out occurs, instances from the warm pool are used instead of launching from scratch — reduces launch latency. Pool size can be set with min and max.
---

---
**Card #174** | Domain: 5
**Q:** How does Auto Scaling instance refresh work?
**A:** Replaces instances in the ASG to deploy updates (e.g., new AMI). Configurable `MinHealthyPercentage` (minimum instances healthy during refresh). Supports **skip matching** (skip instances already using the desired config). Uses a rolling replacement strategy.
---

---
**Card #175** | Domain: 5
**Q:** What are Auto Scaling lifecycle hooks?
**A:** Pause instances during launch (`EC2_INSTANCE_LAUNCHING`) or termination (`EC2_INSTANCE_TERMINATING`). Instance enters `Pending:Wait` or `Terminating:Wait` state. Allows custom actions (install software, drain connections). Default timeout: 1 hour (max 48 hours). Must send `CONTINUE` or `ABANDON`.
---

---
**Card #176** | Domain: 5
**Q:** What are the Auto Scaling termination policies?
**A:** **Default**: oldest launch config/template → closest to next billing hour → random. Others: **OldestInstance**, **NewestInstance**, **OldestLaunchConfiguration**, **OldestLaunchTemplate**, **ClosestToNextInstanceHour**, **AllocationStrategy**. AZ balance is checked first.
---

---
**Card #177** | Domain: 5
**Q:** What are mixed instances policies in Auto Scaling?
**A:** Combine On-Demand and Spot instances in an ASG. Configure: instance type priorities, On-Demand base capacity, On-Demand/Spot percentage above base, Spot allocation strategies (capacity-optimized, lowest-price, price-capacity-optimized).
---

---
**Card #178** | Domain: 5
**Q:** What is predictive scaling in Auto Scaling?
**A:** Uses ML to analyze historical metrics and forecast future demand. Creates scheduled scaling actions in advance. Requires at least 24 hours of data (best with 14 days). Works alongside reactive policies. Modes: forecast-only or forecast-and-scale.
---

---
**Card #179** | Domain: 5
**Q:** What are the two SNS topic types?
**A:** **Standard**: best-effort ordering, at-least-once delivery, high throughput. **FIFO**: strict ordering, exactly-once delivery, limited to SQS FIFO subscribers only, 300 messages/sec (3000 with batching).
---

---
**Card #180** | Domain: 5
**Q:** How does SNS message filtering work?
**A:** Apply filter policies to subscriptions. Only messages whose attributes match the policy are delivered. Supports exact value, prefix, anything-but, numeric range, exists, and string matching. Filter on **message attributes** (default) or **message body**.
---

---
**Card #181** | Domain: 5
**Q:** What is the SNS fan-out pattern?
**A:** Publish one message to an SNS topic that delivers to multiple SQS queues (and/or other endpoints) simultaneously. Each subscriber processes the message independently. Common for decoupling and parallel processing. SNS → multiple SQS queues.
---

---
**Card #182** | Domain: 5
**Q:** What is the difference between Standard and FIFO SQS queues?
**A:** **Standard**: unlimited throughput, at-least-once delivery, best-effort ordering. **FIFO**: 300 msg/sec (3000 with batching), exactly-once processing, strict message ordering, requires MessageGroupId, supports deduplication (content-based or MessageDeduplicationId).
---

---
**Card #183** | Domain: 5
**Q:** What is the SQS Dead Letter Queue (DLQ)?
**A:** A queue that receives messages that failed processing after a specified number of receive attempts (`maxReceiveCount` in redrive policy). Used for debugging. DLQ redrive moves messages back to the source queue. DLQ must be the same type as the source (Standard/FIFO).
---

---
**Card #184** | Domain: 5
**Q:** What is SQS visibility timeout?
**A:** Period during which a message is invisible to other consumers after being received. Default: 30 seconds. Max: 12 hours. If processing completes, consumer deletes the message. If timeout expires before deletion, message becomes visible again. Adjust to match processing time.
---

---
**Card #185** | Domain: 5
**Q:** How do you scale based on SQS queue depth?
**A:** Use `ApproximateNumberOfMessagesVisible` metric. For target tracking: use a custom metric `(backlog per instance) = messages visible / number of instances`. Set target to acceptable backlog per instance. Step scaling can also be used with threshold-based alarms.
---

---
**Card #186** | Domain: 5
**Q:** What are Lambda event source mappings?
**A:** Integration for poll-based sources: SQS, Kinesis, DynamoDB Streams, MSK, self-managed Kafka, MQ. Lambda polls the source, batches records, and invokes the function. Configurable batch size, batch window, and error handling (bisect, max retries, destination).
---

---
**Card #187** | Domain: 5
**Q:** What are Lambda destinations?
**A:** Route the result of asynchronous Lambda invocations to another service. Configure **on-success** and **on-failure** destinations separately. Supported: SQS, SNS, Lambda, EventBridge. Preferred over DLQ because destinations carry more context (request/response payload).
---

---
**Card #188** | Domain: 5
**Q:** How does Lambda concurrency work?
**A:** **Reserved concurrency**: guarantees AND limits concurrency for a function. **Provisioned concurrency**: pre-initializes execution environments (eliminates cold starts). **Unreserved**: shared pool. Account default limit: 1000 concurrent executions (soft limit).
---

---
**Card #189** | Domain: 5
**Q:** How do Lambda versions and aliases work?
**A:** **Version**: immutable snapshot of function code + config ($LATEST is mutable). **Alias**: pointer to a version (e.g., `prod` → v5). Aliases support **weighted routing** for traffic shifting (e.g., 90% v5, 10% v6) — used with CodeDeploy for canary/linear deployments.
---

---
**Card #190** | Domain: 5
**Q:** How do you implement canary deployments with Lambda?
**A:** Use Lambda aliases with weighted traffic shifting, managed by CodeDeploy. Configure in SAM template with `AutoPublishAlias` and `DeploymentPreference` (type: Canary10Percent5Minutes). Pre/post traffic hooks validate the new version. Automatic rollback on CloudWatch alarm.
---

---
**Card #191** | Domain: 5
**Q:** What are the Step Functions state types?
**A:** **Task** (do work — Lambda, ECS, SNS, etc.), **Choice** (branching logic), **Wait** (delay), **Parallel** (concurrent branches), **Map** (iterate over items), **Pass** (pass input to output), **Succeed** (end with success), **Fail** (end with failure).
---

---
**Card #192** | Domain: 5
**Q:** How does error handling work in Step Functions?
**A:** Use **Retry** (with ErrorEquals, IntervalSeconds, MaxAttempts, BackoffRate) and **Catch** (with ErrorEquals, Next, ResultPath) on Task and Parallel states. Built-in error names: `States.ALL`, `States.TaskFailed`, `States.Timeout`, `States.Permissions`.
---

---
**Card #193** | Domain: 5
**Q:** What is the difference between Standard and Express Step Functions?
**A:** **Standard**: max 1-year duration, exactly-once execution, higher price, execution history in console. **Express**: max 5-minute duration, at-least-once (async) or at-most-once (sync) execution, lower price, higher throughput, logs to CloudWatch.
---

---
**Card #194** | Domain: 5
**Q:** What are Step Functions service integrations?
**A:** Three patterns: **Request/Response** (call and continue), **Run a Job (.sync)** (wait for job to complete — ECS, CodeBuild, Glue), **Wait for Callback (.waitForTaskToken)** (pause until a token is returned — human approval, external system). Over 200 AWS service integrations.
---

---
**Card #195** | Domain: 5
**Q:** How do you handle AWS Health events programmatically?
**A:** AWS Health events are sent to EventBridge (default bus). Create rules matching `aws.health` source. Events include scheduled maintenance, operational issues, and account notifications. Use with Lambda, SNS, or incident management workflows. Organization Health via the management account.
---

---
**Card #196** | Domain: 5
**Q:** What is Amazon GuardDuty?
**A:** Intelligent threat detection using ML, anomaly detection, and threat intelligence. Analyzes CloudTrail logs, VPC Flow Logs, DNS logs, EKS audit logs, S3 data events, and RDS login activity. Generates findings (low/medium/high severity). Sends findings to EventBridge.
---

---
**Card #197** | Domain: 5
**Q:** How do you automate incident response for GuardDuty findings?
**A:** GuardDuty finding → EventBridge rule (filter by severity/type) → Lambda (isolate instance by replacing security group, snapshot EBS, create forensics instance) + SNS (notify team). Step Functions can orchestrate complex response workflows.
---

---
**Card #198** | Domain: 5
**Q:** What is the EventBridge schema registry?
**A:** Stores event schemas (structure of events). **Schema discovery** automatically detects schemas from events on a bus. **Code bindings** generate typed code (Java, Python, TypeScript) from schemas. Simplifies developing event-driven applications.
---

---
**Card #199** | Domain: 5
**Q:** How does Auto Scaling with ELB health checks differ from EC2 health checks?
**A:** **EC2 health checks**: only check instance status (running/not running). **ELB health checks**: also check application health via the load balancer's health check endpoint. If ELB reports unhealthy, ASG terminates and replaces the instance. Always use ELB checks with load-balanced ASGs.
---

---
**Card #200** | Domain: 5
**Q:** What is an EventBridge input transformer?
**A:** Customizes the event data before delivering to the target. Two parts: **Input Path** (extract values from the event JSON) and **Input Template** (create the payload using extracted values). Reduces the need for intermediate Lambda functions.
---

---
**Card #201** | Domain: 5
**Q:** How do you implement automated EC2 instance isolation on security finding?
**A:** EventBridge rule catches GuardDuty/Security Hub finding → Lambda removes the instance from its security group and attaches an isolation SG (no inbound, outbound only to forensics tools). Tag the instance for investigation. Optionally snapshot EBS volumes.
---

---
**Card #202** | Domain: 5
**Q:** What is SQS long polling and how do you enable it?
**A:** Long polling waits for messages instead of returning empty responses. Reduces API calls and cost. Enable by setting `ReceiveMessageWaitTimeSeconds` > 0 (max 20 seconds) on the queue, or `WaitTimeSeconds` in the ReceiveMessage API call.
---

---
**Card #203** | Domain: 5
**Q:** What happens when a Lambda event source mapping encounters an error from a Kinesis or DynamoDB stream?
**A:** By default, Lambda retries until the record expires from the stream (blocking the shard). Mitigation: configure **bisect batch on error** (split batch and retry), **max retry attempts**, **max record age**, and **on-failure destination** (SQS/SNS for failed records).
---

---
**Card #204** | Domain: 5
**Q:** What is the difference between synchronous and asynchronous Lambda invocation?
**A:** **Synchronous**: caller waits for response (API Gateway, ALB, SDK invoke). Caller handles retries. **Asynchronous**: Lambda queues the event (S3, SNS, EventBridge). Lambda retries twice on failure. Supports DLQ and destinations.
---

---
**Card #205** | Domain: 5
**Q:** How does Systems Manager Incident Manager work?
**A:** Automated incident response service. Define response plans (engagement plans, runbooks, escalation). Integrates with CloudWatch alarms and EventBridge. Creates incidents, engages on-call responders, runs SSM Automation runbooks, tracks timelines and post-incident analysis.
---

---
**Card #206** | Domain: 5
**Q:** What is the difference between EventBridge rules and Pipes?
**A:** **Rules**: one-to-many, match events from a bus, route to multiple targets. **Pipes**: one-to-one, point-to-point from a source (SQS, Kinesis, DynamoDB Stream) to a single target with optional enrichment. Pipes are simpler for direct integrations.
---

---
**Card #207** | Domain: 5
**Q:** How do you implement backpressure handling with SQS and Lambda?
**A:** Configure Lambda event source mapping with `MaximumConcurrency` to limit concurrent function invocations per SQS source. Use reserved concurrency. Set appropriate batch size and batch window. DLQ handles persistent failures.
---

---
**Card #208** | Domain: 5
**Q:** What is the SNS + SQS + Lambda pattern for reliable event processing?
**A:** SNS fans out to multiple SQS queues. Lambda processes from SQS. Benefits: decoupled, buffered (SQS absorbs spikes), reliable (SQS retries + DLQ), scalable (Lambda scales with queue depth). Better than direct SNS → Lambda for high-volume scenarios.
---

---
**Card #209** | Domain: 5
**Q:** How do you implement a circuit breaker pattern in AWS?
**A:** Use Step Functions with a DynamoDB table tracking failure counts. On failure, increment counter. When threshold is reached, circuit opens — skip service calls and return fallback. A Wait state provides the "half-open" window to test recovery. Also: ECS deployment circuit breaker for rolling deployments.
---

---
**Card #210** | Domain: 5
**Q:** What is the ECS deployment circuit breaker?
**A:** Monitors ECS rolling deployments. If tasks repeatedly fail to reach RUNNING state, the deployment is automatically rolled back to the last completed deployment. Enable with `deploymentCircuitBreaker: { enable: true, rollback: true }` in the service definition.
---

## Domain 6: High Availability, Fault Tolerance, and Disaster Recovery (Cards 211–260)

---
**Card #211** | Domain: 6
**Q:** What are the four DR strategies in order of cost and RTO/RPO?
**A:** 1) **Backup & Restore** (cheapest, highest RTO/RPO — hours). 2) **Pilot Light** (minimal core running, RTO/RPO: 10s of minutes). 3) **Warm Standby** (scaled-down full copy, RTO/RPO: minutes). 4) **Multi-site Active/Active** (most expensive, lowest RTO/RPO — near zero).
---

---
**Card #212** | Domain: 6
**Q:** What is the Pilot Light DR strategy?
**A:** Keep the core infrastructure running in the DR region (database replication, AMIs ready) but don't run application servers. On failover, launch application tier from pre-configured resources. Faster than backup/restore because data layer is live.
---

---
**Card #213** | Domain: 6
**Q:** What is the Warm Standby DR strategy?
**A:** Run a scaled-down but fully functional copy of the production environment in the DR region. On failover, scale up resources (ASG, DB instance size) and switch traffic via Route 53. Faster recovery than pilot light because apps are already running.
---

---
**Card #214** | Domain: 6
**Q:** How does RDS Multi-AZ work?
**A:** Synchronous replication to a standby instance in a different AZ. Automatic failover (DNS endpoint updated, 60-120 seconds). Standby is NOT readable (except Multi-AZ DB cluster which has 2 readable standbys). Protects against AZ failure, instance failure, and maintenance.
---

---
**Card #215** | Domain: 6
**Q:** How does Aurora Multi-AZ differ from RDS Multi-AZ?
**A:** Aurora stores data in a shared cluster volume across 3 AZs (6 copies of data). Read replicas (up to 15) in different AZs serve as failover targets. Failover promotes a replica (typically < 30 seconds). Aurora handles replication at the storage layer, not the DB engine layer.
---

---
**Card #216** | Domain: 6
**Q:** What is Aurora Global Database?
**A:** Cross-region replication with a primary region (read/write) and up to 5 secondary regions (read-only, < 1 second replication lag). Supports **managed planned failover** (switchover, no data loss) and **unplanned failover** (detach and promote, potential minimal data loss). RPO ~1 second.
---

---
**Card #217** | Domain: 6
**Q:** What are the Route 53 routing policies?
**A:** **Simple** (single resource), **Weighted** (traffic split by weight), **Latency** (lowest latency region), **Failover** (active-passive with health checks), **Geolocation** (by user location), **Geoproximity** (by proximity with bias), **Multivalue Answer** (multiple healthy IPs), **IP-based** (by client CIDR).
---

---
**Card #218** | Domain: 6
**Q:** How do Route 53 health checks work for DR failover?
**A:** Create health checks for primary region endpoints. Configure failover routing policy with primary and secondary records. When the primary health check fails, Route 53 automatically routes to the secondary. Health checks can monitor endpoints, other health checks (calculated), or CloudWatch alarms.
---

---
**Card #219** | Domain: 6
**Q:** What is CloudFront origin failover?
**A:** Configure an origin group with a primary and secondary origin. If the primary returns specific error status codes (500, 502, 503, 504, 404, 403), CloudFront automatically routes the request to the secondary origin. Provides regional failover for static content.
---

---
**Card #220** | Domain: 6
**Q:** What is S3 Cross-Region Replication (CRR)?
**A:** Asynchronous replication of S3 objects to a bucket in a different region. Requires versioning on both buckets. Can replicate to a different account. Supports filtering by prefix or tags. Use for compliance, latency reduction, and DR.
---

---
**Card #221** | Domain: 6
**Q:** What are the key differences between S3 CRR and S3 Same-Region Replication (SRR)?
**A:** **CRR**: different regions, used for compliance/DR/latency. **SRR**: same region, used for log aggregation, replication between production and test accounts, or compliance. Both require versioning, are asynchronous, and support cross-account.
---

---
**Card #222** | Domain: 6
**Q:** What are DynamoDB Global Tables?
**A:** Multi-region, multi-active replicated tables. Uses last-writer-wins for conflict resolution. Provides sub-second replication, local read/write performance. Requires DynamoDB Streams enabled. All replicas accept reads AND writes. Automatic failover.
---

---
**Card #223** | Domain: 6
**Q:** What ElastiCache Multi-AZ options exist?
**A:** **Redis**: supports Multi-AZ with automatic failover using read replicas. If primary fails, a replica is promoted. **Memcached**: NO Multi-AZ failover — nodes are independent. Redis also supports cluster mode for partitioning data across shards.
---

---
**Card #224** | Domain: 6
**Q:** What is AWS Backup?
**A:** Centralized backup service for EC2, EBS, RDS, DynamoDB, EFS, FSx, S3, Aurora, DocumentDB, Neptune, Storage Gateway, VMware, and SAP HANA. Define **Backup Plans** (schedule, retention, lifecycle) and **Backup Vaults** (storage, access policies, lock for WORM).
---

---
**Card #225** | Domain: 6
**Q:** How does AWS Backup support cross-account and cross-region backup?
**A:** **Cross-region**: configure a copy rule in the backup plan to replicate to another region's vault. **Cross-account**: use AWS Organizations and Backup policies to backup resources in member accounts to a central vault in a different account.
---

---
**Card #226** | Domain: 6
**Q:** What is EBS Data Lifecycle Manager (DLM)?
**A:** Automates EBS snapshot creation, retention, and deletion. Define lifecycle policies with schedules, retention rules, and target tags. Supports cross-region copy, cross-account sharing, and fast snapshot restore. Simplifies snapshot management at scale.
---

---
**Card #227** | Domain: 6
**Q:** What is AWS Elastic Disaster Recovery (DRS)?
**A:** Block-level continuous replication of source servers to AWS. Maintains low RPO (seconds). On failover, launches recovery instances from replicated data. Supports automated failover and failback. Replaces CloudEndure Disaster Recovery.
---

---
**Card #228** | Domain: 6
**Q:** What is the retry pattern and how is it implemented in AWS?
**A:** Retry failed operations with exponential backoff and jitter. AWS SDKs implement this automatically. In Step Functions, use `Retry` with `BackoffRate` and `MaxAttempts`. In Lambda, configure retry attempts for async invocations. Always include jitter to avoid thundering herd.
---

---
**Card #229** | Domain: 6
**Q:** What is idempotency and why is it important in distributed systems?
**A:** An operation that produces the same result if executed once or multiple times. Critical for retry safety. Implement with: idempotency keys (DynamoDB conditional writes), Lambda Powertools idempotency utility, SQS FIFO deduplication, `ClientRequestToken` in CloudFormation.
---

---
**Card #230** | Domain: 6
**Q:** How does EC2 Auto Recovery work?
**A:** CloudWatch alarm monitors the instance status check. If the **system** status check fails (underlying hardware issue), the instance is automatically migrated to new hardware. Retains instance ID, IP, EBS volumes, and placement group. Only works for instances with EBS-only storage.
---

---
**Card #231** | Domain: 6
**Q:** How do you implement self-healing with Auto Scaling?
**A:** Set min capacity = desired capacity. If an instance fails health checks (EC2 or ELB), ASG terminates it and launches a replacement. Use ELB health checks for application-level healing. Combine with lifecycle hooks for graceful startup.
---

---
**Card #232** | Domain: 6
**Q:** What is the ECS deployment circuit breaker and how does it enable self-healing?
**A:** Monitors rolling deployments. If new tasks repeatedly fail, automatically rolls back to the last stable deployment. Combined with ECS service auto scaling, ECS continuously maintains desired task count and replaces unhealthy tasks.
---

---
**Card #233** | Domain: 6
**Q:** How does Route 53 enable self-healing architectures?
**A:** Health checks monitor endpoints. Failover routing automatically redirects traffic when primary is unhealthy. Calculated health checks combine multiple checks. Can monitor CloudWatch alarms for custom health criteria. DNS failover happens automatically.
---

---
**Card #234** | Domain: 6
**Q:** What is the RTO and RPO for each DR strategy?
**A:** **Backup/Restore**: RTO hours, RPO hours. **Pilot Light**: RTO 10s of minutes, RPO minutes. **Warm Standby**: RTO minutes, RPO seconds-minutes. **Multi-site Active/Active**: RTO near-zero, RPO near-zero (or zero with sync replication).
---

---
**Card #235** | Domain: 6
**Q:** How do you implement multi-region active-active with DynamoDB?
**A:** Use DynamoDB Global Tables for multi-region read/write. Route 53 latency-based routing to regional API endpoints. API Gateway with regional endpoints in each region. Lambda functions in each region. Sub-second replication between regions.
---

---
**Card #236** | Domain: 6
**Q:** What is an Aurora cluster endpoint vs reader endpoint vs custom endpoint?
**A:** **Cluster (writer) endpoint**: connects to the current primary instance. **Reader endpoint**: load-balances across read replicas. **Custom endpoint**: you define which instances to include (e.g., larger instances for analytics queries). Writer endpoint auto-updates on failover.
---

---
**Card #237** | Domain: 6
**Q:** How does S3 achieve 99.999999999% (11 9s) durability?
**A:** S3 automatically stores data redundantly across a minimum of 3 AZs (for Standard). Uses checksums to detect and repair corruption. Objects are replicated synchronously before returning success. S3 One Zone-IA uses a single AZ and has lower durability guarantees.
---

---
**Card #238** | Domain: 6
**Q:** What is AWS Global Accelerator and how does it support DR?
**A:** Provides static anycast IP addresses that route traffic to optimal AWS endpoints globally. Health checks automatically failover to healthy endpoints in other regions. Provides faster failover than DNS-based (Route 53) because no TTL caching issues.
---

---
**Card #239** | Domain: 6
**Q:** What is the difference between RPO and RTO?
**A:** **RPO (Recovery Point Objective)**: maximum acceptable data loss measured in time — how far back you can afford to lose data. **RTO (Recovery Time Objective)**: maximum acceptable downtime — how quickly you must recover operations.
---

---
**Card #240** | Domain: 6
**Q:** How do you test DR plans in AWS?
**A:** Regular DR drills: use AWS Fault Injection Simulator (FIS) for chaos engineering, test failover procedures, measure actual RTO/RPO, validate runbooks. GameDays simulate failures. Elastic Disaster Recovery supports non-disruptive recovery drills.
---

---
**Card #241** | Domain: 6
**Q:** What is AWS Fault Injection Simulator (FIS)?
**A:** Managed chaos engineering service. Run controlled fault injection experiments: stop instances, throttle APIs, inject latency, disrupt networking. Define experiment templates with actions, targets, and stop conditions. Integrates with CloudWatch alarms for safety.
---

---
**Card #242** | Domain: 6
**Q:** How does ElastiCache Redis replication and failover work?
**A:** Redis replication group: 1 primary + up to 5 replicas across AZs. Async replication. Multi-AZ failover: if primary fails, a replica is automatically promoted (typically 30-60 seconds). Cluster mode adds sharding for horizontal scaling.
---

---
**Card #243** | Domain: 6
**Q:** What are the S3 storage classes relevant to DR?
**A:** **S3 Standard** (multi-AZ, frequently accessed), **S3 Standard-IA** (multi-AZ, infrequent), **S3 One Zone-IA** (single AZ, lower cost), **S3 Glacier Instant Retrieval** (milliseconds), **S3 Glacier Flexible** (minutes-hours), **S3 Glacier Deep Archive** (12-48 hours). Use lifecycle policies for cost optimization.
---

---
**Card #244** | Domain: 6
**Q:** How do you implement a multi-region API with API Gateway?
**A:** Deploy **Regional** API Gateway endpoints in each region. Use Route 53 latency-based or failover routing. DynamoDB Global Tables for data. Lambda functions deployed in each region. Custom domain names with Route 53 for unified URL.
---

---
**Card #245** | Domain: 6
**Q:** What is AWS Backup Vault Lock?
**A:** Enforces WORM (Write Once Read Many) policy on a backup vault. Once locked, backups cannot be deleted by anyone (including root) before the retention period expires. Supports governance mode (can be removed) and compliance mode (cannot be removed).
---

---
**Card #246** | Domain: 6
**Q:** How does EFS achieve high availability?
**A:** EFS stores data and metadata across multiple AZs within a region. Mount targets in multiple AZs enable access from any AZ. Supports automatic failover. Regional service by default. EFS One Zone stores data in a single AZ for cost savings.
---

---
**Card #247** | Domain: 6
**Q:** What is the difference between RDS Multi-AZ instance and Multi-AZ DB cluster?
**A:** **Multi-AZ Instance**: one primary + one standby (not readable), synchronous replication, failover 60-120s. **Multi-AZ DB Cluster**: one writer + two readers (readable, usable for read traffic), faster failover (~35s), uses local NVMe SSD, supports only MySQL and PostgreSQL.
---

---
**Card #248** | Domain: 6
**Q:** How do you implement automated failover for a web application?
**A:** Route 53 failover routing with health checks → ALB in each region → ASG with ELB health checks for self-healing → Multi-AZ RDS or Aurora Global Database → S3 CRR for static assets. EventBridge + Lambda for additional automation.
---

---
**Card #249** | Domain: 6
**Q:** What is a split-brain scenario in HA and how do you prevent it?
**A:** When both sides of a cluster believe they are the primary, leading to data conflicts. Prevention: use quorum-based systems (Aurora, DynamoDB), proper fencing mechanisms, and leader election algorithms. AWS managed services handle this internally.
---

---
**Card #250** | Domain: 6
**Q:** How does AWS handle AZ failure for managed services?
**A:** Most managed services (ALB, RDS Multi-AZ, ECS, Lambda, DynamoDB) automatically failover to healthy AZs. ALB cross-zone load balancing distributes traffic. ASG replaces instances in the failed AZ by launching in healthy AZs. Design for at least 2 AZ redundancy.
---

---
**Card #251** | Domain: 6
**Q:** What is an RDS Read Replica and how does it differ from Multi-AZ?
**A:** **Read Replica**: async replication, readable, can be in same/different region, used for read scaling and DR. **Multi-AZ**: sync replication, NOT readable (standby), same region, used for HA. A read replica can be promoted to a standalone DB for DR.
---

---
**Card #252** | Domain: 6
**Q:** What is the maximum RTO achievable with Aurora Global Database?
**A:** Managed planned failover: minutes (no data loss). Unplanned failover (detach and promote): typically < 1 minute, RPO ~1 second. Cross-region failover is faster than traditional RDS cross-region read replica promotion.
---

---
**Card #253** | Domain: 6
**Q:** How does DynamoDB on-demand backup differ from continuous backups (PITR)?
**A:** **On-demand**: manual or scheduled full backups, no performance impact, retained until deleted. **PITR**: continuous backup with 35-day retention, restore to any second within the window. Both create a new table on restore (not in-place).
---

---
**Card #254** | Domain: 6
**Q:** What is the Lambda reserved concurrency's role in fault tolerance?
**A:** Reserved concurrency guarantees a function always has capacity (not starved by other functions) AND limits it to prevent a runaway function from consuming all account concurrency. Protects both the function and other functions in the account.
---

---
**Card #255** | Domain: 6
**Q:** How do you design for fault tolerance with SQS?
**A:** Use SQS as a buffer between components. If downstream fails, messages stay in queue (up to 14 days retention). DLQ captures poison messages. Visibility timeout prevents duplicate processing. FIFO for ordered, exactly-once processing. Enables graceful degradation.
---

---
**Card #256** | Domain: 6
**Q:** What is the difference between HA and fault tolerance?
**A:** **High Availability (HA)**: system remains operational with minimal downtime (allows brief interruptions). **Fault Tolerance (FT)**: system continues operating without any interruption even when components fail. FT is more expensive and complex. HA accepts some downtime; FT accepts none.
---

---
**Card #257** | Domain: 6
**Q:** How do you implement cross-region disaster recovery for EKS?
**A:** Use GitOps (ArgoCD/Flux) to deploy to multiple clusters. Persistent data: EBS snapshots with cross-region copy, or use EFS with DataSync. DNS failover via Route 53. Infrastructure: CloudFormation StackSets or Terraform for multi-region cluster creation.
---

---
**Card #258** | Domain: 6
**Q:** What is the AWS Well-Architected Reliability Pillar's key design principle?
**A:** **Automatically recover from failure.** Monitor KPIs, trigger automation when thresholds are breached, and automatically remediate. Also: test recovery procedures, scale horizontally, stop guessing capacity, and manage change through automation.
---

---
**Card #259** | Domain: 6
**Q:** How does Amazon S3 Transfer Acceleration help with DR?
**A:** Uses CloudFront edge locations to accelerate uploads to S3 buckets in distant regions. Useful for fast cross-region data replication in DR scenarios where large datasets need to be transferred quickly.
---

---
**Card #260** | Domain: 6
**Q:** What is the recommended approach for stateless vs stateful application DR?
**A:** **Stateless** (web/app tier): use ASG with launch templates, AMIs replicated cross-region, or containers (ECR cross-region). Fast to recreate. **Stateful** (databases): use managed replication (Aurora Global, DynamoDB Global, RDS cross-region read replicas). Stateless components have inherently lower RTO.
---

---

> **Study Tip:** Review these flashcards using spaced repetition. Focus on cards you get wrong and review them more frequently. Cover the answer before checking your recall.
