variable "node" {
  type        = string
  description = "The PVE node to download the ISO to."
}

variable "url" {
  type        = string
  description = "The URL of the ISO file to download."
}

variable "filename" {
  type        = string
  description = "The filename of the downloaded ISO file."
}
