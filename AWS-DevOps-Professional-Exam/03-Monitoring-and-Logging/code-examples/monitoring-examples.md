# Domain 3: Monitoring and Logging — Code Examples

## Table of Contents
1. [CloudWatch Alarm Configurations (CloudFormation)](#1-cloudwatch-alarm-configurations-cloudformation)
2. [CloudWatch Logs Metric Filter Patterns](#2-cloudwatch-logs-metric-filter-patterns)
3. [CloudWatch Logs Insights Queries](#3-cloudwatch-logs-insights-queries)
4. [EventBridge Rules for Various Scenarios](#4-eventbridge-rules-for-various-scenarios)
5. [X-Ray SDK Instrumentation (Node.js)](#5-x-ray-sdk-instrumentation-nodejs)
6. [X-Ray SDK Instrumentation (Python)](#6-x-ray-sdk-instrumentation-python)
7. [CloudTrail Lake Queries](#7-cloudtrail-lake-queries)
8. [Custom CloudWatch Metrics Publishing Code](#8-custom-cloudwatch-metrics-publishing-code)
9. [Centralized Logging Architecture (CloudFormation)](#9-centralized-logging-architecture-cloudformation)
10. [CloudWatch Synthetics Canary](#10-cloudwatch-synthetics-canary)

---

## 1. CloudWatch Alarm Configurations (CloudFormation)

### 1.1 EC2 CPU Utilization Alarm with M-out-of-N

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: CloudWatch alarms for EC2, ALB, RDS, and composite alarm patterns.

Parameters:
  InstanceId:
    Type: AWS::EC2::Instance::Id
  AlertEmail:
    Type: String

Resources:
  AlarmSNSTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: monitoring-alerts
      Subscription:
        - Protocol: email
          Endpoint: !Ref AlertEmail

  # CPU alarm: triggers if 3 out of 5 evaluation periods breach 80%
  CPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: EC2-High-CPU
      AlarmDescription: >
        CPU utilization exceeded 80% for 3 out of 5 evaluation periods.
        Investigate instance load and consider scaling.
      Namespace: AWS/EC2
      MetricName: CPUUtilization
      Dimensions:
        - Name: InstanceId
          Value: !Ref InstanceId
      Statistic: Average
      Period: 300
      EvaluationPeriods: 5
      DatapointsToAlarm: 3
      Threshold: 80
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: notBreaching
      AlarmActions:
        - !Ref AlarmSNSTopic
      OKActions:
        - !Ref AlarmSNSTopic

  # Memory alarm using CloudWatch Agent custom metric
  MemoryAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: EC2-High-Memory
      AlarmDescription: Memory utilization exceeded 90%
      Namespace: CWAgent
      MetricName: mem_used_percent
      Dimensions:
        - Name: InstanceId
          Value: !Ref InstanceId
      Statistic: Average
      Period: 300
      EvaluationPeriods: 3
      DatapointsToAlarm: 3
      Threshold: 90
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: missing
      AlarmActions:
        - !Ref AlarmSNSTopic

  # Disk space alarm
  DiskSpaceAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: EC2-Low-Disk
      AlarmDescription: Disk usage exceeded 85%
      Namespace: CWAgent
      MetricName: disk_used_percent
      Dimensions:
        - Name: InstanceId
          Value: !Ref InstanceId
        - Name: path
          Value: /
        - Name: fstype
          Value: xfs
      Statistic: Average
      Period: 300
      EvaluationPeriods: 1
      Threshold: 85
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: missing
      AlarmActions:
        - !Ref AlarmSNSTopic
```

### 1.2 ALB and Application Alarms

```yaml
Resources:
  # ALB 5XX Error Rate Alarm
  ALB5XXAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: ALB-High-5XX-Rate
      AlarmDescription: ALB 5XX error rate exceeded 5% of total requests
      Metrics:
        - Id: e1
          Expression: (m1 / m2) * 100
          Label: Error Rate Percentage
        - Id: m1
          MetricStat:
            Metric:
              Namespace: AWS/ApplicationELB
              MetricName: HTTPCode_ELB_5XX_Count
              Dimensions:
                - Name: LoadBalancer
                  Value: !Ref ALBFullName
            Period: 60
            Stat: Sum
          ReturnData: false
        - Id: m2
          MetricStat:
            Metric:
              Namespace: AWS/ApplicationELB
              MetricName: RequestCount
              Dimensions:
                - Name: LoadBalancer
                  Value: !Ref ALBFullName
            Period: 60
            Stat: Sum
          ReturnData: false
      EvaluationPeriods: 3
      DatapointsToAlarm: 2
      Threshold: 5
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: notBreaching
      AlarmActions:
        - !Ref AlarmSNSTopic

  # ALB Target Response Time (P99 latency)
  LatencyAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: ALB-High-Latency-P99
      AlarmDescription: P99 response time exceeded 2 seconds
      Namespace: AWS/ApplicationELB
      MetricName: TargetResponseTime
      Dimensions:
        - Name: LoadBalancer
          Value: !Ref ALBFullName
      ExtendedStatistic: p99
      Period: 60
      EvaluationPeriods: 5
      DatapointsToAlarm: 3
      Threshold: 2.0
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: notBreaching
      AlarmActions:
        - !Ref AlarmSNSTopic

  # Unhealthy hosts alarm
  UnhealthyHostsAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: ALB-Unhealthy-Hosts
      AlarmDescription: One or more target group hosts are unhealthy
      Namespace: AWS/ApplicationELB
      MetricName: UnHealthyHostCount
      Dimensions:
        - Name: TargetGroup
          Value: !Ref TargetGroupFullName
        - Name: LoadBalancer
          Value: !Ref ALBFullName
      Statistic: Maximum
      Period: 60
      EvaluationPeriods: 2
      Threshold: 0
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: notBreaching
      AlarmActions:
        - !Ref AlarmSNSTopic
```

### 1.3 RDS Alarms

```yaml
Resources:
  # RDS CPU alarm
  RDSCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: RDS-High-CPU
      Namespace: AWS/RDS
      MetricName: CPUUtilization
      Dimensions:
        - Name: DBInstanceIdentifier
          Value: !Ref DBInstanceId
      Statistic: Average
      Period: 300
      EvaluationPeriods: 3
      Threshold: 80
      ComparisonOperator: GreaterThanThreshold
      TreatMissingData: missing
      AlarmActions:
        - !Ref AlarmSNSTopic

  # RDS Free Storage Space
  RDSStorageAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: RDS-Low-Storage
      AlarmDescription: Free storage below 10 GB
      Namespace: AWS/RDS
      MetricName: FreeStorageSpace
      Dimensions:
        - Name: DBInstanceIdentifier
          Value: !Ref DBInstanceId
      Statistic: Minimum
      Period: 300
      EvaluationPeriods: 1
      Threshold: 10737418240  # 10 GB in bytes
      ComparisonOperator: LessThanThreshold
      AlarmActions:
        - !Ref AlarmSNSTopic

  # RDS Database Connections
  RDSConnectionsAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: RDS-High-Connections
      Namespace: AWS/RDS
      MetricName: DatabaseConnections
      Dimensions:
        - Name: DBInstanceIdentifier
          Value: !Ref DBInstanceId
      Statistic: Maximum
      Period: 60
      EvaluationPeriods: 3
      Threshold: 100
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref AlarmSNSTopic
```

### 1.4 Composite Alarm

```yaml
Resources:
  # Only alert when ALL conditions are true
  CriticalCompositeAlarm:
    Type: AWS::CloudWatch::CompositeAlarm
    Properties:
      AlarmName: CRITICAL-Application-Degraded
      AlarmDescription: >
        Multiple systems are under stress simultaneously.
        CPU is high, error rate is elevated, and latency is above threshold.
      AlarmRule: >
        ALARM("EC2-High-CPU")
        AND ALARM("ALB-High-5XX-Rate")
        AND ALARM("ALB-High-Latency-P99")
      AlarmActions:
        - !Ref CriticalSNSTopic
      InsufficientDataActions: []
      OKActions:
        - !Ref CriticalSNSTopic

  # Alert on ANY critical infrastructure issue
  InfraCompositeAlarm:
    Type: AWS::CloudWatch::CompositeAlarm
    Properties:
      AlarmName: INFRA-Any-Critical-Issue
      AlarmDescription: At least one critical infrastructure alarm is firing
      AlarmRule: >
        ALARM("RDS-Low-Storage")
        OR ALARM("RDS-High-CPU")
        OR ALARM("ALB-Unhealthy-Hosts")
      AlarmActions:
        - !Ref InfraSNSTopic

  # Anomaly detection alarm
  AnomalyDetectionAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: API-Latency-Anomaly
      AlarmDescription: API latency is outside the expected band
      Metrics:
        - Id: m1
          MetricStat:
            Metric:
              Namespace: AWS/ApiGateway
              MetricName: Latency
              Dimensions:
                - Name: ApiName
                  Value: MyAPI
            Period: 300
            Stat: Average
        - Id: ad1
          Expression: ANOMALY_DETECTION_BAND(m1, 2)
      EvaluationPeriods: 3
      ThresholdMetricId: ad1
      ComparisonOperator: LessThanLowerOrGreaterThanUpperThreshold
      TreatMissingData: missing
      AlarmActions:
        - !Ref AlarmSNSTopic
```

### 1.5 EC2 Auto-Recovery Alarm

```yaml
Resources:
  # EC2 instance auto-recovery on system check failure
  EC2RecoveryAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: EC2-System-Check-Failed
      AlarmDescription: >
        Triggers EC2 instance recovery when the system status check fails.
        Recovery preserves instance ID, IP address, metadata, and placement.
      Namespace: AWS/EC2
      MetricName: StatusCheckFailed_System
      Dimensions:
        - Name: InstanceId
          Value: !Ref InstanceId
      Statistic: Maximum
      Period: 60
      EvaluationPeriods: 2
      Threshold: 0
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Sub 'arn:${AWS::Partition}:automate:${AWS::Region}:ec2:recover'
        - !Ref AlarmSNSTopic
```

---

## 2. CloudWatch Logs Metric Filter Patterns

### 2.1 JSON Log Patterns

```yaml
Resources:
  # Count 5XX errors from JSON-formatted application logs
  # Log format: {"timestamp":"2024-01-01T00:00:00Z","status":500,"path":"/api/users","duration":234}
  Error5XXFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/api-gateway
      FilterPattern: '{ $.status >= 500 }'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: 5XXErrorCount
          MetricValue: '1'
          DefaultValue: 0

  # Track slow requests (duration > 3000ms)
  SlowRequestFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/api-gateway
      FilterPattern: '{ $.duration > 3000 }'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: SlowRequestCount
          MetricValue: '1'
          DefaultValue: 0

  # Extract actual duration as metric value
  RequestDurationFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/api-gateway
      FilterPattern: '{ $.status = 200 }'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: RequestDuration
          MetricValue: '$.duration'
          DefaultValue: 0

  # Combined filter: 4XX errors on specific path
  Auth4XXFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/api-gateway
      FilterPattern: '{ $.status >= 400 && $.status < 500 && $.path = "/api/auth*" }'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: AuthErrorCount
          MetricValue: '1'
          DefaultValue: 0

  # Filter on nested JSON fields
  # Log: {"request":{"method":"POST","path":"/api/orders"},"response":{"status":500},"user":{"id":"u123"}}
  NestedJSONFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/api-gateway
      FilterPattern: '{ $.response.status = 500 && $.request.method = "POST" }'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: FailedPostRequests
          MetricValue: '1'
```

### 2.2 Space-Delimited Log Patterns (Apache/Nginx)

```yaml
Resources:
  # Apache Common Log Format:
  # 192.168.1.1 - frank [10/Oct/2024:13:55:36 +0000] "GET /api/users HTTP/1.1" 404 2326
  Apache4XXFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /var/log/httpd/access_log
      FilterPattern: '[ip, dash, user, timestamp, request, status_code = 4*, size]'
      MetricTransformations:
        - MetricNamespace: WebServer
          MetricName: 4XXErrorCount
          MetricValue: '1'

  Apache5XXFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /var/log/httpd/access_log
      FilterPattern: '[ip, dash, user, timestamp, request, status_code = 5*, size]'
      MetricTransformations:
        - MetricNamespace: WebServer
          MetricName: 5XXErrorCount
          MetricValue: '1'

  # Track request size
  LargeResponseFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /var/log/httpd/access_log
      FilterPattern: '[ip, dash, user, timestamp, request, status_code, size > 1000000]'
      MetricTransformations:
        - MetricNamespace: WebServer
          MetricName: LargeResponseCount
          MetricValue: '1'
```

### 2.3 Text Pattern Matching

```yaml
Resources:
  # Match any line containing "ERROR"
  ErrorFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/backend
      FilterPattern: 'ERROR'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: ErrorLogCount
          MetricValue: '1'
          DefaultValue: 0

  # Match lines containing "Exception" but NOT "NotFoundException"
  CriticalExceptionFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/backend
      FilterPattern: '?Exception -NotFoundException -ValidationException'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: CriticalExceptionCount
          MetricValue: '1'

  # Match exact phrase
  OutOfMemoryFilter:
    Type: AWS::Logs::MetricFilter
    Properties:
      LogGroupName: /app/backend
      FilterPattern: '"OutOfMemoryError"'
      MetricTransformations:
        - MetricNamespace: MyApp
          MetricName: OOMCount
          MetricValue: '1'
```

---

## 3. CloudWatch Logs Insights Queries

### 3.1 Application Log Analysis

```sql
-- Top 20 most frequent errors in the last 24 hours
fields @timestamp, @message
| filter @message like /ERROR/
| stats count(*) as errorCount by @message
| sort errorCount desc
| limit 20

-- Error rate per 5-minute interval
filter @message like /ERROR/
| stats count(*) as errors by bin(5m) as timeWindow
| sort timeWindow asc

-- Average and P99 response time by API endpoint (JSON logs)
fields endpoint, duration_ms
| stats avg(duration_ms) as avgLatency,
        pct(duration_ms, 99) as p99Latency,
        count(*) as requestCount
  by endpoint
| sort p99Latency desc
| limit 20

-- Find the slowest requests with full context
fields @timestamp, endpoint, duration_ms, status_code, user_id
| filter duration_ms > 5000
| sort duration_ms desc
| limit 50

-- Count errors by HTTP status code grouped by time
fields status_code
| filter status_code >= 400
| stats count(*) as cnt by status_code, bin(15m) as timeWindow
| sort timeWindow desc, cnt desc
```

### 3.2 Lambda Function Analysis

```sql
-- Lambda cold starts vs warm starts
filter @type = "REPORT"
| stats count(*) as invocations,
        sum(strcontains(@message, "Init Duration")) as coldStarts,
        avg(@duration) as avgDuration,
        max(@duration) as maxDuration,
        avg(@maxMemoryUsed / 1024 / 1024) as avgMemoryMB
  by bin(1h) as timeWindow

-- Lambda timeout detection
filter @message like /Task timed out/
| stats count(*) as timeouts by bin(5m)
| sort timeouts desc

-- Lambda errors with request context
filter @message like /ERROR/ or @message like /Exception/
| fields @timestamp, @requestId, @message
| sort @timestamp desc
| limit 100

-- Lambda memory utilization analysis
filter @type = "REPORT"
| parse @message "Memory Size: * MB" as memoryAllocated
| parse @message "Max Memory Used: * MB" as memoryUsed
| stats avg(memoryUsed / memoryAllocated * 100) as avgUtilization,
        max(memoryUsed / memoryAllocated * 100) as maxUtilization
  by bin(1h)

-- Lambda cost estimation
filter @type = "REPORT"
| stats sum(@billedDuration) as totalDurationMs,
        count(*) as invocations,
        avg(@billedDuration) as avgBilledMs
  by bin(1d)
```

### 3.3 VPC Flow Log Analysis

```sql
-- Top 20 rejected traffic sources
filter action = "REJECT"
| stats count(*) as rejectCount, sum(bytes) as totalBytes
  by srcAddr
| sort rejectCount desc
| limit 20

-- Traffic analysis by destination port (find port scanning)
filter action = "REJECT"
| stats count(*) as attempts by dstPort, srcAddr
| filter attempts > 100
| sort attempts desc

-- Data transfer analysis per instance
stats sum(bytes) as totalBytes, count(*) as flowCount
  by interfaceId
| sort totalBytes desc
| limit 20

-- SSH traffic monitoring
filter dstPort = 22 or srcPort = 22
| stats count(*) as sshFlows, sum(bytes) as sshBytes
  by srcAddr, dstAddr, action
| sort sshFlows desc

-- Cross-AZ traffic analysis (for cost optimization)
filter srcAddr like /10\.0\./
| stats sum(bytes) as transferBytes by srcAddr, dstAddr
| sort transferBytes desc
| limit 50
```

### 3.4 CloudTrail Log Analysis (via CloudWatch Logs)

```sql
-- Unauthorized API calls
filter errorCode = "AccessDenied" or errorCode = "UnauthorizedAccess"
| stats count(*) as deniedCount
  by userIdentity.arn, eventName, errorCode
| sort deniedCount desc

-- Root account activity
filter userIdentity.type = "Root"
| fields @timestamp, eventName, sourceIPAddress, userAgent
| sort @timestamp desc

-- Security group modifications
filter eventName in ["AuthorizeSecurityGroupIngress",
                      "AuthorizeSecurityGroupEgress",
                      "RevokeSecurityGroupIngress",
                      "RevokeSecurityGroupEgress",
                      "CreateSecurityGroup",
                      "DeleteSecurityGroup"]
| fields @timestamp, userIdentity.arn, eventName,
         requestParameters.groupId, sourceIPAddress
| sort @timestamp desc

-- Console login activity
filter eventName = "ConsoleLogin"
| fields @timestamp, userIdentity.arn,
         responseElements.ConsoleLogin, sourceIPAddress, userAgent
| sort @timestamp desc

-- Resource creation tracking
filter eventName like /^Create/ or eventName like /^Run/
| stats count(*) as creations by eventName, userIdentity.arn
| sort creations desc
| limit 30
```

---

## 4. EventBridge Rules for Various Scenarios

### 4.1 EC2 Instance State Changes

```yaml
Resources:
  EC2StateChangeRule:
    Type: AWS::Events::Rule
    Properties:
      Name: EC2-Instance-Terminated
      Description: Detect when EC2 instances are terminated
      EventBusName: default
      State: ENABLED
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - EC2 Instance State-change Notification
        detail:
          state:
            - terminated
      Targets:
        - Arn: !GetAtt CleanupFunction.Arn
          Id: CleanupTarget

  EC2StateChangeLambdaPermission:
    Type: AWS::Lambda::Permission
    Properties:
      FunctionName: !Ref CleanupFunction
      Action: lambda:InvokeFunction
      Principal: events.amazonaws.com
      SourceArn: !GetAtt EC2StateChangeRule.Arn
```

### 4.2 Security-Related Events (CloudTrail via EventBridge)

```yaml
Resources:
  # Detect public S3 bucket creation
  PublicS3BucketRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Detect-Public-S3-Bucket
      EventPattern:
        source:
          - aws.s3
        detail-type:
          - AWS API Call via CloudTrail
        detail:
          eventName:
            - PutBucketAcl
            - PutBucketPolicy
            - CreateBucket
      Targets:
        - Arn: !GetAtt S3RemediationFunction.Arn
          Id: RemediateTarget

  # Detect IAM policy changes
  IAMPolicyChangeRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Detect-IAM-Policy-Changes
      EventPattern:
        source:
          - aws.iam
        detail-type:
          - AWS API Call via CloudTrail
        detail:
          eventName:
            - CreatePolicy
            - CreatePolicyVersion
            - DeletePolicy
            - AttachRolePolicy
            - DetachRolePolicy
            - AttachUserPolicy
            - DetachUserPolicy
            - AttachGroupPolicy
            - DetachGroupPolicy
            - PutRolePolicy
            - PutUserPolicy
            - PutGroupPolicy
      Targets:
        - Arn: !Ref SecurityAlertTopic
          Id: SNSTarget

  # Detect security group changes allowing 0.0.0.0/0
  SecurityGroupOpenRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Detect-Open-SecurityGroup
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - AWS API Call via CloudTrail
        detail:
          eventName:
            - AuthorizeSecurityGroupIngress
      Targets:
        - Arn: !GetAtt SGRemediationFunction.Arn
          Id: RemediateTarget
```

### 4.3 Scheduled Rules

```yaml
Resources:
  # Daily compliance check
  DailyComplianceCheck:
    Type: AWS::Events::Rule
    Properties:
      Name: Daily-Compliance-Check
      Description: Run compliance check every day at 6 AM UTC
      ScheduleExpression: 'cron(0 6 * * ? *)'
      State: ENABLED
      Targets:
        - Arn: !GetAtt ComplianceCheckFunction.Arn
          Id: ComplianceTarget
          Input: '{"checkType": "full", "notify": true}'

  # Every-5-minutes health check
  HealthCheckRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Health-Check-5min
      ScheduleExpression: 'rate(5 minutes)'
      State: ENABLED
      Targets:
        - Arn: !GetAtt HealthCheckFunction.Arn
          Id: HealthTarget
```

### 4.4 Cross-Account Event Routing

```yaml
# In the SOURCE account:
Resources:
  CrossAccountRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Forward-Security-Events
      EventPattern:
        source:
          - aws.guardduty
        detail-type:
          - GuardDuty Finding
        detail:
          severity:
            - numeric: ['>=', 7]
      Targets:
        - Arn: !Sub 'arn:aws:events:${AWS::Region}:${CentralAccountId}:event-bus/security-events'
          Id: CentralSecurityBus
          RoleArn: !GetAtt CrossAccountRole.Arn

  CrossAccountRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: events.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: PutEventsPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action: events:PutEvents
                Resource: !Sub 'arn:aws:events:${AWS::Region}:${CentralAccountId}:event-bus/security-events'
```

### 4.5 CodePipeline and Deployment Events

```yaml
Resources:
  # Trigger on CodePipeline failure
  PipelineFailureRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Pipeline-Failure-Alert
      EventPattern:
        source:
          - aws.codepipeline
        detail-type:
          - CodePipeline Pipeline Execution State Change
        detail:
          state:
            - FAILED
          pipeline:
            - prefix: production-
      Targets:
        - Arn: !Ref PagerDutyTopic
          Id: PagerDutyTarget
          InputTransformer:
            InputPathsMap:
              pipeline: $.detail.pipeline
              state: $.detail.state
              time: $.time
            InputTemplate: >
              "Pipeline <pipeline> entered state <state> at <time>.
               Investigate immediately."

  # Trigger on CodeDeploy deployment failure
  DeploymentFailureRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Deployment-Failure-Alert
      EventPattern:
        source:
          - aws.codedeploy
        detail-type:
          - CodeDeploy Deployment State-change Notification
        detail:
          state:
            - FAILURE
      Targets:
        - Arn: !GetAtt RollbackFunction.Arn
          Id: RollbackTarget
```

### 4.6 Config Compliance Change Events

```yaml
Resources:
  ConfigComplianceRule:
    Type: AWS::Events::Rule
    Properties:
      Name: Config-NonCompliant-Alert
      EventPattern:
        source:
          - aws.config
        detail-type:
          - Config Rules Compliance Change
        detail:
          messageType:
            - ComplianceChangeNotification
          newEvaluationResult:
            complianceType:
              - NON_COMPLIANT
      Targets:
        - Arn: !GetAtt RemediationFunction.Arn
          Id: RemediateTarget
        - Arn: !Ref ComplianceAlertTopic
          Id: AlertTarget
```

---

## 5. X-Ray SDK Instrumentation (Node.js)

### 5.1 Express.js Application with Full Instrumentation

```javascript
const AWSXRay = require('aws-xray-sdk-core');
const xrayExpress = require('aws-xray-sdk-express');

// Capture all AWS SDK calls
const AWS = AWSXRay.captureAWS(require('aws-sdk'));

// Capture all HTTP/HTTPS outgoing calls
AWSXRay.captureHTTPsGlobal(require('http'));
AWSXRay.captureHTTPsGlobal(require('https'));
const https = require('https');

const express = require('express');
const app = express();

// X-Ray middleware: open segment for each request
app.use(xrayExpress.openSegment('OrderService'));

const dynamodb = new AWS.DynamoDB.DocumentClient();
const sns = new AWS.SNS();

app.post('/api/orders', async (req, res) => {
  const segment = AWSXRay.getSegment();
  const subsegment = segment.addNewSubsegment('ProcessOrder');

  try {
    const orderId = `ORD-${Date.now()}`;
    const userId = req.body.userId;

    // Add annotations (indexed, searchable in X-Ray console)
    subsegment.addAnnotation('orderId', orderId);
    subsegment.addAnnotation('userId', userId);
    subsegment.addAnnotation('orderType', req.body.type || 'standard');

    // Add metadata (not indexed, for supplementary data)
    subsegment.addMetadata('orderDetails', req.body);
    subsegment.addMetadata('requestHeaders', req.headers);

    // DynamoDB call (auto-captured by X-Ray SDK)
    const dbSubsegment = subsegment.addNewSubsegment('SaveOrder');
    await dynamodb.put({
      TableName: 'Orders',
      Item: {
        orderId,
        userId,
        status: 'CREATED',
        items: req.body.items,
        createdAt: new Date().toISOString(),
      },
    }).promise();
    dbSubsegment.close();

    // SNS notification (auto-captured)
    const notifySubsegment = subsegment.addNewSubsegment('NotifyOrderCreated');
    await sns.publish({
      TopicArn: process.env.ORDER_TOPIC_ARN,
      Message: JSON.stringify({ orderId, userId }),
      MessageAttributes: {
        orderType: { DataType: 'String', StringValue: req.body.type || 'standard' },
      },
    }).promise();
    notifySubsegment.close();

    // External HTTP call (auto-captured)
    const validateSubsegment = subsegment.addNewSubsegment('ValidateInventory');
    const inventoryResult = await checkInventory(req.body.items);
    validateSubsegment.addMetadata('inventoryResult', inventoryResult);
    validateSubsegment.close();

    subsegment.close();
    res.json({ orderId, status: 'CREATED' });
  } catch (error) {
    subsegment.addError(error);
    subsegment.close();
    res.status(500).json({ error: error.message });
  }
});

async function checkInventory(items) {
  return new Promise((resolve, reject) => {
    https.get(`${process.env.INVENTORY_URL}/check`, (resp) => {
      let data = '';
      resp.on('data', (chunk) => data += chunk);
      resp.on('end', () => resolve(JSON.parse(data)));
    }).on('error', reject);
  });
}

// X-Ray middleware: close segment
app.use(xrayExpress.closeSegment());

app.listen(3000);
```

### 5.2 Lambda Function with X-Ray (Node.js)

```javascript
const AWSXRay = require('aws-xray-sdk-core');
const AWS = AWSXRay.captureAWS(require('aws-sdk'));

const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  const segment = AWSXRay.getSegment();
  const subsegment = segment.addNewSubsegment('ProcessEvent');

  try {
    for (const record of event.Records) {
      const body = JSON.parse(record.body);

      subsegment.addAnnotation('orderId', body.orderId);
      subsegment.addAnnotation('processingStage', 'fulfillment');

      // Business logic subsegment
      const bizSubsegment = subsegment.addNewSubsegment('BusinessLogic');

      const result = await dynamodb.update({
        TableName: 'Orders',
        Key: { orderId: body.orderId },
        UpdateExpression: 'SET #s = :status, updatedAt = :ts',
        ExpressionAttributeNames: { '#s': 'status' },
        ExpressionAttributeValues: {
          ':status': 'PROCESSING',
          ':ts': new Date().toISOString(),
        },
      }).promise();

      bizSubsegment.addMetadata('updateResult', result);
      bizSubsegment.close();
    }

    subsegment.close();
    return { statusCode: 200 };
  } catch (error) {
    subsegment.addError(error);
    subsegment.close();
    throw error;
  }
};
```

---

## 6. X-Ray SDK Instrumentation (Python)

### 6.1 Flask Application with X-Ray

```python
from aws_xray_sdk.core import xray_recorder, patch_all
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
import boto3
import json
import time
from flask import Flask, request, jsonify

# Patch all supported libraries (boto3, requests, sqlite, etc.)
patch_all()

app = Flask(__name__)

# Configure X-Ray recorder
xray_recorder.configure(
    service='PaymentService',
    sampling=True,
    context_missing='LOG_ERROR',
    daemon_address='127.0.0.1:2000',
)

# Add X-Ray middleware
XRayMiddleware(app, xray_recorder)

dynamodb = boto3.resource('dynamodb')
sqs = boto3.client('sqs')


@app.route('/api/payments', methods=['POST'])
def process_payment():
    data = request.get_json()

    # Add annotations for searchable trace data
    segment = xray_recorder.current_segment()
    segment.put_annotation('customerId', data['customerId'])
    segment.put_annotation('paymentMethod', data['method'])
    segment.put_annotation('amount', data['amount'])

    # Add metadata for detailed (non-indexed) data
    segment.put_metadata('paymentRequest', data, 'PaymentDetails')

    try:
        # Custom subsegment for payment validation
        with xray_recorder.in_subsegment('ValidatePayment') as subsegment:
            validation_result = validate_payment(data)
            subsegment.put_metadata('validationResult', validation_result)
            if not validation_result['valid']:
                segment.put_annotation('paymentStatus', 'VALIDATION_FAILED')
                return jsonify({'error': 'Validation failed'}), 400

        # Custom subsegment for payment processing
        with xray_recorder.in_subsegment('ChargePayment') as subsegment:
            charge_result = charge_payment_provider(data)
            subsegment.put_annotation('chargeId', charge_result['chargeId'])
            subsegment.put_metadata('chargeDetails', charge_result)

        # Save to DynamoDB (auto-traced by patch_all)
        with xray_recorder.in_subsegment('SaveTransaction') as subsegment:
            table = dynamodb.Table('Transactions')
            table.put_item(Item={
                'transactionId': charge_result['chargeId'],
                'customerId': data['customerId'],
                'amount': str(data['amount']),
                'status': 'COMPLETED',
                'timestamp': str(time.time()),
            })

        # Send notification via SQS (auto-traced)
        with xray_recorder.in_subsegment('SendNotification'):
            sqs.send_message(
                QueueUrl=app.config['NOTIFICATION_QUEUE_URL'],
                MessageBody=json.dumps({
                    'type': 'PAYMENT_COMPLETED',
                    'transactionId': charge_result['chargeId'],
                    'customerId': data['customerId'],
                }),
            )

        segment.put_annotation('paymentStatus', 'SUCCESS')
        return jsonify({
            'transactionId': charge_result['chargeId'],
            'status': 'COMPLETED',
        })

    except Exception as e:
        segment.put_annotation('paymentStatus', 'FAILED')
        segment.put_annotation('errorType', type(e).__name__)
        raise


def validate_payment(data):
    """Validate payment data (auto-traced as subsegment)."""
    if data['amount'] <= 0:
        return {'valid': False, 'reason': 'Invalid amount'}
    if data['method'] not in ['credit_card', 'debit_card', 'bank_transfer']:
        return {'valid': False, 'reason': 'Unsupported payment method'}
    return {'valid': True}


@xray_recorder.capture('ChargePaymentProvider')
def charge_payment_provider(data):
    """Call external payment provider (custom subsegment via decorator)."""
    import requests
    response = requests.post(
        'https://api.payment-provider.com/charges',
        json={'amount': data['amount'], 'method': data['method']},
        timeout=10,
    )
    response.raise_for_status()
    return response.json()


if __name__ == '__main__':
    app.run(port=5000)
```

### 6.2 Lambda Function with X-Ray (Python)

```python
import json
import boto3
from aws_xray_sdk.core import xray_recorder, patch_all

patch_all()

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Events')


def handler(event, context):
    """Lambda handler with X-Ray instrumentation.

    Active tracing must be enabled in Lambda function configuration.
    """
    for record in event['Records']:
        body = json.loads(record['body'])

        # Add searchable annotations
        xray_recorder.current_subsegment().put_annotation('eventType', body.get('type', 'unknown'))
        xray_recorder.current_subsegment().put_annotation('sourceService', body.get('source', 'unknown'))

        with xray_recorder.in_subsegment('ProcessRecord') as subseg:
            subseg.put_metadata('record', body)

            result = process_event(body)

            subseg.put_annotation('processingResult', result['status'])

    return {'statusCode': 200, 'body': json.dumps({'processed': len(event['Records'])})}


@xray_recorder.capture('ProcessEvent')
def process_event(event_data):
    """Process a single event with X-Ray tracing."""
    table.put_item(Item={
        'eventId': event_data['eventId'],
        'type': event_data['type'],
        'data': json.dumps(event_data['data']),
        'processedAt': str(__import__('time').time()),
    })
    return {'status': 'SUCCESS', 'eventId': event_data['eventId']}
```

---

## 7. CloudTrail Lake Queries

```sql
-- Find all root user console logins in the last 30 days
SELECT
    eventTime,
    userIdentity.arn as userArn,
    sourceIPAddress,
    userAgent,
    responseElements
FROM $EDS_ID
WHERE
    eventName = 'ConsoleLogin'
    AND userIdentity.type = 'Root'
    AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC;

-- Find all failed API calls (AccessDenied) by user
SELECT
    userIdentity.arn as userArn,
    eventName,
    errorCode,
    errorMessage,
    COUNT(*) as failureCount
FROM $EDS_ID
WHERE
    errorCode IN ('AccessDenied', 'UnauthorizedAccess', 'Client.UnauthorizedAccess')
    AND eventTime > '2024-01-15 00:00:00'
GROUP BY userIdentity.arn, eventName, errorCode, errorMessage
ORDER BY failureCount DESC
LIMIT 50;

-- Track security group changes
SELECT
    eventTime,
    userIdentity.arn as changedBy,
    eventName,
    requestParameters,
    sourceIPAddress
FROM $EDS_ID
WHERE
    eventName IN (
        'AuthorizeSecurityGroupIngress',
        'AuthorizeSecurityGroupEgress',
        'RevokeSecurityGroupIngress',
        'RevokeSecurityGroupEgress',
        'CreateSecurityGroup',
        'DeleteSecurityGroup'
    )
    AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC;

-- Find all S3 data events for a specific bucket
SELECT
    eventTime,
    userIdentity.arn as userArn,
    eventName,
    requestParameters,
    sourceIPAddress,
    resources
FROM $EDS_ID
WHERE
    eventSource = 's3.amazonaws.com'
    AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC
LIMIT 100;

-- IAM role creation and modification audit
SELECT
    eventTime,
    userIdentity.arn as actor,
    eventName,
    requestParameters,
    responseElements
FROM $EDS_ID
WHERE
    eventSource = 'iam.amazonaws.com'
    AND eventName LIKE '%Role%'
    AND eventTime > '2024-01-01 00:00:00'
ORDER BY eventTime DESC;

-- API call volume analysis (for Insights correlation)
SELECT
    eventName,
    COUNT(*) as callCount,
    COUNT(DISTINCT userIdentity.arn) as uniqueCallers,
    COUNT(DISTINCT sourceIPAddress) as uniqueIPs
FROM $EDS_ID
WHERE
    eventTime BETWEEN '2024-01-15 00:00:00' AND '2024-01-15 23:59:59'
GROUP BY eventName
ORDER BY callCount DESC
LIMIT 30;
```

---

## 8. Custom CloudWatch Metrics Publishing Code

### 8.1 Python — PutMetricData API

```python
import boto3
import time
from datetime import datetime

cloudwatch = boto3.client('cloudwatch')


def publish_application_metrics(order_data: dict):
    """Publish custom application metrics to CloudWatch."""
    cloudwatch.put_metric_data(
        Namespace='MyApp/Orders',
        MetricData=[
            {
                'MetricName': 'OrderCount',
                'Value': 1,
                'Unit': 'Count',
                'Timestamp': datetime.utcnow(),
                'Dimensions': [
                    {'Name': 'Environment', 'Value': 'production'},
                    {'Name': 'OrderType', 'Value': order_data['type']},
                ],
            },
            {
                'MetricName': 'OrderValue',
                'Value': order_data['total_amount'],
                'Unit': 'None',
                'Timestamp': datetime.utcnow(),
                'Dimensions': [
                    {'Name': 'Environment', 'Value': 'production'},
                    {'Name': 'Currency', 'Value': order_data['currency']},
                ],
            },
            {
                'MetricName': 'ProcessingTime',
                'Value': order_data['processing_ms'],
                'Unit': 'Milliseconds',
                'Timestamp': datetime.utcnow(),
                'Dimensions': [
                    {'Name': 'Environment', 'Value': 'production'},
                ],
                'StorageResolution': 1,  # High-resolution (1 second)
            },
        ],
    )


def publish_batch_metrics(metrics_batch: list):
    """Publish pre-aggregated metrics using StatisticValues."""
    cloudwatch.put_metric_data(
        Namespace='MyApp/Batch',
        MetricData=[
            {
                'MetricName': 'BatchProcessingTime',
                'StatisticValues': {
                    'SampleCount': len(metrics_batch),
                    'Sum': sum(m['duration'] for m in metrics_batch),
                    'Minimum': min(m['duration'] for m in metrics_batch),
                    'Maximum': max(m['duration'] for m in metrics_batch),
                },
                'Unit': 'Milliseconds',
                'Timestamp': datetime.utcnow(),
                'Dimensions': [
                    {'Name': 'Environment', 'Value': 'production'},
                ],
            },
        ],
    )
```

### 8.2 CloudWatch Embedded Metric Format (EMF) — Lambda (Python)

```python
import json
import time
from aws_embedded_metrics import metric_scope
from aws_embedded_metrics.config import get_config


# Method 1: Using the aws-embedded-metrics library
@metric_scope
def handler(event, context, metrics):
    """Lambda handler using EMF library for zero-API-call metric publishing."""
    metrics.set_namespace('MyApp/Orders')
    metrics.set_dimensions({'Service': 'OrderProcessor', 'Environment': 'production'})

    start_time = time.time()

    for record in event['Records']:
        body = json.loads(record['body'])

        metrics.put_metric('OrderProcessed', 1, 'Count')
        metrics.put_metric('OrderValue', body.get('amount', 0), 'None')

    processing_time = (time.time() - start_time) * 1000
    metrics.put_metric('ProcessingTime', processing_time, 'Milliseconds')

    metrics.set_property('batchSize', len(event['Records']))
    metrics.set_property('functionVersion', context.function_version)

    return {'statusCode': 200}


# Method 2: Manual EMF format (no library needed)
def handler_manual_emf(event, context):
    """Lambda handler with manual EMF — metrics extracted from log output."""
    start_time = time.time()
    records_processed = 0

    for record in event['Records']:
        body = json.loads(record['body'])
        records_processed += 1

    processing_time = (time.time() - start_time) * 1000

    # Print EMF-formatted JSON to stdout — CloudWatch extracts metrics automatically
    emf_log = {
        '_aws': {
            'Timestamp': int(time.time() * 1000),
            'CloudWatchMetrics': [
                {
                    'Namespace': 'MyApp/Orders',
                    'Dimensions': [['Service', 'Environment']],
                    'Metrics': [
                        {'Name': 'RecordsProcessed', 'Unit': 'Count'},
                        {'Name': 'ProcessingTime', 'Unit': 'Milliseconds'},
                        {'Name': 'BatchSize', 'Unit': 'Count'},
                    ],
                }
            ],
        },
        'Service': 'OrderProcessor',
        'Environment': 'production',
        'RecordsProcessed': records_processed,
        'ProcessingTime': processing_time,
        'BatchSize': len(event['Records']),
        'functionName': context.function_name,
        'requestId': context.aws_request_id,
    }

    # This single print statement publishes 3 metrics to CloudWatch
    print(json.dumps(emf_log))

    return {'statusCode': 200}
```

### 8.3 Node.js — EMF with createMetricsLogger

```javascript
const { createMetricsLogger, Unit, StorageResolution } = require('aws-embedded-metrics');

exports.handler = async (event, context) => {
  const metrics = createMetricsLogger();

  metrics.setNamespace('MyApp/API');
  metrics.putDimensions({ Service: 'UserService', Environment: 'production' });

  const startTime = Date.now();

  try {
    const result = await processRequest(event);

    const duration = Date.now() - startTime;
    metrics.putMetric('RequestDuration', duration, Unit.Milliseconds, StorageResolution.High);
    metrics.putMetric('SuccessCount', 1, Unit.Count);
    metrics.putMetric('ResponseSize', JSON.stringify(result).length, Unit.Bytes);

    // Properties are included in logs but not as metrics
    metrics.setProperty('requestId', context.awsRequestId);
    metrics.setProperty('endpoint', event.path);

    await metrics.flush();

    return { statusCode: 200, body: JSON.stringify(result) };
  } catch (error) {
    const duration = Date.now() - startTime;
    metrics.putMetric('RequestDuration', duration, Unit.Milliseconds);
    metrics.putMetric('ErrorCount', 1, Unit.Count);
    metrics.setProperty('errorMessage', error.message);

    await metrics.flush();
    throw error;
  }
};
```

---

## 9. Centralized Logging Architecture (CloudFormation)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: >
  Centralized logging account infrastructure.
  Receives logs from multiple accounts via Kinesis Data Firehose and stores in S3.

Resources:
  # Central S3 bucket for all logs
  CentralLogBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub 'central-logs-${AWS::AccountId}'
      VersioningConfiguration:
        Status: Enabled
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: aws:kms
              KMSMasterKeyID: !Ref LogEncryptionKey
      LifecycleConfiguration:
        Rules:
          - Id: TransitionToIA
            Status: Enabled
            Transitions:
              - StorageClass: STANDARD_IA
                TransitionInDays: 30
              - StorageClass: GLACIER
                TransitionInDays: 90
            ExpirationInDays: 2555  # ~7 years
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

  CentralLogBucketPolicy:
    Type: AWS::S3::BucketPolicy
    Properties:
      Bucket: !Ref CentralLogBucket
      PolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Sid: AllowFirehoseDelivery
            Effect: Allow
            Principal:
              Service: firehose.amazonaws.com
            Action:
              - s3:PutObject
              - s3:PutObjectAcl
            Resource: !Sub '${CentralLogBucket.Arn}/*'
            Condition:
              StringEquals:
                s3:x-amz-acl: bucket-owner-full-control
          - Sid: AllowCloudTrailDelivery
            Effect: Allow
            Principal:
              Service: cloudtrail.amazonaws.com
            Action: s3:PutObject
            Resource: !Sub '${CentralLogBucket.Arn}/cloudtrail/*'
            Condition:
              StringEquals:
                s3:x-amz-acl: bucket-owner-full-control
          - Sid: AllowCloudTrailACLCheck
            Effect: Allow
            Principal:
              Service: cloudtrail.amazonaws.com
            Action: s3:GetBucketAcl
            Resource: !GetAtt CentralLogBucket.Arn

  LogEncryptionKey:
    Type: AWS::KMS::Key
    Properties:
      Description: KMS key for encrypting centralized logs
      KeyPolicy:
        Version: '2012-10-17'
        Statement:
          - Sid: RootAccess
            Effect: Allow
            Principal:
              AWS: !Sub 'arn:aws:iam::${AWS::AccountId}:root'
            Action: 'kms:*'
            Resource: '*'
          - Sid: AllowFirehose
            Effect: Allow
            Principal:
              Service: firehose.amazonaws.com
            Action:
              - kms:Decrypt
              - kms:GenerateDataKey
            Resource: '*'
          - Sid: AllowCloudTrail
            Effect: Allow
            Principal:
              Service: cloudtrail.amazonaws.com
            Action: kms:GenerateDataKey*
            Resource: '*'

  # Kinesis Data Firehose delivery stream for application logs
  ApplicationLogStream:
    Type: AWS::KinesisFirehose::DeliveryStream
    Properties:
      DeliveryStreamName: central-application-logs
      DeliveryStreamType: DirectPut
      ExtendedS3DestinationConfiguration:
        BucketARN: !GetAtt CentralLogBucket.Arn
        Prefix: 'application-logs/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/'
        ErrorOutputPrefix: 'errors/application-logs/!{firehose:error-output-type}/year=!{timestamp:yyyy}/'
        BufferingHints:
          IntervalInSeconds: 60
          SizeInMBs: 64
        CompressionFormat: GZIP
        EncryptionConfiguration:
          KMSEncryptionConfig:
            AWSKMSKeyARN: !GetAtt LogEncryptionKey.Arn
        RoleARN: !GetAtt FirehoseRole.Arn
        CloudWatchLoggingOptions:
          Enabled: true
          LogGroupName: !Ref FirehoseLogGroup
          LogStreamName: S3Delivery

  FirehoseLogGroup:
    Type: AWS::Logs::LogGroup
    Properties:
      LogGroupName: /firehose/central-logs
      RetentionInDays: 14

  FirehoseRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: firehose.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: FirehoseDelivery
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:PutObject
                  - s3:PutObjectAcl
                  - s3:GetBucketLocation
                  - s3:ListBucket
                Resource:
                  - !GetAtt CentralLogBucket.Arn
                  - !Sub '${CentralLogBucket.Arn}/*'
              - Effect: Allow
                Action:
                  - kms:Decrypt
                  - kms:GenerateDataKey
                Resource: !GetAtt LogEncryptionKey.Arn
              - Effect: Allow
                Action:
                  - logs:PutLogEvents
                  - logs:CreateLogStream
                Resource: !GetAtt FirehoseLogGroup.Arn

  # Athena workgroup for querying logs
  LogAnalyticsWorkgroup:
    Type: AWS::Athena::WorkGroup
    Properties:
      Name: log-analytics
      WorkGroupConfiguration:
        ResultConfiguration:
          OutputLocation: !Sub 's3://${CentralLogBucket}/athena-results/'
          EncryptionConfiguration:
            EncryptionOption: SSE_KMS
            KmsKey: !GetAtt LogEncryptionKey.Arn
        EnforceWorkGroupConfiguration: true
        PublishCloudWatchMetricsEnabled: true
        BytesScannedCutoffPerQuery: 10737418240  # 10 GB query scan limit

  # CloudWatch cross-account sharing role
  CrossAccountMonitoringRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: CrossAccountCloudWatchRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              AWS: '*'
            Action: sts:AssumeRole
            Condition:
              StringEquals:
                'aws:PrincipalOrgID': !Ref OrganizationId
      Policies:
        - PolicyName: CloudWatchReadAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - cloudwatch:GetMetricData
                  - cloudwatch:ListMetrics
                  - cloudwatch:GetMetricStatistics
                  - logs:GetLogEvents
                  - logs:DescribeLogGroups
                  - logs:DescribeLogStreams
                  - logs:StartQuery
                  - logs:GetQueryResults
                Resource: '*'

Outputs:
  CentralLogBucketName:
    Value: !Ref CentralLogBucket
    Export:
      Name: CentralLogBucket
  FirehoseStreamARN:
    Value: !GetAtt ApplicationLogStream.Arn
    Export:
      Name: CentralFirehoseARN
```

---

## 10. CloudWatch Synthetics Canary

### CloudFormation Canary Definition

```yaml
Resources:
  CanaryRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
      Policies:
        - PolicyName: CanaryPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:PutObject
                  - s3:GetObject
                Resource: !Sub '${CanaryBucket.Arn}/*'
              - Effect: Allow
                Action:
                  - s3:GetBucketLocation
                  - s3:ListBucket
                Resource: !GetAtt CanaryBucket.Arn
              - Effect: Allow
                Action:
                  - cloudwatch:PutMetricData
                Resource: '*'
                Condition:
                  StringEquals:
                    cloudwatch:namespace: CloudWatchSynthetics

  CanaryBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub 'synthetics-canary-${AWS::AccountId}'
      LifecycleConfiguration:
        Rules:
          - Id: DeleteOldResults
            Status: Enabled
            ExpirationInDays: 30

  APIHealthCanary:
    Type: AWS::Synthetics::Canary
    Properties:
      Name: api-health-check
      RuntimeVersion: syn-nodejs-puppeteer-6.2
      ArtifactS3Location: !Sub 's3://${CanaryBucket}/canary-artifacts'
      ExecutionRoleArn: !GetAtt CanaryRole.Arn
      Schedule:
        Expression: 'rate(5 minutes)'
        DurationInSeconds: 0  # Run indefinitely
      RunConfig:
        TimeoutInSeconds: 60
        MemoryInMB: 960
        ActiveTracing: true  # Enable X-Ray integration
      StartCanaryAfterCreation: true
      Code:
        Handler: apiCanary.handler
        Script: |
          const synthetics = require('Synthetics');
          const log = require('SyntheticsLogger');

          const apiCanaryBlueprint = async function () {
            const API_URL = process.env.API_URL || 'https://api.example.com';

            // Test 1: Health endpoint
            const healthResponse = await synthetics.executeHttpStep(
              'Health Check',
              `${API_URL}/health`,
              {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' },
              }
            );

            if (healthResponse.statusCode !== 200) {
              throw new Error(`Health check failed with status ${healthResponse.statusCode}`);
            }

            const healthBody = JSON.parse(healthResponse.body);
            if (healthBody.status !== 'healthy') {
              throw new Error(`Service reports unhealthy: ${JSON.stringify(healthBody)}`);
            }
            log.info('Health check passed');

            // Test 2: API response time
            const startTime = Date.now();
            const apiResponse = await synthetics.executeHttpStep(
              'API Response Time',
              `${API_URL}/api/v1/status`,
              {
                method: 'GET',
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': `Bearer ${process.env.API_TOKEN}`,
                },
              }
            );
            const responseTime = Date.now() - startTime;

            if (responseTime > 500) {
              log.warn(`Response time ${responseTime}ms exceeds 500ms threshold`);
            }

            if (apiResponse.statusCode !== 200) {
              throw new Error(`API returned ${apiResponse.statusCode}`);
            }
            log.info(`API response time: ${responseTime}ms`);

            // Test 3: POST endpoint
            const createResponse = await synthetics.executeHttpStep(
              'Create Test Record',
              `${API_URL}/api/v1/test-records`,
              {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                  name: `canary-test-${Date.now()}`,
                  type: 'synthetic',
                }),
              }
            );

            if (createResponse.statusCode !== 201) {
              throw new Error(`Create failed: ${createResponse.statusCode}`);
            }
            log.info('POST endpoint test passed');
          };

          exports.handler = async () => {
            return await apiCanaryBlueprint();
          };
      Tags:
        - Key: Environment
          Value: production

  # Alarm on canary failure
  CanaryAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: API-Canary-Failed
      AlarmDescription: API health canary is failing
      Namespace: CloudWatchSynthetics
      MetricName: SuccessPercent
      Dimensions:
        - Name: CanaryName
          Value: !Ref APIHealthCanary
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      DatapointsToAlarm: 2
      Threshold: 100
      ComparisonOperator: LessThanThreshold
      TreatMissingData: breaching
      AlarmActions:
        - !Ref AlertTopic

  AlertTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: canary-alerts
```
