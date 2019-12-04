variable "vpc_id" {
    type = "string"
}

variable "launch_template_name" {
    type = "string"
}

variable "auto_scaling_group_name" {
    type = "string"
}

variable "ebs_volume_size" {
    type = "string"
}

variable "ebs_optimized" {
    type = "string"
}

variable "iam_instance_profile" {
    type = "string"
}

variable "image_id" {
    type = "string"
}

variable "instance_type" {
    type = "string"
}

variable "key_name" {
    type = "string"
}

variable "autoscaling_cpu_scale_up_threshold" {
    type = "string"
}

variable "autoscaling_cpu_scale_down_threshold" {
    type = "string"
}

variable "detailed_monitoring" {
    type = "string"
}

variable "associate_public_ip_address" {
    type = "string"
}

variable "ec2_instance_names" {
    type = "string"
}

variable "subnets" {
}

variable "min_size" {
    type = "string"
}

variable "max_size" {
    type = "string"
}

variable "elb_name" {
    type = "string"
}

variable "internal_elb" {
    type = "string"
}