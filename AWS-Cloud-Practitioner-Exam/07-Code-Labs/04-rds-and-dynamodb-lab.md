# Lab 4 — RDS + DynamoDB

## 1. DynamoDB quick tour

```bash
aws dynamodb create-table \
  --table-name CCPOrders \
  --attribute-definitions AttributeName=OrderId,AttributeType=S \
  --key-schema AttributeName=OrderId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

aws dynamodb put-item --table-name CCPOrders \
  --item '{"OrderId":{"S":"O-1001"},"Customer":{"S":"Alice"},"Amount":{"N":"42.99"}}'

aws dynamodb get-item --table-name CCPOrders \
  --key '{"OrderId":{"S":"O-1001"}}'

aws dynamodb scan --table-name CCPOrders
```

Enable Point-in-Time Recovery:

```bash
aws dynamodb update-continuous-backups \
  --table-name CCPOrders \
  --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true
```

## 2. Launch a tiny RDS PostgreSQL (Free Tier)

```bash
# Create a subnet group in the default VPC (two private subnets preferred)
SUBNETS=$(aws ec2 describe-subnets \
  --filters Name=vpc-id,Values=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query 'Vpcs[0].VpcId' --output text) \
  --query 'Subnets[*].SubnetId' --output text | tr '\t' ' ')

aws rds create-db-subnet-group \
  --db-subnet-group-name ccp-sng \
  --db-subnet-group-description "CCP lab" \
  --subnet-ids $SUBNETS

RDS_SG=$(aws ec2 create-security-group \
  --group-name ccp-rds --description ccp-rds \
  --query GroupId --output text)
aws ec2 authorize-security-group-ingress --group-id $RDS_SG \
  --protocol tcp --port 5432 --cidr 10.0.0.0/8

aws rds create-db-instance \
  --db-instance-identifier ccp-pg \
  --engine postgres \
  --db-instance-class db.t3.micro \
  --allocated-storage 20 \
  --master-username ccpadmin \
  --master-user-password 'CCP-Lab-Pass-1' \
  --db-subnet-group-name ccp-sng \
  --vpc-security-group-ids $RDS_SG \
  --backup-retention-period 1 \
  --storage-encrypted
```

## 3. Clean up (important — RDS costs if left running)

```bash
aws rds delete-db-instance --db-instance-identifier ccp-pg \
  --skip-final-snapshot --delete-automated-backups

# Wait for deletion, then:
aws rds delete-db-subnet-group --db-subnet-group-name ccp-sng
aws ec2 delete-security-group --group-id $RDS_SG
aws dynamodb delete-table --table-name CCPOrders
```
