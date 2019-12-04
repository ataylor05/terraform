variable "vpc_cidr" {
  description = "The IPv4 CIDR block"
  default     = "192.168.0.0/16"
  type        = string
}

variable "vpc_tenancy" {
  description = "The allowed tenancy of instances launched into the VPC."
  default     = "default"
  type        = string
}

variable "vpc_tag_name" {
  description = "The name applied to the VPC."
  default     = "VPC"
  type        = string 
}

variable "vpc_tag_cost_center" {
  description = "The value for the Cost Center tag."
  default     = "none"
  type        = string 
}

variable "vpc_tag_environment" {
  description = "The value for the Environment tag."
  default     = "none"
  type        = string 
}

variable "enable_vpc_flow_logs" {
  description = "Enables VPC flow logs."
  default     = true
  type        = bool
}

variable "vpc_flow_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  default     = 1
  type        = number
}

variable "availability_zones" {
  description = "The Availability Zone of the subnet."
  type        = list
}

variable "subnet_name_suffix" {
  default     = ["1", "2", "3"]
  type        = list
}

variable "public_subnets" {
  description = "Subnets attached to the public route table."
  type        = list
}

variable "private_subnets" {
  description = "Subnets attached to the private route table."
  type        = list
}

variable "data_subnets" {
  description = "Database subnets attached to the private route table."
  type        = list
}

variable "mgmt_subnets" {
  description = "Management subnets attached to the public route table."
  type        = list
}