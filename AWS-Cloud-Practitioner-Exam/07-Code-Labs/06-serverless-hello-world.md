# Lab 6 — Serverless Hello World (Lambda + API Gateway + DynamoDB)

We'll use AWS SAM (Serverless Application Model). Install:

```bash
brew install aws-sam-cli   # macOS
# or: pip install aws-sam-cli
```

## 1. Scaffolding

```
counter-app/
├── template.yaml
└── app.py
```

`template.yaml`:

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31
Description: Hit counter — Lambda + API Gateway + DynamoDB

Globals:
  Function:
    Runtime: python3.12
    Timeout: 5
    MemorySize: 128

Resources:
  Counters:
    Type: AWS::DynamoDB::Table
    Properties:
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: id
          AttributeType: S
      KeySchema:
        - AttributeName: id
          KeyType: HASH

  HitCounter:
    Type: AWS::Serverless::Function
    Properties:
      Handler: app.handler
      CodeUri: .
      Environment:
        Variables:
          TABLE: !Ref Counters
      Policies:
        - DynamoDBCrudPolicy: { TableName: !Ref Counters }
      Events:
        Api:
          Type: HttpApi
          Properties:
            Path: /hit/{name}
            Method: get

Outputs:
  Url:
    Value: !Sub "https://${ServerlessHttpApi}.execute-api.${AWS::Region}.amazonaws.com/hit/{name}"
```

`app.py`:

```python
import os, json, boto3
ddb = boto3.resource("dynamodb").Table(os.environ["TABLE"])

def handler(event, _ctx):
    name = event["pathParameters"]["name"]
    r = ddb.update_item(
        Key={"id": name},
        UpdateExpression="ADD hits :one",
        ExpressionAttributeValues={":one": 1},
        ReturnValues="UPDATED_NEW",
    )
    return {
        "statusCode": 200,
        "headers": {"content-type": "application/json"},
        "body": json.dumps({"name": name, "hits": int(r["Attributes"]["hits"])}),
    }
```

## 2. Deploy

```bash
sam build
sam deploy --guided
# Stack name: counter-app
# Region: us-east-1
# Confirm changes: y
# Allow SAM CLI IAM role creation: y
# Disable rollback: n
# HitCounter may not have authorization defined: y (HTTP API public)
# Save arguments to samconfig.toml: y
```

SAM prints an API URL; hit it:

```bash
curl https://xxxxxxx.execute-api.us-east-1.amazonaws.com/hit/alice
curl https://xxxxxxx.execute-api.us-east-1.amazonaws.com/hit/alice
# {"name":"alice","hits":2}
```

## 3. Observe

- **CloudWatch Logs** → log group `/aws/lambda/counter-app-HitCounter-…`
- **X-Ray** (if enabled) → request traces
- **DynamoDB** → Counters table items

## 4. Clean up

```bash
sam delete
```
