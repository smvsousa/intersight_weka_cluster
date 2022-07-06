# Weka.IO cluster management with Cisco Intersight
# ________________________________________________
#   Plan outcomes : OS configuration and WekaIO software deployment
#   Plan version  : 0.5 (Draft)
#   Author        : Sergio Sousa (https://www.linkedin.com/in/ssousa/)
# 

# Intersight provider Information
terraform {
  cloud {    
    organization = "cisco-lisbon-coe"    # Your Terraform Cloud organization
    workspaces {      
      name = "weka_configure_os"    # Your Terraform Cloud workspace.
    }  
  }
  
  /*required_providers { 
    intersight = {
      source = "CiscoDevNet/intersight"
      version = "~> 1.0.28" }
  } */
}

locals {
  server_names  = compact(tolist(values(var.profiles2servers)))  # List of physical server names
  profiles      = compact(tolist(keys(var.profiles2servers)))  # List of server profile names
  
# Operating System install answers    
  settings = flatten([
    for profile,server in var.profiles2servers : {
      server_profile      = profile
      server_name         = server
   #   mgmtif_mac          = lookup(local.server_macs,  server, "")
      ipv4addr            = var.os_ipv4_addr[index(local.profiles,profile)] # Select IP on the same index position as the server profile to keep consistency.
    } if server != ""
    ])
}


resource "null_resource" "cluster" {
    count = length(local.settings)

  provisioner "remote-exec" {
    inline = [
      "echo 0 > /proc/sys/kernel/numa_balancing", # Disable NUMA balancing. The Weka system manages the NUMA balancing by itself and makes the best possible decisions.
      "find /etc/yum.repos.d -type f -exec sed -i 's/^mirrorlist/#mirrorlist/g' {} \\;",  # Centos EOL - Repository changed from mirror to vault
      "find /etc/yum.repos.d -type f -exec sed -i 's/^#baseurl/baseurl/g' {} \\;", # Centos EOL - Repository changed from mirror to vault
      "find /etc/yum.repos.d -type f -exec sed -i 's/mirror/vault/g' {} \\;", # Centos EOL - Repository changed from mirror to vault
      "dnf upgrade -y", # Upgrade CentOS
      "sed -i 's/^pool.*/pool ${var.ntp_pool} iburst/' /etc/chrony.conf", # Use local NTP servers
      "systemctl restart chronyd", # Restart NTP service
      # "reboot"
    ]

    on_failure = continue

    # Establishes connection to be used by all
    # generic remote provisioners (i.e. file/remote-exec)
    connection {
    type     = "ssh"
    user     = "root"
    password = "MyR00tP4ss" # var.os_root_password
    host     = local.settings[count.index].ipv4addr
    }
  }
}

output "Settings" {
  value = local.settings
}


