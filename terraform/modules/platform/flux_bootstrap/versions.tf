terraform {
  required_providers {
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
