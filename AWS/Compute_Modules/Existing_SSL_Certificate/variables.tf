variable "domin_name" {
  description = "Domain name for SSL certificate."
  type        = string
}

variable "alt_domin_name" {
  description = "Alt domain name for SSL certificate."
  type        = string
}

variable "ssl_certificate" {
  description = "Data for the certificate."
  type        = string
}

variable "ssl_key" {
  description = "Data for the key."
  type        = string
}

variable "ssl_chain_certificate" {
  description = "Data for the certificate."
  type        = string
}