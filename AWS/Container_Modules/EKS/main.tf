resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller_policy_attachment" {
  count      = var.enable_security_groups_for_pods ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = var.eks_cluster_role_name
}

resource "aws_cloudwatch_log_group" "eks_control_plane_log_group" {
  count             = var.enable_eks_control_plane_logging ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.eks_control_plane_logging_retention_in_days
}

resource "aws_kms_key" "eks_secrets_key" {
  count                   = var.enable_eks_secrets_kms_key ? 1 : 0
  description             = "Provides envelope encryption of Kubernetes secrets stored in etcd for your cluster. This encryption is in addition to the EBS volume encryption that is enabled by default for all data (including secrets) that is stored in etcd as part of an EKS cluster."
  deletion_window_in_days = var.kms_key_deletion_window_in_days
}

resource "aws_eks_cluster" "eks" {
  name                      = var.cluster_name
  role_arn                  = data.aws_iam_role.eks_cluster_iam_role.arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    subnet_ids              = data.aws_subnets.eks_control_plane_subnets.ids
    endpoint_private_access = var.enable_private_access
    endpoint_public_access  = var.enable_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  dynamic "encryption_config" { 
    for_each = aws_kms_key.eks_secrets_key
    content {
      provider {
        key_arn = aws_kms_key.eks_secrets_key[0].arn
      }
      resources = ["secrets"]
    }
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name         = aws_eks_cluster.eks.name
  node_group_name      = "${var.cluster_name}-nodegroup"
  node_role_arn        = data.aws_iam_role.eks_worker_iam_role.arn
  subnet_ids           = data.aws_subnets.eks_node_group_subnets.ids
  disk_size            = var.eks_nodes_disk_size
  instance_types       = [var.eks_nodes_instance_size]
  capacity_type        = "ON_DEMAND"

  scaling_config {
    desired_size = var.worker_pool_desired_size
    min_size     = var.worker_pool_min_size
    max_size     = var.worker_pool_max_size
  }

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks.name}" = "owned"
  }
}

resource "kubernetes_config_map_v1_data" "aws-auth" {
  depends_on = [aws_eks_node_group.eks_node_group]
  data = {
    "mapUsers" = <<EOT
%{ for user in var.admin_users }
- userarn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}
  username: ${user}
  groups:
    - system:masters
%{ endfor }
EOT
  }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}