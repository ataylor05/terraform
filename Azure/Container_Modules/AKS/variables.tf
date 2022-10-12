variable "environment_tag" {
  type        = string
  description = "The environment name for tagging."
}

variable "aks_subnet_name" {
  type        = string
  description = "The name of the subnet to deploy AKS onto."
}

variable "aks_vnet_name" {
  type        = string
  description = "The name of the vnet to deploy AKS onto."
}

variable "aks_cluster_name" {
  type        = string
  description = "The name for the AKS cluster."
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix specified when creating the managed cluster."
}

variable "region" {
  type        = string
  description = "The Azure region to deploy to."
}

variable "aks_resource_group" {
  type        = string
  description = "The Azure resource group the AKS cluster belongs to."
}

variable "network_resource_group" {
  type        = string
  description = "The Azure resource group the AKS node pool NIC's belongs to."
}

variable "node_admin_username" {
  type        = string
  description = "The SSH username for AKS node access."
}

variable "node_admin_ssh_pub_key" {
  type        = string
  description = "The public key for the SSH user."
}

variable "cluster_node_vm_size" {
  type        = string
  description = "The size of the VM's being used for nodes."
}

variable "aks_version" {
  type        = string
  description = "The version of AKS to deploy."
  default     = null
}

variable "cluster_node_vm_disk_size" {
  type        = number
  description = "The disk size on the AKS nodes."
  default     = 1024
}

variable "node_count" {
  type        = number
  description = "The number of nodes in the default node pool."
  default     = 3
}

variable "node_availability_zones" {
  type        = list(any)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = ["1", "2", "3"]
}

variable "k8s_rbac_enabled" {
  type        = bool
  description = "Determines if Kubernetes RBAC controls are enabled on cluster."
  default     = true
}

variable "azure_ad_rbac_enabled" {
  type        = bool
  description = "Determines if Azure AD RBAC controls are enabled on cluster."
  default     = false
}

variable "aad_admin_group" {
  type        = list(any)
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
  default     = null
}

variable "network_policy" {
  type        = string
  description = "Sets up network policy to be used with Azure CNI. Currently supported values are calico and azure."
  default     = "azure"
}

variable "network_plugin" {
  type        = string
  description = "The cluster network plugin.  Could be azure or kubenet."
  default     = "azure"
}

variable "local_account_disabled" {
  type        = bool
  description = "If true nodes local accounts will be disabled."
  default     = false
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
  default     = "Free"
}

variable "azure_policy" {
  type        = bool
  description = "Enables the Azure Policy for Kubernetes Add On."
  default     = false
}

variable "cluster_auto_scaling_enabled" {
  type        = bool
  description = "Determines if AKS node pool Auto Scaling is enabled."
  default     = false
}

variable "cluster_auto_scaling_min_nodes" {
  type        = number
  description = "The minimum number of nodes of an auto scaling pool."
  default     = null
}

variable "cluster_auto_scaling_max_nodes" {
  type        = number
  description = "The max number of nodes auto scaling can scale up to."
  default     = null
}

variable "maintenance_window_day" {
  type        = string
  description = "A day in a week. Possible values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday and Saturday."
  default     = "Saturday"
}

variable "maintenance_window_time_frame" {
  type        = list(any)
  description = "An array of hour slots in a day. Possible values are between 0 and 23."
  default     = [1, 2, 3]
}

variable "allowed_ips_to_api" {
  type        = list(any)
  description = "A list of public IPs in CIDR format that should be allowed to the AKS API interface."
  default     = null
}

variable "http_application_routing" {
  type        = bool
  description = "Enables Azure Ingress HTTP routing on the cluster."
  default     = false
}

variable "automatic_channel_upgrade" {
  type        = string
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image, and stable."
  default     = null
}

variable "kubeconfig_raw_output" {
  type        = bool
  description = "Used for testing."
  default     = false
}

variable "managed_identities" {
  type        = list(string)
  description = "A list of names for User Defined Managed Identities placed in the node resourse group. Defaults to null."
  default     = []
}

variable "max_pods" {
  type        = number
  description = "The max number of pods per host"
  default     = 50
}

variable "service_cidr" {
  type        = string
  description = "The CIDR block used in the AKS service."
  default     = "172.16.0.0/16"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "The CIDR block used in the Docker network bridge."
  default     = "172.17.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "The IP used for the cluster DNS service."
  default     = "172.16.255.254"
}
