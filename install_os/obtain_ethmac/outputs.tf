

output "mac_address" {
  value = [for result in data.intersight_adapter_host_eth_interface.mgmtif_eth0.*.results: result[0].mac_address]
}

output "eth_interface" {
  value = data.intersight_adapter_host_eth_interface.mgmtif_eth0
}



