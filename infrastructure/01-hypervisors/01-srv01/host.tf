resource "proxmox_virtual_environment_hosts" "hosts" {
  node_name = local.node

  entry {
    address = "127.0.0.1"

    hostnames = [
      "localhost.localdomain",
      "localhost",
    ]
  }

  entry {
    address = local.ip

    hostnames = [
      "${local.node}.${local.domain}",
      local.node,
    ]
  }

  # IPv6 - Currently not in use

  entry {
    address = "::1"
    hostnames = [
      "ip6-localhost",
      "ip6-loopback",
    ]
  }

  entry {
    address = "fe00::0"
    hostnames = [
      "ip6-localnet",
    ]
  }

  entry {
    address = "ff00::0"
    hostnames = [
      "ip6-mcastprefix",
    ]
  }

  entry {
    address = "ff02::1"
    hostnames = [
      "ip6-allnodes",
    ]
  }

  entry {
    address = "ff02::2"
    hostnames = [
      "ip6-allrouters",
    ]
  }

  entry {
    address = "ff02::3"
    hostnames = [
      "ip6-allhosts",
    ]
  }
}
