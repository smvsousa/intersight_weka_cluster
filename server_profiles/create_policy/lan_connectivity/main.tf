
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

resource "intersight_vnic_lan_connectivity_policy" "vnic_lan" {
  name                = "${var.policy_name_prefix}lan_con"
  description         = "Vnic lan connectivity policy"
  iqn_allocation_type = var.iqn_allocation_type
  placement_mode      = var.placement_mode
  target_platform     = var.target_platform
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
}

output "lan_connectivity_moid" {
    value = intersight_vnic_lan_connectivity_policy.vnic_lan.id
}

output "lan_connectivity_name" {
    value = intersight_vnic_lan_connectivity_policy.vnic_lan.name
}
 