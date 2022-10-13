variable "region" {
    type        = string
    description = "The Azure region the resources will be deployed to."
}

variable "tags" {}

variable "vnet_name" {
    type        = string
    description = "The name of an Azure VNET."
}

variable "vnet_rg_name" {
    type        = string
    description = "The name of an Azure VNET resource group."
}

variable "pip_allocation_method" {
    type        = string
    description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
}

variable "pip_sku" {
    type        = string
    description = "The SKU of the Public IP. Accepted values are Basic and Standard"
}

variable "rt_disable_bgp_route_propagation" {
    type        = string
    description = "Boolean flag which controls propagation of routes learned by BGP on the route table"
}

variable "firewall_subnet_name" {
    type        = string
    description = "The Subnet name where the Azure Firewall will be deployed"
}

variable "firewall_subnet_cidr" {
    type        = string
    description = "The address prefixes to use for the firewall"
}

variable "protected_subnet_cidr" {
    type        = string
    description = "The address prefixes to use for the subnet behind the firewall"
}

variable "protected_subnet_name" {
    type = string
}

variable "fw_sku_tier" {
    type        = string
    description = "SKU tier of the Firewall. Possible values are Premium and Standard"
}

variable "fw_sku_name" {
    type        = string
    description = "SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet"
}

variable "fw_policy_proxy_enabled" {
    type        = bool
    description = "Whether to enable DNS proxy on Firewalls attached to this Firewall Policy"
}

variable "fw_policy_dns_servers" {
    type        = list(any)
    default     = null
    description = "A list of custom DNS servers' IP addresses"
}

variable "fw_rules" {}