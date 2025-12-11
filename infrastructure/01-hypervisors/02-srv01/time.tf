resource "proxmox_virtual_environment_time" "time" {
  node_name = local.node
  time_zone = "Europe/Stockholm"
}
