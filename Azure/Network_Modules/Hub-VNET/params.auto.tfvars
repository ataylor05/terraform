region = "eastus"
tags   = {
    environment = "prod"
    department = "devops"
}

vnet_name  = "Test"
vnet_cidr  = "10.0.0.0/16"
enable_nsg = true

subnets = {
    public = {
        address_prefixes  = ["10.0.0.0/24"]
        service_endpoints = null
        nsg_association   = true
    }
    private = {
        address_prefixes  = ["10.0.1.0/24"]
        service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web"]
        nsg_association   = false
    }
}

nsg_rules = {
    ssh-inbound = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    http-inbound = {
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    https-inbound = {
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

enable_p2p_vpn        = false
gateway_subnet_cidr   = "10.0.254.0/24"
remote_site_name      = "Home"
remote_peer_ip        = "1.2.3.4"
remote_network_cidr   = "192.168.0.0/16"
pip_allocation_method = "Static"
pip_sku               = "Standard"
network_gateway_sku   = "VpnGw1"
vpn_type              = "RouteBased"
vpn_active_active     = false
vpn_enable_bgp        = false
vpn_ike_version       = "IKEv2"
vpn_psk               = "password"
vpn_ike_encryption    = "AES256"
vpn_ike_integrity     = "SHA256"
vpn_dh_group          = "DHGroup2"
vpn_ipsec_encryption  = "GCMAES256"
vpn_ipsec_integrity   = "GCMAES256"
vpn_pfs_group         = "None"
vpn_sa_lifetime       = 27000