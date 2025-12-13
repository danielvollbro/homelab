module "vm" {
  source = "../../modules/platform/windows"

  vm_id        = 100
  vm_name      = "gaming-pc"
  vm_node_name = "ravenclaw"

  res_cpu_cores         = 8
  res_cpu_type          = "host"
  res_dedicated_memory  = 32768
  res_enable_ballooning = false

  res_disks = [
    {
      datastore_id      = "data"
      interface         = "scsi0"
      size              = 200
      path_in_datastore = "vm-100-disk-0"
      ssd               = true
      iothread          = true
      aio               = "io_uring"
      backup            = true
      cache             = "none"
      discard           = "ignore"
      file_format       = "raw"
      replicate         = true
    },
    {
      datastore_id      = "storage"
      interface         = "scsi1"
      size              = 500
      path_in_datastore = "vm-100-disk-2"
      ssd               = true
      iothread          = true
      aio               = "io_uring"
      backup            = true
      cache             = "none"
      discard           = "ignore"
      file_format       = "raw"
      replicate         = true
    }
  ]

  net_mac = "BC:24:11:87:E5:6C"

  res_hostpci = [{
    device  = "hostpci0"
    mapping = "RTX3070"
    pcie    = true
    rombar  = true
    xvga    = true
  }]
}
