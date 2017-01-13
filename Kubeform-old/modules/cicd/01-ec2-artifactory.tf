###########Artifactory cloud-init script to be used as ec2 userdata
data "template_file" "artifactory" {
  template = "${file("${path.module}/Files/artifactory.tpl")}"
}

######### Artifactory server
resource "aws_instance" "artifactory" {
  instance_type = "${var.amazonlinuxsize}"
  ami           = "${lookup(var.amazonlinuxami, var.adminregion)}"
  user_data     = "${data.template_file.artifactory.rendered}"
  private_ip    = "${var.artifactory_ip}"

  key_name               = "${var.base_aws_key_pair}"
  vpc_security_group_ids = ["${var.base_aws_security_group}"]

  #Launching into public subnet - not recommended for prod components
  subnet_id = "${var.base_aws_subnet_public1}"

  #Connection user settings for interacting with ami
  connection {
    user = "ec2-user"
  }

  tags {
    Name = "Artifactory"
  }
}
