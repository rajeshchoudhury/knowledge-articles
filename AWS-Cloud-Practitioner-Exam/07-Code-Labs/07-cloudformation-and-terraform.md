# Lab 7 — Same Stack, Two IaC Flavors

We'll build the **same S3 bucket + Lambda function** stack in both
CloudFormation and Terraform. The purpose is to make IaC click: once
you see the parallel, everything else is just more resource types.

## 7A. CloudFormation (`cfn/stack.yaml`)

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Simple bucket + Lambda

Parameters:
  Env:
    Type: String
    AllowedValues: [dev, prod]
    Default: dev

Resources:
  Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "ccp-${Env}-${AWS::AccountId}-${AWS::Region}"
      BucketEncryption:
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault: { SSEAlgorithm: AES256 }
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

  FnRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal: { Service: lambda.amazonaws.com }
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

  Fn:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.12
      Handler: index.handler
      Role: !GetAtt FnRole.Arn
      Code:
        ZipFile: |
          def handler(event, context):
              return {"statusCode": 200, "body": "hello ccp"}

Outputs:
  BucketName: { Value: !Ref Bucket }
  FunctionName: { Value: !Ref Fn }
```

Deploy:

```bash
aws cloudformation deploy \
  --template-file cfn/stack.yaml \
  --stack-name ccp-cfn \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides Env=dev
```

## 7B. Terraform (`tf/main.tf`)

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "env" {
  type    = string
  default = "dev"
}

data "aws_caller_identity" "me" {}
data "aws_region" "here" {}

resource "aws_s3_bucket" "b" {
  bucket = "ccp-${var.env}-${data.aws_caller_identity.me.account_id}-${data.aws_region.here.name}-tf"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "b" {
  bucket = aws_s3_bucket.b.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket                  = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service", identifiers = ["lambda.amazonaws.com"] }
  }
}

resource "aws_iam_role" "fn" {
  name               = "ccp-tf-fn"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.fn.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "z" {
  type        = "zip"
  output_path = "${path.module}/fn.zip"
  source { content = "def handler(e,c):\n  return {'statusCode':200,'body':'hello ccp'}\n", filename = "index.py" }
}

resource "aws_lambda_function" "fn" {
  function_name = "ccp-tf-fn"
  runtime       = "python3.12"
  handler       = "index.handler"
  role          = aws_iam_role.fn.arn
  filename      = data.archive_file.z.output_path
  source_code_hash = data.archive_file.z.output_base64sha256
}

output "bucket"   { value = aws_s3_bucket.b.id }
output "function" { value = aws_lambda_function.fn.function_name }
```

Deploy:

```bash
cd tf
terraform init
terraform apply -var env=dev
```

## 7C. Clean up

```bash
aws cloudformation delete-stack --stack-name ccp-cfn
# Terraform:
cd tf
terraform destroy -var env=dev
```

## Takeaways

- CloudFormation is native (no state file, uses AWS service).
- Terraform is provider-based, multi-cloud, with a local or remote
  **state file** (recommend S3 + DynamoDB locking for team projects).
- Both are declarative and idempotent.
- Choose based on ecosystem and team skills; exam does not prefer
  one over the other.
