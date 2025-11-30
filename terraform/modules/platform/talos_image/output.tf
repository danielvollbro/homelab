output "download_iso_secureboot" {
  value       = data.talos_image_factory_urls.this.urls.iso_secureboot
  description = "The URL to the iso with secure boot."
}

output "download_installer_secureboot" {
  value       = data.talos_image_factory_urls.this.urls.installer_secureboot
  description = "The URL to the installer with secure boot."
}
