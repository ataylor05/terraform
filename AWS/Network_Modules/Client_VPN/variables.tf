variable "client_vpn_name" {
  type        = string
}

variable "client_cidr_block" {
  type        = string
}

variable "split_tunnel" {
  type        = bool
}

variable "vpn_subnets" {
  type        = list
}

variable "enable_ad_authentication" {
  type        = bool
}

variable "directory_id" {
  type        = string
}

variable "enable_ssl_authentication" {
  type        = bool
}

variable "asm_server_cert" {
  type        = string
}

variable "asm_client1_cert" {
  type        = string
}