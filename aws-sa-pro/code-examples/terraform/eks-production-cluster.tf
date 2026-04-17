################################################################################
# AWS Solutions Architect Professional – EKS Production Cluster (Terraform)
#
# KEY EXAM TOPICS DEMONSTRATED:
#   • EKS cluster with managed node groups (EC2) and Fargate profiles
#   • IRSA (IAM Roles for Service Accounts) – pod-level IAM without node roles
#   • VPC CNI addon (native VPC networking for pods)
#   • EBS CSI Driver for persistent volumes
#   • AWS Load Balancer Controller (ALB Ingress)
#   • Cluster Autoscaler for dynamic node scaling
#   • CloudWatch Container Insights for observability
#   • Network policies via Calico
#
# EXAM TIP: EKS pricing = $0.10/hr per cluster (~$73/mo).  Worker node
# costs (EC2/Fargate) are separate.  Fargate costs more per vCPU/GB but
# removes node management overhead.  Use managed node groups for
# predictable workloads; Fargate for burst/batch.
################################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# ===========================================================================
# Variables
# ===========================================================================
variable "cluster_name" {
  type    = string
  default = "production-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for worker nodes"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB"
}

variable "environment" {
  type    = string
  default = "production"
}

# ===========================================================================
# Data Sources
# ===========================================================================
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# ===========================================================================
# EKS Cluster using terraform-aws-modules/eks
#
# EXAM TIP: The EKS module handles the complex setup of:
#   - Cluster IAM role with required policies
#   - Security groups (cluster + node communication)
#   - OIDC provider for IRSA
#   - Managed node groups with launch templates
#   - Add-on management
# ===========================================================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Cluster endpoint access configuration
  # EXAM TIP: Private endpoint = API server reachable from within VPC only.
  # Public endpoint = reachable from internet (use with CIDR allowlist).
  # Production recommendation: enable both, restrict public to VPN/office CIDRs.
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = [
    "10.0.0.0/8"     # Replace with your VPN/office CIDR
  ]

  # Cluster encryption: encrypt Kubernetes secrets with KMS
  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }

  # Control plane logging to CloudWatch
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # ===========================================================================
  # EKS Add-ons
  #
  # EXAM TIP: EKS managed add-ons are AWS-maintained and auto-updated.
  # VPC CNI is critical: it assigns VPC IP addresses to pods, enabling
  # native VPC networking (pods get real VPC IPs, not overlay network).
  # This allows Security Groups to be applied directly to pods.
  # ===========================================================================
  cluster_addons = {
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        tolerations = [{
          key      = "node.kubernetes.io/not-ready"
          operator = "Exists"
          effect   = "NoSchedule"
        }]
      })
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
      # Enable prefix delegation for higher pod density per node
      # EXAM TIP: With prefix delegation, each ENI gets /28 prefixes
      # (16 IPs each) instead of individual IPs, supporting up to
      # 110 pods on m5.large (vs 29 without prefix delegation)
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }

    # EBS CSI Driver: enables EBS-backed PersistentVolumes
    # EXAM TIP: EBS CSI driver replaced the in-tree EBS provisioner.
    # It requires IRSA for IAM permissions (cannot use node instance role).
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
  }

  # ===========================================================================
  # Managed Node Groups
  #
  # EXAM TIP: Managed node groups handle:
  #   - AMI selection and updates (Amazon Linux 2 or Bottlerocket)
  #   - Node draining during updates (graceful pod eviction)
  #   - Auto Scaling Group management
  #   - Lifecycle hooks for spot interruption handling
  # ===========================================================================
  eks_managed_node_groups = {
    # General-purpose node group for most workloads
    general = {
      name            = "general-purpose"
      instance_types  = ["m6i.xlarge", "m5.xlarge"]  # Multiple types for availability
      capacity_type   = "ON_DEMAND"

      min_size     = 3
      max_size     = 20
      desired_size = 3

      # Launch template customization
      disk_size    = 100
      disk_type    = "gp3"
      disk_iops    = 3000
      disk_throughput = 125

      labels = {
        workload-type = "general"
        environment   = var.environment
      }

      # Kubernetes taints prevent scheduling unless pods tolerate them
      taints = []

      update_config = {
        max_unavailable_percentage = 25  # Rolling update: 25% at a time
      }

      tags = {
        # Required for Cluster Autoscaler discovery
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }

    # Spot instance node group for fault-tolerant workloads
    # EXAM TIP: Spot instances save up to 90% vs on-demand.  Use for
    # stateless, fault-tolerant workloads.  Always use multiple instance
    # types across AZs to maximize spot capacity availability.
    spot = {
      name           = "spot-workers"
      instance_types = [
        "m6i.xlarge", "m5.xlarge", "m5a.xlarge",
        "m6i.2xlarge", "m5.2xlarge", "m5a.2xlarge"
      ]
      capacity_type = "SPOT"

      min_size     = 0
      max_size     = 50
      desired_size = 2

      labels = {
        workload-type = "spot"
        environment   = var.environment
      }

      taints = [{
        key    = "spot-instance"
        value  = "true"
        effect = "NO_SCHEDULE"
      }]

      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }

  # ===========================================================================
  # Fargate Profiles
  #
  # EXAM TIP: Fargate pods run on AWS-managed infrastructure (no EC2 nodes).
  # Each pod gets its own micro-VM (Firecracker) for security isolation.
  # Limitations: no DaemonSets, no privileged containers, no GPUs,
  # max 4 vCPU / 30 GB memory per pod, no EBS volumes (use EFS instead).
  # ===========================================================================
  fargate_profiles = {
    # Run kube-system pods (CoreDNS) on Fargate for a fully serverless control plane
    kube_system = {
      name = "kube-system"
      selectors = [{
        namespace = "kube-system"
        labels = {
          "eks.amazonaws.com/component" = "coredns"
        }
      }]
    }

    # Batch processing jobs on Fargate (no node management needed)
    batch = {
      name = "batch-processing"
      selectors = [{
        namespace = "batch"
      }]
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# ===========================================================================
# KMS Key for EKS Secrets Encryption
# ===========================================================================
resource "aws_kms_key" "eks" {
  description             = "EKS secrets encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks.key_id
}

# ===========================================================================
# IRSA (IAM Roles for Service Accounts)
#
# EXAM TIP: IRSA eliminates the need for broad node-level IAM roles.
# Each Kubernetes service account gets its own IAM role via OIDC
# federation.  The pod receives temporary credentials scoped to exactly
# the permissions it needs (least privilege).  This is the recommended
# approach for ALL pod IAM access.
# ===========================================================================

# EBS CSI Driver IRSA
module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "${var.cluster_name}-ebs-csi-controller"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# AWS Load Balancer Controller IRSA
module "lb_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${var.cluster_name}-aws-lb-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Cluster Autoscaler IRSA
module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "${var.cluster_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.cluster_name]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

# CloudWatch agent IRSA for Container Insights
module "cloudwatch_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.cluster_name}-cloudwatch-agent"

  role_policy_arns = {
    CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["amazon-cloudwatch:cloudwatch-agent"]
    }
  }
}

# ===========================================================================
# Kubernetes / Helm Provider Configuration
# ===========================================================================
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# ===========================================================================
# AWS Load Balancer Controller (Helm)
#
# EXAM TIP: The AWS LB Controller manages ALBs (Ingress) and NLBs
# (Service type LoadBalancer) natively.  It replaces the legacy
# in-tree AWS cloud provider for load balancing.  ALB Ingress
# supports path-based and host-based routing, WAF integration,
# and Cognito authentication.
# ===========================================================================
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.7.1"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.lb_controller_irsa.iam_role_arn
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  depends_on = [module.eks]
}

# ===========================================================================
# Cluster Autoscaler (Helm)
#
# EXAM TIP: Cluster Autoscaler adjusts the number of nodes based on
# pending pods that can't be scheduled.  It works with managed node
# groups by modifying the ASG desired count.  Use expander=least-waste
# for cost optimization.  For Karpenter (newer alternative), nodes are
# provisioned directly without ASGs.
# ===========================================================================
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.35.0"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa.iam_role_arn
  }

  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

  set {
    name  = "extraArgs.expander"
    value = "least-waste"
  }

  depends_on = [module.eks]
}

