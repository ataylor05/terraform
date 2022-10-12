output "ipam_arn" {
  value       = aws_vpc_ipam.ipam.arn
  description = "Amazon Resource Name (ARN) of IPAM"
}

output "ipam_id" {
  value       = aws_vpc_ipam.ipam.id
  description = "The ID of the IPAM"
}

output "ipam_private_default_scope_id" {
  value       = aws_vpc_ipam.ipam.private_default_scope_id
  description = "The ID of the IPAM's private scope"
}

output "ipam_public_default_scope_id" {
  value       = aws_vpc_ipam.ipam.public_default_scope_id
  description = "The ID of the IPAM's public scope."
}

output "scope_count" {
  value       = aws_vpc_ipam.ipam.scope_count
  description = "The number of scopes in the IPAM"
}

output "ipam_pool_id" {
  value       = aws_vpc_ipam_pool.ipam_pool.id
  description = "The ID of the IPAM pool"
}

output "ipam_pool_arn" {
  value       = aws_vpc_ipam_pool.ipam_pool.arn
  description = "The ARN of the IPAM pool"
}

output "ipam_pool_cidr_id" {
  value       = aws_vpc_ipam_pool_cidr.ipam_pool_cidr.id
  description = "The ID of the IPAM Pool Cidr concatenated with the IPAM Pool ID."
}
