# Lab 3 — EC2 + S3

## 1. Launch a t3.micro EC2 (Free Tier)

```bash
aws ec2 create-key-pair --key-name ccp-key \
  --query 'KeyMaterial' --output text > ccp-key.pem
chmod 400 ccp-key.pem

# Default VPC already has a security group; create a narrower one:
aws ec2 create-security-group --group-name ccp-web \
  --description "CCP lab web SG" \
  --query 'GroupId' --output text
# Capture the GroupId:
SG=sg-0abc…
aws ec2 authorize-security-group-ingress \
  --group-id $SG --protocol tcp --port 22 --cidr $(curl -s https://checkip.amazonaws.com)/32
aws ec2 authorize-security-group-ingress \
  --group-id $SG --protocol tcp --port 80 --cidr 0.0.0.0/0

# Latest Amazon Linux 2023 AMI:
AMI=$(aws ssm get-parameters \
  --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query 'Parameters[0].Value' --output text)

aws ec2 run-instances \
  --image-id $AMI \
  --instance-type t3.micro \
  --key-name ccp-key \
  --security-group-ids $SG \
  --iam-instance-profile Name=EC2ReadS3Profile \
  --user-data '#!/bin/bash
dnf -y install httpd
systemctl enable --now httpd
echo "<h1>Hello from CCP lab on $(hostname)</h1>" > /var/www/html/index.html' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ccp-web}]'
```

After a few minutes:

```bash
IP=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=ccp-web' \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
curl http://$IP/
```

## 2. Create an S3 bucket and upload

```bash
BUCKET=ccp-lab-$(date +%s)-$RANDOM
aws s3 mb s3://$BUCKET --region us-east-1
echo "hello s3" > hello.txt
aws s3 cp hello.txt s3://$BUCKET/
aws s3 ls s3://$BUCKET/
```

Verify from the EC2 using the attached instance role:

```bash
ssh -i ccp-key.pem ec2-user@$IP
aws s3 ls s3://$BUCKET/
aws s3 cp s3://$BUCKET/hello.txt -
```

## 3. Enable versioning, lifecycle, default encryption

```bash
aws s3api put-bucket-versioning --bucket $BUCKET \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption --bucket $BUCKET \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws s3api put-bucket-lifecycle-configuration --bucket $BUCKET \
  --lifecycle-configuration '{
    "Rules":[{
      "ID":"TransitionToIA",
      "Status":"Enabled",
      "Filter":{"Prefix":""},
      "Transitions":[{"Days":30,"StorageClass":"STANDARD_IA"},{"Days":90,"StorageClass":"GLACIER_IR"}],
      "Expiration":{"Days":365}
    }]
  }'
```

## 4. Clean up

```bash
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filters 'Name=tag:Name,Values=ccp-web' --query 'Reservations[0].Instances[0].InstanceId' --output text)
aws ec2 delete-security-group --group-id $SG
aws s3 rm s3://$BUCKET --recursive
aws s3api delete-bucket --bucket $BUCKET
aws ec2 delete-key-pair --key-name ccp-key
rm -f ccp-key.pem hello.txt
```
