output "tg_id" {
  value = aws_ec2_transit_gateway.vpc_transit_gateway.id
}

output "tg_asn" {
  value = aws_ec2_transit_gateway.vpc_transit_gateway.amazon_side_asn
}

output "tg_arn" {
  value = aws_ec2_transit_gateway.vpc_transit_gateway.arn
}

output "tg_default_route_table_id" {
  value = aws_ec2_transit_gateway.vpc_transit_gateway.association_default_route_table_id
}

output "tg_vpc_1_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.vpc1_tg_attachment.id
}

output "tg_vpc_2_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.vpc2_tg_attachment.id
}