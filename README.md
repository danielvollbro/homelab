# 🚀 Enterprise Homelab Platform

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Talos](https://img.shields.io/badge/talos-linux-orange?style=for-the-badge&logo=linux&logoColor=white)
![Flux](https://img.shields.io/badge/flux-gitops-blue?style=for-the-badge&logo=flux&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Cilium](https://img.shields.io/badge/Cilium-eBPF-F8C42D?style=for-the-badge&logo=cilium&logoColor=white)

> **"ClickOps is forbidden."**
> An immutable, declarative, and self-healing platform managing everything from
> **Layer 1 (Cabling)** to **Layer 7 (Applications)** entirely via GitOps.

## 📋 Overview

This repository hosts the Infrastructure as Code (IaC) and documentation for a
full-stack bare-metal environment. The platform is designed to emulate a modern
enterprise architecture, enforcing strict separation of concerns, zero-trust
networking, and automated disaster recovery.

**The Goal:** A robust platform where the entire stack—from Network VLANs and OS
provisioning to Application deployment—can be restored from a single repository
in under 60 minutes.

---

## 🏗 Architecture & Tech Stack

The architecture follows a strict **Layered Approach**, ensuring physical
dependencies are met before logical reconciliation proceeds.

### Core Components

* **Network & Security:** [Ubiquiti UniFi](https://ui.com)
(UDM-Pro, WiFi 7) with **Zone-Based Firewalling**.
* **Compute Layer:** [Proxmox VE](https://www.proxmox.com)
(Hypervisor) & [Talos Linux](https://www.talos.dev) (Immutable OS).
* **Provisioning:** [Terraform](https://www.terraform.io)
(VMs, DNS, Cluster Bootstrap).
* **GitOps:** [Flux v2](https://fluxcd.io) (Automated reconciliation).
* **Networking (CNI):** [Cilium](https://cilium.io)
(eBPF, L2 LoadBalancing, Network Policies).
* **Storage:** [TrueNAS Scale](https://www.truenas.com)
via **Democratic-CSI** (iSCSI Zvols).
* **Secrets:** [Mozilla SOPS](https://github.com/mozilla/sops)
(Encrypted at rest) & [Cert-Manager](https://cert-manager.io) (Automated PKI).

### High-Level Topology

The physical and logical foundation upon which the Kubernetes cluster rests.

```mermaid
graph TD
  ISP((ISP Fiber)) == WAN ==> UDM[UDM-Pro Gateway]

  subgraph Backbone
    UDM == 10GbE DAC ==> CORE[US-48-500W Switch]
  end

  subgraph Segmentation [VLAN Segmentation]
    CORE -.-> VLAN10(Main / Mgmt)
    CORE -.-> VLAN30(IoT - Zero Trust)
    CORE -.-> VLAN50(Servers - K8s Nodes)
    CORE -.-> VLAN100(Work - Isolated)
  end

  subgraph Compute [Kubernetes Cluster]
    VLAN50 --> CP[Control Plane]
    VLAN50 --> WORKER[Worker Nodes]
  end
````

-----

## 📦 Repository Structure
The repository utilizes Kustomize Overlays to manage multiple environments (Prod/Staging) from a single codebase without duplication.
```text
.
├── docs/                   # 📚 Extensive Documentation & ADRs
│   ├── 01-adr/             # Architecture Decision Records
│   ├── 02-networks         # Network Design & Architecture
│   ├── 03-compute          # Compute (Talos, VM, Terraform)
│   ├── 04-storage          # Storage (NAS, iSCSI)
│   ├── 05-platforms/       # Platform Design (Network, GitOps)
│   └── 06-operations/      # Runbooks & Disaster Recovery
├── gitops/
│   └── flux/               # The Cluster State (Flux v2)
│       ├── infrastructure/ # Controllers & Configs (Base/Overlays)
│       ├── apps/           # Workloads (Base/Overlays)
│       └── clusters/       # Entry points per environment
└── infrastructure/         # The Hardware State (Terraform)
    ├── modules/            # Reusable TF modules
    └── environments/       # Environment specific variables
```

-----

## 📚 Documentation & Deep Dives

Extensive documentation is maintained alongside the code. This is not just a
repo; it's a knowledge base.

### 🌐 1. Networking (Layer 1-3)

Detailed breakdown of the physical infrastructure and logical segmentation.

* **[Physical Hardware & Inventory](docs/02-networks/physical/hardware-inventory.md)**
  – *Specs, wiring, and ISP uplink.*
* **[Firewall Policies](docs/02-networks/firewall/firewall-policies.md)**
  – *Zero Trust ruleset and Zone logic.*
* **[VLAN 50 - Server Segment](docs/02-networks/vlans/vlan-50-servers.md)**
  – *IPAM and Segmentation strategy for Compute.*
* **[VLAN 30 - IoT Strategy](docs/02-networks/vlans/vlan-30-iot.md)**
  – *Handling untrusted devices.*

### ☁️ 2. Platform & Kubernetes (Layer 4-7)

Design decisions for the container orchestration layer.

* **[Architecture Decisions (ADR)](docs/01-adr/)**
  – *Why Talos? Why iSCSI? Read the design choices.*
* **[Disaster Recovery Plan](docs/06-operations/disaster-recovery/dr-plan-total-cluster-loss.md)**
  – *The "Total Cluster Loss" recovery playbook.*
* **[Cilium CNI Design](docs/05-platforms/networking/cilium-cni.md)**
  – *Replacing MetalLB with eBPF and L2 Announcements.*

-----

## 🛠 Usage & Bootstrapping

The entire cluster is bootstrapped via Terraform. No SSH access is required
(or even possible on Talos).

**Bootstrap Sequence:**

```bash
# 1. Provision VMs & Bootstrap Talos
cd infrastructure/environments/prod
terraform apply

# 2. Watch Flux reconcile the world
watch flux get kustomizations
```

## 🔮 Roadmap & Improvements

An infrastructure is never "finished". Current identified bottlenecks and
planned upgrades:

* **Power Redundancy:** Implementation of a Line-Interactive UPS
  (Pure Sine Wave) to secure the compute cluster and ZFS storage against power
  anomalies.
* **Switching Upgrade:** Migration from Gen1 Core Switch to
  **USW-Pro-Max-24-PoE** to unlock the full 2.5GbE/6GHz capacity of the WiFi 7
  infrastructure.

## 🔐 Security Posture

* **Read-Only OS:** The root filesystem is immutable (Talos).
* **No SSH:** All node access is via mTLS authenticated APIs.
* **Network Isolation:** Default-Deny firewall policies between VLANs.
* **Secret Management:** No secrets are committed in plain text (SOPS/Age).

-----

<center>
Built with ❤️ and too much coffee by Daniel Vollbro.
</center>
