variable "node_hostname" {
  type        = string
  description = "The Talos node hostname."
}

variable "node_machine_secrets" {
  type        = any
  description = "The Talos machine secrets."
  sensitive   = true
}

variable "node_machine_installer" {
  type = string
}
