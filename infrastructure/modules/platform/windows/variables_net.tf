variable "net_mac" {
  description = "The mac of the network device."
  type        = string
}

variable "net_ipv4_address" {
  description = "The IPv4 address for the VM."
  type        = string
  default     = "dhcp"
}
