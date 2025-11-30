variable "res_cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the VM."
}

variable "res_dedicated_memory" {
  type        = number
  description = "The amount of dedicated memory (in MB) to allocate to the VM."
}

variable "res_disc_size" {
  type        = number
  description = "The size of the VM's disk (in GB)."
}
