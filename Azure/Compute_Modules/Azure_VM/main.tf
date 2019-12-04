data "azurerm_virtual_network" "vm_vnet" {
  name                = var.vm_vnet_name
  resource_group_name = var.vnet_resource_group
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.id
  resource_group_name  = var.vnet_resource_group
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = "${var.app_name}Web-NSG"
  location            = var.region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment     = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}

resource "azurerm_public_ip" "web_pip" {
  name                = "${var.vm_name}-PIP"
  location            = var.region
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment     = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}

resource "azurerm_network_interface" "web_nic" {
  name                      = "${var.vm_name}-NIC"
  location                  = var.region
  resource_group_name       = var.resource_group
  network_security_group_id = azurerm_network_security_group.web_nsg.id

  ip_configuration {
    name                                    = "IpConfiguration1"
    subnet_id                               = data.azurerm_subnet.vm_subnet.id
    private_ip_address_allocation           = "Static"
    public_ip_address_id                    = azurerm_public_ip.web_pip.id
  }
  tags = {
    environment     = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}

resource "azurerm_availability_set" "web_as" {
  name                = "Web-Availability-Set"
  location            = var.region
  resource_group_name = var.resource_group
  managed = true
  tags = {
    environment     = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}

resource "azurerm_virtual_machine" "web_vm" {
  name                             = var.vm_name
  location                         = var.region
  resource_group_name              = var.resource_group
  network_interface_ids            = [azurerm_network_interface.web_nic.id]
  vm_size                          = var.vm_size
  availability_set_id              = azurerm_availability_set.web_as.id
  delete_os_disk_on_termination    = var.delete_disks_on_termination
  delete_data_disks_on_termination = var.delete_disks_on_termination

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.7"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_username
    admin_password = var.vm_user_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment     = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}