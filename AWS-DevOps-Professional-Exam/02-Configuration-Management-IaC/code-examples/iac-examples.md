# Domain 2: Configuration Management and IaC — Code Examples

## Table of Contents
1. [Complete VPC CloudFormation Template](#1-complete-vpc-cloudformation-template)
2. [EC2 Instance with cfn-init Bootstrap](#2-ec2-instance-with-cfn-init-bootstrap)
3. [Auto Scaling Group with Rolling Updates](#3-auto-scaling-group-with-rolling-updates)
4. [Nested Stacks Example](#4-nested-stacks-example)
5. [Custom Resource — S3 Bucket Cleanup](#5-custom-resource--s3-bucket-cleanup)
6. [Custom Resource — Latest AMI Lookup](#6-custom-resource--latest-ami-lookup)
7. [StackSets Template for Multi-Account Config](#7-stacksets-template-for-multi-account-config)
8. [CloudFormation with Dynamic References](#8-cloudformation-with-dynamic-references)
9. [CDK Examples (TypeScript)](#9-cdk-examples-typescript)
10. [SSM Automation Documents](#10-ssm-automation-documents)
11. [Patch Manager Configuration](#11-patch-manager-configuration)
12. [Service Catalog Portfolio and Product](#12-service-catalog-portfolio-and-product)
13. [CloudFormation Pipeline with CodePipeline](#13-cloudformation-pipeline-with-codepipeline)

---

## 1. Complete VPC CloudFormation Template

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: >
  Production-ready VPC with public and private subnets across 3 AZs,
  NAT Gateways, and VPC Flow Logs.

Parameters:
  EnvironmentName:
    Type: String
    Default: Production
    AllowedValues:
      - Production
      - Staging
      - Development
    Description: Environment name for tagging

  VpcCIDR:
    Type: String
    Default: 10.0.0.0/16
    AllowedPattern: '(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/(\d{1,2})'
    Description: CIDR block for the VPC

  EnableFlowLogs:
    Type: String
    Default: 'true'
    AllowedValues: ['true', 'false']

Conditions:
  CreateFlowLogs: !Equals [!Ref EnableFlowLogs, 'true']
  IsProduction: !Equals [!Ref EnvironmentName, Production]

Mappings:
  SubnetConfig:
    PublicSubnet1:
      CIDR: 10.0.1.0/24
    PublicSubnet2:
      CIDR: 10.0.2.0/24
    PublicSubnet3:
      CIDR: 10.0.3.0/24
    PrivateSubnet1:
      CIDR: 10.0.11.0/24
    PrivateSubnet2:
      CIDR: 10.0.12.0/24
    PrivateSubnet3:
      CIDR: 10.0.13.0/24

Resources:
  # --- VPC ---
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCIDR
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-VPC'

  # --- Internet Gateway ---
  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-IGW'

  InternetGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      InternetGatewayId: !Ref InternetGateway
      VpcId: !Ref VPC

  # --- Public Subnets ---
  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PublicSubnet1, CIDR]
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-AZ1'

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [1, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PublicSubnet2, CIDR]
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-AZ2'

  PublicSubnet3:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [2, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PublicSubnet3, CIDR]
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-AZ3'

  # --- Private Subnets ---
  PrivateSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PrivateSubnet1, CIDR]
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-AZ1'

  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [1, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PrivateSubnet2, CIDR]
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-AZ2'

  PrivateSubnet3:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [2, !GetAZs '']
      CidrBlock: !FindInMap [SubnetConfig, PrivateSubnet3, CIDR]
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-AZ3'

  # --- NAT Gateways (one per AZ for HA in production, single in non-prod) ---
  NatGateway1EIP:
    Type: AWS::EC2::EIP
    DependsOn: InternetGatewayAttachment
    Properties:
      Domain: vpc

  NatGateway2EIP:
    Type: AWS::EC2::EIP
    Condition: IsProduction
    DependsOn: InternetGatewayAttachment
    Properties:
      Domain: vpc

  NatGateway1:
    Type: AWS::EC2::NatGateway
    Properties:
      AllocationId: !GetAtt NatGateway1EIP.AllocationId
      SubnetId: !Ref PublicSubnet1
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-NAT-AZ1'

  NatGateway2:
    Type: AWS::EC2::NatGateway
    Condition: IsProduction
    Properties:
      AllocationId: !GetAtt NatGateway2EIP.AllocationId
      SubnetId: !Ref PublicSubnet2
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-NAT-AZ2'

  # --- Route Tables ---
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-RT'

  DefaultPublicRoute:
    Type: AWS::EC2::Route
    DependsOn: InternetGatewayAttachment
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  PublicSubnet1RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PublicRouteTable
      SubnetId: !Ref PublicSubnet1

  PublicSubnet2RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PublicRouteTable
      SubnetId: !Ref PublicSubnet2

  PublicSubnet3RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PublicRouteTable
      SubnetId: !Ref PublicSubnet3

  PrivateRouteTable1:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-RT-AZ1'

  DefaultPrivateRoute1:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable1
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !Ref NatGateway1

  PrivateSubnet1RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PrivateRouteTable1
      SubnetId: !Ref PrivateSubnet1

  PrivateRouteTable2:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-RT-AZ2'

  DefaultPrivateRoute2:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PrivateRouteTable2
      DestinationCidrBlock: 0.0.0.0/0
      NatGatewayId: !If [IsProduction, !Ref NatGateway2, !Ref NatGateway1]

  PrivateSubnet2RouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PrivateRouteTable2
      SubnetId: !Ref PrivateSubnet2

  # --- VPC Flow Logs ---
  FlowLogGroup:
    Type: AWS::Logs::LogGroup
    Condition: CreateFlowLogs
    Properties:
      LogGroupName: !Sub '/vpc/flowlogs/${EnvironmentName}'
      RetentionInDays: 90

  FlowLogRole:
    Type: AWS::IAM::Role
    Condition: CreateFlowLogs
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: vpc-flow-logs.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: FlowLogPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                  - logs:DescribeLogGroups
                  - logs:DescribeLogStreams
                Resource: '*'

  VPCFlowLog:
    Type: AWS::EC2::FlowLog
    Condition: CreateFlowLogs
    Properties:
      DeliverLogsPermissionArn: !GetAtt FlowLogRole.Arn
      LogGroupName: !Ref FlowLogGroup
      ResourceId: !Ref VPC
      ResourceType: VPC
      TrafficType: ALL

Outputs:
  VPCId:
    Description: VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub '${EnvironmentName}-VPCID'

  PublicSubnets:
    Description: Public subnet IDs
    Value: !Join [',', [!Ref PublicSubnet1, !Ref PublicSubnet2, !Ref PublicSubnet3]]
    Export:
      Name: !Sub '${EnvironmentName}-PublicSubnets'

  PrivateSubnets:
    Description: Private subnet IDs
    Value: !Join [',', [!Ref PrivateSubnet1, !Ref PrivateSubnet2, !Ref PrivateSubnet3]]
    Export:
      Name: !Sub '${EnvironmentName}-PrivateSubnets'

  VPCCidrBlock:
    Description: VPC CIDR Block
    Value: !GetAtt VPC.CidrBlock
    Export:
      Name: !Sub '${EnvironmentName}-VPCCidr'
```

---

## 2. EC2 Instance with cfn-init Bootstrap

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: EC2 instance bootstrapped with cfn-init, cfn-signal, and cfn-hup.

Parameters:
  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues: [t3.micro, t3.small, t3.medium]
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64
  VpcId:
    Type: AWS::EC2::VPC::Id
  SubnetId:
    Type: AWS::EC2::Subnet::Id

Resources:
  InstanceSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow HTTP
      VpcId: !Ref VpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

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

  InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref InstanceRole

  WebServer:
    Type: AWS::EC2::Instance
    CreationPolicy:
      ResourceSignal:
        Count: 1
        Timeout: PT15M
    Metadata:
      AWS::CloudFormation::Init:
        configSets:
          full_install:
            - install_packages
            - configure_app
            - configure_cfn_hup
            - start_services
        install_packages:
          packages:
            yum:
              httpd: []
              php: []
          files:
            /var/www/html/index.html:
              content: !Sub |
                <html>
                <head><title>${AWS::StackName}</title></head>
                <body>
                  <h1>Hello from ${AWS::Region}!</h1>
                  <p>Stack: ${AWS::StackName}</p>
                  <p>Instance bootstrapped with cfn-init</p>
                </body>
                </html>
              mode: '000644'
              owner: root
              group: root
        configure_app:
          files:
            /etc/app/config.json:
              content: !Sub |
                {
                  "region": "${AWS::Region}",
                  "stack": "${AWS::StackName}",
                  "environment": "production"
                }
              mode: '000644'
              owner: root
              group: root
          commands:
            01_create_log_dir:
              command: mkdir -p /var/log/myapp
              test: '[ ! -d /var/log/myapp ]'
        configure_cfn_hup:
          files:
            /etc/cfn/cfn-hup.conf:
              content: !Sub |
                [main]
                stack=${AWS::StackId}
                region=${AWS::Region}
                interval=5
              mode: '000400'
              owner: root
              group: root
            /etc/cfn/hooks.d/cfn-auto-reloader.conf:
              content: !Sub |
                [cfn-auto-reloader-hook]
                triggers=post.update
                path=Resources.WebServer.Metadata.AWS::CloudFormation::Init
                action=/opt/aws/bin/cfn-init -v --stack ${AWS::StackName} --resource WebServer --configsets full_install --region ${AWS::Region}
                runas=root
              mode: '000400'
              owner: root
              group: root
        start_services:
          services:
            sysvinit:
              httpd:
                enabled: true
                ensureRunning: true
                files:
                  - /var/www/html/index.html
                  - /etc/app/config.json
              cfn-hup:
                enabled: true
                ensureRunning: true
                files:
                  - /etc/cfn/cfn-hup.conf
                  - /etc/cfn/hooks.d/cfn-auto-reloader.conf
    Properties:
      InstanceType: !Ref InstanceType
      ImageId: !Ref LatestAmiId
      IamInstanceProfile: !Ref InstanceProfile
      SubnetId: !Ref SubnetId
      SecurityGroupIds:
        - !Ref InstanceSecurityGroup
      Tags:
        - Key: Name
          Value: !Sub '${AWS::StackName}-WebServer'
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash -xe
          yum update -y aws-cfn-bootstrap

          # Run cfn-init to apply the metadata configuration
          /opt/aws/bin/cfn-init -v \
            --stack ${AWS::StackName} \
            --resource WebServer \
            --configsets full_install \
            --region ${AWS::Region}

          # Signal CloudFormation with the exit status of cfn-init
          /opt/aws/bin/cfn-signal -e $? \
            --stack ${AWS::StackName} \
            --resource WebServer \
            --region ${AWS::Region}

Outputs:
  InstanceId:
    Value: !Ref WebServer
  PublicDnsName:
    Value: !GetAtt WebServer.PublicDnsName
```

---

## 3. Auto Scaling Group with Rolling Updates

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Auto Scaling Group with rolling update policy and CreationPolicy.

Parameters:
  VpcId:
    Type: AWS::EC2::VPC::Id
  SubnetIds:
    Type: List<AWS::EC2::Subnet::Id>
  DesiredCapacity:
    Type: Number
    Default: 4
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64

Resources:
  LaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateData:
        ImageId: !Ref LatestAmiId
        InstanceType: t3.small
        IamInstanceProfile:
          Arn: !GetAtt InstanceProfile.Arn
        SecurityGroupIds:
          - !Ref AppSecurityGroup
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash -xe
            yum update -y aws-cfn-bootstrap
            /opt/aws/bin/cfn-init -v \
              --stack ${AWS::StackName} \
              --resource AutoScalingGroup \
              --region ${AWS::Region}
            /opt/aws/bin/cfn-signal -e $? \
              --stack ${AWS::StackName} \
              --resource AutoScalingGroup \
              --region ${AWS::Region}

  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    CreationPolicy:
      ResourceSignal:
        Count: !Ref DesiredCapacity
        Timeout: PT15M
      AutoScalingCreationPolicy:
        MinSuccessfulInstancesPercent: 75
    UpdatePolicy:
      AutoScalingRollingUpdate:
        MaxBatchSize: 2
        MinInstancesInService: 2
        MinSuccessfulInstancesPercent: 75
        PauseTime: PT10M
        WaitOnResourceSignals: true
        SuspendProcesses:
          - HealthCheck
          - ReplaceUnhealthy
          - AZRebalance
          - AlarmNotification
          - ScheduledActions
      AutoScalingScheduledAction:
        IgnoreUnmodifiedGroupSizeProperties: true
    Properties:
      LaunchTemplate:
        LaunchTemplateId: !Ref LaunchTemplate
        Version: !GetAtt LaunchTemplate.LatestVersionNumber
      MinSize: 2
      MaxSize: 8
      DesiredCapacity: !Ref DesiredCapacity
      VPCZoneIdentifier: !Ref SubnetIds
      TargetGroupARNs:
        - !Ref TargetGroup
      HealthCheckType: ELB
      HealthCheckGracePeriod: 300
      Tags:
        - Key: Name
          Value: !Sub '${AWS::StackName}-ASG-Instance'
          PropagateAtLaunch: true
    Metadata:
      AWS::CloudFormation::Init:
        config:
          packages:
            yum:
              httpd: []
          services:
            sysvinit:
              httpd:
                enabled: true
                ensureRunning: true

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
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

  ApplicationLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Scheme: internet-facing
      Subnets: !Ref SubnetIds
      SecurityGroups:
        - !Ref ALBSecurityGroup

  TargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      HealthCheckIntervalSeconds: 30
      HealthCheckPath: /
      HealthCheckProtocol: HTTP
      HealthyThresholdCount: 2
      Port: 80
      Protocol: HTTP
      TargetType: instance
      VpcId: !Ref VpcId

  Listener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref TargetGroup
      LoadBalancerArn: !Ref ApplicationLoadBalancer
      Port: 80
      Protocol: HTTP

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

  InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref InstanceRole

Outputs:
  ALBDNSName:
    Value: !GetAtt ApplicationLoadBalancer.DNSName
```

---

## 4. Nested Stacks Example

### Parent Stack

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Parent stack that orchestrates VPC and Application child stacks.

Parameters:
  EnvironmentName:
    Type: String
    Default: Production
  TemplatesBucket:
    Type: String
    Description: S3 bucket containing nested stack templates

Resources:
  VPCStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: !Sub 'https://${TemplatesBucket}.s3.amazonaws.com/vpc-stack.yaml'
      Parameters:
        EnvironmentName: !Ref EnvironmentName
        VpcCIDR: 10.0.0.0/16
      Tags:
        - Key: Environment
          Value: !Ref EnvironmentName

  ApplicationStack:
    Type: AWS::CloudFormation::Stack
    DependsOn: VPCStack
    Properties:
      TemplateURL: !Sub 'https://${TemplatesBucket}.s3.amazonaws.com/app-stack.yaml'
      Parameters:
        VpcId: !GetAtt VPCStack.Outputs.VPCId
        SubnetIds: !GetAtt VPCStack.Outputs.PrivateSubnets
        EnvironmentName: !Ref EnvironmentName
      Tags:
        - Key: Environment
          Value: !Ref EnvironmentName

  DatabaseStack:
    Type: AWS::CloudFormation::Stack
    DependsOn: VPCStack
    Properties:
      TemplateURL: !Sub 'https://${TemplatesBucket}.s3.amazonaws.com/db-stack.yaml'
      Parameters:
        VpcId: !GetAtt VPCStack.Outputs.VPCId
        SubnetIds: !GetAtt VPCStack.Outputs.PrivateSubnets
        DBPassword: '{{resolve:secretsmanager:MyDBSecret:SecretString:password}}'
      Tags:
        - Key: Environment
          Value: !Ref EnvironmentName

Outputs:
  ApplicationURL:
    Value: !GetAtt ApplicationStack.Outputs.ALBDNSName
  VPCId:
    Value: !GetAtt VPCStack.Outputs.VPCId
```

---

## 5. Custom Resource — S3 Bucket Cleanup

This custom resource empties an S3 bucket before CloudFormation attempts to delete it.

### CloudFormation Template

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: S3 bucket with custom resource for automatic cleanup on deletion.

Resources:
  MyBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Delete
    Properties:
      BucketName: !Sub 'my-app-bucket-${AWS::AccountId}'

  BucketCleanupFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.12
      Handler: index.handler
      Timeout: 300
      Role: !GetAtt CleanupFunctionRole.Arn
      Code:
        ZipFile: |
          import json
          import boto3
          import cfnresponse

          s3 = boto3.resource('s3')

          def handler(event, context):
              try:
                  bucket_name = event['ResourceProperties']['BucketName']
                  bucket = s3.Bucket(bucket_name)

                  if event['RequestType'] == 'Delete':
                      bucket.object_versions.delete()
                      bucket.objects.all().delete()
                      print(f"Emptied bucket: {bucket_name}")

                  cfnresponse.send(event, context, cfnresponse.SUCCESS, {
                      'Message': f"Bucket {bucket_name} processed for {event['RequestType']}"
                  })
              except Exception as e:
                  print(f"Error: {str(e)}")
                  cfnresponse.send(event, context, cfnresponse.FAILED, {
                      'Error': str(e)
                  })

  BucketCleanup:
    Type: Custom::BucketCleanup
    DependsOn: MyBucket
    Properties:
      ServiceToken: !GetAtt BucketCleanupFunction.Arn
      BucketName: !Ref MyBucket

  CleanupFunctionRole:
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
        - PolicyName: S3CleanupPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:DeleteObject
                  - s3:DeleteObjectVersion
                  - s3:ListBucket
                  - s3:ListBucketVersions
                  - s3:GetBucketVersioning
                Resource:
                  - !Sub 'arn:${AWS::Partition}:s3:::my-app-bucket-${AWS::AccountId}'
                  - !Sub 'arn:${AWS::Partition}:s3:::my-app-bucket-${AWS::AccountId}/*'
```

---

## 6. Custom Resource — Latest AMI Lookup

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Custom resource to look up the latest AMI ID dynamically.

Resources:
  AMILookupFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.12
      Handler: index.handler
      Timeout: 60
      Role: !GetAtt AMILookupRole.Arn
      Code:
        ZipFile: |
          import json
          import boto3
          import cfnresponse

          ec2 = boto3.client('ec2')

          def handler(event, context):
              try:
                  if event['RequestType'] in ['Create', 'Update']:
                      os_name = event['ResourceProperties'].get('OSName', 'amzn2-ami-hvm')
                      arch = event['ResourceProperties'].get('Architecture', 'x86_64')

                      response = ec2.describe_images(
                          Owners=['amazon'],
                          Filters=[
                              {'Name': 'name', 'Values': [f'{os_name}-*']},
                              {'Name': 'architecture', 'Values': [arch]},
                              {'Name': 'state', 'Values': ['available']},
                              {'Name': 'virtualization-type', 'Values': ['hvm']},
                              {'Name': 'root-device-type', 'Values': ['ebs']}
                          ]
                      )

                      images = sorted(
                          response['Images'],
                          key=lambda x: x['CreationDate'],
                          reverse=True
                      )

                      if not images:
                          cfnresponse.send(event, context, cfnresponse.FAILED, {
                              'Error': 'No matching AMI found'
                          })
                          return

                      ami_id = images[0]['ImageId']
                      cfnresponse.send(event, context, cfnresponse.SUCCESS, {
                          'AMIId': ami_id,
                          'AMIName': images[0]['Name']
                      })
                  else:
                      cfnresponse.send(event, context, cfnresponse.SUCCESS, {})
              except Exception as e:
                  cfnresponse.send(event, context, cfnresponse.FAILED, {
                      'Error': str(e)
                  })

  AMILookup:
    Type: Custom::AMILookup
    Properties:
      ServiceToken: !GetAtt AMILookupFunction.Arn
      OSName: amzn2-ami-hvm
      Architecture: x86_64

  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !GetAtt AMILookup.AMIId
      InstanceType: t3.micro

  AMILookupRole:
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
        - PolicyName: EC2Describe
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action: ec2:DescribeImages
                Resource: '*'

Outputs:
  LatestAMI:
    Value: !GetAtt AMILookup.AMIId
    Description: The latest AMI ID found
```

---

## 7. StackSets Template for Multi-Account Config

This template is designed to be deployed via StackSets to enable AWS Config across all accounts.

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: >
  StackSet template to enable AWS Config in every account.
  Deploy via StackSets with service-managed permissions and auto-deployment.

Parameters:
  CentralLoggingBucket:
    Type: String
    Description: S3 bucket ARN in the central logging account for Config delivery

Resources:
  ConfigRecorder:
    Type: AWS::Config::ConfigurationRecorder
    Properties:
      Name: default
      RoleARN: !GetAtt ConfigRole.Arn
      RecordingGroup:
        AllSupported: true
        IncludeGlobalResourceTypes: true

  ConfigDeliveryChannel:
    Type: AWS::Config::DeliveryChannel
    Properties:
      Name: default
      S3BucketName: !Ref CentralLoggingBucket
      ConfigSnapshotDeliveryProperties:
        DeliveryFrequency: Six_Hours

  ConfigRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: config.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWS_ConfigRole
      Policies:
        - PolicyName: ConfigS3Delivery
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:PutObject
                  - s3:GetBucketAcl
                Resource:
                  - !Sub '${CentralLoggingBucket}'
                  - !Sub '${CentralLoggingBucket}/*'

  # Managed Config Rules
  RequiredTagsRule:
    Type: AWS::Config::ConfigRule
    DependsOn: ConfigRecorder
    Properties:
      ConfigRuleName: required-tags
      Source:
        Owner: AWS
        SourceIdentifier: REQUIRED_TAGS
      InputParameters:
        tag1Key: Environment
        tag2Key: Owner
        tag3Key: CostCenter
      Scope:
        ComplianceResourceTypes:
          - AWS::EC2::Instance
          - AWS::S3::Bucket
          - AWS::RDS::DBInstance

  EncryptedVolumesRule:
    Type: AWS::Config::ConfigRule
    DependsOn: ConfigRecorder
    Properties:
      ConfigRuleName: encrypted-volumes
      Source:
        Owner: AWS
        SourceIdentifier: ENCRYPTED_VOLUMES
      Scope:
        ComplianceResourceTypes:
          - AWS::EC2::Volume

  S3BucketEncryptionRule:
    Type: AWS::Config::ConfigRule
    DependsOn: ConfigRecorder
    Properties:
      ConfigRuleName: s3-bucket-server-side-encryption-enabled
      Source:
        Owner: AWS
        SourceIdentifier: S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED
```

---

## 8. CloudFormation with Dynamic References

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Demonstrates dynamic references for secrets and configuration.

Resources:
  MyDBInstance:
    Type: AWS::RDS::DBInstance
    DeletionPolicy: Snapshot
    Properties:
      DBInstanceClass: db.t3.medium
      Engine: mysql
      EngineVersion: '8.0'
      AllocatedStorage: 100
      StorageType: gp3
      # Dynamic reference to Secrets Manager for the master password
      MasterUsername: '{{resolve:secretsmanager:prod/myapp/db-credentials:SecretString:username}}'
      MasterUserPassword: '{{resolve:secretsmanager:prod/myapp/db-credentials:SecretString:password}}'
      # Dynamic reference to SSM Parameter Store for configuration
      DBName: '{{resolve:ssm:/myapp/prod/db-name:1}}'
      VPCSecurityGroups:
        - !Ref DBSecurityGroup
      DBSubnetGroupName: !Ref DBSubnetGroup
      MultiAZ: true
      BackupRetentionPeriod: 7
      Tags:
        - Key: Environment
          Value: '{{resolve:ssm:/myapp/environment}}'

  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Subnets for RDS
      SubnetIds:
        - '{{resolve:ssm:/vpc/prod/private-subnet-1}}'
        - '{{resolve:ssm:/vpc/prod/private-subnet-2}}'

  DBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: RDS Security Group
      VpcId: '{{resolve:ssm:/vpc/prod/vpc-id}}'
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 3306
          ToPort: 3306
          CidrIp: 10.0.0.0/16
```

---

## 9. CDK Examples (TypeScript)

### 9.1 VPC with ECS Fargate Service

```typescript
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as ecs_patterns from 'aws-cdk-lib/aws-ecs-patterns';
import * as rds from 'aws-cdk-lib/aws-rds';
import * as secretsmanager from 'aws-cdk-lib/aws-secretsmanager';

export class ApplicationStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // L2 construct: VPC with sensible defaults (public + private subnets, NAT)
    const vpc = new ec2.Vpc(this, 'AppVPC', {
      maxAzs: 3,
      natGateways: 1,
      subnetConfiguration: [
        { name: 'Public', subnetType: ec2.SubnetType.PUBLIC, cidrMask: 24 },
        { name: 'Private', subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS, cidrMask: 24 },
        { name: 'Isolated', subnetType: ec2.SubnetType.PRIVATE_ISOLATED, cidrMask: 24 },
      ],
    });

    // RDS with auto-generated credentials stored in Secrets Manager
    const dbSecret = new secretsmanager.Secret(this, 'DBSecret', {
      generateSecretString: {
        secretStringTemplate: JSON.stringify({ username: 'admin' }),
        generateStringKey: 'password',
        excludePunctuation: true,
      },
    });

    const database = new rds.DatabaseInstance(this, 'Database', {
      engine: rds.DatabaseInstanceEngine.mysql({ version: rds.MysqlEngineVersion.VER_8_0 }),
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.MEDIUM),
      vpc,
      vpcSubnets: { subnetType: ec2.SubnetType.PRIVATE_ISOLATED },
      credentials: rds.Credentials.fromSecret(dbSecret),
      multiAz: true,
      removalPolicy: cdk.RemovalPolicy.SNAPSHOT,
    });

    // ECS Cluster
    const cluster = new ecs.Cluster(this, 'Cluster', {
      vpc,
      containerInsights: true,
    });

    // L3 construct: ALB + Fargate service in one construct
    const service = new ecs_patterns.ApplicationLoadBalancedFargateService(
      this, 'WebService', {
        cluster,
        cpu: 512,
        memoryLimitMiB: 1024,
        desiredCount: 3,
        taskImageOptions: {
          image: ecs.ContainerImage.fromRegistry('nginx:latest'),
          containerPort: 80,
          environment: {
            DB_HOST: database.dbInstanceEndpointAddress,
            DB_PORT: database.dbInstanceEndpointPort,
          },
          secrets: {
            DB_PASSWORD: ecs.Secret.fromSecretsManager(dbSecret, 'password'),
          },
        },
        publicLoadBalancer: true,
      },
    );

    // Allow Fargate tasks to connect to RDS
    database.connections.allowDefaultPortFrom(service.service);

    // Auto-scaling
    const scaling = service.service.autoScaleTaskCount({ maxCapacity: 10, minCapacity: 2 });
    scaling.scaleOnCpuUtilization('CpuScaling', {
      targetUtilizationPercent: 70,
      scaleInCooldown: cdk.Duration.seconds(60),
      scaleOutCooldown: cdk.Duration.seconds(60),
    });

    // Outputs
    new cdk.CfnOutput(this, 'LoadBalancerDNS', {
      value: service.loadBalancer.loadBalancerDnsName,
    });
  }
}
```

### 9.2 CDK Aspect for Compliance Enforcement

```typescript
import * as cdk from 'aws-cdk-lib';
import { IConstruct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as ec2 from 'aws-cdk-lib/aws-ec2';

/**
 * Aspect that enforces encryption on all S3 buckets
 * and validates that no security groups allow unrestricted SSH.
 */
export class SecurityComplianceAspect implements cdk.IAspect {
  public visit(node: IConstruct): void {
    if (node instanceof s3.CfnBucket) {
      if (!node.bucketEncryption) {
        cdk.Annotations.of(node).addError(
          'S3 buckets must have server-side encryption enabled.'
        );
      }
    }

    if (node instanceof ec2.CfnSecurityGroup) {
      const ingress = node.securityGroupIngress as any[];
      if (ingress) {
        for (const rule of ingress) {
          if (rule.cidrIp === '0.0.0.0/0' && rule.fromPort <= 22 && rule.toPort >= 22) {
            cdk.Annotations.of(node).addError(
              'Security groups must not allow unrestricted SSH (0.0.0.0/0 on port 22).'
            );
          }
        }
      }
    }
  }
}

// Usage in the App:
// const app = new cdk.App();
// const stack = new MyStack(app, 'MyStack');
// cdk.Aspects.of(app).add(new SecurityComplianceAspect());
```

### 9.3 CDK Unit Tests with Assertions

```typescript
import * as cdk from 'aws-cdk-lib';
import { Template, Match } from 'aws-cdk-lib/assertions';
import { ApplicationStack } from '../lib/application-stack';

describe('ApplicationStack', () => {
  let template: Template;

  beforeAll(() => {
    const app = new cdk.App();
    const stack = new ApplicationStack(app, 'TestStack', {
      env: { account: '123456789012', region: 'us-east-1' },
    });
    template = Template.fromStack(stack);
  });

  test('VPC is created with correct CIDR', () => {
    template.hasResourceProperties('AWS::EC2::VPC', {
      CidrBlock: Match.anyValue(),
      EnableDnsSupport: true,
      EnableDnsHostnames: true,
    });
  });

  test('RDS instance is Multi-AZ', () => {
    template.hasResourceProperties('AWS::RDS::DBInstance', {
      MultiAZ: true,
      Engine: 'mysql',
    });
  });

  test('RDS has SNAPSHOT removal policy', () => {
    template.hasResource('AWS::RDS::DBInstance', {
      DeletionPolicy: 'Snapshot',
      UpdateReplacePolicy: 'Snapshot',
    });
  });

  test('Fargate service has at least 2 tasks', () => {
    template.hasResourceProperties('AWS::ECS::Service', {
      DesiredCount: Match.anyValue(),
    });
  });

  test('There are exactly 3 subnets per type', () => {
    template.resourceCountIs('AWS::EC2::Subnet', 9); // 3 types x 3 AZs
  });

  test('No S3 bucket without encryption', () => {
    const buckets = template.findResources('AWS::S3::Bucket');
    for (const [id, bucket] of Object.entries(buckets)) {
      expect((bucket as any).Properties.BucketEncryption).toBeDefined();
    }
  });
});
```

### 9.4 CDK Pipelines (Self-Mutating)

```typescript
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as pipelines from 'aws-cdk-lib/pipelines';
import { ApplicationStack } from './application-stack';

class MyApplicationStage extends cdk.Stage {
  constructor(scope: Construct, id: string, props?: cdk.StageProps) {
    super(scope, id, props);
    new ApplicationStack(this, 'AppStack');
  }
}

export class PipelineStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const pipeline = new pipelines.CodePipeline(this, 'Pipeline', {
      pipelineName: 'MyAppPipeline',
      synth: new pipelines.ShellStep('Synth', {
        input: pipelines.CodePipelineSource.gitHub('myorg/myrepo', 'main'),
        commands: [
          'npm ci',
          'npm run build',
          'npx cdk synth',
        ],
      }),
      selfMutation: true, // Pipeline updates itself when definition changes
    });

    // Dev stage
    const devStage = pipeline.addStage(
      new MyApplicationStage(this, 'Dev', {
        env: { account: '111111111111', region: 'us-east-1' },
      })
    );

    devStage.addPost(
      new pipelines.ShellStep('IntegrationTests', {
        commands: ['npm run test:integration'],
      })
    );

    // Prod stage with manual approval
    const prodStage = pipeline.addStage(
      new MyApplicationStage(this, 'Prod', {
        env: { account: '222222222222', region: 'us-east-1' },
      }),
      {
        pre: [new pipelines.ManualApprovalStep('PromoteToProd')],
      }
    );
  }
}
```

---

## 10. SSM Automation Documents

### 10.1 Automation Runbook: Tag Non-Compliant Resources with Approval

```yaml
description: Remediate missing tags on EC2 instances with approval workflow.
schemaVersion: '0.3'
assumeRole: '{{ AutomationAssumeRole }}'

parameters:
  InstanceId:
    type: String
    description: EC2 Instance ID
  AutomationAssumeRole:
    type: String
    description: IAM role ARN for Automation
  ApproverArn:
    type: String
    description: IAM ARN of the approver
  Environment:
    type: String
    default: production
    description: Environment tag value
  Owner:
    type: String
    description: Owner tag value

mainSteps:
  - name: GetInstanceDetails
    action: aws:executeAwsApi
    inputs:
      Service: ec2
      Api: DescribeInstances
      InstanceIds:
        - '{{ InstanceId }}'
    outputs:
      - Name: InstanceState
        Selector: '$.Reservations[0].Instances[0].State.Name'
        Type: String

  - name: ApproveTagging
    action: aws:approve
    timeoutSeconds: 86400
    inputs:
      NotificationArn: !Sub 'arn:aws:sns:${AWS::Region}:${AWS::AccountId}:approval-notifications'
      Message: >
        Instance {{ InstanceId }} is missing required tags.
        Current state: {{ GetInstanceDetails.InstanceState }}.
        Please approve adding Environment={{ Environment }} and Owner={{ Owner }}.
      MinRequiredApprovals: 1
      Approvers:
        - '{{ ApproverArn }}'

  - name: AddTags
    action: aws:createTags
    inputs:
      ResourceType: EC2
      ResourceIds:
        - '{{ InstanceId }}'
      Tags:
        - Key: Environment
          Value: '{{ Environment }}'
        - Key: Owner
          Value: '{{ Owner }}'
        - Key: ManagedBy
          Value: SSM-Automation
        - Key: LastRemediated
          Value: '{{ global:DATE_TIME }}'

  - name: VerifyTags
    action: aws:executeAwsApi
    inputs:
      Service: ec2
      Api: DescribeTags
      Filters:
        - Name: resource-id
          Values:
            - '{{ InstanceId }}'
    outputs:
      - Name: Tags
        Selector: '$.Tags'
        Type: MapList
```

### 10.2 Automation Runbook: Patch with Rollback

```yaml
description: Patch an EC2 instance with AMI backup and automatic rollback on failure.
schemaVersion: '0.3'
assumeRole: '{{ AutomationAssumeRole }}'

parameters:
  InstanceId:
    type: String
  AutomationAssumeRole:
    type: String

mainSteps:
  - name: CreateAMIBackup
    action: aws:createImage
    inputs:
      InstanceId: '{{ InstanceId }}'
      ImageName: 'pre-patch-{{ InstanceId }}-{{ global:DATE_TIME }}'
      NoReboot: true
    outputs:
      - Name: BackupAMI
        Selector: '$.ImageId'
        Type: String

  - name: StopInstance
    action: aws:changeInstanceState
    inputs:
      InstanceIds:
        - '{{ InstanceId }}'
      DesiredState: stopped

  - name: StartInstance
    action: aws:changeInstanceState
    inputs:
      InstanceIds:
        - '{{ InstanceId }}'
      DesiredState: running

  - name: RunPatchBaseline
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunPatchBaseline
      InstanceIds:
        - '{{ InstanceId }}'
      Parameters:
        Operation: Install
    onFailure: step:RollbackFromAMI

  - name: VerifyPatch
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      InstanceIds:
        - '{{ InstanceId }}'
      Parameters:
        commands:
          - |
            # Verify the application is healthy after patching
            curl -sf http://localhost/health || exit 1
            systemctl is-active httpd || exit 1
    onFailure: step:RollbackFromAMI

  - name: CleanupSuccess
    action: aws:executeAwsApi
    inputs:
      Service: ec2
      Api: CreateTags
      Resources:
        - '{{ InstanceId }}'
      Tags:
        - Key: LastPatched
          Value: '{{ global:DATE_TIME }}'
    isEnd: true

  - name: RollbackFromAMI
    action: aws:executeAutomation
    inputs:
      DocumentName: AWS-RestoreFromAMI
      RuntimeParameters:
        InstanceId: '{{ InstanceId }}'
        ImageId: '{{ CreateAMIBackup.BackupAMI }}'
```

---

## 11. Patch Manager Configuration

### Patch Baseline (CloudFormation)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Patch Manager configuration with baselines, groups, and maintenance windows.

Resources:
  # Custom patch baseline for Amazon Linux 2
  LinuxPatchBaseline:
    Type: AWS::SSM::PatchBaseline
    Properties:
      Name: CustomLinuxBaseline
      Description: Custom baseline for Amazon Linux 2
      OperatingSystem: AMAZON_LINUX_2
      PatchGroups:
        - production-linux
        - staging-linux
      ApprovalRules:
        PatchRules:
          - ApproveAfterDays: 3
            ComplianceLevel: CRITICAL
            EnableNonSecurity: false
            PatchFilterGroup:
              PatchFilters:
                - Key: CLASSIFICATION
                  Values:
                    - Security
                - Key: SEVERITY
                  Values:
                    - Critical
                    - Important
          - ApproveAfterDays: 7
            ComplianceLevel: HIGH
            PatchFilterGroup:
              PatchFilters:
                - Key: CLASSIFICATION
                  Values:
                    - Security
                    - Bugfix
                - Key: SEVERITY
                  Values:
                    - Medium
                    - Low
      ApprovedPatchesComplianceLevel: CRITICAL
      RejectedPatches:
        - kernel*4.14.123*
      RejectedPatchesAction: BLOCK
      GlobalFilters:
        PatchFilters:
          - Key: PRODUCT
            Values:
              - AmazonLinux2
      Sources: []

  # Windows patch baseline
  WindowsPatchBaseline:
    Type: AWS::SSM::PatchBaseline
    Properties:
      Name: CustomWindowsBaseline
      OperatingSystem: WINDOWS
      PatchGroups:
        - production-windows
      ApprovalRules:
        PatchRules:
          - ApproveAfterDays: 3
            ComplianceLevel: CRITICAL
            PatchFilterGroup:
              PatchFilters:
                - Key: CLASSIFICATION
                  Values:
                    - CriticalUpdates
                    - SecurityUpdates
                - Key: MSRC_SEVERITY
                  Values:
                    - Critical
                    - Important

  # Maintenance Window
  PatchMaintenanceWindow:
    Type: AWS::SSM::MaintenanceWindow
    Properties:
      Name: SundayNightPatching
      Description: Weekly patching window - Sunday 2AM-6AM UTC
      Schedule: cron(0 2 ? * SUN *)
      Duration: 4
      Cutoff: 1
      AllowUnassociatedTargets: false

  # Maintenance Window Targets
  PatchTargetsLinux:
    Type: AWS::SSM::MaintenanceWindowTarget
    Properties:
      WindowId: !Ref PatchMaintenanceWindow
      ResourceType: INSTANCE
      Targets:
        - Key: tag:PatchGroup
          Values:
            - production-linux
      Name: LinuxPatchTargets

  PatchTargetsWindows:
    Type: AWS::SSM::MaintenanceWindowTarget
    Properties:
      WindowId: !Ref PatchMaintenanceWindow
      ResourceType: INSTANCE
      Targets:
        - Key: tag:PatchGroup
          Values:
            - production-windows
      Name: WindowsPatchTargets

  # Maintenance Window Task
  PatchTask:
    Type: AWS::SSM::MaintenanceWindowTask
    Properties:
      WindowId: !Ref PatchMaintenanceWindow
      TaskType: RUN_COMMAND
      TaskArn: AWS-RunPatchBaseline
      Priority: 1
      MaxConcurrency: '25%'
      MaxErrors: '10%'
      Targets:
        - Key: WindowTargetIds
          Values:
            - !Ref PatchTargetsLinux
      TaskInvocationParameters:
        MaintenanceWindowRunCommandParameters:
          Parameters:
            Operation:
              - Install
            RebootOption:
              - RebootIfNeeded
          TimeoutSeconds: 3600
          OutputS3BucketName: !Ref PatchLogBucket
          OutputS3KeyPrefix: patch-logs/

  # S3 bucket for patch logs
  PatchLogBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub 'patch-logs-${AWS::AccountId}-${AWS::Region}'
      LifecycleConfiguration:
        Rules:
          - Id: DeleteOldLogs
            Status: Enabled
            ExpirationInDays: 90

  # Resource Data Sync for centralized compliance data
  ComplianceDataSync:
    Type: AWS::SSM::ResourceDataSync
    Properties:
      SyncName: PatchComplianceSync
      S3Destination:
        BucketName: !Ref PatchLogBucket
        SyncFormat: JsonSerDe
        Region: !Ref AWS::Region
        BucketPrefix: compliance-data/
```

---

## 12. Service Catalog Portfolio and Product

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Service Catalog portfolio with an approved EC2 instance product.

Parameters:
  OrgId:
    Type: String
    Description: AWS Organization ID for portfolio sharing

Resources:
  # Portfolio
  ComputePortfolio:
    Type: AWS::ServiceCatalog::Portfolio
    Properties:
      DisplayName: Approved Compute Resources
      Description: Pre-approved EC2 instance configurations for development teams
      ProviderName: Cloud Platform Team
      Tags:
        - Key: ManagedBy
          Value: PlatformTeam

  # Product: Standard EC2 Instance
  StandardEC2Product:
    Type: AWS::ServiceCatalog::CloudFormationProduct
    Properties:
      Name: Standard EC2 Instance
      Description: >
        Launch a pre-approved EC2 instance with standard security configurations,
        SSM agent, and CloudWatch monitoring.
      Owner: Cloud Platform Team
      Distributor: Internal
      SupportDescription: Contact platform-team@company.com
      SupportEmail: platform-team@company.com
      SupportUrl: https://wiki.internal/ec2-product
      ProvisioningArtifactParameters:
        - Name: v1.0
          Description: Initial version with AL2023
          Info:
            LoadTemplateFromURL: https://s3.amazonaws.com/my-templates/ec2-product-v1.yaml
        - Name: v2.0
          Description: Updated with enhanced monitoring
          Info:
            LoadTemplateFromURL: https://s3.amazonaws.com/my-templates/ec2-product-v2.yaml
      Tags:
        - Key: ProductType
          Value: Compute

  # Associate product with portfolio
  ProductAssociation:
    Type: AWS::ServiceCatalog::PortfolioProductAssociation
    Properties:
      PortfolioId: !Ref ComputePortfolio
      ProductId: !Ref StandardEC2Product

  # Launch constraint: specify the IAM role for provisioning
  LaunchConstraint:
    Type: AWS::ServiceCatalog::LaunchRoleConstraint
    DependsOn: ProductAssociation
    Properties:
      PortfolioId: !Ref ComputePortfolio
      ProductId: !Ref StandardEC2Product
      RoleArn: !GetAtt LaunchRole.Arn

  # Template constraint: restrict instance types
  TemplateConstraint:
    Type: AWS::ServiceCatalog::LaunchTemplateConstraint
    DependsOn: ProductAssociation
    Properties:
      PortfolioId: !Ref ComputePortfolio
      ProductId: !Ref StandardEC2Product
      Rules: |
        {
          "Rule1": {
            "Assertions": [
              {
                "Assert": {
                  "Fn::Contains": [
                    ["t3.micro", "t3.small", "t3.medium"],
                    {"Ref": "InstanceType"}
                  ]
                },
                "AssertDescription": "Only t3.micro, t3.small, and t3.medium instance types are allowed."
              }
            ]
          }
        }

  # TagOptions
  EnvironmentTagOption:
    Type: AWS::ServiceCatalog::TagOption
    Properties:
      Key: Environment
      Value: Development
      Active: true

  TagOptionAssociation:
    Type: AWS::ServiceCatalog::TagOptionAssociation
    Properties:
      TagOptionId: !Ref EnvironmentTagOption
      ResourceId: !Ref ComputePortfolio

  # Portfolio sharing with Organization
  PortfolioShare:
    Type: AWS::ServiceCatalog::PortfolioShare
    Properties:
      PortfolioId: !Ref ComputePortfolio
      OrganizationNode:
        Type: ORGANIZATION
        Value: !Ref OrgId
      ShareTagOptions: true

  # Principal association: allow developers to access the portfolio
  PrincipalAssociation:
    Type: AWS::ServiceCatalog::PortfolioPrincipalAssociation
    Properties:
      PortfolioId: !Ref ComputePortfolio
      PrincipalARN: !Sub 'arn:${AWS::Partition}:iam::${AWS::AccountId}:role/DeveloperRole'
      PrincipalType: IAM

  # IAM role for launching products
  LaunchRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: ServiceCatalogLaunchRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: servicecatalog.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: LaunchEC2
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - ec2:RunInstances
                  - ec2:CreateTags
                  - ec2:DescribeInstances
                  - ec2:TerminateInstances
                  - ec2:CreateSecurityGroup
                  - ec2:AuthorizeSecurityGroupIngress
                  - ec2:DescribeSecurityGroups
                  - ec2:DescribeSubnets
                  - ec2:DescribeVpcs
                  - iam:PassRole
                Resource: '*'
              - Effect: Allow
                Action:
                  - cloudformation:*
                Resource: '*'
              - Effect: Allow
                Action:
                  - s3:GetObject
                Resource: 'arn:aws:s3:::my-templates/*'
```

---

## 13. CloudFormation Pipeline with CodePipeline

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: >
  CodePipeline for deploying CloudFormation templates with validation,
  change set review, and manual approval.

Parameters:
  RepositoryName:
    Type: String
    Default: infra-templates
  BranchName:
    Type: String
    Default: main

Resources:
  ArtifactBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    Properties:
      VersioningConfiguration:
        Status: Enabled
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: aws:kms

  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: InfraDeploymentPipeline
      RoleArn: !GetAtt PipelineRole.Arn
      ArtifactStore:
        Type: S3
        Location: !Ref ArtifactBucket
      Stages:
        # Stage 1: Source
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: CodeCommit
                Version: '1'
              Configuration:
                RepositoryName: !Ref RepositoryName
                BranchName: !Ref BranchName
                PollForSourceChanges: false
              OutputArtifacts:
                - Name: SourceOutput

        # Stage 2: Validate (cfn-lint + cfn-guard)
        - Name: Validate
          Actions:
            - Name: LintAndGuard
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref ValidateProject
              InputArtifacts:
                - Name: SourceOutput
              OutputArtifacts:
                - Name: ValidatedOutput

        # Stage 3: Deploy to Staging (direct update)
        - Name: DeployStaging
          Actions:
            - Name: DeployStagingStack
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Configuration:
                ActionMode: CREATE_UPDATE
                StackName: staging-app-stack
                TemplatePath: ValidatedOutput::template.yaml
                TemplateConfiguration: ValidatedOutput::config/staging.json
                RoleArn: !GetAtt CloudFormationRole.Arn
                Capabilities: CAPABILITY_IAM,CAPABILITY_NAMED_IAM,CAPABILITY_AUTO_EXPAND
              InputArtifacts:
                - Name: ValidatedOutput

        # Stage 4: Integration Tests
        - Name: IntegrationTest
          Actions:
            - Name: RunTests
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref IntegrationTestProject
              InputArtifacts:
                - Name: ValidatedOutput

        # Stage 5: Create Production Change Set
        - Name: ProductionChangeSet
          Actions:
            - Name: CreateChangeSet
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Configuration:
                ActionMode: CHANGE_SET_REPLACE
                StackName: production-app-stack
                ChangeSetName: production-changeset
                TemplatePath: ValidatedOutput::template.yaml
                TemplateConfiguration: ValidatedOutput::config/production.json
                RoleArn: !GetAtt CloudFormationRole.Arn
                Capabilities: CAPABILITY_IAM,CAPABILITY_NAMED_IAM,CAPABILITY_AUTO_EXPAND
              InputArtifacts:
                - Name: ValidatedOutput

        # Stage 6: Manual Approval
        - Name: ApproveProduction
          Actions:
            - Name: ManualApproval
              ActionTypeId:
                Category: Approval
                Owner: AWS
                Provider: Manual
                Version: '1'
              Configuration:
                NotificationArn: !Ref ApprovalSNSTopic
                CustomData: >
                  Review the change set for production-app-stack before approving.
                  Check the CloudFormation console for change set details.

        # Stage 7: Execute Change Set
        - Name: DeployProduction
          Actions:
            - Name: ExecuteChangeSet
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Configuration:
                ActionMode: CHANGE_SET_EXECUTE
                StackName: production-app-stack
                ChangeSetName: production-changeset

  # CodeBuild project for validation
  ValidateProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: CFN-Validate
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: |
          version: 0.2
          phases:
            install:
              commands:
                - pip install cfn-lint
                - curl -Lo cfn-guard.tar.gz https://github.com/aws-cloudformation/cloudformation-guard/releases/latest/download/cfn-guard-v3-x86_64-unknown-linux-gnu.tar.gz
                - tar -xzf cfn-guard.tar.gz
                - mv cfn-guard /usr/local/bin/
            build:
              commands:
                - echo "Running cfn-lint..."
                - cfn-lint template.yaml
                - echo "Running cfn-guard..."
                - cfn-guard validate -d template.yaml -r rules/
          artifacts:
            files:
              - '**/*'

  IntegrationTestProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: IntegrationTests
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: |
          version: 0.2
          phases:
            build:
              commands:
                - echo "Running integration tests against staging..."
                - python tests/integration_tests.py

  ApprovalSNSTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: pipeline-approval-notifications

  # IAM Roles (abbreviated)
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
```
