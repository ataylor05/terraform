terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_acm_certificate" "new_certificate" {
  domain_name               = var.domin_name
  subject_alternative_names = [var.alt_domin_name]
  validation_method         = "DNS"
}