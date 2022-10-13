region = "eastus"
tags   = {
    environment = "prod"
    department = "devops"
}

vnet_name                        = "Test"
vnet_rg_name                     = "Test-RG"
pip_allocation_method            = "Static"
pip_sku                          = "Standard"
rt_disable_bgp_route_propagation = false
firewall_subnet_name             = "public"
firewall_subnet_cidr             = "10.0.255.0/26"
protected_subnet_cidr            = "10.0.5.0/24"
protected_subnet_name            = "FwProtectedSubnet"
fw_sku_name                      = "AZFW_VNet"
fw_sku_tier                      = "Standard"
fw_policy_proxy_enabled          = true

fw_rules = {
    allow-all = {
        priority              = 100
        action                = "Allow"
        protocols             = ["TCP", "UDP"]
        source_addresses      = "*"
        destination_ports     = "*"
        destination_addresses = "*"
    }
}