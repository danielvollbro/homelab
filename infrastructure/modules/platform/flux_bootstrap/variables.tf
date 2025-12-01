variable "target_path" {
  type        = string
  description = "Path to where Flux stores manifests."
}

variable "github_repo" {
  type        = string
  description = "The name of the GitHub repository to store Flux manifests."
}
