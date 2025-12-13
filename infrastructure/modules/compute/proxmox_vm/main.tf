resource "proxmox_virtual_environment_vm" "this" {
  vm_id               = var.vm_id
  name                = var.vm_name
  description         = var.vm_description
  tags                = var.vm_tags
  node_name           = var.vm_node
  on_boot             = var.vm_onboot
  reboot              = var.vm_reboot
  reboot_after_update = var.vm_reboot_after_update
  migrate             = true
  stop_on_destroy     = var.vm_stop_on_destroy
  scsi_hardware       = var.vm_scsi_hardware
  keyboard_layout     = var.vm_keyboard_layout

  machine = var.vm_machine
  bios    = var.vm_bios

  boot_order = var.vm_boot_order

  operating_system {
    type = var.vm_os
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.res_cpu_cores
    type  = var.res_cpu_type
    units = var.res_cpu_units
  }

  memory {
    dedicated = var.res_dedicated_memory
    floating  = var.res_enable_ballooning ? var.res_dedicated_memory : null
  }

  initialization {
    datastore_id = var.vm_initialization_datastore_id

    ip_config {
      ipv4 {
        address = var.network_ipv4_address
        gateway = var.network_gateway
      }
    }

    dynamic "dns" {
      for_each = length(var.network_dns_servers) > 0 ? [0] : []

      content {
        servers = var.network_dns_servers
      }
    }
  }

  network_device {
    bridge       = "vmbr0"
    mac_address  = var.network_mac
    disconnected = var.network_disconnected
    firewall     = var.network_firewall
    model        = "virtio"
  }

  dynamic "cdrom" {
    for_each = var.vm_iso_file == null ? [] : [0]

    content {
      file_id = var.vm_iso_file
    }
  }

  tpm_state {
    datastore_id = var.res_tpm_state_datastore_id
  }

  efi_disk {
    datastore_id      = var.res_efi_disk_datastore_id
    type              = "4m"
    file_format       = "raw"
    pre_enrolled_keys = var.res_efi_disk_pre_enrolled_keys
  }

  dynamic "disk" {
    for_each = var.res_disks

    content {
      datastore_id      = disk.value.datastore_id
      interface         = disk.value.interface
      size              = disk.value.size
      path_in_datastore = disk.value.path_in_datastore
      ssd               = disk.value.ssd
      iothread          = disk.value.iothread
      aio               = disk.value.aio
      backup            = disk.value.backup
      cache             = disk.value.cache
      discard           = disk.value.discard
      file_format       = disk.value.file_format
      replicate         = disk.value.replicate
    }
  }

  dynamic "hostpci" {
    for_each = var.res_hostpci

    content {
      device  = hostpci.value.device
      mapping = hostpci.value.mapping
      pcie    = hostpci.value.pcie
      rombar  = hostpci.value.rombar
      xvga    = hostpci.value.xvga
    }
  }
}
