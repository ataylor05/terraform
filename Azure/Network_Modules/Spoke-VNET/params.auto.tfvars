region = "eastus"
tags   = {
    environment = "prod"
    department = "devops"
}

hub_vnet_name          = "Test"
hub_vnet_rg            = "Test-RG"
vnet_name              = "App1"
vnet_cidr              = "10.1.0.0/16"
enable_nsg             = true
enable_remote_gateways = false

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
}

subnets = {
    default-1 = {
        address_prefixes  = ["10.1.0.0/24"]
        service_endpoints = null
        nsg_association   = true
    }
    default-2 = {
        address_prefixes  = ["10.1.1.0/24"]
        service_endpoints = null
        nsg_association   = true
    }
}