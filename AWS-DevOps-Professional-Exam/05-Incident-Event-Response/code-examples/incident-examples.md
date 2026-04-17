# Domain 5: Incident and Event Response — Code Examples

## Table of Contents
1. [EventBridge Rules (Various Patterns)](#eventbridge-rules-various-patterns)
2. [Lambda Functions for Automated Remediation (Python)](#lambda-functions-for-automated-remediation-python)
3. [Step Functions State Machine Definitions](#step-functions-state-machine-definitions)
4. [Auto Scaling Configurations (CloudFormation)](#auto-scaling-configurations-cloudformation)
5. [SQS-Based Scaling Patterns](#sqs-based-scaling-patterns)
6. [GuardDuty Automated Response](#guardduty-automated-response)
7. [SNS with Filtering Policies](#sns-with-filtering-policies)

---

## EventBridge Rules (Various Patterns)

### 1. EC2 Instance State Change Detection

```json
{
  "Source": ["aws.ec2"],
  "DetailType": ["EC2 Instance State-change Notification"],
  "Detail": {
    "state": ["stopped", "terminated"],
    "instance-id": [{"prefix": "i-"}]
  }
}
```

**CloudFormation:**
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  EC2StateChangeRule:
    Type: AWS::Events::Rule
    Properties:
      Name: ec2-state-change-detection
      Description: Detect EC2 instance stop/terminate events
      State: ENABLED
      EventPattern:
        source:
          - aws.ec2
        detail-type:
          - "EC2 Instance State-change Notification"
        detail:
          state:
            - stopped
            - terminated
      Targets:
        - Arn: !GetAtt RemediationFunction.Arn
          Id: RemediationTarget
          InputTransformer:
            InputPathsMap:
              instance: "$.detail.instance-id"
              state: "$.detail.state"
              account: "$.account"
              region: "$.region"
            InputTemplate: |
              "Instance <instance> changed to state <state> in account <account> region <region>"
```

### 2. Security Group Change Detection (via CloudTrail)

```json
{
  "source": ["aws.ec2"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com"],
    "eventName": [
      "AuthorizeSecurityGroupIngress",
      "AuthorizeSecurityGroupEgress",
      "RevokeSecurityGroupIngress",
      "RevokeSecurityGroupEgress",
      "CreateSecurityGroup",
      "DeleteSecurityGroup"
    ]
  }
}
```

### 3. Console Sign-In Without MFA

```json
{
  "source": ["aws.signin"],
  "detail-type": ["AWS Console Sign In via CloudTrail"],
  "detail": {
    "eventName": ["ConsoleLogin"],
    "additionalEventData": {
      "MFAUsed": ["No"]
    },
    "responseElements": {
      "ConsoleLogin": ["Success"]
    }
  }
}
```

### 4. S3 Bucket Policy Changes

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": [
      "PutBucketPolicy",
      "PutBucketAcl",
      "PutBucketPublicAccessBlock",
      "DeleteBucketPolicy",
      "DeleteBucketPublicAccessBlock"
    ]
  }
}
```

### 5. IAM Policy Changes (Excluding Automation Role)

```json
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": [
      {"prefix": "Create"},
      {"prefix": "Delete"},
      {"prefix": "Attach"},
      {"prefix": "Detach"},
      {"prefix": "Put"}
    ],
    "userIdentity": {
      "arn": [{
        "anything-but": "arn:aws:iam::123456789012:role/SecurityAutomationRole"
      }]
    }
  }
}
```

### 6. Config Compliance Change

```json
{
  "source": ["aws.config"],
  "detail-type": ["Config Rules Compliance Change"],
  "detail": {
    "messageType": ["ComplianceChangeNotification"],
    "newEvaluationResult": {
      "complianceType": ["NON_COMPLIANT"]
    },
    "configRuleName": [{"prefix": "security-"}]
  }
}
```

### 7. GuardDuty High Severity Finding

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{"numeric": [">=", 7]}],
    "type": [
      {"prefix": "UnauthorizedAccess:"},
      {"prefix": "CryptoCurrency:"},
      {"prefix": "Backdoor:"}
    ]
  }
}
```

### 8. AWS Health Scheduled Maintenance

```json
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"],
  "detail": {
    "service": ["EC2", "RDS"],
    "eventTypeCategory": ["scheduledChange"],
    "eventTypeCode": [{"prefix": "AWS_EC2_"}, {"prefix": "AWS_RDS_"}]
  }
}
```

### 9. CodePipeline Execution Failure

```json
{
  "source": ["aws.codepipeline"],
  "detail-type": ["CodePipeline Pipeline Execution State Change"],
  "detail": {
    "state": ["FAILED"],
    "pipeline": [{"prefix": "prod-"}]
  }
}
```

### 10. Scheduled Rule (EventBridge Scheduler)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  DailyCleanupSchedule:
    Type: AWS::Scheduler::Schedule
    Properties:
      Name: daily-resource-cleanup
      ScheduleExpression: "cron(0 2 * * ? *)"
      ScheduleExpressionTimezone: "America/New_York"
      FlexibleTimeWindow:
        Mode: "FLEXIBLE"
        MaximumWindowInMinutes: 15
      Target:
        Arn: !GetAtt CleanupFunction.Arn
        RoleArn: !GetAtt SchedulerRole.Arn
        RetryPolicy:
          MaximumRetryAttempts: 3
          MaximumEventAgeInSeconds: 3600
        DeadLetterConfig:
          Arn: !GetAtt SchedulerDLQ.Arn
```

---

## Lambda Functions for Automated Remediation (Python)

### 1. Remediate Public Security Group (Revoke 0.0.0.0/0 SSH)

```python
import json
import boto3

ec2 = boto3.client('ec2')
sns = boto3.client('sns')
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:security-alerts'

def lambda_handler(event, context):
    detail = event.get('detail', {})
    request_params = detail.get('requestParameters', {})
    group_id = request_params.get('groupId', '')

    if not group_id:
        return {'statusCode': 400, 'body': 'No security group ID found'}

    sg = ec2.describe_security_groups(GroupIds=[group_id])['SecurityGroups'][0]

    revoked_rules = []
    for permission in sg.get('IpPermissions', []):
        for ip_range in permission.get('IpRanges', []):
            if ip_range.get('CidrIp') == '0.0.0.0/0' and permission.get('FromPort') == 22:
                ec2.revoke_security_group_ingress(
                    GroupId=group_id,
                    IpPermissions=[{
                        'IpProtocol': permission['IpProtocol'],
                        'FromPort': permission['FromPort'],
                        'ToPort': permission['ToPort'],
                        'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
                    }]
                )
                revoked_rules.append(f"Port {permission['FromPort']} from 0.0.0.0/0")

    if revoked_rules:
        message = (
            f"Security Group {group_id} remediated.\n"
            f"Revoked rules: {', '.join(revoked_rules)}\n"
            f"Account: {event.get('account')}\n"
            f"Region: {event.get('region')}\n"
            f"User: {detail.get('userIdentity', {}).get('arn', 'unknown')}"
        )
        sns.publish(TopicArn=SNS_TOPIC_ARN, Subject='Security Group Remediated', Message=message)

    return {'statusCode': 200, 'body': f'Remediated {len(revoked_rules)} rules'}
```

### 2. Auto-Quarantine Compromised EC2 Instance

```python
import json
import boto3
from datetime import datetime

ec2 = boto3.client('ec2')
sns = boto3.client('sns')
dynamodb = boto3.resource('dynamodb')
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:security-incidents'
QUARANTINE_SG = 'sg-quarantine123456'
AUDIT_TABLE = 'incident-audit-log'

def lambda_handler(event, context):
    finding = event['detail']
    severity = finding['severity']
    finding_type = finding['type']

    resource = finding['resource']
    instance_details = resource.get('instanceDetails', {})
    instance_id = instance_details.get('instanceId')

    if not instance_id:
        return {'statusCode': 400, 'body': 'No instance ID in finding'}

    # Step 1: Tag the instance for forensics
    ec2.create_tags(
        Resources=[instance_id],
        Tags=[
            {'Key': 'SecurityIncident', 'Value': 'true'},
            {'Key': 'QuarantinedAt', 'Value': datetime.utcnow().isoformat()},
            {'Key': 'FindingType', 'Value': finding_type},
            {'Key': 'Severity', 'Value': str(severity)}
        ]
    )

    # Step 2: Get current security groups (for recovery)
    instance = ec2.describe_instances(InstanceIds=[instance_id])
    current_sgs = [
        sg['GroupId']
        for sg in instance['Reservations'][0]['Instances'][0]['SecurityGroups']
    ]

    # Step 3: Replace security groups with quarantine SG
    ec2.modify_instance_attribute(
        InstanceId=instance_id,
        Groups=[QUARANTINE_SG]
    )

    # Step 4: Create EBS snapshots for forensics
    volumes = ec2.describe_volumes(
        Filters=[{'Name': 'attachment.instance-id', 'Values': [instance_id]}]
    )
    snapshot_ids = []
    for volume in volumes['Volumes']:
        snapshot = ec2.create_snapshot(
            VolumeId=volume['VolumeId'],
            Description=f'Forensics snapshot for incident on {instance_id}',
            TagSpecifications=[{
                'ResourceType': 'snapshot',
                'Tags': [
                    {'Key': 'ForensicsInstance', 'Value': instance_id},
                    {'Key': 'FindingType', 'Value': finding_type}
                ]
            }]
        )
        snapshot_ids.append(snapshot['SnapshotId'])

    # Step 5: Log to DynamoDB audit table
    table = dynamodb.Table(AUDIT_TABLE)
    table.put_item(Item={
        'incidentId': finding.get('id', context.aws_request_id),
        'timestamp': datetime.utcnow().isoformat(),
        'instanceId': instance_id,
        'findingType': finding_type,
        'severity': int(severity),
        'previousSecurityGroups': current_sgs,
        'quarantineSecurityGroup': QUARANTINE_SG,
        'snapshotIds': snapshot_ids,
        'status': 'quarantined'
    })

    # Step 6: Notify security team
    message = json.dumps({
        'incident': 'EC2 Instance Quarantined',
        'instanceId': instance_id,
        'findingType': finding_type,
        'severity': severity,
        'previousSGs': current_sgs,
        'forensicsSnapshots': snapshot_ids,
        'action': 'Instance isolated. Review and respond.'
    }, indent=2)

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=f'[{severity}] EC2 Quarantined: {instance_id}',
        Message=message
    )

    return {
        'statusCode': 200,
        'body': {
            'instanceId': instance_id,
            'quarantined': True,
            'snapshots': snapshot_ids
        }
    }
```

### 3. Disable Exposed IAM Access Key

```python
import json
import boto3
from datetime import datetime

iam = boto3.client('iam')
sns = boto3.client('sns')
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:security-alerts'

def lambda_handler(event, context):
    detail = event.get('detail', {})
    check_result = detail.get('check-item-detail', {})

    access_key_id = check_result.get('Access Key ID', '')
    username = check_result.get('User Name (IAM or Root)', '')

    if not access_key_id or not username:
        return {'statusCode': 400, 'body': 'Missing key or username'}

    actions_taken = []

    # Step 1: Disable the exposed access key
    try:
        iam.update_access_key(
            UserName=username,
            AccessKeyId=access_key_id,
            Status='Inactive'
        )
        actions_taken.append(f'Disabled access key {access_key_id}')
    except Exception as e:
        actions_taken.append(f'Failed to disable key: {str(e)}')

    # Step 2: Attach an explicit deny-all policy to the user
    deny_policy = {
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "DateLessThan": {
                    "aws:TokenIssueTime": datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
                }
            }
        }]
    }

    try:
        iam.put_user_policy(
            UserName=username,
            PolicyName='ExposedKey-DenyAll-' + access_key_id[-8:],
            PolicyDocument=json.dumps(deny_policy)
        )
        actions_taken.append('Attached deny-all policy for sessions before now')
    except Exception as e:
        actions_taken.append(f'Failed to attach deny policy: {str(e)}')

    # Step 3: Notify
    message = json.dumps({
        'incident': 'IAM Access Key Exposed',
        'username': username,
        'accessKeyId': access_key_id,
        'actionsTaken': actions_taken,
        'nextSteps': [
            'Investigate CloudTrail for unauthorized usage',
            'Rotate all credentials for the user',
            'Review and remove the deny-all policy after investigation',
            'Create a new access key if needed'
        ]
    }, indent=2)

    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=f'CRITICAL: Exposed Access Key for {username}',
        Message=message
    )

    return {'statusCode': 200, 'body': {'actions': actions_taken}}
```

### 4. Auto-Enable S3 Bucket Encryption

```python
import json
import boto3

s3 = boto3.client('s3')
sns = boto3.client('sns')
SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:compliance-notifications'

def lambda_handler(event, context):
    """Triggered by Config compliance change for s3-bucket-server-side-encryption-enabled."""
    config_item = event.get('detail', {}).get('configurationItem', {})
    bucket_name = event.get('detail', {}).get('resourceId', '')

    if not bucket_name:
        invoking_event = json.loads(event.get('invokingEvent', '{}'))
        config_item = invoking_event.get('configurationItem', {})
        bucket_name = config_item.get('resourceName', '')

    if not bucket_name:
        return {'statusCode': 400, 'body': 'No bucket name found'}

    try:
        s3.put_bucket_encryption(
            Bucket=bucket_name,
            ServerSideEncryptionConfiguration={
                'Rules': [{
                    'ApplyServerSideEncryptionByDefault': {
                        'SSEAlgorithm': 'aws:kms'
                    },
                    'BucketKeyEnabled': True
                }]
            }
        )

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f'S3 Encryption Enabled: {bucket_name}',
            Message=f'KMS encryption with bucket key enabled on {bucket_name}.'
        )

        return {'statusCode': 200, 'body': f'Encryption enabled on {bucket_name}'}

    except Exception as e:
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f'FAILED: S3 Encryption on {bucket_name}',
            Message=f'Error: {str(e)}'
        )
        raise
```

### 5. Lambda with Partial Batch Failure Reporting (SQS)

```python
import json

def lambda_handler(event, context):
    batch_item_failures = []

    for record in event['Records']:
        try:
            body = json.loads(record['body'])
            process_message(body)
        except Exception as e:
            print(f"Failed to process message {record['messageId']}: {str(e)}")
            batch_item_failures.append({
                'itemIdentifier': record['messageId']
            })

    return {
        'batchItemFailures': batch_item_failures
    }

def process_message(body):
    order_id = body.get('orderId')
    if not order_id:
        raise ValueError('Missing orderId')
    print(f"Processing order: {order_id}")
```

---

## Step Functions State Machine Definitions

### 1. Incident Response Workflow

```json
{
  "Comment": "Automated Incident Response for Compromised EC2 Instance",
  "StartAt": "EvaluateSeverity",
  "States": {
    "EvaluateSeverity": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.detail.severity",
          "NumericGreaterThanEquals": 7,
          "Next": "HighSeverityResponse"
        },
        {
          "Variable": "$.detail.severity",
          "NumericGreaterThanEquals": 4,
          "Next": "MediumSeverityResponse"
        }
      ],
      "Default": "LowSeverityNotification"
    },

    "HighSeverityResponse": {
      "Type": "Parallel",
      "Branches": [
        {
          "StartAt": "IsolateInstance",
          "States": {
            "IsolateInstance": {
              "Type": "Task",
              "Resource": "arn:aws:lambda:us-east-1:123456789012:function:isolate-instance",
              "Retry": [
                {
                  "ErrorEquals": ["States.TaskFailed"],
                  "IntervalSeconds": 5,
                  "MaxAttempts": 3,
                  "BackoffRate": 2.0
                }
              ],
              "End": true
            }
          }
        },
        {
          "StartAt": "CreateForensicSnapshots",
          "States": {
            "CreateForensicSnapshots": {
              "Type": "Task",
              "Resource": "arn:aws:lambda:us-east-1:123456789012:function:create-snapshots",
              "End": true
            }
          }
        },
        {
          "StartAt": "NotifySOC",
          "States": {
            "NotifySOC": {
              "Type": "Task",
              "Resource": "arn:aws:states:::sns:publish",
              "Parameters": {
                "TopicArn": "arn:aws:sns:us-east-1:123456789012:soc-alerts",
                "Subject": "HIGH Severity Incident - Immediate Action Required",
                "Message.$": "States.Format('Instance {} compromised. Finding: {}', $.detail.resource.instanceDetails.instanceId, $.detail.type)"
              },
              "End": true
            }
          }
        }
      ],
      "Next": "WaitForApproval",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "EscalateFailure",
          "ResultPath": "$.error"
        }
      ]
    },

    "WaitForApproval": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
      "Parameters": {
        "QueueUrl": "https://sqs.us-east-1.amazonaws.com/123456789012/approval-queue",
        "MessageBody": {
          "taskToken.$": "$$.Task.Token",
          "incident.$": "$.detail",
          "message": "Approve instance termination or restore?"
        }
      },
      "HeartbeatSeconds": 86400,
      "Next": "ProcessApproval",
      "Catch": [
        {
          "ErrorEquals": ["States.HeartbeatTimeout"],
          "Next": "ApprovalTimeout"
        }
      ]
    },

    "ProcessApproval": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.decision",
          "StringEquals": "terminate",
          "Next": "TerminateInstance"
        },
        {
          "Variable": "$.decision",
          "StringEquals": "restore",
          "Next": "RestoreInstance"
        }
      ],
      "Default": "EscalateFailure"
    },

    "TerminateInstance": {
      "Type": "Task",
      "Resource": "arn:aws:states:::ec2:terminateInstances",
      "Parameters": {
        "InstanceIds.$": "States.Array($.detail.resource.instanceDetails.instanceId)"
      },
      "Next": "CloseIncident"
    },

    "RestoreInstance": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:restore-instance",
      "Next": "CloseIncident"
    },

    "MediumSeverityResponse": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:security-alerts",
        "Subject": "Medium Severity Security Finding",
        "Message.$": "States.JsonToString($.detail)"
      },
      "Next": "CloseIncident"
    },

    "LowSeverityNotification": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:security-info",
        "Subject": "Low Severity Security Finding",
        "Message.$": "States.JsonToString($.detail)"
      },
      "Next": "CloseIncident"
    },

    "ApprovalTimeout": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:soc-alerts",
        "Subject": "ESCALATION: Approval Timeout for Security Incident",
        "Message": "No approval received within 24 hours. Instance remains quarantined. Manual action required."
      },
      "Next": "CloseIncident"
    },

    "EscalateFailure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:soc-escalation",
        "Subject": "CRITICAL: Incident Response Automation Failed",
        "Message.$": "States.JsonToString($.error)"
      },
      "Next": "IncidentFailed"
    },

    "CloseIncident": {
      "Type": "Task",
      "Resource": "arn:aws:states:::dynamodb:putItem",
      "Parameters": {
        "TableName": "incident-log",
        "Item": {
          "incidentId": {"S.$": "$.detail.id"},
          "status": {"S": "closed"},
          "closedAt": {"S.$": "$$.State.EnteredTime"}
        }
      },
      "Next": "IncidentResolved"
    },

    "IncidentResolved": {
      "Type": "Succeed"
    },

    "IncidentFailed": {
      "Type": "Fail",
      "Error": "IncidentResponseFailed",
      "Cause": "Automated incident response failed. Manual intervention required."
    }
  }
}
```

### 2. Approval Workflow with Timeout

```json
{
  "Comment": "Change approval workflow with SNS notification and timeout",
  "StartAt": "RequestApproval",
  "States": {
    "RequestApproval": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish.waitForTaskToken",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:approvals",
        "Subject": "Approval Required: Infrastructure Change",
        "Message.$": "States.Format('Please approve or reject this change. Task Token: {}', $$.Task.Token)"
      },
      "HeartbeatSeconds": 3600,
      "Next": "ExecuteChange",
      "Catch": [
        {
          "ErrorEquals": ["States.HeartbeatTimeout"],
          "Next": "ApprovalTimedOut"
        },
        {
          "ErrorEquals": ["RejectedError"],
          "Next": "ChangeRejected"
        }
      ]
    },
    "ExecuteChange": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:execute-change",
      "Retry": [
        {
          "ErrorEquals": ["States.ALL"],
          "IntervalSeconds": 10,
          "MaxAttempts": 2,
          "BackoffRate": 2.0
        }
      ],
      "Next": "ChangeSucceeded",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "ChangeFailed"
        }
      ]
    },
    "ChangeSucceeded": { "Type": "Succeed" },
    "ChangeRejected": { "Type": "Fail", "Error": "Rejected", "Cause": "Change was rejected by approver" },
    "ApprovalTimedOut": { "Type": "Fail", "Error": "Timeout", "Cause": "No approval within 1 hour" },
    "ChangeFailed": { "Type": "Fail", "Error": "ExecutionFailed", "Cause": "Change execution failed after retries" }
  }
}
```

---

## Auto Scaling Configurations (CloudFormation)

### 1. Complete ASG with Mixed Instances, Target Tracking, and Lifecycle Hooks

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Production Auto Scaling Group with advanced features

Parameters:
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
  VpcId:
    Type: AWS::EC2::VPC::Id
  SubnetIds:
    Type: List<AWS::EC2::Subnet::Id>

Resources:
  LaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateName: prod-app-lt
      LaunchTemplateData:
        ImageId: !Ref LatestAmiId
        SecurityGroupIds:
          - !Ref AppSecurityGroup
        IamInstanceProfile:
          Arn: !GetAtt InstanceProfile.Arn
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash
            yum update -y
            amazon-linux-extras install docker -y
            systemctl start docker
            /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource AutoScalingGroup --region ${AWS::Region}
        TagSpecifications:
          - ResourceType: instance
            Tags:
              - Key: Name
                Value: prod-app-instance
              - Key: Environment
                Value: prod
        MetadataOptions:
          HttpTokens: required
          HttpEndpoint: enabled
        Monitoring:
          Enabled: true
        BlockDeviceMappings:
          - DeviceName: /dev/xvda
            Ebs:
              VolumeSize: 50
              VolumeType: gp3
              Encrypted: true

  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      AutoScalingGroupName: prod-app-asg
      MinSize: 2
      MaxSize: 20
      DesiredCapacity: 4
      DefaultInstanceWarmup: 300
      HealthCheckType: ELB
      HealthCheckGracePeriod: 300
      VPCZoneIdentifier: !Ref SubnetIds
      TargetGroupARNs:
        - !Ref TargetGroup
      MixedInstancesPolicy:
        InstancesDistribution:
          OnDemandBaseCapacity: 2
          OnDemandPercentageAboveBaseCapacity: 25
          SpotAllocationStrategy: price-capacity-optimized
        LaunchTemplate:
          LaunchTemplateSpecification:
            LaunchTemplateId: !Ref LaunchTemplate
            Version: !GetAtt LaunchTemplate.LatestVersionNumber
          Overrides:
            - InstanceType: m5.large
            - InstanceType: m5a.large
            - InstanceType: m5d.large
            - InstanceType: c5.large
            - InstanceType: c5a.large
      CapacityRebalance: true
      TerminationPolicies:
        - OldestLaunchTemplate
        - AllocationStrategy
        - Default
      LifecycleHookSpecificationList:
        - LifecycleHookName: launch-hook
          LifecycleTransition: "autoscaling:EC2_INSTANCE_LAUNCHING"
          HeartbeatTimeout: 600
          DefaultResult: ABANDON
        - LifecycleHookName: terminate-hook
          LifecycleTransition: "autoscaling:EC2_INSTANCE_TERMINATING"
          HeartbeatTimeout: 300
          DefaultResult: CONTINUE
      Tags:
        - Key: Name
          Value: prod-app
          PropagateAtLaunch: true

  # Target Tracking Policy - CPU
  CPUScalingPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      PolicyType: TargetTrackingScaling
      TargetTrackingConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ASGAverageCPUUtilization
        TargetValue: 50.0
        DisableScaleIn: false

  # Target Tracking Policy - ALB Request Count
  RequestCountPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      PolicyType: TargetTrackingScaling
      TargetTrackingConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ALBRequestCountPerTarget
          ResourceLabel: !Sub
            - "${ALBFullName}/${TargetGroupFullName}"
            - ALBFullName: !GetAtt ApplicationLoadBalancer.LoadBalancerFullName
              TargetGroupFullName: !GetAtt TargetGroup.TargetGroupFullName
        TargetValue: 1000

  # Predictive Scaling Policy
  PredictiveScalingPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      PolicyType: PredictiveScaling
      PredictiveScalingConfiguration:
        MetricSpecifications:
          - TargetValue: 50.0
            PredefinedMetricPairSpecification:
              PredefinedMetricType: ASGCPUUtilization
        Mode: ForecastAndScale
        SchedulingBufferTime: 300
        MaxCapacityBreachBehavior: HonorMaxCapacity

  # Warm Pool
  WarmPool:
    Type: AWS::AutoScaling::WarmPool
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      PoolState: Stopped
      MinSize: 2
      MaxGroupPreparedCapacity: 5
      InstanceReusePolicy:
        ReuseOnScaleIn: true

  # Scheduled Scaling - Scale up for business hours
  ScheduledScaleUp:
    Type: AWS::AutoScaling::ScheduledAction
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      MinSize: 4
      MaxSize: 20
      DesiredCapacity: 6
      Recurrence: "45 8 * * MON-FRI"
      TimeZone: America/New_York

  # Scheduled Scaling - Scale down after hours
  ScheduledScaleDown:
    Type: AWS::AutoScaling::ScheduledAction
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      MinSize: 2
      MaxSize: 10
      DesiredCapacity: 2
      Recurrence: "15 18 * * MON-FRI"
      TimeZone: America/New_York

  # Lifecycle Hook EventBridge Rule
  LaunchHookRule:
    Type: AWS::Events::Rule
    Properties:
      EventPattern:
        source:
          - aws.autoscaling
        detail-type:
          - "EC2 Instance-launch Lifecycle Action"
        detail:
          AutoScalingGroupName:
            - !Ref AutoScalingGroup
      Targets:
        - Arn: !GetAtt LifecycleHandlerFunction.Arn
          Id: LaunchHookTarget

  AppSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Application security group
      VpcId: !Ref VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          SourceSecurityGroupId: !Ref ALBSecurityGroup

  ALBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: ALB security group
      VpcId: !Ref VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0

  ApplicationLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Scheme: internet-facing
      SecurityGroups:
        - !Ref ALBSecurityGroup
      Subnets: !Ref SubnetIds

  TargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      HealthCheckPath: /health
      HealthCheckIntervalSeconds: 30
      HealthyThresholdCount: 2
      UnhealthyThresholdCount: 3
      Port: 80
      Protocol: HTTP
      VpcId: !Ref VpcId
      TargetType: instance
      DeregistrationDelay:
        timeout_seconds: 300

  InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref InstanceRole

  InstanceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
        - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

  LifecycleHandlerFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: asg-lifecycle-handler
      Runtime: python3.12
      Handler: index.lambda_handler
      Role: !GetAtt LifecycleHandlerRole.Arn
      Timeout: 300
      Code:
        ZipFile: |
          import boto3
          asg = boto3.client('autoscaling')
          ssm = boto3.client('ssm')
          def lambda_handler(event, context):
              detail = event['detail']
              instance_id = detail['EC2InstanceId']
              hook_name = detail['LifecycleHookName']
              asg_name = detail['AutoScalingGroupName']
              token = detail['LifecycleActionToken']
              try:
                  ssm.send_command(
                      InstanceIds=[instance_id],
                      DocumentName='AWS-RunShellScript',
                      Parameters={'commands': [
                          'echo "Configuring instance..."',
                          '/opt/scripts/register-service.sh',
                          'echo "Configuration complete"'
                      ]},
                      TimeoutSeconds=300
                  )
                  asg.complete_lifecycle_action(
                      AutoScalingGroupName=asg_name,
                      LifecycleHookName=hook_name,
                      LifecycleActionToken=token,
                      LifecycleActionResult='CONTINUE'
                  )
              except Exception as e:
                  print(f'Error: {str(e)}')
                  asg.complete_lifecycle_action(
                      AutoScalingGroupName=asg_name,
                      LifecycleHookName=hook_name,
                      LifecycleActionToken=token,
                      LifecycleActionResult='ABANDON'
                  )

  LifecycleHandlerRole:
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
        - PolicyName: LifecycleHandlerPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - autoscaling:CompleteLifecycleAction
                  - ssm:SendCommand
                Resource: '*'
```

---

## SQS-Based Scaling Patterns

### 1. Backlog Per Instance Custom Metric Publisher

```python
import boto3

cloudwatch = boto3.client('cloudwatch')
sqs = boto3.client('sqs')
asg_client = boto3.client('autoscaling')

QUEUE_URL = 'https://sqs.us-east-1.amazonaws.com/123456789012/order-processing'
ASG_NAME = 'order-processor-asg'

def lambda_handler(event, context):
    """Publish backlog-per-instance metric every minute (triggered by EventBridge schedule)."""

    queue_attrs = sqs.get_queue_attributes(
        QueueUrl=QUEUE_URL,
        AttributeNames=['ApproximateNumberOfMessagesVisible', 'ApproximateNumberOfMessagesNotVisible']
    )
    messages_visible = int(queue_attrs['Attributes']['ApproximateNumberOfMessagesVisible'])
    messages_in_flight = int(queue_attrs['Attributes']['ApproximateNumberOfMessagesNotVisible'])

    asg_response = asg_client.describe_auto_scaling_groups(
        AutoScalingGroupNames=[ASG_NAME]
    )
    asg = asg_response['AutoScalingGroups'][0]
    running_instances = len([
        i for i in asg['Instances']
        if i['LifecycleState'] == 'InService'
    ])

    backlog_per_instance = 0
    if running_instances > 0:
        backlog_per_instance = messages_visible / running_instances

    cloudwatch.put_metric_data(
        Namespace='Custom/SQSScaling',
        MetricData=[
            {
                'MetricName': 'BacklogPerInstance',
                'Dimensions': [
                    {'Name': 'QueueName', 'Value': 'order-processing'},
                    {'Name': 'AutoScalingGroupName', 'Value': ASG_NAME}
                ],
                'Value': backlog_per_instance,
                'Unit': 'Count'
            },
            {
                'MetricName': 'TotalBacklog',
                'Dimensions': [
                    {'Name': 'QueueName', 'Value': 'order-processing'}
                ],
                'Value': messages_visible,
                'Unit': 'Count'
            }
        ]
    )

    return {
        'messagesVisible': messages_visible,
        'messagesInFlight': messages_in_flight,
        'runningInstances': running_instances,
        'backlogPerInstance': backlog_per_instance
    }
```

### 2. Target Tracking with Custom Metric (CloudFormation)

```yaml
Resources:
  SQSBacklogScalingPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AutoScalingGroupName: !Ref ProcessingASG
      PolicyType: TargetTrackingScaling
      TargetTrackingConfiguration:
        CustomizedMetricSpecification:
          Namespace: Custom/SQSScaling
          MetricName: BacklogPerInstance
          Dimensions:
            - Name: QueueName
              Value: order-processing
            - Name: AutoScalingGroupName
              Value: !Ref ProcessingASG
          Statistic: Average
        TargetValue: 10
        DisableScaleIn: false

  MetricPublisherSchedule:
    Type: AWS::Events::Rule
    Properties:
      ScheduleExpression: "rate(1 minute)"
      Targets:
        - Arn: !GetAtt MetricPublisherFunction.Arn
          Id: MetricPublisher
```

### 3. Lambda + SQS Event Source Mapping with DLQ

```yaml
Resources:
  OrderQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: order-processing
      VisibilityTimeout: 900
      MessageRetentionPeriod: 1209600
      ReceiveMessageWaitTimeSeconds: 20
      RedrivePolicy:
        deadLetterTargetArn: !GetAtt OrderDLQ.Arn
        maxReceiveCount: 3

  OrderDLQ:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: order-processing-dlq
      MessageRetentionPeriod: 1209600
      RedriveAllowPolicy:
        redrivePermission: byQueue
        sourceQueueArns:
          - !GetAtt OrderQueue.Arn

  OrderProcessorMapping:
    Type: AWS::Lambda::EventSourceMapping
    Properties:
      EventSourceArn: !GetAtt OrderQueue.Arn
      FunctionName: !Ref OrderProcessorFunction
      BatchSize: 10
      MaximumBatchingWindowInSeconds: 5
      FunctionResponseTypes:
        - ReportBatchItemFailures
      ScalingConfig:
        MaximumConcurrency: 50

  DLQAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: order-dlq-messages
      MetricName: ApproximateNumberOfMessagesVisible
      Namespace: AWS/SQS
      Statistic: Sum
      Period: 300
      EvaluationPeriods: 1
      Threshold: 1
      ComparisonOperator: GreaterThanOrEqualToThreshold
      Dimensions:
        - Name: QueueName
          Value: !GetAtt OrderDLQ.QueueName
      AlarmActions:
        - !Ref AlertTopic
```

---

## GuardDuty Automated Response

### Complete GuardDuty Response Architecture (CloudFormation)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: GuardDuty automated response infrastructure

Resources:
  GuardDutyHighSeverityRule:
    Type: AWS::Events::Rule
    Properties:
      Name: guardduty-high-severity-response
      Description: Respond to high severity GuardDuty findings
      State: ENABLED
      EventPattern:
        source:
          - aws.guardduty
        detail-type:
          - "GuardDuty Finding"
        detail:
          severity:
            - numeric:
                - ">="
                - 7
      Targets:
        - Arn: !GetAtt ResponseStateMachine.Arn
          Id: StepFunctionsTarget
          RoleArn: !GetAtt EventBridgeRole.Arn

  GuardDutyMediumSeverityRule:
    Type: AWS::Events::Rule
    Properties:
      Name: guardduty-medium-severity-alert
      EventPattern:
        source:
          - aws.guardduty
        detail-type:
          - "GuardDuty Finding"
        detail:
          severity:
            - numeric:
                - ">="
                - 4
                - "<"
                - 7
      Targets:
        - Arn: !Ref SecurityAlertTopic
          Id: SNSTarget

  SecurityAlertTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: guardduty-security-alerts

  QuarantineSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Quarantine SG - no inbound or outbound
      VpcId: !Ref VpcId

  QuarantineSGEgressRule:
    Type: AWS::EC2::SecurityGroupEgress
    Properties:
      GroupId: !Ref QuarantineSecurityGroup
      IpProtocol: "-1"
      CidrIp: 127.0.0.1/32
      Description: Block all outbound except loopback

  ResponseFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: guardduty-auto-response
      Runtime: python3.12
      Handler: index.lambda_handler
      Role: !GetAtt ResponseFunctionRole.Arn
      Timeout: 300
      Environment:
        Variables:
          QUARANTINE_SG: !Ref QuarantineSecurityGroup
          SNS_TOPIC: !Ref SecurityAlertTopic
          AUDIT_TABLE: !Ref AuditTable
      Code:
        ZipFile: |
          import json
          import os
          import boto3
          from datetime import datetime
          ec2 = boto3.client('ec2')
          sns = boto3.client('sns')
          dynamodb = boto3.resource('dynamodb')
          def lambda_handler(event, context):
              finding = event['finding']
              instance_id = finding['resource']['instanceDetails']['instanceId']
              qsg = os.environ['QUARANTINE_SG']
              instance = ec2.describe_instances(InstanceIds=[instance_id])
              original_sgs = [sg['GroupId'] for sg in instance['Reservations'][0]['Instances'][0]['SecurityGroups']]
              ec2.modify_instance_attribute(InstanceId=instance_id, Groups=[qsg])
              ec2.create_tags(Resources=[instance_id], Tags=[
                  {'Key': 'Quarantined', 'Value': 'true'},
                  {'Key': 'OriginalSGs', 'Value': ','.join(original_sgs)}
              ])
              table = dynamodb.Table(os.environ['AUDIT_TABLE'])
              table.put_item(Item={
                  'incidentId': finding.get('id', context.aws_request_id),
                  'instanceId': instance_id,
                  'timestamp': datetime.utcnow().isoformat(),
                  'originalSGs': original_sgs,
                  'action': 'quarantined'
              })
              return {'instanceId': instance_id, 'status': 'quarantined', 'originalSGs': original_sgs}

  AuditTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: guardduty-incident-audit
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: incidentId
          AttributeType: S
      KeySchema:
        - AttributeName: incidentId
          KeyType: HASH
      PointInTimeRecoverySpecification:
        PointInTimeRecoveryEnabled: true

  ResponseFunctionRole:
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
        - PolicyName: GuardDutyResponsePolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - ec2:ModifyInstanceAttribute
                  - ec2:DescribeInstances
                  - ec2:CreateTags
                  - ec2:CreateSnapshot
                  - ec2:DescribeVolumes
                Resource: '*'
              - Effect: Allow
                Action:
                  - sns:Publish
                Resource: !Ref SecurityAlertTopic
              - Effect: Allow
                Action:
                  - dynamodb:PutItem
                Resource: !GetAtt AuditTable.Arn

  EventBridgeRole:
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
        - PolicyName: InvokeStepFunctions
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action: states:StartExecution
                Resource: !Ref ResponseStateMachine

  ResponseStateMachine:
    Type: AWS::StepFunctions::StateMachine
    Properties:
      StateMachineName: guardduty-incident-response
      RoleArn: !GetAtt StepFunctionsRole.Arn
      Definition:
        Comment: GuardDuty incident response orchestration
        StartAt: QuarantineInstance
        States:
          QuarantineInstance:
            Type: Task
            Resource: !GetAtt ResponseFunction.Arn
            ResultPath: "$.quarantineResult"
            Next: CreateSnapshots
            Retry:
              - ErrorEquals: ["States.TaskFailed"]
                IntervalSeconds: 5
                MaxAttempts: 2
                BackoffRate: 2.0
            Catch:
              - ErrorEquals: ["States.ALL"]
                Next: NotifyFailure
                ResultPath: "$.error"
          CreateSnapshots:
            Type: Task
            Resource: "arn:aws:lambda:us-east-1:123456789012:function:create-forensic-snapshots"
            ResultPath: "$.snapshotResult"
            Next: NotifySuccess
            Catch:
              - ErrorEquals: ["States.ALL"]
                Next: NotifySuccess
                ResultPath: "$.snapshotError"
          NotifySuccess:
            Type: Task
            Resource: "arn:aws:states:::sns:publish"
            Parameters:
              TopicArn: !Ref SecurityAlertTopic
              Subject: "GuardDuty: Instance Quarantined Successfully"
              Message.$: "States.JsonToString($.quarantineResult)"
            End: true
          NotifyFailure:
            Type: Task
            Resource: "arn:aws:states:::sns:publish"
            Parameters:
              TopicArn: !Ref SecurityAlertTopic
              Subject: "CRITICAL: GuardDuty Response Failed"
              Message.$: "States.JsonToString($.error)"
            Next: ResponseFailed
          ResponseFailed:
            Type: Fail
            Error: "ResponseFailed"
            Cause: "Automated response failed - manual intervention required"

  StepFunctionsRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: states.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: StepFunctionsPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action: lambda:InvokeFunction
                Resource:
                  - !GetAtt ResponseFunction.Arn
                  - "arn:aws:lambda:us-east-1:123456789012:function:create-forensic-snapshots"
              - Effect: Allow
                Action: sns:Publish
                Resource: !Ref SecurityAlertTopic
```

---

## SNS with Filtering Policies

### 1. Order Processing Fan-Out with Filtering

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: SNS fan-out with message filtering

Resources:
  OrderTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: order-events

  # Payment queue - only receives high-value orders
  PaymentQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: payment-processing

  PaymentSubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: sqs
      TopicArn: !Ref OrderTopic
      Endpoint: !GetAtt PaymentQueue.Arn
      FilterPolicy:
        orderType:
          - purchase
          - refund
        amount:
          - numeric:
              - ">="
              - 100
      FilterPolicyScope: MessageAttributes

  # Inventory queue - receives all purchase orders
  InventoryQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: inventory-updates

  InventorySubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: sqs
      TopicArn: !Ref OrderTopic
      Endpoint: !GetAtt InventoryQueue.Arn
      FilterPolicy:
        orderType:
          - purchase
      FilterPolicyScope: MessageAttributes

  # Analytics queue - receives everything
  AnalyticsQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: order-analytics

  AnalyticsSubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: sqs
      TopicArn: !Ref OrderTopic
      Endpoint: !GetAtt AnalyticsQueue.Arn

  # Notification queue - only purchase orders for premium customers
  NotificationQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: customer-notifications

  NotificationSubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: sqs
      TopicArn: !Ref OrderTopic
      Endpoint: !GetAtt NotificationQueue.Arn
      FilterPolicy:
        orderType:
          - purchase
        customerTier:
          - premium
          - enterprise
        region:
          - prefix: "us-"
      FilterPolicyScope: MessageAttributes

  # Fraud detection - high-value orders from new customers
  FraudQueue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: fraud-detection

  FraudSubscription:
    Type: AWS::SNS::Subscription
    Properties:
      Protocol: sqs
      TopicArn: !Ref OrderTopic
      Endpoint: !GetAtt FraudQueue.Arn
      FilterPolicy:
        amount:
          - numeric:
              - ">="
              - 500
        customerAge:
          - numeric:
              - "<="
              - 30
        orderType:
          - anything-but: "refund"
      FilterPolicyScope: MessageAttributes

  # SQS policies to allow SNS to publish
  PaymentQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref PaymentQueue
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: sns.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt PaymentQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref OrderTopic

  InventoryQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref InventoryQueue
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: sns.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt InventoryQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref OrderTopic

  AnalyticsQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref AnalyticsQueue
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: sns.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt AnalyticsQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref OrderTopic

  NotificationQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref NotificationQueue
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: sns.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt NotificationQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref OrderTopic

  FraudQueuePolicy:
    Type: AWS::SQS::QueuePolicy
    Properties:
      Queues:
        - !Ref FraudQueue
      PolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: sns.amazonaws.com
            Action: sqs:SendMessage
            Resource: !GetAtt FraudQueue.Arn
            Condition:
              ArnEquals:
                aws:SourceArn: !Ref OrderTopic
```

### 2. Publishing with Message Attributes (Python)

```python
import json
import boto3

sns = boto3.client('sns')
TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:order-events'

def publish_order_event(order):
    response = sns.publish(
        TopicArn=TOPIC_ARN,
        Message=json.dumps(order),
        MessageAttributes={
            'orderType': {
                'DataType': 'String',
                'StringValue': order['type']
            },
            'amount': {
                'DataType': 'Number',
                'StringValue': str(order['amount'])
            },
            'customerTier': {
                'DataType': 'String',
                'StringValue': order['customerTier']
            },
            'region': {
                'DataType': 'String',
                'StringValue': order['region']
            },
            'customerAge': {
                'DataType': 'Number',
                'StringValue': str(order['customerAgeDays'])
            }
        }
    )
    return response['MessageId']

order = {
    'orderId': 'ORD-12345',
    'type': 'purchase',
    'amount': 750.00,
    'customerTier': 'premium',
    'region': 'us-east-1',
    'customerAgeDays': 15,
    'items': [
        {'sku': 'PROD-001', 'quantity': 2},
        {'sku': 'PROD-002', 'quantity': 1}
    ]
}

message_id = publish_order_event(order)
print(f'Published order event: {message_id}')
```

### 3. Message Body Filtering (FilterPolicyScope: MessageBody)

```json
{
  "orderType": ["purchase"],
  "shipping": {
    "priority": ["express", "overnight"]
  },
  "total": [{"numeric": [">=", 200]}],
  "destination": {
    "country": [{"prefix": "US"}]
  }
}
```

> **Note:** When `FilterPolicyScope` is set to `MessageBody`, the filter policy applies to the JSON message body rather than message attributes. The message body must be valid JSON for body-based filtering to work.
