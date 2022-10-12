data "azurerm_key_vault" "unseal_keyvault" {
  name                = var.auto_unseal_keyvault_name
  resource_group_name = var.auto_unseal_keyvault_resource_group
}

data "azurerm_key_vault_secret" "values_yaml" {
  name         = var.values_yaml_secret_name
  key_vault_id = data.azurerm_key_vault.unseal_keyvault.id
}

resource "kubernetes_namespace" "vault_ns" {
  metadata {
    name = var.vault_namespace
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  wait       = false
  namespace  = kubernetes_namespace.vault_ns.metadata[0].name
  values     = [data.azurerm_key_vault_secret.values_yaml.value]
}

resource "kubernetes_secret" "vault_tls_cert" {
  metadata {
    name       = "vault-tls"
    namespace  = kubernetes_namespace.vault_ns.metadata[0].name
  }
  data = {
    "vault.crt" = var.vault_crt
    "vault.key" = var.vault_key
    "vault.ca"  = var.vault_ca
  }
  type = "generic"
}

resource "kubernetes_secret" "acr_access" {
  metadata {
    name       = "acr-access"
    namespace  = kubernetes_namespace.vault_ns.metadata[0].name
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}