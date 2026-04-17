################################################################################
# AWS Solutions Architect Professional – Multi-Region Infrastructure (Terraform)
#
# KEY EXAM TOPICS DEMONSTRATED:
#   • Multi-region provider aliases for deploying to two regions
#   • Non-overlapping VPC CIDRs (critical for TGW/peering)
#   • Transit Gateway with inter-region peering
#   • Aurora Global Database spanning two regions
#   • S3 cross-region replication
#   • Route 53 latency-based routing
#   • CloudFront distribution with regional origins
#   • ACM certificates in both regions (+ us-east-1 for CloudFront)
#
# EXAM TIP: Multi-region architecture addresses:
#   1. Disaster recovery (failover to secondary)
#   2. Latency optimization (serve users from nearest region)
#   3. Data residency (keep data in specific geographies)
#   4. Compliance (some regulations require multi-region)
################################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state in S3 with DynamoDB locking (production best practice)
  backend "s3" {
    bucket         = "terraform-state-ACCOUNT_ID"
    key            = "multi-region/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# ===========================================================================
# Provider Configuration – Two Regions
#
# EXAM TIP: Terraform uses provider aliases to manage resources in multiple
# regions.  Each resource specifies which provider (region) it belongs to.
# Default tags propagate to every resource automatically.
# ===========================================================================
provider "aws" {
  region = var.primary_region

  default_tags {
    tags = {
      Project     = "multi-region-infra"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = {
      Project     = "multi-region-infra"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

# CloudFront requires ACM certificates in us-east-1 regardless of origin region
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "multi-region-infra"
      ManagedBy   = "terraform"
    }
  }
}

# ===========================================================================
# Variables
# ===========================================================================
variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "secondary_region" {
  type    = string
  default = "us-west-2"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
  default     = "app.example.com"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 hosted zone ID"
}

# Non-overlapping CIDRs are essential for Transit Gateway routing
variable "primary_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "secondary_vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

# ===========================================================================
# Data Sources
# ===========================================================================
data "aws_availability_zones" "primary" {
  state = "available"
}

data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"
}

data "aws_caller_identity" "current" {}

# ===========================================================================
# VPC – Primary Region
# ===========================================================================
module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-primary-vpc"
  cidr = var.primary_vpc_cidr

  azs             = slice(data.aws_availability_zones.primary.names, 0, 3)
  public_subnets  = [for i in range(3) : cidrsubnet(var.primary_vpc_cidr, 4, i)]
  private_subnets = [for i in range(3) : cidrsubnet(var.primary_vpc_cidr, 4, i + 3)]
  intra_subnets   = [for i in range(3) : cidrsubnet(var.primary_vpc_cidr, 4, i + 6)]

  enable_nat_gateway     = true
  single_nat_gateway     = false    # One per AZ for HA
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_iam_role             = true
  flow_log_max_aggregation_interval    = 60
}

# ===========================================================================
# VPC – Secondary Region
# ===========================================================================
module "vpc_secondary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.secondary
  }

  name = "${var.environment}-secondary-vpc"
  cidr = var.secondary_vpc_cidr

  azs             = slice(data.aws_availability_zones.secondary.names, 0, 3)
  public_subnets  = [for i in range(3) : cidrsubnet(var.secondary_vpc_cidr, 4, i)]
  private_subnets = [for i in range(3) : cidrsubnet(var.secondary_vpc_cidr, 4, i + 3)]
  intra_subnets   = [for i in range(3) : cidrsubnet(var.secondary_vpc_cidr, 4, i + 6)]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_iam_role             = true
  flow_log_max_aggregation_interval    = 60
}

