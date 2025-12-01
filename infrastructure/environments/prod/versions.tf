terraform {
  required_version = ">= 1.14.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.87.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.9.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.7.6"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.8.3"
    }
  }
}

