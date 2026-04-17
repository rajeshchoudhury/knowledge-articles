# Lab 2 — IAM (users, groups, roles, policies, MFA)

## 1. Create a group with a managed policy

```bash
aws iam create-group --group-name Developers
aws iam attach-group-policy \
  --group-name Developers \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
```

## 2. Create a user and add them to the group

```bash
aws iam create-user --user-name alice
aws iam add-user-to-group --user-name alice --group-name Developers
aws iam create-login-profile --user-name alice --password 'Temp#CCP-12345' --password-reset-required
```

## 3. Enforce MFA on the user (via a permissions boundary)

`enforce-mfa.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListActionsWithoutMFA",
      "Effect": "Allow",
      "Action": ["iam:ListUsers","iam:GetUser","iam:ChangePassword","iam:CreateVirtualMFADevice","iam:EnableMFADevice","iam:ListMFADevices","sts:GetSessionToken"],
      "Resource": "*"
    },
    {
      "Sid": "DenyAllUnlessMFAd",
      "Effect": "Deny",
      "NotAction": ["iam:ListUsers","iam:GetUser","iam:ChangePassword","iam:CreateVirtualMFADevice","iam:EnableMFADevice","iam:ListMFADevices","sts:GetSessionToken"],
      "Resource": "*",
      "Condition": { "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" } }
    }
  ]
}
```

```bash
aws iam create-policy \
  --policy-name MFA-Enforcement \
  --policy-document file://enforce-mfa.json
```

## 4. Create a role for EC2 that can read S3

`ec2-trust.json`:

```json
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal":{ "Service":"ec2.amazonaws.com" },
    "Action":"sts:AssumeRole"
  }]
}
```

```bash
aws iam create-role --role-name EC2ReadS3 \
  --assume-role-policy-document file://ec2-trust.json

aws iam attach-role-policy --role-name EC2ReadS3 \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam create-instance-profile --instance-profile-name EC2ReadS3Profile
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2ReadS3Profile \
  --role-name EC2ReadS3
```

Attach `EC2ReadS3Profile` when launching an EC2 in Lab 3.

## 5. Cross-account role (concept)

In account A, create a role that trusts account B:

`cross-account-trust.json`:

```json
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal":{ "AWS":"arn:aws:iam::222222222222:root" },
    "Action":"sts:AssumeRole",
    "Condition":{ "StringEquals": { "sts:ExternalId": "shared-secret" } }
  }]
}
```

In account B, principals can `aws sts assume-role --role-arn … --external-id
shared-secret` to get temporary creds for account A.

## 6. Policy simulator and Access Analyzer

Try these UI tools in the console:
- IAM → Policies → **Simulate Policy**
- IAM → **Access Analyzer** → External Access
- IAM → **Access Advisor** tab on a user/role to see unused permissions

## 7. Clean-up

```bash
aws iam remove-user-from-group --user-name alice --group-name Developers
aws iam delete-login-profile --user-name alice
aws iam delete-user --user-name alice
aws iam detach-group-policy --group-name Developers --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
aws iam delete-group --group-name Developers

aws iam remove-role-from-instance-profile --instance-profile-name EC2ReadS3Profile --role-name EC2ReadS3
aws iam delete-instance-profile --instance-profile-name EC2ReadS3Profile
aws iam detach-role-policy --role-name EC2ReadS3 --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam delete-role --role-name EC2ReadS3
```
