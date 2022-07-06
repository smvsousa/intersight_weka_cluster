
# Server and Organization names
variable "profiles2servers" { 
  type = map(string)
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
