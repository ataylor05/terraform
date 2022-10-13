variable "region" {
    type        = string
    description = "The AWS region"
}

variable "vpc_name" {
    type        = string
    description = "The name of the VPC"
}

variable "cidr_block" {
    type        = string
    description = "Cidr block of the desired VPC"
}

variable "instance_tenancy" {
    type        = string
    description = "A tenancy option for instances launched into the VPC"
}

variable "enable_dns_support" {
    type        = bool
    description = "Enable/disable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Enable/disable DNS hostnames in the VPC"
}

variable "subnets" {
   type = map
}

variable "route_tables" {
   type = list(any)
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Enable/disable internet gateway in the VPC"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable/disable nat gateway in the VPC"
}

variable "nat_gw_subnet" {
  type        = string
  description = "Subnet from list of subnets"
}

variable "nacl_rules" {
   type = map
}

variable "enable_p2p_vpn" {
    type        = bool
    description = "Enable/disable a point to point VPN"
}

variable "customer_vpn_device_name" {
    type        = string
    description = "A name for the customer gateway device"
}

variable "customer_vpn_gateway_ip" {
    type        = string
    description = "The IPv4 address for the customer gateway device's outside interface"
}

variable "customer_vpn_gateway_bgp_asn" {
    type        = number
    description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)"
}

variable "ike_versions" {
    type        = list(any)
    description = "The IKE version that is permitted"
}

variable "tunnel1_psk" {
    type        = string
    description = "The preshared key of the first VPN tunnel"
    sensitive   = true
    default     = null
}

variable "tunnel2_psk" {
    type        = string
    description = "The preshared key of the second VPN tunnel"
    sensitive   = true
    default     = null
}

variable "phase1_encryption_algorithms" {
    type        = list(any)
    description = "List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16"
}

variable "phase1_dh_group_numbers" {
    type        = list(any)
    description = "List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations. Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24"
}

variable "phase1_integrity_algorithms" {
    type        = list(any)
    description = "One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512"
}

variable "phase1_lifetime_seconds" {
    type        = number
    description = "The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 28800"
}

variable "phase2_dh_group_numbers" {
    type        = list(any)
    description = "List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations"
}

variable "phase2_encryption_algorithms" {
    type        = list(any)
    description = "List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16"
}

variable "phase2_integrity_algorithms" {
    type        = list(any)
    description = "List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512"
}

variable "phase2_lifetime_seconds" {
    type        = number
    description = "The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. Valid value is between 900 and 3600"
}