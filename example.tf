locals {
  app_name          = "App1"
  region            = "eastus2"
  resource_group    = "sre-nonprod-east2-rg"
  tag_environment   = "production"
  tag_business_unit = "developers"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "alm-demo-k8s-cluster-1"
  location            = "eastus2"
  resource_group_name = "sre-nonprod-east2-rg"
  dns_prefix          = "alm-cluster-1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = 
  }

resource "azurerm_container_registry" "acr" {
  name                     = "containerRegistry1"
  resource_group_name      = "sre-nonprod-east2-rg"
  location                 = "eastus2"
  sku                      = "Premium"
  admin_enabled            = false
}