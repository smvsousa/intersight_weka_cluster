
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

resource "intersight_vnic_eth_network_policy" "v_eth_network" {

    name = var.net_name 
    organization {
      object_type = "organization.Organization"
      moid        = var.organization_moid
    }
    vlan_settings {
      object_type  = "vnic.VlanSettings"
      default_vlan = var.default_vlan
      mode         = var.eth_mode
    }
}

output "eth_net_name" {
  value = intersight_vnic_eth_network_policy.v_eth_network.name  
}

output "eth_net_moid" {
  value = intersight_vnic_eth_network_policy.v_eth_network.id 
}

