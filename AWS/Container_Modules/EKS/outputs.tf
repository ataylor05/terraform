output "eks_control_plane_log_group_arn" {
  value = var.enable_eks_control_plane_logging ? aws_cloudwatch_log_group.eks_control_plane_log_group[0].arn : null
}

output "eks_control_plane_log_group_name" {
  value = var.enable_eks_control_plane_logging ? aws_cloudwatch_log_group.eks_control_plane_log_group[0].name : null
}

output "eks_secrets_key_id" {
  value = var.enable_eks_secrets_kms_key ? aws_kms_key.eks_secrets_key[0].id : null
}

output "eks_secrets_key_arn" {
  value = var.enable_eks_secrets_kms_key ? aws_kms_key.eks_secrets_key[0].arn : null
}

output "eks_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_arn" {
  value = aws_eks_cluster.eks.arn
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_platform_version" {
  value = aws_eks_cluster.eks.platform_version
}

output "eks_cluster_security_group_id" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "eks_node_group_id" {
  value = aws_eks_node_group.eks_node_group.id
}

output "eks_node_group_arn" {
  value = aws_eks_node_group.eks_node_group.arn
}

output "aws-auth_data_id" {
  value = kubernetes_config_map_v1_data.aws-auth.id
}