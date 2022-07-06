
variable "policy_name_prefix" {}
variable "organization_moid" { }

# Server Template variables

variable "server_template_name" {}
variable "server_template_description" {}
variable "server_template_platform" {}

# MOIDs of policies to attach
variable "boot_policy_moid" {}
variable "lanconn_policy_moid" {}
variable "adapter_policy_moid" {}
variable "ntp_policy_moid" {}
variable "vkvm_policy_moid" {}
variable "storage_policy_moid" {}
variable "bios_policy_moid" {}
#variable "uuidpool_moid" {}  # Not applicable to Standalone Servers

