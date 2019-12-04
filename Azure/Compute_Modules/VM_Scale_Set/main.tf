data "azurerm_virtual_network" "vm_vnet" {
  name                = var.vm_vnet_name
  resource_group_name = var.vnet_resource_group
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.id
  resource_group_name  = var.vnet_resource_group
}

resource "azurerm_virtual_machine_scale_set" "vm_scale_set" {
  name                = var.vm_ss_name
  location            = var.region
  resource_group_name = var.resource_group
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"
  health_probe_id      = var.lb_health_probe

  rolling_upgrade_policy {
    max_batch_instance_percent              = var.rolling_upgrade_max_batch_percentage
    max_unhealthy_instance_percent          = var.rolling_upgrade_max_unhealthy_batch_percentage
    max_unhealthy_upgraded_instance_percent = var.max_percent_of_upgraded_unhealthy
    pause_time_between_batches              = "PT0S"
  }

  sku {
    name     = var.vm_ss_sku
    tier     = var.vm_ss_tier
    capacity = var.vm_ss_capacity
  }

  storage_profile_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = "${var.app_name}-OS-Disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = var.os_hostname
    admin_username       = var.os_admin_user
    admin_password       = var.admin_passwd
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "NetworkProfile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = data.azurerm_subnet.vm_subnet.id
      load_balancer_backend_address_pool_ids = [var.lb_backend_pool]
    }
  }

  tags = {
    environment   = var.tag_environment
    business_unit = var.tag_business_unit
  }
}