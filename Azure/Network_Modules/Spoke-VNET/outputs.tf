output "resource_group_name" {
  value = azurerm_resource_group.spoke_rg.name
}

output "resource_group_id" {
  value = azurerm_resource_group.spoke_rg.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.network_security_group.*.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "route_table_id" {
  value = azurerm_route_table.route_table.id
}