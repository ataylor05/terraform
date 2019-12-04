resource "azurerm_app_service_plan" "web_app_service_plan" {
  name                = "${var.app_name}-App-Service-Plan"
  location            = var.region
  resource_group_name = var.resource_group
  kind                = var.os_platform
  reserved            = true
  sku {
    tier     = var.app_service_plan_tier
    size     = var.app_service_plan_size
    capacity = var.capacity
  }
}

resource "azurerm_app_service" "web_app_service" {
  name                = "${var.app_name}-App-Service"
  location            = var.region
  resource_group_name = var.resource_group
  app_service_plan_id = azurerm_app_service_plan.web_app_service_plan.id
  https_only          = var.app_service_https_only
  site_config {
    python_version    = var.app_service_python_version
    scm_type          = "None"
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    environment = var.tag_environment
    "business unit" = var.tag_business_unit
  }
}