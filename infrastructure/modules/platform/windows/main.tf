resource "proxmox_virtual_environment_vm" "this" {
  vm_id               = var.vm_id
  name                = var.vm_name
  node_name           = var.vm_node_name
  description         = var.vm_description
  tags                = ["terraform", "windows"]
  stop_on_destroy     = var.vm_stop_on_destroy
  reboot              = false
  reboot_after_update = false

  bios          = "ovmf"
  machine       = "pc-q35-10.0"
  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = var.vm_agent_enabled
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

  network_device {
    disconnected = false
    firewall     = true
    mac_address  = var.net_mac
    model        = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.net_ipv4_address
      }
    }
  }

  efi_disk {
    datastore_id      = "storage"
    file_format       = "raw"
    pre_enrolled_keys = true
    type              = "4m"
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

  operating_system {
    type = "win11"
  }

  tpm_state {
    datastore_id = "storage"
  }
}
