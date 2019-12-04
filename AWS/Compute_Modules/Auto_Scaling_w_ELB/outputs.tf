output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "web_sg_arn" {
  value = aws_security_group.web_sg.arn
}

output "web_sg_name" {
  value = aws_security_group.web_sg.name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_sg_arn" {
  value = aws_security_group.alb_sg.arn
}

output "alb_sg_name" {
  value = aws_security_group.alb_sg.name
}

output "auto_scaling_launch_template_id" {
  value = aws_launch_template.auto_scaling_launch_template.id
}

output "auto_scaling_launch_template_arn" {
  value = aws_launch_template.auto_scaling_launch_template.arn
}

output "auto_scaling_group_id" {
  value = aws_autoscaling_group.auto_scaling_group.id
}

output "auto_scaling_group_arn" {
  value = aws_autoscaling_group.auto_scaling_group.arn
}

output "elastic_load_balancer_id" {
  value = aws_elb.elastic_load_balancer.id
}

output "elastic_load_balancer_arn" {
  value = aws_elb.elastic_load_balancer.arn
}

output "elastic_load_balancer_name" {
  value = aws_elb.elastic_load_balancer.name
}