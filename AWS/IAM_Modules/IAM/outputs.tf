output "iam_users" {
  value = aws_iam_user.iam_users
}

output "iam_groups" {
  value = aws_iam_group.iam_groups
}

output "iam_roles" {
  value = aws_iam_role.iam_roles
}

output "iam_policy_id" {
  value = aws_iam_policy.policy[*].id
}