# ADR-002: Cilium CNI and L2 Announcements

- Status: accepted
- Date: 2025-11-22
- Decision owner: Daniel Vollbro

## Context

A Kubernetes cluster requires a Container Network Interface (CNI) to manage pod
communication. Additionally, on bare-metal infrastructure (unlike AWS/GCP),
there is no built-in "LoadBalancer" implementation. We need a high-performance
network stack that can also assign IP addresses to services accessible from the
home LAN.

## Decision

We will use **Cilium** as the CNI in `kube-proxy` replacement mode, utilizing
its native **L2 Announcement** feature for Load Balancing.

## Alternatives considered

- **Flannel:** Simple, but lacks network policies, observability, and advanced
routing.
- **Calico:** Strong contender, but Cilium's eBPF approach offers better
future-proofing for observability (Hubble).
- **MetalLB:** The traditional choice for bare-metal LoadBalancing. Rejected
because Cilium now includes this functionality natively, reducing the need for
an extra software component.

## Rationale

1.  **Performance:** Cilium uses eBPF to route packets in the kernel, bypassing
slow IPtables chains.
2.  **Consolidation:** By using Cilium's L2 Announcements, we avoid installing
MetalLB, reducing complexity and resource usage.
3.  **Security:** Cilium provides advanced Network Policies (L3/L4/L7) out of
the box.

## Consequences

### Positive

- High-performance data plane.
- Unified stack for Networking, Security, and Load Balancing.
- Removes dependency on `kube-proxy` and MetalLB.

### Negative

- eBPF can be complex to debug if issues arise.
- Requires specific Kernel versions (handled by Talos Linux).

## Follow-up

- Configure IP Pools (`CiliumLoadBalancerIPPool`) matching the VLAN 50 network
design.
- Verify ARP resolution works correctly on the physical switch/router.

## Transparency Note

The architecture and implementation detailed in this repository are 100% manual
and self-hosted. However, AI tools have been leveraged to refine the
documentation's structure and language to ensure readability.
