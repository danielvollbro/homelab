variable "cluster_env" {
  type        = string
  description = "The environment of the Talos cluster."
}

variable "cluster_vip" {
  type        = string
  description = "The IP address for the Talos cluster API server."
}

variable "cluster_talos_version" {
  type        = string
  description = "The version of Talos to use for the cluster nodes."
}
