variable "cluster_vip" {
  type        = string
  description = "The VIP address for the Kubernetes API server."
}

variable "cilium_version" {
  type        = string
  description = "The version of Cilium to deploy."
}
