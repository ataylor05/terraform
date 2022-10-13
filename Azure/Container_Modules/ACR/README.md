# terraform-azure-container-registry
A Terraform module to create an Azure Container Registry


## Using this module
```
module "container_registry" {
  depends_on                    = [azurerm_resource_group.shared_services_rg]
  source                        = "github.com/teokyllc/terraform-azure-container-registry"
  rg_name                       = azurerm_resource_group.shared_services_rg.name
  cr_name                       = "SharedServicesCR"
  region                        = local.region
  sku                           = "Standard"
  admin_account_enabled         = true
  public_network_access_enabled = false
}
```
