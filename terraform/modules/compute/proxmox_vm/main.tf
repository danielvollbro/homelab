resource "proxmox_virtual_environment_vm" "talos_node" {
  vm_id           = var.vm_id
  name            = var.vm_name
  node_name       = var.vm_node
  on_boot         = var.vm_onboot
  migrate         = true
  stop_on_destroy = true

  machine = "q35"
  bios    = "ovmf"

  boot_order = ["virtio0", "ide3", "net0"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.res_cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.res_dedicated_memory
  }

  initialization {
    datastore_id = "WD3TB"

    ip_config {
      ipv4 {
        address = "${var.network_ipaddress}/24"
        gateway = var.network_gateway
      }
    }

    dns {
      servers = var.network_dns_servers
    }
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = var.network_mac
  }

  cdrom {
    file_id = var.vm_iso_file
  }

  tpm_state {
    datastore_id = "WD3TB"
  }

  efi_disk {
    datastore_id      = "WD3TB"
    type              = "4m"
    file_format       = "raw"
    pre_enrolled_keys = false
  }

  disk {
    datastore_id = "WD3TB"
    interface    = "virtio0"
    size         = var.res_disc_size
    file_format  = "raw"
  }
}
