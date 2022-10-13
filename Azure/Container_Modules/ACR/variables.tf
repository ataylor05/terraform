variable "container_registry_name" {
    type = string
    description = "The name for the container registry."
}

variable "container_registry_resource_group_name" {
    type = string
    description = "The name for the resource group to deploy into."
}

variable "region" {
    type = string
    description = "The Azure region to deploy into."
}

variable "sku" {
    type = string
    description = "The container registry sku."
}

variable "admin_account_enabled" {
    type = string
    description = "Determines if an admin account will be enabled."
}

variable "public_network_access_enabled" {
    type = string
    description = "Determines if public access will be enabled."
}
