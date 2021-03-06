adminregion = "us-east-2"
adminprofile = "default"
key_name = "terraform"
public_key_path = "~/.ssh/id_rsa.pub"

#VPC Networking
myip = "0.0.0.0/0"

vpc_cidr = "10.0.0.0/16"

private1_az   = "us-east-1a"
public1_az    = "us-east-1a"
private2_az   = "us-east-1c"
public2_az    = "us-east-1c"

private1_cidr = "10.0.0.0/24"
public1_cidr  = "10.0.2.0/24"
private2_cidr = "10.0.1.0/24"
public2_cidr  = "10.0.3.0/24"

# Kubernetes Cluster instance specification

coresize = "t2.micro"
amazonlinuxsize = "t2.micro"

amazonlinuxami = {
  us-east-1 = "ami-9be6f38c"
  us-east-2 = "ami-38cd975d"
  us-west-1 = "ami-1e299d7e"
  us-west-2 = "ami-b73d6cd7"
  eu-west-1 = "ami-c51e3eb6"
  eu-west-2 = "ami-bfe0eadb"
  eu-central-1 = "ami-211ada4e"
}

coreami = {
  us-east-1 = "ami-7ee7e169"
  us-east-2 = "ami-f8aaf09d"
  us-west-1 = "ami-f7df8897"
  us-west-2 = "ami-d0e54eb0"
  eu-west-1 = "ami-eb3b6198"
  eu-west-2 = "ami-ebc0ca8f"
  eu-central-1 = "ami-f603c599"
}

# Subnet Availability zones

subnetaz1 = {
  us-east-1 = "us-east-1a"
  us-east-2 = "us-east-2a"
  us-west-1 = "us-west-1a"
  us-west-2 = "us-west-2a"
  eu-west-1 = "eu-west-1a"
  eu-west-2 = "eu-west-2a"
  eu-central-1 = "eu-central-1a"
}

subnetaz2 = {
  us-east-1 = "us-east-1c"
  us-east-2 = "us-east-2b"
  us-west-1 = "us-west-1b"
  us-west-2 = "us-west-2b"
  eu-west-1 = "eu-west-1b"
  eu-west-2 = "eu-west-2b"
  eu-central-1 = "eu-central-1b"
}

# Instance IPs
jenkins_ip = "10.0.2.10"
artifactory_ip = "10.0.2.20"

kubemaster_ips = {
  "0" = "10.0.0.100"
  "1" = "10.0.0.101"
  "2" = "10.0.0.102"
}

kubenode_ips = {
  "0" = "10.0.0.150"
  "1" = "10.0.0.151"
  "2" = "10.0.0.152"
}

etcd_ips = {
  "0" = "10.0.0.200"
  "1" = "10.0.0.201"
  "2" = "10.0.0.202"
}
