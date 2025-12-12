variable "res_cpu_cores" {
  description = "The number of cores dedicated to the VM."
  type        = number
  default     = 2
}

variable "res_cpu_type" {
  description = "The type of the CPU cores dedicated to the VM."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "res_cpu_units" {
  description = "The unit of the CPU."
  type        = number
  default     = 1024
}

variable "res_dedicated_memory" {
  description = "The amount of memory dedicated to the VM."
  type        = number
  default     = 2048
}

variable "res_enable_ballooning" {
  description = "Should ballooning be enabled for the VM?"
  type        = bool
  default     = true
}

variable "res_disks" {
  description = "List of disks to create for the VM."
  type = list(object({
    datastore_id      = string
    interface         = string
    size              = number
    path_in_datastore = string
    ssd               = bool
    iothread          = bool
  }))
  default = [{
    datastore_id      = "storage"
    interface         = "scsi0"
    size              = 20
    path_in_datastore = ""
    ssd               = false
    iothread          = false
  }]
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
