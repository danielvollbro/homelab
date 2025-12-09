variable "vm_id" {
  type        = number
  description = "The ID that will be set to the VM in Proxmox."
}

variable "vm_node" {
  type        = string
  description = "The Proxmox node where the VM will be created."
}

variable "vm_onboot" {
  type        = bool
  default     = true
  description = "Whether the VM should start on boot."
}

variable "vm_iso_file" {
  type        = string
  description = "The ISO file to use for the VM."
}
