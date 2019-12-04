variable "transit_gateway_name" {
  type        = string
}

variable "vpc_1" {
  type        = string
}

variable "vpc_1_attachment_name" {
  type        = string
}

variable "vpc_1_cidr" {
  type        = string
}

variable "vpc_1_subnets" {
  type        = list
}

variable "vpc_1_public_route_table" {
  type        = string
}

variable "vpc_1_private_route_table" {
  type        = string
}

variable "vpc_2" {
  type        = string
}

variable "vpc_2_attachment_name" {
  type        = string
}

variable "vpc_2_cidr" {
  type        = string
}

variable "vpc_2_subnets" {
  type        = list
}

variable "vpc_2_public_route_table" {
  type        = string
}

variable "vpc_2_private_route_table" {
  type        = string
}