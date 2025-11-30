variable "vm_id" {
  type        = number
  description = "The ID of the Proxmox VM."
}

variable "vm_name" {
  type        = string
  description = "The name of the Proxmox VM."
}

variable "vm_node" {
  type        = string
  description = "The Proxmox node where the VM will be created."
}

variable "vm_onboot" {
  type        = bool
  description = "Whether the VM should start on Proxmox boot."
}

variable "vm_iso_file" {
  type        = string
  description = "The ISO file to use for the VM."
}
