output "web_app_service_plan_id" {
  value = azurerm_app_service_plan.web_app_service_plan.id
}

output "web_app_service_id" {
  value = azurerm_app_service.web_app_service.id
}

output "web_app_service_default_site_hostname" {
  value = azurerm_app_service.web_app_service.default_site_hostname
}

output "web_app_service_outbound_ip_addresses" {
  value = azurerm_app_service.web_app_service.outbound_ip_addresses
}