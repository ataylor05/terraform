terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = var.vpc_tenancy
  tags = {
    Name          = var.vpc_tag_name
    "Cost Center" = var.vpc_tag_cost_center
    Environment   = var.vpc_tag_environment
  }
}

 resource "aws_cloudwatch_log_group" "vpc_flow_logs_group" {
   count             = var.enable_vpc_flow_logs == true ? 1 : 0
   name              = "${var.vpc_tag_name}-Flow-Logs"
   retention_in_days = var.vpc_flow_logs_retention_in_days
}

resource "aws_flow_log" "vpc_flow_logs" {
  count           = var.enable_vpc_flow_logs == true ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs_group[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  count = var.enable_vpc_flow_logs == true ? 1 : 0
  name = "VPC-Flow-Logs-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  count  = var.enable_vpc_flow_logs == true ? 1 : 0
  name   = "VPC-Flow-Logs-Policy"
  role   = aws_iam_role.vpc_flow_logs_role[0].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = join("", ["Public-Subnet-", var.subnet_name_suffix[count.index]])
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = join("", ["Private-Subnet-", var.subnet_name_suffix[count.index]])
  }
}

resource "aws_subnet" "data_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.data_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = join("", ["Data-Subnet-", var.subnet_name_suffix[count.index]])
  }
}

resource "aws_subnet" "mgmt_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.mgmt_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = join("", ["MGMT-Subnet-", var.subnet_name_suffix[count.index]])
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "INET-GW"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_internet_gateway.internet_gateway]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.mgmt_subnets[0].id
  tags = {
    Name = "NAT-GW"
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_routes" {
  count          = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "data_routes" {
  count          = 2
  subnet_id      = aws_subnet.data_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "mgmt_routes" {
  count          = 2
  subnet_id      = aws_subnet.mgmt_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}