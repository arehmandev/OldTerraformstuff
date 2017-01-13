# To set variable modify the 2 terraform.tfvars files (make sure its named "terraform.tfvars")
variable "adminregion" {}

variable "adminprofile" {}

variable "key_name" {}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"

  description = <<DESCRIPTION
Path to the SSH public key for authentication.
Example: ~/.ssh/id_rsa.pub
DESCRIPTION
}

# Kubernetes Cluster instance specification
variable "coreami" {
  type = "map"
}

variable "coresize" {}

variable "amazonlinuxami" {
  type = "map"
}

variable "amazonlinuxsize" {}

# Subnet Availability zones

variable "subnetaz1" {
  type = "map"
}

variable "subnetaz2" {
  type = "map"
}

#VPC Networking
variable "myip" {}

variable "vpc_cidr" {}

#2 Private subnets
variable "private1_cidr" {}

variable "private1_az" {}

variable "private2_cidr" {}

variable "private2_az" {}

#2 Public subnets
variable "public1_cidr" {}

variable "public1_az" {}

variable "public2_cidr" {}

variable "public2_az" {}

# Jenkins and artifactory IPs
variable "jenkins_ip" {}

variable "artifactory_ip" {}

#kubemaster IPs
variable "kubemaster_ips" {
  type = "map"
}

#kubeworker IPs
variable "kubenode_ips" {
  type = "map"
}

#etcd IPs
variable "etcd_ips" {
  type = "map"
}
