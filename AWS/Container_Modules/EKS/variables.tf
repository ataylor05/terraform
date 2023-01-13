variable "vpc_id" {
    type        = string
    description = "The ID of an AWS VPC."
}

variable "control_plane_subnet_tier" {
    type        = string
    description = "Subnet tier tag, the subnets in your VPC where the control plane may place elastic network interfaces (ENIs) to facilitate communication with your cluster."
}

variable "node_group_subnet_tier" {
    type        = string
    description = "Subnet tier tag, the subnets in your VPC where the control plane may place elastic network interfaces (ENIs) to facilitate communication with your node group."
}

variable "eks_cluster_role_name" {
    type        = string
    description = "Name of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf."
}

variable "eks_worker_role_name" {
    type        = string
    description = "Name of the IAM role that provides permissions for the Kubernetes node group to make calls to AWS API operations on your behalf."
}

variable "enable_security_groups_for_pods" {
    type        = bool
    description = "Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html"
    default     = false
}

variable "cluster_name" {
    type        = string
    description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9-_]+$)."
}

variable "eks_version" {
    type        = string
    description = "Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS."
    default     = null
}

variable "enable_private_access" {
    type        = bool
    description = "Whether the Amazon EKS private API server endpoint is enabled."
    default     = true
}

variable "enable_public_access" {
    type        = bool
    description = "Whether the Amazon EKS public API server endpoint is enabled."
    default     = false
}

variable "public_access_cidrs" {
    type        = list(any)
    description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
    default     = null
}

variable "enable_eks_secrets_kms_key" {
    type        = bool
    description = "Provides envelope encryption of Kubernetes secrets stored in etcd for your cluster. This encryption is in addition to the EBS volume encryption that is enabled by default for all data (including secrets) that is stored in etcd as part of an EKS cluster."
    default     = false
}

variable "kms_key_deletion_window_in_days" {
    type        = number
    description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30."
    default     = 7
}

variable "service_ipv4_cidr" {
    type        = string
    description = "The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks."
    default     = null
}

variable "enable_eks_control_plane_logging" {
    type        = bool
    description = "Enables a Cloud Watch Log Group for EKS cluster logging."
    default     = false
}

variable "eks_control_plane_logging_retention_in_days" {
    type        = number
    description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, 3653, and 0."
    default     = null
}

variable "cluster_log_types" {
    type        = list(any)
    description = "List of the desired control plane logging to enable.  Possible values are: api, audit, authenticator, controllerManager, scheduler."
    default     = null
}

variable "admin_users" {
    type        = list(any)
    description = "A list of IAM users to be added for cluster administration."
    default     = null
}

variable "eks_nodes_disk_size" {
    type        = number
    description = "Disk size in GiB for worker nodes. Defaults to 20."
    default     = null
}

variable "eks_nodes_instance_size" {
    type        = string
    description = "Instance type associated with the EKS Node Group"
}

variable "worker_pool_desired_size" {
    type        = number
    description = "Desired number of worker nodes."
    default     = 1
}

variable "worker_pool_min_size" {
    type        = number
    description = "Minimum number of worker nodes."
    default     = 1
}

variable "worker_pool_max_size" {
    type        = number
    description = "Maximum number of worker nodes."
    default     = 1
}