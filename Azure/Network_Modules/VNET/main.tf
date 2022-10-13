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
  address_space       = var.vnet_cidrs
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
  default_local_network_gateway_id = azurerm_local_network_gateway.local_network_gateway.id
  tags                             = var.tags

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_public_ip.id
    private_ip_address_allocation = var.pip_allocation_method
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  count                      = "${var.enable_p2p_vpn == true ? 1 : 0}"
  depends_on                 = [azurerm_virtual_network_gateway.virtual_network_gateway]
  name                       = "Hub-to-OnPrem"
  location                   = var.region
  resource_group_name        = var.hub_rg_name
  type                       = "IPsec"
  connection_protocol        = "IKEv2"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.virtual_network_gateway[count.index].id
  local_network_gateway_id   = azurerm_local_network_gateway.ptp_vpn_local_gw[count.index].id
  shared_key                 = var.ptp_vpn_psk

  ipsec_policy {
   ike_encryption   = var.ptp_vpn_ike_encryption
   ike_integrity    = var.ptp_vpn_ike_integrity
   dh_group         = var.ptp_vpn_dh_group
   ipsec_encryption = var.ptp_vpn_ipsec_encryption
   ipsec_integrity  = var.ptp_vpn_ipsec_integrity
   pfs_group        = var.ptp_vpn_pfs_group
   sa_lifetime      = var.ptp_vpn_sa_lifetime
  }

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_route" "vpn_route" {
  count               = "${var.enable_p2p_vpn == true ? 1 : 0}"
  name                = "VPNRoute"
  resource_group_name = azurerm_resource_group.resource_group.name
  route_table_name    = azurerm_virtual_network.virtual_network.
  address_prefix      = var.ptp_vpn_remote_network
  next_hop_type       = "VirtualNetworkGateway"
}