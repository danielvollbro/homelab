resource "proxmox_virtual_environment_apt_repository" "ceph" {
  enabled   = false
  file_path = "/etc/apt/sources.list.d/ceph.list"
  index     = 0
  node      = local.node
}
