variable "adminregion" {}

### Template variables

variable "capem" {}

variable "cacert" {}

variable "kubemasterpem" {}

variable "kubemastercert" {}

# Instance variables

variable "iam_master_profile_name" {}

variable "base_aws_key_pair" {}

variable "base_aws_security_group" {}

variable "base_aws_subnet_private1" {}

# Kubernetes Cluster instance specification
variable "coreami" {
  type = "map"
}

variable "coresize" {}

#kubemaster IPs
variable "kubemaster_ips" {
  type = "map"
}

#etcd IPs
variable "etcd_ips" {
  type = "map"
}
