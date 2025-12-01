variable "network_ipaddress" {
  type        = string
  description = "The IP address to assign to the VM."
}

variable "network_gateway" {
  type        = string
  description = "The gateway for the VM's network."
}

variable "network_dns_servers" {
  type        = list(string)
  description = "The DNS servers for the VM."
}

variable "network_mac" {
  type        = string
  description = "The MAC address to assign to the VM."
}
