variable "iam_users" {
  type        = list(any)
  description = "A list of IAM users to create"
  default     = []
}

variable "iam_groups" {
  type        = list(any)
  description = "A list of IAM users to create"
  default     = []
}

variable "iam_roles" {
  description = "A map of IAM roles to create."
  default     = {}
}

variable "tags" {
  type        = map
  description = "A map of tags."
  default     = null
}

variable "path" {
  type        = string
  description = "The path in IAM to create the object."
  default     = "/"
}

variable "create_custom_policy" {
  type        = bool
  description = "Setting to true enables the creation of an IAM policy."
  default     = false
}

variable "policy_name" {
  type        = string
  description = "The name for the IAM policy."
  default     = null
}

variable "description" {
  type        = string
  description = "A description for the object."
  default     = null
}

variable "custom_policy" {
  description = "The policy document."
  default     = null
}

variable "add_users_to_group" {
  type        = bool
  description = "Enables group membership object."
  default     = false
}

variable "group_name" {
  type        = string
  description = "A name of an IAM group."
  default     = null
}

variable "policy_attachment_users" {
  type        = list(any)
  description = "A list of users to attach a policy to."
  default     = null
}

variable "policy_attachment_roles" {
  type        = list(any)
  description = "A list of roles to attach a policy to."
  default     = null
}

variable "policy_attachment_groups" {
  type        = list(any)
  description = "A list of groups to attach a policy to."
  default     = null
}

variable "policy_arn" {
  type        = string
  description = "An IAM policy ARN."
  default     = null
}

variable "policy_attachment" {
  type        = bool
  description = "Enables a policy attachment."
  default     = false
}