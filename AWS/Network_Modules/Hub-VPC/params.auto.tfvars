
region                  = "us-east-2"
vpc_name                = "Example-VPC"
cidr_block              = "10.0.0.0/16"
instance_tenancy        = "default"
enable_dns_support      = true
enable_dns_hostnames    = true
subnets                 = {
    public = {
        public-subnet-1a    = {
            availability_zone       = "us-east-2a"
            cidr_block              = "10.0.0.0/24"
            map_public_ip_on_launch = true
        }
        public-subnet-1b    = {
            availability_zone       = "us-east-2b"
            cidr_block              = "10.0.1.0/24"
            map_public_ip_on_launch = true
        }
    }
    private = {
        private-subnet-1a   = {
            availability_zone       = "us-east-2a"
            cidr_block              = "10.0.2.0/24"
            map_public_ip_on_launch = false
        }
        private-subnet-1b   = {
            availability_zone       = "us-east-2b"
            cidr_block              = "10.0.3.0/24"
            map_public_ip_on_launch = false
        }
    }
}
route_tables            = ["public", "private"]
enable_internet_gateway = true
enable_nat_gateway      = true
nat_gw_subnet           = "public-subnet-1a"

nacl_rules = {
    ssh_inbound = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      rule_action = "allow"
      rule_number = 1000
      egress      = false
      cidr_block  = "10.0.0.0/24"
    }

    http_inbound = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      rule_action = "allow"
      rule_number = 1100
      egress      = false
      cidr_block  = "0.0.0.0/0"
    }

    https_inbound = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      rule_action = "allow"
      rule_number = 1200
      egress      = false
      cidr_block  = "0.0.0.0/0"
    }
}

enable_p2p_vpn               = true
customer_vpn_device_name     = "pfsense"
customer_vpn_gateway_ip      = "67.215.210.199"
customer_vpn_gateway_bgp_asn = 65000
ike_versions                 = ["ikev1","ikev2"]
phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
phase1_dh_group_numbers      = [2]
phase1_integrity_algorithms  = ["SHA2-256", "SHA2-512"]
phase1_lifetime_seconds      = 28800
phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
phase2_dh_group_numbers      = [2]
phase2_integrity_algorithms  = ["SHA2-256", "SHA2-512"]
phase2_lifetime_seconds      = 3600