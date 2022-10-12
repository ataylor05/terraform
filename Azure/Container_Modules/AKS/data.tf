data "azurerm_subnet" "k8s_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.aks_vnet_name
  resource_group_name  = var.network_resource_group
}