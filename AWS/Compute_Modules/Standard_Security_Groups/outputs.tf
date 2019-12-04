output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "elb_sg" {
  value = aws_security_group.elb_sg.id
}

output "database_sg" {
  value = aws_security_group.database_sg.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}