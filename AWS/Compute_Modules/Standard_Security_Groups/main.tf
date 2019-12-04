terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

resource "aws_security_group" "web_sg" {
  name        = "Web-Servers"
  description = "Allow traffic from ELB to EC2 Web Servers."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "web_sg_rule_1" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb_sg.id
  security_group_id        = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_rule_2" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb_sg.id
  security_group_id        = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_rule_3" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_rule_4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group" "elb_sg" {
  name               = "Elastic-Load-Balancers"
  description        = "Allow external traffic to ELB."
  vpc_id             = var.vpc_id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "database_sg" {
  name        = "Databases"
  description = "Allow internal traffic to database servers."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "database_sg_rule_1" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "database_sg_rule_2" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.database_sg.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "Bastion-Host"
  description = "Allow traffic to and from the Bastion host."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "bastion_sg_rule_1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_sg_rule_2" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_sg_rule_3" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "bastion_sg_rule_4" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "bastion_sg_rule_5" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}