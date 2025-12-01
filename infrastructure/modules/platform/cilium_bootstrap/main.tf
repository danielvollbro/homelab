resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = var.cilium_version
  namespace  = "kube-system"

  # This is required to prevent Helm from waiting for CRDs to be established,
  # Cilium is the one responsible for setting up CRD, so we cant wait for it.
  wait = false

  set = [
    # Run as privileged, needed for Talos due to it being an immutable OS.
    {
      name  = "securityContext.privileged"
      value = "true"
    },
    # Replace KubeProxy
    {
      name  = "kubeProxyReplacement"
      value = "true"
    },
    {
      name  = "k8sServiceHost"
      value = var.cluster_vip
    },
    {
      name  = "k8sServicePort"
      value = "6443"
    },
    # IPAM (IP Address Management)
    {
      name  = "ipam.mode"
      value = "kubernetes"
    },
    # Security and monitoring using Hubble
    {
      name  = "cgroup.autoMount.enabled"
      value = "false"
    },
    {
      name  = "cgroup.hostRoot"
      value = "/sys/fs/cgroup"
    },
    {
      name  = "hubble.relay.enabled"
      value = "true"
    },
    {
      name  = "hubble.ui.enabled"
      value = "true"
    },
    # L2 Announcements (Replaces MetalLB)
    {
      name  = "l2announcements.enabled"
      value = "true"
    },
    {
      name  = "externalIPs.enabled"
      value = "true"
    }
  ]
}
