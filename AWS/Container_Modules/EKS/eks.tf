resource "aws_security_group" "worker_pool_sg" {
  name        = "k8s-worker-pool"
  description = "Kubernetes worker pool for ${var.cluster_name}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.cluster_name}-worker-pool"
  }
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.worker_pool_sg.id]
  }

}


resource "null_resource" "remove_default_nacl_rule" {
  provisioner "local-exec" {
    command = "echo ${var.subnet_ids} && aws ec2 create-tags --resources subnet-08d693fa4fb175920 --tags Key=kubernetes.io/cluster/ataylor-test,Value=shared"
  }
}


resource "aws_eks_node_group" "eks_node_group" {
  cluster_name         = aws_eks_cluster.eks.name
  node_group_name      = "${var.cluster_name}-nodegroup"
  node_role_arn        = var.eks_node_role_arn
  subnet_ids           = var.subnet_ids
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks.name}" = "owned"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}