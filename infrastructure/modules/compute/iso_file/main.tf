resource "proxmox_virtual_environment_download_file" "this" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node
  url          = var.url
  file_name    = var.filename
}
