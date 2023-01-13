# terraform-aws-vpc
This is a Terraform module for an AWS VPC and related networking resources.  For examples of use cases refer to the tests folder.<br>

## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "vpc" {
    source                  = "github.com/ataylor05/terraform-aws-vpc"
    ...
```
<br><br>
<b>Tagged release</b><br>
```
module "vpc" {
    source                  = "github.com/ataylor05/terraform-aws-vpc?ref=1.0.2"
    ...
```

## Example of using this module
This is an example of using this module to create a hub and spoke architecture.<br>

```
module "Hub-VPC" {
    source                  = "github.com/ataylor05/terraform-aws-vpc?ref=1.0.2"
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
    enable_nat_gateway      = false
    nat_gw_subnet           = "public-subnet-1a"

    remove_nacl_allow_all_rule = true
    nacl_rules                 = {
        ssh_inbound = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        rule_action = "allow"
        rule_number = 1000
        egress      = false
        cidr_block  = "192.168.0.0/16"
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

    enable_transit_gateway                          = true
    transit_gateway_amazon_side_asn                 = 64512
    transit_gateway_auto_accept_shared_attachments  = "enable"
    transit_gateway_default_route_table_association = "enable"
    transit_gateway_default_route_table_propagation = "enable"
    transit_gateway_dns_support                     = "enable"
    transit_gateway_cidr_blocks                     = null
    transit_gateway_vpc_subnet_tier                 = "public"

    enable_p2p_vpn_tgw           = true
    customer_vpn_device_name     = "pfsense"
    customer_vpn_gateway_ip      = "67.215.210.71"
    customer_vpn_gateway_bgp_asn = 65000
    vpn_local_network            = "192.168.0.0/16"
    ike_versions                 = ["ikev1","ikev2"]
    phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
    phase1_dh_group_numbers      = [2]
    phase1_integrity_algorithms  = ["SHA2-256", "SHA2-512"]
    phase1_lifetime_seconds      = 28800
    phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
    phase2_dh_group_numbers      = [2]
    phase2_integrity_algorithms  = ["SHA2-256", "SHA2-512"]
    phase2_lifetime_seconds      = 3600
}

module "Spoke-VPC-1" {
    source                                      = "github.com/ataylor05/terraform-aws-vpc?ref=1.0.2"
    enable_spoke_transit_gateway_vpc_attachment = true
    transit_gateway_vpc_subnet_tier             = "public"
    hub_transit_gw_id                           = module.Hub-VPC.transit_gateway_id[0]
    region                                      = "us-east-2"
    vpc_name                                    = "Example-Spoke-VPC-1"
    cidr_block                                  = "10.1.0.0/16"
    instance_tenancy                            = "default"
    enable_dns_support                          = true
    enable_dns_hostnames                        = true
    subnets                 = {
        public = {
            public-subnet-1a    = {
                availability_zone       = "us-east-2a"
                cidr_block              = "10.1.0.0/24"
                map_public_ip_on_launch = true
            }
            public-subnet-1b    = {
                availability_zone       = "us-east-2b"
                cidr_block              = "10.1.1.0/24"
                map_public_ip_on_launch = true
            }
        }
        private = {
            private-subnet-1a   = {
                availability_zone       = "us-east-2a"
                cidr_block              = "10.1.2.0/24"
                map_public_ip_on_launch = false
            }
            private-subnet-1b   = {
                availability_zone       = "us-east-2b"
                cidr_block              = "10.1.3.0/24"
                map_public_ip_on_launch = false
            }
        }
    }
    route_tables            = ["public", "private"]
    enable_internet_gateway = true
    enable_nat_gateway      = false
    nat_gw_subnet           = "public-subnet-1a"

    remove_nacl_allow_all_rule = true
    nacl_rules                 = {
        ssh_inbound = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        rule_action = "allow"
        rule_number = 1000
        egress      = false
        cidr_block  = "192.168.0.0/16"
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
    vpn_local_network = "192.168.0.0/16"
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/ataylor05/terraform-aws-vpc.git
cd terraform-aws-vpc
terraform init
terraform apply -var-file="tests/hub-tgw.tfvars"
```