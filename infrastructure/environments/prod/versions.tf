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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.1"
    }
  }
}
