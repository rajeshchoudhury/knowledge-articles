# High Availability & Disaster Recovery — Code Examples

> CloudFormation, CLI, and configuration examples for key HA/DR patterns tested on the DOP-C02 exam.

---

## Table of Contents

1. [Multi-AZ VPC with Auto Scaling](#1-multi-az-vpc-with-auto-scaling)
2. [Route 53 Failover Configuration](#2-route-53-failover-configuration)
3. [Aurora Global Database Setup](#3-aurora-global-database-setup)
4. [AWS Backup Plan Configuration](#4-aws-backup-plan-configuration)
5. [DynamoDB Global Table](#5-dynamodb-global-table)
6. [Elastic Disaster Recovery Configuration](#6-elastic-disaster-recovery-configuration)
7. [Multi-Region Deployment Pipeline](#7-multi-region-deployment-pipeline)
8. [ECS Service with Circuit Breaker](#8-ecs-service-with-circuit-breaker)

---

## 1. Multi-AZ VPC with Auto Scaling

This CloudFormation template creates a production-ready VPC spanning three AZs with public/private subnets, per-AZ NAT Gateways, an ALB, and an Auto Scaling Group.

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Multi-AZ VPC with ALB and Auto Scaling Group

Parameters:
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64

  InstanceType:
    Type: String
    Default: t3.medium

  Environment:
    Type: String
    Default: production
    AllowedValues: [production, staging]

Resources:
  # ============================================================
  # VPC and Networking
  # ============================================================
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-vpc

  InternetGateway:
    Type: AWS::EC2::InternetGateway

  VPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

  # --- Public Subnets (one per AZ) ---
  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-public-1

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.2.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-public-2

  PublicSubnet3:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.3.0/24
      AvailabilityZone: !Select [2, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-public-3

  # --- Private Subnets (one per AZ) ---
  PrivateSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.11.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-private-1

  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.12.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-private-2

  PrivateSubnet3:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.13.0/24
      AvailabilityZone: !Select [2, !GetAZs '']
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-private-3

  # --- NAT Gateways (one per AZ for HA) ---
  NatEIP1:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc

  NatEIP2:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc

  NatEIP3:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc

  NatGateway1:
    Type: AWS::EC2::NatGateway
    Properties:
      SubnetId: !Ref PublicSubnet1
      AllocationId: !GetAtt NatEIP1.AllocationId
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-nat-1

  NatGateway2:
    Type: AWS::EC2::NatGateway
    Properties:
      SubnetId: !Ref PublicSubnet2
      AllocationId: !GetAtt NatEIP2.AllocationId
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-nat-2

  NatGateway3:
    Type: AWS::EC2::NatGateway
    Properties:
      SubnetId: !Ref PublicSubnet3
      AllocationId: !GetAtt NatEIP3.AllocationId
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-nat-3

  # --- Route Tables ---
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC

  PublicRoute:
    Type: AWS::EC2::Route
    DependsOn: VPCGatewayAttachment
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  PublicSubnet1RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet1
      RouteTableId: !Ref PublicRouteTable

  PublicSubnet2RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet2
      RouteTableId: !Ref PublicRouteTable

  PublicSubnet3RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet3
      RouteTableId: !Ref PublicRouteTable

  # Per-AZ private route tables pointing to local NAT Gateway
  PrivateRouteTable1:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC

  PrivateRoute1:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable1
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway1

  PrivateSubnet1RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet1
      RouteTableId: !Ref PrivateRouteTable1

  PrivateRouteTable2:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC

  PrivateRoute2:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable2
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway2

  PrivateSubnet2RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet2
      RouteTableId: !Ref PrivateRouteTable2

  PrivateRouteTable3:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC

  PrivateRoute3:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable3
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway3

  PrivateSubnet3RouteTableAssoc:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnet3
      RouteTableId: !Ref PrivateRouteTable3

  # ============================================================
  # Application Load Balancer
  # ============================================================
  ALBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow HTTP/HTTPS from internet
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0

  ApplicationLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Name: !Sub ${Environment}-alb
      Scheme: internet-facing
      Type: application
      Subnets:
        - !Ref PublicSubnet1
        - !Ref PublicSubnet2
        - !Ref PublicSubnet3
      SecurityGroups:
        - !Ref ALBSecurityGroup
      LoadBalancerAttributes:
        - Key: idle_timeout.timeout_seconds
          Value: '60'

  ALBTargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Name: !Sub ${Environment}-tg
      Port: 80
      Protocol: HTTP
      VpcId: !Ref VPC
      TargetType: instance
      HealthCheckPath: /health
      HealthCheckIntervalSeconds: 15
      HealthCheckTimeoutSeconds: 5
      HealthyThresholdCount: 2
      UnhealthyThresholdCount: 3
      DeregistrationDelay.TimeoutSeconds: 30
      Matcher:
        HttpCode: '200'

  ALBListener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      LoadBalancerArn: !Ref ApplicationLoadBalancer
      Port: 80
      Protocol: HTTP
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref ALBTargetGroup

  # ============================================================
  # Auto Scaling Group
  # ============================================================
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow traffic from ALB only
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          SourceSecurityGroupId: !Ref ALBSecurityGroup

  LaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateName: !Sub ${Environment}-lt
      LaunchTemplateData:
        ImageId: !Ref LatestAmiId
        InstanceType: !Ref InstanceType
        SecurityGroupIds:
          - !Ref InstanceSecurityGroup
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash
            yum install -y httpd
            echo "Healthy" > /var/www/html/health
            echo "Hello from $(hostname)" > /var/www/html/index.html
            systemctl start httpd
            systemctl enable httpd

  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      AutoScalingGroupName: !Sub ${Environment}-asg
      LaunchTemplate:
        LaunchTemplateId: !Ref LaunchTemplate
        Version: !GetAtt LaunchTemplate.LatestVersionNumber
      MinSize: 3
      MaxSize: 12
      DesiredCapacity: 6
      VPCZoneIdentifier:
        - !Ref PrivateSubnet1
        - !Ref PrivateSubnet2
        - !Ref PrivateSubnet3
      TargetGroupARNs:
        - !Ref ALBTargetGroup
      HealthCheckType: ELB
      HealthCheckGracePeriod: 300
      CapacityRebalance: true
      Tags:
        - Key: Name
          Value: !Sub ${Environment}-instance
          PropagateAtLaunch: true

  # Target Tracking Scaling Policy
  ScalingPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AutoScalingGroupName: !Ref AutoScalingGroup
      PolicyType: TargetTrackingScaling
      TargetTrackingConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ASGAverageCPUUtilization
        TargetValue: 50.0
        ScaleInCooldown: 300
        ScaleOutCooldown: 60

Outputs:
  ALBDnsName:
    Description: ALB DNS Name
    Value: !GetAtt ApplicationLoadBalancer.DNSName

  VPCId:
    Description: VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub ${Environment}-VpcId
```

### Key Design Decisions

- **Per-AZ NAT Gateways**: Each private subnet routes through its own AZ's NAT Gateway, eliminating cross-AZ dependency.
- **ELB Health Checks on ASG**: Catches application-level failures, not just EC2 hardware issues.
- **HealthCheckGracePeriod = 300**: Gives instances 5 minutes to complete startup before health checking.
- **CapacityRebalance = true**: Proactively replaces instances when AZ health degrades.
- **DeregistrationDelay = 30 seconds**: Faster deployments by reducing connection draining time.

---

## 2. Route 53 Failover Configuration

### CloudFormation: Active-Passive Failover with Health Checks

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Route 53 active-passive failover between two regions

Parameters:
  DomainName:
    Type: String
    Default: app.example.com

  HostedZoneId:
    Type: String

  PrimaryALBDnsName:
    Type: String
    Description: ALB DNS name in the primary region (us-east-1)

  PrimaryALBHostedZoneId:
    Type: String
    Description: ALB hosted zone ID in the primary region

  SecondaryALBDnsName:
    Type: String
    Description: ALB DNS name in the DR region (eu-west-1)

  SecondaryALBHostedZoneId:
    Type: String
    Description: ALB hosted zone ID in the DR region

Resources:
  # Health check for the primary endpoint
  PrimaryHealthCheck:
    Type: AWS::Route53::HealthCheck
    Properties:
      HealthCheckConfig:
        FullyQualifiedDomainName: !Ref PrimaryALBDnsName
        Port: 443
        Type: HTTPS
        ResourcePath: /health
        RequestInterval: 10
        FailureThreshold: 3
        EnableSNI: true
      HealthCheckTags:
        - Key: Name
          Value: primary-health-check

  # CloudWatch alarm that triggers when the primary health check fails
  PrimaryHealthAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: primary-endpoint-unhealthy
      Namespace: AWS/Route53
      MetricName: HealthCheckStatus
      Dimensions:
        - Name: HealthCheckId
          Value: !Ref PrimaryHealthCheck
      Statistic: Minimum
      Period: 60
      EvaluationPeriods: 1
      Threshold: 1
      ComparisonOperator: LessThanThreshold
      AlarmActions:
        - !Ref FailoverSNSTopic

  FailoverSNSTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: dr-failover-notifications

  # Primary DNS record (active)
  PrimaryDNSRecord:
    Type: AWS::Route53::RecordSet
    Properties:
      HostedZoneId: !Ref HostedZoneId
      Name: !Ref DomainName
      Type: A
      SetIdentifier: primary
      Failover: PRIMARY
      HealthCheckId: !Ref PrimaryHealthCheck
      AliasTarget:
        DNSName: !Ref PrimaryALBDnsName
        HostedZoneId: !Ref PrimaryALBHostedZoneId
        EvaluateTargetHealth: true

  # Secondary DNS record (passive — receives traffic only when primary fails)
  SecondaryDNSRecord:
    Type: AWS::Route53::RecordSet
    Properties:
      HostedZoneId: !Ref HostedZoneId
      Name: !Ref DomainName
      Type: A
      SetIdentifier: secondary
      Failover: SECONDARY
      AliasTarget:
        DNSName: !Ref SecondaryALBDnsName
        HostedZoneId: !Ref SecondaryALBHostedZoneId
        EvaluateTargetHealth: true
```

### AWS CLI: Calculated Health Check (Composite)

```bash
# Create a calculated health check that requires at least 2 of 3 child checks to pass
aws route53 create-health-check \
  --caller-reference "calculated-$(date +%s)" \
  --health-check-config '{
    "Type": "CALCULATED",
    "HealthThreshold": 2,
    "ChildHealthChecks": [
      "health-check-id-1",
      "health-check-id-2",
      "health-check-id-3"
    ]
  }'
```

### AWS CLI: CloudWatch Alarm-Based Health Check (For Private Resources)

```bash
# Step 1: Create a CloudWatch alarm on a custom metric
aws cloudwatch put-metric-alarm \
  --alarm-name "app-health-alarm" \
  --namespace "Custom/Application" \
  --metric-name "HealthStatus" \
  --statistic Average \
  --period 60 \
  --evaluation-periods 3 \
  --threshold 1 \
  --comparison-operator LessThanThreshold

# Step 2: Create a Route 53 health check based on the alarm
aws route53 create-health-check \
  --caller-reference "cw-alarm-$(date +%s)" \
  --health-check-config '{
    "Type": "CLOUDWATCH_METRIC",
    "AlarmIdentifier": {
      "Region": "us-east-1",
      "Name": "app-health-alarm"
    },
    "InsufficientDataHealthStatus": "LastKnownStatus"
  }'
```

---

## 3. Aurora Global Database Setup

### CloudFormation: Aurora Global Database (Primary + Secondary Region)

**Primary Region Stack (us-east-1):**

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Aurora Global Database - Primary Region

Parameters:
  GlobalClusterIdentifier:
    Type: String
    Default: my-global-cluster

  MasterUsername:
    Type: String
    Default: admin
    NoEcho: true

  MasterUserPassword:
    Type: String
    NoEcho: true

Resources:
  GlobalCluster:
    Type: AWS::RDS::GlobalCluster
    Properties:
      GlobalClusterIdentifier: !Ref GlobalClusterIdentifier
      Engine: aurora-mysql
      EngineVersion: '8.0.mysql_aurora.3.04.0'
      StorageEncrypted: true

  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Aurora subnet group
      SubnetIds:
        - !ImportValue production-PrivateSubnet1
        - !ImportValue production-PrivateSubnet2
        - !ImportValue production-PrivateSubnet3

  DBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Aurora security group
      VpcId: !ImportValue production-VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 3306
          ToPort: 3306
          SourceSecurityGroupId: !ImportValue production-AppSecurityGroup

  PrimaryCluster:
    Type: AWS::RDS::DBCluster
    Properties:
      DBClusterIdentifier: primary-cluster
      GlobalClusterIdentifier: !Ref GlobalClusterIdentifier
      Engine: aurora-mysql
      EngineVersion: '8.0.mysql_aurora.3.04.0'
      MasterUsername: !Ref MasterUsername
      MasterUserPassword: !Ref MasterUserPassword
      DBSubnetGroupName: !Ref DBSubnetGroup
      VpcSecurityGroupIds:
        - !Ref DBSecurityGroup
      BackupRetentionPeriod: 35
      StorageEncrypted: true
      DeletionProtection: true

  PrimaryWriter:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: primary-writer
      DBClusterIdentifier: !Ref PrimaryCluster
      DBInstanceClass: db.r6g.xlarge
      Engine: aurora-mysql
      PubliclyAccessible: false

  PrimaryReader1:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: primary-reader-1
      DBClusterIdentifier: !Ref PrimaryCluster
      DBInstanceClass: db.r6g.large
      Engine: aurora-mysql
      PubliclyAccessible: false
      PromotionTier: 1

Outputs:
  GlobalClusterArn:
    Value: !GetAtt GlobalCluster.Arn
    Export:
      Name: GlobalClusterArn

  ClusterEndpoint:
    Value: !GetAtt PrimaryCluster.Endpoint.Address

  ReaderEndpoint:
    Value: !GetAtt PrimaryCluster.ReadEndpoint.Address
```

**Secondary Region Stack (eu-west-1):**

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Aurora Global Database - Secondary Region

Parameters:
  GlobalClusterIdentifier:
    Type: String
    Default: my-global-cluster

Resources:
  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Aurora DR subnet group
      SubnetIds:
        - !ImportValue dr-PrivateSubnet1
        - !ImportValue dr-PrivateSubnet2
        - !ImportValue dr-PrivateSubnet3

  SecondaryCluster:
    Type: AWS::RDS::DBCluster
    Properties:
      DBClusterIdentifier: secondary-cluster
      GlobalClusterIdentifier: !Ref GlobalClusterIdentifier
      Engine: aurora-mysql
      EngineVersion: '8.0.mysql_aurora.3.04.0'
      DBSubnetGroupName: !Ref DBSubnetGroup
      StorageEncrypted: true
      DeletionProtection: true

  SecondaryReader1:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: secondary-reader-1
      DBClusterIdentifier: !Ref SecondaryCluster
      DBInstanceClass: db.r6g.large
      Engine: aurora-mysql
      PubliclyAccessible: false
```

### AWS CLI: Managed Planned Failover

```bash
# Perform managed planned failover (zero data loss)
aws rds failover-global-cluster \
  --global-cluster-identifier my-global-cluster \
  --target-db-cluster-identifier arn:aws:rds:eu-west-1:123456789012:cluster:secondary-cluster

# Perform unplanned failover (detach and promote)
aws rds remove-from-global-cluster \
  --global-cluster-identifier my-global-cluster \
  --db-cluster-identifier arn:aws:rds:eu-west-1:123456789012:cluster:secondary-cluster
```

---

## 4. AWS Backup Plan Configuration

### CloudFormation: Comprehensive Backup Plan with Cross-Region and Vault Lock

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: AWS Backup with cross-region copy, vault lock, and organization policies

Resources:
  # Primary backup vault
  PrimaryBackupVault:
    Type: AWS::Backup::BackupVault
    Properties:
      BackupVaultName: primary-vault
      EncryptionKeyArn: !GetAtt BackupKMSKey.Arn
      AccessPolicy:
        Version: '2012-10-17'
        Statement:
          - Effect: Deny
            Principal: '*'
            Action: backup:DeleteBackupVault
            Resource: '*'

  # DR backup vault in another region (deployed separately or via StackSets)
  DRBackupVault:
    Type: AWS::Backup::BackupVault
    Properties:
      BackupVaultName: dr-vault
      EncryptionKeyArn: !GetAtt BackupKMSKey.Arn
      LockConfiguration:
        MinRetentionDays: 365
        MaxRetentionDays: 2555
        ChangeableForDays: 3

  BackupKMSKey:
    Type: AWS::KMS::Key
    Properties:
      Description: Key for backup encryption
      KeyPolicy:
        Version: '2012-10-17'
        Statement:
          - Sid: Enable Root Account
            Effect: Allow
            Principal:
              AWS: !Sub arn:aws:iam::${AWS::AccountId}:root
            Action: kms:*
            Resource: '*'

  # Backup plan with multiple rules
  BackupPlan:
    Type: AWS::Backup::BackupPlan
    Properties:
      BackupPlan:
        BackupPlanName: production-backup-plan
        BackupPlanRule:
          # Daily backup retained for 35 days
          - RuleName: DailyBackup
            TargetBackupVault: !Ref PrimaryBackupVault
            ScheduleExpression: cron(0 2 * * ? *)
            StartWindowMinutes: 60
            CompletionWindowMinutes: 180
            Lifecycle:
              DeleteAfterDays: 35
            CopyActions:
              - DestinationBackupVaultArn: !GetAtt DRBackupVault.BackupVaultArn
                Lifecycle:
                  DeleteAfterDays: 35

          # Weekly backup retained for 90 days
          - RuleName: WeeklyBackup
            TargetBackupVault: !Ref PrimaryBackupVault
            ScheduleExpression: cron(0 3 ? * SUN *)
            StartWindowMinutes: 120
            CompletionWindowMinutes: 360
            Lifecycle:
              MoveToColdStorageAfterDays: 30
              DeleteAfterDays: 90
            CopyActions:
              - DestinationBackupVaultArn: !GetAtt DRBackupVault.BackupVaultArn
                Lifecycle:
                  MoveToColdStorageAfterDays: 30
                  DeleteAfterDays: 90

          # Monthly backup retained for 1 year
          - RuleName: MonthlyBackup
            TargetBackupVault: !Ref PrimaryBackupVault
            ScheduleExpression: cron(0 4 1 * ? *)
            StartWindowMinutes: 120
            CompletionWindowMinutes: 720
            Lifecycle:
              MoveToColdStorageAfterDays: 30
              DeleteAfterDays: 365
            CopyActions:
              - DestinationBackupVaultArn: !GetAtt DRBackupVault.BackupVaultArn
                Lifecycle:
                  MoveToColdStorageAfterDays: 30
                  DeleteAfterDays: 365

  # Resource selection by tags
  BackupSelection:
    Type: AWS::Backup::BackupSelection
    Properties:
      BackupPlanId: !Ref BackupPlan
      BackupSelection:
        SelectionName: tagged-resources
        IamRoleArn: !GetAtt BackupRole.Arn
        ListOfTags:
          - ConditionType: STRINGEQUALS
            ConditionKey: backup
            ConditionValue: 'true'
        Resources:
          - 'arn:aws:dynamodb:*:*:table/*'

  BackupRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: backup.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup
        - arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores
```

### AWS CLI: Enable Vault Lock (Compliance Mode — Irreversible)

```bash
# Enable vault lock in compliance mode
# WARNING: After ChangeableForDays expires, this is IRREVERSIBLE
aws backup put-backup-vault-lock-configuration \
  --backup-vault-name dr-vault \
  --min-retention-days 365 \
  --max-retention-days 2555 \
  --changeable-for-days 3
```

---

## 5. DynamoDB Global Table

### CloudFormation: DynamoDB Global Table (Multi-Region Active-Active)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: DynamoDB Global Table with PITR and auto scaling

Resources:
  GlobalTable:
    Type: AWS::DynamoDB::GlobalTable
    Properties:
      TableName: user-sessions
      AttributeDefinitions:
        - AttributeName: userId
          AttributeType: S
        - AttributeName: sessionId
          AttributeType: S
      KeySchema:
        - AttributeName: userId
          KeyType: HASH
        - AttributeName: sessionId
          KeyType: RANGE
      BillingMode: PAY_PER_REQUEST
      StreamSpecification:
        StreamViewType: NEW_AND_OLD_IMAGES
      SSESpecification:
        SSEEnabled: true
        SSEType: KMS
      TimeToLiveSpecification:
        AttributeName: ttl
        Enabled: true
      Replicas:
        - Region: us-east-1
          PointInTimeRecoverySpecification:
            PointInTimeRecoveryEnabled: true
          Tags:
            - Key: Environment
              Value: production
          GlobalSecondaryIndexes: []
        - Region: eu-west-1
          PointInTimeRecoverySpecification:
            PointInTimeRecoveryEnabled: true
          Tags:
            - Key: Environment
              Value: production
          GlobalSecondaryIndexes: []
        - Region: ap-southeast-1
          PointInTimeRecoverySpecification:
            PointInTimeRecoveryEnabled: true
          Tags:
            - Key: Environment
              Value: production
          GlobalSecondaryIndexes: []
```

### AWS CLI: Create Global Table and Add Replicas

```bash
# Create a table with DynamoDB Streams (required for Global Tables)
aws dynamodb create-table \
  --table-name user-sessions \
  --attribute-definitions \
    AttributeName=userId,AttributeType=S \
    AttributeName=sessionId,AttributeType=S \
  --key-schema \
    AttributeName=userId,KeyType=HASH \
    AttributeName=sessionId,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST \
  --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES \
  --region us-east-1

# Enable PITR
aws dynamodb update-continuous-backups \
  --table-name user-sessions \
  --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true \
  --region us-east-1

# Add replica regions
aws dynamodb update-table \
  --table-name user-sessions \
  --replica-updates \
    '[{"Create": {"RegionName": "eu-west-1"}}, {"Create": {"RegionName": "ap-southeast-1"}}]' \
  --region us-east-1

# Verify replication status
aws dynamodb describe-table \
  --table-name user-sessions \
  --query 'Table.Replicas' \
  --region us-east-1
```

---

## 6. Elastic Disaster Recovery Configuration

### AWS CLI: Set Up AWS DRS for On-Premises to AWS DR

```bash
# Step 1: Initialize DRS in the target region
aws drs initialize-service --region us-west-2

# Step 2: Create a replication configuration template
aws drs create-replication-configuration-template \
  --region us-west-2 \
  --staging-area-subnet-id subnet-0abc123def456 \
  --associate-default-security-group \
  --replication-server-instance-type t3.small \
  --use-dedicated-replication-server false \
  --default-large-staging-disk-type GP3 \
  --ebs-encryption DEFAULT \
  --replication-servers-security-groups-ids sg-0abc123 \
  --data-plane-routing PRIVATE_IP \
  --create-public-ip false \
  --bandwidth-throttling 0

# Step 3: On the source server, install the replication agent
# (Run on the on-premises/source server)
# wget -O aws-replication-installer-init \
#   https://aws-elastic-disaster-recovery-{region}.s3.amazonaws.com/latest/linux/aws-replication-installer-init
# chmod +x aws-replication-installer-init
# sudo ./aws-replication-installer-init \
#   --region us-west-2 \
#   --aws-access-key-id AKIA... \
#   --aws-secret-access-key ...

# Step 4: Create launch configuration for recovery instances
aws drs update-launch-configuration \
  --region us-west-2 \
  --source-server-id s-1234567890abcdef0 \
  --target-instance-type-right-sizing-method BASIC \
  --launch-disposition STARTED \
  --licensing '{"osByol": true}' \
  --copy-private-ip false \
  --copy-tags true

# Step 5: Perform a DR drill (non-disruptive test)
aws drs start-recovery \
  --region us-west-2 \
  --is-drill true \
  --source-servers '[{"sourceServerID": "s-1234567890abcdef0"}]'

# Step 6: Perform actual failover
aws drs start-recovery \
  --region us-west-2 \
  --is-drill false \
  --source-servers '[{"sourceServerID": "s-1234567890abcdef0"}]'

# Step 7: After primary site is restored, initiate failback
aws drs start-failback-launch \
  --region us-west-2 \
  --recovery-instance-ids ri-1234567890abcdef0

# Monitor replication status
aws drs describe-source-servers \
  --region us-west-2 \
  --filters '{"sourceServerIDs": ["s-1234567890abcdef0"]}' \
  --query 'items[0].{State:dataReplicationInfo.dataReplicationState,Lag:dataReplicationInfo.replicatedDisks[0].replicatedStorageBytes}'
```

---

## 7. Multi-Region Deployment Pipeline

### CloudFormation: CodePipeline with Cross-Region Deployments

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Multi-region deployment pipeline with approval gate

Parameters:
  RepoName:
    Type: String
    Default: my-app

  BranchName:
    Type: String
    Default: main

  SecondaryRegion:
    Type: String
    Default: eu-west-1

Resources:
  ArtifactBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub pipeline-artifacts-${AWS::AccountId}-${AWS::Region}
      VersioningConfiguration:
        Status: Enabled
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: aws:kms

  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: multi-region-pipeline
      RoleArn: !GetAtt PipelineRole.Arn
      ArtifactStores:
        - Region: !Ref AWS::Region
          ArtifactStore:
            Type: S3
            Location: !Ref ArtifactBucket
        - Region: !Ref SecondaryRegion
          ArtifactStore:
            Type: S3
            Location: !Sub pipeline-artifacts-${AWS::AccountId}-${SecondaryRegion}
      Stages:
        # Source stage
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: CodeCommit
                Version: '1'
              Configuration:
                RepositoryName: !Ref RepoName
                BranchName: !Ref BranchName
                PollForSourceChanges: false
              OutputArtifacts:
                - Name: SourceOutput

        # Build stage
        - Name: Build
          Actions:
            - Name: BuildAction
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref BuildProject
              InputArtifacts:
                - Name: SourceOutput
              OutputArtifacts:
                - Name: BuildOutput

        # Deploy to primary region
        - Name: DeployPrimary
          Actions:
            - Name: DeployToPrimaryRegion
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Region: !Ref AWS::Region
              Configuration:
                ActionMode: CREATE_UPDATE
                StackName: app-stack-primary
                TemplatePath: BuildOutput::template.yaml
                RoleArn: !GetAtt CloudFormationRole.Arn
                Capabilities: CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND
              InputArtifacts:
                - Name: BuildOutput

        # Validation tests in primary
        - Name: ValidatePrimary
          Actions:
            - Name: IntegrationTests
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref IntegrationTestProject
              InputArtifacts:
                - Name: BuildOutput

        # Manual approval before secondary region
        - Name: ApproveSecondaryDeploy
          Actions:
            - Name: ManualApproval
              ActionTypeId:
                Category: Approval
                Owner: AWS
                Provider: Manual
                Version: '1'
              Configuration:
                NotificationArn: !Ref ApprovalSNSTopic
                CustomData: "Approve deployment to secondary region?"

        # Deploy to secondary region
        - Name: DeploySecondary
          Actions:
            - Name: DeployToSecondaryRegion
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Region: !Ref SecondaryRegion
              Configuration:
                ActionMode: CREATE_UPDATE
                StackName: app-stack-secondary
                TemplatePath: BuildOutput::template.yaml
                RoleArn: !GetAtt CloudFormationRole.Arn
                Capabilities: CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND
              InputArtifacts:
                - Name: BuildOutput

        # Update Route 53 weights
        - Name: UpdateDNS
          Actions:
            - Name: UpdateRoute53
              ActionTypeId:
                Category: Invoke
                Owner: AWS
                Provider: Lambda
                Version: '1'
              Configuration:
                FunctionName: !Ref UpdateDNSFunction
              InputArtifacts:
                - Name: BuildOutput

  BuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: app-build
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_MEDIUM
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: buildspec.yml

  IntegrationTestProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: app-integration-tests
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: testspec.yml

  ApprovalSNSTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: pipeline-approval

  UpdateDNSFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: update-route53-weights
      Runtime: python3.12
      Handler: index.handler
      Role: !GetAtt LambdaRole.Arn
      Code:
        ZipFile: |
          import boto3
          import json

          def handler(event, context):
              route53 = boto3.client('route53')
              hosted_zone_id = 'Z1234567890'
              record_name = 'app.example.com'

              response = route53.change_resource_record_sets(
                  HostedZoneId=hosted_zone_id,
                  ChangeBatch={
                      'Changes': [
                          {
                              'Action': 'UPSERT',
                              'ResourceRecordSet': {
                                  'Name': record_name,
                                  'Type': 'A',
                                  'SetIdentifier': 'secondary',
                                  'Weight': 50,
                                  'AliasTarget': {
                                      'HostedZoneId': 'Z32O12XQLNTSW2',
                                      'DNSName': 'alb-secondary.eu-west-1.elb.amazonaws.com',
                                      'EvaluateTargetHealth': True
                                  }
                              }
                          }
                      ]
                  }
              )
              return {'statusCode': 200, 'body': json.dumps(response)}

  # IAM roles (simplified)
  PipelineRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: codepipeline.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess

  CodeBuildRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: codebuild.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AdministratorAccess

  CloudFormationRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: cloudformation.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AdministratorAccess

  LambdaRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: Route53Access
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - route53:ChangeResourceRecordSets
                Resource: '*'
```

---

## 8. ECS Service with Circuit Breaker

### CloudFormation: ECS Fargate Service with Deployment Circuit Breaker and Auto Scaling

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: ECS Fargate service with circuit breaker, Blue/Green readiness, and auto scaling

Parameters:
  ContainerImage:
    Type: String
    Default: '123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest'

  VpcId:
    Type: AWS::EC2::VPC::Id

  PrivateSubnets:
    Type: List<AWS::EC2::Subnet::Id>

  ALBTargetGroupArn:
    Type: String

  ALBSecurityGroupId:
    Type: AWS::EC2::SecurityGroup::Id

Resources:
  ECSCluster:
    Type: AWS::ECS::Cluster
    Properties:
      ClusterName: production-cluster
      ClusterSettings:
        - Name: containerInsights
          Value: enabled
      CapacityProviders:
        - FARGATE
        - FARGATE_SPOT
      DefaultCapacityProviderStrategy:
        - CapacityProvider: FARGATE
          Weight: 1
          Base: 2
        - CapacityProvider: FARGATE_SPOT
          Weight: 3

  TaskDefinition:
    Type: AWS::ECS::TaskDefinition
    Properties:
      Family: my-app
      Cpu: '512'
      Memory: '1024'
      NetworkMode: awsvpc
      RequiresCompatibilities:
        - FARGATE
      ExecutionRoleArn: !GetAtt ECSExecutionRole.Arn
      TaskRoleArn: !GetAtt ECSTaskRole.Arn
      ContainerDefinitions:
        - Name: app
          Image: !Ref ContainerImage
          Essential: true
          PortMappings:
            - ContainerPort: 8080
              Protocol: tcp
          HealthCheck:
            Command:
              - CMD-SHELL
              - curl -f http://localhost:8080/health || exit 1
            Interval: 15
            Timeout: 5
            Retries: 3
            StartPeriod: 60
          LogConfiguration:
            LogDriver: awslogs
            Options:
              awslogs-group: !Ref LogGroup
              awslogs-region: !Ref AWS::Region
              awslogs-stream-prefix: app
          Environment:
            - Name: ENVIRONMENT
              Value: production

  ContainerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: ECS container security group
      VpcId: !Ref VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 8080
          ToPort: 8080
          SourceSecurityGroupId: !Ref ALBSecurityGroupId

  # ECS Service with deployment circuit breaker
  ECSService:
    Type: AWS::ECS::Service
    Properties:
      ServiceName: my-app-service
      Cluster: !Ref ECSCluster
      TaskDefinition: !Ref TaskDefinition
      DesiredCount: 4
      LaunchType: FARGATE
      PlatformVersion: LATEST
      DeploymentConfiguration:
        MinimumHealthyPercent: 100
        MaximumPercent: 200
        DeploymentCircuitBreaker:
          Enable: true
          Rollback: true
      NetworkConfiguration:
        AwsvpcConfiguration:
          Subnets: !Ref PrivateSubnets
          SecurityGroups:
            - !Ref ContainerSecurityGroup
          AssignPublicIp: DISABLED
      LoadBalancers:
        - ContainerName: app
          ContainerPort: 8080
          TargetGroupArn: !Ref ALBTargetGroupArn
      HealthCheckGracePeriodSeconds: 120
      PlacementStrategies:
        - Type: spread
          Field: attribute:ecs.availability-zone

  # Auto Scaling
  ScalableTarget:
    Type: AWS::ApplicationAutoScaling::ScalableTarget
    Properties:
      MaxCapacity: 20
      MinCapacity: 4
      ResourceId: !Sub service/${ECSCluster}/${ECSService.Name}
      ScalableDimension: ecs:service:DesiredCount
      ServiceNamespace: ecs
      RoleARN: !GetAtt AutoScalingRole.Arn

  # CPU-based scaling
  CPUScalingPolicy:
    Type: AWS::ApplicationAutoScaling::ScalingPolicy
    Properties:
      PolicyName: cpu-scaling
      PolicyType: TargetTrackingScaling
      ScalingTargetId: !Ref ScalableTarget
      TargetTrackingScalingPolicyConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ECSServiceAverageCPUUtilization
        TargetValue: 60.0
        ScaleInCooldown: 300
        ScaleOutCooldown: 60

  # Memory-based scaling
  MemoryScalingPolicy:
    Type: AWS::ApplicationAutoScaling::ScalingPolicy
    Properties:
      PolicyName: memory-scaling
      PolicyType: TargetTrackingScaling
      ScalingTargetId: !Ref ScalableTarget
      TargetTrackingScalingPolicyConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ECSServiceAverageMemoryUtilization
        TargetValue: 70.0
        ScaleInCooldown: 300
        ScaleOutCooldown: 60

  # Request count based scaling
  RequestCountScalingPolicy:
    Type: AWS::ApplicationAutoScaling::ScalingPolicy
    Properties:
      PolicyName: request-count-scaling
      PolicyType: TargetTrackingScaling
      ScalingTargetId: !Ref ScalableTarget
      TargetTrackingScalingPolicyConfiguration:
        PredefinedMetricSpecification:
          PredefinedMetricType: ALBRequestCountPerTarget
          ResourceLabel: !Sub
            - "${ALBFullName}/${TGFullName}"
            - ALBFullName: !Select [1, !Split ["loadbalancer/", !Ref ALBTargetGroupArn]]
              TGFullName: !Select [5, !Split [":", !Ref ALBTargetGroupArn]]
        TargetValue: 1000.0
        ScaleInCooldown: 300
        ScaleOutCooldown: 60

  LogGroup:
    Type: AWS::Logs::LogGroup
    Properties:
      LogGroupName: /ecs/my-app
      RetentionInDays: 30

  ECSExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ecs-tasks.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

  ECSTaskRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ecs-tasks.amazonaws.com
            Action: sts:AssumeRole

  AutoScalingRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: application-autoscaling.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole
```

### Step Functions: Saga Pattern with Compensation (Bonus Example)

```json
{
  "Comment": "Order processing saga with compensation",
  "StartAt": "ReserveInventory",
  "States": {
    "ReserveInventory": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:reserve-inventory",
      "ResultPath": "$.inventoryResult",
      "Retry": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "IntervalSeconds": 2,
          "MaxAttempts": 3,
          "BackoffRate": 2.0
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.error",
          "Next": "NotifyFailure"
        }
      ],
      "Next": "ProcessPayment"
    },
    "ProcessPayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:process-payment",
      "ResultPath": "$.paymentResult",
      "Retry": [
        {
          "ErrorEquals": ["PaymentRetryableError"],
          "IntervalSeconds": 5,
          "MaxAttempts": 3,
          "BackoffRate": 2.0
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.error",
          "Next": "ReleaseInventory"
        }
      ],
      "Next": "FulfillOrder"
    },
    "FulfillOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:fulfill-order",
      "ResultPath": "$.fulfillmentResult",
      "Retry": [
        {
          "ErrorEquals": ["States.TaskFailed"],
          "IntervalSeconds": 10,
          "MaxAttempts": 2,
          "BackoffRate": 2.0
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.error",
          "Next": "RefundPayment"
        }
      ],
      "Next": "OrderComplete"
    },
    "OrderComplete": {
      "Type": "Succeed"
    },
    "RefundPayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:refund-payment",
      "ResultPath": "$.refundResult",
      "Next": "ReleaseInventory"
    },
    "ReleaseInventory": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:release-inventory",
      "ResultPath": "$.releaseResult",
      "Next": "NotifyFailure"
    },
    "NotifyFailure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:order-failures",
        "Message.$": "States.Format('Order {} failed: {}', $.orderId, $.error)"
      },
      "Next": "OrderFailed"
    },
    "OrderFailed": {
      "Type": "Fail",
      "Cause": "Order processing failed after compensation"
    }
  }
}
```

### Key Points About the Saga Pattern

- **ReserveInventory → ProcessPayment → FulfillOrder**: The happy path.
- **If ProcessPayment fails**: Catch routes to `ReleaseInventory` (compensating action), then `NotifyFailure`.
- **If FulfillOrder fails**: Catch routes to `RefundPayment` → `ReleaseInventory` → `NotifyFailure`.
- Each compensating step reverses the effects of the previous successful step.
- `Retry` handles transient errors; `Catch` handles persistent failures.

---

*These templates demonstrate exam-relevant patterns. In real implementations, tighten IAM policies to least-privilege and parameterize hardcoded values.*
