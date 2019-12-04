resource "azurerm_sql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group
  location                     = var.region
  version                      = var.sql_server_version
  administrator_login          = var.sql_server_username
  administrator_login_password = var.sql_server_password
  tags = {
    environment     = var.environment_tag
    "business unit" = var.business_unit_tag
  }
}

resource "azurerm_sql_database" "sonarqube_db" {
  name                = var.sonarqube_db_name
  resource_group_name = var.resource_group
  location            = var.region
  server_name         = azurerm_sql_server.sql_server.name
  edition             = var.sql_edition
  tags = {
    environment     = var.environment_tag
    "business unit" = var.business_unit_tag
  }
}