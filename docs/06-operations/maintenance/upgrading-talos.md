# Upgrading Talos Linux

## Description
Since Talos Linux is immutable, upgrades are performed by swapping the OS image
via the API. This process is orchestrated by Terraform.

## Procedure

### 1. Identify New Version
Check the [Talos Releases](https://github.com/siderolabs/talos/releases) page.
* Example Target: `v1.9.0`

### 2. Update Terraform
Edit `infrastructure/environments/prod/variables_talos.tf`.

```hcl
variable "talos_version" {
  default = "v1.9.0"
}
```

### 3\. Apply Upgrade

Run Terraform to push the new configuration.

```bash
terraform apply
```

* Terraform will detect the version change in
  `talos_machine_configuration_apply`.
* **Note:** This does *not* immediately reboot the nodes if `apply_mode` is set
  to `stage`.

### 4\. Trigger Upgrade (Rolling)

Use `talosctl` to perform the actual upgrade safely.

```bash
# Upgrade Node 1
talosctl upgrade --nodes 10.0.50.51 --image ghcr.io/siderolabs/installer:v1.9.0 --preserve=true

# Wait for healthy node
talosctl health --nodes 10.0.50.51

# Repeat for other nodes
```

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
