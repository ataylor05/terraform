variable "ami_name" {
  description = "AMI name search pattern."
  type        = string
}

variable "instance_type" {
  description = "EC2 isntance type."
  type        = string
}

variable "availability_zone" {
  description = "AZ for EC2."
  type        = string
}

variable "key_name" {
  description = "EC2 keypair for instance."
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to be applied to instance."
  type        = string
}

variable "ebs_optimized" {
  description = "Best performance for the Amazon EBS volumes."
  type        = bool
}

variable "disable_api_termination" {
  description = "Determines if termination should be disabled for instance."
  type        = bool
}

variable "detailed_monitoring" {
  description = "Data is available in 1-minute periods for an additional cost."
  type        = bool
}

variable "vpc_security_group_ids" {
  description = "EC2 Security Groups."
}

variable "subnet_id" {
  description = "Subnet to launch the instance into."
  type        = string
}

variable "root_ebs_size" {
  description = "Size in GB for root EBS volume."
  type        = string
}

variable "root_ebs_type" {
  description = "EBS volume type."
  type        = string
}

variable "root_ebs_delete_on_termination" {
  description = "Determines if EBS volume is deleted on instance termination."
  type        = string
}

variable "associate_public_ip_address" {
  description = "Apply public IP address to instance."
  type        = bool
}

variable "ec2_tag_name" {
  description = "Name for the EC2 instance."
  type        = string
}

variable "ec2_tag_cost_center" {
  description = "Tag to identify the Cost Center."
  type        = string
}

variable "ec2_tag_environment" {
  description = "Tag to identify the environment."
  type        = string
}

variable "ec2_tag_backups" {
  description = "Tag to identify if automated backups should be used."
  type        = string
}

variable "ec2_tag_patch_group" {
  description = "Tag to identify which patching group the instance belongs to."
  type        = string
}

variable "user_data" {
  description = "Userdata to pass as bootstrapping code."
}