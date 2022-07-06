
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

resource "intersight_storage_storage_policy" "storage_policy" {
  name               = "${var.policy_name_prefix}${var.storage_pol_name}"
  use_jbod_for_vd_creation = var.storage_pol_use_jbod
  description        = "Storage policy"
  unused_disks_state = var.storage_pol_unused_state
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
  
  # Enable M2 virtual drive if available
  m2_virtual_drive {
    enable      = var.storage_pol_m2vd
    object_type = "storage.M2VirtualDriveConfig"
  }
}

output "storage_policy_moid" {
  value = intersight_storage_storage_policy.storage_policy.id
}

output "storage_policy_name" {
  value = intersight_storage_storage_policy.storage_policy.name
}