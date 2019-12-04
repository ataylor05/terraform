output "web_nic_id" {
  value = azurerm_network_interface.web_nic.id
}

output "web_nsg_id" {
  value = azurerm_network_security_group.web_nsg.id
}

output "web_nic_private_ip_address" {
  value = azurerm_network_interface.web_nic.private_ip_address
}

output "web_pip_id" {
  value = azurerm_public_ip.web_pip.id
}

output "web_pip_ip_address" {
  value = azurerm_public_ip.web_pip.ip_address
}

output "web_pip_fqdn" {
  value = azurerm_public_ip.web_pip.fqdn
}

output "web_availability_set_id" {
  value = azurerm_availability_set.web_as.id
}

output "web_vm_id" {
  value = azurerm_virtual_machine.web_vm.id
}