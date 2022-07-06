

# Intersight Organization name where new resources will be allocated and/or created
organization_name = "Weka"

# Software catalog name 
catalog_name = "user-catalog"

# Prefix to be used when creating new policies
policy_name_prefix = "wekaIO."

#osimagelink_name = "Centos8.2(local)"

#Lan Connectivity Variables
iqn_allocation_type = "None"
placement_mode = "auto"
target_platform = "Standalone"

# Ethernet QoS Policy values. One object per policy.
ethernet_qos_policies = [
    { qos_name_suf = "qos1500", vnic_qos = 1500, rate_limit = 0, cos = 0, burst = 1024, priority = "Best Effort", trust_host_cos = false},
    { qos_name_suf = "qos9000", vnic_qos = 9000, rate_limit = 0, cos = 0, burst = 1024, priority = "Best Effort", trust_host_cos = false }
 ]

# Ethernet Adapter policy values. One object per policy.
# The values defined as example on the "cluster" policy are inline with Weka's fine tuning for the VIC card.
ethernet_adapter_policies = [ 
    {adpt_name_suf = "mgmt",compqueue_nr = 3,compqueue_ringsize = 1,rxqueue_nr = 4,rxqueue_ringsize = 512,txqueue_nr = 4,txqueue_ringsize = 512},
    {adpt_name_suf = "cluster",compqueue_nr = 3,compqueue_ringsize = 1,rxqueue_nr = 8,rxqueue_ringsize = 4096,txqueue_nr = 2,txqueue_ringsize = 512} 
]
    
# Ethernet Network policy values. One object per policy.
# This needs to be adjusted as per environment's network policy
ethernet_network_policies = [
    { description = "Management", net_name_suf = "mgmt81", default_vlan = 81, allowed_vlans = "89,88", eth_mode = "TRUNK"},
    { description = "ClusterA", net_name_suf = "clus53", default_vlan = 53, allowed_vlans = "53", eth_mode = "TRUNK"},
    { description = "ClusterB", net_name_suf = "clus54", default_vlan = 54, allowed_vlans = "54", eth_mode = "TRUNK"}
  ]

# network_config parameters "net_policy", "adapter_policy" and "qos_policy" should have a match with the corresponding policies above, 
# respectively "net_name_suf", "adpt_name_suf" and "qos_name_suf"
network_config = [
    {description = "mgmt0", net_policy = "mgmt81", vnic_order = "0", vic_slot_id = 2, pci_link = 0, phy_port = "0", if_nameprefix = "eth", adapter_policy = "mgmt", qos_policy = "qos1500"},
    {description = "mgmt1", net_policy = "mgmt81", vnic_order = "1", vic_slot_id = 2, pci_link = 0, phy_port = "1", if_nameprefix = "eth", adapter_policy = "mgmt", qos_policy = "qos1500"},
    {description = "faba01", net_policy = "clus53", vnic_order = "2", vic_slot_id = 2, pci_link = 0, phy_port = "0", if_nameprefix = "eth", adapter_policy = "cluster", qos_policy = "qos9000"},
    {description = "fabb01", net_policy = "clus54", vnic_order = "3", vic_slot_id = 2, pci_link = 0, phy_port = "1", if_nameprefix = "eth", adapter_policy = "cluster", qos_policy = "qos9000"}
]

# Storage Inputs
storage_dg_name = "ssd_r1"
storage_dg_raid = "Raid1"
storage_dg_type = 0 # "0" for manual drive selection and "1" for automatic drive selection
storage_dg_drive_slots = "23,24"

storage_vd_name = "boot"
storage_vd_size =  1 #minimum size
storage_vd_expand = true # true or false
storage_vd_bootable = true # true or false

storage_pol_name = "storage"
storage_pol_use_jbod = true #boolean
storage_pol_unused_state = "UnconfiguredGood"
storage_pol_m2vd = false #boolean

# OS Boot Inputs
osboot_pol_name = "bootOS"
osboot_pol_description = "OS Boot Policy for Weka"
osboot_pol_bootmode = "Uefi"
osboot_pol_enforceuefi = false #boolean
osboot_enable_cimcdvd = true #boolean
osboot_enable_localhdd = true #boolean
osboot_localhdd_slot = "MRAID"

# NTP Inputs
ntp_name = "ntp"
ntp_description = "Weka NTP configuration"
ntp_enabled = true
ntp_timezone = "Europe/Lisbon"
ntp_servers = [
    "0.pt.pool.ntp.org",
    "1.pt.pool.ntp.org",
    "2.pt.pool.ntp.org"
  ]

# vKVM Inputs
vkvm_name = "vKVM"
vkvm_description = "Weka vKVM Policy"
enabled                   = true
maximum_sessions          = 3
remote_port               = 2069
enable_video_encryption   = true
enable_local_server_video = true

# BIOS Inputs
bios_name = "bios"
bios_description = "Weka BIOS Policy"

# Server Profile Template Inputs
server_template_name = "servernode"
server_template_description = "Weka Server Profile Template"
server_template_platform = "Standalone" # Standalone or FIAttached

# Server Profile Inputs
server_profile_description = "WekaIO Node "
server_profile_platform = "Standalone"  # Using standalone by default. "FIattached" for UCSM mode.
tags_key1 = "solution"
tags_value1 = "wekaIO SDS"
tags_key2 = "nodeid"
tags_value2 = ""