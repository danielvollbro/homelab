resource "proxmox_virtual_environment_user" "terraform_user" {
  user_id = "terraform@pve"

  lifecycle {
    ignore_changes = [acl]
  }
}

resource "proxmox_virtual_environment_role" "terraform_role" {
  role_id = "terraform"

  privileges = [
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.AllocateTemplate",
    "Datastore.Audit",
    "Mapping.Modify",
    "Pool.Allocate",
    "SDN.Use",
    "Sys.Audit",
    "Sys.Console",
    "Sys.Modify",
    "User.Modify",
    "VM.Allocate",
    "VM.Audit",
    "VM.Clone",
    "VM.Config.CDROM",
    "VM.Config.Cloudinit",
    "VM.Config.CPU",
    "VM.Config.Disk",
    "VM.Config.HWType",
    "VM.Config.Memory",
    "VM.Config.Network",
    "VM.Config.Options",
    "VM.GuestAgent.Audit",
    "VM.Migrate",
    "VM.PowerMgmt",
  ]
}

resource "proxmox_virtual_environment_user_token" "terraform_api_token" {
  token_name            = "provider"
  user_id               = proxmox_virtual_environment_user.terraform_user.user_id
  privileges_separation = false
}

resource "proxmox_virtual_environment_acl" "terraform_acl" {
  role_id = proxmox_virtual_environment_role.terraform_role.role_id
  user_id = proxmox_virtual_environment_user.terraform_user.id

  path      = "/"
  propagate = true
}
