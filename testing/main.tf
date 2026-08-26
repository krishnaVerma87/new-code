terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Deliberately empty: the provider picks up AWS_ACCESS_KEY_ID,
# AWS_SECRET_ACCESS_KEY (and AWS_SESSION_TOKEN if present) plus AWS_REGION
# from the workspace environment variables.
provider "aws" {}

# Reports which account the run actually authenticated as. This is the check
# that matters for the issue you're chasing — if `aws_account_id` comes back as
# Atmosly's account, the env-var credentials did not take effect and it fell
# through to the pod's IRSA identity.
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  # Bucket names are globally unique; the account ID keeps this collision-free
  # and doubles as proof of which account the bucket landed in.
  bucket_name = "${var.bucket_name_prefix}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  # Test bucket — lets `terraform destroy` succeed even if objects exist.
  force_destroy = true

  tags = merge(var.tags, {
    Name      = local.bucket_name
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
