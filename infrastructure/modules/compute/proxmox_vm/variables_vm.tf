variable "vm_id" {
  type        = number
  description = "The ID of the Proxmox VM."
}

variable "vm_name" {
  type        = string
  description = "The name of the Proxmox VM."
}

variable "vm_description" {
  description = "An description of the VM in the PVE."
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_tags" {
  description = "Tags added to VM in PVE."
  type        = list(string)
  default     = ["terraform"]
}

variable "vm_node" {
  type        = string
  description = "The Proxmox node where the VM will be created."
}

variable "vm_onboot" {
  type        = bool
  description = "Whether the VM should start on Proxmox boot."
  default     = true
}

variable "vm_reboot" {
  type        = bool
  description = "Should the VM restart after creation?"
  default     = false
}

variable "vm_reboot_after_update" {
  type        = bool
  description = "Should the VM be restarted after updating config?"
  default     = true
}

variable "vm_stop_on_destroy" {
  description = "Should the VM turn off before destroy?"
  type        = bool
  default     = true
}

variable "vm_keyboard_layout" {
  description = "Keyboard layout on the VM."
  type        = string
  default     = "en-us"
}

variable "vm_iso_file" {
  type        = string
  description = "The ISO file to use for the VM."
  default     = null
}

variable "vm_boot_order" {
  type        = list(string)
  description = "Media boot order of VM."
  default     = []
}

variable "vm_bios" {
  type        = string
  description = "BIOS architecture on the VM."
  default     = "ovmf"
}

variable "vm_os" {
  type        = string
  description = "What OS should be running on the VM?"
  default     = "other"
}

variable "vm_machine" {
  type        = string
  description = "The machine type of the VM."
  default     = "q35"
}

variable "vm_initialization_datastore_id" {
  type        = string
  description = "The ID of the datastore to save initialization data to."
}

variable "vm_scsi_hardware" {
  type        = string
  description = "The SCSI hardware type"
  default     = "virtio-scsi-pci"
}
