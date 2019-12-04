output "lb_pip_id" {
  value = azurerm_public_ip.lb_pip.id
}

output "lb_pip_ip_address" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "lb_pip_fqdn" {
  value = azurerm_public_ip.lb_pip.fqdn
}

output "lb_id" {
  value = azurerm_lb.lb.id
}

output "lb_private_ip_address" {
  value = azurerm_lb.lb.private_ip_address
}

output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

output "lb_probe_id" {
  value = azurerm_lb_probe.lb_probe.id
}