variable "security_group_name" {
  type        = string
  description = "Name of the security group."
}

variable "security_group_description" {
  type        = string
  description = "Security group description. Defaults to Managed by Terraform."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "tags" {
  type        = map
  description = "Map of tags to assign to the resource."
  default     = null
}

variable "security_group_rules" {
  type        = map
  description = "Provides a security group rule resource."
  default     = {}
}