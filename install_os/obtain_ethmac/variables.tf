# Device MOIDs
variable "device_moids" { 
  type = list
}

variable "mgmt_if" {
  type = string
  description = "name of the managament interface for initial IP configuration "
}

variable "mgmt_if_slot" {  
  type = number
  description = "slot where the mgmt_if is located: Can be MLOM, 2 or 5"
}
