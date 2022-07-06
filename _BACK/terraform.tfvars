api_key_id = "5a58c3ba3768393836cb0f1b/5a58c41a3768393836cb10bc/61a8b4847564612d33b6c29c"
api_endpoint = "https://intersight.com"
api_private_key = "/Users/sesousa/Development/Terraform/is-basic-cluster/iscoe.pem"



server_names = [
 " C240-WZP21400H6C",
 " C240-WZP2138003C",
 " C240-WZP214903Y3",
 " C240-WZP2138002S",
 " C240-WZP2138001O",
 " C240-WZP21380LWF",
 " C240-WZP21380LX4",
 " C240-WZP21400H6O",
 " C240-WZP21380LWJ",
 " C240-WZP21380LWR",
]

organization_name = "Weka"

catalog_name = "user-catalog"

policy_name_prefix = "wekatf_"

#Lan Connectivity Variables
iqn_allocation_type = "None"
placement_mode = "auto"
target_platform = "Standalone"


ethernet_qos_policies = [
    { vnic_qos = 1500 },
    { vnic_qos = 9000 }
 ]

ethernet_adapter_policies = [ 
    {net_function = "mgmt",compqueue_nr = 3,compqueue_ringsize = 1,rxqueue_nr = 4,rxqueue_ringsize = 512,txqueue_nr = 4,txqueue_ringsize = 512},
    {net_function = "cluster",compqueue_nr = 3,compqueue_ringsize = 1,rxqueue_nr = 8,rxqueue_ringsize = 4096,txqueue_nr = 2,txqueue_ringsize = 512} 
]
    
ethernet_networks = [

    { description = "Management", default_vlan = 81, allowed_vlans = "89,88", eth_mode = "TRUNK"},
    { description = "ClusterA", default_vlan = 53, allowed_vlans = "53", eth_mode = "TRUNK"},
    { description = "ClusterB", default_vlan = 54, allowed_vlans = "54", eth_mode = "TRUNK"}
  ]

network_config = [
    {description = "mgmt0", default_vlan = 81, vnic_slot = "0", vic_slot_id = 2, pci_link = 0, phy_port = "0", if_nameprefix = "eth", adapter_policy = "mgmt", qos_policy = "1500"},
    {description = "mgmt1", default_vlan = 81, vnic_slot = "1", vic_slot_id = 2, pci_link = 0, phy_port = "1", if_nameprefix = "eth", adapter_policy = "mgmt", qos_policy = "1500"},
    {description = "faba01", default_vlan = 53, vnic_slot = "2", vic_slot_id = 2, pci_link = 0, phy_port = "0", if_nameprefix = "eth", adapter_policy = "cluster", qos_policy = "9000"},
    {description = "fabb01", default_vlan = 54, vnic_slot = "3", vic_slot_id = 2, pci_link = 0, phy_port = "1", if_nameprefix = "eth", adapter_policy = "cluster", qos_policy = "9000"}
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

# BIOS Inputs
bios_name = "bios"
bios_description = "Weka BIOS Policy"

# Server Profile Template Inputs
server_template_name = "servernode"
server_template_description = "Weka Server Profile Template"
server_template_platform = "Standalone" # Standalone or FIAttached