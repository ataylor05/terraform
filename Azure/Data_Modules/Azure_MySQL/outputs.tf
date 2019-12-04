output "sql_rg_id" {
  value = azurerm_resource_group.sql_rg.id
}

output "mysql_server_id" {
  value = azurerm_mysql_server.mysql_server.id
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_server.mysql_server.fqdn
}

output "sql_server_name" {
  value = var.sql_server_name
}

output "sql_database_username" {
  value = var.sql_server_admin_username
}

output "sql_database_password" {
  value = var.sql_server_admin_password
}