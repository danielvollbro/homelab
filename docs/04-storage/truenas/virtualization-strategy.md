# TrueNAS Virtualization & Passthrough Strategy

## Overview
TrueNAS Scale runs as a Virtual Machine on the `srv01` host. While
virtualization of storage appliances requires careful planning, this setup
mitigates risks by using direct **PCIe Passthrough** for storage controllers and
network interfaces.

This architecture allows TrueNAS to manage physical ZFS disks directly, unaware
of the hypervisor layer, ensuring data integrity and SMART monitoring
capabilities.

## Architecture

The system is split into two distinct storage domains to avoid circular
dependencies:

1.  **Hypervisor Storage (Local):** The VM boot disk (OS) resides on a local 3TB
disk managed by Proxmox.
2.  **Data Storage (Passthrough):** The massive ZFS pool resides on physical
disks connected to an HBA card passed through to the VM.

```mermaid
graph TD
    subgraph "Physical Host: Srv01"
        PVE[Proxmox VE]
        LocalDisk[(Local 3TB HDD)]
        HBA[LSI SAS HBA Card]
        NIC[1GbE Network Card]
    end

    subgraph "VM: TrueNAS Scale"
        OS[OS Disk (VirtIO)]
        ZFS[ZFS Pool]
    end

    PVE -- Hosting --> OS
    LocalDisk -- Stores --> OS

    HBA -- PCIe Passthrough --> ZFS
    NIC -- PCIe Passthrough --> ZFS

    style HBA stroke:#f00,stroke-width:2px,stroke-dasharray: 5 5
    style NIC stroke:#f00,stroke-width:2px,stroke-dasharray: 5 5
````

## Hardware Passthrough (Terraform Implementation)

The infrastructure code explicitly maps physical PCI devices to the VM via the
`modules/platform/truenas` wrapper.

### 1\. Storage Controller (HBA)

We pass the entire SAS Controller to the VM. This is critical for ZFS stability.

* **Mapping:** `hostpci0` -\> `HBA`
* **Effect:** Proxmox loses access to these disks; TrueNAS gains full native
control (Scrub, SMART, Trim).

### 2\. Network Interfaces (NICs)

To maximize throughput for iSCSI/NFS traffic, we bypass the Proxmox virtual
bridge (`vmbr0`) for storage traffic.

* **Mapping:** `hostpci1` -\> `NIC1` (WAN/LAN Uplink)
* **Mapping:** `hostpci2` -\> `NIC2` (Storage VLAN 50)

## Terraform Module Configuration

The configuration uses the `modules/platform/truenas` wrapper to enforce the
correct hardware resource allocation while keeping specific node placement
flexible.

**File:** `infrastructure/02-platforms/truenas/main.tf`

```hcl
module "truenas_vm" {
  source = "../../modules/platform/truenas"

  # Resource Allocation
  res_dedicated_memory = 32768  # 32GB ECC RAM (Critical for ARC Cache)
  res_cpu_cores        = 6      # Enough for ZFS compression/encryption
  res_cpu_type         = "host" # Expose AES-NI instructions for encryption speed

  # Hardware Mapping
  res_hostpci = [
    {
      mapping = "HBA"
      pcie    = true
      rombar  = false # Disabled for faster boot
    },
    {
      mapping = "NIC1" # Dedicated Uplink
      pcie    = true
    },
    {
      mapping = "NIC2" # Dedicated Storage Network
      pcie    = true
    }
  ]
}
```

## Boot Order & Dependencies

Since other services (Kubernetes PVs) depend on TrueNAS:

* **TrueNAS:** Configured to start automatically on boot.
* **Dependents (Talos):** Kubernetes is resilient by design. Pods requiring
storage will stay in `ContainerCreating` state until iSCSI targets become
available. No artificial delays are enforced in Terraform to keep the
provisioning logic clean.

## Disaster Recovery & Migration

Because the disks are not virtual files (`.qcow2`) but physical disks controlled
by the passed-through HBA, recovery is hardware-independent.

**Scenario: Host Failure**

1.  Remove the HBA card and disks from the broken server.
2.  Insert them into a new server (virtual or bare-metal).
3.  **Import Pool:** TrueNAS will detect the ZFS signature and import the pool
with zero data loss.

## Future Roadmap: Migration to Bare Metal

While the current virtualized setup is performant, the long-term architectural
goal is to decouple Storage from Compute entirely.

* **Goal:** Migrate TrueNAS to a dedicated hardware chassis.
* **Benefit:** Eliminates the dependency on the Proxmox hypervisor. This allows
for maintenance (reboots/upgrades) of the Compute nodes without disrupting
Storage availability for the rest of the network.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
