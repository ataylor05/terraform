output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "web_sg_arn" {
  value = aws_security_group.web_sg.arn
}

output "web_sg_name" {
  value = aws_security_group.web_sg.name
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