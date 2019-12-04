terraform {
  required_version = "~> 0.12" # lock this to 0.12.x series only
}

data "aws_ami" "ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

resource "aws_network_interface" "ec2_instance_eni" {
  subnet_id   = var.subnet_id
}

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  monitoring                  = var.detailed_monitoring
  vpc_security_group_ids      = [var.vpc_security_group_ids[0]]
  associate_public_ip_address = var.associate_public_ip_address
  network_interface {
    network_interface_id      = aws_network_interface.ec2_instance_eni.id
    device_index              = 0
  }
  root_block_device {
    volume_size               = var.root_ebs_size
    volume_type               = var.root_ebs_type
    delete_on_termination     = var.root_ebs_delete_on_termination
  }
  tags = {
    Name                      = var.ec2_tag_name
    "Cost Center"             = var.ec2_tag_cost_center
    Environment               = var.ec2_tag_environment
    Backups                   = var.ec2_tag_backups
    "Patch Group"             = var.ec2_tag_patch_group
  }
  user_data                    =  var.user_data
}