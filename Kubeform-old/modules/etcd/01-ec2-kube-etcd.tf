########### Kubernetes etcd nodes

###########Kubernetes etcd cloud-init script to be used as ec2 userdata
data "template_file" "kubeetcd" {
  template = "${file("${path.module}/Files/kubeetcd.tpl")}"

  vars {
    capem    = "${var.capem}"
    cacert   = "${var.cacert}"
    etcdpem  = "${var.etcdpem}"
    etcdcert = "${var.etcdcert}"
    etcd0ip  = "${var.etcd_ips["0"]}"
    etcd1ip  = "${var.etcd_ips["1"]}"
    etcd2ip  = "${var.etcd_ips["2"]}"
  }
}

###### CoreOS AMI x 3
resource "aws_instance" "etcdcluster" {
  count      = "${length(keys(var.etcd_ips))}"
  private_ip = "${lookup(var.etcd_ips, count.index)}"

  instance_type = "${var.coresize}"
  ami           = "${lookup(var.coreami, var.adminregion)}"
  user_data     = "${data.template_file.kubeetcd.rendered}"

  key_name               = "${var.base_aws_key_pair}"
  vpc_security_group_ids = ["${var.base_aws_security_group}"]

  #Launching into private subnet
  subnet_id = "${var.base_aws_subnet_private1}"

  #Connection user settings for interacting with ami
  connection {
    user = "core"
  }

  tags {
    Name = "${format("etcd-%0${length(keys(var.etcd_ips))}d", count.index + 1)}"
  }
}
