variable "region" {
}

variable "resource_prefix" {
  default = "Dev"
  type    = "string"
}

variable "vpc" {
}

variable "subnets" {
}

variable "eks_ami" {
  type = "map"   # https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
  default = {
    "us-east-1" = "ami-0d3998d69ebe9b214"
    "us-east-2" = "ami-027683840ad78d833"
    "us-west-2" = "ami-00b95829322267382"
  }
}

variable "eks_public_access" {
}

variable "eks_private_access" {
}