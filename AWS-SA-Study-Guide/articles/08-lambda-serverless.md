# Lambda & Serverless

## Table of Contents

1. [Introduction to Serverless on AWS](#introduction-to-serverless-on-aws)
2. [Lambda Fundamentals](#lambda-fundamentals)
3. [Lambda Limits](#lambda-limits)
4. [Lambda Execution Model](#lambda-execution-model)
5. [Lambda Triggers & Invocation Models](#lambda-triggers--invocation-models)
6. [Lambda with VPC](#lambda-with-vpc)
7. [Lambda Layers & Extensions](#lambda-layers--extensions)
8. [Lambda Versions, Aliases & Traffic Shifting](#lambda-versions-aliases--traffic-shifting)
9. [Lambda@Edge and CloudFront Functions](#lambdaedge-and-cloudfront-functions)
10. [Lambda Destinations](#lambda-destinations)
11. [Lambda Environment Variables & Encryption](#lambda-environment-variables--encryption)
12. [Step Functions](#step-functions)
13. [API Gateway](#api-gateway)
14. [SAM (Serverless Application Model)](#sam-serverless-application-model)
15. [EventBridge](#eventbridge)
16. [AppSync](#appsync)
17. [Serverless Patterns](#serverless-patterns)
18. [Lambda vs Fargate vs EC2](#lambda-vs-fargate-vs-ec2)
19. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## Introduction to Serverless on AWS

Serverless means you don't manage or provision servers. The cloud provider handles infrastructure, scaling, patching, and availability. You only pay for what you use (per invocation, per duration, per request).

**AWS Serverless services include:**
- **Compute:** Lambda, Fargate
- **API:** API Gateway, AppSync
- **Storage:** S3, DynamoDB
- **Orchestration:** Step Functions
- **Messaging:** SQS, SNS, EventBridge
- **Streaming:** Kinesis Data Firehose
- **Developer tools:** SAM, CDK

---

## Lambda Fundamentals

AWS Lambda lets you run code without provisioning or managing servers. You upload your code as a **deployment package** or **container image**, and Lambda runs it in response to events.

### Handler

The **handler** is the entry point for your Lambda function — the method that Lambda invokes when the function is triggered.

```python
# Python example
def lambda_handler(event, context):
    # event: input data (JSON)
    # context: runtime information
    name = event.get('name', 'World')
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
```

### Event Object

The **event** object contains data from the invoking service. Its structure varies by trigger:

- **API Gateway**: HTTP method, headers, query parameters, body
- **S3**: Bucket name, object key, event type
- **SQS**: Message body, attributes, receipt handle
- **DynamoDB Streams**: New/old image of the changed item
- **EventBridge**: Detail type, source, detail

### Context Object

The **context** object provides runtime information about the invocation:

| Property | Description |
|----------|-------------|
| `function_name` | The name of the Lambda function |
| `function_version` | The version ($LATEST or published) |
| `memory_limit_in_mb` | Memory allocated |
| `invoked_function_arn` | The ARN used to invoke the function |
| `aws_request_id` | Unique ID for the invocation |
| `log_group_name` | CloudWatch Logs group |
| `log_stream_name` | CloudWatch Logs stream |
| `get_remaining_time_in_millis()` | Milliseconds remaining before timeout |

### Supported Runtimes

- Python (3.9, 3.10, 3.11, 3.12)
- Node.js (16.x, 18.x, 20.x)
- Java (8, 11, 17, 21)
- .NET (6, 8)
- Ruby (3.2, 3.3)
- Go (provided.al2 custom runtime)
- Rust (provided.al2 custom runtime)
- **Custom Runtime**: Use the `provided.al2023` or `provided.al2` runtime to run any language
- **Container Image**: Package your function as a container image (up to 10 GB), must implement the Lambda Runtime API

### Deployment Packages

**ZIP archive:**
- Upload directly (up to 50 MB compressed) or from S3 (up to 250 MB uncompressed)
- Contains function code and dependencies

**Container Image:**
- Must be based on a Lambda-compatible base image or implement the Lambda Runtime API
- Stored in ECR
- Up to 10 GB in size
- Supports the same invocation patterns as ZIP-based functions

---

## Lambda Limits

Understanding Lambda limits is critical for the exam. These are frequently tested.

### Per-Function Limits

| Resource | Limit |
|----------|-------|
| Memory allocation | **128 MB to 10,240 MB** (10 GB), in 1 MB increments |
| Maximum execution time (timeout) | **15 minutes** (900 seconds) |
| Ephemeral storage (`/tmp`) | **512 MB to 10,240 MB** (10 GB) |
| Environment variables | 4 KB total |
| Deployment package (ZIP, compressed) | 50 MB (direct upload) |
| Deployment package (uncompressed) | 250 MB (including layers) |
| Container image size | 10 GB |
| Layers per function | 5 |

### Per-Account/Region Limits

| Resource | Limit |
|----------|-------|
| Concurrent executions | **1,000** (default, can be increased) |
| Burst concurrency | 500-3000 (varies by region) |
| Function and layer storage | 75 GB |
| Elastic network interfaces per VPC | 250 (for VPC-connected functions) |

### Invocation Limits

| Resource | Limit |
|----------|-------|
| Invocation payload (synchronous) | 6 MB |
| Invocation payload (asynchronous) | 256 KB |
| Response payload (streaming) | 20 MB |

**Exam Tip**: If a question mentions processing that takes >15 minutes → Lambda is NOT the answer (use Fargate, ECS, EC2, or Step Functions to orchestrate). If the deployment package exceeds 250 MB → use container image deployment (up to 10 GB) or Lambda Layers.

---

## Lambda Execution Model

### Cold Starts vs Warm Starts

**Cold Start** (first invocation or scaling up):
1. Download code from S3/ECR
2. Create a new execution environment (micro-VM)
3. Initialize the runtime (JVM, Python interpreter, etc.)
4. Run initialization code (code outside the handler)
5. Execute the handler

**Warm Start** (subsequent invocation reusing an existing environment):
1. Execute the handler (steps 1-4 are skipped)

**Cold start duration** varies by language:
- Python, Node.js, Go: ~100-300ms
- Java, .NET: ~500ms-5+ seconds (JVM/.NET CLR startup)
- Container images: Longer initial pull time

**Reducing cold starts:**
- Keep deployment packages small
- Minimize initialization code
- Use Provisioned Concurrency
- Choose lighter-weight runtimes (Python, Node.js)
- Avoid VPC if not needed (though modern VPC attachment is much faster)
- Use ARM/Graviton (often faster init)

### Provisioned Concurrency

Provisioned Concurrency keeps a specified number of execution environments **pre-initialized and ready** to respond instantly.

- Eliminates cold starts for the provisioned environments
- You pay for the provisioned environments even when idle
- Can be applied to a specific **version or alias** (not $LATEST)
- Can be scheduled to scale up/down using **Application Auto Scaling**
- Ideal for latency-sensitive applications (APIs, real-time processing)

### Reserved Concurrency

Reserved Concurrency **guarantees** a maximum number of concurrent executions for a function and also **limits** it.

- Reserves a portion of the account-level concurrency for a specific function
- Other functions **cannot** use reserved concurrency (even if unused)
- **Throttles** the function if it exceeds the reserved limit
- Set to **0** to effectively **disable** a function
- No additional cost
- Useful for: protecting downstream resources, ensuring critical functions have capacity

**Reserved vs Provisioned Concurrency:**

| Feature | Reserved | Provisioned |
|---------|----------|-------------|
| Guarantees capacity | Yes (from account pool) | Yes (pre-initialized) |
| Eliminates cold starts | No | Yes |
| Cost | Free | Additional charge |
| Applied to | Function | Version or Alias |
| Limits function | Yes (caps at reserved amount) | No (can exceed provisioned amount, with cold starts) |

---

## Lambda Triggers & Invocation Models

### Synchronous Invocation

The caller waits for the function to process the event and return a response.

**Services that invoke Lambda synchronously:**
- API Gateway (REST/HTTP API)
- Application Load Balancer
- CloudFront (Lambda@Edge)
- Amazon Cognito
- Amazon Alexa
- Amazon Lex
- Amazon Kinesis Data Firehose
- AWS CLI (`aws lambda invoke`)

**Error handling**: Errors are returned directly to the caller. The caller is responsible for retries.

### Asynchronous Invocation

The caller places the event on an internal queue and returns immediately. Lambda processes the event asynchronously.

**Services that invoke Lambda asynchronously:**
- S3 event notifications
- SNS
- CloudWatch Events / EventBridge
- AWS CodeCommit
- AWS CodePipeline
- CloudWatch Logs (subscription filters)
- Amazon SES
- AWS Config
- AWS IoT
- CloudFormation (custom resources)

**Error handling for async:**
- Lambda automatically retries **2 times** (total 3 attempts)
- Events are placed in an internal queue with up to 6 hours retention
- Failed events (after all retries) can be sent to a **Dead-Letter Queue (DLQ)**: SQS or SNS
- Or use **Lambda Destinations** (preferred over DLQ — more flexible)
- You can configure: maximum retry attempts (0-2), maximum event age (60s to 6 hours)

### Event Source Mappings

Event Source Mappings are Lambda-managed pollers that read from a stream or queue and invoke your function.

**Supported sources:**
- Amazon Kinesis Data Streams
- Amazon DynamoDB Streams
- Amazon SQS (Standard and FIFO)
- Amazon MQ (ActiveMQ, RabbitMQ)
- Amazon MSK (Managed Streaming for Apache Kafka)
- Self-managed Apache Kafka

**Key behaviors:**

**For Streams (Kinesis, DynamoDB Streams):**
- Lambda polls the stream and invokes your function with a batch of records
- Batch size: 1 to 10,000 records
- **Parallelization factor**: Process multiple batches from the same shard concurrently (up to 10)
- On error: entire batch is retried. Can configure:
  - Maximum retry attempts
  - Maximum record age
  - Split failed batches (bisect on error)
  - On-failure destination (SQS, SNS)
- Records are processed **in order** within each shard

**For SQS:**
- Lambda polls the SQS queue using long polling
- Batch size: 1 to 10 messages (Standard) or up to 10 (FIFO)
- Scaling: Lambda scales up to 1,000 batches/min for standard queues, 300 messages/sec for FIFO
- On error: Messages become visible again after visibility timeout. Failed messages go to DLQ configured on the **SQS queue** (not the Lambda function)
- FIFO queues: Messages in the same message group are processed in order
- Report batch item failures: Return partial success (only re-process failed items from the batch)

**Exam Tip**: For event source mappings, the Lambda function's **execution role** must have permissions to read from the source (e.g., `kinesis:GetRecords`, `sqs:ReceiveMessage`).

---

## Lambda with VPC

By default, Lambda functions run in an **AWS-owned VPC** and have internet access. To access resources in your VPC (RDS, ElastiCache, private EC2 instances), you must configure VPC access.

### How Lambda VPC Connectivity Works

1. Lambda creates **Hyperplane ENIs** (Elastic Network Interfaces) in your specified subnets
2. These ENIs are shared across function executions (since 2019 improvement)
3. Your function's traffic flows through these ENIs into your VPC
4. The function inherits the VPC's networking (security groups, NACLs, route tables)

### VPC Configuration Requirements

- Specify at least one **subnet** (recommend multiple for HA)
- Specify at least one **security group**
- Lambda execution role needs: `ec2:CreateNetworkInterface`, `ec2:DescribeNetworkInterfaces`, `ec2:DeleteNetworkInterface`

### Internet Access for VPC-Connected Lambda

**Critical**: A Lambda function in a VPC does **NOT** automatically have internet access, even if the VPC has an Internet Gateway.

To give a VPC-connected Lambda internet access:
1. Place the Lambda ENIs in **private subnets**
2. Route traffic through a **NAT Gateway** (in a public subnet)
3. The NAT Gateway connects to the Internet Gateway

**Alternative**: Use **VPC Endpoints** (Interface or Gateway) to access AWS services without internet:
- Gateway Endpoint: S3, DynamoDB (free)
- Interface Endpoint (PrivateLink): Most other AWS services (per-hour + per-GB charge)

### Cold Start Impact (Historical vs Current)

**Before 2019**: Creating a new ENI for each execution environment caused cold starts of 10+ seconds. This was a major issue.

**After 2019 (Hyperplane ENIs)**: ENIs are created when the function configuration is updated (not at invocation time). Cold start for VPC is now comparable to non-VPC (~<1 second additional). ENIs are shared across concurrent executions.

**Exam Tip**: VPC-connected Lambda needing internet access = private subnet + NAT Gateway. If it only needs AWS service access, use VPC endpoints instead (more cost-effective).

---

## Lambda Layers & Extensions

### Lambda Layers

A Layer is a ZIP archive containing additional code (libraries, dependencies, custom runtimes, configuration files).

**Benefits:**
- **Code reuse**: Share common libraries across multiple functions
- **Smaller deployment packages**: Keep function code separate from dependencies
- **Separation of concerns**: Update dependencies independently from function code

**Key details:**
- A function can use up to **5 layers**
- Total unzipped size (function + all layers) must be ≤ **250 MB**
- Layers are extracted to `/opt` in the execution environment
- Layers are immutable and versioned
- Can be shared across accounts (make the layer version public or share with specific accounts)
- AWS provides managed layers (e.g., AWS SDK, Pandas for Python)

### Lambda Extensions

Extensions augment Lambda functions with monitoring, observability, security, and governance tools.

**Types:**
- **Internal Extensions**: Run within the function's process (e.g., agents, wrappers)
- **External Extensions**: Run as separate processes in the execution environment

**Lifecycle:**
- Extensions initialize **before** the function handler
- They can run during invocations and **after** the function completes (up to 2 seconds)
- Useful for: sending telemetry, flushing buffers, cleaning up resources

**Examples**: Datadog agent, AWS AppConfig, Sentry, Dynatrace

---

## Lambda Versions, Aliases & Traffic Shifting

### Versions

- `$LATEST` is the mutable, default version (what you edit)
- When you **publish** a version, it creates an immutable snapshot (code + configuration)
- Versions are numbered: 1, 2, 3, ...
- Each version has its own ARN: `arn:aws:lambda:region:account:function:my-function:1`

### Aliases

An alias is a **named pointer** to a specific Lambda version.

- Example: `PROD` → version 5, `DEV` → $LATEST
- Aliases have their own ARN: `arn:aws:lambda:region:account:function:my-function:PROD`
- Aliases are mutable (can be updated to point to a different version)
- Aliases **cannot** reference other aliases

### Traffic Shifting (Weighted Aliases)

Aliases support **weighted routing** to enable canary deployments:

```
Alias: PROD
├── 90% → Version 5 (current stable)
└── 10% → Version 6 (new release, canary)
```

- Gradually shift traffic from the old version to the new version
- If issues are detected, roll back by updating the alias
- Integrates with **CodeDeploy** for automated traffic shifting:
  - **Canary**: Shift a small percentage first, then shift the rest (e.g., 10% for 10 minutes, then 100%)
  - **Linear**: Shift traffic in equal increments (e.g., 10% every 10 minutes)
  - **All-at-once**: Shift 100% immediately
- CodeDeploy can roll back automatically based on CloudWatch alarms

---

## Lambda@Edge and CloudFront Functions

Both run code at CloudFront edge locations to customize CDN behavior, but they differ significantly.

### Lambda@Edge

| Feature | Detail |
|---------|--------|
| **Runtime** | Node.js, Python |
| **Execution location** | Regional edge caches (13 regions) |
| **Max execution time** | Viewer: 5 seconds, Origin: 30 seconds |
| **Max memory** | 128 MB to 10,240 MB |
| **Max package size** | 1 MB (Viewer), 50 MB (Origin) |
| **Network access** | Yes (can call external services) |
| **File system access** | Yes (`/tmp`) |
| **Request body access** | Yes (Origin request/response) |
| **Triggers** | Viewer Request, Viewer Response, Origin Request, Origin Response |

### CloudFront Functions

| Feature | Detail |
|---------|--------|
| **Runtime** | JavaScript (ECMAScript 5.1 compatible) |
| **Execution location** | All CloudFront edge locations (400+) |
| **Max execution time** | < 1 ms |
| **Max memory** | 2 MB |
| **Max package size** | 10 KB |
| **Network access** | No |
| **File system access** | No |
| **Request body access** | No |
| **Triggers** | Viewer Request, Viewer Response only |
| **Scale** | Millions of requests/second |
| **Cost** | ~1/6th the price of Lambda@Edge |

### When to Use Which

| Use Case | CloudFront Functions | Lambda@Edge |
|----------|---------------------|-------------|
| URL rewrites/redirects | ✅ | ✅ |
| Header manipulation | ✅ | ✅ |
| Cache key normalization | ✅ | ✅ |
| JWT/token validation | ✅ (simple) | ✅ (complex) |
| A/B testing | ✅ | ✅ |
| HTTP response generation | ✅ (simple) | ✅ |
| Access external services | ❌ | ✅ |
| Modify request body | ❌ | ✅ |
| Origin selection/failover | ❌ | ✅ |
| Complex processing | ❌ | ✅ |
| Requires sub-ms execution | ✅ | ❌ |

---

## Lambda Destinations

Lambda Destinations route the result of an asynchronous invocation to another AWS service without needing a DLQ.

**Supported destinations:**
- SQS queue
- SNS topic
- Lambda function
- EventBridge event bus

**Destination types:**
- **On Success**: Route the result of a successful invocation
- **On Failure**: Route the result of a failed invocation (after all retries)

**Why Destinations over DLQ:**
- Destinations can capture **success** events (DLQ only captures failures)
- Destinations send more information (request payload, response payload, context)
- Destinations support more target types (DLQ only supports SQS and SNS)
- Destinations can be configured per alias/version

**Exam Tip**: AWS recommends Destinations over DLQ for async invocations. But DLQ on the SQS queue is still used for event source mapping failures.

---

## Lambda Environment Variables & Encryption

### Environment Variables

- Key-value pairs available to your function code
- Maximum total size: **4 KB**
- Available via standard environment variable access (`os.environ` in Python, `process.env` in Node.js)
- Set at deploy time; immutable at runtime
- Useful for: database connection strings, API endpoints, feature flags

### Encryption

**In transit**: Environment variables are encrypted in transit using TLS.

**At rest (default)**: Environment variables are encrypted at rest using the AWS Lambda service key (AWS-managed KMS key).

**At rest (custom)**: You can encrypt environment variables with your own **customer-managed KMS key (CMK)**:
- Lambda encrypts variables after deployment
- Lambda decrypts variables before passing to the function
- You can also use **encryption helpers** to encrypt variables **before** deployment and decrypt them in your function code (double encryption)

**Secrets management best practices:**
- For simple configs → Environment variables (encrypted with KMS)
- For secrets → **AWS Secrets Manager** or **SSM Parameter Store** (SecureString)
- Cache secrets in the execution environment (outside the handler) for warm starts
- Use the AWS SDK in initialization code to fetch secrets

---

## Step Functions

AWS Step Functions orchestrate multiple AWS services into serverless workflows using visual state machines.

### Standard vs Express Workflows

| Feature | Standard | Express |
|---------|----------|---------|
| **Max duration** | 1 year | 5 minutes |
| **Execution model** | Exactly-once | At-least-once (async) / At-most-once (sync) |
| **Execution rate** | 2,000/sec (start) | 100,000/sec (start) |
| **State transitions** | 25,000/sec (account) | Nearly unlimited |
| **Pricing** | Per state transition | Per execution + duration + memory |
| **Execution history** | Yes (up to 90 days) | CloudWatch Logs only |
| **Use cases** | Long-running, non-idempotent, auditable workflows | High-volume, short-duration event processing |

### States

Step Functions workflows are defined in **Amazon States Language (ASL)**, a JSON-based language.

**Task State:**
Performs work — invokes a Lambda function, calls an AWS API, runs an activity, or integrates with other services.
```json
{
  "Type": "Task",
  "Resource": "arn:aws:lambda:us-east-1:123456789:function:MyFunction",
  "Next": "NextState"
}
```

Service integrations:
- **Optimized**: Direct integration with services (DynamoDB, SQS, SNS, ECS, Glue, SageMaker, etc.)
- **AWS SDK**: Call any AWS API action
- Integration patterns:
  - **Request Response** (default): Call the service, get the response, continue
  - **Run a Job (.sync)**: Call the service, wait for the job to complete, then continue
  - **Wait for Callback (.waitForTaskToken)**: Send a token to the service, pause, resume when the token is returned

**Choice State:**
Branching logic based on input values. Like a switch/case statement.

**Parallel State:**
Execute multiple branches concurrently. All branches must succeed for the state to succeed.

**Map State:**
Iterate over an array and process each element. Supports:
- **Inline mode**: Process items within the workflow's execution
- **Distributed mode**: Process large-scale datasets (up to millions of items) using child executions

**Wait State:**
Delay for a specified time or until a specific timestamp.

**Succeed State:**
Successfully terminates the execution.

**Fail State:**
Terminates the execution with a failure. Includes error name and cause.

**Pass State:**
Passes input to output, optionally transforming data. Useful for debugging or injecting fixed data.

### Error Handling

- **Retry**: Automatically retry failed states with configurable intervals, back-off rate, and max attempts
- **Catch**: Catch specific errors and transition to a fallback state
- Predefined error codes: `States.ALL`, `States.Timeout`, `States.TaskFailed`, `States.Permissions`, `States.ResultPathMatchFailure`

```json
{
  "Retry": [
    {
      "ErrorEquals": ["States.TaskFailed"],
      "IntervalSeconds": 3,
      "MaxAttempts": 2,
      "BackoffRate": 2.0
    }
  ],
  "Catch": [
    {
      "ErrorEquals": ["States.ALL"],
      "Next": "FallbackState"
    }
  ]
}
```

---

## API Gateway

Amazon API Gateway is a fully managed service for creating, publishing, maintaining, monitoring, and securing APIs at any scale.

### API Types

| Feature | REST API | HTTP API | WebSocket API |
|---------|----------|----------|---------------|
| **Protocol** | RESTful | RESTful | WebSocket |
| **Latency** | Higher | ~40% lower | Persistent connections |
| **Cost** | Higher | ~70% cheaper | Per message + connection-minutes |
| **Authorizers** | IAM, Cognito, Lambda | IAM, Cognito, Lambda, JWT | IAM, Lambda |
| **Caching** | Yes | No | No |
| **Usage Plans / API Keys** | Yes | No | No |
| **Request validation** | Yes | No | No |
| **WAF integration** | Yes | No | Yes |
| **Resource policies** | Yes | No | No |
| **Private APIs** | Yes | No | No |
| **Import/Export (OpenAPI)** | Yes | Yes | No |
| **Request transformation** | Yes (VTL mapping) | Parameter mapping only | Yes |

**When to choose:**
- **REST API**: Full API management features, caching, request validation, WAF
- **HTTP API**: Simple proxy to Lambda/HTTP backends, lower cost, lower latency
- **WebSocket API**: Real-time bidirectional communication (chat, gaming, streaming)

### Stages & Deployments

- A **stage** is a named reference to a deployment (e.g., `dev`, `staging`, `prod`)
- **Deployments** are snapshots of the API configuration
- Each stage has its own URL: `https://{api-id}.execute-api.{region}.amazonaws.com/{stage}`
- **Stage variables**: Key-value pairs that act like environment variables for each stage
  - Can reference different Lambda aliases, backend URLs, or config per stage
  - Access in Lambda via `event.stageVariables`
- **Canary deployments**: Route a percentage of traffic to the canary stage for testing

### Throttling

- Default: **10,000 requests/second** (account level, across all APIs in a region)
- Default burst: **5,000 concurrent requests**
- Stage-level throttling and method-level throttling can be configured
- Usage plans can set per-client throttling limits
- Returns **429 Too Many Requests** when throttled

### Caching (REST API only)

- Cache API responses to reduce backend calls
- TTL: default 300 seconds (0-3600 seconds)
- Cache size: 0.5 GB to 237 GB
- Cache per-stage
- Cache invalidation: clients can send `Cache-Control: max-age=0` header (if authorized)
- Encryption option available

### Usage Plans & API Keys

- **Usage Plans**: Define throttling limits and quota (requests per day/week/month) for API consumers
- **API Keys**: String tokens distributed to customers, associated with usage plans
- API Keys are for **throttling/quota management**, NOT for authentication
- For authentication, use IAM, Cognito, or Lambda authorizers

### Authorizers

**IAM Authorization:**
- Uses SigV4 signed requests
- Good for internal services, cross-account access
- Combined with resource policies for cross-account

**Cognito User Pool Authorizer:**
- Client authenticates with Cognito, gets a token
- API Gateway validates the token against the User Pool
- No custom code needed
- Best for apps with Cognito-based authentication

**Lambda Authorizer (Custom Authorizer):**
- Lambda function validates tokens or request parameters
- Returns an IAM policy (and optional context)
- Two types:
  - **Token-based**: Receives a bearer token (e.g., OAuth, SAML)
  - **Request-based**: Receives the full request (headers, query string, stage variables)
- Policies are cached (TTL configurable, up to 1 hour)
- Flexible — can integrate with any identity provider

---

## SAM (Serverless Application Model)

AWS SAM is an open-source framework for building serverless applications. It extends CloudFormation with simplified syntax.

**Key components:**
- **SAM Template** (`template.yaml`): Defines serverless resources using simplified syntax
- **SAM CLI**: Build, test, and deploy serverless apps locally and to AWS

**SAM resource types:**
- `AWS::Serverless::Function` → Lambda function
- `AWS::Serverless::Api` → API Gateway REST API
- `AWS::Serverless::HttpApi` → API Gateway HTTP API
- `AWS::Serverless::SimpleTable` → DynamoDB table
- `AWS::Serverless::LayerVersion` → Lambda Layer
- `AWS::Serverless::Application` → Nested serverless application (from SAR)
- `AWS::Serverless::StateMachine` → Step Functions state machine

**SAM CLI commands:**
- `sam init` → Initialize a new SAM project
- `sam build` → Build your application
- `sam local invoke` → Invoke a function locally
- `sam local start-api` → Start a local API Gateway
- `sam deploy --guided` → Deploy to AWS (guided mode)
- `sam validate` → Validate the SAM template
- `sam logs` → Fetch logs from CloudWatch

**SAM deploys to CloudFormation** under the hood. Every SAM template is a valid CloudFormation template with a `Transform: AWS::Serverless-2016-10-31` header.

---

## EventBridge

Amazon EventBridge (formerly CloudWatch Events) is a serverless event bus that connects applications using events.

### Core Concepts

**Event Bus:**
- **Default event bus**: Receives events from AWS services automatically
- **Custom event bus**: Receives events from your applications
- **Partner event bus**: Receives events from SaaS partners (Datadog, Zendesk, Auth0, etc.)
- Cross-account: Can send/receive events across accounts (resource policies)

**Rules:**
- Match incoming events based on patterns and route them to targets
- Each rule can have up to **5 targets**
- Two types:
  - **Event pattern rules**: Match specific event structures
  - **Scheduled rules**: Trigger on a schedule (cron or rate expression)

**Event pattern matching example:**
```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "stopped"]
  }
}
```

### Targets

EventBridge can route events to 20+ AWS services:
- Lambda, Step Functions, SQS, SNS, Kinesis
- ECS tasks, CodePipeline, CodeBuild
- SSM Run Command, EC2 actions (reboot, stop, terminate)
- API Gateway, Redshift, Firehose
- API Destinations (external HTTP endpoints)
- Another event bus (cross-account/cross-region)

### Schema Registry & Discovery

- **Schema Registry**: Stores event schemas (the structure of events)
- **Schema Discovery**: Automatically detects and registers schemas from events on the bus
- Generate code bindings from schemas (Java, Python, TypeScript)
- Useful for development — know the exact structure of events

### EventBridge Pipes

EventBridge Pipes connects sources to targets with optional filtering, enrichment, and transformation:
- **Source**: SQS, Kinesis, DynamoDB Streams, MQ, MSK, Kafka
- **Filter**: Match only specific events from the source
- **Enrichment**: Call Lambda, Step Functions, API Gateway, API Destinations to enrich the event
- **Target**: Any EventBridge-supported target

### EventBridge Scheduler

- Cron or rate-based scheduling (like CloudWatch Events schedules)
- One-time or recurring schedules
- More features than EventBridge rules: time zones, flexible time windows, retry policies
- Scales to millions of schedules

**Exam Tip**: EventBridge is the preferred service for event-driven architectures. It replaces CloudWatch Events with more features. Use it for: reacting to AWS service events, building decoupled architectures, scheduling tasks.

---

## AppSync

AWS AppSync is a fully managed service for building **GraphQL** APIs.

### Key Features

- **GraphQL**: Query language that lets clients request exactly the data they need
- **Real-time subscriptions**: Clients can subscribe to data changes via WebSocket
- **Offline support**: Built-in offline data synchronization (with Amplify client libraries)
- **Conflict resolution**: Automatic or custom conflict detection and resolution

### Resolvers

Resolvers connect GraphQL fields to data sources. When a field is queried, the resolver fetches or modifies data.

**Resolver types:**
- **Unit resolvers**: Single data source
- **Pipeline resolvers**: Chain multiple data sources/operations in sequence

### Data Sources

AppSync can connect to multiple backends:
- **DynamoDB**: Direct integration with VTL or JavaScript resolvers
- **Lambda**: For custom business logic
- **RDS (Aurora)**: SQL databases
- **OpenSearch (Elasticsearch)**: Full-text search
- **HTTP endpoints**: Any HTTP data source
- **EventBridge**: Send events to EventBridge
- **None**: Local resolvers (for simple transformations)

### Security

- **API Key**: Simple, time-limited (max 365 days). For public APIs.
- **IAM**: SigV4. For AWS services and programmatic access.
- **Cognito User Pools**: JWT tokens. For user-facing apps.
- **OpenID Connect (OIDC)**: Third-party identity providers.

**Exam Tip**: AppSync appears when the question mentions "GraphQL," "real-time data," "mobile app sync," or "offline data synchronization."

---

## Serverless Patterns

### Pattern 1: API + Lambda + DynamoDB (Serverless CRUD)

```
Client → API Gateway → Lambda → DynamoDB
```

Classic serverless web API pattern. API Gateway handles routing, Lambda processes business logic, DynamoDB stores data. Fully serverless, auto-scaling, pay-per-use.

### Pattern 2: Event-Driven Processing

```
S3 (upload) → Lambda → DynamoDB (metadata)
                    └→ SQS → Lambda → Elasticsearch
```

Upload a file to S3, trigger Lambda for processing. Lambda stores metadata in DynamoDB and sends events to SQS for secondary processing (indexing in Elasticsearch).

### Pattern 3: Fan-Out Pattern

```
SNS Topic → SQS Queue 1 → Lambda 1 (process)
          → SQS Queue 2 → Lambda 2 (archive)
          → SQS Queue 3 → Lambda 3 (notify)
```

An event is published to SNS, which fans out to multiple SQS queues. Each queue triggers a different Lambda function for parallel processing. This decouples producers from consumers.

### Pattern 4: Saga Pattern (Distributed Transactions)

```
Step Functions:
  1. Reserve Inventory (Lambda)
  2. Process Payment (Lambda)
  3. Ship Order (Lambda)
  
  If any step fails → Compensating transactions:
  3. Cancel Shipment
  2. Refund Payment
  1. Release Inventory
```

Step Functions orchestrate a multi-step business process. If any step fails, compensating transactions undo previous steps. This replaces distributed transactions in microservices.

### Pattern 5: Asynchronous Processing with DLQ

```
API Gateway → SQS → Lambda → DynamoDB
                       └ (failure) → DLQ (SQS) → Alarm → Investigation
```

API Gateway writes messages to SQS for asynchronous processing. Lambda processes messages. Failed messages go to a DLQ for investigation.

---

## Lambda vs Fargate vs EC2

| Feature | Lambda | Fargate | EC2 |
|---------|--------|---------|-----|
| **Max duration** | 15 minutes | No limit | No limit |
| **Scaling** | Automatic (0 to thousands) | Auto Scaling | Auto Scaling (you configure) |
| **Scale to zero** | Yes | Yes (with ECS Service 0 tasks) | No |
| **Startup time** | Milliseconds-seconds | 30-90 seconds | Minutes |
| **Pricing** | Per invocation + duration | Per vCPU + memory per second | Per instance per second/hour |
| **Max memory** | 10 GB | 120 GB | TBs |
| **Max vCPUs** | 6 (at 10 GB) | 16 | Hundreds |
| **Container support** | Container images up to 10 GB | Full Docker support | Full Docker support |
| **OS access** | No | No | Full |
| **GPU support** | No | No | Yes |
| **Persistent storage** | EFS (via VPC) | EFS, EBS | Any |
| **Management overhead** | Minimal | Low | High |
| **Best for** | Short, event-driven tasks | Long-running containers | Custom OS, GPU, compliance |

**Decision guide:**
- **Lambda**: Short tasks (<15 min), event-driven, unpredictable/spiky traffic, rapid scaling needed
- **Fargate**: Long-running tasks, containers, no server management, predictable workloads
- **EC2**: Full OS control, GPU needs, legacy apps, specific compliance, high-performance computing

---

## Exam Tips & Scenarios

### Scenario 1: Processing S3 Uploads
**Q:** Process each file uploaded to S3 (files average 100 MB, processing takes 2 minutes).
**A:** S3 event notification → Lambda function. Lambda timeout set to 3+ minutes (well within 15-min limit).

### Scenario 2: Long-Running ETL
**Q:** ETL job processes data for 30 minutes per batch.
**A:** Lambda (15-min max) won't work. Use Step Functions to orchestrate Lambda functions (split work), Fargate, or AWS Batch.

### Scenario 3: Spiky API Traffic
**Q:** API receives 0-10,000 requests/second with unpredictable spikes.
**A:** API Gateway + Lambda (auto-scales instantly, scales to zero). Configure reserved concurrency for critical functions.

### Scenario 4: Real-Time WebSocket Communication
**Q:** Chat application needs real-time bidirectional communication.
**A:** API Gateway WebSocket API + Lambda for message handling + DynamoDB for connection tracking.

### Scenario 5: Reducing Cold Starts
**Q:** API responses must be under 100ms. Lambda cold starts are causing timeout issues.
**A:** Provisioned Concurrency on the Lambda alias, with Application Auto Scaling to match traffic patterns.

### Scenario 6: Event-Driven Architecture
**Q:** Multiple microservices need to react to the same event without tight coupling.
**A:** EventBridge custom event bus → Multiple rules routing to different Lambda functions/SQS queues.

### Scenario 7: Lambda Cannot Reach RDS
**Q:** Lambda function configured for VPC access cannot connect to the internet to call external APIs.
**A:** Lambda is in a private subnet. Add a NAT Gateway in a public subnet and update route tables. Or use VPC endpoints for AWS services.

### Scenario 8: Orchestrating Microservices
**Q:** Multi-step order processing with error handling and compensation logic.
**A:** Step Functions Standard workflow with Retry/Catch for error handling and compensating Task states.

### Scenario 9: GraphQL API for Mobile App
**Q:** Mobile app needs efficient data fetching (avoid over-fetching) with offline sync.
**A:** AppSync (GraphQL) with DynamoDB data source. Amplify client for offline sync.

### Scenario 10: Deploying Serverless Infrastructure
**Q:** Team wants infrastructure as code for their serverless stack (Lambda + API Gateway + DynamoDB).
**A:** AWS SAM template with `sam deploy`. Or CloudFormation/CDK with serverless resources.

### Key Exam Patterns

1. **Lambda 15-minute limit** is the most common gotcha — if the task takes longer, Lambda is wrong
2. **Lambda concurrency**: 1,000 default. If one function consumes all concurrency, others are throttled → use Reserved Concurrency
3. **Lambda + VPC**: Private subnet + NAT Gateway for internet. VPC endpoints for AWS services.
4. **Synchronous = caller retries**; **Asynchronous = Lambda retries (2x)**; **Event Source Mapping = depends on source**
5. **Provisioned Concurrency** eliminates cold starts (costs money); **Reserved Concurrency** guarantees and limits capacity (free)
6. **Step Functions Standard** for long workflows (up to 1 year); **Express** for high-volume, short workflows
7. **API Gateway REST API** for full features; **HTTP API** for lower cost and latency
8. **EventBridge** is the go-to for event-driven architectures (replaces CloudWatch Events)
9. **Lambda@Edge** for complex edge logic; **CloudFront Functions** for lightweight, high-volume operations
10. **Lambda Destinations > DLQ** for async invocations (more flexible, captures successes too)

---

*Previous: [← EC2 Deep Dive](07-ec2-deep-dive.md) | Next: [ECS, EKS & Container Services →](09-containers-ecs-eks.md)*
