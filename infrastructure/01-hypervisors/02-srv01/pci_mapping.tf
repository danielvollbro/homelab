resource "proxmox_virtual_environment_hardware_mapping_pci" "hba_mapping" {
  name = "HBA"
  map = [
    {
      id           = "1000:0087"
      iommu_group  = 32
      node         = local.node
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
      node         = local.node
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
      node         = local.node
      path         = "0000:01:00.0"
      subsystem_id = "7470:3468"
    },
  ]
  mediated_devices = false
}
