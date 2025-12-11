variable "cf_account_id" {
  description = "Cloudflare account id, used when communicating with Cloudflare"
  type        = string
}

variable "cf_token" {
  description = "Cloudflare API Token, used to communicate with Cloudflare"
  type        = string
  sensitive   = true
}
