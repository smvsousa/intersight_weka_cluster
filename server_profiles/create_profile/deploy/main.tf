
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


resource "intersight_server_profile" "server2" {
  count = var.physical_server != 0 ? 1 : 0

  moid                    = var.server_profile_moid
  server_assignment_mode  = "Static"

  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }

  assigned_server {
      moid = var.physical_server 
      object_type = "compute.RackUnit"
  }
  action = "Deploy"
}

/*
output "server_profile_moid" {
  value = intersight_server_profile.server2.id
}

output "server_profile_name" {
  value = intersight_server_profile.server2.name
}
*/