################################################################################
# AWS Solutions Architect - EKS Cluster (Terraform)
################################################################################
# KEY EXAM CONCEPTS:
#   - EKS = managed Kubernetes control plane (AWS manages etcd, API server, etc.)
#   - Node types: Managed Node Groups, Self-managed nodes, Fargate
#   - IAM Roles for Service Accounts (IRSA): map K8s service accounts to IAM roles
#   - OIDC provider: enables IRSA by establishing trust between K8s and IAM
#   - VPC CNI: assigns VPC IPs directly to pods (native VPC networking)
#   - CoreDNS: provides DNS resolution within the cluster
#   - kube-proxy: maintains network rules on nodes
#   - EKS supports public, private, or public+private API endpoints
################################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# ===========================================================================
# VARIABLES
# ===========================================================================
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "sa-exam-eks"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS nodes"
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types for managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "node_disk_size" {
  description = "Disk size in GB for worker nodes"
  type        = number
  default     = 50
}

# ===========================================================================
# LOCALS
# ===========================================================================
locals {
  cluster_name = "${var.environment}-${var.cluster_name}"
}

# ===========================================================================
# DATA SOURCES
# ===========================================================================
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# ===========================================================================
# EKS CLUSTER IAM ROLE
# Exam tip: The cluster IAM role allows the EKS service to manage AWS
# resources on your behalf. It needs the AmazonEKSClusterPolicy which
# grants permissions for the Kubernetes control plane.
# ===========================================================================
resource "aws_iam_role" "cluster" {
  name = "${local.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${local.cluster_name}-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Exam tip: VPC Resource Controller policy is needed for security groups
# for pods feature and managing ENIs for pod networking.
resource "aws_iam_role_policy_attachment" "cluster_vpc_resource_controller" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# ===========================================================================
# EKS CLUSTER SECURITY GROUP
# Exam tip: The cluster security group is automatically created by EKS.
# This additional security group provides more fine-grained control.
# ===========================================================================
resource "aws_security_group" "cluster" {
  name        = "${local.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.cluster_name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "Allow all outbound traffic"
}

# Allow nodes to communicate with the cluster API server
resource "aws_security_group_rule" "cluster_ingress_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.cluster.id
  description              = "Allow nodes to communicate with cluster API"
}

# ===========================================================================
# NODE SECURITY GROUP
# ===========================================================================
resource "aws_security_group" "node" {
  name        = "${local.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name                                          = "${local.cluster_name}-node-sg"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node.id
  description       = "Allow all outbound traffic"
}

# Allow nodes to communicate with each other
resource "aws_security_group_rule" "node_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow node-to-node communication"
}

# Allow cluster control plane to communicate with nodes (kubelet, kube-proxy)
resource "aws_security_group_rule" "node_ingress_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster control plane to reach nodes"
}

# Allow cluster control plane to communicate with nodes on port 443 (for extensions)
resource "aws_security_group_rule" "node_ingress_cluster_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
  description              = "Allow cluster API to communicate with node webhooks"
}

# ===========================================================================
# EKS CLUSTER
# Exam tip: EKS API endpoint access:
#   - Public: API server accessible from internet (default)
#   - Private: API server only accessible from within VPC
#   - Public + Private: API server accessible from both (recommended for dev)
# In production, use Private only + VPN/Direct Connect for access.
# ===========================================================================
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 30
}

resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    # Exam tip: Restrict public access to specific CIDRs for security.
    # In production, consider making the endpoint fully private.
    public_access_cidrs = ["0.0.0.0/0"]
  }

  # Exam tip: EKS control plane logging types:
  # api, audit, authenticator, controllerManager, scheduler
  # Logs go to CloudWatch Logs. Useful for debugging and compliance.
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Exam tip: Encryption of Kubernetes secrets using a customer-managed KMS key.
  # Without this, secrets are stored in etcd with base64 encoding (not encrypted).
  # encryption_config {
  #   provider {
  #     key_arn = aws_kms_key.eks.arn
  #   }
  #   resources = ["secrets"]
  # }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_resource_controller,
    aws_cloudwatch_log_group.eks,
  ]

  tags = {
    Name = local.cluster_name
  }
}

