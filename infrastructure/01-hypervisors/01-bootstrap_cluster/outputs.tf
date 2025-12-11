output "terraform_api_token" {
  description = "API Token used for terraform operations."
  value       = proxmox_virtual_environment_user_token.terraform_api_token.value
  sensitive   = true
}
