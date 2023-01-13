# terraform-aws-ecr
This is a Terraform module which creates an AWS Elastic Container Registry (ECR).<br>
[AWS ECR](https://aws.amazon.com/ecr/)<br>
[Terraform AWS ECR](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)<br>

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "ecr" {
  source = "github.com/ataylor05/terraform-aws-ecr"
  ...
```
<br>

<b>Tagged release</b><br>

```
module "ecr" {
  source = "github.com/ataylor05/terraform-aws-ecr?ref=1.0.0"
  ...
```
<br>

## Examples of using this module
This is an example of using this module.<br>

```
module "ecr" {
  source               = "github.com/ataylor05/terraform-aws-ecr?ref=1.0.0"
  name                 = "example"
  image_tag_mutability = "MUTABLE"
  ecr_scan_on_push     = true
  force_delete         = false
  tags                 = {
    tag = "value"
  }
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-ecr.git
cd terraform-aws-ecr

cat <<EOF > ecr.auto.tfvars
name                 = "example"
image_tag_mutability = "MUTABLE"
ecr_scan_on_push     = true
force_delete         = false
tags                 = {
  tag = "value"
}
EOF

terraform init
terraform apply
```