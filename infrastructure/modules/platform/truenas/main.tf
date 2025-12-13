module "this" {
  source = "../../compute/proxmox_vm"

  vm_id                  = var.vm_id
  vm_name                = var.vm_name
  vm_node                = var.vm_node_name
  vm_tags                = ["terraform", "truenas"]
  vm_os                  = "l26"
  vm_keyboard_layout     = "sv"
  vm_reboot_after_update = false

  vm_initialization_datastore_id = "WD3TB"

  res_cpu_cores              = var.res_cpu_cores
  res_cpu_type               = var.res_cpu_type
  res_dedicated_memory       = var.res_dedicated_memory
  res_tpm_state_datastore_id = "local-zfs"
  res_efi_disk_datastore_id  = "local-zfs"
  res_hostpci                = var.res_hostpci
  res_disks                  = var.res_disks

  network_mac          = var.network_mac
  network_disconnected = var.network_disconnected
}
