resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = var.target_path
}

resource "kubernetes_secret" "sops_age" {
  metadata {
    name      = "sops-age"
    namespace = "flux-system"
  }

  data = {
    "age.agekey" = var.age_key_content
  }

  depends_on = [flux_bootstrap_git.this]
}
