
variable "policy_name_prefix" {}
variable "organization_moid" {}
variable "storage_policy_moid" {}
variable "storage_dg_name" {}
variable "storage_dg_raid" {}
variable "storage_dg_type" {} # "0" for manual drive selectio and "1" for automatic drive selection
variable "storage_dg_drive_slots" {}
variable "storage_vd_name" {}
variable "storage_vd_size" {} #minimum size
variable "storage_vd_expand" {} # true or false
variable "storage_vd_bootable" {} # true or false