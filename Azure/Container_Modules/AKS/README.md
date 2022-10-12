# AKS Cluster
This module will deploy an Azure Kubernetes cluster resource.  [See this page](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) for more information on using this Terraform resource.  This module will deploy AKS along with the following optional features:<br>
* Auto Scaling
* Azure AD Integration
* K8S & Azure RBAC
* Additional managed identities created in AKS node pool resource group
* Create an ACL for Kubernetes API access
* Joined nodes to an AD domain (not yet implemented)
* Windows container support (not yet implemented)

<br>

| Variable | Required | Type | Description |
| --- | --- | --- | --- |
| aks_cluster_name | True | String | The name for the AKS cluster. |
| dns_prefix | True | String | DNS prefix specified when creating the managed cluster. |
| region | True | String | The Azure region to deploy to. |
| aks_resource_group | True | String | The Azure resource group the AKS cluster belongs to. |
| aks_vnet_name | True | String | The name of the vnet to deploy AKS onto. |
| aks_subnet_name | True | String | The name of the subnet to deploy AKS onto. |
| network_resource_group | True | String | The Azure resource group the AKS node pool NIC's belongs to. |
| cluster_node_vm_size | True | String | The size of the VM's being used for nodes. |
| node_admin_username | True | String | The SSH username for AKS node access. |
| node_admin_ssh_pub_key | True | String | The public key for the SSH user. |
| aks_version | False | String | he version of AKS to deploy.  If ommited the latest recommended is deployed. |
| cluster_node_vm_disk_size | False | Number | The disk size on the AKS nodes.  Defaults to 1024GB. |
| node_count | False | Number | The number of nodes in the default node pool.  Defaults to 3. |
| node_availability_zones | False | List | Availability Zones across which the Node Pool should be spread. Defaults to ["1", "2", "3"].|
| k8s_rbac_enabled | False | Boolean | Determines if Kubernetes RBAC controls are enabled on cluster. Defaults to true. |
| managed_identities | False | List | A list of names for User Defined Managed Identities placed in the node resourse group. Defaults to []. |
| azure_ad_rbac_enabled | False | Boolean | Determines if Azure AD RBAC controls are enabled on cluster. Defaults to false |
| aad_admin_group | False | List | A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster. Defaults to null. |
| network_policy | False | String | Sets up network policy to be used with Azure CNI. Currently supported values are calico and azure. Defaults to azure. |
| network_plugin | False | String | The cluster network plugin. Currently supported values are azure or kubenet. Defaults to azure. |
| local_account_disabled | False | Boolean | If true nodes local accounts will be disabled. Defaults to false. |
| sku_tier | False | String | The SKU tier used for cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free. |
| azure_policy | False | Boolean | Enables the Azure Policy for Kubernetes Add On. |
| cluster_auto_scaling_enabled | False | Boolean | Determines if AKS node pool Auto Scaling is enabled. Defaults to false. |
| cluster_auto_scaling_min_nodes | False | Number | The minimum number of nodes of an auto scaling pool. Defaults to null. |
| cluster_auto_scaling_max_nodes | False | Number | The max number of nodes auto scaling can scale up to. Defaults to null. |
| maintenance_window_day | False | String | Possible values are Sunday, Monday, Tuesday, Wednesday, Thursday, Friday and Saturday. Defaults to Saturday. |
| maintenance_window_time_frame | False | List | An array of hour slots in a day. Possible values are between 0 and 23. Defaults to [1,2,3]. |
| allowed_ips_to_api | False | List | A list of public IPs in CIDR format that should be allowed to the AKS API interface.  Defaults to null. |
| http_application_routing | False | Boolean | Enables Azure Ingress HTTP routing on the cluster. Defaults to false. |
| automatic_channel_upgrade | False | String | The upgrade channel for cluster. Possible values are patch, rapid, node-image, and stable. Defaults to null. |
| kubeconfig_raw_output | False | Boolean | Used for testing in Terratest. Defaults to false. |

## Azure AD Integration
To enable Azure AD Integration on the cluster set the following variable <b>azure_ad_rbac_enabled</b> to true.  When this is set to true, this additional variable should be set:<br>

