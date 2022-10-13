locals {
    routes = {
        igw = {
            "0.0.0.0/0" = aws_internet_gateway.igw.*.id
        }
        nat_gw = {
            "0.0.0.0/0" = aws_nat_gateway.nat_gw.*.id
        }
    }
}