variable "vm_id" {
  description = "The ID of the VM in the PVE."
  type        = number
}

variable "vm_name" {
  description = "The name of the VM in the PVE."
  type        = string
}

variable "vm_node_name" {
  description = "What node should the VM be connected to?"
  type        = string
}
