output "firewall_pip_id" {
  value       = azurerm_public_ip.firewall_pip.id
  description = "The ID of this Public IP."
}

output "firewall_pip_name" {
  value       = azurerm_public_ip.firewall_pip.name
  description = "The name of this Public IP."
}

output "firewall_pip_ip_address" {
  value       = azurerm_public_ip.firewall_pip.ip_address
  description = "The IP address value that was allocated"
}

output "protected_route_table_id" {
  value       = azurerm_route_table.protected_route_table.id
  description = "The Route Table ID"
}

output "protected_route_table_name" {
  value       = azurerm_route_table.protected_route_table.name
  description = "The Route Table name"
}

output "protected_subnet_id" {
  value       = azurerm_subnet.firewall_protected_subnet.id
  description = "The id of the firewall protected subnet"
}

output "firewall_subnet_id" {
  value       = azurerm_subnet.firewall_subnet.id
  description = "The id of the firewall subnet"
}

output "firewall_id" {
  value       = azurerm_subnet.firewall_subnet.id
  description = "The ID of the Azure Firewall"
}