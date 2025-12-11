resource "proxmox_virtual_environment_dns" "dns_configuration" {
  domain    = local.domain
  node_name = local.node

  servers = [
    "10.0.50.10",
  ]
}