# ===========================================================================
# Transit Gateway – Primary Region
#
# EXAM TIP: Transit Gateway is a regional resource.  For cross-region
# connectivity, you create a TGW in each region and then create a
# peering attachment between them.  TGW peering uses AWS backbone
# (encrypted, low-latency).  Unlike VPC peering, TGW supports
# transitive routing across all attached VPCs.
# ===========================================================================
resource "aws_ec2_transit_gateway" "primary" {
  description                     = "Primary region Transit Gateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  auto_accept_shared_attachments  = "enable"

  tags = {
    Name = "${var.environment}-tgw-primary"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "primary" {
  transit_gateway_id = aws_ec2_transit_gateway.primary.id
  vpc_id             = module.vpc_primary.vpc_id
  subnet_ids         = module.vpc_primary.private_subnets
  dns_support        = "enable"

  tags = {
    Name = "${var.environment}-tgw-attach-primary"
  }
}

resource "aws_ec2_transit_gateway" "secondary" {
  provider                        = aws.secondary
  description                     = "Secondary region Transit Gateway"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"

  tags = {
    Name = "${var.environment}-tgw-secondary"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "secondary" {
  provider           = aws.secondary
  transit_gateway_id = aws_ec2_transit_gateway.secondary.id
  vpc_id             = module.vpc_secondary.vpc_id
  subnet_ids         = module.vpc_secondary.private_subnets
  dns_support        = "enable"

  tags = {
    Name = "${var.environment}-tgw-attach-secondary"
  }
}

# Inter-region TGW peering
resource "aws_ec2_transit_gateway_peering_attachment" "cross_region" {
  transit_gateway_id      = aws_ec2_transit_gateway.primary.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.secondary.id
  peer_region             = var.secondary_region

  tags = {
    Name = "${var.environment}-tgw-peering"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "cross_region" {
  provider                      = aws.secondary
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.cross_region.id

  tags = {
    Name = "${var.environment}-tgw-peering-accepter"
  }
}

# ===========================================================================
# Aurora Global Database
#
# EXAM TIP: Aurora Global Database uses dedicated replication infrastructure
# that doesn't impact database performance.  Cross-region replicas have
# typical replication lag of < 1 second.  Managed planned failover is
# zero data loss; unplanned (detach+promote) may lose last ~1s of writes.
# Aurora PostgreSQL and MySQL are both supported.
# ===========================================================================
resource "aws_rds_global_cluster" "main" {
  global_cluster_identifier = "${var.environment}-global-db"
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
  storage_encrypted         = true
  deletion_protection       = true
}

resource "aws_rds_cluster" "primary" {
  cluster_identifier          = "${var.environment}-aurora-primary"
  global_cluster_identifier   = aws_rds_global_cluster.main.id
  engine                      = aws_rds_global_cluster.main.engine
  engine_version              = aws_rds_global_cluster.main.engine_version
  master_username             = "dbadmin"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.primary.name
  vpc_security_group_ids      = [aws_security_group.aurora_primary.id]
  storage_encrypted           = true
  backup_retention_period     = 35
  preferred_backup_window     = "03:00-04:00"
  deletion_protection         = true
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.environment}-aurora-primary-final"

  enabled_cloudwatch_logs_exports = ["postgresql"]
}

resource "aws_rds_cluster_instance" "primary" {
  count              = 2
  identifier         = "${var.environment}-aurora-primary-${count.index}"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = "db.r6g.xlarge"
  engine             = aws_rds_cluster.primary.engine

  performance_insights_enabled          = true
  performance_insights_retention_period = 731
  monitoring_interval                   = 60
  monitoring_role_arn                   = aws_iam_role.rds_monitoring.arn
}

resource "aws_rds_cluster" "secondary" {
  provider                    = aws.secondary
  cluster_identifier          = "${var.environment}-aurora-secondary"
  global_cluster_identifier   = aws_rds_global_cluster.main.id
  engine                      = aws_rds_global_cluster.main.engine
  engine_version              = aws_rds_global_cluster.main.engine_version
  db_subnet_group_name        = aws_db_subnet_group.secondary.name
  vpc_security_group_ids      = [aws_security_group.aurora_secondary.id]
  storage_encrypted           = true
  backup_retention_period     = 35
  deletion_protection         = true
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.environment}-aurora-secondary-final"

  # Secondary cluster cannot have master credentials until promoted
  depends_on = [aws_rds_cluster.primary]

  lifecycle {
    ignore_changes = [
      replication_source_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "secondary" {
  provider           = aws.secondary
  count              = 2
  identifier         = "${var.environment}-aurora-secondary-${count.index}"
  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = "db.r6g.xlarge"
  engine             = aws_rds_cluster.secondary.engine

  performance_insights_enabled          = true
  performance_insights_retention_period = 731
}

resource "aws_db_subnet_group" "primary" {
  name       = "${var.environment}-aurora-primary"
  subnet_ids = module.vpc_primary.intra_subnets
}

resource "aws_db_subnet_group" "secondary" {
  provider   = aws.secondary
  name       = "${var.environment}-aurora-secondary"
  subnet_ids = module.vpc_secondary.intra_subnets
}

resource "aws_security_group" "aurora_primary" {
  name_prefix = "${var.environment}-aurora-primary-"
  vpc_id      = module.vpc_primary.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
    description = "PostgreSQL from primary VPC"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "aurora_secondary" {
  provider    = aws.secondary
  name_prefix = "${var.environment}-aurora-secondary-"
  vpc_id      = module.vpc_secondary.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
    description = "PostgreSQL from secondary VPC"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name = "${var.environment}-rds-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  ]
}

# ===========================================================================
# S3 Cross-Region Replication
# ===========================================================================
resource "aws_s3_bucket" "primary" {
  bucket = "${var.environment}-data-primary-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "${var.environment}-data-secondary-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_iam_role" "replication" {
  name = "${var.environment}-s3-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "replication" {
  name = "s3-replication-policy"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.primary.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.primary.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.secondary.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  depends_on = [
    aws_s3_bucket_versioning.primary,
    aws_s3_bucket_versioning.secondary
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.primary.id

  rule {
    id     = "full-replication"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD_IA"

      # Replication Time Control (RTC): SLA-backed 15-minute guarantee
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }
    }
  }
}

# ===========================================================================
# ACM Certificates
#
# EXAM TIP: ACM certificates in us-east-1 are required for CloudFront.
# Regional ALBs need certificates in their own region.  ACM DNS
# validation is preferred over email (automated renewal).
# ===========================================================================
resource "aws_acm_certificate" "primary" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "secondary" {
  provider                  = aws.secondary
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate for CloudFront (must be in us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

# ===========================================================================
# Route 53 – Latency-Based Routing
#
# EXAM TIP: Latency-based routing sends users to the region with lowest
# network latency.  Combined with health checks, it provides both
# performance optimization AND automatic failover.  Unlike failover
# routing (active-passive), latency routing is active-active.
# ===========================================================================
resource "aws_route53_health_check" "primary" {
  fqdn              = "primary-alb.${var.domain_name}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 10

  tags = {
    Name = "primary-health-check"
  }
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = "secondary-alb.${var.domain_name}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 10

  tags = {
    Name = "secondary-health-check"
  }
}

resource "aws_route53_record" "primary_latency" {
  zone_id        = var.hosted_zone_id
  name           = "api.${var.domain_name}"
  type           = "A"
  set_identifier = "primary"

  latency_routing_policy {
    region = var.primary_region
  }

  health_check_id = aws_route53_health_check.primary.id

  alias {
    # In production: reference the actual ALB DNS name
    name                   = "primary-alb.${var.domain_name}"
    zone_id                = var.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "secondary_latency" {
  zone_id        = var.hosted_zone_id
  name           = "api.${var.domain_name}"
  type           = "A"
  set_identifier = "secondary"

  latency_routing_policy {
    region = var.secondary_region
  }

  health_check_id = aws_route53_health_check.secondary.id

  alias {
    name                   = "secondary-alb.${var.domain_name}"
    zone_id                = var.hosted_zone_id
    evaluate_target_health = true
  }
}

# ===========================================================================
# CloudFront Distribution
#
# EXAM TIP: CloudFront can have multiple origins with origin groups for
# automatic origin failover.  OAC (Origin Access Control) is the modern
# replacement for OAI for S3 origins.  For ALB origins, use custom
# headers for origin authentication.
# ===========================================================================
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name]
  price_class         = "PriceClass_100"   # US/EU/Israel only (cheapest)
  http_version        = "http2and3"
  web_acl_id          = null               # Attach WAFv2 WebACL here

  # Origin group: automatic failover between primary and secondary
  origin_group {
    origin_id = "api-origin-group"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "primary-api"
    }

    member {
      origin_id = "secondary-api"
    }
  }

  origin {
    origin_id   = "primary-api"
    domain_name = "api-primary.${var.domain_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Origin-Verify"
      value = "SHARED_SECRET_REPLACE_ME"   # ALB validates this header
    }
  }

  origin {
    origin_id   = "secondary-api"
    domain_name = "api-secondary.${var.domain_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Origin-Verify"
      value = "SHARED_SECRET_REPLACE_ME"
    }
  }

  # S3 origin for static assets
  origin {
    origin_id                = "s3-static"
    domain_name              = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  default_cache_behavior {
    target_origin_id       = "api-origin-group"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = true
      headers      = ["Authorization", "Accept", "Origin"]
      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0      # Dynamic API content: no caching
    max_ttl     = 0
  }

  ordered_cache_behavior {
    path_pattern           = "/static/*"
    target_origin_id       = "s3-static"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400     # 1 day for static assets
    max_ttl     = 31536000  # 1 year max
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name = "${var.environment}-cloudfront"
  }
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${var.environment}-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ===========================================================================
# Outputs
# ===========================================================================
output "primary_vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "secondary_vpc_id" {
  value = module.vpc_secondary.vpc_id
}

output "aurora_primary_endpoint" {
  value = aws_rds_cluster.primary.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.primary.reader_endpoint
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "primary_tgw_id" {
  value = aws_ec2_transit_gateway.primary.id
}

output "secondary_tgw_id" {
  value = aws_ec2_transit_gateway.secondary.id
}
