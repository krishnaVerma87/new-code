output "aws_account_id" {
  description = "Account the run authenticated as — verify this is YOUR account, not Atmosly's"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Region the provider resolved from AWS_REGION"
  value       = data.aws_region.current.name
}

output "bucket_name" {
  description = "Name of the created bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the created bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Regional domain name of the created bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
