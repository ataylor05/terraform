terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id        = var.source_vpc
  peer_vpc_id   = var.target_vpc
  #peer_owner_id = var.target_vpc_account
  #peer_region   = var.target_vpc_region
  auto_accept   = var.auto_accept
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "source_peering_route_1" {
  route_table_id            = var.source_vpc_route_tables[0]
  destination_cidr_block    = var.source_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  depends_on                = ["aws_vpc_peering_connection.peering_connection"]
}

resource "aws_route" "source_peering_route_2" {
  route_table_id            = var.source_vpc_route_tables[1]
  destination_cidr_block    = var.source_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  depends_on                = ["aws_vpc_peering_connection.peering_connection"]
}

resource "aws_route" "target_peering_route_1" {
  count                     = var.configure_target_vpc_routes == true ? 1 : 0
  route_table_id            = var.target_vpc_route_tables[0]
  destination_cidr_block    = var.target_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  depends_on                = ["aws_vpc_peering_connection.peering_connection"]
}

resource "aws_route" "target_peering_route_2" {
  count                     = var.configure_target_vpc_routes == true ? 1 : 0
  route_table_id            = var.target_vpc_route_tables[1]
  destination_cidr_block    = var.target_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
  depends_on                = ["aws_vpc_peering_connection.peering_connection"]
}