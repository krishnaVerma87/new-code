terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Deliberately empty. The provider reads AWS_ACCESS_KEY_ID,
# AWS_SECRET_ACCESS_KEY (and AWS_SESSION_TOKEN when present) plus AWS_REGION
# from the workspace environment variables — no credentials live in this repo.
#
# No `backend` block here either: Atmosly injects its own
# (atmosly_backend_override.tf) to keep state in its bucket.
provider "aws" {}

# Reports which account the run actually authenticated as. If `aws_account_id`
# comes back as Atmosly's account rather than yours, the env-var credentials did
# not take effect and the provider fell through to the pod's IRSA identity.
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # Test bucket — lets `terraform destroy` succeed even if objects exist.
  force_destroy = true

  tags = merge(var.tags, {
    Name      = var.bucket_name
    ManagedBy = "atmosly-infra-workflow"
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}
