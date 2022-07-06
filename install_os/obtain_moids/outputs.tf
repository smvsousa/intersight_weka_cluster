output "server_moids" {
  value = data.intersight_compute_physical_summary.server_moid.*.results.0.moid
}

output "device_moids" {
  value = data.intersight_compute_physical_summary.server_moid.*.results.0.device_mo_id
}

output "organization_moid" {
  value = data.intersight_organization_organization.organization_moid.results[0].moid
}

output "catalog_moid" {
  value = data.intersight_softwarerepository_catalog.catalog_moid.results[2].moid
}

output "osimagelink_moid" {
  value = data.intersight_softwarerepository_operating_system_file.osimagelink_moid.results[0].moid
}

output "scuimagelink_moid" {
  value = data.intersight_firmware_server_configuration_utility_distributable.scuimagelink_moid.results[0].moid
}

