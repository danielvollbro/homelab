module "this" {
  source = "../../compute/proxmox_vm"

  vm_id                          = var.vm_id
  vm_name                        = var.vm_name
  vm_node                        = var.vm_node_name
  vm_tags                        = ["terraform", "windows"]
  vm_machine                     = "pc-q35-10.0"
  vm_os                          = "win11"
  vm_initialization_datastore_id = "data"
  vm_scsi_hardware               = "virtio-scsi-single"
  vm_reboot_after_update         = false

  res_hostpci                    = var.res_hostpci
  res_disks                      = var.res_disks
  res_cpu_cores                  = var.res_cpu_cores
  res_cpu_type                   = var.res_cpu_type
  res_cpu_units                  = 1024
  res_dedicated_memory           = var.res_dedicated_memory
  res_enable_ballooning          = var.res_enable_ballooning
  res_tpm_state_datastore_id     = "storage"
  res_efi_disk_datastore_id      = "storage"
  res_efi_disk_pre_enrolled_keys = true

  network_mac      = var.net_mac
  network_firewall = true
}
