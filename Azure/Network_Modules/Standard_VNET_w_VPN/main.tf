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

resource "azurerm_local_network_gateway" "local_network_gateway" {
  name                = "${var.remote_site_name}-GW"
  resource_group_name = azurerm_resource_group.vnet_rg.name
  location            = var.region
  gateway_address     = var.remote_peer_ip
  address_space       = [var.remote_network_cidr]
}

resource "azurerm_public_ip" "vpn_gw_public_ip" {
  name                = "${var.vnet_name}-GW-PIP"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  name                = "${var.vnet_name}-GW"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet_rg.name
  type     = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = var.az_vpn_gw_type
  default_local_network_gateway_id = azurerm_local_network_gateway.local_network_gateway.id

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}