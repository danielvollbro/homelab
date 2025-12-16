output "kubeconfig" {
  value     = module.talos_cluster.kubeconfig
  sensitive = true
}

output "talosconfig" {
  value     = module.talos_cluster.talosconfig
  sensitive = true
}
