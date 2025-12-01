provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = var.ssh_username
  }
}

provider "github" {
  owner = var.github_username
  token = var.github_token
}

provider "flux" {
  kubernetes = {
    host = yamldecode(module.talos_cluster.kubeconfig).clusters[0].cluster.server

    client_certificate = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).users[0].user.client-certificate-data
    )
    client_key = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).users[0].user.client-key-data
    )
    cluster_ca_certificate = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).clusters[0].cluster.certificate-authority-data
    )
  }

  git = {
    url = "https://github.com/${var.github_username}/${var.github_repo}.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}

provider "helm" {
  kubernetes = {
    host = yamldecode(module.talos_cluster.kubeconfig).clusters[0].cluster.server

    client_certificate = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).users[0].user.client-certificate-data
    )
    client_key = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).users[0].user.client-key-data
    )
    cluster_ca_certificate = base64decode(
      yamldecode(module.talos_cluster.kubeconfig).clusters[0].cluster.certificate-authority-data
    )
  }
}
