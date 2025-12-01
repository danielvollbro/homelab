variable "talos_version" {
  type        = string
  description = "The version of Talos to use for the image."
}

variable "official_extensions" {
  type        = list(string)
  description = "List of official Talos system extensions to include in the image."
}
