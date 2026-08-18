output "app_name" {
  description = "Value received from the tf_var"
  value       = var.app_name
}

output "environment" {
  value = var.environment
}

output "replica_names" {
  description = "One entry per replica — proves count/state worked"
  value       = [for r in terraform_data.replica : r.output]
}

output "sample_env_from_env_var" {
  description = "Value read from the SAMPLE_ENV workspace env_var"
  value       = data.external.env_probe.result["sample_env"]
}

output "tags" {
  value = var.tags
}

output "smoke" {
  value = "infra-workflow pipeline OK"
}
