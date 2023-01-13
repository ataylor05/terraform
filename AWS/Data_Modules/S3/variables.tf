variable "bucket_name" {
  type        = string
  description = "The name of the bucket."
}

variable "enable_versioning" {
  type        = bool
  description = "Provides a resource for controlling versioning on an S3 bucket."
  default     = false
}

variable "enable_server_side_encryption" {
  type        = bool
  description = "Provides a S3 bucket server-side encryption configuration resource."
  default     = false
}

variable "s3_kms_key_id" {
  type        = string
  description = "The AWS KMS master key ID used for the SSE-KMS encryption."
  default     = null
}

variable "create_bucket_policy" {
  type        = bool
  description = "If enabled, a S3 bucket policy will be created and applied to the bucket."
  default     = false
}

variable "bucket_policy" {
  type        = string
  description = "The policy to be applied to the bucket."
  default     = null
}

variable "create_lifecycle_policy" {
  type        = bool
  description = "If enabled, a S3 bucket policy will be created and applied to the bucket."
  default     = false
}

variable "lifecycle_rules" {
  description = "A list of lifecycle rules to apply to the bucket."
  type = list(object({
    id              = string
    status          = string
    expiration_days = number
    filter_prefix   = string
    transitions     = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = null
}