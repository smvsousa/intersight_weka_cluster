
# Intersight provider Information
terraform {
  cloud {    
    organization = "cisco-lisbon-coe"    
    workspaces {      
      name = "weka_install_os"    
    }  
  }  
  
  required_providers { 
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "~> 1.0.28" }
  } 
}

data "intersight_adapter_host_eth_interface" "mgmtif_eth0" {
  count = length(var.device_moids)

  # Filter devices that belong to the instance of physical server
  device_mo_id = var.device_moids[count.index]

  # Filter by mgmt interface on specified ethernet adapter slot
  # This should map back to the configuration defined on the server_profiles plan
  dn = "sys/rack-unit-1/adaptor-${var.mgmt_if_slot}/host-eth-${var.mgmt_if}"  

}

