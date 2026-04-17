# Elastic Beanstalk, OpsWorks, AppConfig, and Proton Deep Dive

These services represent different approaches to application deployment and configuration management. Elastic Beanstalk is heavily tested on the DOP-C02 exam, with OpsWorks, AppConfig, and Proton appearing in more targeted scenarios.

---

## AWS Elastic Beanstalk

### Service Overview

Elastic Beanstalk is a PaaS that handles capacity provisioning, load balancing, auto scaling, and application health monitoring. You upload your code, and Beanstalk manages the underlying infrastructure. Despite the abstraction, you retain full control of the underlying resources.

### Platforms

Beanstalk supports managed platforms for:

- **Docker** (single container and multi-container via ECS)
- **Java** (SE, Tomcat)
- **.NET** (on Windows Server / IIS)
- **Node.js**
- **PHP**
- **Python**
- **Ruby** (Puma, Passenger)
- **Go**

Each platform has multiple **platform versions** that include specific OS, runtime, and web server versions.

### Environment Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Web server** | Runs behind an ELB, handles HTTP requests | Web applications, APIs |
| **Worker** | Processes messages from an SQS queue. Beanstalk manages the SQS queue and a daemon that polls it. | Background processing, async tasks |

### Deployment Policies

This is one of the **most frequently tested** Beanstalk topics:

| Policy | How It Works | Downtime | Rollback Speed | Cost |
|--------|-------------|----------|----------------|------|
| **All at once** | Deploy to all instances simultaneously | Yes (brief) | Manual redeploy | No extra cost |
| **Rolling** | Deploy in batches. Each batch is taken out of service, updated, then returned. | Reduced capacity during deployment | Manual redeploy | No extra cost |
| **Rolling with additional batch** | Launch a new batch of instances first, then rolling update. Maintains full capacity. | No downtime, full capacity maintained | Manual redeploy | Small additional cost for extra batch |
| **Immutable** | Launch an entirely new set of instances in a new ASG. Once healthy, swap into the original ASG and terminate old instances. | No downtime | Very fast (terminate new instances) | Double capacity during deployment |
| **Traffic splitting** | Launch new instances like immutable, but split traffic using ALB weighted target groups. Canary-style testing. | No downtime | Very fast (reroute traffic) | Double capacity during deployment |

> **Key Points for the Exam:**
> - **All at once** is fastest but causes downtime—suitable for dev/test.
> - **Rolling** reduces capacity—not ideal if you're at minimum capacity.
> - **Rolling with additional batch** is preferred when you must maintain full capacity during rolling updates.
> - **Immutable** is the safest for production—fast rollback by terminating the new ASG.
> - **Traffic splitting** is the most advanced—enables canary testing with real production traffic.
> - Know the trade-offs: speed, downtime, rollback time, cost.

### .ebextensions

The `.ebextensions` directory contains `.config` files (YAML/JSON) that customize the Beanstalk environment:

**Key sections:**

```yaml
# .ebextensions/01-custom.config

option_settings:
  aws:autoscaling:asg:
    MinSize: 2
    MaxSize: 10
  aws:elasticbeanstalk:application:environment:
    MY_ENV_VAR: "my-value"

Resources:
  MyDynamoDBTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: my-table
      AttributeDefinitions:
        - AttributeName: id
          AttributeType: S
      KeySchema:
        - AttributeName: id
          KeyType: HASH
      BillingMode: PAY_PER_REQUEST

files:
  "/etc/myapp/config.json":
    mode: "000644"
    owner: root
    group: root
    content: |
      {"key": "value"}

commands:
  01_install_dependency:
    command: "yum install -y jq"

container_commands:
  01_migrate_db:
    command: "python manage.py migrate"
    leader_only: true

packages:
  yum:
    postgresql-devel: []

services:
  sysvinit:
    myservice:
      enabled: true
      ensureRunning: true
```

**Important distinctions:**
- **`commands`**: Execute before the application is deployed (before app source is extracted). Run as root.
- **`container_commands`**: Execute after the application is deployed but before it is launched. Support `leader_only` for tasks that should run on only one instance (e.g., database migrations).
- **`Resources`**: Create additional AWS resources (uses CloudFormation syntax). These resources are part of the Beanstalk stack.
- **`option_settings`**: Configure Beanstalk environment options (instance type, scaling, environment variables).

> **Key Points for the Exam:**
> - **`leader_only: true`** in container_commands ensures the command runs on only one instance—critical for database migrations.
> - **`commands`** run before app extraction; **`container_commands`** run after extraction but before app starts.
> - Resources defined in `.ebextensions` are managed by the Beanstalk CloudFormation stack—they're deleted when the environment is terminated (unless you use `DeletionPolicy: Retain`).

### Platform Hooks

