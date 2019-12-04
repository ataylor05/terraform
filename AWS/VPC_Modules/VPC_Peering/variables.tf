variable "source_vpc" {
  description = "Source VPC for connection."
  type        = string
}

variable "target_vpc" {
  description = "Target VPC for connection."
  type        = string
}

variable "target_vpc_account" {
  description = "Target AWS account for VPC peering connection."
  type        = string
}

variable "target_vpc_region" {
  description = "Target AWS region for VPC perring connection."
  type        = string
}

variable "auto_accept" {
  description = "Auto accept the peering connection request."
  type        = bool
}

variable "configure_target_vpc_routes" {
  description = "Configure target VPC's route tables to use peering connection."
  type        = bool
}

variable "source_vpc_route_tables" {
  description = "List of route tables to add a peering route to."
  type        = list
}

variable "target_vpc_route_tables" {
  description = "List of route tables to add a peering route to."
  type        = list
}

variable "source_vpc_cidr" {
  description = "Source VPC CIDR for route tables."
  type        = string
}

variable "target_vpc_cidr" {
  description = "Target VPC CIDR for route tables."
  type        = string
}