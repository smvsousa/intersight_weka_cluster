
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


resource "intersight_server_profile" "server_profile" {

  lifecycle {
    ignore_changes = [
      # Ignore changes to "action" state
      # After profile deployment "action" is automaticaly updated which would imply a change.
      action,
    ]
  }

  name            = var.server_profile_name
  description     = var.server_profile_description
  target_platform = var.server_profile_platform
  
  # If physical server is assigned to server profile (servers.auto.tfvars) then set assignment mode to "Static", otherwise to "None"
  server_assignment_mode  = (var.physical_server != 0 ? "Static" : "None")

  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }

  # Associate to a server profile template
  # NOTE: Currently commented as per the notes on the root main.tf code
  /*
  src_template {
    moid = var.src_template_moid
    object_type = "server.ProfileTemplate"
  }
  */

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
  tags {
    key = var.tags_key1
    value = var.tags_value1
  }
  tags {
    key = var.tags_key2
    value = var.tags_value2
  }

# Only assign server if one is mapped to a server profile on "servers.auto.tfvars"
# var.physical_server = "0" => no server assigned
dynamic "assigned_server" {
    for_each = var.physical_server != 0 ? [1] : []
    content {
      moid = var.physical_server
      object_type = "compute.RackUnit"
    }
  }

# If a server is assigned to a profile then set Action to "deploy", otherwise to "No-op"
action  = (var.physical_server != 0 ? "Deploy" : "No-op")
}


output "moid" {
  value = intersight_server_profile.server_profile.id
}

output "name" {
  value = intersight_server_profile.server_profile.name
}
