# Authentication

# Intersight API endpoint
variable "api_private_key" {}

# Intersight API Key ID
variable "api_key_id" {}

# Absolut path to the location of the API private key file 
variable "api_endpoint" {
  default = "https://intersight.com"
}


# Server and Organization names
variable "profiles2servers" { 
  type = map(string)
}

variable "organization_name" {} 

variable "catalog_name" {}

variable "policy_name_prefix" {
    default = "tf_"
}

# Variables for Lan Connectivity Policy
variable "iqn_allocation_type" {}
variable "placement_mode" {}
variable "target_platform" {}


# Variables for Network Configurations
variable "ethernet_network_policies" {
  type = list(object({
      description = string 
      net_name_suf = string
      default_vlan = number
      allowed_vlans = string
      eth_mode = string
    })  
  )
  default = [
    {
      description = "Management"
      net_name_suf = "mgmt"
      default_vlan = 1
      allowed_vlans = "0-4096"
      eth_mode = "TRUNK"
    }
  ]
}

# Variables for Ethernet Adapter Policies
variable "ethernet_adapter_policies" {
  type = list(object({
    adpt_name_suf = string
    compqueue_nr = number
    compqueue_ringsize = number
    rxqueue_nr = number
    rxqueue_ringsize = number
    txqueue_nr = number
    txqueue_ringsize = number
    })
  )
  default = [ {
    adpt_name_suf = "mgmt"
    compqueue_nr = 3
    compqueue_ringsize = 1
    rxqueue_nr = 4
    rxqueue_ringsize = 512
    txqueue_nr = 4
    txqueue_ringsize = 512
  } ]
}

# Variables for Ethernet QoS Policies
variable "ethernet_qos_policies" {
  type = list(object({
    qos_name_suf    = string
    vnic_qos        = number
    rate_limit      = number 
    cos             = number
    burst           = number
    priority        = string
    trust_host_cos  = bool
    })
  )
  default = [{
    qos_name_suf    = "qos1500"
    vnic_qos        = 1500
    rate_limit      = 0  
    cos             = 0
    burst           = 1024
    priority        = "Best Effort"
    trust_host_cos  = false
  }]
}

# Variables for Network Adapters (VNICS)
variable "network_config" {
  type = list(object({
      description = string 
      net_policy = string
      vnic_order = string
      vic_slot_id = string
      pci_link = number
      phy_port = string
      if_nameprefix = string
      adapter_policy = string
      qos_policy = string
    })
  )
  default = [
    {
      description = "mgmt0"
      net_policy = "mgmt0"
      vnic_order = "0"
      vic_slot_id = "MLOM"
      pci_link = 0
      phy_port = "0"
      if_nameprefix = "eth"
      adapter_policy = "mgmt"
      qos_policy = 1500
    },
    {
      description = "mgmt1"
      net_policy = "mgmt1"
      vnic_order = "1"
      vic_slot_id = "MLOM"
      pci_link = 0
      phy_port = "1"
      if_nameprefix = "eth"
      adapter_policy = "mgmt"
      qos_policy = 1500
    },
  ]
}

#Storage Configuration

variable "storage_dg_name" {}
variable "storage_dg_raid" {}
variable "storage_dg_type" {} # "0" for manual drive selection and "1" for automatic drive selection
variable "storage_dg_drive_slots" {}

variable "storage_vd_name" {}
variable "storage_vd_size" {} #minimum size
variable "storage_vd_expand" {} # true or false
variable "storage_vd_bootable" {} # true or false

variable "storage_pol_name" {}
variable "storage_pol_use_jbod" {} #boolean
variable "storage_pol_unused_state" {}
variable "storage_pol_m2vd" {} #boolean


#OS Boot Configuration
variable "osboot_pol_name" {}
variable "osboot_pol_description" {}
variable "osboot_pol_bootmode" {}
variable "osboot_pol_enforceuefi" {} #boolean
variable "osboot_enable_cimcdvd" {} #boolean
variable "osboot_enable_localhdd" {} #boolean
variable "osboot_localhdd_slot" {}

# NTP Policy Configuration
variable "ntp_name" {}
variable "ntp_description" {}
variable "ntp_enabled" {}
variable "ntp_timezone" {}
variable "ntp_servers" {}

# vKVM Policy Configuration

variable "vkvm_name" {}
variable "vkvm_description" {}
variable "enabled" {}
variable "maximum_sessions" {}
variable "remote_port" {}
variable "enable_video_encryption" {}
variable "enable_local_server_video" {}

# BIOS policy Configuration
variable "bios_name" {}
variable "bios_description" {}

# Server Profile Template Configuration
variable "server_template_name" {}
variable "server_template_description" {}
variable "server_template_platform" {}


# Server Profile  Configuration
# variable "src_template_moid" {}

variable "tags_key1" {}
variable "tags_value1" {}
variable "tags_key2" {}
variable "tags_value2" {}
variable "server_profile_description" {}
variable "server_profile_platform" {}
#variable "server_profile_moid" {}