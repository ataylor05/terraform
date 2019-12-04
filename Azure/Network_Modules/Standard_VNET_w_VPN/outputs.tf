output "vnet_rg_id" {
  value = azurerm_resource_group.vnet_rg.id
}

output "vnet_nsg_id" {
  value = azurerm_network_security_group.vnet_nsg.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}

output "local_network_gateway_id" {
  value = azurerm_local_network_gateway.local_network_gateway.id
}

output "vpn_gw_public_ip_id" {
  value = azurerm_public_ip.vpn_gw_public_ip.id
}