# ===========================================================================
# CloudWatch Container Insights
#
# EXAM TIP: Container Insights provides CPU, memory, disk, and network
# metrics for EKS clusters, nodes, pods, and containers.  It uses the
# CloudWatch agent (DaemonSet) and Fluent Bit for log collection.
# Costs: custom metrics pricing (~$0.30/metric/month).
# ===========================================================================
resource "helm_release" "cloudwatch_observability" {
  name       = "amazon-cloudwatch-observability"
  repository = "https://aws-observability.github.io/helm-charts"
  chart      = "amazon-cloudwatch-observability"
  namespace  = "amazon-cloudwatch"
  version    = "1.5.0"

  create_namespace = true

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cloudwatch_irsa.iam_role_arn
  }

  depends_on = [module.eks]
}

# ===========================================================================
# Network Policies (Calico)
#
# EXAM TIP: Kubernetes NetworkPolicies require a CNI plugin that supports
# them.  The default AWS VPC CNI does NOT enforce NetworkPolicies
# (as of EKS 1.29, it does via network policy agent addon).
# Calico provides full NetworkPolicy enforcement.
# ===========================================================================
resource "helm_release" "calico" {
  name       = "calico"
  repository = "https://docs.tigera.io/calico/charts"
  chart      = "tigera-operator"
  namespace  = "tigera-operator"
  version    = "3.27.0"

  create_namespace = true

  set {
    name  = "installation.kubernetesProvider"
    value = "EKS"
  }

  set {
    name  = "installation.cni.type"
    value = "AmazonVPC"
  }

  depends_on = [module.eks]
}

# Example: Default deny-all NetworkPolicy for production namespace
resource "kubernetes_network_policy" "default_deny" {
  metadata {
    name      = "default-deny-all"
    namespace = "production"
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }

  depends_on = [module.eks]
}

# Example: Allow ingress only from specific namespace
resource "kubernetes_network_policy" "allow_web_to_api" {
  metadata {
    name      = "allow-web-to-api"
    namespace = "production"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "api"
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "web"
          }
        }
      }

      ports {
        port     = "8080"
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }

  depends_on = [module.eks]
}

# ===========================================================================
# Outputs
# ===========================================================================
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for creating additional IRSA roles"
  value       = module.eks.oidc_provider_arn
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${data.aws_region.current.name}"
}