Platform hooks are scripts that run during specific deployment phases:

```
.platform/
  hooks/
    prebuild/    # Before Beanstalk builds the app (before nginx setup)
    predeploy/   # After build, before deployment
    postdeploy/  # After successful deployment
  confighooks/   # Same structure, runs on configuration changes only
```

- Scripts must be executable (`chmod +x`)
- Scripts run in alphabetical order
- Platform hooks are the **modern replacement** for `commands` and `container_commands` in `.ebextensions`

### Custom Platforms with Packer

For scenarios where no managed platform fits, create a custom platform:

- Use **Packer** to build a custom AMI
- Define a `platform.yaml` manifest
- `eb platform create` builds and registers the custom platform
- Useful for unsupported languages or heavily customized environments

### Environment Configuration

- **Saved configurations**: Save an environment's configuration to S3 for reuse. Apply to new or existing environments.
- **Environment manifest** (`env.yaml`): Define environment name, platform, and tier in a YAML file at the application root.
- **Configuration precedence** (highest to lowest): Direct API/CLI settings → Saved configurations → `.ebextensions` → Default values

### Managed Platform Updates

Beanstalk can automatically update the platform version:

- **Scheduling**: Set a maintenance window (day of week, time)
- **Update type**: Minor version and patch updates (e.g., platform version 3.4.1 → 3.4.5). Does not upgrade major versions.
- **Update method**: Uses **immutable** deployment to apply platform updates (zero downtime, fast rollback)

### Environment Cloning

Clone an existing environment with identical configuration:

- Creates a new environment with the same settings, resources, and platform version
- Useful for creating staging environments from production
- Does not clone data (databases, S3 contents)

### CNAME Swap for Blue/Green

Beanstalk blue/green deployment using CNAME swap:

1. Create a new environment with the new application version
2. Validate the new environment
3. **Swap environment URLs**: `eb swap` or console swap
4. DNS CNAME is updated to point to the new environment's load balancer
5. Terminate the old environment after validation

> **Key Points for the Exam:**
> - CNAME swap is **not instant**—DNS propagation may take time (TTL-dependent).
> - The swap exchanges the CNAME between two environments—both environments continue to exist until one is manually terminated.
> - This is the Beanstalk-native approach to blue/green deployments.

### Worker Environments

Worker environments process background tasks:

- Beanstalk creates an **SQS queue** and a daemon process
- The daemon pulls messages from the queue and POSTs them to `http://localhost/` on the instance
- **`cron.yaml`**: Define periodic tasks (cron-like scheduling) that post messages to the queue

```yaml
version: 1
cron:
  - name: "daily-cleanup"
    url: "/tasks/cleanup"
    schedule: "rate(1 day)"
  - name: "hourly-stats"
    url: "/tasks/stats"
    schedule: "cron(0 * * * ? *)"
```

### Lifecycle Policy for Application Versions

Beanstalk stores application versions in S3. Lifecycle policies manage cleanup:

- **Total count-based**: Keep only the last N versions
- **Age-based**: Delete versions older than N days
- Can choose to delete the S3 source bundle or just the version record
- The currently deployed version is never deleted

### Docker on Elastic Beanstalk

**Single container Docker**: Runs one Docker container per instance. Define with a `Dockerfile` or `Dockerrun.aws.json` (v1).

**Multi-container Docker**: Runs multiple containers per instance using **ECS**. Define with `Dockerrun.aws.json` (v2), which maps to an ECS task definition.

**`Dockerrun.aws.json` v2 example:**

```json
{
  "AWSEBDockerrunVersion": 2,
  "containerDefinitions": [
    {
      "name": "nginx-proxy",
      "image": "nginx",
      "essential": true,
      "memory": 128,
      "portMappings": [{ "hostPort": 80, "containerPort": 80 }],
      "links": ["app"]
    },
    {
      "name": "app",
      "image": "my-app:latest",
      "essential": true,
      "memory": 256
    }
  ]
}
```

### EB CLI Commands

| Command | Purpose |
|---------|---------|
| `eb init` | Initialize Beanstalk application (select region, platform, keypair) |
| `eb create` | Create a new environment |
| `eb deploy` | Deploy application to environment |
| `eb status` | View environment status |
| `eb health` | View detailed health information |
| `eb logs` | Retrieve logs |
| `eb swap` | Swap environment CNAMEs |
| `eb terminate` | Terminate an environment |
| `eb setenv` | Set environment variables |
| `eb config` | View/update environment configuration |

---

## AWS OpsWorks

### Service Overview

AWS OpsWorks is a configuration management service that provides managed instances of **Chef** and **Puppet**. It was more prominent in previous exam versions but still appears in DOP-C02 for migration and comparison scenarios.

