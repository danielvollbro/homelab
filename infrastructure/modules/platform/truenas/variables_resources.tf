variable "res_cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the VM."
}

variable "res_cpu_type" {
  description = "The type of the CPU cores dedicated to the VM."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "res_dedicated_memory" {
  type        = number
  description = "The amount of dedicated memory (in MB) to allocate to the VM."
}

variable "res_disks" {
  description = "List of disks to create for the VM."
  type = list(object({
    aio               = string
    backup            = bool
    cache             = string
    datastore_id      = string
    discard           = string
    file_format       = string
    interface         = string
    iothread          = bool
    path_in_datastore = string
    replicate         = bool
    size              = number
    ssd               = bool
  }))
}

variable "res_hostpci" {
  description = "List of mapped pci devices from host."
  type = list(object({
    device  = string
    mapping = string
    pcie    = bool
    rombar  = bool
    xvga    = bool
  }))

  default = []
}
