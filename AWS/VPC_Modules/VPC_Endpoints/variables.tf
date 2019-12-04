variable "region" {
  description = "Target endpoint region."
  type        = string
}

variable "target_vpc" {
  description = "Target VPC."
  type        = string
}

variable "target_route_table" {
  description = "Target VPC Route Table."
}

variable "target_subnets" {
  description = "Target VPC Subnet."
}


variable "enable_codebuild_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_codecommit_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_dynamodb_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_ec2_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_events_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_git-codecommit_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_logs_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_monitoring_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_s3_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_secretsmanager_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_sns_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_sqs_endpoint" {
  description = "Target VPC."
  type        = bool
}

variable "enable_ssm_endpoint" {
  description = "Target VPC."
  type        = bool
}