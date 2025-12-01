variable "node_hostname" {
  type        = string
  description = "The Talos node hostname."
}

variable "node_machine_secrets" {
  type        = any
  description = "The Talos machine secrets."
  sensitive   = true
}

variable "node_client_configuration" {
  type        = any
  description = "The Talos client configuration."
  sensitive   = true
}

variable "node_machine_installer" {
  type        = string
  description = "The Talos machine installer image URL."
}
