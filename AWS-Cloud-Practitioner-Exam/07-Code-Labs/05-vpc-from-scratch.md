# Lab 5 — Build a VPC from Scratch

We'll build a simple VPC with 1 public + 1 private subnet in one AZ.
Production designs use ≥ 2 AZs, but the semantics are identical.

```bash
VPC=$(aws ec2 create-vpc --cidr-block 10.20.0.0/16 \
  --query Vpc.VpcId --output text)
aws ec2 create-tags --resources $VPC --tags Key=Name,Value=ccp-vpc

aws ec2 modify-vpc-attribute --vpc-id $VPC --enable-dns-hostnames
aws ec2 modify-vpc-attribute --vpc-id $VPC --enable-dns-support

IGW=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC --internet-gateway-id $IGW

PUB=$(aws ec2 create-subnet --vpc-id $VPC --cidr-block 10.20.1.0/24 \
  --availability-zone us-east-1a --query Subnet.SubnetId --output text)
PRIV=$(aws ec2 create-subnet --vpc-id $VPC --cidr-block 10.20.2.0/24 \
  --availability-zone us-east-1a --query Subnet.SubnetId --output text)

RT_PUB=$(aws ec2 create-route-table --vpc-id $VPC --query RouteTable.RouteTableId --output text)
aws ec2 create-route --route-table-id $RT_PUB --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW
aws ec2 associate-route-table --route-table-id $RT_PUB --subnet-id $PUB
aws ec2 modify-subnet-attribute --subnet-id $PUB --map-public-ip-on-launch

EIP=$(aws ec2 allocate-address --query AllocationId --output text)
NAT=$(aws ec2 create-nat-gateway --subnet-id $PUB --allocation-id $EIP \
  --query NatGateway.NatGatewayId --output text)
# Wait for NAT: aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT

RT_PRIV=$(aws ec2 create-route-table --vpc-id $VPC --query RouteTable.RouteTableId --output text)
aws ec2 create-route --route-table-id $RT_PRIV --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT
aws ec2 associate-route-table --route-table-id $RT_PRIV --subnet-id $PRIV
```

Add a **gateway endpoint for S3** (free, keeps traffic off the NAT GW):

```bash
aws ec2 create-vpc-endpoint \
  --vpc-id $VPC \
  --service-name com.amazonaws.us-east-1.s3 \
  --route-table-ids $RT_PRIV $RT_PUB
```

## Clean up (NAT GW costs ~$0.045/hour — don't leave it!)

```bash
aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $(aws ec2 describe-vpc-endpoints --filters Name=vpc-id,Values=$VPC --query 'VpcEndpoints[*].VpcEndpointId' --output text)
aws ec2 delete-nat-gateway --nat-gateway-id $NAT
# Wait until deleted
aws ec2 release-address --allocation-id $EIP
aws ec2 delete-subnet --subnet-id $PRIV
aws ec2 delete-subnet --subnet-id $PUB
aws ec2 delete-route-table --route-table-id $RT_PRIV
aws ec2 delete-route-table --route-table-id $RT_PUB
aws ec2 detach-internet-gateway --vpc-id $VPC --internet-gateway-id $IGW
aws ec2 delete-internet-gateway --internet-gateway-id $IGW
aws ec2 delete-vpc --vpc-id $VPC
```
