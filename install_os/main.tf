# Intersight provider Information
terraform {
  cloud {    
    organization = "cisco-lisbon-coe"    # Your Terraform Cloud organization
    workspaces {      
      name = "weka_install_os"    # Your Terraform Cloud workspace.
    }  
  }
  
  required_providers { 
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "~> 1.0.28" }
  } 
}

# Authentication and API
provider "intersight" {
  apikey    = var.api_key_id
  secretkey = var.api_private_key
  endpoint  = var.api_endpoint
}


locals {
  server_names  = compact(tolist(values(var.profiles2servers)))  # List of physical server names
  profiles      = compact(tolist(keys(var.profiles2servers)))  # List of server profile names
  server_moids  = zipmap(local.server_names,module.moids.server_moids) # Map of physical server names to MOIDs
  device_moids  = zipmap(local.server_names,module.moids.device_moids) # Map of physical server names to device_moids (used to find internal ethernet cards)
  server_macs   = zipmap(local.server_names,module.macaddresses.mac_address) # Map of physical server names to mgmt MAC addresses
  
# Operating System install answers    
  settings = flatten([
    for profile,server in var.profiles2servers : {
      server_profile      = profile
      server_name         = server
      server_moid         = lookup(local.server_moids, server, "")
      device_moid         = lookup(local.device_moids, server, "")
      mgmtif_mac          = lookup(local.server_macs,  server, "")
      ipv4addr            = var.os_ipv4_addr[index(local.profiles,profile)] # Select IP on the same index position as the server profile to keep consistency.
      organization_moid   = module.moids.organization_moid
      catalog_moid        = module.moids.catalog_moid
      osimage_moid        = module.moids.osimagelink_moid
      scuimage_moid       = module.moids.scuimagelink_moid
    } if server != ""
    ])
}

# Identify MOIDs of required objects
module "moids" {
  source = "./obtain_moids"

  server_names      = local.server_names 
  organization_name = var.organization_name
  catalog_name      = var.catalog_name
  osimagelink_name  = var.osimagelink_name
  scuimagelink_name = var.scuimagelink_name
}

# Find the MAC Address for the mgmt IP of the server OS
module "macaddresses" {
  source        = "./obtain_ethmac"
  device_moids  = module.moids.device_moids
  mgmt_if_slot  = var.mgmt_if_slot
  mgmt_if       = var.mgmt_if

  depends_on = [
    module.moids
  ]
}


/* For later use if needed: To add a new OS repository
resource "intersight_softwarerepository_operating_system_file" "rhel-custom-iso-with-kickstart-minio" {
  count = length(var.server_names)
  nr_version = "Red Hat Enterprise Linux 8.2"
  description = "RHEL 8.2 installer ISO with embedded kickstart MinIO"
  name = "ISO-${var.server_names[count.index]}"
  nr_source {
    additional_properties = jsonencode({
	  LocationLink = var.remote-os-image-link[count.index]
	  })
	object_type = var.remote-protocol
  }
  vendor = "Red Hat"
  catalog {
	moid = module.intersight-moids.catalog_moid
  }
}
*/


resource "intersight_os_install" "os" {
  count = length(local.settings)
  name = "osinstall-${local.settings[count.index].server_profile}"

  server {
    object_type = "compute.RackUnit"
    moid = local.settings[count.index].server_moid
  }
  image {
    object_type = "softwarerepository.OperatingSystemFile"
    moid = local.settings[count.index].osimage_moid
  }
  osdu_image {
    object_type = "firmware.ServerConfigurationUtilityDistributable"
    moid        = local.settings[count.index].scuimage_moid
   }
  configuration_file {
    object_type = "os.ConfigurationFile"
    selector    = var.os_install_configuration_file_selector
  }
  answers {
    hostname       = local.settings[count.index].server_profile
    ip_config_type = var.os_ip_config_type
    ip_configuration {
      additional_properties = jsonencode({
        IpV4Config = {
          IpAddress = local.settings[count.index].ipv4addr
          Netmask = var.os_ipv4_netmask
          Gateway  = var.os_ipv4_gateway
        }
      })
      object_type = "os.Ipv4Configuration"
    }
    is_root_password_crypted = var.root_pass_crypted
    nameserver               = var.os_ipv4_dns_ip
    root_password            = var.os_root_password
    nr_source                = var.os_answers_nr_source
    network_device           = local.settings[count.index].mgmtif_mac
  }
  description = "OS install"
  install_method = "vMedia" 
  organization {
    object_type = "organization.Organization"
    moid = module.moids.organization_moid
  }
  install_target {
    additional_properties = jsonencode({
      Id = var.storage_target_id
      Name = var.storage_target_name
      StorageControllerSlotId = var.storage_controller_slot
    })
    object_type = "os.VirtualDrive"
  }
}



output "Settings" {
  value = local.settings
}

output "OS_install_tasks" {
  value = zipmap(resource.intersight_os_install.os.*.name,resource.intersight_os_install.os.*.moid)
}


output "server_names" {
  value = local.server_names
}

output "profiles" {
  value = local.profiles
}

output "server_moids" {
  value = local.server_moids
}

output "device_moids" {
  value = local.device_moids
}

output "server_macs" {
  value = local.server_macs
}
/*
output "eth_interface" {
  value = module.macaddresses.eth_interface
}*/
