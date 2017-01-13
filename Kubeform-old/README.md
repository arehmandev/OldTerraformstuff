<a href="http://54.163.2.164/arehmandev/Terraform-Kubernetes"><img src="http://54.163.2.164/api/badges/arehmandev/Terraform-Kubernetes/status.svg" /></a>

# Terraform script to create HA Kubernetes Cluster

## Status update: BIG CHANGES COMING! STAY TUNED!

 Under development. Cluster is currently being refined!

### Todo:
- Test and confirm each cloud-init script - currently making changes
- Currently experimenting with different TLS generation methods
- Create Launch config for EC2 instances, and autoscaling groups to auto launch into multi AZ
- Optional bonus task: Ansible scripts to perform complex setup

### Done:
- Complete ELB module - will require refining
- Complete Master and Worker IAM roles - will do Bastion later
- Added MULTIREGION SUPPORT!!  AMI lookups and AZ lookups for subnets in each region
- TLS module - needs testing with cloud-init implementation
- Complete cloud-init bootstrap scripts (From Kelsey Hightowers Kubernetes the Hard way)
- Refactored into modules
- Created HA VPC model


###2 x t1.micro Amazon Linux AMIs - public subnet
1) Jenkins installed (port 8080)
2) Artifactory installed (port 8081)

### 9 x CoreOS instances - Kubernetes HA setup - private subnet
1) 3 x Kube masters
2) 3 x Kube nodes
3) 3 x etcd nodes

###Terraform scripts contain:
- VPC
- Internet Gateway
- Public Subnets - 2x AZ public, limited to 10.0.0.0/24 and 10.0.1.0/24 CIDR
- Private Subnets - 2x AZ private, limited to 10.0.0.2.0/24 10.0.3.0/24 CIDR
- Security groups - 20, 443, 80 private, 8080 and 8081 as per variable CIDR
- AWS keypair creation from local public key
- Cloud init templates imported as ec2 userdata

For Private Subnets:
- 2 x NAT gateway (1 for each AZ)
- 2 x private route table
- 2 x private routes (to NAT gateway) and 2 x private subnet associations

For Public Subnets:
- 2 x public route tables
- 2 x public routes (to Internet gateway) and 2 x public subnet associations

###Cloud init templates:
- Setup Jenkins server
- Setup Artifactory
- Setup Kubernetes components (3x etcd, 3x kubemaster, 3x kubenodes)

## Instructions
```
1. Clone this repo, ensure you have a public key available and awscli configured

2. Modify terraform.tfvars as you wish:

If you are not using the default AWS-cli profile make sure to change
adminprofile = "default"
to
adminprofile = "yourprofilename"

3. Run 'terraform plan' to test:

4. Run 'terraform apply'
```

##Recommended extra security step:

Lock down the Jenkins and Artifactory interface to your IP:

1. Open 'terraform.tfvars' with a text editor

2. Set your ip in CIDR notation to the 'myip' variable e.g:

myip = "143.21.24.5/32"

## How this works:

```
├── main.tf
├── modules
│   ├── base
│   ├── cicd
│   ├── elb
│   ├── etcd
│   ├── iam
│   ├── kubemasters
│   ├── kubenodes
│   └── tls
├── .drone.sec
├── .drone.yml
├── secrets.yml(for droneCI)
├── terraform.tfvars
└── variables.tf
```

Order of module execution:

Base module -> ELB initial creation -> TLS submodules -> IAM module -> Etcd module -> Kubemaster module -> ELB instance attachments-> Kubenodes module
