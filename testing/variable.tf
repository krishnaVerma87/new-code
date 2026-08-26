variable "bucket_name_prefix" {
  description = "Prefix for the bucket name; the AWS account ID is appended to keep it globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,40}$", var.bucket_name_prefix))
    error_message = "Lowercase letters, digits and hyphens only, starting with a letter or digit."
  }
}

variable "tags" {
  description = "Extra tags applied to the bucket"
  type        = map(string)
  default     = {}
}
