resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "gitops/flux/clusters/${var.env}"
}

resource "kubernetes_secret_v1" "sops_age" {
  # checkov:skip=CKV_K8S_21:The SOPS decryption key must reside in the flux-system namespace for Flux to operate
  metadata {
    name      = "sops-age"
    namespace = "flux-system"
  }

  data = {
    "age.agekey" = var.age_key_content
  }

  depends_on = [flux_bootstrap_git.this]
}

resource "kubernetes_secret_v1" "truenas_apikey" {
  # checkov:skip=CKV_K8S_21:Democratic-CSI driver requires installation in kube-system or privileged namespace
  metadata {
    name      = "truenas-apikey"
    namespace = "kube-system"
  }

  data = {
    key = var.truenas_api_key
  }

  depends_on = [flux_bootstrap_git.this]
}

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret_v1" "cloudflare_token" {
  # checkov:skip=CKV_K8S_21:Namespace is defined via dynamic reference which static analysis misses
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
  }

  data = {
    api-token = var.cloudflare_token
  }

  depends_on = [kubernetes_namespace_v1.cert_manager]
}

resource "kubernetes_secret_v1" "cloudflare_token_gitlab" {
  # checkov:skip=CKV_K8S_21:Namespace is defined via dynamic reference which static analysis misses
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "gitlab"
  }

  data = {
    api-token = var.cloudflare_token
  }

  # Se till att namespacen finns först
  depends_on = [kubernetes_namespace_v1.gitlab]
}

resource "kubernetes_namespace_v1" "gitlab" {
  metadata {
    name = "gitlab"
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
