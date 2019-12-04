resource "azurerm_resource_group" "sql_rg" {
  name     = "${var.project_name_prefix}-SQL-RG"
  location = var.region
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = var.sql_server_name
  location            = var.region
  resource_group_name = azurerm_resource_group.sql_rg.name
  sku {
    name     = var.sql_sku
    capacity = var.sql_server_capacity
    tier     = var.sql_tier
    family   = var.sql_server_generation
  }
  storage_profile {
    storage_mb            = var.storage_size_in_mb
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup  = var.geo_redundant_backup
  }

  administrator_login          = var.sql_server_admin_username
  administrator_login_password = var.sql_server_admin_password
  version                      = var.sql_server_version
  ssl_enforcement              = var.ssl_enforcement
}