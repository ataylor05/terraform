variable "region" {
    type = string
    description = "The Azure region the resources will be deployed to."
}

variable "vnet_name" {
    type = string
    description = "The name of an Azure VNET."
}

variable "vnet_rg_name" {
    type = string
    description = "The name of an Azure VNET resource group."
}