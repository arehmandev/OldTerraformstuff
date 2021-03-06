### Provider
adminregion = "us-east-2"
adminprofile = "default"
key_name = "terraform"
public_key_path = "~/.ssh/id_rsa.pub"

##### Module base

#VPC Networking
myip = "0.0.0.0/0"
vpc_cidr = "10.0.0.0/16"

# 2 Private CIDRs
private1_cidr = "10.0.0.0/24"
private2_cidr = "10.0.1.0/24"

# 2 Public CIDRs
public1_cidr  = "10.0.2.0/24"
public2_cidr  = "10.0.3.0/24"

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

### module Etcd

# Launch config
lc_name = "Etcd-lc"
coresize = "t2.micro"

# Autoscaling group
asg_name = "Etcd-asg"
asg_number_of_instances = "1"
asg_minimum_number_of_instances = "1"
