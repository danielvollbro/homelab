variable "network_ipv4_address" {
  type        = string
  description = "The IP address to assign to the VM."
  default     = "dhcp"
}

variable "network_gateway" {
  type        = string
  description = "The gateway for the VM's network."
  default     = ""
}

variable "network_dns_servers" {
  type        = list(string)
  description = "The DNS servers for the VM."
  default     = []
}

variable "network_mac" {
  type        = string
  description = "The MAC address to assign to the VM."
}

variable "network_firewall" {
  type        = bool
  description = "Should the firewall be enabled?"
  default     = false
}
