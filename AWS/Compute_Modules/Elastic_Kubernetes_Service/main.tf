locals {
  
  cluster_name = "${var.resource_prefix}-Cluster"
  worker_node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority.0.data}' '${local.cluster_name}'
USERDATA
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks_worker_role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}


resource "aws_iam_role" "eks_service_role" {
  name = "EKS-Service-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "eks_cluster_attachment" {
  name       = "eks_cluster_attachment"
  roles      = [aws_iam_role.eks_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_policy_attachment" "eks_service_attachment" {
  name       = "eks_service_attachment"
  roles      = [aws_iam_role.eks_service_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role" "eks_worker_role" {
  name = "EKS-Worker-Role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_role_container_registry_read_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_instance_profile" "eks_worker_instance_profile" {
  name = "EKS-Worker-Role"
  role = aws_iam_role.eks_worker_role.name
}

resource "aws_security_group" "eks_control_plane_security_group" {
  name        = "${var.resource_prefix} EKS Control Plane"
  description = "${var.resource_prefix} EKS Control Plane Security Group"
  vpc_id      = var.vpc
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_worker_node_security_group" {
  name        = "${var.resource_prefix} EKS Worker Node"
  description = "${var.resource_prefix} EKS Worker Node Security Group"
  vpc_id      = var.vpc
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "eks_worker_node_ingress_self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker_node_security_group.id
  source_security_group_id = aws_security_group.eks_worker_node_security_group.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_worker_node_ingress_control_plane" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_node_security_group.id
  source_security_group_id = aws_security_group.eks_control_plane_security_group.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_worker_node_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane_security_group.id
  source_security_group_id = aws_security_group.eks_worker_node_security_group.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "eks_cluster" {
  depends_on = [
    "aws_cloudwatch_log_group.eks_log_group",
    "aws_iam_policy_attachment.eks_cluster_attachment",
    "aws_iam_policy_attachment.eks_service_attachment"
    ]
  role_arn = aws_iam_role.eks_service_role.arn
  enabled_cluster_log_types = ["api", "audit"]
  name                      = local.cluster_name
  vpc_config {
    subnet_ids = [var.subnets[0], var.subnets[1]]
    security_group_ids = [aws_security_group.eks_control_plane_security_group.id]
    endpoint_public_access = var.eks_public_access
    endpoint_private_access = var.eks_private_access
  }
}

resource "aws_launch_configuration" "eks_worker_launch_config" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.eks_worker_instance_profile.name
  image_id                    = lookup(var.eks_ami,var.region,var.region)
  instance_type               = "t3.medium"
  name_prefix                 = "${var.resource_prefix}-EKS-Worker-LaunchConfig-"
  security_groups             = [aws_security_group.eks_worker_node_security_group.id]
  user_data_base64            = base64encode(local.worker_node_userdata)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks_worker_auto_scaling_group" {
  launch_configuration = aws_launch_configuration.eks_worker_launch_config.id
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1
  name                 = "${var.resource_prefix}-EKS-Worker-Auto Scaling"
  vpc_zone_identifier  = [var.subnets[0], var.subnets[1]]
  tag {
    key                 = "Name"
    value               = "${var.resource_prefix}-EKS-Worker-Node"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}