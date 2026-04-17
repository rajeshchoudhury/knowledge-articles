# Elastic Beanstalk & App Runner

## Table of Contents

1. [Elastic Beanstalk Overview](#elastic-beanstalk-overview)
2. [Beanstalk Platforms](#beanstalk-platforms)
3. [Beanstalk Environments](#beanstalk-environments)
4. [Beanstalk Components](#beanstalk-components)
5. [Deployment Policies](#deployment-policies)
6. [Configuration Files (.ebextensions)](#configuration-files-ebextensions)
7. [Platform Hooks](#platform-hooks)
8. [Beanstalk with RDS](#beanstalk-with-rds)
9. [Beanstalk Lifecycle Policy](#beanstalk-lifecycle-policy)
10. [Blue/Green Deployment](#bluegreen-deployment)
11. [Custom Platform Using Packer](#custom-platform-using-packer)
12. [Beanstalk with Docker](#beanstalk-with-docker)
13. [App Runner Deep Dive](#app-runner-deep-dive)
14. [Amazon Lightsail](#amazon-lightsail)
15. [AWS Batch](#aws-batch)
16. [Service Comparison](#service-comparison)
17. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## Elastic Beanstalk Overview

AWS Elastic Beanstalk is a **Platform as a Service (PaaS)** that simplifies the deployment and management of web applications. You upload your code, and Beanstalk automatically handles capacity provisioning, load balancing, auto-scaling, and application health monitoring.

**Key characteristics:**
- **Developer-focused**: Abstract away infrastructure — focus on code
- **Full control retained**: You still have access to all underlying resources (EC2, ALB, ASG, RDS, etc.)
- **No additional cost**: You only pay for the underlying AWS resources
- **Infrastructure as Code**: All configuration is managed through Beanstalk's configuration system
- **Managed platform updates**: AWS provides patched and updated platform versions

**What Beanstalk provisions (typical web tier):**
- EC2 instances in an Auto Scaling Group
- Application Load Balancer
- Security groups
- CloudWatch alarms and metrics
- S3 bucket for application versions
- CloudFormation stack (Beanstalk uses CloudFormation under the hood)

---

## Beanstalk Platforms

A **platform** is a combination of an OS, runtime, web server, and application server.

### Supported Platforms

| Platform | Languages/Runtimes | Web/App Server |
|----------|-------------------|----------------|
| **Java** | Java 8, 11, 17 (Corretto) | Tomcat, or standalone |
| **Node.js** | Node.js 16, 18, 20 | Nginx or Apache proxy |
| **.NET on Linux** | .NET 6, 8 | Nginx proxy + Kestrel |
| **.NET on Windows** | .NET Framework, .NET Core | IIS |
| **Python** | Python 3.8, 3.9, 3.11, 3.12 | Nginx or Apache + Gunicorn |
| **Ruby** | Ruby 3.0, 3.1, 3.2 | Nginx or Apache + Puma |
| **PHP** | PHP 8.1, 8.2, 8.3 | Nginx or Apache |
| **Go** | Go 1.x | Standalone binary |
| **Docker** | Single container, multi-container (ECS) | Docker engine |
| **Preconfigured Docker** | GlassFish, Go | Docker with preconfigured runtime |

### Platform Branches and Versions

- **Platform branch**: A specific runtime version stream (e.g., "Python 3.11 running on 64bit Amazon Linux 2023")
- **Platform version**: A specific release within a branch (e.g., 4.0.1)
- AWS regularly releases new platform versions with security patches and updates
- **Managed platform updates**: Beanstalk can automatically apply platform updates during a maintenance window

---

## Beanstalk Environments

Each Beanstalk application can have multiple **environments** (e.g., dev, staging, prod).

### Web Server Environment

The standard environment for serving HTTP requests.

**Architecture:**
```
Internet → Route 53 → ALB → Auto Scaling Group → EC2 Instances
                                                    ↓
                                              CloudWatch Monitoring
```

**Components:**
- **Elastic Load Balancer** (ALB or CLB or NLB): Distributes incoming traffic
- **Auto Scaling Group**: Manages EC2 instances
- **EC2 instances**: Run your application
- **Host Manager**: Agent on each instance that handles deployment, log collection, monitoring

### Worker Environment

For processing background tasks from a queue.

**Architecture:**
```
SQS Queue → SQS Daemon (on EC2) → Application (HTTP POST to localhost)
     ↑
cron.yaml (scheduled tasks)
```

**Components:**
- **SQS Queue**: Automatically created and managed by Beanstalk
- **SQS Daemon**: Runs on each instance, polls the queue, sends messages as HTTP POST to `http://localhost/` on the instance
- **Auto Scaling**: Based on queue depth (number of messages)
- No load balancer (worker processes messages, doesn't serve HTTP)

**Use cases:**
- Processing uploaded files (images, videos)
- Sending emails
- Generating reports
- Any long-running background task

**Periodic tasks with cron.yaml:**
```yaml
version: 1
cron:
  - name: "cleanup"
    url: "/tasks/cleanup"
    schedule: "0 */6 * * *"
  - name: "report"
    url: "/tasks/daily-report"
    schedule: "0 8 * * *"
```

The SQS daemon sends periodic HTTP POST requests based on the schedule. Uses leader election to ensure only one instance processes each scheduled task.

### Single Instance Environment

- One EC2 instance (no load balancer, no ASG)
- Elastic IP assigned directly to the instance
- Lowest cost option
- Good for development and testing
- No high availability

### Environment Tiers

| Feature | Web Server Tier | Worker Tier |
|---------|----------------|-------------|
| Serves HTTP | Yes | No |
| Load Balancer | Yes (optional for single) | No |
| SQS Queue | No (unless you add one) | Yes (auto-created) |
| Auto Scaling metric | Request count, CPU | Queue depth |
| URL endpoint | Yes | No |
| Typical use | Web APIs, websites | Background processing |

---

## Beanstalk Components

### Application

- The top-level container in Beanstalk
- Has a unique name
- Contains environments, application versions, and environment configurations
- Think of it as a "project folder"

### Application Version

- A specific, labeled iteration of deployable code
- Stored as a ZIP file in S3
- Each deployment creates a new application version
- Versions can be deployed to any environment
- Versions have a label (e.g., "v1.0.3", "my-app-20240115")

### Environment

- A running instance of an application version on a platform
- Has its own URL: `myapp-env.us-east-1.elasticbeanstalk.com`
- Contains the provisioned resources (EC2, ALB, ASG, etc.)
- Each environment runs one application version at a time
- Can have multiple environments per application (dev, staging, prod)

### Environment Configuration

- Settings that define how the environment's resources behave
- Saved configurations can be stored and applied to other environments
- Configuration sources (in order of precedence, highest first):
  1. **Settings applied directly** to the environment (API, console, CLI, `.ebextensions`)
  2. **Saved configurations** (stored in S3)
  3. **Configuration files** (`.ebextensions` in source bundle)
  4. **Default values** (Beanstalk defaults)

---

## Deployment Policies

This is one of the most heavily tested Beanstalk topics on the exam.

### All at Once

| Aspect | Detail |
|--------|--------|
| **How it works** | Deploy new version to all instances simultaneously |
| **Downtime** | Yes — all instances are updated at once |
| **Speed** | Fastest |
| **Rollback** | Manual re-deploy of previous version |
| **Cost** | No additional instances |
| **When to use** | Development/testing environments where downtime is acceptable |

### Rolling

| Aspect | Detail |
|--------|--------|
| **How it works** | Update instances in batches. Each batch is taken out of service, updated, then put back. |
| **Downtime** | No, but reduced capacity during deployment |
| **Batch size** | Configurable (fixed number or percentage) |
| **Speed** | Slower than All at Once |
| **Rollback** | Manual — must re-deploy previous version |
| **Cost** | No additional instances |
| **When to use** | Production environments where some capacity reduction is acceptable |

**Example**: 4 instances, batch size = 2
1. Batch 1: Take 2 instances out → update → return (2 instances serving traffic)
2. Batch 2: Take remaining 2 → update → return (2 instances serving traffic)

### Rolling with Additional Batch

| Aspect | Detail |
|--------|--------|
| **How it works** | Like Rolling, but launches a new batch of instances first to maintain full capacity |
| **Downtime** | No, full capacity maintained |
| **Speed** | Slower (must launch new instances) |
| **Rollback** | Manual re-deploy |
| **Cost** | Temporarily higher (extra batch of instances) |
| **When to use** | Production — maintain full capacity during deployment |

**Example**: 4 instances, batch size = 2
1. Launch 2 additional instances with new version (6 total)
2. Take 2 old instances → update → return
3. Take remaining 2 old → update → return
4. Terminate the 2 extra instances

### Immutable

| Aspect | Detail |
|--------|--------|
| **How it works** | Launch entirely new instances with the new version in a new temporary ASG. Once healthy, swap them into the original ASG and terminate old instances. |
| **Downtime** | No |
| **Speed** | Slowest (full new set of instances) |
| **Rollback** | Fast — just terminate new instances |
| **Cost** | Temporarily double the instances |
| **When to use** | Production — need quick and safe rollback |

**Process:**
1. Create a temporary ASG with new instances running the new version
2. Health checks pass → move new instances to the original ASG
3. Terminate old instances
4. Delete temporary ASG

### Traffic Splitting (Canary)

| Aspect | Detail |
|--------|--------|
| **How it works** | Like Immutable, but routes a configurable percentage of traffic to new instances for a set evaluation time |
| **Downtime** | No |
| **Speed** | Slowest |
| **Rollback** | Fast — redirect traffic back to old instances |
| **Cost** | Temporarily double |
| **When to use** | Production — validate new version with real traffic before full deployment |

**Configuration:**
- **Traffic split percentage**: e.g., 10% to new, 90% to old
- **Evaluation time**: How long to test before shifting all traffic
- If health checks fail during evaluation → automatic rollback

### Deployment Policy Comparison Table

| Policy | Downtime | Deploy Speed | Rollback | Cost During Deploy | Capacity During Deploy |
|--------|----------|-------------|----------|-------------------|----------------------|
| All at Once | **Yes** | Fastest | Manual redeploy | Same | **Zero** (briefly) |
| Rolling | No | Medium | Manual redeploy | Same | **Reduced** |
| Rolling + Extra Batch | No | Medium-Slow | Manual redeploy | Slightly higher | **Full** |
| Immutable | No | Slow | **Quick** (terminate new) | **Double** | Full + extra |
| Traffic Splitting | No | Slowest | **Quick** (terminate new) | **Double** | Full + extra |

---

## Configuration Files (.ebextensions)

`.ebextensions` is a directory in your application source bundle containing YAML or JSON configuration files that customize your Beanstalk environment.

### Location and Format

- Directory: `.ebextensions/` at the root of your source bundle
- Files: Must end in `.config` (e.g., `.ebextensions/01-packages.config`)
- Format: YAML or JSON
- Files are processed in **alphabetical order**

### Common Sections

**option_settings** — Set Beanstalk configuration options:
```yaml
option_settings:
  aws:autoscaling:asg:
    MinSize: 2
    MaxSize: 10
  aws:elasticbeanstalk:environment:
    EnvironmentType: LoadBalanced
  aws:elasticbeanstalk:application:environment:
    DB_HOST: mydb.example.com
    NODE_ENV: production
```

**Resources** — Create or modify any AWS resource (CloudFormation syntax):
```yaml
Resources:
  MySQSQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: my-worker-queue
      VisibilityTimeout: 300
  
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
```

**packages** — Install OS packages:
```yaml
packages:
  yum:
    git: []
    postgresql-devel: []
```

**commands** — Execute commands before the application is deployed:
```yaml
commands:
  01_create_dir:
    command: "mkdir -p /var/app/shared/logs"
  02_set_permissions:
    command: "chmod 755 /var/app/shared/logs"
```

**container_commands** — Execute commands after the application is deployed but before it starts:
```yaml
container_commands:
  01_migrate:
    command: "python manage.py migrate"
    leader_only: true
  02_collectstatic:
    command: "python manage.py collectstatic --noinput"
```

**`leader_only: true`**: Only runs on one instance (the leader) — important for database migrations.

**files** — Create files on the instance:
```yaml
files:
  "/etc/nginx/conf.d/proxy.conf":
    mode: "000644"
    owner: root
    group: root
    content: |
      client_max_body_size 50M;
```

**services** — Manage system services:
```yaml
services:
  sysvinit:
    nginx:
      enabled: true
      ensureRunning: true
```

---

## Platform Hooks

Platform hooks let you run custom scripts at various stages of the platform lifecycle (available on Amazon Linux 2 and later).

### Hook Directories

| Directory | When Scripts Run |
|-----------|-----------------|
| `.platform/hooks/prebuild/` | Before the build step (before packages are installed) |
| `.platform/hooks/predeploy/` | After build, before deployment |
| `.platform/hooks/postdeploy/` | After deployment completes |
| `.platform/confighooks/prebuild/` | Same as above, but runs on configuration changes too |
| `.platform/confighooks/predeploy/` | Same as above, but runs on configuration changes too |
| `.platform/confighooks/postdeploy/` | Same as above, but runs on configuration changes too |

### Nginx/Apache Configuration

Customize the reverse proxy by placing configuration files in:
- `.platform/nginx/conf.d/` — Additional Nginx config files
- `.platform/nginx/nginx.conf` — Full Nginx config replacement
- `.platform/httpd/conf.d/` — Additional Apache config files

### Procfile

Define your application startup command:
```
web: gunicorn myapp.wsgi --bind 0.0.0.0:8000
worker: celery -A myapp worker
```

### Buildfile

Define a build command (runs once during deployment):
```
make: ./build.sh
```

---

## Beanstalk with RDS

### Option 1: RDS Inside the Beanstalk Environment

Beanstalk can create and manage an RDS instance as part of the environment.

**Pros:**
- Simple — Beanstalk handles everything
- Database connection info automatically passed as environment variables (`RDS_HOSTNAME`, `RDS_PORT`, `RDS_DB_NAME`, `RDS_USERNAME`, `RDS_PASSWORD`)

**Cons:**
- **Database lifecycle is tied to the environment** — if you terminate the environment, the database is deleted
- Not suitable for production (data loss risk)
- Cannot be shared across environments

**Best for:** Development and testing only.

### Option 2: RDS Outside the Beanstalk Environment (Decoupled)

Create the RDS instance independently and reference it in the Beanstalk environment.

**Pros:**
- Database persists independently of the environment lifecycle
- Can be shared across multiple environments
- Full control over database configuration
- Standard production approach

**Cons:**
- More configuration required
- Must pass connection info via environment variables or Secrets Manager

**How to connect:**
1. Create the RDS instance separately (or via CloudFormation)
2. Create a security group for the RDS instance
3. Pass connection info as environment properties in Beanstalk
4. Add the Beanstalk environment's security group to the RDS security group's inbound rules
5. Use `.ebextensions` to configure the security group relationship

### Migrating RDS from Inside to Outside

If you accidentally created RDS inside the environment and need to decouple:

1. Take a snapshot of the RDS instance
2. Enable deletion protection on the RDS instance
3. Create a new Beanstalk environment without RDS
4. Point the new environment to the existing RDS instance (env variables)
5. Perform a CNAME swap (blue/green) to the new environment
6. Terminate the old environment (RDS survives due to deletion protection)
7. Delete the old CloudFormation stack's reference to the RDS instance

---

## Beanstalk Lifecycle Policy

Over time, you can accumulate hundreds of application versions. Lifecycle policies help manage this.

**Settings:**
- **Based on total count**: Keep only the last N versions (e.g., keep last 200, default max is 1000)
- **Based on age**: Delete versions older than X days
- **Source bundle deletion**: Optionally delete the S3 source bundle when the version is deleted
- **Service role**: Lifecycle policy uses the Beanstalk service role

**Key points:**
- Lifecycle policy does NOT delete versions currently deployed to an environment
- Deleting an application version deletes the version record but can optionally preserve the S3 source bundle
- Default limit: 1000 application versions per application

---

## Blue/Green Deployment

Beanstalk doesn't natively support blue/green deployments as a deployment policy, but you can implement it using **environment swapping**.

### Process

1. **Blue Environment**: Your current production environment
2. **Green Environment**: Clone the Blue environment or create a new one
3. Deploy the new version to the Green environment
4. Test and validate the Green environment
5. **Swap URLs (CNAME swap)**: Route production traffic to the Green environment
6. Monitor. If issues arise, swap back to Blue.
7. Terminate the Blue environment when satisfied

### CNAME Swap

- Beanstalk swaps the CNAME records of the two environments
- DNS propagation delay (typically 60 seconds, could be more)
- No downtime (old and new environments both serve traffic briefly during DNS propagation)
- Can be done via Console, CLI, or API

### Swap vs Traffic Splitting

| Feature | CNAME Swap (Blue/Green) | Traffic Splitting |
|---------|------------------------|-------------------|
| Two separate environments | Yes | No (same environment) |
| Gradual traffic shift | No (instant swap) | Yes (percentage-based) |
| DNS propagation delay | Yes | No |
| Cost | Double (two environments running) | Double (extra instances temporarily) |
| Independent scaling | Yes | No |
| Database migration complexity | Higher (two environments) | Lower (same environment) |

---

## Custom Platform Using Packer

When the built-in platforms don't meet your needs, you can create a **custom platform**.

### What is Packer?

HashiCorp Packer is a tool for creating machine images from a configuration template.

### Custom Platform Process

1. Define a **Packer template** (JSON/HCL) that describes the AMI build process
2. Define a **platform.yaml** file that describes the platform metadata
3. Use the `eb platform create` command to build the custom platform
4. Beanstalk uses Packer to create a custom AMI
5. Deploy to environments using the custom platform

### When to Use Custom Platforms

- Need an OS not supported by managed platforms
- Need specific system libraries or configurations
- Require hardened/certified AMIs
- Want to preinstall large dependencies (reduce deployment time)
- Company policy requires custom base images

**Note**: Custom platforms are rarely the answer on the exam. AWS generally recommends using managed platforms with `.ebextensions` or Docker for customization.

---

## Beanstalk with Docker

### Single Container Docker

- Runs a single Docker container per EC2 instance
- Beanstalk manages Docker for you
- Provide either:
  - A `Dockerfile` (Beanstalk builds the image)
  - A `Dockerrun.aws.json` v1 (references a pre-built image)

**Dockerrun.aws.json v1:**
```json
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest",
    "Update": "true"
  },
  "Ports": [
    { "ContainerPort": 8080, "HostPort": 80 }
  ],
  "Volumes": [
    {
      "HostDirectory": "/var/app/data",
      "ContainerDirectory": "/app/data"
    }
  ]
}
```

### Multi-Container Docker (ECS)

- Runs multiple containers per EC2 instance
- Uses **ECS** under the hood (creates an ECS cluster)
- Provide a `Dockerrun.aws.json` v2 file (ECS task definition format)
- Great for sidecar patterns (e.g., app container + log forwarder + reverse proxy)

**Dockerrun.aws.json v2:**
```json
{
  "AWSEBDockerrunVersion": 2,
  "containerDefinitions": [
    {
      "name": "app",
      "image": "my-app:latest",
      "essential": true,
      "memory": 256,
      "portMappings": [
        { "hostPort": 80, "containerPort": 8080 }
      ]
    },
    {
      "name": "nginx-proxy",
      "image": "nginx:latest",
      "essential": true,
      "memory": 128,
      "portMappings": [
        { "hostPort": 443, "containerPort": 443 }
      ],
      "links": ["app"]
    }
  ]
}
```

### Docker Compose (Amazon Linux 2)

- Use `docker-compose.yml` with the Docker platform on Amazon Linux 2
- Beanstalk runs `docker-compose up` to start containers
- More familiar workflow for developers used to Docker Compose

---

## App Runner Deep Dive

AWS App Runner is the simplest way to deploy containerized web applications and APIs on AWS.

### Architecture

```
Source (ECR/GitHub) → App Runner Build → Auto Scaling → Your App (HTTPS endpoint)
                                              ↕
                                     VPC Connector (optional for private resources)
```

### Deployment Sources

**ECR (Elastic Container Registry):**
- Reference an existing container image
- Automatic deployments on image push (optional)
- Supports ECR public and private repositories
- Good for: pre-built images, complex build processes

**GitHub Source Code:**
- Connect to a GitHub repository
- App Runner builds the image from your source code
- Supported runtimes: Python, Node.js, Java, .NET, Go, Ruby, PHP
- **Build configuration** via `apprunner.yaml`:

```yaml
version: 1.0
runtime: python3
build:
  commands:
    build:
      - pip install -r requirements.txt
run:
  command: python app.py
  network:
    port: 8080
    env: APP_PORT
  env:
    - name: DB_HOST
      value: mydb.example.com
```

### Auto Scaling Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Max concurrency** | Max concurrent requests per instance | 100 |
| **Max size** | Maximum number of instances | 25 |
| **Min size** | Minimum number of instances | 1 |

- App Runner scales based on incoming request concurrency
- Scale-up: when concurrency per instance exceeds the threshold
- Scale-down: when traffic decreases
- Minimum 1 instance (always running — no true scale-to-zero)

### Health Checks

- **TCP health check**: Check if the port is responsive (default)
- **HTTP health check**: Check a specific path for a 200 response
- Configurable: path, interval, timeout, healthy/unhealthy threshold

### Observability

- **CloudWatch Metrics**: Request count, latency (2xx, 4xx, 5xx), active instances
- **CloudWatch Logs**: Application logs automatically sent
- **AWS X-Ray**: Distributed tracing (opt-in)

### Custom Domains

- Add custom domain names to your App Runner service
- App Runner provisions and manages SSL/TLS certificates
- CNAME or alias record validation

### Pricing

- **Per vCPU-hour**: Compute charges (active processing + provisioned idle)
- **Per GB-hour**: Memory charges
- **Provisioned instances**: Reduced rate when idle (not processing requests) — you still pay a base rate for provisioned instances
- **Automatic pause**: Can pause provisioning to reduce costs (cold start on resume)

---

## Amazon Lightsail

Amazon Lightsail is a simplified cloud platform for developers who need to deploy simple web applications, websites, and small databases.

### Overview

- **Simplified EC2**: Pre-configured instances with predictable monthly pricing
- **Bundles**: Fixed plans combining compute, memory, storage, and data transfer
- **One-click deployments**: WordPress, LAMP, Node.js, Joomla, Magento, GitLab, etc.

### Features

| Feature | Detail |
|---------|--------|
| **Instances** | Linux or Windows VMs with fixed plans |
| **Containers** | Container deployment service (simplified Fargate) |
| **Databases** | Managed MySQL and PostgreSQL |
| **Storage** | Block storage (SSD) and object storage (S3-compatible) |
| **Networking** | Static IPs, DNS management, VPC peering to AWS VPC, load balancers, CDN |
| **Snapshots** | Instance and disk snapshots for backup |
| **Pricing** | Simple, predictable monthly plans starting at $3.50/month |

### When to Use Lightsail

- Simple websites (WordPress, blogs, personal sites)
- Small business applications
- Development and test environments
- Students and learners
- When you don't need the complexity of full AWS services

### Lightsail vs EC2

| Feature | Lightsail | EC2 |
|---------|-----------|-----|
| Pricing | Fixed monthly | Per-second/hour |
| Simplicity | Very simple | Complex (many options) |
| Instance types | Limited bundles | Hundreds of types |
| Networking | Basic | Full VPC with all features |
| Scaling | Manual (limited) | Auto Scaling Groups |
| Load Balancing | Simple (included) | ALB/NLB (separate) |
| Storage | Block + Object | EBS, EFS, Instance Store |
| Integration with AWS | Limited (VPC peering) | Full |
| Best for | Simple, small-scale | Any scale, complex needs |

**Exam Tip**: Lightsail appears when the question mentions a simple website, small business, predictable pricing, or when someone doesn't want to deal with AWS complexity. It is NOT the answer for production enterprise workloads.

---

## AWS Batch

AWS Batch enables you to run **batch computing workloads** on the AWS Cloud. It dynamically provisions the right quantity and type of compute resources based on the job requirements.

### Core Concepts

**Job:**
- A unit of work submitted to AWS Batch
- Can be a shell script, Docker container image, or Linux executable
- Has parameters: vCPUs, memory, command, environment variables
- Job states: SUBMITTED → PENDING → RUNNABLE → STARTING → RUNNING → SUCCEEDED/FAILED

**Job Definition:**
- A template for jobs (like a task definition in ECS)
- Specifies: container image, vCPUs, memory, command, IAM role, volumes, environment variables
- Supports retries and timeout

**Job Queue:**
- Jobs are submitted to a queue
- A queue is associated with one or more compute environments
- Priority ordering between queues (higher priority queues are served first)
- Multiple queues can point to the same compute environment

**Compute Environment:**
- The compute resources that run your jobs
- Two types:
  - **Managed**: AWS Batch manages EC2 instances/Fargate for you
  - **Unmanaged**: You manage the compute resources yourself

### Managed Compute Environments

**EC2-based:**
- Batch launches and manages EC2 instances
- Configurable: instance types (or "optimal" — Batch picks the best), min/max vCPUs, VPC/subnets, AMI
- Supports On-Demand and Spot instances
- Spot with automatic retry on interruption
- ECS Agent runs on each instance

**Fargate-based:**
- Serverless compute for batch jobs
- No EC2 instances to manage
- Best for: jobs without special compute requirements (no GPU, no large instance needs)
- Fargate and Fargate Spot pricing

### Batch vs Lambda

| Feature | AWS Batch | Lambda |
|---------|-----------|--------|
| Max duration | No limit | 15 minutes |
| Max memory | Unlimited (based on instance) | 10 GB |
| Runtime | Any (Docker container) | Supported runtimes only |
| GPU support | Yes | No |
| Startup time | Minutes (provisioning) | Milliseconds-seconds |
| Scaling | Auto (managed compute) | Auto (instant) |
| Pricing | EC2/Fargate pricing | Per invocation + duration |
| Best for | Long-running batch jobs, HPC | Short event-driven tasks |

### Multi-Node Parallel Jobs

- Run a single job across multiple EC2 instances
- For tightly-coupled HPC workloads
- Uses EFA for inter-node communication
- Supports MPI (Message Passing Interface)
- Not supported on Fargate

### Array Jobs

- Submit a collection of related jobs as an array
- Each job in the array runs with a different index (like a for loop)
- Share the same job definition but different parameters
- Good for: parameter sweeps, Monte Carlo simulations, data processing pipelines

---

## Service Comparison

### Comprehensive Comparison

| Feature | Beanstalk | App Runner | Lightsail | Batch | Fargate (ECS) |
|---------|-----------|-----------|-----------|-------|---------------|
| **Type** | PaaS | PaaS | Simple VPS | Batch compute | Container orchestration |
| **Abstraction level** | High | Highest | High | Medium | Medium |
| **Container support** | Docker platform | Yes | Limited | Yes | Yes |
| **Source code deploy** | Yes | Yes (GitHub) | Via blueprints | No | No |
| **Auto Scaling** | Yes (ASG) | Yes (built-in) | Manual | Yes (managed) | Yes (Service Auto Scaling) |
| **Load Balancing** | ALB/NLB | Built-in | Simple LB | N/A | ALB/NLB |
| **Custom VPC** | Yes | VPC Connector | VPC peering | Yes | Yes |
| **GPU** | Yes (via instance type) | No | No | Yes | No |
| **Pricing** | Underlying resources | Per vCPU/memory | Monthly plans | Underlying resources | Per vCPU/memory |
| **Deployment options** | 5 policies | Automatic | Manual | N/A | Rolling, Blue/Green |
| **Best for** | Traditional web apps | Simple web APIs | Small websites | Batch/HPC jobs | Microservices |

---

## Exam Tips & Scenarios

### Scenario 1: Zero-Downtime Deployment
**Q:** Production Beanstalk environment needs a deployment with zero downtime and the ability to quickly roll back.
**A:** **Immutable** deployment policy. New instances are launched, and old instances are terminated only after the new ones are healthy. Quick rollback by terminating new instances.

### Scenario 2: Validate with Real Traffic
**Q:** Want to test a new version with 10% of production traffic before full deployment.
**A:** **Traffic Splitting** deployment policy. Routes a percentage of traffic to new instances for a configurable evaluation period.

### Scenario 3: Full Environment Testing
**Q:** Need to test a new version in a complete, isolated environment before switching production traffic.
**A:** **Blue/Green deployment** using environment CNAME swap. Create a new environment, test it, then swap URLs.

### Scenario 4: Database Persistence
**Q:** Beanstalk application uses RDS. The database must survive environment termination.
**A:** Create RDS **outside** the Beanstalk environment. Pass connection info via environment variables.

### Scenario 5: Custom Configuration
**Q:** Need to install custom packages and run database migrations during deployment.
**A:** Use `.ebextensions` configuration files. `packages` for OS packages, `container_commands` with `leader_only: true` for migrations.

### Scenario 6: Simple Container API
**Q:** Developer wants to deploy a REST API from a GitHub repository with minimal setup.
**A:** **App Runner** with GitHub source. Automatic build and deployment, auto-scaling, HTTPS endpoint.

### Scenario 7: Small WordPress Site
**Q:** Small business owner wants a WordPress blog with predictable monthly cost.
**A:** **Lightsail** with WordPress blueprint. Simple, low-cost, predictable pricing.

### Scenario 8: Nightly Data Processing
**Q:** Company needs to run a 4-hour data processing job every night using Docker containers.
**A:** **AWS Batch** with managed compute environment. Batch handles provisioning, scheduling, and cleanup.

### Scenario 9: Worker Processing Background Tasks
**Q:** Web application needs to process image uploads asynchronously (resize, compress, thumbnail).
**A:** Beanstalk **Worker environment**. Web tier sends messages to SQS, worker tier processes them.

### Scenario 10: Cost Optimization for Development
**Q:** Developer wants to minimize Beanstalk costs for a development environment.
**A:** Single Instance environment type (no load balancer, no ASG).

### Key Exam Patterns

1. **Deployment policies**: Know all 5 by heart — downtime, rollback speed, cost, capacity
2. **Immutable** = safest deployment for production (quick rollback)
3. **Traffic Splitting** = canary testing with real traffic
4. **Blue/Green** = CNAME swap between two environments
5. **RDS outside** Beanstalk = production best practice (decouple database lifecycle)
6. **.ebextensions** = customize environment with config files
7. **Worker environment** = SQS-based background processing
8. **App Runner** = simplest container deployment (exam keywords: "minimal operational overhead," "simplest way")
9. **Lightsail** = simple, predictable pricing for small websites
10. **AWS Batch** = long-running batch jobs with automatic compute provisioning
11. **`leader_only: true`** = run a command on only one instance (e.g., database migration)
12. **Docker on Beanstalk**: Single container (Dockerfile) or multi-container (ECS-based)

---

*Previous: [← ECS, EKS & Container Services](09-containers-ecs-eks.md) | Next: [S3 Deep Dive →](11-s3-deep-dive.md)*
