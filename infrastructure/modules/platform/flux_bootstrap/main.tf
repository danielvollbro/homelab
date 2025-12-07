resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = var.target_path
}

resource "kubernetes_secret" "sops_age" {
  metadata {
    name      = "sops-age"
    namespace = "flux-system"
    annotations = {
      "checkov.io/skip1" = "CKV_K8S_21=False positive. Namespace is defined but Checkov fails to parse SOPS file."
    }
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
    annotations = {
      "checkov.io/skip1" = "CKV_K8S_21=False positive. Namespace is defined but Checkov fails to parse SOPS file."
    }
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
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
    annotations = {
      "checkov.io/skip1" = "CKV_K8S_21=False positive. Namespace is defined but Checkov fails to parse SOPS file."
    }
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
