resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  depends_on = [
    proxmox_virtual_environment_network_linux_vlan.vlan
  ]

  node_name = local.node
  name      = "vmbr0"

  address = "${local.ip}/24"
  gateway = local.gateway

  ports = [
    "enp0s25"
  ]

  autostart  = true
  vlan_aware = true
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan" {
  node_name = local.node
  name      = "vmbr0.${local.vlan}"
}
