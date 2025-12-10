# Upgrading Talos Linux

## Description
Since Talos Linux is immutable, upgrades are performed by swapping the OS image
via the API. This process is orchestrated by Terraform to ensure the
configuration state (Machine Config) matches the running cluster version.

## Procedure

### 1. Identify New Version
Check the [Talos Releases](https://github.com/siderolabs/talos/releases) page.
* Example Target: `v1.9.0`

### 2. Update Terraform

Navigate to the platform definition for the specific cluster you wish to
upgrade (e.g., Production).

File: `infrastructure/02-platforms/k8s-prod/variables_talos.tf`

Update the version variable:

```hcl
variable "talos_version" {
  description = "Talos OS version"
  default = "v1.9.0"
}
```

### 3\. Apply Upgrade Config

Run Terraform to push the new machine configuration to the cluster API.

```bash
# Navigate to the correct layer
cd infrastructure/02-platforms/k8s-prod

# Apply changes
terraform apply
```

* Terraform will detect the version change in
  `talos_machine_configuration_apply`.
* **Note:** This only updates the *configuration* at the endpoint. It does
    *not* immediately reboot the nodes if `apply_mode` is set to `stage`
    (recommended for production).

### 4\. Trigger Upgrade (Rolling)

Use `talosctl` to perform the actual upgrade safely, one node at a time. This
ensures workloads are drained properly before the node reboots into the new OS.

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
