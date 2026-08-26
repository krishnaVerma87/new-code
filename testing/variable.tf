variable "bucket_name" {
  description = "Exact S3 bucket name to create — must be globally unique across all of AWS"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "3-63 chars, lowercase letters, digits, hyphens or dots, starting and ending with a letter or digit."
  }
}

variable "versioning_enabled" {
  description = "Whether to enable object versioning on the bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags applied to the bucket"
  type        = map(string)
  default     = {}
}
