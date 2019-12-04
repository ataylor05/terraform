output "sql_server_id" {
  value = azurerm_sql_server.sql_server.id
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}

output "sql_server_username" {
  value = var.sql_server_username
}

output "sonarqube_db_id" {
  value = azurerm_sql_database.sonarqube_db.id
}

output "sonarqube_db_name" {
  value = var.sonarqube_db_name
}