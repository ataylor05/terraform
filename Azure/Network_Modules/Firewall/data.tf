data "azurerm_subnet" "firewall_subnet" {
  name                 = var.firewall_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}