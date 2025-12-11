resource "proxmox_virtual_environment_hardware_mapping_pci" "hba_mapping" {
  name = "HBA"
  map = [
    {
      id           = "1000:0087"
      iommu_group  = 32
      node         = local.main_node
      path         = "0000:02:00.0"
      subsystem_id = "1000:3020"
    },
  ]
  mediated_devices = false
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "nic1_mapping" {
  name = "NIC1"
  map = [
    {
      id           = "8086:1533"
      iommu_group  = 34
      node         = local.main_node
      path         = "0000:05:00.0"
      subsystem_id = "1849:1533"
    },
  ]
  mediated_devices = false
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "nic2_mapping" {
  name = "NIC2"
  map = [
    {
      id           = "10ec:8168"
      iommu_group  = 31
      node         = local.main_node
      path         = "0000:01:00.0"
      subsystem_id = "7470:3468"
    },
  ]
  mediated_devices = false
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "rtx3070_mapping" {
  name = "RTX3070"
  map = [
    {
      id           = "10de:2484"
      iommu_group  = 24
      node         = local.srv02
      path         = "0000:05:00"
      subsystem_id = "1043:87c1"
    },
  ]
  mediated_devices = false
}
