variable "adminregion" {}

# Instance variables

variable "base_aws_key_pair" {}

variable "base_aws_security_group" {}

variable "base_aws_subnet_public1" {}

variable "amazonlinuxami" {
  type = "map"
}

variable "amazonlinuxsize" {}

# Jenkins and artifactory IPs
variable "jenkins_ip" {}

variable "artifactory_ip" {}
