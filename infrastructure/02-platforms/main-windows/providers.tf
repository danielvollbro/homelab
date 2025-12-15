provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = var.proxmox_api_token

  ssh {
    agent = true
  }
}
