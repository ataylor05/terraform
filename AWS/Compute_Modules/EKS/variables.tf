variable "eks_cluster_role_arn" {
    type        = string
    description = "ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf"
}

variable "eks_node_role_arn" {
    type        = string
    description = "Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group"
}

variable "cluster_name" {
    type        = string
    description = "Name of the cluster"
}

variable "vpc_id" {
    type        = string
    description = "The ID of a VPC"
}

variable "subnet_ids" {
    type        = list(any)
    description = "List of subnet IDs"
}

variable "disk_size" {
    type        = number
    description = "Disk size in GiB for worker nodes"
}

variable "force_update_version" {
    type        = bool
    description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
}

variable "instance_types" {
    type        = list(any)
    description = "List of instance types associated with the EKS Node Group"
}

variable "desired_size" {
    type        = number
    description = "Desired number of worker nodes"
}

variable "max_size" {
    type        = number
    description = "Maximum number of worker nodes"
}

variable "min_size" {
    type        = number
    description = "Minimum number of worker nodes"
}