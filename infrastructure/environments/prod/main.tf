module "talos_cluster" {
  source = "../../modules/platform/talos_cluster"

  cluster_name          = "prod-cluster"
  cluster_vip           = var.talos_cluster_vip
  cluster_talos_version = "v1.11.5"

  nodes_count       = length(var.talos_node_configs)
  nodes_vm_start_id = 200
  nodes_pve_node    = "gryffindor"
  nodes_extensions = [
    "siderolabs/qemu-guest-agent",
    "siderolabs/iscsi-tools"
  ]

  network_gateway       = var.gateway
  network_dns_servers   = var.dns_servers
  network_nodes_configs = var.talos_node_configs
}

module "cilium_bootstrap" {
  source = "../../modules/platform/cilium_bootstrap"

  cluster_vip    = var.talos_cluster_vip
  cilium_version = "1.18.4"

  depends_on = [module.talos_cluster]
}

resource "time_sleep" "wait_for_network" {
  depends_on = [module.cilium_bootstrap]

  // Wait for Cilium network to stabilize
  create_duration = "180s"
}

module "flux_bootstrap" {
  source = "../../modules/platform/flux_bootstrap"

  depends_on = [time_sleep.wait_for_network]

  target_path     = "gitops/flux/clusters/prod"
  github_repo     = var.github_repo
  age_key_content = file("${path.root}/../../../age.agekey")
  truenas_api_key = var.truenas_api_key
}
