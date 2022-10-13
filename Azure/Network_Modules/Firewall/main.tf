resource "azurerm_public_ip" "firewall_pip" {
  name                = "${var.vnet_name}-Firewall-PIP"
  location            = var.region
  resource_group_name = var.vnet_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}



# resource "azurerm_route" "firewall_route" {
#   count                  = "${var.enable_subnet_firewall == true ? 1 : 0}"
#   depends_on             = [azurerm_firewall.vnet_firewall]
#   name                   = "FirewallRoute"
#   resource_group_name    = var.hub_rg_name
#   route_table_name       = azurerm_route_table.vnet_route_table.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = azurerm_firewall.vnet_firewall[count.index].ip_configuration[0].private_ip_address
# }
