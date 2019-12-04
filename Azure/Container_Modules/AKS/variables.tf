variable "cluster_name" {}

variable "cluster_subnet" {}

variable "subnet_vnet_name" {}

variable "resource_group" {}

variable "region" {}

variable "node_admin_username" {}

variable "node_admin_ssh_pub_key" {}

variable "cluster_dns_prefix" {}

variable "aks_network_plugin" {}

variable "aks_pod_cidr" {}

variable "aks_docker_bridge_cidr" {}

variable "aks_service_cidr" {}

variable "aks_dns_service_ip" {}

variable "cluster_node_count" {}

variable "cluster_node_vm_size" {}

variable "cluster_node_vm_disk_size" {}

variable "service_principal_id" {}

variable "service_principal_secret" {}

variable log_analytics_workspace_location {}

variable log_analytics_workspace_sku {}

variable tag_environment {}

variable tag_business_unit {}

variable container_registry_name {}

variable container_registry_sku {}

variable container_registry_admin_enabled {}