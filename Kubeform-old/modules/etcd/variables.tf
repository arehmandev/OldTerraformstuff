variable "adminregion" {}

### Template variables

variable "capem" {}

variable "cacert" {}

variable "etcdpem" {}

variable "etcdcert" {}

# Instance variables

variable "base_aws_key_pair" {}

variable "base_aws_security_group" {}

variable "base_aws_subnet_private1" {}

# Kubernetes Cluster instance specification
variable "coreami" {
  type = "map"
}

variable "coresize" {}

#etcd IPs
variable "etcd_ips" {
  type = "map"
}
