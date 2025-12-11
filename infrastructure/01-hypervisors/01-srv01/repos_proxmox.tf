resource "proxmox_virtual_environment_apt_standard_repository" "proxmox_no_sub" {
  handle = "no-subscription"
  node   = local.node
}

resource "proxmox_virtual_environment_apt_repository" "proxmox_trixie" {
  enabled   = true
  file_path = proxmox_virtual_environment_apt_standard_repository.proxmox_no_sub.file_path
  index     = proxmox_virtual_environment_apt_standard_repository.proxmox_no_sub.index
  node      = proxmox_virtual_environment_apt_standard_repository.proxmox_no_sub.node
}

resource "proxmox_virtual_environment_apt_repository" "pve_enterprise_trixie" {
  enabled   = false
  file_path = "/etc/apt/sources.list.d/pve-enterprise.list"
  index     = 0
  node      = local.node
}

resource "proxmox_virtual_environment_apt_repository" "pve_enterprise_sources_trixie" {
  enabled   = false
  file_path = "/etc/apt/sources.list.d/pve-enterprise.sources"
  index     = 0
  node      = local.node
}
