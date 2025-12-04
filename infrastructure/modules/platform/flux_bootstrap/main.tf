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

resource "kubernetes_secret" "truenas_apikey" {
  metadata {
    name      = "truenas-apikey"
    namespace = "kube-system"
  }

  data = {
    key = var.truenas_api_key
  }

  depends_on = [flux_bootstrap_git.this]
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret" "cloudflare_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = kubernetes_namespace.gitlab.metadata[0].name
  }

  data = {
    api-token = var.cloudflare_token
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = "gitlab"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
