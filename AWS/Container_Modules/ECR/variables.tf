variable "name" {
  type        = string
  description = "Name of the repository."
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE."
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default     = false
}

variable "encryption_type" {
  type        = string
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS."
  default     = "AES256"
}

variable "kms_key" {
  type        = string
  description = "The ARN of the KMS key to use when encryption_type is KMS."
  default     = null
}

variable "force_delete" {
  type        = bool
  description = "If true, will delete the repository even if it contains images."
  default     = false
}

variable "tags" {
  type        = map
  description = "A map of tags."
  default     = null
}