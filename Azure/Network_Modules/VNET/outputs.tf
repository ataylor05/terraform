output "resource_group_id" {
  value = azurerm_resource_group.resource_group.id
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "network_security_group_id" {
  value = azurerm_network_security_group.network_security_group.*.id
}

output "subnets" {
  value = azurerm_subnet.subnets
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.*.id
}

output "local_network_gateway" {
  value = azurerm_local_network_gateway.local_network_gateway
}