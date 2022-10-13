resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnets" {
  for_each                = var.subnets.public
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
  tags = {
    Name = "${var.vpc_name}-subnet-${each.key}"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "private_subnets" {
  for_each                = var.subnets.private
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
  tags = {
    Name = "${var.vpc_name}-subnet-${each.key}"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "igw" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.enable_nat_gateway ? 1 : 0
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnets[var.nat_gw_subnet].id

  tags = {
    Name = "${var.vpc_name}-NATGW"
  }
}

resource "aws_route_table" "route_tables" {
  for_each = toset(var.route_tables)
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-${each.key}-rt"
  }
}

resource "aws_route" "aws_route_igw" {
  route_table_id         = aws_route_table.route_tables["public"].id
  for_each               = var.enable_internet_gateway ? local.routes.igw : {}
  destination_cidr_block = each.key
  gateway_id             = each.value[0]
}

resource "aws_route" "aws_route_nat_gw" {
  route_table_id         = aws_route_table.route_tables["private"].id
  for_each               = var.enable_nat_gateway ? local.routes.nat_gw : {}
  destination_cidr_block = each.key
  gateway_id             = each.value[0]
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_tables["public"].id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_tables["private"].id
}

resource "aws_network_acl_rule" "default_nacl_rules" {
  for_each       = var.nacl_rules
  network_acl_id = aws_vpc.vpc.default_network_acl_id
  rule_number    = each.value["rule_number"]
  egress         = each.value["egress"]
  protocol       = each.value["protocol"]
  rule_action    = each.value["rule_action"]
  cidr_block     = each.value["cidr_block"]
  from_port      = each.value["from_port"]
  to_port        = each.value["to_port"]
}

resource "null_resource" "remove_default_nacl_rule" {
  depends_on = [aws_vpc.vpc]
  provisioner "local-exec" {
    command = "aws ec2 delete-network-acl-entry --network-acl-id ${aws_vpc.vpc.default_network_acl_id} --ingress --rule-number 100"
  }
}

resource "aws_customer_gateway" "customer_gateway" {
  count       = var.enable_p2p_vpn ? 1 : 0
  device_name = var.customer_vpn_device_name
  ip_address  = var.customer_vpn_gateway_ip
  bgp_asn     = var.customer_vpn_gateway_bgp_asn
  type        = "ipsec.1"

  tags = {
    Name = "${var.customer_vpn_device_name}-CGW"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  count  = var.enable_p2p_vpn ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.customer_vpn_device_name}-VPN-GW"
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  count                                = var.enable_p2p_vpn ? 1 : 0
  vpn_gateway_id                       = aws_vpn_gateway.vpn_gw[0].id
  customer_gateway_id                  = aws_customer_gateway.customer_gateway[0].id
  type                                 = "ipsec.1"
  static_routes_only                   = true
  tunnel1_ike_versions                 = var.ike_versions
  tunnel2_ike_versions                 = var.ike_versions
  tunnel1_preshared_key                = var.tunnel1_psk
  tunnel2_preshared_key                = var.tunnel2_psk
  tunnel1_phase1_encryption_algorithms = var.phase1_encryption_algorithms
  tunnel2_phase1_encryption_algorithms = var.phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.phase1_integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = var.phase1_integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = var.phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.phase1_dh_group_numbers
  tunnel1_phase1_lifetime_seconds      = var.phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = var.phase1_lifetime_seconds
  tunnel1_phase2_encryption_algorithms = var.phase2_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.phase2_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.phase2_integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = var.phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.phase2_dh_group_numbers
  tunnel1_phase2_lifetime_seconds      = var.phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = var.phase2_lifetime_seconds
}