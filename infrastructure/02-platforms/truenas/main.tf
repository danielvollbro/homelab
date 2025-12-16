module "truenas_vm" {
  source = "../../modules/platform/truenas"

  vm_id        = 1000
  vm_name      = "truenas"
  vm_node_name = "srv01"

  res_cpu_cores        = 4
  res_cpu_type         = "host"
  res_dedicated_memory = 18432

  res_hostpci = [
    {
      device  = "hostpci0"
      mapping = "HBA"
      pcie    = true
      rombar  = false
      xvga    = false
    },
    {
      device  = "hostpci1"
      mapping = "NIC1"
      pcie    = true
      rombar  = false
      xvga    = false
    },
    {
      device  = "hostpci2"
      mapping = "NIC2"
      pcie    = true
      rombar  = false
      xvga    = false
    }
  ]

  res_disks = [
    {
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
  ]

  network_mac          = "BC:24:11:51:FA:97"
  network_disconnected = true
}
