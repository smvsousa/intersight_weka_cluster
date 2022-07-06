
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


resource "intersight_kvm_policy" "kvm" {
  name                      = "${var.policy_name_prefix}${var.vkvm_name}"
  description               = var.vkvm_description
  enabled                   = var.enabled
  maximum_sessions          = var.maximum_sessions
  remote_port               = var.remote_port
  enable_video_encryption   = var.enable_video_encryption
  enable_local_server_video = var.enable_local_server_video
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
}

output "vkvm_policy_moid" {
  value = intersight_kvm_policy.kvm.id
}

output "vkvm_policy_name" {
  value = intersight_kvm_policy.kvm.name
}