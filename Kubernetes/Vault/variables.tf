variable "vault_namespace" {
    type        = string
    description = "The namespace vault will be deployed to."
}

variable "vault_crt" {
    type        = string
    description = "The TLS certificate for vault server."
    sensitive   = true
}

variable "vault_key" {
    type        = string
    description = "The TLS certificate key for vault server."
    sensitive   = true
}

variable "vault_ca" {
    type        = string
    description = "The TLS certificate for Certificate Authority."
    sensitive   = true
}

variable "registry_server" {
    type        = string
    description = "The container registry URL."
}

variable "registry_username" {
    type        = string
    description = "The container registry username."
}

variable "registry_password" {
    type        = string
    description = "The container registry password."
    sensitive   = true
}

variable "auto_unseal_keyvault_name" {
    type        = string
    description = "The name of the Auto Unseal Azure Key Vault."
}

variable "auto_unseal_keyvault_resource_group" {
    type        = string
    description = "The name of the Auto Unseal Azure Key Vault Resource Group."
}

variable "values_yaml_secret_name" {
    type        = string
    description = "The name of the secret containing values.yaml."
}