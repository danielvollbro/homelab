variable "res_cpu_cores" {
  type        = number
  default     = 2
  description = "The amount of CPU cores that will be allocated to the node."
}

variable "res_dedicated_memory" {
  type        = number
  default     = 2048
  description = "The amount of dedicated memory (in MB) that will be allocated to the node."
}

variable "res_disc_size" {
  type        = number
  default     = 20
  description = "The size of the disk (in GB) that will be allocated to the node."
}
