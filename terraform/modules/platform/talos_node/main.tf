module "node_vm" {
  source = "../../compute/proxmox_vm"

  vm_id                = var.vm_id
  vm_name              = var.node_hostname
  vm_node              = var.vm_node
  vm_onboot            = var.vm_onboot
  vm_iso_file          = var.vm_iso_file
  res_cpu_cores        = var.res_cpu_cores
  res_dedicated_memory = var.res_dedicated_memory
  res_disc_size        = var.res_disc_size

  network_ipaddress   = var.network_ipaddress
  network_gateway     = var.network_gateway
  network_dns_servers = var.network_dns_servers
  network_mac         = var.network_mac
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${var.cluster_vip}:6443"
  machine_secrets  = var.node_machine_secrets.machine_secrets
  talos_version    = "v1.11.5"
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = var.node_machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration

  node = var.network_ipaddress

  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda"
          wipe  = true
          image = var.node_machine_installer
        }
        systemDiskEncryption = {
          ephemeral = {
            provider = "luks2"
            keys = [
              {
                slot = 0
                tpm  = {}
              }
            ]
          }
          state = {
            provider = "luks2"
            keys = [
              {
                slot = 0
                tpm  = {}
              }
            ]
          }
        }
        network = {
          hostname = var.node_hostname
          interfaces = [
            {
              interface = "eth0"
              dhcp      = false
              addresses = ["${var.network_ipaddress}/24"]

              vip = {
                ip = var.cluster_vip
              }

              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = var.network_gateway
                }
              ]
            }
          ]
          nameservers = var.network_dns_servers
        }
      }
      cluster = {
        allowSchedulingOnControlPlanes = true
      }
    })
  ]

  depends_on = [module.node_vm]
}
