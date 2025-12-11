resource "proxmox_virtual_environment_apt_repository" "trixie" {
  enabled   = true
  file_path = "/etc/apt/sources.list.d/debian.sources"
  index     = 0
  node      = local.node
}

resource "proxmox_virtual_environment_apt_repository" "trixie_updates" {
  enabled   = true
  file_path = "/etc/apt/sources.list.d/debian.sources"
  index     = 1
  node      = local.node
}

resource "proxmox_virtual_environment_apt_repository" "trixie_security" {
  enabled   = true
  file_path = "/etc/apt/sources.list.d/debian.sources"
  index     = 2
  node      = local.node
}
