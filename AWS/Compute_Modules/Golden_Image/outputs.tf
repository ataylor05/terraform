output "golden_image_bucket_id" {
  value = aws_s3_bucket.golden_image_bucket.id
}

output "golden_image_bucket_arn" {
  value = aws_s3_bucket.golden_image_bucket.arn
}

output "build_spec_file_id" {
  value = aws_s3_bucket_object.build_spec_file.id
}
