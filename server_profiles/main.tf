
# Weka.IO cluster management with Cisco Intersight
# ________________________________________________
#   Plan outcomes : Creation of Intersight policies, profiles and server profiles
#   Plan version  : 1.0
#   Author        : Sergio Sousa (https://www.linkedin.com/in/ssousa/)
# 

# Intersight provider Information
terraform {
  cloud {    
    organization = "cisco-lisbon-coe"    
    workspaces {      
      name = "weka"    
    }  
  }
  
  required_providers { 
    intersight  = {
      source    = "CiscoDevNet/intersight"
      version   = "~> 1.0.28" }
  } 
}

provider "intersight" {
  apikey    = var.api_key_id
  secretkey = var.api_private_key
  endpoint  = var.api_endpoint
}

locals {
  new_ethernet_networks   = zipmap(module.ethernet_networks[*].eth_net_name,module.ethernet_networks[*].eth_net_moid) # Map new Eth Network policy names to respective MOIDs
  new_eth_adapter_configs = zipmap(module.ethernet_adapters[*].eth_adapter_name,module.ethernet_adapters[*].eth_adapter_moid) # Map new Eth adapter policy names to respective MOIDs
  new_qos_configs         = zipmap(module.ethernet_qos[*].eth_qos_name,module.ethernet_qos[*].eth_qos_moid) # Map new QoS policy names to respective MOIDs
  server_moids            = zipmap(local.server_names,module.moids.server_moids) # Map physical server names to respective MOIDs
  server_names            = compact(tolist(values(var.profiles2servers))) # Extract list of physical server names
  server_profiles         = compact(tolist(keys(var.profiles2servers))) # Extract list of server profile names
}

# Identify MOIDs of existing resources
module "moids" {
  source = "./obtain_moids"

server_names      = local.server_names # List of the physical server names
organization_name = var.organization_name # Organization name to assign the new resources
catalog_name      = var.catalog_name # Software Catalog name to be used
osimagelink_name  = ""  # Empty as this is only required during OS Install (an a separate workspace)
scuimagelink_name = ""  # Empty as this is only required during OS Install (an a separate workspace)
}

# Create Lan Connectivity policy
module "lan_conn" {
  source = "./create_policy/lan_connectivity"

organization_moid   = module.moids.organization_moid
policy_name_prefix  = var.policy_name_prefix
iqn_allocation_type = var.iqn_allocation_type
placement_mode      = var.placement_mode
target_platform     = var.target_platform
}

# Create Ethernet QoS policies
module "ethernet_qos" {
  source = "./create_policy/eth_qos"
  count  = length(var.ethernet_qos_policies)  # We're likely to have a 1500 MTU for management and 9000 MTU for cluster backbone

organization_moid = module.moids.organization_moid
qos_name          = "${var.policy_name_prefix}${var.ethernet_qos_policies[count.index].qos_name_suf}"
vnic_qos          = var.ethernet_qos_policies[count.index].vnic_qos
rate_limit        = var.ethernet_qos_policies[count.index].rate_limit
cos               = var.ethernet_qos_policies[count.index].cos
burst             = var.ethernet_qos_policies[count.index].burst
priority          = var.ethernet_qos_policies[count.index].priority
trust_host_cos    = var.ethernet_qos_policies[count.index].trust_host_cos
}

# Create Ethernet Network policies
module "ethernet_networks" {
  source = "./create_policy/eth_net"
  count  = length(var.ethernet_network_policies) # We're likely to have at least a management network/VLAN and one or more cluster networks/VLANs

organization_moid = module.moids.organization_moid
net_name          = "${var.policy_name_prefix}${var.ethernet_network_policies[count.index].net_name_suf}"
default_vlan      = var.ethernet_network_policies[count.index].default_vlan
eth_mode          = var.ethernet_network_policies[count.index].eth_mode
allowed_vlans     = var.ethernet_network_policies[count.index].allowed_vlans
}

# Create Ethernet Adapter policies
module "ethernet_adapters" {
  source = "./create_policy/eth_adapter"
  count  = length(var.ethernet_adapter_policies)
  # While management VLANs can take default parameters, Weka.io cluster interfaces should be tunned for the Cisco VIC. Recommended parameters are described on the terraform.auto.tfvars file. 

organization_moid   = module.moids.organization_moid
adapter_name        = "${var.policy_name_prefix}${var.ethernet_adapter_policies[count.index].adpt_name_suf}"
compqueue_nr        = var.ethernet_adapter_policies[count.index].compqueue_nr
compqueue_ringsize  = var.ethernet_adapter_policies[count.index].compqueue_ringsize
rxqueue_nr          = var.ethernet_adapter_policies[count.index].rxqueue_nr
rxqueue_ringsize    = var.ethernet_adapter_policies[count.index].rxqueue_ringsize
txqueue_nr          = var.ethernet_adapter_policies[count.index].txqueue_nr
txqueue_ringsize    = var.ethernet_adapter_policies[count.index].txqueue_ringsize
}

