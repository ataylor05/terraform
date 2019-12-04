resource "aws_ec2_transit_gateway" "vpc_transit_gateway" {
  description                     = "VPC Transit Gateway"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags {
    Name        = "VPC Transit Gateway"
    CostCenter  = var.cost_center
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "transit_gateway_vpc_attachment" {
  subnet_ids         = [aws_subnet.example.id]
  transit_gateway_id = aws_ec2_transit_gateway.vpc_transit_gateway.id
  vpc_id             = aws_vpc.example.id
}