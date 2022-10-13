resource "azurerm_resource_group" "resource_group" {
  name     = "${var.vnet_name}-RG"
  location = var.region
  tags     = var.tags
}

resource "azurerm_network_security_group" "network_security_group" {
  count               = var.enable_nsg ? 1 : 0
  name                = "${var.vnet_name}-NSG"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each                  = var.subnets
  name                      = each.key
  resource_group_name       = azurerm_resource_group.resource_group.name
  virtual_network_name      = azurerm_virtual_network.virtual_network.name
  address_prefixes          = each.value["address_prefixes"]
  service_endpoints         = each.value["service_endpoints"]
}

resource "azurerm_subnet" "gateway_subnet" {
  count                = var.enable_p2p_vpn ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.gateway_subnet_cidr]
}

resource "azurerm_route_table" "route_table" {
  name                          = "${var.vnet_name}-route-table"
  location                      = var.region
  resource_group_name           = azurerm_resource_group.resource_group.name
  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name           = "vnet-route"
    address_prefix = var.vnet_cidr
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each                  = { for k, v in var.subnets : k => v if v.nsg_association }
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.network_security_group[0].id
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
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_security_group[0].name
}

resource "azurerm_local_network_gateway" "local_network_gateway" {
  count               = var.enable_p2p_vpn ? 1 : 0
  name                = "${var.remote_site_name}-GW"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.region
  gateway_address     = var.remote_peer_ip
  address_space       = [var.remote_network_cidr]
  tags                = var.tags
}

resource "azurerm_public_ip" "vpn_gw_public_ip" {
  count               = var.enable_p2p_vpn ? 1 : 0
  name                = "${var.vnet_name}-GW-PIP"
  location            = var.region
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  count                            = var.enable_p2p_vpn ? 1 : 0
  name                             = "${var.vnet_name}-GW"
  location                         = var.region
  resource_group_name              = azurerm_resource_group.resource_group.name
  type                             = "Vpn"
  vpn_type                         = var.vpn_type
  active_active                    = var.vpn_active_active
  enable_bgp                       = var.vpn_enable_bgp
  sku                              = var.network_gateway_sku
  default_local_network_gateway_id = azurerm_local_network_gateway.local_network_gateway[0].id
  tags                             = var.tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_public_ip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet[0].id
  }
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  count                      = var.enable_p2p_vpn ? 1 : 0
  name                       = "Hub-to-OnPrem"
  location                   = var.region
  resource_group_name        = azurerm_resource_group.resource_group.name
  type                       = "IPsec"
  connection_protocol        = var.vpn_ike_version
  virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway[0].id
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway[0].id
  shared_key                 = var.vpn_psk

  ipsec_policy {
   ike_encryption   = var.vpn_ike_encryption
   ike_integrity    = var.vpn_ike_integrity
   dh_group         = var.vpn_dh_group
   ipsec_encryption = var.vpn_ipsec_encryption
   ipsec_integrity  = var.vpn_ipsec_integrity
   pfs_group        = var.vpn_pfs_group
   sa_lifetime      = var.vpn_sa_lifetime
  }
}

resource "azurerm_route" "vpn_route" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                = "VPNRoute"
  resource_group_name = azurerm_resource_group.resource_group.name
  route_table_name    = azurerm_route_table.route_table.name
  address_prefix      = var.remote_network_cidr
  next_hop_type       = "VirtualNetworkGateway"
}