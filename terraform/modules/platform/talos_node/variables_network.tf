variable "network_ipaddress" {
  type        = string
  description = "The IP address that will be set on the node."
}

variable "network_gateway" {
  type        = string
  description = "The gateway that will be set on the node."
}

variable "network_mac" {
  type        = string
  description = "The MAC address that will be set on the node."
}

variable "network_dns_servers" {
  type        = list(string)
  description = "The DNS servers that will be set on the node."
}
