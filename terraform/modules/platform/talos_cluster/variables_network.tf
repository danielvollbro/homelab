variable "network_gateway" {
  type        = string
  description = "The gateway that will be set on each node."
}

variable "network_dns_servers" {
  type        = list(string)
  description = "The DNS servers that will be set on the node."
}

variable "network_nodes_configs" {
  type = map(object({
    mac = string
    ip  = string
  }))
  description = "A map of network configurations for each cluster node."
}
