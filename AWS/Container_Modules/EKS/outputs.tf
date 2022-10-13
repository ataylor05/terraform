output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_identity" {
  value = aws_eks_cluster.eks.identity
}