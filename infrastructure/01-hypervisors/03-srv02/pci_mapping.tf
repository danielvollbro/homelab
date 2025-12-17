resource "proxmox_virtual_environment_hardware_mapping_pci" "rtx3070_mapping" {
  name = "RTX3070"
  map = [
    {
      id           = "10de:2484"
      iommu_group  = 23
      node         = local.node
      path         = "0000:05:00"
      subsystem_id = "1043:87c1"
    },
  ]
  mediated_devices = false
}
