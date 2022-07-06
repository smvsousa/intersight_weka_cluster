
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

resource "intersight_boot_precision_policy" "boot_precision1" {
  name                     = "${var.policy_name_prefix}${var.osboot_pol_name}"
  description              = var.osboot_pol_description
  configured_boot_mode     = var.osboot_pol_bootmode
  enforce_uefi_secure_boot = var.osboot_pol_enforceuefi
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
  # Define a local HDD boot device
  #
  boot_devices {
    enabled     = var.osboot_enable_localhdd
    name        = "localHDD"
    object_type = "boot.LocalDisk"
    additional_properties = jsonencode({
      Slot = var.osboot_localhdd_slot
      Bootloader = {
        Description = ""
        Name        = ""
        ObjectType  = "boot.Bootloader"
        Path        = ""
      }
    })
  }
# Define a virtual KVM DVD boot device
#
  boot_devices {
    enabled     = var.osboot_enable_cimcdvd
    name        = "cimcDVD"
    object_type = "boot.VirtualMedia"
    additional_properties = jsonencode({
      Subtype = "cimc-mapped-dvd"
    })
  }

# Add other boot devices as required per the storage configuration
# 
}

output "os_boot_policy_moid" {
  value = intersight_boot_precision_policy.boot_precision1.id
}

output "os_boot_policy_name" {
  value = intersight_boot_precision_policy.boot_precision1.name
}