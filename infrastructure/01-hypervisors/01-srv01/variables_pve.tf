variable "proxmox_url" {
  type        = string
  description = "The URL for the Proxmox server."
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "The API token for Proxmox."
}

variable "ssh_username" {
  type        = string
  description = "The SSH username for Proxmox."
}
