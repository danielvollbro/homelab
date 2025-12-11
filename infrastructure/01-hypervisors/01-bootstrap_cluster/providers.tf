provider "proxmox" {
  endpoint = var.proxmox_url
  insecure = true

  # Note: Using API Token is more secure and should always be the prefered way
  #       to authenticate with the Proxmox API, but because we are creating the
  #       API token using terraform we don't have it in this context so we need
  #       to use SSH authentication for the bootstraping of the cluster.
  username = var.ssh_username
  password = var.ssh_password

  ssh {
    agent = true
  }
}
