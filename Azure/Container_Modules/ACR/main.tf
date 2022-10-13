resource "azurerm_container_registry" "acr" {
  name                          = var.container_registry_name
  resource_group_name           = var.container_registry_resource_group_name
  location                      = var.region
  sku                           = var.sku
  admin_enabled                 = var.admin_account_enabled
  public_network_access_enabled = var.public_network_access_enabled
}
