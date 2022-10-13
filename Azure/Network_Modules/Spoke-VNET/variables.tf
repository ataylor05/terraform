variable "region" {
    type        = string
    description = "An Azure region"
}

variable "tags" {}

variable "hub_vnet_name" {
    type        = string
    description = "The hub VNET name"
}

variable "hub_vnet_rg" {
    type        = string
    description = "The hub VNET resource group name"
}

variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}

variable "vnet_cidr" {
    description = "The address space that is used the virtual network"
    type        = string
}

variable "subnets" {}

variable "enable_nsg" {
    description = "Enables a network securty group"
    type        = bool
}

variable "nsg_rules" {}

variable "enable_remote_gateways" {
    type        = bool
    description = "Enables routes from a VPN gateway."
}