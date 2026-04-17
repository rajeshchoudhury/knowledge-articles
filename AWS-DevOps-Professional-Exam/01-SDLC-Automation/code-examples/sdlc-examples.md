# Domain 1: SDLC Automation — Code Examples

> Reference examples for buildspec.yml, appspec.yml, CloudFormation pipeline templates, lifecycle hook scripts, and cross-account pipeline configurations.

---

## Table of Contents

1. [buildspec.yml Examples](#1-buildspecyml-examples)
2. [appspec.yml Examples](#2-appspecyml-examples)
3. [CodePipeline CloudFormation Templates](#3-codepipeline-cloudformation-templates)
4. [CodeDeploy Lifecycle Hook Scripts](#4-codedeploy-lifecycle-hook-scripts)
5. [Cross-Account Pipeline](#5-cross-account-pipeline)

---

## 1. buildspec.yml Examples

### 1.1 Standard Java Application Build

```yaml
version: 0.2

env:
  variables:
    JAVA_HOME: "/usr/lib/jvm/java-17-amazon-corretto"
  parameter-store:
    SONAR_TOKEN: "/codebuild/sonar-token"

phases:
  install:
    runtime-versions:
      java: corretto17
  pre_build:
    commands:
      - echo "Running unit tests..."
      - mvn test
  build:
    commands:
      - echo "Building application..."
      - mvn package -DskipTests
  post_build:
    commands:
      - echo "Build completed on $(date)"

artifacts:
  files:
    - target/my-app.jar
    - appspec.yml
    - scripts/**/*
  discard-paths: no

reports:
  unit-tests:
    files:
      - "target/surefire-reports/*.xml"
    file-format: JUNITXML

cache:
  paths:
    - "/root/.m2/**/*"
```

### 1.2 Docker Image Build with ECR Push

```yaml
version: 0.2

env:
  variables:
    AWS_ACCOUNT_ID: "123456789012"
    AWS_REGION: "us-east-1"
    IMAGE_REPO_NAME: "my-application"
    IMAGE_TAG: "latest"
  exported-variables:
    - IMAGE_URI

phases:
  pre_build:
    commands:
      - echo "Logging in to ECR..."
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}
      - IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
  build:
    commands:
      - echo "Building Docker image..."
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $IMAGE_URI
  post_build:
    commands:
      - echo "Pushing Docker image to ECR..."
      - docker push $IMAGE_URI
      - printf '{"ImageURI":"%s"}' $IMAGE_URI > imageDetail.json

artifacts:
  files:
    - imageDetail.json
    - appspec.yaml
    - taskdef.json
```

> **Exam Tip:** The `imageDetail.json` file is used by CodePipeline's ECS deploy action to know which image to deploy. The `taskdef.json` is the ECS task definition with a `<IMAGE1_NAME>` placeholder that CodePipeline replaces with the actual image URI.

### 1.3 Build with S3 and Docker Layer Caching

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
  pre_build:
    commands:
      - echo "Installing dependencies..."
      - npm ci
  build:
    commands:
      - echo "Running tests..."
      - npm test
      - echo "Building application..."
      - npm run build
  post_build:
    commands:
      - echo "Build complete"

artifacts:
  files:
    - "build/**/*"
    - "package.json"
    - "node_modules/**/*"
  base-directory: "."

cache:
  paths:
    - "node_modules/**/*"
    - "/root/.npm/**/*"
```

**CodeBuild project configuration for Docker layer caching:**

```json
{
  "cache": {
    "type": "LOCAL",
    "modes": [
      "LOCAL_DOCKER_LAYER_CACHE",
      "LOCAL_SOURCE_CACHE",
      "LOCAL_CUSTOM_CACHE"
    ]
  }
}
```

> **Exam Tip:** Docker layer caching (`LOCAL_DOCKER_LAYER_CACHE`) is configured at the **CodeBuild project level**, not in the buildspec. The buildspec `cache.paths` section is for **S3 caching** of files/directories.

### 1.4 Build with Test Reports and Code Coverage

```yaml
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - pip install -r requirements.txt
      - pip install pytest pytest-cov coverage
  build:
    commands:
      - echo "Running tests with coverage..."
      - pytest --junitxml=reports/junit.xml --cov=src --cov-report=xml:reports/coverage.xml tests/
    on-failure: CONTINUE
  post_build:
    commands:
      - echo "Test phase complete. Check reports for results."

artifacts:
  files:
    - "**/*"
  base-directory: "dist"

reports:
  pytest-reports:
    files:
      - "junit.xml"
    base-directory: "reports"
    file-format: JUNITXML
  coverage-reports:
    files:
      - "coverage.xml"
    base-directory: "reports"
    file-format: COBERTURAXML
```

> **Exam Tip:** `on-failure: CONTINUE` in the build phase means the `post_build` phase runs even if tests fail. This is useful when you want to publish test reports regardless of pass/fail. Without it, the default `on-failure: ABORT` skips `post_build` on failure.

### 1.5 Multi-Architecture Batch Build

```yaml
version: 0.2

batch:
  fast-fail: true
  build-matrix:
    static:
      ignore-failure: false
    dynamic:
      env:
        image:
          - aws/codebuild/amazonlinux2-x86_64-standard:5.0
          - aws/codebuild/amazonlinux2-aarch64-standard:3.0
        type:
          - LINUX_CONTAINER
          - ARM_CONTAINER
        compute-type:
          - BUILD_GENERAL1_SMALL

phases:
  pre_build:
    commands:
      - echo "Architecture: $(uname -m)"
      - ARCH=$(uname -m)
      - aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REPO
  build:
    commands:
      - docker build -t $IMAGE_REPO:$ARCH .
      - docker push $IMAGE_REPO:$ARCH
  post_build:
    commands:
      - echo "Push complete for $ARCH"
```

### 1.6 CodeBuild with VPC Access and Secrets Manager

```yaml
version: 0.2

env:
  secrets-manager:
    DB_PASSWORD: "prod/database/credentials:password"
    DB_HOST: "prod/database/credentials:host"
  parameter-store:
    DB_NAME: "/app/config/db-name"

phases:
  install:
    runtime-versions:
      python: 3.11
    commands:
      - pip install -r requirements.txt
  pre_build:
    commands:
      - echo "Running database migrations..."
      - python manage.py migrate --database-host=$DB_HOST --database-name=$DB_NAME
  build:
    commands:
      - echo "Running integration tests against database..."
      - pytest tests/integration/ --db-host=$DB_HOST --db-name=$DB_NAME
  post_build:
    commands:
      - echo "Integration tests complete"

reports:
  integration-tests:
    files:
      - "test-results/*.xml"
    file-format: JUNITXML
```

**CodeBuild project VPC configuration (CloudFormation):**

```yaml
  IntegrationTestProject:
    Type: AWS::CodeBuild::Project
    Properties:
      VpcConfig:
        VpcId: !Ref VpcId
        Subnets:
          - !Ref PrivateSubnet1
          - !Ref PrivateSubnet2
        SecurityGroupIds:
          - !Ref CodeBuildSecurityGroup
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
        PrivilegedMode: false
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Source:
        Type: CODEPIPELINE
        BuildSpec: buildspec-integration.yml
```

> **Exam Tip:** CodeBuild in a VPC uses **private subnets**. For internet access (e.g., downloading packages), the private subnets must route through a **NAT Gateway**. The security group must allow outbound traffic to required resources.

---

## 2. appspec.yml Examples

### 2.1 EC2/On-Premises — Standard Web Application

```yaml
version: 0.0
os: linux

files:
  - source: /app
    destination: /var/www/myapp
    overwrite: true
  - source: /config/nginx.conf
    destination: /etc/nginx/sites-available/myapp

permissions:
  - object: /var/www/myapp
    owner: www-data
    group: www-data
    mode: "755"
    type:
      - directory
  - object: /var/www/myapp
    owner: www-data
    group: www-data
    mode: "644"
    pattern: "**"
    type:
      - file

hooks:
  ApplicationStop:
    - location: scripts/stop_server.sh
      timeout: 120
      runas: root

  BeforeInstall:
    - location: scripts/before_install.sh
      timeout: 300
      runas: root

  AfterInstall:
    - location: scripts/after_install.sh
      timeout: 300
      runas: root

  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 120
      runas: root

  ValidateService:
    - location: scripts/validate_service.sh
      timeout: 300
      runas: root
```

### 2.2 EC2/On-Premises — Windows Application

```yaml
version: 0.0
os: windows

files:
  - source: \app
    destination: C:\inetpub\wwwroot\myapp

hooks:
  ApplicationStop:
    - location: scripts\stop_app.ps1
      timeout: 120

  BeforeInstall:
    - location: scripts\before_install.ps1
      timeout: 300

  AfterInstall:
    - location: scripts\after_install.ps1
      timeout: 300

  ApplicationStart:
    - location: scripts\start_app.ps1
      timeout: 120

  ValidateService:
    - location: scripts\validate.ps1
      timeout: 300
```

### 2.3 Amazon ECS — Blue/Green Deployment

```yaml
version: 0.0

Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "<TASK_DEFINITION>"
        LoadBalancerInfo:
          ContainerName: "my-web-app"
          ContainerPort: 8080
        PlatformVersion: "LATEST"
        NetworkConfiguration:
          AwsvpcConfiguration:
            Subnets:
              - "subnet-0123456789abcdef0"
              - "subnet-0123456789abcdef1"
            SecurityGroups:
              - "sg-0123456789abcdef0"
            AssignPublicIp: "DISABLED"
        CapacityProviderStrategy:
          - Base: 1
            CapacityProvider: "FARGATE"
            Weight: 1

Hooks:
  - BeforeInstall: "arn:aws:lambda:us-east-1:123456789012:function:BeforeInstallHook"
  - AfterInstall: "arn:aws:lambda:us-east-1:123456789012:function:AfterInstallHook"
  - AfterAllowTestTraffic: "arn:aws:lambda:us-east-1:123456789012:function:RunIntegrationTests"
  - BeforeAllowTraffic: "arn:aws:lambda:us-east-1:123456789012:function:BeforeTrafficHook"
  - AfterAllowTraffic: "arn:aws:lambda:us-east-1:123456789012:function:AfterTrafficHook"
```

> **Exam Tip:** The `<TASK_DEFINITION>` placeholder is replaced by CodePipeline's ECS deploy action with the actual task definition ARN. The `ContainerName` and `ContainerPort` must match the container definition in the task definition. ECS hooks reference **Lambda function ARNs**, not script file paths.

### 2.4 ECS taskdef.json (Used with ECS Deploy Action)

```json
{
  "family": "my-web-app",
  "networkMode": "awsvpc",
  "executionRoleArn": "arn:aws:iam::123456789012:role/ecsTaskExecutionRole",
  "taskRoleArn": "arn:aws:iam::123456789012:role/ecsTaskRole",
  "containerDefinitions": [
    {
      "name": "my-web-app",
      "image": "<IMAGE1_NAME>",
      "portMappings": [
        {
          "containerPort": 8080,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/my-web-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ],
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024"
}
```

> **Exam Tip:** `<IMAGE1_NAME>` is a placeholder that CodePipeline's ECS (Blue/Green) deploy action replaces with the actual image URI from the `imageDetail.json` produced by the build stage.

### 2.5 AWS Lambda — Canary Deployment

```yaml
version: 0.0

Resources:
  - MyLambdaFunction:
      Type: AWS::Lambda::Function
      Properties:
        Name: "my-api-handler"
        Alias: "live"
        CurrentVersion: "3"
        TargetVersion: "4"

Hooks:
  - BeforeAllowTraffic: "arn:aws:lambda:us-east-1:123456789012:function:PreTrafficValidation"
  - AfterAllowTraffic: "arn:aws:lambda:us-east-1:123456789012:function:PostTrafficValidation"
```

> **Exam Tip:** Lambda CodeDeploy deployment shifts traffic between `CurrentVersion` and `TargetVersion` on the specified `Alias`. The alias acts as a stable endpoint while traffic gradually shifts from one version to another.

---

## 3. CodePipeline CloudFormation Templates

### 3.1 Basic Pipeline — Source → Build → Deploy (EC2 via CodeDeploy)

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: "CodePipeline with CodeCommit, CodeBuild, and CodeDeploy"

Parameters:
  RepositoryName:
    Type: String
    Default: "my-application"
  BranchName:
    Type: String
    Default: "main"
  CodeDeployApplicationName:
    Type: String
  CodeDeployDeploymentGroupName:
    Type: String

Resources:

  ArtifactBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: aws:kms
              KMSMasterKeyID: !GetAtt PipelineKMSKey.Arn
      VersioningConfiguration:
        Status: Enabled

  PipelineKMSKey:
    Type: AWS::KMS::Key
    Properties:
      Description: "KMS key for CodePipeline artifacts"
      KeyPolicy:
        Version: "2012-10-17"
        Statement:
          - Sid: "Enable IAM policies"
            Effect: Allow
            Principal:
              AWS: !Sub "arn:aws:iam::${AWS::AccountId}:root"
            Action: "kms:*"
            Resource: "*"

  PipelineRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: codepipeline.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: PipelinePolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
                  - s3:GetBucketVersioning
                Resource:
                  - !GetAtt ArtifactBucket.Arn
                  - !Sub "${ArtifactBucket.Arn}/*"
              - Effect: Allow
                Action:
                  - kms:Decrypt
                  - kms:DescribeKey
                  - kms:Encrypt
                  - kms:GenerateDataKey
                Resource: !GetAtt PipelineKMSKey.Arn
              - Effect: Allow
                Action:
                  - codecommit:GetBranch
                  - codecommit:GetCommit
                  - codecommit:UploadArchive
                  - codecommit:GetUploadArchiveStatus
                  - codecommit:CancelUploadArchive
                Resource: !Sub "arn:aws:codecommit:${AWS::Region}:${AWS::AccountId}:${RepositoryName}"
              - Effect: Allow
                Action:
                  - codebuild:BatchGetBuilds
                  - codebuild:StartBuild
                Resource: !GetAtt BuildProject.Arn
              - Effect: Allow
                Action:
                  - codedeploy:CreateDeployment
                  - codedeploy:GetApplication
                  - codedeploy:GetApplicationRevision
                  - codedeploy:GetDeployment
                  - codedeploy:GetDeploymentConfig
                  - codedeploy:RegisterApplicationRevision
                Resource: "*"

  CodeBuildRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: codebuild.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: CodeBuildPolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                Resource: "*"
              - Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
                Resource: !Sub "${ArtifactBucket.Arn}/*"
              - Effect: Allow
                Action:
                  - kms:Decrypt
                  - kms:DescribeKey
                  - kms:Encrypt
                  - kms:GenerateDataKey
                Resource: !GetAtt PipelineKMSKey.Arn

  BuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: !Sub "${RepositoryName}-build"
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:5.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: buildspec.yml
      EncryptionKey: !GetAtt PipelineKMSKey.Arn

  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: !Sub "${RepositoryName}-pipeline"
      RoleArn: !GetAtt PipelineRole.Arn
      PipelineType: V2
      ArtifactStore:
        Type: S3
        Location: !Ref ArtifactBucket
        EncryptionKey:
          Id: !GetAtt PipelineKMSKey.Arn
          Type: KMS
      Stages:
        - Name: Source
          Actions:
            - Name: CodeCommitSource
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: CodeCommit
                Version: "1"
              OutputArtifacts:
                - Name: SourceArtifact
              Configuration:
                RepositoryName: !Ref RepositoryName
                BranchName: !Ref BranchName
                PollForSourceChanges: false
              RunOrder: 1

        - Name: Build
          Actions:
            - Name: CodeBuild
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: "1"
              InputArtifacts:
                - Name: SourceArtifact
              OutputArtifacts:
                - Name: BuildArtifact
              Configuration:
                ProjectName: !Ref BuildProject
              RunOrder: 1

        - Name: Approval
          Actions:
            - Name: ManualApproval
              ActionTypeId:
                Category: Approval
                Owner: AWS
                Provider: Manual
                Version: "1"
              Configuration:
                CustomData: "Please review the build output and approve for deployment."
              RunOrder: 1

        - Name: Deploy
          Actions:
            - Name: CodeDeploy
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CodeDeploy
                Version: "1"
              InputArtifacts:
                - Name: BuildArtifact
              Configuration:
                ApplicationName: !Ref CodeDeployApplicationName
                DeploymentGroupName: !Ref CodeDeployDeploymentGroupName
              RunOrder: 1

      Triggers:
        - ProviderType: CodeStarSourceConnection
          GitConfiguration:
            SourceActionName: CodeCommitSource
            Push:
              - Branches:
                  Includes:
                    - main
```

### 3.2 ECS Blue/Green Pipeline

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: "CodePipeline for ECS Blue/Green deployment"

Parameters:
  RepositoryName:
    Type: String
  ECSClusterName:
    Type: String
  ECSServiceName:
    Type: String
  CodeDeployAppName:
    Type: String
  CodeDeployDGName:
    Type: String

Resources:

  ArtifactBucket:
    Type: AWS::S3::Bucket
    Properties:
      VersioningConfiguration:
        Status: Enabled

  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: !Sub "${RepositoryName}-ecs-pipeline"
      PipelineType: V2
      RoleArn: !GetAtt PipelineRole.Arn
      ArtifactStore:
        Type: S3
        Location: !Ref ArtifactBucket
      Stages:
        - Name: Source
          Actions:
            - Name: ECRSource
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: ECR
                Version: "1"
              OutputArtifacts:
                - Name: ECRSourceArtifact
              Configuration:
                RepositoryName: !Ref RepositoryName
                ImageTag: latest
              RunOrder: 1
            - Name: CodeCommitSource
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: CodeCommit
                Version: "1"
              OutputArtifacts:
                - Name: ConfigArtifact
              Configuration:
                RepositoryName: !Sub "${RepositoryName}-config"
                BranchName: main
                PollForSourceChanges: false
              RunOrder: 1

        - Name: Deploy
          Actions:
            - Name: ECSBlueGreenDeploy
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CodeDeployToECS
                Version: "1"
              InputArtifacts:
                - Name: ConfigArtifact
                - Name: ECRSourceArtifact
              Configuration:
                ApplicationName: !Ref CodeDeployAppName
                DeploymentGroupName: !Ref CodeDeployDGName
                TaskDefinitionTemplateArtifact: ConfigArtifact
                TaskDefinitionTemplatePath: taskdef.json
                AppSpecTemplateArtifact: ConfigArtifact
                AppSpecTemplatePath: appspec.yaml
                Image1ArtifactName: ECRSourceArtifact
                Image1ContainerName: "IMAGE1_NAME"
              RunOrder: 1

  PipelineRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: codepipeline.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS
      Policies:
        - PolicyName: ECSPipelinePolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - s3:*
                  - codecommit:*
                  - codedeploy:*
                  - ecs:*
                  - ecr:DescribeImages
                  - iam:PassRole
                Resource: "*"
```

> **Exam Tip:** Note the **two source actions** running in parallel (same `RunOrder`): one for ECR (the Docker image) and one for CodeCommit (the config files: appspec.yaml and taskdef.json). The deploy action references both artifacts. The `Image1ContainerName: "IMAGE1_NAME"` maps to the `<IMAGE1_NAME>` placeholder in taskdef.json.

---

## 4. CodeDeploy Lifecycle Hook Scripts

### 4.1 before_install.sh — Cleanup and Prerequisites

```bash
#!/bin/bash
set -e

echo "[BeforeInstall] Starting pre-installation tasks..."

if [ -d /var/www/myapp ]; then
  echo "Backing up current application..."
  cp -r /var/www/myapp /var/www/myapp.backup.$(date +%Y%m%d%H%M%S)
fi

echo "Cleaning up old backups (keep last 3)..."
ls -dt /var/www/myapp.backup.* 2>/dev/null | tail -n +4 | xargs rm -rf

echo "Installing system dependencies..."
yum install -y httpd

echo "[BeforeInstall] Complete"
```

### 4.2 after_install.sh — Configuration and Permissions

```bash
#!/bin/bash
set -e

echo "[AfterInstall] Configuring application..."

APP_DIR="/var/www/myapp"

echo "Setting file permissions..."
chown -R apache:apache $APP_DIR
chmod -R 755 $APP_DIR
find $APP_DIR -type f -exec chmod 644 {} \;

echo "Setting up environment file..."
ENVIRONMENT=$(aws ssm get-parameter \
  --name "/myapp/environment" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region us-east-1)

cat > $APP_DIR/.env << EOF
NODE_ENV=$ENVIRONMENT
PORT=8080
EOF

echo "Installing application dependencies..."
cd $APP_DIR && npm install --production

echo "[AfterInstall] Complete"
```

### 4.3 start_server.sh — Application Startup

```bash
#!/bin/bash
set -e

echo "[ApplicationStart] Starting application..."

systemctl start myapp

RETRIES=30
COUNT=0
while [ $COUNT -lt $RETRIES ]; do
  if systemctl is-active --quiet myapp; then
    echo "Application started successfully"
    exit 0
  fi
  echo "Waiting for application to start... ($COUNT/$RETRIES)"
  sleep 2
  COUNT=$((COUNT + 1))
done

echo "ERROR: Application failed to start within timeout"
exit 1
```

### 4.4 stop_server.sh — Graceful Shutdown

```bash
#!/bin/bash

echo "[ApplicationStop] Stopping application..."

if systemctl is-active --quiet myapp; then
  systemctl stop myapp
  echo "Application stopped"
else
  echo "Application was not running"
fi

exit 0
```

> **Exam Tip:** The `ApplicationStop` script should **not** use `set -e` aggressively and should always exit 0 if possible — because this script runs from the **previous** deployment's AppSpec. If it fails, the new deployment fails. If the previous deployment left a broken stop script, you may need to manually fix it on the instance.

### 4.5 validate_service.sh — Post-Deployment Validation

```bash
#!/bin/bash
set -e

echo "[ValidateService] Validating deployment..."

HEALTH_URL="http://localhost:8080/health"
MAX_RETRIES=20
RETRY_INTERVAL=5

for i in $(seq 1 $MAX_RETRIES); do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL || echo "000")

  if [ "$HTTP_CODE" = "200" ]; then
    echo "Health check passed (HTTP $HTTP_CODE)"
    exit 0
  fi

  echo "Health check attempt $i/$MAX_RETRIES returned HTTP $HTTP_CODE. Retrying in ${RETRY_INTERVAL}s..."
  sleep $RETRY_INTERVAL
done

echo "ERROR: Health check failed after $MAX_RETRIES attempts"
exit 1
```

### 4.6 ECS Lifecycle Hook — Lambda Function (AfterAllowTestTraffic)

This Lambda function is invoked by CodeDeploy during ECS blue/green deployment to run integration tests against the test listener.

```python
import boto3
import urllib.request
import os
import json

codedeploy = boto3.client("codedeploy")


def handler(event, context):
    deployment_id = event["DeploymentId"]
    lifecycle_event_hook_execution_id = event["LifecycleEventHookExecutionId"]

    test_listener_url = os.environ["TEST_LISTENER_URL"]
    test_endpoints = ["/health", "/api/v1/status", "/api/v1/version"]

    status = "Succeeded"

    try:
        for endpoint in test_endpoints:
            url = f"{test_listener_url}{endpoint}"
            print(f"Testing: {url}")

            req = urllib.request.Request(url, method="GET")
            with urllib.request.urlopen(req, timeout=10) as response:
                if response.status != 200:
                    print(f"FAILED: {url} returned {response.status}")
                    status = "Failed"
                    break
                print(f"PASSED: {url} returned {response.status}")

    except Exception as e:
        print(f"ERROR: {e}")
        status = "Failed"

    codedeploy.put_lifecycle_event_hook_execution_status(
        deploymentId=deployment_id,
        lifecycleEventHookExecutionId=lifecycle_event_hook_execution_id,
        status=status,
    )

    return {"statusCode": 200, "body": json.dumps({"testResult": status})}
```

> **Exam Tip:** The hook Lambda **must** call `put_lifecycle_event_hook_execution_status` with `Succeeded` or `Failed`. If the Lambda times out or crashes without calling this API, CodeDeploy waits for the hook timeout and then fails the deployment. The `DeploymentId` and `LifecycleEventHookExecutionId` come from the event object passed by CodeDeploy.

---

## 5. Cross-Account Pipeline

### 5.1 Architecture Overview

```
Account A (111111111111) — Tools Account     Account B (222222222222) — Production Account
┌──────────────────────────────────┐         ┌────────────────────────────────────┐
│ CodePipeline                     │         │                                    │
│ CodeBuild                        │         │ CloudFormation / CodeDeploy / ECS  │
│ S3 Artifact Bucket (KMS)         │────────▶│                                    │
│ Pipeline IAM Role                │         │ CrossAccountDeployRole             │
│                                  │         │ (trusts Account A pipeline role)   │
│ KMS Key (grants Account B       │         │                                    │
│   decrypt access)                │         │ CloudFormation Execution Role      │
└──────────────────────────────────┘         └────────────────────────────────────┘
```

### 5.2 Account A — KMS Key Policy (Grants Account B Decrypt Access)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM policies in Account A",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow Account B to decrypt artifacts",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
      },
      "Action": [
        "kms:Decrypt",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
```

### 5.3 Account A — S3 Artifact Bucket Policy (Grants Account B Access)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountArtifactAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::pipeline-artifacts-111111111111/*"
    },
    {
      "Sid": "AllowBucketListing",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::pipeline-artifacts-111111111111"
    }
  ]
}
```

### 5.4 Account A — Pipeline Role (Needs AssumeRole Permission)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAssumeRoleInProductionAccount",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
    }
  ]
}
```

### 5.5 Account B — Cross-Account Deploy Role

```yaml
# CloudFormation template deployed in Account B (222222222222)
AWSTemplateFormatVersion: "2010-09-09"
Description: "Cross-account role for CodePipeline deployment from tools account"

Parameters:
  ToolsAccountId:
    Type: String
    Default: "111111111111"

Resources:

  CrossAccountDeployRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: CrossAccountDeployRole
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              AWS: !Sub "arn:aws:iam::${ToolsAccountId}:root"
            Action: sts:AssumeRole
            Condition:
              StringEquals:
                "sts:ExternalId": "pipeline-deploy"
      Policies:
        - PolicyName: DeployPolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - cloudformation:CreateStack
                  - cloudformation:UpdateStack
                  - cloudformation:DeleteStack
                  - cloudformation:DescribeStacks
                  - cloudformation:DescribeStackEvents
                  - cloudformation:CreateChangeSet
                  - cloudformation:ExecuteChangeSet
                  - cloudformation:DeleteChangeSet
                  - cloudformation:DescribeChangeSet
                Resource: !Sub "arn:aws:cloudformation:${AWS::Region}:${AWS::AccountId}:stack/my-app-*/*"
              - Effect: Allow
                Action: iam:PassRole
                Resource: !GetAtt CloudFormationExecutionRole.Arn
              - Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:GetObjectVersion
                Resource: !Sub "arn:aws:s3:::pipeline-artifacts-${ToolsAccountId}/*"
              - Effect: Allow
                Action:
                  - kms:Decrypt
                  - kms:DescribeKey
                Resource: "*"

  CloudFormationExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: CloudFormationExecutionRole
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: cloudformation.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AdministratorAccess

Outputs:
  CrossAccountRoleArn:
    Value: !GetAtt CrossAccountDeployRole.Arn
  CFNExecutionRoleArn:
    Value: !GetAtt CloudFormationExecutionRole.Arn
```

> **Exam Tip:** Note the **two roles** in Account B:
> 1. `CrossAccountDeployRole` — assumed by the pipeline in Account A to perform the CodePipeline action (create/update CloudFormation stack).
> 2. `CloudFormationExecutionRole` — assumed by CloudFormation itself to create the actual AWS resources (EC2, RDS, etc.). The cross-account role passes this role to CloudFormation via `iam:PassRole`.

### 5.6 Pipeline Stage Configuration (Account A — Deploy to Account B)

```yaml
- Name: Deploy-Production
  Actions:
    - Name: CreateChangeSet
      ActionTypeId:
        Category: Deploy
        Owner: AWS
        Provider: CloudFormation
        Version: "1"
      InputArtifacts:
        - Name: BuildArtifact
      Configuration:
        ActionMode: CHANGE_SET_CREATE
        StackName: my-app-production
        ChangeSetName: my-app-changeset
        TemplatePath: "BuildArtifact::infrastructure/template.yaml"
        TemplateConfiguration: "BuildArtifact::infrastructure/params-prod.json"
        RoleArn: "arn:aws:iam::222222222222:role/CloudFormationExecutionRole"
        Capabilities: CAPABILITY_NAMED_IAM
      RoleArn: "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
      RunOrder: 1

    - Name: ApproveChangeSet
      ActionTypeId:
        Category: Approval
        Owner: AWS
        Provider: Manual
        Version: "1"
      Configuration:
        CustomData: "Review the CloudFormation change set before deploying to production."
      RunOrder: 2

    - Name: ExecuteChangeSet
      ActionTypeId:
        Category: Deploy
        Owner: AWS
        Provider: CloudFormation
        Version: "1"
      Configuration:
        ActionMode: CHANGE_SET_EXECUTE
        StackName: my-app-production
        ChangeSetName: my-app-changeset
      RoleArn: "arn:aws:iam::222222222222:role/CrossAccountDeployRole"
      RunOrder: 3
```

> **Exam Tip:** The `RoleArn` at the **action level** (inside the `Actions` list) is the cross-account role the pipeline assumes. The `RoleArn` inside `Configuration` is the CloudFormation execution role. These are two different roles for two different purposes. This pattern — create change set → manual approval → execute change set — is a very common exam question for safe production deployments.

---

## Summary

| Example | Key Exam Concept |
|---|---|
| buildspec.yml (Docker) | `exported-variables`, ECR login, `imageDetail.json` for ECS pipelines |
| buildspec.yml (caching) | S3 cache in buildspec vs. Docker layer cache in project config |
| buildspec.yml (reports) | `reports` section, JUnit XML and Cobertura XML formats |
| appspec.yml (EC2) | `files`, `permissions`, `hooks` with script `location` and `timeout` |
| appspec.yml (ECS) | `Resources` with `TaskDefinition` and `LoadBalancerInfo`; hooks are Lambda ARNs |
| appspec.yml (Lambda) | `CurrentVersion` / `TargetVersion` on an `Alias` |
| Pipeline CFN (basic) | V2 pipeline type, artifact store with KMS, manual approval |
| Pipeline CFN (ECS) | Dual source actions (ECR + CodeCommit), `CodeDeployToECS` provider, `IMAGE1_NAME` placeholder |
| Lifecycle hooks | `put_lifecycle_event_hook_execution_status` API call from Lambda hooks |
| Cross-account | Three pillars: S3 bucket policy, KMS key policy, cross-account IAM role; two roles in target account (deploy role + CFN execution role) |

---

*Back to: [Article →](../article.md) | [Practice Questions →](../questions.md)*
