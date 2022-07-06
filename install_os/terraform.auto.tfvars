# Use the same organization name as on server_profiles plan
organization_name = "Weka"

# Software catalog name
catalog_name = "user-catalog"

#policy_name_prefix = "wekaIO."

# OS ISO to deploy
osimagelink_name = "centos82weka"

# UCS System Configuration Utility to use
scuimagelink_name = "scu613c"

# Ethernet interface where to assign OS management IP
# It needs to align with the configuration defined by server_profiles plan, more specifically variable: vnic_name on module ethernet_interfaces
mgmt_if = "eth0"

# Ethernet slot that hosts the management interfaces for the OS
# It needs to align with the configuration defined by server_profiles plan, more specifically variable: vic_slotid on module ethernet_interfaces
mgmt_if_slot = 2

# Storage target ID as per the storage configuration on server_profiles/storage_dg plan
# By default boot drive has target id 0
storage_target_id = "0"

# Storage target name as per the storage configuration on server_profiles/storage_dg plan, variable "name" on the bootable virtual drive
# By default boot drive has target id 0
storage_target_name = "wekaIO.boot"

# Storage target controler for the target virtual drive
# Should be inline with server_profiles plan         
storage_controller_slot = "MRAID"


# Configuration Source : Cisco 
# Configuration File : 
# ESXi  : ESXi6.7ConfigFile, ESXi6.5ConfigFile, 
# Redhat: RHEL8ConfigFile, RHEL7ConfigFile
# Ubuntu: No cisco provided config
# Windows: Windows2019ConfigFile, Windows2016ConfigFile
os_install_configuration_file_selector = "$filter=Name eq 'CentOS8ConfigFile'"
os_ip_config_type = "static"  # static or dhcp

# Is the below root password (os_root_password) BASE64 crypted?
root_pass_crypted = false

os_answers_nr_source = "Template" # Template for cisco provided source files


