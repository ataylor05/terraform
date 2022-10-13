output "acr_id" {
  value = azurerm_container_registry.acr.id
  description = "The ID of the Azure container registry"
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
  description = "The name of the Azure container registry"
}

output "acr_login_url" {
  value = azurerm_container_registry.acr.login_server
  description = "The URL of the Azure container registry"
}

output "acr_login_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  description = "The admin username of the Azure container registry"
}

output "acr_login_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  description = "The admin password of the Azure container registry"
}
