variable "tags" {}

variable "vnet_cidrs" {
    description = "The address space that is used the virtual network"
    type        = list(any)
}

variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}

variable "region" {
    description = "The location/region where the virtual network is created"
    type        = string
}

variable "subnets" {}

variable "enable_nsg" {
    description = "Enables a network securty group"
    type        = bool
}

variable "nsg_rules" {}

variable "enable_p2p_vpn" {
    description = "Enables a point_to_point_vpn"
    type        = bool
}

variable "gateway_subnet_cidr" {
    description = "The CIDR block for the GateWay subnet"
    type        = string
}

variable "remote_site_name" {
    description = "The name of the VPN remote site"
    type        = string
}

variable "remote_peer_ip" {
    description = "The remote peer IP address"
    type        = string
}

variable "remote_network_cidr" {
    description = "The remote peer internal CIDR"
    type        = string
}

variable "pip_allocation_method" {
    description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
    type        = string
}

variable "pip_sku" {
    description = "The SKU of the Public IP. Accepted values are Basic and Standard"
    type        = string
}

variable "network_gateway_sku" {
    description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ"
    type        = string
}

variable "vpn_type" {
    description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased"
    type        = string
}

variable "vpn_active_active" {
    description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance SKU. If false, an active-standby gateway will be created."
    type        = bool
}

variable "vpn_enable_bgp" {
    description = "f true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway"
    type        = bool
}