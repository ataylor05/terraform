terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_acm_certificate" "existing_certificate" {
  domain_name               = var.domin_name
  subject_alternative_names = [var.alt_domin_name]
  private_key               = var.ssl_key
  certificate_body          = var.ssl_certificate
  certificate_chain         = var.ssl_chain_certificate
  validation_method         = "DNS"
}