### OpsWorks Stacks

OpsWorks Stacks uses a **stack → layers → instances** hierarchy:

- **Stack**: Top-level container representing an application. Defines VPC, region, default OS, default SSH key.
- **Layers**: Represent application tiers (web, app, database). Each layer has a set of recipes for lifecycle events.
- **Instances**: EC2 instances assigned to one or more layers.

### Lifecycle Events

Each layer responds to five lifecycle events, each running associated Chef recipes:

| Event | When It Runs |
|-------|-------------|
| **Setup** | After an instance finishes booting. Install packages, set up the base configuration. |
| **Configure** | Runs on **all instances in the stack** whenever any instance enters or leaves the online state. Updates configuration to reflect topology changes. |
| **Deploy** | When you deploy an app. Pulls code and configures the application. |
| **Undeploy** | When you remove an app from instances. |
| **Shutdown** | When an instance is stopped. Clean up, de-register from load balancers. Runs before the instance shuts down (configurable shutdown timeout). |

> **Key Points for the Exam:**
> - The **Configure** event is unique: it runs on **all instances**, not just the one that changed. This enables automatic reconfiguration when new instances join or leave.
> - **Deploy** only runs on the instances where you trigger the deployment.

### Custom Cookbooks and Berkshelf

- **Custom cookbooks**: Store Chef cookbooks in Git, S3, or HTTP archives. Enable custom cookbooks on the stack.
- **Berkshelf**: Dependency manager for Chef cookbooks. Specify dependencies in a `Berksfile`. OpsWorks installs Berkshelf-managed cookbooks automatically.

### Instance Types

| Type | Behavior |
|------|----------|
| **24/7** | Always running. Started/stopped manually. |
| **Time-based** | Automatically started/stopped on a schedule (e.g., business hours only). |
| **Load-based** | Automatically started/stopped based on CloudWatch metrics (CPU, memory, load). |

### OpsWorks for Chef Automate

Fully managed Chef Automate server:

- Chef Infra for configuration management
- Chef InSpec for compliance
- Chef Automate dashboard for visibility
- Supports all standard Chef workflows and cookbooks

### OpsWorks for Puppet Enterprise

Fully managed Puppet master:

- Puppet Enterprise console for node management
- Supports Puppet modules from the Puppet Forge
- Automated node provisioning and compliance

### Comparison with Other Tools

| Feature | OpsWorks Stacks | OpsWorks Chef/Puppet | Beanstalk | SSM |
|---------|----------------|---------------------|-----------|-----|
| Config Management | Chef recipes | Full Chef/Puppet | Platform-managed | Documents |
| Abstraction Level | Medium | Low (full Chef/Puppet) | High (PaaS) | Low (command-level) |
| Lifecycle Events | 5 built-in events | Standard Chef/Puppet | Deployment policies | Associations/Run Command |
| Scaling | Time/load-based instances | Manual | Auto Scaling | N/A (fleet management) |
| Use Case | Legacy Chef workloads | Teams already using Chef/Puppet | Quick app deployment | Operational management |

---

## AWS AppConfig

### Service Overview

AWS AppConfig (a capability of Systems Manager) manages application configuration separately from code deployments. It enables feature flags, operational tuning, and gradual configuration rollouts with safety controls.

### Core Concepts

- **Application**: Logical grouping (maps to a microservice or application)
- **Environment**: Deployment target (e.g., production, staging, beta)
- **Configuration profile**: The configuration data. Two types:
  - **Freeform**: Any structured data (JSON, YAML, text)
  - **Feature flags**: Built-in feature flag management with boolean/string/number flags

### Deployment Strategies

AppConfig deploys configuration changes gradually, similar to CodeDeploy traffic shifting:

| Strategy Type | Behavior |
|---------------|----------|
| **Linear** | Roll out in equal increments over time (e.g., 20% every 6 minutes over 30 minutes) |
| **Exponential** | Roll out with exponentially increasing percentages |
| **All at once** | Deploy to all targets immediately |
| **Custom** | Define growth type, growth factor, deployment duration, and bake time |

Key parameters:
- **Deployment duration**: Total time for the rollout
- **Growth factor**: Percentage increase at each step
- **Final bake time**: Monitoring period after 100% deployment before marking complete

### Validators

Validate configuration before deployment:

- **JSON Schema**: Validate the structure and data types of JSON configuration
- **Lambda function**: Custom validation logic (e.g., check that a configuration value is within acceptable bounds, verify feature flag combinations are compatible)

If validation fails, the deployment is rejected before it starts.

### Feature Flags

AppConfig provides native feature flag support:

- Define flags with boolean, string, or number values
- Set flag attributes for complex configurations
- Target specific user segments
- Gradual rollout via deployment strategies
- Instant rollback by deploying the previous configuration

