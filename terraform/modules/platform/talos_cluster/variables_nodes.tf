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

variable "nodes_extensions" {
  type        = list(string)
  description = "List of Talos system extensions to include in the nodes."
}
