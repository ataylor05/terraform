locals {
  userdata = <<USERDATA
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
USERDATA
}

# --------------
# Security Groups
# --------------
resource "aws_security_group" "alb_sg" {
    name          = "Application-Load-Balancer-SG"
    description   = "Application Load Balancer Security Group"
    vpc_id        = var.vpc_id
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "web_sg" {
    name          = "Web-Servers-SG"
    description   = "Web Servers SG"
    vpc_id        = var.vpc_id
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group_rule" "web_sg_ingress_1" {
    type                     = "ingress"
    to_port                  = 80
    from_port                = 80
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_sg.id
    source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "web_sg_ingress_2" {
    type                     = "ingress"
    to_port                  = 443
    from_port                = 443
    protocol                 = "tcp"
    security_group_id        = aws_security_group.web_sg.id
    source_security_group_id = aws_security_group.alb_sg.id
}



# --------------
# Application Load Balancer
# --------------
resource "aws_lb" "alb" {
    name                             = var.alb_name
    internal                         = var.internal_alb
    load_balancer_type               = "application"
    security_groups                  = [aws_security_group.alb_sg.id]
    enable_cross_zone_load_balancing = "true"
    subnets                          = var.alb_subets
    enable_deletion_protection       = "false"
}

resource "aws_lb_target_group" "target_group" {
    name     = var.target_group_name
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    health_check {    
      healthy_threshold   = 2    
      unhealthy_threshold = 5    
      timeout             = 5    
      interval            = 10    
      path                = "/"    
      port                = 80  
    }
}

resource "aws_lb_listener" "alb_listener_80" {
    load_balancer_arn  = aws_lb.alb.arn
    port               = 80
    protocol           = "HTTP"
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.target_group.arn
    }
}



# --------------
# Auto Scaling
# --------------
resource "aws_launch_template" "auto_scaling_launch_template" {
  name = var.launch_template_name
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.autoscaling_ec2_root_volume_size
      volume_type = "gp2"
    }
  }
  ebs_optimized = var.ebs_optimized
  iam_instance_profile {
    name = var.ec2_instance_profile
  }
  image_id = var.image_id
  instance_type = var.autoscaling_instance_type
  key_name = var.autoscaling_ec2_keypair
  monitoring {
    enabled = var.detailed_monitoring_enabled
  }
  network_interfaces {
    associate_public_ip_address = var.autoscaling_assign_public_ip
    delete_on_termination = true
    security_groups = [aws_security_group.web_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.ec2_instance_names
    }
  }
  user_data = "${base64encode(local.userdata)}"
}

resource "aws_autoscaling_group" "auto_scaling_group" {
    name_prefix               = "Auto-Scaling-Group-"
    max_size                  = var.autoscaling_group_max_size
    min_size                  = var.autoscaling_group_min_size
    health_check_grace_period = 300
    health_check_type         = "ELB"
    force_delete              = true
    target_group_arns         =  [aws_lb_target_group.target_group.arn]
    termination_policies      = var.autoscaling_termination_policy
    vpc_zone_identifier       = var.auto_scaling_subets
    launch_template {
      id      = aws_launch_template.auto_scaling_launch_template.id
      version = "$Latest"
    }
    tag {
      key                 = "Name"
      value               = "Auto-Scaled-Web-Server"
      propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "cpu_scale_up_policy" {
    name                   = "CPU-Scale-Up-Policy"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
    policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "cpu_scale_down_policy" {
    name                   = "CPU-Scale-Down-Policy"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
    policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_scale_up_alarm" {
    alarm_name          = "CPU-Scale-Up-Alarm"
    alarm_description   = "Triggers scale out events."
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 5
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 60
    statistic           = "Average"
    threshold           = var.autoscaling_cpu_scale_up_threshold
    actions_enabled     = true
    alarm_actions       = [aws_autoscaling_policy.cpu_scale_up_policy.arn]
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.auto_scaling_group.name
    }
}

resource "aws_cloudwatch_metric_alarm" "cpu_scale_down_alarm" {
    alarm_name          = "CPU-Scale-Down-Alarm"
    alarm_description   = "Triggers scale in events."
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = 5
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 60
    statistic           = "Average"
    threshold           = var.autoscaling_cpu_scale_down_threshold
    actions_enabled     = true
    alarm_actions       = [aws_autoscaling_policy.cpu_scale_down_policy.arn]
    dimensions = {
        "AutoScalingGroupName" = aws_autoscaling_group.auto_scaling_group.name
    }
}