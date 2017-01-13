########### Kubernetes master nodes

###########Kubernetes master nodes cloud-init script to be used as ec2 userdata
data "template_file" "kubemaster" {
  template = "${file("${path.module}/Files/kubemaster.tpl")}"

  vars {
    capem          = "${var.capem}"
    cacert         = "${var.cacert}"
    kubemasterpem  = "${var.kubemasterpem}"
    kubemastercert = "${var.kubemastercert}"
    etcd0ip        = "${var.etcd_ips["0"]}"
    etcd1ip        = "${var.etcd_ips["1"]}"
    etcd2ip        = "${var.etcd_ips["2"]}"
  }
}

###### CoreOS AMI x 3
resource "aws_instance" "kubemasters" {
  count      = "${length(keys(var.kubemaster_ips))}"
  private_ip = "${lookup(var.kubemaster_ips, count.index)}"

  instance_type        = "${var.coresize}"
  ami                  = "${lookup(var.coreami, var.adminregion)}"
  user_data            = "${data.template_file.kubemaster.rendered}"
  iam_instance_profile = "${var.iam_master_profile_name}"

  key_name               = "${var.base_aws_key_pair}"
  vpc_security_group_ids = ["${var.base_aws_security_group}"]

  #Launching into private subnet
  subnet_id = "${var.base_aws_subnet_private1}"

  #Connection user settings for interacting with ami
  connection {
    user = "core"
  }

  tags {
    Name = "${format("kubemaster-%0${length(keys(var.kubemaster_ips))}d", count.index + 1)}"
  }
}
