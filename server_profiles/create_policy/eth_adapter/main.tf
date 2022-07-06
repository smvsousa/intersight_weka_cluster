
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

resource "intersight_vnic_eth_adapter_policy" "vnic_eth_adapter" {
  name                    = var.adapter_name
  rss_settings            = true
  uplink_failback_timeout = 5
  organization {
    object_type = "organization.Organization"
    moid        = var.organization_moid
  }
  vxlan_settings {
    enabled = false
  }

  nvgre_settings {
    enabled = true
  }

  arfs_settings {
    enabled = false
  }

  interrupt_settings {
    coalescing_time = 125
    coalescing_type = "MIN"
    nr_count        = 8
    mode            = "MSI"
  }

# Weka.IO requires specific tunning of these paramenter for the VIC card
  completion_queue_settings {
    nr_count  = var.compqueue_nr
    ring_size = var.compqueue_ringsize
  }

# Weka.IO requires specific tunning of these paramenter for the VIC card
  rx_queue_settings {
    nr_count  = var.rxqueue_nr
    ring_size = var.rxqueue_ringsize
  }

# Weka.IO requires specific tunning of these paramenter for the VIC card
  tx_queue_settings {
    nr_count  = var.txqueue_nr
    ring_size = var.txqueue_ringsize
  }
  
# Note: Hardcoded for now - To declare variables if values need tunning
  tcp_offload_settings {
    large_receive = true
    large_send    = true
    rx_checksum   = true
    tx_checksum   = true
  }
}

output "eth_adapter_name" {
  value = intersight_vnic_eth_adapter_policy.vnic_eth_adapter.name
}

output "eth_adapter_moid" {
    value = intersight_vnic_eth_adapter_policy.vnic_eth_adapter.id
  }
 