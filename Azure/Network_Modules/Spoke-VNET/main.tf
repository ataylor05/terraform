resource "azurerm_resource_group" "spoke_rg" {
  name     = "${var.vnet_name}-Network-RG"
  location = var.region
  tags     = var.tags
}

resource "azurerm_network_security_group" "network_security_group" {
  count               = var.enable_nsg ? 1 : 0
  name                = "${var.vnet_name}-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.spoke_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each                    = { for k, v in var.nsg_rules : k => v if var.enable_nsg }
  name                        = each.key
  priority                    = each.value["priority"]
  direction                   = each.value["direction"]
  access                      = each.value["access"]
  protocol                    = each.value["protocol"]
  source_port_range           = each.value["source_port_range"]
  destination_port_range      = each.value["destination_port_range"]
  source_address_prefix       = each.value["source_address_prefix"]
  destination_address_prefix  = each.value["destination_address_prefix"]
  resource_group_name         = azurerm_resource_group.spoke_rg.name
  network_security_group_name = azurerm_network_security_group.network_security_group[0].name
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.vnet_name}-VNET"
  address_space       = [var.vnet_cidr]
  location            = var.region
  resource_group_name = azurerm_resource_group.spoke_rg.name
  tags                = var.tags
}

resource "azurerm_route_table" "route_table" {
  name                          = "${var.vnet_name}-Route-Table"
  location                      = var.region
  resource_group_name           = azurerm_resource_group.spoke_rg.name
  disable_bgp_route_propagation = false
  tags                          = var.tags
}

resource "azurerm_route" "route_to_internet" {
  name                = "Internet"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  route_table_name    = azurerm_route_table.route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_route" "route_to_local_vnet" {
  name                = "LocalVNET"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  route_table_name    = azurerm_route_table.route_table.name
  address_prefix      = var.vnet_cidr
  next_hop_type       = "VnetLocal"
}

resource "azurerm_subnet" "subnets" {
  for_each                  = var.subnets
  name                      = each.key
  resource_group_name       = azurerm_resource_group.spoke_rg.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = each.value["address_prefixes"]
  service_endpoints         = each.value["service_endpoints"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each                  = { for k, v in var.subnets : k => v if v.nsg_association }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[0].id
}

resource "azurerm_subnet_route_table_association" "route_table_associations" {
  for_each       = { for k, v in var.subnets : k => v }
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_table.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "Hub-to-${var.vnet_name}"
  resource_group_name          = var.hub_vnet_rg
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_network.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = var.enable_remote_gateways
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${var.vnet_name}-to-Hub"
  resource_group_name          = azurerm_resource_group.spoke_rg.name
  virtual_network_name         = azurerm_virtual_network.virtual_network.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.enable_remote_gateways
}