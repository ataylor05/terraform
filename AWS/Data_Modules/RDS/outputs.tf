output "db_instance_id" {
  value = aws_db_instance.db_instance[*].id
}

output "db_instance_arn" {
  value = aws_db_instance.db_instance[*].arn
}

output "db_instance_address" {
  value = aws_db_instance.db_instance[*].address
}

output "db_options_group_id" {
  value = aws_db_option_group.option_group[*].id
}

output "db_options_group_arn" {
  value = aws_db_option_group.option_group[*].arn
}

output "db_parameters_group_id" {
  value = aws_db_parameter_group.parameter_group[*].id
}

output "db_parameters_group_arn" {
  value = aws_db_parameter_group.parameter_group[*].arn
}