locals {
  userdata = <<USERDATA
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
USERDATA
}

resource "aws_security_group" "web_sg" {
    name          = "Web-Servers-SG"
    description   = "Web Servers SG"
    vpc_id        = var.vpc_id
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port   = 443
      to_port     = 443
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

resource "aws_launch_template" "auto_scaling_launch_template" {
  name           = var.launch_template_name
  block_device_mappings {
    device_name  = "/dev/sda1"
    ebs {
      volume_size = var.ebs_volume_size
      volume_type = "gp2"
    }
  }
  ebs_optimized   = var.ebs_optimized
  iam_instance_profile {
    name          = var.iam_instance_profile
  }
  image_id        = var.image_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  monitoring {
    enabled       = var.detailed_monitoring
  }
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = [aws_security_group.web_sg.id]
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
  name                 = var.auto_scaling_group_name
  vpc_zone_identifier  = [var.subnets[0], var.subnets[1]]
  max_size             = var.max_size
  min_size             = var.min_size
  launch_template {
    id      = aws_launch_template.auto_scaling_launch_template.id
    version = "$Latest"
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