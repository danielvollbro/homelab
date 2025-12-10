variable "gateway" {
  type        = string
  description = "Gateway IP address for the network."
}

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS server IP addresses."
}
