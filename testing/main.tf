terraform {
  # Lowered from ">= 1.10": your executor is 1.9.4, and nothing here needs 1.10.
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.session_token
}

variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-2"
}

variable "access_key" {
  type        = string
  description = "AWS access key id for the target account"
  sensitive   = true
}

variable "secret_key" {
  type        = string
  description = "AWS secret access key for the target account"
  sensitive   = true
}

variable "session_token" {
  type        = string
  description = "AWS session token; only needed when the credentials are temporary"
  sensitive   = true
  default     = ""
}

variable "owner" {
  type        = string
  description = "Probe variable. Surfaces in a tag so variable pass-through is visible in a plan diff."
  default     = "unset"
}

resource "aws_s3_bucket" "qa" {
  bucket_prefix = "atmosly-qa-"

  tags = {
    ManagedBy = "atmosly"
    Purpose   = "infra-management-qa"
    Owner     = var.owner
    CaseThree = "drift-probe-1"
  }
}

# Proves which account actually authenticated.
data "aws_caller_identity" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "bucket_name" {
  value = aws_s3_bucket.qa.id
}

output "bucket_arn" {
  value = aws_s3_bucket.qa.arn
}

output "owner_seen_by_terraform" {
  value = var.owner
}