# Create Ethernet Interfaces
# This module references resources: Network Policies; Ethernet Adapter Policies; QoS Policies; Lan Connectivity Policies
module "ethernet_interfaces" {
  source = "./create_policy/eth_ifaces"
  count  = length(var.network_config)

organization_moid       = module.moids.organization_moid
vnic_name               = "${var.network_config[count.index].if_nameprefix}${var.network_config[count.index].vnic_order}"
vnic_order              = var.network_config[count.index].vnic_order
vic_slotid              = var.network_config[count.index].vic_slot_id
vnic_pci_link           = var.network_config[count.index].pci_link
vnic_phy_port           = var.network_config[count.index].phy_port
lan_connectivity_moid   = module.lan_conn.lan_connectivity_moid
eth_net_moid            = lookup(local.new_ethernet_networks, 
                          "${var.policy_name_prefix}${var.network_config[count.index].net_policy}", 
                          "NotFound")  # "NotFound" should indicate incorrect mapping between network_config and network_policies objects.
eth_adapter_moid        = lookup(local.new_eth_adapter_configs, 
                          "${var.policy_name_prefix}${var.network_config[count.index].adapter_policy}", 
                          "NotFound")  # "NotFound" should indicate incorrect mapping between network_config and ethernet_adapter_policies objects.
eth_qos_moid            = lookup(local.new_qos_configs, 
                          "${var.policy_name_prefix}${var.network_config[count.index].qos_policy}", 
                          "NotFound") # "NotFound" should indicate incorrect mapping between network_config and qos_policies objects.
}

# Create storage policy
# This needs to be inline with the physical disk configuration of the server. Adjust as needed
module "storage_policy" {
  source = "./create_policy/storage_policy"

organization_moid         = module.moids.organization_moid
policy_name_prefix        = var.policy_name_prefix
storage_pol_name          = var.storage_pol_name
storage_pol_use_jbod      = var.storage_pol_use_jbod
storage_pol_unused_state  = var.storage_pol_unused_state
storage_pol_m2vd          = var.storage_pol_m2vd

}

# Create disk group policy
# This resource maps the resource created by storage_policy module
# This needs to be inline with the physical disk configuration of the server. Adjust as needed
module "storage_diskgroups" {
  source = "./create_policy/storage_dg"
 
organization_moid       = module.moids.organization_moid
policy_name_prefix      = var.policy_name_prefix
storage_dg_name         = var.storage_dg_name
storage_dg_raid         = var.storage_dg_raid
storage_dg_type         = var.storage_dg_type # "0" for manual drive selection and "1" for automatic drive selection
storage_dg_drive_slots  = var.storage_dg_drive_slots
storage_vd_name         = var.storage_vd_name
storage_vd_size         =  var.storage_vd_size #minimum size
storage_vd_expand       = var.storage_vd_expand # true or false
storage_vd_bootable     = var.storage_vd_bootable # true or false
storage_policy_moid     = module.storage_policy.storage_policy_moid  # Associate with Storage Policy defined above
}

# Create OS Boot policy
module "osboot_policy" {
  source = "./create_policy/os_boot"

organization_moid       = module.moids.organization_moid
policy_name_prefix      = var.policy_name_prefix
osboot_pol_name         = var.osboot_pol_name
osboot_pol_description  = var.osboot_pol_description
osboot_pol_bootmode     = var.osboot_pol_bootmode
osboot_pol_enforceuefi  = var.osboot_pol_enforceuefi
osboot_enable_cimcdvd   = var.osboot_enable_cimcdvd
osboot_enable_localhdd  = var.osboot_enable_cimcdvd
osboot_localhdd_slot    = var.osboot_localhdd_slot 
}

# Create NTP policy
module "ntp_policy" {
  source = "./create_policy/ntp"

organization_moid   = module.moids.organization_moid
policy_name_prefix  = var.policy_name_prefix
ntp_name            = var.ntp_name
ntp_description     = var.ntp_description
ntp_enabled         = var.ntp_enabled
ntp_timezone        = var.ntp_timezone
ntp_servers         = var.ntp_servers
}


# Create vKVM policy
module "vkvm_policy" {
  source = "./create_policy/vkvm"

organization_moid         = module.moids.organization_moid
policy_name_prefix        = var.policy_name_prefix
vkvm_name                 = var.vkvm_name
vkvm_description          = var.vkvm_description
enabled                   = var.enabled
maximum_sessions          = var.maximum_sessions
remote_port               = var.remote_port
enable_video_encryption   = var.enable_video_encryption
enable_local_server_video = var.enable_local_server_video
}

# Create BIOS policy
module "bios_policy" {
  source = "./create_policy/bios"

organization_moid   = module.moids.organization_moid
policy_name_prefix  = var.policy_name_prefix
bios_name           = var.bios_name
bios_description    = var.bios_description
}

