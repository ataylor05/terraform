# terraform-aws-security-group
This is a Terraform module which creates a AWS security group with or without rule polices.<br>
[AWS Security Group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)<br>
[Terraform AWS Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)<br>
[Terraform AWS Security Group Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)<br>

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "security-group" {
  source = "github.com/ataylor05/terraform-aws-security-group"
  ...
```
<br>

<b>Tagged release</b><br>

```
module "security-group" {
  source = "github.com/ataylor05/terraform-aws-security-group?ref=1.0.0"
  ...
```
<br>

## Example of using this module
This is an example of using this module to create a security group with policies from CIDR blocks.  NOTE THAT YOU CAN'T USE BOTH <b>cidr_block</b> AND <b>source_security_group_id</b>.<br>

```
module "security-group" {
  source                     = "github.com/ataylor05/terraform-aws-security-group?ref=1.0.0"
  security_group_name        = "Example-HTTP-SG"
  security_group_description = "An example security group allowing port 80."
  vpc_id                     = module.vpc.vpc_id
  tags                       = local.tags
  security_group_rules       = {
    rule-1 = {
      type                     = "ingress"
      to_port                  = 80
      from_port                = 80
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
    }
  }
}
```

This is an example of using this module to create a security group with policies from another security group.

```
module "security-group" {
  source                     = "github.com/ataylor05/terraform-aws-security-group?ref=1.0.0"
  security_group_name        = "Example-HTTP-SG"
  security_group_description = "An example security group allowing port 80."
  vpc_id                     = module.vpc.vpc_id
  tags                       = local.tags
  security_group_rules       = {
    rule-1 = {
      type                     = "ingress"
      to_port                  = 80
      from_port                = 80
      protocol                 = "tcp"
      cidr_blocks              = null
      source_security_group_id = "sg-02ce123456e7893c7"
    }
  }
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-security-group.git
cd terraform-aws-security-group

cat <<EOF > security-group.auto.tfvars
security_group_name        = "Example-HTTP-SG"
security_group_description = "An example security group allowing port 80."
vpc_id                     = module.vpc.vpc_id
tags                       = local.tags
security_group_rules       = {
rule-1 = {
    type                     = "ingress"
    to_port                  = 80
    from_port                = 80
    protocol                 = "tcp"
    cidr_blocks              = null
    source_security_group_id = "sg-02ce123456e7893c7"
}
EOF

terraform init
terraform apply
```