variable "res_cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the VM."
}

variable "res_cpu_type" {
  description = "The type of the CPU cores dedicated to the VM."
  type        = string
  default     = "x86-64-v2-AES"
}

variable "res_cpu_units" {
  description = "The unit of the CPU."
  type        = number
  default     = 100
}

variable "res_dedicated_memory" {
  type        = number
  description = "The amount of dedicated memory (in MB) to allocate to the VM."
}

variable "res_enable_ballooning" {
  description = "Should ballooning be enabled for the VM?"
  type        = bool
  default     = false
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

variable "res_tpm_state_datastore_id" {
  type        = string
  description = "Where the TPM state should be stored"
}

variable "res_efi_disk_datastore_id" {
  type        = string
  description = "Where the EFI disk should be stored"
}

variable "res_efi_disk_pre_enrolled_keys" {
  type        = bool
  description = "Should the VM use the Pre Enrolled Keys"
  default     = false
}
