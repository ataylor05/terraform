variable "ipam_cidr" {
    type        = string
    description = "The CIDR block for the VPC."
}

variable "ipam_regions" {
  type    = list(any)
}

variable "ipam_description" {
    type        = string
    description = "A description for the IPAM."
}