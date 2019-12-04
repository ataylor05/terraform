data "azurerm_subnet" "k8s_subnet" {
  name                 = var.cluster_subnet
  virtual_network_name = var.subnet_vnet_name
  resource_group_name  = var.resource_group
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
    name                = "${var.log_analytics_name_prefix}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = var.resource_group
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "analytics_solution" {
    solution_name         = "ALMContainerInsights"
    location              = azurerm_log_analytics_workspace.log_analytics_workspace.location
    resource_group_name   = var.resource_group
    workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
    workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = var.region
    resource_group_name = var.resource_group
    dns_prefix          = var.cluster_dns_prefix

    linux_profile {
        admin_username = var.node_admin_username

        ssh_key {
            key_data = var.node_admin_ssh_pub_key
        }
    }

    network_profile {
        network_plugin     = var.aks_network_plugin
        pod_cidr           = var.aks_pod_cidr
        docker_bridge_cidr = var.aks_docker_bridge_cidr
        service_cidr       = var.aks_service_cidr
        dns_service_ip     = var.aks_dns_service_ip
    }

    agent_pool_profile {
        name            = "agentpool"
        count           = var.cluster_node_count
        vm_size         = var.cluster_node_vm_size
        os_type         = "Linux"
        os_disk_size_gb = var.cluster_node_vm_disk_size
        vnet_subnet_id  = data.azurerm_subnet.k8s_subnet.id
    }

    service_principal {
        client_id     = var.service_principal_id
        client_secret = var.service_principal_secret
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
        }
    }

    tags = {
        Environment = var.service_principal_id
    }
}

resource "azurerm_container_registry" "acr" {
  name                     = var.container_registry_name
  resource_group_name      = var.resource_group
  location                 = var.region
  sku                      = var.container_registry_sku
  admin_enabled            = var.container_registry_admin_enabled
}