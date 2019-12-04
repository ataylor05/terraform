resource "azurerm_resource_group" "vnet_rg" {
  name     = "${var.vnet_name}-RG"
  location = var.region
}

resource "azurerm_network_security_group" "vnet_nsg" {
  name                = "${var.vnet_name}-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name
}

resource "azurerm_virtual_network" "virtual_network" {
  name          = var.vnet_name
  address_space = [var.vnet_cidr]
  location      = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_subnet" "public_subnet" {
  depends_on                = [azurerm_virtual_network.virtual_network]
  name                      = var.public_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.public_subnet
}

resource "azurerm_subnet" "app_subnet" {
  depends_on                = [azurerm_subnet.public_subnet]
  name                      = var.app_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.app_subnet
}

resource "azurerm_subnet" "data_subnet" {
  depends_on                = [azurerm_subnet.app_subnet]
  name                      = var.data_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.data_subnet
}

resource "azurerm_subnet" "mgmt_subnet" {
  depends_on                = [azurerm_subnet.data_subnet]
  name                      = var.mgmt_subnet_name
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.mgmt_subnet
}

resource "azurerm_subnet" "gateway_subnet" {
  depends_on                = [azurerm_subnet.mgmt_subnet]
  name                      = "GatewaySubnet"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefix            = var.gateway_subnet
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  depends_on                = [azurerm_subnet.gateway_subnet]
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  depends_on                = [azurerm_subnet_network_security_group_association.public_nsg_association]
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "data_nsg_association" {
  depends_on                = [azurerm_subnet_network_security_group_association.app_nsg_association]
  subnet_id                 = azurerm_subnet.data_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "mgmt_nsg_association" {
  depends_on                = [azurerm_subnet_network_security_group_association.data_nsg_association]
  subnet_id                 = azurerm_subnet.mgmt_subnet.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}