### Integration with Lambda Extensions

The **AppConfig Lambda extension** fetches and caches configuration locally:

- Runs as a Lambda layer
- Caches configuration in memory, reducing API calls
- Automatically polls for configuration updates at a configurable interval
- Available at `http://localhost:2772/applications/{app}/environments/{env}/configurations/{config}`
- Significantly faster than calling the AppConfig API directly from Lambda code

> **Key Points for the Exam:**
> - AppConfig is for **configuration changes without code deployments**—feature flags, tuning parameters, allow/deny lists.
> - The Lambda extension is the recommended integration pattern for Lambda functions consuming AppConfig.
> - AppConfig deployment strategies are **independent** of application code deployments—you can change configuration without redeploying.

### Rollback Triggers

Associate CloudWatch alarms with AppConfig deployments:

- If an alarm enters ALARM state during deployment, AppConfig automatically rolls back to the previous configuration
- Monitors application health during gradual rollouts
- Analogous to CodeDeploy alarm-based rollback

---

## AWS Proton

### Service Overview

AWS Proton is a managed delivery service for platform teams to provide self-service infrastructure templates to developers. It separates infrastructure concerns (platform team) from application concerns (developer team).

### Core Concepts

**Environment templates:**
- Define shared infrastructure (VPC, ECS cluster, networking)
- Versioned and published by platform teams
- Developers select an environment template to deploy their infrastructure foundation

**Service templates:**
- Define the compute, CI/CD pipeline, and monitoring for an application
- Reference an environment template (compatible environments)
- Include **components** for developer-defined infrastructure extensions

**Components:**
- Developer-defined infrastructure that extends a service instance
- Directly provisioned by the developer (not part of the service template)
- Useful for resources specific to one service instance (e.g., an SQS queue for one microservice)

### Pipeline Provisioning

Proton can provision CI/CD pipelines as part of service templates:

- Templates define the pipeline stages (source, build, deploy)
- Pipelines are created when developers create service instances
- Supports CodePipeline as the pipeline provider

### Self-Service Model

1. **Platform team** creates and publishes environment and service templates
2. **Developers** select templates and create service instances
3. **Proton** provisions the infrastructure using the template
4. **Template updates** can be propagated to existing instances (with approval)

> **Key Points for the Exam:**
> - Proton addresses the "platform engineering" use case—standardized infrastructure templates for self-service.
> - Proton is less commonly tested than other services but may appear in scenarios about standardizing infrastructure delivery across teams.

---

## Cross-Service Comparison

### Deployment Strategy Comparison

| Service | Strategies Available |
|---------|---------------------|
| **Elastic Beanstalk** | All at once, Rolling, Rolling with additional batch, Immutable, Traffic splitting |
| **CodeDeploy (EC2)** | In-place (OneAtATime, HalfAtATime, AllAtOnce), Blue/Green |
| **CodeDeploy (ECS)** | Blue/Green (Canary, Linear, AllAtOnce) |
| **CodeDeploy (Lambda)** | Canary, Linear, AllAtOnce |
| **AppConfig** | Linear, Exponential, All at once, Custom |
| **OpsWorks** | Rolling (one layer at a time) |

### When to Use Which Service

| Scenario | Service |
|----------|---------|
| Quick app deployment with minimal infrastructure management | **Elastic Beanstalk** |
| Deploying application code to EC2 with lifecycle hooks | **CodeDeploy** |
| Feature flags and runtime configuration changes | **AppConfig** |
| Existing Chef/Puppet investment | **OpsWorks** |
| Standardized infrastructure templates for dev teams | **Proton** |
| OS patching and fleet management | **Systems Manager** |

---

## Summary: Top Exam Scenarios

1. **Zero-downtime deployment in Beanstalk**: Use **immutable** or **traffic splitting** deployment policy
2. **Database migration during Beanstalk deployment**: Use `container_commands` with **`leader_only: true`**
3. **Beanstalk blue/green deployment**: Use **CNAME swap** between two environments
4. **Maintain full capacity during rolling update**: Use **rolling with additional batch**
5. **Configuration changes separate from code deployment**: Use **AppConfig** with deployment strategies and rollback alarms
6. **Feature flags with gradual rollout**: **AppConfig** feature flags with linear/exponential deployment strategy
7. **OpsWorks topology change detection**: The **Configure** lifecycle event runs on all instances when any instance changes state
8. **Beanstalk worker cron jobs**: Define schedule in **`cron.yaml`** in the worker environment
9. **Custom resources in Beanstalk**: Define in `.ebextensions` `Resources` section (CloudFormation syntax)
10. **AppConfig in Lambda**: Use the **AppConfig Lambda extension** (layer) for cached, low-latency configuration retrieval
