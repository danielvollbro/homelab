provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = var.ssh_username
  }
}
