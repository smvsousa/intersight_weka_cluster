
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

# Physical server data
data "intersight_compute_physical_summary" "server_moid" { 
  count = length(var.server_names)
  name = var.server_names[count.index]
}

# Organization data
data "intersight_organization_organization" "organization_moid" {
  name = var.organization_name
}

# Software repository data
data "intersight_softwarerepository_catalog" "catalog_moid" {
  name = var.catalog_name
}

# OS install image link
data "intersight_softwarerepository_operating_system_file" "osimagelink_moid" {
  name = var.osimagelink_name
}

# Firmware ISO link 
data "intersight_firmware_server_configuration_utility_distributable" "scuimagelink_moid" {
  name = var.scuimagelink_name
}