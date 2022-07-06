
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

resource "intersight_vnic_eth_if" "eth_if" {
  name  = var.vnic_name
  order = var.vnic_order
  placement {
    id       = var.vic_slotid # Slot ID - By default MLOM
    pci_link = var.vnic_pci_link # This should be 0
    uplink   = (var.vnic_phy_port != "" ? var.vnic_phy_port : var.vnic_order % 2) # Fabric A (0) or Fabric B (1). If not manually defined then split evenly
  }

# For future use
  usnic_settings {
    cos      = 5
    nr_count = 0
  }

# Associate ethernet, lan and QoS policies
# 
  lan_connectivity_policy {
    moid        = var.lan_connectivity_moid
    object_type = "vnic.LanConnectivityPolicy"
  }
  eth_network_policy {
    moid        = var.eth_net_moid
  }
  eth_adapter_policy {
    moid        = var.eth_adapter_moid
  }
  eth_qos_policy {
    moid        = var.eth_qos_moid
  }
}

output "new_ifaces" {
  value = "${intersight_vnic_eth_if.eth_if.name},${intersight_vnic_eth_if.eth_if.id}"
}

