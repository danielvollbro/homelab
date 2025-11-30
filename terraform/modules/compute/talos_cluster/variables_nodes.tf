variable "nodes_count" {
  type        = number
  description = "The number of nodes in the Talos cluster."
}

variable "nodes_vm_start_id" {
  type        = number
  description = "The starting VM ID for the cluster nodes."
}

variable "nodes_pve_node" {
  type        = string
  description = "The Proxmox VE node where the cluster nodes will be created."
}

variable "nodes_iso_file" {
  type        = string
  description = "The ISO file to use for the Talos nodes."
}

variable "nodes_machine_installer" {
  type        = string
  description = "The installer that will be used to install each machine."
}
