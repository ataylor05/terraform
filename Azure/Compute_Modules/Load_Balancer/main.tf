resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.lb_name}-PIP"
  location            = var.region
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment   = var.tag_environment
    business_unit = var.tag_business_unit
  }
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.region
  resource_group_name = var.resource_group
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

  tags = {
    environment   = var.tag_environment
    business_unit = var.tag_business_unit
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = var.lb_probe_path
  port                = var.lb_probe_port
}