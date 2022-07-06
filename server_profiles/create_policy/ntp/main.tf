
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

resource "intersight_ntp_policy" "ntp" {
  name         = "${var.policy_name_prefix}${var.ntp_name}"
  description  = "${var.ntp_description}"
  enabled      = var.ntp_enabled
  timezone     = var.ntp_timezone
  ntp_servers  = var.ntp_servers
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
}

output "ntp_policy_moid" {
  value = intersight_ntp_policy.ntp.id
}

output "ntp_policy_name" {
  value = intersight_ntp_policy.ntp.name
}