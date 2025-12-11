resource "proxmox_virtual_environment_acme_account" "acme_account" {
  name      = "cloudflare"
  contact   = "wollbro90@gmail.com"
  directory = "https://acme-v02.api.letsencrypt.org/directory"
  tos       = "https://letsencrypt.org/documents/LE-SA-v1.5-February-24-2025.pdf"
}

resource "proxmox_virtual_environment_acme_dns_plugin" "acme_plugin" {
  plugin = "cloudflare"
  api    = "cf"
  data = {
    CF_Account_ID = var.cf_account_id
    CF_Token      = var.cf_token
  }
  validation_delay = 0
}
