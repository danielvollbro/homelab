resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  node_name = local.node
  name      = "vmbr0"

  address = "${local.ip}/24"
  gateway = local.gateway

  ports = [
    "enp6s0"
  ]

  autostart  = true
  vlan_aware = true
}
