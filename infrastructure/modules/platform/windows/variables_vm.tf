variable "vm_id" {
  description = "The ID of the VM in the PVE."
  type        = number
}

variable "vm_name" {
  description = "The name of the VM in the PVE."
  type        = string
}

variable "vm_description" {
  description = "An description of the VM in the PVE."
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_node_name" {
  description = "What node should the VM be connected to?"
  type        = string
}

variable "vm_agent_enabled" {
  description = "Should the QEMU agent be enabled for the VM?"
  type        = bool
  default     = true
}

variable "vm_stop_on_destroy" {
  description = "Should the VM turn off before destroy?"
  type        = bool
  default     = true
}
