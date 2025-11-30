variable "cluster_name" {
  type        = string
  description = "The name of the Talos cluster."
}

variable "cluster_vip" {
  type        = string
  description = "The IP address for the Talos cluster API server."
}
