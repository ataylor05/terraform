resource "aws_cloudwatch_log_group" "client_vpn_log_group" {
  name              = "Client-VPN-Logs"
  retention_in_days = 30
}

resource "aws_ec2_client_vpn_endpoint" "vpc_ssl_client_vpn" {
  description            = var.client_vpn_name
  server_certificate_arn = var.asm_server_cert
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  transport_protocol     = "udp"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.asm_client1_cert
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn_log_group.name
  }
}

resource "aws_ec2_client_vpn_network_association" "mgmt_subnet_1_vpn_network_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpc_ssl_client_vpn.id
  subnet_id              = var.vpn_subnets[0]
}