variable "tags" {}

variable "vnet_cidr" {
    description = "The address space that is used the virtual network"
    type        = string
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

variable "vpn_psk" {
    type        = string
    sensitive   = true
    default     = null
    description = "The protocol used for this VPN Link Connection. Possible values are IKEv1 and IKEv2"
}

variable "vpn_ike_version" {
    type        = string
    default     = "IKEv2"
    description = "The protocol used for this VPN Link Connection. Possible values are IKEv1 and IKEv2"
}

variable "vpn_ike_encryption" {
    type = string
    default = "AES256"
    description = "The IKE encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, or GCMAES256."
}

variable "vpn_ike_integrity" {
    type        = string
    default     = "SHA256"
    description = "The IKE integrity algorithm. Valid options are GCMAES128, GCMAES256, MD5, SHA1, SHA256, or SHA384."
}

variable "vpn_dh_group" {
    type        = string
    default     = "DHGroup2"
    description = "The DH group used in IKE phase 1 for initial SA. Valid options are DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None."
}

variable "vpn_ipsec_encryption" {
    type        = string
    default     = "AES256"
    description = "The IPSec encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, GCMAES192, GCMAES256, or None."
}

variable "vpn_ipsec_integrity" {
    type        = string
    default     = "GCMAES256"
    description = "The IPSec integrity algorithm. Valid options are GCMAES128, GCMAES192, GCMAES256, MD5, SHA1, or SHA256."
}

variable "vpn_pfs_group" {
    type        = string
    default     = "None"
    description = "The DH group used in IKE phase 2 for new child SA. Valid options are ECP256, ECP384, PFS1, PFS14, PFS2, PFS2048, PFS24, PFSMM, or None."
}

variable "vpn_sa_lifetime" {
    type        = number
    default     = 27000
    description = "The IPSec SA lifetime in seconds. Must be at least 300 seconds."
}