resource "aws_iam_user" "iam_users" {
  for_each = toset(var.iam_users)
  name     = each.key
  path     = var.path
  tags     = var.tags
}

resource "aws_iam_group" "iam_groups" {
  for_each = toset(var.iam_groups)
  name     = each.key
  path     = var.path
}

resource "aws_iam_role" "iam_roles" {
  for_each            = var.iam_roles
  name                = each.key
  path                = each.value.path
  description         = each.value.description
  assume_role_policy  = jsonencode(each.value.assume_role_policy)
  managed_policy_arns = each.value.managed_policy_arns
}

resource "aws_iam_group_membership" "group_membership" {
  count = var.add_users_to_group ? 1 : 0
  name  = var.group_name
  users = var.iam_users
  group = var.group_name
}

resource "random_string" "suffix" {
  length  = 6
  special = false
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  count      = var.policy_attachment ? 1 : 0
  depends_on = [aws_iam_user.iam_users, aws_iam_group.iam_groups]
  name       = "attachment-${random_string.suffix.result}"
  users      = var.policy_attachment_users
  roles      = var.policy_attachment_roles
  groups     = var.policy_attachment_groups
  policy_arn = var.policy_arn
}

resource "aws_iam_policy" "policy" {
  count       = var.create_custom_policy ? 1 : 0
  name        = var.policy_name
  path        = var.path
  description = var.description
  policy      = jsonencode(var.custom_policy)
}