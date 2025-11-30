module "talos_cluster" {
  source = "../../modules/platform/talos_cluster"

  cluster_name          = "prod-cluster"
  cluster_vip           = var.talos_cluster_vip
  cluster_talos_version = "v1.11.5"

  nodes_count       = length(var.talos_node_configs)
  nodes_vm_start_id = 200
  nodes_pve_node    = "gryffindor"
  nodes_extensions = [
    "siderolabs/qemu-guest-agent"
  ]

  network_gateway       = var.gateway
  network_dns_servers   = var.dns_servers
  network_nodes_configs = var.talos_node_configs
}
