# Lab 1 — First Account & AWS CLI

## 1. Create your AWS account

1. Visit <https://aws.amazon.com> → *Create an AWS Account*.
2. Pick the **Basic Support** plan (free).
3. On first login, **enable MFA on the root user** (Security Credentials
   → MFA).
4. **Never use root** again for daily work.

## 2. Create your first IAM admin user (temporary — we'll migrate to
Identity Center later)

```bash
# In the console (root user), go to IAM → Users → Add user
# - Name: admin
# - Access type: Console access + Programmatic access
# - Attach the AWS-managed policy: AdministratorAccess
# - Download the .csv with the access key and secret key
```

## 3. Install AWS CLI v2

macOS:
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o AWSCLIV2.pkg
sudo installer -pkg AWSCLIV2.pkg -target /
aws --version
```

Linux:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

Windows (PowerShell):
```powershell
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet
aws --version
```

## 4. Configure credentials

```bash
aws configure --profile ccp
# AWS Access Key ID: <from .csv>
# AWS Secret Access Key: <from .csv>
# Default region name: us-east-1
# Default output format: json

export AWS_PROFILE=ccp

aws sts get-caller-identity
# Shows your Account + UserId + Arn
```

## 5. Explore the CLI

```bash
aws ec2 describe-regions --query 'Regions[*].RegionName' --output text
aws ec2 describe-availability-zones --region us-east-1 --output table
aws s3 ls
aws iam list-users
```

## 6. Launch AWS CloudShell

In the console toolbar, click the *CloudShell* icon. It's a
pre-authenticated shell with AWS CLI, Python, Node, git, and 1 GB of
persistent `$HOME`. Free.

## 7. (Recommended) Switch to IAM Identity Center

Long-lived access keys are a security risk. For day-to-day CLI use,
configure IAM Identity Center and `aws sso login`:

```bash
aws configure sso
# SSO session name: my-sso
# SSO start URL: https://<your-portal>.awsapps.com/start
# SSO region: us-east-1
# SSO registration scopes: sso:account:access
# Then pick an account and permission set
# Default region: us-east-1
# Default output: json

aws sso login --profile my-sso-admin
aws sts get-caller-identity --profile my-sso-admin
```

## 8. Clean-up

No resources created in this lab. You can delete your long-lived admin
access key after switching to SSO.
