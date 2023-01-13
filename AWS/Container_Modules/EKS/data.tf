data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks.name
}

data "aws_iam_role" "eks_cluster_iam_role" {
  name = var.eks_cluster_role_name
}

data "aws_iam_role" "eks_worker_iam_role" {
  name = var.eks_worker_role_name
}

data "aws_subnets" "eks_control_plane_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = var.control_plane_subnet_tier
  }
}

data "aws_subnets" "eks_node_group_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = var.node_group_subnet_tier
  }
}