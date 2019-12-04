output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "public_subnets" {
  value = [aws_subnet.public_subnets.*.id]
}

output "public_subnets_arns" {
  value = [aws_subnet.public_subnets.*.arn]
}

output "public_subnets_cidrs" {
  value = [aws_subnet.public_subnets.*.cidr_block]
}

output "private_subnets" {
  value = [aws_subnet.private_subnets.*.id]
}

output "private_subnets_arns" {
  value = [aws_subnet.private_subnets.*.arn]
}

output "private_subnets_cidrs" {
  value = [aws_subnet.private_subnets.*.cidr_block]
}

output "database_subnets" {
  value = [aws_subnet.data_subnets.*.id]
}

output "database_subnets_arns" {
  value = [aws_subnet.data_subnets.*.arn]
}

output "database_subnets_cidrs" {
  value = [aws_subnet.data_subnets.*.cidr_block]
}

output "management_subnets" {
  value = [aws_subnet.mgmt_subnets.*.id]
}

output "management_subnets_arns" {
  value = [aws_subnet.mgmt_subnets.*.arn]
}

output "management_subnets_cidrs" {
  value = [aws_subnet.mgmt_subnets.*.cidr_block]
}

output "vpc_flow_log_id" {
  value = aws_flow_log.vpc_flow_logs.*.id
}

output "vpc_flow_logs_group_arn" {
  value = aws_cloudwatch_log_group.vpc_flow_logs_group.*.arn
}

output "vpc_flow_logs_role_id" {
  value = aws_iam_role.vpc_flow_logs_role.*.id
}

output "vpc_flow_logs_role_arn" {
  value = aws_iam_role.vpc_flow_logs_role.*.arn
}