# Step Functions, SWF & AppFlow

## Table of Contents

1. [AWS Step Functions Overview](#aws-step-functions-overview)
2. [Standard vs Express Workflows](#standard-vs-express-workflows)
3. [Step Functions States](#step-functions-states)
4. [Step Functions Error Handling](#step-functions-error-handling)
5. [Step Functions Service Integrations](#step-functions-service-integrations)
6. [Step Functions Patterns](#step-functions-patterns)
7. [Step Functions Input/Output Processing](#step-functions-inputoutput-processing)
8. [Step Functions Execution](#step-functions-execution)
9. [Amazon AppFlow](#amazon-appflow)
10. [Amazon SWF (Simple Workflow Service)](#amazon-swf-simple-workflow-service)
11. [Amazon Kinesis Data Streams](#amazon-kinesis-data-streams)
12. [Amazon Kinesis Data Firehose](#amazon-kinesis-data-firehose)
13. [Amazon Kinesis Data Analytics](#amazon-kinesis-data-analytics)
14. [Amazon Kinesis Video Streams](#amazon-kinesis-video-streams)
15. [Kinesis vs SQS Comparison](#kinesis-vs-sqs-comparison)
16. [Common Exam Scenarios](#common-exam-scenarios)

---

## AWS Step Functions Overview

AWS Step Functions is a serverless orchestration service that lets you combine AWS Lambda functions and other AWS services to build business-critical applications.

### Key Characteristics

- **Visual workflow**: Design workflows as state machines with a visual editor
- **Serverless**: No infrastructure to manage
- **Automatic scaling**: Scales to match workflow execution volume
- **Built-in error handling**: Retry, catch, and timeout mechanisms
- **Auditable**: Full execution history and logging
- **JSON-based**: Workflows defined using **Amazon States Language (ASL)**
- **Integration**: Direct integration with 200+ AWS services

### Core Concepts

- **State Machine**: The workflow definition (written in Amazon States Language)
- **State**: An individual step in the workflow
- **Execution**: A running instance of a state machine
- **Transition**: Movement from one state to the next
- **Input/Output**: Data passed between states as JSON

### Amazon States Language (ASL)

- JSON-based structured language
- Defines states, transitions, and error handling
- Each state machine has a `StartAt` field and a `States` object

```json
{
  "Comment": "Simple workflow",
  "StartAt": "FirstState",
  "States": {
    "FirstState": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789:function:myFunction",
      "Next": "SecondState"
    },
    "SecondState": {
      "Type": "Succeed"
    }
  }
}
```

---

## Standard vs Express Workflows

Step Functions offers two workflow types with different characteristics.

### Standard Workflows

| Feature | Value |
|---------|-------|
| **Maximum duration** | Up to **1 year** (365 days) |
| **Execution model** | Exactly-once execution |
| **State transitions** | Up to **25,000** per execution |
| **Execution start rate** | 2,000 per second (soft limit) |
| **State transition rate** | 4,000 per second per account |
| **History** | Full execution history available |
| **Pricing** | Per state transition ($0.025 per 1,000) |
| **Idempotency** | Built-in (exactly-once) |

**Best for:**
- Long-running workflows
- Workflows requiring exactly-once processing
- Workflows that need full audit trail
- Human approval workflows
- ETL pipelines, order processing

### Express Workflows

| Feature | Value |
|---------|-------|
| **Maximum duration** | Up to **5 minutes** |
| **Execution model** | At-least-once execution |
| **State transitions** | Unlimited |
| **Execution start rate** | 100,000 per second |
| **State transition rate** | Nearly unlimited |
| **History** | Must be configured (CloudWatch Logs) |
| **Pricing** | Per execution + duration + memory |
| **Idempotency** | Not built-in (at-least-once) |

**Best for:**
- High-volume event processing
- Streaming data processing
- IoT data ingestion
- Short-duration, high-frequency workflows

### Express Workflow Types

**Synchronous Express:**
- Caller waits for the workflow to complete
- Returns the result to the caller
- Used when: API Gateway needs immediate response, request/response pattern
- Maximum duration: 5 minutes

**Asynchronous Express:**
- Returns immediately after starting
- Results sent to CloudWatch Logs
- Does not wait for completion
- Used when: Fire-and-forget processing, event-driven processing
- Maximum duration: 5 minutes

### Standard vs Express Comparison

| Feature | Standard | Express |
|---------|----------|---------|
| Duration | Up to 1 year | Up to 5 minutes |
| Execution Guarantee | Exactly-once | At-least-once |
| Max Transitions | 25,000 | Unlimited |
| Start Rate | 2,000/s | 100,000/s |
| Execution History | Built-in | CloudWatch Logs |
| Pricing | Per transition | Per execution + duration |
| Sync Invocation | Not supported | Supported |
| Cost for High Volume | Higher | Lower |

---

## Step Functions States

Step Functions supports eight state types.

### Task State

Performs work by invoking an activity, Lambda function, or AWS service.

```json
{
  "Type": "Task",
  "Resource": "arn:aws:lambda:us-east-1:123456789:function:ProcessOrder",
  "TimeoutSeconds": 300,
  "HeartbeatSeconds": 60,
  "Next": "NextState"
}
```

- **Resource**: ARN of the service to invoke
- **TimeoutSeconds**: Maximum time for task completion (default: no timeout, inherits state machine timeout)
- **HeartbeatSeconds**: Interval for activity heartbeat (prevents timeout for long-running tasks)
- Most commonly used state type

### Choice State

Adds branching logic (like if/else or switch).

```json
{
  "Type": "Choice",
  "Choices": [
    {
      "Variable": "$.status",
      "StringEquals": "approved",
      "Next": "ProcessOrder"
    },
    {
      "Variable": "$.amount",
      "NumericGreaterThan": 1000,
      "Next": "ManagerApproval"
    }
  ],
  "Default": "DefaultState"
}
```

- **Choices**: Array of comparison rules
- **Default**: State to transition to if no choice matches
- Supports: StringEquals, StringGreaterThan, NumericEquals, BooleanEquals, TimestampEquals, IsPresent, IsString, And, Or, Not
- Does NOT support `End` or `Next` at the Choice state level (each choice branch specifies Next)

### Parallel State

Executes multiple branches simultaneously.

```json
{
  "Type": "Parallel",
  "Branches": [
    {
      "StartAt": "LookupAddress",
      "States": {
        "LookupAddress": { "Type": "Task", "Resource": "...", "End": true }
      }
    },
    {
      "StartAt": "LookupPhone",
      "States": {
        "LookupPhone": { "Type": "Task", "Resource": "...", "End": true }
      }
    }
  ],
  "Next": "MergeResults"
}
```

- Each branch is an independent sub-state machine
- All branches start simultaneously
- Parallel state waits for ALL branches to complete
- Output: Array of results from each branch
- If any branch fails, the entire Parallel state fails

### Map State

Iterates over an array, processing each element.

**Inline Map (for smaller datasets):**
```json
{
  "Type": "Map",
  "ItemsPath": "$.orders",
  "MaxConcurrency": 10,
  "Iterator": {
    "StartAt": "ProcessOrder",
    "States": {
      "ProcessOrder": { "Type": "Task", "Resource": "...", "End": true }
    }
  },
  "Next": "Done"
}
```

**Distributed Map (for large datasets):**
- Process millions of items from S3, DynamoDB, or other sources
- Up to **10,000 concurrent** child workflow executions
- Input from S3 (CSV, JSON, S3 inventory)
- Results written to S3
- Launched as child executions (separate state machines)
- Use for: Large-scale batch processing, ETL

### Wait State

Delays the state machine for a specified time.

```json
{
  "Type": "Wait",
  "Seconds": 300,
  "Next": "NextState"
}
```

OR using a timestamp:
```json
{
  "Type": "Wait",
  "TimestampPath": "$.scheduledTime",
  "Next": "NextState"
}
```

- **Seconds**: Wait a fixed number of seconds
- **Timestamp**: Wait until a specific time (ISO 8601)
- **SecondsPath/TimestampPath**: Dynamic wait from input data

### Succeed State

Terminates the state machine successfully.

```json
{
  "Type": "Succeed"
}
```

- No `Next` field
- Marks successful completion
- Used as a terminal state in Choice branches

### Fail State

Terminates the state machine with a failure.

```json
{
  "Type": "Fail",
  "Error": "CustomError",
  "Cause": "The request was invalid"
}
```

- **Error**: Error name
- **Cause**: Human-readable description
- Stops execution and marks it as failed

### Pass State

Passes input to output, optionally transforming the data.

```json
{
  "Type": "Pass",
  "Result": { "key": "value" },
  "ResultPath": "$.addedData",
  "Next": "NextState"
}
```

- Useful for debugging and testing
- Can inject fixed data into the state output
- Can transform data without invoking a service

---

## Step Functions Error Handling

Step Functions provides robust error handling through Retry and Catch mechanisms.

### Error Types

| Error | Description |
|-------|-------------|
| **States.ALL** | Matches all errors |
| **States.Timeout** | Task exceeded TimeoutSeconds |
| **States.TaskFailed** | Lambda/Activity returned an error |
| **States.Permissions** | Insufficient permissions for the Task |
| **States.ResultPathMatchFailure** | ResultPath couldn't be applied |
| **States.ParameterPathFailure** | Parameter path doesn't exist |
| **States.BranchFailed** | Parallel state branch failed |
| **States.NoChoiceMatched** | Choice state had no match and no Default |
| **States.IntrinsicFailure** | Intrinsic function call failed |
| Custom errors | Application-defined error names |

### Retry

Automatically retries a failed state.

```json
{
  "Type": "Task",
  "Resource": "arn:aws:lambda:...",
  "Retry": [
    {
      "ErrorEquals": ["States.Timeout"],
      "IntervalSeconds": 3,
      "MaxAttempts": 2,
      "BackoffRate": 2.0
    },
    {
      "ErrorEquals": ["States.ALL"],
      "IntervalSeconds": 1,
      "MaxAttempts": 3,
      "BackoffRate": 1.5
    }
  ],
  "Next": "NextState"
}
```

**Retry Parameters:**
- **ErrorEquals**: List of error names to match
- **IntervalSeconds**: Initial wait before first retry (default 1)
- **MaxAttempts**: Maximum retry count (default 3, set to 0 to disable)
- **BackoffRate**: Multiplier for subsequent wait times (default 2.0)
- **MaxDelaySeconds**: Maximum wait between retries
- **JitterStrategy**: Add randomness to retry intervals (FULL or NONE)

**Retry Order:**
- Retry rules are evaluated in order (first match wins)
- Place specific errors before `States.ALL`
- After all retries are exhausted, falls through to Catch

### Catch

Routes to a fallback state when retries are exhausted or for unretried errors.

```json
{
  "Type": "Task",
  "Resource": "arn:aws:lambda:...",
  "Retry": [...],
  "Catch": [
    {
      "ErrorEquals": ["CustomError"],
      "Next": "HandleCustomError",
      "ResultPath": "$.error"
    },
    {
      "ErrorEquals": ["States.ALL"],
      "Next": "HandleAllErrors",
      "ResultPath": "$.error"
    }
  ],
  "Next": "NextState"
}
```

**Catch Parameters:**
- **ErrorEquals**: List of error names to match
- **Next**: State to transition to on error
- **ResultPath**: Where to place the error information in the output

### ResultPath in Error Handling

- `"ResultPath": "$.error"` → Error info is added to the input under `$.error`
- `"ResultPath": null` → Error info is discarded, original input is preserved
- Useful for preserving the original input while adding error details

### Error Handling Best Practices

1. Always define Retry and Catch for Task states
2. Use specific error types before `States.ALL`
3. Set `TimeoutSeconds` on Task states (avoid infinite waits)
4. Use `HeartbeatSeconds` for long-running activities
5. Route to cleanup/compensation states on failure (saga pattern)
6. Log errors to CloudWatch for debugging

---

## Step Functions Service Integrations

Step Functions integrates with over 200 AWS services directly (without Lambda intermediary).

### Integration Patterns

**Request Response (default):**
- Call the service and move to the next state immediately
- Does not wait for the service to complete
- Use for fire-and-forget operations

**Run a Job (.sync):**
- Call the service and wait for completion
- Step Functions polls the service for completion
- Use for: Batch jobs, ECS tasks, Glue jobs
- Resource ARN ends with `.sync`

**Wait for Callback (.waitForTaskToken):**
- Send a task token to the service
- Pause until the service calls `SendTaskSuccess` or `SendTaskFailure` with the token
- Use for: Human approval, external system integration, long-running external processes
- Resource ARN ends with `.waitForTaskToken`

### Key Service Integrations

| Service | Integration Type | Use Case |
|---------|-----------------|----------|
| **Lambda** | Request Response, .sync | Compute, transformation |
| **DynamoDB** | Request Response | GetItem, PutItem, UpdateItem, DeleteItem |
| **ECS/Fargate** | .sync | Container tasks |
| **SNS** | Request Response | Notifications |
| **SQS** | Request Response, .waitForTaskToken | Messaging, human tasks |
| **Batch** | .sync | Batch processing |
| **Glue** | .sync | ETL jobs |
| **SageMaker** | .sync | ML training, transform |
| **CodeBuild** | .sync | Build projects |
| **Step Functions** | .sync, .waitForTaskToken | Nested workflows |
| **API Gateway** | Request Response | REST API calls |
| **EventBridge** | Request Response | Event publishing |
| **Athena** | .sync | SQL queries |
| **EMR** | .sync | Big data processing |
| **MediaConvert** | .sync | Video processing |

### Optimized Integrations

Some services have **optimized integrations** that use direct API calls instead of Lambda:
- DynamoDB: PutItem, GetItem, DeleteItem, UpdateItem directly
- SQS: SendMessage directly
- SNS: Publish directly
- This reduces cost (no Lambda invocation) and latency

---

## Step Functions Patterns

### Saga Pattern

Implements distributed transactions with compensating actions.

**Problem**: Multi-step processes where each step must be undone if a later step fails.

**Solution**: For each forward action, define a compensating action:

```
Book Flight → Book Hotel → Book Car
       ↓ fail      ↓ fail      ↓ fail
Cancel Flight ← Cancel Hotel ← Cancel Car
```

**Implementation:**
1. Each step is a Task state
2. Each Task has a Catch that routes to a compensation chain
3. Compensation states undo the completed steps in reverse order
4. Use ResultPath to preserve context for compensation

### Human Approval Pattern

Pause workflow until a human approves or rejects.

**Implementation:**
1. Task state sends approval request (email via SNS, SQS message)
2. Include the **task token** in the notification
3. Workflow pauses (`.waitForTaskToken`)
4. Human clicks approve/reject link → API call to `SendTaskSuccess` or `SendTaskFailure`
5. Workflow resumes based on the response

```json
{
  "Type": "Task",
  "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
  "Parameters": {
    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/123456789/approval-queue",
    "MessageBody": {
      "TaskToken.$": "$$.Task.Token",
      "Message": "Please approve this request"
    }
  },
  "Next": "ApprovalDecision"
}
```

### Map State for Batch Processing

Process collections of items in parallel.

**Example**: Process all orders for a customer:
1. Query DynamoDB for all orders
2. Map state iterates over each order
3. Each order is processed by a Lambda function
4. Results are collected

**Distributed Map for large-scale:**
- Read millions of items from S3
- Process up to 10,000 items in parallel
- Write results back to S3
- Use for: ETL, data migration, batch processing

### Chaining Pattern

Simple sequential execution of tasks:

```
Task A → Task B → Task C → Done
```

Each task passes its output as input to the next task.

### Branching Pattern

Use Choice state for conditional routing:

```
Start → Choice → Branch A → End
              → Branch B → End
              → Default  → End
```

### Parallel Processing Pattern

Execute independent tasks simultaneously:

```
Start → Parallel → Branch 1 (verify identity)
                → Branch 2 (check credit)
                → Branch 3 (verify address)
       → Merge Results → Continue
```

---

## Step Functions Input/Output Processing

Step Functions provides fine-grained control over data flow between states.

### Data Flow Fields

| Field | Purpose | Applied When |
|-------|---------|-------------|
| **InputPath** | Filter the state input | Before the task executes |
| **Parameters** | Construct the input for the task | Before the task executes |
| **ResultSelector** | Filter the task result | After the task completes |
| **ResultPath** | Combine the result with original input | After ResultSelector |
| **OutputPath** | Filter the final state output | Before passing to next state |

### Processing Order

```
State Input → InputPath → Parameters → [Task Execution] → ResultSelector → ResultPath → OutputPath → State Output
```

### InputPath

Selects a subset of the state input to pass to the task.

```json
{
  "InputPath": "$.order"
}
```

- If input is `{"order": {"id": 123}, "customer": {"name": "John"}}`, only `{"id": 123}` is passed to the task
- Set to `null` to pass empty JSON `{}`
- Default: `$` (entire input)

### Parameters

Constructs a new JSON object as the task input. Can include static values and references to input.

```json
{
  "Parameters": {
    "FunctionName": "myFunction",
    "Payload": {
      "orderId.$": "$.order.id",
      "staticValue": "hello"
    }
  }
}
```

- Fields ending in `.$` are JSONPath references to the input
- Fields without `.$` are static/literal values
- Can reference context object: `$$.Execution.Id`, `$$.Task.Token`, etc.

### ResultSelector

Filters and reshapes the task's raw result.

```json
{
  "ResultSelector": {
    "statusCode.$": "$.SdkHttpMetadata.HttpStatusCode",
    "body.$": "$.Payload"
  }
}
```

- Applied after task completes, before ResultPath
- Useful for extracting relevant fields from verbose AWS API responses

### ResultPath

Determines where in the original input the task result is placed.

```json
{
  "ResultPath": "$.taskResult"
}
```

- `"$.taskResult"` → Original input is preserved, task result is added at `$.taskResult`
- `"$"` (default) → Task result replaces entire input
- `null` → Task result is discarded, original input passes through unchanged
- **Critical for error handling**: Preserve input while adding error info

### OutputPath

Filters the combined result (input + task result) before passing to the next state.

```json
{
  "OutputPath": "$.taskResult"
}
```

- Selects a subset of the state's output
- Default: `$` (entire output)
- Set to `null` to discard all output (pass `{}` to next state)

### Context Object

Available in Parameters via `$$`:

| Field | Description |
|-------|-------------|
| `$$.Execution.Id` | Execution ARN |
| `$$.Execution.Name` | Execution name |
| `$$.Execution.StartTime` | Start timestamp |
| `$$.Execution.Input` | Original execution input |
| `$$.State.Name` | Current state name |
| `$$.State.EnteredTime` | Time state was entered |
| `$$.Task.Token` | Task token (for callback) |
| `$$.Map.Item.Index` | Map state item index |
| `$$.Map.Item.Value` | Map state item value |

---

## Step Functions Execution

### Starting an Execution

- **Console**: Start execution from the Step Functions console
- **API**: `StartExecution` API call
- **SDK**: AWS SDK (any supported language)
- **EventBridge**: Rule target
- **API Gateway**: Integration target
- **Lambda**: Invoke via SDK
- **CLI**: `aws stepfunctions start-execution`

### Describe Execution

- `DescribeExecution`: Get execution status, input, output, start/stop time
- Status values: RUNNING, SUCCEEDED, FAILED, TIMED_OUT, ABORTED

### Execution History

- Standard workflows: Full history available (up to 25,000 events)
- Express workflows: Sent to CloudWatch Logs (must configure)
- History includes: StateEntered, StateExited, TaskStarted, TaskSucceeded, TaskFailed, etc.
- Useful for debugging and auditing

### Express Workflow Invocation

**Synchronous (StartSyncExecution):**
- Caller blocks until execution completes (or times out)
- Returns output directly
- Used with API Gateway for request/response patterns
- Maximum 5-minute timeout

**Asynchronous (StartExecution):**
- Returns immediately with execution ARN
- Results available in CloudWatch Logs
- Fire-and-forget pattern

### Step Functions with CloudWatch

- **CloudWatch Metrics**: ExecutionsStarted, ExecutionsSucceeded, ExecutionsFailed, ExecutionsTimedOut, ExecutionThrottled
- **CloudWatch Logs**: Execution history for Express workflows, logging for Standard
- **X-Ray**: Distributed tracing for workflow execution
- **CloudWatch Alarms**: Alert on execution failures or timeouts

---

## Amazon AppFlow

Amazon AppFlow is a fully managed integration service for transferring data between SaaS applications and AWS services.

### Key Characteristics

- **No-code/low-code**: Visual interface for creating data flows
- **Secure**: Data encrypted in transit and at rest
- **Scalable**: Handles billions of data records
- **Managed**: No infrastructure to manage
- **Bidirectional**: Source → AWS or AWS → Destination

### Supported Sources (SaaS Applications)

- **Salesforce**: Accounts, contacts, opportunities, custom objects
- **SAP**: S/4HANA, ECC
- **Slack**: Messages, channels
- **ServiceNow**: Incidents, change requests
- **Google Analytics**: Reports, dimensions, metrics
- **Zendesk**: Tickets, users
- **Marketo**: Leads, activities
- **Datadog**: Metrics, events
- **Veeva**: Vault documents
- **Amazon S3** (as source)
- Many more (40+ SaaS connectors)

### Supported Destinations

- **Amazon S3**: Data lake storage
- **Amazon Redshift**: Data warehouse
- **Salesforce**: Write back to Salesforce
- **Snowflake**: Cloud data warehouse
- **Amazon EventBridge**: Event-driven processing
- **Amazon Lookout for Metrics**: Anomaly detection
- **Zendesk**: Write back
- **SAP**: Write back
- Custom connectors

### Flow Triggers

| Trigger | Description | Use Case |
|---------|-------------|----------|
| **On-demand** | Manual trigger | One-time data transfer |
| **Scheduled** | Periodic execution | Regular data sync (hourly, daily) |
| **Event-driven** | Triggered by source events | Real-time sync (Salesforce events) |

### Data Transformations

- **Mapping**: Map source fields to destination fields
- **Filtering**: Include/exclude records based on conditions
- **Validation**: Validate data before transfer
- **Masking**: Mask sensitive data fields
- **Merging**: Combine fields
- **Truncating**: Limit field length
- **Arithmetic**: Perform calculations on fields

### AppFlow Security

- Data encrypted in transit with TLS
- Data encrypted at rest with KMS
- Supports **AWS PrivateLink**: Data flows through AWS private network (not internet)
- VPC endpoints for secure connectivity
- Fine-grained IAM policies

### Use Cases

- Sync Salesforce data to S3/Redshift for analytics
- Real-time Salesforce event processing via EventBridge
- Data migration from SaaS to AWS
- Bi-directional sync between SaaS applications and AWS
- Compliance: Keep data within AWS network (PrivateLink)

### Exam Tip

- "Transfer data from SaaS (Salesforce, SAP) to AWS" → **Amazon AppFlow**
- "No-code data integration" → **AppFlow**
- "Salesforce to S3/Redshift sync" → **AppFlow**

---

## Amazon SWF (Simple Workflow Service)

Amazon SWF is an older workflow orchestration service that coordinates work across distributed applications.

### Key Concepts

- **Workflow**: The overall coordination logic
- **Activities**: Individual tasks (units of work)
- **Activity Workers**: Programs that perform activities
- **Deciders**: Programs that control the flow of activities (coordination logic)
- **Domain**: Scope for workflows (similar to namespace)
- **Workflow Execution**: A running instance of a workflow

### How SWF Works

1. Decider determines the next activity to perform
2. SWF schedules the activity with an activity worker
3. Activity worker performs the task and reports results
4. Decider evaluates results and determines next step
5. Repeat until workflow completes

### SWF vs Step Functions

| Feature | SWF | Step Functions |
|---------|-----|---------------|
| Age | Older (2012) | Newer (2016) |
| Programming | Code-based (deciders, workers) | JSON/YAML (ASL) |
| Visual | No built-in visual editor | Visual workflow designer |
| Maintenance | AWS not investing new features | Actively developed |
| Recommendation | Legacy only | Preferred for new projects |
| Max Duration | 1 year | Standard: 1 year, Express: 5 min |
| Human Tasks | Native support | Via callbacks |
| External Signals | Native | Callback with task token |

### When SWF Is Still Relevant

- Legacy applications already using SWF
- Need for **external signal handling** (human/mechanical Turk integration)
- Complex custom workflow logic that requires programmatic deciders
- Already heavily invested in SWF infrastructure

### Exam Tip

- For **new projects**: Always recommend **Step Functions**
- SWF may appear as a distractor or for legacy migration scenarios
- "Coordinate tasks across distributed components" → **Step Functions** (unless legacy context)

---

## Amazon Kinesis Data Streams

Amazon Kinesis Data Streams is a real-time data streaming service for ingesting and processing large volumes of data records.

### Key Concepts

- **Stream**: A logical grouping of shards
- **Shard**: A uniquely identified sequence of data records (unit of capacity)
- **Data Record**: The unit of data; consists of sequence number, partition key, and data blob
- **Partition Key**: Determines which shard a record goes to (hashed)
- **Sequence Number**: Unique per-record identifier assigned by Kinesis
- **Producers**: Applications that put data records into the stream
- **Consumers**: Applications that get data records from the stream

### Shard Capacity

| Direction | Capacity per Shard |
|-----------|-------------------|
| **Write** | 1 MB/second or 1,000 records/second |
| **Read (shared)** | 2 MB/second (shared across all consumers) |
| **Read (enhanced fan-out)** | 2 MB/second per consumer per shard |

### Provisioned Mode

- You specify the number of shards
- Each shard has fixed capacity (1 MB/s in, 2 MB/s out)
- Scale by splitting (increase) or merging (decrease) shards
- Manual or API-based scaling
- Pay per shard-hour

### On-Demand Mode

- Kinesis automatically manages shards
- No capacity planning needed
- Default capacity: 4 MB/s write, scales up to 200 MB/s
- Pay per stream-hour and per GB of data

### Data Retention

- Default: **24 hours**
- Maximum: **365 days** (8,760 hours)
- Extended retention incurs additional charges
- **Key feature**: Data replay — consumers can reprocess data within the retention period

### Producers

| Producer | Description |
|----------|-------------|
| **AWS SDK** | PutRecord, PutRecords API |
| **Kinesis Producer Library (KPL)** | Batching, compression, retry, async |
| **Kinesis Agent** | Pre-built Java agent for log files |
| **AWS IoT** | IoT rules action |
| **CloudWatch Logs** | Subscription filter |
| **Amazon EventBridge** | Target |

### Consumers

**Shared Throughput (Pull/Polling):**
- Consumer calls `GetRecords` API
- All consumers for a shard **share** 2 MB/s read throughput
- Higher latency (~200ms to 1s)
- Consumers: KCL, AWS SDK, Lambda

**Enhanced Fan-Out (Push):**
- Consumer subscribes to a shard using `SubscribeToShard` API
- Each consumer gets **dedicated** 2 MB/s per shard
- Lower latency (~70ms)
- Push-based (HTTP/2 connection)
- Up to **20 consumers** per stream with enhanced fan-out
- Additional cost per consumer

### Kinesis Client Library (KCL)

- Java library for building Kinesis consumer applications
- Handles: Shard discovery, checkpointing, load balancing, failover
- **Checkpointing**: Tracks the last processed record (using DynamoDB table)
- **Lease table**: DynamoDB table for shard assignments
- One KCL worker can process multiple shards
- Number of KCL instances should be ≤ number of shards
- KCL versions: KCL 1.x (polling), KCL 2.x (supports enhanced fan-out)

### Kinesis with Lambda

- Lambda can be an event source for Kinesis Data Streams
- Lambda polls the stream and invokes your function with a batch of records
- Configuration:
  - **Batch size**: 1 to 10,000 records
  - **Batch window**: Up to 5 minutes
  - **Starting position**: LATEST, TRIM_HORIZON, AT_TIMESTAMP
  - **Parallelization factor**: 1-10 (number of concurrent batches per shard)
  - **On failure**: Bisect batch, retry, DLQ (SQS/SNS)

### Ordering in Kinesis

- Records with the **same partition key** go to the **same shard**
- Within a shard, records are **strictly ordered** by sequence number
- Different partition keys may go to different shards (no cross-shard ordering)
- Design partition keys for even shard distribution

---

## Amazon Kinesis Data Firehose

Amazon Kinesis Data Firehose is a fully managed service for delivering real-time streaming data to destinations.

### Key Characteristics

- **Fully managed**: No administration, auto-scaling
- **Near real-time**: Minimum buffer time of **60 seconds** (not true real-time)
- **Serverless**: No shards, no capacity planning
- **Automatic scaling**: Handles any data volume
- **Data transformation**: Optional Lambda transformation before delivery

### Delivery Destinations

| Destination | Description |
|-------------|-------------|
| **Amazon S3** | Data lake, archival |
| **Amazon Redshift** | Data warehouse (via S3 COPY) |
| **Amazon OpenSearch** | Search and analytics |
| **Splunk** | Operational intelligence |
| **HTTP Endpoint** | Custom destinations, partners |
| **Datadog** | Monitoring |
| **New Relic** | Monitoring |
| **MongoDB** | Document database |

### Data Transformation with Lambda

1. Firehose receives records from producers
2. Optionally invokes a **Lambda function** for transformation
3. Lambda processes each record and returns:
   - `Ok`: Record is delivered
   - `Dropped`: Record is discarded
   - `ProcessingFailed`: Record is treated as failed
4. Transformed records are delivered to the destination

### Buffering

- **Buffer size**: 1 MB to 128 MB (varies by destination)
- **Buffer interval**: 60 seconds to 900 seconds
- Firehose delivers when EITHER condition is met (size OR time)
- Smaller buffer = lower latency, more delivery requests
- Larger buffer = higher latency, fewer delivery requests, better compression

### Data Format Conversion

- Convert input format to output format automatically
- Example: JSON → Apache Parquet or ORC (columnar)
- Uses AWS Glue table definition for schema
- Reduces storage costs and improves query performance (for Athena, Redshift Spectrum)

### Compression

- Supported: GZIP, ZIP, Snappy, Hadoop-compatible Snappy
- Applied after transformation, before delivery
- S3 destination: All compression types supported
- Redshift: GZIP, ZIP, Snappy (Redshift handles decompression)

### Error Handling

- Failed records backed up to **S3** (separate S3 prefix)
- Retry: Firehose retries for up to 24 hours (S3) or configurable
- Source record backup: Optionally store original (untransformed) records in S3

### Firehose vs Kinesis Data Streams

| Feature | Firehose | Data Streams |
|---------|----------|--------------|
| Management | Fully managed | You manage shards |
| Latency | Near real-time (60s+) | Real-time (~200ms or 70ms) |
| Scaling | Automatic | Manual/On-demand |
| Consumers | One destination | Multiple consumers |
| Data Replay | No | Yes |
| Transformation | Lambda (built-in) | Consumer-side |
| Destinations | S3, Redshift, OpenSearch, etc. | Custom consumers |
| Retention | None (pass-through) | 1-365 days |

---

## Amazon Kinesis Data Analytics

Amazon Kinesis Data Analytics enables real-time analytics on streaming data using SQL or Apache Flink.

### Kinesis Data Analytics for SQL (Legacy)

- Write **SQL queries** against streaming data
- Input: Kinesis Data Streams or Kinesis Data Firehose
- Output: Kinesis Data Streams, Kinesis Data Firehose, Lambda
- Real-time dashboards, metrics, alerts
- Reference data from S3 for enrichment
- **Being replaced by Managed Apache Flink**

### Kinesis Data Analytics for Apache Flink (Managed Service for Apache Flink)

- Run **Apache Flink** applications on streaming data
- Languages: Java, Scala, Python, SQL
- Input: Kinesis Data Streams, Amazon MSK (Kafka)
- Output: Kinesis Data Streams, Kinesis Data Firehose, S3, DynamoDB, etc.
- Supports stateful processing, windowing, aggregations
- Automatic scaling and fault tolerance
- Checkpointing for exactly-once processing

### Use Cases

- Real-time dashboards and monitoring
- Anomaly detection on streaming data
- Real-time ETL
- Log analytics
- Click-stream analytics
- IoT data processing

### Exam Tip

- "Real-time analytics on streaming data" → Kinesis Data Analytics (Managed Apache Flink)
- "SQL on streaming data" → Kinesis Data Analytics for SQL

---

## Amazon Kinesis Video Streams

Amazon Kinesis Video Streams is a fully managed service for streaming video from connected devices to AWS.

### Key Features

- Ingest video streams from cameras, IoT devices, smartphones
- Store, process, and analyze video in real-time
- Supports H.264, H.265 video codecs and other media formats
- **HLS (HTTP Live Streaming)**: Play back video in real-time
- **DASH**: Dynamic Adaptive Streaming over HTTP
- Encryption at rest and in transit
- Data retention: No limit (configurable)

### Integration

- **Amazon Rekognition Video**: Facial recognition, object detection
- **Amazon SageMaker**: Custom ML models on video
- **Apache MXNet**: Deep learning framework
- **Custom consumers**: GetMedia API

### Use Cases

- Security and surveillance
- Smart home (Ring doorbell, baby monitors)
- Industrial automation (visual inspection)
- Live streaming
- Computer vision applications

### Exam Tip

- "Stream video from devices to AWS" → **Kinesis Video Streams**
- "Video analysis with ML" → Kinesis Video Streams + Rekognition Video

---

## Kinesis vs SQS Comparison

| Feature | Kinesis Data Streams | SQS |
|---------|---------------------|-----|
| **Model** | Data streaming | Message queuing |
| **Ordering** | Per-shard guarantee | FIFO only (Standard: best-effort) |
| **Consumers** | Multiple (fan-out) | Single per message |
| **Data Replay** | Yes (within retention) | No (consumed = deleted) |
| **Retention** | 1 day – 365 days | 1 min – 14 days |
| **Max Record Size** | 1 MB | 256 KB |
| **Throughput** | Per shard (1 MB/s in) | Unlimited (Standard) |
| **Provisioning** | Shards (or on-demand) | No provisioning |
| **Latency** | ~70ms (enhanced fan-out) | Variable |
| **Scaling** | Split/merge shards | Automatic |
| **Use Case** | Streaming analytics, real-time | Decoupling, buffering |
| **Processing** | KCL, Lambda, Flink | Lambda, EC2 |
| **Cost Model** | Per shard-hour + data | Per request |

### When to Choose Kinesis

- Real-time data streaming and analytics
- Multiple consumers need the same data
- Need to replay data
- Ordered processing is required
- IoT data, clickstream, log aggregation
- Need Apache Flink or real-time SQL

### When to Choose SQS

- Simple producer/consumer decoupling
- Guaranteed message delivery (even if consumer is down)
- Variable processing speed (buffer)
- Single consumer per message (competing consumers)
- Simpler to set up and manage
- Cost-effective for lower throughput

---

## Common Exam Scenarios

### Scenario 1: Orchestrate Multi-Step Order Processing

**Question**: An e-commerce application needs to orchestrate order processing: validate inventory, charge payment, send notification, update database.

**Solution**: Use **AWS Step Functions** Standard workflow. Each step is a Task state. Use Retry for transient failures. Use Catch with a saga pattern to compensate (refund payment, restore inventory) if any step fails.

### Scenario 2: High-Volume Event Processing

**Question**: An IoT application receives 100,000 events per second and needs to process each event in under 5 minutes.

**Solution**: Use **Step Functions Express workflow** (asynchronous). Express workflows support 100,000 executions/second and are designed for high-volume, short-duration workloads.

### Scenario 3: Human Approval Workflow

**Question**: A workflow needs to pause and wait for a manager to approve a request before continuing.

**Solution**: Use **Step Functions** with a `.waitForTaskToken` integration. Send the task token via SNS (email to manager). The workflow pauses until the manager's approval system calls `SendTaskSuccess` with the token.

### Scenario 4: Sync Salesforce Data to S3

**Question**: A company needs to regularly sync Salesforce contact data to S3 for analytics.

**Solution**: Use **Amazon AppFlow**. Create a flow with Salesforce as the source and S3 as the destination. Schedule the flow to run daily. AppFlow handles authentication, data transformation, and transfer.

### Scenario 5: Real-Time Clickstream Analytics

**Question**: An application needs to analyze clickstream data in real-time and detect anomalies.

**Solution**: Use **Kinesis Data Streams** to ingest clickstream data. Use **Kinesis Data Analytics (Managed Apache Flink)** for real-time SQL analytics. Send results to CloudWatch for dashboards and alerts.

### Scenario 6: Deliver Streaming Data to S3 and Redshift

**Question**: A streaming application needs to deliver data to both S3 (data lake) and Redshift (data warehouse).

**Solution**: Use **Kinesis Data Firehose** with S3 as the primary destination. Configure Firehose to also COPY data to Redshift (Firehose stages data in S3, then issues a Redshift COPY command). Optionally use Lambda for data transformation.

### Scenario 7: Process S3 Files at Scale

**Question**: Millions of files in S3 need to be processed (e.g., image resizing, data validation).

**Solution**: Use **Step Functions Distributed Map** state. Read file list from S3. Map state launches up to 10,000 concurrent child executions. Each execution processes one or more files using Lambda or ECS.

### Scenario 8: Real-Time Data with Multiple Consumers

**Question**: A data stream needs to be consumed by three different applications simultaneously: analytics, archival, and alerting.

**Solution**: Use **Kinesis Data Streams** with **enhanced fan-out**. Each consumer gets dedicated 2 MB/s throughput per shard. Analytics uses Kinesis Data Analytics, archival uses Kinesis Data Firehose to S3, and alerting uses a Lambda consumer.

### Scenario 9: Migrate from On-Premises Workflow Engine

**Question**: A company has a complex workflow engine on-premises coordinating tasks across multiple applications.

**Solution**: If the application uses standard messaging protocols (JMS, AMQP) → consider **Amazon MQ** for the messaging layer. For workflow orchestration, use **Step Functions** to replace the workflow engine. If already using SWF → continue with SWF or migrate to Step Functions.

### Scenario 10: Convert Streaming JSON to Parquet

**Question**: JSON data is streaming in and needs to be stored in S3 in Parquet format for efficient querying with Athena.

**Solution**: Use **Kinesis Data Firehose** with:
1. Source: Kinesis Data Streams (or direct put)
2. Data format conversion: JSON → Parquet (using Glue table for schema)
3. Destination: S3
4. Query with Athena for analytics

### Scenario 11: Parallel Data Enrichment

**Question**: An incoming record needs to be enriched with data from three different APIs simultaneously before being stored.

**Solution**: Use **Step Functions** with a **Parallel** state. Each branch calls a different API (via Lambda or API Gateway integration). Results from all branches are combined and used to create the enriched record.

### Scenario 12: Long-Running ETL Pipeline

**Question**: An ETL pipeline runs AWS Glue jobs, waits for completion, validates results, and loads into Redshift. The entire process takes several hours.

**Solution**: Use **Step Functions Standard workflow** (supports up to 1 year). Use `.sync` integration pattern for Glue jobs (Step Functions waits for completion). Use Choice state for validation logic. Use Retry for transient failures.

---

## Key Numbers to Remember

| Feature | Value |
|---------|-------|
| Step Functions Standard max duration | 1 year |
| Step Functions Express max duration | 5 minutes |
| Step Functions Standard max transitions | 25,000 |
| Step Functions Express start rate | 100,000/s |
| Step Functions Standard start rate | 2,000/s |
| Kinesis shard write capacity | 1 MB/s, 1,000 records/s |
| Kinesis shard read capacity (shared) | 2 MB/s |
| Kinesis shard read capacity (fan-out) | 2 MB/s per consumer |
| Kinesis max record size | 1 MB |
| Kinesis default retention | 24 hours |
| Kinesis max retention | 365 days |
| Kinesis max enhanced fan-out consumers | 20 |
| Firehose min buffer interval | 60 seconds |
| Distributed Map max concurrency | 10,000 |
| KCL checkpoint store | DynamoDB |

---

## Summary

- **Step Functions** = serverless workflow orchestration, Standard (1 year, exactly-once) vs Express (5 min, at-least-once)
- **States** = Task, Choice, Parallel, Map, Wait, Succeed, Fail, Pass
- **Error handling** = Retry (exponential backoff) + Catch (fallback states)
- **Service integrations** = 200+ AWS services, three patterns (request/response, .sync, .waitForTaskToken)
- **Saga pattern** = Distributed transactions with compensating actions
- **AppFlow** = No-code SaaS to AWS data integration (Salesforce, SAP, etc.)
- **SWF** = Legacy workflow service (use Step Functions for new projects)
- **Kinesis Data Streams** = Real-time streaming, shards, replay, multiple consumers
- **Kinesis Data Firehose** = Managed delivery to S3/Redshift/OpenSearch, near real-time
- **Kinesis Data Analytics** = Real-time SQL/Flink on streaming data
- **Kinesis Video Streams** = Video ingestion and processing
