# General
variable "region" {}

variable "vpc_id" {}

variable "launch_template_name" {}

variable "auto_scaling_group_name" {}

variable "ec2_instance_profile" {}


# Load Balancing 

variable "aws_elb_root_ids" {
  type = "map"
  default = {
    "us-east-1" = "127311923021"
    "us-east-2" = "033677994240"
    "us-west-1" = "027434742980"
    "us-west-2" = "797873946194"
  }
}

variable "alb_subets" {type = "list"}

variable "internal_alb" {}

variable "alb_name" {}

variable "target_group_name" {}


# Auto Scaling
variable "auto_scaling_subets" {}

variable "autoscaling_instance_type" {}

variable "image_id" {}

variable "ec2_instance_names" {}

variable "autoscaling_assign_public_ip" {}

variable "autoscaling_ec2_keypair" {}

variable "ebs_optimized" {}

variable "detailed_monitoring_enabled" {}

variable "autoscaling_ec2_root_volume_size" {}

variable "autoscaling_group_min_size" {}

variable "autoscaling_group_max_size" {}

variable "autoscaling_termination_policy" {}

variable "autoscaling_cpu_scale_up_threshold" {}

variable "autoscaling_cpu_scale_down_threshold" {}