variable "elb_name" {
  description = "Name for the load balancer."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones for load balancing."
}

variable "ec2_instances" {
  description = "EC2 instances to attach to load balancer."
}

variable "ssl_certificate" {
  description = "ACM SSL certificate."
}