variable "proxmox_url" {
  type        = string
  description = "The URL for the Proxmox server."
}

variable "ssh_username" {
  type        = string
  description = "The SSH username for Proxmox."
}

variable "ssh_password" {
  type        = string
  description = "The SSH password for Proxmox."
}
