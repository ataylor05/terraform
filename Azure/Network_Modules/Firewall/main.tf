resource "azurerm_public_ip" "firewall_pip" {
  name                = "${var.vnet_name}-Firewall-PIP"
  location            = var.region
  resource_group_name = var.vnet_rg_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
  tags                = var.tags
}

resource "azurerm_route_table" "protected_route_table" {
  name                          = "${var.vnet_name}-Firewall-Protected"
  location                      = var.region
  resource_group_name           = var.vnet_rg_name
  disable_bgp_route_propagation = var.rt_disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.firewall_subnet_cidr]
}

resource "azurerm_subnet" "firewall_protected_subnet" {
  name                 = var.protected_subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.protected_subnet_cidr]
}

resource "azurerm_firewall" "firewall" {
  name                = "${var.vnet_name}-Firewall"
  location            = var.region
  resource_group_name = var.vnet_rg_name
  sku_name            = var.fw_sku_name
  sku_tier            = var.fw_sku_tier
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

resource "azurerm_route" "firewall_route" {
  name                   = "FirewallRoute"
  resource_group_name    = var.vnet_rg_name
  route_table_name       = azurerm_route_table.protected_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  subnet_id      = azurerm_subnet.firewall_protected_subnet.id
  route_table_id = azurerm_route_table.protected_route_table.id
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "${var.vnet_name}-Firewall-Policy"
  resource_group_name = var.vnet_rg_name
  location            = var.region

  dns {
    proxy_enabled = var.fw_policy_proxy_enabled
    servers       = var.fw_policy_dns_servers
  }
}