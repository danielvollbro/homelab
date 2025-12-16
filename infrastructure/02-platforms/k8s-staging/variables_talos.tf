variable "talos_cluster_vip" {
  type        = string
  description = "The VIP for the Talos cluster."
}

variable "talos_node_configs" {
  type = map(object({
    mac = string
    ip  = string
  }))
  description = "A map of Talos node network configurations."
}
