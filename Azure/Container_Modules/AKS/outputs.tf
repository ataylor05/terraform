output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.k8s.id
}

output "aks_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.k8s.fqdn
}

output "aks_node_resource_group" {
  value = azurerm_kubernetes_cluster.k8s.node_resource_group
}

output "aks_identity_principal_id" {
  value = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}

output "aks_kube_admin_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_admin_config
  sensitive = true
}

output "aks_kube_admin_config_raw" {
  value = var.kubeconfig_raw_output ? azurerm_kubernetes_cluster.k8s.kube_admin_config_raw : null
  sensitive = true
}

output "aks_kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config
  sensitive = true
}

output "aks_kube_config_raw" {
  value = var.kubeconfig_raw_output ? azurerm_kubernetes_cluster.k8s.kube_config_raw : null
  sensitive = true
}
