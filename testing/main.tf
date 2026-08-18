terraform {
  required_version = ">= 1.4"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

# Reads a plain workspace env_var. Terraform can only see env vars natively when
# they are TF_VAR_-prefixed, so this proves non-prefixed env_vars reach the pod.
data "external" "env_probe" {
  program = ["sh", "-c", "printf '{\"sample_env\":\"%s\"}' \"$SAMPLE_ENV\""]
}

# terraform_data is built into Terraform >= 1.4 — no cloud provider, no credentials,
# no real resource. It still lands in state, so state upload and the Outputs /
# Associated Resources tabs all get exercised.
resource "terraform_data" "deployment" {
  input = {
    app         = var.app_name
    environment = var.environment
    replicas    = var.replica_count
    env_value   = data.external.env_probe.result["sample_env"]
  }
}

resource "terraform_data" "replica" {
  count = var.replica_count
  input = "${var.app_name}-${var.environment}-${count.index}"
}
