locals {
  cluster_name = "${var.cluster_env}-cluster"
}

module "talos_image" {
  source = "../talos_image"

  official_extensions = var.nodes_extensions
  talos_version       = var.cluster_talos_version
}

module "talos_iso" {
  source = "../../compute/iso_file"

  node     = "srv01"
  url      = module.talos_image.download_iso_secureboot
  filename = "${var.cluster_env}-nocloud-amd64-secureboot.iso"
}

resource "talos_machine_secrets" "this" {}

module "nodes" {
  source = "../talos_node"
  count  = var.nodes_count

  vm_id       = var.nodes_vm_start_id + count.index
  vm_node     = var.nodes_pve_node
  vm_iso_file = module.talos_iso.id

  network_ipaddress   = var.network_nodes_configs[tostring(count.index)]["ip"]
  network_mac         = var.network_nodes_configs[tostring(count.index)]["mac"]
  network_gateway     = var.network_gateway
  network_dns_servers = var.network_dns_servers

  cluster_name          = local.cluster_name
  cluster_vip           = var.cluster_vip
  cluster_talos_version = var.cluster_talos_version

  node_hostname             = "talos-${var.cluster_env}-node-${count.index}"
  node_machine_secrets      = talos_machine_secrets.this.machine_secrets
  node_client_configuration = talos_machine_secrets.this.client_configuration
  node_machine_installer    = module.talos_image.download_installer_secureboot
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [module.nodes]
  client_configuration = talos_machine_secrets.this.client_configuration

  node = var.network_nodes_configs["0"]["ip"]
}

data "talos_cluster_health" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes = [
    for k, v in var.network_nodes_configs : v.ip
  ]
  endpoints = [var.network_nodes_configs["0"]["ip"]]

  timeouts = {
    read = "10m"
  }

  skip_kubernetes_checks = true
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [data.talos_cluster_health.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.network_nodes_configs["0"]["ip"]
}
