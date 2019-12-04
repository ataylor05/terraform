terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_security_group" "interface_endpoint" {
  name          = "Interface-Endpoint"
  description   = "Allows access to VPC Interface Endpoint."
  vpc_id        = var.target_vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "codebuild_endpoint" {
  count                = var.enable_codebuild_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.codebuild"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "codecommit_endpoint" {
  count                = var.enable_codecommit_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.codecommit"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  count             = var.enable_dynamodb_endpoint == true ? 1 : 0
  vpc_id            = var.target_vpc
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids   = [var.target_route_table]
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  count                = var.enable_ec2_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.ec2"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "events_endpoint" {
  count                = var.enable_events_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.events"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "git_codecommit_endpoint" {
  count                = var.enable_git-codecommit_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.git-codecommit"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  count                = var.enable_logs_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.logs"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "monitoring_endpoint" {
  count                = var.enable_monitoring_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.monitoring"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "secretsmanager_endpoint" {
  count                = var.enable_secretsmanager_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.secretsmanager"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "sns_endpoint" {
  count                = var.enable_sns_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.sns"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "sns_endpoint" {
  count                = var.enable_sns_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.sns"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}

resource "aws_vpc_endpoint" "sqs_endpoint" {
  count             = var.enable_s3_endpoint == true ? 1 : 0
  vpc_id            = var.target_vpc
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [var.target_route_table]
}

resource "aws_vpc_endpoint" "ssm_endpoint" {
  count                = var.enable_ssm_endpoint == true ? 1 : 0
  vpc_id               = var.target_vpc
  vpc_endpoint_type    = "Interface"
  service_name         = "com.amazonaws.${var.region}.ssm"
  subnet_ids           = var.target_subnets
  security_group_ids   = [aws_security_group.interface_endpoint.id]
  private_dns_enabled  = true
}