module "talos-vms" {
  source = "../../modules/platform/talos_cluster"

  cluster_name = "prod-cluster"
  cluster_vip  = var.talos_cluster_vip

  nodes_count             = length(var.talos_node_configs)
  nodes_vm_start_id       = 200
  nodes_pve_node          = "gryffindor"
  nodes_iso_file          = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.11.5/nocloud-amd64-secureboot.iso"
  nodes_machine_installer = "factory.talos.dev/nocloud-installer-secureboot/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.11.5"

  network_gateway       = var.gateway
  network_dns_servers   = var.dns_servers
  network_nodes_configs = var.talos_node_configs
}
