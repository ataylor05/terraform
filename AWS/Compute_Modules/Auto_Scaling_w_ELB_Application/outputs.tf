output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_sg_arn" {
  value = aws_security_group.alb_sg.arn
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "web_sg_arn" {
  value = aws_security_group.web_sg.arn
}

output "application_load_balancer_id" {
  value = aws_lb.alb.id
}

output "application_load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "application_load_balancer_dns_name" {
  value = aws_lb.alb.dns_name
}

output "application_load_balancer_zone_id" {
  value = aws_lb.alb.zone_id
}

output "application_load_balancer_target_group_id" {
  value = aws_lb_target_group.target_group.id
}

output "application_load_balancer_target_group_name" {
  value = aws_lb_target_group.target_group.name
}

output "alb_listener_80_arn" {
  value = aws_lb_listener.alb_listener_80.arn
}

output "auto_scaling_launch_template_id" {
  value = aws_launch_template.auto_scaling_launch_template.id
}

output "auto_scaling_group_id" {
  value = aws_autoscaling_group.auto_scaling_group.id
}

output "auto_scaling_group_arn" {
  value = aws_autoscaling_group.auto_scaling_group.arn
}

output "cpu_scale_up_policy_arn" {
  value = aws_autoscaling_policy.cpu_scale_up_policy.arn
}

output "cpu_scale_down_policy_arn" {
  value = aws_autoscaling_policy.cpu_scale_down_policy.arn
}

output "cpu_scale_up_alarm_id" {
  value = aws_cloudwatch_metric_alarm.cpu_scale_up_alarm.id
}

output "cpu_scale_down_alarm_id" {
  value = aws_cloudwatch_metric_alarm.cpu_scale_down_alarm.id
}