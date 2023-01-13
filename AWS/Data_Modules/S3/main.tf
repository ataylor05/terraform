resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
  count  = var.enable_server_side_encryption ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.create_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration" {
  count  = var.create_lifecycle_policy ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status
      expiration {
              days = rule.value.expiration_days
      }
      filter {
        prefix = rule.value.filter_prefix
      }
      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }
}