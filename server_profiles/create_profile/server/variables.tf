
variable "policy_name_prefix" {}
variable "organization_moid" { }

# Server Profile variables
variable "server_profile_name" {}
variable "server_profile_description" {}
variable "server_profile_platform" {}

# Uncomment the variable below to use server profile templates
#
#variable "src_template_moid" {}
variable "boot_policy_moid" {}
variable "lanconn_policy_moid" {}
variable "ntp_policy_moid" {}
variable "vkvm_policy_moid" {}
variable "storage_policy_moid" {}
variable "bios_policy_moid" {}
variable "physical_server" {}
variable "tags_key1" {}
variable "tags_value1" {}
variable "tags_key2" {}
variable "tags_value2" {}
#variable "uuidpool_moid" {} ##  NOT APPLICABLE TO STANDALONE SERVERS