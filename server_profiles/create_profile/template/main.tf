
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


resource "intersight_server_profile_template" "server_template" {
  name            = "${var.policy_name_prefix}${var.server_template_name}"
  description     = var.server_template_description
  target_platform = var.server_template_platform
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
  policy_bucket {
    moid        = var.boot_policy_moid
    object_type = "boot.PrecisionPolicy"
  }
  policy_bucket {
    moid = var.lanconn_policy_moid
    object_type = "vnic.LanConnectivityPolicy"
  }
  policy_bucket {
    moid = var.adapter_policy_moid
    object_type = "adapter.Policy"
  } 
  policy_bucket {
    moid = var.ntp_policy_moid
    object_type = "ntp.Policy"
  }
  policy_bucket {
    moid = var.vkvm_policy_moid
    object_type = "kvm.Policy"
  }
  policy_bucket {
    moid = var.storage_policy_moid
    object_type = "storage.StoragePolicy"
  }
  policy_bucket {
    moid = var.bios_policy_moid
    object_type = "bios.Policy"
  }
  /*  Code to be reviewed - Not applicable to Standalone Servers
  uuid_address_type = "POOL"
  uuid_pool {
    moid = var.uuidpool_moid
    object_type = "uuidpool.Pool"
  }*/
}

output "server_template_moid" {
  value = intersight_server_profile_template.server_template.id
}

output "server_template_name" {
  value = intersight_server_profile_template.server_template.name
}