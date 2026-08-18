# Required — no default. Omit these from the workspace tf_vars and the run
# fails fast with "No value for required variable", which is itself a useful test.
variable "app_name" {
  description = "Logical application name"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
}

# Optional — has a default, so it works whether or not you set a tf_var.
variable "replica_count" {
  description = "Number of replicas to simulate"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Arbitrary key/value tags"
  type        = map(string)
  default     = {}
}
