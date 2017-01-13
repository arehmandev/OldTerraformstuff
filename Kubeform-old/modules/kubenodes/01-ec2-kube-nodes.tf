########### Kubernetes worker nodes

###########Kubernetes worker nodes cloud-init script to be used as ec2 userdata
data "template_file" "kubenode" {
  template = "${file("${path.module}/Files/kubenode.tpl")}"

  vars {
    capem        = "${var.capem}"
    cacert       = "${var.cacert}"
    kubenodepem  = "${var.kubenodepem}"
    kubenodecert = "${var.kubenodecert}"
  }
}

###### CoreOS AMI x 3
resource "aws_instance" "kubeworkers" {
  count      = "${length(keys(var.kubenode_ips))}"
  private_ip = "${lookup(var.kubenode_ips, count.index)}"

  instance_type        = "${var.coresize}"
  ami                  = "${lookup(var.coreami, var.adminregion)}"
  user_data            = "${data.template_file.kubenode.rendered}"
  iam_instance_profile = "${var.iam_worker_profile_name}"

  key_name               = "${var.base_aws_key_pair}"
  vpc_security_group_ids = ["${var.base_aws_security_group}"]

  #Launching into private subnet
  subnet_id = "${var.base_aws_subnet_private1}"

  #Connection user settings for interacting with ami
  connection {
    user = "core"
  }

  tags {
    Name = "${format("kubeworker-%0${length(keys(var.kubenode_ips))}d", count.index + 1)}"
  }
}
