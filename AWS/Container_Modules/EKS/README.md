# terraform-aws-eks
This is a Terraform module to deploy an AWS Elastic Kubernetes Service (EKS).

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "eks" {
  source = "github.com/ataylor05/terraform-aws-eks"
  ...
}
```
<br><br>
<b>Tagged release</b><br>
```
module "eks" {
  source = "github.com/ataylor05/terraform-aws-eks?ref=1.0.0"
  ...
}
```

## Example of using this module
This is an example of using this module to create a hub and spoke architecture.<br>

```
module "eks" {
    source                  = "github.com/ataylor05/terraform-aws-vpc?ref=1.0.2"
    vpc_id                                      = "vpc-0d2a61a549c358af4"
    control_plane_subnet_tier                   = "public"
    node_group_subnet_tier                      = "public"
    eks_cluster_role_name                       = "eks-cluster-example"
    eks_worker_role_name                        = "eks-node-group-example"
    enable_security_groups_for_pods             = true
    cluster_name                                = "example"
    enable_private_access                       = true
    enable_public_access                        = true
    enable_eks_secrets_kms_key                  = false
    kms_key_deletion_window_in_days             = 7
    enable_eks_control_plane_logging            = false
    eks_control_plane_logging_retention_in_days = 7
    cluster_log_types                           = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    admin_users                                 = ["allan", "terraform"]
    eks_nodes_disk_size                         = 512
    eks_nodes_instance_size                     = "t3.medium"
    worker_pool_desired_size                    = 1
    worker_pool_min_size                        = 1
    worker_pool_max_size                        = 1
}
```





<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-vpc.git
cd terraform-aws-vpc
terraform init
terraform apply -var-file="tests/hub-tgw.tfvars"
```