# ===========================================================================
# OIDC PROVIDER FOR IRSA
# Exam tip: OIDC (OpenID Connect) provider establishes a trust relationship
# between the Kubernetes cluster and AWS IAM. This enables:
#   - IAM Roles for Service Accounts (IRSA)
#   - Pods can assume IAM roles via their Kubernetes service account
#   - Fine-grained IAM permissions per pod (not per node)
#   - Better security than attaching roles to EC2 instances
# ===========================================================================
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = {
    Name = "${local.cluster_name}-oidc-provider"
  }
}

# ===========================================================================
# NODE GROUP IAM ROLE
# Exam tip: Worker nodes need several managed policies:
#   - AmazonEKSWorkerNodePolicy: basic EKS node operations
#   - AmazonEKS_CNI_Policy: VPC CNI plugin (assigning IPs to pods)
#   - AmazonEC2ContainerRegistryReadOnly: pull images from ECR
#   - AmazonSSMManagedInstanceCore: optional, for SSM Session Manager access
# ===========================================================================
resource "aws_iam_role" "node" {
  name = "${local.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${local.cluster_name}-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_ecr_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_ssm_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node.name
}

# ===========================================================================
# MANAGED NODE GROUP
# Exam tip: Managed Node Groups vs Self-Managed vs Fargate:
#   - Managed Node Groups: AWS manages provisioning, updates, draining
#   - Self-Managed: you manage the EC2 instances (more control, more work)
#   - Fargate: serverless — no EC2 to manage, pay per pod (vCPU + memory)
#     Fargate limitations: no DaemonSets, no GPU, no privileged containers
# ===========================================================================
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.cluster_name}-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.node_instance_types
  disk_size       = var.node_disk_size
  # Exam tip: capacity_type can be ON_DEMAND or SPOT.
  # SPOT is cheaper (~60-90% savings) but can be interrupted.
  # Use for stateless, fault-tolerant workloads.
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    # Exam tip: max_unavailable controls rolling updates.
    # Setting 1 means only 1 node is updated at a time for safety.
    max_unavailable = 1
  }

  labels = {
    role        = "general"
    environment = var.environment
  }

  # Exam tip: Taints prevent pods from scheduling on nodes unless they
  # have a matching toleration. Useful for dedicated node groups.
  # taint {
  #   key    = "dedicated"
  #   value  = "gpu"
  #   effect = "NO_SCHEDULE"
  # }

  depends_on = [
    aws_iam_role_policy_attachment.node_worker_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy,
  ]

  tags = {
    Name = "${local.cluster_name}-nodes"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# ===========================================================================
# EKS ADD-ONS
# Exam tip: EKS add-ons are operational software that provides key
# functionality. Managed add-ons are automatically updated by AWS.
#   - vpc-cni: Assigns VPC IP addresses directly to pods
#   - coredns: DNS service for Kubernetes cluster
#   - kube-proxy: Network proxy that runs on each node
#   - aws-ebs-csi-driver: Enables EBS volumes as persistent storage
# ===========================================================================

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
  # Exam tip: OVERWRITE resolves conflicts by using the Amazon EKS
  # default values. PRESERVE keeps existing values.
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${local.cluster_name}-vpc-cni"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.main]

  tags = {
    Name = "${local.cluster_name}-coredns"
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${local.cluster_name}-kube-proxy"
  }
}

# EBS CSI Driver add-on with IRSA
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi.arn
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.main]

  tags = {
    Name = "${local.cluster_name}-ebs-csi"
  }
}

# ===========================================================================
# IRSA EXAMPLE — EBS CSI Driver
# Exam tip: This shows the IRSA pattern — creating an IAM role that
# can only be assumed by a specific Kubernetes service account.
# The OIDC condition restricts which service account can assume the role.
# ===========================================================================
data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }
  }
}

resource "aws_iam_role" "ebs_csi" {
  name               = "${local.cluster_name}-ebs-csi-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = {
    Name = "${local.cluster_name}-ebs-csi-role"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi.name
}

# ===========================================================================
# OUTPUTS
# ===========================================================================
output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "EKS cluster certificate authority data"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  description = "Cluster security group ID"
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Node security group ID"
  value       = aws_security_group.node.id
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN (for creating IRSA roles)"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "OIDC provider URL"
  value       = aws_iam_openid_connect_provider.eks.url
}

output "node_group_name" {
  description = "Managed node group name"
  value       = aws_eks_node_group.main.node_group_name
}

output "kubeconfig_command" {
  description = "Command to update kubeconfig"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}"
}
