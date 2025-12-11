/*
  Notice: This file has a lot of configuration, this VM I created 2020 and has
  been manually managed since, the current version of the provider want to make
  a lot of changes that I don't feel comfortable right now.

  The plan for this NAS is to make it a stand alone machine that is not
  virtualize so I just let it run as is until then.
*/

resource "proxmox_virtual_environment_vm" "this" {
  name        = "truenas"
  description = "Managed by Terraform"
  tags        = ["terraform", "truenas"]

  node_name       = "gryffindor"
  vm_id           = 1000
  keyboard_layout = "sv"
  machine         = "q35"
  bios            = "ovmf"

  agent {
    enabled = true
  }

  cpu {
    cores = 6
    type  = "host"
  }

  memory {
    dedicated = 32768
  }

  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "none"
    datastore_id      = "local-zfs"
    discard           = "ignore"
    file_format       = "raw"
    interface         = "virtio0"
    iothread          = true
    path_in_datastore = "vm-1000-disk-2"
    replicate         = true
    size              = 50
    ssd               = false
  }


  efi_disk {
    datastore_id      = "local-zfs"
    file_format       = "raw"
    pre_enrolled_keys = false
    type              = "4m"
  }

  initialization {
    datastore_id = ""

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge       = "vmbr0"
    disconnected = true
  }

  hostpci {
    device  = "hostpci0"
    mapping = "HBA"
    pcie    = true
    rombar  = false
    xvga    = false
  }
  hostpci {
    device  = "hostpci1"
    mapping = "NIC1"
    pcie    = true
    rombar  = false
    xvga    = false
  }
  hostpci {
    device  = "hostpci2"
    mapping = "NIC2"
    pcie    = true
    rombar  = false
    xvga    = false
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version      = "v2.0"
    datastore_id = "local-zfs"
  }
}
