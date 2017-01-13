provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

module "base" {
  source          = "./modules/base"
  adminregion     = "${var.adminregion}"
  adminprofile    = "${var.adminprofile}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"

  #VPC Networking
  myip = "${var.myip}"

  vpc_cidr      = "${var.vpc_cidr}"
  private1_cidr = "${var.private1_cidr}"
  private1_az   = "${var.private1_az}"
  private2_cidr = "${var.private2_cidr}"
  private2_az   = "${var.private2_az}"
  public1_cidr  = "${var.public1_cidr}"
  public1_az    = "${var.public1_az}"
  public2_cidr  = "${var.public2_cidr}"
  public2_az    = "${var.public2_az}"

  subnetaz1 = "${var.subnetaz1}"
  subnetaz2 = "${var.subnetaz2}"
}

#module "elbinitial" {
#  source          = "./modules/elb/elbinitial"
#  security_groups = "${module.base.aws_security_group.default.id}"
#  subnets         = "[module.base.aws_subnet.public2.id, module.base.aws_subnet.public1.id]"
#}

module "certauth" {
  source   = "./modules/tls/ca"
  capem    = "certauth.pem"
  keypem   = "certauthkey.pem"
  iplistca = "${concat(values(var.etcd_ips), values(var.kubemaster_ips), values(var.kubenode_ips))}"
}

module "etcd-ca" {
  source             = "./modules/tls/etcd"
  capem              = "etcdcert.pem"
  keypem             = "etcdkey.pem"
  iplistca           = "${values(var.etcd_ips)}"
  ca_cert_pem        = "${module.certauth.ca_cert_pem}"
  ca_private_key_pem = "${module.certauth.ca_private_key_pem}"
}

#module "kubemaster-ca" {
#  source             = "./modules/tls/kubemaster"
#  capem              = "kubemastercert.pem"
#  keypem             = "kubemasterkey.pem"
#  iplistca           = "${values(var.kubemaster_ips)}"
#  ca_cert_pem        = "${module.certauth.ca_cert_pem}"
#  ca_private_key_pem = "${module.certauth.ca_private_key_pem}"
#  elb_dnsname        = "${module.elbinitial.elb_dns_name}"
#}

module "kubenode-ca" {
  source             = "./modules/tls/kubenode"
  capem              = "kubenodeca.pem"
  keypem             = "kubenodekey.pem"
  iplistca           = "${values(var.kubenode_ips)}"
  ca_cert_pem        = "${module.certauth.ca_cert_pem}"
  ca_private_key_pem = "${module.certauth.ca_private_key_pem}"
}

module "kube_admin_cert" {
  source             = "./modules/tls/admin"
  ca_cert_pem        = "${module.certauth.ca_cert_pem}"
  ca_private_key_pem = "${module.certauth.ca_private_key_pem}"
  kubectl_server_ip  = "${var.kubemaster_ips["0"]}"
}

module "iam" {
  source = "./modules/iam"
}

module "etcd" {
  source      = "./modules/etcd"
  adminregion = "${var.adminregion}"

  ### Template variables
  capem    = "${module.certauth.ca_private_key_pem}"
  cacert   = "${module.certauth.ca_cert_pem}"
  etcdpem  = "${module.etcd-ca.etcd_private_key}"
  etcdcert = "${module.etcd-ca.etcd_cert_pem}"

  # Instance variables
  base_aws_key_pair        = "${module.base.aws_key_pair.auth.id}"
  base_aws_security_group  = "${module.base.aws_security_group.default.id}"
  base_aws_subnet_private1 = "${module.base.aws_subnet.private1.id}"

  #Kubernetes Cluster specification
  coresize = "${var.coresize}"
  coreami  = "${var.coreami}"

  #Instance IPs
  etcd_ips = "${var.etcd_ips}"
}

#module "kubemasters" {
#  source      = "./modules/kubemasters"
#  adminregion = "${var.adminregion}"

  ### Template variables
#  capem          = "${module.certauth.ca_private_key_pem}"
#  cacert         = "${module.certauth.ca_cert_pem}"
#  kubemasterpem  = "${module.kubemaster-ca.private_key}"
#  kubemastercert = "${module.kubemaster-ca.cert_pem}"

  # Instance variables
#  iam_master_profile_name  = "${module.iam.master_profile_name}"
#  base_aws_key_pair        = "${module.base.aws_key_pair.auth.id}"
#  base_aws_security_group  = "${module.base.aws_security_group.default.id}"
#  base_aws_subnet_private1 = "${module.base.aws_subnet.private1.id}"

  #Kubernetes Cluster specification
#  coresize = "${var.coresize}"
#  coreami  = "${var.coreami}"

  #Instance IPs
#  kubemaster_ips = "${var.kubemaster_ips}"
#  etcd_ips       = "${var.etcd_ips}"
#}

#module "elbattach" {
#  source            = "./modules/elb/elbattach"
#  elb_kubemaster_id = "${module.elbinitial.elb_id}"
#  kubemaster1_ip    = "${var.kubemaster_ips["0"]}"
#  kubemaster2_ip    = "${var.kubemaster_ips["1"]}"
#  kubemaster3_ip    = "${var.kubemaster_ips["2"]}"
#}

module "kubenodes" {
  source      = "./modules/kubenodes"
  adminregion = "${var.adminregion}"

  ### Template variables
  capem        = "${module.certauth.ca_private_key_pem}"
  cacert       = "${module.certauth.ca_cert_pem}"
  kubenodepem  = "${module.kubenode-ca.kubenode_private_key}"
  kubenodecert = "${module.kubenode-ca.kubenode_cert_pem}"

  # Instance variables
  iam_worker_profile_name  = "${module.iam.worker_profile_name}"
  base_aws_key_pair        = "${module.base.aws_key_pair.auth.id}"
  base_aws_security_group  = "${module.base.aws_security_group.default.id}"
  base_aws_subnet_private1 = "${module.base.aws_subnet.private1.id}"

  #Kubernetes Cluster specification
  coresize = "${var.coresize}"
  coreami  = "${var.coreami}"

  #Instance IPs
  kubenode_ips = "${var.kubenode_ips}"
}
