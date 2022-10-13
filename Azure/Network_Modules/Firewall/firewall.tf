resource "azurerm_public_ip" "vnet_firewall_pip" {
  count               = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-Firewall-PIP"
  location            = var.region
  resource_group_name = var.hub_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "vnet_firewall" {
  count               = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                = "${var.hub_vnet_name}-Firewall"
  location            = var.region
  resource_group_name = var.hub_rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet[count.index].id
    public_ip_address_id = azurerm_public_ip.vnet_firewall_pip[count.index].id
  }
}

resource "azurerm_route_table" "vnet_route_table" {
  name                          = var.hub_route_table_name
  location                      = var.region
  resource_group_name           = var.hub_rg_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_subnet" "firewall_subnet" {
  count                = "${var.enable_subnet_firewall == true ? 1 : 0}"
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.hub_rg_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.firewall_subnet_cidr]
}