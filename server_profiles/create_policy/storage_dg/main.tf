
# Intersight provider Information
terraform {
  cloud {    
    organization = "cisco-lisbon-coe"    
    workspaces {      
      name = "weka"    
    }  
  }  
  
  required_providers { 
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "~> 1.0.28" }
  } 
}

resource "intersight_storage_drive_group" "drive_group" {
  type = var.storage_dg_type
  name = "${var.policy_name_prefix}${var.storage_dg_name}"
  raid_level = var.storage_dg_raid
  manual_drive_group {
    span_groups {
      slots = var.storage_dg_drive_slots
    }
  }
  virtual_drives {
    name = "${var.policy_name_prefix}${var.storage_vd_name}"
    size = var.storage_vd_size
    expand_to_available = var.storage_vd_expand
    boot_drive = var.storage_vd_bootable
    # Keeping some defaults hardcoded
    virtual_drive_policy {
      strip_size = 64
      write_policy = "Default"
      read_policy = "Default"
      access_policy = "Default"
      drive_cache = "Default"
    }
  }
  # Associate storage policy
  #
  storage_policy {
    moid = var.storage_policy_moid
  }
}

output "storage_dg_policy_moid" {
  value = intersight_storage_drive_group.drive_group.id
}

output "storage_dg_policy_name" {
  value = intersight_storage_drive_group.drive_group.name
}