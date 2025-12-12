variable "proxmox_url" {
  type        = string
  description = "The URL for the Proxmox server."
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "The API token for Proxmox."
}
