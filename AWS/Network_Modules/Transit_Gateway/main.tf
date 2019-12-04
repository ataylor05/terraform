resource "aws_ec2_transit_gateway" "vpc_transit_gateway" {
  description                     = "VPC Transit Gateway"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = {
    Name = var.transit_gateway_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_tg_attachment" {
  subnet_ids         = [var.vpc_1_subnets[0], var.vpc_1_subnets[1]]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_transit_gateway.id
  vpc_id             = var.vpc_1
  tags = {
    Name = var.vpc_1_attachment_name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_tg_attachment" {
  subnet_ids         = [var.vpc_2_subnets[0], var.vpc_2_subnets[1]]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_transit_gateway.id
  vpc_id             = var.vpc_2
  tags = {
    Name = var.vpc_2_attachment_name
  }
}

resource "aws_route" "vpc_1_public_route" {
  route_table_id            = var.vpc_1_public_route_table
  destination_cidr_block    = var.vpc_2_cidr
  transit_gateway_id        = aws_ec2_transit_gateway.vpc_transit_gateway.id
}

resource "aws_route" "vpc_1_private_route" {
  route_table_id            = var.vpc_1_private_route_table
  destination_cidr_block    = var.vpc_2_cidr
  transit_gateway_id        = aws_ec2_transit_gateway.vpc_transit_gateway.id
}

resource "aws_route" "vpc_2_public_route" {
  route_table_id            = var.vpc_2_public_route_table
  destination_cidr_block    = var.vpc_1_cidr
  transit_gateway_id        = aws_ec2_transit_gateway.vpc_transit_gateway.id
}

resource "aws_route" "vpc_2_private_route" {
  route_table_id            = var.vpc_2_private_route_table
  destination_cidr_block    = var.vpc_1_cidr
  transit_gateway_id        = aws_ec2_transit_gateway.vpc_transit_gateway.id
}