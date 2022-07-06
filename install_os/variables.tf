# Authentication

# Intersight API endpoint
variable "api_private_key" {
  default = "/Users/sesousa/Development/Terraform/is-basic-cluster/iscoe.pem"
}
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

variable "osimagelink_name" {}

variable "scuimagelink_name" {}

variable "os_ip_config_type" {
  type        = string
  description = "OS Configuration Type"
}
variable "os_install_configuration_file_selector" {
  type        = string
  description = "Cisco provided OS configuration file name"
}

variable "mgmt_if" {
  type = string
  description = "name of the managament interface for initial IP configuration "
}

variable "mgmt_if_slot" {
  type = number
  description = "slot where the mgmt_if is located: Can be MLOM, 2 or 5"
}

variable "root_pass_crypted" {
  type = bool
  description = "Is the root password crypted?"
}


variable "storage_target_id" {
  type = string
}                      

variable "storage_target_name" {
  type = string
}                    

variable "storage_controller_slot" {
  type = string
}


## OS IP Info
# IP address pool should be of the same size of server pool (at least)
variable "os_ipv4_addr" {
  type        = list
  description = "OS IPv4 addresses"
}
variable "os_ipv4_netmask" {
  type        = string
  description = "OS IPv4 Subnet mask"
}
variable "os_ipv4_gateway" {
  type        = string
  description = "OS IPv4 Gateway"
}
variable "os_ipv4_dns_ip" {
  type        = string
  description = "IPv4 DNS server IP"
}
variable "os_root_password" {
  type        = string
  description = "OS Password"
}
variable "os_answers_nr_source" {
  type        = string
  description = "Source of Answer file"
  default     = "Template" # Template for cisco provided source files
}