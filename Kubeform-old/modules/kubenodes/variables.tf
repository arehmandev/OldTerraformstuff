variable "adminregion" {}

### Template variables

variable "capem" {}

variable "cacert" {}

variable "kubenodepem" {}

variable "kubenodecert" {}

# Instance variables

variable "iam_worker_profile_name" {}

variable "base_aws_key_pair" {}

variable "base_aws_security_group" {}

variable "base_aws_subnet_private1" {}

# Kubernetes Cluster instance specification
variable "coreami" {
  type = "map"
}

variable "coresize" {}

#kubeworker IPs
variable "kubenode_ips" {
  type = "map"
}
