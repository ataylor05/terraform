# terraform-aws-iam
This is a Terraform module which creates AWS IAM resources such as users, groups, roles, and policies.<br>
[AWS IAM](https://aws.amazon.com/iam/)<br>
[Terraform AWS IAM User](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)<br>
[Terraform AWS IAM Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group)<br>
[Terraform AWS IAM Roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)<br>
[Terraform AWS IAM Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)<br>

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "iam" {
  source = "github.com/ataylor05/terraform-aws-iam"
  ...
```
<br>

<b>Tagged release</b><br>

```
module "iam" {
  source = "github.com/ataylor05/terraform-aws-iam?ref=1.0.0"
  ...
```
<br>

## Examples of using this module
This is an example of using this module to create users, groups, and roles.<br>

```
module "groups" {
  source     = "github.com/ataylor05/terraform-aws-iam?ref=1.0.0"
  iam_groups = ["admins", "power-users", "read-only"]
}

module "users" {
  source     = "github.com/ataylor05/terraform-aws-iam?ref=1.0.0"
  iam_users = ["user1", "user2", "user3"]
}

module "roles" {
  source       = "github.com/ataylor05/terraform-aws-iam?ref=1.0.0"
  iam_roles    = {
    ConfigRole = {
        description        = "A role for the AWS Config service."
        path               = "/"
        assume_role_policy = {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "config.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
                }
            ]
        }
        managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"]
    }
  }
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-iam.git
cd terraform-aws-iam

cat <<EOF > iam.auto.tfvars
policy_attachment        = true
policy_attachment_groups = ["admins"]
policy_arn               = "arn:aws:iam::aws:policy/AdministratorAccess"
EOF

terraform init
terraform apply
```