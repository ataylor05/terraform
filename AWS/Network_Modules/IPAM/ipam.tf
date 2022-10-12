resource "aws_vpc_ipam" "ipam" {
  description = var.ipam_description
  dynamic operating_regions {
    for_each = var.ipam_regions
    content {
      region_name = operating_regions.value
    }
  }
}

resource "aws_vpc_ipam_pool" "ipam_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "ipam_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.ipam_pool.id
  cidr         = var.ipam_cidr
}