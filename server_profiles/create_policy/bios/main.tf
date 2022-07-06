
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


# Setting up for future use
# Using minimal set of variables for BIOS and taking the defaults for everything else 
# It will need more variable definition for granular configuration. 
resource "intersight_bios_policy" "bios" {
  name                      = "${var.policy_name_prefix}${var.bios_name}"
  description               = var.bios_description
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
}

output "bios_policy_moid" {
  value = intersight_bios_policy.bios.id
}

output "bios_policy_name" {
  value = intersight_bios_policy.bios.name
}