# Create a server profile template for the server nodes
# NOTE: While this resource can be created here, its value when using IaC is quite limited and may cause more confusion than helping
#       By using Terraform's IaC we are already defining our own stateless profiles (as per the module below)
#       That said, leaving the code here for reference but commented
/*
module "server_template" {
  source = "./create_profile/template"

organization_moid             = module.moids.organization_moid
policy_name_prefix            = var.policy_name_prefix
server_template_name          = var.server_template_name
server_template_description   = var.server_template_description 
server_template_platform      = var.server_template_platform
boot_policy_moid              = module.osboot_policy.os_boot_policy_moid # Associate OS Boot Policy
lanconn_policy_moid           = module.lan_conn.lan_connectivity_moid # Associate LAN Connectivity Policy
ntp_policy_moid               = module.ntp_policy.ntp_policy_moid # Associate NTP Policy
vkvm_policy_moid              = module.vkvm_policy.vkvm_policy_moid # Associate vKVM Policy
storage_policy_moid           = module.storage_policy.storage_policy_moid  # Associate Storage Policy
bios_policy_moid              = module.bios_policy.bios_policy_moid # Associate BIOS Policy

# Terraform destroy fails randomly when destroying eth_interfaces and storage_policies
# Setting explicit dependencies to overcome the situation
depends_on = [module.lan_conn,
              module.ethernet_qos,
              module.ethernet_networks,
              module.ethernet_adapters,
              module.ethernet_interfaces,
              module.storage_policy,
              module.storage_diskgroups]
}
*/

# Create the server profiles 
# All server profiles definied on server.auto.tfvars will be created, even if no physical server is assigned to it
# This helps build naming and IP consistency in the cluster
module "server_profile" {
  source = "./create_profile/server"
  count = length(local.server_profiles)

organization_moid           = module.moids.organization_moid
policy_name_prefix          = var.policy_name_prefix
server_profile_name         = local.server_profiles[count.index]
server_profile_description  = "${var.server_profile_description}${count.index}" 
server_profile_platform     = var.server_profile_platform
# src_template_moid         = module.server_template.server_template_moid # As per the note on the module above, not spawning server template profiles
boot_policy_moid            = module.osboot_policy.os_boot_policy_moid
lanconn_policy_moid         = module.lan_conn.lan_connectivity_moid
ntp_policy_moid             = module.ntp_policy.ntp_policy_moid
vkvm_policy_moid            = module.vkvm_policy.vkvm_policy_moid
storage_policy_moid         = module.storage_policy.storage_policy_moid
bios_policy_moid            = module.bios_policy.bios_policy_moid
# Return the MOID of the physical server or "0" if there isn't one assigned to profile
physical_server             = lookup(local.server_moids,lookup(var.profiles2servers,local.server_profiles[count.index],"noserver"),0)
# Not applicable to standalone servers
#uuidpool_moid              = module.uuidpool.uuid_pool_moid   

tags_key1           = var.tags_key1
tags_value1         = var.tags_value1
tags_key2           = var.tags_key2
tags_value2         = "${count.index}"
}

# Several outputs for visibility on which resources were created and/or will be used
# Comment the blocks if you prefer to reduce console output
# ----------------------------------------------------------------------------------
output "theservers" {
  value = module.moids.server_moids
}

output "new_networks" {
  value = local.new_ethernet_networks
}

output "new_adapter_configs" {
  value = local.new_eth_adapter_configs
}

output "new_qos_configs" {
  value = local.new_qos_configs
}

output "current_servers" {
  value = local.server_moids
}

output "new_ifaces" {
  value = module.ethernet_interfaces[*].new_ifaces
}

output "new_lanconnectivity" {
  value = "${module.lan_conn.lan_connectivity_name}:${module.lan_conn.lan_connectivity_moid}"
}

output "new_storage_dg_policy" {
  value = "${module.storage_diskgroups.storage_dg_policy_name}:${module.storage_diskgroups.storage_dg_policy_moid}"
}

output "new_storage_policy" {
  value = "${module.storage_policy.storage_policy_name}:${module.storage_policy.storage_policy_moid}"
}

output "new_osboot_policy" {
  value = "${module.osboot_policy.os_boot_policy_name}:${module.osboot_policy.os_boot_policy_moid}"
}

output "new_ntp_policy" {
  value = "${module.ntp_policy.ntp_policy_name}:${module.ntp_policy.ntp_policy_moid}"
}

output "new_vkvm_policy" {
  value = "${module.vkvm_policy.vkvm_policy_name}:${module.vkvm_policy.vkvm_policy_moid}"
}

output "new_bios_policy" {
  value = "${module.bios_policy.bios_policy_name}:${module.bios_policy.bios_policy_moid}"
}

output "new_server_profiles" {
  value = zipmap(module.server_profile[*].name,module.server_profile[*].moid)
}
