variable "network_mac" {
  type        = string
  description = "The MAC address to assign to the VM."
}

variable "network_disconnected" {
  type        = bool
  description = "Should the network device be disconnected?"
  default     = false
}