| Variable | Description |
| --- | --- |
| aad_admin_group | A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster. |


## Auto Scaling
<b>Warning: [There are known issues with AAD Pod Identity and cluster Auto-Scaling](https://azure.github.io/aad-pod-identity/docs/known-issues/#nmi-pods-not-yet-running-during-a-cluster-autoscaling-event)</b>.  When the variable <b>cluster_auto_scaling_enabled</b> to true, these additional variables need to be set:<br>

| Variable | Description |
| --- | --- |
| node_count | The number of nodes in the default node pool. |
| cluster_auto_scaling_min_nodes | The minimum number of nodes of an auto scaling pool. |
| cluster_auto_scaling_max_nodes | The max number of nodes auto scaling can scale up to. |


# Using this module
This module is intended to be stored in Terraform Enterprise private registery and to used in Terraform Enterprise, but it can be used locally.<br><br>

Minimum number of vars:<br>

```
module "AKS" {
  source                         = "<TBD>"
  region                         = var.region
  environment_tag                = var.environment_tag
  aks_cluster_name               = var.aks_cluster_name
  resource_group                 = var.resource_group
  aks_subnet_name                = var.aks_subnet_name
  aks_vnet_name                  = var.aks_vnet_name
  dns_prefix                     = var.dns_prefix
  node_admin_username            = var.node_admin_username
  node_admin_ssh_pub_key         = var.node_admin_ssh_pub_key
  cluster_node_vm_size           = var.cluster_node_vm_size
}
```

Using this module locally:<br>

```
git clone <REPO_URL>
cd <REPO_URL>

terraform init
terraform apply \
  -var="environment_tag=Test" \
  -var="aks_subnet_name=WebContainer" \
  -var="aks_vnet_name=VNetTestAksEast" \
  -var="aks_version=1.21.2" \
  -var="aks_cluster_name=DtrEastTestTest" \
  -var="dns_prefix=dtr-east-test-test" \
  -var="region=eastus" \
  -var="resource_group=AksWebTestEast" \
  -var="network_resource_group=VnetTestAksEast" \
  -var="dns_prefix=dtr-east-test-test" \
  -var="node_admin_username=dtr" \
  -var="node_admin_ssh_pub_key=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/Ar742uGirB+ofXQdC8/28QucVYXGC4W69A7t0WVflXnGNTox7+7QzGL31sSzpa0pnbVIZ1lHFSYj8sE7EZJgS+eilv5/zV3WF1bTTvB9u/knQPnjXj5zP9Oqr7HSDZKNxEGB3DY2Z2oYD6CYsQ8jJx5NuVy2AUqdmp40gRf7h6Jc7ZaPXp2XLaYU1yjottBDsqiH/ECE7v9YcQOxG/2W6fCOXnFHFesxs9MVlCIS/ld+O72zYoQyaH7N9i1lpnPCTHiNdJ+qezFmmOmvaj3icAdbbnnlZJAbgPKvMrmgnZPiyW9VLN/6TiSDNZi/0tUsZj6tInyZN33dhS7cYjP1zkoqGqWewwViogryFMm4bDwOI4K6S+O/+taGFYmcl18LchPlUdQxrYVgvKvAjAe5vQVCJmw7hv6jqhPF2K8LOLRW7jdY4xPK+jji6OH7t/6BMqJ0cxZk4mkFLEB0uI7dWH22q4OlPJM0UqjDvtxfXir1tGXTZaJuQL7BxVou7UE=" \
  -var="cluster_node_vm_size=Standard_D4s_v3" \
  -var="kubeconfig_raw_output=true" \
  -var='managed_identities=[{name = "istio"}]'
```

## Testing this module
<b>Testing Pre-Reqs</b> These tests use the Terratest framework which is a Go lang libary.  A Go environment needs to be setup in advance with environment variables conatining paths to Go resources.  $GOROOT should be a path to the location where the Go binaries are.  $GOPATH should be a path to your Go workspace.  The Go workspace should contain the following folders - bin, pkg, and src.<br><br>

Run the following commands to test this module.
```
git clone https://<URL>
cd <REPONAME>/tests

go mod init test
go mod tidy

go test -v -timeout 60m
```
