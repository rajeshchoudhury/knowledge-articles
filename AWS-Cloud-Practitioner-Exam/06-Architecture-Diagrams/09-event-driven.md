# Event-Driven Integration Patterns

## Pub/Sub with fan-out (SNS → SQS → Lambda)

```mermaid
graph LR
  Producer --> SNS["SNS Topic"]
  SNS --> Q1["SQS (order-email)"]
  SNS --> Q2["SQS (order-warehouse)"]
  SNS --> Lambda1["Lambda (audit)"]
  Q1 --> Lambda2["Lambda (send email)"]
  Q2 --> ECS["ECS task (pick-pack)"]
```

## Event Bus routing (EventBridge)

```mermaid
graph LR
  S3Event["S3 ObjectCreated"] --> Bus["EventBridge Bus"]
  Cognito["Cognito SignUp"] --> Bus
  GitHub["Partner: GitHub"] --> Bus
  Bus -->|"detail.type == 'order.created'"| Fn1["Lambda"]
  Bus -->|"detail.type == 'order.canceled'"| SFN["Step Functions"]
  Bus -->|"source == 'aws.s3'"| Q["SQS"]
```

## Orchestration (Step Functions)

```mermaid
graph TB
  Start([Start])
  Start --> Validate[[Validate]]
  Validate -->|ok| Process[[Process]]
  Validate -->|invalid| Fail([Fail])
  Process --> Parallel{Parallel}
  Parallel --> Charge[[Charge card]]
  Parallel --> Reserve[[Reserve stock]]
  Charge --> Notify[[Notify customer]]
  Reserve --> Notify
  Notify --> End([End])
```

## Stream processing (Kinesis + Lambda)

```mermaid
graph LR
  IoT[(IoT devices)] --> KDS["Kinesis Data Streams"]
  KDS --> Lambda["Lambda processors"]
  KDS --> Firehose["Kinesis Firehose"] --> S3[(S3 data lake)]
  S3 --> Athena["Athena SQL"]
```
