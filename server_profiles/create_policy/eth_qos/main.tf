
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


resource "intersight_vnic_eth_qos_policy" "v_eth_qos" {
  name           = var.qos_name
  description    = "Vnic eth QoS policy"
  mtu            = var.vnic_qos
  rate_limit     = var.rate_limit
  cos            = var.cos
  burst          = var.burst
  priority       = var.priority
  trust_host_cos = var.trust_host_cos
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
}

output "eth_qos_name" {
  value = intersight_vnic_eth_qos_policy.v_eth_qos.name
}

output "eth_qos_moid" {
  value = intersight_vnic_eth_qos_policy.v_eth_qos.id
}
